Return-Path: <SRS0=7So8=MQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2D4C4338F
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jul 2021 07:26:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B25E60E93
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jul 2021 07:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B25E60E93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-CC_QJbrbOjOaDiBXZ-OJHA-1; Sat, 24 Jul 2021 03:26:09 -0400
X-MC-Unique: CC_QJbrbOjOaDiBXZ-OJHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DCF88042E2;
	Sat, 24 Jul 2021 07:26:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48CD010016F8;
	Sat, 24 Jul 2021 07:26:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D1FF11800FFC;
	Sat, 24 Jul 2021 07:26:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16O7Q3fI012538 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 24 Jul 2021 03:26:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CB81D2051B6C; Sat, 24 Jul 2021 07:26:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B182062C16
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 07:26:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CF161857F00
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 07:26:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-86-rUHWjNVaNQmCOJ-jHQlrXA-1;
	Sat, 24 Jul 2021 03:25:55 -0400
X-MC-Unique: rUHWjNVaNQmCOJ-jHQlrXA-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id A9EFB20B7178;
	Sat, 24 Jul 2021 00:25:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A9EFB20B7178
To: Mimi Zohar <zohar@linux.ibm.com>, dm-devel@redhat.com, agk@redhat.com,
	snitzer@redhat.com
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-8-tusharsu@linux.microsoft.com>
	<205b5336d60aee6b3f33ad67b2d0250e104d6779.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <6b81b92f-7d7b-d198-5056-bab1bcbac522@linux.microsoft.com>
Date: Sat, 24 Jul 2021 00:25:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <205b5336d60aee6b3f33ad67b2d0250e104d6779.camel@linux.ibm.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mimi,

On 7/20/21 7:33 PM, Mimi Zohar wrote:
> Hi Tushar, Mike,
> 
> On Mon, 2021-07-12 at 17:49 -0700, Tushar Sugandhi wrote:
>> +Then IMA ASCII measurement log has the following format:
>> +PCR TEMPLATE_DIGEST TEMPLATE ALG:EVENT_DIGEST EVENT_NAME EVENT_DATA
>> +
>> +PCR := Platform Configuration Register, in which the values are registered.
>> +       This is applicable if TPM chip is in use.
>> +TEMPLATE_DIGEST := Template digest of the IMA record.
> 
> ^TEMPLATE_DATA_DIGEST
> 
Will do.

>> +TEMPLATE := Template that registered the integrity value (e.g. ima-buf).
> 
> ^TEMPLATE_NAME
>
Will do.

> The template data format consists of:
>> +ALG:EVENT_DIGEST = Algorithm to compute event digest, followed by digest of event data
>> +EVENT_NAME := Description of the event (e.g. 'table_load').
>> +EVENT_DATA := The event data to be measured.
> 
Thanks. I will add this to the dm-ima documentation.

> Missing from the document is a way of validating the template data.
> For example, in the original case of file measurements, the template
> data contains the file hash, which can be recalculated or verified
> against an allow list.
> 
> Other than re-calculating the template data digest based on the
> template data, and verifying it against the template data digest in the
> measurement list, would an attestation server be able to verify the
> template data itself?
>
Yes.
In the context of device-mapper, EVENT_DATA for 'table_load' would
contain the key-value pairs for various targets in the table
(crypt, verity, integrity etc.) which the attestation servers
should be able to verify against the allowed/expected
key-value pairs specified in the attestation policy.

To avoid bloating the IMA log with same data from table_load again,
we only measure hash of the loaded table in the EVENT_DATA -
when there is a state change for DM device.
e.g. when EVENT_NAME is 'device_resume', 'table_clear',
'device_remove' etc.

Since the table clear-text is already present in the EVENT_DATA
buffer for 'table_load', and is available to attestation servers,
verifying the corresponding hash values in the
EVENT_DATA in the subsequent DM events should be possible for
the attestation servers.

Please let us know if you need further info.

Thanks,
Tushar

> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

