Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9A2C433E9
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB6D422225
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB6D422225
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-GvAQxeVaPe6lzV_SSNVy6Q-1; Mon, 04 Jan 2021 14:03:46 -0500
X-MC-Unique: GvAQxeVaPe6lzV_SSNVy6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEC0B100C615;
	Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D30A0614F5;
	Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A617F1809CA8;
	Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNLAkdC004230 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 16:10:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E8D871134CC7; Wed, 23 Dec 2020 21:10:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E47471134CC3
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:10:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E94D186E120
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:10:43 +0000 (UTC)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com
	[209.85.208.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-334-6ZrMcdK4MdyXTuaT2ubV4A-1; Wed, 23 Dec 2020 16:10:41 -0500
X-MC-Unique: 6ZrMcdK4MdyXTuaT2ubV4A-1
Received: by mail-ed1-f47.google.com with SMTP id u19so490069edx.2
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 13:10:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=Uawmuf30g8hFwJC27vRaIVBzmTPClIdro7xuWf9Sm78=;
	b=a60cVLgDPNUCyC+VOuOv0OCuReumskDmMi9h6iJVNDxzJAbWn3WwO4Yneziip7HfI/
	deHtgd1poUEW9zXtayDyc6WpPyliU/u+HimnD1VlWYmXZEODHSOAW4DXO5YRnHbXQ/sO
	i3qHoYzJDb0Em1vUo1jDpQu8u6mOzE90y9HL+WKfSwWQbROsvDhjzGhK5GYmMxFjiNgy
	+g6h2xr7piVTXuo/m6SvgzY7BjjizB7t31OqyJ4KVNYVXXgXUgJ0xSmOcybds3ht9U3U
	ojfajBvoxDSwZ9D8rbaULEDzFmS6teNmdosAfXdnYWVwX65mTaCbKfBgirW1t1z7kSei
	a9Lw==
X-Gm-Message-State: AOAM533AIKtLmE5ntimsUnJAEg+wGN0NWmBkDg7Ogop693L9A5IT1Q4F
	puyJziR9BjZesPPV5B/G325y3t/4Ypw4b43E/sZZ
X-Google-Smtp-Source: ABdhPJwDgd5vJjHNoYvW6djLXniqbUaSdL2T70zxwf8HHr0zlEHG3Y5JtpuVE8PoB63cYTHQgTDHwgNYF4vQ9gmJcio=
X-Received: by 2002:aa7:c0d6:: with SMTP id j22mr26211419edp.31.1608757839451; 
	Wed, 23 Dec 2020 13:10:39 -0800 (PST)
MIME-Version: 1.0
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-9-tusharsu@linux.microsoft.com>
In-Reply-To: <20201212180251.9943-9-tusharsu@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 23 Dec 2020 16:10:28 -0500
Message-ID: <CAHC9VhSao7DGtskbDMax8hN+PhQr8homFXUGjm+c7NtEUCtKhg@mail.gmail.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, snitzer@redhat.com,
	selinux@vger.kernel.org, Stephen Smalley <stephen.smalley.work@gmail.com>,
	James Morris <jmorris@namei.org>, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Dec 12, 2020 at 1:03 PM Tushar Sugandhi
<tusharsu@linux.microsoft.com> wrote:
> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
>
> SELinux stores the active policy in memory, so the changes to this data
> at runtime would have an impact on the security guarantees provided
> by SELinux. Measuring in-memory SELinux policy through IMA subsystem
> provides a secure way for the attestation service to remotely validate
> the policy contents at runtime.
>
> Measure the hash of the loaded policy by calling the IMA hook
> ima_measure_critical_data(). Since the size of the loaded policy can
> be large (several MB), measure the hash of the policy instead of
> the entire policy to avoid bloating the IMA log entry.
>
> Add "selinux" to the list of supported data sources maintained by IMA
> to enable measuring SELinux data.
>
> To enable SELinux data measurement, the following steps are required:
>
> 1, Add "ima_policy=critical_data" to the kernel command line arguments
>    to enable measuring SELinux data at boot time.
> For example,
>   BOOT_IMAGE=/boot/vmlinuz-5.10.0-rc1+ root=UUID=fd643309-a5d2-4ed3-b10d-3c579a5fab2f ro nomodeset security=selinux ima_policy=critical_data
>
> 2, Add the following rule to /etc/ima/ima-policy
>    measure func=CRITICAL_DATA data_source=selinux
>
> Sample measurement of the hash of SELinux policy:
>
> To verify the measured data with the current SELinux policy run
> the following commands and verify the output hash values match.
>
>   sha256sum /sys/fs/selinux/policy | cut -d' ' -f 1
>
>   grep "selinux-policy-hash" /sys/kernel/security/integrity/ima/ascii_runtime_measurements | tail -1 | cut -d' ' -f 6
>
> Note that the actual verification of SELinux policy would require loading
> the expected policy into an identical kernel on a pristine/known-safe
> system and run the sha256sum /sys/kernel/selinux/policy there to get
> the expected hash.
>
> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
>  Documentation/ABI/testing/ima_policy |  3 +-
>  security/selinux/Makefile            |  2 +
>  security/selinux/include/security.h  | 11 +++-
>  security/selinux/measure.c           | 79 ++++++++++++++++++++++++++++
>  security/selinux/ss/services.c       | 71 +++++++++++++++++++++----
>  5 files changed, 155 insertions(+), 11 deletions(-)
>  create mode 100644 security/selinux/measure.c

...

> diff --git a/security/selinux/Makefile b/security/selinux/Makefile
> index 4d8e0e8adf0b..83d512116341 100644
> --- a/security/selinux/Makefile
> +++ b/security/selinux/Makefile
> @@ -16,6 +16,8 @@ selinux-$(CONFIG_NETLABEL) += netlabel.o
>
>  selinux-$(CONFIG_SECURITY_INFINIBAND) += ibpkey.o
>
> +selinux-$(CONFIG_IMA) += measure.o

Naming things is hard, I get that, but I would prefer if we just
called this file "ima.c" or something similar.  The name "measure.c"
implies a level of abstraction or general use which simply doesn't
exist here.  Let's help make it a bit more obvious what should belong
in this file.

> diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
> index 3cc8bab31ea8..18ee65c98446 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -229,7 +229,8 @@ void selinux_policy_cancel(struct selinux_state *state,
>                         struct selinux_policy *policy);
>  int security_read_policy(struct selinux_state *state,
>                          void **data, size_t *len);
> -
> +int security_read_policy_kernel(struct selinux_state *state,
> +                               void **data, size_t *len);
>  int security_policycap_supported(struct selinux_state *state,
>                                  unsigned int req_cap);
>
> @@ -446,4 +447,12 @@ extern void ebitmap_cache_init(void);
>  extern void hashtab_cache_init(void);
>  extern int security_sidtab_hash_stats(struct selinux_state *state, char *page);
>
> +#ifdef CONFIG_IMA
> +extern void selinux_measure_state(struct selinux_state *selinux_state);
> +#else
> +static inline void selinux_measure_state(struct selinux_state *selinux_state)
> +{
> +}
> +#endif

If you are going to put the SELinux/IMA function(s) into a separate
source file, please put the function declarations into a separate
header file too.  For example, look at
security/selinux/include/{netif,netnode,netport,etc.}.h.

> diff --git a/security/selinux/measure.c b/security/selinux/measure.c
> new file mode 100644
> index 000000000000..b7e24358e11d
> --- /dev/null
> +++ b/security/selinux/measure.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Measure SELinux state using IMA subsystem.
> + */
> +#include <linux/vmalloc.h>
> +#include <linux/ktime.h>
> +#include <linux/ima.h>
> +#include "security.h"
> +
> +/*
> + * This function creates a unique name by appending the timestamp to
> + * the given string. This string is passed as "event_name" to the IMA
> + * hook to measure the given SELinux data.
> + *
> + * The data provided by SELinux to the IMA subsystem for measuring may have
> + * already been measured (for instance the same state existed earlier).
> + * But for SELinux the current data represents a state change and hence
> + * needs to be measured again. To enable this, pass a unique "event_name"
> + * to the IMA hook so that IMA subsystem will always measure the given data.
> + *
> + * For example,
> + * At time T0 SELinux data to be measured is "foo". IMA measures it.
> + * At time T1 the data is changed to "bar". IMA measures it.
> + * At time T2 the data is changed to "foo" again. IMA will not measure it
> + * (since it was already measured) unless the event_name, for instance,
> + * is different in this call.
> + */
> +static char *selinux_event_name(const char *name_prefix)
> +{
> +       struct timespec64 cur_time;
> +
> +       ktime_get_real_ts64(&cur_time);
> +       return kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
> +                        cur_time.tv_sec, cur_time.tv_nsec);
> +}

Why is this a separate function?  It's three lines long and only
called from selinux_measure_state().  Do you ever see the SELinux/IMA
code in this file expanding to the point where this function is nice
from a reuse standpoint?

Also, I assume you are not concerned about someone circumventing the
IMA measurements by manipulating the time?  In most systems I would
expect the time to be a protected entity, but with many systems
getting their time from remote systems I thought it was worth
mentioning.

> +/*
> + * selinux_measure_state - Measure hash of the SELinux policy
> + *
> + * @state: selinux state struct
> + *
> + * NOTE: This function must be called with policy_mutex held.
> + */
> +void selinux_measure_state(struct selinux_state *state)

Similar to the name of this source file, let's make it clear this is
for IMA.  How about calling this selinux_ima_measure_state() or
similar?

> +{
> +       void *policy = NULL;
> +       char *policy_event_name = NULL;
> +       size_t policy_len;
> +       int rc = 0;
> +       bool initialized = selinux_initialized(state);

Why bother with the initialized variable?  Unless I'm missing
something it is only used once in the code below.

> +       /*
> +        * Measure SELinux policy only after initialization is completed.
> +        */
> +       if (!initialized)
> +               goto out;
> +
> +       policy_event_name = selinux_event_name("selinux-policy-hash");
> +       if (!policy_event_name) {
> +               pr_err("SELinux: %s: event name for policy not allocated.\n",
> +                      __func__);
> +               rc = -ENOMEM;

This function doesn't return an error code, why bother with setting
the rc variable here?

> +               goto out;
> +       }
> +
> +       rc = security_read_policy_kernel(state, &policy, &policy_len);
> +       if (rc) {
> +               pr_err("SELinux: %s: failed to read policy %d.\n", __func__, rc);
> +               goto out;
> +       }
> +
> +       ima_measure_critical_data("selinux", policy_event_name,
> +                                 policy, policy_len, true);
> +
> +       vfree(policy);
> +
> +out:
> +       kfree(policy_event_name);
> +}
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 9704c8a32303..dfa2e00894ae 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2180,6 +2180,7 @@ static void selinux_notify_policy_change(struct selinux_state *state,
>         selinux_status_update_policyload(state, seqno);
>         selinux_netlbl_cache_invalidate();
>         selinux_xfrm_notify_policyload();
> +       selinux_measure_state(state);
>  }
>
>  void selinux_policy_commit(struct selinux_state *state,
> @@ -3875,8 +3876,33 @@ int security_netlbl_sid_to_secattr(struct selinux_state *state,
>  }
>  #endif /* CONFIG_NETLABEL */
>
> +/**
> + * security_read_selinux_policy - read the policy.
> + * @policy: SELinux policy
> + * @data: binary policy data
> + * @len: length of data in bytes
> + *
> + */
> +static int security_read_selinux_policy(struct selinux_policy *policy,
> +                                       void *data, size_t *len)

Let's just call this "security_read_policy()".

> +{
> +       int rc;
> +       struct policy_file fp;
> +
> +       fp.data = data;
> +       fp.len = *len;
> +
> +       rc = policydb_write(&policy->policydb, &fp);
> +       if (rc)
> +               return rc;
> +
> +       *len = (unsigned long)fp.data - (unsigned long)data;
> +       return 0;
> +}
> +
>  /**
>   * security_read_policy - read the policy.
> + * @state: selinux_state
>   * @data: binary policy data
>   * @len: length of data in bytes
>   *
> @@ -3885,8 +3911,6 @@ int security_read_policy(struct selinux_state *state,
>                          void **data, size_t *len)
>  {
>         struct selinux_policy *policy;
> -       int rc;
> -       struct policy_file fp;
>
>         policy = rcu_dereference_protected(
>                         state->policy, lockdep_is_held(&state->policy_mutex));
> @@ -3898,14 +3922,43 @@ int security_read_policy(struct selinux_state *state,
>         if (!*data)> --
> 2.17.1
>

>                 return -ENOMEM;
>
> -       fp.data = *data;
> -       fp.len = *len;
> +       return security_read_selinux_policy(policy, *data, len);
> +}
>
> -       rc = policydb_write(&policy->policydb, &fp);
> -       if (rc)
> -               return rc;
> +/**
> + * security_read_policy_kernel - read the policy.
> + * @state: selinux_state
> + * @data: binary policy data
> + * @len: length of data in bytes
> + *
> + * Allocates kernel memory for reading SELinux policy.
> + * This function is for internal use only and should not
> + * be used for returning data to user space.
> + *
> + * This function must be called with policy_mutex held.
> + */
> +int security_read_policy_kernel(struct selinux_state *state,
> +                               void **data, size_t *len)

Let's call this "security_read_state_kernel()".

> +{
> +       struct selinux_policy *policy;
> +       int rc = 0;

See below, the rc variable is not needed.

> -       *len = (unsigned long)fp.data - (unsigned long)*data;
> -       return 0;
> +       policy = rcu_dereference_protected(
> +                       state->policy, lockdep_is_held(&state->policy_mutex));
> +       if (!policy) {
> +               rc = -EINVAL;
> +               goto out;

Jumping to the out label is a little silly since it is just a return;
do a "return -EINVAL;" here instead.

> +       }
> +
> +       *len = policy->policydb.len;
> +       *data = vmalloc(*len);
> +       if (!*data) {
> +               rc = -ENOMEM;
> +               goto out;

Same as above, "return -ENOMEM;" please.

> +       }
>
> +       rc = security_read_selinux_policy(policy, *data, len);

You should be able to do "return security_read_selinux_policy(...);" here.

> +
> +out:
> +       return rc;
>  }

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

