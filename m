Return-Path: <SRS0=IN2R=QG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58E8C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 14:16:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6444161AD0
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 14:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6444161AD0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-5fLPSRbvMN20W2_PnWdApQ-1; Fri, 19 Nov 2021 09:16:21 -0500
X-MC-Unique: 5fLPSRbvMN20W2_PnWdApQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 397B910B744C;
	Fri, 19 Nov 2021 14:16:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEC8060622;
	Fri, 19 Nov 2021 14:16:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 650E74A703;
	Fri, 19 Nov 2021 14:16:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJEGAhK012900 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 09:16:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C330404727A; Fri, 19 Nov 2021 14:16:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 774624047279
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 14:16:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FD6810665A0
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 14:16:10 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-96-9mLUFZxOMYCywZwMFeTDWg-1; Fri, 19 Nov 2021 09:16:08 -0500
X-MC-Unique: 9mLUFZxOMYCywZwMFeTDWg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48745212B5;
	Fri, 19 Nov 2021 14:16:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EAE8613B35;
	Fri, 19 Nov 2021 14:16:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +C4hN6axl2EFfAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 19 Nov 2021 14:16:06 +0000
Message-ID: <7abf6786f86729cee46fb3de4dc61da6ff514891.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Fri, 19 Nov 2021 15:16:06 +0100
In-Reply-To: <062b605f-e4c1-8832-d18f-05d403b070b1@huawei.com>
References: <4b37e359-4e75-55bb-c55e-c73dde4c9fd2@huawei.com>
	<062b605f-e4c1-8832-d18f-05d403b070b1@huawei.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AJEGAhK012900
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] Fix potential null pointer dereference
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-11-19 at 16:56 +0800, lixiaokeng wrote:
> udev_device_* may return NULL, check it.
>=20
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
> =A0libmultipath/discovery.c=A0=A0=A0 |=A0 8 +++++---
> =A0libmultipath/foreign/nvme.c |=A0 4 +++-
> =A0libmultipath/util.c=A0=A0=A0=A0=A0=A0=A0=A0 | 10 +++++++++-
> =A03 files changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index f25fe9e3..07ebe7d5 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
>=20
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index ea858409..3d036e19 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -168,6 +168,7 @@ size_t strlcat(char * restrict dst, const char *
> restrict src, size_t size)
> =A0int devt2devname(char *devname, int devname_len, const char *devt)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct udev_device *u_dev;
> +=A0=A0=A0=A0=A0=A0=A0const char * dev_name;
> =A0=A0=A0=A0=A0=A0=A0=A0int r;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0if (!devname || !devname_len || !devt)
> @@ -178,7 +179,14 @@ int devt2devname(char *devname, int devname_len,
> const char *devt)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "\"%s\": inval=
id major/minor numbers, not
> found in sysfs", devt);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0r =3D strlcpy(devname, udev_device_get_sysname(u_de=
v),
> devname_len);
> +
> +=A0=A0=A0=A0=A0=A0=A0dev_name =3D udev_device_get_sysname(u_dev);
> +=A0=A0=A0=A0=A0=A0=A0if (!dev_name) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "\"%s\": fail to=
 get sysname\n", devt);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0udev_device_unref(u_dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0r =3D strlcpy(devname, dev_name, devname_len);

No condlog() here, please. The only caller, sysfs_check_holders(),
already logs an error from devt2devname().

Martin





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

