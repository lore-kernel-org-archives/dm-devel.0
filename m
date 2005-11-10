From: "goggin, edward" <egoggin@emc.com>
Subject: patch to bus_add_device to delay call to device_attach
	till after "bus" and bus id sym links are set up
Date: Thu, 10 Nov 2005 14:01:27 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADDA@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Patch to drivers/base/bus.c:bus_add_device to delay the driver_attach
call until after the "bus" and bus_id symbolic links for the device exist
so that a hotplug/uevent handler will not fail to find these links already
established for a newly added device.

--- ../base/linux-2.6.14-rc4/drivers/base/bus.c	2005-10-10
20:19:19.000000000 -0500
+++ drivers/base/bus.c	2005-11-03 13:32:02.000000000 -0600
@@ -359,13 +359,13 @@ int bus_add_device(struct device * dev)
 
 	if (bus) {
 		pr_debug("bus %s: add device %s\n", bus->name, dev->bus_id);
-		device_attach(dev);
 		klist_add_tail(&dev->knode_bus, &bus->klist_devices);
 		error = device_add_attrs(bus, dev);
 		if (!error) {
 			sysfs_create_link(&bus->devices.kobj, &dev->kobj,
dev->bus_id);
 			sysfs_create_link(&dev->kobj,
&dev->bus->subsys.kset.kobj, "bus");
 		}
+		device_attach(dev);
 	}
 	return error;
 }
