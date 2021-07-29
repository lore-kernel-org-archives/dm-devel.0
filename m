Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7057DC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 17:40:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 025E260524
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 17:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 025E260524
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-kIYllCzOMbiDLTQGkN1R5Q-1; Thu, 29 Jul 2021 13:40:35 -0400
X-MC-Unique: kIYllCzOMbiDLTQGkN1R5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CF0B34830;
	Thu, 29 Jul 2021 17:40:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9984453B;
	Thu, 29 Jul 2021 17:40:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89F7C180BAB1;
	Thu, 29 Jul 2021 17:40:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16THWn8X018117 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 13:32:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C5F4B20B6645; Thu, 29 Jul 2021 17:32:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1EC820B6642
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 17:32:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 093DD8D1381
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 17:32:47 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-539-GC1Pm_8tP6a1cNsPsBvjCA-1;
	Thu, 29 Jul 2021 13:32:44 -0400
X-MC-Unique: GC1Pm_8tP6a1cNsPsBvjCA-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9239E2043BBF;
	Thu, 29 Jul 2021 10:32:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9239E2043BBF
To: Thore Sommer <public@thson.de>
References: <a30c8208-f255-d0f0-0bfb-c037367e638c@linux.microsoft.com>
	<20210728171402.1120181-1-public@thson.de>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <51402c7b-eeab-9dd5-a78f-05e501f578e3@linux.microsoft.com>
Date: Thu, 29 Jul 2021 10:32:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728171402.1120181-1-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
 IMA
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 7/28/21 10:14 AM, Thore Sommer wrote:
> Hi Tushar,
> 
>> Most likely this is because you haven't set CONFIG_IMA_DISABLE_HTABLE=y.
> Yes, that was the case.
> 
> With CONFIG_IMA_DISABLE_HTABLE=y the behavior is as expected. Now a new
> measurement is created if I create the same device twice.
> 
> Regards,
> Thore
> 
Thanks for confirming Thore. :)

Regards,
Tushar

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

