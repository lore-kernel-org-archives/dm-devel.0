Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACF9C47097
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:17:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1C5961402
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:17:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1C5961402
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622758625;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gawq8V5jmSA3c8LUdYbaJ5U/kT5OqnNMzI3psUtyh48=;
	b=b9/Owip6q48awntxhzLOBP9XBYejoxrhmuSLxIJ+m9ABROVv3Gj+GvN7i0SqDE66c+LIzs
	15bTNAaniGBQp87tmCRis2X5Vk6pAaQU3A96msFCNHEku+6qj3gRpJXl25vmyBjRG8efYN
	JQ3o0cYOuAOQ0dV6UYmoT7cpnfES3sk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-wSp6qIwkOAOAIGvvFxsAnQ-1; Thu, 03 Jun 2021 18:17:03 -0400
X-MC-Unique: wSp6qIwkOAOAIGvvFxsAnQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18165107ACC7;
	Thu,  3 Jun 2021 22:16:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F17C60D06;
	Thu,  3 Jun 2021 22:16:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 422A0E183;
	Thu,  3 Jun 2021 22:16:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 153MGtKj011692 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 18:16:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5DF5011E5B3; Thu,  3 Jun 2021 22:16:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5722911E5BB
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 22:16:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04B401857F1E
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 22:16:50 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
	[209.85.160.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-349-pQIwUI2bMn2wZgBgfBQVVA-1; Thu, 03 Jun 2021 18:16:48 -0400
X-MC-Unique: pQIwUI2bMn2wZgBgfBQVVA-1
Received: by mail-qt1-f182.google.com with SMTP id t17so5558615qta.11
	for <dm-devel@redhat.com>; Thu, 03 Jun 2021 15:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=qFuN6eT5h+wbstMj3EMiehBJecwbG0rCxSK9QUGY3Xc=;
	b=IRTpfSZnPCNIfseUxZPzDIWUN+NshzJlEyq49R9jEPbAwsiB31wNWxKciZ9b9oGBxA
	uleOFAgM25zbxZfCZKoXGXa79O27qawIbnda5lMXwqirXlqZ984wVFNNb4LsQi8tQVM7
	553jFVRmzweVqO7rcyyQ8WzBV6JU4J9EAuRcCzsr165PC49sb8b2ui4IFi+1MZ6LyZdV
	qTS6fDf1qLhMptFzmI4LNIDNO8469q0+WcdtxD5cvhP2jFiEhSFTc7FgNy2AS1EhX+zk
	G3Nj7LC7pL9a7zZwAC+wF2nyTNZEF6bEpgAJYkdVgmiAxu+pw7C09XovYZY97thjr8B5
	kw5w==
X-Gm-Message-State: AOAM531gYC6n+/gck1uZBISog9TCQrHlIUYtd3E7IikVHxZy4FGb10Q0
	EiNUrZQhh7bDkBke88hg9ZjzIM5y47cavA==
X-Google-Smtp-Source: ABdhPJwR5/TuuHiL4TwOD3rkiC3n62bwV8WOdWoergRrm2VJMeWiCuki4Zq5ELxlMZJOw5tYNtoMrA==
X-Received: by 2002:ac8:47c2:: with SMTP id d2mr180902qtr.128.1622758607537;
	Thu, 03 Jun 2021 15:16:47 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	137sm1926418qko.29.2021.06.03.15.16.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Jun 2021 15:16:46 -0700 (PDT)
Date: Thu, 3 Jun 2021 18:16:45 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <YLlUzX18P0V2lAek@redhat.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<DM6PR04MB708146E418BF65FC2F7847E3E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
	<YLfO168QXfAWJ9dn@redhat.com>
	<a972018e-781b-c0f8-d18a-168c3d1fe963@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <a972018e-781b-c0f8-d18a-168c3d1fe963@kernel.dk>
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 00/11] dm: Improve zoned block device
	support
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 03 2021 at  1:46P -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 6/2/21 12:32 PM, Mike Snitzer wrote:
> > On Tue, Jun 01 2021 at  6:57P -0400,
> > Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> > 
> >> On 2021/05/26 6:25, Damien Le Moal wrote:
> >>> This series improve device mapper support for zoned block devices and
> >>> of targets exposing a zoned device.
> >>
> >> Mike, Jens,
> >>
> >> Any feedback regarding this series ?
> >>
> >>>
> >>> The first patch improve support for user requests to reset all zones of
> >>> the target device. With the fix, such operation behave similarly to
> >>> physical block devices implementation based on the single zone reset
> >>> command with the ALL bit set.
> >>>
> >>> The following 2 patches are preparatory block layer patches.
> >>>
> >>> Patch 4 and 5 are 2 small fixes to DM core zoned block device support.
> >>>
> >>> Patch 6 reorganizes DM core code, moving conditionally defined zoned
> >>> block device code into the new dm-zone.c file. This avoids sprinkly DM
> >>> with zone related code defined under an #ifdef CONFIG_BLK_DEV_ZONED.
> >>>
> >>> Patch 7 improves DM zone report helper functions for target drivers.
> >>>
> >>> Patch 8 fixes a potential problem with BIO requeue on zoned target.
> >>>
> >>> Finally, patch 9 to 11 implement zone append emulation using regular
> >>> writes for target drivers that cannot natively support this BIO type.
> >>> The only target currently needing this emulation is dm-crypt. With this
> >>> change, a zoned dm-crypt device behaves exactly like a regular zoned
> >>> block device, correctly executing user zone append BIOs.
> >>>
> >>> This series passes the following tests:
> >>> 1) zonefs tests on top of dm-crypt with a zoned nullblk device
> >>> 2) zonefs tests on top of dm-crypt+dm-linear with an SMR HDD
> >>> 3) btrfs fstests on top of dm-crypt with zoned nullblk devices.
> >>>
> >>> Comments are as always welcome.
> > 
> > I've picked up DM patches 4-8 because they didn't depend on the first
> > 3 block patches.
> > 
> > But I'm fine with picking up 1-3 if Jens provides his Acked-by.
> > And then I can pickup the remaining DM patches 9-11.
> 
> I'm fine with 1-3, you can add my Acked-by to those.

Thanks, did so.

Damien: I've staged this patchset in linux-next via the dm-5.14 branch of linux-dm.git

Might look at optimizing the fast-path of __map_bio further, e.g. this
leaves something to be desired considering how niche this all is:

        /*
         * Check if the IO needs a special mapping due to zone append emulation
         * on zoned target. In this case, dm_zone_map_bio() calls the target
         * map operation.
         */
        if (dm_emulate_zone_append(io->md))
                r = dm_zone_map_bio(tio);
        else
                r = ti->type->map(ti, clone);

Does it make sense to split out a new CONFIG_ that encapsulates legacy
zoned devices?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

