From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/21] dm: whitespace fixes
Date: Sun, 9 Oct 2016 16:28:37 +0300
Message-ID: <20161009132837.GA1936@obsidian>
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
 dm.c |   87 +++++++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 52 insertions(+), 35 deletions(-)

diff --git a/dm.c b/dm.c
index 33a3972..d81983d 100644
--- a/dm.c
+++ b/dm.c
@@ -2,8 +2,8 @@
 
 #ifdef HAVE_LINUX_DM_IOCTL_H
 
-#include <sys/ioctl.h>
-#include <linux/dm-ioctl.h>
+# include <sys/ioctl.h>
+# include <linux/dm-ioctl.h>
 
 static void
 dm_decode_device(const unsigned int code, const struct dm_ioctl *ioc)
@@ -38,7 +38,7 @@ dm_decode_values(struct tcb *tcp, const unsigned int code,
 	if (entering(tcp)) {
 		switch (code) {
 		case DM_TABLE_LOAD:
-			tprintf(", target_count=%"PRIu32"",
+			tprintf(", target_count=%" PRIu32,
 				ioc->target_count);
 			break;
 		case DM_DEV_SUSPEND:
@@ -47,7 +47,7 @@ dm_decode_values(struct tcb *tcp, const unsigned int code,
 		case DM_DEV_RENAME:
 		case DM_DEV_REMOVE:
 		case DM_DEV_WAIT:
-			tprintf(", event_nr=%"PRIu32"",
+			tprintf(", event_nr=%" PRIu32,
 				ioc->event_nr);
 			break;
 		}
@@ -63,11 +63,11 @@ dm_decode_values(struct tcb *tcp, const unsigned int code,
 		case DM_TABLE_DEPS:
 		case DM_TABLE_STATUS:
 		case DM_TARGET_MSG:
-			tprintf(", target_count=%"PRIu32"",
+			tprintf(", target_count=%" PRIu32,
 				ioc->target_count);
-			tprintf(", open_count=%"PRIu32"",
+			tprintf(", open_count=%" PRIu32,
 				ioc->open_count);
-			tprintf(", event_nr=%"PRIu32"",
+			tprintf(", event_nr=%" PRIu32,
 				ioc->event_nr);
 			break;
 		}
@@ -89,21 +89,23 @@ dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
 {
 	uint32_t i;
 	uint32_t offset = ioc->data_start;
+
 	for (i = 0; i < ioc->target_count; i++) {
-		if (offset + (uint32_t)sizeof(struct dm_target_spec) >= offset &&
-		    offset + (uint32_t)sizeof(struct dm_target_spec) < extra_size) {
+		if (offset + (uint32_t) sizeof(struct dm_target_spec) >= offset &&
+		    offset + (uint32_t) sizeof(struct dm_target_spec) < extra_size) {
 			uint32_t new_offset;
 			const struct dm_target_spec *s =
-				(const struct dm_target_spec *)(extra + offset);
-			tprintf(", {sector_start=%"PRIu64", length=%"PRIu64"",
-				(uint64_t)s->sector_start, (uint64_t)s->length);
+				(const struct dm_target_spec *) (extra + offset);
+			tprintf(", {sector_start=%" PRIu64 ", length=%" PRIu64,
+				(uint64_t) s->sector_start,
+				(uint64_t) s->length);
 			if (!entering(tcp))
-				tprintf(", status=%"PRId32"", s->status);
+				tprintf(", status=%" PRId32, s->status);
 			tprints(", target_type=");
 			print_quoted_string(s->target_type, DM_MAX_TYPE_NAME,
 					    QUOTE_0_TERMINATED);
 			tprints(", string=");
-			print_quoted_string((const char *)(s + 1), extra_size -
+			print_quoted_string((const char *) (s + 1), extra_size -
 					    (offset +
 					    sizeof(struct dm_target_spec)),
 					    QUOTE_0_TERMINATED);
@@ -112,7 +114,8 @@ dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
 				new_offset = offset + s->next;
 			else
 				new_offset = ioc->data_start + s->next;
-			if (new_offset <= offset + (uint32_t)sizeof(struct dm_target_spec))
+			if (new_offset <= offset +
+			    (uint32_t) sizeof(struct dm_target_spec))
 				goto misplaced;
 			offset = new_offset;
 		} else {
@@ -128,13 +131,15 @@ dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
 			 uint32_t extra_size)
 {
 	uint32_t offset = ioc->data_start;
-	if (offset + (uint32_t)offsetof(struct dm_target_deps, dev) >= offset &&
-	    offset + (uint32_t)offsetof(struct dm_target_deps, dev) <= extra_size) {
+	if (offset + (uint32_t) offsetof(struct dm_target_deps, dev) >= offset &&
+	    offset + (uint32_t) offsetof(struct dm_target_deps, dev) <= extra_size) {
+
 		uint32_t i;
 		uint32_t space = (extra_size - (offset +
 			offsetof(struct dm_target_deps, dev))) / sizeof(__u64);
 		const struct dm_target_deps *s =
-			(const struct dm_target_deps *)(extra + offset);
+			(const struct dm_target_deps *) (extra + offset);
+
 		if (s->count > space)
 			goto misplaced;
 		tprints(", deps={");
@@ -154,21 +159,25 @@ dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
 		       uint32_t extra_size)
 {
 	uint32_t offset = ioc->data_start;
+
 	while (1) {
-		if (offset + (uint32_t)offsetof(struct dm_name_list, name) >= offset &&
-		    offset + (uint32_t)offsetof(struct dm_name_list, name) < extra_size) {
+		if (offset + (uint32_t) offsetof(struct dm_name_list, name) >= offset &&
+		    offset + (uint32_t) offsetof(struct dm_name_list, name) < extra_size) {
 			const struct dm_name_list *s =
-				(const struct dm_name_list *)(extra + offset);
+				(const struct dm_name_list *) (extra + offset);
+
 			if (!s->dev)
 				break;
-			tprintf(", {dev=makedev(%u, %u), name=", major(s->dev), minor(s->dev));
+			tprintf(", {dev=makedev(%u, %u), name=", major(s->dev),
+				minor(s->dev));
 			print_quoted_string(s->name, extra_size - (offset +
 					    offsetof(struct dm_name_list,
 					    name)), QUOTE_0_TERMINATED);
 			tprints("}");
 			if (!s->next)
 				break;
-			if (offset + s->next <= offset + (uint32_t)offsetof(struct dm_name_list, name))
+			if (offset + s->next <= offset +
+			    (uint32_t) offsetof(struct dm_name_list, name))
 				goto misplaced;
 			offset = offset + s->next;
 		} else {
@@ -184,22 +193,25 @@ dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra,
 			     uint32_t extra_size)
 {
 	uint32_t offset = ioc->data_start;
+
 	while (1) {
-		if (offset + (uint32_t)offsetof(struct dm_target_versions, name) >=
+		if (offset + (uint32_t) offsetof(struct dm_target_versions, name) >=
 		    offset &&
-		    offset + (uint32_t)offsetof(struct dm_target_versions, name) <
+		    offset + (uint32_t) offsetof(struct dm_target_versions, name) <
 		    extra_size) {
 			const struct dm_target_versions *s =
 			    (const struct dm_target_versions *)(extra + offset);
+
 			tprints(", {name=");
 			print_quoted_string(s->name, extra_size - (offset +
 					    offsetof(struct dm_target_versions,
 					    name)), QUOTE_0_TERMINATED);
-			tprintf(", version=%"PRIu32".%"PRIu32".%"PRIu32"}",
+			tprintf(", version=%" PRIu32 ".%" PRIu32 ".%" PRIu32 "}",
 				s->version[0], s->version[1], s->version[2]);
 			if (!s->next)
 				break;
-			if (offset + s->next <= offset + (uint32_t)offsetof(struct dm_target_versions, name))
+			if (offset + s->next <= offset +
+			    (uint32_t) offsetof(struct dm_target_versions, name))
 				goto misplaced;
 			offset = offset + s->next;
 		} else {
@@ -215,11 +227,14 @@ dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
 			uint32_t extra_size)
 {
 	uint32_t offset = ioc->data_start;
-	if (offset + (uint32_t)offsetof(struct dm_target_msg, message) >= offset &&
-	    offset + (uint32_t)offsetof(struct dm_target_msg, message) < extra_size) {
+
+	if (offset + (uint32_t) offsetof(struct dm_target_msg, message) >= offset &&
+	    offset + (uint32_t) offsetof(struct dm_target_msg, message) < extra_size) {
 		const struct dm_target_msg *s =
-			(const struct dm_target_msg *)(extra + offset);
-		tprintf(", {sector=%"PRIu64", message=", (uint64_t)s->sector);
+			(const struct dm_target_msg *) (extra + offset);
+
+		tprintf(", {sector=%" PRIu64 ", message=",
+			(uint64_t) s->sector);
 		print_quoted_string(s->message, extra_size -
 				    offsetof(struct dm_target_msg, message),
 				    QUOTE_0_TERMINATED);
@@ -234,6 +249,7 @@ dm_decode_string(const struct dm_ioctl *ioc, const char *extra,
 		 uint32_t extra_size)
 {
 	uint32_t offset = ioc->data_start;
+
 	if (offset < extra_size) {
 		tprints(", string=");
 		print_quoted_string(extra + offset, extra_size - offset,
@@ -250,7 +266,7 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	char *extra = NULL;
 	uint32_t extra_size = 0;
 
-	if (umoven(tcp, arg, sizeof(ioc) - sizeof(ioc.data), (char *)&ioc) < 0)
+	if (umoven(tcp, arg, sizeof(ioc) - sizeof(ioc.data), (char *) &ioc) < 0)
 		return 0;
 	tprintf(", {version=%d.%d.%d", ioc.version[0], ioc.version[1],
 		ioc.version[2]);
@@ -276,7 +292,8 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	dm_decode_device(code, &ioc);
 	dm_decode_values(tcp, code, &ioc);
 	dm_decode_flags(&ioc);
-	if (!abbrev(tcp)) switch (code) {
+	if (!abbrev(tcp))
+		switch (code) {
 		case DM_DEV_WAIT:
 		case DM_TABLE_STATUS:
 			if (entering(tcp) || syserror(tcp))
@@ -308,7 +325,7 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 				dm_decode_dm_target_msg(&ioc, extra,
 							extra_size);
 			} else if (!syserror(tcp) &&
-				   ioc.flags & DM_DATA_OUT_FLAG) {
+			    ioc.flags & DM_DATA_OUT_FLAG) {
 				dm_decode_string(&ioc, extra, extra_size);
 			}
 			break;
@@ -318,7 +335,7 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 				break;
 			dm_decode_string(&ioc, extra, extra_size);
 			break;
-	}
+		}
 
  skip:
 	tprints("}");
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
