Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAFDC63777
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B320920729
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B320920729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-C0fdKKBHOtC-IpzYyqnJdg-1; Mon, 23 Nov 2020 03:40:33 -0500
X-MC-Unique: C0fdKKBHOtC-IpzYyqnJdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01AB710766CA;
	Mon, 23 Nov 2020 08:40:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D692860C15;
	Mon, 23 Nov 2020 08:40:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AF26A50032;
	Mon, 23 Nov 2020 08:40:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKNXn0m025185 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 18:33:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6253DAF03; Fri, 20 Nov 2020 23:33:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF6F3F1033
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 23:33:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86D6A103B801
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 23:33:47 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-25-Fa_kFuIcOjirCbqRu6u_yg-1;
	Fri, 20 Nov 2020 18:33:43 -0500
X-MC-Unique: Fa_kFuIcOjirCbqRu6u_yg-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id 89BC420B717A;
	Fri, 20 Nov 2020 15:33:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 89BC420B717A
To: Mimi Zohar <zohar@linux.ibm.com>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201119232611.30114-8-tusharsu@linux.microsoft.com>
	<e151e67e0749766c1b501ecc54dbeb0450c0cea2.camel@linux.ibm.com>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <58607cc2-2a20-03d7-9f38-9c3bebb1c494@linux.microsoft.com>
Date: Fri, 20 Nov 2020 15:33:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e151e67e0749766c1b501ecc54dbeb0450c0cea2.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:39:39 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v6 7/8] IMA: add a built-in policy rule for
 critical data measurement
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/20/20 6:30 AM, Mimi Zohar wrote:

Hi Mimi,

> 
> On Thu, 2020-11-19 at 15:26 -0800, Tushar Sugandhi wrote:
>> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>>
>> The IMA hook to measure kernel critical data, namely
>> ima_measure_critical_data(), could be called before a custom IMA policy
>> is loaded.
>> Define a new critical data builtin policy to allow measuring
>> early kernel integrity critical data before a custom IMA policy is
>> loaded.
> 
> Everything needing to be said seems to be included in the second
> sentence.  Does the first sentence add anything?  "Define a new
> critical data builtin policy" makes for a good Subject line.

Agreed - will update.

> 
>>
>> Add critical data to built-in IMA rules if the kernel command line
>> contains "ima_policy=critical_data".
> 
> The boot command line parameters are defined in Documentation/admin-
> guide/kernel-parameters.txt.  Please update "ima_policy".

Will do.

> 
>>
>> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>> ---
>>   security/integrity/ima/ima_policy.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index c9e52dab0638..119604a3efa0 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -206,6 +206,10 @@ static struct ima_rule_entry secure_boot_rules[] __ro_after_init = {
>>   	 .flags = IMA_FUNC | IMA_DIGSIG_REQUIRED},
>>   };
>>
>> +static struct ima_rule_entry critical_data_rules[] __ro_after_init = {
>> +	{.action = MEASURE, .func = CRITICAL_DATA, .flags = IMA_FUNC},
>> +};
>> +
>>   /* An array of architecture specific rules */
>>   static struct ima_rule_entry *arch_policy_entry __ro_after_init;
>>   
>> @@ -228,6 +232,7 @@ __setup("ima_tcb", default_measure_policy_setup);
>>   
>>   static bool ima_use_appraise_tcb __initdata;
>>   static bool ima_use_secure_boot __initdata;
>> +static bool ima_use_critical_data __ro_after_init;
> 
> Unlike ima_fail_unverifiable_sigs, ima_use_critical_data is only used
> during __init.  Please change "__ro_after_init" to "__initdata".  (The
> critical data policy itself is defined properly as __ro_after_init.)

Will do.

> 
>>   static bool ima_fail_unverifiable_sigs __ro_after_init;
>>   static int __init policy_setup(char *str)
>>   {
>> @@ -242,6 +247,8 @@ static int __init policy_setup(char *str)
>>   			ima_use_appraise_tcb = true;
>>   		else if (strcmp(p, "secure_boot") == 0)
>>   			ima_use_secure_boot = true;
>> +		else if (strcmp(p, "critical_data") == 0)
>> +			ima_use_critical_data = true;
>>   		else if (strcmp(p, "fail_securely") == 0)
>>   			ima_fail_unverifiable_sigs = true;
>>   		else
>> @@ -875,6 +882,11 @@ void __init ima_init_policy(void)
>>   			  ARRAY_SIZE(default_appraise_rules),
>>   			  IMA_DEFAULT_POLICY);
>>   
>> +	if (ima_use_critical_data)
>> +		add_rules(critical_data_rules,
>> +			  ARRAY_SIZE(critical_data_rules),
>> +			  IMA_DEFAULT_POLICY);
>> +
>>   	ima_update_policy_flag();
>>   }
>>   
> 

thanks,
  -lakshmi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

