Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CEC30F922
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006504; cv=none; b=lTQVVn+OJfCtC6dZrNTzi1kJ5WFmwgXCTRk7SCu+rAbfyoUl7x5CKJ6eSQ1I/F1CJyoS1S6Q/PoTI9NKW9EtmP5EcI9lRjRrHxe9xdtYW5E38kc3VI8HmsW3a2t7YYLSGTkr2t4DKI/poMsg39Fy9RHcLhlE1X49bf/GeIL639k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006504; c=relaxed/simple;
	bh=G7ncWxSeAu16OSVvi6lGaIFaRD+LOXT7VG+xBL74pbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIb8QfTSCQvtxPOrT7rvfilxdqBmkjiQ0JVwKCmwwQraRTFUvXq7H1wPVNfQ/e4zbK0WlPbxXKkFJ1MneiPZ50wIAYnpENa++IYB/zEdpsnMbph2DGskGd+1M9LxWtKMm3cwfjIct0wmoy272HqCes4qgUQwX2B9FO8qVbit2sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cY1qxKXg; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cY1qxKXg"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b79af62d36bso195156066b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006500; x=1766611300; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eR4ITPI+17yEZP4GFvNgW/GF5JhZ5vePoVq5qn5Wgs=;
        b=cY1qxKXgsMaCRzs25pv7onjqaKD4WTaWNUki3O7eKTADE1jtfWfGNNwGjle5TPEkqE
         9wBddc+ZQOfmAhh+LsGOT1VsAfO6wq4ngoWtkNUkk2uChQ5cOc1q3QKe7eNsnm/5apu1
         IkEkCFKxd2IaMARliIBUehMs5zcpzebmuCvZCsH1Rqsjd2A7uzebVvIyNoKsiGgg7cwF
         oGE/pq7R6hJG5fpYM3pI0QcKywD73AjvxA6e/2XI13XzXMbJjkpgUSD5Fj3RX0S/YrCO
         kFoZDlZk53DFMQw5nMGuxpTTttp13+LIy2HZCJOL3lbCSELUA0KAJAEWk7hBmSOMRRm/
         sFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006500; x=1766611300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4eR4ITPI+17yEZP4GFvNgW/GF5JhZ5vePoVq5qn5Wgs=;
        b=X//6IFuuR9wjK0iMYdeZX5PuybWAYauBFvIos1bnXgfI2XZRdjGzm00V6rfbmoIzbt
         Ufo0/MoAu2Im/ZWURd9Z9oNBlugBXXViMMgmHD9ONjUBpamjhjwIyH1d6w6Y3TVMPXy9
         wCLxgMJnXQ20+a93prM7ov96/ts7sU8SGb9SrCDcHj2jQv9/FZUa75YdTMd10Lct8obq
         NxboByzbyYalSoG8/V9gLaWN3tw1wQAU0/VbrWvg3P/SBiXymCZdYcBxDh5cqPWf5z1m
         7n/h/0sLnxe2S5ZSjvGGcKCdJuGa+xrra38HB0EQk/3cwoR2Yobx4nDZVfMQfBfC3b7W
         Utfw==
X-Gm-Message-State: AOJu0YxuKZPx7MmldX2Zmv4Uev8klESGmQn/xtAzMeF9KBtEoe/FveqB
	uwXj5oga48I/HN1977JvNskd0LPP3ovInRyMhzL7O8BOcmrSHjazhgmNjJr0ReoOy8o=
X-Gm-Gg: AY/fxX7r1RFYXlM+bZG9b4Y0KmSod7FcBj+gCCyrj8jXgFEaOJj5uPmcACb9r8eJP+6
	b9tBZm6xOFy81l8IRhRiHo9N2LSmRLjhPGYTF+B7X/UqOZ8J9KWak5w1byw6fwXJvvHzDPrRQO2
	kWOYTLmZ/lpR2ns/YqndWgPLU43MG7cW3FdZfyGrn2FOKfH8TrSXQ0WZfOmhxYOzqGMfL/JBYSe
	y7N0I+Hog+U5UVFqw9G7QI03RoEPx3NNUWCkUKu5w/lhroOMUFuUgsRK5LSPqJzoc8X4Lei+fhp
	65MTJloAw7LNFjTwtwvJXNnL9kukShi2nnyZMKX4WUx6AQn26Tt8q91O1naXpyTQeuDXje7INYl
	1TGsZFKGvGDb3aXqBwRttbaM9ORyr9MUIg+F3MtNbYMqqdVu6N8IKy4PSuX+2KKvJXoB8WV0yQK
	NpmruTaKHlIdoOhM3rlD0ecAqZ7uZPcY2JiiS48qxrU2wn1ANL3punu9pW6Uw3Uqq8eITtYF3xy
	w==
X-Google-Smtp-Source: AGHT+IFZYWZAtud48+S28Hn8SyFmwCJhHATLlUMEDvVlsZNab1tI5lD78QjKGq/io1F/JwPQPtew0g==
X-Received: by 2002:a17:906:c115:b0:b77:1166:7d63 with SMTP id a640c23a62f3a-b7d238c34f1mr2083202266b.40.1766006500337;
        Wed, 17 Dec 2025 13:21:40 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8022f952e3sm29353366b.7.2025.12.17.13.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:39 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 17/21] libmpathutil: use union for bitfield
Date: Wed, 17 Dec 2025 22:21:09 +0100
Message-ID: <20251217212113.234959-18-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
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

Fix this by using a union

Fixes: 9a2f173 ("libmpathutil: change STATIC_BITFIELD to BITFIELD")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/util.c       |  8 ++++----
 libmpathutil/util.h       | 41 +++++++++++++++++++++++----------------
 libmultipath/configure.c  |  4 ++--
 libmultipath/pgpolicies.c |  2 +-
 tests/util.c              | 10 +++++-----
 5 files changed, 36 insertions(+), 29 deletions(-)

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
index 3799fd4..1ec6a46 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -86,29 +86,36 @@ typedef unsigned int bitfield_t;
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
+ * gcc 4.9.2 (Debian Jessie) raises an error if the initializer for
+ * .__len comes first. Thus put .__bits first.
+ */
+#define BITFIELD(name, length)						\
+	union bitfield __storage_for__ ## name = {			\
+		.__bits = { 0 },					\
+		.__len = (length),					\
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
@@ -118,7 +125,7 @@ static inline bool is_bit_set_in_bitfield(unsigned int bit,
 		  (1ULL << (bit % bits_per_slot)));
 }
 
-static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
+static inline void set_bit_in_bitfield(unsigned int bit, union bitfield *bf)
 {
 	if (bit >= bf->len) {
 		log_bitfield_overflow(bit, bf->len);
@@ -127,7 +134,7 @@ static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 	bf->bits[bit / bits_per_slot] |= (1ULL << (bit % bits_per_slot));
 }
 
-static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
+static inline void clear_bit_in_bitfield(unsigned int bit, union bitfield *bf)
 {
 	if (bit >= bf->len) {
 		log_bitfield_overflow(bit, bf->len);
@@ -146,5 +153,5 @@ static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 void cleanup_charp(char **p);
 void cleanup_ucharp(unsigned char **p);
 void cleanup_udev_device(struct udev_device **udd);
-void cleanup_bitfield(struct bitfield **p);
+void cleanup_bitfield(union bitfield **p);
 #endif /* UTIL_H_INCLUDED */
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a8e18a2..41b6a9f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -440,7 +440,7 @@ static int pgcmp(struct multipath *mpp, struct multipath *cmpp)
 	int i, j;
 	struct pathgroup *pgp, *cpgp;
 	BITFIELD(bf, bits_per_slot);
-	struct bitfield *bf__  __attribute__((cleanup(cleanup_bitfield))) = NULL;
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

