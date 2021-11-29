Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9E0C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:12:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-FCQ_aQ_XNQai35toVclKmA-1; Mon, 29 Nov 2021 15:12:12 -0500
X-MC-Unique: FCQ_aQ_XNQai35toVclKmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7E1A1006AA1;
	Mon, 29 Nov 2021 20:12:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D153845D64;
	Mon, 29 Nov 2021 20:12:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A72211802E2A;
	Mon, 29 Nov 2021 20:12:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATK9kUo001969 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:09:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D9BBC492C3B; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4947492C38
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3C2080A0AB
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-330-hYBp0mieMLKdRdk_yOaghA-1; Mon, 29 Nov 2021 15:09:42 -0500
X-MC-Unique: hYBp0mieMLKdRdk_yOaghA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD35D21891;
	Mon, 29 Nov 2021 20:09:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 79CBA13BDA;
	Mon, 29 Nov 2021 20:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id sL5rG4QzpWFsHgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 20:09:40 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 21:08:59 +0100
Message-Id: <20211129200902.21817-11-mwilck@suse.com>
In-Reply-To: <20211129200902.21817-1-mwilck@suse.com>
References: <20211129200902.21817-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATK9kUo001969
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 10/13] libmultipath: introduce width argument
	for pretty-printing functions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Instead of modifying the global variables to store the field width for
pretty-printed table-formatted output, use field-width arrays passed
down from the caller. The calling function needs to allocate the array
using alloc_path_layout() or alloc_multipath_layout(), and initialize the
layout with the data to be printed. This is no different than before,
except that the field width is now stored in local variables of the caller.

The type used for column width, fieldwidth_t, is defined to unsigned char.
This limits the size of fields (padding in table columns) to 255 characters.
That's plenty even for lengthy WWID formats (as WWID_SIZE is 128). The typedef
could be changed in the future if necessary.

In some functions, namely _print_multipath_topology() and
print_foreign_topology(), field widths need to be initialized. This was true
before this patch already, but it wasn't done as the necessity wasn't
apparent. Essentially we were using pre-calculated field widths in these
functions, or just 0 if no field width calculation had been done previously.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign.c            |  55 +++++++++----
 libmultipath/foreign.h            |  23 +++---
 libmultipath/generic.h            |   8 ++
 libmultipath/libmultipath.version |   5 +-
 libmultipath/print.c              | 127 +++++++++++++++++++-----------
 libmultipath/print.h              |  37 +++++----
 multipath/main.c                  |   7 +-
 multipathd/cli_handlers.c         |  70 ++++++++++------
 8 files changed, 218 insertions(+), 114 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index c69c5c3..e80eb3e 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -30,10 +30,10 @@
 #include "vector.h"
 #include "debug.h"
 #include "util.h"
-#include "foreign.h"
 #include "structs.h"
 #include "structs_vec.h"
 #include "print.h"
+#include "foreign.h"
 #include "strbuf.h"
 
 static vector foreigns;
@@ -437,7 +437,7 @@ void check_foreign(void)
 }
 
 /* Call this after get_path_layout */
-void foreign_path_layout(void)
+void foreign_path_layout(fieldwidth_t *width)
 {
 	struct foreign *fgn;
 	int i;
@@ -457,7 +457,7 @@ void foreign_path_layout(void)
 
 		vec = fgn->get_paths(fgn->context);
 		if (vec != NULL) {
-			_get_path_layout(vec, LAYOUT_RESET_NOT);
+			_get_path_layout(vec, LAYOUT_RESET_NOT, width);
 		}
 		fgn->release_paths(fgn->context, vec);
 
@@ -468,7 +468,7 @@ void foreign_path_layout(void)
 }
 
 /* Call this after get_multipath_layout */
-void foreign_multipath_layout(void)
+void foreign_multipath_layout(fieldwidth_t *width)
 {
 	struct foreign *fgn;
 	int i;
@@ -488,7 +488,7 @@ void foreign_multipath_layout(void)
 
 		vec = fgn->get_multipaths(fgn->context);
 		if (vec != NULL) {
-			_get_multipath_layout(vec, LAYOUT_RESET_NOT);
+			_get_multipath_layout(vec, LAYOUT_RESET_NOT, width);
 		}
 		fgn->release_multipaths(fgn->context, vec);
 
@@ -498,7 +498,8 @@ void foreign_multipath_layout(void)
 	pthread_cleanup_pop(1);
 }
 
-static int __snprint_foreign_topology(struct strbuf *buf, int verbosity)
+static int __snprint_foreign_topology(struct strbuf *buf, int verbosity,
+				      const fieldwidth_t *width)
 {
 	struct foreign *fgn;
 	int i;
@@ -516,7 +517,7 @@ static int __snprint_foreign_topology(struct strbuf *buf, int verbosity)
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gm, j) {
 				if (_snprint_multipath_topology(
-					    gm, buf, verbosity) < 0)
+					    gm, buf, verbosity, width) < 0)
 					break;
 			}
 		}
@@ -527,7 +528,8 @@ static int __snprint_foreign_topology(struct strbuf *buf, int verbosity)
 	return get_strbuf_len(buf) - initial_len;
 }
 
-int snprint_foreign_topology(struct strbuf *buf, int verbosity)
+int snprint_foreign_topology(struct strbuf *buf, int verbosity,
+			     const fieldwidth_t *width)
 {
 	int rc;
 
@@ -537,7 +539,7 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity)
 		return 0;
 	}
 	pthread_cleanup_push(unlock_foreigns, NULL);
-	rc = __snprint_foreign_topology(buf, verbosity);
+	rc = __snprint_foreign_topology(buf, verbosity, width);
 	pthread_cleanup_pop(1);
 	return rc;
 }
@@ -545,12 +547,35 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity)
 void print_foreign_topology(int verbosity)
 {
 	STRBUF_ON_STACK(buf);
+	struct foreign *fgn;
+	int i;
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
-	snprint_foreign_topology(&buf, verbosity);
+	if ((width = alloc_path_layout()) == NULL)
+		return;
+	rdlock_foreigns();
+	if (foreigns == NULL) {
+		unlock_foreigns(NULL);
+		return;
+	}
+	pthread_cleanup_push(unlock_foreigns, NULL);
+	vector_foreach_slot(foreigns, fgn, i) {
+		const struct _vector *vec;
+
+		fgn->lock(fgn->context);
+		pthread_cleanup_push(fgn->unlock, fgn->context);
+		vec = fgn->get_paths(fgn->context);
+		_get_multipath_layout(vec, LAYOUT_RESET_NOT, width);
+		fgn->release_paths(fgn->context, vec);
+		pthread_cleanup_pop(1);
+	}
+	__snprint_foreign_topology(&buf, verbosity, width);
+	pthread_cleanup_pop(1);
 	printf("%s", get_strbuf_str(&buf));
 }
 
-int snprint_foreign_paths(struct strbuf *buf, const char *style, int pretty)
+int snprint_foreign_paths(struct strbuf *buf, const char *style,
+			  const fieldwidth_t *width)
 {
 	struct foreign *fgn;
 	int i;
@@ -574,7 +599,7 @@ int snprint_foreign_paths(struct strbuf *buf, const char *style, int pretty)
 		vec = fgn->get_paths(fgn->context);
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gp, j) {
-				ret = _snprint_path(gp, buf, style, pretty);
+				ret = _snprint_path(gp, buf, style, width);
 				if (ret < 0)
 					break;
 			}
@@ -589,8 +614,8 @@ int snprint_foreign_paths(struct strbuf *buf, const char *style, int pretty)
 	return get_strbuf_len(buf) - initial_len;
 }
 
-int snprint_foreign_multipaths(struct strbuf *buf,
-			       const char *style, int pretty)
+int snprint_foreign_multipaths(struct strbuf *buf, const char *style,
+			       const fieldwidth_t *width)
 {
 	struct foreign *fgn;
 	int i;
@@ -615,7 +640,7 @@ int snprint_foreign_multipaths(struct strbuf *buf,
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gm, j) {
 				ret = _snprint_multipath(gm, buf,
-							 style, pretty);
+							 style, width);
 				if (ret < 0)
 					break;
 			}
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 77fc485..cf8f570 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -18,7 +18,7 @@
 #define _FOREIGN_H
 #include <stdbool.h>
 #include <libudev.h>
-#define LIBMP_FOREIGN_API ((1 << 8) | 1)
+#define LIBMP_FOREIGN_API ((1 << 8) | 2)
 
 struct strbuf;
 struct context;
@@ -252,15 +252,17 @@ void check_foreign(void);
  * foreign_path_layout()
  * call this before printing paths, after get_path_layout(), to determine
  * output field width.
+ * @param width: an array allocated by alloc_path_layout()
  */
-void foreign_path_layout(void);
+void foreign_path_layout(fieldwidth_t *width);
 
 /**
  * foreign_multipath_layout()
  * call this before printing maps, after get_multipath_layout(), to determine
  * output field width.
+ * @param width: an array allocated by alloc_multipath_layout()
  */
-void foreign_multipath_layout(void);
+void foreign_multipath_layout(fieldwidth_t *width);
 
 /**
  * snprint_foreign_topology(buf, len, verbosity);
@@ -268,9 +270,11 @@ void foreign_multipath_layout(void);
  * '\0' - terminated.
  * @param buf: output buffer
  * @param verbosity: verbosity level
+ * @param width: an array of field widths, initialized by _get_path_layout()
  * @returns: number of printed characters excluding trailing '\0'.
  */
-int snprint_foreign_topology(struct strbuf *buf, int verbosity);
+int snprint_foreign_topology(struct strbuf *buf, int verbosity,
+			     const fieldwidth_t *width);
 
 /**
  * snprint_foreign_paths(buf, len, style, pad);
@@ -278,10 +282,11 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity);
  * '\0' - terminated.
  * @param buf: output buffer
  * @param style: format string
- * @param pad: whether to pad field width
+ * @param width: array initialized with get_path_layout(), or NULL for no padding
  * @returns: number of printed characters excluding trailing '\0'.
  */
-int snprint_foreign_paths(struct strbuf *buf, const char *style, int pad);
+int snprint_foreign_paths(struct strbuf *buf, const char *style,
+			  const fieldwidth_t *width);
 
 /**
  * snprint_foreign_multipaths(buf, len, style, pad);
@@ -289,11 +294,11 @@ int snprint_foreign_paths(struct strbuf *buf, const char *style, int pad);
  * '\0' - terminated.
  * @param buf: output buffer
  * @param style: format string
- * @param pad: whether to pad field width
+ * @param width: array initialized with get_path_layout(), or NULL for no padding
  * @returns: number of printed characters excluding trailing '\0'.
  */
-int snprint_foreign_multipaths(struct strbuf *buf,
-			       const char *style, int pretty);
+int snprint_foreign_multipaths(struct strbuf *buf, const char *style,
+			       const fieldwidth_t *width);
 
 /**
  * print_foreign_topology(v)
diff --git a/libmultipath/generic.h b/libmultipath/generic.h
index 57c123c..e89848f 100644
--- a/libmultipath/generic.h
+++ b/libmultipath/generic.h
@@ -18,6 +18,14 @@
 #define _GENERIC_H
 #include "vector.h"
 
+/*
+ * fieldwidth_t is required in print.h and foreign.h.
+ * Defining it twice is not allowed before C11.
+ * So do it here.
+ */
+typedef unsigned char fieldwidth_t;
+#define MAX_FIELD_WIDTH UCHAR_MAX
+
 struct strbuf;
 struct gen_multipath;
 struct gen_pathgroup;
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 4c22995..0c5417d 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,14 +31,16 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_12.0.0 {
+LIBMULTIPATH_13.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
 	add_map_with_path;
 	adopt_paths;
 	alloc_multipath;
+	alloc_multipath_layout;
 	alloc_path;
+	alloc_path_layout;
 	alloc_path_with_pathinfo;
 	alloc_strvec;
 	change_foreign;
@@ -270,6 +272,7 @@ global:
 
 	/* added in 7.0.0 */
 	cleanup_charp;
+	cleanup_ucharp;
 
 	/* added in 8.1.0 */
 	reset_strbuf;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b5aeca8..033d663 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -884,18 +884,22 @@ int snprint_wildcards(struct strbuf *buff)
 	return get_strbuf_len(buff) - initial_len;
 }
 
-void
-get_path_layout(vector pathvec, int header)
+fieldwidth_t *alloc_path_layout(void) {
+	return calloc(ARRAY_SIZE(pd), sizeof(fieldwidth_t));
+}
+
+void get_path_layout(vector pathvec, int header, fieldwidth_t *width)
 {
 	vector gpvec = vector_convert(NULL, pathvec, struct path,
 				      dm_path_to_gen);
 	_get_path_layout(gpvec,
-			 header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO);
+			 header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO,
+			 width);
 	vector_free(gpvec);
 }
 
 static void
-reset_width(unsigned int *width, enum layout_reset reset, const char *header)
+reset_width(fieldwidth_t *width, enum layout_reset reset, const char *header)
 {
 	switch (reset) {
 	case LAYOUT_RESET_HEADER:
@@ -910,67 +914,70 @@ reset_width(unsigned int *width, enum layout_reset reset, const char *header)
 	}
 }
 
-void
-_get_path_layout (const struct _vector *gpvec, enum layout_reset reset)
+void _get_path_layout (const struct _vector *gpvec, enum layout_reset reset,
+		       fieldwidth_t *width)
 {
 	unsigned int i, j;
 	const struct gen_path *gp;
 
+	if (width == NULL)
+		return;
+
 	for (j = 0; j < ARRAY_SIZE(pd); j++) {
 		STRBUF_ON_STACK(buff);
 
-		reset_width(&pd[j].width, reset, pd[j].header);
+		reset_width(&width[j], reset, pd[j].header);
 
 		if (gpvec == NULL)
 			continue;
 
 		vector_foreach_slot (gpvec, gp, i) {
 			gp->ops->snprint(gp, &buff, pd[j].wildcard);
-			pd[j].width = MAX(pd[j].width, get_strbuf_len(&buff));
+			width[j] = MAX(width[j],
+				       MIN(get_strbuf_len(&buff), MAX_FIELD_WIDTH));
 			truncate_strbuf(&buff, 0);
 		}
 	}
 }
 
-static void
-reset_multipath_layout (void)
-{
-	unsigned int i;
+fieldwidth_t *alloc_multipath_layout(void) {
 
-	for (i = 0; i < ARRAY_SIZE(mpd); i++)
-		mpd[i].width = 0;
+	return calloc(ARRAY_SIZE(mpd), sizeof(fieldwidth_t));
 }
 
-void
-get_multipath_layout (vector mpvec, int header) {
+void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width) {
 	vector gmvec = vector_convert(NULL, mpvec, struct multipath,
 				      dm_multipath_to_gen);
 	_get_multipath_layout(gmvec,
-			 header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO);
+			      header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO,
+			      width);
 	vector_free(gmvec);
 }
 
 void
-_get_multipath_layout (const struct _vector *gmvec,
-			    enum layout_reset reset)
+_get_multipath_layout (const struct _vector *gmvec, enum layout_reset reset,
+		       fieldwidth_t *width)
 {
 	unsigned int i, j;
 	const struct gen_multipath * gm;
 
+	if (width == NULL)
+		return;
 	for (j = 0; j < ARRAY_SIZE(mpd); j++) {
 		STRBUF_ON_STACK(buff);
 
-		reset_width(&mpd[j].width, reset, mpd[j].header);
+		reset_width(&width[j], reset, mpd[j].header);
 
 		if (gmvec == NULL)
 			continue;
 
 		vector_foreach_slot (gmvec, gm, i) {
 			gm->ops->snprint(gm, &buff, mpd[j].wildcard);
-			mpd[j].width = MAX(mpd[j].width, get_strbuf_len(&buff));
+			width[j] = MAX(width[j],
+				       MIN(get_strbuf_len(&buff), MAX_FIELD_WIDTH));
 			truncate_strbuf(&buff, 0);
 		}
-		condlog(4, "%s: width %d", mpd[j].header, mpd[j].width);
+		condlog(4, "%s: width %d", mpd[j].header, width[j]);
 	}
 }
 
@@ -1040,7 +1047,8 @@ int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
 	return pgd[i].snprint(buf, pg);
 }
 
-int snprint_multipath_header(struct strbuf *line, const char *format)
+int snprint_multipath_header(struct strbuf *line, const char *format,
+			     const fieldwidth_t *width)
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
@@ -1060,8 +1068,8 @@ int snprint_multipath_header(struct strbuf *line, const char *format)
 
 		if ((rc = append_strbuf_str(line, data->header)) < 0)
 			return rc;
-		else if ((unsigned int)rc < data->width)
-			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
+		else if ((unsigned int)rc < width[iwc])
+			if ((rc = fill_strbuf(line, ' ', width[iwc] - rc)) < 0)
 				return rc;
 	}
 
@@ -1071,11 +1079,11 @@ int snprint_multipath_header(struct strbuf *line, const char *format)
 }
 
 int _snprint_multipath(const struct gen_multipath *gmp,
-		       struct strbuf *line, const char *format, int pad)
+		       struct strbuf *line, const char *format,
+		       const fieldwidth_t *width)
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
-	struct multipath_data * data;
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
@@ -1087,12 +1095,11 @@ int _snprint_multipath(const struct gen_multipath *gmp,
 		format = f + 1;
 		if ((iwc = mpd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
-		data = &mpd[iwc];
 
 		if ((rc = gmp->ops->snprint(gmp, line, *format)) < 0)
 			return rc;
-		else if (pad && (unsigned int)rc < data->width)
-			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
+		else if (width != NULL && (unsigned int)rc < width[iwc])
+			if ((rc = fill_strbuf(line, ' ', width[iwc] - rc)) < 0)
 				return rc;
 	}
 
@@ -1101,7 +1108,8 @@ int _snprint_multipath(const struct gen_multipath *gmp,
 	return get_strbuf_len(line) - initial_len;
 }
 
-int snprint_path_header(struct strbuf *line, const char *format)
+int snprint_path_header(struct strbuf *line, const char *format,
+			const fieldwidth_t *width)
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
@@ -1121,8 +1129,8 @@ int snprint_path_header(struct strbuf *line, const char *format)
 
 		if ((rc = append_strbuf_str(line, data->header)) < 0)
 			return rc;
-		else if ((unsigned int)rc < data->width)
-			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
+		else if ((unsigned int)rc < width[iwc])
+			if ((rc = fill_strbuf(line, ' ', width[iwc] - rc)) < 0)
 				return rc;
 	}
 
@@ -1132,11 +1140,10 @@ int snprint_path_header(struct strbuf *line, const char *format)
 }
 
 int _snprint_path(const struct gen_path *gp, struct strbuf *line,
-		  const char *format, int pad)
+		  const char *format, const fieldwidth_t *width)
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
-	struct path_data * data;
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
@@ -1148,12 +1155,11 @@ int _snprint_path(const struct gen_path *gp, struct strbuf *line,
 		format = f + 1;
 		if ((iwc = pd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
-		data = &pd[iwc];
 
 		if ((rc = gp->ops->snprint(gp, line, *format)) < 0)
 			return rc;
-		else if (pad && (unsigned int)rc < data->width)
-			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
+		else if (width != NULL && (unsigned int)rc < width[iwc])
+			if ((rc = fill_strbuf(line, ' ', width[iwc] - rc)) < 0)
 				return rc;
 	}
 
@@ -1190,8 +1196,26 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
 {
 	STRBUF_ON_STACK(buff);
+	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+	const struct gen_pathgroup *gpg;
+	const struct _vector *pgvec, *pathvec;
+	int j;
 
-	_snprint_multipath_topology(gmp, &buff, verbosity);
+	p_width = alloc_path_layout();
+	pgvec = gmp->ops->get_pathgroups(gmp);
+
+	if (pgvec != NULL) {
+		vector_foreach_slot (pgvec, gpg, j) {
+			pathvec = gpg->ops->get_paths(gpg);
+			if (pathvec == NULL)
+				continue;
+			_get_path_layout(pathvec, LAYOUT_RESET_NOT, p_width);
+			gpg->ops->rel_paths(gpg, pathvec);
+		}
+		gmp->ops->rel_pathgroups(gmp, pgvec);
+	}
+
+	_snprint_multipath_topology(gmp, &buff, verbosity, p_width);
 	printf("%s", get_strbuf_str(&buff));
 }
 
@@ -1211,21 +1235,24 @@ int snprint_multipath_style(const struct gen_multipath *gmp,
 }
 
 int _snprint_multipath_topology(const struct gen_multipath *gmp,
-				struct strbuf *buff, int verbosity)
+				struct strbuf *buff, int verbosity,
+				const fieldwidth_t *p_width)
 {
 	int j, i, rc;
 	const struct _vector *pgvec;
 	const struct gen_pathgroup *gpg;
 	STRBUF_ON_STACK(style);
 	size_t initial_len = get_strbuf_len(buff);
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
 	if (verbosity <= 0)
 		return 0;
 
-	reset_multipath_layout();
+	if ((width = alloc_multipath_layout()) == NULL)
+		return -ENOMEM;
 
 	if (verbosity == 1)
-		return _snprint_multipath(gmp, buff, "%n", 1);
+		return _snprint_multipath(gmp, buff, "%n", width);
 
 	if(isatty(1) &&
 	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 1)) < 0) /* bold on */
@@ -1236,8 +1263,8 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 0)) < 0) /* bold off */
 		return rc;
 
-	if ((rc = _snprint_multipath(gmp, buff, get_strbuf_str(&style), 1)) < 0
-	    || (rc = _snprint_multipath(gmp, buff, PRINT_MAP_PROPS, 1)) < 0)
+	if ((rc = _snprint_multipath(gmp, buff, get_strbuf_str(&style), width)) < 0
+	    || (rc = _snprint_multipath(gmp, buff, PRINT_MAP_PROPS, width)) < 0)
 		return rc;
 
 	pgvec = gmp->ops->get_pathgroups(gmp);
@@ -1264,7 +1291,7 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 					       i + 1 == VECTOR_SIZE(pathvec) ?
 					       '`': '|')) < 0 ||
 			    (rc = _snprint_path(gp, buff,
-						PRINT_PATH_INDENT, 1)) < 0)
+						PRINT_PATH_INDENT, p_width)) < 0)
 				return rc;
 		}
 		gpg->ops->rel_paths(gpg, pathvec);
@@ -1949,6 +1976,7 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 	int i;
 	struct path * pp;
 	STRBUF_ON_STACK(line);
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
 	if (!VECTOR_SIZE(pathvec)) {
 		if (banner)
@@ -1956,14 +1984,17 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 		return;
 	}
 
+	if ((width = alloc_path_layout()) == NULL)
+		return;
+	get_path_layout(pathvec, 1, width);
+
 	if (banner)
 		append_strbuf_str(&line, "===== paths list =====\n");
 
-	get_path_layout(pathvec, 1);
-	snprint_path_header(&line, fmt);
+	snprint_path_header(&line, fmt, width);
 
 	vector_foreach_slot (pathvec, pp, i)
-		snprint_path(&line, fmt, pp, 1);
+		snprint_path(&line, fmt, pp, width);
 
 	printf("%s", get_strbuf_str(&line));
 }
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 4322f6e..52f5b25 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -15,23 +15,30 @@ enum layout_reset {
 	LAYOUT_RESET_HEADER,
 };
 
-void _get_path_layout (const struct _vector *gpvec, enum layout_reset);
-void get_path_layout (vector pathvec, int header);
-void _get_multipath_layout (const struct _vector *gmvec, enum layout_reset);
-void get_multipath_layout (vector mpvec, int header);
-int snprint_path_header(struct strbuf *, const char *);
-int snprint_multipath_header(struct strbuf *, const char *);
-int _snprint_path (const struct gen_path *, struct strbuf *, const char *, int);
-#define snprint_path(buf, fmt, pp, v) \
-	_snprint_path(dm_path_to_gen(pp), buf, fmt,  v)
+/* fieldwidth_t is defined in generic.h */
+fieldwidth_t *alloc_path_layout(void);
+void _get_path_layout (const struct _vector *gpvec, enum layout_reset,
+		       fieldwidth_t *width);
+void get_path_layout (vector pathvec, int header, fieldwidth_t *width);
+fieldwidth_t *alloc_multipath_layout(void);
+void _get_multipath_layout (const struct _vector *gmvec, enum layout_reset,
+			    fieldwidth_t *width);
+void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width);
+int snprint_path_header(struct strbuf *, const char *, const fieldwidth_t *);
+int snprint_multipath_header(struct strbuf *, const char *,
+			     const fieldwidth_t *);
+int _snprint_path (const struct gen_path *, struct strbuf *, const char *,
+		   const fieldwidth_t *);
+#define snprint_path(buf, fmt, pp, w)		\
+	_snprint_path(dm_path_to_gen(pp), buf, fmt, w)
 int _snprint_multipath (const struct gen_multipath *, struct strbuf *,
-			const char *, int);
-#define snprint_multipath(buf, fmt, mp, v)				\
-	_snprint_multipath(dm_multipath_to_gen(mp), buf, fmt,  v)
+			const char *, const fieldwidth_t *);
+#define snprint_multipath(buf, fmt, mp, w)				\
+	_snprint_multipath(dm_multipath_to_gen(mp), buf, fmt, w)
 int _snprint_multipath_topology (const struct gen_multipath *, struct strbuf *,
-				 int verbosity);
-#define snprint_multipath_topology(buf, mpp, v) \
-	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v)
+				 int verbosity, const fieldwidth_t *);
+#define snprint_multipath_topology(buf, mpp, v, w)			\
+	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v, w)
 int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
 int __snprint_config(const struct config *conf, struct strbuf *buff,
 		     const struct _vector *hwtable, const struct _vector *mpvec);
diff --git a/multipath/main.c b/multipath/main.c
index 5711acf..0a9377e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -460,6 +460,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
 	/*
 	 * allocate core vectors to store paths and multipaths
@@ -546,8 +547,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	if (libmp_verbosity > 2)
 		print_all_paths(pathvec, 1);
 
-	get_path_layout(pathvec, 0);
-	foreign_path_layout();
+	if ((width = alloc_path_layout()) == NULL)
+		goto out;
+	get_path_layout(pathvec, 0, width);
+	foreign_path_layout(width);
 
 	if (get_dm_mpvec(cmd, curmp, pathvec, refwwid))
 		goto out;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 1b7f258..d79cdd7 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -38,18 +38,22 @@ show_paths (struct strbuf *reply, struct vectors *vecs, char *style, int pretty)
 	int i;
 	struct path * pp;
 	int hdr_len = 0;
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
-	get_path_layout(vecs->pathvec, 1);
-	foreign_path_layout();
-
-	if (pretty && (hdr_len = snprint_path_header(reply, style)) < 0)
+	if (pretty) {
+		if ((width = alloc_path_layout()) == NULL)
+			return 1;
+		get_path_layout(vecs->pathvec, 1, width);
+		foreign_path_layout(width);
+	}
+	if (pretty && (hdr_len = snprint_path_header(reply, style, width)) < 0)
 		return 1;
 
 	vector_foreach_slot(vecs->pathvec, pp, i) {
-		if (snprint_path(reply, style, pp, pretty) < 0)
+		if (snprint_path(reply, style, pp, width) < 0)
 			return 1;
 	}
-	if (snprint_foreign_paths(reply, style, pretty) < 0)
+	if (snprint_foreign_paths(reply, style, width) < 0)
 		return 1;
 
 	if (pretty && get_strbuf_len(reply) == (size_t)hdr_len)
@@ -63,7 +67,11 @@ static int
 show_path (struct strbuf *reply, struct vectors *vecs, struct path *pp,
 	   char *style)
 {
-	get_path_layout(vecs->pathvec, 1);
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
+
+	if ((width = alloc_path_layout()) == NULL)
+		return 1;
+	get_path_layout(vecs->pathvec, 1, width);
 	if (snprint_path(reply, style, pp, 0) < 0)
 		return 1;
 	return 0;
@@ -71,12 +79,12 @@ show_path (struct strbuf *reply, struct vectors *vecs, struct path *pp,
 
 static int
 show_map_topology (struct strbuf *reply, struct multipath *mpp,
-		   struct vectors *vecs)
+		   struct vectors *vecs, const fieldwidth_t *width)
 {
 	if (update_multipath(vecs, mpp->alias, 0))
 		return 1;
 
-	if (snprint_multipath_topology(reply, mpp, 2) < 0)
+	if (snprint_multipath_topology(reply, mpp, 2, width) < 0)
 		return 1;
 
 	return 0;
@@ -87,19 +95,22 @@ show_maps_topology (struct strbuf *reply, struct vectors * vecs)
 {
 	int i;
 	struct multipath * mpp;
+	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
-	get_path_layout(vecs->pathvec, 0);
-	foreign_path_layout();
+	if ((p_width = alloc_path_layout()) == NULL)
+		return 1;
+	get_path_layout(vecs->pathvec, 0, p_width);
+	foreign_path_layout(p_width);
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if (update_multipath(vecs, mpp->alias, 0)) {
 			i--;
 			continue;
 		}
-		if (snprint_multipath_topology(reply, mpp, 2) < 0)
+		if (snprint_multipath_topology(reply, mpp, 2, p_width) < 0)
 			return 1;
 	}
-	if (snprint_foreign_topology(reply, 2) < 0)
+	if (snprint_foreign_topology(reply, 2, p_width) < 0)
 		return 1;
 
 	return 0;
@@ -247,9 +258,12 @@ cli_list_map_topology (void *v, struct strbuf *reply, void *data)
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
+	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
+	if ((p_width = alloc_path_layout()) == NULL)
+		return 1;
+	get_path_layout(vecs->pathvec, 0, p_width);
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
@@ -257,7 +271,7 @@ cli_list_map_topology (void *v, struct strbuf *reply, void *data)
 
 	condlog(3, "list multipath %s (operator)", param);
 
-	return show_map_topology(reply, mpp, vecs);
+	return show_map_topology(reply, mpp, vecs, p_width);
 }
 
 static int
@@ -328,9 +342,9 @@ show_daemon (struct strbuf *reply)
 
 static int
 show_map (struct strbuf *reply, struct multipath *mpp, char *style,
-	  int pretty)
+	  const fieldwidth_t *width)
 {
-	if (snprint_multipath(reply, style, mpp, pretty) < 0)
+	if (snprint_multipath(reply, style, mpp, width) < 0)
 		return 1;
 
 	return 0;
@@ -343,11 +357,16 @@ show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 	int i;
 	struct multipath * mpp;
 	int hdr_len = 0;
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
-	get_multipath_layout(vecs->mpvec, 1);
-	foreign_multipath_layout();
+	if (pretty) {
+		if ((width = alloc_multipath_layout()) == NULL)
+			return 1;
+		get_multipath_layout(vecs->mpvec, 1, width);
+		foreign_multipath_layout(width);
+	}
 
-	if (pretty && (hdr_len = snprint_multipath_header(reply, style)) < 0)
+	if (pretty && (hdr_len = snprint_multipath_header(reply, style, width)) < 0)
 		return 1;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
@@ -355,10 +374,10 @@ show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 			i--;
 			continue;
 		}
-		if (snprint_multipath(reply, style, mpp, pretty) < 0)
+		if (snprint_multipath(reply, style, mpp, width) < 0)
 			return 1;
 	}
-	if (snprint_foreign_multipaths(reply, style, pretty) < 0)
+	if (snprint_foreign_multipaths(reply, style, width) < 0)
 		return 1;
 
 	if (pretty && get_strbuf_len(reply) == (size_t)hdr_len)
@@ -397,16 +416,19 @@ cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 	char * fmt = get_keyparam(v, FMT);
+	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
+	if ((width = alloc_multipath_layout()) == NULL)
+		return 1;
+	get_multipath_layout(vecs->pathvec, 1, width);
 	param = convert_dev(param, 0);
-	get_multipath_layout(vecs->mpvec, 1);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 	if (!mpp)
 		return 1;
 
 	condlog(3, "list map %s fmt %s (operator)", param, fmt);
 
-	return show_map(reply, mpp, fmt, 1);
+	return show_map(reply, mpp, fmt, width);
 }
 
 static int
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

