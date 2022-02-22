Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB06C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 19:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645558327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0dqttwWMFuvVazvW69lkbCDXBtuZzSyhHCV51bgg5Ug=;
	b=DUCAE2k72hFHo0C3cExi8S/3SsqxmOxhywM470YNXJVThpeKmdhU1HN+AjtDweC2yVdYgi
	WYPpf4RfLHZCzZoUL8RzgB3xs4jbaDGkGEoj9rkuTMVDQnAUVjqocN+MGLi0LegEftd78/
	iNGxKquiTslgfxHcRjUbR9FkYfcP7Go=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-BFADSA8-Owe2ivAI-NO6aw-1; Tue, 22 Feb 2022 14:32:04 -0500
X-MC-Unique: BFADSA8-Owe2ivAI-NO6aw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74204801AB2;
	Tue, 22 Feb 2022 19:31:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43F9660BD8;
	Tue, 22 Feb 2022 19:31:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4C47A4EE45;
	Tue, 22 Feb 2022 19:31:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MJVrMR029421 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 14:31:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B1EB17AD9; Tue, 22 Feb 2022 19:31:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2307C226E8;
	Tue, 22 Feb 2022 19:31:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 21MJVig6008830; 
	Tue, 22 Feb 2022 13:31:44 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 21MJVhcN008829;
	Tue, 22 Feb 2022 13:31:43 -0600
Date: Tue, 22 Feb 2022 13:31:43 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Ritika Srivastava <ritika.srivastava@oracle.com>
Message-ID: <20220222193143.GW24684@octiron.msp.redhat.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
MIME-Version: 1.0
In-Reply-To: <89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 22, 2022 at 06:59:10PM +0000, Ritika Srivastava wrote:
> On 2/22/22, 10:28 AM, "Benjamin Marzinski" wrote:
> 
>     On Fri, Feb 11, 2022 at 12:41:48PM -0800, Ritika Srivastava wrote:
>     >> Add -P, partition scanning option to kpartx which would set
>     >> LO_FLAGS_PARTSCAN flag during loop device creation.
>     >> This option is same as losetup -P option.
> 
>     >I'm confused here. What's the benefit of doing this? Doesn't this create
>     >partition devices, just like kpartx would?
> 
> This enables partition scanning for loop devices created via kpartx.
> When enabled, LO_FLAGS_PARTSCAN flag will be set during loop creation via kpartx -a.
> On detach (kpartx -d), any partitions (/dev/loopXpY) would also be removed.
> It has similar use cases as losetup -P option.
> 
> Currently, kpartx does not create partition loop devices (/dev/loopXpY)  via kpartx -a

And I'm trying to figure out why you want to create /dev/loop0p1 if you
already have /dev/mapper/loop0p1?  The ability of kpartx to create
partitioned loop devices predates the existance "kpartx -P". So perhaps
the better question is, why do you want to run

# kpartx -av test.img

instead of just running

# loasetup -fP test.img

They both get you partition devices, and you don't need both of them.
Or do you, for some reason I don't understand?

-Ben

> Example:
> 1. Current behavior: kpartx -a does not create /dev/loop0p1
> 
> # kpartx -av test.img
> add map loop0p1 (252:0): 0 99937 linear /dev/loop0 64
> 
> (Notice below: /dev/loop0p1 NOT created)
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk  7,   0 Jan 14 20:46 /dev/loop0 
> 
> 2. IF -P IS USED to create loop device, /dev/loop0p1 IS created.
> 
> # kpartx -av -P test.img
> add map loop0p1 (252:0): 0 99937 linear /dev/loop0 64
> 
> (Notice below: /dev/loop0p1 IS created)
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk   7,   0 Jan 14 20:50 /dev/loop0
> brw-rw----. 1 root disk 259,   0 Jan 14 20:50 /dev/loop0p1
> 
> 
> Similar behavior can also be observed during detach
> 1. Current Behavior:  kpartx -d does NOT delete partitions
> 
> # kpartx -a -v test.img
> # parted -a none -s /dev/loop0 mkpart primary 64s 100000s
> 
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk   7,   0 Jan 14 20:54 /dev/loop0
> brw-rw----. 1 root disk 259,   0 Jan 14 20:54 /dev/loop0p1
> 
> # kpartx -d test.img
> loop deleted : /dev/loop0
> 
> (Notice: /dev/loop0p1 NOT deleted)
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk   7,   0 Jan 14 20:54 /dev/loop0
> brw-rw----. 1 root disk 259,   0 Jan 14 20:54 /dev/loop0p1
> 
> 2. IF -P IS added while creating loop, kpartx -d DOES delete loop0p1
> 
> # kpartx -a -v -P test.img
> # parted -a none -s /dev/loop0 mkpart primary 64s 100000s
> 
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk   7,   0 Jan 14 20:46 /dev/loop0
> brw-rw----. 1 root disk 259,   0 Jan 14 20:46 /dev/loop0p1
> 
> # kpartx -d test.img
> loop deleted : /dev/loop0
> 
> (Notice: /dev/loop0p1 IS deleted)
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk  7,   0 Jan 14 20:46 /dev/loop0
> 
> Thanks,
> Ritika
> 
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

