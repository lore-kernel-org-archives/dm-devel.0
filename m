Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8542CC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 06:09:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-tkq74WESNHeGL0P_Jm89kg-1; Mon, 21 Feb 2022 01:08:59 -0500
X-MC-Unique: tkq74WESNHeGL0P_Jm89kg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE6C1006AA0;
	Mon, 21 Feb 2022 06:08:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EA575E480;
	Mon, 21 Feb 2022 06:08:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 765291806D1D;
	Mon, 21 Feb 2022 06:08:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21JN130d015649 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 19 Feb 2022 18:01:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B01140C1241; Sat, 19 Feb 2022 23:01:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66685400E10C
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 23:01:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EB0380005D
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 23:01:03 +0000 (UTC)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
	[209.85.166.172]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-587-PrafripFOai68BeEGulEjg-1; Sat, 19 Feb 2022 18:01:01 -0500
X-MC-Unique: PrafripFOai68BeEGulEjg-1
Received: by mail-il1-f172.google.com with SMTP id 9so6601704ily.11
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 15:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=JsTvQXRsbNOiGcu58U9fFMq2V+cC9hbrFYaW/h3E+1g=;
	b=d0Bytvdqwc3KUaGxAvOAeKvXkJ5qwUlChEccIivefZU1jqLZgZHkoLHkwHnXOJKrOl
	4qx88dVxye4fj6WdLPmSz6IfMH43YbTDtORytcGRmdmMNDW8B6awTAUSqMQzjblnND9l
	J3x+oqLTb0ZhLwc6I/s4i6ll1Z+0dyhgte+UyGCCWxeTk8BgjlXVyUMqzK+1vDYIjZic
	2tXzDGBTwKuhiPgIBMb+i40r1O8r1k19CAzBd2EJYSC49I/lpAvr6plOKgJAAfJrx92F
	7XGigWfHo3GvScKt8GsDPwV8BQilVU4//qu3zgd767xOtKDVNx8YEYVfcjCSNnrRKoyA
	o9VA==
X-Gm-Message-State: AOAM530M0zRwP/68lfMOlA8RnWME8ht8BuT53BQqxUu9oX5Ai0wfneYF
	0YqErE9VE5JV/rq2hKIHFruGvg1SeZz9rRZKoip7coANS2zomA==
X-Google-Smtp-Source: ABdhPJxAq6Xhci6X8EyjKISKWHQB8A7GAnQkTQsSYKWI9pTBuyyqr9uAdwughLQMbr6RkpSBKXR6D5MB/Sif6OYt2oU=
X-Received: by 2002:a92:cd8c:0:b0:2be:abb:ec04 with SMTP id
	r12-20020a92cd8c000000b002be0abbec04mr10635076ilb.246.1645311660937;
	Sat, 19 Feb 2022 15:01:00 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
In-Reply-To: <20220219210354.GF59715@dread.disaster.area>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Sat, 19 Feb 2022 15:00:51 -0800
Message-ID: <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 21 Feb 2022 01:04:54 -0500
Cc: giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
	pablo.marcos.oltra@intel.com,
	Greg KH <gregkh@linuxfoundation.org>, qat-linux@intel.com,
	Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, salvatore.benedetto@intel.com,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

hi Dave,

> This really sounds like broken hardware, not a kernel problem.

It is indeed a hardware issue, specifically the intel qat crypto
driver that's in-tree - the hardware is fine (see below). The IQAT
eratta documentation states that if a request is not submitted
properly it can stall the entire device. The remediation guidance from
2020 was "don't do that" and "don't allow unprivileged users access to
the device". The in-tree driver is not implemented properly either for
this SoC or board - I'm thinking it's related to QATE-7495.

https://01.org/sites/default/files/downloads//336211qatsoftwareforlinux-rn-hwversion1.7021.pdf

> This implies a dmcrypt level problem - XFS can't make progress is dmcrypt is not completing IOs.

That's the weird part about it. Some bio's are completing, others are
completely dropped, with some stalling forever. I had to use
xfs_repair to get the volumes operational again. I lost a good deal of
files and had to recover from backup after toggling the device back on
on a production system (silly, I know).

> Where are the XFS corruption reports that the subject implies is occurring?

I think you're right, it's dm-crypt that's broken here, with
ultimately the crypto driver causing this corruption. XFS being the
edge to the end-user is taking the brunt of it. There's reports going
back to late 2017 of significant issues with this mainlined stable
driver.

https://bugzilla.redhat.com/show_bug.cgi?id=1522962
https://serverfault.com/questions/1010108/luks-hangs-on-centos-running-on-atom-c3758-cpu
https://www.phoronix.com/forums/forum/software/distributions/1172231-fedora-33-s-enterprise-linux-next-effort-approved-testbed-for-raising-cpu-requirements-etc?p=1174560#post1174560

Any guidance would be appreciated.
Kyle.
On Sat, Feb 19, 2022 at 1:03 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Feb 18, 2022 at 09:02:28PM -0800, Kyle Sanderson wrote:
> > A2SDi-8C-HLN4F has IQAT enabled by default, when this device is
> > attempted to be used by xfs (through dm-crypt) the entire kernel
> > thread stalls forever. Multiple users have hit this over the years
> > (through sporadic reporting) - I ended up trying ZFS and encryption
> > wasn't an issue there at all because I guess they don't use this
> > device. Returning to sanity (xfs), I was able to provision a dm-crypt
> > volume no problem on the disk, however when running mkfs.xfs on the
> > volume is what triggers the cascading failure (each request kills a
> > kthread).
>
> Can you provide the full stack traces for these errors so we can see
> exactly what this cascading failure looks like, please? In reality,
> the stall messages some time after this are not interesting - it's
> the first errors that cause the stall that need to be investigated.
>
> A good idea would be to provide the full storage stack decription
> and hardware in use, as per:
>
> https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> > Disabling IQAT on the south bridge results in a working
> > system, however this is not the default configuration for the
> > distribution of choice (Ubuntu 20.04.3 LTS), nor the motherboard. I'm
> > convinced this never worked properly based on the lack of popularity
> > for kernel encryption (crypto), and the embedded nature that
> > SuperMicro has integrated this device in collaboration with intel as
> > it looks like the primary usage is through external accelerator cards.
>
> This really sounds like broken hardware, not a kernel problem.
>
> > Kernels tried were from RHEL8 over a year ago, and this impacts the
> > entirety of the 5.4 series on Ubuntu.
> > Please CC me on replies as I'm not subscribed to all lists. CPU is C3758.
>
> [snip stalled kcryptd worker threads]
>
> This implies a dmcrypt level problem - XFS can't make progress is
> dmcrypt is not completing IOs.
>
> Where are the XFS corruption reports that the subject implies is
> occurring?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

