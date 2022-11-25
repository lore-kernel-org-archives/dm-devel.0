Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6537C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 25 Nov 2022 04:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669351024;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zw93+0ItaZTWpNU9AujblOR2Zid5DBh4/ynOdjiloaI=;
	b=PFX+7lQmseC+6i1aCK+ZNc0JMOzxWQoUPUcW8QGfvlezAAqnNHjz08iJAEPNAjfVfpRoXQ
	2a3T+In+zfNTlk/SfDzmBMa5nx5fV0MJPMMyhrZEzcEx8idR7oYFOb5BSvFajmyWns0a3D
	duWmCR3uDZML3V1n3yeCELiPJOqsl+o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-ziJLBXIdMKy5wCTcT_OHqw-1; Thu, 24 Nov 2022 23:37:00 -0500
X-MC-Unique: ziJLBXIdMKy5wCTcT_OHqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD3622932497;
	Fri, 25 Nov 2022 04:36:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E47DC1908E;
	Fri, 25 Nov 2022 04:36:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 02BD41946589;
	Fri, 25 Nov 2022 04:36:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D97721946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Nov 2022 04:36:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B82FE40C2088; Fri, 25 Nov 2022 04:36:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC4440C2064
 for <dm-devel@redhat.com>; Fri, 25 Nov 2022 04:36:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CD3F833A0D
 for <dm-devel@redhat.com>; Fri, 25 Nov 2022 04:36:55 +0000 (UTC)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-94-758XbvgTOauMYVEWYY7luw-1; Thu,
 24 Nov 2022 23:36:53 -0500
X-MC-Unique: 758XbvgTOauMYVEWYY7luw-1
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1oyQAK-006aa1-1q; Fri, 25 Nov 2022 04:18:16 +0000
Date: Fri, 25 Nov 2022 04:18:16 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <Y4BCCB9U10mkiehu@ZenIV>
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c@epcas5p2.samsung.com>
 <20221123055827.26996-11-nj.shetty@samsung.com>
 <729254f8-2468-e694-715e-72bcbef80ff3@opensource.wdc.com>
 <349a4d66-3a9f-a095-005c-1f180c5f3aac@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <349a4d66-3a9f-a095-005c-1f180c5f3aac@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v5 10/10] fs: add support for copy file range
 in zonefs
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
Cc: axboe@kernel.dk, naohiro.aota@wdc.com, gost.dev@samsung.com, kch@nvidia.com,
 sagi@grimberg.me, joshi.k@samsung.com, linux-kernel@vger.kernel.org,
 anuj20.g@samsung.com, snitzer@kernel.org, james.smart@broadcom.com,
 linux-nvme@lists.infradead.org, hch@lst.de, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, nitheshshetty@gmail.com,
 kbusch@kernel.org, jth@kernel.org, Nitesh Shetty <nj.shetty@samsung.com>,
 agk@redhat.com, p.raghav@samsung.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 24, 2022 at 10:47:55AM +0900, Damien Le Moal wrote:
> >> +	inode_lock(src_inode);
> >> +	inode_lock(dst_inode);
> > 
> > So you did zonefs_copy_file_checks() outside of these locks, which mean
> > that everything about the source and destination files may have changed.
> > This does not work.
> 
> I forgot to mention that locking 2 inodes blindly like this can leads to
> deadlocks if another process tries a copy range from dst to src at the
> same time (lock order is reversed and so can deadlock).

Not to mention the deadlocks with existing places where fs/namei.c locks
two inodes...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

