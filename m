From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v3 3/6] IMA: update process_buffer_measurement to
 measure buffer hash
Date: Mon, 31 Aug 2020 13:02:56 -0400
Message-ID: <f11dbfc1382e60c04fdd519ce5122239fa0cab8b.camel@linux.ibm.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
         <20200828015704.6629-4-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200828015704.6629-4-tusharsu@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2020-08-27 at 18:57 -0700, Tushar Sugandhi wrote:
> process_buffer_measurement() currently only measures the input buffer.
> When the buffer being measured is too large, it may result in bloated
> IMA logs.

The subject of  this sentence refers to an individual record, while
"bloated" refers to the measurement list.  A "bloated" measurement list
would contain too many or unnecessary records.  Your concern seems to
be with the size of the individual record, not the number of
measurement list entries.

Measuring the hash of the buffer data is similar to measuring the file
data.  In the case of the file data, however, the attestation server
may rely on a white list manifest/DB or the file signature to verify
the file data hash.  For buffer measurements, how will the attestation
server ascertain what is a valid buffer hash?

Hint:  I assume, correct me if I'm wrong, the measurement list record
template data is not meant to be verified, but used to detect if the "critical data" changed.

Please update the patch description accordingly.

> 
> Introduce a boolean parameter measure_buf_hash to support measuring
> hash of a buffer, which would be much smaller, instead of the buffer
> itself.
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> ---

<snip>

> +++ b/security/integrity/ima/ima_main.c
> @@ -733,17 +733,21 @@ int ima_load_data(enum kernel_load_data_id id)
>   * @func: IMA hook
>   * @pcr: pcr to extend the measurement
>   * @func_data: private data specific to @func, can be NULL.
> + * @measure_buf_hash: if set to true - will measure hash of the buf,
> + *                    instead of buf
>   *
>   * Based on policy, the buffer is measured into the ima log.
>   */
>  int process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  			       const char *eventname, enum ima_hooks func,
> -			       int pcr, const char *func_data)
> +			       int pcr, const char *func_data,
> +			       bool measure_buf_hash)
>  {
>  	int ret = 0;
>  	const char *audit_cause = "ENOMEM";
>  	struct ima_template_entry *entry = NULL;
>  	struct integrity_iint_cache iint = {};
> +	struct integrity_iint_cache digest_iint = {};
>  	struct ima_event_data event_data = {.iint = &iint,
>  					    .filename = eventname,
>  					    .buf = buf,
> @@ -752,7 +756,7 @@ int process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  	struct {
>  		struct ima_digest_data hdr;
>  		char digest[IMA_MAX_DIGEST_SIZE];
> -	} hash = {};
> +	} hash = {}, digest_hash = {};
>  	int violation = 0;
>  	int action = 0;
>  	u32 secid;
> @@ -801,6 +805,24 @@ int process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  		goto out;
>  	}
>  
> +	if (measure_buf_hash) {
> +		digest_iint.ima_hash = &digest_hash.hdr;
> +		digest_iint.ima_hash->algo = ima_hash_algo;
> +		digest_iint.ima_hash->length = hash_digest_size[ima_hash_algo];
> +
> +		ret = ima_calc_buffer_hash(hash.hdr.digest,
> +					   iint.ima_hash->length,
> +					   digest_iint.ima_hash);
> +		if (ret < 0) {
> +			audit_cause = "digest_hashing_error";
> +			goto out;
> +		}
> +
> +		event_data.iint = &digest_iint;
> +		event_data.buf = hash.hdr.digest;
> +		event_data.buf_len = iint.ima_hash->length;
> +	}
> +

There seems to be some code and variable duplication by doing it this
way.  Copying the caluclated buffer data hash to a temporary buffer
might eliminate it.

>  	ret = ima_alloc_init_template(&event_data, &entry, template);
>  	if (ret < 0) {
>  		audit_cause = "alloc_entry";
