Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6C5C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 17 Nov 2022 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668722376;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g4qZFP3Tb4lg6X5U3YC24uif6LAA5qwCHDG6YjWksTI=;
	b=eW6I5zwVeQGesMCITsvcI1oE11rJxV+vdhg7dS71RQJdTzdEqXhvETTTFzbOtRQVn/Q+va
	WZMnsSFcpOzKtNPCEdSrZ5J4BMV/tjHHLU3EVHtSs89Eo5p44eWXMluUZE5Vjx+W3IgF0H
	BKH2kSmQnKNYBWr+yi8mKX2ZY2i5QGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-0iXJ7dx9Nn-xLiBAByrksw-1; Thu, 17 Nov 2022 16:59:32 -0500
X-MC-Unique: 0iXJ7dx9Nn-xLiBAByrksw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CE14101A592;
	Thu, 17 Nov 2022 21:59:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F013E40C6EC3;
	Thu, 17 Nov 2022 21:59:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C6E0719465A2;
	Thu, 17 Nov 2022 21:59:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E74791946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 17 Nov 2022 21:59:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC3F439D7C; Thu, 17 Nov 2022 21:59:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EDF335429;
 Thu, 17 Nov 2022 21:59:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2AHLxQLm002128;
 Thu, 17 Nov 2022 15:59:26 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2AHLxPUp002127;
 Thu, 17 Nov 2022 15:59:25 -0600
Date: Thu, 17 Nov 2022 15:59:25 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20221117215925.GV19568@octiron.msp.redhat.com>
References: <20221109211007.389-1-mwilck@suse.com>
 <20221117185333.GT19568@octiron.msp.redhat.com>
 <32a8240e11ad76fa6d2f4547916a81d594200b1a.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <32a8240e11ad76fa6d2f4547916a81d594200b1a.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC PATCH] libmultipath: is_path_valid(): check if
 device is in use
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
Cc: fbui@suse.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17, 2022 at 09:40:26PM +0100, Martin Wilck wrote:
> On Thu, 2022-11-17 at 12:53 -0600, Benjamin Marzinski wrote:
> > On Wed, Nov 09, 2022 at 10:10:07PM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > With greedy, we expect that the blacklists must be correctly set up,
> > so
> > we're just slowing things down to deal with people not configuring
> > multipath correctly.=A0
>=20
> Only in theory. Because of the failed-wwids logic, "greedy" works quite
> well actually, even if the blacklist is not correctly set up.
> With this as a special exception.
>=20
> > But since I rarely see greedy configurations, I
> > don't really have strong feelings about this trade-off.
>=20
> I've been wondering whether we could make this depend on a config
> option (yes I know, I've said often that we have too many of them).
> We could also have it depend on "greedy". But it might also be useful
> with "smart" if we have a lot of LUNs.
>=20
> >=20
> > More suggestions below.
> >=20
> > [...]

<snip>

Ooops. I signed my name a bit too high. I had one more suggestion, but
it's basically the same as what you suggest above.
> >=20
> > -Ben
> >=20

<snip>

> > > @@ -96,6 +346,9 @@ is_path_valid(const char *name, struct config
> > > *conf, struct path *pp,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > > =A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0
> > > +=A0=A0=A0=A0=A0=A0=A0if (is_device_in_use(pp->udev) > 0)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VALI=
D;
> > > +

Here.

> >=20
> > Can we make this only apply to "greedy"? For "strict", "no" and "yes"
> > this makes the common case slower (you are running multipath on a
> > machine with multipath devices that you've seen before) with no real
> > benefit.
> >=20
> > It might also be useful to run this check before we return "maybe"
> > for
> > find_multipaths "smart", perhaps as an alternative to the O_EXCL test
> > we
> > currently use.
> >=20
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (conf->find_multipaths =3D=3D FIND_MULTIPA=
THS_GREEDY)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_VALID;
> > > =A0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

