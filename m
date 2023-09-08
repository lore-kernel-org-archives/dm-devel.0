Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1269FEE57F0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694168428;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E9KHgir10wLHtxrDhv9Hgo4QuJJ/oC6Caf2Ap9XJiBI=;
	b=Vl6wmdSBsxaTwuD6YjCaPih9/rfvhwzYdkvVe+fU6LLHnO8mB+QD0dVUjxIuLvBCj8s8nQ
	cg5PvzpjOlzVEcLk9d7xf2VdU0bh1EbWjTY90WtbjSM7rUAJbDr7J+fRxLHARYk8E8Tc2A
	xZPQKv7Lv46J+pMa8mGQCIx6KAC4zCs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-694-uRrNLrERN-arLfCsU-l3-Q-1; Fri, 08 Sep 2023 06:20:25 -0400
X-MC-Unique: uRrNLrERN-arLfCsU-l3-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B63A3C11A0A;
	Fri,  8 Sep 2023 10:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 612F2412F2D1;
	Fri,  8 Sep 2023 10:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DFAA194658F;
	Fri,  8 Sep 2023 10:20:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE45C194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 10:20:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D883021EE56A; Fri,  8 Sep 2023 10:20:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D18F321EE566
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 10:20:21 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B461C3815EE3
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 10:20:21 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-deQJGv4ZP16537MY9b3XJg-1; Fri,
 08 Sep 2023 06:20:17 -0400
X-MC-Unique: deQJGv4ZP16537MY9b3XJg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 98E171FD74;
 Fri,  8 Sep 2023 10:20:14 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89FAD131FD;
 Fri,  8 Sep 2023 10:20:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id jqaKIV71+mSgcQAAMHmgww
 (envelope-from <jack@suse.cz>); Fri, 08 Sep 2023 10:20:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id 267B6A0774; Fri,  8 Sep 2023 12:20:14 +0200 (CEST)
Date: Fri, 8 Sep 2023 12:20:14 +0200
From: Jan Kara <jack@suse.cz>
To: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <20230908102014.xgtcf5wth2l2cwup@quack3>
References: <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
 <20230908073244.wyriwwxahd3im2rw@quack3>
 <86235d7a-a7ea-49da-968e-c5810cbf4a7b@redhat.com>
MIME-Version: 1.0
In-Reply-To: <86235d7a-a7ea-49da-968e-c5810cbf4a7b@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] fix writing to the filesystem after unmount
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
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.cz
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri 08-09-23 11:29:40, Zdenek Kabelac wrote:
> Dne 08. 09. 23 v 9:32 Jan Kara napsal(a):
> > On Thu 07-09-23 14:04:51, Mikulas Patocka wrote:
> > >=20
> > > On Thu, 7 Sep 2023, Christian Brauner wrote:
> > >=20
> > > > > I think we've got too deep down into "how to fix things" but I'm =
not 100%
> > > > We did.
> > > >=20
> > > > > sure what the "bug" actually is. In the initial posting Mikulas w=
rites "the
> > > > > kernel writes to the filesystem after unmount successfully return=
ed" - is
> > > > > that really such a big issue?
> > > I think it's an issue if the administrator writes a script that unmou=
nts a
> > > filesystem and then copies the underyling block device somewhere. Or =
a
> > > script that unmounts a filesystem and runs fsck afterwards. Or a scri=
pt
> > > that unmounts a filesystem and runs mkfs on the same block device.
> > Well, e.g. e2fsprogs use O_EXCL open so they will detect that the files=
ystem
> > hasn't been unmounted properly and complain. Which is exactly what shou=
ld
> > IMHO happen.
> >=20
> > > > > Anybody else can open the device and write to it as well. Or even
> > > > > mount the device again. So userspace that relies on this is kind =
of
> > > > > flaky anyway (and always has been).
> > > It's admin's responsibility to make sure that the filesystem is not
> > > mounted multiple times when he touches the underlying block device af=
ter
> > > unmount.
> > What I wanted to suggest is that we should provide means how to make su=
re
> > block device is not being modified and educate admins and tool authors
> > about them. Because just doing "umount /dev/sda1" and thinking this mea=
ns
> > that /dev/sda1 is unused now simply is not enough in today's world for
> > multiple reasons and we cannot solve it just in the kernel.
> >=20
>=20
> /me just wondering how do you then imagine i.e. safe removal of USB drive
> when user shall not expect unmount really unmounts filesystem?

Well, currently you click some "Eject / safely remove / whatever" button
and then you get a "wait" dialog until everything is done after which
you're told the stick is safe to remove. What I imagine is that the "wait"
dialog needs to be there while there are any (or exclusive at minimum) open=
ers
of the device. Not until umount(2) syscall has returned. And yes, the
kernel doesn't quite make that easy - the best you can currently probably
do is to try opening the device with O_EXCL and if that fails, you know
there's some other exclusive open.

> IMHO=A0 - unmount should detect some very suspicious state of block devic=
e if
> it cannot correctly proceed - i.e. reporting 'warning/error' on such
> commands...

You seem to be concentrated too much on the simple case of a desktop with
an USB stick you just copy data to & from. :) The trouble is, as Al wrote
elsewhere in this thread that filesystem unmount can be for example a
result of exit(2) or close(2) system call if you setup things in a nasty
way. Do you want exit(2) to fail because the block device is frozen?
Umount(2) has to work for all its users and changing the behavior has nasty
corner-cases. So does the current behavior, I agree, but improving
situation for one usecase while breaking another usecase isn't really a way
forward...

> Main problem is - if the 'unmount' is successful in this case - the last
> connection userspace had to this fileystem is lost - and user cannot get =
rid
> of such filesystem anymore for a system.

Well, the filesystem (struct superblock to be exact) is invisible in
/proc/mounts (or whatever), that is true. But it is still very much
associated with that block device and if you do 'mount <device>
<mntpoint>', you'll get it back. But yes, the filesystem will not go away
until all references to it are dropped and you cannot easily find who holds
those references and how to get rid of them.

> I'd likely propose in this particular state of unmounting of a frozen
> filesystem to just proceed - and drop the frozen state together with rele=
ase
> filesystem and never issue any ioctl from such filelsystem to the device
> below - so it would not be a 100% valid unmount - but since the freeze
> should be nearly equivalent of having a proper 'unmount' being done -=A0 =
it
> shoudn't be causing any harm either - and=A0 all resources associated cou=
ld=A0
> be 'released.=A0 IMHO it's correct to 'drop' frozen state for filesystem
> that is not going to exist anymore=A0 (assuming it's the last=A0 such use=
r)

This option was also discussed in the past and it has nasty consequences as
well. Cleanly shutting down a filesystem usually needs to write to the
underlying device so either you allow the filesystem to write to the device
on umount breaking assumptions of the user who froze the fs or you'd have
to implement a special handling for this case for every filesystem to avoid
the writes (and put up with the fact that the filesystem will appear as
uncleanly shutdown on the next mount). Not particularly nice either...

=09=09=09=09=09=09=09=09Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

