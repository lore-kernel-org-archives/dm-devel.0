Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA72C2BB40
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB23E22CB1
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB23E22CB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-ZyFrfDOvNumfN_udeszJaA-1; Mon, 14 Dec 2020 06:01:00 -0500
X-MC-Unique: ZyFrfDOvNumfN_udeszJaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDF8619251CA;
	Mon, 14 Dec 2020 11:00:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BE4A70490;
	Mon, 14 Dec 2020 11:00:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6DB6A5002E;
	Mon, 14 Dec 2020 11:00:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BC096O6000571 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 19:09:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 38C812166B2A; Sat, 12 Dec 2020 00:09:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 335212166B29
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 00:09:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A1B81010426
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 00:09:04 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-548-8c8zYYeiO7SMoWsmcnZazw-1;
	Fri, 11 Dec 2020 19:08:59 -0500
X-MC-Unique: 8c8zYYeiO7SMoWsmcnZazw-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id AA20620B717A;
	Fri, 11 Dec 2020 16:08:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AA20620B717A
Date: Fri, 11 Dec 2020 18:08:54 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201212000854.GC4951@sequoia>
References: <20201211235807.30815-1-tusharsu@linux.microsoft.com>
	<20201211235807.30815-2-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201211235807.30815-2-tusharsu@linux.microsoft.com>
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
Subject: Re: [dm-devel] [PATCH v8 1/8] IMA: generalize keyring specific
 measurement constructs
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020-12-11 15:58:00, Tushar Sugandhi wrote:
> IMA functions such as ima_match_keyring(), process_buffer_measurement(),
> ima_match_policy() etc. handle data specific to keyrings. Currently,
> these constructs are not generic to handle any func specific data.
> This makes it harder to extend them without code duplication.
> 
> Refactor the keyring specific measurement constructs to be generic and
> reusable in other measurement scenarios.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

This looks good to me. Thanks!

Tyler

> ---
>  security/integrity/ima/ima.h        |  6 ++--
>  security/integrity/ima/ima_api.c    |  6 ++--
>  security/integrity/ima/ima_main.c   |  6 ++--
>  security/integrity/ima/ima_policy.c | 46 ++++++++++++++++++-----------
>  4 files changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 8e8b1e3cb847..e5622ce8cbb1 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -256,7 +256,7 @@ static inline void ima_process_queued_keys(void) {}
>  int ima_get_action(struct inode *inode, const struct cred *cred, u32 secid,
>  		   int mask, enum ima_hooks func, int *pcr,
>  		   struct ima_template_desc **template_desc,
> -		   const char *keyring);
> +		   const char *func_data);
>  int ima_must_measure(struct inode *inode, int mask, enum ima_hooks func);
>  int ima_collect_measurement(struct integrity_iint_cache *iint,
>  			    struct file *file, void *buf, loff_t size,
> @@ -268,7 +268,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>  			   struct ima_template_desc *template_desc);
>  void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  				const char *eventname, enum ima_hooks func,
> -				int pcr, const char *keyring);
> +				int pcr, const char *func_data);
>  void ima_audit_measurement(struct integrity_iint_cache *iint,
>  			   const unsigned char *filename);
>  int ima_alloc_init_template(struct ima_event_data *event_data,
> @@ -284,7 +284,7 @@ const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
>  int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
>  		     enum ima_hooks func, int mask, int flags, int *pcr,
>  		     struct ima_template_desc **template_desc,
> -		     const char *keyring);
> +		     const char *func_data);
>  void ima_init_policy(void);
>  void ima_update_policy(void);
>  void ima_update_policy_flag(void);
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 4f39fb93f278..af218babd198 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -170,7 +170,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>   * @func: caller identifier
>   * @pcr: pointer filled in if matched measure policy sets pcr=
>   * @template_desc: pointer filled in if matched measure policy sets template=
> - * @keyring: keyring name used to determine the action
> + * @func_data: private data specific to @func, can be NULL.
>   *
>   * The policy is defined in terms of keypairs:
>   *		subj=, obj=, type=, func=, mask=, fsmagic=
> @@ -186,14 +186,14 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>  int ima_get_action(struct inode *inode, const struct cred *cred, u32 secid,
>  		   int mask, enum ima_hooks func, int *pcr,
>  		   struct ima_template_desc **template_desc,
> -		   const char *keyring)
> +		   const char *func_data)
>  {
>  	int flags = IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE | IMA_HASH;
>  
>  	flags &= ima_policy_flag;
>  
>  	return ima_match_policy(inode, cred, secid, func, mask, flags, pcr,
> -				template_desc, keyring);
> +				template_desc, func_data);
>  }
>  
>  /*
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 68956e884403..e76ef4bfd0f4 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -786,13 +786,13 @@ int ima_post_load_data(char *buf, loff_t size,
>   * @eventname: event name to be used for the buffer entry.
>   * @func: IMA hook
>   * @pcr: pcr to extend the measurement
> - * @keyring: keyring name to determine the action to be performed
> + * @func_data: private data specific to @func, can be NULL.
>   *
>   * Based on policy, the buffer is measured into the ima log.
>   */
>  void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  				const char *eventname, enum ima_hooks func,
> -				int pcr, const char *keyring)
> +				int pcr, const char *func_data)
>  {
>  	int ret = 0;
>  	const char *audit_cause = "ENOMEM";
> @@ -831,7 +831,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  	if (func) {
>  		security_task_getsecid(current, &secid);
>  		action = ima_get_action(inode, current_cred(), secid, 0, func,
> -					&pcr, &template, keyring);
> +					&pcr, &template, func_data);
>  		if (!(action & IMA_MEASURE))
>  			return;
>  	}
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 823a0c1379cb..a09d1a41a290 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -453,30 +453,41 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
>  }
>  
>  /**
> - * ima_match_keyring - determine whether the keyring matches the measure rule
> - * @rule: a pointer to a rule
> - * @keyring: name of the keyring to match against the measure rule
> + * ima_match_rule_data - determine whether the given func_data matches
> + *			 the measure rule data
> + * @rule: IMA policy rule
> + * @func_data: data to match against the measure rule data
>   * @cred: a pointer to a credentials structure for user validation
>   *
> - * Returns true if keyring matches one in the rule, false otherwise.
> + * Returns true if func_data matches one in the rule, false otherwise.
>   */
> -static bool ima_match_keyring(struct ima_rule_entry *rule,
> -			      const char *keyring, const struct cred *cred)
> +static bool ima_match_rule_data(struct ima_rule_entry *rule,
> +				const char *func_data,
> +				const struct cred *cred)
>  {
> +	const struct ima_rule_opt_list *opt_list = NULL;
>  	bool matched = false;
>  	size_t i;
>  
>  	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
>  		return false;
>  
> -	if (!rule->keyrings)
> -		return true;
> +	switch (rule->func) {
> +	case KEY_CHECK:
> +		if (!rule->keyrings)
> +			return true;
> +
> +		opt_list = rule->keyrings;
> +		break;
> +	default:
> +		return false;
> +	}
>  
> -	if (!keyring)
> +	if (!func_data)
>  		return false;
>  
> -	for (i = 0; i < rule->keyrings->count; i++) {
> -		if (!strcmp(rule->keyrings->items[i], keyring)) {
> +	for (i = 0; i < opt_list->count; i++) {
> +		if (!strcmp(opt_list->items[i], func_data)) {
>  			matched = true;
>  			break;
>  		}
> @@ -493,20 +504,20 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
>   * @secid: the secid of the task to be validated
>   * @func: LIM hook identifier
>   * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
> - * @keyring: keyring name to check in policy for KEY_CHECK func
> + * @func_data: private data specific to @func, can be NULL.
>   *
>   * Returns true on rule match, false on failure.
>   */
>  static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>  			    const struct cred *cred, u32 secid,
>  			    enum ima_hooks func, int mask,
> -			    const char *keyring)
> +			    const char *func_data)
>  {
>  	int i;
>  
>  	if (func == KEY_CHECK) {
>  		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
> -		       ima_match_keyring(rule, keyring, cred);
> +			ima_match_rule_data(rule, func_data, cred);
>  	}
>  	if ((rule->flags & IMA_FUNC) &&
>  	    (rule->func != func && func != POST_SETATTR))
> @@ -610,8 +621,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
>   * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
>   * @pcr: set the pcr to extend
>   * @template_desc: the template that should be used for this rule
> - * @keyring: the keyring name, if given, to be used to check in the policy.
> - *           keyring can be NULL if func is anything other than KEY_CHECK.
> + * @func_data: private data specific to @func, can be NULL.
>   *
>   * Measure decision based on func/mask/fsmagic and LSM(subj/obj/type)
>   * conditions.
> @@ -623,7 +633,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
>  int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
>  		     enum ima_hooks func, int mask, int flags, int *pcr,
>  		     struct ima_template_desc **template_desc,
> -		     const char *keyring)
> +		     const char *func_data)
>  {
>  	struct ima_rule_entry *entry;
>  	int action = 0, actmask = flags | (flags << 1);
> @@ -638,7 +648,7 @@ int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
>  			continue;
>  
>  		if (!ima_match_rules(entry, inode, cred, secid, func, mask,
> -				     keyring))
> +				     func_data))
>  			continue;
>  
>  		action |= entry->flags & IMA_ACTION_FLAGS;
> -- 
> 2.17.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

