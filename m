Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AD0C001B0
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jul 2023 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689257860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Mv7Yrmc2iAQuVb7Ii4BNb1/2K/1QQLAmSDqU3L2Q1C4=;
	b=Sz2iJVubfGhhcSBQP0zZ1K16IfYoE63ZzSUVF6lzGPj7+5PLrC8YYeoVYaxvyUPr20HAIL
	Hnqo0k20ZjvQM+3Q1SVqnCmHqHzbW+C8rVc0SeK7zTlsaflZ65I2Y2UCgb/vDG/YmG4ux2
	3JWcW0YsCgWimMuIbJ2LRMb1VTAe1+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-Q0UIUtipPF62rmbqIjVELw-1; Thu, 13 Jul 2023 10:16:43 -0400
X-MC-Unique: Q0UIUtipPF62rmbqIjVELw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E00489E753;
	Thu, 13 Jul 2023 14:09:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5026C40C2063;
	Thu, 13 Jul 2023 14:09:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE25A194037B;
	Thu, 13 Jul 2023 14:06:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7B4A1946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Jul 2023 12:53:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CB00D492C13; Thu, 13 Jul 2023 12:53:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3B914CD0CE
 for <dm-devel@redhat.com>; Thu, 13 Jul 2023 12:53:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E835104458F
 for <dm-devel@redhat.com>; Thu, 13 Jul 2023 12:53:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-r1R8LvC5PMWvw3koPg3ZxQ-1; Thu, 13 Jul 2023 08:53:20 -0400
X-MC-Unique: r1R8LvC5PMWvw3koPg3ZxQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1qJulF-003872-2u; Thu, 13 Jul 2023 11:45:29 +0000
Date: Thu, 13 Jul 2023 04:45:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <ZK/j2URSDt4nwSvk@infradead.org>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209201358120.26535@file01.intranet.prod.int.rdu2.redhat.com>
 <ace0451f-b979-be13-cf47-a8cb3656c72e@huaweicloud.com>
 <4b6788d2-c6e1-948-22d-dbb7cbba657d@redhat.com>
 <2ade2716-d875-5e4c-82ce-c4c7f00f1bbc@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <2ade2716-d875-5e4c-82ce-c4c7f00f1bbc@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 3/4] brd: enable discard
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Li Nan <linan666@huaweicloud.com>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 10, 2023 at 01:05:00PM -0600, Jens Axboe wrote:
> When a series is posted and reviewers comment on required changes, I
> always wait for a respin of that series with those addressed. That
> didn't happen, so this didn't get applied.

... independent of that any software that assumes all block devices
can discard data is simply broken. 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

