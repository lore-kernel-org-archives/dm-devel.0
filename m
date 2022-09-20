Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1893C6FA90
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663696025;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ILb3Vct+agt72nMxORd7IMIayAYLC8mLafA2/ul0L+E=;
	b=YnW72QLSoaNTukWy9FjCYXQ86Fif1X539aba9NS21esPaXkvmkioW+faN9Rqusw+cym4Bk
	oXtbHolYNIuiQpMNNrf4VuMsYEA2AqZAV/qwpKOBJD25loq4g16vJFW5GnVRPfO9t2Lfoo
	ukCvXw3kR/ZeXOoymLXMoJQJvuoXctA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-2PHthH-YM76VwrUUy1Uc_g-1; Tue, 20 Sep 2022 13:47:02 -0400
X-MC-Unique: 2PHthH-YM76VwrUUy1Uc_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A26A3C0F67E;
	Tue, 20 Sep 2022 17:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 576E51759F;
	Tue, 20 Sep 2022 17:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BAAC1946589;
	Tue, 20 Sep 2022 17:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBA541946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 17:46:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9EC152027063; Tue, 20 Sep 2022 17:46:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 718662027061;
 Tue, 20 Sep 2022 17:46:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28KHkuXT025484; Tue, 20 Sep 2022 13:46:56 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28KHktCx025480; Tue, 20 Sep 2022 13:46:56 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 20 Sep 2022 13:46:55 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Yylr9g6B7Px6xBXb@infradead.org>
Message-ID: <alpine.LRH.2.02.2209201255500.21483@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209151604410.13231@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209160500190.543@file01.intranet.prod.int.rdu2.redhat.com>
 <Yylr9g6B7Px6xBXb@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 4/4] brd: implement secure erase and write
 zeroes
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 20 Sep 2022, Christoph Hellwig wrote:

> On Fri, Sep 16, 2022 at 05:00:46AM -0400, Mikulas Patocka wrote:
> > This patch implements REQ_OP_SECURE_ERASE and REQ_OP_WRITE_ZEROES on brd.
> > Write zeroes will free the pages just like discard, but the difference is
> > that it writes zeroes to the preceding and following page if the range is
> > not aligned on page boundary. Secure erase is just like write zeroes,
> > except that it clears the page content before freeing the page.
> 
> What is the use case of this?  And just a single overwrite is not what
> storage standards would consider a secure erase, but then again we
> don't really have any documentation or standards for the Linux OP,
> which strongly suggests not actually implementing it for now.

Without support for REQ_OP_WRITE_ZEROES, "blkdiscard -z" actually 
overwrites the ramdisk with zeroes and allocates all the blocks. 
Allocating all the blocks is pointless if we want to clear them.

I implemented REQ_OP_SECURE_ERASE just because it is similar to 
REQ_OP_WRITE_ZEROES. Unlike disks, DRAM has no memory of previous content, 
so a single overwrite should be OK. We could also flush cache in 
REQ_OP_SECURE_ERASE, but I don't know if Linux has any portable function 
that does it.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

