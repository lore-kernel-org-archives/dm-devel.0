From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath compilation fixes
Date: Fri, 09 Dec 2005 13:06:01 +0100
Message-ID: <43997329.7080803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090203090303030801070704"
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
--------------090203090303030801070704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

dm_mapname returns a strdup()ed string, which does not really
qualify as const. This patchs corrects it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------090203090303030801070704
Content-Type: text/x-patch;
 name="multipath-tools-compile-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-compile-fix.patch"

[devmapper] Compilation fixes

As we're returning a strdup()ed string from dm_mapname() it hardly
qualifies as 'const'.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -119,11 +119,12 @@ out:
 }
 
 
-const char *
+char *
 dm_mapname(int major, int minor)
 {
 	struct dm_task *dmt;
-	const char *mapname = NULL, *map;
+	char *mapname = NULL;
+	const char *map;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
 		return NULL;
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -2,5 +2,5 @@ int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, unsigned long);
 int dm_map_present (char *);
-const char * dm_mapname(int major, int minor);
+char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -675,7 +675,8 @@ out:
 char *
 dm_mapname(int major, int minor)
 {
-	char * response = NULL, *map;
+	char * response = NULL;
+	const char *map;
 	struct dm_task *dmt;
 	int r;
 	int loop = MAX_WAIT * LOOPS_PER_SEC;

--------------090203090303030801070704
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090203090303030801070704--
