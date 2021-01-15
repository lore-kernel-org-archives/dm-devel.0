Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82949C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 17:27:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0C57235DD
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 17:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0C57235DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-2O_kSAjaMOGLHR_26PokDg-1; Fri, 15 Jan 2021 12:27:18 -0500
X-MC-Unique: 2O_kSAjaMOGLHR_26PokDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79045180A09E;
	Fri, 15 Jan 2021 17:27:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52E185C1A1;
	Fri, 15 Jan 2021 17:27:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83F384BB7B;
	Fri, 15 Jan 2021 17:27:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10FHR5F6010823 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Jan 2021 12:27:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CE4D52166B2C; Fri, 15 Jan 2021 17:27:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C97B52166B2A
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 17:27:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCB1D1010426
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 17:27:02 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-120-6q0snbZKPUG6y1qdFibPbA-1;
	Fri, 15 Jan 2021 12:27:00 -0500
X-MC-Unique: 6q0snbZKPUG6y1qdFibPbA-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id C7DDE20B7192;
	Fri, 15 Jan 2021 09:26:58 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7DDE20B7192
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
	<5189c15054885863b1b5cb86a43bec09725d8650.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <e3deb1a0-a624-f85f-e2d2-3206fa609b64@linux.microsoft.com>
Date: Fri, 15 Jan 2021 09:26:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5189c15054885863b1b5cb86a43bec09725d8650.camel@linux.ibm.com>
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
Subject: Re: [dm-devel] [PATCH v10 0/8] IMA: support for measuring kernel
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



On 2021-01-15 4:54 a.m., Mimi Zohar wrote:
> On Thu, 2021-01-07 at 20:07 -0800, Tushar Sugandhi wrote:
>> IMA measures files and buffer data such as keys, command-line arguments
>> passed to the kernel on kexec system call, etc.  While these measurements
>> are necessary for monitoring and validating the integrity of the system,
>> they are not sufficient.  Various data structures, policies, and states
>> stored in kernel memory also impact the integrity of the system.
>> Several kernel subsystems contain such integrity critical data -
>> e.g.  LSMs like SELinux, AppArmor etc.  or device-mapper targets like
>> dm-crypt, dm-verity, dm-integrity etc.  These kernel subsystems help
>> protect the integrity of a system.  Their integrity critical data is not
>> expected to change frequently during run-time.  Some of these structures
>> cannot be defined as __ro_after_init, because they are initialized later.
>>
>> For a given system, various external services/infrastructure tools
>> (including the attestation service) interact with it - both during the
>> setup and during rest of the system run-time.  They share sensitive data
>> and/or execute critical workload on that system.  The external services
>> may want to verify the current run-time state of the relevant kernel
>> subsystems before fully trusting the system with business critical
>> data/workload.  For instance, verifying that SELinux is in "enforce" mode
>> along with the expected policy, disks are encrypted with a certain
>> configuration, secure boot is enabled etc.
>>
>> This series provides the necessary IMA functionality for kernel
>> subsystems to ensure their configuration can be measured:
>>    - by kernel subsystems themselves,
>>    - in a tamper resistant way,
>>    - and re-measured - triggered on state/configuration change.
>>
>> This patch set:
>>    - defines a new IMA hook ima_measure_critical_data() to measure
>>      integrity critical data,
>>    - limits the critical data being measured based on a label,
>>    - defines a builtin critical data measurement policy,
>>    - and includes an SELinux consumer of the new IMA critical data hook.
> 
> Thanks Tushar, Lakshmi.  This patch set is queued in the next-
> integrity-testing branch.
> 
> Mimi
> 
Hello Mimi, Paul, Stephen, Tyler,
Thanks a lot for reviewing this series and providing all the valuable 
feedback over the last few months.

We really really appreciate it.

Thanks,
Tushar

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

