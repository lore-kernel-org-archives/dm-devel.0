Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFB4C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 18:53:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5E07222D04
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 18:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E07222D04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-zv_Q94HoPQ6iKQtgOlWcGg-1; Tue, 05 Jan 2021 13:53:27 -0500
X-MC-Unique: zv_Q94HoPQ6iKQtgOlWcGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BF2510054FF;
	Tue,  5 Jan 2021 18:53:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D58501002388;
	Tue,  5 Jan 2021 18:53:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 227FC4BB7B;
	Tue,  5 Jan 2021 18:53:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105IrJN0009964 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 13:53:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 125658A4C9; Tue,  5 Jan 2021 18:53:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A7EA8A4C2
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 18:53:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA3D9811E84
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 18:53:09 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-551-R2mOKp-RP1Kk-rutUEqP3A-1;
	Tue, 05 Jan 2021 13:53:07 -0500
X-MC-Unique: R2mOKp-RP1Kk-rutUEqP3A-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 167CF20B7192;
	Tue,  5 Jan 2021 10:53:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 167CF20B7192
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-3-tusharsu@linux.microsoft.com>
	<4e83480731b937cea479f688029560444b9cb66a.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <3fdb72ae-f291-386b-e7b9-688dfe092dc5@linux.microsoft.com>
Date: Tue, 5 Jan 2021 10:53:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4e83480731b937cea479f688029560444b9cb66a.camel@linux.ibm.com>
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
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 2/8] IMA: add support to measure buffer
	data hash
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



On 2020-12-23 4:03 p.m., Mimi Zohar wrote:
> On Sat, 2020-12-12 at 10:02 -0800, Tushar Sugandhi wrote:
>> The original IMA buffer data measurement sizes were small (e.g. boot
>> command line), but the new buffer data measurement use cases have data
>> sizes that are a lot larger.  Just as IMA measures the file data hash,
>> not the file data, IMA should similarly support the option for measuring
>> the hash of the buffer data.
>>
>> Measuring in-memory buffer-data/buffer-data-hash is different than
>> measuring file-data/file-data-hash. For the file, IMA stores the
>> measurements in both measurement log and the file's extended attribute -
>> which can later be used for appraisal as well. For buffer, the
>> measurements are only stored in the IMA log, since the buffer has no
>> extended attributes associated with it.
> 
> By definition, buffer data is only measured.  Nothing new is added by
> the above paragraph.  Please remove it.
> 
Sure. Will remove.
>>
>> Introduce a boolean parameter measure_buf_hash to support measuring
>> hash of a buffer, which would be much smaller, instead of the buffer
>> itself.
> 
> Like the patch Subject line use "the buffer data hash" instead of the
> "hash of a buffer".
> 
Will do.
> There's no need to include the boolean parameter name
> "measure_buf_hash".  Please remove it.
> 
Will do.
>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
>> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
>> ---
>>   security/integrity/ima/ima.h                 |  3 +-
>>   security/integrity/ima/ima_appraise.c        |  2 +-
>>   security/integrity/ima/ima_asymmetric_keys.c |  2 +-
>>   security/integrity/ima/ima_main.c            | 38 +++++++++++++++++---
>>   security/integrity/ima/ima_queue_keys.c      |  3 +-
>>   5 files changed, 39 insertions(+), 9 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
>> index e5622ce8cbb1..fa3044a7539f 100644
>> --- a/security/integrity/ima/ima.h
>> +++ b/security/integrity/ima/ima.h
>> @@ -268,7 +268,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>>   			   struct ima_template_desc *template_desc);
>>   void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   				const char *eventname, enum ima_hooks func,
>> -				int pcr, const char *func_data);
>> +				int pcr, const char *func_data,
>> +				bool measure_buf_hash);
> 
> Please abbreviate the boolean name to "hash".   The test would then be
> "if (hash == true)" or "if (hash)".
> 
Will do.
>>   void ima_audit_measurement(struct integrity_iint_cache *iint,
>>   			   const unsigned char *filename);
>>   int ima_alloc_init_template(struct ima_event_data *event_data,
>> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
>> index 8361941ee0a1..46ffa38bab12 100644
>> --- a/security/integrity/ima/ima_appraise.c
>> +++ b/security/integrity/ima/ima_appraise.c
>> @@ -352,7 +352,7 @@ int ima_check_blacklist(struct integrity_iint_cache *iint,
>>   		if ((rc == -EPERM) && (iint->flags & IMA_MEASURE))
>>   			process_buffer_measurement(NULL, digest, digestsize,
>>   						   "blacklisted-hash", NONE,
>> -						   pcr, NULL);
>> +						   pcr, NULL, false);
>>   	}
>>   
>>   	return rc;
>> diff --git a/security/integrity/ima/ima_asymmetric_keys.c b/security/integrity/ima/ima_asymmetric_keys.c
>> index 1c68c500c26f..a74095793936 100644
>> --- a/security/integrity/ima/ima_asymmetric_keys.c
>> +++ b/security/integrity/ima/ima_asymmetric_keys.c
>> @@ -60,5 +60,5 @@ void ima_post_key_create_or_update(struct key *keyring, struct key *key,
>>   	 */
>>   	process_buffer_measurement(NULL, payload, payload_len,
>>   				   keyring->description, KEY_CHECK, 0,
>> -				   keyring->description);
>> +				   keyring->description, false);
>>   }
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index e76ef4bfd0f4..0f8409d77602 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -779,7 +779,7 @@ int ima_post_load_data(char *buf, loff_t size,
>>   }
>>   
>>   /*
>> - * process_buffer_measurement - Measure the buffer to ima log.
>> + * process_buffer_measurement - Measure the buffer or the buffer data hash
>>    * @inode: inode associated with the object being measured (NULL for KEY_CHECK)
>>    * @buf: pointer to the buffer that needs to be added to the log.
>>    * @size: size of buffer(in bytes).
>> @@ -787,12 +787,23 @@ int ima_post_load_data(char *buf, loff_t size,
>>    * @func: IMA hook
>>    * @pcr: pcr to extend the measurement
>>    * @func_data: private data specific to @func, can be NULL.
>> + * @measure_buf_hash: measure buffer hash
> 
> ^@hash: measure buffer data hash
> 
Agreed. Will fix.
>>    *
>> - * Based on policy, the buffer is measured into the ima log.
>> + * Measure the buffer into the IMA log, and extend the @pcr.
> 
> IMA always measures/appraises files and measures buffer data based on
> policy.  The above sentence succintly summarizes what
> process_buffer_measurement() does.   This patch adds support for
> measuring the "buffer data hash".   The following would be an
> appropriate change.
> 
> * Based on policy, either the buffer data or buffer data hash is
> measured
> 
Sounds good. Will update.
>> + *
>> + * Determine what buffers are allowed to be measured, based on the policy rules
>> + * and the IMA hook passed using @func.
>> + *
>> + * Use @func_data, if provided, to match against the measurement policy rule
>> + * data for @func.
>> + *
>> + * If @measure_buf_hash is set to true - measure hash of the buffer data,
>> + * else measure the buffer data itself.
> 
> This patch should be limited to adding "buffer data hash" support.
> These changes don't belong in this patch.  Please remove.
> 
Agreed. Will remove.
>>    */
>>   void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   				const char *eventname, enum ima_hooks func,
>> -				int pcr, const char *func_data)
>> +				int pcr, const char *func_data,
>> +				bool measure_buf_hash)
>>   {
>>   	int ret = 0;
>>   	const char *audit_cause = "ENOMEM";
>> @@ -807,6 +818,8 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   		struct ima_digest_data hdr;
>>   		char digest[IMA_MAX_DIGEST_SIZE];
>>   	} hash = {};
>> +	char buf_hash[IMA_MAX_DIGEST_SIZE];
>> +	int buf_hash_len = hash_digest_size[ima_hash_algo];
>>   	int violation = 0;
>>   	int action = 0;
>>   	u32 secid;
>> @@ -849,13 +862,27 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   		goto out;
>>   	}
>>   
>> +	if (measure_buf_hash) {
> 
> ^ if (hash) {
Yes.
>> +		memcpy(buf_hash, hash.hdr.digest, buf_hash_len);
>> +
>> +		ret = ima_calc_buffer_hash(buf_hash, buf_hash_len,
>> +					   iint.ima_hash);
>> +		if (ret < 0) {
>> +			audit_cause = "measure_buf_hash_error";
> 
> I don't see a good no reason for defining a new audit cause.  Use the
> existing "hashing_error".
> 
> thanks,
> 
> Mimi
> 

Thanks,
Tushar
>> +			goto out;
>> +		}
>> +
>> +		event_data.buf = buf_hash;
>> +		event_data.buf_len = buf_hash_len;
>> +	}
>> +
>>   	ret = ima_alloc_init_template(&event_data, &entry, template);
>>   	if (ret < 0) {
>>   		audit_cause = "alloc_entry";
>>   		goto out;
>>   	}
>>   
>> -	ret = ima_store_template(entry, violation, NULL, buf, pcr);
>> +	ret = ima_store_template(entry, violation, NULL, event_data.buf, pcr);
>>   	if (ret < 0) {
>>   		audit_cause = "store_entry";
>>   		ima_free_template_entry(entry);
>> @@ -890,7 +917,8 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>>   		return;
>>   
>>   	process_buffer_measurement(file_inode(f.file), buf, size,
>> -				   "kexec-cmdline", KEXEC_CMDLINE, 0, NULL);
>> +				   "kexec-cmdline", KEXEC_CMDLINE, 0, NULL,
>> +				   false);
>>   	fdput(f);
>>   }
>>   
>> diff --git a/security/integrity/ima/ima_queue_keys.c b/security/integrity/ima/ima_queue_keys.c
>> index 69a8626a35c0..c2f2ad34f9b7 100644
>> --- a/security/integrity/ima/ima_queue_keys.c
>> +++ b/security/integrity/ima/ima_queue_keys.c
>> @@ -162,7 +162,8 @@ void ima_process_queued_keys(void)
>>   						   entry->payload_len,
>>   						   entry->keyring_name,
>>   						   KEY_CHECK, 0,
>> -						   entry->keyring_name);
>> +						   entry->keyring_name,
>> +						   false);
>>   		list_del(&entry->list);
>>   		ima_free_key_entry(entry);
>>   	}
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

