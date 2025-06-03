Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4765A2F2D
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748969759; cv=none; b=qOqsx/prS2gfhWJzEJYTeyOxXTgWOEYRnNSqHybwD9QmXzk8zNLt7/1ZWDLL1NyERFq1KObzDqm2A9vvpCzG78UA93vSuvQXtN4FGIIUhBfRehzTiqUhbvYYfts/Ea37jcHuR8yoxvO9dtQqZ11xIdB0GIUvUqMrpUsxRZt2nCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748969759; c=relaxed/simple;
	bh=eTC36oasqBYW6Nakvd+zKRGJQPUZyZ4QDpmdlesHerA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=N08YMkwAC3QBE/VJuEtowY21BdGdEy9CoxA283kUVtneKS0spJ2PLImmZr5+MKhtSi+7rHXf3u/9EWztizIcQ41Tm2SC8jjR/aUAdgy0mhRZtaGRTT8nRbTk/R56OakLNXXtXLS6B6RuQ8Gx83vBuImtLjXqbnk6PGk8/yK24mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H2x5xFMM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2x5xFMM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748969756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=rBaaT4LzCKrB8KuybvT3VGVr7zzm6TKpxQklafMWol8=;
	b=H2x5xFMM+PLD1K6POx0wcprRojz8qz0FF8cYzMJpu9Uxixcx6TTugo4ro/aBBEzV+3Cc3a
	u0PR12rOZ2qbWYxuBl6uS7Nio1Ehe34QMxjW1RxoEsrWjrk86DcJrtd4JLWCt8U9YG9l7q
	GYYZmry+ZxGT0DGxYw8GYnHgMYJ5x/0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-qBy46EIZPMCeOfeE-oulLw-1; Tue,
 03 Jun 2025 12:55:55 -0400
X-MC-Unique: qBy46EIZPMCeOfeE-oulLw-1
X-Mimecast-MFC-AGG-ID: qBy46EIZPMCeOfeE-oulLw_1748969754
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1519519560AE;
	Tue,  3 Jun 2025 16:55:54 +0000 (UTC)
Received: from [10.22.80.20] (unknown [10.22.80.20])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7E8A195608D;
	Tue,  3 Jun 2025 16:55:52 +0000 (UTC)
Date: Tue, 3 Jun 2025 18:55:50 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-verity: fix a memory leak if some arguments are specified
 multiple times
Message-ID: <bfb1aefb-ccea-a252-7c52-aaa4aeaf9c56@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RrqW23BJmQLQWW_-YoVRioisi9fpK8myXqS10LA4vLM_1748969754
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If some of the arguments "check_at_most_once", "ignore_zero_blocks",
"use_fec_from_device", "root_hash_sig_key_desc" were specified more than
once on the target line, a memory leak would happen.

This commit fixes the memory leak. It also fixes error handling in
verity_verify_sig_parse_opt_args.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-fec.c        |    4 ++++
 drivers/md/dm-verity-target.c     |    8 +++++++-
 drivers/md/dm-verity-verify-sig.c |   17 +++++++++++++----
 3 files changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-fec.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.c	2025-06-02 22:25:04.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-fec.c	2025-06-02 22:25:04.000000000 +0200
@@ -593,6 +593,10 @@ int verity_fec_parse_opt_args(struct dm_
 	(*argc)--;
 
 	if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_DEV)) {
+		if (v->fec->dev) {
+			ti->error = "FEC device already specified";
+			return -EINVAL;
+		}
 		r = dm_get_device(ti, arg_value, BLK_OPEN_READ, &v->fec->dev);
 		if (r) {
 			ti->error = "FEC device lookup failed";
Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-06-02 22:25:04.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2025-06-03 18:32:01.000000000 +0200
@@ -1120,6 +1120,9 @@ static int verity_alloc_most_once(struct
 {
 	struct dm_target *ti = v->ti;
 
+	if (v->validated_blocks)
+		return 0;
+
 	/* the bitset can only handle INT_MAX blocks */
 	if (v->data_blocks > INT_MAX) {
 		ti->error = "device too large to use check_at_most_once";
@@ -1143,6 +1146,9 @@ static int verity_alloc_zero_digest(stru
 	struct dm_verity_io *io;
 	u8 *zero_data;
 
+	if (v->zero_digest)
+		return 0;
+
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
@@ -1577,7 +1583,7 @@ static int verity_ctr(struct dm_target *
 			goto bad;
 	}
 
-	/* Root hash signature is  a optional parameter*/
+	/* Root hash signature is an optional parameter */
 	r = verity_verify_root_hash(root_hash_digest_to_validate,
 				    strlen(root_hash_digest_to_validate),
 				    verify_args.sig,
Index: linux-2.6/drivers/md/dm-verity-verify-sig.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-verify-sig.c	2025-06-02 22:25:04.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-verify-sig.c	2025-06-02 22:25:04.000000000 +0200
@@ -71,9 +71,14 @@ int verity_verify_sig_parse_opt_args(str
 				     const char *arg_name)
 {
 	struct dm_target *ti = v->ti;
-	int ret = 0;
+	int ret;
 	const char *sig_key = NULL;
 
+	if (v->signature_key_desc) {
+		ti->error = DM_VERITY_VERIFY_ERR("root_hash_sig_key_desc already specified");
+		return -EINVAL;
+	}
+
 	if (!*argc) {
 		ti->error = DM_VERITY_VERIFY_ERR("Signature key not specified");
 		return -EINVAL;
@@ -83,14 +88,18 @@ int verity_verify_sig_parse_opt_args(str
 	(*argc)--;
 
 	ret = verity_verify_get_sig_from_key(sig_key, sig_opts);
-	if (ret < 0)
+	if (ret < 0) {
 		ti->error = DM_VERITY_VERIFY_ERR("Invalid key specified");
+		return ret;
+	}
 
 	v->signature_key_desc = kstrdup(sig_key, GFP_KERNEL);
-	if (!v->signature_key_desc)
+	if (!v->signature_key_desc) {
+		ti->error = DM_VERITY_VERIFY_ERR("Could not allocate memory for signature key");
 		return -ENOMEM;
+	}
 
-	return ret;
+	return 0;
 }
 
 /*

