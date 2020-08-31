From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v3 2/6] IMA: change process_buffer_measurement return
 type from void to int
Date: Mon, 31 Aug 2020 07:36:32 -0400
Message-ID: <e76bdb18c6045702156441470e50380445e6e218.camel@linux.ibm.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
         <20200828015704.6629-3-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200828015704.6629-3-tusharsu@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2020-08-27 at 18:57 -0700, Tushar Sugandhi wrote:
> process_buffer_measurement() does not return the result of the operation.
> Therefore, the consumers of this function cannot act on it, if needed.
> 
> Update return type of process_buffer_measurement() from void to int.

Failure to measure may be audited, but should never fail.  This is one
of the main differences between secure and trusted boot concepts. 
Notice in process_measurement() that -EACCES is only returned for
appraisal.

Returning a failure from process_buffer_measurement() in itself isn't a
problem, as long as the failure isn't returned to the LSM/IMA hook. 
However,  just as the callers of  process_measurement() originally
processed the result, that processing was moved into
process_measurement() [1].

Mimi

[1] 750943a30714 ima: remove enforce checking duplication

> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> ---
>  security/integrity/ima/ima.h      |  6 +++---
>  security/integrity/ima/ima_main.c | 14 +++++++-------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 8875085db689..83ed57147e68 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -265,9 +265,9 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>  			   struct evm_ima_xattr_data *xattr_value,
>  			   int xattr_len, const struct modsig *modsig, int pcr,
>  			   struct ima_template_desc *template_desc);
> -void process_buffer_measurement(struct inode *inode, const void *buf, int size,
> -				const char *eventname, enum ima_hooks func,
> -				int pcr, const char *func_data);
> +int process_buffer_measurement(struct inode *inode, const void *buf, int size,
> +			       const char *eventname, enum ima_hooks func,
> +			       int pcr, const char *func_data);
>  void ima_audit_measurement(struct integrity_iint_cache *iint,
>  			   const unsigned char *filename);
>  int ima_alloc_init_template(struct ima_event_data *event_data,
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index c870fd6d2f83..0979a62a9257 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -736,9 +736,9 @@ int ima_load_data(enum kernel_load_data_id id)
>   *
>   * Based on policy, the buffer is measured into the ima log.
>   */
> -void process_buffer_measurement(struct inode *inode, const void *buf, int size,
> -				const char *eventname, enum ima_hooks func,
> -				int pcr, const char *func_data)
> +int process_buffer_measurement(struct inode *inode, const void *buf, int size,
> +			       const char *eventname, enum ima_hooks func,
> +			       int pcr, const char *func_data)
>  {
>  	int ret = 0;
>  	const char *audit_cause = "ENOMEM";
> @@ -758,7 +758,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  	u32 secid;
>  
>  	if (!ima_policy_flag)
> -		return;
> +		return 0;
>  
>  	/*
>  	 * Both LSM hooks and auxilary based buffer measurements are
> @@ -772,7 +772,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  		action = ima_get_action(inode, current_cred(), secid, 0, func,
>  					&pcr, &template, func_data);
>  		if (!(action & IMA_MEASURE))
> -			return;
> +			return 0;
>  	}
>  
>  	if (!pcr)
> @@ -787,7 +787,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  			pr_err("template %s init failed, result: %d\n",
>  			       (strlen(template->name) ?
>  				template->name : template->fmt), ret);
> -			return;
> +			return ret;
>  		}
>  	}
>  
> @@ -819,7 +819,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  					func_measure_str(func),
>  					audit_cause, ret, 0, ret);
>  
> -	return;
> +	return ret;
>  }
>  
>  /**
