Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8975C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 03:27:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AFB723E54
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 03:27:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AFB723E54
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-Q-hByUXoM62OwbNb8_3B-A-1; Thu, 10 Dec 2020 22:27:18 -0500
X-MC-Unique: Q-hByUXoM62OwbNb8_3B-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE9AD1926DA0;
	Fri, 11 Dec 2020 03:27:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2AD010016F5;
	Fri, 11 Dec 2020 03:27:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A0F17180954D;
	Fri, 11 Dec 2020 03:27:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BB3R5TY025271 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 22:27:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 617A4E7792; Fri, 11 Dec 2020 03:27:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BCEFE778F
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 03:27:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F9E4800889
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 03:27:03 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-474-fo0yWMCoOZO3X0HK6K-4_Q-1;
	Thu, 10 Dec 2020 22:26:58 -0500
X-MC-Unique: fo0yWMCoOZO3X0HK6K-4_Q-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id AA7E420B717A;
	Thu, 10 Dec 2020 19:26:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AA7E420B717A
To: Tyler Hicks <tyhicks@linux.microsoft.com>
References: <20201209194212.5131-1-tusharsu@linux.microsoft.com>
	<20201209194212.5131-4-tusharsu@linux.microsoft.com>
	<20201210230218.GH489768@sequoia>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <492dd4a8-1edd-211f-42d5-59c24731ddbb@linux.microsoft.com>
Date: Thu, 10 Dec 2020 19:26:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201210230218.GH489768@sequoia>
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
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v7 3/8] IMA: define a hook to measure kernel
 integrity critical data
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2020-12-10 3:02 p.m., Tyler Hicks wrote:
> On 2020-12-09 11:42:07, Tushar Sugandhi wrote:
>> IMA provides capabilities to measure file data, and in-memory buffer
>> data. However, various data structures, policies, and states
>> stored in kernel memory also impact the integrity of the system.
>> Several kernel subsystems contain such integrity critical data. These
>> kernel subsystems help protect the integrity of a device. Currently,
>> IMA does not provide a generic function for kernel subsystems to measure
>> their integrity critical data.
>>   
>> Define a new IMA hook - ima_measure_critical_data to measure kernel
>> integrity critical data.
>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
>> ---
>>   Documentation/ABI/testing/ima_policy |  2 +-
>>   include/linux/ima.h                  |  6 +++++
>>   security/integrity/ima/ima.h         |  1 +
>>   security/integrity/ima/ima_api.c     |  2 +-
>>   security/integrity/ima/ima_main.c    | 36 ++++++++++++++++++++++++++++
>>   security/integrity/ima/ima_policy.c  |  2 ++
>>   6 files changed, 47 insertions(+), 2 deletions(-)
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
>> diff --git a/include/linux/ima.h b/include/linux/ima.h
>> index ac3d82f962f2..675f54db6264 100644
>> --- a/include/linux/ima.h
>> +++ b/include/linux/ima.h
>> @@ -30,6 +30,9 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
>>   extern void ima_post_path_mknod(struct dentry *dentry);
>>   extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
>>   extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
>> +extern void ima_measure_critical_data(const char *event_name,
>> +				      const void *buf, int buf_len,
>> +				      bool measure_buf_hash);
>>   
>>   #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
>>   extern void ima_appraise_parse_cmdline(void);
>> @@ -122,6 +125,9 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
>>   }
>>   
>>   static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
>> +static inline void ima_measure_critical_data(const char *event_name,
>> +					     const void *buf, int buf_len,
>> +					     bool measure_buf_hash) {}
>>   #endif /* CONFIG_IMA */
>>   
>>   #ifndef CONFIG_IMA_KEXEC
>> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
>> index fa3044a7539f..7d9deda6a8b3 100644
>> --- a/security/integrity/ima/ima.h
>> +++ b/security/integrity/ima/ima.h
>> @@ -201,6 +201,7 @@ static inline unsigned int ima_hash_key(u8 *digest)
>>   	hook(POLICY_CHECK, policy)			\
>>   	hook(KEXEC_CMDLINE, kexec_cmdline)		\
>>   	hook(KEY_CHECK, key)				\
>> +	hook(CRITICAL_DATA, critical_data)		\
>>   	hook(MAX_CHECK, none)
>>   
>>   #define __ima_hook_enumify(ENUM, str)	ENUM,
>> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
>> index af218babd198..9917e1730cb6 100644
>> --- a/security/integrity/ima/ima_api.c
>> +++ b/security/integrity/ima/ima_api.c
>> @@ -176,7 +176,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>>    *		subj=, obj=, type=, func=, mask=, fsmagic=
>>    *	subj,obj, and type: are LSM specific.
>>    *	func: FILE_CHECK | BPRM_CHECK | CREDS_CHECK | MMAP_CHECK | MODULE_CHECK
>> - *	| KEXEC_CMDLINE | KEY_CHECK
>> + *	| KEXEC_CMDLINE | KEY_CHECK | CRITICAL_DATA
>>    *	mask: contains the permission mask
>>    *	fsmagic: hex value
>>    *
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index 03aad13e9e70..ae59f4a4dd70 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -922,6 +922,42 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>>   	fdput(f);
>>   }
>>   
>> +/**
>> + * ima_measure_critical_data - measure kernel integrity critical data
>> + * @event_name: event name to be used for the buffer entry
>> + * @buf: pointer to buffer containing data to measure
>> + * @buf_len: length of buffer(in bytes)
>> + * @measure_buf_hash: measure buffer hash
>> + *
>> + * Measure the kernel subsystem data, critical to the integrity of the kernel,
>> + * into the IMA log and extend the @pcr.
>> + *
>> + * Use @event_name to describe the state/buffer data change.
>> + * Examples of critical data (buf) could be kernel in-memory r/o structures,
>                                   ^
> 				 @buf
> 
Will do.
>> + * hash of the memory structures, or data that represents subsystem state
>> + * change.
>> + *
>> + * If @measure_buf_hash is set to true - measure hash of the buffer data,
>> + * else measure the buffer data itself.
>> + * measure_buf_hash can be used to save space, if the data being measured
>        ^
>        @measure_buf_hash
> 
>> + * is too large.
>> + *
>> + * The data (buf) can only be measured, not appraised.
>                  ^
> 		@buf
> 
Will do.
>> + */
>> +void ima_measure_critical_data(const char *event_name,
>> +			       const void *buf, int buf_len,
>> +			       bool measure_buf_hash)
>> +{
>> +	if (!event_name || !buf || !buf_len) {
>> +		pr_err("Invalid arguments passed to %s().\n", __func__);
> 
> This is a problem for the developer making use of the
> ima_measure_critical_data() API and shouldn't be logged, IMO, because a
> user/admin can do nothing about it. I think the error message should be
> dropped.
> 
>> +		return;
>> +	}
>> +
>> +	process_buffer_measurement(NULL, buf, buf_len, event_name,
>> +				   CRITICAL_DATA, 0, NULL,
>> +				   measure_buf_hash);
>> +}
>> +
>>   static int __init init_ima(void)
>>   {
>>   	int error;
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index 25419c7ff50b..2a0c0603626e 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -1251,6 +1251,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>>   			else if (IS_ENABLED(CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS) &&
>>   				 strcmp(args[0].from, "KEY_CHECK") == 0)
>>   				entry->func = KEY_CHECK;
>> +			else if (strcmp(args[0].from, "CRITICAL_DATA") == 0)
>> +				entry->func = CRITICAL_DATA;
>>   			else
>>   				result = -EINVAL;
>>   			if (!result)
> 
> This hunk and the above change to Documentation/ABI/testing/ima_policy
> need to be moved to the next patch when you introduce the policy
> changes.
> 
Will do.
~Tushar
> Tyler
> 
>> -- 
>> 2.17.1
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

