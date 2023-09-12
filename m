Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 841EFCA0EC3
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694509829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8LdL4g2Gkh6QXsG5vQSKbar1ESov3GjXqV9Kd2US5d4=;
	b=EDznG5CHJAwPjDQJJxe6JPlV0PzNXNLpu/ssv7snEamrW6jk3O5JiIyYMUwmQ7eUqcnZcy
	WbhPY/6MpaO9PJX9UxGNw4R1h6IUkAsU32uokt3tc2GUq4FaS383SRxk4B40nCkSC8+xKe
	S/j9qx3XRSf0E8/B3rd+I5dPVws8tOg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-4UmAFcT-ONuMpsP4HLZIMw-1; Tue, 12 Sep 2023 05:10:25 -0400
X-MC-Unique: 4UmAFcT-ONuMpsP4HLZIMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC7DC805F6B;
	Tue, 12 Sep 2023 09:10:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD47740C6EA8;
	Tue, 12 Sep 2023 09:10:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A02F1946597;
	Tue, 12 Sep 2023 09:10:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E243194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 09:10:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 455B540C6EC0; Tue, 12 Sep 2023 09:10:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E7F240C6EA8
 for <dm-devel@redhat.com>; Tue, 12 Sep 2023 09:10:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B3DD80523C
 for <dm-devel@redhat.com>; Tue, 12 Sep 2023 09:10:20 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-M_qoKDoTOcWgiqv-tDftVg-1; Tue,
 12 Sep 2023 05:10:18 -0400
X-MC-Unique: M_qoKDoTOcWgiqv-tDftVg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 78C631F8BB;
 Tue, 12 Sep 2023 09:10:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66F6F139DB;
 Tue, 12 Sep 2023 09:10:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id xGD0GPgqAGWkMAAAMHmgww
 (envelope-from <jack@suse.cz>); Tue, 12 Sep 2023 09:10:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id EF43AA077E; Tue, 12 Sep 2023 11:10:15 +0200 (CEST)
Date: Tue, 12 Sep 2023 11:10:15 +0200
From: Jan Kara <jack@suse.cz>
To: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <20230912091015.n37x6gx52jmuwmx7@quack3>
References: <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
 <20230908073244.wyriwwxahd3im2rw@quack3>
 <86235d7a-a7ea-49da-968e-c5810cbf4a7b@redhat.com>
 <20230908102014.xgtcf5wth2l2cwup@quack3>
 <15c62097-d58f-4e66-bdf5-e0edb1306b2f@redhat.com>
MIME-Version: 1.0
In-Reply-To: <15c62097-d58f-4e66-bdf5-e0edb1306b2f@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

On Fri 08-09-23 12:51:03, Zdenek Kabelac wrote:
> Dne 08. 09. 23 v 12:20 Jan Kara napsal(a):
> > On Fri 08-09-23 11:29:40, Zdenek Kabelac wrote:
> > > Dne 08. 09. 23 v 9:32 Jan Kara napsal(a):
> > > > On Thu 07-09-23 14:04:51, Mikulas Patocka wrote:
> > > > > On Thu, 7 Sep 2023, Christian Brauner wrote:
> > > > >=20
> > > > > > > I think we've got too deep down into "how to fix things" but =
I'm not 100%
> > > > > > We did.
> > > > > >=20
> > > > > > > sure what the "bug" actually is. In the initial posting Mikul=
as writes "the
> > > > > > > kernel writes to the filesystem after unmount successfully re=
turned" - is
> > > > > > > that really such a big issue?
> > > > > I think it's an issue if the administrator writes a script that u=
nmounts a
> > > > > filesystem and then copies the underyling block device somewhere.=
 Or a
> > > > > script that unmounts a filesystem and runs fsck afterwards. Or a =
script
> > > > > that unmounts a filesystem and runs mkfs on the same block device=
.
> > > > Well, e.g. e2fsprogs use O_EXCL open so they will detect that the f=
ilesystem
> > > > hasn't been unmounted properly and complain. Which is exactly what =
should
> > > > IMHO happen.
> > > I'd likely propose in this particular state of unmounting of a frozen
> > > filesystem to just proceed - and drop the frozen state together with =
release
> > > filesystem and never issue any ioctl from such filelsystem to the dev=
ice
> > > below - so it would not be a 100% valid unmount - but since the freez=
e
> > > should be nearly equivalent of having a proper 'unmount' being done -=
=A0 it
> > > shoudn't be causing any harm either - and=A0 all resources associated=
 could
> > > be 'released.=A0 IMHO it's correct to 'drop' frozen state for filesys=
tem
> > > that is not going to exist anymore=A0 (assuming it's the last=A0 such=
 user)
> > This option was also discussed in the past and it has nasty consequence=
s as
> > well. Cleanly shutting down a filesystem usually needs to write to the
> > underlying device so either you allow the filesystem to write to the de=
vice
> > on umount breaking assumptions of the user who froze the fs or you'd ha=
ve
> > to implement a special handling for this case for every filesystem to a=
void
> > the writes (and put up with the fact that the filesystem will appear as
> > uncleanly shutdown on the next mount). Not particularly nice either...
>=20
>=20
> I'd say there are several options and we should aim towards the variant
> which is most usable by normal users.
>=20
> Making hyper complex=A0 unmount rule logic that basically no user-space t=
ools
> around Gnome/KDE... are able to handle well and getting it to the positio=
n
> where only the core kernel developer have all the 'wisdom' to detect and
> decode system state and then 'know what's going on'=A0 isn't the favourit=
e
> goal here.

I don't think we are really making forward progress in the argument which
behavior is more or less correct or useful. But maybe when we cannot agree
on the general solution we could still improve the situation that
practically matters? E.g. disputing Gnome apps telling you you can safely
remove the USB stick when you actually cannot because the filesystem on it
is frozen is actually kind of weak argument because users that freeze
filesystem on their USB stick are practically non-existent. So is there a
usecase where users are hitting these problems in practice? Maybe some user
report that triggered original Mikulas' patch? Or was that mostly a
theoretical concern?

> Freeze should be getting the filesystem into 'consistent' state - filesys=
tem
> should=A0 be able to 'easily' recover and finish all the ongoing=A0 'unfi=
nished'
> process with the next mount without requiring full 'fsck' - otherwise it
> would be useless for i.e. snapshot.

More or less yes but e.g. grub2 isn't able to reliably read images of just
frozen filesystem because it ignores journal contents. So if this was root
filesystem this could result in unbootable system.

=09=09=09=09=09=09=09=09Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

