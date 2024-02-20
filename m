Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DD777653
	for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708452716; cv=none; b=jgRP9/s2F6b+sjMJDhIPqjO14ZSI6RPooX5RswgKrlYfrFO6Fjp4aKGmbvj1yo/mkU12A6x2uATGsZ9Vz+nXjllzlEiFRQjXgFzUgh43MvVVk7mwee2VUhwegi9jhTEig+eSAMAImb3sw2Bc42kngVVxYTnDvfBVYdSN8WgI/fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708452716; c=relaxed/simple;
	bh=NMFB0ZU3ZxK+kQzhBfYC5sZy+RhM6UZv6wFPyB7Ybu4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=bxBTqJNh7Xbqtd5ZICItwGXRF9zaThX4Ld9hTeSpXk4UECSbCmy3cqKSyMAmSQLAZPR4rHRwrGqwm8rJSFg6KcGHm7AL69ykS2TC5HJ0LDZQAeXprGFVurEX/0b4ULAO+2lWRzErxPHkNzjo01iPcqnGCOzUxYl+/ha+zZUHoVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cR4Ghj3y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cR4Ghj3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708452713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=7uTFwTVLzxV93JudyiT9yfRXrXemQK9rPWhZxq+jIoQ=;
	b=cR4Ghj3yhVzWJ70maLHzpWC6qqQss1K4X2gjbrhnPyd0fwSEwD+Or1J+x2SHlRuDRzLuJx
	uTOKpcS/mKFzozYfHdf8pZ2PiQAUgAV17lf2q5sER9LzH2V8XH+kC/C6nvMUO3ztdU3LOQ
	vAqNwv8capeDzM2ZZHl8sBvHGRfTegY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-464-p69YNXaiNf-mPidtgXduFw-1; Tue,
 20 Feb 2024 13:11:51 -0500
X-MC-Unique: p69YNXaiNf-mPidtgXduFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E74D38041D1
	for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 18:11:51 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A01740C1064;
	Tue, 20 Feb 2024 18:11:51 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 33FA230C1B8F; Tue, 20 Feb 2024 18:11:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 3029C3FB4E;
	Tue, 20 Feb 2024 19:11:51 +0100 (CET)
Date: Tue, 20 Feb 2024 19:11:51 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity, dm-crypt: align "struct bvec_iter" correctly
Message-ID: <8ebe6f5b-4941-6ca8-9445-91ae36fa2f39@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

"struct bvec_iter" is defined with the __packed attribute, so it is
aligned on a single byte. On X86 (and on other architectures that support
unaligned addresses in hardware), "struct bvec_iter" is accessed using the
8-byte and 4-byte memory instructions, however these instructions are less
efficient if they operate on unaligned addresses.

(on RISC machines that don't have unaligned access in hardware, GCC
generates byte-by-byte accesses that are very inefficient - see [1])

This commit reorders the entries in "struct dm_verity_io" and "struct
convert_context", so that "struct bvec_iter" is aligned on 8 bytes.

[1] https://lore.kernel.org/all/ZcLuWUNRZadJr0tQ@fedora/T/

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c  |    4 ++--
 drivers/md/dm-verity.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2024-02-20 18:05:29.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity.h	2024-02-20 18:40:45.000000000 +0100
@@ -80,12 +80,12 @@ struct dm_verity_io {
 	/* original value of bio->bi_end_io */
 	bio_end_io_t *orig_bi_end_io;
 
+	struct bvec_iter iter;
+
 	sector_t block;
 	unsigned int n_blocks;
 	bool in_tasklet;
 
-	struct bvec_iter iter;
-
 	struct work_struct work;
 
 	char *recheck_buffer;
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-02-20 18:39:06.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2024-02-20 18:44:02.000000000 +0100
@@ -53,11 +53,11 @@
 struct convert_context {
 	struct completion restart;
 	struct bio *bio_in;
-	struct bio *bio_out;
 	struct bvec_iter iter_in;
+	struct bio *bio_out;
 	struct bvec_iter iter_out;
-	u64 cc_sector;
 	atomic_t cc_pending;
+	u64 cc_sector;
 	union {
 		struct skcipher_request *req;
 		struct aead_request *req_aead;

