Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9C7C64EC7
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453631;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NAQRoLqz0IFVwiMzLG7Vxy+imqZn2TRijjzZaHiuSpQ=;
	b=P8E1rTodOqZoLtmulZmGVDo0oTynUhR+ta4XrUCnQmCbIiG/eBmHi0FUiND6Zg+PRPFf21
	C2QXRHy7L4droxoEw1qDAXPuA3ViqQppDWQlt64Gp3hwu2zlXGh68yyiUXKnxuCwNbq9UB
	M46aCkzwE1BzOcpxeEilwLTEaskYZ/w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-0ksW32iOOpGQNj2qg0JRjw-1; Wed, 15 Feb 2023 04:33:48 -0500
X-MC-Unique: 0ksW32iOOpGQNj2qg0JRjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E173B803493;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE19E1121325;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2294319452CB;
	Wed, 15 Feb 2023 09:33:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C6231946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 07:23:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F75540B40E4; Wed, 15 Feb 2023 07:23:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7820040B40C9
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 07:23:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E1242807D6B
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 07:23:21 +0000 (UTC)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com
 [209.85.217.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-353-foUYxfZyNOCDEVJ-IkPONw-1; Wed, 15 Feb 2023 02:23:16 -0500
X-MC-Unique: foUYxfZyNOCDEVJ-IkPONw-1
Received: by mail-vs1-f44.google.com with SMTP id k4so18959774vsc.4;
 Tue, 14 Feb 2023 23:23:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1676445796;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=tAyp2EwBTKDmkRSvi384rqVQ6cxfxzWF6zUVOpX2DOQ=;
 b=rwlEogCxPT6GI85OtQlkMPNy+Z4g3tIbpX33oizi0hH0S8md4fgsPPT98ep4saxGOW
 AVzS8h9GIcN5h8hQ+P4H5/TINv8Cyz0R+EMIRHRL3/UBEr/yiEd2HSgAKIBejtL71Xoq
 5iCVXjBiVVRUkNqq1DKi9ggDLerXxwkVuA2t8IbPfufVFnT6tNvlrwpaNyiJBWLFth6G
 l5djtLJM1nH0h2pFW3AW9N9NaDCTXp87S042vAi8qneH0NF86E0X/bxDoILNoblmJ8Ac
 2iwgK3Rl2Rq3Ab+MhqQqSvnEEhRjc7LWR1GGQkvwo9aLEscX6D5IPH9LbOGcvgfIgFf9
 RFJA==
X-Gm-Message-State: AO0yUKX//B6xLxS0TLc7tnBXgr5Ln3HEIA7TGb2TjIFVbGbGSJ8vGzod
 P77l+uBvRNldUgdALx3HMvls/XXvPmqRaZx8V3uwQFzMaWg=
X-Google-Smtp-Source: AK7set9AudZ/Bhpl7dEpZejs4OV1t5b0SNb2UeQiGB7mYAUUz0OeGE3MPRX173q0QQTSMd9YxwPzTowXo2oIOryFI04=
X-Received: by 2002:a67:cb92:0:b0:412:2da0:b284 with SMTP id
 h18-20020a67cb92000000b004122da0b284mr235319vsl.26.1676445796123; Tue, 14 Feb
 2023 23:23:16 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
 <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
 <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
In-Reply-To: <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Tue, 14 Feb 2023 23:23:04 -0800
Message-ID: <CACsaVZLKEYWzr5zHwE+rCJpYKu0d8-fzQycvn8ow4b=kCSTtjg@mail.gmail.com>
To: Roger Heflin <rogerheflin@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> On Tue, Feb 14, 2023 at 2:28 PM Roger Heflin <rogerheflin@gmail.com> wrote:
>
> Such that you can lose any one data disk and parity can rebuild that
> disk.  And if you lose several data diskis, then you have intact
> non-striped data for the remaining disks.
>
> It would almost seem that you would need to put a separate filesystem
> on each data disk/section (or have a filesystem that is redundant
> enough to survive) otherwise losing an entire data disk would leave
> the filesystem in a mess..

Exactly, each disk operates completely independently (so a XFS
partition per disk on each md device). So I have 4 disks presently, 3
are data, and one is dedicated parity. I can scale up or down these
disks freely, changing the physical data disk sizes and still have
them all protected by the single parity disk by removing and adding
them to the array.

> On Tue, Feb 14, 2023 at 6:23 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
>
> as any of the currently implemented 'parity' algorithms (block xor/P-/Q-Syndrome) provided by DM/MD RAID
> have to have at least two data blocks to calculate:  are you, apart from the filesystem thoughts you bring up, thinking
> about running those on e.g. pairs of disks of mentioned even numbered set of 8?

Users of these appliances today gain "parity" by adding the second
disk (note it must be the equal to or the largest in the array), and
can scale by adding disk by disk individually (so 3, 4, 5, 6...).

Hopefully it's starting to make more sense now.

On Tue, Feb 14, 2023 at 2:28 PM Roger Heflin <rogerheflin@gmail.com> wrote:
>
> On Tue, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
> >
>
> >
> >
> > ...which is RAID1 plus a parity disk which seems superfluous as you achieve (N-1)
> > resilience against single device failures already without the later.
> >
> > What would you need such parity disk for?
> >
> > Heinz
> >
>
> I thought that at first too, but threw that idea out as it did not
> make much sense.
>
> What he appears to want is 8 linear non-striped data disks + a parity disk.
>
> Such that you can lose any one data disk and parity can rebuild that
> disk.  And if you lose several data diskis, then you have intact
> non-striped data for the remaining disks.
>
> It would almost seem that you would need to put a separate filesystem
> on each data disk/section (or have a filesystem that is redundant
> enough to survive) otherwise losing an entire data disk would leave
> the filesystem in a mess..
>
> So N filesystems + a parity disk for the data on the N separate
> filesystems.   And each write needs you to read the data from the disk
> you are writing to, and the parity and recalculate the new parity and
> write out the data and new parity.
>
> If the parity disk was an SSD it would be fast enough, but if parity
> was an SSD I would expect it to get used up/burned out from all of
> parity being re-written for each write on each disk unless you bought
> an expensive high-write ssd.
>
> The only advantage of the setup is that if you lose too many disks you
> still have some data.
>
> It is not clear to me that it would be any cheaper if parity needs to
> be a normal ssd's (since ssds are about 4x the price/gb and high-write
> ones are even more) than a classic bunch of mirrors, or even say a 4
> disks raid6 where you can lose any 2 and still have data.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

