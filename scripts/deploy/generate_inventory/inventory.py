import header

class Inventory:
  def __init__(self):
    self._inventory = {}  # TODO: create an iterator instead...

  def register_inventory(self, id):
    def _register_inventory(cls):
      self._inventory[id] = cls
      return cls
    return _register_inventory

  def process(self, id, parents = []):
    # find list of extension classes
    extends = [ self._inventory[parent] for parent in parents if parent in self._inventory ]

    # register the inventory type
    return self._inventory[id](id, extends)

class Group():
  def __init__(self, id, extends = []):

    self._id = id
    self._extends = extends

    print "we are in group..."

    print "we are in init, ", self._id
    print "we are in init, ", self._extends

  def __call__(self, data):
    # print "hello, data is: ", data
    print "id is:? ", self._id
    print "hello?, data is: ", data
    self.some_function()

  def some_function(self):
    print "calling me"

class System():
  def __init__(self, id, extends = []):

    self._id = id
    self._extends = extends

    print "we are in system..."

    print "we are in init, ", self._id
    print "we are in init, ", self._extends

  def __call__(self, data):
    # print "hello, data is: ", data
    print "id is:? ", self._id
    print "hello?, data is: ", data
    self.some_function()

  def some_function(self):
    print "calling me"


class const(header.utils.constant):
  """ @brief maintains phaser's contant values"""

  INVENTORY = { "group" : Group, "system" : System }
  EXTENDS = "extends"


