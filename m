Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945D6C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 06:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638252723;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yLRdlki/JYNIAbVR8yfggkxvBeY7K+FnkQc6RZV6tRc=;
	b=Jo7z6LCpw0NKGnKmah7W0rA8omScB6xJEC1xfODCm0Lhi+IbpiEKAJnMymCFAe7yyKUPYF
	YTgfV58aL4Yaa/qqFLy5L0ohO+EL/Onju13G9eQreKn1h/WoU5+ZDyhD99XjprBGQ+sTiV
	XnMxKfRIZB4k4C4mcRqWW5A/VH46aTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-2JfvzMlmNnyU8M5Vx9zPeA-1; Tue, 30 Nov 2021 01:11:59 -0500
X-MC-Unique: 2JfvzMlmNnyU8M5Vx9zPeA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB72E93922;
	Tue, 30 Nov 2021 06:11:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A509608BA;
	Tue, 30 Nov 2021 06:11:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C26DD4BB7C;
	Tue, 30 Nov 2021 06:11:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATGQUhj015577 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 11:26:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11B7C60854; Mon, 29 Nov 2021 16:26:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC21760622;
	Mon, 29 Nov 2021 16:26:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ATGQSdi020956; 
	Mon, 29 Nov 2021 10:26:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ATGQRqF020955;
	Mon, 29 Nov 2021 10:26:27 -0600
Date: Mon, 29 Nov 2021 10:26:27 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20211129162627.GB19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-31-mwilck@suse.com>
	<20211125010813.GU19591@octiron.msp.redhat.com>
	<84682701a0d34ffadc3356a843f8803e458cd8d2.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <84682701a0d34ffadc3356a843f8803e458cd8d2.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 30 Nov 2021 01:11:05 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 26, 2021 at 03:23:18PM +0100, Martin Wilck wrote:
> On Wed, 2021-11-24 at 19:08 -0600, Benjamin Marzinski wrote:
> > On Thu, Nov 18, 2021 at 11:58:22PM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > The previous patches added the state machine and the timeout
> > > handling,
> > > but there was no wakeup mechanism for the uxlsnr for cases where
> > > client connections were waiting for the vecs lock.
> > >=20
> > > This patch uses the previously introduced wakeup mechanism of
> > > struct mutex_lock for this purpose. Processes which unlock the
> > > "global" vecs lock send an event in an eventfd which the uxlsnr
> > > loop is polling for.
> > >=20
> > > As we are now woken up for servicing client handlers that don't
> > > wait for input but for the lock, we need to set up the pollfds
> > > differently, and iterate over all clients when handling events,
> > > not only over the ones that are receiving. The hangup handling
> > > is changed, too. We have to look at every client, even if one has
> > > hung up. Note that I don't take client_lock for the loop in
> > > uxsock_listen(), it's not necessary and will be removed elsewhere
> > > in a follow-up patch.
> > >=20
> > > With this in place, the lock need not be taken in execute_handler()
> > > any more. The uxlsnr only ever calls trylock() on the vecs lock,
> > > avoiding any waiting for other threads to finish.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =A0multipathd/uxlsnr.c | 200 ++++++++++++++++++++++++++++------------
> > > ----
> > > =A01 file changed, 129 insertions(+), 71 deletions(-)
> > >=20
> > > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > > index 87134d5..bf9780d 100644
> > > --- a/multipathd/uxlsnr.c
> > > +++ b/multipathd/uxlsnr.c
> >=20
> > Nitpick: This would look clearer to me if, instead of a switch
> > statement, it was just
> >=20
> > if (c->state !=3D CLT_RECV)
> > =A0=A0=A0=A0=A0=A0=A0 continue;
> >=20
> > polls[i].events =3D POLLIN;
> > polls[i].fd =3D c->fd;
> > ...
>=20
> That's true if you look at this patch in isolation. The reason I use a
> switch statement is that with patch 32, we get another case to treat
> here (CLT_SEND). At that point, the switch is at least on par wrt
> clarity, IMO.
>=20
> No?

Yep. I retrack my objection

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

>=20
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

