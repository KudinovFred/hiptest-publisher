require_relative '../spec_helper'
require_relative "../render_shared"

# ALPHA VERSON: search for "NOT SUPPORTED YET" to found what is not yet supported.

describe 'Render as Robot framework' do
  include_context "shared render"

  before(:each) do
    # In Hiptest: null
    @null_rendered = 'None'

    # In Hiptest: 'What is your quest ?'
    @what_is_your_quest_rendered = "What is your quest ?"

    # In Hiptest: 3.14
    @pi_rendered = '3.14'

    # In Hiptest: false
    @false_rendered = 'false'

    # In Hiptest: "${foo}fighters"
    @foo_template_rendered = '${foo}fighters'

    # In Hiptest: "Fighters said \"Foo !\""
    @double_quotes_template_rendered = 'Fighters said \"Foo !\"'

    # In Hiptest: foo (as in 'foo := 1')
    @foo_variable_rendered = '${foo}'

    # In Hiptest: foo.fighters
    @foo_dot_fighters_rendered = '${foo}.fighters'

    # In Hiptest: foo['fighters']
    @foo_brackets_fighters_rendered = "${foo}[fighters]"

    # In Hiptest: -foo
    @minus_foo_rendered = '-${foo}'

    # In Hiptest: foo - 'fighters'
    @foo_minus_fighters_rendered = "${foo} - fighters"

    # In Hiptest: (foo)
    @parenthesis_foo_rendered = '(${foo})'

    # In Hiptest: [foo, 'fighters']
    @foo_list_rendered = "[${foo}, fighters]"

    # In Hiptest: foo: 'fighters'
    @foo_fighters_prop_rendered = "${foo}: fighters"

    # In Hiptest: {foo: 'fighters', Alt: J}
    @foo_dict_rendered = "{${foo}: fighters, Alt: J}"

    # In Hiptest: foo := 'fighters'
    @assign_fighters_to_foo_rendered = "${foo} = fighters"

    # In Hiptest: call 'foo'
    @call_foo_rendered = "foo"
    # In Hiptest: call 'foo bar'
    @call_foo_bar_rendered = "foo_bar"

    # In Hiptest: call 'foo'('fighters')
    @call_foo_with_fighters_rendered = "foo\tfighters"
    # In Hiptest: call 'foo bar'('fighters')
    @call_foo_bar_with_fighters_rendered = "foo_bar\tfighters"

    # In Hiptest: step {action: "${foo}fighters"}
    @action_foo_fighters_rendered = '# TODO: Implement action: ${foo}fighters'

    # In Hiptest:
    # if (true)
    #   foo := 'fighters'
    #end
    @if_then_rendered = "# NOT SUPPORTED YET"

    # In Hiptest:
    # if (true)
    #   foo := 'fighters'
    # else
    #   fighters := 'foo'
    #end
    @if_then_else_rendered = "# NOT SUPPORTED YET"

    # In Hiptest:
    # while (foo)
    #   fighters := 'foo'
    #   foo('fighters')
    # end
    @while_loop_rendered = "# NOT SUPPORTED YET"

    # In Hiptest: @myTag
    @simple_tag_rendered = 'myTag'

    # In Hiptest: @myTag:somevalue
    @valued_tag_rendered = 'myTag:somevalue'

    # In Hiptest: plic (as in: definition 'foo'(plic))
    @plic_param_rendered = '${plic}'

    # In Hiptest: plic = 'ploc' (as in: definition 'foo'(plic = 'ploc'))
    @plic_param_default_ploc_rendered = '${plic}=ploc'

    # In Hiptest:
    # actionword 'my action word' do
    # end
    @empty_action_word_rendered = "my_action_word\n"

    # In Hiptest:
    # @myTag @myTag:somevalue
    # actionword 'my action word' do
    # end
    @tagged_action_word_rendered = [
      "my_action_word",
      ""
    ].join("\n")

    # In Hiptest:
    # actionword 'my action word' (plic, flip = 'flap') do
    # end
    @parameterized_action_word_rendered = [
      "my_action_word",
      "\t[Arguments]\t${plic}\t${flip}=flap",
      ""
    ].join("\n")

    # In Hiptest:
    # @myTag
    # actionword 'compare to pi' (x) do
    #   foo := 3.14
    #   if (foo > x)
    #     step {result: "x is greater than Pi"}
    #   else
    #     step {result: "x is lower than Pi
    #       on two lines"}
    #   end
    # end
    @full_actionword_rendered = [
      "compare_to_pi",
      "\t[Arguments]\t${x}",
      "\t${foo} = 3.14",
      "\t# NOT SUPPORTED YET",
      ""].join("\n")

    # In Hiptest:
    # actionword 'my action word' do
    #   step {action: "basic action"}
    # end
    @step_action_word_rendered = [
      "my_action_word",
      "\t# TODO: Implement action: basic action",
      ""].join("\n")

    # In Hiptest, correspond to two action words:
    # actionword 'first action word' do
    # end
    # actionword 'second action word' do
    #   call 'first action word'
    # end
    @actionwords_rendered = [
      "*** Keywords ***",
      "first_action_word",
      "",
      "",
      "second_action_word",
      "\tfirst_action_word",
      "",
      "",
      ""
    ].join("\n")

    # In Hiptest, correspond to these action words with parameters:
    # actionword 'aw with int param'(x) do end
    # actionword 'aw with float param'(x) do end
    # actionword 'aw with boolean param'(x) do end
    # actionword 'aw with null param'(x) do end
    # actionword 'aw with string param'(x) do end
    #
    # but called by this scenario
    # scenario 'many calls scenarios' do
    #   call 'aw with int param'(x = 3)
    #   call 'aw with float param'(x = 4.2)
    #   call 'aw with boolean param'(x = true)
    #   call 'aw with null param'(x = null)
    #   call 'aw with string param'(x = 'toto')
    #   call 'aw with template param'(x = "toto")
    @actionwords_with_params_rendered = [
      "*** Keywords ***",
      "aw_with_int_param",
      "\t[Arguments]\t${x}",
      "",
      "",
      "aw_with_float_param",
      "\t[Arguments]\t${x}",
      "",
      "",
      "aw_with_boolean_param",
      "\t[Arguments]\t${x}",
      "",
      "",
      "aw_with_null_param",
      "\t[Arguments]\t${x}",
      "",
      "",
      "aw_with_string_param",
      "\t[Arguments]\t${x}",
      "",
      "",
      "aw_with_template_param",
      "\t[Arguments]\t${x}",
      "",
      "",
      ""
    ].join("\n")


    # In Hiptest:
    # @myTag
    # scenario 'compare to pi' (x) do
    #   foo := 3.14
    #   if (foo > x)
    #     step {result: "x is greater than Pi"}
    #   else
    #     step {result: "x is lower than Pi
    #       on two lines"}
    #   end
    # end
    @full_scenario_rendered = [
      "",
      "*** Test Cases ***",
      "",
      "compare_to_pi",
      "\t[Arguments]\t${x}",
      "\t${foo} = 3.14",
      "\t\# NOT SUPPORTED YET",
      ""
    ].join("\n")

    # In hiptest
    # scenario 'reset password' do
    #   call given 'Page "url" is opened'(url='/login')
    #   call when 'I click on "link"'(link='Reset password')
    #   call then 'page "url" should be opened'(url='/reset-password')
    # end
    @bdd_scenario_rendered = [
      "",
      "*** Test Cases ***",
      "",
      "reset_password",
      "\t# Given Page \"/login\" is opened",
      "\tpage_url_is_opened\t/login",
      "\t# When I click on \"Reset password\"",
      "\ti_click_on_link\tReset password",
      "\t# Then Page \"/reset-password\" should be opened",
      "\tpage_url_should_be_opened\t/reset-password",
      ""
    ].join("\n")

    @full_scenario_with_uid_rendered = [
      "",
      "*** Test Cases ***",
      "",
      "compare_to_pi_uidabcd1234",
      "\t[Arguments]\t${x}",
      "\t${foo} = 3.14",
      "\t\# NOT SUPPORTED YET",
      ""
    ].join("\n")

    # Same than previous scenario, except that is is rendered
    # so it can be used in a single file (using the --split-scenarios option)
    @full_scenario_rendered_for_single_file = [
      "*** Settings ***",
      "Documentation",
      "...  This is a scenario which description ",
      "...  is on two lines",
      "...  Tags: myTag",
      "",
      "Resource          keywords.txt",
      "",
      "",
      "*** Test Cases ***",
      "",
      "compare_to_pi",
      "\t[Arguments]\t${x}",
      "\t${foo} = 3.14",
      "\t\# NOT SUPPORTED YET",
      ""
      ].join("\n")

    # Scenario definition is:
    # call 'fill login' (login = login)
    # call 'fill password' (password = password)
    # call 'press enter'
    # call 'assert "error" is displayed' (error = expected)

    # Scenario datatable is:
    # Dataset name             | login   | password | expected
    # -----------------------------------------------------------------------------
    # Wrong 'login'            | invalid | invalid  | 'Invalid username or password
    # Wrong "password"         | valid   | invalid  | 'Invalid username or password
    # Valid 'login'/"password" | valid   | valid    | nil

    @scenario_with_datatable_rendered = [
      "",
      "Test Template     check_login",
      "",
      "*** Test Cases ***\tlogin\tpassword\texpected",
      "Wrong 'login'\tinvalid\tinvalid\tInvalid username or password",
      "Wrong \"password\"\tvalid\tinvalid\tInvalid username or password",
      "Valid 'login'/\"password\"\tvalid\tvalid\tNone",
      "",
      "",
      "*** Keywords ***",
      "",
      "check_login",
      "\t[Arguments]\t${login}\t${password}\t${expected}",
      "\tfill_login\t${login}",
      "\tfill_password\t${password}",
      "\tpress_enter",
      "\tassert_error_is_displayed\t${expected}",
      ""
    ].join("\n")

    @scenario_with_datatable_rendered_with_uids = [
      "",
      "Test Template     check_login",
      "",
      "*** Test Cases ***\tlogin\tpassword\texpected",
      "Wrong 'login' (uid:a-123)\tinvalid\tinvalid\tInvalid username or password",
      "Wrong \"password\" (uid:b-456)\tvalid\tinvalid\tInvalid username or password",
      "Valid 'login'/\"password\" (uid:c-789)\tvalid\tvalid\tNone",
      "",
      "",
      "*** Keywords ***",
      "",
      "check_login",
      "\t[Arguments]\t${login}\t${password}\t${expected}",
      "\tfill_login\t${login}",
      "\tfill_password\t${password}",
      "\tpress_enter",
      "\tassert_error_is_displayed\t${expected}",
      ""
    ].join("\n")

    # Same than "scenario_with_datatable_rendered" but rendered with the option --split-scenarios
    @scenario_with_datatable_rendered_in_single_file = [
      "*** Settings ***",
      "Documentation",
      "...  Ensure the login process",
      "",
      "Resource          keywords.txt",
      "",
      "",
      "Test Template     check_login",
      "",
      "*** Test Cases ***\tlogin\tpassword\texpected",
      "Wrong 'login'\tinvalid\tinvalid\tInvalid username or password",
      "Wrong \"password\"\tvalid\tinvalid\tInvalid username or password",
      "Valid 'login'/\"password\"\tvalid\tvalid\tNone",
      "",
      "",
      "*** Keywords ***",
      "",
      "check_login",
      "\t[Arguments]\t${login}\t${password}\t${expected}",
      "\tfill_login\t${login}",
      "\tfill_password\t${password}",
      "\tpress_enter",
      "\tassert_error_is_displayed\t${expected}",
      ""
    ].join("\n")

    # In Hiptest, correspond to two scenarios in a project called 'My project'
    # scenario 'first scenario' do
    # end
    # scenario 'second scenario' do
    #   call 'my action word'
    # end
    @scenarios_rendered = "PLEASE USE THE --split-scenarios OPTION WHEN PUBLISHING"

    @tests_rendered = "PLEASE USE THE --split-scenarios OPTION WHEN PUBLISHING"

    @first_test_rendered = [
      "",
      "*** Test Cases ***",
      "",
      "login",
      "\tvisit\t/login",
      "\tfill\tuser@example.com",
      "\tfill\ts3cret",
      "\tclick\t.login-form input[type=submit]",
      "\tcheck_url\t/welcome",
      ""
    ].join("\n")

    @first_test_rendered_for_single_file = [
      "*** Settings ***",
      "Documentation",
      "...  The description is on ",
      "...  two lines",
      "...  Tags: myTag myTag:somevalue",
      "",
      "Resource          keywords.txt",
      "",
      "",
      "*** Test Cases ***",
      "",
      "login",
      "\tvisit\t/login",
      "\tfill\tuser@example.com",
      "\tfill\ts3cret",
      "\tclick\t.login-form input[type=submit]",
      "\tcheck_url\t/welcome",
      ""
    ].join("\n")
  end

  context 'Robot framework' do
    it_behaves_like "a renderer" do
      let(:language) {'robotframework'}
      let(:framework) {''}
    end
  end
end
