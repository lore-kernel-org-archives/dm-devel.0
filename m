Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266FAC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648661672;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rJeJwFuRftPD/KoXz8xcfVKuTYKwcQewGUKTOsK1XK4=;
	b=XtXInM7gLml92xYEOymAOYU1lLB7STIDAN4S/y4KqpmrtQqmaVNfCiVAuByrtNU46fXbeH
	MbAugmU8T/r6dYCIoTVF/qua6eYld9TJvLKMrgu9dV1oQB8gNFpMKapBTJb4wR11AM3W9W
	Mb4dliJTmQxIC3/P1yXe6+PMZDvc/I8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-yyOrln_DNiC8Bl0Xr5Q7cg-1; Wed, 30 Mar 2022 13:34:27 -0400
X-MC-Unique: yyOrln_DNiC8Bl0Xr5Q7cg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC5B811E83;
	Wed, 30 Mar 2022 17:34:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A77AD4010A2D;
	Wed, 30 Mar 2022 17:34:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E12A1947BBB;
	Wed, 30 Mar 2022 17:34:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B60C819451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 17:34:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9052757E43C; Wed, 30 Mar 2022 17:34:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 807A157ECC3;
 Wed, 30 Mar 2022 17:34:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22UHYHSs032620;
 Wed, 30 Mar 2022 12:34:22 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22UHYGmU032619;
 Wed, 30 Mar 2022 12:34:16 -0500
Date: Wed, 30 Mar 2022 12:33:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220330173359.GR24684@octiron.msp.redhat.com>
References: <1648610498-28440-1-git-send-email-bmarzins@redhat.com>
 <6c69d3e943217da7027e65279d6f84830d9a881d.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <6c69d3e943217da7027e65279d6f84830d9a881d.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] multipath: return failure on an invalid
 remove command
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 30, 2022 at 12:50:00PM +0000, Martin Wilck wrote:
> On Tue, 2022-03-29 at 22:21 -0500, Benjamin Marzinski wrote:
> > When "multipath -f" is run on a device that doesn't exist or isn't a
> > multipath device, the command will not remove any device, but it will
> > still return success.=A0 Multiple functions rely on _dm_flush_map()
> > returning success when called with name that doesn't match any
> > multipath device. So before calling _dm_flush_map(), call
> > dm_is_mpath(),
> > to check if the device exists and is a multipath device, and return
> > failure if it's not.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0multipath/main.c | 5 +++++
> > =A01 file changed, 5 insertions(+)
> >=20
> > diff --git a/multipath/main.c b/multipath/main.c
> > index d09f62db..e865309d 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -1060,6 +1060,11 @@ main (int argc, char *argv[])
> > =A0=A0=A0=A0=A0=A0=A0=A0if (retries < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retries =3D conf->remov=
e_retries;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (cmd =3D=3D CMD_FLUSH_ONE) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (dm_is_mpath(dev) !=3D=
 1) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "failed removing \"%s\"", dev);
>=20
> Could we provide a more meaningful error message here?
> (As you're the native speaker - shouldn't it rather be "failed to
> remove"?)

Sure. I'll clean that up.

-Ben

>=20
> Otherwise, ack.
>=20
> Martin
>=20
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
 =3D RTVL_FAIL;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_suspend_and_fl=
ush_map(dev, retries) ?
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 RTVL_FAIL : R=
TVL_OK;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

