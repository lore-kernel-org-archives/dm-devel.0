From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v3 5/6] IMA: add hook to measure critical data from
 kernel components
Date: Mon, 31 Aug 2020 14:23:55 -0400
Message-ID: <6c80bdad49c72fa58b5a9fb7ce2d20c8cabe1324.camel@linux.ibm.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
         <20200828015704.6629-6-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200828015704.6629-6-tusharsu@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 52cbbc1f7ea2..a889bf40cb7e 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -869,6 +869,30 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  	fdput(f);
>  }
>  
> +/**
> + * ima_measure_critical_data - measure critical data
> + * @event_name: name for the given data
> + * @event_data_source: name of the event data source
> + * @buf: pointer to buffer containing data to measure
> + * @buf_len: length of buffer(in bytes)
> + * @measure_buf_hash: if set to true - will measure hash of the buf,
> + *                    instead of buf
> + *
> + * Buffers can only be measured, not appraised.
> + */
> +int ima_measure_critical_data(const char *event_name,
> +			      const char *event_data_source,
> +			      const void *buf, int buf_len,
> +			      bool measure_buf_hash)
> +{
> +	if (!event_name || !event_data_source || !buf || !buf_len)
> +		return -EINVAL;
> +
> +	return process_buffer_measurement(NULL, buf, buf_len, event_name,
> +					  CRITICAL_DATA, 0, event_data_source,
> +					  measure_buf_hash);

This is exactly what I'm concerned about.  Failure to measure data may
be audited, but should never fail.

Mimi

> +}
