Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C507C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 07:44:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC85A246EE
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 07:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC85A246EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-UIPVqaKePJ-aPvCFH1UJpA-1; Thu, 19 Nov 2020 02:44:26 -0500
X-MC-Unique: UIPVqaKePJ-aPvCFH1UJpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A16961868400;
	Thu, 19 Nov 2020 07:44:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FC5060843;
	Thu, 19 Nov 2020 07:44:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 32C4B1809CA0;
	Thu, 19 Nov 2020 07:44:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI94HI1021353 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 04:04:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A706A1148B79; Wed, 18 Nov 2020 09:04:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2C9A1148B77
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 09:04:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06472858298
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 09:04:13 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-352-er3rrff1O-SKeLYPIAtzzg-1;
	Wed, 18 Nov 2020 04:04:07 -0500
X-MC-Unique: er3rrff1O-SKeLYPIAtzzg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 19B49B138;
	Wed, 18 Nov 2020 09:04:05 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
	<22ca5396-0253-f286-9eab-d417b2e0b3ad@suse.com>
	<20201118085804.GA20384@lst.de>
From: Jan Beulich <jbeulich@suse.com>
Message-ID: <1ded2079-f1be-6d5d-01df-65754447df78@suse.com>
Date: Wed, 18 Nov 2020 10:04:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118085804.GA20384@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 19 Nov 2020 02:44:06 -0500
Cc: linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: Re: [dm-devel] merge struct block_device and struct hd_struct
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 18.11.2020 09:58, Christoph Hellwig wrote:
> On Wed, Nov 18, 2020 at 09:56:11AM +0100, Jan Beulich wrote:
>> since this isn't the first series from you recently spamming
>> xen-devel, may I ask that you don't Cc entire series to lists
>> which are involved with perhaps just one out of the many patches?
>> IMO Cc lists should be compiled on a per-patch basis; the cover
>> letter may of course be sent to the union of all of them.
> 
> No way.  Individual CCs are completely broken as they don't provide
> the reviewer a context.

That's the view of some people, but not all. Context can be easily
established by those who care going to one of the many archives on
which the entire series lands. Getting spammed, however, can't be
avoided by the dozens or hundreds of list subscribers.

>  If you don't want xen-blkfront patches to
> go to xen-devel remove it from MAINTAINERS.

Patches to Xen drivers very much ought to go to xen-devel imo, so
no - removal is not an option.

Jan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

