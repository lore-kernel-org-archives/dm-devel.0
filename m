Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 708EBC54EE9
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 06:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662100795;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tuxCdhrWlTeI0cDTAx76uaTTA0dSqb49tRTduptY8sE=;
	b=NRZQ8GD1yc1UOO7lfCKf5SlZOwGamlTLI7rP8QwMr5T7la06B6R24X/L2/qh3T5o2gbC4D
	n6wfBPxnHgw59JAckT27PBVMrtaW6KM2XI/ChH5RtKykPRvIcrkxQWVk/kpPvLqLkXopin
	2B75wGULNEz6tRl7z5hvAeFe1QnjT9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-G5L7a6iANDiSiBDeO3NyqQ-1; Fri, 02 Sep 2022 02:39:52 -0400
X-MC-Unique: G5L7a6iANDiSiBDeO3NyqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4B1E8039AE;
	Fri,  2 Sep 2022 06:39:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19298C15BB3;
	Fri,  2 Sep 2022 06:39:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9AAE31940343;
	Fri,  2 Sep 2022 06:39:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 034641946A5E
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 15:06:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E9356C15BBA; Thu,  1 Sep 2022 15:06:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E569DC15BB3
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 15:06:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D102A85A58B
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 15:06:07 +0000 (UTC)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-3dfWmLWdMaCIjV35dcgsrw-1; Thu, 01 Sep 2022 11:06:05 -0400
X-MC-Unique: 3dfWmLWdMaCIjV35dcgsrw-1
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 281EZMls040695;
 Thu, 1 Sep 2022 23:35:22 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Thu, 01 Sep 2022 23:35:22 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
 (authenticated bits=0)
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 281EZMvP040692
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
 Thu, 1 Sep 2022 23:35:22 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c1f57ac7-c35e-8e1b-bcb1-1320e6c41a11@I-love.SAKURA.ne.jp>
Date: Thu, 1 Sep 2022 23:35:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Mike Snitzer <snitzer@kernel.org>
References: <e3ac2722-01c4-decb-2b79-bfd1b6c2b782@I-love.SAKURA.ne.jp>
 <a41b962e-8423-75b5-ef89-74e8b9f25259@I-love.SAKURA.ne.jp>
 <6deb326e-0b0e-84f5-5d1e-2f321d5816ca@I-love.SAKURA.ne.jp>
 <YtF45oMcHMKXjIyy@redhat.com>
 <fd68a776-6df0-fdb1-1520-239d639dee2b@I-love.SAKURA.ne.jp>
In-Reply-To: <fd68a776-6df0-fdb1-1520-239d639dee2b@I-love.SAKURA.ne.jp>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Fri, 02 Sep 2022 06:39:47 +0000
Subject: Re: [dm-devel] dm: Avoid flush_scheduled_work() usage
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

How is the progress?

On 2022/07/16 14:33, Tetsuo Handa wrote:
> Please clarify which work items does flush_scheduled_work() from local_exit()
> needs to wait. Depending on the clarification result, we might be able to
> simply remove flush_scheduled_work() from local_exit() and/or replace with
> flush_work() instead of introducing dedicated workqueues.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

