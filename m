Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990792;
	b=hwWzwwdUPrJE9A6qKExHShIod7gxQ4C+5H+LIOM4vW8i2dkm5SWt67QDoEqCJXZ8e3eg
	 5NCLFKPtHfjMUSPkoMd9MBaSgJzlZ0BwToS24Vto7vWwJHC3OZW1A9S8NxF66mw29TVmG
	 Y1caz+/JxDhEdC3SwflQRK1U+reUoqot5HdYLiza/QoZMjGJUSh+vdF+7Vq8aDLdQ4Oqx
	 rQ9tp/l1Q+TRk0qItROiCLx6tlrRusvpSKDjz5tfPxE4v3T7kXuJf4kdF2+S4a7Lr4cyM
	 NRRluEM/C2sDkPa1Hn8CNwrxMZYzzrh0/YVB33U5ji4e0BMjMYHI9wtu1bfWzUBdJVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990792;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=sdoZNkGc8QTavUWio52cWw6+PQAzO+cJ/cquFtr2fbw=;
	b=DUVCT+mT4OZrCNmQAAyZFQQOSFaTJ2fIdXt0F9EEy8fNtOEYY1zoXTcRjV0YIfvU5FD0
	 Ekx4a8aTTMKdR7B09jckV727il0UHXZffzRFdA30mODTiCxd9mkPEuzj9zHpbFhrrllm4
	 xffAdoq9IqRGbpyu5dr6kWu8AOqsygvy3jstSadrDcWsx1t8EFuoFH8G2lBmvYMoANNvP
	 Nxi5lju9oyGLIIIqRAMBoo64P8ui5y6BsiqJ6OSTJPVNPDeB4n40zddKHuelhdnBRF6q3
	 8jC4m0KuVkiSpCZixjwRNN95ZvmXBR+057p6owHt9wkacu2NNn70Sw2saOYxs7Yvz7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I++gmr8c;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485F606D806
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D485F606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I++gmr8c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sdoZNkGc8QTavUWio52cWw6+PQAzO+cJ/cquFtr2fbw=;
	b=I++gmr8c47IyNii+HoJFczGNmH8eMpTBFLkF6GEr+3BHULwh9dWCFfbjlgpOJPNG0s6Bdr
	DndHUE+j220jewn3eoyu+A8j7rVTb81n5uPQj/n9dAcU1+TF2PIzHltiAPjd2noh/4d5Z6
	pUNIpDuBE1DBNNsaPQvM9poxbpxSaL0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-FMKCQ6tkMPCyk2Mha_0yoQ-1; Fri,
 06 Nov 2026 13:46:29 -0500
X-MC-Unique: FMKCQ6tkMPCyk2Mha_0yoQ-1
X-Mimecast-MFC-AGG-ID: FMKCQ6tkMPCyk2Mha_0yoQ_1793990788
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B4231955D79;
	Fri,  6 Nov 2026 18:46:28 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33B4530000E3;
	Fri,  6 Nov 2026 18:46:27 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:46:24 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm persistent data: test return value of node_copy
Message-ID: <db8878fd-43c1-d976-debd-8e1d1547e7c7@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dOZJQdVvqc3jnPz3PdBtwwwdJ-I0KcLNa9bv0teLS5A_1793990788
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There were 3 places where the return value of node_copy was not tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 3241b1d3e0aa ("dm: add persistent data library")

---
 drivers/md/persistent-data/dm-btree-remove.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-btree-remove.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-remove.c
+++ linux-2.6/drivers/md/persistent-data/dm-btree-remove.c
@@ -253,7 +253,9 @@ static int __rebalance2(struct dm_btree_
 		/*
 		 * Merge
 		 */
-		node_copy(left, right, -nr_right);
+		ret = node_copy(left, right, -nr_right);
+		if (unlikely(ret))
+			return ret;
 		left->header.nr_entries = cpu_to_le32(nr_left + nr_right);
 		delete_at(parent, r->index);
 
@@ -315,13 +317,16 @@ static int delete_center_node(struct dm_
 {
 	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
 	unsigned int shift = min(max_entries - nr_left, nr_center);
+	int ret;
 
 	if (nr_left + shift > max_entries) {
 		DMERR("node shift out of bounds");
 		return -EINVAL;
 	}
 
-	node_copy(left, center, -shift);
+	ret = node_copy(left, center, -shift);
+	if (unlikely(ret))
+		return ret;
 	left->header.nr_entries = cpu_to_le32(nr_left + shift);
 
 	if (shift != nr_center) {
@@ -333,7 +338,9 @@ static int delete_center_node(struct dm_
 		}
 
 		node_shift(right, shift);
-		node_copy(center, right, shift);
+		ret = node_copy(center, right, shift);
+		if (unlikely(ret))
+			return ret;
 		right->header.nr_entries = cpu_to_le32(nr_right + shift);
 	}
 	*key_ptr(parent, r->index) = right->keys[0];

