#!/usr/bin/env kotlin

@file:DependsOn("org.libreoffice:juh:7.4.7")
@file:DependsOn("org.libreoffice:unoil:7.4.7")
@file:DependsOn("org.libreoffice:ridl:7.4.7")
@file:DependsOn("org.libreoffice:libreoffice:7.4.7")
@file:DependsOn("org.libreoffice:unoloader:7.4.7")
@file:DependsOn("org.libreoffice:jurt:7.4.7")
@file:DependsOn("com.xenomachina:kotlin-argparser:2.0.7")

import com.sun.star.beans.PropertyValue
import com.sun.star.beans.XPropertySet
import com.sun.star.bridge.XBridgeFactory
import com.sun.star.comp.helper.Bootstrap
import com.sun.star.connection.XConnection
import com.sun.star.connection.XConnector
import com.sun.star.frame.XComponentLoader
import com.sun.star.frame.XDesktop
import com.sun.star.frame.XStorable
import com.sun.star.lang.XComponent
import com.sun.star.lang.XMultiComponentFactory
import com.sun.star.text.XDocumentIndex
import com.sun.star.text.XDocumentIndexesSupplier
import com.sun.star.text.XTextDocument
import com.sun.star.uno.UnoRuntime
import com.sun.star.uno.XComponentContext
import com.xenomachina.argparser.ArgParser
import com.xenomachina.argparser.default
import com.xenomachina.argparser.mainBody
import java.io.File
import java.io.IOException
import kotlin.system.exitProcess

class MyArgs(parser: ArgParser) {
    val pInputDoc by parser.storing(
            "-i", "--input-doc", help = "Input document")
    val pOutputFormats by parser.storing(
            "-f", "--output-formats", help = "Comma separated result format list like docx,pdf,odt. Default result format is PDF").default("pdf")
    val pLoCliCommand by parser.storing(
            "-c", "--lo-cli-command", help = "CLI command to run Libre Office. Default command is 'soffice'.").default("soffice")
}
lateinit var inputDoc: String
lateinit var outputFormats: String
lateinit var loCliCommand: String

mainBody {
    ArgParser(args).parseInto(::MyArgs).run {
        inputDoc = pInputDoc
        outputFormats = pOutputFormats
        loCliCommand = pLoCliCommand
    }
}

val matchedDocBasePath = """.*(?=[\.][a-zA-Z_]+$)""".toRegex().find(inputDoc)
val outputDocBasePath = matchedDocBasePath?.value ?: inputDoc
val xContext = socketContext()
val xMCF: XMultiComponentFactory? = xContext.serviceManager
//val available = if (xMCF != null) "available" else "not available"
val desktop: Any = xMCF!!.createInstanceWithContext("com.sun.star.frame.Desktop", xContext)
val xDeskop = qi(XDesktop::class.java, desktop)
val xComponentLoader = qi(XComponentLoader::class.java, desktop)
val loadProps = arrayOf<PropertyValue>()
lateinit var component : XComponent
try {
    component = xComponentLoader.loadComponentFromURL(fnmToURL(inputDoc), "_blank", 0, loadProps)
} catch (e: Exception) {
    println(e)
    println("ERROR: Unable to open $inputDoc. If file exists and not corrupted try to delete LibreOffice lock files")
    exitProcess(-1)
}
val xTextDocument = qi(XTextDocument::class.java, component)

// Update indexes
val indexes = qi(XDocumentIndexesSupplier::class.java, xTextDocument)
for (i in 0..indexes.documentIndexes.count - 1) {
    val index = qi(XDocumentIndex::class.java, indexes.documentIndexes.getByIndex(i))
    index.update()
}
println("INFO: Indexes updated")

val xStorable = qi(XStorable::class.java, component)
val saveProps = Array(2) { PropertyValue() }
saveProps[0].Name = "Overwrite"
saveProps[0].Value = true
outputFormats.split(",").forEach {
    saveProps[1].Name = "FilterName"
    saveProps[1].Value = ext2format(it)
    try {
        xStorable.storeToURL(fnmToURL("$outputDocBasePath.$it"), saveProps)
        println("INFO: $outputDocBasePath.$it stored")
    } catch (e: Exception) {
        println(e)
        println("ERROR: Unable to save $outputDocBasePath.$it. Probably file is locked")
    }
}

xDeskop.terminate()

fun socketContext(): XComponentContext // use socket connection to Office
// https://forum.openoffice.org/en/forum/viewtopic.php?f=44&t=1014
{
    val xcc: XComponentContext?  // the remote office component context
    try {
        val cmdArray = arrayOfNulls<String>(3)
        cmdArray[0] = loCliCommand
        // requires soffice to be in Windows/Linux PATH env var.
        cmdArray[1] = "--headless"
        cmdArray[2] = "--accept=socket,host=localhost,port=" +
                "8100" + ";urp;"
        val p = Runtime.getRuntime().exec(cmdArray)
        if (p != null) println("INFO: Office process created")
        val localContext = Bootstrap.createInitialComponentContext(null)
        // Get the local service manager
        val localFactory = localContext.serviceManager
        // connect to Office via its socket
        val connector: XConnector = qi(XConnector::class.java,
                localFactory.createInstanceWithContext(
                        "com.sun.star.connection.Connector", localContext))
        lateinit var connection: XConnection
        var connected = false
        var attempts = 10
        while (attempts > 0 && !connected) {
            try {
                connection = connector.connect(
                        "socket,host=localhost,port=" + "8100")
                connected = true
            } catch (_: Exception) {
            }
            delay(500)
            attempts -= 1
        }

        // create a bridge to Office via the socket
        val bridgeFactory: XBridgeFactory = qi(XBridgeFactory::class.java,
                localFactory.createInstanceWithContext(
                        "com.sun.star.bridge.BridgeFactory", localContext))

        // create a nameless bridge with no instance provider
        val bridge = bridgeFactory.createBridge("socketBridgeAD", "urp", connection, null)

        // get the remote service manager
        val serviceManager: XMultiComponentFactory = qi(XMultiComponentFactory::class.java,
                bridge.getInstance("StarOffice.ServiceManager"))

        // retrieve Office's remote component context as a property
        val props: XPropertySet = qi(XPropertySet::class.java, serviceManager)
        val defaultContext = props.getPropertyValue("DefaultContext")

        // get the remote interface XComponentContext
        xcc = qi(XComponentContext::class.java, defaultContext)
    } catch (e: Exception) {
        println("ERROR: Unable to socket connect to Office")
        exitProcess(-1)
    }
    return xcc
} // end of socketContext()

fun delay(ms: Int) {
    try {
        Thread.sleep(ms.toLong())
    } catch (_: InterruptedException) {
    }
}

// ====== interface object creation wrapper (uses generics) ===========
fun <T> qi(aType: Class<T>?, o: Any?): T // the "Loki" function -- reduces typing
{
    return UnoRuntime.queryInterface(aType, o)
}

fun fnmToURL(fnm: String): String? // convert a file path to URL format
{
    return try {
        val sb: StringBuffer?
        val path = File(fnm).canonicalPath
        sb = StringBuffer("file:///")
        sb.append(path.replace('\\', '/'))
        sb.toString()
    } catch (e: IOException) {
        println("Could not access $fnm")
        null
    }
} // end of fnmToURL()

fun ext2format(ext: String): String {
    val format = when (ext) {
        "docx" -> "Office Open XML Text"
        "pdf" -> "writer_pdf_Export"
        "odt" -> "writer8"
        "fodt" -> "OpenDocument Text Flat XML"
        else -> null
    }
    if (format == null) {
        throw Exception("Output format [$ext] not supported")
    } else {
        return format
    }
}
