import yaml, sys, re, itertools
from collections import OrderedDict, deque, Mapping, Iterable
from string import Template
from itertools import groupby

# @brief exceptions
class GenerateInventoryError(Exception):
  """ @brief default generate inventor exception overloader. """
  pass

class Yaml(object):
  """ @brief general purpose yamlfile loader """

  def __init__(self, filepath):
    self._yaml = filepath
    # TODO: verify the filepath is valid and of type yaml...

  def load(self):
    """ @brief load the script, script is formatted as a yaml as a ordered dictionary """

    with open(self._yaml, 'r') as fo:
      return self._load(fo)

  def _load(self, stream, Loader=yaml.Loader, object_pairs_hook=OrderedDict):
    """ @brief load yamlfile as ordered dictionary. """

    class OrderedLoader(Loader):
      pass
    def construct_mapping(loader, node):
      loader.flatten_mapping(node)
      return object_pairs_hook(loader.construct_pairs(node))
    OrderedLoader.add_constructor(
      yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, construct_mapping)
    return yaml.load(stream, OrderedLoader)

class utils(object):
  """ @brief general purpose utilities """

  class constant(object):
    """
    @brief setup constant parent class

    :raises GenerateInventoryError: attempting to set any class variable
    """

    def __setattr__(self, *_):
      raise header.GenerateInventoryError('Cannot redefine a constant variable.')
