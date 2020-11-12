Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9A7C55ABD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:03:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 401DA20857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 401DA20857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-aVhhLIhsNkW2tK3hx_VhOQ-1; Fri, 13 Nov 2020 03:03:36 -0500
X-MC-Unique: aVhhLIhsNkW2tK3hx_VhOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A6CC835B4F;
	Fri, 13 Nov 2020 08:03:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4893360BE2;
	Fri, 13 Nov 2020 08:03:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2029D181A06C;
	Fri, 13 Nov 2020 08:03:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACMJ0rY010337 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 17:19:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A8156103CD7; Thu, 12 Nov 2020 22:19:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A27051032A5
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:18:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52592181E3E3
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:18:58 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-271-mbWPRe0KNQWBEIACa5FY4A-1;
	Thu, 12 Nov 2020 17:18:56 -0500
X-MC-Unique: mbWPRe0KNQWBEIACa5FY4A-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1615F20C2877;
	Thu, 12 Nov 2020 14:18:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1615F20C2877
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<c840953db2937296c8d77d5d3b4e1274bf990e46.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <a554b2d0-c59a-4ed8-12b8-5a1735cae9a4@linux.microsoft.com>
Date: Thu, 12 Nov 2020 14:18:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c840953db2937296c8d77d5d3b4e1274bf990e46.camel@linux.ibm.com>
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
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 0/7] IMA: Infrastructure for measurement
 of critical kernel data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2020-11-04 4:31 p.m., Mimi Zohar wrote:
> Hi Tushar,
> 
> Measuring "critical kernel data" is not a new infrastructure, simply a
> new IMA hook.   Please update the above Subject line to "support for
> measuring critical kernel data".
> 
Thanks a lot. Will update.
> On Sun, 2020-11-01 at 14:26 -0800, Tushar Sugandhi wrote:
>> There are several kernel subsystems that contain critical data which if
>> accidentally or maliciously altered, can compromise the integrity of the
>> system. Examples of such subsystems would include LSMs like SELinux, or
>> AppArmor; or device-mapper targets like dm-crypt, dm-verity etc.
>> "critical data" in this context is kernel subsystem specific information
>> that is stored in kernel memory. Examples of critical data could be
>> kernel in-memory r/o structures, hash of the memory structures, or
>> data that represents a linux kernel subsystem state.
> 
> This is a bit better, but needs to be much clearer.  Please define
> "critical data", not by example, but by describing "what" critical
> kernel data is.  "There are several kernel subsystems ...."  is an
> example of "how" it would be used, not a definition.  Without a clear
> definition it will become a dumping ground for measuring anything
> anyone wants to measure.  As a result, it may be abused.
> 
Good point. I will come up with a better definition.
>>
>> This patch set defines a new IMA hook namely CRITICAL_DATA, and a
>> function ima_measure_critical_data() - to measure the critical data.
> 
> The name of the IMA hook is ima_measure_critical_data.  This is similar
> to the LSM hooks, which are prefixed with "security_".  (For a full
> list of LSM hooks, refer to lsm_hook_defs.h.)
> 
Thanks for the clarification. I will update this description.
>> Kernel subsystems can use this functionality, to take advantage of IMA's
>> measuring and quoting abilities - thus ultimately enabling remote
>> attestation for the subsystem specific information stored in the kernel
>> memory.
>>
>> The functionality is generic enough to measure the data of any kernel
>> subsystem at run-time. To ensure that only data from supported sources
>> are measured, the kernel subsystem needs to be added to a compile-time
>> list of supported sources (an "allowed list of components"). IMA
>> validates the source passed to ima_measure_critical_data() against this
>> allowed list at run-time.
> 
> Yes, this new feature is generic, but one of the main goals of IMA is
> to measure and attest to the integrity of the system, not to measure
> and attest to random things.
> 
Ok. I will update the above paragraph accordingly.
>>
>> System administrators may want to pick and choose which kernel
>> subsystem information they would want to enable for measurements,
>> quoting, and remote attestation. To enable that, a new IMA policy is
>> introduced.
> 
> ^may want to limit the critical data being measured, quoted and
> attested.
> ^ a new IMA policy condition is defined.
> 
Sounds good. Will update.
>>
>> This patch set also addresses the need for the kernel subsystems to
>> measure their data before a custom IMA policy is loaded - by providing
>> a builtin IMA policy.
> 
> ^for measuring kernel critical data early, before a custom IMA policy
> ...
> 
Sounds good. Will update.
>>
>> And lastly, the use of the overall functionality is demonstrated by
>> measuring the kernel in-memory data for one such subsystem - SeLinux.
> 
> The purpose isn't to demonstrate the "overall functionality", but to
> provide an initial caller of the new IMA hook.
> 
Fair point. Will change the description accordingly.
~Tushar

> thanks,
> 
> Mimi
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

