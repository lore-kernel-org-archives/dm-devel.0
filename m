Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B288C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 20:21:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1BD12311A
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 20:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1BD12311A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-9Uxy_6WKM9qFV6BU3jzbDg-1; Mon, 07 Dec 2020 15:21:13 -0500
X-MC-Unique: 9Uxy_6WKM9qFV6BU3jzbDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B94B8144E2;
	Mon,  7 Dec 2020 20:21:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 158CF5D6AB;
	Mon,  7 Dec 2020 20:21:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07F054E58E;
	Mon,  7 Dec 2020 20:21:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7KL1iB019614 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 15:21:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C387F2166B2A; Mon,  7 Dec 2020 20:21:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE9622166B27
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 20:20:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B914800969
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 20:20:59 +0000 (UTC)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
	[209.85.166.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-477-KykhpZRJMguPW22_qtMD5A-1; Mon, 07 Dec 2020 15:20:57 -0500
X-MC-Unique: KykhpZRJMguPW22_qtMD5A-1
Received: by mail-il1-f181.google.com with SMTP id j12so6267985ilk.3
	for <dm-devel@redhat.com>; Mon, 07 Dec 2020 12:20:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Tej9GY05mZXgV9mNE704/sNm7beFt5nAhjB/8/aBReQ=;
	b=W55GT01VwS1ILu01qmZl8b+IEDCDR1aTcZ/sAUj+8K6ir+RNG5rkkrUBaO9kPchypK
	YxTbYMfSkobw0rdQaXaRebtZgapIzdvfOYfObqfTkmghwQ1lZUFEkQxU8O1IUYXxLe5E
	7FjZ/GDBXw9AUu1atL89XZJrUSl2rO38ZZ5J6eoLU62B7W/NCnsOUfZGqt8je/Pr8V8P
	/VtVuPu7n776XB0KWfB0usCO8BLBCATK7sSronKPIfUWQJhkoAxbnpuJSXAIiZNasgIz
	aE4FmTUW3MKj/7HxL6p5piP8r+COqq7SctBYGCcXUEWQEvz4UJAk0HGuPdTMCPhjCXJy
	20Dw==
X-Gm-Message-State: AOAM533UgZ3XFOyICvdr7GN1FwFqT+hOf+vBmVr2Zf7XF8Z+sg3WqBWY
	+VbcM4hLFInfqKn0jO/CbcZ5Qw==
X-Google-Smtp-Source: ABdhPJy0Jnsr7/OtLB3lcu38tiaUnDGbRUb9mNjvFf3jY7wBcRk6npkyOfNJF05HCytsclSzwVrwaQ==
X-Received: by 2002:a05:6e02:13cf:: with SMTP id
	v15mr22654778ilj.222.1607372456254; 
	Mon, 07 Dec 2020 12:20:56 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id
	s17sm7855074ilj.25.2020.12.07.12.20.55
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 07 Dec 2020 12:20:55 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>, Qian Cai <qcai@redhat.com>
References: <20201201165424.2030647-1-hch@lst.de>
	<920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
	<20201207190149.GA22524@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ed7a484d-91d5-50fa-7927-2703b9426d65@kernel.dk>
Date: Mon, 7 Dec 2020 13:20:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207190149.GA22524@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Linux Next Mailing List <linux-next@vger.kernel.org>,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] store a pointer to the block_device in struct bio
	(again)
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/7/20 12:01 PM, Christoph Hellwig wrote:
> Thanks for the report.
> 
> Jens, can you revert the series for now?  I think waiting any longer
> with a report like this is not helpful.  I'll look into it with
> Qian in the meantime.

Agree, I reverted it.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

