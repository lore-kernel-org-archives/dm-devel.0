Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9D4C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:24:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DAA9464E79
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 18:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAA9464E79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-8PxsakwxNX6jAsDNwUQc0Q-1; Tue, 09 Feb 2021 13:24:14 -0500
X-MC-Unique: 8PxsakwxNX6jAsDNwUQc0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FEBC80402C;
	Tue,  9 Feb 2021 18:24:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5B1917AE2;
	Tue,  9 Feb 2021 18:24:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9FCB118095CB;
	Tue,  9 Feb 2021 18:24:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119INkTs030657 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 13:23:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EE2161112852; Tue,  9 Feb 2021 18:23:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA69C1004163
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:23:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA52A80B93F
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 18:23:42 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-105-JamTdfz1NbanWywftMPbEA-1;
	Tue, 09 Feb 2021 13:23:40 -0500
X-MC-Unique: JamTdfz1NbanWywftMPbEA-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 898D520B57A9;
	Tue,  9 Feb 2021 10:23:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 898D520B57A9
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
	<27f73411fc1d6ce6dd16a29344d729d9aa760250.camel@linux.ibm.com>
	<27a4592c3b75861d2b9c8fb1511f593aa987222c.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <c5ecccbe-9e23-f297-8a79-2a9dd62a40fb@linux.microsoft.com>
Date: Tue, 9 Feb 2021 10:23:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <27a4592c3b75861d2b9c8fb1511f593aa987222c.camel@linux.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] support for duplicate measurement of
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Thank you Mimi for reviewing this series.

On 2021-02-08 1:10 p.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> 
> On Mon, 2021-02-08 at 15:22 -0500, Mimi Zohar wrote:
>> On Fri, 2021-01-29 at 16:45 -0800, Tushar Sugandhi wrote:
>>> IMA does not measure duplicate buffer data since TPM extend is a very
>>> expensive operation.  However, in some cases for integrity critical
>>> data, the measurement of duplicate data is necessary to accurately
>>> determine the current state of the system.  Eg, SELinux state changing
>>> from 'audit', to 'enforcing', and back to 'audit' again.  In this
>>> example, currently, IMA will not measure the last state change to
>>> 'audit'.  This limits the ability of attestation services to accurately
>>> determine the current state of the integrity critical data on the
>>> system.
>>>
>>> This series addresses this gap by providing the ability to measure
>>> duplicate entries for integrity critical data, driven by policy.
>>
>> The same reason for re-measuring buffer data is equally applicable to
>> files.  In both cases, the file or the buffer isn't re-measured if it
>> already exists in the htable.   Please don't limit this patch set to
>> just buffer data.
> 
Agreed.  I wasn't sure if you wanted the support for files, or other 
buffer measurement scenarios, except critical data.  So I started the 
implementation with supporting just critical data.  Happy to extend it 
to files and other buffer measurement scenarios as you suggested.

> Instead of making the change on a per measurement rule basis, disabling
> "htable" would be the simplest way of forcing re-measurements.  All
> that would be needed is a new Kconfig (e.g. CONFIG_IMA_DISABLE_HTABLE)
> and the associated test in ima_add_template_entry().
> 
Agreed.  Earlier I wasn't sure if you wanted allow_dup support for all 
the scenarios.  Now that it is clear,  I will implement it as you 
suggested.  Thank you so much for the pointers.  Appreciate it.

Thanks,
Tushar

> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

