Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D250FC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 17:54:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3694B2220B
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 17:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3694B2220B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-UuhYkm5VMs2LJle4xbTStw-1; Wed, 30 Dec 2020 12:54:08 -0500
X-MC-Unique: UuhYkm5VMs2LJle4xbTStw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03DB859;
	Wed, 30 Dec 2020 17:54:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CDB06E519;
	Wed, 30 Dec 2020 17:54:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8BEF3180954D;
	Wed, 30 Dec 2020 17:54:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BUHrvrJ023741 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Dec 2020 12:53:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A1CAA7AE8; Wed, 30 Dec 2020 17:53:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C7D85D232
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 17:53:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47F22805BC3
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 17:53:51 +0000 (UTC)
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-130-m9f--IqVPO-K96xDpkUGhA-1; Wed, 30 Dec 2020 12:53:46 -0500
X-MC-Unique: m9f--IqVPO-K96xDpkUGhA-1
Received: from host86-158-105-41.range86-158.btcentralplus.com
	([86.158.105.41] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1kuffN-0002l6-Al; Wed, 30 Dec 2020 17:53:45 +0000
To: John Stoffel <john@stoffel.org>, Danny Shih <dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
	<1609233522-25837-2-git-send-email-dannyshih@synology.com>
	<24555.49943.411197.147225@quad.stoffel.home>
	<abac671f-91f2-ca4e-7f77-8bb5da85a4cc@synology.com>
	<24556.45969.276771.345181@quad.stoffel.home>
From: antlists <antlists@youngman.org.uk>
Message-ID: <1b6c4709-8409-a73f-d3f0-4b4cf19bfae1@youngman.org.uk>
Date: Wed, 30 Dec 2020 17:53:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <24556.45969.276771.345181@quad.stoffel.home>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, snitzer@redhat.com,
	linux-block@vger.kernel.org, song@kernel.org,
	dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 1/4] block: introduce
	submit_bio_noacct_add_head
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 30/12/2020 17:06, John Stoffel wrote:
> Danny> "Provide a way for stacking block device to re-submit
> 
> Danny> the bio which should be handled first."
> 
> Danny> I will fix it.
> 
> Great, though my second question is*why*  it needs to be handled
> first?  What is the difference between stacked and un-stacked devices
> and how could it be done in a way that doesn't require a seperate
> function like this?

Is this anything to do with what's on my mind as a database guy? I've 
heard that things like RAID and LVM have difficulty providing write 
barriers.

I want to be confident that, at EVERY level of the stack, I can put a 
barrier in that guarantees that everything written by user-space BEFORE 
the barrier is handled before anything written AFTER the barrier. That 
way, I can be confident that, after a problem, I know whether I can 
safely roll the log forward or back.

Cheers,
Wol

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

