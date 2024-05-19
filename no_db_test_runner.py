from fnmatch import fnmatch
from unittest import TestLoader

from django.test.runner import DiscoverRunner


class FullPathTestLoader(TestLoader):
    def _match_path(self, path, full_path, pattern):
        return fnmatch(full_path, pattern)


class DefaultTestRunnerFullPath(DiscoverRunner):
    test_loader = FullPathTestLoader


class NoDbTestRunnerFullPath(DiscoverRunner):
    """ A test runner to test without database creation/deletion """
    test_loader = FullPathTestLoader

    def setup_databases(self, **kwargs):
        pass
        
    def teardown_databases(self, old_config, **kwargs):
        pass
