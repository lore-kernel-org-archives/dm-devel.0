Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8056C1A3179
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817150; cv=none; b=hQmE7eKDp/cXUKGp1jnfLax6o3OEtQHgnXlwd4Htj9pwr7pMg+I58xZ4P+AJ2neOXDgbWZXVQu164yGGwtXUbxSkx0oTv8c78IMnpVGt7lhs3jDJ3EO/OPzdYXqLBZtaPnPUrQJzcAcFfiuiXD21DwuOpu4RtvS0eWY+zYmttGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817150; c=relaxed/simple;
	bh=4YrHv7YdQmXKM43wUAvOqKYG81vXnQT3wzLk2t/vubg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sg410zblyeyoelVlccXQCcxCqlUYhn23D61Aq9MM2EW/2VnYcuuhVSg3i0h+30VPFos0dNWnN98ObkGImPJ4g5V/D+tI++WBbswf1hvTbis0h1PeFlIXevQsffTOzrSIWTEt44+fiNAWnxA1GrvJ53y29MJYwp/MG36wc5HaR8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TjxJrBGc; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TjxJrBGc"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64d4d8b3ad7so3806316a12.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817143; x=1768421943; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGyIdUPsR4Q2fcO3tH+2Thj0aXxfVcDysfZX6A2zKW0=;
        b=TjxJrBGc/YGn3tX0wAzX4acciMXCpkh0S8U0yqHvX1UhGk8Du0Aazb+L2LG+7T8GZz
         tv8cvvVVBEuAoiLnVNozEeniI5l8i0STpdUWVwYZi7fvZXrsgvBJKqJqh/meCrRpj5bj
         KEW665/Udfkxe1Yfy6IZyWLEtq9asV7SvovyCwICF+Rk2I0qbPer6Iv0b1xeTh/j1Zhp
         doY++jnyJq82O1cWMpM/l2sIsrFhOR62phHjZXU5gi3pn9e6JCAB1KHzhQGmS2/rdwou
         3+VCWzLkgd7H2//8jeJpyRUYsutqDU2m4xjE/wmPsv5gscNj5wEaA8CH68uagWhbfVhY
         QCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817143; x=1768421943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MGyIdUPsR4Q2fcO3tH+2Thj0aXxfVcDysfZX6A2zKW0=;
        b=NX3gY2fWghoDqU42nsGtcSFCoQ7/Teq98rZHtrY2K2pt8BBURJBGSK04vCwHz4J/AT
         j7qrgEWUlUYVoHIycpQPx0yAQI9mBEnNrvAXoQjdP/+9nONmAoZVRU8pfO4x1mKwPNuO
         j+xgYRkwlnL14gK6c0N6VILXJLMpdzD2BaKUOBvFSIP0trr7X4vtP0+Wr84d0VOJn6lf
         Eh6kp1YZEFN5KnnAtXm/CzTudR4iklAEFvOUnbEb+67d+ib5VUv4zUowrTudIzsjdmwt
         CfGqTdjWxeM0eVAFEFVfMICKaoO1A9uE6VH2QNCBUXUkyq3u4m8kWj62BzMMv2/tzCwe
         VkBg==
X-Gm-Message-State: AOJu0YwhB1DBptxJWpA38KjvmGwWAnLyKlpy9dF3aE3pJEQGupuli/7t
	mzSPOSuhWhspe8mkG6LiUwY/WK7qw10spLjYSyJvn6WcKznjWcQtzyPqmQ7CUboL5kg=
X-Gm-Gg: AY/fxX7cuj2wZyoS2YIJXZX8EKyJU65C2YFgkWfobFOgFgj13AY1xyukcuOl6kHkvQN
	7Ul0YQ15JDvaUuz/26AXAB34lgwJFTWYXCHTXpUCL2Qz5p6Vn4GoM1ndGj0PsZ7N+rBRurS7TON
	vJ51DgII31UyZ4yyf5zj1ZDSskSJhUeMfOFepw5j0w/qFCFN20atv0rHfwUyNmQjJbDP/SEHyzk
	HwrvjKrFq6gvmrMlQGxMUjOmReCGqjTz0WJlbczdJU/9VqXisl9D6YImZxnfVEfh2N2mdXJ9Y0Z
	3mcPABi/8fbG/May8BCR66wuVa6U3YvMHnT7eCVQc+HvxS93ZbK4agrM4msWJ64UWi9sPxaMrwj
	p6PV3AznyN8E6jh+8FeLXWQp0hfxet3HjqlAg3Qm54htxZiBI4T+nCkmfw5p7Nf+YKuo+Bqu3Ws
	IOJgt8YxweV6PhXRGcmksQIJg/io2oD5Zu4xOqUFp/gGby7MvwGZozIZfdjZmtLKWJTFK9gFDqG
	qd05+HPJKcB
X-Google-Smtp-Source: AGHT+IFqDRBvpfocsoc8dPrbVf2lxE+KJlHidyqyJDWxLweTjaF6Ttd2e7z5UhkI7DJJt82JeiX1WQ==
X-Received: by 2002:a05:6402:1ec9:b0:641:2cf3:ec3e with SMTP id 4fb4d7f45d1cf-65097dea100mr3665125a12.11.1767817143212;
        Wed, 07 Jan 2026 12:19:03 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6507b9eb402sm5630695a12.15.2026.01.07.12.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:19:02 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 22/26] libmpathutil: use union for bitfield
Date: Wed,  7 Jan 2026 21:18:22 +0100
Message-ID: <20260107201826.323977-23-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macro BITFIELD used a cast of a pointer to a different anonymous struct
to (struct bitfield *). This violates strict aliasing rules, because the
two structs aren't compatible types in the sense of the language
specification. With -O2, gcc 15.1 generates code that makes th pgcmp()
function fail, because the compiler doesn't initialize bf->len aka
__storage_for__bf.len to 64.

The problem will show through error messages like this:

multipathd[1974208]: is_bit_set_in_bitfield: bitfield overflow: 1 >= 0

Fix this by using a union.

The "length" argument to BITFIELD has no effect any more. Remove it.
BITFIELD will now always have space for bits_per_slot bits (usually
64 on modern 64-bit distros).

Introduce BUILD_BUG_ON and use it in ordert to make sure static bit fields
are large enough.

Fixes: 9a2f173 ("libmpathutil: change STATIC_BITFIELD to BITFIELD")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/util.c       |  8 +++----
 libmpathutil/util.h       | 47 +++++++++++++++++++++++++--------------
 libmultipath/configure.c  |  6 ++---
 libmultipath/discovery.c  |  4 +++-
 libmultipath/pgpolicies.c |  2 +-
 tests/util.c              | 10 ++++-----
 6 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 37412c6..5e45750 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -337,15 +337,15 @@ void cleanup_fclose(void *p)
 		fclose(p);
 }
 
-void cleanup_bitfield(struct bitfield **p)
+void cleanup_bitfield(union bitfield **p)
 {
 	free(*p);
 }
 
-struct bitfield *alloc_bitfield(unsigned int maxbit)
+union bitfield *alloc_bitfield(unsigned int maxbit)
 {
 	unsigned int n;
-	struct bitfield *bf;
+	union bitfield *bf;
 
 	if (maxbit == 0) {
 		errno = EINVAL;
@@ -353,7 +353,7 @@ struct bitfield *alloc_bitfield(unsigned int maxbit)
 	}
 
 	n = (maxbit - 1) / bits_per_slot + 1;
-	bf = calloc(1, sizeof(struct bitfield) + n * sizeof(bitfield_t));
+	bf = calloc(1, sizeof(union bitfield) + (n - 1) * sizeof(bitfield_t));
 	if (bf)
 		bf->len = maxbit;
 	return bf;
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index 3799fd4..d2a6c52 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -16,6 +16,8 @@
 #define __GLIBC_PREREQ(x, y) 0
 #endif
 
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+
 size_t strchop(char *);
 
 const char *libmp_basename(const char *filename);
@@ -86,29 +88,40 @@ typedef unsigned int bitfield_t;
 #endif
 #define bits_per_slot (sizeof(bitfield_t) * CHAR_BIT)
 
-struct bitfield {
-	unsigned int len;
-	bitfield_t bits[];
+union bitfield {
+	struct {
+		unsigned int len;
+		bitfield_t bits[];
+	};
+	/* for initialization in the BITFIELD macro */
+	struct {
+		unsigned int __len;
+		bitfield_t __bits[1];
+	};
 };
 
-#define BITFIELD(name, length)					\
-	struct {							\
-		unsigned int len;					\
-		bitfield_t bits[((length) - 1) / bits_per_slot + 1];	\
-	} __storage_for__ ## name = {					\
-		.len = (length),					\
-		.bits = { 0, },						\
+/*
+ * BITFIELD: define a static bitfield of length bits_per_slot
+ * (aka 64 on 64-bit architectures).
+ * gcc 4.9.2 (Debian Jessie) raises an error if the initializer for
+ * .__len comes first. Thus put .__bits first.
+ * Use e.g. BUILD_BUG_ON() to make sure the bitfield size is sufficient
+ * to hold the number of bits required.
+ */
+#define BITFIELD(name)							\
+	union bitfield __storage_for__ ## name = {			\
+		.__bits = { 0 },					\
+		.__len = (bits_per_slot),				\
 	}; \
-	struct bitfield *name = (struct bitfield *)& __storage_for__ ## name
+	union bitfield *name = & __storage_for__ ## name
 
-struct bitfield *alloc_bitfield(unsigned int maxbit);
+union bitfield *alloc_bitfield(unsigned int maxbit);
 
 void log_bitfield_overflow__(const char *f, unsigned int bit, unsigned int len);
 #define log_bitfield_overflow(bit, len) \
 	log_bitfield_overflow__(__func__, bit, len)
 
-static inline bool is_bit_set_in_bitfield(unsigned int bit,
-				       const struct bitfield *bf)
+static inline bool is_bit_set_in_bitfield(unsigned int bit, const union bitfield *bf)
 {
 	if (bit >= bf->len) {
 		log_bitfield_overflow(bit, bf->len);
@@ -118,7 +131,7 @@ static inline bool is_bit_set_in_bitfield(unsigned int bit,
 		  (1ULL << (bit % bits_per_slot)));
 }
 
-static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
+static inline void set_bit_in_bitfield(unsigned int bit, union bitfield *bf)
 {
 	if (bit >= bf->len) {
 		log_bitfield_overflow(bit, bf->len);
@@ -127,7 +140,7 @@ static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 	bf->bits[bit / bits_per_slot] |= (1ULL << (bit % bits_per_slot));
 }
 
-static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
+static inline void clear_bit_in_bitfield(unsigned int bit, union bitfield *bf)
 {
 	if (bit >= bf->len) {
 		log_bitfield_overflow(bit, bf->len);
@@ -146,5 +159,5 @@ static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 void cleanup_charp(char **p);
 void cleanup_ucharp(unsigned char **p);
 void cleanup_udev_device(struct udev_device **udd);
-void cleanup_bitfield(struct bitfield **p);
+void cleanup_bitfield(union bitfield **p);
 #endif /* UTIL_H_INCLUDED */
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a8e18a2..b5f1bab 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -439,8 +439,8 @@ static int pgcmp(struct multipath *mpp, struct multipath *cmpp)
 {
 	int i, j;
 	struct pathgroup *pgp, *cpgp;
-	BITFIELD(bf, bits_per_slot);
-	struct bitfield *bf__  __attribute__((cleanup(cleanup_bitfield))) = NULL;
+	BITFIELD(bf);
+	union bitfield *bf__ __attribute__((cleanup(cleanup_bitfield))) = NULL;
 
 	if (VECTOR_SIZE(mpp->pg) != VECTOR_SIZE(cmpp->pg))
 		return 1;
@@ -1049,7 +1049,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 	vector newmp;
 	struct config *conf = NULL;
 	int allow_queueing;
-	struct bitfield *size_mismatch_seen;
+	union bitfield *size_mismatch_seen;
 	struct multipath * cmpp;
 
 	/* ignore refwwid if it's empty */
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 85ea1aa..72e64da 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -880,10 +880,12 @@ sysfs_set_nexus_loss_tmo(struct path *pp)
 static void
 scsi_tmo_error_msg(struct path *pp)
 {
-	static BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
+	static BITFIELD(bf);
 	STRBUF_ON_STACK(proto_buf);
 	unsigned int proto_id = bus_protocol_id(pp);
 
+	/* make sure the bitfield is large enough */
+	BUILD_BUG_ON((LAST_BUS_PROTOCOL_ID + 1) > bits_per_slot);
 	snprint_path_protocol(&proto_buf, pp);
 	condlog(2, "%s: setting scsi timeouts is unsupported for protocol %s",
 		pp->dev, get_strbuf_str(&proto_buf));
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 2e1a543..57b7485 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -201,7 +201,7 @@ int group_by_match(struct multipath * mp, vector paths,
 		   bool (*path_match_fn)(struct path *, struct path *))
 {
 	int i, j;
-	struct bitfield *bitmap;
+	union bitfield *bitmap;
 	struct path * pp;
 	struct pathgroup * pgp;
 	struct path * pp2;
diff --git a/tests/util.c b/tests/util.c
index da192ba..67d8148 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -198,7 +198,7 @@ static uint64_t maybe_swap(uint64_t v)
 
 static void test_bitmask_1(void **state)
 {
-	struct bitfield *bf;
+	union bitfield *bf;
 	uint64_t *arr;
 	int i, j, k, m, b;
 
@@ -240,7 +240,7 @@ static void test_bitmask_1(void **state)
 
 static void test_bitmask_2(void **state)
 {
-	struct bitfield *bf;
+	union bitfield *bf;
 	uint64_t *arr;
 	int i, j, k, m, b;
 
@@ -307,7 +307,7 @@ static void test_bitmask_2(void **state)
  */
 static void test_bitmask_len_0(void **state)
 {
-	struct bitfield *bf;
+	union bitfield *bf;
 
 	bf = alloc_bitfield(0);
 	assert_null(bf);
@@ -329,7 +329,7 @@ static unsigned int maybe_swap_idx(unsigned int i)
 
 static void _test_bitmask_small(unsigned int n)
 {
-	struct bitfield *bf;
+	union bitfield *bf;
 	uint32_t *arr;
 	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
 
@@ -378,7 +378,7 @@ static void _test_bitmask_small(unsigned int n)
 
 static void _test_bitmask_small_2(unsigned int n)
 {
-	struct bitfield *bf;
+	union bitfield *bf;
 	uint32_t *arr;
 	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
 
-- 
2.52.0

