Return-Path: <SRS0=Z7ED=LY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C79C11F65
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 16:09:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 019826135C
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 16:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 019826135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-LSsPzIhZO6ag4Z2COsxVxg-1; Wed, 30 Jun 2021 12:09:53 -0400
X-MC-Unique: LSsPzIhZO6ag4Z2COsxVxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E801802920;
	Wed, 30 Jun 2021 16:09:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91BFC19C79;
	Wed, 30 Jun 2021 16:09:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EED3F4EA2A;
	Wed, 30 Jun 2021 16:09:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15UG1wnU017279 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Jun 2021 12:01:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2FBCD2028683; Wed, 30 Jun 2021 16:01:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29CF521F1B00
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 16:01:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9253210AC3AB
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 16:01:52 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
	[209.85.160.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-184-JVJ2_tXYOd2vsJr0iHEkLg-1; Wed, 30 Jun 2021 12:01:47 -0400
X-MC-Unique: JVJ2_tXYOd2vsJr0iHEkLg-1
Received: by mail-qt1-f181.google.com with SMTP id f20so1797522qtk.10;
	Wed, 30 Jun 2021 09:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:date:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=VgquIkFATUQKw2xt3ccqyQ1g7M1FlKGEVH4Mz2jCNRI=;
	b=HI/7ifwzyKxF4KR9JdYRElHV6D5QBY52OlpsGCZo11n3Q+ncivPVNiQ2SDrPwB5iHX
	BOu9ATdlSPHLiHNTspmaNYKTUaPxquo53VRWL12y7Vy7rm6cUvEQGnCepsAzc4vIqICl
	tYgX5Q+FgsNSpPWWInLyev8h/jzUPkvScGKJyCYWRQXzttEW/93rhZxQa+0rp6lPUq5+
	3zvhiVKSTQVNgUYKvkd5pf9nYz+OxA6ErvkttDYuGgxv4EMpQkn5ye2zhROoH+1UoCKg
	ADH8q18lTIZK1Gj1Lu6pO4uTsV8JwitDEyOrdEFOLilmRj2AJKdxrKi1TayGJOolo47y
	GrHQ==
X-Gm-Message-State: AOAM530iHw1I6fenxmlAEtZ7nRSug/E4tgAFSN4o02yPPYiPldOPcrSK
	sxPEk0ofKS80g5kd1DK9LXs=
X-Google-Smtp-Source: ABdhPJzgZOIfAqvQLKW7HIlxfQhxyqklQuVF+2ZjmG9wirCVM1cQyIUH/wyJMWixkXFiXVuDp0RRkQ==
X-Received: by 2002:ac8:4a84:: with SMTP id l4mr23006857qtq.372.1625068906828; 
	Wed, 30 Jun 2021 09:01:46 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	m189sm13546973qkd.107.2021.06.30.09.01.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 30 Jun 2021 09:01:45 -0700 (PDT)
From: Mike Snitzer <snitzer@gmail.com>
X-Google-Original-From: Mike Snitzer <kbusch@kernel.org>
Date: Wed, 30 Jun 2021 12:01:45 -0400
To: Martin Wilck <mwilck@suse.com>
Message-ID: <YNyVafnX09cOIZPe@redhat.com>
References: <20210628095210.26249-1-mwilck@suse.com>
	<20210628095210.26249-2-mwilck@suse.com>
	<20210628095341.GA4105@lst.de>
	<4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
	<20210629125909.GB14372@lst.de>
	<2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
	<20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
	<1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	emilne@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 30 2021 at  4:12P -0400,
Martin Wilck <mwilck@suse.com> wrote:

> On Di, 2021-06-29 at 14:23 -0700, Keith Busch wrote:
> > On Tue, Jun 29, 2021 at 09:23:18PM +0200, Martin Wilck wrote:
> > > On Di, 2021-06-29 at 14:59 +0200, Christoph Hellwig wrote:
> > > > On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> > > >=20
> > > > > The sg_io-on-multipath code needs to answer the question "is
> > > > > this a
> > > > > path or a target error?". Therefore it calls blk_path_error(),
> > > > > which
> > > > > requires obtaining a blk_status_t first. But that's not
> > > > > available
> > > > > in
> > > > > the sg_io code path. So how=A0should I deal with this situation?
> > > >=20
> > > > Not by exporting random crap from the SCSI code.

Helpful as always Christoph... ;)

> > > So, you'd prefer inlining scsi_result_to_blk_status()?
> >=20
> > I don't think you need to. The only scsi_result_to_blk_status()
> > caller
> > is sg_io_to_blk_status(). That's already in the same file as
> > scsi_result_to_blk_status() so no need to export it. You could even
> > make
> > it static.
>=20
> Thanks for your suggestion. I'd be lucky if this was true. But the most
> important users of scsi_result_to_blk_status() are in scsi_lib.c
> (scsi_io_completion_action(), scsi_io_completion_nz_result()).
>=20
> If I move scsi_result_to_blk_status() to vmlinux without exporting it,
> it won't be available in the SCSI core any more, at least not with
> CONFIG_SCSI=3Dm.

For what you're trying to accomplish with this patchset, you only need
sg_io_to_blk_status() exported.

So check with Martin and/or Bart on the best way to give
sg_io_to_blk_status() access to the equivalent of your
__scsi_result_to_blk_status() without exporting it.

I'd start by just folding patches 1 and 2, fixing up the logic Dan
Carpenter pointed ouit, and only exporting sg_io_to_blk_status().

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

