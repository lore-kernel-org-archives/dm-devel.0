Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05830C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 03:28:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5BFDF23E54
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 03:28:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BFDF23E54
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-Ij8GI6B0NPCHKj0NNkBDXg-1; Thu, 10 Dec 2020 22:28:34 -0500
X-MC-Unique: Ij8GI6B0NPCHKj0NNkBDXg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 593A1CC62E;
	Fri, 11 Dec 2020 03:28:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0819160BF1;
	Fri, 11 Dec 2020 03:28:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 541C04A7C6;
	Fri, 11 Dec 2020 03:28:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BB3SQ9D025399 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 22:28:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 333262166B29; Fri, 11 Dec 2020 03:28:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D5952166B2B
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 03:28:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FD0D811E84
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 03:28:23 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-317-nY3LQJhyNCuJOef3MiEr1A-1;
	Thu, 10 Dec 2020 22:28:18 -0500
X-MC-Unique: nY3LQJhyNCuJOef3MiEr1A-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8633220B717A;
	Thu, 10 Dec 2020 19:28:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8633220B717A
To: Tyler Hicks <tyhicks@linux.microsoft.com>
References: <20201209194212.5131-1-tusharsu@linux.microsoft.com>
	<20201209194212.5131-5-tusharsu@linux.microsoft.com>
	<20201210231045.GI489768@sequoia>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <472dc503-295c-1723-b329-c9e08fff4574@linux.microsoft.com>
Date: Thu, 10 Dec 2020 19:28:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201210231045.GI489768@sequoia>
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
Subject: Re: [dm-devel] [PATCH v7 4/8] IMA: add policy rule to measure
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2020-12-10 3:10 p.m., Tyler Hicks wrote:
> On 2020-12-09 11:42:08, Tushar Sugandhi wrote:
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
>>   security/integrity/ima/ima_policy.c | 35 +++++++++++++++++++++++++----
>>   1 file changed, 31 insertions(+), 4 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index 2a0c0603626e..9a8ee80a3128 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -34,6 +34,7 @@
>>   #define IMA_PCR		0x0100
>>   #define IMA_FSNAME	0x0200
>>   #define IMA_KEYRINGS	0x0400
>> +#define IMA_DATA_SOURCE	0x0800
> 
> You introduce data_source= in the next patch. This macro shouldn't be
> added until the next patch.
> 
Ok I will move IMA_DATA_SOURCE to the next patch.

>>   
>>   #define UNKNOWN		0
>>   #define MEASURE		0x0001	/* same as IMA_MEASURE */
>> @@ -85,6 +86,7 @@ struct ima_rule_entry {
>>   	} lsm[MAX_LSM_RULES];
>>   	char *fsname;
>>   	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
>> +	struct ima_rule_opt_list *data_source; /* Measure data from this source */
>>   	struct ima_template_desc *template;
>>   };
>>   
>> @@ -479,6 +481,12 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
>>   		else
>>   			opt_list = rule->keyrings;
>>   		break;
>> +	case CRITICAL_DATA:
>> +		if (!rule->data_source)
>> +			return true;
>> +		else
>> +			opt_list = rule->data_source;
> 
> If you take my suggestions on patch #1, remove the else and simply
> assign opt_list here, too.
> 
Yup. Will do.
>> +		break;
>>   	default:
>>   		break;
>>   	}
>> @@ -518,13 +526,19 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>>   {
>>   	int i;
>>   
>> -	if (func == KEY_CHECK) {
>> -		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
>> -			ima_match_rule_data(rule, func_data, cred);
>> -	}
>>   	if ((rule->flags & IMA_FUNC) &&
>>   	    (rule->func != func && func != POST_SETATTR))
>>   		return false;
>> +
>> +	switch (func) {
>> +	case KEY_CHECK:
>> +	case CRITICAL_DATA:
>> +		return ((rule->func == func) &&
>> +			ima_match_rule_data(rule, func_data, cred));
>> +	default:
>> +		break;
>> +	}
>> +
>>   	if ((rule->flags & IMA_MASK) &&
>>   	    (rule->mask != mask && func != POST_SETATTR))
>>   		return false;
>> @@ -1119,6 +1133,19 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
>>   		if (ima_rule_contains_lsm_cond(entry))
>>   			return false;
>>   
>> +		break;
>> +	case CRITICAL_DATA:
>> +		if (entry->action & ~(MEASURE | DONT_MEASURE))
>> +			return false;
>> +
>> +		if (!(entry->flags & IMA_DATA_SOURCE) ||
>> +		    (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
>> +		    IMA_DATA_SOURCE)))
> 
> IMA_DATA_SOURCE shouldn't exist in this patch. This isn't the right
> indentation, either. See how IMA_KEYRINGS is indented in the KEY_CHECK
> case above.
> 
Will do.
~Tushar
> Tyler
> 
>> +			return false;
>> +
>> +		if (ima_rule_contains_lsm_cond(entry))
>> +			return false;
>> +
>>   		break;
>>   	default:
>>   		return false;
>> -- 
>> 2.17.1
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

