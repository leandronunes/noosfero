class Kalibro::MetricResult < Kalibro::Model

  attr_accessor :id, :configuration, :value, :error

  def value=(value)
    @value = value.to_f
  end

  def configuration=(value)
    @configuration = Kalibro::MetricConfigurationSnapshot.to_object value
  end

  def metric_configuration_snapshot
    configuration
  end

  def error=(value)
    @error = Kalibro::Throwable.to_object value
  end
  
  def descendant_results
    self.class.request(:descendant_results_of, {:metric_result_id => self.id})[:descendant_result].to_a
  end

  def self.metric_results_of(module_result_id)
    request(:metric_results_of, {:module_result_id => module_result_id})[:metric_result].to_a.map {|metric_result| new metric_result}
  end

  def self.history_of(metric_name, module_result_id)
    self.request(:history_of, {:metric_name => metric_name, :module_result_id => module_result_id})[:date_metric_result].to_a.map {|date_metric_result| Kalibro::DateMetricResult.new date_metric_result}
  end

end
