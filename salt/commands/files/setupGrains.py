import glob
import os.path

import sys
import yaml

class MyDumper(yaml.Dumper):
  def increase_indent(self, flow=False, indentless=False):
    return super(MyDumper, self).increase_indent(flow, False)

GRAIN_FILE="/etc/salt/grains";

if os.path.exists(GRAIN_FILE):
  grains_dict = yaml.load(open(GRAIN_FILE))
  print (grains_dict)
  print ("Grain file found, load it...")
else:
  print ("Grain file not found, init vars...")
  grains_dict={}

print ("Get installed profiles...")
grains_dict['salt-profile'] = []
for file in glob.glob("/home/ec2-user/environment/.c9/salt/*.profile"):
  profile_name=os.path.basename(file)[:-8]
  print ("Add profile '{0}'...".format(profile_name))
  grains_dict['salt-profile'].append(profile_name)
  
if not grains_dict['salt-profile']:
  grains_dict['salt-profile'].append("none")

print ("grains_dict : {0}".format(grains_dict))

print ("Write in grains file...")
with open('/etc/salt/grains', 'w') as yaml_file:
  yaml.dump(grains_dict, yaml_file,default_flow_style = False, Dumper=MyDumper)
  print ("/etc/salt/grains updated !")
            
            
