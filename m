Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70970C1B0D8
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECC0422CB2
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECC0422CB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-swX9c0xEOpmFh5lO8YJDvA-1; Mon, 14 Dec 2020 06:01:01 -0500
X-MC-Unique: swX9c0xEOpmFh5lO8YJDvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CF4F19251C8;
	Mon, 14 Dec 2020 11:00:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51341704D9;
	Mon, 14 Dec 2020 11:00:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E90F91809C9F;
	Mon, 14 Dec 2020 11:00:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BC0Y4iQ002120 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 19:34:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C4E5D2026D11; Sat, 12 Dec 2020 00:34:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF8CB2026D48
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 00:34:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6450F186E121
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 00:34:02 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-464-z7mok4ouOWSUn-s7AgRtvg-1;
	Fri, 11 Dec 2020 19:33:58 -0500
X-MC-Unique: z7mok4ouOWSUn-s7AgRtvg-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id B971820B7189;
	Fri, 11 Dec 2020 16:33:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B971820B7189
To: Tyler Hicks <tyhicks@linux.microsoft.com>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>
References: <20201211235807.30815-1-tusharsu@linux.microsoft.com>
	<20201211235807.30815-9-tusharsu@linux.microsoft.com>
	<20201212003215.GG4951@sequoia>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <09c3b609-eacb-86e1-b130-cf1dbf4852b8@linux.microsoft.com>
Date: Fri, 11 Dec 2020 16:33:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201212003215.GG4951@sequoia>
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
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v8 8/8] selinux: include a consumer of the
 new IMA critical data hook
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/11/20 4:32 PM, Tyler Hicks wrote:
> On 2020-12-11 15:58:07, Tushar Sugandhi wrote:
>> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>>
>> SELinux stores the active policy in memory, so the changes to this data
>> at runtime would have an impact on the security guarantees provided
>> by SELinux. Measuring in-memory SELinux policy through IMA subsystem
>> provides a secure way for the attestation service to remotely validate
>> the policy contents at runtime.
>>
>> Measure the hash of the loaded policy by calling the IMA hook
>> ima_measure_critical_data(). Since the size of the loaded policy can
>> be large (several MB), measure the hash of the policy instead of
>> the entire policy to avoid bloating the IMA log entry.
>>
>> Add "selinux" to the list of supported data sources maintained by IMA
>> to enable measuring SELinux data.
>>
>> To enable SELinux data measurement, the following steps are required:
>>
>> 1, Add "ima_policy=critical_data" to the kernel command line arguments
>>     to enable measuring SELinux data at boot time.
>> For example,
>>    BOOT_IMAGE=/boot/vmlinuz-5.10.0-rc1+ root=UUID=fd643309-a5d2-4ed3-b10d-3c579a5fab2f ro nomodeset security=selinux ima_policy=critical_data
>>
>> 2, Add the following rule to /etc/ima/ima-policy
>>     measure func=CRITICAL_DATA data_source=selinux
>>
>> Sample measurement of the hash of SELinux policy:
>>
>> To verify the measured data with the current SELinux policy run
>> the following commands and verify the output hash values match.
>>
>>    sha256sum /sys/fs/selinux/policy | cut -d' ' -f 1
>>
>>    grep "selinux-policy-hash" /sys/kernel/security/integrity/ima/ascii_runtime_measurements | tail -1 | cut -d' ' -f 6
>>
>> Note that the actual verification of SELinux policy would require loading
>> the expected policy into an identical kernel on a pristine/known-safe
>> system and run the sha256sum /sys/kernel/selinux/policy there to get
>> the expected hash.
>>
>> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> 
> This looks good but I've got one small suggestion below if you roll a
> v9. Feel free to add:
> 
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> 
>> diff --git a/security/selinux/measure.c b/security/selinux/measure.c
>> new file mode 100644
>> index 000000000000..a070d8dae403
>> --- /dev/null
>> +++ b/security/selinux/measure.c
>> @@ -0,0 +1,81 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Measure SELinux state using IMA subsystem.
>> + */
>> +#include <linux/vmalloc.h>
>> +#include <linux/ktime.h>
>> +#include <linux/ima.h>
>> +#include "security.h"
>> +
>> +/*
>> + * This function creates a unique name by appending the timestamp to
>> + * the given string. This string is passed as "event_name" to the IMA
>> + * hook to measure the given SELinux data.
>> + *
>> + * The data provided by SELinux to the IMA subsystem for measuring may have
>> + * already been measured (for instance the same state existed earlier).
>> + * But for SELinux the current data represents a state change and hence
>> + * needs to be measured again. To enable this, pass a unique "event_name"
>> + * to the IMA hook so that IMA subsystem will always measure the given data.
>> + *
>> + * For example,
>> + * At time T0 SELinux data to be measured is "foo". IMA measures it.
>> + * At time T1 the data is changed to "bar". IMA measures it.
>> + * At time T2 the data is changed to "foo" again. IMA will not measure it
>> + * (since it was already measured) unless the event_name, for instance,
>> + * is different in this call.
>> + */
>> +static char *selinux_event_name(const char *name_prefix)
>> +{
>> +	char *event_name = NULL;
>> +	struct timespec64 cur_time;
>> +
>> +	ktime_get_real_ts64(&cur_time);
>> +	event_name = kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
>> +			       cur_time.tv_sec, cur_time.tv_nsec);
>> +	return event_name;
> 
> There's no longer a need to store the return of kasprintf() in a
> variable. Just 'return kasprint(...);' and get rid of the event_name
> variable.
> 

Sure - I'll make the change.

  -lakshmi


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

