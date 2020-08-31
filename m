From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v3 1/6] IMA: generalize keyring specific measurement
 constructs
Date: Mon, 31 Aug 2020 07:55:45 -0400
Message-ID: <4802c73c2ed22c64ea4f315d3115ead919c3205e.camel@linux.ibm.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
         <20200828015704.6629-2-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200828015704.6629-2-tusharsu@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2020-08-27 at 18:56 -0700, Tushar Sugandhi wrote:
> IMA functions such as ima_match_keyring(), process_buffer_measurement(),
> ima_match_policy() etc. handle data specific to keyrings. Currently,
> these constructs are not generic to handle any func specific data.
> This makes it harder to extend without code duplication.
> 
> Refactor the keyring specific measurement constructs to be generic and
> reusable in other measurement scenarios.

Mostly this patch changes the variable name from keyring to func_data,
which is good.  Other changes should be minimized.

> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> ---

<snip>

> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index fe1df373c113..8866e84d0062 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -451,15 +451,21 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
>  }
>  
>  /**
> - * ima_match_keyring - determine whether the keyring matches the measure rule
> - * @rule: a pointer to a rule
> - * @keyring: name of the keyring to match against the measure rule
> + * ima_match_rule_data - determine whether the given func_data matches
> + *			 the measure rule data
> + * @rule: IMA policy rule
> + * @opt_list: rule data to match func_data against
> + * @func_data: data to match against the measure rule data
> + * @allow_empty_opt_list: If true matches all func_data
>   * @cred: a pointer to a credentials structure for user validation
>   *
> - * Returns true if keyring matches one in the rule, false otherwise.
> + * Returns true if func_data matches one in the rule, false otherwise.
>   */
> -static bool ima_match_keyring(struct ima_rule_entry *rule,
> -			      const char *keyring, const struct cred *cred)
> +static bool ima_match_rule_data(struct ima_rule_entry *rule,
> +				const struct ima_rule_opt_list *opt_list, 

Ok

> +				const char *func_data,
> +				bool allow_empty_opt_list,

As the policy is loaded, shouldn't the rules should be checked, not
here on usage?

Mimi

> +				const struct cred *cred)
>  {
>  	bool matched = false;
>  	size_t i;
> 
