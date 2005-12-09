From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Check for mapname length
Date: Fri, 09 Dec 2005 12:43:59 +0100
Message-ID: <43996DFF.6000000@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000301020102060001090202"
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
--------------000301020102060001090202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

you asked for it:
This patch checks whether the mapname returned by dm_task_get_name is
not zero-sized. So NULL is returned always for an invalid mapname.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------000301020102060001090202
Content-Type: text/x-patch;
 name="multipath-tools-mapname-length.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-mapname-length.patch"

[devmapper] Check mapname length

dm_task_get_name might return a zero-length string, which also
seem to indicate an invalid mapname. Fix dm_mapname() to always
return NULL if either no mapname or an zero-length mapname
was returned.

Signed-off-by: Hannes Reinecke <hare@suse.de>

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
@@ -135,7 +135,10 @@ dm_mapname(int major, int minor)
 	if (!dm_task_run(dmt))
 		goto out;
 
-	mapname = strdup(dm_task_get_name(dmt));
+	map = dm_task_get_name(dmt);
+	if (map && strlen(map))
+		mapname = strdup(map);
+
 out:
 	dm_task_destroy(dmt);
 	return mapname;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -675,7 +675,7 @@ out:
 char *
 dm_mapname(int major, int minor)
 {
-	char * response;
+	char * response = NULL, *map;
 	struct dm_task *dmt;
 	int r;
 	int loop = MAX_WAIT * LOOPS_PER_SEC;
@@ -709,7 +709,10 @@ dm_mapname(int major, int minor)
 		goto bad;
 	}
 
-	response = STRDUP((char *)dm_task_get_name(dmt));
+	map = dm_task_get_name(dmt);
+	if (map && strlen(map))
+		response = STRDUP((char *)dm_task_get_name(dmt));
+
 	dm_task_destroy(dmt);
 	return response;
 bad:

--------------000301020102060001090202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000301020102060001090202--
