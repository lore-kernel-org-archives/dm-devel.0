Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CB2C77B73
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 19:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686079298;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bN/7Wm3jj6xTNpj07GLl6hdiE0+meM70oRq4ITTGUuI=;
	b=VxKzkaT28VqNhz6ewNX67XefwkaS/2LCYFAK+0M3sa/2yvRUTkzYdyFFhSvM/wQuyVlwBp
	US5R5HrK+wKDRyLnyznDBk0JngJT/Ry9UWjvrmzX4dI2daAPPDm8HqWgvj5Bo2ov+1/QcE
	d6XsA/Wv+KcZPvTOWt2s2kGa6XiGcPw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-IStGWPtVNGGsRtBEAcoBUQ-1; Tue, 06 Jun 2023 15:21:35 -0400
X-MC-Unique: IStGWPtVNGGsRtBEAcoBUQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0A1F8032EF;
	Tue,  6 Jun 2023 19:21:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DAB5400F4E;
	Tue,  6 Jun 2023 19:21:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7907E19465BC;
	Tue,  6 Jun 2023 19:21:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07F4019465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 19:21:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA06140D1B68; Tue,  6 Jun 2023 19:21:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2C1940D1B66
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 19:21:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A96C92999B2D
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 19:21:30 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-NrfUzsWxMPOW1aSeTi8HJA-1; Tue,
 06 Jun 2023 15:21:28 -0400
X-MC-Unique: NrfUzsWxMPOW1aSeTi8HJA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 206141FD8A;
 Tue,  6 Jun 2023 19:21:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C630F13519;
 Tue,  6 Jun 2023 19:21:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 0g1+LTaHf2QGEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 06 Jun 2023 19:21:26 +0000
Message-ID: <1f452452d8f0952d3fa704f6ad9861392c5b45f7.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Chris Hofstaedtler <zeha@debian.org>
Date: Tue, 06 Jun 2023 21:21:25 +0200
In-Reply-To: <bjgxqic4umo4rk2srj4mqdgvvxntosb2xxo63fmymirulir7st@jduzswoyhupe>
References: <a674434b-d365-1f07-2c6f-6a4ffa07578f@gmail.com>
 <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
 <bjgxqic4umo4rk2srj4mqdgvvxntosb2xxo63fmymirulir7st@jduzswoyhupe>
User-Agent: Evolution 3.48.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] multipath-tools: Debian patches
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 dm-devel mailing list <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 18:48 +0200, Chris Hofstaedtler wrote:
> Hi,
>=20
> * Martin Wilck <mwilck@suse.com> [230606 17:18]:
> > On Mon, 2023-06-05 at 21:59 +0200, Xose Vazquez Perez wrote:
> > > Hi,
>=20
> > I have no Debian salsa account, so I reply here, trying to reach
> > Chris
> > via email.
>=20
> (not sure where this mail thread started, I don't see the first mail
> in the dm-devel archives)

It started off-list, but I thought this should rather be a public
discussion. I hope that's ok for everybody.

>=20
> > > A complaint about upstream, "Remove library development files and
> > > all
> > > of libdmmp":
> > > https://salsa.debian.org/linux-blocks-team/multipath-tools/-/commit/8=
c46661697d757763192d8e011c9ad53358d20b7
>=20
> FTR, I don't consider this a "complaint".
>=20
> This commit mostly exists to rectify a few Debian-specific, historic
> issues:
>=20
> 1) we ship(ped) libraries in the daemon package. This would be okay,
> if the libraries are private libs, but given libmpathpersist exists,
> they are clearly not private.
>=20
> 2) we install(ed) various files into old non-/usr paths. These were
> mostly the pkg-config, headers and .so files. For Debian reasons, we
> cannot "just move them" (yet) into /usr, however at the same time
> there existence is a (Debian-specific) problem in the future.
>=20
> Given there are currently no users in Debian for any of these, it
> was easiest to remove all the development files.
>=20
> If and when other packages in Debian want to use the libs, the
> packaging will have to become a lot more complicated.
>=20
> > If Chris has followed the upstream discussion, he is probably aware
> > that we do care about the ABI. We don't keep the libmultipath ABI
> > stable, but track it using ABI versioning.
>=20
> I was only vaguely aware of the changes in the <lib>.version files,
> and that all .so files are ".so.0".
> From a quick glance it looks like libmultipath.so.0 from 0.9.4
> exports a lot of symbols versioned @LIBMULTIPATH_17.0.0, but f.e.
> none versioned @LIBMULTIPATH_15.0.0, but the soname didn't change.

Maybe Debian enforces additional policies I'm unaware of, but
technically, the soname, or filename based library versioning, doesn't
matter if symbol versioning is used [1]. Symbol versioning can be used
in different ways. For libmultipath, we don't attempt to provide
multiple backward-compatible ABIs. We just want to avoid undefined
behavior which would result from an executable calling a library
routine with a different version of the ABI, and this is what our
library versioning scheme achieves. The idea is similar to the kernel's
symvers mechanism, which avoids loading binary-incompatible modules.

> So - I'm not sure if, for a Debian library package, it is okay to do
> essentially drop symbols without a new soname.

I can't tell for Debian, but other distributions haven't complained so
far. I don't think that multipath-tools is the only project that uses
symbol versioning this way.

>=20
> > It is true that most of the
> > libmultipath headers are not used for other projects. Not
> > installing
> > any headers except the public ones makes sense, actually.
> >=20
> > The libmpathpersist API (LIBMPATHPERSIST_2.1.0) that's used by qemu
> > is
> > supposed to remain stable. We have moved those parts of the ABI
> > that
> > used to be more volatile into __LIBMPATHPERSIST_INT_1.0.0.
> >=20
> > Therefore it makes sense to keep shipping mpath_persist.h and drop
> > the
> > rest. If that works for Debian, it will probably work for other
> > distros, too.
>=20
> I haven't tried building anything against libmpathpersist, but
> wouldn't people also need libmultipath.so, and thus transitively
> link in libmultipath.so.0, possibly using its symbols?

The libmultipath data structures that libmpathpersist uses are set up
in libmpathpersist, they are opaque to the calling application.
libmpathpersist will require versioned symbols from libmultipath, and
if these don't match, runtime linking will fail. So if you ship
libmpathpersist with a matching libmultipath, you should be fine.

As Ben noted, the same holds for libmpathvalid and libmpathcmd. We
continuously test our ABI using abigail.

On rpm-based distributions,package management will be able to figure
out this kind of (in)compatibility, albeit in a more coarse-grained way
(e.g. the multipathd package requires
libmpathpersist.so.0(LIBMPATHPERSIST_2.1.0)(64bit), which must match
the provided features of the library package). I suppose something
similar exists in the Debian realm, too.

> > libdmpp comes from Red Hat, perhaps Ben knows whether it is still
> > used
> > by any alive project. It does have a stable API/ABI.
>=20
> I couldn't find any users in Debian, so it didn't seem useful to
> keep shipping it.

Sure. It's your decision. Time will tell if anyone complains. IIRC the
purpose of libdmmp was to provide a stable API for 3rd-party
applications to use.

> > > And maybe these are relevant for upstream ( repo:
> > > https://salsa.debian.org/linux-blocks-team/multipath-tools/-/tree/mas=
ter/debian/patches
> > > =A0):
> > >=20
> > > https://udd.debian.org/patches.cgi?src=3Dmultipath-tools&version=3D0.=
9.4-3
> > >=20
> >=20
> > That's not how we work. We don't pick downstream patches. If
> > something's wrong with the upstream code, we'll happily discuss
> > patches
> > from the Debian project, preferably here on dm-devel.
>=20
> I think most of these patches are not useful for upstream. Do you
> care about our historic install paths?
>=20

Historic - no. But in general we have the goal that distributions
should be able to customize install paths using make variables, without
having to resort to patching.

Thanks,
Martin

[1] https://akkadia.org/drepper/dsohowto.pdf

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

