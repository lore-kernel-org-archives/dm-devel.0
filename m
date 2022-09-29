Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74A1C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664481964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DrgkxJ983CCEHsuvyjvGkQlvFfuYja5GQikaApDXQhM=;
	b=Gp9mI8ySXEEmsKfycDuKn5tMsPjkyzOlOCEGnMExKfgBk2LvH36sxJ57NEpAMpK4qQ4IvV
	vTQkGUyN9mSH3qJUazWzKQSbH1G2JWYJtBOckTPKN1HkcwEYJDCrYv7JRqpgJag88zyY6n
	DmF0wgPxEVVSXEkfS8qhzlyM+XTwg38=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-X5zFcnffO72eAsLY39J_ww-1; Thu, 29 Sep 2022 16:06:00 -0400
X-MC-Unique: X5zFcnffO72eAsLY39J_ww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BC3F8041B5;
	Thu, 29 Sep 2022 20:05:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2EE32084836;
	Thu, 29 Sep 2022 20:05:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB8521946A52;
	Thu, 29 Sep 2022 20:05:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1E071946A4E
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Sep 2022 20:05:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B092B23177; Thu, 29 Sep 2022 20:05:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3FD77AE5;
 Thu, 29 Sep 2022 20:05:43 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28TK5hCb011567; Thu, 29 Sep 2022 16:05:43 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28TK5hub011563; Thu, 29 Sep 2022 16:05:43 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 29 Sep 2022 16:05:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <YzOdau9e5HYcjQKf@B-P7TQMD6M-0146.local>
Message-ID: <alpine.LRH.2.02.2209291600540.7875@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <YyqfHfadJvxbB/JC@B-P7TQMD6M-0146.local>
 <alpine.LRH.2.02.2209271006590.28431@file01.intranet.prod.int.rdu2.redhat.com>
 <YzOdau9e5HYcjQKf@B-P7TQMD6M-0146.local>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 28 Sep 2022, Gao Xiang wrote:

> > Hi
> > 
> > Ramdisk DAX was there in the past, but it was removed in the kernel 4.15.
> 
> Hi Mikulas!
> 
> Thanks for pointing out! I didn't realize that, although I think if we really
> use brd driver in production, enabling DAX support for brd is much better to
> remove double caching so that ramdisk can become a real ramdisk for most
> regular files.
> 
> I have no idea how other people think about ramdisk DAX, or brd is just a
> stuff for testing only now.  If it behaves like this, sorry about the
> noise.
> 
> Thanks,
> Gao Xiang

Hi

See the message for the commit 7a862fbbdec665190c5ef298c0c6ec9f3915cf45 
for the reason why it was removed.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

