Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC0A284B29
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155305; cv=none; b=E/vsLe91x7K+BUd75dUjLytCjD4S1eFaCUk0Ezb5TA4nkx4eO79RR+1Idx9/zr8R6GnQaTvqzGvRFEFat3ji3ansRlmoGI1wn2KZ/4gpbAu/vcpggcxWojjOqi524Uku8YZDwQu5tKZ9Fbx3FzXLHdi30SiyvdLGujuaq+f++XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155305; c=relaxed/simple;
	bh=jsH7g+ywMwjf13wl3rAsZH2LDK4ZxzoLw83R3IyMlTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9fLWj0WSE2+EouwjmZDlEsNFEBSM4aLjlAixduzvu6zNjhbleF/vEBgvmw/Xn4MSvamEV4dUIlOkAFaGcqW6iOenL/ztZiHtHSSA0gBY0nf5R+DsOCW5FzCPEejypDd/gspBYktOluhDa1y/OGIR/E0prKIhiytiiAcVp7wdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ek5qABci; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ek5qABci"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b727f452fffso473221166b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155301; x=1766760101; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRanMH1ks00YH4vMQoJjrQp5OFfxyhmA0V5smThj1ZI=;
        b=Ek5qABciu5+88XWTWdhWwfAbf3JJsvb4VT4PKAgm+cDEjpxm65mAtzXXjma5OeDEY8
         eUrzWs8i08AHQokKexks1i81/0KIYC7YaANEcMAQ/ZqXR/mmKd3+GiwPeTDM6c1dmZoe
         JCZUNHPOP8yaPD13ACKyvFnnDzxY/MQPlB9PbOgw8QFYtANIkZO+Unwqzj6felGp/6W9
         phzjR8U2azWE9b4qErTQiQYcOrcc62P76G62Of1cS43cWhmBYK9st47udNHRnOb8g9AG
         1Qun0fgfvNiSpcJdTW9W0kxagvYabkU+1W8W0XHaImSsv6gJm/fYVFzTdfwDzXMrCIJu
         zRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155301; x=1766760101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dRanMH1ks00YH4vMQoJjrQp5OFfxyhmA0V5smThj1ZI=;
        b=J1QSngBE+69xwnsO07tyfhc1EgyB0FZ7yHYCRJEH92xiyFlk+U4nXDeM9WMpqlZf5v
         cnIPBZ/RoUYCj7kyjdHCGULbIBjb0/Qb4+mxUVTqcxQoJxrigJONY+8OK1fT04nBhOon
         kmYX2++4vcmFGKIdLsMwyp1jOtlAbar/FQ4EDXf3OEpb3yw66TE+yfIBuq8etSHGhsGq
         9d1qkf4267uP6AR4/aYCugU0VGe/E4/Ak0fSTPuCggcxk4zSoWzsNhb9wS25+uxb7mx1
         RVTkI3ZDSLuTuQQvB0ERcKrKAVBxWEoQcozByoVQ1w5+2lWy2zoB9V6ZTWyxFSgd3JMM
         RZcA==
X-Gm-Message-State: AOJu0Yx0ygADn4vJtNAJDG61lwAwEGbOUGbmGY7D31yo+0ToJAy6IXrA
	MfpDYO9e4UfTMoT0pEmqD7HjWu5B00FzIzSZGus8faTgdzRGGxwvL2F6GDVsOaz3JU8=
X-Gm-Gg: AY/fxX4SKlP98NksDNIo3Gbl59YsPXwXx2wQxtShN0HHXOIYFTRQ5pkZbD2zSLnSvkc
	AhmfhKTJecliVXwADw3QqPaOeTq3kiEnT2vkqkuBArCQ2HIQIg9pOGOztkzUAi47jlpPYHJf8K9
	0k6UUyZgMWEKA5zwDziYc9pJoKesCgQYTHpwrQjIbrAK434S3EhDNaswVwhPocUFzaQJIj3fTDV
	9EaUrQsAtqjcPXdA/k/Q9v8Eq8X0s5R+pXMHwvi3OXOISDykh9LhFNz1SyrpbzBNiVXbZBUYAf1
	lGqE6GPZbyc8hgCHf2kPISd7LOS4Bet65PxcYTnjj0lgWkEH+Sd95Baul7x4sCFZh4hq711zVYN
	ekUIDeYZoh+P7yrKiB1oPCtO9MZl+OQZOOVz36C/AKEzwc/qxsIAMYl/jRP03xkqMWmHlXTmVaG
	GMDb41jHythFJyuOyJeq5oid9L/HWhx9/lt1CDA/LAU1uMP2zr3bMArbZwFdY3Kmb7IGymeiH+S
	A==
X-Google-Smtp-Source: AGHT+IH2/R3YNbr1A6nmLFS89E7nWT3oP3sVvf2cmuzer7CrB0xZ/23++eaJmoadjfFgIy3oJsYvpA==
X-Received: by 2002:a17:907:7f01:b0:b71:ea7c:e501 with SMTP id a640c23a62f3a-b80355b2523mr456289466b.4.1766155300793;
        Fri, 19 Dec 2025 06:41:40 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f37edasm241598566b.58.2025.12.19.06.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:40 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 22/26] libmpathutil: use union for bitfield
Date: Fri, 19 Dec 2025 15:41:04 +0100
Message-ID: <20251219144108.237928-23-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
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

