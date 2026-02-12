Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE92040B6
	for <dm-devel@lists.linux.dev>; Thu, 12 Feb 2026 16:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770914032; cv=none; b=VBc6bQhdgiorxWHUQmIDi4dRPsOEzR/8U0qRHScT5Ev7wXv73y6VMb+twmW3Lq4xeA5DTchyC9m7EcdcMnt6BAkFWQkEDdow5SsLs/savve5RTpiaLgDxxuXAg7zdbQqgb1jKeRJOqoXWjfCNJdByUXHuE2MznjCBypPbmfUHxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770914032; c=relaxed/simple;
	bh=hviYCmEZzGcUS/O4+t/Imp+zyt1/KyQJBAheFK8SPG0=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=kKd2pVXp5Sk7na5fDNBqtD0bpyRQs/zuabSjkGVPRy4OVEceU8SjwiB7jqOsHYtushPTk+871rpD5v8eXO8Ec3gDax82GkHWVPjQT7YLEGWJvOGcBng7V4SCpsal3cfD1m+v4yy+WYPTkJTAmvU1ImOI8X6JAsyAVsBOnS5BzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BDG93oYq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDG93oYq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770914029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=xXi4H0Jq66OLHcU6m/KdB+pSxwS1QdAsEeayWF3YRA8=;
	b=BDG93oYqkuwAuSE4rXUvme2bvgHMyzLsDKx2kCrVrD4UoauCyl87JYtXuQy/iDE/3u9sCV
	a3RL9802S4p5sVRv0f29MdxvKy3pT1f7TmfMBh2bGFpbs93Vrlkui/AGjbsDD6oQHLGEmv
	tZvBYZjrv/SyG7jzwRNavGT+EDeyN2U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-qrRILHvlMSaFIakZuTTmxw-1; Thu,
 12 Feb 2026 11:33:45 -0500
X-MC-Unique: qrRILHvlMSaFIakZuTTmxw-1
X-Mimecast-MFC-AGG-ID: qrRILHvlMSaFIakZuTTmxw_1770914023
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93535180AED4;
	Thu, 12 Feb 2026 16:33:39 +0000 (UTC)
Received: from [10.45.224.59] (unknown [10.45.224.59])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5A411800465;
	Thu, 12 Feb 2026 16:33:36 +0000 (UTC)
Date: Thu, 12 Feb 2026 17:33:30 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Vishal Moola <vishal.moola@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>, 
    "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
    SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    zkabelac@redhat.com, Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, 
    dm-devel@lists.linux.dev
Subject: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t8REnFEonxPKYkH4ERZ_Sd9WIVfnk2-sMA0rlLJwPnM_1770914023
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
flags") breaks the device mapper VDO target. The VDO target calls vmalloc
with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
flags.

There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
let's add this flag to GFP_VMALLOC_SUPPORTED.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Cc: stable@vger.kernel.org	# v6.19

---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -3928,6 +3928,7 @@ fail:
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
 				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 

