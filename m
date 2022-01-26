Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8DDC2BA4C
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643212308;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c2pi7ybYKTDh5OQ2DNtm7+ZN+JCsDLHqLadrwX9vI1U=;
	b=EXoHpDmvbz0fy8bFoCpt3PWIPDoU28JH0QTMEiQBBsv+YbcH6q9VsTvFo2eGGO8N3t7+70
	6qulM0CKoKjEK+MJ1b5jghCouorACsrQ9lQHd0xJr5W5s04USVe3p/BrjeNZ+GZqHghLn9
	UAl3U5GjYH06bl71XrnyQ4WJeZ7Q+uE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-AsAbRez0MRWW1j9nTbwLug-1; Wed, 26 Jan 2022 10:51:44 -0500
X-MC-Unique: AsAbRez0MRWW1j9nTbwLug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3084B51081;
	Wed, 26 Jan 2022 15:51:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCCD3798BF;
	Wed, 26 Jan 2022 15:51:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D442C18218AF;
	Wed, 26 Jan 2022 15:51:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QFpagP020203 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 10:51:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 055B27E116; Wed, 26 Jan 2022 15:51:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57D217D498;
	Wed, 26 Jan 2022 15:51:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 20QFp7ZM011746; 
	Wed, 26 Jan 2022 09:51:07 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 20QFp7I8011743;
	Wed, 26 Jan 2022 09:51:07 -0600
Date: Wed, 26 Jan 2022 09:51:06 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220126155106.GL24684@octiron.msp.redhat.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
	<2d4c46dcaee54eb39e96831c0ee9bf88204cc819.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <2d4c46dcaee54eb39e96831c0ee9bf88204cc819.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH v2 0/9] multipathd: remove udev settle
	dependency
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24, 2022 at 11:19:53AM +0000, Martin Wilck wrote:
> On Wed, 2021-11-17 at 15:21 -0600, Benjamin Marzinski wrote:
> 
> My late testing has revealed an issue with this patch with explicit
> ALUA. It's similar to what you solved with the "ghost_delay" parameter
> in the past.
> 
> With this patch, multipathd now starts before SCSI device detection
> begins, and as soon as multipathd sets up a map, I/O on this map may be
> started. With arrays supporting Active/optimized and Active/non-
> optimized states and explicit ALUA, this causes unnecessary path state
> switching if paths in non-optimized state are detected before optimized
> ones. I/O will cause scsi_dh_activate() to be called in the kernel, and
> this will run an STPG, which always uses active/optimized as target
> state.
> 
> With RDDAC, we'll have a similar problem. The other device handlers
> don't distinguish active and optimal states, AFAICS.

Just to clarify things, is there a difference between this and the case
that has always existed, where multipathd is up and running and a new
storage array gets discovered? The active/optimized paths aren't always
discovered first.

-Ben
 
> I fear this behavior will not be welcome in some configurations. So far
> I haven't made up my mind how, and if at all, we can fix it. I suppose
> something similar to ghost_delay would be possible on the multipath-
> tools side, but it's not straightforward, because non-optimized paths
> simply count as PATH_UP in multipathd. Also, the delay should probably
> be much shorter than for PATH_GHOST. In my testing against a LIO
> target, it was a matter of milliseconds which path would appear first.
> 
> Alternatively, maybe we can consider the way scsi_dh_activate() works?
> Perhaps it doesn't have to switch from active/non-optimized to
> active/optimized state? OTOH, there are other situation (explicit path
> group switch) where we'd want exactly that.
> 
> The other alternative would be waiting for udev settle again. I'd
> really like to avoid that.
> 
> Ideas and thoughts highly welcome.
> 
> Regards,
> Martin
> 
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

