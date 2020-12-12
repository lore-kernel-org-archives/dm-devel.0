Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E20C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 18:14:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C81C22571
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 18:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C81C22571
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-nwO_cpb9PYChA5JF8MxRkA-1; Sat, 12 Dec 2020 13:14:54 -0500
X-MC-Unique: nwO_cpb9PYChA5JF8MxRkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0CFF10054FF;
	Sat, 12 Dec 2020 18:14:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D61710013BD;
	Sat, 12 Dec 2020 18:14:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7816C180954D;
	Sat, 12 Dec 2020 18:14:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCIEgE6030118 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 13:14:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BBCA02166B2A; Sat, 12 Dec 2020 18:14:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B66952166B29
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 18:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C95F8007D9
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 18:14:39 +0000 (UTC)
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com
	[209.85.216.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-338-YIYap28nPVSLHWP3OKnUYA-1; Sat, 12 Dec 2020 13:14:35 -0500
X-MC-Unique: YIYap28nPVSLHWP3OKnUYA-1
Received: by mail-pj1-f68.google.com with SMTP id f14so3981454pju.4
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 10:14:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=vPqkNEV8mHk/bP+lF6DmFa2iJcEPH5rRm6JP4KbBMo0=;
	b=l3fc0VVS1ow1R+RFsESHDr+x1v2goPLQTHqsxKqJQs9WMDQa6u22EtKHAxefL+7lbH
	N/JWMeOz5R7xaOqilA4MJGWTawxo9HIccfqckiiFCoWzVxymhS2u4Z31Qcpqqrgz0O6j
	KjsUcjR/N65ROqrCTMHgfqaFYwONe5rw1rfi8ORCq0RDf4AyuRulFgjixufgrCCyw9bS
	W3ejmlDtXKowqGPj2HunhMOG5qs04qNzGzr5yMBPmJZgcFqFg1vEe0fHposSu33eNBqa
	AkfAPkaAFf8ty4pWsNhSxsPtkrz09f/rTM3zCzyhsfnAtCvxDbz0gU6D+K1hFL7zsO9p
	xR3w==
X-Gm-Message-State: AOAM530uLUu5yeMhmBu+nPcOZAopzuA402wY6FgZ95l46MNs6t2ibZ7O
	Q7TFfnZ0LgAPj4uLByaPMN6uVmM1yMvx0A==
X-Google-Smtp-Source: ABdhPJyzLfzuB0KUyKGFSNr6IYFEPAE0OXxmdsTO8gURDuRU0fhyabebg0ctlKQwB8lLEJ+t16aEuA==
X-Received: by 2002:a17:90a:df12:: with SMTP id
	gp18mr18051977pjb.43.1607796873727; 
	Sat, 12 Dec 2020 10:14:33 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
	by smtp.gmail.com with ESMTPSA id u24sm574816pjx.56.2020.12.12.10.14.32
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 12 Dec 2020 10:14:33 -0800 (PST)
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
	Sergei Shtepa <sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
	<208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
	<06b4a10d-5ea5-27e1-af0d-83d5c714996f@kernel.dk>
	<b4f3ee74-58fd-52c8-ae60-f352758fb42a@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6bc5ff77-4977-a9bd-3fb8-ce35e1179b94@kernel.dk>
Date: Sat, 12 Dec 2020 11:14:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b4f3ee74-58fd-52c8-ae60-f352758fb42a@suse.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/11/20 11:03 AM, Hannes Reinecke wrote:
> On 12/11/20 6:04 PM, Jens Axboe wrote:
>> On 12/11/20 9:56 AM, Hannes Reinecke wrote:
>>> On 12/11/20 5:33 PM, Jens Axboe wrote:
>>>> On 12/11/20 9:30 AM, Mike Snitzer wrote:
>>>>> While I still think there needs to be a proper _upstream_ consumer of
>>>>> blk_interposer as a condition of it going in.. I'll let others make the
>>>>> call.
>>>>
>>>> That's an unequivocal rule.
>>>>
>>>>> As such, I'll defer to Jens, Christoph and others on whether your
>>>>> minimalist blk_interposer hook is acceptable in the near-term.
>>>>
>>>> I don't think so, we don't do short term bandaids just to plan on
>>>> ripping that out when the real functionality is there. IMHO, the dm
>>>> approach is the way to go - it provides exactly the functionality that
>>>> is needed in an appropriate way, instead of hacking some "interposer"
>>>> into the core block layer.
>>>>
>>> Which is my plan, too.
>>>
>>> I'll be working with the Veeam folks to present a joint patchset
>>> (including the DM bits) for the next round.
>>
>> Just to be clear, core block additions for something that dm will
>> consume is obviously fine. Adding this as block layer functionality than
>> then exposes an application API for setting it up, tearing down, etc -
>> that is definitely NOT
>>
> That was never my intention.
> Any consumers of this thing would need to be in-kernel.
> If that was your concern.

Yep, that is/was indeed my concern!

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

