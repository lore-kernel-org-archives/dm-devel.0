Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952DFC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638306884;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6h7LATHq+ZzLk70+OyuPFY4HxpwoItdUH5vBIR+yi00=;
	b=FD7HkI9LdGpOeqbkEnr/qEyjK6Zi0/xCys3cGUzG9/7b4HuYlnSLbuVSPcz4IpsOCpuyWk
	BIc5AK9Ni7kT0prszjX9KVOm4wL+GR/LBmkN7UV1Nb/AbMrNv5FkqqBVajyOh0oJZAehRL
	secdIzxwxBN6JbtBBjvY3xHINw8toss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-_7J7J0CfMrGwbAgmiQNsJw-1; Tue, 30 Nov 2021 16:14:40 -0500
X-MC-Unique: _7J7J0CfMrGwbAgmiQNsJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DDCD94EE1;
	Tue, 30 Nov 2021 21:14:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B76E5D9DE;
	Tue, 30 Nov 2021 21:14:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5BF221809C89;
	Tue, 30 Nov 2021 21:14:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AULEWDf000706 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 16:14:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AC0F60C13; Tue, 30 Nov 2021 21:14:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F26C260C0F;
	Tue, 30 Nov 2021 21:14:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AULERsS031112; 
	Tue, 30 Nov 2021 15:14:27 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AULEQvx031111;
	Tue, 30 Nov 2021 15:14:26 -0600
Date: Tue, 30 Nov 2021 15:14:26 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20211130211426.GN19591@octiron.msp.redhat.com>
References: <20211118231338.22358-1-mwilck@suse.com>
	<20211118231338.22358-6-mwilck@suse.com>
	<20211130011759.GG19591@octiron.msp.redhat.com>
	<e56fcde94769fcdd44d0237b152407618be7f23e.camel@suse.com>
	<20211130173051.GL19591@octiron.msp.redhat.com>
	<10c985a14d43729b36e76f8e4aeb617876ee8165.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <10c985a14d43729b36e76f8e4aeb617876ee8165.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/21] libmultipath (coverity): improve input
 checking in parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 30, 2021 at 09:14:10PM +0100, Martin Wilck wrote:
> On Tue, 2021-11-30 at 11:30 -0600, Benjamin Marzinski wrote:
> >=20
> > If you export scsi IDs from sg_inq, it will print them out until it
> > hits an error, so I would prefer if we used the best designator we got
> > before we hit the error, to match it.
>=20
> That's what my code does (embarrassingly, I didn't realize that when I
> wrote my previous reply).=A0
>=20
> In shortened pseudo code:
>=20
> =09int prio =3D -1;
> =09int err =3D -ENODATA;
>=20
> =09d =3D first_designator();
> =09while (d <=3D in + in_len - 4) {
> =09=09bool invalid =3D false;
> =09=09int new_prio =3D -1;
>=20
>                 if (designator_is_invalid(d))
>                      invalid =3D true;
>                 else if (lun_association(d))
>                      new_prio =3D prio(d);
>=20
> =09next_designator:
> =09=09if (invalid) {
> =09=09=09err =3D -EINVAL;
> =09=09=09break;  /** see below **/
> =09=09}
> =09=09if (new_prio > prio) {
> =09=09=09vpd =3D d;
> =09=09=09prio =3D new_prio;
> =09=09}
> =09=09d =3D next_designator(d);
> =09}
>=20
>         /* if we did find a valid designator, prio will be > 0, and we
>            will not error out */
> =09if (prio <=3D 0)
> =09=09return err;
>=20
>         convert_designator_to_wwid(d);
>=20
> If you think we should use a different strategy, please explain.
> We *could* try to go on even after encountering broken designators,
> assuming the length field is correct if it's within the given limits,
> even if the rest is bogus. So baiscally instead of the break statement
> above, we'd continue the loop.
>=20
> Would you prefer that?

Again looking at sg_inq, it will loop through all the descriptors,
trusting the length field, until it gets to the whole data length. It
prints a warning if it doesn't end up at exactly the data length, but
still exports all the IDs it finds.  If an individual descriptor doesn't
make sense, it gets skipped. That would be my preference.

-Ben

> Regards,
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

