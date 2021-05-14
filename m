Return-Path: <SRS0=HAWy=KJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43307C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 09:51:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE52C61453
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 09:51:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE52C61453
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620985864;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5IyMqDS4Ml2iCWbOrVsjmhyY3gon8DARsCJluTKx8rU=;
	b=Y1qyke6OTNChdzm6a05lwfpLab3vp+o5IoAU3WmoqT1guOD46OYGCfrVEKQEYujtBpDlgE
	Od2KnT8+jW2fKb3kV14D5oL3BWCwrlYcvHdbuZpN2AHG4f+s/dhI+uXiE46yGqhDB2bXhJ
	nHUsrJydtuuQ47UL/Cf6r0L+AFff4bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-LqjTbM01Oga1_orRujsKYQ-1; Fri, 14 May 2021 05:51:02 -0400
X-MC-Unique: LqjTbM01Oga1_orRujsKYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DECDC8015F7;
	Fri, 14 May 2021 09:50:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72B235F9B8;
	Fri, 14 May 2021 09:50:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E868180B464;
	Fri, 14 May 2021 09:50:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14E9osCK023381 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 May 2021 05:50:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB79F6787D; Fri, 14 May 2021 09:50:54 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2C986788A;
	Fri, 14 May 2021 09:50:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 14E9of0U023228; Fri, 14 May 2021 05:50:41 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 14E9oebu023224; Fri, 14 May 2021 05:50:40 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 14 May 2021 05:50:40 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Milan Broz <gmazyland@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Changheun Lee <nanich.lee@samsung.com>
In-Reply-To: <alpine.LRH.2.02.2105131510330.21927@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2105140544010.22439@file01.intranet.prod.int.rdu2.redhat.com>
References: <a01ab479-69e8-9395-7d24-9de1eec28aff@acm.org>
	<0e7b0b6e-e78c-f22d-af8d-d7bdcb597bea@gmail.com>
	<alpine.LRH.2.02.2105131510330.21927@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, yi.zhang@redhat.com, bgoncalv@redhat.com,
	dm-crypt@saout.de, linux-kernel@vger.kernel.org,
	alex_y_xu@yahoo.ca, ming.lei@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org, hch@lst.de
Subject: Re: [dm-devel] regression: data corruption with ext4 on LUKS on
 nvme with torvalds master
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 5/13/21 7:15 AM, Theodore Ts'o wrote:
> On Thu, May 13, 2021 at 06:42:22PM +0900, Changheun Lee wrote:
>>
>> Problem might be casued by exhausting of memory. And memory exhausting
>> would be caused by setting of small bio_max_size. Actually it was not
>> reproduced in my VM environment at first. But, I reproduced same problem
>> when bio_max_size is set with 8KB forced. Too many bio allocation would
>> be occurred by setting of 8KB bio_max_size.
> 
> Hmm... I'm not sure how to align your diagnosis with the symptoms in
> the bug report.  If we were limited by memory, that should slow down
> the I/O, but we should still be making forward progress, no?  And a
> forced reboot should not result in data corruption, unless maybe there

If you use data=writeback, data writes and journal writes are not 
synchronized. So, it may be possible that a journal write made it through, 
a data write didn't - the end result would be a file containing random 
contents that was on the disk.

Changheun - do you use data=writeback? Did the corruption happen only in 
newly created files? Or did it corrupt existing files?

> was a missing check for a failed memory allocation, causing data to be
> written to the wrong location, a missing error check leading to the
> block or file system layer not noticing that a write had failed
> (although again, memory exhaustion should not lead to failed writes;
> it might slow us down, sure, but if writes are being failed, something
> is Badly Going Wrong --- things like writes to the swap device or
> writes by the page cleaner must succeed, or else Things Would Go Bad
> In A Hurry).

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

