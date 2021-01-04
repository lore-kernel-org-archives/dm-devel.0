Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7D0C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 08:38:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7BD68224F9
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 08:38:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BD68224F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-m81htgd2MJGyyUmc49LDYA-1; Tue, 05 Jan 2021 03:38:14 -0500
X-MC-Unique: m81htgd2MJGyyUmc49LDYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42C6E57240;
	Tue,  5 Jan 2021 08:38:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 240B1669FC;
	Tue,  5 Jan 2021 08:38:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 812F04E58E;
	Tue,  5 Jan 2021 08:38:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104NUstj016290 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 18:30:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 892081111C64; Mon,  4 Jan 2021 23:30:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84BF41111C62
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 23:30:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F1E3803DCE
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 23:30:52 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-516-EMaKScFoMdK1Wwu4Rulz_w-1;
	Mon, 04 Jan 2021 18:30:48 -0500
X-MC-Unique: EMaKScFoMdK1Wwu4Rulz_w-1
Received: from [192.168.0.104] (c-73-42-176-67.hsd1.wa.comcast.net
	[73.42.176.67])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1A58120B7192;
	Mon,  4 Jan 2021 15:30:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1A58120B7192
To: Paul Moore <paul@paul-moore.com>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSao7DGtskbDMax8hN+PhQr8homFXUGjm+c7NtEUCtKhg@mail.gmail.com>
From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <2dce2244-adbd-df2a-e890-271bbcc8f9f2@linux.microsoft.com>
Date: Mon, 4 Jan 2021 15:30:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSao7DGtskbDMax8hN+PhQr8homFXUGjm+c7NtEUCtKhg@mail.gmail.com>
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
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, casey@schaufler-ca.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/23/20 1:10 PM, Paul Moore wrote:

Hi Paul,

> ...
> 
>> diff --git a/security/selinux/Makefile b/security/selinux/Makefile
>> index 4d8e0e8adf0b..83d512116341 100644
>> --- a/security/selinux/Makefile
>> +++ b/security/selinux/Makefile
>> @@ -16,6 +16,8 @@ selinux-$(CONFIG_NETLABEL) += netlabel.o
>>
>>   selinux-$(CONFIG_SECURITY_INFINIBAND) += ibpkey.o
>>
>> +selinux-$(CONFIG_IMA) += measure.o
> 
> Naming things is hard, I get that, but I would prefer if we just
> called this file "ima.c" or something similar.  The name "measure.c"
> implies a level of abstraction or general use which simply doesn't
> exist here.  Let's help make it a bit more obvious what should belong
> in this file.
Agreed - I will rename the file to ima.c

> 
>> diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
>> index 3cc8bab31ea8..18ee65c98446 100644
>> --- a/security/selinux/include/security.h
>> +++ b/security/selinux/include/security.h
>> @@ -229,7 +229,8 @@ void selinux_policy_cancel(struct selinux_state *state,
>>                          struct selinux_policy *policy);
>>   int security_read_policy(struct selinux_state *state,
>>                           void **data, size_t *len);
>> -
>> +int security_read_policy_kernel(struct selinux_state *state,
>> +                               void **data, size_t *len);
>>   int security_policycap_supported(struct selinux_state *state,
>>                                   unsigned int req_cap);
>>
>> @@ -446,4 +447,12 @@ extern void ebitmap_cache_init(void);
>>   extern void hashtab_cache_init(void);
>>   extern int security_sidtab_hash_stats(struct selinux_state *state, char *page);
>>
>> +#ifdef CONFIG_IMA
>> +extern void selinux_measure_state(struct selinux_state *selinux_state);
>> +#else
>> +static inline void selinux_measure_state(struct selinux_state *selinux_state)
>> +{
>> +}
>> +#endif
> 
> If you are going to put the SELinux/IMA function(s) into a separate
> source file, please put the function declarations into a separate
> header file too.  For example, look at
> security/selinux/include/{netif,netnode,netport,etc.}.h.

I will create a new header file "security/selinux/include/ima.h" and 
move the function declarations for IMA functions to that header.

> 
>> diff --git a/security/selinux/measure.c b/security/selinux/measure.c
>> new file mode 100644
>> index 000000000000..b7e24358e11d
>> --- /dev/null
>> +++ b/security/selinux/measure.c
>> @@ -0,0 +1,79 @@
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
>> +       struct timespec64 cur_time;
>> +
>> +       ktime_get_real_ts64(&cur_time);
>> +       return kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
>> +                        cur_time.tv_sec, cur_time.tv_nsec);
>> +}
> 
> Why is this a separate function?  It's three lines long and only
> called from selinux_measure_state().  Do you ever see the SELinux/IMA
> code in this file expanding to the point where this function is nice
> from a reuse standpoint?

Earlier I had two measurements - one for SELinux configuration/state and 
another for SELinux policy. selinux_event_name() was used to generate 
event name for each of them.

In this patch set I have included only one measurement - for SELinux 
policy. I plan to add "SELinux configuration/state" measurement in a 
separate patch - I can reuse selinux_event_name() in that patch.

Also, I think the comment in the function header for 
selinux_event_name() is useful.

I prefer to have a separate function, if that's fine by you.

> 
> Also, I assume you are not concerned about someone circumventing the
> IMA measurements by manipulating the time?  In most systems I would
> expect the time to be a protected entity, but with many systems
> getting their time from remote systems I thought it was worth
> mentioning.
I am using time function to generate a unique name for the IMA 
measurement event, such as, "selinux-policy-hash-1609790281:860232824". 
This is to ensure that state changes in SELinux data are always measured.

If you think time manipulation can be an issue, please let me know a 
better way to generate unique event names.

> 
>> +/*
>> + * selinux_measure_state - Measure hash of the SELinux policy
>> + *
>> + * @state: selinux state struct
>> + *
>> + * NOTE: This function must be called with policy_mutex held.
>> + */
>> +void selinux_measure_state(struct selinux_state *state)
> 
> Similar to the name of this source file, let's make it clear this is
> for IMA.  How about calling this selinux_ima_measure_state() or
> similar?
Sure - I will change the function name to selinux_ima_measure_state().

> 
>> +{
>> +       void *policy = NULL;
>> +       char *policy_event_name = NULL;
>> +       size_t policy_len;
>> +       int rc = 0;
>> +       bool initialized = selinux_initialized(state);
> 
> Why bother with the initialized variable?  Unless I'm missing
> something it is only used once in the code below.
You are right - I will remove "initialized" variable and directly get 
the state using selinux_initialized().

> 
>> +       /*
>> +        * Measure SELinux policy only after initialization is completed.
>> +        */
>> +       if (!initialized)
>> +               goto out;
>> +
>> +       policy_event_name = selinux_event_name("selinux-policy-hash");
>> +       if (!policy_event_name) {
>> +               pr_err("SELinux: %s: event name for policy not allocated.\n",
>> +                      __func__);
>> +               rc = -ENOMEM;
> 
> This function doesn't return an error code, why bother with setting
> the rc variable here?
Yes - it is not necessary. I will remove the line.

> 
>> +               goto out;
>> +       }
>> +
>> +       rc = security_read_policy_kernel(state, &policy, &policy_len);
>> +       if (rc) {
>> +               pr_err("SELinux: %s: failed to read policy %d.\n", __func__, rc);
>> +               goto out;
>> +       }
>> +
>> +       ima_measure_critical_data("selinux", policy_event_name,
>> +                                 policy, policy_len, true);
>> +
>> +       vfree(policy);
>> +
>> +out:
>> +       kfree(policy_event_name);
>> +}
>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
>> index 9704c8a32303..dfa2e00894ae 100644
>> --- a/security/selinux/ss/services.c
>> +++ b/security/selinux/ss/services.c
>> @@ -2180,6 +2180,7 @@ static void selinux_notify_policy_change(struct selinux_state *state,
>>          selinux_status_update_policyload(state, seqno);
>>          selinux_netlbl_cache_invalidate();
>>          selinux_xfrm_notify_policyload();
>> +       selinux_measure_state(state);
>>   }
>>
>>   void selinux_policy_commit(struct selinux_state *state,
>> @@ -3875,8 +3876,33 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
>>   }
>>   #endif /* CONFIG_NETLABEL */
>>
>> +/**
>> + * security_read_selinux_policy - read the policy.
>> + * @policy: SELinux policy
>> + * @data: binary policy data
>> + * @len: length of data in bytes
>> + *
>> + */
>> +static int security_read_selinux_policy(struct selinux_policy *policy,
>> +                                       void *data, size_t *len)
> 
> Let's just call this "security_read_policy()".
There is another function in this file with the name security_read_policy().

How about changing the above function name to "read_selinux_policy()" 
since this is a local/static function.

> 
>> +{
>> +       int rc;
>> +       struct policy_file fp;
>> +
>> +       fp.data = data;
>> +       fp.len = *len;
>> +
>> +       rc = policydb_write(&policy->policydb, &fp);
>> +       if (rc)
>> +               return rc;
>> +
>> +       *len = (unsigned long)fp.data - (unsigned long)data;
>> +       return 0;
>> +}
>> +
>>   /**
>>    * security_read_policy - read the policy.
>> + * @state: selinux_state
>>    * @data: binary policy data
>>    * @len: length of data in bytes
>>    *
>> @@ -3885,8 +3911,6 @@ int security_read_policy(struct selinux_state *state,
>>                           void **data, size_t *len)
>>   {
>>          struct selinux_policy *policy;
>> -       int rc;
>> -       struct policy_file fp;
>>
>>          policy = rcu_dereference_protected(
>>                          state->policy, lockdep_is_held(&state->policy_mutex));
>> @@ -3898,14 +3922,43 @@ int security_read_policy(struct selinux_state *state,
>>          if (!*data)> --
>> 2.17.1
>>
> 
>>                  return -ENOMEM;
>>
>> -       fp.data = *data;
>> -       fp.len = *len;
>> +       return security_read_selinux_policy(policy, *data, len);
>> +}
>>
>> -       rc = policydb_write(&policy->policydb, &fp);
>> -       if (rc)
>> -               return rc;
>> +/**
>> + * security_read_policy_kernel - read the policy.
>> + * @state: selinux_state
>> + * @data: binary policy data
>> + * @len: length of data in bytes
>> + *
>> + * Allocates kernel memory for reading SELinux policy.
>> + * This function is for internal use only and should not
>> + * be used for returning data to user space.
>> + *
>> + * This function must be called with policy_mutex held.
>> + */
>> +int security_read_policy_kernel(struct selinux_state *state,
>> +                               void **data, size_t *len)
> 
> Let's call this "security_read_state_kernel()".
Sure - I will rename the function.

> 
>> +{
>> +       struct selinux_policy *policy;
>> +       int rc = 0;
> 
> See below, the rc variable is not needed.
> 
>> -       *len = (unsigned long)fp.data - (unsigned long)*data;
>> -       return 0;
>> +       policy = rcu_dereference_protected(
>> +                       state->policy, lockdep_is_held(&state->policy_mutex));
>> +       if (!policy) {
>> +               rc = -EINVAL;
>> +               goto out;
> 
> Jumping to the out label is a little silly since it is just a return;
> do a "return -EINVAL;" here instead.
> 
>> +       }
>> +
>> +       *len = policy->policydb.len;
>> +       *data = vmalloc(*len);
>> +       if (!*data) {
>> +               rc = -ENOMEM;
>> +               goto out;
> 
> Same as above, "return -ENOMEM;" please.
> 
>> +       }
>>
>> +       rc = security_read_selinux_policy(policy, *data, len);
> 
> You should be able to do "return security_read_selinux_policy(...);" here.

I will remove the local variable "rc" and make the three changes you've 
stated above.

Thanks for reviewing the changes.

  -lakshmi

> 
>> +
>> +out:
>> +       return rc;
>>   }
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

