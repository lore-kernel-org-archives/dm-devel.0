From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 2/3] IMA: add policy to support measuring critical
 data from kernel components
Date: Mon, 24 Aug 2020 18:46:41 -0400
Message-ID: <d82c5cdab170d3dcc513b38632801c3aa14ca389.camel@linux.ibm.com>
References: <20200821182107.5328-1-tusharsu@linux.microsoft.com>
         <20200821182107.5328-3-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200821182107.5328-3-tusharsu@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2020-08-21 at 11:21 -0700, Tushar Sugandhi wrote:
> There would be several candidate kernel components suitable for IMA
> measurement. Not all of them would have support for IMA measurement.
> Also, system administrators may not want to measure data for all of
> them, even when they support IMA measurement. An IMA policy specific
> to various kernel components is needed to measure their respective
> critical data.
> 
> Add a new IMA policy CRITICAL_DATA+data_sources to support measuring
> various critical kernel components. This policy would enable the
> system administrators to limit the measurement to the components,
> if the components support IMA measurement.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> ---
>  Documentation/ABI/testing/ima_policy |  6 ++-
>  security/integrity/ima/ima.h         |  1 +
>  security/integrity/ima/ima_api.c     |  2 +-
>  security/integrity/ima/ima_policy.c  | 62 +++++++++++++++++++++++++---
>  4 files changed, 63 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index cd572912c593..a0dd0f108555 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -29,7 +29,7 @@ Description:
>  		base: 	func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
>  				[FIRMWARE_CHECK]
>  				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
> -				[KEXEC_CMDLINE] [KEY_CHECK]
> +				[KEXEC_CMDLINE] [KEY_CHECK] [CRITICAL_DATA]
>  			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
>  			       [[^]MAY_EXEC]
>  			fsmagic:= hex value
> @@ -125,3 +125,7 @@ Description:
>  		keys added to .builtin_trusted_keys or .ima keyring:
>  
>  			measure func=KEY_CHECK keyrings=.builtin_trusted_keys|.ima
> +
> +		Example of measure rule using CRITICAL_DATA to measure critical data
> +
> +			measure func=CRITICAL_DATA data_sources=selinux|apparmor|dm-crypt

This example uses "data_sources" without first defining it in the
"option:" section.  Defining two new options is an indication that this
patch should be split up.  One which defines the "CRITICAL_DATA" and
another one which defines the new key value pair.  The term
"data_sources" is pretty generic.  Perhaps constrain it a bit by re-
naming it "critical_data=".  Or was such using a generic name
intentional?

Normally "CRITICAL_DATA" would be defined with the critical data hook,
but that seems to be defined in patch 3/3 "IMA: define IMA hook to
measure critical data from kernel components".

> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 8875085db689..0f4209a92bfb 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -200,6 +200,7 @@ static inline unsigned int ima_hash_key(u8 *digest)
>  	hook(POLICY_CHECK, policy)			\
>  	hook(KEXEC_CMDLINE, kexec_cmdline)		\
>  	hook(KEY_CHECK, key)				\
> +	hook(CRITICAL_DATA, critical_data)		\
>  	hook(MAX_CHECK, none)
>  
>  #define __ima_hook_enumify(ENUM, str)	ENUM,
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index af218babd198..9917e1730cb6 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -176,7 +176,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>   *		subj=, obj=, type=, func=, mask=, fsmagic=
>   *	subj,obj, and type: are LSM specific.
>   *	func: FILE_CHECK | BPRM_CHECK | CREDS_CHECK | MMAP_CHECK | MODULE_CHECK
> - *	| KEXEC_CMDLINE | KEY_CHECK
> + *	| KEXEC_CMDLINE | KEY_CHECK | CRITICAL_DATA
>   *	mask: contains the permission mask
>   *	fsmagic: hex value
>   *
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 8866e84d0062..7b649095ac7a 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -33,6 +33,7 @@
>  #define IMA_PCR		0x0100
>  #define IMA_FSNAME	0x0200
>  #define IMA_KEYRINGS	0x0400
> +#define IMA_DATA_SOURCES	0x0800
>  
>  #define UNKNOWN		0
>  #define MEASURE		0x0001	/* same as IMA_MEASURE */
> @@ -84,6 +85,7 @@ struct ima_rule_entry {
>  	} lsm[MAX_LSM_RULES];
>  	char *fsname;
>  	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
> +	struct ima_rule_opt_list *data_sources; /* Measure data from these sources */
>  	struct ima_template_desc *template;
>  };
>  
> @@ -508,14 +510,23 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>  {
>  	int i;
>  
> -	if (func == KEY_CHECK) {
> -		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
> -		       ima_match_rule_data(rule, rule->keyrings, func_data,
> -					   true, cred);
> -	}
>  	if ((rule->flags & IMA_FUNC) &&
>  	    (rule->func != func && func != POST_SETATTR))
>  		return false;
> +
> +	switch (func) {
> +	case KEY_CHECK:
> +		return ((rule->func == func) &&
> +			ima_match_rule_data(rule, rule->keyrings,
> +					    func_data, true, cred));
> +	case CRITICAL_DATA:
> +		return ((rule->func == func) &&
> +			ima_match_rule_data(rule, rule->data_sources,
> +					    func_data, false, cred));
> +	default:
> +		break;
> +	}
> +
>  	if ((rule->flags & IMA_MASK) &&
>  	    (rule->mask != mask && func != POST_SETATTR))
>  		return false;
> @@ -911,7 +922,7 @@ enum {
>  	Opt_uid_lt, Opt_euid_lt, Opt_fowner_lt,
>  	Opt_appraise_type, Opt_appraise_flag,
>  	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
> -	Opt_err
> +	Opt_data_sources, Opt_err
>  };
>  
>  static const match_table_t policy_tokens = {
> @@ -948,6 +959,7 @@ static const match_table_t policy_tokens = {
>  	{Opt_pcr, "pcr=%s"},
>  	{Opt_template, "template=%s"},
>  	{Opt_keyrings, "keyrings=%s"},
> +	{Opt_data_sources, "data_sources=%s"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -1110,6 +1122,19 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
>  		if (ima_rule_contains_lsm_cond(entry))
>  			return false;
>  
> +		break;
> +	case CRITICAL_DATA:
> +		if (entry->action & ~(MEASURE | DONT_MEASURE))
> +			return false;
> +
> +		if (!(entry->flags & IMA_DATA_SOURCES) ||
> +		    (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
> +		    IMA_DATA_SOURCES)))
> +			return false;

Requiring IMA_FUNC and IMA_DATA_SOURCES makes sense, but why are
IMA_UID and IMA_PCR required?

> +
> +		if (ima_rule_contains_lsm_cond(entry))
> +			return false;
> +
>  		break;
>  	default:
>  		return false;
> @@ -1242,6 +1267,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			else if (IS_ENABLED(CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS) &&
>  				 strcmp(args[0].from, "KEY_CHECK") == 0)
>  				entry->func = KEY_CHECK;
> +			else if (strcmp(args[0].from, "CRITICAL_DATA") == 0)
> +				entry->func = CRITICAL_DATA;
>  			else
>  				result = -EINVAL;
>  			if (!result)
> @@ -1312,6 +1339,23 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  
>  			entry->flags |= IMA_KEYRINGS;
>  			break;
> +		case Opt_data_sources:
> +			ima_log_string(ab, "data_sources", args[0].from);
> +
> +			if (entry->data_sources) {
> +				result = -EINVAL;
> +				break;
> +			}
> +
> +			entry->data_sources = ima_alloc_rule_opt_list(args);
> +			if (IS_ERR(entry->data_sources)) {
> +				result = PTR_ERR(entry->data_sources);
> +				entry->data_sources = NULL;
> +				break;
> +			}
> +

"keyrings=" isn't bounded because keyrings can be created by userspace.
Perhaps keyring names has a minimum/maximum length.  IMA isn't
measuring userspace construsts.  Shouldn't the list of critical data
being measured be bounded and verified?

Mimi

> +			entry->flags |= IMA_DATA_SOURCES;
> +			break;
>  		case Opt_fsuuid:
>  			ima_log_string(ab, "fsuuid", args[0].from);
>  
> @@ -1692,6 +1736,12 @@ int ima_policy_show(struct seq_file *m, void *v)
>  		seq_puts(m, " ");
>  	}
>  
> +	if (entry->flags & IMA_DATA_SOURCES) {
> +		seq_puts(m, "data_sources=");
> +		ima_show_rule_opt_list(m, entry->data_sources);
> +		seq_puts(m, " ");
> +	}
> +
>  	if (entry->flags & IMA_PCR) {
>  		snprintf(tbuf, sizeof(tbuf), "%d", entry->pcr);
>  		seq_printf(m, pt(Opt_pcr), tbuf);
