Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF05C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 06:09:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-fiN5Ubi7OKSbYqXDhm9dPg-1; Wed, 30 Mar 2022 02:09:25 -0400
X-MC-Unique: fiN5Ubi7OKSbYqXDhm9dPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F0881884984;
	Wed, 30 Mar 2022 06:09:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A706141DED9;
	Wed, 30 Mar 2022 06:09:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C50871940351;
	Wed, 30 Mar 2022 06:08:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E465319452D2
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 22:30:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A01EE5690F1; Tue, 29 Mar 2022 22:30:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BC8546A3B6
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 22:30:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 801533C01D95
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 22:30:21 +0000 (UTC)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-waGAuGODMjiBVuSBidyl3g-1; Tue, 29 Mar 2022 18:30:18 -0400
X-MC-Unique: waGAuGODMjiBVuSBidyl3g-1
Received: by mail-lf1-f44.google.com with SMTP id e16so32690147lfc.13
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 15:30:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:from:to:cc:references:in-reply-to
 :content-transfer-encoding;
 bh=pVfFf2LUiJ+lsVTn/1q73IQZHWiUdzX5dxpnEtrh5/M=;
 b=740UcpvVZixSXfbZQdVCKZIQP3hDgrqY4OlbUyED7y/7B7zSFO4IEGZO8h3rm3fHwN
 1SCq/V/L2G37IbypnanJ8sn099NuZ5Dhk+B2Jo61SRnZh3AFm4CD3lt5dq/bCWSu8qBK
 OE4Y5u+70z4gXTr/ItDFLQ7qNR8xeHzeVTO6PlGofnHk7lFloH9vczPFMNQWYAPxHcaV
 ez/aMAXp4592GsiKsfOO/9l5Oc63n8umDfETEEEteNknr+r4RiJ9XDFnUha++YLHzF4s
 M42k2Mfk1YbIdr/Ex50Ly5vpfJAAw4G86L4nqLcpIZWs8fNwgBe/zf6LxbgKLTmTxy2O
 VOJw==
X-Gm-Message-State: AOAM533VLAqfd1q4VAG2siAV/xKGDWCrMBH0Tt6fb01CoZ5cZXIyemVt
 tQFlJaER6xkAdoT2MX8JuA9B2A==
X-Google-Smtp-Source: ABdhPJwjPyIRXEqSaJ3aXsai40mgW0ySP5DWFmKQLoiwZAkLzP+t506D6D+qytxazIQad66XZ7nyZQ==
X-Received: by 2002:a05:6512:1398:b0:445:bcef:e4fd with SMTP id
 p24-20020a056512139800b00445bcefe4fdmr4506411lfa.398.1648593016505; 
 Tue, 29 Mar 2022 15:30:16 -0700 (PDT)
Received: from [192.168.0.120] ([2.92.192.13])
 by smtp.gmail.com with ESMTPSA id
 h22-20020a0565123c9600b0044a3b2549c1sm2129416lfv.165.2022.03.29.15.30.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 29 Mar 2022 15:30:16 -0700 (PDT)
Message-ID: <7e7c19f3-ec6a-9a82-5b6f-04edbdc7040d@openvz.org>
Date: Wed, 30 Mar 2022 01:30:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From: Kirill Tkhai <kirill.tkhai@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
References: <164846619932.251310.3668540533992131988.stgit@pro>
 <164846631540.251310.2398727490395218229.stgit@pro>
 <YkMK1cmWyEJGoMB+@infradead.org>
 <241b972d-5f78-6282-4f67-131a2566d479@openvz.org>
In-Reply-To: <241b972d-5f78-6282-4f67-131a2566d479@openvz.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 30 Mar 2022 06:08:49 +0000
Subject: Re: [dm-devel] [PATCH 3/4] dm-qcow2: Introduce driver to create
 block devices over QCOW2 files
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
Cc: axboe@kernel.dk, snitzer@redhat.com, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
 agk@redhat.com, khorenko@virtuozzo.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 29.03.2022 18:24, Kirill Tkhai wrote:
> On 29.03.2022 16:34, Christoph Hellwig wrote:
>> On Mon, Mar 28, 2022 at 02:18:35PM +0300, Kirill Tkhai wrote:
>>> The driver is request based, since this allows to use blk-mq
>>> merging of request. Driver splits requests itself, and every
>>> request (i.e., qio) after splitting fits a single cluster.
>>> (In some cases it is worth to create bigger splits, and this
>>> is a subject of further optimizations).
>>
>> Nak, please don't do that.  If you want finer grained processing use
>> a bio based driver, not a request based one.  This is just getting us
>> into tons of problems.
> 
> Could you explain what you mean? Why shouldn't I use generic bio merging
> code, but implementing my own merging? Which problems you point?
> 
> Generic blk-mq is well tested and lots of people work on its performance.
> It's not obvious reason I should better implement own realization.

In addition to this message. Possible, I confused you with patch description. Let I explain on example.

There are a lot cases, when block device receives sequential bios, which
consist of one page. The driver wants to have these bios are merged together because of
it's not a good idea to call call_write_iter() for each of such 1-page bios.

The same time, in QCOW2 format two sequential clusters may be placed inconsequently.
For instance, let we have 1Mb cluster size and mapping:

virtual device range      range inside QCOW2 file
[0Mb, 1Mb]            ->  [20Mb, 21Mb]
[1Mb, 2Mb]            ->  [30Mb, 31Mb].

This may happen because of cluster #1 were allocated later than cluster #0.
In case of a request going to [512K, 1.5Mb], it intersects cluster boundary
and we want to split it into two. Otherwise it impossible to call call_write_iter().

Solving the problem with 1-page bios, an implementing own elevator for only driver
does not look a good idea. Making an elevator with performance comparable with
generic block layer's is not a trivial task. At least it will require the same
amount of code that block layer has. This is not a solution for a single driver.

From the driver side, it tells block layer about optimal IO size, so the number
of splits should gravitate to zero.

Looking at another drivers like loop and nbd, they both are request based.
Necessity to split a request to fit a filesystem extent is not a reason to stop
merging loop requests, isn't it?! Also, nbd merges bios despite they are splitted
by qemu-nbd in userspace level to fit 1 cluster boundary just like my driver does.
Because, this is the only way. I've already tried another way, when I started
writing this driver as bio-based. But then found that this is not a good solution,
and converted it in request-based.

Kirill

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

