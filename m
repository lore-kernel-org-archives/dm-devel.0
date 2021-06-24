Return-Path: <SRS0=hwRu=LS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D91C48BDF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Jun 2021 10:19:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FCF7613FD
	for <dm-devel@archiver.kernel.org>; Thu, 24 Jun 2021 10:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FCF7613FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-ta-O-Q5ANwaeRPgcql-YOQ-1; Thu, 24 Jun 2021 06:19:17 -0400
X-MC-Unique: ta-O-Q5ANwaeRPgcql-YOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA21B8C5EC0;
	Thu, 24 Jun 2021 10:19:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D188B17001;
	Thu, 24 Jun 2021 10:19:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83DA31809C99;
	Thu, 24 Jun 2021 10:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15OAJ7pM030757 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Jun 2021 06:19:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AF03821EE579; Thu, 24 Jun 2021 10:19:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB44621EE576
	for <dm-devel@redhat.com>; Thu, 24 Jun 2021 10:19:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5F41108C18B
	for <dm-devel@redhat.com>; Thu, 24 Jun 2021 10:19:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-60-oFTqvYkvPZ65OZJOw5BZaw-1; Thu, 24 Jun 2021 06:19:02 -0400
X-MC-Unique: oFTqvYkvPZ65OZJOw5BZaw-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 278111FD79;
	Thu, 24 Jun 2021 10:19:01 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id E1D8A11A97;
	Thu, 24 Jun 2021 10:19:00 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id 21iZNRRc1GDnXQAALh3uQQ
	(envelope-from <mwilck@suse.com>); Thu, 24 Jun 2021 10:19:00 +0000
Message-ID: <4f2a3b45c0e9466a69708be7f0f06227dbf695f2.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Thu, 24 Jun 2021 12:19:00 +0200
In-Reply-To: <74753cee-a5c9-7655-2779-baad5786b66a@huawei.com>
References: <74753cee-a5c9-7655-2779-baad5786b66a@huawei.com>
User-Agent: Evolution 3.40.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15OAJ7pM030757
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] multipathd: fix no checking persistent
 reservation registration
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Do, 2021-06-24 at 16:47 +0800, lixiaokeng wrote:
> If one multipath device has two paths, the first is down (network
> failure) and the second is up, then we register a prkey to the
> device. The first path will register successfully but the second
> won't. Then fix the network. The uev_update_path will race with
> check_path. If uev_update_path -> pathinfo is called before
> check_path, the state of the first path will be set PATH_UP
> without checking persistent reservation registration.
>=20
> Here we add checking in uev_update_path.
>=20
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
> =A0multipathd/main.c | 14 ++++++++++++++
> =A01 file changed, 14 insertions(+)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2251e02c..0948bf81 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1316,6 +1316,7 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0int needs_reinit =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int oldstate;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0switch ((rc =3D change_foreign(uev->udev))) {
> =A0=A0=A0=A0=A0=A0=A0=A0case FOREIGN_OK:
> @@ -1366,9 +1367,22 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->udev =3D udev_device_ref(uev->udev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onf =3D get_multipath_config();
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_cleanup_push(put_multipath_config,
> conf);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0old=
state =3D pp->state;
> +
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) !=3D
> PATHINFO_OK)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: pathinfo failed after
> change uevent",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(pp->state !=3D oldstate && (pp->state =3D=3D
> PATH_UP || pp->state =3D=3D PATH_GHOST)) {


I don't understand. pathinfo(DI_SYSFS|DI_NOIO) doesn't modify=20
pp->state.  So your first condition should always be false.
Am I overlooking something?

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

