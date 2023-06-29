Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD349EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jun 2023 08:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688027662;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H8V07hx9fMrxNFemxvKTFWvgBwyOYUGJuSFdukus9VM=;
	b=GGhHZVMMMqT6YTXwlL8O0mjLvjBHRhnk8xOv8GGy3jyQJtBOPsJ+fTla2cd8L1k1Ru2NdI
	xwdus9YqdhtKLsJjDKapuhwn40hscLUGMdHG2sbcSkvERuN2/+1howJvIAK3oond/1IjHY
	TqjTNFqfQ5Vdp99sj58NAnt4W2Lmoqg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-Ygzu0047NIGAAt462ZCLpw-1; Thu, 29 Jun 2023 04:34:21 -0400
X-MC-Unique: Ygzu0047NIGAAt462ZCLpw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CE603C01BA8;
	Thu, 29 Jun 2023 08:34:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 351C84CD0C3;
	Thu, 29 Jun 2023 08:34:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E198319465B6;
	Thu, 29 Jun 2023 08:34:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 013151946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Jun 2023 08:34:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C26E14CD0C3; Thu, 29 Jun 2023 08:34:02 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com
 [10.72.8.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F8C5492C13;
 Thu, 29 Jun 2023 08:33:32 +0000 (UTC)
Date: Thu, 29 Jun 2023 16:33:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <ZJ1B1k0KifZrGRIp@ovpn-8-26.pek2.redhat.com>
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184020epcas5p13fdcea52edead5ffa3fae444f923439e@epcas5p1.samsung.com>
 <20230627183629.26571-4-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230627183629.26571-4-nj.shetty@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v13 3/9] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, linux-doc@vger.kernel.org,
 djwong@kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

On Wed, Jun 28, 2023 at 12:06:17AM +0530, Nitesh Shetty wrote:
> For the devices which does not support copy, copy emulation is added.
> It is required for in-kernel users like fabrics, where file descriptor is

I can understand copy command does help for FS GC and fabrics storages,
but still not very clear why copy emulation is needed for kernel users,
is it just for covering both copy command and emulation in single
interface? Or other purposes?

I'd suggest to add more words about in-kernel users of copy emulation.

> not available and hence they can't use copy_file_range.
> Copy-emulation is implemented by reading from source into memory and
> writing to the corresponding destination asynchronously.
> Also emulation is used, if copy offload fails or partially completes.

Per my understanding, this kind of emulation may not be as efficient
as doing it in userspace(two linked io_uring SQEs, read & write with
shared buffer). But it is fine if there are real in-kernel such users.


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

