Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D25C3F6B0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661371533;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e31V42r/QWEf8pnBi0hNFxzHDZlDHpEmWnzKmof3M5Y=;
	b=ikqBmtIrVeJilA5kKCZgNnOuDi67L3J/M7qSHfbKjkP7G3CE6CtPpfV8iyErkRSMW7RFH0
	1CgURPsZ853WhD1/FwgIR7ePzJyOBWrOPuo12OQRFBLoqJu8jGbTvwucUoQIkH1F2vtaM4
	RBEaMJD1G7Va6AMA4w9WkJI6TuZ6xgo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28--lzud8E7NrKEY8G6e62fgQ-1; Wed, 24 Aug 2022 16:05:30 -0400
X-MC-Unique: -lzud8E7NrKEY8G6e62fgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ABDA1857F02;
	Wed, 24 Aug 2022 20:05:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D68A6945DB;
	Wed, 24 Aug 2022 20:05:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBB291946A61;
	Wed, 24 Aug 2022 20:05:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 645EF1946A42
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 19:05:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EDE562166B29; Wed, 24 Aug 2022 19:05:05 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
 (agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E46112166B26;
 Wed, 24 Aug 2022 19:05:05 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
 from userid 3883)
 id 3DBFD424F086; Wed, 24 Aug 2022 20:04:57 +0100 (BST)
Date: Wed, 24 Aug 2022 20:04:57 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Coly Li <colyli@suse.de>
Message-ID: <20220824190457.GA80211@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: Coly Li <colyli@suse.de>, dm-devel@redhat.com
References: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
MIME-Version: 1.0
In-Reply-To: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] A kernel panic (or soft lockup) due to stack
 overflow by recursive dm-table reload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 25, 2022 at 12:49:06AM +0800, Coly Li wrote:
> 5, reload dm table for dm-0
> # cat dm-table-reload | dmsetup reload /dev/dm-0
> And the content of dm-table-reload is,
> 	0 1 linear /dev/dm-0 0
> 	1 181065566 linear /dev/dm-0 1 
 
> 1) Does anyone observe or encounter such panic or deadlock before?
> 2) To permit recursive dm-table reload, is it a bug or just as-designed ?
 
It's one of those 'That is a stupid thing to do!' situations.
Don't do it!

We have some detection for recursion in our userspace code but we can't
catch everything.

But arguably that specific case of a self-reference is an easy one to
detect kernel-side - table_load could ensure dm_table_get_devices() does
not include the device itself - so it might be worth patching.

Alasdair
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

