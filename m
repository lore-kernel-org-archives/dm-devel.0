Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58810C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:31:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC2FC60C3F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:31:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC2FC60C3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-ULepjgOXP--ioq69p2Cm6g-1; Wed, 11 Aug 2021 11:30:58 -0400
X-MC-Unique: ULepjgOXP--ioq69p2Cm6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 139BADF8A0;
	Wed, 11 Aug 2021 15:30:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7815A60BF1;
	Wed, 11 Aug 2021 15:30:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 492E44A7C8;
	Wed, 11 Aug 2021 15:30:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BFRF4H006820 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:27:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 57F431032A5; Wed, 11 Aug 2021 15:27:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 532331032A3
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:27:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5CF9806604
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:27:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-484--ii6XnKBP8a8G4U6jS7bLw-1; Wed, 11 Aug 2021 11:27:07 -0400
X-MC-Unique: -ii6XnKBP8a8G4U6jS7bLw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5190C1FED9;
	Wed, 11 Aug 2021 15:27:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1FCAF13C17;
	Wed, 11 Aug 2021 15:27:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 7eSKBUrsE2FHUQAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:27:06 +0000
Message-ID: <fb0961e9e14bdfc655561cc078069614fb7268a6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 11 Aug 2021 17:27:05 +0200
In-Reply-To: <20210728190343.GL3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-5-mwilck@suse.com>
	<20210728190343.GL3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BFRF4H006820
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/9] libmultipath: use strbuf in dict.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mi, 2021-07-28 at 14:03 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 15, 2021 at 12:52:18PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Temporary solution for snprint_keyword(), as print.c hasn't been
> > migrated yet.
>=20
> Mostly good. I have some minor issues with this.
>=20
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/dict.c=A0=A0=A0 | 313 ++++++++++++++++++---------------=
----
> > ----
> > =A0libmultipath/dict.h=A0=A0=A0 |=A0 19 +--
> > =A0libmultipath/parser.c=A0 |=A0 47 ++++---
> > =A0libmultipath/parser.h=A0 |=A0 15 +-
> > =A0libmultipath/propsel.c | 147 +++++++++----------
> > =A05 files changed, 253 insertions(+), 288 deletions(-)
> >=20
> > =A0
> > @@ -419,21 +381,18 @@ declare_ovr_snprint(selector, print_str)
> > =A0declare_mp_handler(selector, set_str)
> > =A0declare_mp_snprint(selector, print_str)
> > =A0
> > -static int snprint_uid_attrs(struct config *conf, char *buff, int
> > len,
> > +static int snprint_uid_attrs(struct config *conf, struct strbuf
> > *buff,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 const void *dummy)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0char *p =3D buff;
> > -=A0=A0=A0=A0=A0=A0=A0int n, j;
> > +=A0=A0=A0=A0=A0=A0=A0int j, ret;
> > =A0=A0=A0=A0=A0=A0=A0=A0const char *att;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(&conf->uid_attrs, att, j) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0n =3D snprintf(p, len, "%=
s%s", j =3D=3D 0 ? "" : " ",
> > att);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (n >=3D len)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn (p - buff) + n;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D n;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0len -=3D n;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D print_strbuf(buff=
, "%s%s", j =3D=3D 0 ? "" : " ",
> > att);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn ret;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> On success, this should return the amount of data written, instead of
> like the other snprint_* functions, not 0.
>=20
> > -=A0=A0=A0=A0=A0=A0=A0return p - buff;
> > +=A0=A0=A0=A0=A0=A0=A0return 0;

Right, thanks!


> > +snprint_ble_simple (struct config *conf, struct strbuf *buff,
> > const void *data)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0const struct blentry * ble =3D (const struct blen=
try *)data;
> > +=A0=A0=A0=A0=A0=A0=A0const struct blentry *ble =3D (const struct blent=
ry *)data;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0return snprintf(buff, len, "\"%s\"", ble->str);
>=20
> We should probably quote the regexes when printing them, so either
> append_strbuf_quoted() or, if you're worried about how that would
> handle
> interior quotes, print_strbud with "\"%s\"".
>=20
> > +=A0=A0=A0=A0=A0=A0=A0return print_str(buff, ble->str);

print_str() already calls append_strbuf_quoted(). Am I overlooking
something?

Thanks,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

