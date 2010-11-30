From: Hannes Reinecke <hare@suse.de>
Subject: Re: ioctl HDIO_GETGEO to device mapper devpath
Date: Tue, 30 Nov 2010 08:33:43 +0100
Message-ID: <4CF4A8D7.1020802@suse.de>
References: <AANLkTikBJzQM7gPPo-Wj1-2cfUqzUDa31W9gw=zZGwO4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020401050007060004010609"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTikBJzQM7gPPo-Wj1-2cfUqzUDa31W9gw=zZGwO4@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Santosh Sarangi <santosh.sarangi1@gmail.com>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------020401050007060004010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id oAU7Ulxd019418

On 10/14/2010 11:40 AM, Santosh Sarangi wrote:
> Hi,
> I have a linux  mapper device on the host, I would like to get the star=
t
> offset.
> I get this by the following ioctl . Although the call succeeds but it s=
ets
> the hd_geometry_rec to "0"
>=20
> I checked through gdb , the ioctl call suceeds ,but sets all the field =
of
> hd_geometry to "0"
>=20
Yep. Device-mapper device are able to report the geometry, but you
have to set it first :-)

The attached patch should fix this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------020401050007060004010609
Content-Type: text/x-patch;
 name="multipath-tools-set-geometry.patch"
Content-Disposition: attachment; filename="multipath-tools-set-geometry.patch"
Content-Transfer-Encoding: 7bit

From 20122c8691d8833dbef64d21957c5e1dcce12278 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Fri, 18 Jun 2010 12:32:21 +0200
Subject: [PATCH] Set geometry information for multipath maps

Some programs (most notably grub) try to get the device geometry
information via the HDIO_GETGEO ioctl. While device-mapper provides
this ioctl, it's values have to be set previously.
So we can just use the geometry information from the first path
to set this information for the multipath map.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a40bef3..9530d8e 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -421,6 +421,7 @@ domap (struct multipath * mpp)
 			if (mpp->action != ACT_CREATE)
 				mpp->action = ACT_NOTHING;
 		}
+		dm_setgeometry(mpp);
 		return DOMAP_OK;
 	}
 	return DOMAP_FAIL;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index fb69ee8..4a25563 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1133,3 +1133,51 @@ out:
 	dm_task_destroy(dmt);
 	return r;
 }
+
+int dm_setgeometry(struct multipath *mpp)
+{
+	struct dm_task *dmt;
+	struct path *pp;
+	char heads[4], sectors[4];
+	char cylinders[10], start[32];
+	int r = 0;
+
+	if (!mpp)
+		return 1;
+
+	pp = first_path(mpp);
+	if (!pp) {
+		condlog(3, "%s: no path for geometry", mpp->alias);
+		return 1;
+	}
+	if (pp->geom.cylinders == 0 ||
+	    pp->geom.heads == 0 ||
+	    pp->geom.sectors == 0) {
+		condlog(3, "%s: invalid geometry on %s", mpp->alias, pp->dev);
+		return 1;
+	}
+
+	if (!(dmt = dm_task_create(DM_DEVICE_SET_GEOMETRY)))
+		return 0;
+
+	if (!dm_task_set_name(dmt, mpp->alias))
+		goto out;
+
+	dm_task_no_open_count(dmt);
+
+	/* What a sick interface ... */
+	snprintf(heads, 4, "%u", pp->geom.heads);
+	snprintf(sectors, 4, "%u", pp->geom.sectors);
+	snprintf(cylinders, 10, "%u", pp->geom.cylinders);
+	snprintf(start, 32, "%lu", pp->geom.start);
+	if (!dm_task_set_geometry(dmt, cylinders, heads, sectors, start)) {
+		condlog(3, "%s: Failed to set geometry", mpp->alias);
+		goto out;
+	}
+
+	r = dm_task_run(dmt);
+out:
+	dm_task_destroy(dmt);
+
+	return r;
+}
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 6c22bf3..d2dd572 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -38,5 +38,6 @@ int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
 char * dm_get_name(char * uuid);
+int dm_setgeometry(struct multipath *mpp);
 
 #endif /* _DEVMAPPER_H */
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c371b47..5b04e2e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -501,6 +501,23 @@ get_inq (char * dev, char * vendor, char * product, char * rev, int fd)
 }
 
 static int
+get_geometry(struct path *pp)
+{
+	if (pp->fd < 0)
+		return 1;
+
+	if (ioctl(pp->fd, HDIO_GETGEO, &pp->geom)) {
+		condlog(2, "%s: HDIO_GETGEO failed with %d", pp->dev, errno);
+		memset(&pp->geom, 0, sizeof(pp->geom));
+		return 1;
+	}
+	condlog(3, "%s: %u cyl, %u heads, %u sectors/track, start at %lu",
+		pp->dev, pp->geom.cylinders, pp->geom.heads,
+		pp->geom.sectors, pp->geom.start);
+	return 0;
+}
+
+static int
 scsi_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 {
 	char attr_path[FILE_NAME_SIZE];
@@ -895,6 +912,9 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		goto blank;
 	}
 
+	if (mask & DI_SERIAL)
+		get_geometry(pp);
+
 	if (pp->bus == SYSFS_BUS_SCSI &&
 	    scsi_ioctl_pathinfo(pp, mask))
 		goto blank;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index fc6413b..78ba81e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -119,12 +119,23 @@ struct sysfs_device {
 	char driver[NAME_SIZE];			/* device driver name */
 };
 
+# ifndef HDIO_GETGEO
+#  define HDIO_GETGEO	0x0301	/* get device geometry */
+
+struct hd_geometry {
+      unsigned char heads;
+      unsigned char sectors;
+      unsigned short cylinders;
+      unsigned long start;
+};
+#endif
 struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
 	struct sysfs_device *sysdev;
 	struct scsi_idlun scsi_id;
 	struct sg_id sg_id;
+	struct hd_geometry geom;
 	char wwid[WWID_SIZE];
 	char vendor_id[SCSI_VENDOR_SIZE];
 	char product_id[SCSI_PRODUCT_SIZE];
@@ -146,7 +157,7 @@ struct path {
 	struct checker checker;
 	struct multipath * mpp;
 	int fd;
-	
+
 	/* configlet pointers */
 	struct hwentry * hwe;
 };

--------------020401050007060004010609
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------020401050007060004010609--
