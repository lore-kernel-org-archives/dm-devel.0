From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [PATCH v3 5/6] IMA: add hook to measure critical data from kernel
 components
Date: Fri, 11 Sep 2020 10:38:30 -0700
Message-ID: <01f5ea67-447e-c1c2-9c47-49fd3f6c16ec@linux.microsoft.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
 <20200828015704.6629-6-tusharsu@linux.microsoft.com>
 <6c80bdad49c72fa58b5a9fb7ce2d20c8cabe1324.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6c80bdad49c72fa58b5a9fb7ce2d20c8cabe1324.camel@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On 2020-08-31 11:23 a.m., Mimi Zohar wrote:
>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>> index 52cbbc1f7ea2..a889bf40cb7e 100644
>> --- a/security/integrity/ima/ima_main.c
>> +++ b/security/integrity/ima/ima_main.c
>> @@ -869,6 +869,30 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>>   	fdput(f);
>>   }
>>   
>> +/**
>> + * ima_measure_critical_data - measure critical data
>> + * @event_name: name for the given data
>> + * @event_data_source: name of the event data source
>> + * @buf: pointer to buffer containing data to measure
>> + * @buf_len: length of buffer(in bytes)
>> + * @measure_buf_hash: if set to true - will measure hash of the buf,
>> + *                    instead of buf
>> + *
>> + * Buffers can only be measured, not appraised.
>> + */
>> +int ima_measure_critical_data(const char *event_name,
>> +			      const char *event_data_source,
>> +			      const void *buf, int buf_len,
>> +			      bool measure_buf_hash)
>> +{
>> +	if (!event_name || !event_data_source || !buf || !buf_len)
>> +		return -EINVAL;
>> +
>> +	return process_buffer_measurement(NULL, buf, buf_len, event_name,
>> +					  CRITICAL_DATA, 0, event_data_source,
>> +					  measure_buf_hash);
> 
> This is exactly what I'm concerned about.  Failure to measure data may
> be audited, but should never fail.
> 
> Mimi
> 
As I responded in patch 2, I can ignore the result of 
process_buffer_measurement() in ima_measure_critical_data(), and make
ima_measure_critical_data() return type as "void".

But that’s the only place where the results of p_b_m() are being used.
So I might as well just revert the return type of p_b_m() to the
original "void".

>> +}
> 
