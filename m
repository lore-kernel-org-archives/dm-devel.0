Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C452F2F2604
	for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769185029; cv=none; b=cK2cgFPPkeKia+8gmidHswuyB/eo8DXJulK9X2AJrG04mxUmjq69StwvzvoLsFMSW30WeJ5sqYrbQ+rcsT1eh2WDlfJYmJvkyHS1r2k0F37XZ/kdRSxPswuemg9Rj/W3lZD5QDyXa1Kxd+9WRGrsBWzqIQdX8674Cw/CHhDb9+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769185029; c=relaxed/simple;
	bh=nbJa3JQ8YGysAxwDTcq+13cYv0FPt1KYgwxWB0Yo5zA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qIbpatoxNXsbbCIiv7csqEUEFiMk4KhnidjNNf66a1G9K2FbwczyTVf6czXfmlAyvlD+hlb21KS2j35B7ONLi2CO7kX3YvLUXC6Wpj9hXkwfNRWUTq+7HnjrJkXmLB8fWGj9Pye9XyabJF5QuexILPDMA1QQr3HC8Mx1GDrJKes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvTOF+eU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvTOF+eU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769185026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afoXArO+XWTJyzsoOKc4uTxqnzUsR1b4tnwkzr0xN3c=;
	b=cvTOF+eU5X7HCa56rn/ye+ul7eBEEBZNXjNEM9gPNHaRDDgrvgYdbMVOiciYJ6CSCaC7AX
	OaYE731pD6d78E5tbhuZL7CDiDGbxqdjx4ASyrVaWEabv5wF1J16+XHLpYEzPQUaCRqKFk
	36dwtYGWQAUIjFCUcSTJhQkg7fhFHbY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-3Rod1OQnPA-3l2HvUKcfIg-1; Fri,
 23 Jan 2026 11:17:05 -0500
X-MC-Unique: 3Rod1OQnPA-3l2HvUKcfIg-1
X-Mimecast-MFC-AGG-ID: 3Rod1OQnPA-3l2HvUKcfIg_1769185024
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D5D619373E2;
	Fri, 23 Jan 2026 16:17:03 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22CE51958DC1;
	Fri, 23 Jan 2026 16:17:00 +0000 (UTC)
Date: Fri, 23 Jan 2026 17:16:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    yangerkun@huawei.com, lilingfeng3@huawei.com
Subject: Re: [PATCH] dm: pass origin bio's bdev to bio_alloc_clone
In-Reply-To: <bb49f820-473a-a951-60b0-32dcd8fb0110@huawei.com>
Message-ID: <b3731751-c286-f61e-95ab-c59f9aba98d0@redhat.com>
References: <20260116120744.908987-1-chengzhihao1@huawei.com> <bb49f820-473a-a951-60b0-32dcd8fb0110@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1508282898-1769185023=:900946"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1508282898-1769185023=:900946
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8BIT



On Fri, 23 Jan 2026, Zhihao Cheng wrote:

> ÔÚ 2026/1/16 20:07, Zhihao Cheng Ð´µÀ:
> 
> friendly ping

Hi

I find it quite hacky to set bi_bdev and overwrite it later. I came up 
with this patch that clones the control group association explictely, it 
fixes your testcase. Please test it and report if it works for you.

Mikulas


dm: use bio_clone_blkg_association

The origin bio carries blk-cgroup information which could be set from
foreground(task_css(css) - wbc->wb->blkcg_css), so the blkcg won't
control buffer io since commit ca522482e3eaf ("dm: pass NULL bdev to
bio_alloc_clone"). The synchronous io is still under control by blkcg,
because 'bio->bi_blkg' is set by io submitting task which has been added
into 'cgroup.procs'.

Fix it by using bio_clone_blkg_association when submitting a cloned bio.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220985
Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2026-01-06 15:55:41.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2026-01-23 17:07:50.000000000 +0100
@@ -1364,6 +1364,8 @@ void dm_submit_bio_remap(struct bio *clo
 	if (!tgt_clone)
 		tgt_clone = clone;
 
+	bio_clone_blkg_association(tgt_clone, io->orig_bio);
+
 	/*
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.

---1463811712-1508282898-1769185023=:900946--

