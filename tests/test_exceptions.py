from covgate.exceptions import CovgateError


def test_root_error_is_an_exception() -> None:
    assert issubclass(CovgateError, Exception)
