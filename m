Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D720C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 08:37:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F27C92065D
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 08:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F27C92065D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-5H_vm4GwPgWLOIFZShMmlw-1; Tue, 05 Jan 2021 03:37:20 -0500
X-MC-Unique: 5H_vm4GwPgWLOIFZShMmlw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB8C2107ACE3;
	Tue,  5 Jan 2021 08:37:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 364761F065;
	Tue,  5 Jan 2021 08:37:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 520FA180954D;
	Tue,  5 Jan 2021 08:37:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1055P93Z015891 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 00:25:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC8601111C82; Tue,  5 Jan 2021 05:25:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8A631111C83
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 05:25:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 706E7811E76
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 05:25:06 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-3-qeRupOJYN3Km5Anz24kkhw-1;
	Tue, 05 Jan 2021 00:25:02 -0500
X-MC-Unique: qeRupOJYN3Km5Anz24kkhw-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8F17520B7192;
	Mon,  4 Jan 2021 21:24:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8F17520B7192
To: Paul Moore <paul@paul-moore.com>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSao7DGtskbDMax8hN+PhQr8homFXUGjm+c7NtEUCtKhg@mail.gmail.com>
	<2dce2244-adbd-df2a-e890-271bbcc8f9f2@linux.microsoft.com>
	<CAHC9VhQ8H+UCnLTJ4Mb=GHCdExGvVEB_+nbK+-keMVie-tnbnQ@mail.gmail.com>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <9d360a9e-5cf2-3d56-d510-8f3d9bd90bcf@linux.microsoft.com>
Date: Mon, 4 Jan 2021 21:24:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQ8H+UCnLTJ4Mb=GHCdExGvVEB_+nbK+-keMVie-tnbnQ@mail.gmail.com>
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
X-Mailman-Approved-At: Tue, 05 Jan 2021 03:37:11 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, snitzer@redhat.com,
	selinux@vger.kernel.org, Stephen Smalley <stephen.smalley.work@gmail.com>,
	James Morris <jmorris@namei.org>, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, tyhicks@linux.microsoft.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v9 8/8] selinux: include a consumer of the
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/4/21 6:13 PM, Paul Moore wrote:
> On Mon, Jan 4, 2021 at 6:30 PM Lakshmi Ramasubramanian
> <nramas@linux.microsoft.com> wrote:
>> On 12/23/20 1:10 PM, Paul Moore wrote:
>> Hi Paul,
> 
> Hello.
> 
>>>> diff --git a/security/selinux/measure.c b/security/selinux/measure.c
>>>> new file mode 100644
>>>> index 000000000000..b7e24358e11d
>>>> --- /dev/null
>>>> +++ b/security/selinux/measure.c
>>>> @@ -0,0 +1,79 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>>> +/*
>>>> + * Measure SELinux state using IMA subsystem.
>>>> + */
>>>> +#include <linux/vmalloc.h>
>>>> +#include <linux/ktime.h>
>>>> +#include <linux/ima.h>
>>>> +#include "security.h"
>>>> +
>>>> +/*
>>>> + * This function creates a unique name by appending the timestamp to
>>>> + * the given string. This string is passed as "event_name" to the IMA
>>>> + * hook to measure the given SELinux data.
>>>> + *
>>>> + * The data provided by SELinux to the IMA subsystem for measuring may have
>>>> + * already been measured (for instance the same state existed earlier).
>>>> + * But for SELinux the current data represents a state change and hence
>>>> + * needs to be measured again. To enable this, pass a unique "event_name"
>>>> + * to the IMA hook so that IMA subsystem will always measure the given data.
>>>> + *
>>>> + * For example,
>>>> + * At time T0 SELinux data to be measured is "foo". IMA measures it.
>>>> + * At time T1 the data is changed to "bar". IMA measures it.
>>>> + * At time T2 the data is changed to "foo" again. IMA will not measure it
>>>> + * (since it was already measured) unless the event_name, for instance,
>>>> + * is different in this call.
>>>> + */
>>>> +static char *selinux_event_name(const char *name_prefix)
>>>> +{
>>>> +       struct timespec64 cur_time;
>>>> +
>>>> +       ktime_get_real_ts64(&cur_time);
>>>> +       return kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
>>>> +                        cur_time.tv_sec, cur_time.tv_nsec);
>>>> +}
>>>
>>> Why is this a separate function?  It's three lines long and only
>>> called from selinux_measure_state().  Do you ever see the SELinux/IMA
>>> code in this file expanding to the point where this function is nice
>>> from a reuse standpoint?
>>
>> Earlier I had two measurements - one for SELinux configuration/state and
>> another for SELinux policy. selinux_event_name() was used to generate
>> event name for each of them.
>>
>> In this patch set I have included only one measurement - for SELinux
>> policy. I plan to add "SELinux configuration/state" measurement in a
>> separate patch - I can reuse selinux_event_name() in that patch.
> 
> I'm curious about this second measurement.  My apologies if you posted
> it previously, this patchset has gone through several iterations and
> simply can't recall all the different versions without digging through
> the list archives.
> 

The 2nd measurement is for SELinux state data such as "enforcing", 
"checkreqprot", policycap[__POLICYDB_CAPABILITY_MAX], etc.

> Is there a reason why the second measurement isn't included in this
> patch?  Or this patchset if it is too big to be a single patch?
> 

For illustrating the use of the new IMA hook, that my colleague Tushar 
has added for measuring kernel critical data, we have included only one 
SELinux measurement in this patch set - the measurement of SELinux 
policy. This also helped in keeping this patch smaller.

When this patch set is merged, I'll post a separate patch to add 
measurement of SELinux state data I have mentioned above.

>> Also, I think the comment in the function header for
>> selinux_event_name() is useful.
>>
>> I prefer to have a separate function, if that's fine by you.
> 
> Given just this patch I would prefer if you folded
> selinux_event_name() into selinux_measure_state().  However, I agree
> with you that the comments in the selinux_event_name() header block is
> useful, I would suggest moving those into the body of
> selinux_measure_state() directly above the calls to
> ktime_get_real_ts64() and kasprintf().

Sure - I will make that change.

> 
>>> Also, I assume you are not concerned about someone circumventing the
>>> IMA measurements by manipulating the time?  In most systems I would
>>> expect the time to be a protected entity, but with many systems
>>> getting their time from remote systems I thought it was worth
>>> mentioning.
>>
>> I am using time function to generate a unique name for the IMA
>> measurement event, such as, "selinux-policy-hash-1609790281:860232824".
>> This is to ensure that state changes in SELinux data are always measured.
>>
>> If you think time manipulation can be an issue, please let me know a
>> better way to generate unique event names.
> 
> Yes, I understand that you are using the time value as a way of
> ensuring you always have a different event name and hence a new
> measurement.  However, I was wondering if you would be okay if the
> time was adjusted such that an event name was duplicated and a
> measurement missed?  Is that a problem for you?  It seems like it
> might be an issue, but you and Mimi know IMA better than I do.

If the system time was adjusted such that the event name is duplicated, 
we could miss measurements - this is not okay.

For example:
  #1 Say, at time T1 SELinux state being measured is "foo" - IMA will 
measure it.
  #2 at time T2, the state changes to "bar" - IMA will measure it
  #3 at time T3, the state changes from "bar" to "foo" again. Unless the 
"event name" passed in the measurement call is different from what was 
passed in step #1, IMA will not measure it and hence we'll miss the 
state change.

If system time can be manipulated to return the same "timer tick" on 
every call to ktime_get_real_ts64(), we will lose measurement in Step #3 
above.

But given that we are using ktime_get_real_ts64() to get the timer tick, 
is it possible to manipulate the system time without compromising the 
overall functioning of the rest of the system? If yes, then it is an 
issue - I mean, there is a possibility of losing some measurements.

> 
>>>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
>>>> index 9704c8a32303..dfa2e00894ae 100644
>>>> --- a/security/selinux/ss/services.c
>>>> +++ b/security/selinux/ss/services.c
>>>> @@ -3875,8 +3876,33 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
>>>>    }
>>>>    #endif /* CONFIG_NETLABEL */
>>>>
>>>> +/**
>>>> + * security_read_selinux_policy - read the policy.
>>>> + * @policy: SELinux policy
>>>> + * @data: binary policy data
>>>> + * @len: length of data in bytes
>>>> + *
>>>> + */
>>>> +static int security_read_selinux_policy(struct selinux_policy *policy,
>>>> +                                       void *data, size_t *len)
>>>
>>> Let's just call this "security_read_policy()".
>> There is another function in this file with the name security_read_policy().
>>
>> How about changing the above function name to "read_selinux_policy()"
>> since this is a local/static function.
> 
> Ooops, sorry about that!  I'm not sure what I was thinking there :)
> 
> How about "__security_read_policy()"?
> 

Sure - I will change the function name to "__security_read_policy()".

thanks,
  -lakshmi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

