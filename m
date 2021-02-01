Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7465C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 15:12:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 55D3064DE3
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 15:12:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55D3064DE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-2sh9WaFOPmiiYJG8M-EQKA-1; Mon, 01 Feb 2021 10:12:50 -0500
X-MC-Unique: 2sh9WaFOPmiiYJG8M-EQKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D429715720;
	Mon,  1 Feb 2021 15:12:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3FEB5D6BA;
	Mon,  1 Feb 2021 15:12:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27C68180954D;
	Mon,  1 Feb 2021 15:12:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 111FCgK7006092 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 10:12:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DDA251111445; Mon,  1 Feb 2021 15:12:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D90991004050
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 15:12:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 561D6811E84
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 15:12:39 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-423-fv5eF5AWPg2dSHs1y82NZg-1;
	Mon, 01 Feb 2021 10:12:36 -0500
X-MC-Unique: fv5eF5AWPg2dSHs1y82NZg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5C55CB125;
	Mon,  1 Feb 2021 15:12:35 +0000 (UTC)
Message-ID: <299a237e5fd558b6f54a1934f4c8aed8aaf24f24.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Mon, 01 Feb 2021 16:12:34 +0100
In-Reply-To: <b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
References: <d6652b08-2d6c-ac46-9d73-b252bc26f41a@huawei.com>
	<3992c887b6b9a00c4faad17c1d381d2afb4a2e86.camel@suse.com>
	<b9824ac2-7c64-95e0-d352-1aed99eacb12@huawei.com>
	<035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
	<b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 111FCgK7006092
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-02-01 at 22:50 +0800, lixiaokeng wrote:
>=20
> > >=20
> > > cli_add_path
> > > =A0=A0 ->ev_add_path
> > > =A0=A0=A0=A0=A0 ->add_map_with_path
> > > =A0=A0=A0=A0=A0=A0=A0=A0 ->adopt_paths
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pathinfo
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->filter_property
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return PATHINFO_SKIPPED,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->mpp is NULL and not be set
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return 0
> >=20
> > This returns 0, but add_map_with_path() has this code to check
> > whether
> > the path passed to it was actually added to the new map:
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0if (adopt_paths(vecs->pathvec, mpp) ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 find_slot(vecs->pathvec, pp) =3D=3D -=
1)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;=A0 -> return =
NULL
> >=20
> > So ev_add_path() should have seen a NULL return from
> > add_map_with_path(), should not have set start_waiter, and failed.=A0
> >=20
>=20
> I'm sorry for a big mistake in my stack. As the code is optimized,
> pathinfo
> return PATHINFO_SKIPPED after finish filter_property when I use gdb.
> It
> happens acctualy in:
> 2141=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->b=
us =3D=3D SYSFS_BUS_SCSI &&
> 2142=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 pp->sg_id.proto_id =3D=3D SCSI_PROTOCOL_USB
> &&
> 2143=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 !conf->allow_usb_devices) {
> 2144=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0condlog(3, "%s: skip USB device %s",
> pp->dev,
> 2145=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tgt_node_name);
> 2146=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0return PATHINFO_SKIPPED;
> 2147=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> 2148=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> Stack:
> cli_add_path
> =A0=A0 ->ev_add_path
> =A0=A0=A0=A0=A0 ->add_map_with_path
> =A0=A0=A0=A0=A0=A0=A0=A0 ->adopt_paths
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pathinfo
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->bus =3D=3D SYSFS_BUS_SCS=
I
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return PATHINFO_SKIPPED,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->pp->mpp is NULL and not be set
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ->return 0
> =A0=A0=A0=A0=A0 ->mpath_pr_event_handle
> =A0=A0=A0=A0=A0=A0=A0=A0 ->get_be64 //pp->mpp is dereference
>=20
> If you think my patch is ok, I will resend it.

The same argument I made above still holds. "pp" wouldn't have been
added to mpp, and add_map_with_path() would fail and return NULL.
Also, if pathinfo() returns PATHINFO_SKIPPED for this device,
how comes that cli_add_path() called ev_add_path() for it? It should
have returned "blacklisted" instead.

Your patch would only be effective if it was possible that
add_map_with_path(vecs, pp, 1) returned an mpp !=3D NULL, and at the same
time pp->mpp was NULL; I still don't understand how that can come to
pass.

Have you tried my patch?

Regards,
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

