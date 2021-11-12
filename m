Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9898C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:47:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5485660240
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5485660240
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-FGYt0kfXPz6qr9VnDbrORQ-1; Fri, 12 Nov 2021 16:47:33 -0500
X-MC-Unique: FGYt0kfXPz6qr9VnDbrORQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A7A615720;
	Fri, 12 Nov 2021 21:47:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD0FD60C17;
	Fri, 12 Nov 2021 21:47:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 44DF1181A1CF;
	Fri, 12 Nov 2021 21:47:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACLjjPj019435 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 16:45:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6990B404727D; Fri, 12 Nov 2021 21:45:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60BA2404727C
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:45:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 404B1185A7B2
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:45:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-28-OqKl7Sv8MUCXJt2I33z4Jw-1; Fri, 12 Nov 2021 16:45:43 -0500
X-MC-Unique: OqKl7Sv8MUCXJt2I33z4Jw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50B812170C;
	Fri, 12 Nov 2021 21:45:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12B4913C96;
	Fri, 12 Nov 2021 21:45:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id MMKOAobgjmFvawAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 12 Nov 2021 21:45:42 +0000
Message-ID: <843cdc61e0b49d9d3dbddc82d1175ea176fa8b9e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Nov 2021 22:45:41 +0100
In-Reply-To: <20210916000128.GX3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-13-mwilck@suse.com>
	<20210916000128.GX3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACLjjPj019435
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 12/35] multipathd: add and set cli_handlers
 in a single step
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

On Wed, 2021-09-15 at 19:01 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:40:57PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Modify set_handler_callback() such that a missing slot is created
> > if no matching slot is found. This way, we can skip the
> > initialization
> > with NULL handlers on startup.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/cli.c | 85 +++++++-------------------------------------
> > ----
> > =A0multipathd/cli.h |=A0 6 ++--
> > =A02 files changed, 15 insertions(+), 76 deletions(-)
> >=20
> > diff --git a/multipathd/cli.c b/multipathd/cli.c
> > index 5213813..7020d2b 100644
> > --- a/multipathd/cli.c
> > +++ b/multipathd/cli.c
> > @@ -100,26 +100,20 @@ find_handler (uint64_t fp)
> > =A0}
> > =A0
> > =A0int
> > -set_handler_callback (uint64_t fp, cli_handler *fn)
> > +__set_handler_callback (uint64_t fp, cli_handler *fn, bool locked)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0struct handler * h =3D find_handler(fp);
> > +=A0=A0=A0=A0=A0=A0=A0struct handler *h =3D find_handler(fp);
> > =A0
>=20
> Wouldn't it be a bug if we reset the handler? Is this really
> something
> we need to check for? Also, if add_handler() just returned a pointer
> to
> the handler, we wouldn't need to call fail_handler() immediately
> after
> creating it.

I'll fix this in an add-on patch in v2.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

