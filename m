Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A16C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 20:33:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A50E2068D
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 20:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODHXexjQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A50E2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606250035;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SXzUAEuxZHWxgIRKWwbtmC6zSBDZaRIGw0NIsmYIp3M=;
	b=ODHXexjQNycIHErGQAnXai/Xl/f41bw6gI8mXh1BuhEUXx79BeftYbg2IHmdQTyq3Avw0P
	54yzLC02ieUL9X6s1UE9BLvX2SBQmQPOyLQ4vj8SJSHlCOgNHlJIuYLFi/GPz6TsmvBUH0
	0VUSySUZK1E7Z5fHeLY0rBB18So0ngk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-bjCRWPctMom4mtw_9HGSAA-1; Tue, 24 Nov 2020 15:33:52 -0500
X-MC-Unique: bjCRWPctMom4mtw_9HGSAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83313805BE6;
	Tue, 24 Nov 2020 20:33:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 553B35D6AB;
	Tue, 24 Nov 2020 20:33:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAAF41809CA1;
	Tue, 24 Nov 2020 20:33:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOKXjow016244 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 15:33:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6E7B660877; Tue, 24 Nov 2020 20:33:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D7160873;
	Tue, 24 Nov 2020 20:33:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0AOKXeUq030821; 
	Tue, 24 Nov 2020 14:33:40 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0AOKXe1p030820;
	Tue, 24 Nov 2020 14:33:40 -0600
Date: Tue, 24 Nov 2020 14:33:39 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20201124203339.GD3103@octiron.msp.redhat.com>
References: <20201105114952.1059-1-mwilck@suse.com>
	<20201106004115.GH3384@octiron.msp.redhat.com>
	<39c3227eb6fc8c9edb0f8927b180005e5b4ff445.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <39c3227eb6fc8c9edb0f8927b180005e5b4ff445.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [RFC PATCH] libmultipath: prevent DSO unloading with
 astray checker threads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 06, 2020 at 06:32:16PM +0100, Martin Wilck wrote:
> On Thu, 2020-11-05 at 18:41 -0600, Benjamin Marzinski wrote:
> > 
> > I can't make this segfault. So that looks good, but it does need
> > libmultipath.version updated to include checker_thread_entry()
> 
> Great news, thanks. Well the library version stuff hasn't been
> committed yet anyway, this was against Christophe's current base.

Actually, I ran into a different segfault with this patch.

While the tur checker's libcheck_check() function is run under locking,
so the device cannot be removed, The thread it creates is not. This
means that it is possible for the device to get removed after
libcheck_check() runs, but before checker_thread_entry() runs. In this
case, when checker_thread_entry() is finally run, the passed in checker
structure would already have been freed, causing a segfault.  I have
been able to easily reproduce this in the case where multipath device
creation failed in the kernel.

I'm pretty sure that the checker class needs its ref count increased
before the thread is created, and the thread inself must only access the
context, which should include a pointer to the class.

-Ben

> 
> @Christophe, any chance to move forward with the merge?
> (then we can go ahead with this patch later, too...)
> 
> Martin
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

