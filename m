Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD37C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643909718;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+S2euFrehdrYVLZkeplfgFsN3jq81FTQlWN/Ub9qGd8=;
	b=aF+dWGMRw7TuDG1LuspA1/j6W5GcBA0seWXXBwkOjktWNs8aMib9grhE2F7ptbBEybI2UJ
	efC45VrwC8hjJ0nEi4huf4frFhESXg9NKAoKHnryouqOA99ChsQdyZS5UyybbBz94ZxRkP
	FI+y7EDMNC0dkIVxec44wz3eR/2b0hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-VRefuMv7NomZMNYOitJcaA-1; Thu, 03 Feb 2022 12:33:58 -0500
X-MC-Unique: VRefuMv7NomZMNYOitJcaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425D58143E5;
	Thu,  3 Feb 2022 17:33:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A074753F0;
	Thu,  3 Feb 2022 17:33:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73FC91806D1D;
	Thu,  3 Feb 2022 17:33:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213HOI1h024976 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 12:24:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 536E584D3A; Thu,  3 Feb 2022 17:24:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0554C84D31;
	Thu,  3 Feb 2022 17:24:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 213HOG2t012528; 
	Thu, 3 Feb 2022 11:24:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 213HOFq9012527;
	Thu, 3 Feb 2022 11:24:15 -0600
Date: Thu, 3 Feb 2022 11:24:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220203172415.GV24684@octiron.msp.redhat.com>
References: <20220201234024.27675-1-mwilck@suse.com>
	<20220201234024.27675-6-mwilck@suse.com>
	<20220203003753.GP24684@octiron.msp.redhat.com>
	<d2b5957bf439cf992c9d7086fff6771cde2c66c5.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d2b5957bf439cf992c9d7086fff6771cde2c66c5.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 5/6] multipath: Makefile: modules-load.d file
 for SCSI device handlers
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 03, 2022 at 08:20:10AM +0100, Martin Wilck wrote:
> On Wed, 2022-02-02 at 18:37 -0600, Benjamin Marzinski wrote:
> > On Wed, Feb 02, 2022 at 12:40:23AM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > The kernel's autoload mechanism for SCSI device handlers doesn't
> > > work during SCSI device probing. While it's possible to load and
> > > attach device handlers after probing, it has disadvantages: the
> > > handlers are useful for error handling even before multipathd has
> > > started, and at least up to kernel 5.17, the sysfs "access_state"
> > > attribute
> > > will remain invisible for already probed devices.
> > >=20
> > > Distributions will therefore want to make sure the handlers are
> > > either
> > > built-in in the kernel, or loaded early. Add functionality to
> > > create and install a modules-load.d file with a list of handlers
> > > to load. By default, the list is empty, and no file will be
> > > generated.
> > > The list can be specified at install-time like this:
> > >=20
> > > =A0=A0 make SCSI_DH_MODULES_PRELOAD=3D"scsi_dh_rdac scsi_dh_emc" inst=
all
> > >=20
> > > dracut automatically adds modules-load.d files and the modules they
> > > reference to the initramfs.
> > >=20
> > > Note: distributions that compile scsi_mod as a module may rather
> > > want
> > > to use a modprobe.d file with a statement like this:
> > >=20
> > > softdep scsi_mod post: scsi_dh_alua scsi_dh_rdac
> > >=20
> >=20
> > I think you might need a default scsi_dh.conf file with a comment
> > header
> > or something. install won't install a file that doesn't exist. Or am
> > I
> > missing something here?
>=20
> Yes, you would need a conf file. But we can't construct it in the
> upstream code. It depends on how the distro compiles the SCSI modules.
> softdeps don't work with built-in modules, and with current kmod, there
> can be only one softdep directive per module (no stacking) [1]; thus if
> the distro (or the admin) needs further softdeps for scsi_mod, the
> directives would need to be merged into one, which is tricky to
> automate.
>=20
> The advantage of the softdep over modules-load.d is that it avoids
> loading the device handlers for systems without SCSI (like NVMe
> laptops, or embedded devices). The distro needs to decide whether or
> not that's worth it.
>=20
> On the contrary, the modules-load.d file stacks nicely with other
> packages.

Right, but having a default scsi_dh.conf file that just has a comment
header explaining what it is won't make anything get installed to
modules-load.d by default. You already made that install command
conditional. It just means that running

make SCSI_DH_MODULES_PRELOAD=3D"scsi_dh_rdac scsi_dh_emc" install

will succeed, and give you a scsi_dh.conf in the modules-load.d
directory that loads those modules, instead of failing because there is
no scsi_dh.conf file to install. If you're against having a default
scsi_dh.conf for install to work with, I suppose another option would be
add the modules to scsi_dh.conf first, and then install it. Something
like

ifneq ($(SCSI_DH_MODULES_PRELOAD),)
=09> scsi_dh.conf
        for _x in $(SCSI_DH_MODULES_PRELOAD); do echo "$$_x"; done \
            >>scsi_dh.conf
        $(INSTALL_PROGRAM) -m 644 scsi_dh.conf $(DESTDIR)$(modulesloaddir)/=
scsi_dh.conf
endif

But you have to truncate or remove the local copy of scsi_dh.conf first,
otherwise you would just keep adding the same modules on to the end.
This would mean that distros can't make their own custom scsi_dh.conf.
It would just be generated.

If none of this seems o.k. to you, at the very least you should change
the commit message to metion that

make SCSI_DH_MODULES_PRELOAD=3D"scsi_dh_rdac scsi_dh_emc" install

will only work if you've already created a file named scsi_dh.conf in
the multipath directory.

-Ben

>=20
> Regards,
> Martin
>=20
> [1] https://www.spinics.net/lists/linux-modules/msg01654.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

