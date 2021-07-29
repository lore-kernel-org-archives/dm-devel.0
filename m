Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B96C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:59:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC21E60ED4
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:59:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EC21E60ED4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-xF3TsGIjOUeuNJN8imvvNw-1; Thu, 29 Jul 2021 15:59:10 -0400
X-MC-Unique: xF3TsGIjOUeuNJN8imvvNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 818F8100A44D;
	Thu, 29 Jul 2021 19:59:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46431369A;
	Thu, 29 Jul 2021 19:59:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F44A4A7C8;
	Thu, 29 Jul 2021 19:59:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TJwf1D001794 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 15:58:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D0EE711F4D1; Thu, 29 Jul 2021 19:58:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB94511F4B6
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 19:58:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED83800883
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 19:58:38 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-592-62uiLRGeNgCJ2wWa86TteA-1;
	Thu, 29 Jul 2021 15:58:36 -0400
X-MC-Unique: 62uiLRGeNgCJ2wWa86TteA-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 51A0C20B36E0;
	Thu, 29 Jul 2021 12:58:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 51A0C20B36E0
To: Mimi Zohar <zohar@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-2-tusharsu@linux.microsoft.com>
	<713d22788b678c612c5b18edfb8cf849af61ace5.camel@linux.ibm.com>
	<YPhAaAyo8fKXzu5c@redhat.com>
	<a6887d022d3943e0ca1efb845270fa715a60b925.camel@linux.ibm.com>
	<758a4a85e0fb92e8cbc62b218c12b02f9123f640.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <32086dac-97e0-471c-2dc6-938e4fbc7d02@linux.microsoft.com>
Date: Thu, 29 Jul 2021 12:58:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <758a4a85e0fb92e8cbc62b218c12b02f9123f640.camel@linux.ibm.com>
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
Cc: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, dm-devel@redhat.com,
	linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 1/7] dm: measure data on table load
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mimi,

On 7/21/21 2:17 PM, Mimi Zohar wrote:
> On Wed, 2021-07-21 at 12:07 -0400, Mimi Zohar wrote:
>> On Wed, 2021-07-21 at 11:42 -0400, Mike Snitzer wrote:
>>> On Tue, Jul 20 2021 at 10:12P -0400,
>>> Mimi Zohar <zohar@linux.ibm.com> wrote:
>>>
>>>> Hi Tushar, Mike,
>>>>
>>>> On Mon, 2021-07-12 at 17:48 -0700, Tushar Sugandhi wrote:
>>>>> +struct dm_ima_device_table_metadata {
>>>>> +       /*
>>>>> +        * Contains data specific to the device which is common across
>>>>> +        * all the targets in the table.e.g. name, uuid, major, minor etc.
>>>>> +        * The values are stored in comma separated list of key1=val1,key2=val2; pairs
>>>>> +        * delimited by a semicolon at the end of the list.
>>>>> +        */
>>>>> +       char *device_metadata;
>>>>> +       unsigned int device_metadata_len;
>>>>> +       unsigned int num_targets;
>>>>> +
>>>>> +       /*
>>>>> +        * Contains the sha256 hashs of the IMA measurements of the
>>>>> +        * target attributes key-value pairs from the active/inactive tables.
>>>>> +        */
>>>>
>>>>  From past experience hard coding the hash algorithm is really not a
>>>> good idea.
>>>>
>>>> Mimi
>>>>
>>>>> +       char *hash;
>>>>> +       unsigned int hash_len;
>>>>> +
>>>>> +};
>>>
>>> Hi Mimi,
>>>
>>> The dm-ima.c code is using SHASH_DESC_ON_STACK and then storing the
>>> more opaque result via 'hash' and 'hash_len'.
>>>
>>> So if/when the dm-ima.c hash algorithm were to change this detail
>>> won't change the dm_ima_device_table_metadata structure at all right?
>>> But even if changes were needed this is purely an implementation
>>> detail correct?  Why might users care which algorithm is used by
>>> dm-ima to generate the hashes?
>>>
>>> Assuming there is a valid reason for users to care about this, we can
>>> improve this aspect as follow-on work.. so I don't consider this a
>>> blocker for this patchset at this point.  Please clarify if you feel
>>> it should be a blocker.
>>
>> This goes back to my question as to if or how the template data in
>> these DM critical data records are to be validated by the attestation
>> server.   Asumming the hash/hash_len is being stored in the IMA
>> measurement list, the less the attestation should need to know about
>> the specific kernel version the better.
> 
> Hi Mike, Tushar,  Laskshmi,
> 
> Perhaps, when defining a new IMA "critical data" record, especially if
> you know it's going to change, the critical data should contain a
> version number.
>
Just to close the loop on this thread:

As I explained on the other thread in this patch series -

@the hash verification:
the clear-text for the active/inactive table hashes is already logged in
the 'table_load' event. And we will prefix the active/inactive table
hashes with hash_algo.  (e.g. sha256:<hash>) in the remaining events.
Together it should be sufficient for the attestation server to verify
the active/inactive table hashes without maintaining any list of
expected hashes or referring to kernel version etc.

@versioning:
We are already logging versions for individual targets. What was missing
was some versioning at device level. So thanks again for the suggestion.
We will add a version at device level in each of the events. Together
that should help attestation server to determine what attributes to 
expect in the event data - without relying on specific kernel version.

Thanks again for your feedback.

Regards,
Tushar

> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

