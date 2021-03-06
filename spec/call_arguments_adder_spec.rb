require_relative 'spec_helper'
require_relative '../lib/hiptest-publisher/call_arguments_adder'

describe Hiptest::DefaultArgumentAdder do
  include HelperFactories

  let(:aw) {
    make_actionword('first actionword', parameters: [
      make_parameter('x', default: literal('Hi, I am a valued parameter')),
      make_parameter('y', default: literal('Hi, I am another valued parameter'))
    ])
  }

  let(:aw1) {
    make_actionword('second actionword', parameters: [make_parameter('x')])
  }

  let(:call_to_unknown_actionword) {
    make_call('Humm, nope')
  }

  let(:call_with_all_parameters_set) {
    make_call('first actionword', arguments: [
      make_argument('y', literal('And another value here')),
      make_argument('x', literal(3.14))
    ])
  }

  let(:call_with_no_parameter_set) {
    make_call('first actionword')
  }

  let(:call_with_no_parameters_even_if_needed) {
    # Yep, that' a long name
    make_call('second actionword')
  }

  let(:scenario) {
    make_scenario('My scenario', body: [
      call_to_unknown_actionword,
      call_with_all_parameters_set,
      call_with_no_parameter_set,
      call_with_no_parameters_even_if_needed
    ])
  }

  let(:project) {
    make_project('My project', scenarios: [scenario], actionwords: [aw, aw1])
  }

  before(:each) do
    Hiptest::DefaultArgumentAdder.add(project)
  end

  def get_all_arguments_for_call(call)
    call.children[:all_arguments].map {|arg|
      [arg.class, arg.children[:name], arg.children[:value].children[:value]]
    }
  end

  it 'adds a :all_arguments children to Call nodes where missing arguments are set with the default value' do
    expect(call_with_no_parameter_set.children.has_key?(:all_arguments)).to be true

    expect(get_all_arguments_for_call(call_with_no_parameter_set)).to eq([
      [Hiptest::Nodes::Argument, 'x', 'Hi, I am a valued parameter'],
      [Hiptest::Nodes::Argument, 'y', 'Hi, I am another valued parameter']
    ])
  end

  it 'when all value are set in a call, then :all_arguments contains the set values' do
    expect(get_all_arguments_for_call(call_with_all_parameters_set)).to eq([
      [Hiptest::Nodes::Argument, 'x', '3.14'],
      [Hiptest::Nodes::Argument, 'y', 'And another value here']
    ])
  end

  it 'the :all_arguments child are sorted in the same order than in the actionword definition' do
    expect(call_with_all_parameters_set.children[:arguments].map {|a| a.children[:name]}).to eq(
      ['y', 'x'])
    expect(call_with_all_parameters_set.children[:all_arguments].map {|a| a.children[:name]}).to eq(['x', 'y'])
  end

  it 'if the value is not set nor the default one, then we get nil as value' do
    arg = call_with_no_parameters_even_if_needed.children[:all_arguments].first
    expect(arg.children[:name]).to eq('x')
    expect(arg.children[:value]).to eq(nil)
  end

  it 'if the action word is unknown, then the :all_arguments key is set to arguments' do
    expect(call_to_unknown_actionword.children.has_key?(:all_arguments)).to be true
    expect(call_to_unknown_actionword.children[:all_arguments]).to eq(call_to_unknown_actionword.children[:arguments])
  end
end
