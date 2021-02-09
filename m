Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF6DC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:26:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4763D64E76
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4763D64E76
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-SEGkt-vhMhSIDdbvZi8WVQ-1; Tue, 09 Feb 2021 13:26:31 -0500
X-MC-Unique: SEGkt-vhMhSIDdbvZi8WVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F064880196C;
	Tue,  9 Feb 2021 18:26:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B85B357;
	Tue,  9 Feb 2021 18:26:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52D9818095CB;
	Tue,  9 Feb 2021 18:26:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119IQN93030944 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 13:26:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5CFBDA9A0E; Tue,  9 Feb 2021 18:26:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5797C7C44
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:26:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56DBE800C81
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:26:20 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-175-DvdVRTSdORW6MZO1SgtA6Q-1;
	Tue, 09 Feb 2021 13:26:15 -0500
X-MC-Unique: DvdVRTSdORW6MZO1SgtA6Q-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0BF6520B6C40;
	Tue,  9 Feb 2021 10:26:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0BF6520B6C40
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
	<20210130004519.25106-2-tusharsu@linux.microsoft.com>
	<059e77ffa861680ccac7fd94251fedc7cffe7a7e.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <0643d35b-b765-0c9f-ffc5-99fb8cd22eb4@linux.microsoft.com>
Date: Tue, 9 Feb 2021 10:26:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <059e77ffa861680ccac7fd94251fedc7cffe7a7e.camel@linux.ibm.com>
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
Subject: Re: [dm-devel] [PATCH 1/3] IMA: add policy condition to measure
 duplicate critical data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021-02-08 12:45 p.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> On Fri, 2021-01-29 at 16:45 -0800, Tushar Sugandhi wrote:
>> IMA needs to support duplicate measurements of integrity
>> critical data to accurately determine the current state of that data
>> on the system.  Further, since measurement of duplicate data is not
>> required for all the use cases, it needs to be policy driven.
>>
>> Define "allow_dup", a new IMA policy condition, for the IMA func
>> CRITICAL_DATA to allow duplicate buffer measurement of integrity
>> critical data.
>>
>> Limit the ability to measure duplicate buffer data when action is
>> "measure" and func is CRITICAL_DATA.
> 
> Why?!
> 
I wasn't sure if it would break any use-case by supporting this for all 
the files / buffers.  That's why I only wanted to address the scenario 
that we discussed in the last series (critical data measurement).
But as you suggested in this series' cover letter response, I am happy 
to extend it to other scenarios (by disabling "htable" using new Kconfig 
(e.g. CONFIG_IMA_DISABLE_HTABLE)
>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
>> ---
>>
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index 9b45d064a87d..b89eb768dd05 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -35,6 +35,7 @@
>>   #define IMA_FSNAME	0x0200
>>   #define IMA_KEYRINGS	0x0400
>>   #define IMA_LABEL	0x0800
>> +#define IMA_ALLOW_DUP	0x1000
>>   
>>   #define UNKNOWN		0
>>   #define MEASURE		0x0001	/* same as IMA_MEASURE */
>> @@ -87,6 +88,7 @@ struct ima_rule_entry {
>>   	char *fsname;
>>   	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
>>   	struct ima_rule_opt_list *label; /* Measure data grouped under this label */
> 
> Defining a new boolean entry shouldn't be necessary.    The other
> boolean values are just stored in "flags".
> 
Thanks.  Will do the same here.
Thanks,
Tushar
>>   	struct ima_template_desc *template;
>>   };
> 
> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

