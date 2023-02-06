Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E39AC636D3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675717364;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7B3rjh9TbpjEUc1eI65kpfwwljoPjEZrFzzA9fHmUxg=;
	b=bF5lfwz60+xQ/enOUAGpZXr9jBPuHvaCJfZkdyD4qAtVqVGNUw2PxoZJz2iYZk4hapszgW
	hhDJsD9H5PBS+U2bg2EzTd+QpP9iq65R+Sxfu5+rCujFSZqSb4LpDDqslkFHH/MYB6/KhD
	RxyjyF6IbHyskRyIzN3EGTTTOsKAz6o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-GLnx2yvCNDqWGC7E1bJYow-1; Mon, 06 Feb 2023 16:02:40 -0500
X-MC-Unique: GLnx2yvCNDqWGC7E1bJYow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ECA4857A87;
	Mon,  6 Feb 2023 21:02:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A06E403D0C1;
	Mon,  6 Feb 2023 21:02:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A623C194658C;
	Mon,  6 Feb 2023 21:02:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BFFC41946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 20:59:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97A75440D9; Mon,  6 Feb 2023 20:59:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F0CE44037
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 20:59:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D3EA811E6E
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 20:59:07 +0000 (UTC)
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-515-6b-vOrd0OWOWwvTE8VI1QQ-1; Mon, 06 Feb 2023 15:59:05 -0500
X-MC-Unique: 6b-vOrd0OWOWwvTE8VI1QQ-1
Received: from [192.168.1.103] (178.176.73.245) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Mon, 6 Feb 2023
 23:58:55 +0300
To: Mikulas Patocka <mpatocka@redhat.com>
References: <c8c9df45-1d59-3195-7631-51b3a58148ee@omp.ru>
 <alpine.LRH.2.21.2301180658250.13031@file01.intranet.prod.int.rdu2.redhat.com>
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b8269463-9f7e-4c28-2bfe-44663f3764c1@omp.ru>
Date: Mon, 6 Feb 2023 23:58:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2301180658250.13031@file01.intranet.prod.int.rdu2.redhat.com>
X-Originating-IP: [178.176.73.245]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.59, Database issued on: 02/06/2023 20:39:23
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 175298 [Feb 06 2023]
X-KSE-AntiSpam-Info: Version: 5.9.59.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.73.245 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.73.245 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info: 178.176.73.245:7.7.3,7.4.1,7.1.2; 127.0.0.199:7.1.2;
 d41d8cd98f00b204e9800998ecf8427e.com:7.1.1; omp.ru:7.1.1
X-KSE-AntiSpam-Info: {iprep_blacklist}
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.73.245
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2023 20:41:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/6/2023 6:36:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 06 Feb 2023 21:02:22 +0000
Subject: Re: [dm-devel] [PATCH] md: dm-ioctl: drop always-false condition
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 lvc-patches@linuxtesting.org, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/18/23 2:59 PM, Mikulas Patocka wrote:

[...]

>> The expression 'indata[3] > ULONG_MAX' always evaluates to false since
>> indata[] is declared as an array of *unsigned long* elements and #define
>> ULONG_MAX represents the max value of that exact type...
>>
>> Note that gcc seems to be able to detect the dead code here and eliminate
>> this check anyway...
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
>> analysis tool.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

   Thank you!

>> ---
>> This patch is atop of the 'for-next' branch of the device-mapper repo...
>>
>>  drivers/md/dm-ioctl.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> Index: linux-dm/drivers/md/dm-ioctl.c
>> ===================================================================
>> --- linux-dm.orig/drivers/md/dm-ioctl.c
>> +++ linux-dm/drivers/md/dm-ioctl.c
>> @@ -1073,8 +1073,7 @@ static int dev_set_geometry(struct file

   Returning to this patch, I think I should've added the name of the function
in question in both the subject and and commit msg... I'll recast...

>>  		goto out;
>>  	}
>>  
>> -	if (indata[0] > 65535 || indata[1] > 255 ||
>> -	    indata[2] > 255 || indata[3] > ULONG_MAX) {
>> +	if (indata[0] > 65535 || indata[1] > 255 || indata[2] > 255) {
>>  		DMERR("Geometry exceeds range limits.");
>>  		goto out;
>>  	}
>>

MBR, Sergey

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

