Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10950C43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:04:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-MLfkixIaN0qZrqsKQ3JwRg-1; Wed, 08 Jun 2022 04:04:50 -0400
X-MC-Unique: MLfkixIaN0qZrqsKQ3JwRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB21C85A584;
	Wed,  8 Jun 2022 08:04:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6983C404E4BE;
	Wed,  8 Jun 2022 08:04:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53A48194704C;
	Wed,  8 Jun 2022 08:04:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4EE72194704C
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 08:04:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3BF1E2166B29; Wed,  8 Jun 2022 08:04:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36FF02166B26
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 08:04:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18E811C1C1A9
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 08:04:46 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-ICY1IwokNzyqnWoZxMgKYA-1; Wed, 08 Jun 2022 04:04:44 -0400
X-MC-Unique: ICY1IwokNzyqnWoZxMgKYA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id F13B321B81;
 Wed,  8 Jun 2022 08:04:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA61113AD9;
 Wed,  8 Jun 2022 08:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wZL4KxpYoGIGLgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 08 Jun 2022 08:04:42 +0000
Message-ID: <9fb15737f74c486497c7c722c481945b2676beb6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 08 Jun 2022 10:04:42 +0200
In-Reply-To: <20220607223153.GU5254@octiron.msp.redhat.com>
References: <20220601202628.5469-1-mwilck@suse.com>
 <20220601202628.5469-2-mwilck@suse.com>
 <20220607223153.GU5254@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-06-07 at 17:31 -0500, Benjamin Marzinski wrote:
> On Wed, Jun 01, 2022 at 10:26:27PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > So far we were using the general defaults (pgpolicy =3D FAILOVER,
> > pgfailback =3D -FAILBACK_MANUAL). Xos=E9's late patches were setting
> > this to
> > either MULTIBUS or ANA, and -FAILBACK_IMMEDIATE, respectively
> > for most specific arrays. At the same time, some vendors don't like
> > seeing their NVMe arrays listed specifically in the multipath-tools
> > hwtable.
> >=20
> > IMO it makes sense to change the general defaults.
> >=20
> > detect_prio is the default, and we probe for ANA support. Thus prio
> > will be "ana" for arrays that support it, and "const" otherwise.
> > With "const", GROUP_BY_PRIO degenerates to MULTIBUS, and pgfailback
> > won't happen anyway. This way, our defaults match most Xos=E9's new
> > entries. The
> > only devices for which this patch changes behavior (from FAILOVER
> > to MULTIBUS)
> > are those generic devices that aren't listed, and don't support
> > ANA.
> >=20
> > I considered changing the default for no_path_retry, too, but
> > decided against
> > it. The default is "fail", and users who dislike that will need to
> > change it.
> > no_path_retry is more a policy setting than a hardware property,
> > anyway.
>=20
> I agree that these new defaults are sensible, but this patch will
> cause
> some user's arrays to change configuration when they update.=A0 I'm not
> against doing this at all, but this is one of those patches that
> distributions need to take some care with, so that they can make this
> change at a sensible time.
>=20
> So, unless there are other objections, I'm O.k. with this patch set,
> I
> just wanted to point this out.

Understood. I believe everyone understands that Linux distributions
may, and will, sometimes use device defaults that are different from
upstream, especially in cases where backward compatibility matters more
than anything else.

The main motivation behind this patch was to avoid mentioning certain
NVMe devices explicitly in the _upstream_ hwtable. Simplification, and
a slight improvement of the actual defaults, is a side effect.

If you don't mind, I'd appreciated a Reviewed-by ;-)

Martin


>=20
> -Ben
>=20
> > ---
> > =A0libmultipath/hwtable.c | 3 ++-
> > =A01 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 39daadc..e0dce84 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -90,7 +90,8 @@ static struct hwentry default_hw[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D ".*",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.uid_attribute =3D DEFA=
ULT_NVME_UID_ATTRIBUTE,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.checker_name=A0 =3D NO=
NE,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.retain_hwhandler =3D RET=
AIN_HWHANDLER_OFF,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D =
-FAILBACK_IMMEDIATE,
> > =A0=A0=A0=A0=A0=A0=A0=A0},
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * Apple
> > --=20
> > 2.36.1
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

