Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686D4C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 30 Sep 2022 07:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664521904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kmzE+y/b1zEybjNv7ne7bD2a+Vo/dX4uATUgLoiP/Ao=;
	b=ObOwNlRgbBDAyKxIRUYX4N1fkEoKlJ21jzC6z5R/jn3rdx1/Ij1uzyO+hqCPdiR+U/dbsg
	7fJA2XhO0e+DlN/zVbaaQFOHJjnHyj0/Fg+3pOsF4ZNLvReM8Ta6SMBiIehHQM08aW7HRd
	hOUPTA9y7ZLDFi+Rq0kdUqB5yZjWXNc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-ad0CZmRdNb6JAHZpehWIBw-1; Fri, 30 Sep 2022 03:11:42 -0400
X-MC-Unique: ad0CZmRdNb6JAHZpehWIBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFD1D855305;
	Fri, 30 Sep 2022 07:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19DC6112131B;
	Fri, 30 Sep 2022 07:11:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D4951946A6E;
	Fri, 30 Sep 2022 07:11:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7006F1946A4E
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Sep 2022 20:48:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5A7E9492CA4; Thu, 29 Sep 2022 20:48:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52C38492CA2
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 20:48:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2C003C0D863
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 20:48:35 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
 (out30-42.freemail.mail.aliyun.com [115.124.30.42]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256)
 id us-mta-615-oFJcn7wmMd6qN4xeMD5keA-1; Thu, 29 Sep 2022 16:48:33 -0400
X-MC-Unique: oFJcn7wmMd6qN4xeMD5keA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VR.8PdO_1664484505
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VR.8PdO_1664484505) by smtp.aliyun-inc.com;
 Fri, 30 Sep 2022 04:48:27 +0800
Date: Fri, 30 Sep 2022 04:48:25 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YzYEmZH7GKlw3QoP@B-P7TQMD6M-0146.local>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Zdenek Kabelac <zkabelac@redhat.com>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <YyqfHfadJvxbB/JC@B-P7TQMD6M-0146.local>
 <alpine.LRH.2.02.2209271006590.28431@file01.intranet.prod.int.rdu2.redhat.com>
 <YzOdau9e5HYcjQKf@B-P7TQMD6M-0146.local>
 <alpine.LRH.2.02.2209291600540.7875@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209291600540.7875@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 30 Sep 2022 07:11:37 +0000
Subject: Re: [dm-devel] [PATCH v2 0/4] brd: implement discard
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 29, 2022 at 04:05:43PM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 28 Sep 2022, Gao Xiang wrote:
> 
> > > Hi
> > > 
> > > Ramdisk DAX was there in the past, but it was removed in the kernel 4.15.
> > 
> > Hi Mikulas!
> > 
> > Thanks for pointing out! I didn't realize that, although I think if we really
> > use brd driver in production, enabling DAX support for brd is much better to
> > remove double caching so that ramdisk can become a real ramdisk for most
> > regular files.
> > 
> > I have no idea how other people think about ramdisk DAX, or brd is just a
> > stuff for testing only now.  If it behaves like this, sorry about the
> > noise.
> > 
> > Thanks,
> > Gao Xiang
> 
> Hi
> 
> See the message for the commit 7a862fbbdec665190c5ef298c0c6ec9f3915cf45 
> for the reason why it was removed.

I've already seen that commit after you told me, yet I think the reasons
listed inside are not fundamental reasons why ramdisk cannot support DAX
in principle (although I know there are issues as listed to handle.)

IMHO, reserving ZONE_DEVICE memory to emulate pmem for ramdisk DAX-like
use is inflexible on my side since currently such reserved memory cannot
be used for other uses later even the ramdisk actually use little space
in practice regardless of its capacity.

Thanks,
Gao Xiang

> 
> Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

