From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v4 05/12] fs: add security blob and hooks for
 block_device
Date: Mon, 20 Jul 2020 09:42:05 -0700
Message-ID: <e82dbf6b-e90d-205b-62d1-b7cd8b5df844@linux.microsoft.com>
References: <20200717230941.1190744-1-deven.desai@linux.microsoft.com>
 <20200717230941.1190744-6-deven.desai@linux.microsoft.com>
 <1843d707-c62e-fa13-c663-c123ea1205a0@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1843d707-c62e-fa13-c663-c123ea1205a0@schaufler-ca.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>, agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, viro@zeniv.linux.org.uk, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com
Cc: tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com
List-Id: dm-devel.ids



On 7/17/2020 5:14 PM, Casey Schaufler wrote:

[...snip]

>> +EXPORT_SYMBOL(security_bdev_free);
>> +
>> +int security_bdev_setsecurity(struct block_device *bdev,
>> +			      const char *name, const void *value,
>> +			      size_t size)
>> +{
>> +	return call_int_hook(bdev_setsecurity, 0, bdev, name, value, size);
>> +}
> 
> What is your expectation regarding multiple security modules using the
> same @name? What do you expect a security module to do if it does not
> support a particular @name? You may have a case where SELinux supports
> a @name that AppArmor (or KSRI) doesn't. -ENOSYS may be you friend here.
> 

I expect that some security modules may want to use the same @name / use
the data contained with @name. I cannot speak to the future cases of
other LSMs, but I expect if they want the raw @value, they'll copy it
into their security blob, or interpret @value to a field defined by
their security blob.

Originally, I expected a security module that does not implement a
particular @name no-op with return 0, not -ENOSYS, but I recognize that
error codes are valuable, and it's a trivial change - I'll switch the 
security hook to call the hooks while allowing -ENOSYS or 0 in the next 
iteration.

>> +EXPORT_SYMBOL(security_bdev_setsecurity);
>> +
>>   #ifdef CONFIG_PERF_EVENTS
>>   int security_perf_event_open(struct perf_event_attr *attr, int type)
>>   {
