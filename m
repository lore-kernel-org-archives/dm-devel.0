Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73330C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 17:52:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB98320789
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 17:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB98320789
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-fnljIZPyN4SY78C3rBy96w-1; Mon, 30 Nov 2020 12:52:10 -0500
X-MC-Unique: fnljIZPyN4SY78C3rBy96w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF80DE763;
	Mon, 30 Nov 2020 17:52:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 485459CA0;
	Mon, 30 Nov 2020 17:52:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE9994E58F;
	Mon, 30 Nov 2020 17:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUHq2QX007233 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 12:52:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9CBB65D21D; Mon, 30 Nov 2020 17:52:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96EBB5D21F
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 17:52:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 322A4811E85
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 17:52:00 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
	[209.85.210.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-393-wdDh4ay_N1OHvswKjTT66g-1; Mon, 30 Nov 2020 12:51:57 -0500
X-MC-Unique: wdDh4ay_N1OHvswKjTT66g-1
Received: by mail-pf1-f175.google.com with SMTP id t8so10883291pfg.8
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 09:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=zGnnwAdYWjtdhwju8NcFhzJcpMrWjZbZM1FQN8kVDHg=;
	b=Vqkr7mwXdJirG+JumlAu/dxnYl6TWhnm5UN6v9NR6XEs/SAjg2Y32rPBXt7AGz3kUi
	bt11u5ph9dg4HhQ3Jl4c+2cMjGZaK9SYTzEIUYZfv1bS61jRqJXnRqUnhKIwa/ms71h1
	Xd/8L/v4ZRYtzSICyHmqjntycNoA3W1nQKaiMsZSWqlZsKlRmuk3D/DWt+jiAsTZ0IEI
	xVdp8LMz78Tdo9IcIyrXU7hxxRZsOpSS2c1zXW61LV6sOLYYPbBl6FxMDqWfcxWNKFgZ
	xro3wlEiYcaTZEApU07YPWADr0lB6YhBzH7FEbYTizsyLLebGkhedS4jQQPDGlI3eceh
	iTcg==
X-Gm-Message-State: AOAM532Rz/CQ1zdfGaO1D191vNrgDNUyV2OtsRu+zX/QZQntHZUx7Z8B
	iBPwKM7ccAUNu4l/ioQJ1cIH3g==
X-Google-Smtp-Source: ABdhPJwMTZsLj5SnQFza8cXET/WnIEE6pVW7Y7fE9/cYA5ZaExgItRAY6sgUO5JUjmSVf3YBKD1+nQ==
X-Received: by 2002:a62:ed01:0:b029:19a:a667:9925 with SMTP id
	u1-20020a62ed010000b029019aa6679925mr17651943pfh.35.1606758716075;
	Mon, 30 Nov 2020 09:51:56 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
	by smtp.gmail.com with ESMTPSA id
	w18sm17681748pfi.216.2020.11.30.09.51.54
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 30 Nov 2020 09:51:55 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20201128161510.347752-1-hch@lst.de> <20201130171915.GA1499@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e67ffb20-ce91-a3a7-e1f7-6fd32334abc4@kernel.dk>
Date: Mon, 30 Nov 2020 10:51:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201130171915.GA1499@lst.de>
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] merge struct block_device and struct hd_struct v4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/30/20 10:19 AM, Christoph Hellwig wrote:
> On Sat, Nov 28, 2020 at 05:14:25PM +0100, Christoph Hellwig wrote:
>> A git tree is available here:
>>
>>     git://git.infradead.org/users/hch/block.git bdev-lookup
>>
>> Gitweb:
>>
>>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bdev-lookup
> 
> I've updated the git tree with the set_capacity_and_notify change
> suggested by Jan, a commit log typo fix and the Reviewed-by tags.
> 
> Jens, can you take a look and potentially merge the branch?  That would
> really help with some of the pending work.

Done, queued up for 5.11.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

