From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 24/24] multipath: use symbolic return value
	and exit code
Date: Mon,  3 Dec 2018 20:36:24 +0100
Message-ID: <20181203193624.21870-7-mwilck@suse.com>
References: <20181203193624.21870-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181203193624.21870-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use an enum to represent the return code and exit status of
multipath and its most important subroutine, configure().
This clarifies the confusing use of booleans and status
codes a bit, hopefully.

This patch doesn't introduce a change in behavior.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 120 ++++++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 54 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index eb087482..e437746d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -68,6 +68,19 @@ int logsink;
 struct udev *udev;
 struct config *multipath_conf;
 
+/*
+ * Return values of configure(), print_cmd_valid(), and main().
+ * RTVL_{YES,NO} are synonyms for RTVL_{OK,FAIL} for the CMD_VALID_PATH case.
+ */
+enum {
+	RTVL_OK = 0,
+	RTVL_YES = RTVL_OK,
+	RTVL_FAIL = 1,
+	RTVL_NO = RTVL_FAIL,
+	RTVL_MAYBE, /* only used internally, never returned */
+	RTVL_RETRY, /* returned by configure(), not by main() */
+};
+
 struct config *get_multipath_config(void)
 {
 	return multipath_conf;
@@ -475,15 +488,14 @@ retry:
 static int print_cmd_valid(int k, const vector pathvec,
 			   struct config *conf)
 {
-	static const int vals[] = { 1, 0, 2 };
 	int wait = FIND_MULTIPATHS_NEVER;
 	struct timespec until;
 	struct path *pp;
 
-	if (k < 0 || k >= (sizeof(vals) / sizeof(int)))
-		return 1;
+	if (k != RTVL_YES && k != RTVL_NO && k != RTVL_MAYBE)
+		return RTVL_NO;
 
-	if (k == 2) {
+	if (k == RTVL_MAYBE) {
 		/*
 		 * Caller ensures that pathvec[0] is the path to
 		 * examine.
@@ -493,7 +505,7 @@ static int print_cmd_valid(int k, const vector pathvec,
 		wait = find_multipaths_check_timeout(
 			pp, pp->find_multipaths_timeout, &until);
 		if (wait != FIND_MULTIPATHS_WAITING)
-			k = 1;
+			k = RTVL_NO;
 	} else if (pathvec != NULL && (pp = VECTOR_SLOT(pathvec, 0)))
 		wait = find_multipaths_check_timeout(pp, 0, &until);
 	if (wait == FIND_MULTIPATHS_WAITING)
@@ -501,8 +513,10 @@ static int print_cmd_valid(int k, const vector pathvec,
 			       until.tv_sec, until.tv_nsec/1000);
 	else if (wait == FIND_MULTIPATHS_WAIT_DONE)
 		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"0\"\n");
-	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n", vals[k]);
-	return k == 1;
+	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n",
+	       k == RTVL_MAYBE ? 2 : k == RTVL_YES ? 1 : 0);
+	/* Never return RTVL_MAYBE */
+	return k == RTVL_NO ? RTVL_NO : RTVL_YES;
 }
 
 /*
@@ -524,12 +538,6 @@ static bool released_to_systemd(void)
 	return ret;
 }
 
-/*
- * Return value:
- *  -1: Retry
- *   0: Success
- *   1: Failure
- */
 static int
 configure (struct config *conf, enum mpath_cmds cmd,
 	   enum devtypes dev_type, char *devpath)
@@ -537,7 +545,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	vector curmp = NULL;
 	vector pathvec = NULL;
 	struct vectors vecs;
-	int r = 1, rc;
+	int r = RTVL_FAIL, rc;
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
@@ -585,21 +593,23 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			goto out;
 		}
 		if (cmd == CMD_REMOVE_WWID) {
-			r = remove_wwid(refwwid);
-			if (r == 0)
+			rc = remove_wwid(refwwid);
+			if (rc == 0) {
 				printf("wwid '%s' removed\n", refwwid);
-			else if (r == 1) {
+				r = RTVL_OK;
+			} else if (rc == 1) {
 				printf("wwid '%s' not in wwids file\n",
 					refwwid);
-				r = 0;
+				r = RTVL_OK;
 			}
 			goto out;
 		}
 		if (cmd == CMD_ADD_WWID) {
-			r = remember_wwid(refwwid);
-			if (r >= 0)
+			rc = remember_wwid(refwwid);
+			if (rc >= 0) {
 				printf("wwid '%s' added\n", refwwid);
-			else
+				r = RTVL_OK;
+			} else
 				printf("failed adding '%s' to wwids file\n",
 				       refwwid);
 			goto out;
@@ -614,13 +624,13 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 */
 		if (cmd == CMD_VALID_PATH) {
 			if (is_failed_wwid(refwwid) == WWID_IS_FAILED) {
-				r = 1;
+				r = RTVL_NO;
 				goto print_valid;
 			}
 			if ((!find_multipaths_on(conf) &&
 				    ignore_wwids_on(conf)) ||
 				   check_wwids_file(refwwid, 0) == 0)
-				r = 0;
+				r = RTVL_YES;
 			if (!ignore_wwids_on(conf))
 				goto print_valid;
 			/* At this point, either r==0 or find_multipaths_on. */
@@ -630,7 +640,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			 * Quick check if path is already multipathed.
 			 */
 			if (sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0))) {
-				r = 0;
+				r = RTVL_YES;
 				goto print_valid;
 			}
 
@@ -644,10 +654,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			 * Leave DM_MULTIPATH_DEVICE_PATH="0".
 			 */
 			if (released) {
-				r = 1;
+				r = RTVL_NO;
 				goto print_valid;
 			}
-			if (r == 0)
+			if (r == RTVL_YES)
 				goto print_valid;
 			/* find_multipaths_on: Fall through to path detection */
 		}
@@ -703,13 +713,12 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * the refwwid, or there is more than one path matching
 		 * the refwwid, then the path is valid */
 		if (VECTOR_SIZE(curmp) != 0) {
-			r = 0;
+			r = RTVL_YES;
 			goto print_valid;
 		} else if (VECTOR_SIZE(pathvec) > 1)
-			r = 0;
+			r = RTVL_YES;
 		else
-			/* Use r=2 as an indication for "maybe" */
-			r = 2;
+			r = RTVL_MAYBE;
 
 		/*
 		 * If opening the path with O_EXCL fails, the path
@@ -739,13 +748,14 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			/*
 			 * Check if we raced with multipathd
 			 */
-			r = !sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0));
+			r = sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0)) ?
+				RTVL_YES : RTVL_NO;
 		}
 		goto print_valid;
 	}
 
 	if (cmd != CMD_CREATE && cmd != CMD_DRY_RUN) {
-		r = 0;
+		r = RTVL_OK;
 		goto out;
 	}
 
@@ -754,7 +764,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	 */
 	rc = coalesce_paths(&vecs, NULL, refwwid,
 			   conf->force_reload, cmd);
-	r = rc == CP_RETRY ? -1 : rc == CP_OK ? 0 : 1;
+	r = rc == CP_RETRY ? RTVL_RETRY : rc == CP_OK ? RTVL_OK : RTVL_FAIL;
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
@@ -855,7 +865,7 @@ main (int argc, char *argv[])
 	int arg;
 	extern char *optarg;
 	extern int optind;
-	int r = 1;
+	int r = RTVL_FAIL;
 	enum mpath_cmds cmd = CMD_CREATE;
 	enum devtypes dev_type = DEV_NONE;
 	char *dev = NULL;
@@ -866,7 +876,7 @@ main (int argc, char *argv[])
 	logsink = 0;
 	conf = load_config(DEFAULT_CONFIGFILE);
 	if (!conf)
-		exit(1);
+		exit(RTVL_FAIL);
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
 	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
@@ -877,7 +887,7 @@ main (int argc, char *argv[])
 			if (sizeof(optarg) > sizeof(char *) ||
 			    !isdigit(optarg[0])) {
 				usage (argv[0]);
-				exit(1);
+				exit(RTVL_FAIL);
 			}
 
 			conf->verbosity = atoi(optarg);
@@ -924,7 +934,7 @@ main (int argc, char *argv[])
 			if (conf->pgpolicy_flag == IOPOLICY_UNDEF) {
 				printf("'%s' is not a valid policy\n", optarg);
 				usage(argv[0]);
-				exit(1);
+				exit(RTVL_FAIL);
 			}
 			break;
 		case 'r':
@@ -934,14 +944,14 @@ main (int argc, char *argv[])
 			conf->find_multipaths |= _FIND_MULTIPATHS_I;
 			break;
 		case 't':
-			r = dump_config(conf, NULL, NULL);
+			r = dump_config(conf, NULL, NULL) ? RTVL_FAIL : RTVL_OK;
 			goto out_free_config;
 		case 'T':
 			cmd = CMD_DUMP_CONFIG;
 			break;
 		case 'h':
 			usage(argv[0]);
-			exit(0);
+			exit(RTVL_OK);
 		case 'u':
 			cmd = CMD_VALID_PATH;
 			dev_type = DEV_UEVENT;
@@ -965,20 +975,20 @@ main (int argc, char *argv[])
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
-			exit(1);
+			exit(RTVL_FAIL);
 		case '?':
 			fprintf(stderr, "Unknown switch: %s\n", optarg);
 			usage(argv[0]);
-			exit(1);
+			exit(RTVL_FAIL);
 		default:
 			usage(argv[0]);
-			exit(1);
+			exit(RTVL_FAIL);
 		}
 	}
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
-		exit(1);
+		exit(RTVL_FAIL);
 	}
 
 	if (optind < argc) {
@@ -1016,7 +1026,8 @@ main (int argc, char *argv[])
 	/* Failing here is non-fatal */
 	init_foreign(conf->multipath_dir);
 	if (cmd == CMD_USABLE_PATHS) {
-		r = check_usable_paths(conf, dev, dev_type);
+		r = check_usable_paths(conf, dev, dev_type) ?
+			RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
 	if (cmd == CMD_VALID_PATH &&
@@ -1032,7 +1043,7 @@ main (int argc, char *argv[])
 		if (fd == -1) {
 			condlog(3, "%s: daemon is not running", dev);
 			if (!systemd_service_enabled(dev)) {
-				r = print_cmd_valid(1, NULL, conf);
+				r = print_cmd_valid(RTVL_NO, NULL, conf);
 				goto out;
 			}
 		} else
@@ -1046,9 +1057,9 @@ main (int argc, char *argv[])
 
 	switch(delegate_to_multipathd(cmd, dev, dev_type, conf)) {
 	case DELEGATE_OK:
-		exit(0);
+		exit(RTVL_OK);
 	case DELEGATE_ERROR:
-		exit(1);
+		exit(RTVL_FAIL);
 	case NOT_DELEGATED:
 		break;
 	}
@@ -1064,8 +1075,8 @@ main (int argc, char *argv[])
 			goto out;
 		}
 		if (dm_get_maps(curmp) == 0)
-			r = replace_wwids(curmp);
-		if (r == 0)
+			r = replace_wwids(curmp) ? RTVL_FAIL : RTVL_OK;
+		if (r == RTVL_OK)
 			printf("successfully reset wwids\n");
 		vector_foreach_slot_backwards(curmp, mpp, i) {
 			vector_del_slot(curmp, i);
@@ -1078,17 +1089,18 @@ main (int argc, char *argv[])
 		retries = conf->remove_retries;
 	if (conf->remove == FLUSH_ONE) {
 		if (dev_type == DEV_DEVMAP) {
-			r = dm_suspend_and_flush_map(dev, retries);
+			r = dm_suspend_and_flush_map(dev, retries) ?
+				RTVL_FAIL : RTVL_OK;
 		} else
 			condlog(0, "must provide a map name to remove");
 
 		goto out;
 	}
 	else if (conf->remove == FLUSH_ALL) {
-		r = dm_flush_maps(retries);
+		r = dm_flush_maps(retries) ? RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
-	while ((r = configure(conf, cmd, dev_type, dev)) < 0)
+	while ((r = configure(conf, cmd, dev_type, dev)) == RTVL_RETRY)
 		condlog(3, "restart multipath configuration process");
 
 out:
@@ -1103,8 +1115,8 @@ out:
 	 * multipath -u must exit with status 0, otherwise udev won't
 	 * import its output.
 	 */
-	if (cmd == CMD_VALID_PATH && dev_type == DEV_UEVENT && r == 1)
-		r = 0;
+	if (cmd == CMD_VALID_PATH && dev_type == DEV_UEVENT && r == RTVL_NO)
+		r = RTVL_OK;
 
 	if (dev_type == DEV_UEVENT)
 		closelog();
-- 
2.19.1
