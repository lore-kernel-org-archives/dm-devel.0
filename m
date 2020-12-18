Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6581C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 16:34:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4710623B52
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 16:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4710623B52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608309246;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/wlOZXTZWNQ7WDn2SwPAUovMiirgP1BknQ/BIOEu+Tw=;
	b=DMQzteOMrZV71X+cX6X/YTRFbJymViKlfQJRLK+2UXLbgbswA1E4R2npHdZ8w8l7w6UXXN
	FjsAOE5IoDgdM1AvI6RnCCzxMhNYgMx1F2/ZyOJ5xWYl6PYbKJrOT/QMcBT6dtBhFQ5mMY
	sm2tgYqHB6N45LCQzXCGHrT1LeK9qpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-mBcunqH5MMGyjydM3AG_gw-1; Fri, 18 Dec 2020 11:34:04 -0500
X-MC-Unique: mBcunqH5MMGyjydM3AG_gw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B0E6CE642;
	Fri, 18 Dec 2020 16:33:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1741E5D9E4;
	Fri, 18 Dec 2020 16:33:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABA5750035;
	Fri, 18 Dec 2020 16:33:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIGWd1e022570 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 11:32:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1695019EF2; Fri, 18 Dec 2020 16:32:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F243A2C01E;
	Fri, 18 Dec 2020 16:32:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BIGWbVu007792; 
	Fri, 18 Dec 2020 10:32:37 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BIGWbMZ007791;
	Fri, 18 Dec 2020 10:32:37 -0600
Date: Fri, 18 Dec 2020 10:32:36 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20201218163236.GI3103@octiron.msp.redhat.com>
References: <20201217110018.3347-1-mwilck@suse.com>
	<20201217110018.3347-3-mwilck@suse.com>
	<20201218000311.GD3103@octiron.msp.redhat.com>
	<4e17c5f7ae1c911dc280458cda3ccb5578c0de9e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <4e17c5f7ae1c911dc280458cda3ccb5578c0de9e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/7] libmultipath: protect logarea with
	logq_lock
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 18, 2020 at 05:24:25PM +0100, Martin Wilck wrote:
> On Thu, 2020-12-17 at 18:03 -0600, Benjamin Marzinski wrote:
> > On Thu, Dec 17, 2020 at 12:00:13PM +0100, mwilck@suse.com wrote:
> > >  
> > > -void free_logarea (void)
> > > +static void free_logarea (void)
> > >  {
> > >  	FREE(la->start);
> > >  	FREE(la->buff);
> > 
> > I realize that the log area can only be freed by log_close(), which
> > is
> > called when mulitpathd exits, but it would be nice to have la set to
> > NULL it's freed, just to make it obvious that that there can't be
> > double-frees there. 
> 
> There's FREE(la) right after this, and FREE(x) sets the pointer to
> NULL. So it should be fine, or am I confused?
> 

Yep it's fine. It was me missing that.

-Ben

> > However, the code is clearly correct, so
> > 
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Thanks,
> Martin
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

