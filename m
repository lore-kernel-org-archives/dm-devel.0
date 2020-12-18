Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA25C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 15:07:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C13123AFD
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 15:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C13123AFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-gq_f0YCIPqu4HTYZazeveg-1; Fri, 18 Dec 2020 10:07:18 -0500
X-MC-Unique: gq_f0YCIPqu4HTYZazeveg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3F60107ACF5;
	Fri, 18 Dec 2020 15:07:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB0556B8DD;
	Fri, 18 Dec 2020 15:07:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 806D65002C;
	Fri, 18 Dec 2020 15:07:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIF77p1013617 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 10:07:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1B5CB2166B28; Fri, 18 Dec 2020 15:07:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15E582166B27
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 15:07:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D887811E91
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 15:07:03 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-32-SD7vu5TjNOeHVOIciNW07Q-1;
	Fri, 18 Dec 2020 10:06:59 -0500
X-MC-Unique: SD7vu5TjNOeHVOIciNW07Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 69586ACF1;
	Fri, 18 Dec 2020 15:06:58 +0000 (UTC)
Message-ID: <0ff1145b8e8d0bb6034206045b2d1e7b7b4b8737.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 18 Dec 2020 16:06:57 +0100
In-Reply-To: <20201218054820.GG3103@octiron.msp.redhat.com>
References: <20201217110018.3347-1-mwilck@suse.com>
	<20201217110018.3347-5-mwilck@suse.com>
	<20201218054820.GG3103@octiron.msp.redhat.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/7] libmultipath: force map reload if udev
	incomplete
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2020-12-17 at 23:48 -0600, Benjamin Marzinski wrote:
> On Thu, Dec 17, 2020 at 12:00:15PM +0100, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > We've recently observed various cases of incompletely processed
> > uevents
> > during initrd processing. Typically, this would leave a dm device
> > in
> > the state it had after the initial "add" uevent, which is basically
> > unusable,
> > because udevd had been killed by systemd before processing the
> > subsequent
> > "change" event. After switching root, the coldplug event would re-
> > read
> > the db file, which would be in unusable state, and would not do
> > anything.
> > In such cases, a RELOAD action with force_udev_reload=1 is in order
> > to
> > make udev re-process the device completely
> > (DM_UDEV_PRIMARY_SOURCE_FLAG=1 and
> > DM_SUBSYSTEM_UDEV_FLAG0=0).
> > 
> > The previous commits
> > 
> > 2b25a9e libmultipath: select_action(): force udev reload for
> > uninitialized maps
> > cb10d38 multipathd: uev_trigger(): handle incomplete ADD events
> > 
> > addressed the same issue, but incompletely. They would miss cases
> > where the
> > map was configured correctly but none of the RELOAD criteria were
> > met.
> > This patch partially reverts 2b25a9e by converting
> > select_reload_action() into
> > a trivial helper. Instead, we now check for incompletely
> > initialized udev now
> > before checking any of the other reload criteria.
> 
> I'll review this patch tomorrow, but are you able to reproduce this?

Not me, but multiple customers of ours :-/ Most of them where running
PowperPC, for reasons I can only speculate about. The user-visible
phenomenon is that some upper layers on some maps (kpartx-created
partitions, LVM, ...) are not present after boot, and "multipathd
reload" fixes the situation.

I suppose it should be reproducible if one has multiple multipath maps
with partitions, devices are discovered somewhat slowly / with delays
during intird processing, and the root device is discovered early on.
Then systemd has enough time to mount the root FS and stop services
before all maps are completely set up. The exact behavior would still
depend on timing (but in the in the last case I worked on, it was 100%
reproducible by the customer).

> I've seen something similar, except in the case I saw, multipathd
> took
> too long during the initial configuration, and the systemd shut
> things
> down for the switch-root before multipath could finish creating the
> devices. I was thinking of trying to solve cases like this by forcing
> some ordering on multipathd stopping in the initramfs, with something
> like
> 
> Before=initrd-cleanup.service
> Conflicts=initrd-cleanup.service
> 
> for the multipathd.service file for the initramfs. The goal is to
> make
> sure that things don't get shutdown until multipathd has stopped.
> This
> would keep multipath from creating devices when udev isn't around to
> deal with them. Did you try something like this?

No, I didn't think of that. It's an interesting idea, although it might
slow down booting. IMO it's actually a good thing that the services in
the initrd are stopped quickly when the root FS becomes available. It
can just have some side effects our current code doesn't deal well
with.

AFAICS, multipathd is not the problem, udev is. I can see that
multipathd has cleanly set up the maps, but udev has been stopped
before processing the respective events (in particular, the change
events).

If this happens, the udev db for the affected maps looks more or less
like this:

DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG="1"
DM_UDEV_DISABLE_DISK_RULES_FLAG="1"
DM_UDEV_DISABLE_OTHER_RULES_FLAG="1"

The device-mapper hotplug mechanism doesn't help here, because it tries
to import properties from the db. Triggering uevents in other ways
helps even less. Only a "genuine" change event without the "reload"
flag (DM_SUBSYSTEM_UDEV_FLAG0) set will do the trick.

When multipathd starts after switching root, it sees the maps in
perfect state as far as multipath properties are concerned, and thus
will not set the force_udev_reload flag. This patch changes that.

(My break-through step when I attempted to understand the issue was to
tell customers to tar up /run/udev/data before starting coldplug. That
way I could see the state in which the udev db was left when initrd
finished, and I saw the half-completed entries like above).

I suppose this works differently on Red Hat where you use mpathconf and
set up only a very limited set of maps during initrd processing.
Therefore my guess was you'd not see this at all. I'm still wondering
why we have been seeing it only very recently. *Perhaps* my recent
changes to make multipathd shutdown more quickly are part of the
equation, I'm unsure about that. I am pretty positive that this patch
is effective, though.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

