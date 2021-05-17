Return-Path: <SRS0=UUgV=KN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769B6C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 18 May 2021 05:54:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 067A861040
	for <dm-devel@archiver.kernel.org>; Tue, 18 May 2021 05:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 067A861040
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-9N9JQS5QMtONZ86IAewKRw-1; Tue, 18 May 2021 01:54:46 -0400
X-MC-Unique: 9N9JQS5QMtONZ86IAewKRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 820E08049C5;
	Tue, 18 May 2021 05:54:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D3C35D762;
	Tue, 18 May 2021 05:54:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A672055347;
	Tue, 18 May 2021 05:54:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HGeAAJ006210 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 12:40:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 125736D69D; Mon, 17 May 2021 16:40:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B5256B582
	for <dm-devel@redhat.com>; Mon, 17 May 2021 16:40:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A41F59124C5
	for <dm-devel@redhat.com>; Mon, 17 May 2021 16:40:06 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
	[209.85.128.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-573-fFu1RvjfN9y4JIvt7KlTUg-1; Mon, 17 May 2021 12:40:02 -0400
X-MC-Unique: fFu1RvjfN9y4JIvt7KlTUg-1
Received: by mail-wm1-f46.google.com with SMTP id z130so3951242wmg.2;
	Mon, 17 May 2021 09:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=mJg/+7GYl1kUJvfa8nmmRMcNriQOvuN6MAq6Cn+ONao=;
	b=WupgaQWoiS6R6xKpfx+xPd8rOFyupewhiVtGCBibCNr55awLA7xNJwP2pgd34sUPTB
	uen5r5zVGQ8O/fia8Fqqepu2fAFZAn8wHmnTLe6ypwICFrOWo0kZhaKMyMKW7m1ScAPu
	atbCrzP3Z3Wj3dBNSsagSVRCRmrRSDrLBpc4+ioVhHagoLezWWOe5Pse+HaldbjlX2lD
	2u2bfhbz68i9IpPV0wvzvAgeqtVpZijAsf5VeU0IxRmJHDtSu/DPP5uNw15RqyWJXzDd
	H1Nwgu5RkknIcpUfGdsg4EOQAGljKGek9amfDTzzqCAXz43t5FtVDRzIwosoTsJFHXoF
	gyMw==
X-Gm-Message-State: AOAM533wEsPkIg9ajUMTksyDi9XK0ghOZsrmh3oNUIzQ5PtF73F/GlP7
	dFgfUIDwp77YkbCib7ZWHs476CJOAjaJ+0qdAgM=
X-Google-Smtp-Source: ABdhPJztcjSsj0J/JNFDHQf/JgaBAZUnQRFLtkWcpXIR+qh9ia6xfQrYTY+eZZzHSaCUmybr7ASuRfMEoFGty1cPlx0=
X-Received: by 2002:a1c:a442:: with SMTP id n63mr510553wme.25.1621269600181;
	Mon, 17 May 2021 09:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Mon, 17 May 2021 22:09:32 +0530
Message-ID: <CA+1E3rJO-HzZu5q+8ac1wxsnkGeST1epE8Ro00RNBAF340Dgeg@mail.gmail.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 18 May 2021 01:54:34 -0400
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
>
> I'd like to propose a session to go over this topic to understand :-
>
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
>
> * Required Participants :-
> -----------------------------------------------------------------------
>
> I'd like to invite file system, block layer, and device drivers
> developers to:-
>
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
>
I'd like to participate in discussion.
Hopefully we can get consensus on some elements (or discover new
issues) before Dec.
An async-interface (via io_uring) would be good to be discussed while
we are at it.


-- 
Kanchan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

