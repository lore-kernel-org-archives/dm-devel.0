Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56116C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 23:46:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EAE6A61B73
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 23:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EAE6A61B73
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637019960;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VM3Hm8YInWm3+aMFdSyp0avc1wwW02xJj88px/V9f0U=;
	b=Ng1e2bZJJJc9UuHM/PV0tprATnvZ7mr57QxRXQI60fOieZld3altaoRAqL3vmrPvr3kARC
	pkf+PpcYE74J0cYCbQO+ro5LaFSxssre255FuqboBaki2uDOisKqJuCPiv7kWBB+0spqo4
	QZYJQ9Az0ysQOoznCFIu7+P2EpxIlMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-jdRETmNdMXas0Y7R7RU5AQ-1; Mon, 15 Nov 2021 18:45:57 -0500
X-MC-Unique: jdRETmNdMXas0Y7R7RU5AQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C100871803;
	Mon, 15 Nov 2021 23:45:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10F35100164A;
	Mon, 15 Nov 2021 23:45:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9F1FF4A703;
	Mon, 15 Nov 2021 23:45:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFNjkRm000526 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 18:45:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3ACCE100164A; Mon, 15 Nov 2021 23:45:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3D70100EBBE;
	Mon, 15 Nov 2021 23:45:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AFNjYqA022244; 
	Mon, 15 Nov 2021 17:45:34 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AFNjX6a022243;
	Mon, 15 Nov 2021 17:45:33 -0600
Date: Mon, 15 Nov 2021 17:45:33 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211115234533.GV19591@octiron.msp.redhat.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-2-git-send-email-bmarzins@redhat.com>
	<6ff4fe373d52e282af83aa0ca7c116b71fe9480e.camel@suse.com>
	<b908909b2370f188872b0da5e9d90524af848370.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <b908909b2370f188872b0da5e9d90524af848370.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] multipathd: move delayed_reconfig out of
 struct config
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

On Mon, Nov 15, 2021 at 04:27:40PM +0000, Martin Wilck wrote:
> On Mon, 2021-11-15 at 17:10 +0100, Martin Wilck wrote:
> > On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> > > delayed_reconfig was inside the config struct, but it wasn't updated
> > > during an RCU write section, so there's no synchronization on it.
> > > Instead, pull it out of the config structure, and use the config_lock
> > > to synchronize it.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> > 
> 
> I forgot: this patch changes the ABI of libmpathpersist and
> libmultipath. Not in a bad way, because "struct config" is opaque to
> users of libmpathpersist, but for staying consistent, we should adapt
> the library versions.

Oops. Yeah, I can bump the version.

-Ben
 
> See https://github.com/openSUSE/multipath-tools/actions/runs/1455114454
> (open the "abi-test" artifact to check the details).
> 
> Regards
> Martin
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

