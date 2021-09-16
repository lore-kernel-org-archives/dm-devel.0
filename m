Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B03DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 15:30:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5C1A61246
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 15:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E5C1A61246
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631806228;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U4QIK3gSULfMZT716J8dvNps2rlI32MFS1hiSVfZbuo=;
	b=Pe/J9/UXbe6flzPIX+CstLPrjv6qzHgj/K4YLNWnoecOWcspHdjW3UQoZMww31qaLIGvUc
	5LS5LDU6xT7anBGVmkuvC7bNyIxDFKMwBEx5JIxds4nLbQNvq90c+SI/jkRUhfHi9k/IPI
	Hn83QRV6dKP454UATAbGlKEbccUq4Io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-Qk3ovgjgMKSiwMN24112cQ-1; Thu, 16 Sep 2021 11:30:26 -0400
X-MC-Unique: Qk3ovgjgMKSiwMN24112cQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 943D810144F3;
	Thu, 16 Sep 2021 15:30:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5374B83C0D;
	Thu, 16 Sep 2021 15:30:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC4B61800FE4;
	Thu, 16 Sep 2021 15:30:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GFQgHv030449 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 11:26:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C19131045E0A; Thu, 16 Sep 2021 15:26:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA6F81017CE8;
	Thu, 16 Sep 2021 15:26:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18GFQNmU012118; 
	Thu, 16 Sep 2021 10:26:23 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18GFQMdZ012117;
	Thu, 16 Sep 2021 10:26:22 -0500
Date: Thu, 16 Sep 2021 10:26:21 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210916152621.GZ3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-34-mwilck@suse.com>
	<20210916042253.GS3087@octiron.msp.redhat.com>
	<3729ec7dc41fe81c9db8d2c553c5ccc2cdb3d496.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <3729ec7dc41fe81c9db8d2c553c5ccc2cdb3d496.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 16, 2021 at 11:33:29AM +0200, Martin Wilck wrote:
> On Wed, 2021-09-15 at 23:22 -0500, Benjamin Marzinski wrote:
> > On Fri, Sep 10, 2021 at 01:41:18PM +0200, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > send_packet() may busy-loop. By polling for POLLOUT, we can
> > > avoid that, even if it's very unlikely in practice.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =A0multipathd/uxlsnr.c | 39 ++++++++++++++++++++++++++++++++-------
> > > =A01 file changed, 32 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > > index 1bf4126..c18b2c4 100644
> > > --- a/multipathd/uxlsnr.c
> > > +++ b/multipathd/uxlsnr.c
> > > @@ -588,15 +588,37 @@ static void handle_client(struct client *c,
> > > struct vectors *vecs, short revents)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (get_strbuf_len(&c=
->reply) =3D=3D 0)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0default_reply(c, c->error);
> > > =A0
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *buf =3D get=
_strbuf_str(&c->reply);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (c->cmd_len =3D=3D 0=
) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0size_t len =3D get_strbuf_len(&c->reply) + 1;
> > > =A0
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (send_packet(c->fd, =
buf) !=3D 0)
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0dead_client(c);
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(4, "cli[%d]: Reply [%zu bytes]", c-
> > > >fd,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0get_strbuf_len(&c->reply) + 1);
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reset_strbuf(&c->reply)=
;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (send(c->fd, &len, sizeof(len),
> > > MSG_NOSIGNAL)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 !=3D sizeof(len)) {
> >=20
> > This assumes that failing to send the size is always an error. What
> > about if we get EINTR/EAGAIN? Also, it seems pretty likely that we will
> > either send all of the size or none of it, but I'm not sure we can
> > guarantee that.=A0 send_packet() handled partitial writes of the length=
.
> > Actually, mpath_recv_reply_len() which is still used by CLT_RECV still
> > uses read_all(), instead of just polling again on partial reads.
>=20
> That was intentional. I couldn't imagine that reading or writing 8
> bytes would block (after all, we received POLLIN / POLLOUT for the
> socket). Note the minimum socket buffer size that the kernel uses=A0is
> larger than 2048 bytes.
>=20
> https://elixir.bootlin.com/linux/latest/source/include/net/sock.h#L2339
>=20
> When we send the size value, the send buffer is empty by definition
> (even for interactive sessions, if the client uses libmpathcmd, it will
> have fetched the response before sending new requests). Likewise for
> receiving, the size will be received in one piece if the client uses
> libmpathcmd.
>=20
> I take it that some malicious or badly designed client could access the
> socket bypassing libmpathcmd, sending or receiving the size byte-by-
> byte, or in other strange patterns. But I think we are within our
> rights to error out in such cases; it may actually be the right thing
> to do that, as we don't really want to service clients doing tricks
> like that. I will do some tests.

In this case, calling mpath_recv_reply_len() is probably overkill.
=20
> > Also, the fd is not set to be non-blocking. and if we fall through to
> > CLT_SEND, we haven't checked for a POLLOUT revent, so technically, I
> > believe the write could block here.
>=20
> Right, we have to do that. Thanks for pointing it out. This also means
> that polling in read_all() and send_packet() was pointless in the first
> place ...
>=20
> Thanks!
> Martin
>=20
> PS: I was wondering why we haven't been using SOCK_DGRAM for the
> multipath socket in the first place. It would have avoided all this
> hassle...

That design decision predates me working on the code.

-Ben

>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

