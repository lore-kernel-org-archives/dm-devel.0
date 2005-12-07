From: Hannes Reinecke <hare@suse.de>
Subject: [kpartx] add support for S/390 DASD
Date: Wed, 07 Dec 2005 15:08:05 +0100
Message-ID: <4396ECC5.2090202@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030506060202000508040800"
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
--------------030506060202000508040800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this patch adds kpartx support for S/390 DASD partitions.
Helpful when using multipath-tools on them.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030506060202000508040800
Content-Type: text/x-patch;
 name="kpartx-dasd-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kpartx-dasd-support.patch"

[kpartx] Add support for S/390 DASD partitions

As multipath-tools now supports S/390 DASDs there is no reason why
kpartx should not.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---
 kpartx/Makefile    |    4 ++--
 kpartx/devmapper.c |   40 ++++++++++++++++++++++++++++++++++++++--
 kpartx/devmapper.h |    1 +
 kpartx/kpartx.c    |    1 +
 kpartx/kpartx.h    |    1 +
 5 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -10,11 +10,11 @@ CFLAGS = -pipe -g -Wall -Wunused -Wstric
 
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o gpt.o crc32.o \
-	       lopart.o xstrncpy.o devmapper.o \
+	       lopart.o xstrncpy.o devmapper.o dasd.o \
 	       $(MULTIPATHLIB)-$(BUILD).a $(libdm)
 else
 	LDFLAGS = -ldevmapper
-	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o \
+	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o \
 	       gpt.o crc32.o lopart.o xstrncpy.o devmapper.o
 endif
 
diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -123,7 +123,7 @@ const char *
 dm_mapname(int major, int minor)
 {
 	struct dm_task *dmt;
-	const char *mapname;
+	const char *mapname = NULL, *map;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
 		return NULL;
@@ -135,9 +135,45 @@ dm_mapname(int major, int minor)
 	if (!dm_task_run(dmt))
 		goto out;
 
-	mapname = strdup(dm_task_get_name(dmt));
+	map = dm_task_get_name(dmt);
+	if (map && map[0] != '\0')
+		mapname = strdup(map);
+
 out:
 	dm_task_destroy(dmt);
 	return mapname;
 }
 
+/*
+ * dm_get_first_dep
+ *
+ * Return the device number of the first dependend device
+ * for a given target.
+ */
+dev_t dm_get_first_dep(char *devname)
+{
+	struct dm_task *dmt;
+	struct dm_deps *dm_deps;
+	dev_t ret = 0;
+
+	if ((dmt = dm_task_create(DM_DEVICE_DEPS)) == NULL) {
+		return ret;
+	}
+	if (!dm_task_set_name(dmt, devname)) {
+		goto out;
+	}
+	if (!dm_task_run(dmt)) {
+		goto out;
+	}
+	if ((dm_deps = dm_task_get_deps(dmt)) == NULL) {
+		goto out;
+	}
+	if (dm_deps->count > 0) {
+		ret = dm_deps->device[0];
+	}
+out:
+	dm_task_destroy(dmt);
+
+	return ret;
+}
+
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -3,3 +3,4 @@ int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, unsigned long);
 int dm_map_present (char *);
 const char * dm_mapname(int major, int minor);
+dev_t dm_get_first_dep(char *devname);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -77,6 +77,7 @@ initpts(void)
 	addpts("bsd", read_bsd_pt);
 	addpts("solaris", read_solaris_pt);
 	addpts("unixware", read_unixware_pt);
+	addpts("dasd", read_dasd_pt);
 }
 
 static char short_opts[] = "ladgvnp:t:";
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -31,6 +31,7 @@ extern ptreader read_bsd_pt;
 extern ptreader read_solaris_pt;
 extern ptreader read_unixware_pt;
 extern ptreader read_gpt_pt;
+extern ptreader read_dasd_pt;
 
 char *getblock(int fd, unsigned int secnr);
 

--------------030506060202000508040800
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030506060202000508040800--
