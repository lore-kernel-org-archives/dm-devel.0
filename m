Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC6F1C3DA66
	for <dm-devel@archiver.kernel.org>; Wed, 23 Aug 2023 19:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692820638;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3yUGGZ8B4OSksYggs6yxJ6GEdLa4y/v8lfxF34QkfXo=;
	b=CKDxNthC3g4+dHh5cIFhgcrLkWzHY+zYKpEelmCuUIRoGcpQ3psdLwIcq6bRNOnaSKMjGs
	l5AfqoH38ZHk/H/SILgqk6z87mX443t5cZlW+ZxMmXsRncsNxSS8lyoRbyImWQljc7fDQM
	sIW1vN+yaxM20iOHVSvazj6TwpXl6oo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-Kt0ac9z4OMO__Ygak1Fc5Q-1; Wed, 23 Aug 2023 15:57:15 -0400
X-MC-Unique: Kt0ac9z4OMO__Ygak1Fc5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 307F4800C78;
	Wed, 23 Aug 2023 19:57:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A86761121314;
	Wed, 23 Aug 2023 19:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 582F0194658C;
	Wed, 23 Aug 2023 19:56:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 820CB1946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Aug 2023 19:52:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60FED40C2073; Wed, 23 Aug 2023 19:52:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A3FE40C207A
 for <dm-devel@redhat.com>; Wed, 23 Aug 2023 19:52:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 382563C147E6
 for <dm-devel@redhat.com>; Wed, 23 Aug 2023 19:52:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-r8iQqE_VNoG3G4AMX4gOTQ-1; Wed,
 23 Aug 2023 15:52:03 -0400
X-MC-Unique: r8iQqE_VNoG3G4AMX4gOTQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id C51E322488;
 Wed, 23 Aug 2023 19:52:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8A61113458;
 Wed, 23 Aug 2023 19:52:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id eKHfHmBj5mSLGQAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 23 Aug 2023 19:52:00 +0000
Message-ID: <9bb4ca089c3d2dd5b331df88f3f89953916b0b17.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Etienne Aujames <eaujames@ddn.com>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>
Date: Wed, 23 Aug 2023 21:51:59 +0200
In-Reply-To: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
References: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] libmultipath: fix max_sectors_kb on adding
 path
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-08-23 at 16:24 +0000, Etienne Aujames wrote:
> From: Etienne AUJAMES <eaujames@ddn.com>
>=20
> A user can change the value of max_sectors_kb on the multipath device
> and its path devices.
> So when a path is deleted and then re-added, its value will not be
> the
> same as the multipath device. In that case the IOs could be mis-
> sized.
>=20
> On reload, this patch re-apply max_sectors_kb value of the multipath
> device on its path devices.
>=20
> Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>

Looks good to me.
Reviewed-by: Martin Wilck <mwilck@suse.com>



> ---
> =A0libmultipath/configure.c | 7 ++++---
> =A01 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 4a1c28bb..639c0905 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -593,11 +593,12 @@ sysfs_set_max_sectors_kb(struct multipath *mpp,
> int is_reload)
> =A0=A0=A0=A0=A0=A0=A0=A0ssize_t len;
> =A0=A0=A0=A0=A0=A0=A0=A0int i, j, ret, err =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0struct udev_device *udd;
> -=A0=A0=A0=A0=A0=A0=A0int max_sectors_kb;
> +=A0=A0=A0=A0=A0=A0=A0int max_sectors_kb =3D mpp->max_sectors_kb;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (mpp->max_sectors_kb =3D=3D MAX_SECTORS_KB_UNDEF=
)
> +=A0=A0=A0=A0=A0=A0=A0/* by default, do not initialize max_sectors_kb on =
the device
> */
> +=A0=A0=A0=A0=A0=A0=A0if (max_sectors_kb =3D=3D MAX_SECTORS_KB_UNDEF && !=
is_reload)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0max_sectors_kb =3D mpp->max_sectors_kb;
> +=A0=A0=A0=A0=A0=A0=A0/* on reload, re-apply the user tuning on all the p=
ath
> devices
> */
> =A0=A0=A0=A0=A0=A0=A0=A0if (is_reload) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!has_dm_info(mpp) &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_get_info(mpp=
->alias, &mpp->dmi) !=3D 0) {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

