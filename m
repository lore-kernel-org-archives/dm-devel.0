From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/21] dm: Use static constants for offset sizes
Date: Sun, 9 Oct 2016 16:30:06 +0300
Message-ID: <20161009133006.GA3129@obsidian>
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

This may improve readability an leads to more compact code.
---
 dm.c |   58 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/dm.c b/dm.c
index 66b615d..adfa97e 100644
--- a/dm.c
+++ b/dm.c
@@ -102,12 +102,14 @@ static void
 dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
 			 const char *extra, uint32_t extra_size)
 {
+	static const uint32_t target_spec_size =
+		sizeof(struct dm_target_spec);
 	uint32_t i;
 	uint32_t offset = ioc->data_start;
 
 	for (i = 0; i < ioc->target_count; i++) {
-		if (offset + (uint32_t) sizeof(struct dm_target_spec) >= offset &&
-		    offset + (uint32_t) sizeof(struct dm_target_spec) < extra_size) {
+		if (offset + target_spec_size >= offset &&
+		    offset + target_spec_size < extra_size) {
 			uint32_t new_offset;
 			const struct dm_target_spec *s =
 				(const struct dm_target_spec *) (extra + offset);
@@ -121,16 +123,14 @@ dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
 					    QUOTE_0_TERMINATED);
 			tprints(", string=");
 			print_quoted_string((const char *) (s + 1), extra_size -
-					    (offset +
-					    sizeof(struct dm_target_spec)),
+					    (offset + target_spec_size),
 					    QUOTE_0_TERMINATED);
 			tprintf("}");
 			if (entering(tcp))
 				new_offset = offset + s->next;
 			else
 				new_offset = ioc->data_start + s->next;
-			if (new_offset <= offset +
-			    (uint32_t) sizeof(struct dm_target_spec))
+			if (new_offset <= offset + target_spec_size)
 				goto misplaced;
 			offset = new_offset;
 		} else {
@@ -145,13 +145,15 @@ static void
 dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
 			 uint32_t extra_size)
 {
+	static const uint32_t target_deps_dev_offs =
+		offsetof(struct dm_target_deps, dev);
 	uint32_t offset = ioc->data_start;
-	if (offset + (uint32_t) offsetof(struct dm_target_deps, dev) >= offset &&
-	    offset + (uint32_t) offsetof(struct dm_target_deps, dev) <= extra_size) {
 
+	if (offset + target_deps_dev_offs >= offset &&
+	    offset + target_deps_dev_offs <= extra_size) {
 		uint32_t i;
-		uint32_t space = (extra_size - (offset +
-			offsetof(struct dm_target_deps, dev))) / sizeof(__u64);
+		uint32_t space = (extra_size - offset - target_deps_dev_offs) /
+			sizeof(__u64);
 		const struct dm_target_deps *s =
 			(const struct dm_target_deps *) (extra + offset);
 
@@ -173,11 +175,13 @@ static void
 dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
 		       uint32_t extra_size)
 {
+	static const uint32_t name_list_name_offs =
+		offsetof(struct dm_name_list, name);
 	uint32_t offset = ioc->data_start;
 
 	while (1) {
-		if (offset + (uint32_t) offsetof(struct dm_name_list, name) >= offset &&
-		    offset + (uint32_t) offsetof(struct dm_name_list, name) < extra_size) {
+		if (offset + name_list_name_offs >= offset &&
+		    offset + name_list_name_offs < extra_size) {
 			const struct dm_name_list *s =
 				(const struct dm_name_list *) (extra + offset);
 
@@ -186,13 +190,12 @@ dm_decode_dm_name_list(const struct dm_ioctl *ioc, const char *extra,
 			tprintf(", {dev=makedev(%u, %u), name=", major(s->dev),
 				minor(s->dev));
 			print_quoted_string(s->name, extra_size - (offset +
-					    offsetof(struct dm_name_list,
-					    name)), QUOTE_0_TERMINATED);
+					    name_list_name_offs),
+					    QUOTE_0_TERMINATED);
 			tprints("}");
 			if (!s->next)
 				break;
-			if (offset + s->next <= offset +
-			    (uint32_t) offsetof(struct dm_name_list, name))
+			if (offset + s->next <= offset + name_list_name_offs)
 				goto misplaced;
 			offset = offset + s->next;
 		} else {
@@ -207,26 +210,25 @@ static void
 dm_decode_dm_target_versions(const struct dm_ioctl *ioc, const char *extra,
 			     uint32_t extra_size)
 {
+	static const uint32_t target_vers_name_offs =
+		offsetof(struct dm_target_versions, name);
 	uint32_t offset = ioc->data_start;
 
 	while (1) {
-		if (offset + (uint32_t) offsetof(struct dm_target_versions, name) >=
-		    offset &&
-		    offset + (uint32_t) offsetof(struct dm_target_versions, name) <
-		    extra_size) {
+		if (offset + target_vers_name_offs >= offset &&
+		    offset + target_vers_name_offs < extra_size) {
 			const struct dm_target_versions *s =
 			    (const struct dm_target_versions *)(extra + offset);
 
 			tprints(", {name=");
 			print_quoted_string(s->name, extra_size - (offset +
-					    offsetof(struct dm_target_versions,
-					    name)), QUOTE_0_TERMINATED);
+					    target_vers_name_offs),
+					    QUOTE_0_TERMINATED);
 			tprintf(", version=%" PRIu32 ".%" PRIu32 ".%" PRIu32 "}",
 				s->version[0], s->version[1], s->version[2]);
 			if (!s->next)
 				break;
-			if (offset + s->next <= offset +
-			    (uint32_t) offsetof(struct dm_target_versions, name))
+			if (offset + s->next <= offset + target_vers_name_offs)
 				goto misplaced;
 			offset = offset + s->next;
 		} else {
@@ -242,17 +244,19 @@ static void
 dm_decode_dm_target_msg(const struct dm_ioctl *ioc, const char *extra,
 			uint32_t extra_size)
 {
+	static const uint32_t target_msg_message_offs =
+		offsetof(struct dm_target_msg, message);
 	uint32_t offset = ioc->data_start;
 
-	if (offset + (uint32_t) offsetof(struct dm_target_msg, message) >= offset &&
-	    offset + (uint32_t) offsetof(struct dm_target_msg, message) < extra_size) {
+	if (offset + target_msg_message_offs >= offset &&
+	    offset + target_msg_message_offs < extra_size) {
 		const struct dm_target_msg *s =
 			(const struct dm_target_msg *) (extra + offset);
 
 		tprintf(", {sector=%" PRIu64 ", message=",
 			(uint64_t) s->sector);
 		print_quoted_string(s->message, extra_size -
-				    offsetof(struct dm_target_msg, message),
+				    target_msg_message_offs,
 				    QUOTE_0_TERMINATED);
 		tprints("}");
 	} else {
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
