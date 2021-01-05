Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493BAC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:28:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7700A22D5A
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7700A22D5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-tcBLwtRiOVaZT1PX9z19rA-1; Tue, 05 Jan 2021 15:28:38 -0500
X-MC-Unique: tcBLwtRiOVaZT1PX9z19rA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16BFA1005504;
	Tue,  5 Jan 2021 20:28:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAAF562465;
	Tue,  5 Jan 2021 20:28:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6AB8C180954D;
	Tue,  5 Jan 2021 20:28:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105KSVaL018611 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 15:28:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E1032166B2B; Tue,  5 Jan 2021 20:28:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1933B2166B29
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:28:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C8E185A794
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:28:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-201-vaaHACMNNFSML9k8EY2NSg-1;
	Tue, 05 Jan 2021 15:28:22 -0500
X-MC-Unique: vaaHACMNNFSML9k8EY2NSg-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id AB3FF20B7192;
	Tue,  5 Jan 2021 12:28:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AB3FF20B7192
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-6-tusharsu@linux.microsoft.com>
	<56db41c08d625b8143454a2e0aaaef3ea2927442.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <2c1d83b6-e344-28ea-e387-01a0febbe391@linux.microsoft.com>
Date: Tue, 5 Jan 2021 12:28:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <56db41c08d625b8143454a2e0aaaef3ea2927442.camel@linux.ibm.com>
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
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 5/8] IMA: limit critical data measurement
 based on a label
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2020-12-24 6:29 a.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> On Sat, 2020-12-12 at 10:02 -0800, Tushar Sugandhi wrote:
>> System administrators should be able to limit which kernel subsystems
>> they want to measure the critical data for. To enable that, an IMA policy
>> condition to choose specific kernel subsystems is needed. This policy
>> condition would constrain the measurement of the critical data based on
>> a label for the given subsystems.
> 
> Restricting which kernel integrity critical data is measured is not
> only of interest to system administrators.   Why single them out?
> 
system administrators are usually responsible for system 
policies/configurations.They own modifications in the config files like
ima-policy. That's why we wanted to address them to begin with. But you
are correct. This is not only of interest to sysadmins. I will make the 
description more generic.


> Limiting which critical data is measured is based on a label, making it
> flexible.  In your use case scenario, you're grouping the label based
> on kernel subsystem, but is that really necessary?  In the broader
> picture, there could be cross subsystem critical data being measured
> based on a single label.
> 
> Please think about the broader picture and re-write the patch
> descirption more generically.
> 
Makes sense. Will make the patch description more generic.
>>
>> Add a new IMA policy condition - "data_source:=" to the IMA func
> 
> What is with "add"?  You're "adding support for" or "defining" a new
> policy condition.  Remove the single hyphen, as explained in 3/8.
> 
> Please replace "data_source" with something more generic (e.g. label).
> 
Sounds good. Would you prefer "label" or something else like "data_label"?

In the policy file the "label" looks logical and more generic than 
"data_label".
    measure func=CRITICAL_DATA label=selinux

For the time being, I will stick with "label", please let me know if you
prefer something else.

Thanks,
Tushar

> thanks,
> 
> Mimi
> 
>> CRITICAL_DATA to allow measurement of various kernel subsystems. This
>> policy condition would enable the system administrators to restrict the
>> measurement to the labels listed in "data_source:=".
>>
>> Limit the measurement to the labels that are specified in the IMA
>> policy - CRITICAL_DATA+"data_source:=". If "data_sources:=" is not
>> provided with the func CRITICAL_DATA, the data from all the
>> supported kernel subsystems is measured.
>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

