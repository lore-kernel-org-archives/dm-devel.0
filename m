Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604E4C388F9
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC6F7206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC6F7206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-Wc6sN9ZNMvOC_ImLb3aHwQ-1; Sun, 08 Nov 2020 12:05:15 -0500
X-MC-Unique: Wc6sN9ZNMvOC_ImLb3aHwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DD04805F18;
	Sun,  8 Nov 2020 17:05:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 009525D9D2;
	Sun,  8 Nov 2020 17:05:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C748718199F8;
	Sun,  8 Nov 2020 17:05:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A6FlOSn005673 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 10:47:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 199D0F5CEC; Fri,  6 Nov 2020 15:47:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 148D9F5CEA
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 15:47:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59536185A78B
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 15:47:20 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-389-NOfyjOYgNjWb1Hx9k_kLqQ-1;
	Fri, 06 Nov 2020 10:47:18 -0500
X-MC-Unique: NOfyjOYgNjWb1Hx9k_kLqQ-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id 39B5020B4905;
	Fri,  6 Nov 2020 07:37:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 39B5020B4905
To: Mimi Zohar <zohar@linux.ibm.com>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-7-tusharsu@linux.microsoft.com>
	<7219f4404bc1bed6eb090b94363c283ec3266a17.camel@linux.ibm.com>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <cdcd63f7-ce1f-4463-f886-c36832d7a706@linux.microsoft.com>
Date: Fri, 6 Nov 2020 07:37:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7219f4404bc1bed6eb090b94363c283ec3266a17.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 6/7] IMA: add critical_data to the
 built-in policy rules
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/6/20 7:24 AM, Mimi Zohar wrote:

Hi Mimi,

Thanks for reviewing the patches.

> Hi Lakshmi, Tushar,
> 
> This patch defines a new critical_data builtin policy.  Please update
> the Subject line.
> 
> On Sun, 2020-11-01 at 14:26 -0800, Tushar Sugandhi wrote:
>> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>>
>> The IMA hook to measure kernel critical data, namely
>> ima_measure_critical_data(), could be called before a custom IMA policy
>> is loaded. For example, SELinux calls ima_measure_critical_data() to
>> measure its state and policy when they are initialized. This occurs
>> before a custom IMA policy is loaded, and hence IMA hook will not
>> measure the data. A built-in policy is therefore needed to measure
>> critical data provided by callers before a custom IMA policy is loaded.
> 
> ^Define a new critical data builtin policy to allow measuring early
> kernel integrity critical data before a custom IMA policy is loaded.

I will add the above line in the patch description.

> 
> Either remove the references to SELinux or move this patch after the
> subsequent patch which measures SELinux critical data.

I will remove the reference to SELinux.
I think it would be better to have this patch before the SELinux 
measurement patch.

> 
>>
>> Add CRITICAL_DATA to built-in IMA rules if the kernel command line
>> contains "ima_policy=critical_data". Set the IMA template for this rule
>> to "ima-buf" since ima_measure_critical_data() measures a buffer.
>>
>> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> 
>> ---
>>   security/integrity/ima/ima_policy.c | 32 +++++++++++++++++++++++++++++
>>   1 file changed, 32 insertions(+)
>>
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index ec99e0bb6c6f..dc8fe969d3fe 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
> 
>> @@ -875,6 +884,29 @@ void __init ima_init_policy(void)
>>   			  ARRAY_SIZE(default_appraise_rules),
>>   			  IMA_DEFAULT_POLICY);
>>   
>> +	if (ima_use_critical_data) {
>> +		template = lookup_template_desc("ima-buf");
>> +		if (!template) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +
>> +		ret = template_desc_init_fields(template->fmt,
>> +						&(template->fields),
>> +						&(template->num_fields));
> 
> The default IMA template when measuring buffer data is "ima_buf".   Is
> there a reason for allocating and initializing it here and not
> deferring it until process_buffer_measurement()?
> 

You are right - good catch.
I will remove the above and validate.

thanks,
  -lakshmi

> 
>> +		if (ret)
>> +			goto out;
>> +
>> +		critical_data_rules[0].template = template;
>> +		add_rules(critical_data_rules,
>> +			  ARRAY_SIZE(critical_data_rules),
>> +			  IMA_DEFAULT_POLICY);
>> +	}
>> +
>> +out:
>> +	if (ret)
>> +		pr_err("%s failed, result: %d\n", __func__, ret);
>> +
>>   	ima_update_policy_flag();
>>   }
>>   
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

