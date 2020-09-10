#!/usr/local/bin/perl
print "Hi there!\n";

my @_deployer_cmds = (
  "robots.ugv.ugv1.transfer.to",
  "robots.ugv.ugv1.transfer.to",
  "robots.ugv.ugv1.catkin.build",
  "robots.ugv.ugv1.catkin.clean",
  "robots.ugv.ugv1.docker.shell",
  "robots.ugv.ugv1.docker.rm",
  "robots.ugv.ugv1.docker.stop",
  "robots.ugv.ugv1.docker.registry.pull"
);


# $string = "The food is in the salad bar";
# $string =~ m/foo/;
# print "Before: $`\n";
# print "Matched: $&\n";
# print "After: $'\n";
print "------------\n";

$_target="r";
$_regex="(?<=$_target).*";
# $_match=""

foreach my $deploy (@_deployer_cmds) {
  # print "word is: $deploy\n";
  $_suffix=$deploy;
  $_suffix =~ m/$_regex/;
  $_suffix_match=$&;
  if ($_suffix eq "") {
    continue;
  }

  $_prefix=$_suffix;
  $_prefix =~ m/^([^\.]+)/;
  $_prefix_match=$&;

  # print "Suffix: $_suffix_match\n";
  # print "Prefix: $_prefix_match\n";
  $_match="$_match $_target$_suffix_match"
}

# print "--\n";
print "$_match";

# echo "target: $_target"
# 
# for deploy in "${_GL_DEPLOYER_CMDS[@]}"; do
#   echo "deploy: $deploy"
# 
#   # if [[ -z "$_target" ]]; then
#   #   _regex="(?<=$_target).*"
#   # else
#   #   _regex="(?<=$_target\.).*"
#   # fi
# 
#   # get the suffix match, i.e. find which full deployer command matches the given target token
#   # _suffix=$(echo "$deploy" | grep -oP "$_regex")
#   _suffix=$(echo "$deploy" | perl -pe "$_regex")
#   
#   # no match found, continue the iteration.
#   [[ -z "$_suffix" ]] && continue
# 
#   # found matching deployer command, get the next prefix
#   _prefix=$(echo "$_suffix" | grep -oP "^([^\.]+)")
# 
#   echo "suffix is: $_suffix"
#   echo "prefix is: $_prefix"
#   echo
# 
#   # if [[ -z "$_target" ]]; then
#   #   _prefix="$_prefix"
#   # else
#   #   _prefix="$_target.$_prefix"
#   # fi
#   _match="$_match $_target$_prefix"
# 
# 
# done
# echo "match is: $_match"