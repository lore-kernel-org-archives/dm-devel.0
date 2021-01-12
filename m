Return-Path: <SRS0=y4zT=GP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5600EC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 01:44:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF93D22D6D
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 01:44:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF93D22D6D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610415895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B7fT+QTIrC2cdzFoPaR6r7hvCqzEss0oRxSUOFETj7I=;
	b=jRFp+UE+t0a+lnY3IIQlvzxrX0KsmUakw/FQlKMH+WpHrKw0CBTnbs0RmIu+LTjjEdUyGV
	gBevdK3V2ZsfJhXHKiVxfA3cJNbYsJzWJ5lzsyXeg3sf2HhV7FtNQlLvK95BtjrxIg0+aH
	/wC6eO7fS9cY+5CD39koktecmTePWfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-kabgaTDkMPC0avbn1vDjXQ-1; Mon, 11 Jan 2021 20:44:53 -0500
X-MC-Unique: kabgaTDkMPC0avbn1vDjXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 915421005D44;
	Tue, 12 Jan 2021 01:44:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D17F462690;
	Tue, 12 Jan 2021 01:44:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96E48180954D;
	Tue, 12 Jan 2021 01:44:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10C1igTl018396 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 11 Jan 2021 20:44:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07F7676E3C; Tue, 12 Jan 2021 01:44:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ECBC60C5B;
	Tue, 12 Jan 2021 01:44:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10C1ibLJ000979; 
	Mon, 11 Jan 2021 19:44:37 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10C1iamn000978;
	Mon, 11 Jan 2021 19:44:36 -0600
Date: Mon, 11 Jan 2021 19:44:36 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210112014436.GX3103@octiron.msp.redhat.com>
References: <20210108170044.7883-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210108170044.7883-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3] multipath-tools: cleanup uevent
	generation on startup
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

On Fri, Jan 08, 2021 at 06:00:41PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

For the set

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> This series undoes several changes I did myself in an attempt to fix
> issues with multipath maps incompletely initialized in udev. They are
> now all superseded by 0d66e03 ("libmultipath: force map reload if 
> udev incomplete"). Triggering artificial (spurious) uevents for
> dm devices is useless in almost all cases. If some map is found in an
> inconsistent or incomplete state, the only action that would fix it
> is a full map reload.
> 
> While the code reverted here doesn't do actual harm, it unnecessarily
> complicates matters, wastes resources, and may leave readers of
> the code with wrong ideas how to handle udev issues in multipathd.
> 
> Martin Wilck (3):
>   libmultipath: select_action(): skip is_mpp_known_to_udev() test
>   libmultipath: coalesce_paths(): stop triggering spurious uevents
>   Revert "multipathd: uev_trigger(): handle incomplete ADD events"
> 
>  libmultipath/configure.c | 39 ---------------------------------------
>  multipathd/main.c        | 25 -------------------------
>  2 files changed, 64 deletions(-)
> 
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

