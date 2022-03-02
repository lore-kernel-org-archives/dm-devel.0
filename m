Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A269DC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646246384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RQqNZ+wwPEboh6Z3fwri4tMInAxKPtnXQf+lGG/HBUQ=;
	b=PPr4d/nMmeQg7/AfCCbOvl43iVDVz+946xgGqA1oHITsLAlEwUpZubt8mmufIHQnBIgjor
	6lTzwSW+1poQ7clMu+09QAIrM4pfKsx4mF2weK5FPflM0tzknMmyyIErjVhB6c5tMpTNBX
	4GBn1rK2KdYTa+05RzDh1AtrtWFJtGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-iwabhC7BOd26qxgZ-hptQQ-1; Wed, 02 Mar 2022 13:39:40 -0500
X-MC-Unique: iwabhC7BOd26qxgZ-hptQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9892A1091DA3;
	Wed,  2 Mar 2022 18:39:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C0A034677;
	Wed,  2 Mar 2022 18:39:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 466FC1CBF;
	Wed,  2 Mar 2022 18:39:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 222Id4CI005518 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Mar 2022 13:39:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7A3367C027; Wed,  2 Mar 2022 18:39:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2CF8804C0;
	Wed,  2 Mar 2022 18:38:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 222IctRA028553; 
	Wed, 2 Mar 2022 12:38:55 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 222IctSF028551;
	Wed, 2 Mar 2022 12:38:55 -0600
Date: Wed, 2 Mar 2022 12:38:54 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Ritika Srivastava <ritika.srivastava@oracle.com>
Message-ID: <20220302183854.GA24684@octiron.msp.redhat.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
	<20220222193143.GW24684@octiron.msp.redhat.com>
	<441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
	<20220228224435.GY24684@octiron.msp.redhat.com>
	<1C4A63A7-0ABB-4A26-9C4A-4BD4EA192B1A@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1C4A63A7-0ABB-4A26-9C4A-4BD4EA192B1A@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Martin Wilck <martin.wilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 02, 2022 at 12:07:11AM +0000, Ritika Srivastava wrote:
> On 2/28/22, 2:44 PM, "Benjamin Marzinski" wrote:
> 
>     > So unless I'm missing something, we'd only really want this for removing
>     > a kpartx device, in the case where somehow you have /dev/loopXpY
>     > partitions without the LO_FLAGS_PARTSCAN flag set on the disk. That
> 
> That's correct. We only want this option so that once PARTSCAN flag is set, 
> Kpartx -d can delete /dev/loopXpY.
> 
>     > seems like it shouldn't happen in the first place.  Obviously, you
>     > showed that it can with parted.  But I would argue that this is a bug in
>     > parted.  If parted is creating partitions, it should set
>     > LO_FLAGS_PARTSCAN so the partition nodes get cleaned up.
>     > I suppose kpartx could check if there are partition devices for the loop
>     > device, and if so, it could set LO_FLAGS_PARTSCAN before doing the
> 
> Would removing all partition nodes (/dev/loop0pY) on kpartx -d be a better solution.?

Like I said, if we fix this in multipath, then checking for /dev/loopXpY
devnodes, and setting LO_FLAGS_PARTSCAN before deleting the loop device
if they are present seems like a better solution.

But again, you can make a pretty good case that when parted creates
those partition devices, it should set LO_FLAGS_PARTSCAN so that their
devnodes will get cleaned up.
 
>     > remove. But setting it unilaterally would just cause it to create an
>     > extra set of devices that would only serve to confuse people (and lvm).
> 
> -P should be used only when partition scan needs to be enabled - only on need basis.
> 
>     > Also, the actual partition /dev/loopXpY will always get removed. It's
>     > just the devnode that stays around, and that won't confuse lvm. This
> 
> The example below shows that /dev/loop0p1 is not removed which is confusing the LVM.

But lvm decides what devices are duplicates by reading them, not by
looking at their name.  So, unless both the /dev/loopXpY and the
/dev/mapper/loopXpY actually are devices, lvm won't have an issue.  If
the /dev/loopXpY devnode is still around, but there's no actual device
connected to it, that lvm issue shouldn't happen.

Leaving devnodes around doesn't cause lvm issues. But adding loop
partitions can cause lvm issues.  This is why I don't like the idea of
kpartx creating them.

>     > isn't that odd for loop devices. The /dev/loopX devnodes will stay
>     > around once you're done with them, regardless of whether you create the
>     > loop device will kpartx or losetup.
> 
> That's correct.
> But loop device when setup with losetup -P option does remove /dev/loopXpY on detach
> Hoping to achieve the same functionality in kpartx.
> 
> 
>     >> 
>     >> // workaround - losetup -P
>     >> # kpartx -a -v test.img                                                                             // First kpartx
>     >> # ls -l /dev/loop0*
>     >> brw-rw----. 1 root disk  7,   0 Feb 22 20:05 /dev/loop0
>     >> 
>     >> # parted -a none -s /dev/loop0 mkpart primary 64s 100000s
>     >> # parted -a none -s /dev/loop0 set 1 lvm on
>     >> # kpartx -d test.img  
>     >> # ls -l /dev/loop0*
>     >> brw-rw----. 1 root disk   7,   0 Feb 22 20:05 /dev/loop0
>     >> brw-rw----. 1 root disk 259,   0 Feb 22 20:05 /dev/loop0p1
>     >> 
>     >> # kpartx -av test.img                                                                         //Second kpartx
>     >> # ls -l /dev/mapper/loop0*
>     >> lrwxrwxrwx. 1 root root       7 Feb 22 20:53 loop0p1 -> ../dm-2
>     >> 
>     >> # pvcreate /dev/mapper/loop0p1
>     >> # pvscan
>     >>   WARNING: Not using device /dev/loop0p1 for PV <UUID>
>     >>   WARNING: PV <UUID> prefers device /dev/mapper/loop0p1 because device is in dm subsystem.
> 
>     > So this example shows exactly why I don't want both /dev/loopXpY and
>     > /dev/mapper/loopXpY. Whenever we use your -P option we can run into
>     > this situation, right?
> 
> In the above example, the first `kpartx -a` could benefit from `-P` option and would remove /dev/loop0p1 on kpartx -d.
> This is to avoid having both /dev/loop0p1 and /dev/mapper/loop0p1.

But again, that pvcreate WARNING happens when both devices exist. Simply
having a devnode present won't cause it. And adding the '-P' option
won't top both devices from existing at the same time. That being said,
I do understand the desire to clean them up.

-Ben

> The second `kpartx -a` does not need a partition scan and `-P` option should not be provided.
> However, yes, you are right - if it is specified in this case, it would create both /dev/loop0p1 and /dev/mapper/loop0p1 
> - which then would have to be deleted and recreated without the `-P` option.
> Maybe a warning message here would help - something like `-P` option should be used only while creating new partitions. 
> 
> Thanks,
> Ritika
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

