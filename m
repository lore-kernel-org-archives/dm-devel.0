Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BD6C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 18:29:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24C9560F8F
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 18:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 24C9560F8F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-xSIHOMRcP8WfuBgj8-G3SQ-1; Mon, 26 Jul 2021 14:29:42 -0400
X-MC-Unique: xSIHOMRcP8WfuBgj8-G3SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4892190B2A2;
	Mon, 26 Jul 2021 18:29:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB39A5D6A1;
	Mon, 26 Jul 2021 18:29:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B8BD4BB7C;
	Mon, 26 Jul 2021 18:29:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16QISwpI001089 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Jul 2021 14:28:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4F3E744021; Mon, 26 Jul 2021 18:28:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A42344019
	for <dm-devel@redhat.com>; Mon, 26 Jul 2021 18:28:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A01D818A01A5
	for <dm-devel@redhat.com>; Mon, 26 Jul 2021 18:28:55 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-225-DDxlKTsJMBWAQzSSP9xkFw-1;
	Mon, 26 Jul 2021 14:28:53 -0400
X-MC-Unique: DDxlKTsJMBWAQzSSP9xkFw-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id C52AA20B36ED;
	Mon, 26 Jul 2021 11:28:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C52AA20B36ED
To: Mimi Zohar <zohar@linux.ibm.com>, dm-devel@redhat.com, agk@redhat.com,
	snitzer@redhat.com
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-8-tusharsu@linux.microsoft.com>
	<205b5336d60aee6b3f33ad67b2d0250e104d6779.camel@linux.ibm.com>
	<6b81b92f-7d7b-d198-5056-bab1bcbac522@linux.microsoft.com>
	<8cea95cdc1349ae60c690c45ddabcd676c5774d2.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <74451a59-d029-239c-4519-da10c7957c22@linux.microsoft.com>
Date: Mon, 26 Jul 2021 11:28:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8cea95cdc1349ae60c690c45ddabcd676c5774d2.camel@linux.ibm.com>
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
Cc: nramas@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 7/7] dm: add documentation for IMA
	measurement support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mimi,

On 7/26/21 9:33 AM, Mimi Zohar wrote:
> Hi Tushar,
> 
> On Sat, 2021-07-24 at 00:25 -0700, Tushar Sugandhi wrote:
>> Hi Mimi,
>>
>>
>>> Missing from the document is a way of validating the template data.
>>> For example, in the original case of file measurements, the template
>>> data contains the file hash, which can be recalculated or verified
>>> against an allow list.
>>>
>>> Other than re-calculating the template data digest based on the
>>> template data, and verifying it against the template data digest in the
>>> measurement list, would an attestation server be able to verify the
>>> template data itself?
>>>
>> Yes.
>> In the context of device-mapper, EVENT_DATA for 'table_load' would
>> contain the key-value pairs for various targets in the table
>> (crypt, verity, integrity etc.) which the attestation servers
>> should be able to verify against the allowed/expected
>> key-value pairs specified in the attestation policy.
>>
>> To avoid bloating the IMA log with same data from table_load again,
>> we only measure hash of the loaded table in the EVENT_DATA -
>> when there is a state change for DM device.
>> e.g. when EVENT_NAME is 'device_resume', 'table_clear',
>> 'device_remove' etc.
>>
>> Since the table clear-text is already present in the EVENT_DATA
>> buffer for 'table_load', and is available to attestation servers,
>> verifying the corresponding hash values in the
>> EVENT_DATA in the subsequent DM events should be possible for
>> the attestation servers.
>>
>> Please let us know if you need further info.
> 
> For regular files with signatures, the file signature is verified
> against the file hash, both contained within the template data.  For
> the SELinux "critical-data",
> commit 2554a48f4437 ("selinux: measure state and policy capabilities")
> contains that information.  Missing from this patch set is information
> on how the attestation server could verify the DM critical data.
> 
> Does the DM record contain everything needed for the attestion server
> to verify the template record?  Are things like the hash algorithm hard
> coded?
> 
Thanks for the feedback.
I think you have a point (on documenting hash algo and version in the
IMA record).

For the individual targets (crypt/linear etc.) the target version
is already recorded during table_load [1].
So for new attribute add/update/delete to those targets in future,
they should be accompanied by bumping the relevant target version.
So that the attestation servers would know what attributes to expect,
based on the target's version number.
So individual targets are already taken care of.

But for overall DM records I think some versioning would be useful
to the attestation servers, to determine what to expect for the
attributes that are at device level (i.e. not part of any individual
targets e.g. "minor_count", "num_targets" etc.).

Further, for the DM records that are not "table_load" - what hashing
algo is used to hash active/inactive table is the implementation detail
specific to DM, as Mike called out; and it is orthogonal to IMA's hash
algo.

But I think it would be useful to record the active/inactive table's
hash algo as part of the overall DM record template, so that attestation 
servers would know to how to interpret the relevant data.
(i.e. "active_table_hash", "inactive_table_hash" in [2]).

Both the changes are simple enough.

I will prototype and propose them as incremental patches along with
other changes (pointed to dm-5.15 branch as per Mike's suggestion.)

Thanks for your suggestions again.

Regards,
Tushar

[1]
+10 a8c5ff755561c7a28146389d1514c318592af49a ima-buf 
sha256:4d73481ecce5eadba8ab084640d85bb9ca899af4d0a122989252a76efadc5b72
+table_load
+name=linear1,uuid=,major=253,minor=0,minor_count=1,num_targets=1;
+target_index=0,target_begin=0,target_len=2,target_name=linear,target_version=1.4.0,device_name=7:0,start=512;


+table_load
+name=test-crypt,uuid=,major=253,minor=0,minor_count=1,num_targets=1;
+target_index=0,target_begin=0,target_len=1953125,target_name=crypt,target_version=1.23.0,


[2]
+device_remove
+device_active_metadata=name=linear1,uuid=,major=253,minor=0,minor_count=1,num_targets=4;
+device_inactive_metadata=name=linear1,uuid=,major=253,minor=0,minor_count=1,num_targets=2;
+active_table_hash=4d73481ecce5eadba8ab084640d85bb9ca899af4d0a122989252a76efadc5b72,
+inactive_table_hash=5596cc857b0e887fd0c5d58dc6382513284596b07f09fd37efae2da224bd521d,remove_all=n;
+current_device_capacity=8;
> thanks,
> 
> Mimi
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

