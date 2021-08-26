Return-Path: <SRS0=4ZGW=NV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53255C432BE
	for <dm-devel@archiver.kernel.org>; Mon, 30 Aug 2021 06:53:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DAE9360FC0
	for <dm-devel@archiver.kernel.org>; Mon, 30 Aug 2021 06:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DAE9360FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-1BB5M5imMIyHJhdnAnQouQ-1; Mon, 30 Aug 2021 02:53:41 -0400
X-MC-Unique: 1BB5M5imMIyHJhdnAnQouQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69C2F87511D;
	Mon, 30 Aug 2021 06:53:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EBA410013C1;
	Mon, 30 Aug 2021 06:53:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3CC7D181A0F7;
	Mon, 30 Aug 2021 06:53:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17Q7l8dK021758 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Aug 2021 03:47:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0C1E7EAF8C; Thu, 26 Aug 2021 07:47:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05985E77B3
	for <dm-devel@redhat.com>; Thu, 26 Aug 2021 07:47:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45C8C100B8C2
	for <dm-devel@redhat.com>; Thu, 26 Aug 2021 07:47:05 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
	[209.85.167.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-240-ERvCt658OxSDPmhywfjIhA-1; Thu, 26 Aug 2021 03:47:00 -0400
X-MC-Unique: ERvCt658OxSDPmhywfjIhA-1
Received: by mail-lf1-f43.google.com with SMTP id bq28so4854763lfb.7;
	Thu, 26 Aug 2021 00:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=WFfBSeUoIkVFq2c+wyysTynFg5YjCpP2+vF7k66ApRg=;
	b=sVrj+m5SpQc2LMoTGZeoVBx+h1VVbCx9PqTK2zkPt6jDjomliAyixvbmItnKXhSWXg
	1goAtNoghfOGrhyk7HQnJzP/218Xx6RVsD+ENnOWVQmZqtGVdnGEL4uR5KlIYfMThhJi
	/XnV5q/mTzADJvHqq30fOtEn5CpadQlW8FfDMffDm6jYxRIY0fRWX0V8zjb0/qMyU3zV
	ko9gygFUhyayoXNTHcQalCpanWDsYWRW4gb/kd059ksY6eFAGKARjAOUo4b5hm+Ccns6
	aszTgW0JAiO3Ypoei0sKtN8e1bCFUE9Dx/5eT0hBLKqha2nqnYhqKMmJYmL+FiE0kabg
	+R2A==
X-Gm-Message-State: AOAM531v8nXX1xNk8vgTDImgG8NU5+/uPpTlM4WSs15j6a/mwJ5ggklz
	IuWLjk70FKXheu5TjDMLjGyyE5iTbrE04PnJWWeZZwkbhRZcGw==
X-Google-Smtp-Source: ABdhPJyjbSulKVzeS1ayorUS6e0PDTdjH/3YKsApr3OabyEwjGfG27IO4vB7ZiqR7/y8lcLFPtK9qboXnc4pB3rdlck=
X-Received: by 2002:a05:6512:1114:: with SMTP id
	l20mr1781869lfg.550.1629964017693; 
	Thu, 26 Aug 2021 00:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101758epcas5p1ec353b3838d64654e69488229256d9eb@epcas5p1.samsung.com>
	<20210817101423.12367-4-selvakuma.s1@samsung.com>
	<ad3561b9-775d-dd4d-0d92-6343440b1f8f@acm.org>
	<CA+1E3rK2ULVajQRkNTZJdwKoqBeGvkfoVYNF=WyK6Net85YkhA@mail.gmail.com>
	<fb9931ae-de27-820a-1333-f24e020913ff@acm.org>
In-Reply-To: <fb9931ae-de27-820a-1333-f24e020913ff@acm.org>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Thu, 26 Aug 2021 13:16:46 +0530
Message-ID: <CAOSviJ1uQo=O8trN71t5p+qYU8GRgGerSvkE9y5tDR+4pM4f1g@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
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
X-Mailman-Approved-At: Mon, 30 Aug 2021 02:52:24 -0400
Cc: Mike Snitzer <snitzer@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-nvme@lists.infradead.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, agk@redhat.com,
	linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Nitesh Shetty <nj.shetty@samsung.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Selva Jove <selvajove@gmail.com>, linux-block@vger.kernel.org,
	mpatocka@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	KANCHAN JOSHI <joshi.k@samsung.com>, linux-api@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshiiitr@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [dm-devel] [PATCH 3/7] block: copy offload support
	infrastructure
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Bart,Mikulas,Martin,Douglas,

We will go through your previous work and use this thread as a medium for
further discussion, if we come across issues to be sorted out.

Thank you,
Nitesh Shetty

On Sat, Aug 21, 2021 at 2:48 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/20/21 3:39 AM, Kanchan Joshi wrote:
> > Bart, Mikulas
> >
> > On Tue, Aug 17, 2021 at 10:44 PM Bart Van Assche <bvanassche@acm.org> wrote:
> >>
> >> On 8/17/21 3:14 AM, SelvaKumar S wrote:
> >>> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> >>> bio with control information as payload and submit to the device.
> >>> Larger copy operation may be divided if necessary by looking at device
> >>> limits. REQ_OP_COPY(19) is a write op and takes zone_write_lock when
> >>> submitted to zoned device.
> >>> Native copy offload is not supported for stacked devices.
> >>
> >> Using a single operation for copy-offloading instead of separate
> >> operations for reading and writing is fundamentally incompatible with
> >> the device mapper. I think we need a copy-offloading implementation that
> >> is compatible with the device mapper.
> >>
> >
> > While each read/write command is for a single contiguous range of
> > device, with simple-copy we get to operate on multiple discontiguous
> > ranges, with a single command.
> > That seemed like a good opportunity to reduce control-plane traffic
> > (compared to read/write operations) as well.
> >
> > With a separate read-and-write bio approach, each source-range will
> > spawn at least one read, one write and eventually one SCC command. And
> > it only gets worse as there could be many such discontiguous ranges (for
> > GC use-case at least) coming from user-space in a single payload.
> > Overall sequence will be
> > - Receive a payload from user-space
> > - Disassemble into many read-write pair bios at block-layer
> > - Assemble those (somehow) in NVMe to reduce simple-copy commands
> > - Send commands to device
> >
> > We thought payload could be a good way to reduce the
> > disassembly/assembly work and traffic between block-layer to nvme.
> > How do you see this tradeoff?  What seems necessary for device-mapper
> > usecase, appears to be a cost when device-mapper isn't used.
> > Especially for SCC (since copy is within single ns), device-mappers
> > may not be too compelling anyway.
> >
> > Must device-mapper support be a requirement for the initial support atop SCC?
> > Or do you think it will still be a progress if we finalize the
> > user-space interface to cover all that is foreseeable.And for
> > device-mapper compatible transport between block-layer and NVMe - we
> > do it in the later stage when NVMe too comes up with better copy
> > capabilities?
>
> Hi Kanchan,
>
> These days there might be more systems that run the device mapper on top
> of the NVMe driver or a SCSI driver than systems that do use the device
> mapper. It is common practice these days to use dm-crypt on personal
> workstations and laptops. LVM (dm-linear) is popular because it is more
> flexible than a traditional partition table. Android phones use
> dm-verity on top of hardware encryption. In other words, not supporting
> the device mapper means that a very large number of use cases is
> excluded. So I think supporting the device mapper from the start is
> important, even if that means combining individual bios at the bottom of
> the storage stack into simple copy commands.
>
> Thanks,
>
> Bart.
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

