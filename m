Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1644DC2BA4C
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 04:42:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-chx5l7BvOPeFVIpST_su8g-1; Tue, 25 Jan 2022 23:42:24 -0500
X-MC-Unique: chx5l7BvOPeFVIpST_su8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B889C84E0A9;
	Wed, 26 Jan 2022 04:42:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 997C06AB87;
	Wed, 26 Jan 2022 04:42:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 668981809CB8;
	Wed, 26 Jan 2022 04:42:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20PEQrdV025747 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 Jan 2022 09:26:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AB9812026990; Tue, 25 Jan 2022 14:26:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A75B52026976
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 14:26:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BF243C11A10
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 14:26:42 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
	[209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-621-6t0XijdSONapE_6FJTyZug-1; Tue, 25 Jan 2022 09:26:30 -0500
X-MC-Unique: 6t0XijdSONapE_6FJTyZug-1
Received: by mail-ed1-f45.google.com with SMTP id a18so63143331edj.7
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 06:26:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=uLYc4GfafSgmS5JKXh594CfMmA35aGk/ExImBcGXGtA=;
	b=rT8Wdbsn0Lidh9evh0jHtewzxu8HYVEEKf5eGOq/GtZeo8bLDQLfIGTjizkPeRAWqO
	/BmScriWTTf4VOh9duFMBDZhyVMB6lFN3BXuMFf1D5K2PhdjTJqme4BGwFmcMq7Qr8Ur
	14w66TdCArRajdQVZMdi3+kl+PEFxoNf1YFvkrseFmsQ1eKpiuMAWQQfFbIyjRICXE41
	lAXcMLJO+5zsF85kUxSAP6fIha4tzlSmx/mUFpQRPB+BJb1NYwPAnUC+Yz3tgxv6AWj4
	5hClKmt+fPsuJoXgAgs4tBAybU84pBlGAJqqUpKiYNAIn0K8XyDdMX2b5CmqG9xQSdn2
	opbQ==
X-Gm-Message-State: AOAM532VkSdp1QGVKjw7+w+GZsK5rqEbjB7c0HRTPbEXj+rvVNZ82D7u
	CQUqQp6gncscldauo9gM3pEqTpt/sQvjcQctrsbJXg==
X-Google-Smtp-Source: ABdhPJweYum/ZG0CXLwcWx/cLh6hSzOrvhiqGj8hBYQ0eR5iW7lIA8q2idFX0Mg3J25eq6LZ46gmxJ6XpwWSSMv5SQs=
X-Received: by 2002:a17:906:c116:: with SMTP id
	do22mr16628213ejc.592.1643120789060; 
	Tue, 25 Jan 2022 06:26:29 -0800 (PST)
MIME-Version: 1.0
References: <20220124150209.22202-1-bgeffon@google.com>
	<20220124151434.GB20331@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CADyq12ykDCswWZw05OdyYfP-zT6afuhXbckii1m1egQ2fSwB4w@mail.gmail.com>
	<20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
In-Reply-To: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 25 Jan 2022 09:25:52 -0500
Message-ID: <CADyq12zS5ZP+0DBdiVWq0_kt4-n0ykdwH_Nw=kJj0V7oF=3OdQ@mail.gmail.com>
To: Brian Geffon <bgeffon@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
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
X-Mailman-Approved-At: Tue, 25 Jan 2022 23:35:56 -0500
Subject: Re: [dm-devel] [PATCH] dm: introduce a no open flag for deferred
	remove
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24, 2022 at 7:21 PM Alasdair G Kergon <agk@redhat.com> wrote:
>
> On Mon, Jan 24, 2022 at 10:25:47AM -0500, Brian Geffon wrote:
> > Thank you for looking at this. There are a few reasons this might be
> > useful, the first is if you're trying to speed up a graceful teardown
> > of the device by informing userspace that this device is going to be
> > removed in the near future. Another might be on systems where it might
> > be worthwhile to not have users with CAP_DAC_OVERRIDE be able to open
> > the device. The logic on this second case is that, suppose you have a
> > dm-crypt block device which is backing swap, the data on this device
> > is ephemeral so a flow might be to setup swap followed by dmsetup
> > remove --deferred /dev/mapper/encrypted-swap. This will guarantee that
> > as soon as swap is torn down the encrypted block device is dropped,
> > additionally with this new flag you'll be guaranteed that there can be
> > no further opens on it.
>
> And is that the reason you propose this?
> - You want a special exclusive 'one time open' device that
>   self-destructs when closed?

Yes, this is the primary reason I'm exploring this. I tried to find an
implementation that might be useful in other situations which is why I
landed on this approach.

>
> > No, this is fully backwards compatible with the current deferred
> > remove behavior, it's not required. Additionally, since on the actual
> > remove userspace would receive an -ENXIO already once the remove
> > process has started it seems reasonable to return -ENXIO in the
> > deferred remove case when this flag is enabled.
>
> Well I feel it does break existing semantics which is why we wrote
> the code the way we did.  The state can be long-lived, the code
> that has it open might legitimately want to open it again in
> parallel etc. - in general this seems a bad idea.

Thanks for explaining and providing that context.

>
> But if the reason for this is basically "make it harder for
> anything else to access my encrypted swap" and to deliberately
> prevent access, then let's approach the requirement from that angle.
> Are there alternative implementations with interventions at different
> points?

Absolutely, we could perhaps create a new ioctl which allows the
caller to specify the maximum open count, and when the open count hits
that value it fails any new opens with -EBUSY. Perhaps this would be
enforced in dm_get_device? This type of behavior could theoretically
mimic the patch I mailed when used in conjunction with deferred
removal. Is this an approach you think might make more sense with the
existing design? Are there any implementation points you believe might
make more sense for such a feature?

>  Are there similar requirements for devices that don't need
> deferred remove?

I cannot immediately think of a situation where you'd do this without
deferred removal.

>  If this is indeed the best place to insert this type
> of restriction, then we should label it and document it accordingly so
> people don't mistakenly use it for the 'normal' case.  (We always keep
> libdevmapper and dmsetup in sync with kernel interface extensions, so
> we'd seek a tiny patch to do that too.)

Yes, absolutely. I'll happily send patches for userspace libraries,
applications, and documentation once we converge on an acceptable
approach.

Thanks again for spending your time discussing this,
Brian

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

