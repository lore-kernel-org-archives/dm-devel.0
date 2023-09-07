Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD3EEE14D0
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 08:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694074990;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bu33IvmBL22/DWV7KYL0sJIF2ciwvcqiqUtfgZh1cGQ=;
	b=D8ZTkUlKmdc3RslsXz+WmqtXcUYhDkBxQLHgWbyClaydUdlWU+Z27lKJIrITIAMCeP+TVd
	7WADYAMUmDmyJJdQf1eUX1YNTKKVM+24rXvBiaV2dCla8/Tw3WWjPhH7eAgvAJxQS/M+gj
	rYr5Mf2hPu9XJpbCiOuBfmwBfSD1TUU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-_so1XC7PPBq-z_PvbQxVnA-1; Thu, 07 Sep 2023 04:23:07 -0400
X-MC-Unique: _so1XC7PPBq-z_PvbQxVnA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FABB1C29784;
	Thu,  7 Sep 2023 08:23:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9607C525726;
	Thu,  7 Sep 2023 08:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54A30194658F;
	Thu,  7 Sep 2023 08:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7816C1946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 08:23:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5892F1460FF2; Thu,  7 Sep 2023 08:23:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 516981460FE7
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 08:23:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 328EB280770F
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 08:23:03 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-AmBTJlrgNRalVthRRFsOKA-1; Thu,
 07 Sep 2023 04:23:00 -0400
X-MC-Unique: AmBTJlrgNRalVthRRFsOKA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 52CD31F88F;
 Thu,  7 Sep 2023 08:22:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2BE79138FA;
 Thu,  7 Sep 2023 08:22:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 6m8kCWOI+WScFAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 07 Sep 2023 08:22:59 +0000
Message-ID: <f8952dd56f3ede5d63474f79bbea44ffcf659d68.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 07 Sep 2023 10:22:58 +0200
In-Reply-To: <20230906224306.GP7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-6-mwilck@suse.com>
 <20230906224306.GP7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 05/21] libmultipath: lookup_binding: add
 comment about the algorithm
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-06 at 17:43 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 01, 2023 at 08:02:18PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > When I read this code, I always get confused. Adding comments to
> > explain the algorithm.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/alias.c | 35 +++++++++++++++++++++++++++++++++++
> > =A01 file changed, 35 insertions(+)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index f7834d1..e61eb91 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -172,6 +172,41 @@ lookup_binding(FILE *f, const char *map_wwid,
> > char **map_alias,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias =3D strtok_r(buf,=
 " \t", &saveptr);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!alias) /* blank li=
ne */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Find an unused index -=
 explanation of the
> > algorithm
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * ID: 1 =3D mpatha, 2 =
=3D mpathb, ...
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * We assume the bindings=
 are unsorted. The only
> > constraint
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * is that no ID occurs m=
ore than once. IDs that
> > occur in the
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * bindings are called "u=
sed".
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * We call the list 1,2,3=
,..., exactly in this
> > order, the list
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * of "expected" IDs. The=
 variable "id" always
> > holds the next
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * "expected" ID, IOW the=
 last "expected" ID
> > encountered plus 1.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Thus all IDs below "id=
" are known to be used.
> > However, at the
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * end of the loop, the v=
alue of "id" isn't
> > necessarily unused.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * "smallest_bigger_id" i=
s the smallest used ID
> > that was
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * encountered while it w=
as larger than the next
> > "expected" ID
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * at that iteration. Let=
 X be some used ID. If all
> > IDs below X
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * are used and encounter=
ed in the right sequence
> > before X, "id"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * will be > X when the l=
oop ends. Otherwise, X was
> > encountered
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * "out of order", the co=
ndition (X > id) holds
> > when X is
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * encountered, and "smal=
lest_bigger_id" will be
> > set to X; i.e.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * it will be less or equ=
al than X when the loop
> > ends.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * At the end of the loop=
, (id <
> > smallest_bigger_id) means that
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * the value of "id" had =
been encountered neither
> > in order nor
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * out of order, and is t=
hus unused. (id >=3D
> > smallest_bigger_id)
>=20
> I know the check is (id >=3D smallest_bigger_id), but as long as no ID
> occurs more than once, id can never actually be bigger than
> smallest_bigger_id since id only gets incremented when (curr_id =3D=3D
> id)
> and if smallest_bigger_id is not INT_MAX, then smallest_bigger_id
> already occured once in the file before id was incremented to equal
> it.
> This means it can't occur again, so id can never get incremented past
> it. Not this this really matters, so

Right. Like you, I thought this didn't matter for the algorithm as
such, and that explaining it would make the lengthy explanation even
lengthier.

Btw, if you have a simpler explanation of this algorithm, please
provide it ;-)

Martin

>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * means that "id"'s valu=
e is in use. In this case,
> > we play safe
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * and use "biggest_id + =
1" as the next value to
> > try.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * biggest_id is always >=
 smallest_bigger_id,
> > except in the
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * "perfectly ordered" ca=
se.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0curr_id =3D scan_devnam=
e(alias, prefix);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (curr_id =3D=3D id) =
{
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (id < INT_MAX)
> > --=20
> > 2.41.0
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

