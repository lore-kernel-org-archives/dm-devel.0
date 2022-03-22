Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC078C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 09:08:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-sUpSX2oYO2OWNzcPmruFZg-1; Tue, 22 Mar 2022 05:08:44 -0400
X-MC-Unique: sUpSX2oYO2OWNzcPmruFZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ED2F803CB8;
	Tue, 22 Mar 2022 09:08:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8AC02166B2D;
	Tue, 22 Mar 2022 09:08:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7CBFB1949762;
	Tue, 22 Mar 2022 09:08:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E2D31947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 09:08:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE8B94B8D43; Tue, 22 Mar 2022 09:08:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAAC6401E3A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 09:08:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCC911C068DF
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 09:08:40 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-jn5IS_zKPBa9EfP6wWJKMg-1; Tue, 22 Mar 2022 05:08:37 -0400
X-MC-Unique: jn5IS_zKPBa9EfP6wWJKMg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id DB6B5210E6;
 Tue, 22 Mar 2022 09:08:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A3DE9133B6;
 Tue, 22 Mar 2022 09:08:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 3QX4JROSOWIAAgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 22 Mar 2022 09:08:35 +0000
Message-ID: <7294c7d0fb76bae0bea9ddbd7545d48449f8eece.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 10:08:35 +0100
In-Reply-To: <CAPt1nt5ntVjCJYVF8B7+uvjoypoUSdGChc3G+jycRHte-V2BOA@mail.gmail.com>
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-8-mwilck@suse.com>
 <CAPt1nt5ntVjCJYVF8B7+uvjoypoUSdGChc3G+jycRHte-V2BOA@mail.gmail.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 07/11] multipathd: use remove_map_callback
 for delayed reconfigure
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-03-21 at 19:34 -0500, Benjamin Marzinski wrote:
> On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
> >=20
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > If multipathd needs to delay reconfigure() because it's waiting for
> > a map
> > creation uevent, it can happen that child() isn't woken up if the
> > map
> > being waited for is removed before the uevent arrives. Fix this by
> > unblocking reconfigure() with the remove_map_callback() function.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/main.c | 11 +++++++++++
> > =A01 file changed, 11 insertions(+)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index f3b8eb4..4721cd8 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -319,6 +319,17 @@ static bool unblock_reconfigure(void)
> > =A0=A0=A0=A0=A0=A0=A0 return was_delayed;
> > =A0}
> >=20
> > +/*
> > + * Make sure child() is woken up when a map is removed that
> > multipathd
> > + * is currently waiting for.
> > + * Overrides libmultipath's weak symbol by the same name
> > + */
> > +void remove_map_callback(struct multipath *mpp)
> > +{
> > +=A0=A0=A0=A0=A0=A0 if (mpp->wait_for_udev > 0)
>=20
> Is there a reason why you don't decrement wait_for_udev, and check
> need_to_delay_reconfig() like in ev_add_map()? I realize that it
> doesn't hurt anything to unblock the reconfigure even if there are
> other devices that need a delay. The main thread will notice that it
> still needs to delay. I'm just wondering why we do it differently
> here?

The main reason was to keep it simple. need_to_delay_reconfig() needs
to be passed a "vecs" pointer, and requires the vecs lock to be
held.=A0remove_map() is deep down in the call stack and has lots of
direct and indirect callers. It can be called with mpvec =3D=3D NULL and
(in theory) also with pathvec =3D=3D NULL, in which case it simply frees
the memory obtained by the map, without unlinking itself or its members
from any vectors.=A0In that case it *could* be called without the vecs
lock held (AFAICS, that's not the case today, but the function could be
used this way, e.g. in an error handling code path).

I thought it was easier and safer not to have to assert that every
current and future caller holds the vecs lock, in particular because
this is called indirectly from libmultipath, the function that grabs
the lock is usually high up in the call stack.

I had indeed pondered whether I should remove the call to
need_to_delay_reconfig() from the ev_add_map(), too. I decided against
it, because I realized that waking up child() for nothing is not
cheap,as child() needs to grab the vecs lock just for calling
need_to_delay_reconfig(). We should avoid this for the common case of=20
an uevent which we are waiting for.=A0
The remove_map() code path, OTOH, is a corner case (map being removed
while in the process of being added). We need to cover it, but we know
that this code path will be rarely executed in practice, and thus
unlikely to cause vecs lock contention.

I hope this makes sense.

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

