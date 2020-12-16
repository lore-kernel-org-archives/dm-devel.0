Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12426C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:20:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F35323437
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F35323437
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608160813;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bacdGjBqZvDhDszFr0gxlxPaD1n4+haBuR2Qelm1Xxw=;
	b=AOZzloX2CEcaIKCIy5bnszNZcPUeckTxw1ASPq1HNq/RKziiGUpeLeRTDMhpWS79QUr261
	rxxiUK/l5dIE8+U0AN0cQ4pbWr+6N7M1g9j+0EBOJgIn9kiPeE0iQmklxLggjRZzxF7jvq
	79YhwRcFrWRoREMWtvGjUmG8WJBVkZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-GIDGwIB4OriZ95GbbhzI8Q-1; Wed, 16 Dec 2020 18:20:11 -0500
X-MC-Unique: GIDGwIB4OriZ95GbbhzI8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C7311842142;
	Wed, 16 Dec 2020 23:20:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E5635D9C0;
	Wed, 16 Dec 2020 23:20:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58FF54A7C6;
	Wed, 16 Dec 2020 23:20:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGNK1gC019438 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 18:20:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3A3363A47; Wed, 16 Dec 2020 23:20:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2724F5D71B;
	Wed, 16 Dec 2020 23:19:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BGNJur8027184; 
	Wed, 16 Dec 2020 17:19:57 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BGNJuV9027183;
	Wed, 16 Dec 2020 17:19:56 -0600
Date: Wed, 16 Dec 2020 17:19:56 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201216231956.GQ3103@octiron.msp.redhat.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
	<1604472849-22422-5-git-send-email-bmarzins@redhat.com>
	<73dd01fbb1141e0da4686d7ccb43110f14d56fc1.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <73dd01fbb1141e0da4686d7ccb43110f14d56fc1.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 4/6] libmultipath: factor out code to get
	vpd page data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16, 2020 at 09:13:49PM +0000, Martin Wilck wrote:
> On Wed, 2020-11-04 at 00:54 -0600, Benjamin Marzinski wrote:
> > A future patch will reuse the code to get the vpd page data, so
> > factor
> > it out from get_vpd_sgio().
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index a97d2998..95ddbbbd 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1319,11 +1319,10 @@ get_vpd_sysfs (struct udev_device *parent,
> > int pg, char * str, int maxlen)
> >  =09return len;
> >  }
> > =20
> > -int
> > -get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
> > +static int
> > +fetch_vpd_page(int fd, int pg, unsigned char *buff)
> >  {
> > -=09int len, buff_len;
> > -=09unsigned char buff[4096];
> > +=09int buff_len;
> > =20
> >  =09memset(buff, 0x0, 4096);
>=20
> I don't know ... I think we shouldn't write any new functions making
> assumptions about the size of buffers passed to them, even if the
> caller is directly next to them in the code.
>=20

Fair enough. I'll change that.

-Ben

> >  =09if (sgio_get_vpd(buff, 4096, fd, pg) < 0) {
> > @@ -1344,6 +1343,18 @@ get_vpd_sgio (int fd, int pg, int vend_id,
> > char * str, int maxlen)
> >  =09=09condlog(3, "vpd pg%02x page truncated", pg);
> >  =09=09buff_len =3D 4096;
> >  =09}
> > +=09return buff_len;
> > +}
> > +
> > +int
> > +get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
> > +{
> > +=09int len, buff_len;
> > +=09unsigned char buff[4096];
> > +
> > +=09buff_len =3D fetch_vpd_page(fd, pg, buff);
> > +=09if (buff_len < 0)
> > +=09=09return buff_len;
> >  =09if (pg =3D=3D 0x80)
> >  =09=09len =3D parse_vpd_pg80(buff, str, maxlen);
> >  =09else if (pg =3D=3D 0x83)
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=C3=BCrnberg GF: Felix
> Imend=C3=B6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

