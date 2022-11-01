Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7744ECAAA1
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667308780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zqIc/36b7jEEQ8vu+R4K/ijt89TdYCQuOKiw3lkkSes=;
	b=Z/cGFtkBWImtU8bv95QzrvCRJfNb2H/NsigE8lWQdswPgxe84PJzQ2P2PoQ852X6CG31+W
	Vt1HyeslR7A25v5g0tTZhDoDexkJp3utYK2ecv9tgiIlvHG+qC00XcQcLLXPXUb60og9qI
	ZsIhLsbB0Ie51i04oOtn5zvWyfE6gNw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-XQpGMjIqM_WPmhxZ4r06ww-1; Tue, 01 Nov 2022 09:19:29 -0400
X-MC-Unique: XQpGMjIqM_WPmhxZ4r06ww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25ECD3C0D851;
	Tue,  1 Nov 2022 13:18:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05DCF40C2140;
	Tue,  1 Nov 2022 13:18:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7E5719465B3;
	Tue,  1 Nov 2022 13:18:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7700D1946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 13:18:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18F4F1415121; Tue,  1 Nov 2022 13:18:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11660141511F
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 13:18:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF6B3800B23
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 13:18:36 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-6C2b3z-7MO6B25ed3kR0mA-1; Tue, 01 Nov 2022 09:18:35 -0400
X-MC-Unique: 6C2b3z-7MO6B25ed3kR0mA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 1501D6732D; Tue,  1 Nov 2022 14:18:31 +0100 (CET)
Date: Tue, 1 Nov 2022 14:18:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20221101131830.GA16341@lst.de>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
 <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
 <20221101104927.GA13823@lst.de>
 <d3f6ec1d-8141-19d1-ce4c-d42710f4a636@huaweicloud.com>
 <20221101112131.GA14379@lst.de>
 <57465370-99fe-d8a5-e150-a1057640e972@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <57465370-99fe-d8a5-e150-a1057640e972@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 01, 2022 at 07:28:17PM +0800, Yu Kuai wrote:
> What if bd_holder_dir is already freed here, then uaf can be triggered.
> Thus bd_holder_dir need to be resed in del_gendisk() if it's reference
> is dropped to 0, however, kobject apis can't do that...

Indeed.  I don't think we can simply move the dropping of the reference
as you suggested as that also implies taking it earlier, and the
device in the disk is only initialized in add_disk.

Now what I think we could do is:

 - hold open_mutex in bd_link_disk_holder as you suggested
 - check that the bdev inode is hashed inside open_mutex before doing
   the kobject_get

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

