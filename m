Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CEDC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 06:19:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-uwf11THbMea8YQ1KhjlTwQ-1; Wed, 02 Feb 2022 01:19:09 -0500
X-MC-Unique: uwf11THbMea8YQ1KhjlTwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A76691006AA5;
	Wed,  2 Feb 2022 06:19:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D3135F90B;
	Wed,  2 Feb 2022 06:19:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 631641809CBF;
	Wed,  2 Feb 2022 06:19:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2125wBGq019733 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 00:58:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 65797202698A; Wed,  2 Feb 2022 05:58:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 610DA2026985
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 05:58:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 693D03C02B78
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 05:58:06 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
	[209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-625-ChfVIMcxMO2LVZ9a7L0McQ-1; Wed, 02 Feb 2022 00:58:05 -0500
X-MC-Unique: ChfVIMcxMO2LVZ9a7L0McQ-1
Received: by mail-pj1-f47.google.com with SMTP id h12so19291228pjq.3;
	Tue, 01 Feb 2022 21:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=WZQskbfglYds00Lw2LuF1T37UDp3X/4QsTuyYVY49D4=;
	b=r7a2KxX/1BGZHx4xSPSkduhW+P+186fxMqhbia8axNSghXTBSWWUDrNfFLWIP/vX6B
	g2hN8cxO/E4NMSWi53cFR5CfuzFlWlvg4QSh+fIuf7n2YyHyS0z0LQFhbVu4Lr7BTLTX
	MhU3XiLlvSQgJrq93L4+6NRNH9BfxOJ8U4W1kSTvGNQPvBRw97AbZld9/XC6aGgMaCOZ
	i2ut83Uf/diyxIxQl80QSl9AfJbf1Ud/yJg9qcWZBfJfT797hU/8kdrcKuajFQ/XQ4Dx
	cKsxayIRVYzj9rDHjdzN62tKrowqSvjAfX5h7edElgSxtzsmnVVusg3ANAx1kGTZZc/F
	qYbQ==
X-Gm-Message-State: AOAM532wgnyB1V/pBlipKEaRpp4pByPDWiN1cPiE/sL/YFXiFaMQ+cEW
	kUaT/2WbuCizLA52cSwtlmAhJeJLVB+uI/kYsgE=
X-Google-Smtp-Source: ABdhPJyeBo4k/TNkTynsMQzGTravvy1ipnwIWve44CKgxgd4qgZ2/EjFAto44bCHIwoCs/6vMk7KTjcopXMkjlGETB4=
X-Received: by 2002:a17:902:c652:: with SMTP id
	s18mr29246528pls.1.1643781483598; 
	Tue, 01 Feb 2022 21:58:03 -0800 (PST)
MIME-Version: 1.0
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
In-Reply-To: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Wed, 2 Feb 2022 11:27:36 +0530
Message-ID: <CA+1E3rJhT_mXiJHWJF14BeE8mz2vRaz4D0gpZRxPJzwr4S-EbQ@mail.gmail.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Feb 2022 01:18:44 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbus >> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 27, 2022 at 12:51 PM Chaitanya Kulkarni
<chaitanyak@nvidia.com> wrote:
>
> Hi,
>
> * Background :-
> -----------------------------------------------------------------------
>
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.
>
> With reference to the RISC-V summit keynote [1] single threaded
> performance is limiting due to Denard scaling and multi-threaded
> performance is slowing down due Moore's law limitations. With the rise
> of SNIA Computation Technical Storage Working Group (TWG) [2],
> offloading computations to the device or over the fabrics is becoming
> popular as there are several solutions available [2]. One of the common
> operation which is popular in the kernel and is not merged yet is Copy
> offload over the fabrics or on to the device.
>
> * Problem :-
> -----------------------------------------------------------------------
>
> The original work which is done by Martin is present here [3]. The
> latest work which is posted by Mikulas [4] is not merged yet. These two
> approaches are totally different from each other. Several storage
> vendors discourage mixing copy offload requests with regular READ/WRITE
> I/O. Also, the fact that the operation fails if a copy request ever
> needs to be split as it traverses the stack it has the unfortunate
> side-effect of preventing copy offload from working in pretty much
> every common deployment configuration out there.
>
> * Current state of the work :-
> -----------------------------------------------------------------------
>
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.
>
> We have conducted a call with interested people late last year since
> lack of LSFMMM and we would like to share the details with broader
> community members.

I'm keen on this topic and would like to join the F2F discussion.
The Novmber call did establish some consensus on requirements.
Planning to have a round or two of code-discussions soon.


Thanks,
-- 
Kanchan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

