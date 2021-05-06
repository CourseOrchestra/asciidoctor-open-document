require 'nokogiri' 
schema_path = "resources/OpenDocument-v1.2-os-schema.rng"   
doc_path = "target/stew/test.fodt" 
template_path  = "lib/a-od-producer/basic-template.fodt" 

schema = Nokogiri::XML::RelaxNG(File.open(schema_path))

instance = Nokogiri::XML(File.open(doc_path))
template_instance = Nokogiri::XML(File.open(template_path))
instance_errors = schema.validate(instance)
template_errors = schema.validate(template_instance)
instance_error_count = 0
instance_errors.each_with_index do |error, index|
  if error != template_errors[index]
    puts error 
    instance_error_count += 1
  end
end

puts "#{instance_error_count} fodt errors"
