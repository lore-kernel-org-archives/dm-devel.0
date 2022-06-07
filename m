Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989B5CCA47F
	for <dm-devel@archiver.kernel.org>; Tue,  7 Jun 2022 22:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654641127;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iTW9LiwYp/WoTTfCMsChSdD2A7CdlOcnzQ3XYiA8sWw=;
	b=az59eplEo/1xExGQyzDsR1bmDUcQYTGot5GiHUpTnvrXXwFc050/3AYK9atF0leHQggLqq
	RbLANxsPEKnln6ngEkmuRGpK/+E5S9RxaCifFPZuiOMkNP0tCYy5qfWvCrl4HmHuyjRVo5
	cgptUSfAbn7penDhup6Ij5Nxx+7aJ7I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-hIDF_YoWPu-U2m9ExttL3Q-1; Tue, 07 Jun 2022 18:32:04 -0400
X-MC-Unique: hIDF_YoWPu-U2m9ExttL3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF3063C17F16;
	Tue,  7 Jun 2022 22:32:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4C5A1121314;
	Tue,  7 Jun 2022 22:31:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 762B11947042;
	Tue,  7 Jun 2022 22:31:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA63E19466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Jun 2022 22:31:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A34C9400DF1C; Tue,  7 Jun 2022 22:31:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80D1540CFD05;
 Tue,  7 Jun 2022 22:31:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 257MVtvg011929;
 Tue, 7 Jun 2022 17:31:56 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 257MVsBC011928;
 Tue, 7 Jun 2022 17:31:54 -0500
Date: Tue, 7 Jun 2022 17:31:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220607223153.GU5254@octiron.msp.redhat.com>
References: <20220601202628.5469-1-mwilck@suse.com>
 <20220601202628.5469-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220601202628.5469-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 1/2] libmultipath: hwtable: new defaults for
 NVMe
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com,
 Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 01, 2022 at 10:26:27PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> So far we were using the general defaults (pgpolicy =3D FAILOVER,
> pgfailback =3D -FAILBACK_MANUAL). Xos=E9's late patches were setting this=
 to
> either MULTIBUS or ANA, and -FAILBACK_IMMEDIATE, respectively
> for most specific arrays. At the same time, some vendors don't like
> seeing their NVMe arrays listed specifically in the multipath-tools
> hwtable.
>=20
> IMO it makes sense to change the general defaults.
>=20
> detect_prio is the default, and we probe for ANA support. Thus prio
> will be "ana" for arrays that support it, and "const" otherwise.
> With "const", GROUP_BY_PRIO degenerates to MULTIBUS, and pgfailback
> won't happen anyway. This way, our defaults match most Xos=E9's new entri=
es. The
> only devices for which this patch changes behavior (from FAILOVER to MULT=
IBUS)
> are those generic devices that aren't listed, and don't support ANA.
>=20
> I considered changing the default for no_path_retry, too, but decided aga=
inst
> it. The default is "fail", and users who dislike that will need to change=
 it.
> no_path_retry is more a policy setting than a hardware property, anyway.

I agree that these new defaults are sensible, but this patch will cause
some user's arrays to change configuration when they update.  I'm not
against doing this at all, but this is one of those patches that
distributions need to take some care with, so that they can make this
change at a sensible time.

So, unless there are other objections, I'm O.k. with this patch set, I
just wanted to point this out.

-Ben

> ---
>  libmultipath/hwtable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 39daadc..e0dce84 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -90,7 +90,8 @@ static struct hwentry default_hw[] =3D {
>  =09=09.product       =3D ".*",
>  =09=09.uid_attribute =3D DEFAULT_NVME_UID_ATTRIBUTE,
>  =09=09.checker_name  =3D NONE,
> -=09=09.retain_hwhandler =3D RETAIN_HWHANDLER_OFF,
> +=09=09.pgpolicy      =3D GROUP_BY_PRIO,
> +=09=09.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  =09},
>  =09/*
>  =09 * Apple
> --=20
> 2.36.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

