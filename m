Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D37482DF
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266440; cv=none; b=guU872iKNM1Hn7TAJbz2BgkG3HRDaduCwmaAKA69qpI8b+M+tLF8GCtRtaVTk6IszxmPpdnWPqqizJXhKy865S+W8y4xsV/ZKxJfoIxzNnzRT8aZPOq7ZRdgfIenVRajxZtQSZ4bZdQVKXj5hmF0TyeHVt7olhSSF+pzi3nnTF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266440; c=relaxed/simple;
	bh=su5j70Fl8pBTrXxsvHlMD/rif+lI2k2xu8Vg1+yWCgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKPbQtgUNjgZ/G6xBsbysGtmzo7IJLBYJGWmbBgje4TOFEk9jGu4pRhrL9GeYBXrC8chbXN8TOK7j/oOBJZNystj6+rRrmw+oykcSxQdLMGkkqMbFjSv8TQiVbW82ErarxONn3uhkEwWQnuu4TIoqRgEk+RSnUx0T/d6VpTLtx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAPs8st4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAPs8st4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F1W7GJP5h2A2Ki7icEEVwIjnZ2VHQmIWdbawJThAoCw=;
	b=aAPs8st4iJrM1q3LWsl8j63xnUG5jNH7WSwambAlU8HvHL1wY2Tnpppfmw88F6OIUodZ+K
	aLvOFfMaxBVtZdEWCSJoRLq4mo0jGrNFMnvCfIpO52NLG0rhJZyvuOj1ZepaOuRIVm1MRg
	+tSeIsYCxbu4vS3uERwdL3QJUgFhPFw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-e1O7sO4NPem6iGmUom3dgA-1; Thu, 29 Feb 2024 23:13:53 -0500
X-MC-Unique: e1O7sO4NPem6iGmUom3dgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B7C683B8E8;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86CB61C060AF;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 73421A15B0; Thu, 29 Feb 2024 23:13:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/5] dm vdo slab-depot: delete unnecessary check in allocate_components
Date: Thu, 29 Feb 2024 23:13:49 -0500
Message-ID: <dd5fa104de0ec6ae76531d08eeeecfd16fd22d1e.1709265967.git.msakai@redhat.com>
In-Reply-To: <cover.1709265967.git.msakai@redhat.com>
References: <cover.1709265967.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Dan Carpenter <dan.carpenter@linaro.org>

This is a duplicate check so it can't be true.  Delete it.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/slab-depot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 5fa7e0838b32..e10c3db8e665 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4106,9 +4106,6 @@ static int allocate_components(struct slab_depot *depot,
 		};
 	}
 
-	if (result != VDO_SUCCESS)
-		return result;
-
 	slab_count = vdo_compute_slab_count(depot->first_block, depot->last_block,
 					    depot->slab_size_shift);
 	if (thread_config->physical_zone_count > slab_count) {
-- 
2.42.0

