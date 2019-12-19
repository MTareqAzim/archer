#gut.p(text, level=0, indent=0)
#print out text

func pending(text=""): pass

func assert_eq(got, expected, text=""): pass

func assert_ne(got, not_expected, text="") : pass

#greater than
func assert_gt(got, expected, text=""): pass

#less than
func assert_lt(got, expected, text=""): pass

func assert_true(got, text=""): pass

func assert_false(got, text=""): pass

func assert_null(got): pass

func assert_not_null(got): pass

func assert_between(got, expect_low, expect_high, text=""): pass

func assert_almost_eq(got, expected, error_interval, text=''): pass
# +/- error_interval
# floats, int, Vector2. SHould work for anything that can be added / subtracted

func assert_almost_ne(got, expected, error_interval, text=''): pass
#inverse of assert_almist_eq.
#pass if outside the error_interval

func assert_has(obj, element, text=''): pass

func assert_does_not_have(obj, element, text=''): pass

func assert_string_contains(text, search, match_case=true): pass

func assert_string_starts_with(text, search, match_case=true): pass

func assert_string_ends_with(text, search, match_case=true): pass

func assert_has_signal(object, signal_name): pass
#All signal asserts check if object has signal first, returns error if not
#So this assert is kinda already used

func watch_signals(object): pass
#Must be used to make assertions based on signals
#Make sure signal params 9 or below

func assert_signal_emitted(object, signal_name): pass

func assert_signal_not_emitted(object, signal_name): pass

func assert_signal_emitted_with_parameters(object, signal_name, parameters, index=-1): pass
#default to most recent signal
#index can be used to check specific signal if multiple were fired

func assert_signal_emit_count(object, signal_name, count): pass
#assert signal fired a number of times

func get_signal_emit_count(object, signal_name): pass
#return -1 if: no signal fired, object not watched, object has no signal

func get_signal_parameters(object, signal_name, index=-1): pass
#default to most recent signal
#index can be used to check specific signal if multiple were fired

func assert_file_exists(file_path): pass

func assert_file_does_not_exist(file_path): pass

func assert_file_empty(file_path): pass

func assert_file_not_empty(file_path): pass

func assert_is(object, a_class, text): pass
#a_class cannot be the built in classes: Array, float, int

func assert_exports(obj, property_name, type): pass
#Read docs to properly set type

#More in the docs, just didn't seem important for now
#doubles should be read up.