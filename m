From: Neil Brown <neilb@suse.de>
Subject: [PATCH] dmraid: Handle spaces in names stored in vendor
	metadata.
Date: Tue, 23 Feb 2010 13:38:33 +1100
Message-ID: <19331.16297.375514.579107@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi Heinz,
 I sent you a few patches a few weeks ago which fixes some problems
 with the dmraid Makefile, but haven't heard back?  Let me know
 if I should resend them.

Here is another patch.  This is related to a rather ancient discussion
which included

    https://www.redhat.com/archives/dm-devel/2008-December/msg00019.html

I think I can get you the "dmraid -rD" output that you asked for in
that email if you are still interested, but the problem is fairly
simple to identify and affects ddf1 and isw metadata as they contain
strings that are included in the name.
This patch changes any spaces (and other special characters) in those
names to '_'.

Thanks,
NeilBrown


-------------
When dmraid activates an array, it builds a name from information in
the metadata.  For two formats of metadata (isw and ddf1), the
information can include a textual string.

dmraid does not allow arrays be created with spaces in the name and
so makes no attempt to handle spaces well.  So for consistency it
should not allow spaces stored in the metadata to get in to the name
either.

This patch changes every character that dmraid would not allow in a
name to be converted to '_'

Signed-off-by: NeilBrown <neilb@suse.de>

---
 include/dmraid/misc.h    |    1 +
 lib/format/ataraid/isw.c |    7 ++++++-
 lib/format/ddf/ddf1.c    |    1 +
 lib/misc/misc.c          |   14 ++++++++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

--- dmraid.orig/include/dmraid/misc.h
+++ dmraid/include/dmraid/misc.h
@@ -18,6 +18,7 @@ extern void libdmraid_exit(struct lib_co
 
 extern void sysfs_workaround(struct lib_context *lc);
 extern void mk_alpha(struct lib_context *lc, char *str, size_t len);
+extern void mk_alphanum(struct lib_context *lc, char *str, size_t len);
 extern char *get_basename(struct lib_context *lc, char *str);
 extern char *get_dirname(struct lib_context *lc, char *str);
 extern char *remove_white_space(struct lib_context *lc, char *str, size_t len);
--- dmraid.orig/lib/format/ataraid/isw.c
+++ dmraid/lib/format/ataraid/isw.c
@@ -169,6 +169,7 @@ static size_t
 _name(struct lib_context *lc, struct isw *isw, char *str, size_t len,
       enum name_type nt, int num, struct isw_dev *dev, struct raid_dev *rd)
 {
+	int n;
 	struct {
 		const char *fmt, *what;
 	} formats[] = {
@@ -189,7 +190,11 @@ _name(struct lib_context *lc, struct isw
 			f += (is_raid10(dev) ? 1 : 0);
 	}
 
-	return snprintf(str, len, f->fmt, isw->family_num, f->what, num);
+	n = snprintf(str, len, f->fmt, isw->family_num, f->what, num);
+	/* As '->volume' could contain anything, we need to sanitise the name */
+	if (str)
+		mk_alphanum(lc, str, n);
+	return n;
 }
 
 static char *
--- dmraid.orig/lib/format/ddf/ddf1.c
+++ dmraid/lib/format/ddf/ddf1.c
@@ -689,6 +689,7 @@ name(struct lib_context *lc, struct ddf1
 		i = prefix + 16;
 		while (!isgraph(buf[--i]));
 		buf[i + 1] = 0;
+		mk_alphanum(lc, buf, i);
 	} else {
 		char *b;
 
--- dmraid.orig/lib/misc/misc.c
+++ dmraid/lib/misc/misc.c
@@ -66,6 +66,20 @@ mk_alpha(struct lib_context *lc, char *s
 	}
 }
 
+/* Convert a string to only have alphanum or '-' or '_'.
+ * All others become '_'
+ */
+void
+mk_alphanum(struct lib_context *lc, char *str, size_t len)
+{
+	for (; len && *str; len--, str++) {
+		if (!isalnum(*str) &&
+		    *str != '-' &&
+		    *str != '_')
+			*str = '_';
+	}
+}
+
 /* Remove any whitespace from a string. */
 char *
 remove_white_space(struct lib_context *lc, char *str, size_t size)
