Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904F5C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 17:51:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B157860F56
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 17:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B157860F56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-AUwxUHq0P2GDIegbteH1wg-1; Mon, 09 Aug 2021 13:51:22 -0400
X-MC-Unique: AUwxUHq0P2GDIegbteH1wg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DAA9801AEB;
	Mon,  9 Aug 2021 17:51:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B799210074E1;
	Mon,  9 Aug 2021 17:51:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4A754BB7C;
	Mon,  9 Aug 2021 17:51:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 179HpAhv020791 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Aug 2021 13:51:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E10D4C77EA; Mon,  9 Aug 2021 17:51:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8A3CC77E5
	for <dm-devel@redhat.com>; Mon,  9 Aug 2021 17:51:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA49A8482CF
	for <dm-devel@redhat.com>; Mon,  9 Aug 2021 17:51:06 +0000 (UTC)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
	[209.85.167.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-392-uVk2-qTwPtS14A93f_eiVg-1; Mon, 09 Aug 2021 13:51:04 -0400
X-MC-Unique: uVk2-qTwPtS14A93f_eiVg-1
Received: by mail-oi1-f173.google.com with SMTP id be20so5817371oib.8
	for <dm-devel@redhat.com>; Mon, 09 Aug 2021 10:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=p35CO2b5gVHFfM+jxHUIY4WYpGVVYWhxKX7SG5GDBak=;
	b=kFHSVD8OKNwN72wSf2snW0U8E+7no2XsuEQNclNptF76kTt811X2uGoMRzbiu+Tp88
	5n+AG7zNBB8uFFBfziFrvvW991/W8fpNxxyxd53aqjGTZ+Ar1tmdF0PhSSYnZ5CkqGkL
	a/K1MGBIzRX8kOTEp1C0lWdA9+B3iIch4/cC0jY9NxTNrcxMeSJmQ9hyv+alm7Hra14m
	zEU6hPD3qaAczTtYLs+jGB1wcbIr410LoH6aBgYrqET9jArWncsN6otOj54XHpPwAAu+
	XBOYRG/eO1dAqveTpviNo7FGsQv/jI6toLyb4mY9s02MFyIycrdHIHcfr8dAjsZ4LNTK
	3mWQ==
X-Gm-Message-State: AOAM533PyvxcucKRZkf4HoIzt3nF35BwXBbh1jYs02f7rfFwpfC6mB6S
	TtBNjTllLOz4b9zVdpNbvxEgtQ==
X-Google-Smtp-Source: ABdhPJzwsv5SQcHRxm7Sl/e2di0rC3ABebpdSF5xZJkvxk5NwzpQIhEQGqAzJVzEeHFCABUKrfkPMA==
X-Received: by 2002:a05:6808:b13:: with SMTP id
	s19mr14536801oij.45.1628531463898; 
	Mon, 09 Aug 2021 10:51:03 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
	by smtp.gmail.com with ESMTPSA id p4sm2881825ooa.35.2021.08.09.10.51.03
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 09 Aug 2021 10:51:03 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
References: <20210804094147.459763-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b93c771f-792d-b892-c88d-e28c81315860@kernel.dk>
Date: Mon, 9 Aug 2021 11:51:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210804094147.459763-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] use regular gendisk registration in device mapper v2
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/4/21 3:41 AM, Christoph Hellwig wrote:
> Hi all,
> 
> The device mapper code currently has a somewhat odd gendisk registration
> scheme where it calls add_disk early, but uses a special flag to skip the
> "queue registration", which is a major part of add_disk.  This series
> improves the block layer holder tracking to work on an entirely
> unregistered disk and thus allows device mapper to use the normal scheme
> of calling add_disk when it is ready to accept I/O.
> 
> Note that this leads to a user visible change - the sysfs attributes on
> the disk and the dm directory hanging off it are not only visible once
> the initial table is loaded.  This did not make a different to my testing
> using dmsetup and the lvm2 tools.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

