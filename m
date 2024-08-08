Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA27119047B
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130829; cv=none; b=KEWAi+7VgnRioyrNf0lga5cw/oN9vhZwKwguj3SrWU120Du16QXEg9XXNWWBZ55GPGxnu6f5W2XwlohfmL834yYIM7rqK15xJgoHpAD7+3B8280caQqfjm9dxx9c0ylme4TC4+lQ9QcR2WH7vfUnob1SaUqnXyt8sah39+LQuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130829; c=relaxed/simple;
	bh=rax+MGScDV6VlPXOTydRWv04YdV7KbTZrkstO5mo/7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLzhOTOqNzzPuBBwmDPl/0wbVGuh2MohAtHaHAWWclk6ofYPJYNwMcgwJkZw2p3DFEiA6N+63w3abu0VxPqCRxCfULs9EkfXz+4wG5gDTk3M7n44H518PIGRquwjWLp1KatlOYtOPO7LHaQKiS2HrwYimKIj6y3Oo/02sPz5PZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EM3eSwjW; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EM3eSwjW"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52efd8807aaso1251452e87.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130825; x=1723735625; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0+TMzyITHM/uvpQoCp/tFTLqXVrNZsgRyiVa7oxJbw=;
        b=EM3eSwjW17qc4SKlvS6g6F/vxg0nCMlemKVINlg6bD218tmbzX7+N3pg3cz8Y+dSS4
         CAUICrt+Fnlot6rhnyPf6Kd5J06ticFiT++i6OP/UGlmTO0oMa/Eov8W/VAKum9FVlXc
         SYOHpuIK2PjbOxWVBfKhtv3a+JNvelAnp2xsGjYjtGgeERVw07AG+YiAod5zlBQ/WD88
         i+IKppTg2Pjz4M7t5+PImqKxYaxmmXvHwX2LIfiO317wBiZBrCWvG01Q0p7hxRa/GeiV
         yKc3s/Nn2eR22vHz94CIS1L/nZjbW6usCXx+n5Moqcft7o8632r8GsMP7iwvsrSmWaoO
         x4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130825; x=1723735625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0+TMzyITHM/uvpQoCp/tFTLqXVrNZsgRyiVa7oxJbw=;
        b=AvEw2UP5qP+2FjC2kNWBhKTO+gqzUaEtrrPiX0LW7UoHDvhdknIUH8EYIg/ZVjuKh4
         12UObLeutSHGXc54x0fwNlW4jrS/MxoNbJEJM7uoglne3NzyHZeubFlOnBVhiPx462JS
         Suoi6Jqpcm6X6JnTuukJh8/XiqaYYRKojd/KxhfGoGs7Vn8kpfPj1GBOn+JOIZdqqpGN
         6nrCCPE/9pE6o3jXQADI9cn42ca6Ot+3eKNnmupv0JLrq7PLjVXKUDatyU8yGvcfT44s
         o5WMv3tRdvSDfhh8rt9c525yUUmgkYnuPRilLXPlP11Rkcz9KQoke7QmRHKWoXp2Mbs6
         43fA==
X-Gm-Message-State: AOJu0Yza7LlmYM/rAFvqatnelx20a6bMcx/IDUgoc0tM5dzCGz9bihMx
	1QOvCizGaXmlxr+5N6hvxvXnP2/e7jfnUiFMzlN08qoqjbkxAofri7z0s6VNlT0=
X-Google-Smtp-Source: AGHT+IHMoqvsbkeb0niX5qq/X03KVuaAph2Nt+vY2wfPIXKcdOwmOYTwTyvzvN8x4Ko3e1fmMPriXQ==
X-Received: by 2002:a05:6512:39cd:b0:52f:228:cf80 with SMTP id 2adb3069b0e04-530e58afe6dmr1803984e87.40.1723130824674;
        Thu, 08 Aug 2024 08:27:04 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ec7173sm747338466b.204.2024.08.08.08.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 30/41] libmultipath: rename symbols starting with underscore in print.h
Date: Thu,  8 Aug 2024 17:26:09 +0200
Message-ID: <20240808152620.93965-31-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign.c            | 12 +++++------
 libmultipath/foreign.h            |  2 +-
 libmultipath/libmultipath.version |  8 ++++----
 libmultipath/print.c              | 34 +++++++++++++++----------------
 libmultipath/print.h              | 20 +++++++++---------
 5 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 5ec2d0b..d23439e 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -458,7 +458,7 @@ void foreign_path_layout(fieldwidth_t *width)
 
 		vec = fgn->get_paths(fgn->context);
 		if (vec != NULL) {
-			_get_path_layout(vec, LAYOUT_RESET_NOT, width);
+			get_path_layout__(vec, LAYOUT_RESET_NOT, width);
 		}
 		fgn->release_paths(fgn->context, vec);
 
@@ -489,7 +489,7 @@ void foreign_multipath_layout(fieldwidth_t *width)
 
 		vec = fgn->get_multipaths(fgn->context);
 		if (vec != NULL) {
-			_get_multipath_layout(vec, LAYOUT_RESET_NOT, width);
+			get_multipath_layout__(vec, LAYOUT_RESET_NOT, width);
 		}
 		fgn->release_multipaths(fgn->context, vec);
 
@@ -517,7 +517,7 @@ static int snprint_foreign_topology__(struct strbuf *buf, int verbosity,
 		vec = fgn->get_multipaths(fgn->context);
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gm, j) {
-				if (_snprint_multipath_topology(
+				if (snprint_multipath_topology__(
 					    gm, buf, verbosity, width) < 0)
 					break;
 			}
@@ -566,7 +566,7 @@ void print_foreign_topology(int verbosity)
 		fgn->lock(fgn->context);
 		pthread_cleanup_push(fgn->unlock, fgn->context);
 		vec = fgn->get_paths(fgn->context);
-		_get_multipath_layout(vec, LAYOUT_RESET_NOT, width);
+		get_multipath_layout__(vec, LAYOUT_RESET_NOT, width);
 		fgn->release_paths(fgn->context, vec);
 		pthread_cleanup_pop(1);
 	}
@@ -600,7 +600,7 @@ int snprint_foreign_paths(struct strbuf *buf, const char *style,
 		vec = fgn->get_paths(fgn->context);
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gp, j) {
-				ret = _snprint_path(gp, buf, style, width);
+				ret = snprint_path__(gp, buf, style, width);
 				if (ret < 0)
 					break;
 			}
@@ -640,7 +640,7 @@ int snprint_foreign_multipaths(struct strbuf *buf, const char *style,
 		vec = fgn->get_multipaths(fgn->context);
 		if (vec != NULL) {
 			vector_foreach_slot(vec, gm, j) {
-				ret = _snprint_multipath(gm, buf,
+				ret = snprint_multipath__(gm, buf,
 							 style, width);
 				if (ret < 0)
 					break;
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index f3bc1b2..809824d 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -271,7 +271,7 @@ void foreign_multipath_layout(fieldwidth_t *width);
  * '\0' - terminated.
  * @param buf: output buffer
  * @param verbosity: verbosity level
- * @param width: an array of field widths, initialized by _get_path_layout()
+ * @param width: an array of field widths, initialized by get_path_layout__()
  * @returns: number of printed characters excluding trailing '\0'.
  */
 int snprint_foreign_topology(struct strbuf *buf, int verbosity,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index f92f759..21d48da 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -149,7 +149,7 @@ global:
 	path_offline;
 	print_all_paths;
 	print_foreign_topology;
-	_print_multipath_topology;
+	print_multipath_topology__;
 	reinstate_paths;
 	remember_wwid;
 	remove_feature;
@@ -179,12 +179,12 @@ global:
 	snprint_foreign_multipaths;
 	snprint_foreign_paths;
 	snprint_foreign_topology;
-	_snprint_multipath;
+	snprint_multipath__;
 	snprint_multipath_header;
 	snprint_multipath_map_json;
-	_snprint_multipath_topology;
+	snprint_multipath_topology__;
 	snprint_multipath_topology_json;
-	_snprint_path;
+	snprint_path__;
 	snprint_path_header;
 	snprint_status;
 	snprint_wildcards;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b8868ea..190c823 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -924,7 +924,7 @@ void get_path_layout(vector pathvec, int header, fieldwidth_t *width)
 {
 	vector gpvec = vector_convert(NULL, pathvec, struct path,
 				      dm_path_to_gen);
-	_get_path_layout(gpvec,
+	get_path_layout__(gpvec,
 			 header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO,
 			 width);
 	vector_free(gpvec);
@@ -946,7 +946,7 @@ reset_width(fieldwidth_t *width, enum layout_reset reset, const char *header)
 	}
 }
 
-void _get_path_layout (const struct _vector *gpvec, enum layout_reset reset,
+void get_path_layout__ (const struct _vector *gpvec, enum layout_reset reset,
 		       fieldwidth_t *width)
 {
 	unsigned int i, j;
@@ -980,14 +980,14 @@ fieldwidth_t *alloc_multipath_layout(void) {
 void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width) {
 	vector gmvec = vector_convert(NULL, mpvec, struct multipath,
 				      dm_multipath_to_gen);
-	_get_multipath_layout(gmvec,
+	get_multipath_layout__(gmvec,
 			      header ? LAYOUT_RESET_HEADER : LAYOUT_RESET_ZERO,
 			      width);
 	vector_free(gmvec);
 }
 
 void
-_get_multipath_layout (const struct _vector *gmvec, enum layout_reset reset,
+get_multipath_layout__ (const struct _vector *gmvec, enum layout_reset reset,
 		       fieldwidth_t *width)
 {
 	unsigned int i, j;
@@ -1110,7 +1110,7 @@ int snprint_multipath_header(struct strbuf *line, const char *format,
 	return get_strbuf_len(line) - initial_len;
 }
 
-int _snprint_multipath(const struct gen_multipath *gmp,
+int snprint_multipath__(const struct gen_multipath *gmp,
 		       struct strbuf *line, const char *format,
 		       const fieldwidth_t *width)
 {
@@ -1171,7 +1171,7 @@ int snprint_path_header(struct strbuf *line, const char *format,
 	return get_strbuf_len(line) - initial_len;
 }
 
-int _snprint_path(const struct gen_path *gp, struct strbuf *line,
+int snprint_path__(const struct gen_path *gp, struct strbuf *line,
 		  const char *format, const fieldwidth_t *width)
 {
 	int initial_len = get_strbuf_len(line);
@@ -1200,7 +1200,7 @@ int _snprint_path(const struct gen_path *gp, struct strbuf *line,
 	return get_strbuf_len(line) - initial_len;
 }
 
-int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
+int snprint_pathgroup__(const struct gen_pathgroup *ggp, struct strbuf *line,
 		       const char *format)
 {
 	int initial_len = get_strbuf_len(line);
@@ -1223,9 +1223,9 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 }
 
 #define snprint_pathgroup(line, fmt, pgp)				\
-	_snprint_pathgroup(dm_pathgroup_to_gen(pgp), line, fmt)
+	snprint_pathgroup__(dm_pathgroup_to_gen(pgp), line, fmt)
 
-void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
+void print_multipath_topology__(const struct gen_multipath *gmp, int verbosity)
 {
 	STRBUF_ON_STACK(buff);
 	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
@@ -1241,13 +1241,13 @@ void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
 			pathvec = gpg->ops->get_paths(gpg);
 			if (pathvec == NULL)
 				continue;
-			_get_path_layout(pathvec, LAYOUT_RESET_NOT, p_width);
+			get_path_layout__(pathvec, LAYOUT_RESET_NOT, p_width);
 			gpg->ops->rel_paths(gpg, pathvec);
 		}
 		gmp->ops->rel_pathgroups(gmp, pgvec);
 	}
 
-	_snprint_multipath_topology(gmp, &buff, verbosity, p_width);
+	snprint_multipath_topology__(gmp, &buff, verbosity, p_width);
 	printf("%s", get_strbuf_str(&buff));
 }
 
@@ -1266,7 +1266,7 @@ int snprint_multipath_style(const struct gen_multipath *gmp,
 			    need_wwid ? " (%w)" : "", " %d %s");
 }
 
-int _snprint_multipath_topology(const struct gen_multipath *gmp,
+int snprint_multipath_topology__(const struct gen_multipath *gmp,
 				struct strbuf *buff, int verbosity,
 				const fieldwidth_t *p_width)
 {
@@ -1284,7 +1284,7 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 		return -ENOMEM;
 
 	if (verbosity == 1)
-		return _snprint_multipath(gmp, buff, "%n", width);
+		return snprint_multipath__(gmp, buff, "%n", width);
 
 	if(isatty(1) &&
 	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 1)) < 0) /* bold on */
@@ -1295,8 +1295,8 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 0)) < 0) /* bold off */
 		return rc;
 
-	if ((rc = _snprint_multipath(gmp, buff, get_strbuf_str(&style), width)) < 0
-	    || (rc = _snprint_multipath(gmp, buff, PRINT_MAP_PROPS, width)) < 0)
+	if ((rc = snprint_multipath__(gmp, buff, get_strbuf_str(&style), width)) < 0
+	    || (rc = snprint_multipath__(gmp, buff, PRINT_MAP_PROPS, width)) < 0)
 		return rc;
 
 	pgvec = gmp->ops->get_pathgroups(gmp);
@@ -1310,7 +1310,7 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 
 		if ((rc = print_strbuf(buff, "%c-+- ",
 				       last_group ? '`' : '|')) < 0 ||
-		    (rc = _snprint_pathgroup(gpg, buff, PRINT_PG_INDENT)) < 0)
+		    (rc = snprint_pathgroup__(gpg, buff, PRINT_PG_INDENT)) < 0)
 			return rc;
 
 		pathvec = gpg->ops->get_paths(gpg);
@@ -1322,7 +1322,7 @@ int _snprint_multipath_topology(const struct gen_multipath *gmp,
 					       last_group ? ' ' : '|',
 					       i + 1 == VECTOR_SIZE(pathvec) ?
 					       '`': '|')) < 0 ||
-			    (rc = _snprint_path(gp, buff,
+			    (rc = snprint_path__(gp, buff,
 						PRINT_PATH_INDENT, p_width)) < 0)
 				return rc;
 		}
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 4dd2ef2..9c2aea4 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -17,28 +17,28 @@ enum layout_reset {
 
 /* fieldwidth_t is defined in generic.h */
 fieldwidth_t *alloc_path_layout(void);
-void _get_path_layout (const struct _vector *gpvec, enum layout_reset,
+void get_path_layout__ (const struct _vector *gpvec, enum layout_reset,
 		       fieldwidth_t *width);
 void get_path_layout (vector pathvec, int header, fieldwidth_t *width);
 fieldwidth_t *alloc_multipath_layout(void);
-void _get_multipath_layout (const struct _vector *gmvec, enum layout_reset,
+void get_multipath_layout__ (const struct _vector *gmvec, enum layout_reset,
 			    fieldwidth_t *width);
 void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width);
 int snprint_path_header(struct strbuf *, const char *, const fieldwidth_t *);
 int snprint_multipath_header(struct strbuf *, const char *,
 			     const fieldwidth_t *);
-int _snprint_path (const struct gen_path *, struct strbuf *, const char *,
+int snprint_path__ (const struct gen_path *, struct strbuf *, const char *,
 		   const fieldwidth_t *);
 #define snprint_path(buf, fmt, pp, w)		\
-	_snprint_path(dm_path_to_gen(pp), buf, fmt, w)
-int _snprint_multipath (const struct gen_multipath *, struct strbuf *,
+	snprint_path__(dm_path_to_gen(pp), buf, fmt, w)
+int snprint_multipath__ (const struct gen_multipath *, struct strbuf *,
 			const char *, const fieldwidth_t *);
 #define snprint_multipath(buf, fmt, mp, w)				\
-	_snprint_multipath(dm_multipath_to_gen(mp), buf, fmt, w)
-int _snprint_multipath_topology (const struct gen_multipath *, struct strbuf *,
+	snprint_multipath__(dm_multipath_to_gen(mp), buf, fmt, w)
+int snprint_multipath_topology__ (const struct gen_multipath *, struct strbuf *,
 				 int verbosity, const fieldwidth_t *);
 #define snprint_multipath_topology(buf, mpp, v, w)			\
-	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v, w)
+	snprint_multipath_topology__ (dm_multipath_to_gen(mpp), buf, v, w)
 int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
 int snprint_config__(const struct config *conf, struct strbuf *buff,
 		     const struct _vector *hwtable, const struct _vector *mpvec);
@@ -58,10 +58,10 @@ int snprint_tgt_wwpn(struct strbuf *, const struct path *);
 #define PROTOCOL_BUF_SIZE sizeof("scsi:unspec")
 int snprint_path_protocol(struct strbuf *, const struct path *);
 
-void _print_multipath_topology (const struct gen_multipath * gmp,
+void print_multipath_topology__ (const struct gen_multipath * gmp,
 				int verbosity);
 #define print_multipath_topology(mpp, v) \
-	_print_multipath_topology(dm_multipath_to_gen(mpp), v)
+	print_multipath_topology__(dm_multipath_to_gen(mpp), v)
 
 void print_all_paths (vector pathvec, int banner);
 
-- 
2.46.0

