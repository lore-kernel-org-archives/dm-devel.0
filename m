Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F547C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 14:35:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B24661246
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 14:35:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1B24661246
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631802936;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nvc2m8sYQlgpY4iW0Cme37z1yUNwM1OK5xYENMUg3Hs=;
	b=hPwy4c5sDBWI9qrvIjgZPZW2qibQTTdMYmY1YV7xmvd6H20VKtqXhAo8sLQJugJliqqzWJ
	R4VPk6OG+zGw4na5gy3O7t1LnEVcvOkUcnclicbHsO2IjuhpcNZoUbzUaPOkX9DeADPO4A
	jJsAbuDIYWgB39dWmP+SUan/A4JEoa8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-LRPlTvrHOlGcnU3I6XIKwA-1; Thu, 16 Sep 2021 10:35:34 -0400
X-MC-Unique: LRPlTvrHOlGcnU3I6XIKwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBB6218D6A25;
	Thu, 16 Sep 2021 14:35:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86D345B826;
	Thu, 16 Sep 2021 14:35:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DD6241800FE4;
	Thu, 16 Sep 2021 14:35:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GEQPZN025159 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 10:26:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5620D4180; Thu, 16 Sep 2021 14:26:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3527B5B4BC;
	Thu, 16 Sep 2021 14:26:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18GEQJ3R011649; 
	Thu, 16 Sep 2021 09:26:19 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18GEQIWu011648;
	Thu, 16 Sep 2021 09:26:18 -0500
Date: Thu, 16 Sep 2021 09:26:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210916142618.GV3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-6-mwilck@suse.com>
	<20210915222023.GQ3087@octiron.msp.redhat.com>
	<cb505cd84add0d70896e589281203c887c13a58f.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <cb505cd84add0d70896e589281203c887c13a58f.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/35] libmultipath: improve cleanup of
 uevent queues on exit
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 16, 2021 at 09:10:57AM +0200, Martin Wilck wrote:
> On Wed, 2021-09-15 at 17:20 -0500, Benjamin Marzinski wrote:
> > On Fri, Sep 10, 2021 at 01:40:50PM +0200, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > uevents listed on merge_node must be cleaned up, too. uevents
> > > cancelled while being serviced and temporary queues, likewise.
> > > The global uevq must be cleaned out in the uevent listener thread,
> > > because it might have added events after the dispatcher thread
> > > had already finished.
> > >=20
> >=20
> > There's nothing wrong with this, but for the global list, wouldn't it
> > be
> > easier to just wait till after cleanup_child() calls
> > cleanup_threads(),
> > and then call cleanup_global_uevq(). That way you know nothing else
> > is
> > running.
>=20
> That would be possible. If I understand your proposal correctly, that
> would require calling cleanup_global_uevq() from cleanup_child(), i.e.
> from the main process. Currently uevq and the functions handling it are
> static and only visible in uevent.c.
>=20
> By taking the lock in cleanup_global_uevq() and calling it from the
> listener on cleanup, I can be sure that the dispatcher won't see any
> more uevents if it hasn't terminated yet, and that no no events will be
> added to the queue after cleanup. So I think with this patch I can also
> be certain that uevq is cleaned up for good, without a need to export
> the cleanup function, and without enforcing a certain order of thread
> shutdowns on exit. Do you disagree?

Yeah, that's why I said that there's nothing wrong with the patch. It
just seemed more self-evidently correct to do it after stopping all the
threads. But, regardless

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

>=20
> Thanks,
> Martin
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

