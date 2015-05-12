#!/usr/bin/python

import sys, os, libvirt
from xml.dom.minidom import parseString
os.environ['DJANGO_SETTINGS_MODULE'] = 'maas.settings'
sys.path.append("/usr/share/maas")
from maasserver.models import Node, Tag

kvm_host = 'qemu+ssh://ubuntu@10.16.0.28/system'

conn = libvirt.open(kvm_host)
dom_dict = {}
domains = conn.listDefinedDomains()

for dom_name in domains:
    node = conn.lookupByName(dom_name)
    dom_xml = parseString(node.XMLDesc(0))
    dom_mac1 = dom_xml.getElementsByTagName('interface')[0].getElementsByTagName('mac')[0].getAttribute('address')
    dom_dict[dom_mac1] = dom_name

maas_nodes = Node.objects.all()

for node in maas_nodes:
    try:
        system_id = node.system_id
        mac = node.get_primary_mac()
        if str(mac) in dom_dict:
          print node
          dom_name = dom_dict[str(mac)]
          node.hostname = dom_name
          node.power_type = 'virsh'
          node.power_parameters = { 'power_address':kvm_host, 'power_id':dom_name }
          node.save()
    except: 
        pass
