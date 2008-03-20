From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath: update sysfs code
Date: Thu, 20 Mar 2008 09:26:30 +0100
Message-ID: <47E21FB6.8080907@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080401060301090003060403"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080401060301090003060403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch updates the sysfs code to work with the latest driver core cha=
nges.
It's basically copied from the udev sources, so it has to be correct :-)

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------080401060301090003060403
Content-Type: text/plain;
 name="multipath-tools-update-sysfs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-update-sysfs"

commit c7cf6a42715af61790470dc95c1b49e5e2e0ec4b
Author: Hannes Reinecke <hare@suse.de>
Date:   Thu Mar 20 09:17:00 2008 +0100

    update sysfs code
    
    This updates the sysfs code to work with the latest driver core
    changes. Copied from udev sources.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index b9621ac..9f11b95 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -4,12 +4,12 @@
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the
  *	Free Software Foundation version 2 of the License.
- * 
+ *
  *	This program is distributed in the hope that it will be useful, but
  *	WITHOUT ANY WARRANTY; without even the implied warranty of
  *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  *	General Public License for more details.
- * 
+ *
  *	You should have received a copy of the GNU General Public License along
  *	with this program; if not, write to the Free Software Foundation, Inc.,
  *	51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
@@ -58,7 +58,7 @@ int sysfs_init(char *path, size_t len)
 		strlcpy(sysfs_path, path, len);
 		remove_trailing_chars(sysfs_path, '/');
 	} else
-		strlcpy(sysfs_path, "/sys", len);
+		strlcpy(sysfs_path, "/sys", sizeof(sysfs_path));
 	dbg("sysfs_path='%s'", sysfs_path);
 
 	INIT_LIST_HEAD(&attr_list);
@@ -80,6 +80,7 @@ void sysfs_cleanup(void)
 	}
 
 	list_for_each_entry_safe(sysdev_loop, sysdev_temp, &sysfs_dev_list, node) {
+		list_del(&sysdev_loop->node);
 		free(sysdev_loop);
 	}
 }
@@ -162,9 +163,23 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 	int len;
 	char *pos;
 
+	/* we handle only these devpathes */
+	if (devpath != NULL &&
+	    strncmp(devpath, "/devices/", 9) != 0 &&
+	    strncmp(devpath, "/subsystem/", 11) != 0 &&
+	    strncmp(devpath, "/module/", 8) != 0 &&
+	    strncmp(devpath, "/bus/", 5) != 0 &&
+	    strncmp(devpath, "/class/", 7) != 0 &&
+	    strncmp(devpath, "/block/", 7) != 0) {
+		dbg("invalid devpath '%s'", devpath);
+		return NULL;
+	}
+
 	dbg("open '%s'", devpath);
 	strlcpy(devpath_real, devpath, sizeof(devpath_real));
 	remove_trailing_chars(devpath_real, '/');
+	if (devpath[0] == '\0' )
+		return NULL;
 
 	/* if we got a link, resolve it to the real device */
 	strlcpy(path, sysfs_path, sizeof(path));
@@ -174,24 +189,26 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 		dbg("stat '%s' failed: %s", path, strerror(errno));
 		list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
 			if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
-				dbg("found vanished dev in cache '%s'", sysdev_loop->dev.devpath);
+				dbg("found vanished dev in cache '%s'",
+				    sysdev_loop->dev.devpath);
 				return &sysdev_loop->dev;
 			}
 		}
 		return NULL;
 	}
+
 	if (S_ISLNK(statbuf.st_mode)) {
 		if (sysfs_resolve_link(devpath_real, sizeof(devpath_real)) != 0)
 			return NULL;
-
 	}
 
 	list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
 		if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
 			dbg("found dev in cache '%s'", sysdev_loop->dev.devpath);
-				dev = &sysdev_loop->dev;
+			dev = &sysdev_loop->dev;
 		}
 	}
+
 	if(!dev) {
 		/* it is a new device */
 		dbg("new device '%s'", devpath_real);
@@ -217,33 +234,25 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 		pos = strrchr(link_target, '/');
 		if (pos != NULL)
 			strlcpy(dev->subsystem, &pos[1], sizeof(dev->subsystem));
-	} else if (strncmp(dev->devpath, "/class/", 7) == 0) {
-		/* get subsystem from class dir */
-		strlcpy(dev->subsystem, &dev->devpath[7], sizeof(dev->subsystem));
-		pos = strchr(dev->subsystem, '/');
-		if (pos != NULL)
-			pos[0] = '\0';
-		else
-			dev->subsystem[0] = '\0';
-	} else if (strncmp(dev->devpath, "/block/", 7) == 0) {
-		strlcpy(dev->subsystem, "block", sizeof(dev->subsystem));
-	} else if (strncmp(dev->devpath, "/devices/", 9) == 0) {
-		/* get subsystem from "bus" link */
-		strlcpy(link_path, sysfs_path, sizeof(link_path));
-		strlcat(link_path, dev->devpath, sizeof(link_path));
-		strlcat(link_path, "/bus", sizeof(link_path));
-		len = readlink(link_path, link_target, sizeof(link_target));
-		if (len > 0) {
-			link_target[len] = '\0';
-			dbg("bus link '%s' points to '%s'", link_path, link_target);
-			pos = strrchr(link_target, '/');
-			if (pos != NULL)
-				strlcpy(dev->subsystem, &pos[1], sizeof(dev->subsystem));
-		}
 	} else if (strstr(dev->devpath, "/drivers/") != NULL) {
 		strlcpy(dev->subsystem, "drivers", sizeof(dev->subsystem));
 	} else if (strncmp(dev->devpath, "/module/", 8) == 0) {
 		strlcpy(dev->subsystem, "module", sizeof(dev->subsystem));
+	} else if (strncmp(dev->devpath, "/subsystem/", 11) == 0) {
+		pos = strrchr(dev->devpath, '/');
+		if (pos == &dev->devpath[10])
+			strlcpy(dev->subsystem, "subsystem",
+				sizeof(dev->subsystem));
+	} else if (strncmp(dev->devpath, "/class/", 7) == 0) {
+		pos = strrchr(dev->devpath, '/');
+		if (pos == &dev->devpath[6])
+			strlcpy(dev->subsystem, "subsystem",
+				sizeof(dev->subsystem));
+	} else if (strncmp(dev->devpath, "/bus/", 5) == 0) {
+		pos = strrchr(dev->devpath, '/');
+		if (pos == &dev->devpath[4])
+			strlcpy(dev->subsystem, "subsystem",
+				sizeof(dev->subsystem));
 	}
 
 	/* get driver name */
@@ -258,6 +267,7 @@ struct sysfs_device *sysfs_device_get(const char *devpath)
 		if (pos != NULL)
 			strlcpy(dev->driver, &pos[1], sizeof(dev->driver));
 	}
+
 	return dev;
 }
 
@@ -272,13 +282,6 @@ struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev)
 	if (dev->parent != NULL)
 		return dev->parent;
 
-	/* requesting a parent is only valid for devices */
-	if ((strncmp(dev->devpath, "/devices/", 9) != 0) &&
-	    (strncmp(dev->devpath, "/subsystem/", 11) != 0) &&
-	    (strncmp(dev->devpath, "/class/", 7) != 0) &&
-	    (strncmp(dev->devpath, "/block/", 7) != 0))
-		return NULL;
-
 	strlcpy(parent_devpath, dev->devpath, sizeof(parent_devpath));
 	dbg("'%s'", parent_devpath);
 
@@ -288,20 +291,6 @@ struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev)
 		return NULL;
 	pos[0] = '\0';
 
-	/* are we at the top level of /devices */
-	if (strcmp(parent_devpath, "/devices") == 0) {
-		dbg("/devices top level");
-		return NULL;
-	}
-
-	/* at the subsystems top level we want to follow the old-style "device" link */
-	if (strncmp(parent_devpath, "/subsystem", 10) == 0) {
-		pos = strrchr(parent_devpath, '/');
-		if (pos == &parent_devpath[10] || pos == parent_devpath || strcmp(pos, "/devices") == 0) {
-			dbg("/subsystem top level, look for device link");
-			goto device_link;
-		}
-	}
 	if (strncmp(parent_devpath, "/class", 6) == 0) {
 		pos = strrchr(parent_devpath, '/');
 		if (pos == &parent_devpath[6] || pos == parent_devpath) {
@@ -314,6 +303,11 @@ struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev)
 		goto device_link;
 	}
 
+	/* are we at the top level? */
+	pos = strrchr(parent_devpath, '/');
+	if (pos == NULL || pos == parent_devpath)
+		return NULL;
+
 	/* get parent and remember it */
 	dev->parent = sysfs_device_get(parent_devpath);
 	return dev->parent;
@@ -375,6 +369,8 @@ char *sysfs_attr_get_value(const char *devpath, const char *attr_name)
 
 	dbg("open '%s'/'%s'", devpath, attr_name);
 	sysfs_len = strlcpy(path_full, sysfs_path, sizeof(path_full));
+	if(sysfs_len >= sizeof(path_full))
+		sysfs_len = sizeof(path_full) - 1;
 	path = &path_full[sysfs_len];
 	strlcat(path_full, devpath, sizeof(path_full));
 	strlcat(path_full, "/", sizeof(path_full));
@@ -419,8 +415,10 @@ char *sysfs_attr_get_value(const char *devpath, const char *attr_name)
 			link_target[len] = '\0';
 			pos = strrchr(link_target, '/');
 			if (pos != NULL) {
-				dbg("cache '%s' with link value '%s'", path_full, value);
-				strlcpy(attr->value_local, &pos[1], sizeof(attr->value_local));
+				dbg("cache '%s' with link value '%s'",
+				    path_full, value);
+				strlcpy(attr->value_local, &pos[1],
+					sizeof(attr->value_local));
 				attr->value = attr->value_local;
 			}
 		}
@@ -438,7 +436,8 @@ char *sysfs_attr_get_value(const char *devpath, const char *attr_name)
 	/* read attribute value */
 	fd = open(path_full, O_RDONLY);
 	if (fd < 0) {
-		dbg("attribute '%s' does not exist", path_full);
+		dbg("attribute '%s' can not be opened: %s",
+		    path_full, strerror(errno));
 		goto out;
 	}
 	size = read(fd, value, sizeof(value));
@@ -458,3 +457,95 @@ char *sysfs_attr_get_value(const char *devpath, const char *attr_name)
 out:
 	return attr->value;
 }
+
+int sysfs_lookup_devpath_by_subsys_id(char *devpath_full, size_t len,
+				      const char *subsystem, const char *id)
+{
+	size_t sysfs_len;
+	char path_full[PATH_SIZE];
+	char *path;
+	struct stat statbuf;
+
+	sysfs_len = strlcpy(path_full, sysfs_path, sizeof(path_full));
+	path = &path_full[sysfs_len];
+
+	if (strcmp(subsystem, "subsystem") == 0) {
+		strlcpy(path, "/subsystem/", sizeof(path_full) - sysfs_len);
+		strlcat(path, id, sizeof(path_full) - sysfs_len);
+		if (stat(path_full, &statbuf) == 0)
+			goto found;
+
+		strlcpy(path, "/bus/", sizeof(path_full) - sysfs_len);
+		strlcat(path, id, sizeof(path_full) - sysfs_len);
+		if (stat(path_full, &statbuf) == 0)
+			goto found;
+		goto out;
+
+		strlcpy(path, "/class/", sizeof(path_full) - sysfs_len);
+		strlcat(path, id, sizeof(path_full) - sysfs_len);
+		if (stat(path_full, &statbuf) == 0)
+			goto found;
+	}
+
+	if (strcmp(subsystem, "module") == 0) {
+		strlcpy(path, "/module/", sizeof(path_full) - sysfs_len);
+		strlcat(path, id, sizeof(path_full) - sysfs_len);
+		if (stat(path_full, &statbuf) == 0)
+			goto found;
+		goto out;
+	}
+
+	if (strcmp(subsystem, "drivers") == 0) {
+		char subsys[NAME_SIZE];
+		char *driver;
+
+		strlcpy(subsys, id, sizeof(subsys));
+		driver = strchr(subsys, ':');
+		if (driver != NULL) {
+			driver[0] = '\0';
+			driver = &driver[1];
+			strlcpy(path, "/subsystem/", sizeof(path_full) - sysfs_len);
+			strlcat(path, subsys, sizeof(path_full) - sysfs_len);
+			strlcat(path, "/drivers/", sizeof(path_full) - sysfs_len);
+			strlcat(path, driver, sizeof(path_full) - sysfs_len);
+			if (stat(path_full, &statbuf) == 0)
+				goto found;
+
+			strlcpy(path, "/bus/", sizeof(path_full) - sysfs_len);
+			strlcat(path, subsys, sizeof(path_full) - sysfs_len);
+			strlcat(path, "/drivers/", sizeof(path_full) - sysfs_len);
+			strlcat(path, driver, sizeof(path_full) - sysfs_len);
+			if (stat(path_full, &statbuf) == 0)
+				goto found;
+		}
+		goto out;
+	}
+
+	strlcpy(path, "/subsystem/", sizeof(path_full) - sysfs_len);
+	strlcat(path, subsystem, sizeof(path_full) - sysfs_len);
+	strlcat(path, "/devices/", sizeof(path_full) - sysfs_len);
+	strlcat(path, id, sizeof(path_full) - sysfs_len);
+	if (stat(path_full, &statbuf) == 0)
+		goto found;
+
+	strlcpy(path, "/bus/", sizeof(path_full) - sysfs_len);
+	strlcat(path, subsystem, sizeof(path_full) - sysfs_len);
+	strlcat(path, "/devices/", sizeof(path_full) - sysfs_len);
+	strlcat(path, id, sizeof(path_full) - sysfs_len);
+	if (stat(path_full, &statbuf) == 0)
+		goto found;
+
+	strlcpy(path, "/class/", sizeof(path_full) - sysfs_len);
+	strlcat(path, subsystem, sizeof(path_full) - sysfs_len);
+	strlcat(path, "/", sizeof(path_full) - sysfs_len);
+	strlcat(path, id, sizeof(path_full) - sysfs_len);
+	if (stat(path_full, &statbuf) == 0)
+		goto found;
+out:
+	return 0;
+found:
+	if (S_ISLNK(statbuf.st_mode))
+		sysfs_resolve_link(path, sizeof(path_full) - sysfs_len);
+	strlcpy(devpath_full, path, len);
+	return 1;
+}

--------------080401060301090003060403
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080401060301090003060403--
