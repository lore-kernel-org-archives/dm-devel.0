Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D92A8C1
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739828177; cv=none; b=o7o03ylqzKJwvSI5/Pmrvr0pZF9ljSoQoCu3JopwEY4YKzcMvUlRmi2v4rq0CXnUA4xBwW3a0B/qgMqW86AztAnK7N567Jleli28oN1I+yUB0eyy3ftm4mKqmT7e8PSh08T+7roXOmUguKtFGc4/OXhtCG3g1OaKBeYfNyPGAOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739828177; c=relaxed/simple;
	bh=5OllfhQCIZTqcfr2socAB1NkXxKJ/hkyLMR5cwGqldI=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=oq1Ji1bQ519/deoUnZCgi7znNcSXRK6zI3G12+vxu0l9YZoE3rnwTd5EknsArApbebd28OhsiFdquA86TeNXbzXMOT4Tc+ZbKveMWH2MX1Vecxud8bBnmCdAH5UqUTvwIczoddXTKYhErlvXuhGSchakrOcAwPT+uSwiUikTphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWgjnERW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWgjnERW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739828173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=EXFcyYXoNpFXqXe/4nM5+epe1oWMcKxMsXNCjUx4dLI=;
	b=LWgjnERW3xYHrOzp9b1jnub6VEgAyjgJ5rInV1WWWnqpJOpHeWOhP/9SgVUpWL8ZUpXulk
	8ucKVKWyrImhrpX9jDNzpGVAGMWE8bEWcgqMcL3FMQCPyM9goRYCJ2cJInrUewYWc6MJjS
	wX+BcASE/bazz/OmWsOdsh1ZDRnKJbA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-fIeRFvklMz69zyOgSMylKw-1; Mon,
 17 Feb 2025 16:36:10 -0500
X-MC-Unique: fIeRFvklMz69zyOgSMylKw-1
X-Mimecast-MFC-AGG-ID: fIeRFvklMz69zyOgSMylKw_1739828169
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AA7C1800874;
	Mon, 17 Feb 2025 21:36:09 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AFDA19560A3;
	Mon, 17 Feb 2025 21:36:05 +0000 (UTC)
Date: Mon, 17 Feb 2025 22:36:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>, 
    Sami Tolvanen <samitolvanen@google.com>
cc: Akilesh Kailash <akailash@google.com>, kernel-team@android.com, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: [PATCH v2] dm-verity: do forward error correction on metadata I/O
 errors
Message-ID: <920de20f-1d11-e6f6-e7ae-a774f5c210f0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

dm-verity: do forward error correction on metadata I/O errors

Do forward error correction if metadata I/O fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-target.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-02-10 16:24:56.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2025-02-17 16:47:37.000000000 +0100
@@ -311,7 +311,7 @@ static int verity_verify_level(struct dm
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		data = dm_bufio_get(v->bufio, hash_block, &buf);
-		if (data == NULL) {
+		if (IS_ERR_OR_NULL(data)) {
 			/*
 			 * In tasklet and the hash was not in the bufio cache.
 			 * Return early and resume execution from a work-queue
@@ -324,8 +324,24 @@ static int verity_verify_level(struct dm
 						&buf, bio->bi_ioprio);
 	}
 
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	if (IS_ERR(data)) {
+		if (skip_unverified)
+			return 1;
+		r = PTR_ERR(data);
+		data = dm_bufio_new(v->bufio, hash_block, &buf);
+		if (IS_ERR(data))
+			return r;
+		if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
+				      hash_block, data) == 0) {
+			aux = dm_bufio_get_aux_data(buf);
+			aux->hash_verified = 1;
+			goto release_ok;
+		} else {
+			dm_bufio_release(buf);
+			dm_bufio_forget(v->bufio, hash_block);
+			return r;
+		}
+	}
 
 	aux = dm_bufio_get_aux_data(buf);
 
@@ -366,6 +382,7 @@ static int verity_verify_level(struct dm
 		}
 	}
 
+release_ok:
 	data += offset;
 	memcpy(want_digest, data, v->digest_size);
 	r = 0;
@@ -1761,7 +1778,7 @@ static struct target_type verity_target
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 10, 0},
+	.version	= {1, 11, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,

