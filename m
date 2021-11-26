Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB91CC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 06:56:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-YA2PVY1PNS2GtaxG2Ok1rw-1; Mon, 29 Nov 2021 01:56:05 -0500
X-MC-Unique: YA2PVY1PNS2GtaxG2Ok1rw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC7431006AA2;
	Mon, 29 Nov 2021 06:56:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC1D2100AE22;
	Mon, 29 Nov 2021 06:55:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DE7AF1809C8A;
	Mon, 29 Nov 2021 06:55:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AQENLZN018820 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Nov 2021 09:23:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ABB4F404727A; Fri, 26 Nov 2021 14:23:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A808F4047272
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 14:23:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EAD1185A79C
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 14:23:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-381--l_-txPFPPe3xlKU_Omi0w-1; Fri, 26 Nov 2021 09:23:19 -0500
X-MC-Unique: -l_-txPFPPe3xlKU_Omi0w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73F3D212BE;
	Fri, 26 Nov 2021 14:23:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3759213C36;
	Fri, 26 Nov 2021 14:23:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id hnOfC9btoGGfTwAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 26 Nov 2021 14:23:18 +0000
Message-ID: <84682701a0d34ffadc3356a843f8803e458cd8d2.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Nov 2021 15:23:18 +0100
In-Reply-To: <20211125010813.GU19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-31-mwilck@suse.com>
	<20211125010813.GU19591@octiron.msp.redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AQENLZN018820
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Nov 2021 01:55:52 -0500
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 30/48] multipathd: uxlsnr: add idle
	notification
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-11-24 at 19:08 -0600, Benjamin Marzinski wrote:
> On Thu, Nov 18, 2021 at 11:58:22PM +0100, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > The previous patches added the state machine and the timeout
> > handling,
> > but there was no wakeup mechanism for the uxlsnr for cases where
> > client connections were waiting for the vecs lock.
> >=20
> > This patch uses the previously introduced wakeup mechanism of
> > struct mutex_lock for this purpose. Processes which unlock the
> > "global" vecs lock send an event in an eventfd which the uxlsnr
> > loop is polling for.
> >=20
> > As we are now woken up for servicing client handlers that don't
> > wait for input but for the lock, we need to set up the pollfds
> > differently, and iterate over all clients when handling events,
> > not only over the ones that are receiving. The hangup handling
> > is changed, too. We have to look at every client, even if one has
> > hung up. Note that I don't take client_lock for the loop in
> > uxsock_listen(), it's not necessary and will be removed elsewhere
> > in a follow-up patch.
> >=20
> > With this in place, the lock need not be taken in execute_handler()
> > any more. The uxlsnr only ever calls trylock() on the vecs lock,
> > avoiding any waiting for other threads to finish.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/uxlsnr.c | 200 ++++++++++++++++++++++++++++------------
> > ----
> > =A01 file changed, 129 insertions(+), 71 deletions(-)
> >=20
> > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > index 87134d5..bf9780d 100644
> > --- a/multipathd/uxlsnr.c
> > +++ b/multipathd/uxlsnr.c
>=20
> Nitpick: This would look clearer to me if, instead of a switch
> statement, it was just
>=20
> if (c->state !=3D CLT_RECV)
> =A0=A0=A0=A0=A0=A0=A0 continue;
>=20
> polls[i].events =3D POLLIN;
> polls[i].fd =3D c->fd;
> ...

That's true if you look at this patch in isolation. The reason I use a
switch statement is that with patch 32, we get another case to treat
here (CLT_SEND). At that point, the switch is at least on par wrt
clarity, IMO.

No?

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

