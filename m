Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96325C61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 08:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676536032;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AXUuBS4jz9zS5lJ5vq5eFysa1Nih9ZT/vshGqVO1q24=;
	b=YDoGi5pq4X1D3dcl5Kni11gvkc50uJ8HNjvWYMgu0wRKxfJ9NE6A+CWd3gqK0nvv2cprp/
	gjxwTJj5x6QXVnZHFsarJ3cuURWdej3HBVb86EMG4zbLDAegCDSwI76GIs7rzRwny+JgOG
	SPF4T0xm+8nZs8LT1RI66AyQLcnE2fU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346--BqCSinWNrSAp6yMKODW2g-1; Thu, 16 Feb 2023 03:27:09 -0500
X-MC-Unique: -BqCSinWNrSAp6yMKODW2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A927100F90E;
	Thu, 16 Feb 2023 08:27:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69B182166B30;
	Thu, 16 Feb 2023 08:27:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19A32194658C;
	Thu, 16 Feb 2023 08:27:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BA7B1946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 00:02:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DBE1C15BAD; Thu, 16 Feb 2023 00:02:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7600FC15BA0
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 00:02:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 541893C02543
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 00:02:11 +0000 (UTC)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com
 [209.85.222.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-641-MHN0NweDOTqIfamCWX_7JA-1; Wed, 15 Feb 2023 19:02:09 -0500
X-MC-Unique: MHN0NweDOTqIfamCWX_7JA-1
Received: by mail-ua1-f44.google.com with SMTP id r12so61138uan.12;
 Wed, 15 Feb 2023 16:02:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=H7+6qQa+p0mgRiuJ1OJVWY0HGLNJgAvVISPrwm3CHGc=;
 b=hQYyZRMFMhxu8siV8V7Ah3PDmumJq7pu/WcFVVAXqPjWjh5R9jG+Yub8gpNPOGwkDx
 pxK+QKyUnsSy5kbrPkpbnvJNCWxWmlnExNcFHofqHvTvqcp1OGnF0oauWHquXKofLKOw
 jfRU8FyQPw+1rZ/fCnj8yl28OyN7yA8u5bnHZ+Ryr5GGl4+Zi/jjasVGgh5XL6yQplmk
 KPc+wVbLEtAifqxLTY1lXsw75X//nj7JQYLo23UIudV10wl515YFvvH4Q/TYHHz4MOzz
 utpgdyra5irAYP3f+cJ7tHSYKo5lnzrWwHlXBEotDwCwZRxwU9A8Ky8G69npwa7PmvCK
 AT2A==
X-Gm-Message-State: AO0yUKVNH8BPg0MIERGGDSFwNrv3RyKDfNySuvPHzE430Lja6ri/ARZT
 e79mXYUINDFihZxrcQmc8dHvrnTDlr80e5YAzLa2wfNuXe0=
X-Google-Smtp-Source: AK7set8i0RSR1WbmCEWS/0IYke3YKLUGyjLlsV0tEdHcrXVBsL3AafZ/9/47K8J2wttvP+cHORFMXNhXBoVdW8o0Njc=
X-Received: by 2002:ab0:7e8e:0:b0:68a:57ea:ca48 with SMTP id
 j14-20020ab07e8e000000b0068a57eaca48mr379751uax.77.1676505728700; Wed, 15 Feb
 2023 16:02:08 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
 <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
 <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
 <CAM23VxpzY6qYsdTYxe01FT7AJvEbODf8X_vq8ALL35TfyrB8xQ@mail.gmail.com>
 <CAAMCDee2hV1YP=119Rorz1uGTnyBD5q9hb20PvMq89FHow2wPw@mail.gmail.com>
In-Reply-To: <CAAMCDee2hV1YP=119Rorz1uGTnyBD5q9hb20PvMq89FHow2wPw@mail.gmail.com>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Wed, 15 Feb 2023 16:01:56 -0800
Message-ID: <CACsaVZJeC=6f4aGmnfdh1iSj77YQuTduQyXeADKJHnpC1aNWLQ@mail.gmail.com>
To: Roger Heflin <rogerheflin@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 16 Feb 2023 08:27:05 +0000
Subject: Re: [dm-devel] RAID4 with no striping mode request
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, John Stoffel <john@stoffel.org>,
 Linux-Kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, device-mapper development <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> On Wed, Feb 15, 2023 at 3:44 AM Roger Heflin <rogerheflin@gmail.com> wrote:
>
> I think he is wanting the parity across the data blocks on the
> separate filesystems (some sort of parity across fs[1-8]/block0 to
> parity/block0).

Correct.

> On Wed, Feb 15, 2023 at 3:44 AM Roger Heflin <rogerheflin@gmail.com> wrote:
> it is not clear to me what this setup would be enough better than what
> the current setups.    Given that one could have 8 spin + 1ssd or 12
> spin for the same price.    And 2 6 disk raid6's would have the same
> usable space, and be pretty safe (can lose any 2 of the 6 and lose no
> data).

They're not the same price though. Remember these disks are mixed
sizes and various ages, exposing their entire data value
(4d+8d+12d+12p gives you 24T of usable storage) all protected by the
single parity disk.

Yes, higher levels of RAID will always be better. However, that's not
how these millions of appliances are developed by a number of
manufacturers and sold at your local retailer. The proposal (and ask
for help) that I've raised is to have an open-source solution to these
proprietary MD implementations, as opposed to being trapped with buggy
MD drivers on firmware that's glitchy and breaks other aspects of the
kernel.

> On Wed, Feb 15, 2023 at 3:44 AM Roger Heflin <rogerheflin@gmail.com> wrote:
> And given the separate filesystems requirement that would
> require some software above the filesystems to manage spreading the
> disks across multiple filesystems.   The risk of another disk going
> bad (while one was failed) and losing a disk's worth of data would
> push me to use the 6-disk raid6.

This is long solved by a number of FUSE filesystems, as well as
overlayfs (which would be nice if it could gradually spool data down
into layers, but that's another ball of wax).

Hopefully that makes sense. The only thing that's coming closer to
this is bcachefs, but that's still looking like a multi-year long road
(with the above being deployed in homes since the early 2000s).

On Wed, Feb 15, 2023 at 3:44 AM Roger Heflin <rogerheflin@gmail.com> wrote:
>
> I think he is wanting the parity across the data blocks on the
> separate filesystems (some sort of parity across fs[1-8]/block0 to
> parity/block0).
>
> it is not clear to me what this setup would be enough better than what
> the current setups.    Given that one could have 8 spin + 1ssd or 12
> spin for the same price.    And 2 6 disk raid6's would have the same
> usable space, and be pretty safe (can lose any 2 of the 6 and lose no
> data).  And given the separate filesystems requirement that would
> require some software above the filesystems to manage spreading the
> disks across multiple filesystems.   The risk of another disk going
> bad (while one was failed) and losing a disk's worth of data would
> push me to use the 6-disk raid6.
>
> WOL: current SSD's are rated for around 1000-2000 writes.  So a 1Tb
> disk can sustain 1000-2000TB of total writes.  And writes to
> filesystem blocks would get re-written more often than data blocks.
>  How well it would work would depend on how often the data is deleted
> and re-written.   If the disks are some sort of long term storage then
> the SSD is not going to get used up.   And I am not sure if the rated
> used up really means anything unless you are using a STUPID enterprise
> controller that proactively disables/kills the SSD when it says the
> rated writes have happened.   I have a 500GB ssd in a mirror that
> "FAILED" according to smart 2 years ago and so far is still fully
> functional, and it is "GOOD" again because the counters used to
> determine total writes seems to have rolled over.
>
> On Tue, Feb 14, 2023 at 8:23 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
> >
> > Roger,
> >
> > as any of the currently implemented 'parity' algorithms (block xor/P-/Q-Syndrome) provided by DM/MD RAID
> > have to have at least two data blocks to calculate:  are you, apart from the filesystem thoughts you bring up, thinking
> > about running those on e.g. pairs of disks of mentioned even numbered set of 8?
> >
> > Heinz
> >
> > On Tue, Feb 14, 2023 at 11:28 PM Roger Heflin <rogerheflin@gmail.com> wrote:
> >>
> >> On Tue, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
> >> >
> >>
> >> >
> >> >
> >> > ...which is RAID1 plus a parity disk which seems superfluous as you achieve (N-1)
> >> > resilience against single device failures already without the later.
> >> >
> >> > What would you need such parity disk for?
> >> >
> >> > Heinz
> >> >
> >>
> >> I thought that at first too, but threw that idea out as it did not
> >> make much sense.
> >>
> >> What he appears to want is 8 linear non-striped data disks + a parity disk.
> >>
> >> Such that you can lose any one data disk and parity can rebuild that
> >> disk.  And if you lose several data diskis, then you have intact
> >> non-striped data for the remaining disks.
> >>
> >> It would almost seem that you would need to put a separate filesystem
> >> on each data disk/section (or have a filesystem that is redundant
> >> enough to survive) otherwise losing an entire data disk would leave
> >> the filesystem in a mess..
> >>
> >> So N filesystems + a parity disk for the data on the N separate
> >> filesystems.   And each write needs you to read the data from the disk
> >> you are writing to, and the parity and recalculate the new parity and
> >> write out the data and new parity.
> >>
> >> If the parity disk was an SSD it would be fast enough, but if parity
> >> was an SSD I would expect it to get used up/burned out from all of
> >> parity being re-written for each write on each disk unless you bought
> >> an expensive high-write ssd.
> >>
> >> The only advantage of the setup is that if you lose too many disks you
> >> still have some data.
> >>
> >> It is not clear to me that it would be any cheaper if parity needs to
> >> be a normal ssd's (since ssds are about 4x the price/gb and high-write
> >> ones are even more) than a classic bunch of mirrors, or even say a 4
> >> disks raid6 where you can lose any 2 and still have data.
> >>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

