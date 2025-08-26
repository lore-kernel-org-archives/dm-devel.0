Received: from leontynka.twibright.com (leontynka.twibright.com [109.81.181.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2322DFA7;
	Tue, 26 Aug 2025 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.81.181.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218044; cv=none; b=Bw5lUWNktn87rnw9437yopUzLIJdN9IA/1afa/74afORp0GhqwMKuRi1uAVJoF9gJvNsDdSWbhhsK992C7AR2VgQs2HimeFc64vowshs3iMGchliKUBJe0BHE5FgR/AXtQHuBYgxP9jIVDtem53JL0iBqr/uVLJVBs7YLQgwm90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218044; c=relaxed/simple;
	bh=PWzBuhRiLykW9Jk2IT8JkXB/nA9MhhV+YpfUaL0mF4Y=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Z10TvJNKstavTSBwPMzPKjvid1LBBwOjdUutR229Clpu6DAjTDweB4Z4kdLJO1TWI06ioHH8K/KmiPTPCMzvurVF907IpL66eEgi3zOXwiN2iWCMrx58oU5TGDi9J5alyRiGzI7mdqkT86BPA/Lyw9cNLLluTrnI7lxCs9Um8nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; arc=none smtp.client-ip=109.81.181.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from zen ([192.168.128.17] helo=debian.vm)
	by leontynka.twibright.com with smtp (Exim 4.96)
	(envelope-from <mpatocka@redhat.com>)
	id 1uqu9S-008Vrf-0y;
	Tue, 26 Aug 2025 15:55:55 +0200
Received: by debian.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 15:55:53 +0200
Message-ID: <20250826135553.804037490@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 15:54:57 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Biggers <ebiggers@kernel.org>,
 dengler@linux.ibm.com,
 linux-s390@vger.kernel.org,
 dm-devel@lists.linux.dev,
 ifranzki@linux.ibm.com,
 agk@redhat.com,
 snitzer@kernel.org,
 gmazyland@gmail.com,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] dm-integrity: allocate the recalculate buffer with kmalloc
References: <20250826135453.012446010@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Allocate the recalculate buffer with kmalloc rather than vmalloc. This
will be needed later, for the simplification of the asynchronous hash
interface.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-21 18:22:55.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-21 18:22:55.000000000 +0200
@@ -2998,7 +2998,7 @@ static void integrity_recalc(struct work
 	unsigned recalc_sectors = RECALC_SECTORS;
 
 retry:
-	recalc_buffer = __vmalloc(recalc_sectors << SECTOR_SHIFT, GFP_NOIO);
+	recalc_buffer = kmalloc(recalc_sectors << SECTOR_SHIFT, GFP_NOIO | __GFP_NOWARN);
 	if (!recalc_buffer) {
 oom:
 		recalc_sectors >>= 1;
@@ -3012,7 +3012,7 @@ oom:
 		recalc_tags_size += ic->internal_hash_digestsize - ic->tag_size;
 	recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);
 	if (!recalc_tags) {
-		vfree(recalc_buffer);
+		kfree(recalc_buffer);
 		recalc_buffer = NULL;
 		goto oom;
 	}
@@ -3078,7 +3078,7 @@ next_chunk:
 		goto err;
 
 	io_req.bi_opf = REQ_OP_READ;
-	io_req.mem.type = DM_IO_VMA;
+	io_req.mem.type = DM_IO_KMEM;
 	io_req.mem.ptr.addr = recalc_buffer;
 	io_req.notify.fn = NULL;
 	io_req.client = ic->io;
@@ -3136,7 +3136,7 @@ unlock_ret:
 	recalc_write_super(ic);
 
 free_ret:
-	vfree(recalc_buffer);
+	kfree(recalc_buffer);
 	kvfree(recalc_tags);
 }
 

