require "test_helper"

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/metric_result_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/date_metric_result_fixtures"

class MetricResultTest < ActiveSupport::TestCase

  def setup
    @native_hash = MetricResultFixtures.native_metric_result_hash
    @compound_hash = MetricResultFixtures.compound_metric_result_hash
    @result = MetricResultFixtures.native_metric_result
  end

  should 'create metric result from hash' do
    assert_equal @native_hash[:configuration][:code], Kalibro::MetricResult.new(@native_hash).configuration.code
  end

  should 'convert metric result to hash' do
    assert_equal @native_hash, @result.to_hash
  end

  should 'return descendant results of a metric result' do
    descendant = [31, 13]
    Kalibro::MetricResult.expects(:request).with(:descendant_results_of, {:metric_result_id => @result.id}).returns({:descendant_result => descendant})
    assert_equal descendant, @result.descendant_results
  end
  
  should 'return metric results of a module result' do
    id = 31
    Kalibro::MetricResult.expects(:request).with(:metric_results_of, {:module_result_id => id}).returns(:metric_result => [@native_hash, @compound_hash])
    assert_equal @native_hash[:id], Kalibro::MetricResult.metric_results_of(id).first.id
  end

  should 'return history of a metric with a module result id' do
    module_id = 31
    Kalibro::MetricResult.expects(:request).with(:history_of, {:metric_name => @result.configuration.metric.name, :module_result_id => module_id}).returns({:date_metric_result => [DateMetricResultFixtures.date_metric_result_hash]})
    assert_equal DateMetricResultFixtures.date_metric_result_hash[:metric_result][:id], Kalibro::MetricResult.history_of(@result.configuration.metric.name, module_result_id).first.metric_result.id
  end

end
