Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51E3C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 17:04:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B49DB23A7C
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 17:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B49DB23A7C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-dGx-psOHMwCrHcC-1MCpwQ-1; Fri, 11 Dec 2020 12:04:36 -0500
X-MC-Unique: dGx-psOHMwCrHcC-1MCpwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 772A93E747;
	Fri, 11 Dec 2020 17:04:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A0F26F982;
	Fri, 11 Dec 2020 17:04:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 303884A7C6;
	Fri, 11 Dec 2020 17:04:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBH4TY7021261 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 12:04:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D44AE115D7A6; Fri, 11 Dec 2020 17:04:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D05D7115D7A5
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 17:04:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A1FA811E78
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 17:04:26 +0000 (UTC)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
	[209.85.166.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-463-SPlRv0Y9NBiWDSLCQGZrAw-1; Fri, 11 Dec 2020 12:04:24 -0500
X-MC-Unique: SPlRv0Y9NBiWDSLCQGZrAw-1
Received: by mail-io1-f68.google.com with SMTP id r9so10173441ioo.7
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 09:04:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Ahs5t1jZns6ylc9n/wQ8MrZRCY05NSLjV+Xm6qlZmLQ=;
	b=iUEcCSCHedSBKZtBie852M9vu9nxZFCl9WZCEMpQZV64qyHkbKrR3IRMThETXiorWg
	McBfleOi/5YDOGAbHa1QW7s49IKhc966eNf7Dge7DPGZtTkyA4cXRxHZJUJe3b59HmiR
	Ff5q9aF8PBY4Yl8Eb66ucsVwIfI2iiR+92SdtuQVB3mkd2crY9hR1syQR6+0gpz5WnBA
	IxvevF/dPGV0qosFhJGNfgeMjICZbXwVjgG5Ogw4sAJdn/JsPaxk97HCtHjMgmdGONVe
	bY4+lsz2lrJj4n84xRqK1M9/GEp2rDHUBEmV7SDeqnfpgf2W1t2206qHoDT758dPyBFF
	OySg==
X-Gm-Message-State: AOAM532T6ymUkPpspAFp+iaeaQWuh1I69M38BIVHepfl/6bv4YHqQg8v
	gOBz8idpdqZHunG+jMNOUGQGIauaDewBcQ==
X-Google-Smtp-Source: ABdhPJwvy2YLEploQHFEOTRB0QTKfSZuVTASwHRyClJtYVNu+IyG0KHrsLyQREi4mMQkK0EoS7AyTQ==
X-Received: by 2002:a6b:920b:: with SMTP id u11mr16128922iod.191.1607706262460;
	Fri, 11 Dec 2020 09:04:22 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id g6sm5597052ilc.85.2020.12.11.09.04.21
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 11 Dec 2020 09:04:21 -0800 (PST)
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
	Sergei Shtepa <sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
	<208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <06b4a10d-5ea5-27e1-af0d-83d5c714996f@kernel.dk>
Date: Fri, 11 Dec 2020 10:04:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
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
Cc: "steve@sk2.org" <steve@sk2.org>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, "koct9i@gmail.com" <koct9i@gmail.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: blk_interposer - Block Layer
	Interposer
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

On 12/11/20 9:56 AM, Hannes Reinecke wrote:
> On 12/11/20 5:33 PM, Jens Axboe wrote:
>> On 12/11/20 9:30 AM, Mike Snitzer wrote:
>>> While I still think there needs to be a proper _upstream_ consumer of
>>> blk_interposer as a condition of it going in.. I'll let others make the
>>> call.
>>
>> That's an unequivocal rule.
>>
>>> As such, I'll defer to Jens, Christoph and others on whether your
>>> minimalist blk_interposer hook is acceptable in the near-term.
>>
>> I don't think so, we don't do short term bandaids just to plan on
>> ripping that out when the real functionality is there. IMHO, the dm
>> approach is the way to go - it provides exactly the functionality that
>> is needed in an appropriate way, instead of hacking some "interposer"
>> into the core block layer.
>>
> Which is my plan, too.
> 
> I'll be working with the Veeam folks to present a joint patchset 
> (including the DM bits) for the next round.

Just to be clear, core block additions for something that dm will
consume is obviously fine. Adding this as block layer functionality than
then exposes an application API for setting it up, tearing down, etc -
that is definitely NOT

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

