From: "goggin, edward" <egoggin@emc.com>
Subject: patch to enable creating device attributes before
	exporting hotpl ug/uevent for device kobject
Date: Thu, 10 Nov 2005 15:08:53 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADE5@srmanning.eng.emc.com>
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
Cc: Greg KH <greg@kroah.com>
List-Id: dm-devel.ids

In order to guarantee visibility through Sysfs of device attributes for
uevent/hotplug handlers, I've changed drivers/base/core.c:device_add
from calling kobject_register() before adding attributes to the device
kobject to instead

	(1) call kobject_add(),

	(2) add the device attributes to the device kobject, and

	(3) call kobject_hotplug() to export the kobject ONLY AFTER the
attributes
	are added to the device object.

Also, changed scsi_sysfs_add_sdev() to follow this new sequence for creating
scsi device objects.


--- ../base/linux-2.6.14-rc4/include/linux/device.h	2005-10-10
20:19:19.000000000 -0500
+++ include/linux/device.h	2005-10-24 05:48:11.000000000 -0500
@@ -330,6 +330,10 @@ extern void device_unregister(struct dev
 extern void device_initialize(struct device * dev);
 extern int device_add(struct device * dev);
 extern void device_del(struct device * dev);
+extern int device_add_without_export(struct device * dev);
+extern void device_del_without_unexport(struct device * dev);
+extern int device_export(struct device * dev);
+extern void device_unexport(struct device * dev);
 extern int device_for_each_child(struct device *, void *,
 		     int (*fn)(struct device *, void *));

--- ../base/linux-2.6.14-rc4/drivers/base/core.c	2005-10-10
20:19:19.000000000 -0500
+++ drivers/base/core.c	2005-10-24 06:29:04.000000000 -0500
@@ -212,7 +212,7 @@ static void klist_children_put(struct kl
  *
  *	This prepares the device for use by other layers,
  *	including adding it to the device hierarchy.
- *	It is the first half of device_register(), if called by
+ *	It is the first of 3 parts of device_register(), if called by
  *	that, though it can also be called separately, so one
  *	may use @dev's fields (e.g. the refcount).
  */
@@ -228,17 +228,20 @@ void device_initialize(struct device *de
 }
 
 /**
- *	device_add - add device to device hierarchy.
+ *	device_add_without_export - add device to device hierarchy.
  *	@dev:	device.
  *
- *	This is part 2 of device_register(), though may be called
- *	separately _iff_ device_initialize() has been called separately.
+ *	This is a sub-part of device_add() which along with device_export(),
+ *	should be called separately if one must associate device attributes
+ *	with a device between the two calls.
  *
- *	This adds it to the kobject hierarchy via kobject_add(), adds it
- *	to the global and sibling lists for the device, then
- *	adds it to the other relevant subsystems of the driver model.
+ *	This adds it to the kobject hierarchy via kobject_add() and adds it
+ *	to the global and sibling lists for the device.
+ *
+ *	device_export() will add it to the other relevant subsystems of
+ *	the driver model.
  */
-int device_add(struct device *dev)
+int device_add_without_export(struct device *dev)
 {
 	struct device *parent = NULL;
 	int error = -EINVAL;
@@ -256,33 +259,92 @@ int device_add(struct device *dev)
 	if (parent)
 		dev->kobj.parent = &parent->kobj;
 
-	if ((error = kobject_add(&dev->kobj)))
-		goto Error;
+	error = kobject_add(&dev->kobj);
+
+	if (error && parent)
+		put_device(parent);
+
+ Error:
+	put_device(dev);
+
+	return error;
+}
+
+/**
+ *	device_export - export device to device hierarchy.
+ *	@dev:	device.
+ *
+ *	This is a sub-part of device_add() which along with
+ *	device_add_without_export(), should be called separately
+ *	if one must associate device attributes with a device
+ *	between the two calls.
+ *
+ *	This adds the device to the relevant subsystems of the driver model.
+ */
+int device_export(struct device *dev)
+{
+	struct device * parent = dev->parent;
+	int error = -EINVAL;
+
+	dev = get_device(dev);
+	if (!dev || !strlen(dev->bus_id))
+		goto Done;
+
+	if (parent)
+		klist_add_tail(&dev->knode_parent, &parent->klist_children);
+
 	kobject_hotplug(&dev->kobj, KOBJ_ADD);
+
 	if ((error = device_pm_add(dev)))
 		goto PMError;
+
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (parent)
-		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	/* notify platform of device entry */
 	if (platform_notify)
 		platform_notify(dev);
+
  Done:
 	put_device(dev);
 	return error;
+
  BusError:
 	device_pm_remove(dev);
+
  PMError:
+	klist_del(&dev->knode_parent);
 	kobject_hotplug(&dev->kobj, KOBJ_REMOVE);
-	kobject_del(&dev->kobj);
- Error:
-	if (parent)
-		put_device(parent);
+
 	goto Done;
 }
 
+/**
+ *	device_add - add device to device hierarchy.
+ *	@dev:	device.
+ *
+ *	This is part 2 of device_register(), though may be called
+ *	separately _iff_ device_initialize() has been called separately.
+ *
+ *	This adds it to the kobject hierarchy via kobject_add(), adds it
+ *	to the global and sibling lists for the device, then
+ *	adds it to the other relevant subsystems of the driver model.
+ */
+int device_add(struct device *dev)
+{
+	struct device * parent = dev->parent;
+	int error;
+
+	error = device_add_without_export(dev);
+	if (error == 0)
+		error = device_export(dev);
+	else {
+		kobject_del(&dev->kobj);
+		put_device(parent);
+	}
+
+	return error;
+}
 
 /**
  *	device_register - register a device with the system.
@@ -328,22 +390,19 @@ void put_device(struct device * dev)
 		kobject_put(&dev->kobj);
 }
 
-
 /**
- *	device_del - delete device from system.
+ *	device_unexport - remove device from relevant subsystems.
  *	@dev:	device.
  *
  *	This is the first part of the device unregistration
- *	sequence. This removes the device from the lists we control
- *	from here, has it removed from the other driver model
- *	subsystems it was added to in device_add(), and removes it
- *	from the kobject hierarchy.
+ *	sequence. This removes the device from the subsystems it
+ *	was added to in device_export().
  *
- *	NOTE: this should be called manually _iff_ device_add() was
+ *	NOTE: this should be called manually _iff_ device_export() was
  *	also called manually.
  */
 
-void device_del(struct device * dev)
+void device_unexport(struct device * dev)
 {
 	struct device * parent = dev->parent;
 
@@ -358,12 +417,53 @@ void device_del(struct device * dev)
 	bus_remove_device(dev);
 	device_pm_remove(dev);
 	kobject_hotplug(&dev->kobj, KOBJ_REMOVE);
+}
+
+
+/**
+ *	device_del_without_unexport - delete device from system.
+ *	@dev:	device.
+ *
+ *	This is sub-part of the first part of the device unregistration
+ *	sequence. This removes the device from the lists we control
+ *	from here, has it removed from the other driver model
+ *	subsystems it was added to in device_add(), and removes it
+ *	from the kobject hierarchy.
+ *
+ *	NOTE: this should be called manually _iff_ device_add() was
+ *	also called manually.
+ */
+
+void device_del_without_unexport(struct device * dev)
+{
+	struct device * parent = dev->parent;
+
 	kobject_del(&dev->kobj);
 	if (parent)
 		put_device(parent);
 }
 
 /**
+ *	device_del - delete device from system.
+ *	@dev:	device.
+ *
+ *	This is the first part of the device unregistration
+ *	sequence. This removes the device from the lists we control
+ *	from here, has it removed from the other driver model
+ *	subsystems it was added to in device_add(), and removes it
+ *	from the kobject hierarchy.
+ *
+ *	NOTE: this should be called manually _iff_ device_add() was
+ *	also called manually.
+ */
+
+void device_del(struct device * dev)
+{
+	device_unexport(dev);
+	device_del_without_unexport(dev);
+}
+
+/**
  *	device_unregister - unregister device from system.
  *	@dev:	device going away.
  *
@@ -424,9 +524,13 @@ EXPORT_SYMBOL_GPL(device_for_each_child)
 EXPORT_SYMBOL_GPL(device_initialize);
 EXPORT_SYMBOL_GPL(device_add);
 EXPORT_SYMBOL_GPL(device_register);
+EXPORT_SYMBOL_GPL(device_add_without_export);
+EXPORT_SYMBOL_GPL(device_export);
 
 EXPORT_SYMBOL_GPL(device_del);
 EXPORT_SYMBOL_GPL(device_unregister);
+EXPORT_SYMBOL_GPL(device_del_without_unexport);
+EXPORT_SYMBOL_GPL(device_unexport);
 EXPORT_SYMBOL_GPL(get_device);
 EXPORT_SYMBOL_GPL(put_device);


--- ../base/linux-2.6.14-rc4/drivers/scsi/scsi_sysfs.c	2005-10-10
20:19:19.000000000 -0500
+++ drivers/scsi/scsi_sysfs.c	2005-10-24 06:31:55.000000000 -0500
@@ -621,6 +621,20 @@ static int attr_add(struct device *dev, 
 	return device_create_file(dev, attr);
 }
 
+void __scsi_remove_device_without_unexport(struct scsi_device *sdev)
+{
+	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		return;
+
+	class_device_unregister(&sdev->sdev_classdev);
+	device_del_without_unexport(&sdev->sdev_gendev);
+	scsi_device_set_state(sdev, SDEV_DEL);
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	transport_unregister_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
+}
+
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -635,9 +649,8 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
 
-	error = device_add(&sdev->sdev_gendev);
+	error = device_add_without_export(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
@@ -655,7 +668,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = attr_add(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
-				__scsi_remove_device(sdev);
+				__scsi_remove_device_without_unexport(sdev);
 				goto out;
 			}
 		}
@@ -669,20 +682,27 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
scsi_sysfs_sdev_attrs[i]);
 			error = device_create_file(&sdev->sdev_gendev,
attr);
 			if (error) {
-				__scsi_remove_device(sdev);
+				__scsi_remove_device_without_unexport(sdev);
 				goto out;
 			}
 		}
 	}
 
+	error = device_export(&sdev->sdev_gendev);
+	if (error) {
+		__scsi_remove_device_without_unexport(sdev);
+		goto out;
+	}
+
 	transport_add_device(&sdev->sdev_gendev);
+
  out:
 	return error;
 
  clean_device:
 	scsi_device_set_state(sdev, SDEV_CANCEL);
 
-	device_del(&sdev->sdev_gendev);
+	device_del_without_unexport(&sdev->sdev_gendev);
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
