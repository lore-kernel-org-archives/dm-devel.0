Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E982CC433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 12:43:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0EDBE22D04
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 12:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EDBE22D04
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-uwvyfxuRPh-zQOdJ0v1W4Q-1; Mon, 25 Jan 2021 07:43:27 -0500
X-MC-Unique: uwvyfxuRPh-zQOdJ0v1W4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 609BC1005513;
	Mon, 25 Jan 2021 12:43:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5FA360C9C;
	Mon, 25 Jan 2021 12:43:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 44F5618095FF;
	Mon, 25 Jan 2021 12:43:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PChKQg024006 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 07:43:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A7441111A6B; Mon, 25 Jan 2021 12:43:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 167E31111A6A
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 12:43:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6DF7811E76
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 12:43:17 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-92-vQ-mbLkQPIi05PjNm1SXcA-1;
	Mon, 25 Jan 2021 07:43:13 -0500
X-MC-Unique: vQ-mbLkQPIi05PjNm1SXcA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 69884B2D1;
	Mon, 25 Jan 2021 12:43:12 +0000 (UTC)
Message-ID: <ab556abe7dd1df90489f86bb91ea6578cd29a648.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Mon, 25 Jan 2021 13:43:11 +0100
In-Reply-To: <a2693d7a-55f1-234e-74a1-f234c152a490@huawei.com>
References: <a2693d7a-55f1-234e-74a1-f234c152a490@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10PChKQg024006
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: fix NULL dereference in
	find_path_by_dev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-01-23 at 16:19 +0800, lixiaokeng wrote:
> When I test the 0.8.5 code with iscsi login/out, multipathd command
> and multipath command concurrently, there is a multipathd coredump.
> The stack is shown:
>=20
> uxlsnrloop
> =A0 ->cli_list_devices
> =A0=A0=A0 ->show_devices
> =A0=A0=A0=A0=A0 ->snprint_devices
> =A0=A0=A0=A0=A0=A0=A0 ->find_path_by_dev
>=20
> The reason is that devname is NULL in snprint_devices, then it will
> be dereference. Here we check dev in find_path_by_dev.
> ---
> =A0libmultipath/structs.c | 4 ++--
> =A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 464596f..a3f27fd 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -453,12 +453,12 @@ find_mp_by_str (const struct _vector *mpvec,
> const char * str)
> =A0}
>=20
> =A0struct path *
> -find_path_by_dev (const struct _vector *pathvec, const char * dev)
> +find_path_by_dev (const struct _vector *pathvec, const char *dev)
> =A0{
> =A0=A0=A0 int i;
> =A0=A0=A0 struct path * pp;
>=20
> -=A0=A0 if (!pathvec)
> +=A0=A0 if (!pathvec || !dev)
> =A0=A0=A0=A0=A0=A0=A0 return NULL;
>=20
> =A0=A0=A0 vector_foreach_slot (pathvec, pp, i)

Reviewed-by: Martin Wilck <mwilck@suse.de>

However, the actual issue is in snprint_devices():

=09r =3D udev_enumerate_scan_devices(enm);
=09first =3D udev_enumerate_get_list_entry(enm);
=09udev_list_entry_foreach(item, first) {

=09=09path =3D udev_list_entry_get_name(item);
=09=09u_dev =3D udev_device_new_from_syspath(udev, path);
=09=09devname =3D udev_device_get_sysname(u_dev);
                pp =3D find_path_by_dev(vecs->pathvec, devname);

if devname was NULL here, it means that the list returned by
udev_enumerate_scan_devices() contains devices that don't exist
(any more), even though the call to udev_enumerate_scan_devices() was
just a few LoC above. It's the kind of thing you don't expect, but you
should expect when you deal with udev :-/

I'll send a patch for that, too.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

