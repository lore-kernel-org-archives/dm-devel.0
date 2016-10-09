From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/21] dm: replace abbrev branching with goto
Date: Sun, 9 Oct 2016 16:30:56 +0300
Message-ID: <20161009133056.GA3900@obsidian>
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
 dm.c |   78 ++++++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/dm.c b/dm.c
index 73a9b57..814d7d2 100644
--- a/dm.c
+++ b/dm.c
@@ -350,52 +350,54 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 			}
 		}
 	}
-	if (abbrev(tcp))
+
+	if (abbrev(tcp)) {
 		tprints(", ...");
-	else
-		switch (code) {
-		case DM_DEV_WAIT:
-		case DM_TABLE_STATUS:
-			if (entering(tcp) || syserror(tcp))
-				break;
-			dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
-			break;
-		case DM_TABLE_LOAD:
-			if (!entering(tcp))
-				break;
-			dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
+		goto skip;
+	}
+
+	switch (code) {
+	case DM_DEV_WAIT:
+	case DM_TABLE_STATUS:
+		if (entering(tcp) || syserror(tcp))
 			break;
-		case DM_TABLE_DEPS:
-			if (entering(tcp) || syserror(tcp))
-				break;
-			dm_decode_dm_target_deps(ioc, extra, extra_size);
+		dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
+		break;
+	case DM_TABLE_LOAD:
+		if (!entering(tcp))
 			break;
-		case DM_LIST_DEVICES:
-			if (entering(tcp) || syserror(tcp))
-				break;
-			dm_decode_dm_name_list(ioc, extra, extra_size);
+		dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
+		break;
+	case DM_TABLE_DEPS:
+		if (entering(tcp) || syserror(tcp))
 			break;
-		case DM_LIST_VERSIONS:
-			if (entering(tcp) || syserror(tcp))
-				break;
-			dm_decode_dm_target_versions(ioc, extra, extra_size);
+		dm_decode_dm_target_deps(ioc, extra, extra_size);
+		break;
+	case DM_LIST_DEVICES:
+		if (entering(tcp) || syserror(tcp))
 			break;
-		case DM_TARGET_MSG:
-			if (entering(tcp)) {
-				dm_decode_dm_target_msg(ioc, extra,
-							extra_size);
-			} else if (!syserror(tcp) &&
-			    ioc->flags & DM_DATA_OUT_FLAG) {
-				dm_decode_string(ioc, extra, extra_size);
-			}
+		dm_decode_dm_name_list(ioc, extra, extra_size);
+		break;
+	case DM_LIST_VERSIONS:
+		if (entering(tcp) || syserror(tcp))
 			break;
-		case DM_DEV_RENAME:
-		case DM_DEV_SET_GEOMETRY:
-			if (!entering(tcp))
-				break;
+		dm_decode_dm_target_versions(ioc, extra, extra_size);
+		break;
+	case DM_TARGET_MSG:
+		if (entering(tcp)) {
+			dm_decode_dm_target_msg(ioc, extra,
+						extra_size);
+		} else if (!syserror(tcp) && ioc->flags & DM_DATA_OUT_FLAG) {
 			dm_decode_string(ioc, extra, extra_size);
-			break;
 		}
+		break;
+	case DM_DEV_RENAME:
+	case DM_DEV_SET_GEOMETRY:
+		if (!entering(tcp))
+			break;
+		dm_decode_string(ioc, extra, extra_size);
+		break;
+	}
 
  skip:
 	tprints("}");
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
