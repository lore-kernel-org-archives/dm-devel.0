Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2CDC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 19:43:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13BA764F79
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 19:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13BA764F79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615491820;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pkoQRGHKM6vy8RFYZsF+AB4KnXJ35WARliJuE1+Wxg0=;
	b=i9LRSfeZKKEnVT9vXsgcA58kuN+ybl/3jrjP35K2z9rj2wtXh7PkAzNFW3ah94zHMkGGY1
	mxIZ62pt/GxGGQj6YJs7w+jdTlHX/T7PNW7+qskaaWCa1N+M4fl32Rwdi5VxDPhqT5l3K0
	15t6vk8UZPPsBIjvfRrPQW7YEus4v/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-JeAunp1sMQGfHUSMB79FHg-1; Thu, 11 Mar 2021 14:43:38 -0500
X-MC-Unique: JeAunp1sMQGfHUSMB79FHg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11357100C61A;
	Thu, 11 Mar 2021 19:43:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 806A45D6D7;
	Thu, 11 Mar 2021 19:43:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07E074EA48;
	Thu, 11 Mar 2021 19:43:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BJhUJq005177 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 14:43:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2EF1C1037EBB; Thu, 11 Mar 2021 19:43:30 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BA6C1000358;
	Thu, 11 Mar 2021 19:43:23 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 12BJhNAw004207; Thu, 11 Mar 2021 14:43:23 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 12BJhNeC004203; Thu, 11 Mar 2021 14:43:23 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 11 Mar 2021 14:43:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20210311184116.GB28637@redhat.com>
Message-ID: <alpine.LRH.2.02.2103111438170.3860@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2103111326050.28706@file01.intranet.prod.int.rdu2.redhat.com>
	<20210311184116.GB28637@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-ioctl: return UUID in
	DM_LIST_DEVICES_CMD result
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 11 Mar 2021, Mike Snitzer wrote:

> > Index: linux-2.6/include/uapi/linux/dm-ioctl.h
> > ===================================================================
> > --- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2021-03-09 12:20:23.000000000 +0100
> > +++ linux-2.6/include/uapi/linux/dm-ioctl.h	2021-03-11 18:42:14.000000000 +0100
> > @@ -193,8 +193,15 @@ struct dm_name_list {
> >  	__u32 next;		/* offset to the next record from
> >  				   the _start_ of this */
> >  	char name[0];
> > +
> > +	/* uint32_t event_nr; */
> > +	/* uint32_t flags; */
> > +	/* char uuid[0]; */
> >  };
> 
> If extra padding is being leveraged here (from the __u32 next), why not
> at least explicitly add the members and then pad out the balance of that
> __u32?  I'm not liking the usage of phantom struct members.. e.g.
> the games played with accessing them.
> 
> Mike

What exactly do you mean?

Do you want to create another structure that holds event_nr, flags and 
uuid? Or something else?

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

