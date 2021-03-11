Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59BAC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:07:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 11ABA64F80
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11ABA64F80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615493270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wqTpM0bD9fgpEzJCRvp1H8vOEemikE6p612Ubfih4cw=;
	b=aGKknPJZZGx5uhj6cJieaTnkPygjeJKQ7KovQsilDiUD6F7exmLzRw3jdzobRU4VDPtSqq
	wEs8eTCECHUEtHkzsd7lG7N1llfpf08sO7qSKtaV499NIXNjBmkZKqjPSdUUwcr6+LoTrz
	3V4LzZ1qhS3VduDZ0sO1zSv9BoQ2jUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-VcwQ5dv9MkS4m3XwGiQ8kA-1; Thu, 11 Mar 2021 15:07:47 -0500
X-MC-Unique: VcwQ5dv9MkS4m3XwGiQ8kA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84DF6107ACCD;
	Thu, 11 Mar 2021 20:07:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E27B100AE4E;
	Thu, 11 Mar 2021 20:07:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDB244A717;
	Thu, 11 Mar 2021 20:07:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BK7fAs006616 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 15:07:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1DF3118B9D; Thu, 11 Mar 2021 20:07:41 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95DA3138EA;
	Thu, 11 Mar 2021 20:07:37 +0000 (UTC)
Date: Thu, 11 Mar 2021 15:07:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20210311200736.GA29043@redhat.com>
References: <alpine.LRH.2.02.2103111326050.28706@file01.intranet.prod.int.rdu2.redhat.com>
	<20210311184116.GB28637@redhat.com>
	<alpine.LRH.2.02.2103111438170.3860@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103111438170.3860@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 11 2021 at  2:43pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Thu, 11 Mar 2021, Mike Snitzer wrote:
> 
> > > Index: linux-2.6/include/uapi/linux/dm-ioctl.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2021-03-09 12:20:23.000000000 +0100
> > > +++ linux-2.6/include/uapi/linux/dm-ioctl.h	2021-03-11 18:42:14.000000000 +0100
> > > @@ -193,8 +193,15 @@ struct dm_name_list {
> > >  	__u32 next;		/* offset to the next record from
> > >  				   the _start_ of this */
> > >  	char name[0];
> > > +
> > > +	/* uint32_t event_nr; */
> > > +	/* uint32_t flags; */
> > > +	/* char uuid[0]; */
> > >  };
> > 
> > If extra padding is being leveraged here (from the __u32 next), why not
> > at least explicitly add the members and then pad out the balance of that
> > __u32?  I'm not liking the usage of phantom struct members.. e.g.
> > the games played with accessing them.
> > 
> > Mike
> 
> What exactly do you mean?
> 
> Do you want to create another structure that holds event_nr, flags and 
> uuid? Or something else?

Just not liking the comments you added in lieu of explicit struct
members.

Can't you remove __u32 next; and replace with named members of
appropriate size? Adding explicit padding to end to get you to 32bit
offset?  I'd need to look closer at the way the code is written, but I
just feel like this patch makes the code even more fiddley.

But I can let it go if you don't see a way forward to make it better..

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

