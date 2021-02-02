Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2449FC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 07:19:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 408C764ED9
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 07:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 408C764ED9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612250358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6gnvcF5P18e6VCef2EC7IWOw9up1FIpY2qhJfUoMM2U=;
	b=dRWVjX42nAGlaYn2gomBvaRp4U2a0xdfkS7mjZzIP2fNLF0YhRrrGhJa1kNG7RBQlnTOsh
	7EB7TnCYL9tf/BuWmaVIYeullMYY442jaLREnAYTSIrbZAq34TGTzzuu5a8yiFExzVyrb7
	uXWZ/BrzE9yfyFJn02LULOcIQUJfhpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-YdKYPDWaOgmTaUSlcPFw-A-1; Tue, 02 Feb 2021 02:19:15 -0500
X-MC-Unique: YdKYPDWaOgmTaUSlcPFw-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94F6259;
	Tue,  2 Feb 2021 07:19:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD5E110016F9;
	Tue,  2 Feb 2021 07:19:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 37B84180954D;
	Tue,  2 Feb 2021 07:19:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1127J414012403 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 02:19:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D99CC60C05; Tue,  2 Feb 2021 07:19:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8505060BE5;
	Tue,  2 Feb 2021 07:19:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1127J055026555; 
	Tue, 2 Feb 2021 01:19:00 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1127Ixfv026554;
	Tue, 2 Feb 2021 01:18:59 -0600
Date: Tue, 2 Feb 2021 01:18:59 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210202071859.GQ15006@octiron.msp.redhat.com>
References: <d6652b08-2d6c-ac46-9d73-b252bc26f41a@huawei.com>
	<3992c887b6b9a00c4faad17c1d381d2afb4a2e86.camel@suse.com>
	<b9824ac2-7c64-95e0-d352-1aed99eacb12@huawei.com>
	<035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
	<b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
	<299a237e5fd558b6f54a1934f4c8aed8aaf24f24.camel@suse.com>
	<20210202052636.GP15006@octiron.msp.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210202052636.GP15006@octiron.msp.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	linfeilong <linfeilong@huawei.com>
Subject: Re: [dm-devel] libmultipath: fix NULL dereference in get_be64
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 01, 2021 at 11:26:36PM -0600, Benjamin Marzinski wrote:
> On Mon, Feb 01, 2021 at 04:12:34PM +0100, Martin Wilck wrote:
> > On Mon, 2021-02-01 at 22:50 +0800, lixiaokeng wrote:
> > >=20
> > > > >=20
> > > > > cli_add_path
> > > > > =A0=A0 ->ev_add_path
> > > > > =A0=A0=A0=A0=A0 ->add_map_with_path
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0 ->adopt_paths
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pathinfo
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->filter_property
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return PATHINFO_SKIP=
PED,
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->mpp is NULL and not be se=
t
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return 0
> > > >=20
> > > > This returns 0, but add_map_with_path() has this code to check
> > > > whether
> > > > the path passed to it was actually added to the new map:
> > > >=20
> > > > =A0=A0=A0=A0=A0=A0=A0=A0if (adopt_paths(vecs->pathvec, mpp) ||
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 find_slot(vecs->pathvec, pp) =3D=
=3D -1)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;=A0 -> ret=
urn NULL
> > > >=20
> > > > So ev_add_path() should have seen a NULL return from
> > > > add_map_with_path(), should not have set start_waiter, and failed.=
=A0
> > > >=20
> > >=20
> > > I'm sorry for a big mistake in my stack. As the code is optimized,
> > > pathinfo
> > > return PATHINFO_SKIPPED after finish filter_property when I use gdb.
> > > It
> > > happens acctualy in:
> > > 2141=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (p=
p->bus =3D=3D SYSFS_BUS_SCSI &&
> > > 2142=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->sg_id.proto_id =3D=3D SCSI_PROTOCOL_USB
> > > &&
> > > 2143=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 !conf->allow_usb_devices) {
> > > 2144=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: skip USB device %s",
> > > pp->dev,
> > > 2145=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tgt_node_name);
> > > 2146=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return PATHINFO_SKIPPED;
> > > 2147=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > 2148=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > >=20
> > > Stack:
> > > cli_add_path
> > > =A0=A0 ->ev_add_path
> > > =A0=A0=A0=A0=A0 ->add_map_with_path
> > > =A0=A0=A0=A0=A0=A0=A0=A0 ->adopt_paths
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pathinfo
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->bus =3D=3D SYSFS_BUS=
_SCSI
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return PATHINFO_SKIPPED,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->mpp is NULL and not be set
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return 0
> > > =A0=A0=A0=A0=A0 ->mpath_pr_event_handle
> > > =A0=A0=A0=A0=A0=A0=A0=A0 ->get_be64 //pp->mpp is dereference
> > >=20
> > > If you think my patch is ok, I will resend it.
> >=20
> > The same argument I made above still holds. "pp" wouldn't have been
> > added to mpp, and add_map_with_path() would fail and return NULL.
> > Also, if pathinfo() returns PATHINFO_SKIPPED for this device,
> > how comes that cli_add_path() called ev_add_path() for it? It should
> > have returned "blacklisted" instead.
>=20
> So, I think the main issue here is that filter_property appears to be
> broken.  It only filters if uid_attribute is set, but that will never be
> set the first time it's called in pathinfo.  This means that it will
> pass in the pathinfo call in cli_add_path, and the path will get stored
> in the pathvec.

Just to be a little more clear here, filter_property() will only return
MATCH_PROPERTY_BLIST_MISSING for missing udev properties, if the
uid_attribute is set and seen. We should probably make sure to set
uid_attribute before calling it.

-Ben

>=20
> However, it will fail in the pathinfo call from adopt_paths, so the path
> won't be added to the multipath device.  This means adopt paths doesn't
> actually adopt any paths potentially, but that in itself doesn't cause
> it to fail. This check
>=20
>         if (adopt_paths(vecs->pathvec, mpp) ||
>             find_slot(vecs->pathvec, pp) =3D=3D -1)
>                 goto out;
>=20
> passes, since we only check if the path is on the pathvec, not part of
> the multipath device, and since filter_property let the path past the
> first time, it is. So add_map_with_path() will create a multipath
> device, but the path won't be added to it, and pp->mpp =3D=3D NULL.
>=20
> So, add_map_with_path() should probably check that we actually created a
> map that included the path that got added. But more importantly,
> filter_property shouldn't return different results the when it's called
> the first time.  That would have avoid the entire situation.
>=20
> -Ben
>=20
>=20
> > Your patch would only be effective if it was possible that
> > add_map_with_path(vecs, pp, 1) returned an mpp !=3D NULL, and at the sa=
me
> > time pp->mpp was NULL; I still don't understand how that can come to
> > pass.
> >=20
> > Have you tried my patch?
> >=20
> > Regards,
> > Martin
> >=20
> >=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

