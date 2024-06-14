Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2EF7E76D
	for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389465; cv=none; b=YtqvNNIyljbFewtMGbXBIKx+vkGJ8yZVN/4s5akOwqlvnqmL7K7Ab/11qYAis8niK0sAriCWVnelUYXxZIL2gyfPyBzCAh2+nody1j2ClU7mzvX5VhvAMyMg3oH2yic3E4t+nZXfUCm/bZW0DcYli7fr7lETDytlxSf24fsHEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389465; c=relaxed/simple;
	bh=zJqzTGjjvqWpyyNQt6Ph+2r/LUHSjUwYrr7yVaaO4PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXq4VukZigckLaOaepED7FFs0dikFJUDxFHjI2e1qOpHludKmgj/3knPRjtzIvivinyCDJoXS7mKTX1qHWj64SQGvGPRNNI0txE2JX1AlwdimrnPWy0h9CyNGeYFG+FbwioZY4s93u6V+pzVRwiske6ku83Tne9Fo/fTlQHSDFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2BvAk34; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2BvAk34"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718389462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Mp44ZIQ3eijZtwlEnZ8brdG51OGsA0T6XxB9AYc6pI=;
	b=U2BvAk34y3moq814U/Jnv6ipdbegJpeeNmuAZ2pRHlQdgLnrW4u2xI50Ut9PJaSCIcN7Jq
	LkQZruVlYUQOVksUymiO4jbzdFlNM0jAYMTv+6omzQYa8ru3absGdY4xqsY2UEa28sC4mh
	VQgN01E9rUW9MtMvxuqqDQjzhqVaHSU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-XXmgAenlP2O6QfcPjYU2Dg-1; Fri,
 14 Jun 2024 14:24:16 -0400
X-MC-Unique: XXmgAenlP2O6QfcPjYU2Dg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AAB8195609E;
	Fri, 14 Jun 2024 18:24:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 867181954AC0;
	Fri, 14 Jun 2024 18:24:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45EIODXK952186
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Jun 2024 14:24:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45EIODk0952185;
	Fri, 14 Jun 2024 14:24:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/3] dm io: don't call the async_io notify.fn on invalid num_regions
Date: Fri, 14 Jun 2024 14:24:11 -0400
Message-ID: <20240614182412.952166-3-bmarzins@redhat.com>
In-Reply-To: <20240614182412.952166-1-bmarzins@redhat.com>
References: <20240614182412.952166-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If dm_io() returned an error, callers that set a notify.fn and wanted it
called on an error need to check the return value and call notify.fn
themselves if it was -EINVAL but not if it was -EIO. None of them do
this (granted, all the existing async_io users of dm_io call it in a way
that is guaranteed to not return an error).

Simplify the interface by never calling the notify.fn if dm_io returns
an error. This works with the existing dm_io callers which check for an
error and handle it using the same methods as the notify.fn.

This also allows us to move the now equivalent num_regions checks out of
sync_io() and async_io() and into dm_io() itself. Additionally, change
async_io() into a void function, since it can no longer fail.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-io.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3333943fe288..329a85a12061 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -431,11 +431,6 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	struct io *io;
 	struct sync_io sio;
 
-	if (num_regions > 1 && !op_is_write(opf)) {
-		WARN_ON(1);
-		return -EIO;
-	}
-
 	init_completion(&sio.wait);
 
 	io = mempool_alloc(&client->pool, GFP_NOIO);
@@ -458,19 +453,13 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	return sio.error_bits ? -EIO : 0;
 }
 
-static int async_io(struct dm_io_client *client, unsigned int num_regions,
-		    struct dm_io_region *where, blk_opf_t opf,
-		    struct dpages *dp, io_notify_fn fn, void *context,
-		    unsigned short ioprio)
+static void async_io(struct dm_io_client *client, unsigned int num_regions,
+		     struct dm_io_region *where, blk_opf_t opf,
+		     struct dpages *dp, io_notify_fn fn, void *context,
+		     unsigned short ioprio)
 {
 	struct io *io;
 
-	if (num_regions > 1 && !op_is_write(opf)) {
-		WARN_ON(1);
-		fn(1, context);
-		return -EIO;
-	}
-
 	io = mempool_alloc(&client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
@@ -482,7 +471,6 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
 	dispatch_io(opf, num_regions, where, dp, io, 0, ioprio);
-	return 0;
 }
 
 static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
@@ -529,6 +517,11 @@ int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
 	int r;
 	struct dpages dp;
 
+	if (num_regions > 1 && !op_is_write(io_req->bi_opf)) {
+		WARN_ON(1);
+		return -EIO;
+	}
+
 	r = dp_init(io_req, &dp, (unsigned long)where->count << SECTOR_SHIFT);
 	if (r)
 		return r;
@@ -537,9 +530,9 @@ int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
 		return sync_io(io_req->client, num_regions, where,
 			       io_req->bi_opf, &dp, sync_error_bits, ioprio);
 
-	return async_io(io_req->client, num_regions, where,
-			io_req->bi_opf, &dp, io_req->notify.fn,
-			io_req->notify.context, ioprio);
+	async_io(io_req->client, num_regions, where, io_req->bi_opf, &dp,
+		 io_req->notify.fn, io_req->notify.context, ioprio);
+	return 0;
 }
 EXPORT_SYMBOL(dm_io);
 
-- 
2.45.0

