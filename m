Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA3CC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647963393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9S5vq+1EK7bavW01GMIIYrew6axS1EpFCaA2Tro1x0Y=;
	b=P6nCQbRtQqDUpCz8Zn+WsPp1EtaBJ4x7Ifi8lWRv7zREDSgPtlil1nCnO/fPvuAy+kzwQM
	OYqTltSPpO67Ba2Nv6qXItwqiSwN3RWS1NT7m/Ost8aRHBOv3uO7LciXc+DNuRnRpezqc8
	fNUiAP0uBHrHlq0xiIfMgoNuWg7DamU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-WuUskn2xNlaTkxSPLp9HUA-1; Tue, 22 Mar 2022 11:36:30 -0400
X-MC-Unique: WuUskn2xNlaTkxSPLp9HUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 500CD802803;
	Tue, 22 Mar 2022 15:36:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 372E02026985;
	Tue, 22 Mar 2022 15:36:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF7051940347;
	Tue, 22 Mar 2022 15:36:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3C891947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 15:36:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9DC4256F7F4; Tue, 22 Mar 2022 15:36:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 982DE56F7FC
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:36:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70B4A85178F
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:36:26 +0000 (UTC)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-T_h036dcM9iZRINKxs8iMA-1; Tue, 22 Mar 2022 11:36:25 -0400
X-MC-Unique: T_h036dcM9iZRINKxs8iMA-1
Received: by mail-lj1-f200.google.com with SMTP id
 v2-20020a2e9f42000000b00247e9c3f0e1so7581467ljk.1
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=OIPvPJcq9I6uYgJ0GKIrn1QV2pN24kmvR4uS9aEhl4o=;
 b=AkSsJ0CUxpskiaAQ+o7YVoLmgiQwfMHC0VZEI+VWl73NRyofRM/19Qwsduamrog6uw
 U8gVHTHxU4fTi+n8Zndb2Q5hpyNHmexQaW5wedBaNGJRzpMauZ65VyrhbShsHN++k5Jy
 7P8LLBVzoe240rHFItltLd0xjR6ObQN3Ir/+LtRJS7lwIUo+ehllWyC57Af4XxAjaTYY
 hfCg4a9sYcthehPKPaTxhYwCjfAejFVjKOy1ygRlxY2pLAgij8jFuB+c9AKn07HZ4wnh
 VGoo9rW3384pMwyBeFOoQD4WPVmFByyDOtM68MYhgyOvjCIOPScobEJ8SHt7XbTZaA2K
 Rigw==
X-Gm-Message-State: AOAM530p/s6gyThzTKl92U2xz76W7CUWNCyG7X4Jg7aI9UIebvmrnH8p
 LglHaOfreCWmIYJOekQZFoAiPeFmE5EMb2ximkhu5+L52v/RVjoTdtFyAwVUODy/oAVBaEeHfYR
 wDqc1PSCmlF0LjjGt8cXT6/TKrE1Uoz4=
X-Received: by 2002:a2e:a372:0:b0:249:7108:6778 with SMTP id
 i18-20020a2ea372000000b0024971086778mr14693317ljn.403.1647963383409; 
 Tue, 22 Mar 2022 08:36:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuXFReyTjeaUYPgqV/A9DTnI8W2FFuRfanP6pk6iqfIq2J0Rki/ep8WxmLRaHPn2UXfqJpKOdgGUGzvZMS7jg=
X-Received: by 2002:a2e:a372:0:b0:249:7108:6778 with SMTP id
 i18-20020a2ea372000000b0024971086778mr14693305ljn.403.1647963383188; Tue, 22
 Mar 2022 08:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-8-mwilck@suse.com>
 <CAPt1nt5ntVjCJYVF8B7+uvjoypoUSdGChc3G+jycRHte-V2BOA@mail.gmail.com>
 <7294c7d0fb76bae0bea9ddbd7545d48449f8eece.camel@suse.com>
In-Reply-To: <7294c7d0fb76bae0bea9ddbd7545d48449f8eece.camel@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 10:36:12 -0500
Message-ID: <CAPt1nt4p0bw6a1ARrxCOAV0azoysX3gydwX-Cgxd0kOnHqnRhg@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22, 2022 at 4:08 AM Martin Wilck <mwilck@suse.com> wrote:
>
> On Mon, 2022-03-21 at 19:34 -0500, Benjamin Marzinski wrote:
> > On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
> > >
> > > From: Martin Wilck <mwilck@suse.com>
> > >
> > > If multipathd needs to delay reconfigure() because it's waiting for
> > > a map
> > > creation uevent, it can happen that child() isn't woken up if the
> > > map
> > > being waited for is removed before the uevent arrives. Fix this by
> > > unblocking reconfigure() with the remove_map_callback() function.
> > >
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  multipathd/main.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index f3b8eb4..4721cd8 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -319,6 +319,17 @@ static bool unblock_reconfigure(void)
> > >         return was_delayed;
> > >  }
> > >
> > > +/*
> > > + * Make sure child() is woken up when a map is removed that
> > > multipathd
> > > + * is currently waiting for.
> > > + * Overrides libmultipath's weak symbol by the same name
> > > + */
> > > +void remove_map_callback(struct multipath *mpp)
> > > +{
> > > +       if (mpp->wait_for_udev > 0)
> >
> > Is there a reason why you don't decrement wait_for_udev, and check
> > need_to_delay_reconfig() like in ev_add_map()? I realize that it
> > doesn't hurt anything to unblock the reconfigure even if there are
> > other devices that need a delay. The main thread will notice that it
> > still needs to delay. I'm just wondering why we do it differently
> > here?
>
> The main reason was to keep it simple. need_to_delay_reconfig() needs
> to be passed a "vecs" pointer, and requires the vecs lock to be
> held. remove_map() is deep down in the call stack and has lots of
> direct and indirect callers. It can be called with mpvec == NULL and
> (in theory) also with pathvec == NULL, in which case it simply frees
> the memory obtained by the map, without unlinking itself or its members
> from any vectors. In that case it *could* be called without the vecs
> lock held (AFAICS, that's not the case today, but the function could be
> used this way, e.g. in an error handling code path).
>
> I thought it was easier and safer not to have to assert that every
> current and future caller holds the vecs lock, in particular because
> this is called indirectly from libmultipath, the function that grabs
> the lock is usually high up in the call stack.
>
> I had indeed pondered whether I should remove the call to
> need_to_delay_reconfig() from the ev_add_map(), too. I decided against
> it, because I realized that waking up child() for nothing is not
> cheap,as child() needs to grab the vecs lock just for calling
> need_to_delay_reconfig(). We should avoid this for the common case of
> an uevent which we are waiting for.
> The remove_map() code path, OTOH, is a corner case (map being removed
> while in the process of being added). We need to cover it, but we know
> that this code path will be rarely executed in practice, and thus
> unlikely to cause vecs lock contention.
>
> I hope this makes sense.

Yeah. Whenever a map is getting removed from vecs->mpvec, the vecs
lock better be held. But since a map could be getting removed from
some other vector of maps, we can't use (mpvec != NULL) to be sure
that the vecs lock must be held.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

>
> Regards
> Martin
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

