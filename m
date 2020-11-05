Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35030C388F7
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 00:48:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8480B20867
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 00:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4SVR67M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8480B20867
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604537313;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DhRQJRArhllvrvZ+KCl83OMNnxbfAhA8gYCdFITh/bU=;
	b=M4SVR67MRe/9Pck2zQYrKedb6hSZE3WU2y55Rgz3iNK27LSN3wZWirPuQHVzlpagBjap78
	KL7nYbhO46Hv86OxDN0Kd+FDX1bVdhb8R19TcFAfDuHOdlS9dL/Db05EX3Vtxjv3OHtxfj
	tvcBh7v/dLbPrVr6sbg3gQYeo/IYaAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-vyWeS1urOWCrYEg-U_SS9Q-1; Wed, 04 Nov 2020 19:48:31 -0500
X-MC-Unique: vyWeS1urOWCrYEg-U_SS9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 969EF80B71A;
	Thu,  5 Nov 2020 00:48:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1643A5C3E0;
	Thu,  5 Nov 2020 00:48:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4107C183D021;
	Thu,  5 Nov 2020 00:48:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A50g2jE025963 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 19:42:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57C6310002A4; Thu,  5 Nov 2020 00:42:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A14810013C1;
	Thu,  5 Nov 2020 00:41:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A50fvXK028575; 
	Wed, 4 Nov 2020 18:41:57 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A50fvFf028574;
	Wed, 4 Nov 2020 18:41:57 -0600
Date: Wed, 4 Nov 2020 18:41:57 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201105004157.GF3384@octiron.msp.redhat.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
	<095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
	<20201102182711.GP3384@octiron.msp.redhat.com>
	<589710d08d286f358a97044834550b7f9db47e67.camel@suse.com>
	<20201104232724.GE3384@octiron.msp.redhat.com>
	<ce13eccf5ea69648ae6c814a330201bf521a9212.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <ce13eccf5ea69648ae6c814a330201bf521a9212.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
 DSO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 04, 2020 at 11:56:07PM +0000, Martin Wilck wrote:
> On Wed, 2020-11-04 at 17:27 -0600, Benjamin Marzinski wrote:
> > On Wed, Nov 04, 2020 at 10:39:39PM +0000, Martin Wilck wrote:
> > > On Mon, 2020-11-02 at 12:27 -0600, Benjamin Marzinski wrote:
> > > > On Fri, Oct 30, 2020 at 09:15:39PM +0000, Martin Wilck wrote:
> > > > > On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > > > > > The multipathd tur checker thread is designed to be able to
> > > > > > finish at
> > > > > > any time, even after the tur checker itself has been freed.
> > > > > > The
> > > > > > multipathd shutdown code makes sure all the checkers have
> > > > > > been
> > > > > > freed
> > > > > > before freeing the checker_class and calling dlclose() to
> > > > > > unload
> > > > > > the
> > > > > > DSO, but this doesn't guarantee that the checker threads have
> > > > > > finished.
> > > > > > If one hasn't, the DSO will get unloaded while the thread
> > > > > > still
> > > > > > running
> > > > > > code from it, causing a segfault. Unfortunately, it's not
> > > > > > possible to
> > > > > > be
> > > > > > sure that all tur checker threads have ended during shutdown,
> > > > > > without
> > > > > > making them joinable.
> > > > > >=20
> > > > > > However, since libmultipath will never be reinitialized after
> > > > > > it
> > > > > > has
> > > > > > been uninitialzed, not dlclosing the tur checker DSO once a
> > > > > > thread is
> > > > > > started has minimal cost (keeping the DSO code around until
> > > > > > the
> > > > > > program
> > > > > > exits, which usually happens right after freeing the
> > > > > > checkers).
> > > > >=20
> > > > > I'm not against this, but have you considered using an
> > > > > atomic  refcount
> > > > > for the DSO? With every tur thread starting, we could increase
> > > > > it,
> > > > > and
> > > > > decrease it in the cleanup function of the thread when it
> > > > > exits.
> > > > > That
> > > > > should be safe. If the refcount was positive when we exit, we
> > > > > could
> > > > > refrain from unloading the DSO.
> > > >=20
> > > > I tried exactly that, and I would still get crashes, even if it
> > > > put
> > > > the
> > > > code that decrements the atomic variable in a function that's not
> > > > part
> > > > of the DSO, and put a pthread_exit() before the final
> > > > pthread_cleanup_pop() that would decrement it in tur_thread, so
> > > > that
> > > > after the cleanup code is called the thread should never return
> > > > to
> > > > code
> > > > that is in the DSO. I had to add sleeps in code to force various
> > > > orderings, but I couldn't find any way that worked for all
> > > > possible
> > > > orderings.  I would love it if this worked, and you're free to
> > > > try,
> > > > but
> > > > I could not get this method to work.
> > >=20
> > > I've experimented a bit with a trivial test program, and I found
> > > that
> > > it worked stably if decrementing the refcount is really the last
> > > thing
> > > thread's cleanup function does. Could you provide some details
> > > about
> > > the sleeps that you'd put in that made this approach fail?
> >=20
> > I believe the situation that continued to crash was where the
> > tur_thread() exitted naturally (so it set running to 0), although I'm
> > not sure that this is necessary, or if it would still crash when
> > running
> > the cleanup function because of a cancel.  I put the cleanup function
> > to
> > decrement the count in libmultipath, so that it wasn't part of the
> > DSO,
> > and then I put a sleep(5) as the last line of the cleanup function,
> > and
> > a sleep(10) as the last line of cleanup_checkers(). I also had to set
> > running to 0 before starting the thread, and then take out the code
> > to
> > pause the thread if running was aleady 0, to make sure the thread
> > acted
> > like it was the one to set running to 0. Then the idea is to stop
> > multipathd while there is a thread in its sleep period, so that
> > multipathd sees that the counter is 0, and closes the dso, and then
> > the thread finishes before multipathd shuts the rest of the way
> > down.=20
>=20
> I guess the key is that the thread's entry point must also be in
> libmultipath (i.e. outside the DSO). In pseudo-code:
>=20
> entrypoint() {
>    refcount++;
>    pthread_cleanup_push(refcount--);
>    tur_thread(ct);
>    pthread_cleanup_pop(1);
> }
>=20
> This way the thread can't be in DSO code any more when refcount goes to
> zero.

Oh! I didn't think of solving it that way, but it makes sense. So, were
you planning on posting a patch?

-Ben


>=20
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

