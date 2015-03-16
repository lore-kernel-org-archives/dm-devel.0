From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 63/78] Read wwid from sysfs vpg_pg83 attribute
Date: Mon, 16 Mar 2015 13:36:50 +0100
Message-ID: <1426509425-15978-64-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Using 'uid_attribute' per default has the problem that udev
might not be able to retrieve the device ID in time as the
device might be (temporarily) blocked.
It also has the problem that the 'ID_SERIAL' attribute is
not well defined and might have been overridden by other udev
rules.

As recent kernels have a 'vpd_pg83' sysfs attribute multipath
should be reading this one directly and extract the uid from there.
With that multipath does not need to do any I/O to generate the
device wwid, eliminating one common error cause during failover.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 305 ++++++++++++++++++++++++++++++++++++++++++-----
 libmultipath/sysfs.c     |  51 ++++++++
 libmultipath/sysfs.h     |   2 +
 3 files changed, 331 insertions(+), 27 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c4aee1c..681ee25 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -207,6 +207,30 @@ declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
 
+ssize_t
+sysfs_get_vpd (struct udev_device * udev, int pg,
+	       unsigned char * buff, size_t len)
+{
+	ssize_t attr_len;
+	char attrname[9];
+	const char * devname;
+
+	if (!udev) {
+		condlog(3, "No udev device given\n");
+		return -ENOSYS;
+	}
+
+	devname = udev_device_get_sysname(udev);
+	sprintf(attrname, "vpd_pg%02x", pg);
+	attr_len = sysfs_bin_attr_get_value(udev, attrname, buff, len);
+	if (attr_len < 0) {
+		condlog(3, "%s: attribute %s not found in sysfs",
+			devname, attrname);
+		return attr_len;
+	}
+	return attr_len;
+}
+
 int
 sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 {
@@ -764,6 +788,183 @@ get_geometry(struct path *pp)
 }
 
 static int
+get_vpd (struct udev_device *parent, int pg, char * str, int maxlen)
+{
+	int len = -ENODATA, buff_len;
+	unsigned char buff[4096];
+
+	memset(buff, 0x0, 4096);
+	if (sysfs_get_vpd(parent, pg, buff, 4096) <= 0) {
+		condlog(3, "failed to get vpd pg%02x", pg);
+		return -EIO;
+	}
+
+	if (buff[1] != pg) {
+		condlog(3, "vpd pg%02x error, invalid vpd page %02x",
+			pg, buff[1]);
+		return -ENODATA;
+	}
+	buff_len = (buff[2] << 8) + buff[3] + 4;
+	if (buff_len > 4096)
+		condlog(3, "vpd pg%02x page truncated", pg);
+
+	if (pg == 0x80) {
+		char *p = NULL;
+		len = buff[3] + (buff[2] << 8);
+		if (len >= maxlen) {
+			condlog(3, "vpd pg%02x overflow, %d/%d bytes required",
+				pg, len, maxlen);
+			return -EINVAL;
+		}
+		if (len > 0) {
+			memcpy(str, buff + 4, len);
+			str[len] = '\0';
+		}
+		p = str + len - 1;
+		while (p > str && *p == ' ') {
+			*p = '\0';
+			p--;
+			len --;
+		}
+	} else if (pg == 0x83) {
+		unsigned char *d;
+		unsigned char *vpd = NULL;
+		int vpd_type, vpd_len, prio = -1, i;
+
+		d = (unsigned char *)buff + 4;
+		while (d < (unsigned char *)buff + buff_len) {
+			/* Select 'association: LUN' */
+			if ((d[1] & 0x30) != 0) {
+				d += d[3] + 4;
+				continue;
+			}
+			switch (d[1] & 0xf) {
+			case 0x3:
+				/* NAA: Prio 5 */
+				if (prio < 5) {
+					prio = 5;
+					vpd = d;
+				}
+				break;
+			case 0x8:
+				/* SCSI Name: Prio 4 */
+				if (memcmp(d + 4, "eui.", 4) &&
+				    memcmp(d + 4, "naa.", 4) &&
+				    memcmp(d + 4, "iqn.", 4))
+					continue;
+				if (prio < 4) {
+					prio = 4;
+					vpd = d;
+				}
+				break;
+			case 0x2:
+				/* EUI-64: Prio 3 */
+				if (prio < 3) {
+					prio = 3;
+					vpd = d;
+				}
+				break;
+			case 0x1:
+				/* T-10 Vendor ID: Prio 2 */
+				if (prio < 2) {
+					prio = 2;
+					vpd = d;
+				}
+				break;
+			}
+			d += d[3] + 4;
+		}
+		if (prio > 0) {
+			vpd_type = vpd[1] & 0xf;
+			vpd_len = vpd[3];
+			vpd += 4;
+			if (vpd_type == 0x2 || vpd_type == 0x3) {
+				int i;
+
+				len = sprintf(str, "%d", vpd_type);
+				for (i = 0; i < vpd_len; i++) {
+					len += sprintf(str + len,
+						       "%02x", vpd[i]);
+					if (len >= maxlen)
+						break;
+				}
+			} else if (vpd_type == 0x8) {
+				if (!memcmp("eui.", vpd, 4)) {
+					str[0] =  '2';
+					len = 1;
+					vpd += 4;
+					vpd_len -= 4;
+					for (i = 0; i < vpd_len; i++) {
+						len += sprintf(str + len, "%c",
+							       tolower(vpd[i]));
+						if (len >= maxlen)
+							break;
+					}
+					len = vpd_len + 1;
+					str[len] = '\0';
+				} else if (!memcmp("naa.", vpd, 4)) {
+					str[0] = '3';
+					len = 1;
+					vpd += 4;
+					vpd_len -= 4;
+					for (i = 0; i < vpd_len; i++) {
+						len += sprintf(str + len, "%c",
+							       tolower(vpd[i]));
+						if (len >= maxlen)
+							break;
+					}
+					len = vpd_len + 1;
+					str[len] = '\0';
+				} else {
+					str[0] = '8';
+					len = 1;
+					vpd += 4;
+					vpd_len -= 4;
+					if (vpd_len > maxlen + 2)
+						vpd_len = maxlen - 2;
+					memcpy(str, vpd, vpd_len);
+					len = vpd_len + 1;
+					str[len] = '\0';
+				}
+			} else if (vpd_type == 0x1) {
+				unsigned char *p;
+				int p_len;
+
+				str[0] = '1';
+				len = 1;
+				p = vpd;
+				while ((p = memchr(vpd, ' ', vpd_len))) {
+					p_len = p - vpd;
+					if (len + p_len > maxlen - 1)
+						p_len = maxlen - len - 2;
+					memcpy(str + len, vpd, p_len);
+					len += p_len;
+					if (len >= maxlen - 1) {
+						str[len] = '\0';
+						break;
+					}
+					str[len] = '_';
+					len ++;
+					vpd = p;
+					vpd_len -= p_len;
+					while (vpd && *vpd == ' ') {
+						vpd++;
+						vpd_len --;
+					}
+				}
+				if (len > 1 && str[len - 1] == '_') {
+					str[len - 1] = '\0';
+					len--;
+				}
+			}
+		}
+	} else
+		len = -ENOSYS;
+
+	return len;
+}
+
+static int
 scsi_sysfs_pathinfo (struct path * pp)
 {
 	struct udev_device *parent;
@@ -803,6 +1004,9 @@ scsi_sysfs_pathinfo (struct path * pp)
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
+	if (get_vpd(parent, 0x80, pp->serial, SERIAL_SIZE) >= 0)
+		condlog(3, "%s: serial = %s", pp->dev, pp->serial);
+
 	/*
 	 * set the hwe configlet pointer
 	 */
@@ -1051,7 +1255,8 @@ static int
 scsi_ioctl_pathinfo (struct path * pp, int mask)
 {
 	if (mask & DI_SERIAL) {
-		get_serial(pp->serial, SERIAL_SIZE, pp->fd);
+		if (strlen(pp->serial) == 0)
+			get_serial(pp->serial, SERIAL_SIZE, pp->fd);
 		condlog(3, "%s: serial = %s", pp->dev, pp->serial);
 	}
 
@@ -1144,10 +1349,56 @@ get_prio (struct path * pp)
 }
 
 static int
+get_udev_uid(struct path * pp, char *uid_attribute)
+{
+	ssize_t len;
+	const char *value;
+
+	value = udev_device_get_property_value(pp->udev,
+					       uid_attribute);
+	if ((!value || strlen(value) == 0) && conf->cmd == CMD_VALID_PATH)
+		value = getenv(uid_attribute);
+	if (value && strlen(value)) {
+		if (strlen(value) + 1 > WWID_SIZE) {
+			condlog(0, "%s: wwid overflow", pp->dev);
+			len = WWID_SIZE;
+		} else {
+			len = strlen(value);
+		}
+		strncpy(pp->wwid, value, len);
+	} else {
+		condlog(3, "%s: no %s attribute", pp->dev,
+			uid_attribute);
+		len = -EINVAL;
+	}
+	return len;
+}
+
+static int
+get_vpd_uid(struct path * pp)
+{
+	struct udev_device *parent = pp->udev;
+
+	while (parent) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+
+	if (!parent) {
+		condlog(3, "%s: no scsi device found in sysfs", pp->dev);
+		return -ENXIO;
+	}
+	return get_vpd(parent, 0x83, pp->wwid, WWID_SIZE);
+}
+
+static int
 get_uid (struct path * pp)
 {
 	char *c;
-	const char *origin;
+	const char *origin = "none";
+	ssize_t len = 0;
 
 	if (!pp->uid_attribute && !pp->getuid)
 		select_getuid(pp);
@@ -1166,40 +1417,40 @@ get_uid (struct path * pp)
 		if (apply_format(pp->getuid, &buff[0], pp)) {
 			condlog(0, "error formatting uid callout command");
 			memset(pp->wwid, 0, WWID_SIZE);
+			len = -EINVAL;
 		} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
 			condlog(3, "error calling out %s", buff);
 			memset(pp->wwid, 0, WWID_SIZE);
-		}
+			len = -EIO;
+		} else
+			len = strlen(pp->wwid);
 		origin = "callout";
 	} else {
-		const char *value;
-
-		value = udev_device_get_property_value(pp->udev,
-						       pp->uid_attribute);
-		if ((!value || strlen(value) == 0) &&
-		    conf->cmd == CMD_VALID_PATH)
-			value = getenv(pp->uid_attribute);
-		if (value && strlen(value)) {
-			size_t len = WWID_SIZE;
-
-			if (strlen(value) + 1 > WWID_SIZE) {
-				condlog(0, "%s: wwid overflow", pp->dev);
-			} else {
-				len = strlen(value);
-			}
-			strncpy(pp->wwid, value, len);
+		if (pp->uid_attribute) {
+			len = get_udev_uid(pp, pp->uid_attribute);
+			origin = "udev";
 		} else {
-			condlog(3, "%s: no %s attribute", pp->dev,
-				pp->uid_attribute);
+			len = get_vpd_uid(pp);
+			if (len > 0)
+				origin = "sysfs";
+			else {
+				len = get_udev_uid(pp, DEFAULT_UID_ATTRIBUTE);
+				origin = "udev";
+			}
 		}
-		origin = "udev";
 	}
-	/* Strip any trailing blanks */
-	c = strchr(pp->wwid, '\0');
-	c--;
-	while (c && c >= pp->wwid && *c == ' ') {
-		*c = '\0';
+	if ( len < 0 ) {
+		condlog(1, "%s: failed to get uid: %s",
+			pp->dev, strerror(-len));
+		memset(pp->wwid, 0x0, WWID_SIZE);
+	} else {
+		/* Strip any trailing blanks */
+		c = strchr(pp->wwid, '\0');
 		c--;
+		while (c && c >= pp->wwid && *c == ' ') {
+			*c = '\0';
+			c--;
+		}
 	}
 	condlog(3, "%s: uid = %s (%s)", pp->dev,
 		*pp->wwid == '\0' ? "<empty>" : pp->wwid, origin);
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 102135a..de7df40 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -98,6 +98,57 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	return size;
 }
 
+ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
+				 unsigned char * value, size_t value_len)
+{
+	char devpath[PATH_SIZE];
+	struct stat statbuf;
+	int fd;
+	ssize_t size = -1;
+
+	if (!dev || !attr_name || !value)
+		return 0;
+
+	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
+		 attr_name);
+	condlog(4, "open '%s'", devpath);
+	if (stat(devpath, &statbuf) != 0) {
+		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
+		return -ENXIO;
+	}
+
+	/* skip directories */
+	if (S_ISDIR(statbuf.st_mode)) {
+		condlog(4, "%s is a directory", devpath);
+		return -EISDIR;
+	}
+
+	/* skip non-writeable files */
+	if ((statbuf.st_mode & S_IRUSR) == 0) {
+		condlog(4, "%s is not readable", devpath);
+		return -EPERM;
+	}
+
+	/* read attribute value */
+	fd = open(devpath, O_RDONLY);
+	if (fd < 0) {
+		condlog(4, "attribute '%s' can not be opened: %s",
+			devpath, strerror(errno));
+		return -errno;
+	}
+	size = read(fd, value, value_len);
+	if (size < 0) {
+		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
+		size = -errno;
+	} else if (size == value_len) {
+		condlog(4, "overflow while reading from %s", devpath);
+		size = 0;
+	}
+
+	close(fd);
+	return size;
+}
+
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len)
 {
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 34f3e00..2588c24 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -9,6 +9,8 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len);
 ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len);
+ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
+				 unsigned char * value, size_t value_len);
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 #endif
-- 
1.8.4.5
