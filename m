From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 13/20] libmultipath: print: convert API to
	generic data type
Date: Tue, 20 Feb 2018 14:26:51 +0100
Message-ID: <20180220132658.22295-14-mwilck@suse.com>
References: <20180220132658.22295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180220132658.22295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Convert higher level API (snprint_multipath_topology() etc) to
using the generic multipath API. This will allow "foreign"
multipath objects that implement the generic API to be printed
exactly like native multipathd objects.

The previous API (using "struct multipath*" and "struct path" remains
in place through macros mapping to the new functions. By doing this
and testing in regular setups, it's easily verified that the new
API works and produces the same results.

Moreover, abstract out the code to determine the output format from multipath
properties into snprint_multipath_style(), to be able to use it as generic
->style() method.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c  |   1 +
 libmultipath/dm-generic.c |   2 +-
 libmultipath/print.c      | 116 +++++++++++++++++++++++++++++-----------------
 libmultipath/print.h      |  28 ++++++++---
 multipath/main.c          |   1 +
 multipathd/cli_handlers.c |   1 +
 6 files changed, 100 insertions(+), 49 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 13e14cc25fff..42b7c896ee65 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -30,6 +30,7 @@
 #include "discovery.h"
 #include "debug.h"
 #include "switchgroup.h"
+#include "dm-generic.h"
 #include "print.h"
 #include "configure.h"
 #include "pgpolicies.h"
diff --git a/libmultipath/dm-generic.c b/libmultipath/dm-generic.c
index 42a26085d087..bdc9ca0a488b 100644
--- a/libmultipath/dm-generic.c
+++ b/libmultipath/dm-generic.c
@@ -56,7 +56,7 @@ const struct gen_multipath_ops dm_gen_multipath_ops = {
 	.get_pathgroups = dm_mp_get_pgs,
 	.rel_pathgroups = dm_mp_rel_pgs,
 	.snprint = snprint_multipath_attr,
-	/* .style = snprint_multipath_style, TBD */
+	.style = snprint_multipath_style,
 };
 
 const struct gen_pathgroup_ops dm_gen_pathgroup_ops = {
diff --git a/libmultipath/print.c b/libmultipath/print.c
index e6f56381791f..8846765066ef 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -31,7 +31,8 @@
 #include "discovery.h"
 #include "dm-generic.h"
 
-#define MAX(x,y) (x > y) ? x : y
+#define MAX(x,y) (((x) > (y)) ? (x) : (y))
+#define MIN(x,y) (((x) > (y)) ? (y) : (x))
 #define TAIL     (line + len - 1 - c)
 #define NOPAD    s = c
 #define PAD(x) \
@@ -846,8 +847,8 @@ snprint_multipath_header (char * line, int len, const char * format)
 }
 
 int
-snprint_multipath (char * line, int len, const char * format,
-	     const struct multipath * mpp, int pad)
+_snprint_multipath (const struct gen_multipath * gmp,
+		    char * line, int len, const char * format, int pad)
 {
 	char * c = line;   /* line cursor */
 	char * s = line;   /* for padding */
@@ -870,7 +871,7 @@ snprint_multipath (char * line, int len, const char * format,
 		if (!(data = mpd_lookup(*f)))
 			continue;
 
-		data->snprint(buff, MAX_FIELD_LEN, mpp);
+		gmp->ops->snprint(gmp, buff, MAX_FIELD_LEN, *f);
 		PRINT(c, TAIL, "%s", buff);
 		if (pad)
 			PAD(data->width);
@@ -913,8 +914,8 @@ snprint_path_header (char * line, int len, const char * format)
 }
 
 int
-snprint_path (char * line, int len, const char * format,
-	     const struct path * pp, int pad)
+_snprint_path (const struct gen_path * gp, char * line, int len,
+	       const char * format, int pad)
 {
 	char * c = line;   /* line cursor */
 	char * s = line;   /* for padding */
@@ -937,7 +938,7 @@ snprint_path (char * line, int len, const char * format,
 		if (!(data = pd_lookup(*f)))
 			continue;
 
-		data->snprint(buff, MAX_FIELD_LEN, pp);
+		gp->ops->snprint(gp, buff, MAX_FIELD_LEN, *f);
 		PRINT(c, TAIL, "%s", buff);
 		if (pad)
 			PAD(data->width);
@@ -948,8 +949,8 @@ snprint_path (char * line, int len, const char * format,
 }
 
 int
-snprint_pathgroup (char * line, int len, char * format,
-		   const struct pathgroup * pgp)
+_snprint_pathgroup (const struct gen_pathgroup * ggp, char * line, int len,
+		    char * format)
 {
 	char * c = line;   /* line cursor */
 	char * s = line;   /* for padding */
@@ -972,7 +973,7 @@ snprint_pathgroup (char * line, int len, char * format,
 		if (!(data = pgd_lookup(*f)))
 			continue;
 
-		data->snprint(buff, MAX_FIELD_LEN, pgp);
+		ggp->ops->snprint(ggp, buff, MAX_FIELD_LEN, *f);
 		PRINT(c, TAIL, "%s", buff);
 		PAD(data->width);
 	} while (*f++);
@@ -980,8 +981,10 @@ snprint_pathgroup (char * line, int len, char * format,
 	__endline(line, len, c);
 	return (c - line);
 }
+#define snprint_pathgroup(line, len, fmt, pgp) \
+	_snprint_pathgroup(dm_pathgroup_to_gen(pgp), line, len, fmt)
 
-void print_multipath_topology(struct multipath *mpp, int verbosity)
+void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
 {
 	int resize;
 	char *buff = NULL;
@@ -998,7 +1001,7 @@ void print_multipath_topology(struct multipath *mpp, int verbosity)
 			return;
 		}
 
-		len = snprint_multipath_topology(buff, maxlen, mpp, verbosity);
+		len = _snprint_multipath_topology(gmp, buff, maxlen, verbosity);
 		resize = (len == maxlen - 1);
 
 		if (resize) {
@@ -1011,12 +1014,30 @@ void print_multipath_topology(struct multipath *mpp, int verbosity)
 	FREE(buff);
 }
 
-int snprint_multipath_topology(char *buff, int len, const struct multipath *mpp,
-			       int verbosity)
+int
+snprint_multipath_style(const struct gen_multipath *gmp, char *style, int len,
+			int verbosity)
+{
+	int n;
+	const struct multipath *mpp = gen_multipath_to_dm(gmp);
+	bool need_action = (verbosity > 1 &&
+			    mpp->action != ACT_NOTHING &&
+			    mpp->action != ACT_UNDEF &&
+			    mpp->action != ACT_IMPOSSIBLE);
+	bool need_wwid = (strncmp(mpp->alias, mpp->wwid, WWID_SIZE));
+
+	n = snprintf(style, len, "%s%s%s%s",
+		     need_action ? "%A: " : "", "%n",
+		     need_wwid ? " (%w)" : "", " %d %s");
+	return MIN(n, len - 1);
+}
+
+int _snprint_multipath_topology(const struct gen_multipath *gmp,
+				char *buff, int len, int verbosity)
 {
 	int j, i, fwd = 0;
-	struct path * pp = NULL;
-	struct pathgroup * pgp = NULL;
+	const struct _vector *pgvec;
+	const struct gen_pathgroup *gpg;
 	char style[64];
 	char * c = style;
 	char fmt[64];
@@ -1028,60 +1049,71 @@ int snprint_multipath_topology(char *buff, int len, const struct multipath *mpp,
 	reset_multipath_layout();
 
 	if (verbosity == 1)
-		return snprint_multipath(buff, len, "%n", mpp, 1);
+		return _snprint_multipath(gmp, buff, len, "%n", 1);
 
 	if(isatty(1))
 		c += sprintf(c, "%c[%dm", 0x1B, 1); /* bold on */
 
-	if (verbosity > 1 &&
-	    mpp->action != ACT_NOTHING &&
-	    mpp->action != ACT_UNDEF && mpp->action != ACT_IMPOSSIBLE)
-			c += sprintf(c, "%%A: ");
-
-	c += sprintf(c, "%%n");
-
-	if (strncmp(mpp->alias, mpp->wwid, WWID_SIZE))
-		c += sprintf(c, " (%%w)");
-
-	c += sprintf(c, " %%d %%s");
+	c += gmp->ops->style(gmp, c, sizeof(style) - (c - style),
+			     verbosity);
+	c += snprintf(c, sizeof(style) - (c - style), " %%d %%s");
 	if(isatty(1))
 		c += sprintf(c, "%c[%dm", 0x1B, 0); /* bold off */
 
-	fwd += snprint_multipath(buff + fwd, len - fwd, style, mpp, 1);
+	fwd += _snprint_multipath(gmp, buff + fwd, len - fwd, style, 1);
 	if (fwd >= len)
 		return len;
-	fwd += snprint_multipath(buff + fwd, len - fwd, PRINT_MAP_PROPS, mpp,
-				 1);
+	fwd += _snprint_multipath(gmp, buff + fwd, len - fwd,
+				  PRINT_MAP_PROPS, 1);
 	if (fwd >= len)
 		return len;
 
-	if (!mpp->pg)
+	pgvec = gmp->ops->get_pathgroups(gmp);
+	if (pgvec == NULL)
 		return fwd;
 
-	vector_foreach_slot (mpp->pg, pgp, j) {
+	vector_foreach_slot (pgvec, gpg, j) {
+		const struct _vector *pathvec;
+		struct gen_path *gp;
+
 		f=fmt;
-		if (j + 1 < VECTOR_SIZE(mpp->pg)) {
+
+		if (j + 1 < VECTOR_SIZE(pgvec)) {
 			strcpy(f, "|-+- " PRINT_PG_INDENT);
 		} else
 			strcpy(f, "`-+- " PRINT_PG_INDENT);
-		fwd += snprint_pathgroup(buff + fwd, len - fwd, fmt, pgp);
-		if (fwd >= len)
-			return len;
+		fwd += _snprint_pathgroup(gpg, buff + fwd, len - fwd, fmt);
 
-		vector_foreach_slot (pgp->paths, pp, i) {
+		if (fwd >= len) {
+			fwd = len;
+			break;
+		}
+
+		pathvec = gpg->ops->get_paths(gpg);
+		if (pathvec == NULL)
+			continue;
+
+		vector_foreach_slot (pathvec, gp, i) {
 			f=fmt;
 			if (*f != '|')
 				*f=' ';
 			f++;
-			if (i + 1 < VECTOR_SIZE(pgp->paths))
+			if (i + 1 < VECTOR_SIZE(pathvec))
 				strcpy(f, " |- " PRINT_PATH_INDENT);
 			else
 				strcpy(f, " `- " PRINT_PATH_INDENT);
-			fwd += snprint_path(buff + fwd, len - fwd, fmt, pp, 1);
-			if (fwd >= len)
-				return len;
+			fwd += _snprint_path(gp, buff + fwd, len - fwd, fmt, 1);
+			if (fwd >= len) {
+				fwd = len;
+				break;
+			}
 		}
+		gpg->ops->rel_paths(gpg, pathvec);
+
+		if (fwd == len)
+			break;
 	}
+	gmp->ops->rel_pathgroups(gmp, pgvec);
 	return fwd;
 }
 
diff --git a/libmultipath/print.h b/libmultipath/print.h
index c624d2bfe8d4..e71f87722315 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -1,3 +1,6 @@
+#ifndef _PRINT_H
+#define _PRINT_H
+
 #define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
 #define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
 #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
@@ -94,11 +97,17 @@ void get_path_layout (vector pathvec, int header);
 void get_multipath_layout (vector mpvec, int header);
 int snprint_path_header (char *, int, const char *);
 int snprint_multipath_header (char *, int, const char *);
-int snprint_path (char *, int, const char *, const struct path *, int);
-int snprint_multipath (char *, int, const char *,
-		       const struct multipath *, int);
-int snprint_multipath_topology (char *, int, const struct multipath * mpp,
-				int verbosity);
+int _snprint_path (const struct gen_path *, char *, int, const char *, int);
+#define snprint_path(buf, len, fmt, pp, v) \
+	_snprint_path(dm_path_to_gen(pp), buf, len, fmt,  v)
+int _snprint_multipath (const struct gen_multipath *, char *, int,
+			const char *, int);
+#define snprint_multipath(buf, len, fmt, mp, v)				\
+	_snprint_multipath(dm_multipath_to_gen(mp), buf, len, fmt,  v)
+int _snprint_multipath_topology (const struct gen_multipath *, char *, int, 
+				 int verbosity);
+#define snprint_multipath_topology(buf, len, mpp, v) \
+	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, len, v)
 int snprint_multipath_topology_json (char * buff, int len,
 				const struct vectors * vecs);
 int snprint_multipath_map_json (char * buff, int len,
@@ -119,7 +128,11 @@ int snprint_host_wwpn (char *, size_t, const struct path *);
 int snprint_tgt_wwnn (char *, size_t, const struct path *);
 int snprint_tgt_wwpn (char *, size_t, const struct path *);
 
-void print_multipath_topology (struct multipath * mpp, int verbosity);
+void _print_multipath_topology (const struct gen_multipath * gmp,
+				int verbosity);
+#define print_multipath_topology(mpp, v) \
+	_print_multipath_topology(dm_multipath_to_gen(mpp), v)
+
 void print_all_paths (vector pathvec, int banner);
 void print_all_paths_custo (vector pathvec, int banner, char *fmt);
 
@@ -129,3 +142,6 @@ int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
 			   char *buf, int len, char wildcard);
 int snprint_multipath_attr(const struct gen_multipath* gm,
 			   char *buf, int len, char wildcard);
+int snprint_multipath_style(const struct gen_multipath *gmp,
+			    char *style, int len, int verbosity);
+#endif /* _PRINT_H */
diff --git a/multipath/main.c b/multipath/main.c
index 52bf1658bbca..a0c750e6f623 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -47,6 +47,7 @@
 #include "discovery.h"
 #include "debug.h"
 #include "switchgroup.h"
+#include "dm-generic.h"
 #include "print.h"
 #include "alias.h"
 #include "configure.h"
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 7f13bc9d6f32..78f2a12bc2f8 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -16,6 +16,7 @@
 #include "configure.h"
 #include "blacklist.h"
 #include "debug.h"
+#include "dm-generic.h"
 #include "print.h"
 #include "sysfs.h"
 #include <errno.h>
-- 
2.16.1
