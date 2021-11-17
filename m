Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C904CC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:00:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6263F61B3F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:00:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6263F61B3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637182837;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mr2mHBeE4s56n61eNp9lRcOfjqWKTsjhoa4Qwymdu+Q=;
	b=XPXw0mKhCobng4LLVorB/5S6AD8McK1n3jO6jmWRDDLKP+YjeXzTrHBLCee+zQhv2OnbSD
	JVQlFa6yL4erAqg1cDQDIRQiqqhJu/w8+n7gIfvtrPt8Lis7YL8xKUCzm/FYnZjPjrE5q3
	Aukt5xlSL+AdtfxxDP/SW3H9v+l3mZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-tV8-8D3ZPau6gKuFosYtQA-1; Wed, 17 Nov 2021 16:00:34 -0500
X-MC-Unique: tV8-8D3ZPau6gKuFosYtQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4EDD80414D;
	Wed, 17 Nov 2021 21:00:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C08095D9DE;
	Wed, 17 Nov 2021 21:00:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92FC74EA2A;
	Wed, 17 Nov 2021 21:00:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHKtFBm023717 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 15:55:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5B6B53AEF; Wed, 17 Nov 2021 20:55:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6063826370;
	Wed, 17 Nov 2021 20:55:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHKt90B004519; 
	Wed, 17 Nov 2021 14:55:09 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHKt9Nf004518;
	Wed, 17 Nov 2021 14:55:09 -0600
Date: Wed, 17 Nov 2021 14:55:08 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211117205508.GB19591@octiron.msp.redhat.com>
References: <1637181217-4423-1-git-send-email-bmarzins@redhat.com>
	<c78729cd320b2a8dec4414c389922ec1e41ff13d.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <c78729cd320b2a8dec4414c389922ec1e41ff13d.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/4] Add "reconfigure all" multipath
	command
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

On Wed, Nov 17, 2021 at 08:50:55PM +0000, Martin Wilck wrote:
> On Wed, 2021-11-17 at 14:33 -0600, Benjamin Marzinski wrote:
> > 
> > Changes from v1 as suggested by Martin Wilck:
> > 
> > 0001: update libmultipath.version to handle ABI change in struct
> > config
> > 0003: Clarify commit message
> 
> Did you overlook the two other comments I had on 0003, or did you
> deliberately ignore them? Just asking.

Ooops. Missed them. I'll resend.

-Ben

> 
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

