Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3966FC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 11:04:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7647864DD4
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 11:04:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7647864DD4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-o0hvMJIxNNGtJQnGIKxcUg-1; Tue, 02 Feb 2021 06:04:31 -0500
X-MC-Unique: o0hvMJIxNNGtJQnGIKxcUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A71598030B4;
	Tue,  2 Feb 2021 11:04:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 358DA10016FB;
	Tue,  2 Feb 2021 11:04:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 03F9850039;
	Tue,  2 Feb 2021 11:04:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112B4Kpm005286 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 06:04:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4BB618578A; Tue,  2 Feb 2021 11:04:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4532333250
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 11:04:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09578101A561
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 11:04:18 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-233-SEflkocfN3eSYN4l42fKHQ-1;
	Tue, 02 Feb 2021 06:04:15 -0500
X-MC-Unique: SEflkocfN3eSYN4l42fKHQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3C62FAD87;
	Tue,  2 Feb 2021 11:04:14 +0000 (UTC)
Message-ID: <1d43e7d308df084efb506dad59dc2faa6577361a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 02 Feb 2021 12:04:12 +0100
In-Reply-To: <20210202052636.GP15006@octiron.msp.redhat.com>
References: <d6652b08-2d6c-ac46-9d73-b252bc26f41a@huawei.com>
	<3992c887b6b9a00c4faad17c1d381d2afb4a2e86.camel@suse.com>
	<b9824ac2-7c64-95e0-d352-1aed99eacb12@huawei.com>
	<035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
	<b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
	<299a237e5fd558b6f54a1934f4c8aed8aaf24f24.camel@suse.com>
	<20210202052636.GP15006@octiron.msp.redhat.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112B4Kpm005286
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-02-01 at 23:26 -0600, Benjamin Marzinski wrote:
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
> > > > add_map_with_path(), should not have set start_waiter, and
> > > > failed.=A0
> > > >=20
> > >=20
> > > I'm sorry for a big mistake in my stack. As the code is
> > > optimized,
> > > pathinfo
> > > return PATHINFO_SKIPPED after finish filter_property when I use
> > > gdb.
> > > It
> > > happens acctualy in:
> > > 2141=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (p=
p->bus =3D=3D SYSFS_BUS_SCSI &&
> > > 2142=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->sg_id.proto_id =3D=3D
> > > SCSI_PROTOCOL_USB
> > > &&
> > > 2143=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 !conf->allow_usb_devices) {
> > > 2144=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: skip USB device
> > > %s",
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
> > how comes that cli_add_path() called ev_add_path() for it? It
> > should
> > have returned "blacklisted" instead.
>=20
> So, I think the main issue here is that filter_property appears to be
> broken.=A0 It only filters if uid_attribute is set, but that will never
> be
> set the first time it's called in pathinfo.=A0 This means that it will
> pass in the pathinfo call in cli_add_path, and the path will get
> stored
> in the pathvec.

I'd not say filter_property() is broken; rather, its callers.=A0
See below.

> However, it will fail in the pathinfo call from adopt_paths, so the
> path
> won't be added to the multipath device.=A0 This means adopt paths
> doesn't
> actually adopt any paths potentially, but that in itself doesn't
> cause
> it to fail. This check
>=20
> =A0=A0=A0=A0=A0=A0=A0 if (adopt_paths(vecs->pathvec, mpp) ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 find_slot(vecs->pathvec, pp) =3D=3D -1)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;
>=20
> passes, since we only check if the path is on the pathvec, not part
> of
> the multipath device, and since filter_property let the path past the
> first time, it is. So add_map_with_path() will create a multipath
> device, but the path won't be added to it, and pp->mpp =3D=3D NULL.
>=20
> So, add_map_with_path() should probably check that we actually
> created a
> map that included the path that got added.=A0

Exactly, this is a bug. Thanks for analyzing this. I'll send a patch
asap.

> But more importantly,
> filter_property shouldn't return different results the when it's
> called
> the first time.=A0 That would have avoid the entire situation.

I'm not sure about this. filter_property() returning different results
depending on the initialization state of the path is irritating, sure.
Yet it makes certain sense that once the information about a path
object is more complete, the decision whether or not it should be
blacklisted might change. The only way to avoid that is to provide the
necessary information in the first place.

IMO the only reasonable way to amend this is to call select_getuid()
before filter_property(). I'll send a patch for that, too.
Determination of getuid/uid_attribute isn't expensive; the only reason
why we've been doing it "lazily" is legacy, AFAICS.

Note: We bump into a deep design issue with multipath-tools here, the
fact that path and multipath properties depend on each other in complex
ways, but these dependencies are hidden deeply in the code and need to
be explicitly memorized by us developers when we work on the code,
which is error-prone. Unfortunately, I see no easy way out of this.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

