Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95424C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:32:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6D9B64E54
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:32:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6D9B64E54
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-ilis2WGhO1KEAhmY_or2nw-1; Tue, 09 Feb 2021 13:32:07 -0500
X-MC-Unique: ilis2WGhO1KEAhmY_or2nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 808FA114;
	Tue,  9 Feb 2021 18:32:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E23935D9C0;
	Tue,  9 Feb 2021 18:32:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF64418095CB;
	Tue,  9 Feb 2021 18:31:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119IVvKm031547 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 13:31:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A11DAA9EE0; Tue,  9 Feb 2021 18:31:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99F45A9E6F
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:31:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5563F857AB2
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:31:52 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-266-zUmXh-0DPpu7p8GhIyd0kw-1;
	Tue, 09 Feb 2021 13:31:46 -0500
X-MC-Unique: zUmXh-0DPpu7p8GhIyd0kw-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7089D2020E9E;
	Tue,  9 Feb 2021 10:31:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7089D2020E9E
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
	<20210130004519.25106-4-tusharsu@linux.microsoft.com>
	<158dc2d3398316edefbafdb1cfea5eca840a06e6.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <8af5bf67-54d3-f358-6cb6-34733fc72df2@linux.microsoft.com>
Date: Tue, 9 Feb 2021 10:31:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <158dc2d3398316edefbafdb1cfea5eca840a06e6.camel@linux.ibm.com>
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
Subject: Re: [dm-devel] [PATCH 3/3] IMA: add support to measure duplicate
 buffer for critical data hook
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



On 2021-02-08 12:24 p.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> On Fri, 2021-01-29 at 16:45 -0800, Tushar Sugandhi wrote:
> 
>> diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
>>
>> index c096ef8945c7..fbf359495fa8 100644
>> --- a/security/integrity/ima/ima_queue.c
>> +++ b/security/integrity/ima/ima_queue.c
>> @@ -158,7 +158,7 @@ static int ima_pcr_extend(struct tpm_digest *digests_arg, int pcr)
>>    */
>>   int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>   			   const char *op, struct inode *inode,
>> -			   const unsigned char *filename)
>> +			   const unsigned char *filename, bool allow_dup)
>>   {
>>   	u8 *digest = entry->digests[ima_hash_algo_idx].digest;
>>
>   	struct tpm_digestate_entry(struct ima_template_entry *entry, int violation,
Not sure I understand this.  Maybe a typo?  Could you please explain?

>>   
>>   	mutex_lock(&ima_extend_list_mutex);
>>   	if (!violation) {
>> -		if (ima_lookup_digest_entry(digest, entry->pcr)) {
>> +		if (!allow_dup &&
>> +		    ima_lookup_digest_entry(digest, entry->pcr)) {
> 
> Can't this change be simplified to "if (!violation && !allow_dup)"?
> 
Sure.  Will do.

Earlier I wasn't sure if 'violation' would touch any other use-cases 
inadvertently.  That's why I localized the change as above.

But now since we are supporting other scenarios as well,
I believe "if (!violation && !allow_dup)" would be cleaner.

> Also perhaps instead of passing another variable "allow_dup" to each of
> these functions, pass a mask containing violation and allow_dup.
> 
There were examples of both approaches in ima_match_policy().
  - int *pcr/ima_template_desc **template_desc as an out-param;
  - and various actions as flags in return int.

Earlier I couldn't decide one way or the other, so I picked the 
out-param approach.

But since allow_dup is just a single bit info, returning it as a bit in 
the action flag is a cleaner solution.
Will implement it with flag in the next iteration.

Thanks again for reviewing the series.  Really appreciate it.

Thanks,
Tushar

>>   			audit_cause = "hash_exists";
>>   			result = -EEXIST;
>>   			goto out;
> 
> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

