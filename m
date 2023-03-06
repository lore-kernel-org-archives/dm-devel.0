Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC7EC6FA99
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 18:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678126606;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VkVBVyrZUNDfqtzs5sqB5HbcaIuaqq3esWHW/TWWjsY=;
	b=dD1vzTrV3soEedBx8aMGO371z041FvtAYfVuZltqLdrReDolLnieLmHOHh+XGGduZ+Z6iD
	2RnBC5WfLI1NRKOkPQir8rV0TUvI3J0+etrp2UO8A2bqmkiBwfNDK01HXkctZIJF75Ienm
	VziM1YtBXC+cTDTCXDROdgFGj1Z84Es=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-9Yr8cVoBPyOmTVJnvlphng-1; Mon, 06 Mar 2023 13:16:43 -0500
X-MC-Unique: 9Yr8cVoBPyOmTVJnvlphng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C9C71C05149;
	Mon,  6 Mar 2023 18:16:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF5DC40C945A;
	Mon,  6 Mar 2023 18:16:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA8F1194658D;
	Mon,  6 Mar 2023 18:16:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B10D7194658C
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 18:16:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93B5E2166B2E; Mon,  6 Mar 2023 18:16:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C3DD2166B2B
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 18:16:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C5A43C0DDA6
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 18:16:38 +0000 (UTC)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-hModT95cO0SNXTsghOGNRQ-1; Mon, 06 Mar 2023 13:16:35 -0500
X-MC-Unique: hModT95cO0SNXTsghOGNRQ-1
Received: by mail-pl1-f177.google.com with SMTP id a9so11350923plh.11;
 Mon, 06 Mar 2023 10:16:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678126593;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=qWRMEw69/6QGtgvJh0SpxzYGgeA4jgzxjtj9+O7Jw24=;
 b=3oASVAak4RZ2uH73Iw3qcEzLxkVyJc0Kdz6CG9YFMyTwArNW3x6eRVDfLCjFtARlKI
 AWHULzgYC0BycnRWrVZch9vaLs/5grZ8TmK9KcHmEmvW5QVJHkEVGw7ci75l6/JRdYz/
 NhtdepjqIjTZta1IyLX4MG5Cax5bJdmy8fZXcVrjNeW01hx/mvsk9nHNgKpI5dUJKyCD
 gMFRVc/IEe5QMbU1SeqlNyk5tmutv+FlJtviP2QHNNr8/QW2ox1UGx6CCkM1HWpFYwPY
 BAIce9MGg2Iy5QM/RHIqNSki6m4pUMHaEPx9/tnjOm7RcebZFni3QUt3v96d0OX+zkGI
 pncA==
X-Gm-Message-State: AO0yUKUB4j1rYj5k15vSQtWcoEGjwl+2QDMtMgs87CQo8tNwIsdBszd3
 2JaHhQTH6yv/TtsEXSG5JzaZS/uRslY=
X-Google-Smtp-Source: AK7set9OPUddwxuPnnjsNcugCUHz5P/JhmtGQmTcEpQpC9GNK0m1Wd+xhMQ7g21mN6cJRBSb4jzUPg==
X-Received: by 2002:a17:903:1d2:b0:19c:be07:4af2 with SMTP id
 e18-20020a17090301d200b0019cbe074af2mr15489410plh.45.1678126593590; 
 Mon, 06 Mar 2023 10:16:33 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
 by smtp.gmail.com with ESMTPSA id
 d6-20020a170902c18600b00199025284b3sm7028470pld.151.2023.03.06.10.16.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 06 Mar 2023 10:16:33 -0800 (PST)
Message-ID: <ee7a7a6a-ef46-f487-e78d-a828a4042393@acm.org>
Date: Mon, 6 Mar 2023 10:16:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Mikulas Patocka <mpatocka@redhat.com>,
 yangerkun <yangerkun@huaweicloud.com>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com> <Y/zwVCNDrdAbzC7a@redhat.com>
 <Y/zxI4wK8trtuJgV@redhat.com>
 <3e31584c-b0f3-fc9a-3657-935fc51db74e@huaweicloud.com>
 <alpine.LRH.2.21.2303061240200.31427@file01.intranet.prod.int.rdu2.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <alpine.LRH.2.21.2303061240200.31427@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/6/23 10:02, Mikulas Patocka wrote:
> On Tue, 28 Feb 2023, yangerkun wrote:
>> It's ok to fix the softlockup, but for async write encrypt,
>> kcryptd_crypt_write_io_submit will add bio to write_tree, and once we
>> call cond_resched before every kcryptd_io_write, the write performance
>> may be poor while we meet a high cpu usage scene.
> 
> Hi
> 
> To fix this problem, find the PID of the process "dmcrypt_write" and
> change its priority to -20, for example "renice -n -20 -p 34748".
> 
> This is the proper way how to fix it; locking up the process for one
> second is not.
> 
> We used to have high-priority workqueues by default, but it caused audio
> playback skipping, so we had to revert it - see
> f612b2132db529feac4f965f28a1b9258ea7c22b.
> 
> Perhaps we should add an option to have high-priority kernel threads?

Would calling cond_resched() every n iterations instead of every 
iteration help? From mm/swapfile.c:

			if (unlikely(--latency_ration < 0)) {
				cond_resched();
				latency_ration = LATENCY_LIMIT;
			}

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

