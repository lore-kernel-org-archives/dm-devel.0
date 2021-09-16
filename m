Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EA5C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 09:33:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CBA7461214
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 09:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CBA7461214
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-K2YgBgrbPa2BTaUDG6j3JA-1; Thu, 16 Sep 2021 05:33:51 -0400
X-MC-Unique: K2YgBgrbPa2BTaUDG6j3JA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89FB71842154;
	Thu, 16 Sep 2021 09:33:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBE5C5C1CF;
	Thu, 16 Sep 2021 09:33:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BA8314EA2A;
	Thu, 16 Sep 2021 09:33:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G9Xexq028882 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 05:33:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 01A8010145F7; Thu, 16 Sep 2021 09:33:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1E021010BB2
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 09:33:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0501091C7D9
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 09:33:36 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-238-xTxlr3yHNfS1dTZrC8YIQQ-1; Thu, 16 Sep 2021 05:33:32 -0400
X-MC-Unique: xTxlr3yHNfS1dTZrC8YIQQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CFC2722368;
	Thu, 16 Sep 2021 09:33:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8D9D413A23;
	Thu, 16 Sep 2021 09:33:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id fmFXIGoPQ2FlVwAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 09:33:30 +0000
Message-ID: <3729ec7dc41fe81c9db8d2c553c5ccc2cdb3d496.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Sep 2021 11:33:29 +0200
In-Reply-To: <20210916042253.GS3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-34-mwilck@suse.com>
	<20210916042253.GS3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.4
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18G9Xexq028882
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 33/35] multipathd: uxlsnr: use poll loop for
	sending, too
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

On Wed, 2021-09-15 at 23:22 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:41:18PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > send_packet() may busy-loop. By polling for POLLOUT, we can
> > avoid that, even if it's very unlikely in practice.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/uxlsnr.c | 39 ++++++++++++++++++++++++++++++++-------
> > =A01 file changed, 32 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > index 1bf4126..c18b2c4 100644
> > --- a/multipathd/uxlsnr.c
> > +++ b/multipathd/uxlsnr.c
> > @@ -588,15 +588,37 @@ static void handle_client(struct client *c,
> > struct vectors *vecs, short revents)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (get_strbuf_len(&c->=
reply) =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0default_reply(c, c->error);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *buf =3D get_s=
trbuf_str(&c->reply);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (c->cmd_len =3D=3D 0) =
{
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
ize_t len =3D get_strbuf_len(&c->reply) + 1;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (send_packet(c->fd, bu=
f) !=3D 0)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0d=
ead_client(c);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(4, "cli[%d]: Reply [%zu bytes]", c-
> > >fd,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0get_strbuf_len(&c->reply) + 1);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reset_strbuf(&c->reply);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (send(c->fd, &len, sizeof(len),
> > MSG_NOSIGNAL)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 !=3D sizeof(len)) {
>=20
> This assumes that failing to send the size is always an error. What
> about if we get EINTR/EAGAIN? Also, it seems pretty likely that we will
> either send all of the size or none of it, but I'm not sure we can
> guarantee that.=A0 send_packet() handled partitial writes of the length.
> Actually, mpath_recv_reply_len() which is still used by CLT_RECV still
> uses read_all(), instead of just polling again on partial reads.

That was intentional. I couldn't imagine that reading or writing 8
bytes would block (after all, we received POLLIN / POLLOUT for the
socket). Note the minimum socket buffer size that the kernel uses=A0is
larger than 2048 bytes.

https://elixir.bootlin.com/linux/latest/source/include/net/sock.h#L2339

When we send the size value, the send buffer is empty by definition
(even for interactive sessions, if the client uses libmpathcmd, it will
have fetched the response before sending new requests). Likewise for
receiving, the size will be received in one piece if the client uses
libmpathcmd.

I take it that some malicious or badly designed client could access the
socket bypassing libmpathcmd, sending or receiving the size byte-by-
byte, or in other strange patterns. But I think we are within our
rights to error out in such cases; it may actually be the right thing
to do that, as we don't really want to service clients doing tricks
like that. I will do some tests.

> Also, the fd is not set to be non-blocking. and if we fall through to
> CLT_SEND, we haven't checked for a POLLOUT revent, so technically, I
> believe the write could block here.

Right, we have to do that. Thanks for pointing it out. This also means
that polling in read_all() and send_packet() was pointless in the first
place ...

Thanks!
Martin

PS: I was wondering why we haven't been using SOCK_DGRAM for the
multipath socket in the first place. It would have avoided all this
hassle...



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

