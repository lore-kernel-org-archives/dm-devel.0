Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF264137764
	for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389460; cv=none; b=PfyP+KQZr7FMmTrQr8nIz0HtxY/ak9wbE/WvJt1pgW+XjPfUQP5fI/t5RtCzO6cDPNrRYV/aaukcilWbgGahZQ0ScQASWtHfLfBZvN79mo1G034B5SsYIMuBHv5k/KJS86501S6hocdXxE1a5LdrNnuhEKujpmspW8O2mjtUd0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389460; c=relaxed/simple;
	bh=cG5WviVEhA217aEoAiRjRp/N+zIMjVMAk9zeWnEj/X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScGr/kK+/IE0m2d2sSF81LWECGwUmFtwUw1jnf7KL6S/tQIjPqTnirfc8D50f3IHuRUs/ZJ/E8IebEcu1cUtukYmu5lTw40RRI92rLX2ThrbOY1uKTAbmcY/8/XB2IqpKv/5v2ziyWDrYlrgq1NKto127iympw3pegujOarT/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UOunB/1P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UOunB/1P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718389457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SY+pt5tiuepK+rGrj5eIXyEZBofOvKo3/WbvPjYRnkU=;
	b=UOunB/1PxCNtgEF6w9hNqsKCDlxrlsKJiI2EbyqXGMGBfzCrrMMgbtHlMGJV7lqw2MGn0O
	Ff6oPJqWbBCt+BDN3yffCeo68oTMdp6LKo9Q2FmcprLcPweElsUJg6K8MupZNMq08C4Dab
	2sYGY8NQLdTXd7K+rQCm/VFwZkJ7lc0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-tvXXss_dNHWlMXWs_qkvQA-1; Fri,
 14 Jun 2024 14:24:16 -0400
X-MC-Unique: tvXXss_dNHWlMXWs_qkvQA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E93D195609D;
	Fri, 14 Jun 2024 18:24:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A22953000220;
	Fri, 14 Jun 2024 18:24:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45EIODS7952182
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Jun 2024 14:24:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45EIODPs952181;
	Fri, 14 Jun 2024 14:24:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/3] dm io: bump num_bvecs to handle offset memory.
Date: Fri, 14 Jun 2024 14:24:10 -0400
Message-ID: <20240614182412.952166-2-bmarzins@redhat.com>
In-Reply-To: <20240614182412.952166-1-bmarzins@redhat.com>
References: <20240614182412.952166-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If dp->get_page() returns an non-zero offset, the bio might need an
additional bvec to deal with the offset. For example, if remaining is
exactly one page size, but there is an offset, the memory will span
two pages.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 7409490259d1..3333943fe288 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -347,7 +347,7 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 			break;
 		default:
 			num_bvecs = bio_max_segs(dm_sector_div_up(remaining,
-						(PAGE_SIZE >> SECTOR_SHIFT)));
+						(PAGE_SIZE >> SECTOR_SHIFT)) + 1);
 		}
 
 		bio = bio_alloc_bioset(where->bdev, num_bvecs, opf, GFP_NOIO,
-- 
2.45.0

