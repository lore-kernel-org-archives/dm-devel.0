Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0F5C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 18:47:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-guAB_A1YP_GcUMQmxEHRXA-1; Fri, 28 Jan 2022 13:47:05 -0500
X-MC-Unique: guAB_A1YP_GcUMQmxEHRXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A921B18B9EC3;
	Fri, 28 Jan 2022 18:47:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85502753F8;
	Fri, 28 Jan 2022 18:46:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 092581809CB8;
	Fri, 28 Jan 2022 18:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SIkrPf006508 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 13:46:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5C5584021B8; Fri, 28 Jan 2022 18:46:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58CC048FB03
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 18:46:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C93638008CA
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 18:46:53 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-522-NejWljMQOZKUHZVQMcKFvA-1; Fri, 28 Jan 2022 13:46:51 -0500
X-MC-Unique: NejWljMQOZKUHZVQMcKFvA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59699212B7;
	Fri, 28 Jan 2022 18:46:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 019F713A92;
	Fri, 28 Jan 2022 18:46:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id JDsVOhg69GE1LQAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 28 Jan 2022 18:46:48 +0000
Message-ID: <0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Zdenek Kabelac
	<zkabelac@redhat.com>, David Teigland <teigland@redhat.com>, Peter Rajnoha
	<prajnoha@redhat.com>
Date: Fri, 28 Jan 2022 19:46:48 +0100
In-Reply-To: <e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
User-Agent: Evolution 3.42.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20SIkrPf006508
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>,
	Franck Bui <fbui@suse.de>, lvm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-01-28 at 18:47 +0100, Zdenek Kabelac wrote:
> Dne 28. 01. 22 v 17:02 Martin Wilck napsal(a):
> > On Fri, 2022-01-28 at 16:57 +0100, Martin Wilck wrote:
> > >=20
> > > It's a race condition. It probably happens while multipathd is
> > > reloading a map (*), suspending it during the table reload. The
> > > device
> > > will be resumed a few fractions of a second later (so yes, it's
> > > "quick"), but then it's too late
> >=20
> > More precisely: The suspend state itself may actually not last
> > longer
> > than a few ms. But once the symlink is bent to point to the wrong
> > device, it will remain so, until the CHANGE event following the
> > device
> > resume is successfully processed by udev, which may happen
> > substantially later. And it's that longer time span which matters
> > for
> > systemd's mount attempt (or LVM device activation, for that
> > matter).
> >=20
> >=20
>=20
>=20
> This looks like you are trying to mask-out different synchronization
> bug.

Please explain. What bug would that be, in what subsystem?=A0It takes=20
time until a dm-triggered CHANGE event makes its way through the udev
event queue and completes rules processing. That's perfectly normal.

I say the bug is in this udev rule file. The set of properties and
symlinks of a systemd-managed device must not change when new uevents
for this device are processed, unless absolutely necessary. The current
rule violates this principle: If a device that contains a file system
is suspended, it continues to contain this file system, and the by-uuid
symlink for the file system should be preserved.

You can easily test this. Check the set of symlinks for a partition on
a multipath device, suspend the device, run "udevadm trigger -c add" on
the device (simulating coldplug), and check the set of symlinks again.
You'll see that by-uuid or by-label links will be lost and will now
point to one of the map's paths. These symlinks are crucial for
mounting file systems. With my patch, the symlinks are preserved.

> Also it's worth to note - using symlinks is somewhat doomed on its
> own.

That's how device identification and activation with udev and systemd
works. It won't change any time soon. Explain on which grounds you're
calling it "somewhat doomed".

> So you only solve a very minor subcase where you manage to 'hit' your
> race
> just in a moment where you device is suspend and you actually 'scan'
> state of=20
> device.

I wouldn't call it "minor" if a system fails to boot. The time window
when this is possible is indeed small. But it's not zero, and that's
why this issue occurs.

> But what happen - if device would happen to be already resumed ?

Nothing bad happens. The device is mounted or scanned just fine.

> It looks like there is some race in udev rules processing - just
> somewhere else.

I've personally had a part in fixing multiple race conditions both
multipathd and udev.=A0Ben Marzinski and I recently worked on dropping
the dependency of multipathd.service on udev-settle.service. That
accellerates booting and is conceptually cleaner than before, but it
reveals bugs in other parts of the system, like this one.

> I think Peter could more enlighten the lvm2 logic - but it seems
> there is=20
> possibly missing similar logic on multipath side in the moment when
> devices=20
> are created ?

As long as you don't explain what logic you mean, this is a hard
question to answer.

> There should be no race when switching from ramdisk to rootfs.

I agree that there *should* not be any. But there is one, and this
patch fixes it.

I would appreciate if you said what's actually wrong my patch. So far
you haven't. You just speculated about errors in other parts of the
system. Are you saying my patch would cause regressions or errors? If
yes, how would that come to pass, for which devices, and under which
conditions?

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

