import re

import covgate


def test_version_is_a_release_form() -> None:
    assert re.fullmatch(r"\d+\.\d+\.\d+(rc\d+)?", covgate.__version__)
