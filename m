Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C215C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:53:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52FF564F61
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:53:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52FF564F61
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-FqBq3XUgN7mcT0YMPcB7AA-1; Tue, 02 Feb 2021 15:53:33 -0500
X-MC-Unique: FqBq3XUgN7mcT0YMPcB7AA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ACAD101715D;
	Tue,  2 Feb 2021 20:53:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 663A16EF50;
	Tue,  2 Feb 2021 20:53:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E23950039;
	Tue,  2 Feb 2021 20:53:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112Kr2ja010098 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 15:53:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 191A82026D49; Tue,  2 Feb 2021 20:53:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1367C2026D15
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 20:52:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D21F9187504C
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 20:52:59 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-183-cMKPZ-w-OUKhQJobZz_Fbw-1;
	Tue, 02 Feb 2021 15:52:57 -0500
X-MC-Unique: cMKPZ-w-OUKhQJobZz_Fbw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 21FBCAC55;
	Tue,  2 Feb 2021 20:52:56 +0000 (UTC)
Message-ID: <c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng@huawei.com, Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 02 Feb 2021 21:52:55 +0100
In-Reply-To: <20210128210852.23207-1-mwilck@suse.com>
References: <20210128210852.23207-1-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112Kr2ja010098
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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

lixiaokeng,

did this fix your "crash on exit" issue?

Martin

On Thu, 2021-01-28 at 22:08 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> Crashes have been observed in the unwinder stack of uevent_listen().
> This can only be explained by "udev" not being a valid object at that
> time. Be sure to pass a valid pointer, and don't call udev_unref() if
> it has been set to NULL already.
>=20
> I'm not quite sure how this would come to pass, as we join the
> threads
> before setting udev to NULL, but this is unwinder code, so I guess it
> might actually be executed after the thread has terminated.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> =A0libmultipath/uevent.c | 7 ++++---
> =A01 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index d3061bf..4e662ff 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -397,10 +397,11 @@ service_uevq(struct list_head *tmpq)
> =A0
> =A0static void uevent_cleanup(void *arg)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0struct udev *udev =3D arg;
> +=A0=A0=A0=A0=A0=A0=A0struct udev **pudev =3D arg;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (*pudev)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0udev_unref(*pudev);
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Releasing uevent_listen() resources")=
;
> -=A0=A0=A0=A0=A0=A0=A0udev_unref(udev);
> =A0}
> =A0
> =A0static void monitor_cleanup(void *arg)
> @@ -560,7 +561,7 @@ int uevent_listen(struct udev *udev)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0udev_ref(udev);
> -=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(uevent_cleanup, udev);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(uevent_cleanup, &udev);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0monitor =3D udev_monitor_new_from_netlink(udev, "=
udev");
> =A0=A0=A0=A0=A0=A0=A0=A0if (!monitor) {



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

