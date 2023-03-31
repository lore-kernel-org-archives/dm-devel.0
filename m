Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9BBC76196
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 05:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680240170;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1KzIduEKR0PhrbbtOAq0jdznOJoK3hOmRLm22OEXf+I=;
	b=KWuOvykmGHeM/OhMS/zBoJbzokdLqquSHA6xcVClgMSlVy1hbFQj4JMEQrj+C2SQWISGXN
	8GE8kwHJGQEPacGqfcv54NPkgzF+d95n7Uw4TLvYygGk9S6YzyOnDPa8ogshAJv6PzhJG8
	joTOKkmdk2R3pQDZUSTBdDMx30GBmMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-KSLl2JSdNg2AFo9zV-i_Fg-1; Fri, 31 Mar 2023 01:22:49 -0400
X-MC-Unique: KSLl2JSdNg2AFo9zV-i_Fg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B43E7887410;
	Fri, 31 Mar 2023 05:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECD76492B0A;
	Fri, 31 Mar 2023 05:22:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 723F81946A69;
	Fri, 31 Mar 2023 05:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF7811946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 00:28:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A18A1492B00; Fri, 31 Mar 2023 00:28:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA64492C3E
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 00:28:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80C161C05133
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 00:28:49 +0000 (UTC)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com
 [209.85.208.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-1leAL2IyPSaQ90oAG2seew-2; Thu, 30 Mar 2023 20:28:47 -0400
X-MC-Unique: 1leAL2IyPSaQ90oAG2seew-2
Received: by mail-ed1-f47.google.com with SMTP id y4so83522033edo.2
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 17:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680222527;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=L/321qEfsdd6Li2EcEMfqC9Li7rtjZommEiuh2gRTto=;
 b=ousn4z/ijE26dzuAJ3XvABsztfmamgcFBkbafwCea/FQ29k/rAJ8mAhBMHaGcxWDSj
 Ewp7lnN2qr+vt71VHPtuEkNXGCVx+40bAJMDjDzjblraCdXYXE4VoFBEIg8ZXKoHYePv
 giKOkl6UBlvD5q4GqWt7Yv0koThRkN43GdjsftussZNye4k5Bkf7ZY57cWpvKzwhtKdp
 0unbuWkOhuHm2AMslgrNXJ0dPZd5dtzY61zhCKrmy8fy3h9ejwj85s5oPfr7y83QetB3
 LmzZWJaCtoPVMIwkDCSiy0AzQuL6yc3lu71aEFtZA916C1yHV7Z6fRuQpOCtHR6Q179i
 eMkA==
X-Gm-Message-State: AAQBX9flwjadIrWohmT+p0HjZm4PrDDbRrKAfDexkjhr09G8xcePgi9q
 9Zq3rjo6nv5hr/V4lPWKqgjtSRiMkVSBU1AcxAluvg==
X-Google-Smtp-Source: AKy350YiyWxtdKYS11gbPuOdxgKie3I79uhb6oCaV13YfwgHdVzTkX0BBGKglxLUIUEpEZMbv4YpUX4X2kCh3ahutsM=
X-Received: by 2002:a17:907:3e8b:b0:931:ce20:db6e with SMTP id
 hs11-20020a1709073e8b00b00931ce20db6emr14070290ejc.2.1680222526978; Thu, 30
 Mar 2023 17:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
 <20221229081252.452240-4-sarthakkukreti@chromium.org>
 <Y7Wr2uadI+82BB6a@magnolia>
 <CAG9=OMNbeU=Xg5bWvHUSfzRf8vsk6csvcw5BGZeMD5Lo7dfKFQ@mail.gmail.com>
 <Y7bxjKusa2L/TNRE@mit.edu>
In-Reply-To: <Y7bxjKusa2L/TNRE@mit.edu>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 30 Mar 2023 17:28:35 -0700
Message-ID: <CAG9=OMM_0D+ck6=0dfjBi0B_zqTbp3i28tFDr8c3e1TQip1sQA@mail.gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 31 Mar 2023 05:22:41 +0000
Subject: Re: [dm-devel] [PATCH v2 3/7] fs: Introduce FALLOC_FL_PROVISION
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
 "Michael S. Tsirkin" <mst@redhat.com>, sarthakkukreti@google.com,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 5, 2023 at 7:49 AM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Wed, Jan 04, 2023 at 01:22:06PM -0800, Sarthak Kukreti wrote:
> > > How expensive is this expected to be?  Is this why you wanted a separate
> > > mode flag?
> >
> > Yes, the exact latency will depend on the stacked block devices and
> > the fragmentation at the allocation layers.
> >
> > I did a quick test for benchmarking fallocate() with an:
> > A) ext4 filesystem mounted with 'noprovision'
> > B) ext4 filesystem mounted with 'provision' on a dm-thin device.
> > C) ext4 filesystem mounted with 'provision' on a loop device with a
> > sparse backing file on the filesystem in (B).
> >
> > I tested file sizes from 512M to 8G, time taken for fallocate() in (A)
> > remains expectedly flat at ~0.01-0.02s, but for (B), it scales from
> > 0.03-0.4s and for (C) it scales from 0.04s-0.52s (I captured the exact
> > time distribution in the cover letter
> > https://marc.info/?l=linux-ext4&m=167230113520636&w=2)
> >
> > +0.5s for a 8G fallocate doesn't sound a lot but I think fragmentation
> > and how the block device is layered can make this worse...
>
> If userspace uses fallocate(2) there are generally two reasons.
> Either they **really** don't want to get the NOSPC, in which case
> noprovision will not give them what they want unless we modify their
> source code to add this new FALLOC_FL_PROVISION flag --- which may not
> be possible if it is provided in a binary-only format (for example,
> proprietary databases shipped by companies beginning with the letters
> 'I' or 'O').
>
> Or, they really care about avoiding fragmentation by giving a hint to
> the file system that layout is important, and so **please** allocate
> the space right away so that it is more likely that the space will be
> laid out in a contiguous fashion.  Of course, the moment you use
> thin-provisioning this goes out the window, since even if the space is
> contiguous on the dm-thin layer, on the underlying storage layer it is
> likely that things will be fragmented to a fare-thee-well, and either
> (a) you have a vast amount of flash to try to mitigate the performance
> hit of using thin-provisioning (example, hardware thin-provisioning
> such as EMC storage arrays), or (b) you really don't care about
> performance since space savings is what you're going for.
>
> So.... because of the issue of changing the semantics of what
> fallocate(2) will guarantee, unless programs are forced to change
> their code to use this new FALLOC flag, I really am not very fond of
> it.
>
> I suspect that using a mount option (which should default to
> "provision"; if you want to break user API expectations, it should
> require a mount option for the system administrator to explicitly OK
> such a change), is OK.
>
Understood. I dropped the FALLOC flag from the series in v3, instead
we now rely on the filesystem's mount/policy.

> As far as the per-file mode --- I'm not convinced it's really
> necessary.  In general if you are using thin-provisioning file systems
> tend to be used explicitly for one purpose, so adding the complexity
> of doing it on a per-file basis is probably not really needed.  That
> being said, your existing prototype requires searching for the
> extended attribute on every single file allocation, which is not a
> great idea.  On a system with SELinux enabled, every file will have an
> xattr block, and requiring that it be searched on every file
> allocation would be unfortunate.  It would be better to check for the
> xattr when the file is opened, and then setting a flag in the struct
> file.  However, it might be better to see if it there is a real demand
> for such a feature before adding it.
>
Thanks for the feedback! On ChromeOS, we still have filesystems shared
between applications, partly due to inertia of adoption. So, we have a
few cases of needing to share the filesystem but with differing
provisioning policy.

One more idea that I've been exploring in this space and uses the
above file-based mechanism is to use a 'provisioning disabled'
fallocated file to make the apparent free space in the thinly
provisioned filesystem match the space available in the thinpool. In
theory, this prevents userspace applications from writing much more
than what's available on the thinpool. In practice, it depends on the
responsiveness of the service that monitors and resizes this 'storage
balloon'.

Best
Sarthak

>                                                 - Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

