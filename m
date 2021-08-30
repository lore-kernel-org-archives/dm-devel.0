Return-Path: <SRS0=4ZGW=NV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB95C432BE
	for <dm-devel@archiver.kernel.org>; Mon, 30 Aug 2021 21:28:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B98CC60F3A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Aug 2021 21:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B98CC60F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630358904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nRwYv/DPgq1mEwKXdrMF2RF8bj33pD+udPu425110xk=;
	b=MKu+DtJVmjabpV4XKx/3hoUB1sEdefId5Bpue2HkAM4jBjlCthmXWuUYEbhtHRwKuvxHN7
	3d1NFs2o3OwNQODfTq1UOemppCCaxkeJsuoGHq2URnUyx6v+ATpKAYUfBO0C6/EggXdy76
	PnJ7WTOmou+HnyhoPGKTTi8Lg8+vJ5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-G2AWpG6mOyKdmvyexF1mdg-1; Mon, 30 Aug 2021 17:28:23 -0400
X-MC-Unique: G2AWpG6mOyKdmvyexF1mdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B07431008061;
	Mon, 30 Aug 2021 21:28:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93CE910016FF;
	Mon, 30 Aug 2021 21:28:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3C6894A7C9;
	Mon, 30 Aug 2021 21:28:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17ULSHLs008859 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Aug 2021 17:28:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2F172226E2; Mon, 30 Aug 2021 21:28:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CF5D60939;
	Mon, 30 Aug 2021 21:28:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 17ULSBaa022803; 
	Mon, 30 Aug 2021 16:28:11 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 17ULSBuJ022802;
	Mon, 30 Aug 2021 16:28:11 -0500
Date: Mon, 30 Aug 2021 16:28:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210830212810.GB3087@octiron.msp.redhat.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
	<1627595165-19980-4-git-send-email-bmarzins@redhat.com>
	<a6c0dff1b97512eb4150969894de22c3d2d0efc8.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <a6c0dff1b97512eb4150969894de22c3d2d0efc8.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipath: print warning if multipathd
 is not running.
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

On Thu, Aug 12, 2021 at 10:23:09AM +0000, Martin Wilck wrote:
> On Do, 2021-07-29 at 16:46 -0500, Benjamin Marzinski wrote:
> > If multipath notices that multipath devices exist or were created,
> > and
> > multipathd is not running, it now prints a warning message, so users
> > are
> > notified of the issue.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> I'm not sure about this. Are there zero valid use cases for using
> multipath without multipathd?

There certainly are. That's why I tried to limit the warning to only
cases where the user was creating, reloading, or listing devices and
found/created some. In testing, sure, you might want multipathd
disabled, but in general, if you have multipath devices, you want
multipathd running.  If you have it temporarily disabled for some
reason, I don't see much harm in having multipath remind you of that.

> On production systems, I agree,
> multipathd should always be running. Personally wouldn't want to see
> this warning every time I run "multipath" while multipathd is
> (temporarily) disabled. Have you got user requests for this feature?

Well, Support has requested this.  Apparently they have repeatedly seen
cases where people don't have any multipath devices present, because
multipathd is not running.  They run multipath, the devices appear, and
they move on, unaware that multipathd isn't running for whatever
reason.
 
> In particular, I dislike the idea of putting this code into
> libmultipath. I would love to get rid of the "is_daemon" logic some
> day. If at all, the detection of the situation and the warning should
> be implemented in multipath, IMO.

Sure. I can rework this to keep the logic inside multipath,

> The message should be prefixed with the word "Warning: " to make sure
> the admin understands that he's supposed to take action.

Makes sense.

-Ben

> Regards,
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

