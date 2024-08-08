Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3EC19149D
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130840; cv=none; b=qPw1GQk/JZ3c0ctN8eCnIO30HtnNZ5CL9asHHKAEnQdNO4mRlc4VHrFFNw/VEXzHwcTolG4d3+PNeawl4QL4JdMYd2rxEv9aVBkmf51RAxLUeoBwAGDCamtElfnFZhC6QA5Z9+aCZ/5CUMPiUWylOiX2uTdk1OXf4iWwhMY7FkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130840; c=relaxed/simple;
	bh=mOKErOpkCYdiQeRbBmnaPysfFkGdTVlB2F99QRJhThw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heSEgUH8+X6Wch7rn9Xyu/qtwAyO+WdU4yQ+DwkTxK7vJTIqgd5yhyjBQItgI4t0Ex/5YDYBFFgE0AU6lrE/RfDgSaEAskHAlewSb87rsvEX/3aEFU3ecS1FT8NO926KipM9Kw0GEN3qmJGPZqCF8f+H1grqvapEBpVAMjviPqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UJ4bNDuT; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJ4bNDuT"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5b01af9b0c9so1192835a12.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130836; x=1723735636; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0jdmXW00GtjmZYAeczU5EBbaauVBFiQ2MS4xCMs25c=;
        b=UJ4bNDuTYLLgr85GZEScveNWGuQp0QMlyE0e5e02EhjI0If93zTHwR61l7LpO5v38h
         pm0ywV+LMU2mxhDQEYygx/stYIEdyuENTQBNPHAzkg63akEHRNFj5DZ50W0cyoxiF7Ny
         I+x2atG3aiQVlurGh2+R1DH99uUtkdPHilfgERouonDSxwpdBxiGw9PYju9U2JbOeosM
         dD4j0eQ8aNNB6UOdjlidB/hSzUXDvL8n4VoavspC+ajQPLoPX/5B1k2yekxRDkmHsGTJ
         H+x/JaD3irOARL4YI4BwV4npbw5mOVlC5DarEWRZzwb14/6zZm5dmTXABlYWb7gOx8jS
         QE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130836; x=1723735636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k0jdmXW00GtjmZYAeczU5EBbaauVBFiQ2MS4xCMs25c=;
        b=oUydbSe0VZcoP0wQ8pOHTU1MjYZbAYkyPSkw5KrSUTWT/rBEPqPoms8hPqTKDRjyyY
         j0vJJeRMjSosksUg7jUXASDWQTwNWg87kyQvw1HWiiCXL9vqRi/T0qOr86OubC/zBflR
         kq3K4hzLGSSlh5w8K/kzmbNnZWHaHa2+Eln/qdpj0zcLqBdeGgmvNBx5N/PtMXkmNgBC
         mQ65Uw1i4FJ58ydNpwHXNrcxeXjPgIKVv9qWftndkShuIfcciYgw4d4XZz+ffP+pG37w
         xbLEHOGke9+6pASb6FVXWxHY6ER7yba7Dq1CLTfj1X8IHYkjgtKX1nNbJp+iFT87MLkr
         IY9g==
X-Gm-Message-State: AOJu0Yz4g8Wrglmbr4IErfpjCBciTzVjZEGm7IPzfChBg7dHQm7lclql
	bYz3EV9b42r3f978XkjYqB/P38X4ETrW1zkDHMePT0GznWQyPy8w8/7dw1/vpI4=
X-Google-Smtp-Source: AGHT+IFI+H8Bwko+OGlbj/xxiDbTGRca77L7q8jHkXU1q2/9U2TIq8k+8aDR3mp1HG4gdWnfI+CPlA==
X-Received: by 2002:a05:6402:4403:b0:5bb:9aff:3e30 with SMTP id 4fb4d7f45d1cf-5bbb23e5403mr1739479a12.31.1723130835169;
        Thu, 08 Aug 2024 08:27:15 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2c40084sm726187a12.37.2024.08.08.08.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:14 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 40/41] libmpathutil: rename struct _vector to vector_s
Date: Thu,  8 Aug 2024 17:26:19 +0200
Message-ID: <20240808152620.93965-41-mwilck@suse.com>
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

This isn't strictly required by glibc, but "struct _vector" is
now the only public identifier starting with underscore, so let's
replace it, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/vector.c       |  2 +-
 libmpathutil/vector.h       |  6 +++---
 libmultipath/alias.c        |  2 +-
 libmultipath/blacklist.c    | 14 +++++++-------
 libmultipath/blacklist.h    |  8 ++++----
 libmultipath/config.c       |  8 ++++----
 libmultipath/config.h       |  6 +++---
 libmultipath/configure.c    |  2 +-
 libmultipath/configure.h    |  2 +-
 libmultipath/discovery.c    | 10 +++++-----
 libmultipath/dm-generic.c   |  8 ++++----
 libmultipath/dmparser.c     |  2 +-
 libmultipath/dmparser.h     |  2 +-
 libmultipath/foreign.c      | 12 ++++++------
 libmultipath/foreign.h      |  8 ++++----
 libmultipath/foreign/nvme.c | 20 ++++++++++----------
 libmultipath/generic.h      |  8 ++++----
 libmultipath/io_err_stat.c  |  4 ++--
 libmultipath/print.c        | 22 +++++++++++-----------
 libmultipath/print.h        | 10 +++++-----
 libmultipath/structs.c      | 12 ++++++------
 libmultipath/structs.h      | 12 ++++++------
 libmultipath/structs_vec.c  |  2 +-
 libmultipath/structs_vec.h  |  2 +-
 libmultipath/valid.c        | 10 +++++-----
 multipathd/cli.c            |  4 ++--
 multipathd/cli.h            |  4 ++--
 multipathd/cli_handlers.c   |  6 +++---
 multipathd/main.c           |  4 ++--
 tests/valid.c               |  4 ++--
 30 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 7c3ce43..5392b37 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -30,7 +30,7 @@
 vector
 vector_alloc(void)
 {
-	vector v = (vector) calloc(1, sizeof (struct _vector));
+	vector v = (vector) calloc(1, sizeof (struct vector_s));
 	return v;
 }
 
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 2df1505..8c5617b 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -26,11 +26,11 @@
 #include <stdbool.h>
 
 /* vector definition */
-struct _vector {
+struct vector_s {
 	int allocated;
 	void **slot;
 };
-typedef struct _vector *vector;
+typedef struct vector_s *vector;
 
 #define VECTOR_DEFAULT_SIZE 1
 #define VECTOR_SIZE(V)   ((V) ? ((V)->allocated) / VECTOR_DEFAULT_SIZE : 0)
@@ -53,7 +53,7 @@ typedef struct _vector *vector;
  */
 #define vector_convert(new, vec, type, conv)				\
 	({								\
-		const struct _vector *__v = (vec);			\
+		const struct vector_s *__v = (vec);			\
 		vector __t = (new);					\
 		type *__j;						\
 		int __i;						\
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 5c8ac93..ea6c7b4 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -70,7 +70,7 @@ struct binding {
  * Perhaps one day we'll implement this more efficiently, thus use
  * an abstract type.
  */
-typedef struct _vector Bindings;
+typedef struct vector_s Bindings;
 
 /* Protect global_bindings */
 static pthread_mutex_t bindings_mutex = PTHREAD_MUTEX_INITIALIZER;
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 75100b2..17e1b54 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -141,7 +141,7 @@ out:
 }
 
 static int
-match_reglist (const struct _vector *blist, const char *str)
+match_reglist (const struct vector_s *blist, const char *str)
 {
 	int i;
 	struct blentry * ble;
@@ -154,7 +154,7 @@ match_reglist (const struct _vector *blist, const char *str)
 }
 
 static int
-match_reglist_device (const struct _vector *blist, const char *vendor,
+match_reglist_device (const struct vector_s *blist, const char *vendor,
 		      const char * product)
 {
 	int i;
@@ -175,7 +175,7 @@ match_reglist_device (const struct _vector *blist, const char *vendor,
 }
 
 static int
-find_blacklist_device (const struct _vector *blist, const char *vendor,
+find_blacklist_device (const struct vector_s *blist, const char *vendor,
 		       const char *product)
 {
 	int i;
@@ -316,7 +316,7 @@ log_filter (const char *dev, const char *vendor, const char *product,
 }
 
 int
-filter_device (const struct _vector *blist, const struct _vector *elist,
+filter_device (const struct vector_s *blist, const struct vector_s *elist,
 	       const char *vendor, const char * product, const char *dev)
 {
 	int r = MATCH_NOTHING;
@@ -333,7 +333,7 @@ filter_device (const struct _vector *blist, const struct _vector *elist,
 }
 
 int
-filter_devnode (const struct _vector *blist, const struct _vector *elist,
+filter_devnode (const struct vector_s *blist, const struct vector_s *elist,
 		const char *dev)
 {
 	int r = MATCH_NOTHING;
@@ -350,7 +350,7 @@ filter_devnode (const struct _vector *blist, const struct _vector *elist,
 }
 
 int
-filter_wwid (const struct _vector *blist, const struct _vector *elist,
+filter_wwid (const struct vector_s *blist, const struct vector_s *elist,
 	     const char *wwid, const char *dev)
 {
 	int r = MATCH_NOTHING;
@@ -367,7 +367,7 @@ filter_wwid (const struct _vector *blist, const struct _vector *elist,
 }
 
 int
-filter_protocol(const struct _vector *blist, const struct _vector *elist,
+filter_protocol(const struct vector_s *blist, const struct vector_s *elist,
 		const struct path *pp)
 {
 	STRBUF_ON_STACK(buf);
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 244c59d..f32b582 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -36,16 +36,16 @@ struct blentry_device {
 
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
-int filter_devnode (const struct _vector *, const struct _vector *,
+int filter_devnode (const struct vector_s *, const struct vector_s *,
 		    const char *);
-int filter_wwid (const struct _vector *, const struct _vector *,
+int filter_wwid (const struct vector_s *, const struct vector_s *,
 		 const char *, const char *);
-int filter_device (const struct _vector *, const struct _vector *,
+int filter_device (const struct vector_s *, const struct vector_s *,
 		   const char *, const char *, const char *);
 int filter_path (const struct config *, const struct path *);
 int filter_property(const struct config *, struct udev_device *,
 		    int, const char*);
-int filter_protocol(const struct _vector *, const struct _vector *,
+int filter_protocol(const struct vector_s *, const struct vector_s *,
 		    const struct path *);
 int store_ble (vector, const char *, int);
 int set_ble_device (vector, const char *, const char *, int);
diff --git a/libmultipath/config.c b/libmultipath/config.c
index b742fb4..2d2b507 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -114,7 +114,7 @@ hwe_strmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
 }
 
 static struct hwentry *
-find_hwe_strmatch (const struct _vector *hwtable, const struct hwentry *hwe)
+find_hwe_strmatch (const struct vector_s *hwtable, const struct hwentry *hwe)
 {
 	int i;
 	struct hwentry *tmp, *ret = NULL;
@@ -179,7 +179,7 @@ static void _log_match(const char *fn, const struct hwentry *h,
 #define log_match(h, v, p, r) _log_match(__func__, (h), (v), (p), (r))
 
 int
-find_hwe (const struct _vector *hwtable,
+find_hwe (const struct vector_s *hwtable,
 	  const char * vendor, const char * product, const char * revision,
 	  vector result)
 {
@@ -222,7 +222,7 @@ struct mpentry *find_mpe(vector mptable, char *wwid)
 	return NULL;
 }
 
-const char *get_mpe_wwid(const struct _vector *mptable, const char *alias)
+const char *get_mpe_wwid(const struct vector_s *mptable, const char *alias)
 {
 	int i;
 	struct mpentry * mpe;
@@ -1089,7 +1089,7 @@ out:
 const char *get_uid_attribute_by_attrs(const struct config *conf,
 				       const char *path_dev)
 {
-	const struct _vector *uid_attrs = &conf->uid_attrs;
+	const struct vector_s *uid_attrs = &conf->uid_attrs;
 	int j;
 	char *att, *col;
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 181b78a..94cdf25 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -206,7 +206,7 @@ struct config {
 	int auto_resize;
 
 	char * selector;
-	struct _vector uid_attrs;
+	struct vector_s uid_attrs;
 	char * uid_attribute;
 	char * features;
 	char * hwhandler;
@@ -286,11 +286,11 @@ int libmultipath_init(void);
  */
 void libmultipath_exit(void);
 
-int find_hwe (const struct _vector *hwtable,
+int find_hwe (const struct vector_s *hwtable,
 	      const char * vendor, const char * product, const char *revision,
 	      vector result);
 struct mpentry * find_mpe (vector mptable, char * wwid);
-const char *get_mpe_wwid (const struct _vector *mptable, const char *alias);
+const char *get_mpe_wwid (const struct vector_s *mptable, const char *alias);
 
 struct hwentry * alloc_hwe (void);
 struct mpentry * alloc_mpe (void);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 34158e3..a725798 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -630,7 +630,7 @@ select_reload_action(struct multipath *mpp, const char *reason)
 	condlog(3, "%s: set ACT_RELOAD (%s)", mpp->alias, reason);
 }
 
-void select_action (struct multipath *mpp, const struct _vector *curmp,
+void select_action (struct multipath *mpp, const struct vector_s *curmp,
 		    int force_reload)
 {
 	struct multipath * cmpp;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index ca34442..f98a3b2 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -53,7 +53,7 @@ enum {
 struct vectors;
 
 int setup_map (struct multipath * mpp, char **params, struct vectors *vecs);
-void select_action (struct multipath *mpp, const struct _vector *curmp,
+void select_action (struct multipath *mpp, const struct vector_s *curmp,
 		    int force_reload);
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f130a5c..e94705b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1523,7 +1523,7 @@ get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
 }
 
 static int
-scsi_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
+scsi_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
@@ -1594,7 +1594,7 @@ scsi_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 }
 
 static int
-nvme_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
+nvme_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
@@ -1653,7 +1653,7 @@ nvme_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 }
 
 static int
-ccw_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
+ccw_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 {
 	struct udev_device *parent;
 	char attr_buff[NAME_SIZE];
@@ -1714,7 +1714,7 @@ ccw_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 }
 
 static int
-cciss_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
+cciss_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 {
 	const char * attr_path = NULL;
 	struct udev_device *parent;
@@ -1872,7 +1872,7 @@ path_offline (struct path * pp)
 }
 
 static int
-sysfs_pathinfo(struct path *pp, const struct _vector *hwtable)
+sysfs_pathinfo(struct path *pp, const struct vector_s *hwtable)
 {
 	int r = common_sysfs_pathinfo(pp);
 
diff --git a/libmultipath/dm-generic.c b/libmultipath/dm-generic.c
index 1b42fa0..e49f9bb 100644
--- a/libmultipath/dm-generic.c
+++ b/libmultipath/dm-generic.c
@@ -24,7 +24,7 @@
 #include "config.h"
 #include "print.h"
 
-static const struct _vector*
+static const struct vector_s*
 dm_mp_get_pgs(const struct gen_multipath *gmp)
 {
 	return vector_convert(NULL, gen_multipath_to_dm(gmp)->pg,
@@ -33,12 +33,12 @@ dm_mp_get_pgs(const struct gen_multipath *gmp)
 
 static void dm_mp_rel_pgs(__attribute__((unused))
 			  const struct gen_multipath *gmp,
-			  const struct _vector* v)
+			  const struct vector_s* v)
 {
 	vector_free_const(v);
 }
 
-static const struct _vector*
+static const struct vector_s*
 dm_pg_get_paths(const struct gen_pathgroup *gpg)
 {
 	return vector_convert(NULL, gen_pathgroup_to_dm(gpg)->paths,
@@ -47,7 +47,7 @@ dm_pg_get_paths(const struct gen_pathgroup *gpg)
 
 static void dm_mp_rel_paths(__attribute__((unused))
 			    const struct gen_pathgroup *gpg,
-			    const struct _vector* v)
+			    const struct vector_s* v)
 {
 	vector_free_const(v);
 }
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 3d85e6e..1d0506d 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -117,7 +117,7 @@ err:
  * Call update_pathvec_from_dm() after this function to make sure
  * all data structures are in a sane state.
  */
-int disassemble_map(const struct _vector *pathvec,
+int disassemble_map(const struct vector_s *pathvec,
 		    const char *params, struct multipath *mpp)
 {
 	char * word;
diff --git a/libmultipath/dmparser.h b/libmultipath/dmparser.h
index 43454c3..181967b 100644
--- a/libmultipath/dmparser.h
+++ b/libmultipath/dmparser.h
@@ -2,7 +2,7 @@
 #define DMPARSER_H_INCLUDED
 
 int assemble_map (struct multipath *, char **);
-int disassemble_map (const struct _vector *, const char *, struct multipath *);
+int disassemble_map (const struct vector_s *, const char *, struct multipath *);
 int disassemble_status (const char *, struct multipath *);
 
 #endif
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index d23439e..28d1b11 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -451,7 +451,7 @@ void foreign_path_layout(fieldwidth_t *width)
 	pthread_cleanup_push(unlock_foreigns, NULL);
 
 	vector_foreach_slot(foreigns, fgn, i) {
-		const struct _vector *vec;
+		const struct vector_s *vec;
 
 		fgn->lock(fgn->context);
 		pthread_cleanup_push(fgn->unlock, fgn->context);
@@ -482,7 +482,7 @@ void foreign_multipath_layout(fieldwidth_t *width)
 	pthread_cleanup_push(unlock_foreigns, NULL);
 
 	vector_foreach_slot(foreigns, fgn, i) {
-		const struct _vector *vec;
+		const struct vector_s *vec;
 
 		fgn->lock(fgn->context);
 		pthread_cleanup_push(fgn->unlock, fgn->context);
@@ -507,7 +507,7 @@ static int snprint_foreign_topology__(struct strbuf *buf, int verbosity,
 	size_t initial_len = get_strbuf_len(buf);
 
 	vector_foreach_slot(foreigns, fgn, i) {
-		const struct _vector *vec;
+		const struct vector_s *vec;
 		const struct gen_multipath *gm;
 		int j;
 
@@ -561,7 +561,7 @@ void print_foreign_topology(int verbosity)
 	}
 	pthread_cleanup_push(unlock_foreigns, NULL);
 	vector_foreach_slot(foreigns, fgn, i) {
-		const struct _vector *vec;
+		const struct vector_s *vec;
 
 		fgn->lock(fgn->context);
 		pthread_cleanup_push(fgn->unlock, fgn->context);
@@ -590,7 +590,7 @@ int snprint_foreign_paths(struct strbuf *buf, const char *style,
 	pthread_cleanup_push(unlock_foreigns, NULL);
 
 	vector_foreach_slot(foreigns, fgn, i) {
-		const struct _vector *vec;
+		const struct vector_s *vec;
 		const struct gen_path *gp;
 		int j, ret = 0;
 
@@ -630,7 +630,7 @@ int snprint_foreign_multipaths(struct strbuf *buf, const char *style,
 	pthread_cleanup_push(unlock_foreigns, NULL);
 
 	vector_foreach_slot(foreigns, fgn, i) {
-		const struct _vector *vec;
+		const struct vector_s *vec;
 		const struct gen_multipath *gm;
 		int j, ret = 0;
 
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 809824d..485fb2d 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -155,7 +155,7 @@ struct foreign {
 	 * @returns a vector of "struct gen_multipath*" with the map devices
 	 * belonging to this library (see generic.h).
 	 */
-	const struct _vector* (*get_multipaths)(const struct context *);
+	const struct vector_s* (*get_multipaths)(const struct context *);
 
 	/**
 	 * method: release_multipaths(context, mpvec)
@@ -165,7 +165,7 @@ struct foreign {
 	 * @param[in] mpvec the vector allocated with get_multipaths()
 	 */
 	void (*release_multipaths)(const struct context *ctx,
-				   const struct _vector* mpvec);
+				   const struct vector_s* mpvec);
 
 	/**
 	 * method: get_paths
@@ -176,7 +176,7 @@ struct foreign {
 	 * @returns a vector of "struct gen_path*" with the path devices
 	 * belonging to this library (see generic.h)
 	 */
-	const struct _vector* (*get_paths)(const struct context *);
+	const struct vector_s* (*get_paths)(const struct context *);
 
 	/**
 	 * release data structures obtained with get_multipaths (if any)
@@ -185,7 +185,7 @@ struct foreign {
 	 * @param[in] ppvec the vector allocated with get_paths()
 	 */
 	void (*release_paths)(const struct context *ctx,
-			      const struct _vector* ppvec);
+			      const struct vector_s* ppvec);
 
 	void *handle;
 	struct context *context;
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 40b88f7..0b7f4ea 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -45,7 +45,7 @@ const char *THIS;
 struct nvme_map;
 struct nvme_pathgroup {
 	struct gen_pathgroup gen;
-	struct _vector pathvec;
+	struct vector_s pathvec;
 };
 
 struct nvme_path {
@@ -66,7 +66,7 @@ struct nvme_map {
 	struct udev_device *udev;
 	struct udev_device *subsys;
 	dev_t devt;
-	struct _vector pgvec;
+	struct vector_s pgvec;
 	int nr_live;
 	int ana_supported;
 };
@@ -114,7 +114,7 @@ static void cleanup_nvme_map(struct nvme_map *map)
 	free(map);
 }
 
-static const struct _vector*
+static const struct vector_s*
 nvme_mp_get_pgs(const struct gen_multipath *gmp) {
 	const struct nvme_map *nvme = const_gen_mp_to_nvme(gmp);
 
@@ -124,7 +124,7 @@ nvme_mp_get_pgs(const struct gen_multipath *gmp) {
 
 static void
 nvme_mp_rel_pgs(__attribute__((unused)) const struct gen_multipath *gmp,
-		__attribute__((unused)) const struct _vector *v)
+		__attribute__((unused)) const struct vector_s *v)
 {
 	/* empty */
 }
@@ -201,7 +201,7 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 	return append_strbuf_str(buff, N_A);
 }
 
-static const struct _vector*
+static const struct vector_s*
 nvme_pg_get_paths(const struct gen_pathgroup *gpg) {
 	const struct nvme_pathgroup *gp = const_gen_pg_to_nvme(gpg);
 
@@ -211,7 +211,7 @@ nvme_pg_get_paths(const struct gen_pathgroup *gpg) {
 
 static void
 nvme_pg_rel_paths(__attribute__((unused)) const struct gen_pathgroup *gpg,
-		  __attribute__((unused)) const struct _vector *v)
+		  __attribute__((unused)) const struct vector_s *v)
 {
 	/* empty */
 }
@@ -916,14 +916,14 @@ void check(struct context *ctx)
 /*
  * It's safe to pass our internal pointer, this is only used under the lock.
  */
-const struct _vector *get_multipaths(const struct context *ctx)
+const struct vector_s *get_multipaths(const struct context *ctx)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	return ctx->mpvec;
 }
 
 void release_multipaths(__attribute__((unused)) const struct context *ctx,
-			__attribute__((unused)) const struct _vector *mpvec)
+			__attribute__((unused)) const struct vector_s *mpvec)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	/* NOP */
@@ -932,7 +932,7 @@ void release_multipaths(__attribute__((unused)) const struct context *ctx,
 /*
  * It's safe to pass our internal pointer, this is only used under the lock.
  */
-const struct _vector * get_paths(const struct context *ctx)
+const struct vector_s * get_paths(const struct context *ctx)
 {
 	vector paths = NULL;
 	const struct gen_multipath *gm;
@@ -948,7 +948,7 @@ const struct _vector * get_paths(const struct context *ctx)
 }
 
 void release_paths(__attribute__((unused)) const struct context *ctx,
-		   const struct _vector *mpvec)
+		   const struct vector_s *mpvec)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	vector_free_const(mpvec);
diff --git a/libmultipath/generic.h b/libmultipath/generic.h
index c8fe31c..2e4673b 100644
--- a/libmultipath/generic.h
+++ b/libmultipath/generic.h
@@ -43,7 +43,7 @@ struct gen_multipath_ops {
 	 * @param gmp: generic multipath object to act on
 	 * @returns a vector of const struct gen_pathgroup*
 	 */
-	const struct _vector* (*get_pathgroups)(const struct gen_multipath*);
+	const struct vector_s* (*get_pathgroups)(const struct gen_multipath*);
 	/**
 	 * method: rel_pathgroups(gmp, v)
 	 * free data allocated by get_pathgroups(), if any
@@ -51,7 +51,7 @@ struct gen_multipath_ops {
 	 * @param v the value returned by get_pathgroups()
 	 */
 	void (*rel_pathgroups)(const struct gen_multipath*,
-			       const struct _vector*);
+			       const struct vector_s*);
 	/**
 	 * method: snprint(gmp, buf, len, wildcard)
 	 * prints the property of the multipath map matching
@@ -89,14 +89,14 @@ struct gen_pathgroup_ops {
 	 * @param gpg: generic pathgroup object to act on
 	 * @returns a vector of const struct gen_path*
 	 */
-	const struct _vector* (*get_paths)(const struct gen_pathgroup*);
+	const struct vector_s* (*get_paths)(const struct gen_pathgroup*);
 	/**
 	 * method: rel_paths(gpg, v)
 	 * free data allocated by get_paths(), if any
 	 * @param gmp: generic pathgroup object to act on
 	 * @param v the value returned by get_paths()
 	 */
-	void (*rel_paths)(const struct gen_pathgroup*, const struct _vector*);
+	void (*rel_paths)(const struct gen_pathgroup*, const struct vector_s*);
 	/**
 	 * Method snprint()
 	 * see gen_multipath_ops->snprint() above
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 1c59445..4996c0b 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -619,9 +619,9 @@ static void process_async_ios_event(int timeout_nsecs, char *dev)
 
 static void service_paths(void)
 {
-	struct _vector _pathvec = { .allocated = 0 };
+	struct vector_s _pathvec = { .allocated = 0 };
 	/* avoid gcc warnings that &_pathvec will never be NULL in vector ops */
-	struct _vector * const tmp_pathvec = &_pathvec;
+	struct vector_s * const tmp_pathvec = &_pathvec;
 	struct io_err_stat_path *pp;
 	int i;
 
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 190c823..e536c5c 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -946,7 +946,7 @@ reset_width(fieldwidth_t *width, enum layout_reset reset, const char *header)
 	}
 }
 
-void get_path_layout__ (const struct _vector *gpvec, enum layout_reset reset,
+void get_path_layout__ (const struct vector_s *gpvec, enum layout_reset reset,
 		       fieldwidth_t *width)
 {
 	unsigned int i, j;
@@ -987,7 +987,7 @@ void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width) {
 }
 
 void
-get_multipath_layout__ (const struct _vector *gmvec, enum layout_reset reset,
+get_multipath_layout__ (const struct vector_s *gmvec, enum layout_reset reset,
 		       fieldwidth_t *width)
 {
 	unsigned int i, j;
@@ -1230,7 +1230,7 @@ void print_multipath_topology__(const struct gen_multipath *gmp, int verbosity)
 	STRBUF_ON_STACK(buff);
 	fieldwidth_t *p_width __attribute__((cleanup(cleanup_ucharp))) = NULL;
 	const struct gen_pathgroup *gpg;
-	const struct _vector *pgvec, *pathvec;
+	const struct vector_s *pgvec, *pathvec;
 	int j;
 
 	p_width = alloc_path_layout();
@@ -1271,7 +1271,7 @@ int snprint_multipath_topology__(const struct gen_multipath *gmp,
 				const fieldwidth_t *p_width)
 {
 	int j, i, rc;
-	const struct _vector *pgvec;
+	const struct vector_s *pgvec;
 	const struct gen_pathgroup *gpg;
 	STRBUF_ON_STACK(style);
 	size_t initial_len = get_strbuf_len(buff);
@@ -1304,7 +1304,7 @@ int snprint_multipath_topology__(const struct gen_multipath *gmp,
 		goto out;
 
 	vector_foreach_slot (pgvec, gpg, j) {
-		const struct _vector *pathvec;
+		const struct vector_s *pathvec;
 		struct gen_path *gp;
 		bool last_group = j + 1 == VECTOR_SIZE(pgvec);
 
@@ -1482,7 +1482,7 @@ snprint_pcentry (const struct config *conf, struct strbuf *buff,
 
 static int
 snprint_pctable (const struct config *conf, struct strbuf *buff,
-		 const struct _vector *pctable)
+		 const struct vector_s *pctable)
 {
 	int i, rc;
 	struct pcentry *pce;
@@ -1526,7 +1526,7 @@ snprint_hwentry (const struct config *conf,
 }
 
 static int snprint_hwtable(const struct config *conf, struct strbuf *buff,
-			   const struct _vector *hwtable)
+			   const struct vector_s *hwtable)
 {
 	int i, rc;
 	struct hwentry * hwe;
@@ -1552,7 +1552,7 @@ static int snprint_hwtable(const struct config *conf, struct strbuf *buff,
 
 static int
 snprint_mpentry (const struct config *conf, struct strbuf *buff,
-		 const struct mpentry * mpe, const struct _vector *mpvec)
+		 const struct mpentry * mpe, const struct vector_s *mpvec)
 {
 	int i, rc;
 	struct keyword * kw;
@@ -1587,7 +1587,7 @@ snprint_mpentry (const struct config *conf, struct strbuf *buff,
 }
 
 static int snprint_mptable(const struct config *conf, struct strbuf *buff,
-			   const struct _vector *mpvec)
+			   const struct vector_s *mpvec)
 {
 	int i, rc;
 	struct mpentry * mpe;
@@ -1909,7 +1909,7 @@ static int snprint_blacklist_except(const struct config *conf,
 }
 
 int snprint_config__(const struct config *conf, struct strbuf *buff,
-		     const struct _vector *hwtable, const struct _vector *mpvec)
+		     const struct vector_s *hwtable, const struct vector_s *mpvec)
 {
 	int rc;
 
@@ -1930,7 +1930,7 @@ int snprint_config__(const struct config *conf, struct strbuf *buff,
 }
 
 char *snprint_config(const struct config *conf, int *len,
-		     const struct _vector *hwtable, const struct _vector *mpvec)
+		     const struct vector_s *hwtable, const struct vector_s *mpvec)
 {
 	STRBUF_ON_STACK(buff);
 	char *reply;
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 9c2aea4..489f1e7 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -17,11 +17,11 @@ enum layout_reset {
 
 /* fieldwidth_t is defined in generic.h */
 fieldwidth_t *alloc_path_layout(void);
-void get_path_layout__ (const struct _vector *gpvec, enum layout_reset,
+void get_path_layout__ (const struct vector_s *gpvec, enum layout_reset,
 		       fieldwidth_t *width);
 void get_path_layout (vector pathvec, int header, fieldwidth_t *width);
 fieldwidth_t *alloc_multipath_layout(void);
-void get_multipath_layout__ (const struct _vector *gmvec, enum layout_reset,
+void get_multipath_layout__ (const struct vector_s *gmvec, enum layout_reset,
 			    fieldwidth_t *width);
 void get_multipath_layout (vector mpvec, int header, fieldwidth_t *width);
 int snprint_path_header(struct strbuf *, const char *, const fieldwidth_t *);
@@ -41,10 +41,10 @@ int snprint_multipath_topology__ (const struct gen_multipath *, struct strbuf *,
 	snprint_multipath_topology__ (dm_multipath_to_gen(mpp), buf, v, w)
 int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
 int snprint_config__(const struct config *conf, struct strbuf *buff,
-		     const struct _vector *hwtable, const struct _vector *mpvec);
+		     const struct vector_s *hwtable, const struct vector_s *mpvec);
 char *snprint_config(const struct config *conf, int *len,
-		     const struct _vector *hwtable,
-		     const struct _vector *mpvec);
+		     const struct vector_s *hwtable,
+		     const struct vector_s *mpvec);
 int snprint_multipath_map_json(struct strbuf *, const struct multipath *mpp);
 int snprint_blacklist_report(struct config *, struct strbuf *);
 int snprint_wildcards(struct strbuf *);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 232b423..61c8f32 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -433,7 +433,7 @@ store_adaptergroup(vector adapters, struct adapter_group * agp)
 }
 
 struct multipath *
-find_mp_by_minor (const struct _vector *mpvec, unsigned int minor)
+find_mp_by_minor (const struct vector_s *mpvec, unsigned int minor)
 {
 	int i;
 	struct multipath * mpp;
@@ -452,7 +452,7 @@ find_mp_by_minor (const struct _vector *mpvec, unsigned int minor)
 }
 
 struct multipath *
-find_mp_by_wwid (const struct _vector *mpvec, const char * wwid)
+find_mp_by_wwid (const struct vector_s *mpvec, const char * wwid)
 {
 	int i;
 	struct multipath * mpp;
@@ -468,7 +468,7 @@ find_mp_by_wwid (const struct _vector *mpvec, const char * wwid)
 }
 
 struct multipath *
-find_mp_by_alias (const struct _vector *mpvec, const char * alias)
+find_mp_by_alias (const struct vector_s *mpvec, const char * alias)
 {
 	int i;
 	size_t len;
@@ -491,7 +491,7 @@ find_mp_by_alias (const struct _vector *mpvec, const char * alias)
 }
 
 struct multipath *
-find_mp_by_str (const struct _vector *mpvec, const char * str)
+find_mp_by_str (const struct vector_s *mpvec, const char * str)
 {
 	int minor;
 	char dummy;
@@ -510,7 +510,7 @@ find_mp_by_str (const struct _vector *mpvec, const char * str)
 }
 
 struct path *
-find_path_by_dev (const struct _vector *pathvec, const char *dev)
+find_path_by_dev (const struct vector_s *pathvec, const char *dev)
 {
 	int i;
 	struct path * pp;
@@ -527,7 +527,7 @@ find_path_by_dev (const struct _vector *pathvec, const char *dev)
 }
 
 struct path *
-find_path_by_devt (const struct _vector *pathvec, const char * dev_t)
+find_path_by_devt (const struct vector_s *pathvec, const char * dev_t)
 {
 	int i;
 	struct path * pp;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 56fb74b..074faca 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -564,14 +564,14 @@ int store_hostgroup(vector hostgroupvec, struct host_group *hgp);
 int store_path (vector pathvec, struct path * pp);
 int add_pathgroup(struct multipath*, struct pathgroup *);
 
-struct multipath * find_mp_by_alias (const struct _vector *mp, const char *alias);
-struct multipath * find_mp_by_wwid (const struct _vector *mp, const char *wwid);
-struct multipath * find_mp_by_str (const struct _vector *mp, const char *wwid);
-struct multipath * find_mp_by_minor (const struct _vector *mp,
+struct multipath * find_mp_by_alias (const struct vector_s *mp, const char *alias);
+struct multipath * find_mp_by_wwid (const struct vector_s *mp, const char *wwid);
+struct multipath * find_mp_by_str (const struct vector_s *mp, const char *wwid);
+struct multipath * find_mp_by_minor (const struct vector_s *mp,
 				     unsigned int minor);
 
-struct path * find_path_by_devt (const struct _vector *pathvec, const char *devt);
-struct path * find_path_by_dev (const struct _vector *pathvec, const char *dev);
+struct path * find_path_by_devt (const struct vector_s *pathvec, const char *devt);
+struct path * find_path_by_dev (const struct vector_s *pathvec, const char *dev);
 struct path * first_path (const struct multipath *mpp);
 
 struct path *mp_find_path_by_devt(const struct multipath *mpp, const char *devt);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 50b17e6..5df495b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -891,7 +891,7 @@ void update_queue_mode_add_path(struct multipath *mpp)
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
 }
 
-vector get_used_hwes(const struct _vector *pathvec)
+vector get_used_hwes(const struct vector_s *pathvec)
 {
 	int i, j;
 	struct path *pp;
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 541327d..03bf8ee 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -37,6 +37,6 @@ int update_multipath_table__ (struct multipath *mpp, vector pathvec, int flags,
 			      const char *params, const char *status);
 int update_multipath_table (struct multipath *mpp, vector pathvec, int flags);
 int update_multipath_status (struct multipath *mpp);
-vector get_used_hwes(const struct _vector *pathvec);
+vector get_used_hwes(const struct vector_s *pathvec);
 
 #endif /* STRUCTS_VEC_H_INCLUDED */
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index 5df9b02..f23ee6b 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -120,7 +120,7 @@ static int check_holders(const char *syspath)
 	return sr.n;
 }
 
-static int check_all_holders(const struct _vector *parts)
+static int check_all_holders(const struct vector_s *parts)
 {
 	char syspath[PATH_MAX];
 	const char *sysname;
@@ -168,7 +168,7 @@ static void cleanup_cache(void *arg)
  * check if any of the partitions in the vector is referenced in the table.
  * Note that mnt_table_find_srcpath() also resolves mounts by symlinks.
  */
-static int check_mnt_table(const struct _vector *parts,
+static int check_mnt_table(const struct vector_s *parts,
 			   struct libmnt_table *tbl,
 			   const char *table_name)
 {
@@ -188,7 +188,7 @@ static int check_mnt_table(const struct _vector *parts,
 	return 0;
 }
 
-static int check_mountinfo(const struct _vector *parts)
+static int check_mountinfo(const struct vector_s *parts)
 {
 	static const char mountinfo[] = "/proc/self/mountinfo";
 	struct libmnt_table *tbl;
@@ -223,7 +223,7 @@ static int check_mountinfo(const struct _vector *parts)
 }
 
 #ifdef LIBMOUNT_SUPPORTS_SWAP
-static int check_swaps(const struct _vector *parts)
+static int check_swaps(const struct vector_s *parts)
 {
 	struct libmnt_table *tbl;
 	struct libmnt_cache *cache;
@@ -248,7 +248,7 @@ static int check_swaps(const struct _vector *parts)
 	return used;
 }
 #else
-static int check_swaps(const struct _vector *parts __attribute__((unused)))
+static int check_swaps(const struct vector_s *parts __attribute__((unused)))
 {
 	return 0;
 }
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 139a4c4..3458829 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -335,7 +335,7 @@ int get_cmdvec (char *cmd, vector *v, bool allow_incomplete)
 	return r;
 }
 
-uint32_t fingerprint(const struct _vector *vec)
+uint32_t fingerprint(const struct vector_s *vec)
 {
 	int i;
 	uint32_t fp = 0;
@@ -352,7 +352,7 @@ uint32_t fingerprint(const struct _vector *vec)
 	return fp;
 }
 
-struct handler *find_handler_for_cmdvec(const struct _vector *v)
+struct handler *find_handler_for_cmdvec(const struct vector_s *v)
 {
 	return find_handler(fingerprint(v));
 }
diff --git a/multipathd/cli.h b/multipathd/cli.h
index dd26a2c..9fa5014 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -142,7 +142,7 @@ int set_handler_callback__ (uint32_t fp, cli_handler *fn, bool locked);
 #define set_unlocked_handler_callback(fp, fn) set_handler_callback__(fp, fn, false)
 
 int get_cmdvec (char *cmd, vector *v, bool allow_incomplete);
-struct handler *find_handler_for_cmdvec(const struct _vector *v);
+struct handler *find_handler_for_cmdvec(const struct vector_s *v);
 void genhelp_handler (const char *cmd, int error, struct strbuf *reply);
 
 int load_keys (void);
@@ -152,7 +152,7 @@ void free_keys (vector vec);
 void free_handlers (void);
 int cli_init (void);
 void cli_exit(void);
-uint32_t fingerprint(const struct _vector *vec);
+uint32_t fingerprint(const struct vector_s *vec);
 vector get_keys(void);
 vector get_handlers(void);
 struct key *find_key (const char * str);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 2efe23f..4260354 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -33,7 +33,7 @@
 #include "cli_handlers.h"
 
 static struct path *
-find_path_by_str(const struct _vector *pathvec, const char *str,
+find_path_by_str(const struct vector_s *pathvec, const char *str,
 		  const char *action_str)
 {
 	struct path *pp;
@@ -157,8 +157,8 @@ show_map_json (struct strbuf *reply, struct multipath * mpp,
 }
 
 static int
-show_config (struct strbuf *reply, const struct _vector *hwtable,
-	     const struct _vector *mpvec)
+show_config (struct strbuf *reply, const struct vector_s *hwtable,
+	     const struct vector_s *mpvec)
 {
 	struct config *conf;
 	int rc;
diff --git a/multipathd/main.c b/multipathd/main.c
index 229b516..1b7fd04 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3140,8 +3140,8 @@ void rcu_free_config(struct rcu_head *head)
 	free_config(conf);
 }
 
-static bool reconfigure_check_uid_attrs(const struct _vector *old_attrs,
-					const struct _vector *new_attrs)
+static bool reconfigure_check_uid_attrs(const struct vector_s *old_attrs,
+					const struct vector_s *new_attrs)
 {
 	int i;
 	char *old;
diff --git a/tests/valid.c b/tests/valid.c
index cb56734..c5a1eac 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -106,14 +106,14 @@ const char *__wrap_udev_device_get_sysname(struct udev_device *udev_device)
 }
 
 /* called from pathinfo() */
-int __wrap_filter_devnode(struct config *conf, const struct _vector *elist,
+int __wrap_filter_devnode(struct config *conf, const struct vector_s *elist,
 			  const char *vendor, const char * product, const char *dev)
 {
 	return mock_type(int);
 }
 
 /* called from pathinfo() */
-int __wrap_filter_device(const struct _vector *blist, const struct _vector *elist,
+int __wrap_filter_device(const struct vector_s *blist, const struct vector_s *elist,
 	       const char *vendor, const char * product, const char *dev)
 {
 	return mock_type(int);
-- 
2.46.0

