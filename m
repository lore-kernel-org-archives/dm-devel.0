From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/21] dm: Compare entering field values with exiting ones
Date: Sun, 9 Oct 2016 16:30:33 +0300
Message-ID: <20161009133033.GA3547@obsidian>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005.192828.566127461630656590.yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

---
 dm.c             |   74 ++++++++++++++++++++++++++++++++++++++++--------------
 tests/ioctl_dm.c |   26 +++++++------------
 2 files changed, 64 insertions(+), 36 deletions(-)

diff --git a/dm.c b/dm.c
index f23a65d..b6fb11d 100644
--- a/dm.c
+++ b/dm.c
@@ -282,28 +282,62 @@ dm_decode_string(const struct dm_ioctl *ioc, const char *extra,
 static int
 dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 {
-	struct dm_ioctl ioc;
+	struct dm_ioctl *ioc;
+	struct dm_ioctl *entering_ioc = NULL;
+	bool ioc_changed = false;
 	char *extra = NULL;
 	uint32_t extra_size = 0;
 
-	if (umoven(tcp, arg, sizeof(ioc) - sizeof(ioc.data), &ioc) < 0)
+	ioc = malloc(sizeof(* ioc));
+	if (!ioc)
 		return 0;
+
+	if (umoven(tcp, arg, sizeof(*ioc) - sizeof(ioc->data), ioc) < 0) {
+		free(ioc);
+		return 0;
+	}
+	if (entering(tcp))
+		set_tcb_priv_data(tcp, ioc, free);
+	else {
+		entering_ioc = get_tcb_priv_data(tcp);
+
+		/*
+		 * retrieve_status, __dev_status called only in case of success,
+		 * so it looks like there's no need to check open_count,
+		 * event_nr, target_count, dev fields for change (they are
+		 * printed only in case of absence of errors).
+		 */
+		if (!entering_ioc ||
+		    (ioc->version[0] != entering_ioc->version[0]) ||
+		    (ioc->version[1] != entering_ioc->version[1]) ||
+		    (ioc->version[2] != entering_ioc->version[2]) ||
+		    (ioc->data_size != entering_ioc->data_size) ||
+		    (ioc->data_start != entering_ioc->data_start) ||
+		    (ioc->flags != entering_ioc->flags))
+			ioc_changed = true;
+	}
+
+	if (exiting(tcp) && syserror(tcp) && !ioc_changed) {
+		free(ioc);
+		return 1;
+	}
+
 	tprintf("%s{version=%d.%d.%d",  entering(tcp) ? ", " : " => ",
-		ioc.version[0], ioc.version[1], ioc.version[2]);
+		ioc->version[0], ioc->version[1], ioc->version[2]);
 
 	/*
 	 * if we use a different version of ABI, do not attempt to decode
 	 * ioctl fields
 	 */
-	if (ioc.version[0] != DM_VERSION_MAJOR) {
+	if (ioc->version[0] != DM_VERSION_MAJOR) {
 		tprints(", /* Unsupported device mapper ABI version */ ...");
 		goto skip;
 	}
 
-	if (ioc.data_size > sizeof(ioc)) {
-		extra = malloc(ioc.data_size);
+	if (ioc->data_size > sizeof(ioc)) {
+		extra = malloc(ioc->data_size);
 		if (extra) {
-			extra_size = ioc.data_size;
+			extra_size = ioc->data_size;
 			if (umoven(tcp, arg, extra_size, extra) < 0) {
 				free(extra);
 				extra = NULL;
@@ -311,9 +345,9 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 			}
 		}
 	}
-	dm_decode_device(code, &ioc);
-	dm_decode_values(tcp, code, &ioc);
-	dm_decode_flags(&ioc);
+	dm_decode_device(code, ioc);
+	dm_decode_values(tcp, code, ioc);
+	dm_decode_flags(ioc);
 	if (abbrev(tcp))
 		tprints(", ...");
 	else
@@ -322,42 +356,42 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 		case DM_TABLE_STATUS:
 			if (entering(tcp) || syserror(tcp))
 				break;
-			dm_decode_dm_target_spec(tcp, &ioc, extra, extra_size);
+			dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
 			break;
 		case DM_TABLE_LOAD:
 			if (!entering(tcp))
 				break;
-			dm_decode_dm_target_spec(tcp, &ioc, extra, extra_size);
+			dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
 			break;
 		case DM_TABLE_DEPS:
 			if (entering(tcp) || syserror(tcp))
 				break;
-			dm_decode_dm_target_deps(&ioc, extra, extra_size);
+			dm_decode_dm_target_deps(ioc, extra, extra_size);
 			break;
 		case DM_LIST_DEVICES:
 			if (entering(tcp) || syserror(tcp))
 				break;
-			dm_decode_dm_name_list(&ioc, extra, extra_size);
+			dm_decode_dm_name_list(ioc, extra, extra_size);
 			break;
 		case DM_LIST_VERSIONS:
 			if (entering(tcp) || syserror(tcp))
 				break;
-			dm_decode_dm_target_versions(&ioc, extra, extra_size);
+			dm_decode_dm_target_versions(ioc, extra, extra_size);
 			break;
 		case DM_TARGET_MSG:
 			if (entering(tcp)) {
-				dm_decode_dm_target_msg(&ioc, extra,
+				dm_decode_dm_target_msg(ioc, extra,
 							extra_size);
 			} else if (!syserror(tcp) &&
-			    ioc.flags & DM_DATA_OUT_FLAG) {
-				dm_decode_string(&ioc, extra, extra_size);
+			    ioc->flags & DM_DATA_OUT_FLAG) {
+				dm_decode_string(ioc, extra, extra_size);
 			}
 			break;
 		case DM_DEV_RENAME:
 		case DM_DEV_SET_GEOMETRY:
 			if (!entering(tcp))
 				break;
-			dm_decode_string(&ioc, extra, extra_size);
+			dm_decode_string(ioc, extra, extra_size);
 			break;
 		}
 
@@ -365,6 +399,8 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	tprints("}");
 	if (extra)
 		free(extra);
+	if (exiting(tcp))
+		free(ioc);
 	return 1;
 }
 
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 3c43913..31f474c 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -42,8 +42,6 @@ main(void)
 	ioctl(-1, DM_VERSION, &s);
 	printf("ioctl(-1, DM_VERSION, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0} => "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	init_s();
@@ -58,9 +56,8 @@ main(void)
 	printf("ioctl(-1, DM_TABLE_LOAD, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", target_count=1, flags=0, {sector_start=16, "
-	       "length=32, target_type=\"tgt\", string=\"tparams\"}} => "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	       "length=32, target_type=\"tgt\", string=\"tparams\"}}) = "
+	       "-1 EBADF (%m)\n");
 
 	init_s();
 	s.u.tm.target_msg.sector = 0x1234;
@@ -69,27 +66,24 @@ main(void)
 	ioctl(-1, DM_TARGET_MSG, &s);
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}} => "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	       "uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}}) = "
+	       "-1 EBADF (%m)\n");
 
 	init_s();
 	strcpy(s.u.string, "10 20 30 40");
 	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
 	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0, string=\"10 20 30 40\"} => "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	       "uuid=\"uuu\", flags=0, string=\"10 20 30 40\"}) = "
+	       "-1 EBADF (%m)\n");
 
 	init_s();
 	strcpy(s.u.string, "new-name");
 	ioctl(-1, DM_DEV_RENAME, &s);
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"} => "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	       "uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"}) = "
+	       "-1 EBADF (%m)\n");
 
 	init_s();
 	s.ioc.target_count = -1U;
@@ -98,9 +92,7 @@ main(void)
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", target_count=4294967295, flags=0, "
 	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
-	       "/* misplaced struct dm_target_spec */ ...} => "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	       "/* misplaced struct dm_target_spec */ ...}) = -1 EBADF (%m)\n");
 
 	puts("+++ exited with 0 +++");
 	return 0;
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
