Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8338C4742C
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:03:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1273320857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1273320857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-Iqe4CumWNZCmt-kjIdjj0w-1; Fri, 13 Nov 2020 03:03:34 -0500
X-MC-Unique: Iqe4CumWNZCmt-kjIdjj0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87F846D246;
	Fri, 13 Nov 2020 08:03:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3864F19D6C;
	Fri, 13 Nov 2020 08:03:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AB1D58103;
	Fri, 13 Nov 2020 08:03:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACLn43v005490 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 16:49:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2351E202348E; Thu, 12 Nov 2020 21:49:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DEE9202450E
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 21:49:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE0FB811E79
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 21:49:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-453-Ha6nM2TmOQyrysHATchXSQ-1;
	Thu, 12 Nov 2020 16:48:56 -0500
X-MC-Unique: Ha6nM2TmOQyrysHATchXSQ-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4CDCA20C2872;
	Thu, 12 Nov 2020 13:48:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4CDCA20C2872
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-3-tusharsu@linux.microsoft.com>
	<811fbc4a6f4bd02c77518bd4196d354071145f3e.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <702e7d17-27f0-30e7-b5ce-affecb0c8de7@linux.microsoft.com>
Date: Thu, 12 Nov 2020 13:48:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <811fbc4a6f4bd02c77518bd4196d354071145f3e.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 2/7] IMA: update
 process_buffer_measurement to measure buffer hash
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2020-11-06 4:11 a.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> Below inline are a few additional comments.
> 
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index ae5da9f3339d..4485d87c0aa5 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -787,12 +787,15 @@ int ima_post_load_data(char *buf, loff_t size,
>>    * @func: IMA hook
>>    * @pcr: pcr to extend the measurement
>>    * @func_data: private data specific to @func, can be NULL.
>> + * @measure_buf_hash: if set to true - will measure hash of the buf,
>> + *                    instead of buf
>>    *
>>    * Based on policy, the buffer is measured into the ima log.
> 
> Both the brief and longer function descriptions need to be updated, as
> well as the last argument description.  The last argument should be
> limited to "measure buffer hash".  How it is used could be included in
> the longer function description.  The longer function description would
> include adding the buffer data or the buffer data hash to the IMA
> measurement list and extending the PCR.
> 
> For example,
> process_buffer_measurement - measure the buffer data or the buffer data
> hash
> 
Thanks Mimi. Will update the brief and longer descriptions accordingly.
> 
>>    */
>>   void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   				const char *eventname, enum ima_hooks func,
>> -				int pcr, const char *func_data)
>> +				int pcr, const char *func_data,
>> +				bool measure_buf_hash)
>>   {
>>   	int ret = 0;
>>   	const char *audit_cause = "ENOMEM";
>> @@ -807,6 +810,8 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   		struct ima_digest_data hdr;
>>   		char digest[IMA_MAX_DIGEST_SIZE];
>>   	} hash = {};
>> +	char digest_hash[IMA_MAX_DIGEST_SIZE];
>> +	int hash_len = hash_digest_size[ima_hash_algo];
>>   	int violation = 0;
>>   	int action = 0;
>>   	u32 secid;
>> @@ -855,6 +860,21 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>>   		goto out;
>>   	}
>>   
>> +	if (measure_buf_hash) {
>> +		memcpy(digest_hash, hash.hdr.digest, hash_len);
> 
> Instead of digest_hash and hash_len, consider naming the variables
> buf_hash and buf_hashlen.
> 
Thanks. Will do.
>> +
>> +		ret = ima_calc_buffer_hash(digest_hash,
>> +					   hash_len,
>> +					   iint.ima_hash);
> 
> There's no need for each variable to be on a separate line.
> 
Thanks, will fix.
~Tushar

> thanks,
> 
> Mimi
> 
>> +		if (ret < 0) {
>> +			audit_cause = "measure_buf_hash_error";
>> +			goto out;
>> +		}
>> +
>> +		event_data.buf = digest_hash;
>> +		event_data.buf_len = hash_len;
>> +	}
>> +
>>   	ret = ima_alloc_init_template(&event_data, &entry, template);
>>   	if (ret < 0) {
>>   		audit_cause = "alloc_entry";

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

