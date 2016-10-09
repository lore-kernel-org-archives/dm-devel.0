From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/21] dm: rewrite structure decoding
Date: Sun, 9 Oct 2016 16:31:42 +0300
Message-ID: <20161009133142.GA4692@obsidian>
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

Rewrite structure decoding in attempt to make it more in line with how
structures and arrays are decoded in strace.
 * Replace single structure retrieval with on-demand retrieval. It
   allows limiting amount of memory being allocated (suppose ioctl with
   data_size = -1)
 * Check for abbrev in structure decoders itself. It allows
   distinguishing cases when we want to decode some additional data from
   cases when we are not.
---
 dm.c |  363 +++++++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 217 insertions(+), 146 deletions(-)

diff --git a/dm.c b/dm.c
index ff9e8ad..d846233 100644
--- a/dm.c
+++ b/dm.c
@@ -101,165 +101,254 @@ dm_decode_flags(const struct dm_ioctl *ioc)
 }
 
 static void
-dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
-			 const char *extra, uint32_t extra_size)
+dm_decode_dm_target_spec(struct tcb *tcp, unsigned long addr,
+			 const struct dm_ioctl *ioc)
 {
 	static const uint32_t target_spec_size =
 		sizeof(struct dm_target_spec);
 	uint32_t i;
 	uint32_t offset = ioc->data_start;
 
+	if (abbrev(tcp)) {
+		if (ioc->target_count)
+			tprints(", ...");
+
+		return;
+	}
+
 	for (i = 0; i < ioc->target_count; i++) {
-		if (offset + target_spec_size >= offset &&
-		    offset + target_spec_size < extra_size) {
-			uint32_t new_offset;
-			const struct dm_target_spec *s =
-				(const struct dm_target_spec *) (extra + offset);
-			tprintf(", {sector_start=%" PRIu64 ", length=%" PRIu64,
-				(uint64_t) s->sector_start,
-				(uint64_t) s->length);
-			if (!entering(tcp))
-				tprintf(", status=%" PRId32, s->status);
-			tprints(", target_type=");
-			print_quoted_string(s->target_type, DM_MAX_TYPE_NAME,
-					    QUOTE_0_TERMINATED);
-			tprints(", string=");
-			print_quoted_string((const char *) (s + 1), extra_size -
-					    (offset + target_spec_size),
-					    QUOTE_0_TERMINATED);
-			tprintf("}");
-			if (entering(tcp))
-				new_offset = offset + s->next;
-			else
-				new_offset = ioc->data_start + s->next;
-			if (new_offset <= offset + target_spec_size)
-				goto misplaced;
-			offset = new_offset;
-		} else {
-misplaced:
-			tprints(", /* misplaced struct dm_target_spec */ ...");
+		struct dm_target_spec s;
+		uint32_t new_offset;
+
+		if ((offset + target_spec_size) <= offset ||
+		    (offset + target_spec_size) > ioc->data_size)
+			goto misplaced;
+
+		tprints(", ");
+
+		if (i >= max_strlen) {
+			tprints("...");
 			break;
 		}
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			break;
+
+		tprintf("{sector_start=%" PRI__u64 ", length=%" PRI__u64,
+			s.sector_start, s.length);
+
+		if (!entering(tcp))
+			tprintf(", status=%" PRId32, s.status);
+
+		tprints(", target_type=");
+		print_quoted_string(s.target_type, DM_MAX_TYPE_NAME,
+				    QUOTE_0_TERMINATED);
+
+		tprints(", string=");
+		printstr_ex(tcp, addr + offset + target_spec_size,
+			     ioc->data_size - (offset + target_spec_size),
+			     QUOTE_0_TERMINATED);
+		tprintf("}");
+
+		if (entering(tcp))
+			new_offset = offset + s.next;
+		else
+			new_offset = ioc->data_start + s.next;
+
+		if (new_offset <= offset + target_spec_size)
+			goto misplaced;
+
+		offset = new_offset;
 	}
+
+	return;
+
+misplaced:
+	tprints(", /* misplaced struct dm_target_spec */ ...");
+}
+
+bool
+dm_print_dev(struct tcb *tcp, void *dev_ptr, size_t dev_size, void *dummy)
+{
+	uint64_t *dev = (uint64_t *) dev_ptr;
+
+	tprintf("makedev(%u, %u)", major(*dev), minor(*dev));
+
+	return 1;
 }
 
 static void
-dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
-			 uint32_t extra_size)
+dm_decode_dm_target_deps(struct tcb *tcp, unsigned long addr,
+			 const struct dm_ioctl *ioc)
 {
 	static const uint32_t target_deps_dev_offs =
 		offsetof(struct dm_target_deps, dev);
+	uint64_t dev_buf;
+	struct dm_target_deps s;
 	uint32_t offset = ioc->data_start;
+	uint32_t space;
 
-	if (offset + target_deps_dev_offs >= offset &&
-	    offset + target_deps_dev_offs <= extra_size) {
-		uint32_t i;
-		uint32_t space = (extra_size - offset - target_deps_dev_offs) /
-			sizeof(__u64);
-		const struct dm_target_deps *s =
-			(const struct dm_target_deps *) (extra + offset);
-
-		if (s->count > space)
-			goto misplaced;
-		tprints(", deps={");
-		for (i = 0; i < s->count; i++) {
-			tprintf("%smakedev(%u, %u)", i ? ", " : "",
-				major(s->dev[i]), minor(s->dev[i]));
-		}
-		tprints("}");
-	} else {
- misplaced:
-		tprints(", /* misplaced struct dm_target_deps */ ...");
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
 	}
+
+	tprints(", ");
+
+	if (offset + target_deps_dev_offs <= offset ||
+	    offset + target_deps_dev_offs > ioc->data_size)
+		goto misplaced;
+
+	if (umove_or_printaddr(tcp, addr + offset, &s))
+		return;
+
+	space = (ioc->data_size - offset - target_deps_dev_offs) / sizeof(__u64);
+
+	if (s.count > space)
+		goto misplaced;
+
+	tprintf("{count=%u, deps=", s.count);
+
+	print_array(tcp, addr + offset + target_deps_dev_offs, s.count,
+		    &dev_buf, sizeof(dev_buf), umoven_or_printaddr,
+		    dm_print_dev, NULL);
+
+	tprints("}");
+
+	return;
+
+misplaced:
+	tprints("/* misplaced struct dm_target_deps */ ...");
 }
 
 static void
-dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
-		       uint32_t extra_size)
+dm_decode_dm_name_list(struct tcb *tcp, unsigned long addr,
+		       const struct dm_ioctl *ioc)
 {
 	static const uint32_t name_list_name_offs =
 		offsetof(struct dm_name_list, name);
+	struct dm_name_list s;
 	uint32_t offset = ioc->data_start;
+	uint32_t count;
 
-	while (1) {
-		if (offset + name_list_name_offs >= offset &&
-		    offset + name_list_name_offs < extra_size) {
-			const struct dm_name_list *s =
-				(const struct dm_name_list *) (extra + offset);
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
 
-			if (!s->dev)
-				break;
-			tprintf(", {dev=makedev(%u, %u), name=", major(s->dev),
-				minor(s->dev));
-			print_quoted_string(s->name, extra_size - (offset +
-					    name_list_name_offs),
-					    QUOTE_0_TERMINATED);
-			tprints("}");
-			if (!s->next)
-				break;
-			if (offset + s->next <= offset + name_list_name_offs)
-				goto misplaced;
-			offset = offset + s->next;
-		} else {
- misplaced:
-			tprints(", /* misplaced struct dm_name_list */ ...");
+	for (count = 0;; count++) {
+		if (offset + name_list_name_offs <= offset ||
+		    offset + name_list_name_offs > ioc->data_size)
+			goto misplaced;
+
+		tprints(", ");
+
+		if (count >= max_strlen) {
+			tprints("...");
+			break;
+		}
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			break;
+		if (!count && !s.dev) {
+			tprints("/* no devices present */");
 			break;
 		}
+
+		tprintf("{dev=makedev(%u, %u), name=", major(s.dev),
+			minor(s.dev));
+		printstr_ex(tcp, addr + offset + name_list_name_offs,
+			    ioc->data_size - (offset + name_list_name_offs),
+			    QUOTE_0_TERMINATED);
+		tprints("}");
+
+		if (!s.next)
+			break;
+		if (offset + s.next <= offset + name_list_name_offs)
+			goto misplaced;
+		offset = offset + s.next;
 	}
+
+	return;
+
+misplaced:
+	tprints(", /* misplaced struct dm_name_list */ ...");
 }
 
 static void
-dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra,
-			     uint32_t extra_size)
+dm_decode_dm_target_versions(struct tcb *tcp, unsigned long addr,
+			     const struct dm_ioctl *ioc)
 {
 	static const uint32_t target_vers_name_offs =
 		offsetof(struct dm_target_versions, name);
+	struct dm_target_versions s;
 	uint32_t offset = ioc->data_start;
+	uint32_t count;
 
-	while (1) {
-		if (offset + target_vers_name_offs >= offset &&
-		    offset + target_vers_name_offs < extra_size) {
-			const struct dm_target_versions *s =
-			    (const struct dm_target_versions *)(extra + offset);
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
 
-			tprints(", {name=");
-			print_quoted_string(s->name, extra_size - (offset +
-					    target_vers_name_offs),
-					    QUOTE_0_TERMINATED);
-			tprintf(", version=%" PRIu32 ".%" PRIu32 ".%" PRIu32 "}",
-				s->version[0], s->version[1], s->version[2]);
-			if (!s->next)
-				break;
-			if (offset + s->next <= offset + target_vers_name_offs)
-				goto misplaced;
-			offset = offset + s->next;
-		} else {
- misplaced:
-			tprints(", /* misplaced struct dm_target_versions */ "
-				"...");
+	for (count = 0;; count++) {
+		if (offset + target_vers_name_offs <= offset ||
+		    offset + target_vers_name_offs > ioc->data_size)
+			goto misplaced;
+
+		tprints(", ");
+
+		if (count >= max_strlen) {
+			tprints("...");
 			break;
 		}
+
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			break;
+
+		tprints("{name=");
+		printstr_ex(tcp, addr + offset + target_vers_name_offs,
+			    ioc->data_size - (offset + target_vers_name_offs),
+			    QUOTE_0_TERMINATED);
+		tprintf(", version=%" PRIu32 ".%" PRIu32 ".%" PRIu32 "}",
+			s.version[0], s.version[1], s.version[2]);
+
+		if (!s.next)
+			break;
+		if (offset + s.next <= offset + target_vers_name_offs)
+			goto misplaced;
+		offset = offset + s.next;
 	}
+
+	return;
+
+misplaced:
+	tprints(", /* misplaced struct dm_target_versions */ ...");
 }
 
 static void
-dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
-			uint32_t extra_size)
+dm_decode_dm_target_msg(struct tcb *tcp, unsigned long addr,
+		        const struct dm_ioctl *ioc)
 {
 	static const uint32_t target_msg_message_offs =
 		offsetof(struct dm_target_msg, message);
 	uint32_t offset = ioc->data_start;
 
-	if (offset + target_msg_message_offs >= offset &&
-	    offset + target_msg_message_offs < extra_size) {
-		const struct dm_target_msg *s =
-			(const struct dm_target_msg *) (extra + offset);
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	if (offset + target_msg_message_offs > offset &&
+	    offset + target_msg_message_offs <= ioc->data_size) {
+		struct dm_target_msg s;
 
-		tprintf(", {sector=%" PRIu64 ", message=",
-			(uint64_t) s->sector);
-		print_quoted_string(s->message, extra_size -
-				    target_msg_message_offs,
-				    QUOTE_0_TERMINATED);
+		if (umove_or_printaddr(tcp, addr + offset, &s))
+			return;
+
+		tprintf(", {sector=%" PRI__u64 ", message=", s.sector);
+		printstr_ex(tcp, addr + offset + target_msg_message_offs,
+			    ioc->data_size - offset - target_msg_message_offs,
+			    QUOTE_0_TERMINATED);
 		tprints("}");
 	} else {
 		tprints(", /* misplaced struct dm_target_msg */");
@@ -267,15 +356,20 @@ dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
 }
 
 static void
-dm_decode_string(const struct dm_ioctl *ioc, const char *extra,
-		 uint32_t extra_size)
+dm_decode_string(struct tcb *tcp, unsigned long addr,
+		 const struct dm_ioctl *ioc)
 {
 	uint32_t offset = ioc->data_start;
 
-	if (offset < extra_size) {
+	if (abbrev(tcp)) {
+		tprints(", ...");
+		return;
+	}
+
+	if (offset < ioc->data_size) {
 		tprints(", string=");
-		print_quoted_string(extra + offset, extra_size - offset,
-				    QUOTE_0_TERMINATED);
+		printstr_ex(tcp, addr + offset, ioc->data_size - offset,
+			    QUOTE_0_TERMINATED);
 	} else {
 		tprints(", /* misplaced string */");
 	}
@@ -301,11 +395,9 @@ dm_ioctl_has_params(const unsigned int code)
 static int
 dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 {
-	struct dm_ioctl *ioc;
+	struct dm_ioctl *ioc = NULL;
 	struct dm_ioctl *entering_ioc = NULL;
 	bool ioc_changed = false;
-	char *extra = NULL;
-	uint32_t extra_size = 0;
 
 	ioc = malloc(sizeof(* ioc));
 	if (!ioc)
@@ -371,70 +463,49 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	dm_decode_values(tcp, code, ioc);
 	dm_decode_flags(ioc);
 
-	if (dm_ioctl_has_params(code) && (ioc->data_size > sizeof(ioc))) {
-		extra = malloc(ioc->data_size);
-		if (extra) {
-			extra_size = ioc->data_size;
-			if (umoven(tcp, arg, extra_size, extra) < 0) {
-				free(extra);
-				extra = NULL;
-				extra_size = 0;
-			}
-		}
-	}
-
-	if (abbrev(tcp)) {
-		tprints(", ...");
-		goto skip;
-	}
-
 	switch (code) {
 	case DM_DEV_WAIT:
 	case DM_TABLE_STATUS:
 		if (entering(tcp) || syserror(tcp))
 			break;
-		dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
+		dm_decode_dm_target_spec(tcp, arg, ioc);
 		break;
 	case DM_TABLE_LOAD:
 		if (!entering(tcp))
 			break;
-		dm_decode_dm_target_spec(tcp, ioc, extra, extra_size);
+		dm_decode_dm_target_spec(tcp, arg, ioc);
 		break;
 	case DM_TABLE_DEPS:
 		if (entering(tcp) || syserror(tcp))
 			break;
-		dm_decode_dm_target_deps(ioc, extra, extra_size);
+		dm_decode_dm_target_deps(tcp, arg, ioc);
 		break;
 	case DM_LIST_DEVICES:
 		if (entering(tcp) || syserror(tcp))
 			break;
-		dm_decode_dm_name_list(ioc, extra, extra_size);
+		dm_decode_dm_name_list(tcp, arg, ioc);
 		break;
 	case DM_LIST_VERSIONS:
 		if (entering(tcp) || syserror(tcp))
 			break;
-		dm_decode_dm_target_versions(ioc, extra, extra_size);
+		dm_decode_dm_target_versions(tcp, arg, ioc);
 		break;
 	case DM_TARGET_MSG:
-		if (entering(tcp)) {
-			dm_decode_dm_target_msg(ioc, extra,
-						extra_size);
-		} else if (!syserror(tcp) && ioc->flags & DM_DATA_OUT_FLAG) {
-			dm_decode_string(ioc, extra, extra_size);
-		}
+		if (entering(tcp))
+			dm_decode_dm_target_msg(tcp, arg, ioc);
+		else if (!syserror(tcp) && ioc->flags & DM_DATA_OUT_FLAG)
+			dm_decode_string(tcp, arg, ioc);
 		break;
 	case DM_DEV_RENAME:
 	case DM_DEV_SET_GEOMETRY:
 		if (!entering(tcp))
 			break;
-		dm_decode_string(ioc, extra, extra_size);
+		dm_decode_string(tcp, arg, ioc);
 		break;
 	}
 
  skip:
 	tprints("}");
-	if (extra)
-		free(extra);
 	if (exiting(tcp))
 		free(ioc);
 	return 1;
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
