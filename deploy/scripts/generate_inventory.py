#!/usr/bin/env python
import generate_inventory as gi

# create the register
inventory = gi.Inventory()

def create_inventories(filename):

  # load the given yaml
  yaml = gi.Yaml(filename).load()
  print yaml

  for name in yaml:
    print "name is: ", name
    print "generate? ", yaml[name]["generate"]

    extend = []
    if gi.const.EXTENDS in yaml[name]:
      extend = yaml[name][gi.const.EXTENDS]

    for system in yaml[name]["systems"]:
      # type of inventory (example: system, group)
      key = system.items()[0][0]
      inventory.register_inventory(name)(gi.const.INVENTORY[key])

    print
    print "process..."
    # process each inventory
    for system in inventory._inventory:
      print system
      group = inventory.process(system, ["basestation"])

    """
      for key, value in system.iteritems():
        print "key:", key
        print "value:", value
    """

  # print inventory._inventory
  """
  inventory.register_inventory("basestation")(Group)
  inventory.register_inventory("robots")(Group)

  print "done register."

  group = inventory.process("robots", ["basestation"])
  print "done process."

  group("something?")

  # group = inventory.process("group")
  # group("something?")
  """

def main():
  print "hello world"
  create_inventories("/home/katarina/deploy_ws/src/operations/deploy/inventory/etc_hosts.yaml")

# process main call
main()

