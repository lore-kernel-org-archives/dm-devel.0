From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] Make 'multipath -t' able to run as normal
	user
Date: Tue, 17 Dec 2013 08:04:05 +0100
Message-ID: <1387263848-73945-3-git-send-email-hare@suse.de>
References: <1387263848-73945-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387263848-73945-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

'multipath -t' should be run as normal user, as we might be
needing it to update the default configuration.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c |  1 -
 multipath/main.c      | 22 +++++++++++++---------
 multipathd/main.c     |  2 ++
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 9b7adda..e13c307 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -543,7 +543,6 @@ load_config (char * file, struct udev *udev)
 		conf->verbosity = DEFAULT_VERBOSITY;
 
 	conf->udev = udev;
-	dm_drv_version(conf->version, TGT_MPATH);
 	conf->dev_type = DEV_NONE;
 	conf->minio = DEFAULT_MINIO;
 	conf->minio_rq = DEFAULT_MINIO_RQ;
diff --git a/multipath/main.c b/multipath/main.c
index 91eab88..64c8fc5 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -428,16 +428,8 @@ main (int argc, char *argv[])
 	extern int optind;
 	int r = 1;
 
-	if (getuid() != 0) {
-		fprintf(stderr, "need to be root\n");
-		exit(1);
-	}
-
 	udev = udev_new();
 
-	if (dm_prereq())
-		exit(1);
-
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
 
@@ -502,7 +494,7 @@ main (int argc, char *argv[])
 			break;
 		case 't':
 			r = dump_config();
-			goto out;
+			goto out_free_config;
 		case 'h':
 			usage(argv[0]);
 			exit(0);
@@ -525,6 +517,16 @@ main (int argc, char *argv[])
 			exit(1);
 		}
 	}
+
+	if (getuid() != 0) {
+		fprintf(stderr, "need to be root\n");
+		exit(1);
+	}
+
+	if (dm_prereq())
+		exit(1);
+	dm_drv_version(conf->version, TGT_MPATH);
+
 	if (optind < argc) {
 		conf->dev = MALLOC(FILE_NAME_SIZE);
 
@@ -609,6 +611,8 @@ out:
 
 	cleanup_prio();
 	cleanup_checkers();
+
+out_free_config:
 	/*
 	 * Freeing config must be done after dm_lib_exit(), because
 	 * the logging function (dm_write_log()), which is called there,
diff --git a/multipathd/main.c b/multipathd/main.c
index bf34a76..af93f32 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1457,6 +1457,7 @@ reconfigure (struct vectors * vecs)
 	tzset();
 
 	if (!load_config(DEFAULT_CONFIGFILE, udev)) {
+		dm_drv_version(conf->version, TGT_MPATH);
 		conf->verbosity = old->verbosity;
 		conf->daemon = 1;
 		configure(vecs, 1);
@@ -1682,6 +1683,7 @@ child (void * param)
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		goto failed;
 
+	dm_drv_version(conf->version, TGT_MPATH);
 	if (init_checkers()) {
 		condlog(0, "failed to initialize checkers");
 		goto failed;
-- 
1.7.12.4
