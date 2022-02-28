Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E333C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 22:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646088296;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CvVV9vJaqW5X751qnyEVPDvpDmBQ93iw0I4+QOuInws=;
	b=QJiUbkz7LddSa8WczWFTloyp4q8gG0/pVdfBh21X4td6/O2iRpbo9Qfv/0Dh9AMSD82hwy
	vkj57oZAsoeqjzs7XiHaGbg27EcfIdXsOtV9seFwXZMfqv1HHIFYSHmjjst5BrRR1deOYb
	xoBWnl0tm3nOulwNh/ItfYN/48snRfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-e0v8Zc7NNQCx6Q6gjkmMIw-1; Mon, 28 Feb 2022 17:44:52 -0500
X-MC-Unique: e0v8Zc7NNQCx6Q6gjkmMIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF89918766D0;
	Mon, 28 Feb 2022 22:44:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67D111006861;
	Mon, 28 Feb 2022 22:44:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D98946F98;
	Mon, 28 Feb 2022 22:44:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SMieGb017979 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 17:44:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A1B161006878; Mon, 28 Feb 2022 22:44:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5404100687F;
	Mon, 28 Feb 2022 22:44:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 21SMiZxY009166; 
	Mon, 28 Feb 2022 16:44:35 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 21SMiZp5009163;
	Mon, 28 Feb 2022 16:44:35 -0600
Date: Mon, 28 Feb 2022 16:44:35 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Ritika Srivastava <ritika.srivastava@oracle.com>
Message-ID: <20220228224435.GY24684@octiron.msp.redhat.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
	<20220222193143.GW24684@octiron.msp.redhat.com>
	<441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
MIME-Version: 1.0
In-Reply-To: <441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 22, 2022 at 10:16:35PM +0000, Ritika Srivastava wrote:
> Ben,
> 
> Thank you for reviewing this.
> 
> On 2/22/22, 11:32 AM, "Benjamin Marzinski" wrote:
> 
>    > And I'm trying to figure out why you want to create /dev/loop0p1 if you
>    > already have /dev/mapper/loop0p1?  The ability of kpartx to create
>    > partitioned loop devices predates the existance "kpartx -P". So perhaps
>    > the better question is, why do you want to run
> 
>    > # kpartx -av test.img
> 
>    > instead of just running
> 
>    > # loasetup -fP test.img
> 
>    > They both get you partition devices, and you don't need both of them.
>    > Or do you, for some reason I don't understand?
> 
> My previous update may not have been clear regarding the supporting use case behind this patch.
> It highlighted what the -P option would add to kpartx.
> 
> The idea is to avoid having both /dev/loop0p1 and /dev/mapper/loop0p1 and support the following use case - 
> After detaching via kpartx -d, /dev/loop0p1 is still present which on subsequent kpartx -a operation results in both /dev/loop0p1 and /dev/mapper/loop0p1 being present.
> 
> Yes, you are right, workaround could be to use losetup -P the first time around when creating the loop device.
> Though, having this functionality within kpartx would be nice since kpartx is also used extensively.

So unless I'm missing something, we'd only really want this for removing
a kpartx device, in the case where somehow you have /dev/loopXpY
partitions without the LO_FLAGS_PARTSCAN flag set on the disk. That
seems like it shouldn't happen in the first place.  Obviously, you
showed that it can with parted.  But I would argue that this is a bug in
parted.  If parted is creating partitions, it should set
LO_FLAGS_PARTSCAN so the partition nodes get cleaned up.

I suppose kpartx could check if there are partition devices for the loop
device, and if so, it could set LO_FLAGS_PARTSCAN before doing the
remove. But setting it unilaterally would just cause it to create an
extra set of devices that would only serve to confuse people (and lvm).

Also, the actual partition /dev/loopXpY will always get removed. It's
just the devnode that stays around, and that won't confuse lvm. This
isn't that odd for loop devices. The /dev/loopX devnodes will stay
around once you're done with them, regardless of whether you create the
loop device will kpartx or losetup.


> 
> // workaround - losetup -P
> # kpartx -a -v test.img
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk  7,   0 Feb 22 20:05 /dev/loop0
> 
> # parted -a none -s /dev/loop0 mkpart primary 64s 100000s
> # parted -a none -s /dev/loop0 set 1 lvm on
> # kpartx -d test.img  
> # ls -l /dev/loop0*
> brw-rw----. 1 root disk   7,   0 Feb 22 20:05 /dev/loop0
> brw-rw----. 1 root disk 259,   0 Feb 22 20:05 /dev/loop0p1
> 
> # kpartx -av test.img
> # ls -l /dev/mapper/loop0*
> lrwxrwxrwx. 1 root root       7 Feb 22 20:53 loop0p1 -> ../dm-2
> 
> # pvcreate /dev/mapper/loop0p1
> # pvscan
>   WARNING: Not using device /dev/loop0p1 for PV <UUID>.
>   WARNING: PV <UUID> prefers device /dev/mapper/loop0p1 because device is in dm subsystem.

So this example shows exactly why I don't want both /dev/loopXpY and
/dev/mapper/loopXpY. Whenever we use your -P option we can run into
this situation, right?

Martin, do you have any feelings on this.

-Ben

> Thanks,
> Ritika
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

