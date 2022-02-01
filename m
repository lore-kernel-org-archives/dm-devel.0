Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3A7C4332F
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 10:56:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-x5eITZ7aN6CjeqXQb7zL2g-1; Tue, 01 Feb 2022 05:55:59 -0500
X-MC-Unique: x5eITZ7aN6CjeqXQb7zL2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB2C31B18BCA;
	Tue,  1 Feb 2022 10:55:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88F2466E32;
	Tue,  1 Feb 2022 10:55:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CE451809C88;
	Tue,  1 Feb 2022 10:55:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211AtqNh027823 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 05:55:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9D010C159F6; Tue,  1 Feb 2022 10:55:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99012C0809B
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 10:55:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80087803C9F
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 10:55:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-260-XQ_4YNNTOGumo9wgKRyVNQ-1; Tue, 01 Feb 2022 05:55:49 -0500
X-MC-Unique: XQ_4YNNTOGumo9wgKRyVNQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5FAB41F380;
	Tue,  1 Feb 2022 10:55:47 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EACB513D24;
	Tue,  1 Feb 2022 10:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id Ld95NrIR+WHFHgAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 01 Feb 2022 10:55:46 +0000
Message-ID: <5342a690855f0047efd9eede5499227246e3fb08.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Peter Rajnoha
	<prajnoha@redhat.com>
Date: Tue, 01 Feb 2022 11:55:46 +0100
In-Reply-To: <cc5c503a-c94f-d32f-9f91-e388f36c647c@gmail.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
	<712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
	<20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
	<3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
	<cc5c503a-c94f-d32f-9f91-e388f36c647c@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 211AtqNh027823
X-loop: dm-devel@redhat.com
Cc: Franck Bui <fbui@suse.de>, lvm-devel@redhat.com, dm-devel@redhat.com,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Heming Zhao <heming.zhao@suse.com>
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

On Tue, 2022-02-01 at 11:11 +0100, Zdenek Kabelac wrote:
> > >=20
> > > But yes, if temporarily losing the symlink causes issues, your
> > > patch
> > > solves that (Zdenek will push that upstream).
> >=20
> > Thank you very much! It occured to me that if we want to solve my
> > use
> > case with minimal risk, we could make the the case in which the
> > symlinks are preserved conditional on ACTION=3D=3D"add" (i.e. true
> > coldplug
> > events). Tell me if you'd prefer that, I can re-submit.
>=20
> The problem is handling of 'suspended' state in udev rules - as I've
> mentioned=20
> original no userland tool should mostly care about this.
>=20
> However since there are those things like udev 'trigger' and it would
> be kind=20
> of ugly if the 'left-over' suspended device would stop whole system
> operation
> it's most likely better ATM to have some kind of support for this.
>=20
> It's should be noted there is still 'race' risk of system freezing in
> the case=20
> the suspend happens just after sysfs test and before actual i.e.
> 'blkid' use.

Right. Even if blkid was smart enough to check immediately before=20
doing I/O on the device, there would still be a race window.=20

It occured to me that it might be useful if IO on suspended DM devices
failed with -EAGAIN when opened with a non-blocking file descriptor.
But I haven't thought it through ... I suppose that would have other
issues, it would be a breaking change anyway.

The good thing is that most of the time, the devices are suspended only
for a short period of time, so blkid will just hang for a few fractions
of a second. The fact that udev skips calling blkid is only for the
very rare remaining cases in which the suspend state persists for a
long time.

> The missed issue to be solve is - that ALL rules have to rely on a
> single=20
> suspend check - otherwise we risk 'partial' processing=A0 which is the
> last=20
> thing we want to see (aka all or nothing).

Don't we have that already? Isn't that the check that sets the
DM_SUSPENDED flag?

> Your real problem was not the suspend on its own - which still may
> happen=20
> anytime (so i.e. just after the test whether device is suspended),
> but the bug was related to bad exit path cleaning udev db content in
> this case=20
> - which is clear bug.=A0 Next bug is that other rules have to be
> consistent and=20
> properly skip its processing if the 1st. rules decides its meant to
> be skipped.

Part of the consistency problem is that we have a lot of related but
not equivalent udev variables:

DM_SUSPENDED
DM_NOSCAN
DM_UDEV_DISABLE_OTHER_RULES_FLAG
DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG
DM_UDEV_DISABLE_DISK_RULES_FLAG

and then of course

SYSTEMD_READY
MPATH_DEVICE_READY

For consumers of these variables (i.e. udev rules from other
subsystems), it's not always obvious which one they should look at
(just my =A40.02).

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

