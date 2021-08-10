Return-Path: <SRS0=j8cp=NB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E43DC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 10 Aug 2021 13:14:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D04966101E
	for <dm-devel@archiver.kernel.org>; Tue, 10 Aug 2021 13:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D04966101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628601240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=se8qq0Rox3l4K8YEf+Fqno1Qb1QceJyYUZTYKNncswU=;
	b=W3tEDtb2JL73H3ATkxkiHStNHGPIwj/9Z3UHzXjysDeSfpkXf3VeNB9au0D7BhuoAyxyyZ
	I8XOaXz1H9TUAJB75OqZTjUYCChqyneOTDu/iZamK5NGS4BwzdnmYhJ7+2hyae/oSMOqbM
	qWoE1FWhV6HGisA5qlPX3gXfBWY14Fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-Hg_2Ff0COq6EYeb4ew93tg-1; Tue, 10 Aug 2021 09:13:59 -0400
X-MC-Unique: Hg_2Ff0COq6EYeb4ew93tg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1902107ACF5;
	Tue, 10 Aug 2021 13:13:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48CBF69323;
	Tue, 10 Aug 2021 13:13:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A9AD04BB7C;
	Tue, 10 Aug 2021 13:13:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17ADCcP6015101 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 10 Aug 2021 09:12:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0158A20341D6; Tue, 10 Aug 2021 13:12:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F10A620341D5
	for <dm-devel@redhat.com>; Tue, 10 Aug 2021 13:12:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DD6C101A529
	for <dm-devel@redhat.com>; Tue, 10 Aug 2021 13:12:33 +0000 (UTC)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-499-JjCZjz2-NxCmVTG3_ip_YA-1; Tue, 10 Aug 2021 09:12:32 -0400
X-MC-Unique: JjCZjz2-NxCmVTG3_ip_YA-1
Received: by mail-wm1-f70.google.com with SMTP id
	r21-20020a05600c35d5b02902e685ef1f76so995829wmq.5
	for <dm-devel@redhat.com>; Tue, 10 Aug 2021 06:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=R4vBz2mMGvhkdtkFiw2NditsBGmKPW13//Cafaw3E4Y=;
	b=Xyi7F6uDCf0+/aqFNKNzZpkR3e/nUUysrQnJvtZxEQQQLt3D/2Cg7/GoTSOk1FqKNG
	uHIdKI8YTqCigxBtoGGUgiUWpUONnsu6Gy1NA6WgwXrQmIenKsZsSHEha3kiuoGe0ZMR
	GANfKl4KrMZtZnOiXPb168ROj9MKJcJdvZcYQWqk6n5/mGvI2r+PnJm3owAvlyZzoaQW
	cMEqxhDPfG104NKBRg/Qd9ofsy+pbg01D1FItNlFP/ktzeFFJ3PvFYRvN0mzPkKX3V2c
	EsMwsooyFLYNVgPaD5ugF64Bd8B2/fe4fyxX3T3QvzXzvqE1h7GhAiD+tFRgs8BRnXn9
	otBA==
X-Gm-Message-State: AOAM531qon+O9oSUJm46A/1xqDhKevpm8LU0CLKLUzFHnlkOQD9+fmou
	WtyOriAXk9sCDPkOci3KPpPbeRrrMSwj+j/Qpl7fWv0PnRpnUwVmzpZ1Vn0eKvUuoCbkjmoHFbP
	B0xegeZhuQZsVZbY=
X-Received: by 2002:a05:600c:19cd:: with SMTP id
	u13mr716221wmq.143.1628601150974; 
	Tue, 10 Aug 2021 06:12:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8QSATE7swL8AuNZTG+EQ7iM068PEVg5iYNL8Kim1eedQZqEzh50p3XA1cUFN9ZRJ6UananQ==
X-Received: by 2002:a05:600c:19cd:: with SMTP id
	u13mr716192wmq.143.1628601150735; 
	Tue, 10 Aug 2021 06:12:30 -0700 (PDT)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[213.175.37.10])
	by smtp.gmail.com with ESMTPSA id d4sm8830733wrc.34.2021.08.10.06.12.30
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 10 Aug 2021 06:12:30 -0700 (PDT)
Date: Tue, 10 Aug 2021 15:12:27 +0200
From: Peter Rajnoha <prajnoha@redhat.com>
To: Alasdair G Kergon <agk@redhat.com>
Message-ID: <20210810131227.ofgfi62agal64nqd@alatyr-rpi.brq.redhat.com>
References: <20210804094147.459763-8-hch@lst.de>
	<20210809233143.GA101480@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210809233143.GA101480@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 7/8] dm: delay registering the gendisk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue 10 Aug 2021 00:31, Alasdair G Kergon wrote:
> On Wed, Aug 04, 2021 at 11:41:46AM +0200, Christoph Hellwig wrote:
> > device mapper is currently the only outlier that tries to call
> > register_disk after add_disk, leading to fairly inconsistent state
> > of these block layer data structures.  
> 
> > Note that this introduces a user visible change: the dm kobject is
> > now only visible after the initial table has been loaded.
> 
> Indeed.  We should try to document the userspace implications of this
> change in a bit more detail.  While lvm2 and any other tools that
> followed our recommendations about how to use dm should be OK, there's
> always the chance that some other less robustly-written code will need
> to make adjustments.
> 
> Currently to make a dm device, 3 ioctls are called in sequence:
> 
> 1. DM_DEV_CREATE  - triggers 'add' uevents
> 2. DM_TABLE_LOAD
> 3. DM_SUSPEND     - triggers 'change' uevent
> 
> After this patch we have:
> 
> 1. DM_DEV_CREATE  
> 2. DM_TABLE_LOAD  - triggers 'add' uevents
> 3. DM_SUSPEND     - triggers 'change' uevent
> 
> The equivalent dmsetup commands for a simple test device are
> 0. udevadm monitor --kernel --env &   # View the uevents as they happen
> 1. dmsetup create dev1 --notable
> 2. dmsetup load --table "0 1 error" dev1
> 3. dmsetup resume dev1
> 
>   => Anyone with a udev rule that relies on 'add' needs to check if they
>      need to change their code.
> 
> The udev rules that lvm2 uses to synchronise what it is doing rely
> only on the 'change' event - which is not moving.  The 'add' event
> gets ignored.  
> 
> When loading tables, our tools also always refer to devices using
> the 'major:minor' format, which isn't affected, rather than using
> pathnames in /dev which might not exist now after this change if a table
> hasn't been loaded into a referenced device yet.  Previously this was
> permissible but we always recommended against it to avoid a pointless
> pathname lookup that's subject to races and delays.
> 
> So again, any tools that followed our recommendations ought to be
> unaffected.
> 
> Here's an example of poor code that previously worked but will fail now:
>   dmsetup create dev1 --notable
>   dmsetup create dev2 --notable
>   dmsetup ls  <-- get the minor number of dev1 (say it's 1 corresponding
> to dm-1)
>   dmsetup load dev2 --table '0 1 linear /dev/dm-1 0'
>   ...
> 
> Peter - have I missed anything?

It looks this is the only area affected, but as you say, this should be
well documented (including comments in our own udev rules) so there are
no false assumptions made by other non-lvm/non-libdm users.

(I'm not counting the very corner use case of
'dmsetup --addnodeoncreate --verifyudev' which now ends up with a dev node
in /dev that logically returns -ENODEV when accessed instead of zero-sized
device as it was before.)

-- 
Peter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

