Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95912C6379F
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 07:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676360907;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Sb77f3FnQHzO2GY+1BV7BWE6kK2e1WlKpsM70ekj1M8=;
	b=DaUz8rTQmFQjKQu4489gpFMQ8Uv1/mxNG0LcNIMjTCQnQOkDCyt6HQnf6kboxI//W2Xfns
	K735yn0qqad2w7DA4ehJ/JziMdzLiSxkqJntgAVtUu8MgNS842ajsBOfhDRlU9xZVKqR+F
	M43NnH7OcQ3RH6UdtHaiDbpU7IefvhY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-7fLmKAXiO-mxDmYslqdOMw-1; Tue, 14 Feb 2023 02:48:24 -0500
X-MC-Unique: 7fLmKAXiO-mxDmYslqdOMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3AFE101A55E;
	Tue, 14 Feb 2023 07:48:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 576D12166B26;
	Tue, 14 Feb 2023 07:48:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD80F19465A8;
	Tue, 14 Feb 2023 07:48:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7AF01946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 21:12:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BF7E1C55A; Mon, 13 Feb 2023 21:12:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 645C118EC7
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 21:12:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33D402A5957B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 21:12:00 +0000 (UTC)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com
 [209.85.222.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-i_sZeFIEOC2rBKeP2_qztg-1; Mon, 13 Feb 2023 16:11:58 -0500
X-MC-Unique: i_sZeFIEOC2rBKeP2_qztg-1
Received: by mail-ua1-f53.google.com with SMTP id j1so2442119uan.1
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 13:11:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=6ZPCAt9iaKl4ylawbJPz9x0jubQ10EQyn5A2P4OMHS0=;
 b=QI43RhP3gdhStB7wadaqBEebocpXFEeClvjwy6b6W8GAiNrw0g0ONvpVDXF4Ag8psO
 w/QmlVzXOR4SGn7IsHmjaEW1eQI7SjLXXgv4YHNaC+421x4vcUC1riXenEq4jSATzhRr
 e3jhta/4x7KMPBbVIaOA230IQCSOX5SZB8Y0kTI86/8HjG+4AI30dNGwv9t09+xp9T0T
 wQfxzInEXtUgItX/ehj81HM8MF/9gzrqn0Ab7g1vrYb+mwusC/cIJDLVTTQ+KlxqRYyr
 eqG9pbiqaN8elYwdGi5dCYLuCwwjAxpoDxHnE145wwEMQhoTFjBh+adBVtggWs+TKH88
 wo3w==
X-Gm-Message-State: AO0yUKVwpLQLJ+rAPyKVgLg1n3huOC1Smwe8WCgdnW3Kf7bxNvSrukx8
 35PF8a/7Nnxm/XvsmmBMPwLlGGe3lhdLT1DzDoXh5tTNdbc=
X-Google-Smtp-Source: AK7set8kt3Gm3Fjyrsk+SHSRAkLbF+kb36gCT23fpnOZEtp6+i2RwapdbYhRkB2ndxJH5fQML7xJQPtv8XqMWI1eqNE=
X-Received: by 2002:ab0:2841:0:b0:632:a75f:8b40 with SMTP id
 c1-20020ab02841000000b00632a75f8b40mr4429715uaq.72.1676322717768; Mon, 13 Feb
 2023 13:11:57 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
In-Reply-To: <25578.37401.314298.238192@quad.stoffel.home>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Mon, 13 Feb 2023 13:11:46 -0800
Message-ID: <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
To: John Stoffel <john@stoffel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 14 Feb 2023 07:48:03 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> On Mon, Feb 13, 2023 at 11:40 AM John Stoffel <john@stoffel.org> wrote:
>
> >>>>> "Kyle" == Kyle Sanderson <kyle.leet@gmail.com> writes:
>
> > hi DM and Linux-RAID,
> > There have been multiple proprietary solutions (some nearly 20 years
> > old now) with a number of (userspace) bugs that are becoming untenable
> > for me as an end user. Basically how they work is a closed MD module
> > (typically administered through DM) that uses RAID4 for a dedicated
> > parity disk across multiple other disks.
>
> You need to explain what you want in *much* beter detail.  Give simple
> concrete examples.  From the sound of it, you want RAID6 but with
> RAID4 dedicated Parity so you can spin down some of the data disks in
> the array?  But if need be, spin up idle disks to recover data if you
> lose an active disk?

No, just a single dedicated parity disk - there's no striping on any
of the data disks. The result of this is you can lose 8 data disks and
the parity disk from an array of 10, and still access the last
remaining disk because each disk maintains a complete copy of their
own data. How the implementations do this is still expose each
individual disk (/dev/md*) that are formatted (+ encrypted)
independently, and when written to, update the parity information on
the dedicated disk. That way, when you add a new disk that's fully
zero'd to the array (parity disk is 16T, new disk is 4T), parity is
preserved. Any bytes written beyond the 4T barrier do not include
those disks in the parity calculation.

> Really hard to understand what exactly you're looking for here.

This might help https://www.snapraid.it/compare . There's at least
hundreds of thousands of these systems out there (based on public
sales from a single vendor), if not well into the millions.

Kyle.

On Mon, Feb 13, 2023 at 11:40 AM John Stoffel <john@stoffel.org> wrote:
>
> >>>>> "Kyle" == Kyle Sanderson <kyle.leet@gmail.com> writes:
>
> > hi DM and Linux-RAID,
> > There have been multiple proprietary solutions (some nearly 20 years
> > old now) with a number of (userspace) bugs that are becoming untenable
> > for me as an end user. Basically how they work is a closed MD module
> > (typically administered through DM) that uses RAID4 for a dedicated
> > parity disk across multiple other disks.
>
> You need to explain what you want in *much* beter detail.  Give simple
> concrete examples.  From the sound of it, you want RAID6 but with
> RAID4 dedicated Parity so you can spin down some of the data disks in
> the array?  But if need be, spin up idle disks to recover data if you
> lose an active disk?
>
> Really hard to understand what exactly you're looking for here.
>
>
> > As there is no striping, the maximum size of the protected data is the
> > size of the parity disk (so a set of 4+8+12+16 disks can be protected
> > by a single dedicated 16 disk).When a block is written on any disk,
> > the parity bit is read from the parity disk again, and updated
> > depending on the existing + new bit value (so writing disk + parity
> > disk spun up). Additionally, if enough disks are already spun up, the
> > parity information can be recalculated from all of the spinning disks,
> > resulting in a single write to the parity disk (without a read on the
> > parity, doubling throughput). Finally any of the data disks can be
> > moved around within the array without impacting parity as the layout
> > has not changed. I don't necessarily need all of these features, just
> > the ability to remove a disk and still access the data that was on
> > there by spinning up every other disk until the rebuild is complete is
> > important.
>
> > The benefit of this can be the data disks are all zoned, and you can
> > have a fast parity disk and still maintain excellent performance in
> > the array (limited only by the speed of the disk in question +
> > parity). Additionally, should 2 disks fail, you've either lost the
> > parity and data disk, or 2 data disks with the parity and other disks
> > not lost.
>
> > I was reading through the DM and MD code and it looks like everything
> > may already be there to do this, just needs (significant) stubs to be
> > added to support this mode (or new code). Snapraid is a friendly (and
> > respectable) implementation of this. Unraid and Synology SHR compete
> > in this space, as well as other NAS and enterprise SAN providers.
>
> > Kyle.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

