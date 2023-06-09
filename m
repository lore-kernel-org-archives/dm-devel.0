Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857C5C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 04:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686286449;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8qMNflpHbeG+x3r3S4cSL/dNSTI7e/7ZxzeHT9aOYkg=;
	b=Zjk6dainwWmfc3JOXqGECREHkRkuolmklSeoFmf2iZp7q9CxOMhi1jI8KEoNRirqtvfN/Z
	2UDPw1iq/DxfBP/5go8ZbMCeq4+lSNWv4po3Ohps6eCs6peXNxauJRQmITSkz/b8hD4VYY
	ua/CM9qoACvay0MWBBWI2XDxfq0fG08=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-wBH_378cMuewusi6bMug6g-1; Fri, 09 Jun 2023 00:54:05 -0400
X-MC-Unique: wBH_378cMuewusi6bMug6g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9BE23C021BE;
	Fri,  9 Jun 2023 04:54:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC867492B00;
	Fri,  9 Jun 2023 04:54:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7721619451C0;
	Fri,  9 Jun 2023 04:54:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1CED4194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 04:54:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DDDA540D1B68; Fri,  9 Jun 2023 04:54:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6F0F40D1B66
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 04:54:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B780C811E78
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 04:54:00 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-HVGhCv99O2qnajE9eA6jPg-1; Fri, 09 Jun 2023 00:53:59 -0400
X-MC-Unique: HVGhCv99O2qnajE9eA6jPg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1q7Tfy-00BaXx-39; Fri, 09 Jun 2023 04:24:38 +0000
Date: Thu, 8 Jun 2023 21:24:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <ZIKphgDavKVPREnw@infradead.org>
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494@epcas5p4.samsung.com>
 <20230605121732.28468-6-nj.shetty@samsung.com>
 <ZH3mjUb+yqI11XD8@infradead.org>
 <20230606113535.rjbhe6eqlyqk4pqq@green245>
 <ZIAt7vL+/isPJEl5@infradead.org>
 <20230608120817.jg4xb4jhg77mlksw@green245>
MIME-Version: 1.0
In-Reply-To: <20230608120817.jg4xb4jhg77mlksw@green245>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v12 5/9] nvme: add copy offload support
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 willy@infradead.org, Christoph Hellwig <hch@infradead.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 08, 2023 at 05:38:17PM +0530, Nitesh Shetty wrote:
> Sure, we can do away with subsys and realign more on single namespace copy.
> We are planning to use token to store source info, such as src sector,
> len and namespace. Something like below,
> 
> struct nvme_copy_token {
> 	struct nvme_ns *ns; // to make sure we are copying within same namespace
> /* store source info during *IN operation, will be used by *OUT operation */
> 	sector_t src_sector;
> 	sector_t sectors;
> };
> Do you have any better way to handle this in mind ?

In general every time we tried to come up with a request payload that is
not just data passed to the device it has been a nightmare.

So my gut feeling would be that bi_sector and bi_iter.bi_size are the
ranges, with multiple bios being allowed to form the input data, similar
to how we implement discard merging.

The interesting part is how we'd match up these bios.  One idea would
be that since copy by definition doesn't need integrity data we just
add a copy_id that unions it, and use a simple per-gendisk copy I/D
allocator, but I'm not entirely sure how well that interacts stacking
drivers. 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

