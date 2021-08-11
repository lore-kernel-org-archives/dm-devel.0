Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A41C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:03:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9C0426104F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9C0426104F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-HwFdL-KwMnC8lqRE75C6bA-1; Wed, 11 Aug 2021 11:03:48 -0400
X-MC-Unique: HwFdL-KwMnC8lqRE75C6bA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 014C51936B60;
	Wed, 11 Aug 2021 15:03:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3A5E5C1B4;
	Wed, 11 Aug 2021 15:03:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F08404BB7C;
	Wed, 11 Aug 2021 15:03:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BF3dn6005176 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:03:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 810D010D18DC; Wed, 11 Aug 2021 15:03:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CD8E101B57A
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:03:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62C828D138D
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:03:35 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-426-Q9tpjzrfMxeuvsCeAq7oDg-1; Wed, 11 Aug 2021 11:03:27 -0400
X-MC-Unique: Q9tpjzrfMxeuvsCeAq7oDg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DADA221F9;
	Wed, 11 Aug 2021 15:03:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D32F513C17;
	Wed, 11 Aug 2021 15:03:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id Q5ueMb3mE2F+SwAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:03:25 +0000
Message-ID: <be0163a73b8a4f32d56391cf1075e11af2993ca6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 11 Aug 2021 17:03:25 +0200
In-Reply-To: <20210727045403.GJ3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-3-mwilck@suse.com>
	<20210727045403.GJ3087@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BF3dn6005176
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/9] libmultipath: strbuf: simple api for
 growing string buffers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mo, 2021-07-26 at 23:54 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 15, 2021 at 12:52:16PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Add an API for string buffers that grow in size as text is added.
> > This API will be useful in several places of the multipath-tools
> > code
> > base. Add unit tests for these helpers, too.
> >=20
>=20
> This looks good. I have a couple of nitpicks, but none of them are
> actually bugs, so if you prefer what you have, you can ignore them.
>=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/Makefile |=A0=A0 2 +-
> > =A0libmultipath/strbuf.c | 207 +++++++++++++++++++++
> > =A0libmultipath/strbuf.h | 168 +++++++++++++++++
> > =A0tests/Makefile=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 3 +-
> > =A0tests/strbuf.c=A0=A0=A0=A0=A0=A0=A0 | 412
> > ++++++++++++++++++++++++++++++++++++++++++
> > =A05 files changed, 790 insertions(+), 2 deletions(-)
> > =A0create mode 100644 libmultipath/strbuf.c
> > =A0create mode 100644 libmultipath/strbuf.h
> > =A0create mode 100644 tests/strbuf.c
> >=20
> > diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> > index e7254f3..7f3921c 100644
> > --- a/libmultipath/Makefile
> > +++ b/libmultipath/Makefile
> > @@ -53,7 +53,7 @@ OBJS =3D memory.o parser.o vector.o devmapper.o
> > callout.o \
> > =A0=A0=A0=A0=A0=A0=A0=A0log.o configure.o structs_vec.o sysfs.o prio.o =
checkers.o \
> > =A0=A0=A0=A0=A0=A0=A0=A0lock.o file.o wwids.o prioritizers/alua_rtpg.o =
prkey.o \
> > =A0=A0=A0=A0=A0=A0=A0=A0io_err_stat.o dm-generic.o generic.o foreign.o =
nvme-lib.o \
> > -=A0=A0=A0=A0=A0=A0=A0libsg.o valid.o
> > +=A0=A0=A0=A0=A0=A0=A0libsg.o valid.o strbuf.o
> > =A0
> > =A0all:=A0=A0=A0$(DEVLIB)
> > =A0
> > diff --git a/libmultipath/strbuf.c b/libmultipath/strbuf.c
> > new file mode 100644
> > index 0000000..8422a50
> > --- /dev/null
> > +++ b/libmultipath/strbuf.c

> > +
> > +static int expand_strbuf(struct strbuf *buf, int addsz)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0size_t add;
> > +=A0=A0=A0=A0=A0=A0=A0char *tmp;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0assert(strbuf_is_sane(buf));
> > +=A0=A0=A0=A0=A0=A0=A0if (addsz < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > +=A0=A0=A0=A0=A0=A0=A0if (buf->size - buf->offs >=3D (size_t)addsz + 1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > +
>=20
> With this add calculation, if you need exactly (x) BUF_CHUNKS worth
> of
> space, you will add (x + 1) BUF_CHUNKS worth of space.=A0 If you
> instead
> use
>=20
> add =3D ((addsz - (buf->size - buf->offs)) / BUF_CHUNK + 1)
>=20
> you will avoid allocating the extra BUF_CHUNK.

You are right, thanks. I was erring on the safe side, but still erring.

>=20
> > +=A0=A0=A0=A0=A0=A0=A0add =3D ((addsz + 1 - (buf->size - buf->offs)) / =
BUF_CHUNK +
> > 1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* BUF_CHUNK;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (buf->size >=3D SIZE_MAX - add) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0add =3D SIZE_MAX - buf->s=
ize;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (add < (size_t)addsz +=
 1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -EOVERFLOW;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0tmp =3D realloc(buf->buf, buf->size + add);
> > +=A0=A0=A0=A0=A0=A0=A0if (!tmp)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ENOMEM;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0buf->buf =3D tmp;
> > +=A0=A0=A0=A0=A0=A0=A0buf->size +=3D add;
> > +=A0=A0=A0=A0=A0=A0=A0buf->buf[buf->offs] =3D '\0';
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > +int __append_strbuf_str(struct strbuf *buf, const char *str, int
> > slen)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if ((ret =3D expand_strbuf(buf, slen)) < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > +
>=20
> This is correct, but I think it would be clearer if you calculated
> buf->offs like you do in fill_strbufi():
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0memcpy(buf->buf + buf->offs, str, slen);
> =A0=A0=A0=A0=A0=A0=A0=A0buf->offs +=3D slen;

Ok.

> > +=A0=A0=A0=A0=A0=A0=A0buf->offs =3D (char *)mempcpy(buf->buf + buf->off=
s, str,
> > slen)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0- buf->buf;
> > +=A0=A0=A0=A0=A0=A0=A0buf->buf[buf->offs] =3D '\0';
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return slen;
> > +}
> > +

> > +
> > +int append_strbuf_quoted(struct strbuf *buff, const char *ptr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char *quoted, *q;
> > +=A0=A0=A0=A0=A0=A0=A0const char *p;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned n_quotes, i;
> > +=A0=A0=A0=A0=A0=A0=A0size_t qlen;
> > +=A0=A0=A0=A0=A0=A0=A0int ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!ptr)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0for (n_quotes =3D 0, p =3D strchr(ptr, '"'); p; p=
 =3D strchr(++p,
> > '"'))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0n_quotes++;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* leading + trailing quote, 1 extra quote for ev=
ery quote
> > in ptr */
> > +=A0=A0=A0=A0=A0=A0=A0qlen =3D strlen(ptr) + 2 + n_quotes;
> > +=A0=A0=A0=A0=A0=A0=A0if (qlen > INT_MAX)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ERANGE;
> > +=A0=A0=A0=A0=A0=A0=A0if ((ret =3D expand_strbuf(buff, qlen)) < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0quoted =3D &(buff->buf[buff->offs]);
> > +=A0=A0=A0=A0=A0=A0=A0*quoted++ =3D '"';
> > +=A0=A0=A0=A0=A0=A0=A0for (p =3D ptr, q =3D quoted, i =3D 0; i < n_quot=
es; i++) {
>=20
> "qlen - 2 - (q - quoted)" is likely more space then you need here,
> although it doesn't matter, since you already know that you will find
> a
> quote before the end of the string.

qlen - 2 - (q - quoted) is the available space in the destination
buffer, (2 because I must append another quote after processing).

>  I get that it matches the
> calculation after the loop. but even that one is confusing. I would
> prefer that you either did something like
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0size_t len =3D strlen(ptr);
>=20
> ...
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0char *q1 =3D memccpy(q, p=
, '"', len - (p - ptr));
>=20
> or even more obviously correct
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0const char *p_end =3D ptr + strlen(ptr);
>=20
> ...
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0char *q1 =3D memccpy(q, p=
, '"', p_end - p);

Is it really more obvious? Your suggestion uses the pointers from the
source string, my code uses those from the destination string. The two
approaches are equivalent at a closer look. IMO it's more important to
make it obvious that we don't write beyond the end of the destination
than to show that we don't read beyond the end of the source (assuming
that write overflows do more harm than read overflows).

So in this specific case, I'd like to keep my version.

Thanks,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

