Return-Path: <SRS0=zaPp=GX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AA0C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 19:00:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5425F233FE
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 19:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5425F233FE
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611169238;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=64BZufWMO1faW9DqfpO2WD1k/cMjGK9Nareh4bux3mI=;
	b=dxsKc1R6eYLeafpU8vdU/X37+FU4QVH9Bf6bYu9/rqnb0VkyVEk2wSaeNnEFCaeek952gd
	rC6Gsz+zr7URdO/idqKSN4o0L2CGDHKctugOZwR9AFTeyLEOPqlK9ewa7r+DORCURL4yzS
	1GkjQgkw+9sYbOFBa0p/h5Gq8kaLpCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-GHnpQm7sNOSD_5cMbvA8RA-1; Wed, 20 Jan 2021 14:00:35 -0500
X-MC-Unique: GHnpQm7sNOSD_5cMbvA8RA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 293731800D41;
	Wed, 20 Jan 2021 19:00:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 729E2614FF;
	Wed, 20 Jan 2021 19:00:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0112180954D;
	Wed, 20 Jan 2021 19:00:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10KJ0RdE019168 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Jan 2021 14:00:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B8676E71E; Wed, 20 Jan 2021 19:00:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D81695B4BD;
	Wed, 20 Jan 2021 19:00:23 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 10KJ0NnP017195; Wed, 20 Jan 2021 14:00:23 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 10KJ0Nlo017190; Wed, 20 Jan 2021 14:00:23 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 20 Jan 2021 14:00:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>
Message-ID: <alpine.LRH.2.02.2101201359160.16623@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Laura Abbott <laura@labbott.name>, dm-devel@redhat.com, security@kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	=?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Subject: [dm-devel] [PATCH v2 2/2] dm-integrity: introduce the "fix_hmac"
	argument
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce the "fix_hmac" arguent. It improves security of journal_mac:
- the section number is mixed to the mac, so that an attacker can't
  copy sectors from one journal section to another journal section
- the superblock is protected by journal_mac

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Daniel Glockner <dg@emlix.com>

---
 Documentation/admin-guide/device-mapper/dm-integrity.rst |   12 +
 drivers/md/dm-integrity.c                                |  104 +++++++++++++--
 2 files changed, 105 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -57,6 +57,7 @@
 #define SB_VERSION_2			2
 #define SB_VERSION_3			3
 #define SB_VERSION_4			4
+#define SB_VERSION_5			5
 #define SB_SECTORS			8
 #define MAX_SECTORS_PER_BLOCK		8
 
@@ -78,6 +79,7 @@ struct superblock {
 #define SB_FLAG_RECALCULATING		0x2
 #define SB_FLAG_DIRTY_BITMAP		0x4
 #define SB_FLAG_FIXED_PADDING		0x8
+#define SB_FLAG_FIXED_HMAC		0x10
 
 #define	JOURNAL_ENTRY_ROUNDUP		8
 
@@ -259,6 +261,7 @@ struct dm_integrity_c {
 	bool recalculate_flag;
 	bool discard;
 	bool fix_padding;
+	bool fix_hmac;
 	bool legacy_recalculate;
 
 	struct alg_spec internal_hash_alg;
@@ -389,7 +392,8 @@ static int dm_integrity_failed(struct dm
 
 static bool dm_integrity_disable_recalculate(struct dm_integrity_c *ic)
 {
-	if ((ic->internal_hash_alg.key || ic->journal_mac_alg.key) &&
+	if (!ic->fix_hmac &&
+	    (ic->internal_hash_alg.key || ic->journal_mac_alg.key) &&
 	    !ic->legacy_recalculate)
 		return true;
 	return false;
@@ -477,7 +481,9 @@ static void wraparound_section(struct dm
 
 static void sb_set_version(struct dm_integrity_c *ic)
 {
-	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING))
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC))
+		ic->sb->version = SB_VERSION_5;
+	else if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING))
 		ic->sb->version = SB_VERSION_4;
 	else if (ic->mode == 'B' || ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP))
 		ic->sb->version = SB_VERSION_3;
@@ -487,10 +493,58 @@ static void sb_set_version(struct dm_int
 		ic->sb->version = SB_VERSION_1;
 }
 
+static int sb_mac(struct dm_integrity_c *ic, bool wr)
+{
+	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
+	int r;
+	unsigned size = crypto_shash_digestsize(ic->journal_mac);
+
+	if (sizeof(struct superblock) + size > 1 << SECTOR_SHIFT) {
+		dm_integrity_io_error(ic, "digest is too long", -EINVAL);
+		return -EINVAL;
+	}
+
+	desc->tfm = ic->journal_mac;
+
+	r = crypto_shash_init(desc);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "crypto_shash_init", r);
+		return r;
+	}
+
+	r = crypto_shash_update(desc, (__u8 *)ic->sb, (1 << SECTOR_SHIFT) - size);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "crypto_shash_update", r);
+		return r;
+	}
+
+	if (likely(wr)) {
+		r = crypto_shash_final(desc, (__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_shash_final", r);
+			return r;
+		}
+	} else {
+		__u8 result[HASH_MAX_DIGESTSIZE];
+		r = crypto_shash_final(desc, result);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_shash_final", r);
+			return r;
+		}
+		if (memcmp((__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size, result, size)) {
+			dm_integrity_io_error(ic, "superblock mac", -EILSEQ);
+			return -EILSEQ;
+		}
+	}
+
+	return 0;
+}
+
 static int sync_rw_sb(struct dm_integrity_c *ic, int op, int op_flags)
 {
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
+	int r;
 
 	io_req.bi_op = op;
 	io_req.bi_op_flags = op_flags;
@@ -502,10 +556,28 @@ static int sync_rw_sb(struct dm_integrit
 	io_loc.sector = ic->start;
 	io_loc.count = SB_SECTORS;
 
-	if (op == REQ_OP_WRITE)
+	if (op == REQ_OP_WRITE) {
 		sb_set_version(ic);
+		if (ic->journal_mac && ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
+			r = sb_mac(ic, true);
+			if (unlikely(r))
+				return r;
+		}
+	}
+
+	r = dm_io(&io_req, 1, &io_loc, NULL);
+	if (unlikely(r))
+		return r;
 
-	return dm_io(&io_req, 1, &io_loc, NULL);
+	if (op == REQ_OP_READ) {
+		if (ic->mode != 'R' && ic->journal_mac && ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
+			r = sb_mac(ic, false);
+			if (unlikely(r))
+				return r;
+		}
+	}
+
+	return 0;
 }
 
 #define BITMAP_OP_TEST_ALL_SET		0
@@ -727,6 +799,15 @@ static void section_mac(struct dm_integr
 		goto err;
 	}
 
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
+		uint64_t section_le = cpu_to_le64(section);
+		r = crypto_shash_update(desc, (__u8 *)&section_le, sizeof section_le);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_shash_update", r);
+			goto err;
+		}
+	}
+
 	for (j = 0; j < ic->journal_section_entries; j++) {
 		struct journal_entry *je = access_journal_entry(ic, section, j);
 		r = crypto_shash_update(desc, (__u8 *)&je->u.sector, sizeof je->u.sector);
@@ -3149,6 +3230,7 @@ static void dm_integrity_status(struct d
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
 		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
+		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0;
 		arg_count += ic->legacy_recalculate;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
 		       ic->tag_size, ic->mode, arg_count);
@@ -3173,6 +3255,8 @@ static void dm_integrity_status(struct d
 		}
 		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0)
 			DMEMIT(" fix_padding");
+		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0)
+			DMEMIT(" fix_hmac");
 		if (ic->legacy_recalculate)
 			DMEMIT(" legacy_recalculate");
 
@@ -3310,6 +3394,9 @@ static int initialize_superblock(struct
 	if (!journal_sections)
 		journal_sections = 1;
 
+	if (ic->fix_hmac && ic->journal_mac_alg.alg_string)
+		ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_HMAC);
+
 	if (!ic->meta_dev) {
 		if (ic->fix_padding)
 			ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_PADDING);
@@ -3804,7 +3891,7 @@ static int dm_integrity_ctr(struct dm_ta
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 16, "Invalid number of feature args"},
+		{0, 17, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;
@@ -3942,7 +4029,7 @@ static int dm_integrity_ctr(struct dm_ta
 			if (r)
 				goto bad;
 		} else if (!strncmp(opt_string, "journal_mac:", strlen("journal_mac:"))) {
-			r = get_alg_and_key(opt_string, &ic->journal_mac_alg,  &ti->error,
+			r = get_alg_and_key(opt_string, &ic->journal_mac_alg, &ti->error,
 					    "Invalid journal_mac argument");
 			if (r)
 				goto bad;
@@ -3952,6 +4039,8 @@ static int dm_integrity_ctr(struct dm_ta
 			ic->discard = true;
 		} else if (!strcmp(opt_string, "fix_padding")) {
 			ic->fix_padding = true;
+		} else if (!strcmp(opt_string, "fix_hmac")) {
+			ic->fix_hmac = true;
 		} else if (!strcmp(opt_string, "legacy_recalculate")) {
 			ic->legacy_recalculate = true;
 		} else {
@@ -4110,7 +4199,7 @@ static int dm_integrity_ctr(struct dm_ta
 			should_write_sb = true;
 	}
 
-	if (!ic->sb->version || ic->sb->version > SB_VERSION_4) {
+	if (!ic->sb->version || ic->sb->version > SB_VERSION_5) {
 		r = -EINVAL;
 		ti->error = "Unknown version";
 		goto bad;
@@ -4442,7 +4531,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 6, 0},
+	.version		= {1, 7, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -186,6 +186,12 @@ fix_padding
 	space-efficient. If this option is not present, large padding is
 	used - that is for compatibility with older kernels.
 
+fix_hmac
+	Improve security of journal_mac:
+	- the section number is mixed to the mac, so that an attacker can't
+	  copy sectors from one journal section to another journal section
+	- the superblock is protected by journal_mac
+
 legacy_recalculate
 	Allow recalculating of volumes with HMAC keys. This is disabled by
 	default for security reasons - an attacker could modify the volume,

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

