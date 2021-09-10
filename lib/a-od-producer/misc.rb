class MiscMethods
  def self.measurement_to_mm measurement, unit
    coef = {mm: 1.0,
            cm: 10.0,
            pt: 0.352778,
            pc: 4.23333,
            in: 25.4}
    raise "Unit #{unit} is unsupported" unless coef.key?(unit.to_sym)
    measurement.to_f * coef[unit.to_sym]
  end
  def self.get_optimal_dimensions img_rw, img_rh, rect_w, rect_h
    if img_rw <= 0 or img_rh <= 0 or rect_w <= 0 or rect_h <= 0
      {img_cw: 0, img_ch: 0}
    elsif img_rw.to_f <= rect_w and img_rh <= rect_h
      {img_cw: img_rw, img_ch: img_rh}
    else
      ratio = rect_w.to_f / img_rw.to_f
      ratio =  rect_h.to_f / img_rh.to_f if ratio > rect_h.to_f / img_rh.to_f
      {img_cw: img_rw.to_f * ratio, img_ch: img_rh.to_f * ratio}
    end
  end
  def self.get_normalized_fitrect_attribute fitrect_attribute
    re = /[0-9]+x[0-9]+mm/
    raise "Rectfit is accepted only in millimeters, like 20x10mm" if !!(fitrect_attribute !~ re)
    fitrect_attribute
  end
  def self.normilize_style_name style_name
    style_name.gsub(/ /,"_20_")
  end
end
