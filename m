Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E641C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  6 Dec 2021 10:16:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-AbTaFRoOMbylqPqtBC-Bsw-1; Mon, 06 Dec 2021 05:16:46 -0500
X-MC-Unique: AbTaFRoOMbylqPqtBC-Bsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E45B874989;
	Mon,  6 Dec 2021 10:16:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 092AD1E6;
	Mon,  6 Dec 2021 10:16:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC3334BB7C;
	Mon,  6 Dec 2021 10:16:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B6AGQEs019967 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Dec 2021 05:16:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DD27D2026D69; Mon,  6 Dec 2021 10:16:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8E052026D67
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 10:16:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 002D280122D
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 10:16:23 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-274-S93njpeyP-azZxE_nuyliA-1; Mon, 06 Dec 2021 05:16:19 -0500
X-MC-Unique: S93njpeyP-azZxE_nuyliA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CFC1212C7;
	Mon,  6 Dec 2021 10:16:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C7AD513AED;
	Mon,  6 Dec 2021 10:16:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id rxd+LvHirWG7PgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 06 Dec 2021 10:16:17 +0000
Message-ID: <81e43ecec7905c8ebcb5b5cab04a79d6f8c6cc9d.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Alasdair G Kergon
	<agk@redhat.com>
Date: Mon, 06 Dec 2021 11:16:17 +0100
In-Reply-To: <2fb2d579-c774-50d8-0459-3b9087acbf1f@gmail.com>
References: <20211201223518.3775-1-xose.vazquez@gmail.com>
	<20211201223518.3775-3-xose.vazquez@gmail.com>
	<b548b43ffccf9977ddb37b14046f03f897ec489c.camel@suse.com>
	<2fb2d579-c774-50d8-0459-3b9087acbf1f@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B6AGQEs019967
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH resend] multipath-tools: dm-devel is a closed
	ml
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

On Fri, 2021-12-03 at 19:17 +0100, Xose Vazquez Perez wrote:
> On 12/2/21 08:45, Martin Wilck wrote:
>=20
> > On Wed, 2021-12-01 at 23:35 +0100, Xose Vazquez Perez wrote:
> > > Just for subscribers
> > >=20
> > > Cc: Martin Wilck <mwilck@suse.com>
> > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > > =A0=A0README.md | 2 +-
> > > =A0=A01 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> >=20
> > According to Alasdair's statement,
> > (
> > https://listman.redhat.com/archives/dm-devel/2021-October/msg00037.html
> > ),
> > the list is "moderated for non-subscribers", not strictly
> > subscribers-
> > only.
> >=20
> > Moreover, the same README has "(subscribers-only)" just a few lines
> > above, in the "Mailing List" section.
>=20
> "moderated for non-subscribers" should only be for very sporadic
> posters.
> Contributors must be in the list.
> Sometimes some messages get lost because it's human-operated. And it
> also overloads ml admins with unnecessary extra work.
>=20

Fair enough. Still, "subscribers-only" is factually wrong.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

