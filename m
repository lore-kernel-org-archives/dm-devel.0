Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162C9C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679341313;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qCRWzG4xP0LkSxFaeF2kb25pgD3+m91+gxqN6x9rK5o=;
	b=eW/pDsD/TIqVQ8y9EPraBkqCVaE04U6cT0AuA9YBmEfOkUdNMLI8NhkBBLad76lMAVm6HI
	odc4WUUnrLNDDhvOoHBtNpTIOV1W37FCfeg29n/SfijVWe6rmb5UE/GM5M8CfEPRVMdAPZ
	PZPEMEkXXxo01sDqcRoJfmkJQ4PmXLg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-BrgBMWZwN_mHIKf5cFUzzw-1; Mon, 20 Mar 2023 15:41:52 -0400
X-MC-Unique: BrgBMWZwN_mHIKf5cFUzzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7812185A7A3;
	Mon, 20 Mar 2023 19:41:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B7192166B29;
	Mon, 20 Mar 2023 19:41:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E011D19465B6;
	Mon, 20 Mar 2023 19:41:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 65BCF1946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 19:41:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48A1140C6E69; Mon, 20 Mar 2023 19:41:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 261F840C6E67;
 Mon, 20 Mar 2023 19:41:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 32KJfldk021234;
 Mon, 20 Mar 2023 14:41:47 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 32KJflRv021233;
 Mon, 20 Mar 2023 14:41:47 -0500
Date: Mon, 20 Mar 2023 14:41:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230320194146.GH19878@octiron.msp.redhat.com>
References: <CD5EC3B3-9A64-416A-A04C-C68EDB82F4C6@purestorage.com>
 <a85c4b5a6603be979ddb9aa0909808519a03fa3e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <a85c4b5a6603be979ddb9aa0909808519a03fa3e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] multipath-tools Consider making 'smart' the
 default
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Brian Bunker <brian@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 20, 2023 at 03:18:37PM +0100, Martin Wilck wrote:
> On Thu, 2023-03-16 at 14:47 -0700, Brian Bunker wrote:
> > As a target vendor, it is nice to be able control initiator
> > behavior from the target without relying on user intervention
> > on the initiator. There could be a very large number of initiators
> > at a site.
> > 
> > When ACLs are first added for a volume on our array, we use the
> > transport layer, so that the initiator will discover the volumes
> > without any manual intervention.
> > 
> > kernel: scsi 8:0:0:1: Direct-Access PURE Flash Array
> > 8888 PQ: 0 ANSI: 6
> > kernel: scsi 9:0:0:1: Direct-Access PURE Flash Array
> > 8888 PQ: 0 ANSI: 6
> > kernel: scsi 6:0:0:1: Direct-Access PURE Flash Array
> > 8888 PQ: 0 ANSI: 6
> > kernel: scsi 7:0:0:1: Direct-Access PURE Flash Array
> > 8888 PQ: 0 ANSI: 6
> > ...
> > kernel: sd 6:0:0:1: [sdd] Attached SCSI disk
> > kernel: sd 8:0:0:1: [sdb] Attached SCSI disk
> > kernel: sd 9:0:0:1: [sdc] Attached SCSI disk
> > kernel: sd 7:0:0:1: [sde] Attached SCSI disk
> > 
> > Subsequent volumes after the first one are discovered via unit
> > attentions triggering the udev rule which calls scan-scsi-target.
> > The SCSI devices being discovered without creating the corresponding
> > multipath devices seems to be a bad default. We would like to
> > control as much as possible from the target side to dictate initiator
> > behavior. This comes as a regression to how it previously worked.
> > 
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> 
> I'm fine with this, but keep in mind that distributions will probably
> override this anyway. Red Hat and SUSE have had different defaults for
> this basically forever. At least enterprise distros won't risk
> regressions because of changing defaults.
> 
> Ben, what's your opinion wrt the patch?

tl;dr: I think "yes" makes more sense than "smart".

I don't know if this is a good idea. The default behavior we set is
going to be what happens when people don't set up a configuration file.
I get that "strict" means you have to manually set up maps. But that
actually seems like a reasonable default if you don't have a
configuration set up. Using "no" or "greedy" means that you have to set
up a configuration, or multipath will just use all your devices, and
that seems much worse. But if we want to make multipath "just do the
right thing without getting in my way", then I would argue "yes" is a
better alternative.

The benefit of using "yes" is that multipath will almost always
correctly find your multipath devices, and will never fail in a way
where it grabs devices it shouldn't.  The only time it will fail is on a
multipathable device that has never been multipathed before, and it will
only not work if something else starts using the first path of the
device before the second path appears and multipathd creates a multipath
device on it.  This really only happens when this new device has some
metadata on it that causes something to automatically grab it (for
instance a LABEL for a filesystem that gets automounted, or LVM metadata
for a device that gets autoactivated).  I don't actually know of any
real downsides to using "yes", and if there were some, they would also
be downsides to using "smart"

There are real downsides to using "smart" without setting up a
configuration file. Every single time you boot, the rest of the system's
access to your possibly multipathable devices is delayed while multipath
waits seconds for a sibling to appear. In return for this issue that
happens on every boot for every possibly multipathable device, the only
benfit you get over "yes", is that when you add a new device to your
system, if there is data on the device that would cause it to be
autoassembled and the second path appears within seconds of the first
path (either 1 or 10, depending on whether or not there is a built-in
config for the storage array), multipath will correctly grab the device,
instead of whatever was going to autoassemble on it.  This is a very
rare occurance, still leaves you with a running system, and can easily
be fixed after the fact.

There's only one time when RHEL makes use of "smart", and that's during
installation.  For reasons which I don't understand, the RHEL installer
will autoassemble LVM/MD devices if there is existing metadata on disks
when it boots. In this case the system is unavoidably seeing all of the
storage devices for the very first time, without multipath being
configured for these devices, and it not unlikely that we will see
devices with LVM/MD metadata on them. This means that LVM/MD will likely
autoassemble before the second path appears, and the device gets
multipathed. This confuses the installer. Since we only do this in the
installer, we only see the "smart" delay on releasing the devices to the
systme one time. In this situation, using "smart" makes sense (although
not as much sense as simply not autoassembling LVM devices when the
installer boots, IMHO).

The only other situation where "smart" would be generally helpful is if
you have your system configured so that all devices are blacklisted
except the types that are supposed to be multipathed. In this situation
you wouldn't have to worry about the delay on every boot because all the
non-multipathable devices would be blacklisted. If a new multipathable
device appeared, then "smart" would guarantee that nothing else would
grab it before the second path appeared (assuming that the second path
appeared within the timeout). However, you quite likely still shouldn't
use "smart" in this case.  If you already have your configuration set up
like this, then you can just use "greedy" and get the same benefit,
without having to worry about the second path showing up on time.\

It is possible that you can't set up you configuration to correctly sort
all the devices that may appear in the future into multipathable and
non-multipathable. In this case, if it's important that these new
devices are correctly multipathed the first time they show up, then
"smart" also makes sense. But I don't think that this case was so
common that we should assume that it's the default for people who
install the multipath tools. It takes very little effort to change the
find_multipaths setting. The people who aren't interested enough in
their multipath setup to do that probably aren't the people that want
multipath claiming their devices for a couple seconds every boot, just
in case we're in that rare situation where it could make a difference.

-Ben
 
> Regards
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

