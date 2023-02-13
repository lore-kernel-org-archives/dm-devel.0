Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A61C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 19:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676317783;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0hfYNxwE/REDE7cmR9EsngHox61rqR5GIfSWQTL1esY=;
	b=J8y/dNDmhp76Vr1NUYyzPE/t+HRxE+FM3hL8Mbl3h2e3+CUJc+ySi+UJLg6P4LCW6UF0a9
	72s+eczsfZVKZlYYYEZYzyoQ3jlmnS+UpvhlXKMMMAwBQ79p61eeVQvvSZOVTLQmk+2Cid
	WvmKAMe5li6Xw3xsm0m2cQPiIx3y1So=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-MSkyZs4pMeKGgXCR0uZzdQ-1; Mon, 13 Feb 2023 14:49:39 -0500
X-MC-Unique: MSkyZs4pMeKGgXCR0uZzdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D9F588B767;
	Mon, 13 Feb 2023 19:49:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40C1C40398A0;
	Mon, 13 Feb 2023 19:49:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E9B691946588;
	Mon, 13 Feb 2023 19:49:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9384D1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 19:49:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44D4C1121319; Mon, 13 Feb 2023 19:49:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C9BE1121318
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 19:49:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140D01C05EBF
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 19:49:07 +0000 (UTC)
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-269-wH1K40VCPgqH_DJXvVJ7zA-1; Mon,
 13 Feb 2023 14:49:04 -0500
X-MC-Unique: wH1K40VCPgqH_DJXvVJ7zA-1
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com
 [68.116.170.226])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mail.stoffel.org (Postfix) with ESMTPSA id 725011E131;
 Mon, 13 Feb 2023 14:40:10 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
 id 57E09A83C9; Mon, 13 Feb 2023 14:40:09 -0500 (EST)
MIME-Version: 1.0
Message-ID: <25578.37401.314298.238192@quad.stoffel.home>
Date: Mon, 13 Feb 2023 14:40:09 -0500
From: "John Stoffel" <john@stoffel.org>
To: Kyle Sanderson <kyle.leet@gmail.com>
In-Reply-To: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 Linux-Kernel <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "Kyle" == Kyle Sanderson <kyle.leet@gmail.com> writes:

> hi DM and Linux-RAID,
> There have been multiple proprietary solutions (some nearly 20 years
> old now) with a number of (userspace) bugs that are becoming untenable
> for me as an end user. Basically how they work is a closed MD module
> (typically administered through DM) that uses RAID4 for a dedicated
> parity disk across multiple other disks.

You need to explain what you want in *much* beter detail.  Give simple
concrete examples.  From the sound of it, you want RAID6 but with
RAID4 dedicated Parity so you can spin down some of the data disks in
the array?  But if need be, spin up idle disks to recover data if you
lose an active disk?  

Really hard to understand what exactly you're looking for here.


> As there is no striping, the maximum size of the protected data is the
> size of the parity disk (so a set of 4+8+12+16 disks can be protected
> by a single dedicated 16 disk).When a block is written on any disk,
> the parity bit is read from the parity disk again, and updated
> depending on the existing + new bit value (so writing disk + parity
> disk spun up). Additionally, if enough disks are already spun up, the
> parity information can be recalculated from all of the spinning disks,
> resulting in a single write to the parity disk (without a read on the
> parity, doubling throughput). Finally any of the data disks can be
> moved around within the array without impacting parity as the layout
> has not changed. I don't necessarily need all of these features, just
> the ability to remove a disk and still access the data that was on
> there by spinning up every other disk until the rebuild is complete is
> important.

> The benefit of this can be the data disks are all zoned, and you can
> have a fast parity disk and still maintain excellent performance in
> the array (limited only by the speed of the disk in question +
> parity). Additionally, should 2 disks fail, you've either lost the
> parity and data disk, or 2 data disks with the parity and other disks
> not lost.

> I was reading through the DM and MD code and it looks like everything
> may already be there to do this, just needs (significant) stubs to be
> added to support this mode (or new code). Snapraid is a friendly (and
> respectable) implementation of this. Unraid and Synology SHR compete
> in this space, as well as other NAS and enterprise SAN providers.

> Kyle.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

