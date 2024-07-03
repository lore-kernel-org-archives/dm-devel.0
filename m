Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF41E4A9
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 12:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720010808; cv=none; b=b+fytV+DJL47jucAO7C5iimMzMfb60WBOn69cR1YueAAEV0j2GZgO0hNrto3RfMqho5SvhcckRXPvHL6ZRZ6vV+SlBgtQs15o0ibAegqwBXFntt78T182WPxD/2VDr57i2yqFzpN161S9h2gTff1+eCklsXANaX//+lfZPqQhRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720010808; c=relaxed/simple;
	bh=4AQWktVNQvPlNOlbazAPK9wCwNq/T/gpOjdgXDZcp60=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=iAFJpwG0mUuenbJND1iqjyl/HT7f0/7IaICaFcJU7jBBdetazJL26+30iTTgTlPVL4M+oLaO+dQE9wrB0zMPFX/gd0y0DZI1PC1jw2i/hpy3g1JhQtLwbxNpKA6Hi2/xah4B7ePUikJXaJEqAB0urF+zI7p2nfc52LooVnbYP4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=colaRefo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="colaRefo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720010806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wuqjlF+DSXAhjsVMLnUNreQQa3PiyD6boPtrhqO0X5Q=;
	b=colaRefoxb6d4a5diBYSDXt5trxVnvLkEHeSAjVqthpZXKZHQoHJ2sFIzDQbpX8veWOBtp
	Tyz7NH5ya0KWoJJ+QIYR/xqfyvM2yOkrYKzd0AnJabKnURHVAZWjOikFRsi/stutHGdD37
	Ngl2jA5W+HpBk9bjSm0PsRlWsBD7Y0Q=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-4LOxojnhNHGYELJ_L0Id6w-1; Wed,
 03 Jul 2024 08:46:44 -0400
X-MC-Unique: 4LOxojnhNHGYELJ_L0Id6w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1D231955EF0;
	Wed,  3 Jul 2024 12:46:43 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C89CC195607C;
	Wed,  3 Jul 2024 12:46:42 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id C261A30C1C14; Wed,  3 Jul 2024 12:46:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id BF8B43F7D9;
	Wed,  3 Jul 2024 14:46:41 +0200 (CEST)
Date: Wed, 3 Jul 2024 14:46:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: Laurence Oberman <loberman@redhat.com>, Ming Lei <minlei@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    Waiman Long <longman@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: [PATCH] dm-crypt: limit the size of encryption requests
Message-ID: <3e8cde12-dcd5-aff4-f3e4-23c866d3d942@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There was a performance regression reported where dm-crypt would perform
worse on new kernels than on old kernels. The reason is that the old
kernels split the bios to NVMe request size (that is usually 65536 or
131072 bytes) and the new kernels pass the big bios through dm-crypt and
split them underneath.

If a big 1MiB bio is passed to dm-crypt, dm-crypt processes it on a single 
core without parallelization and this is what causes the performance 
degradation.

This commit introduces new tunable variables
/sys/module/dm_crypt/parameters/max_read_size and
/sys/module/dm_crypt/parameters/max_write_size that specify the maximum
bio size for dm-crypt. Bios larger than this value are split, so that
they can be encrypted in parallel by multiple cores. If these variables
are '0', a default 131072 is used.

Splitting bios may cause performance regressions in other workloads - if
this happens, the user should increase the value in max_read_size and
max_write_size variables.

max_read_size:
128k	2399MiB/s
256k	2368MiB/s
512k	1986MiB/s
1024	1790MiB/s

max_write_size:
128k	1712MiB/s
256k	1651MiB/s
512k	1537MiB/s
1024k	1332MiB/s

Note that if you run dm-crypt inside a virtual machine, you may need to do 
"echo numa >/sys/module/workqueue/parameters/default_affinity_scope" to 
improve performance.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>

---
 Documentation/admin-guide/device-mapper/dm-crypt.rst |   11 ++++++
 drivers/md/dm-crypt.c                                |   32 +++++++++++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-crypt.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-crypt.rst	2024-06-29 21:26:11.000000000 +0200
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-crypt.rst	2024-06-29 21:26:11.000000000 +0200
@@ -160,6 +160,17 @@ iv_large_sectors
    The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
    if this flag is specified.
 
+
+Module parameters::
+max_read_size
+max_write_size
+- Maximum size of read or write requests. When a request larger than this size
+  is received, dm-crypt will split the request. The splitting improves
+  concurrency (the split requests could be encrypted in parallel by multiple
+  cores), but it also causes overhead. The user should tune this parameter to
+  fit the actual workload.
+
+
 Example scripts
 ===============
 LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-06-29 21:26:11.000000000 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2024-07-01 17:42:49.000000000 +0200
@@ -241,6 +241,31 @@ static unsigned int dm_crypt_clients_n;
 static volatile unsigned long dm_crypt_pages_per_client;
 #define DM_CRYPT_MEMORY_PERCENT			2
 #define DM_CRYPT_MIN_PAGES_PER_CLIENT		(BIO_MAX_VECS * 16)
+#define DM_CRYPT_DEFAULT_MAX_READ_SIZE		131072
+#define DM_CRYPT_DEFAULT_MAX_WRITE_SIZE		131072
+
+static unsigned int max_read_size = 0;
+module_param(max_read_size, uint, 0644);
+MODULE_PARM_DESC(max_read_size, "Maximum size of a read request");
+static unsigned int max_write_size = 0;
+module_param(max_write_size, uint, 0644);
+MODULE_PARM_DESC(max_write_size, "Maximum size of a write request");
+static unsigned get_max_request_size(struct crypt_config *cc, bool wrt)
+{
+	unsigned val, sector_align;
+	val = !wrt ? READ_ONCE(max_read_size) : READ_ONCE(max_write_size);
+	if (likely(!val))
+		val = !wrt ? DM_CRYPT_DEFAULT_MAX_READ_SIZE : DM_CRYPT_DEFAULT_MAX_WRITE_SIZE;
+	if (wrt || cc->on_disk_tag_size) {
+		if (unlikely(val > BIO_MAX_VECS << PAGE_SHIFT))
+			val = BIO_MAX_VECS << PAGE_SHIFT;
+	}
+	sector_align = max(bdev_logical_block_size(cc->dev->bdev), (unsigned)cc->sector_size);
+	val = round_down(val, sector_align);
+	if (unlikely(!val))
+		val = sector_align;
+	return val >> SECTOR_SHIFT;
+}
 
 static void crypt_endio(struct bio *clone);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
@@ -3474,6 +3499,7 @@ static int crypt_map(struct dm_target *t
 {
 	struct dm_crypt_io *io;
 	struct crypt_config *cc = ti->private;
+	unsigned max_sectors;
 
 	/*
 	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
@@ -3492,9 +3518,9 @@ static int crypt_map(struct dm_target *t
 	/*
 	 * Check if bio is too large, split as needed.
 	 */
-	if (unlikely(bio->bi_iter.bi_size > (BIO_MAX_VECS << PAGE_SHIFT)) &&
-	    (bio_data_dir(bio) == WRITE || cc->on_disk_tag_size))
-		dm_accept_partial_bio(bio, ((BIO_MAX_VECS << PAGE_SHIFT) >> SECTOR_SHIFT));
+	max_sectors = get_max_request_size(cc, bio_data_dir(bio) == WRITE);
+	if (unlikely(bio_sectors(bio) > max_sectors))
+		dm_accept_partial_bio(bio, max_sectors);
 
 	/*
 	 * Ensure that bio is a multiple of internal sector encryption size

