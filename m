Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B79C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 01:17:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 65BDA23B31
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 01:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65BDA23B31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-0xF2l_nnMOijnEHFxh4oGQ-1; Fri, 11 Dec 2020 20:17:44 -0500
X-MC-Unique: 0xF2l_nnMOijnEHFxh4oGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C28BA10054FF;
	Sat, 12 Dec 2020 01:17:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE2C46F7EC;
	Sat, 12 Dec 2020 01:17:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 294B4180954D;
	Sat, 12 Dec 2020 01:17:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BC1HX1e007364 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 20:17:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC9922166B2B; Sat, 12 Dec 2020 01:17:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E73E42166B2A
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 01:17:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE384185A794
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 01:17:29 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-137-QDB4mUVqMWGPWXWutxPmMQ-1;
	Fri, 11 Dec 2020 20:17:25 -0500
X-MC-Unique: QDB4mUVqMWGPWXWutxPmMQ-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id CC99920B717A;
	Fri, 11 Dec 2020 17:17:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CC99920B717A
To: Tyler Hicks <tyhicks@linux.microsoft.com>
References: <20201211235807.30815-1-tusharsu@linux.microsoft.com>
	<20201211235807.30815-5-tusharsu@linux.microsoft.com>
	<20201212002500.GF4951@sequoia>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <7e137e37-c195-1d16-05ef-56c2645fcc84@linux.microsoft.com>
Date: Fri, 11 Dec 2020 17:17:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201212002500.GF4951@sequoia>
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
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v8 4/8] IMA: add policy rule to measure
	critical data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2020-12-11 4:25 p.m., Tyler Hicks wrote:
> On 2020-12-11 15:58:03, Tushar Sugandhi wrote:
>> A new IMA policy rule is needed for the IMA hook
>> ima_measure_critical_data() and the corresponding func CRITICAL_DATA for
>> measuring the input buffer. The policy rule should ensure the buffer
>> would get measured only when the policy rule allows the action. The
>> policy rule should also support the necessary constraints (flags etc.)
>> for integrity critical buffer data measurements.
>>
>> Add a policy rule to define the constraints for restricting integrity
>> critical data measurements.
>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
>> ---
>>   Documentation/ABI/testing/ima_policy |  2 +-
>>   security/integrity/ima/ima_policy.c  | 34 ++++++++++++++++++++++++----
>>   2 files changed, 31 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
>> index e35263f97fc1..6ec7daa87cba 100644
>> --- a/Documentation/ABI/testing/ima_policy
>> +++ b/Documentation/ABI/testing/ima_policy
>> @@ -32,7 +32,7 @@ Description:
>>   			func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK]MODULE_CHECK]
>>   			        [FIRMWARE_CHECK]
>>   				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
>> -				[KEXEC_CMDLINE] [KEY_CHECK]
>> +				[KEXEC_CMDLINE] [KEY_CHECK] [CRITICAL_DATA]
>>   			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
>>   			       [[^]MAY_EXEC]
>>   			fsmagic:= hex value
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index a09d1a41a290..07116ff35c25 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -85,6 +85,7 @@ struct ima_rule_entry {
>>   	} lsm[MAX_LSM_RULES];
>>   	char *fsname;
>>   	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
>> +	struct ima_rule_opt_list *data_source; /* Measure data from this source */
> 
> Argh, there are still some more instances of data_source sneaking into
> this patch too early instead of waiting until the next patch.
> 
I kept it purposefully in this patch so that the
"case CRITICAL_DATA:" could be properly defined.

Also, my impression was rule->data_source is not part of the user facing
policy.

Whereas IMA_DATA_SOURCE, Opt_data_source, data_source=%s are.
That's why they are part of Patch #5.

Patch #5 IMA: limit critical data measurement based on a label

>>   	struct ima_template_desc *template;
>>   };
>>   
>> @@ -479,6 +480,12 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
>>   
>>   		opt_list = rule->keyrings;
>>   		break;
>> +	case CRITICAL_DATA:
>> +		if (!rule->data_source)
>> +			return true;
>> +
>> +		opt_list = rule->data_source;
>> +		break;
> 
> I guess this case should unconditionally return true in this patch and
> then the include this additional logic in the next patch.
> 
> Sorry, I missed these on my last review.
> 
No worries.

As I mentioned above, I kept it purposefully in this patch since
my impression was rule->data_source is not part of the user facing
policy.

But I can simply return true here as you suggested, and move the logic 
to the next patch.

+	case CRITICAL_DATA:
+		if (!rule->data_source)
+			return true;
+
+		opt_list = rule->data_source;
+		break;


~Tushar

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

