Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6551CC00A89
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 18:27:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7D052222B
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 18:27:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7xqCkYy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7D052222B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604341655;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZvY91rLr6aD6yfk6MDl9kaeKJEuy1lK+wdk/GdpW7BU=;
	b=R7xqCkYyOE68hejuQQFS79SJFip8JAFEFCLhYfGp0GTplVUvxSZY0ruAxv8ue8dcROVPV1
	WnpaHQWUECqDrITIW1/HARwG8Bb+MPVHdGDsWtZX4WmrX/eSaNbH7uLnhy5T6fUKDY/m3C
	QGxmK1wGDwy5fzpq00F3hWMJGM3XPmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-kjXEFkfGNmCEXUrpuZbZaQ-1; Mon, 02 Nov 2020 13:27:33 -0500
X-MC-Unique: kjXEFkfGNmCEXUrpuZbZaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4324809DCF;
	Mon,  2 Nov 2020 18:27:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A08E4672C0;
	Mon,  2 Nov 2020 18:27:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7E7FB8C7B0;
	Mon,  2 Nov 2020 18:27:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A2IRLOi025401 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 2 Nov 2020 13:27:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 92E28109F1BB; Mon,  2 Nov 2020 18:27:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E7CD1002C16;
	Mon,  2 Nov 2020 18:27:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A2IRCMR011043; 
	Mon, 2 Nov 2020 12:27:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A2IRBY5011042;
	Mon, 2 Nov 2020 12:27:11 -0600
Date: Mon, 2 Nov 2020 12:27:11 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201102182711.GP3384@octiron.msp.redhat.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
	<095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 30, 2020 at 09:15:39PM +0000, Martin Wilck wrote:
> On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > The multipathd tur checker thread is designed to be able to finish at
> > any time, even after the tur checker itself has been freed. The
> > multipathd shutdown code makes sure all the checkers have been freed
> > before freeing the checker_class and calling dlclose() to unload the
> > DSO, but this doesn't guarantee that the checker threads have
> > finished.
> > If one hasn't, the DSO will get unloaded while the thread still
> > running
> > code from it, causing a segfault. Unfortunately, it's not possible to
> > be
> > sure that all tur checker threads have ended during shutdown, without
> > making them joinable.
> > 
> > However, since libmultipath will never be reinitialized after it has
> > been uninitialzed, not dlclosing the tur checker DSO once a thread is
> > started has minimal cost (keeping the DSO code around until the
> > program
> > exits, which usually happens right after freeing the checkers).
> 
> I'm not against this, but have you considered using an atomic  refcount
> for the DSO? With every tur thread starting, we could increase it, and
> decrease it in the cleanup function of the thread when it exits. That
> should be safe. If the refcount was positive when we exit, we could
> refrain from unloading the DSO.

I tried exactly that, and I would still get crashes, even if it put the
code that decrements the atomic variable in a function that's not part
of the DSO, and put a pthread_exit() before the final
pthread_cleanup_pop() that would decrement it in tur_thread, so that
after the cleanup code is called the thread should never return to code
that is in the DSO. I had to add sleeps in code to force various
orderings, but I couldn't find any way that worked for all possible
orderings.  I would love it if this worked, and you're free to try, but
I could not get this method to work.

-Ben
 
> Regards,
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

