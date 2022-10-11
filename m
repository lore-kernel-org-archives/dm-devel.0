Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3795C43219
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 21:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665525194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iZ7gmUrsg2OC6tLtlQIsddhuYcp1VspOecPzic+Q4HI=;
	b=fyw8HkpJanlyIsSi74hyPnqryocIdQKJqqJfO8Sx3jsevLE17kCHHlp/jkTDOI7kwXcUtX
	/jxU5/T+GpHc47BwuzihbI9KiRsfZOAStJVZ4kJzzW/RJoQ7Lz46SIqFHct519ggGsavlP
	/TVq5mfeyVC2QjaagAodr7H9xi+tsOc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-ubJTjwAbNrCqeIgTD0ddhg-1; Tue, 11 Oct 2022 17:53:11 -0400
X-MC-Unique: ubJTjwAbNrCqeIgTD0ddhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D325857D0B;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87C4B4EA47;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 519A3194658F;
	Tue, 11 Oct 2022 21:53:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 34E991946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Oct 2022 21:53:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 053761402BDC; Tue, 11 Oct 2022 21:53:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BFB08140EBF5;
 Tue, 11 Oct 2022 21:53:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29BLr6DS027423;
 Tue, 11 Oct 2022 16:53:06 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29BLr51d027422;
 Tue, 11 Oct 2022 16:53:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 11 Oct 2022 16:53:01 -0500
Message-Id: <1665525183-27377-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 2/4] libmultipath: avoid STRBUF_ON_STACK with
 cancellation points
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

STRBUF_ON_STACK() uses the cleanup __attribute__, which doesn't get run
if a thread is cancelled. condlog() will call fprintf() when run under
systemd, which is a cancellation point. The snprint function for the
generic mutipath and generic path operations both call cancellation
points. Also, the keyword print functions can call cancellation points.
Because of all this, I did not see any safe uses of STRBUF_ON_STACK()
outside of the unit tests. Replace them all with pthread cleanup
handlers.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/parser.c                    |  5 +-
 libmpathutil/strbuf.h                    |  4 +-
 libmultipath/alias.c                     | 59 +++++++++++-------
 libmultipath/blacklist.c                 |  4 +-
 libmultipath/discovery.c                 | 34 +++++++----
 libmultipath/dmparser.c                  | 21 +++----
 libmultipath/foreign.c                   |  4 +-
 libmultipath/generic.c                   | 10 +++-
 libmultipath/print.c                     | 50 ++++++++++------
 libmultipath/prioritizers/weightedpath.c | 16 ++---
 libmultipath/propsel.c                   | 76 ++++++++++++++++++------
 libmultipath/sysfs.h                     | 11 +---
 libmultipath/uevent.c                    |  6 +-
 13 files changed, 195 insertions(+), 105 deletions(-)

diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 8d3ac53a..04c65b51 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -25,6 +25,7 @@
 #include "parser.h"
 #include "debug.h"
 #include "strbuf.h"
+#include "util.h"
 
 /* local vars */
 static int sublevel = 0;
@@ -155,11 +156,12 @@ snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 	int r = 0;
 	char *f;
 	struct config *conf;
-	STRBUF_ON_STACK(sbuf);
+	struct strbuf sbuf = STRBUF_INIT;
 
 	if (!kw || !kw->print)
 		return 0;
 
+	pthread_cleanup_push_cast(reset_strbuf, &sbuf);
 	do {
 		f = strchr(fmt, '%');
 		if (f == NULL) {
@@ -193,6 +195,7 @@ out:
 	if (r >= 0)
 		r = __append_strbuf_str(buff, get_strbuf_str(&sbuf),
 					get_strbuf_len(&sbuf));
+	pthread_cleanup_pop(1);
 	return r;
 }
 
diff --git a/libmpathutil/strbuf.h b/libmpathutil/strbuf.h
index ae863417..5aa54677 100644
--- a/libmpathutil/strbuf.h
+++ b/libmpathutil/strbuf.h
@@ -42,7 +42,9 @@ void free_strbuf(struct strbuf *buf);
  * macro: STRBUF_ON_STACK
  *
  * Define and initialize a local struct @strbuf to be cleaned up when
- * the current scope is left
+ * the current scope is left. This can only be used in non-threaded
+ * programs, or if there are no pthread cancellation points in the
+ * current scope, after the buffer could first be used.
  */
 #define STRBUF_ON_STACK(__x)						\
 	struct strbuf __attribute__((cleanup(reset_strbuf))) (__x) = STRBUF_INIT;
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 05201224..3a81a7ad 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -112,12 +112,14 @@ scan_devname(const char *alias, const char *prefix)
 static int
 id_already_taken(int id, const char *prefix, const char *map_wwid)
 {
-	STRBUF_ON_STACK(buf);
+	struct strbuf buf = STRBUF_INIT;
 	const char *alias;
+	int r = 0;
 
+	pthread_cleanup_push_cast(reset_strbuf, &buf);
 	if (append_strbuf_str(&buf, prefix) < 0 ||
 	    format_devname(&buf, id) < 0)
-		return 0;
+		goto out;
 
 	alias = get_strbuf_str(&buf);
 	if (dm_map_present(alias)) {
@@ -126,11 +128,13 @@ id_already_taken(int id, const char *prefix, const char *map_wwid)
 		/* If both the name and the wwid match, then it's fine.*/
 		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
 		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
-			return 0;
+			goto out;
 		condlog(3, "%s: alias '%s' already taken, but not in bindings file. reselecting alias", map_wwid, alias);
-		return 1;
+		r = 1;
 	}
-	return 0;
+out:
+	pthread_cleanup_pop(1);
+	return r;
 }
 
 
@@ -277,10 +281,12 @@ rlookup_binding(FILE *f, char *buff, const char *map_alias)
 static char *
 allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 {
-	STRBUF_ON_STACK(buf);
+	struct strbuf buf = STRBUF_INIT;
 	off_t offset;
 	ssize_t len;
-	char *alias, *c;
+	char *alias = NULL;
+	const char *str;
+	int end;
 
 	if (id <= 0) {
 		condlog(0, "%s: cannot allocate new binding for id %d",
@@ -288,38 +294,41 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 		return NULL;
 	}
 
+	pthread_cleanup_push_cast(reset_strbuf, &buf);
 	if (append_strbuf_str(&buf, prefix) < 0 ||
 	    format_devname(&buf, id) == -1)
-		return NULL;
+		goto out;
 
 	if (print_strbuf(&buf, " %s\n", wwid) < 0)
-		return NULL;
+		goto out;
 
 	offset = lseek(fd, 0, SEEK_END);
 	if (offset < 0){
 		condlog(0, "Cannot seek to end of bindings file : %s",
 			strerror(errno));
-		return NULL;
+		goto out;
 	}
 
 	len = get_strbuf_len(&buf);
-	alias = steal_strbuf_str(&buf);
+	str = get_strbuf_str(&buf);
 
-	if (write(fd, alias, len) != len) {
+	if (write(fd, str, len) != len) {
 		condlog(0, "Cannot write binding to bindings file : %s",
 			strerror(errno));
 		/* clear partial write */
 		if (ftruncate(fd, offset))
 			condlog(0, "Cannot truncate the header : %s",
 				strerror(errno));
-		free(alias);
-		return NULL;
+		goto out;
 	}
-	c = strchr(alias, ' ');
-	if (c)
-		*c = '\0';
+	end = strcspn(str, " ");
 
-	condlog(3, "Created new binding [%s] for WWID [%s]", alias, wwid);
+	condlog(3, "Created new binding [%.*s] for WWID [%s]", end, str, wwid);
+	alias = steal_strbuf_str(&buf);
+
+	alias[len] = '\0';
+out:
+	pthread_cleanup_pop(1);
 	return alias;
 }
 
@@ -549,24 +558,28 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
 static int write_bindings_file(const Bindings *bindings, int fd)
 {
 	struct binding *bnd;
-	STRBUF_ON_STACK(line);
-	int i;
+	struct strbuf line = STRBUF_INIT;
+	int i, r = -1;
 
 	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
 	    != sizeof(BINDINGS_FILE_HEADER) - 1)
 		return -1;
 
+	pthread_cleanup_push_cast(reset_strbuf, &line);
 	vector_foreach_slot(bindings, bnd, i) {
 		int len;
 
 		if ((len = print_strbuf(&line, "%s %s\n",
 					bnd->alias, bnd->wwid)) < 0)
-			return -1;
+			goto out;
 		if (write(fd, get_strbuf_str(&line), len) != len)
-			return -1;
+			goto out;
 		truncate_strbuf(&line, 0);
 	}
-	return 0;
+	r = 0;
+out:
+	pthread_cleanup_pop(1);
+	return r;
 }
 
 static int fix_bindings_file(const struct config *conf,
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 8d15d2ea..7e0b036a 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -341,11 +341,12 @@ int
 filter_protocol(const struct _vector *blist, const struct _vector *elist,
 		const struct path *pp)
 {
-	STRBUF_ON_STACK(buf);
+	struct strbuf buf = STRBUF_INIT;
 	const char *prot;
 	int r = MATCH_NOTHING;
 
 	if (pp) {
+		pthread_cleanup_push_cast(reset_strbuf, &buf);
 		snprint_path_protocol(&buf, pp);
 		prot = get_strbuf_str(&buf);
 
@@ -354,6 +355,7 @@ filter_protocol(const struct _vector *blist, const struct _vector *elist,
 		else if (match_reglist(blist, prot))
 			r = MATCH_PROTOCOL_BLIST;
 		log_filter(pp->dev, NULL, NULL, NULL, NULL, prot, r, 3);
+		pthread_cleanup_pop(1);
 	}
 
 	return r;
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f3fccedd..32181259 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -838,13 +838,15 @@ static void
 scsi_tmo_error_msg(struct path *pp)
 {
 	STATIC_BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
-	STRBUF_ON_STACK(proto_buf);
+	struct strbuf proto_buf = STRBUF_INIT;
 	unsigned int proto_id = bus_protocol_id(pp);
 
+	pthread_cleanup_push_cast(reset_strbuf, &proto_buf);
 	snprint_path_protocol(&proto_buf, pp);
 	condlog(2, "%s: setting scsi timeouts is unsupported for protocol %s",
 		pp->dev, get_strbuf_str(&proto_buf));
 	set_bit_in_bitfield(proto_id, bf);
+	pthread_cleanup_pop(1);
 }
 
 int
@@ -1142,12 +1144,13 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 	size_t len, vpd_len, i;
 	int vpd_type, prio = -1;
 	int err = -ENODATA;
-	STRBUF_ON_STACK(buf);
+	struct strbuf buf = STRBUF_INIT;
 
 	/* Need space at least for one digit */
 	if (out_len <= 1)
 		return 0;
 
+	pthread_cleanup_push_cast(reset_strbuf, &buf);
 	d = in + 4;
 	while (d <= in + in_len - 4) {
 		bool invalid = false;
@@ -1241,8 +1244,9 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 	}
 
 	if (prio <= 0)
-		return err;
+		goto out;
 
+	err = 0;
 	if (d != in + in_len)
 		/* Should this be fatal? (overflow covered above) */
 		condlog(2, "%s: warning: last descriptor end %zd != VPD length %zu",
@@ -1262,10 +1266,10 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		size_t i;
 
 		if ((err = print_strbuf(&buf, "%d", vpd_type)) < 0)
-			return err;
+			goto out;
 		for (i = 0; i < vpd_len; i++)
 			if ((err = print_strbuf(&buf, "%02x", vpd[i])) < 0)
-				return err;
+				goto out;
 	} else if (vpd_type == 0x8) {
 		char type;
 
@@ -1276,12 +1280,12 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		else
 			type = '8';
 		if ((err = fill_strbuf(&buf, type, 1)) < 0)
-			return err;
+			goto out;
 
 		vpd += 4;
 		len = vpd_len - 4;
 		if ((err = __append_strbuf_str(&buf, (const char *)vpd, len)) < 0)
-			return err;
+			goto out;
 
 		/* The input is 0-padded, make sure the length is correct */
 		truncate_strbuf(&buf, strlen(get_strbuf_str(&buf)));
@@ -1298,12 +1302,12 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		size_t p_len;
 
 		if ((err = fill_strbuf(&buf, '1', 1)) < 0)
-			return err;
+			goto out;
 		while (vpd && (p = memchr(vpd, ' ', vpd_len))) {
 			p_len = p - vpd;
 			if ((err = __append_strbuf_str(&buf, (const char *)vpd,
 						       p_len)) < 0)
-				return err;
+				goto out;
 			vpd = p;
 			vpd_len -= p_len;
 			while (vpd && vpd_len > 0 && *vpd == ' ') {
@@ -1311,12 +1315,12 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				vpd_len --;
 			}
 			if (vpd_len > 0 && (err = fill_strbuf(&buf, '_', 1)) < 0)
-				return err;
+				goto out;
 		}
 		if (vpd_len > 0) {
 			if ((err = __append_strbuf_str(&buf, (const char *)vpd,
 						       vpd_len)) < 0)
-				return err;
+				goto out;
 		}
 	}
 
@@ -1331,6 +1335,10 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 			len = out_len - 1;
 	}
 	strlcpy(out, get_strbuf_str(&buf), len + 1);
+out:
+	pthread_cleanup_pop(1);
+	if (err)
+		return err;
 	return len;
 }
 
@@ -2435,11 +2443,13 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 				 * It's likely that this path is not fit for
 				 * multipath use.
 				 */
-				STRBUF_ON_STACK(buf);
+				struct strbuf buf = STRBUF_INIT;
 
+				pthread_cleanup_push_cast(reset_strbuf, &buf);
 				snprint_path(&buf, "%T", pp, 0);
 				condlog(1, "%s: no WWID in state \"%s\", giving up",
 					pp->dev, get_strbuf_str(&buf));
+				pthread_cleanup_pop(1);
 				return PATHINFO_SKIPPED;
 			}
 			return PATHINFO_OK;
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 3b37a926..44650aaa 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -48,10 +48,10 @@ int assemble_map(struct multipath *mp, char **params)
 {
 	static const char no_path_retry[] = "queue_if_no_path";
 	static const char retain_hwhandler[] = "retain_attached_hw_handler";
-	int i, j;
+	int i, j, r = 1;
 	int minio;
 	int nr_priority_groups, initial_pg_nr;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 	struct pathgroup * pgp;
 	struct path * pp;
 
@@ -68,15 +68,16 @@ int assemble_map(struct multipath *mp, char **params)
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
 		add_feature(&mp->features, retain_hwhandler);
 
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_strbuf(&buff, "%s %s %i %i", mp->features, mp->hwhandler,
 			 nr_priority_groups, initial_pg_nr) < 0)
-		goto err;
+		goto out;
 
 	vector_foreach_slot (mp->pg, pgp, i) {
 		pgp = VECTOR_SLOT(mp->pg, i);
 		if (print_strbuf(&buff, " %s %i 1", mp->selector,
 				 VECTOR_SIZE(pgp->paths)) < 0)
-			goto err;
+			goto out;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
 			int tmp_minio = minio;
@@ -86,19 +87,19 @@ int assemble_map(struct multipath *mp, char **params)
 				tmp_minio = minio * pp->priority;
 			if (!strlen(pp->dev_t) ) {
 				condlog(0, "dev_t not set for '%s'", pp->dev);
-				goto err;
+				goto out;
 			}
 			if (print_strbuf(&buff, " %s %d", pp->dev_t, tmp_minio) < 0)
-				goto err;
+				goto out;
 		}
 	}
 
 	*params = steal_strbuf_str(&buff);
 	condlog(4, "%s: assembled map [%s]", mp->alias, *params);
-	return 0;
-
-err:
-	return 1;
+	r = 0;
+out:
+	pthread_cleanup_pop(1);
+	return r;
 }
 
 /*
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index d01a5ef0..8981ff58 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -547,7 +547,7 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity,
 
 void print_foreign_topology(int verbosity)
 {
-	STRBUF_ON_STACK(buf);
+	struct strbuf buf = STRBUF_INIT;
 	struct foreign *fgn;
 	int i;
 	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
@@ -559,6 +559,7 @@ void print_foreign_topology(int verbosity)
 		unlock_foreigns(NULL);
 		return;
 	}
+	pthread_cleanup_push_cast(reset_strbuf, &buf);
 	pthread_cleanup_push(unlock_foreigns, NULL);
 	vector_foreach_slot(foreigns, fgn, i) {
 		const struct _vector *vec;
@@ -573,6 +574,7 @@ void print_foreign_topology(int verbosity)
 	__snprint_foreign_topology(&buf, verbosity, width);
 	pthread_cleanup_pop(1);
 	printf("%s", get_strbuf_str(&buf));
+	pthread_cleanup_pop(1);
 }
 
 int snprint_foreign_paths(struct strbuf *buf, const char *style,
diff --git a/libmultipath/generic.c b/libmultipath/generic.c
index e7cf2975..3e2268e6 100644
--- a/libmultipath/generic.c
+++ b/libmultipath/generic.c
@@ -23,15 +23,19 @@
 int generic_style(const struct gen_multipath* gm, struct strbuf *buf,
 		  __attribute__((unused)) int verbosity)
 {
-	STRBUF_ON_STACK(tmp);
+	struct strbuf tmp = STRBUF_INIT;
 	char *alias_buf __attribute__((cleanup(cleanup_charp)));
 	const char *wwid_buf;
+	int ret;
 
+	pthread_cleanup_push_cast(reset_strbuf, &tmp);
 	gm->ops->snprint(gm, &tmp, 'n');
 	alias_buf = steal_strbuf_str(&tmp);
 	gm->ops->snprint(gm, &tmp, 'w');
 	wwid_buf = get_strbuf_str(&tmp);
 
-	return print_strbuf(buf, "%%n %s[%%G]:%%d %%s",
-			    strcmp(alias_buf, wwid_buf) ? "(%w) " : "");
+	ret = print_strbuf(buf, "%%n %s[%%G]:%%d %%s",
+			   strcmp(alias_buf, wwid_buf) ? "(%w) " : "");
+	pthread_cleanup_pop(1);
+	return ret;
 }
diff --git a/libmultipath/print.c b/libmultipath/print.c
index d7d522c8..97f9a177 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -911,19 +911,21 @@ void _get_path_layout (const struct _vector *gpvec, enum layout_reset reset,
 		return;
 
 	for (j = 0; j < ARRAY_SIZE(pd); j++) {
-		STRBUF_ON_STACK(buff);
+		struct strbuf buff = STRBUF_INIT;
 
 		reset_width(&width[j], reset, pd[j].header);
 
 		if (gpvec == NULL)
 			continue;
 
+		pthread_cleanup_push_cast(reset_strbuf, &buff);
 		vector_foreach_slot (gpvec, gp, i) {
 			gp->ops->snprint(gp, &buff, pd[j].wildcard);
 			width[j] = MAX(width[j],
 				       MIN(get_strbuf_len(&buff), MAX_FIELD_WIDTH));
 			truncate_strbuf(&buff, 0);
 		}
+		pthread_cleanup_pop(1);
 	}
 }
 
@@ -951,19 +953,21 @@ _get_multipath_layout (const struct _vector *gmvec, enum layout_reset reset,
 	if (width == NULL)
 		return;
 	for (j = 0; j < ARRAY_SIZE(mpd); j++) {
-		STRBUF_ON_STACK(buff);
+		struct strbuf buff = STRBUF_INIT;
 
 		reset_width(&width[j], reset, mpd[j].header);
 
 		if (gmvec == NULL)
 			continue;
 
+		pthread_cleanup_push_cast(reset_strbuf, &buff);
 		vector_foreach_slot (gmvec, gm, i) {
 			gm->ops->snprint(gm, &buff, mpd[j].wildcard);
 			width[j] = MAX(width[j],
 				       MIN(get_strbuf_len(&buff), MAX_FIELD_WIDTH));
 			truncate_strbuf(&buff, 0);
 		}
+		pthread_cleanup_pop(1);
 		condlog(4, "%s: width %d", mpd[j].header, width[j]);
 	}
 }
@@ -1182,7 +1186,7 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 
 void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
 {
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 	const struct gen_pathgroup *gpg;
 	const struct _vector *pgvec, *pathvec;
@@ -1202,8 +1206,10 @@ void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
 		gmp->ops->rel_pathgroups(gmp, pgvec);
 	}
 
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	_snprint_multipath_topology(gmp, &buff, verbosity, p_width);
 	printf("%s", get_strbuf_str(&buff));
+	pthread_cleanup_pop(1);
 }
 
 int snprint_multipath_style(const struct gen_multipath *gmp,
@@ -1225,10 +1231,10 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 				struct strbuf *buff, int verbosity,
 				const fieldwidth_t *p_width)
 {
-	int j, i, rc;
+	int j, i, rc = 0;
 	const struct _vector *pgvec;
 	const struct gen_pathgroup *gpg;
-	STRBUF_ON_STACK(style);
+	struct strbuf style = STRBUF_INIT;
 	size_t initial_len = get_strbuf_len(buff);
 	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
@@ -1241,17 +1247,21 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 	if (verbosity == 1)
 		return _snprint_multipath(gmp, buff, "%n", width);
 
+	pthread_cleanup_push_cast(reset_strbuf, &style);
 	if(isatty(1) &&
 	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 1)) < 0) /* bold on */
-		return rc;
+		goto err;
 	if ((rc = gmp->ops->style(gmp, &style, verbosity)) < 0)
-		return rc;
+		goto err;
 	if(isatty(1) &&
 	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 0)) < 0) /* bold off */
-		return rc;
+		goto err;
 
-	if ((rc = _snprint_multipath(gmp, buff, get_strbuf_str(&style), width)) < 0
-	    || (rc = _snprint_multipath(gmp, buff, PRINT_MAP_PROPS, width)) < 0)
+	if ((rc = _snprint_multipath(gmp, buff, get_strbuf_str(&style), width)) >= 0)
+		rc = _snprint_multipath(gmp, buff, PRINT_MAP_PROPS, width);
+err:
+	pthread_cleanup_pop(1);
+	if (rc < 0)
 		return rc;
 
 	pgvec = gmp->ops->get_pathgroups(gmp);
@@ -1868,7 +1878,7 @@ int __snprint_config(const struct config *conf, struct strbuf *buff,
 {
 	int rc;
 
-	if ((rc = snprint_defaults(conf, buff)) < 0 ||
+	if ((rc = snprint_defaults(conf, buff)) < 1 ||
 	    (rc = snprint_blacklist(conf, buff)) < 0 ||
 	    (rc = snprint_blacklist_except(conf, buff)) < 0 ||
 	    (rc = snprint_hwtable(conf, buff,
@@ -1887,17 +1897,21 @@ int __snprint_config(const struct config *conf, struct strbuf *buff,
 char *snprint_config(const struct config *conf, int *len,
 		     const struct _vector *hwtable, const struct _vector *mpvec)
 {
-	STRBUF_ON_STACK(buff);
-	char *reply;
-	int rc = __snprint_config(conf, &buff, hwtable, mpvec);
+	struct strbuf buff = STRBUF_INIT;
+	char *reply = NULL;
+	int rc;
+
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
+	rc = __snprint_config(conf, &buff, hwtable, mpvec);
 
 	if (rc < 0)
-		return NULL;
+		goto out;
 
 	if (len)
 		*len = get_strbuf_len(&buff);
 	reply = steal_strbuf_str(&buff);
-
+out:
+	pthread_cleanup_pop(1);
 	return reply;
 }
 
@@ -2012,7 +2026,7 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 {
 	int i;
 	struct path * pp;
-	STRBUF_ON_STACK(line);
+	struct strbuf line = STRBUF_INIT;
 	fieldwidth_t *width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 
 	if (!VECTOR_SIZE(pathvec)) {
@@ -2025,6 +2039,7 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 		return;
 	get_path_layout(pathvec, 1, width);
 
+	pthread_cleanup_push_cast(reset_strbuf, &line);
 	if (banner)
 		append_strbuf_str(&line, "===== paths list =====\n");
 
@@ -2034,6 +2049,7 @@ static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
 		snprint_path(&line, fmt, pp, width);
 
 	printf("%s", get_strbuf_str(&line));
+	pthread_cleanup_pop(1);
 }
 
 void print_all_paths(vector pathvec, int banner)
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 561ebb48..df700bf3 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -63,7 +63,7 @@ build_wwn_path(struct path *pp, struct strbuf *buf)
 /* main priority routine */
 int prio_path_weight(struct path *pp, char *prio_args)
 {
-	STRBUF_ON_STACK(path);
+	struct strbuf path = STRBUF_INIT;
 	char *arg __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *temp, *regex, *prio;
 	char split_char[] = " \t";
@@ -84,24 +84,25 @@ int prio_path_weight(struct path *pp, char *prio_args)
 		return priority;
 	}
 
+	pthread_cleanup_push_cast(reset_strbuf, &path);
 	if (!strcmp(regex, HBTL)) {
 		if (print_strbuf(&path, "%d:%d:%d:%" PRIu64, pp->sg_id.host_no,
 				 pp->sg_id.channel, pp->sg_id.scsi_id,
 				 pp->sg_id.lun) < 0)
-			return priority;
+			goto out;
 	} else if (!strcmp(regex, DEV_NAME)) {
 		if (append_strbuf_str(&path, pp->dev) < 0)
-			return priority;
+			goto out;
 	} else if (!strcmp(regex, SERIAL)) {
 		if (build_serial_path(pp, &path) != 0)
-			return priority;
+			goto out;
 	} else if (!strcmp(regex, WWN)) {
 		if (build_wwn_path(pp, &path) != 0)
-			return priority;
+			goto out;
 	} else {
 		condlog(0, "%s: %s - Invalid arguments", pp->dev,
 			pp->prio.name);
-		return priority;
+		goto out;
 	}
 
 	while (!path_found) {
@@ -121,7 +122,8 @@ int prio_path_weight(struct path *pp, char *prio_args)
 			regfree(&pathe);
 		}
 	}
-
+out:
+	pthread_cleanup_pop(1);
 	return priority;
 }
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d4f19897..f35acdaa 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -217,7 +217,7 @@ out:
 int select_rr_weight(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	mp_set_mpe(rr_weight);
 	mp_set_ovr(rr_weight);
@@ -225,16 +225,18 @@ int select_rr_weight(struct config *conf, struct multipath * mp)
 	mp_set_conf(rr_weight);
 	mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_rr_weight(&buff, mp->rr_weight);
 	condlog(3, "%s: rr_weight = %s %s", mp->alias,
 		get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_pgfailback(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	mp_set_mpe(pgfailback);
 	mp_set_ovr(pgfailback);
@@ -242,9 +244,11 @@ int select_pgfailback(struct config *conf, struct multipath * mp)
 	mp_set_conf(pgfailback);
 	mp_set_default(pgfailback, DEFAULT_FAILBACK);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_pgfailback(&buff, mp->pgfailback);
 	condlog(3, "%s: failback = %s %s", mp->alias,
 		get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
@@ -367,7 +371,7 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 {
 	static const char q_i_n_p[] = "queue_if_no_path";
 	static const char r_a_h_h[] = "retain_attached_hw_handler";
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (*features == NULL)
 		return;
@@ -382,6 +386,7 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 	 * For backward compatibility we allow 'features "1 queue_if_no_path"';
 	 * it's translated into "no_path_retry queue" here.
 	 */
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (strstr(*features, q_i_n_p)) {
 		condlog(0, "%s: option 'features \"1 %s\"' is deprecated, "
 			"please use 'no_path_retry queue' instead",
@@ -400,6 +405,7 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 		}
 		remove_feature(features, q_i_n_p);
 	}
+	pthread_cleanup_pop(1);
 	if (strstr(*features, r_a_h_h)) {
 		condlog(0, "%s: option 'features \"1 %s\"' is deprecated",
 			id, r_a_h_h);
@@ -779,7 +785,7 @@ out:
 int select_no_path_retry(struct config *conf, struct multipath *mp)
 {
 	const char *origin = NULL;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (mp->disable_queueing) {
 		condlog(0, "%s: queueing disabled", mp->alias);
@@ -791,6 +797,7 @@ int select_no_path_retry(struct config *conf, struct multipath *mp)
 	mp_set_hwe(no_path_retry);
 	mp_set_conf(no_path_retry);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_no_path_retry(&buff, mp->no_path_retry);
 	if (origin)
 		condlog(3, "%s: no_path_retry = %s %s", mp->alias,
@@ -798,6 +805,7 @@ out:
 	else
 		condlog(3, "%s: no_path_retry = undef %s",
 			mp->alias, default_origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
@@ -845,23 +853,25 @@ int select_minio(struct config *conf, struct multipath *mp)
 int select_fast_io_fail(struct config *conf, struct path *pp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	pp_set_ovr_pce(fast_io_fail);
 	pp_set_hwe(fast_io_fail);
 	pp_set_conf(fast_io_fail);
 	pp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_undef_off_zero(&buff, pp->fast_io_fail);
 	condlog(3, "%s: fast_io_fail_tmo = %s %s", pp->dev,
 		get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_dev_loss(struct config *conf, struct path *pp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	pp_set_ovr_pce(dev_loss);
 	pp_set_hwe(dev_loss);
@@ -869,16 +879,18 @@ int select_dev_loss(struct config *conf, struct path *pp)
 	pp->dev_loss = DEV_LOSS_TMO_UNSET;
 	return 0;
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_dev_loss(&buff, pp->dev_loss);
 	condlog(3, "%s: dev_loss_tmo = %s %s", pp->dev,
 		get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_eh_deadline(struct config *conf, struct path *pp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	pp_set_ovr_pce(eh_deadline);
 	pp_set_hwe(eh_deadline);
@@ -887,9 +899,11 @@ int select_eh_deadline(struct config *conf, struct path *pp)
 	/* not changing sysfs in default cause, so don't print anything */
 	return 0;
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_undef_off_zero(&buff, pp->eh_deadline);
 	condlog(3, "%s: eh_deadline = %s %s", pp->dev,
 		get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
@@ -911,7 +925,7 @@ out:
 int select_reservation_key(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 	char *from_file = "";
 	uint64_t prkey = 0;
 
@@ -929,10 +943,12 @@ out:
 		else
 			put_be64(mp->reservation_key, prkey);
 	}
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	print_reservation_key(&buff, mp->reservation_key,
 			      mp->sa_flags, mp->prkey_source);
 	condlog(3, "%s: reservation_key = %s %s%s", mp->alias,
 		get_strbuf_str(&buff), origin, from_file);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
@@ -1029,16 +1045,18 @@ use_delay_watch_checks(struct config *conf, struct multipath *mp)
 {
 	int value = NU_UNDEF;
 	const char *origin = default_origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	do_set(delay_watch_checks, mp->mpe, value, multipaths_origin);
 	do_set(delay_watch_checks, conf->overrides, value, overrides_origin);
 	do_set_from_hwe(delay_watch_checks, mp, value, hwe_origin);
 	do_set(delay_watch_checks, conf, value, conf_origin);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, value) > 0)
 		condlog(3, "%s: delay_watch_checks = %s %s", mp->alias,
 			get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return value;
 }
 
@@ -1047,23 +1065,25 @@ use_delay_wait_checks(struct config *conf, struct multipath *mp)
 {
 	int value = NU_UNDEF;
 	const char *origin = default_origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	do_set(delay_wait_checks, mp->mpe, value, multipaths_origin);
 	do_set(delay_wait_checks, conf->overrides, value, overrides_origin);
 	do_set_from_hwe(delay_wait_checks, mp, value, hwe_origin);
 	do_set(delay_wait_checks, conf, value, conf_origin);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, value) > 0)
 		condlog(3, "%s: delay_wait_checks = %s %s", mp->alias,
 			get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return value;
 }
 
 int select_delay_checks(struct config *conf, struct multipath *mp)
 {
 	int watch_checks, wait_checks;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	watch_checks = use_delay_watch_checks(conf, mp);
 	wait_checks = use_delay_wait_checks(conf, mp);
@@ -1077,6 +1097,7 @@ int select_delay_checks(struct config *conf, struct multipath *mp)
 	mp->san_path_err_threshold = 1;
 	condlog(3, "%s: san_path_err_threshold = 1 %s", mp->alias,
 		(watch_checks > 0)? delay_watch_origin : delay_wait_origin);
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (watch_checks > 0) {
 		mp->san_path_err_forget_rate = watch_checks;
 		print_off_int_undef(&buff, mp->san_path_err_forget_rate);
@@ -1091,6 +1112,7 @@ int select_delay_checks(struct config *conf, struct multipath *mp)
 		condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
 			get_strbuf_str(&buff), delay_wait_origin);
 	}
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
@@ -1108,7 +1130,7 @@ static int san_path_deprecated_warned;
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (marginal_path_check_enabled(mp) || (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)) {
 		mp->san_path_err_threshold = NU_NO;
@@ -1124,17 +1146,19 @@ int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 	mp_set_conf(san_path_err_threshold);
 	mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->san_path_err_threshold) > 0)
 		condlog(3, "%s: san_path_err_threshold = %s %s",
 			mp->alias, get_strbuf_str(&buff), origin);
 	warn_san_path_deprecated(mp, san_path_err_threshold);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (marginal_path_check_enabled(mp) || (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)) {
 		mp->san_path_err_forget_rate = NU_NO;
@@ -1150,9 +1174,11 @@ int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 	mp_set_conf(san_path_err_forget_rate);
 	mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->san_path_err_forget_rate) > 0)
 		condlog(3, "%s: san_path_err_forget_rate = %s %s",
 			mp->alias, get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	warn_san_path_deprecated(mp, san_path_err_forget_rate);
 	return 0;
 
@@ -1161,7 +1187,7 @@ out:
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (marginal_path_check_enabled(mp) || (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)) {
 		mp->san_path_err_recovery_time = NU_NO;
@@ -1177,9 +1203,11 @@ int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 	mp_set_conf(san_path_err_recovery_time);
 	mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->san_path_err_recovery_time) != 0)
 		condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
 			get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	warn_san_path_deprecated(mp, san_path_err_recovery_time);
 	return 0;
 
@@ -1188,7 +1216,7 @@ out:
 int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
 		mp->marginal_path_err_sample_time = NU_NO;
@@ -1208,16 +1236,18 @@ out:
 			mp->alias, 2 * IOTIMEOUT_SEC);
 			mp->marginal_path_err_sample_time = 2 * IOTIMEOUT_SEC;
 	}
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->marginal_path_err_sample_time) > 0)
 		condlog(3, "%s: marginal_path_err_sample_time = %s %s",
 			mp->alias, get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_marginal_path_err_rate_threshold(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
 		mp->marginal_path_err_rate_threshold = NU_NO;
@@ -1231,16 +1261,18 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_err_rate_threshold);
 	mp_set_default(marginal_path_err_rate_threshold, DEFAULT_ERR_CHECKS);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->marginal_path_err_rate_threshold) > 0)
 		condlog(3, "%s: marginal_path_err_rate_threshold = %s %s",
 			mp->alias, get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
 		mp->marginal_path_err_recheck_gap_time = NU_NO;
@@ -1254,17 +1286,19 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 	mp_set_conf(marginal_path_err_recheck_gap_time);
 	mp_set_default(marginal_path_err_recheck_gap_time, DEFAULT_ERR_CHECKS);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff,
 				mp->marginal_path_err_recheck_gap_time) > 0)
 		condlog(3, "%s: marginal_path_err_recheck_gap_time = %s %s",
 			mp->alias, get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
 int select_marginal_path_double_failed_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
 		mp->marginal_path_double_failed_time = NU_NO;
@@ -1278,9 +1312,11 @@ int select_marginal_path_double_failed_time(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_double_failed_time);
 	mp_set_default(marginal_path_double_failed_time, DEFAULT_ERR_CHECKS);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->marginal_path_double_failed_time) > 0)
 		condlog(3, "%s: marginal_path_double_failed_time = %s %s",
 			mp->alias, get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
@@ -1324,7 +1360,7 @@ out:
 int select_ghost_delay (struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	STRBUF_ON_STACK(buff);
+	struct strbuf buff = STRBUF_INIT;
 
 	mp_set_mpe(ghost_delay);
 	mp_set_ovr(ghost_delay);
@@ -1332,9 +1368,11 @@ int select_ghost_delay (struct config *conf, struct multipath * mp)
 	mp_set_conf(ghost_delay);
 	mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY);
 out:
+	pthread_cleanup_push_cast(reset_strbuf, &buff);
 	if (print_off_int_undef(&buff, mp->ghost_delay) != 0)
 		condlog(3, "%s: ghost_delay = %s %s", mp->alias,
 			get_strbuf_str(&buff), origin);
+	pthread_cleanup_pop(1);
 	return 0;
 }
 
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 799f68e9..7e80b411 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -26,14 +26,9 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 		sysfs_attr_value_ok(__rc, __l); \
 	})
 
-#define log_sysfs_attr_set_value(prio, rc, fmt, __args...)		\
-do {									\
-	STRBUF_ON_STACK(__buf);						\
-	if (print_strbuf(&__buf, fmt, ##__args) >= 0 &&			\
-	    print_strbuf(&__buf, ": %s", rc < 0 ? strerror(-rc) :	\
-					"write underflow") >= 0)	\
-		condlog(prio, "%s", get_strbuf_str(&__buf));		\
-} while(0)
+#define log_sysfs_attr_set_value(prio, rc, fmt, __args...) \
+	condlog(prio, fmt ": %s", ##__args , rc < 0 ? strerror(-rc) :	\
+					     "write underflow")
 
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 57447ca0..db6da984 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -460,11 +460,12 @@ static void print_uevq(const char *msg, struct list_head *uevq)
 {
 	struct uevent *uev;
 	int i = 0;
-	STRBUF_ON_STACK(buf);
+	struct strbuf buf = STRBUF_INIT;
 
 	if (4 > MAX_VERBOSITY || 4 > libmp_verbosity)
 		return;
 
+	pthread_cleanup_push_cast(reset_strbuf, &buf);
 	if (list_empty(uevq))
 		append_strbuf_str(&buf, "*empty*");
 	else
@@ -473,7 +474,8 @@ static void print_uevq(const char *msg, struct list_head *uevq)
 			print_uev(&buf, uev);
 		}
 
-	condlog(4, "uevent queue (%s): %s", msg, steal_strbuf_str(&buf));
+	condlog(4, "uevent queue (%s): %s", msg, get_strbuf_str(&buf));
+	pthread_cleanup_pop(1);
 }
 
 static void
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

