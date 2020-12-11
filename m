Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B63C2BB40
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:00:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3134022BEF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3134022BEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-lYzWtGS_NlOm3-meEOOLRQ-1; Mon, 14 Dec 2020 06:00:36 -0500
X-MC-Unique: lYzWtGS_NlOm3-meEOOLRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0FF1801B13;
	Mon, 14 Dec 2020 11:00:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54AFC60C05;
	Mon, 14 Dec 2020 11:00:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C4DB74E58F;
	Mon, 14 Dec 2020 11:00:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBFab56011954 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 10:36:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 63B532166B2A; Fri, 11 Dec 2020 15:36:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EB822166B29
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 15:36:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09709811E87
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 15:36:35 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-425-wWM0pTjcN4O92UAQ5epzHw-1;
	Fri, 11 Dec 2020 10:36:30 -0500
X-MC-Unique: wWM0pTjcN4O92UAQ5epzHw-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id BACDD20B717A;
	Fri, 11 Dec 2020 07:36:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BACDD20B717A
Date: Fri, 11 Dec 2020 09:36:18 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201211153618.GA4951@sequoia>
References: <20201209194212.5131-1-tusharsu@linux.microsoft.com>
	<20201209194212.5131-9-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201209194212.5131-9-tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v7 8/8] selinux: include a consumer of the
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020-12-09 11:42:12, Tushar Sugandhi wrote:
> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> 
> IMA measures files and buffer data such as keys, command line arguments
> passed to the kernel on kexec system call, etc. While these measurements
> enable monitoring and validating the integrity of the system, it is not
> sufficient. Various data structures, policies and states stored in kernel
> memory also impact the integrity of the system. Updates to these data
> structures would have an impact on the security functionalities.

This is repetitive when looking at the entire series. I think it can be
dropped.

> For example, SELinux stores the active policy in memory. Changes to this

Start here and drop the "For example, ":

 SELinux stores the active policy in memory and changes to this data ...

> data at runtime would have an impact on the security guarantees provided
> by SELinux. Measuring such in-memory data structures through IMA
> subsystem provides a secure way for a remote attestation service to
> know the state of the system and also the runtime changes in the state
> of the system.
> 
> SELinux policy is a critical data for this security module that needs

 SELinux policy is critical data and should be measured. This measurement ...

> to be measured. This measurement can be used by an attestation service,
> for instance, to verify if the policy has been setup correctly and that
> it hasn't been tampered at run-time.
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
> ---
>  Documentation/ABI/testing/ima_policy |  3 +-
>  security/selinux/Makefile            |  2 +
>  security/selinux/include/security.h  | 11 +++-
>  security/selinux/measure.c           | 86 ++++++++++++++++++++++++++++
>  security/selinux/ss/services.c       | 71 ++++++++++++++++++++---
>  5 files changed, 162 insertions(+), 11 deletions(-)
>  create mode 100644 security/selinux/measure.c
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 0f4ee9e0a455..7c7023f7986b 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -52,8 +52,9 @@ Description:
>  			template:= name of a defined IMA template type
>  			(eg, ima-ng). Only valid when action is "measure".
>  			pcr:= decimal value
> -			data_source:= [label]
> +			data_source:= [selinux]|[label]
>  			label:= a unique string used for grouping and limiting critical data.
> +			For example, "selinux" to measure critical data for SELinux.
>  
>  		  default policy:
>  			# PROC_SUPER_MAGIC
> diff --git a/security/selinux/Makefile b/security/selinux/Makefile
> index 4d8e0e8adf0b..83d512116341 100644
> --- a/security/selinux/Makefile
> +++ b/security/selinux/Makefile
> @@ -16,6 +16,8 @@ selinux-$(CONFIG_NETLABEL) += netlabel.o
>  
>  selinux-$(CONFIG_SECURITY_INFINIBAND) += ibpkey.o
>  
> +selinux-$(CONFIG_IMA) += measure.o
> +
>  ccflags-y := -I$(srctree)/security/selinux -I$(srctree)/security/selinux/include
>  
>  $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
> diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
> index 3cc8bab31ea8..18ee65c98446 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -229,7 +229,8 @@ void selinux_policy_cancel(struct selinux_state *state,
>  			struct selinux_policy *policy);
>  int security_read_policy(struct selinux_state *state,
>  			 void **data, size_t *len);
> -
> +int security_read_policy_kernel(struct selinux_state *state,
> +				void **data, size_t *len);
>  int security_policycap_supported(struct selinux_state *state,
>  				 unsigned int req_cap);
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
> +
>  #endif /* _SELINUX_SECURITY_H_ */
> diff --git a/security/selinux/measure.c b/security/selinux/measure.c
> new file mode 100644
> index 000000000000..c409ada6ea39
> --- /dev/null
> +++ b/security/selinux/measure.c
> @@ -0,0 +1,86 @@
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
> +	char *event_name = NULL;
> +	struct timespec64 cur_time;
> +
> +	ktime_get_real_ts64(&cur_time);
> +	event_name = kasprintf(GFP_KERNEL, "%s-%lld:%09ld", name_prefix,
> +			       cur_time.tv_sec, cur_time.tv_nsec);
> +	if (!event_name) {
> +		pr_err("%s: event name not allocated.\n", __func__);
> +		return NULL;
> +	}
> +
> +	return event_name;
> +}
> +
> +/*
> + * selinux_measure_state - Measure hash of the SELinux policy
> + *
> + * @state: selinux state struct
> + *
> + * NOTE: This function must be called with policy_mutex held.
> + */
> +void selinux_measure_state(struct selinux_state *state)
> +{
> +	void *policy = NULL;
> +	char *policy_event_name = NULL;
> +	size_t policy_len;
> +	int rc = 0;
> +	bool initialized = selinux_initialized(state);
> +
> +	/*
> +	 * Measure SELinux policy only after initialization is completed.
> +	 */
> +	if (!initialized)
> +		goto out;
> +
> +	policy_event_name = selinux_event_name("selinux-policy-hash");
> +	if (!policy_event_name) {
> +		pr_err("%s: Event name for policy not allocated.\n",
> +		       __func__);

If the kasprintf() in selinux_event_name() fails, we'll get two similar
error messages saying that the event name could not be allocated. One of
these error messages can be removed.

> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	rc = security_read_policy_kernel(state, &policy, &policy_len);
> +	if (rc) {
> +		pr_err("%s: Failed to read policy %d.\n", __func__, rc);

The calls to pr_err() in this aren't quite following the style of the
other error SELinux error messages.

 $ git grep pr_err security/selinux
 security/selinux/hooks.c:               pr_err("SELinux:  out of range capability %d\n", cap);
 security/selinux/hooks.c:               pr_err("SELinux:  unable to map context to SID"
 security/selinux/netlink.c:     pr_err("SELinux:  OOM in %s\n", __func__);
 security/selinux/selinuxfs.c:   pr_err("SELinux:  Runtime disable is deprecated, use selinux=0 on the kernel cmdline.\n");
 security/selinux/selinuxfs.c:           pr_err("SELinux: failed to load policy booleans\n");
 security/selinux/selinuxfs.c:           pr_err("SELinux: failed to load policy classes\n");
 ...
 security/selinux/ss/services.c:         pr_err("SELinux: %s:  unrecognized SID %d\n",
 security/selinux/ss/services.c:         pr_err("SELinux: %s:  unrecognized SID %d\n",
 security/selinux/ss/services.c:         pr_err("SELinux: %s:  unrecognized SID %d\n",
 security/selinux/ss/services.c:         pr_err("SELinux: %s:  unrecognized SID %d\n",
 security/selinux/ss/services.c:         pr_err("SELinux: %s:  unrecognized class %s\n",

Prepending your error message strings with "SELinux: " and lowercasing the
first character after "%s: " ought to do it.


All the other code changes in this patch look correct to me.

Tyler


> +		goto out;
> +	}
> +
> +	ima_measure_critical_data("selinux", policy_event_name,
> +				  policy, policy_len, true);
> +
> +	vfree(policy);
> +
> +out:
> +	kfree(policy_event_name);
> +}
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 9704c8a32303..dfa2e00894ae 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2180,6 +2180,7 @@ static void selinux_notify_policy_change(struct selinux_state *state,
>  	selinux_status_update_policyload(state, seqno);
>  	selinux_netlbl_cache_invalidate();
>  	selinux_xfrm_notify_policyload();
> +	selinux_measure_state(state);
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
> +					void *data, size_t *len)
> +{
> +	int rc;
> +	struct policy_file fp;
> +
> +	fp.data = data;
> +	fp.len = *len;
> +
> +	rc = policydb_write(&policy->policydb, &fp);
> +	if (rc)
> +		return rc;
> +
> +	*len = (unsigned long)fp.data - (unsigned long)data;
> +	return 0;
> +}
> +
>  /**
>   * security_read_policy - read the policy.
> + * @state: selinux_state
>   * @data: binary policy data
>   * @len: length of data in bytes
>   *
> @@ -3885,8 +3911,6 @@ int security_read_policy(struct selinux_state *state,
>  			 void **data, size_t *len)
>  {
>  	struct selinux_policy *policy;
> -	int rc;
> -	struct policy_file fp;
>  
>  	policy = rcu_dereference_protected(
>  			state->policy, lockdep_is_held(&state->policy_mutex));
> @@ -3898,14 +3922,43 @@ int security_read_policy(struct selinux_state *state,
>  	if (!*data)
>  		return -ENOMEM;
>  
> -	fp.data = *data;
> -	fp.len = *len;
> +	return security_read_selinux_policy(policy, *data, len);
> +}
>  
> -	rc = policydb_write(&policy->policydb, &fp);
> -	if (rc)
> -		return rc;
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
> +				void **data, size_t *len)
> +{
> +	struct selinux_policy *policy;
> +	int rc = 0;
>  
> -	*len = (unsigned long)fp.data - (unsigned long)*data;
> -	return 0;
> +	policy = rcu_dereference_protected(
> +			state->policy, lockdep_is_held(&state->policy_mutex));
> +	if (!policy) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	*len = policy->policydb.len;
> +	*data = vmalloc(*len);
> +	if (!*data) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
>  
> +	rc = security_read_selinux_policy(policy, *data, len);
> +
> +out:
> +	return rc;
>  }
> -- 
> 2.17.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

