Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654F2C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 07:20:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-x8IW9pEYPTeHGvSH7PWRrw-1; Thu, 03 Feb 2022 02:20:29 -0500
X-MC-Unique: x8IW9pEYPTeHGvSH7PWRrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AD8983DD22;
	Thu,  3 Feb 2022 07:20:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 275AF78DD8;
	Thu,  3 Feb 2022 07:20:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE8554BB7C;
	Thu,  3 Feb 2022 07:20:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2137KGXs029623 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 02:20:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 82EA4492D4E; Thu,  3 Feb 2022 07:20:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F44F492D4B
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 07:20:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64E401044560
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 07:20:16 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-339-hPfhSSYkNZGpfGgEnpIdsw-1; Thu, 03 Feb 2022 02:20:12 -0500
X-MC-Unique: hPfhSSYkNZGpfGgEnpIdsw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 68B4F21110;
	Thu,  3 Feb 2022 07:20:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 343D613310;
	Thu,  3 Feb 2022 07:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id I3JmCiuC+2EccgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 03 Feb 2022 07:20:11 +0000
Message-ID: <d2b5957bf439cf992c9d7086fff6771cde2c66c5.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 03 Feb 2022 08:20:10 +0100
In-Reply-To: <20220203003753.GP24684@octiron.msp.redhat.com>
References: <20220201234024.27675-1-mwilck@suse.com>
	<20220201234024.27675-6-mwilck@suse.com>
	<20220203003753.GP24684@octiron.msp.redhat.com>
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
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2137KGXs029623
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-02-02 at 18:37 -0600, Benjamin Marzinski wrote:
> On Wed, Feb 02, 2022 at 12:40:23AM +0100, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > The kernel's autoload mechanism for SCSI device handlers doesn't
> > work during SCSI device probing. While it's possible to load and
> > attach device handlers after probing, it has disadvantages: the
> > handlers are useful for error handling even before multipathd has
> > started, and at least up to kernel 5.17, the sysfs "access_state"
> > attribute
> > will remain invisible for already probed devices.
> >=20
> > Distributions will therefore want to make sure the handlers are
> > either
> > built-in in the kernel, or loaded early. Add functionality to
> > create and install a modules-load.d file with a list of handlers
> > to load. By default, the list is empty, and no file will be
> > generated.
> > The list can be specified at install-time like this:
> >=20
> > =A0=A0 make SCSI_DH_MODULES_PRELOAD=3D"scsi_dh_rdac scsi_dh_emc" instal=
l
> >=20
> > dracut automatically adds modules-load.d files and the modules they
> > reference to the initramfs.
> >=20
> > Note: distributions that compile scsi_mod as a module may rather
> > want
> > to use a modprobe.d file with a statement like this:
> >=20
> > softdep scsi_mod post: scsi_dh_alua scsi_dh_rdac
> >=20
>=20
> I think you might need a default scsi_dh.conf file with a comment
> header
> or something. install won't install a file that doesn't exist. Or am
> I
> missing something here?

Yes, you would need a conf file. But we can't construct it in the
upstream code. It depends on how the distro compiles the SCSI modules.
softdeps don't work with built-in modules, and with current kmod, there
can be only one softdep directive per module (no stacking) [1]; thus if
the distro (or the admin) needs further softdeps for scsi_mod, the
directives would need to be merged into one, which is tricky to
automate.

The advantage of the softdep over modules-load.d is that it avoids
loading the device handlers for systems without SCSI (like NVMe
laptops, or embedded devices). The distro needs to decide whether or
not that's worth it.

On the contrary, the modules-load.d file stacks nicely with other
packages.

Regards,
Martin

[1] https://www.spinics.net/lists/linux-modules/msg01654.html


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

