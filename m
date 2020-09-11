From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [PATCH v3 2/6] IMA: change process_buffer_measurement return type
 from void to int
Date: Fri, 11 Sep 2020 09:22:44 -0700
Message-ID: <b4cc6ec3-a58b-df2b-2de9-864775ae2a5f@linux.microsoft.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
 <20200828015704.6629-3-tusharsu@linux.microsoft.com>
 <e76bdb18c6045702156441470e50380445e6e218.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <e76bdb18c6045702156441470e50380445e6e218.camel@linux.ibm.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On 2020-08-31 4:36 a.m., Mimi Zohar wrote:
> On Thu, 2020-08-27 at 18:57 -0700, Tushar Sugandhi wrote:
>> process_buffer_measurement() does not return the result of the operation.
>> Therefore, the consumers of this function cannot act on it, if needed.
>>
>> Update return type of process_buffer_measurement() from void to int.
> 
> Failure to measure may be audited, but should never fail.  This is one
> of the main differences between secure and trusted boot concepts.
> Notice in process_measurement() that -EACCES is only returned for
> appraisal.
> 
> Returning a failure from process_buffer_measurement() in itself isn't a
> problem, as long as the failure isn't returned to the LSM/IMA hook.
> However,  just as the callers of  process_measurement() originally
> processed the result, that processing was moved into
> process_measurement() [1].
> 
> Mimi
> 
> [1] 750943a30714 ima: remove enforce checking duplication
> 
I can ignore the result of process_buffer_measurement() in
ima_measure_critical_data(), and make  ima_measure_critical_data()
return type "void".

But currently ima_measure_critical_data() is the only place where the
results of p_b_m() are being used.
So I might as well just revert back the return type of p_b_m() to
the original "void".
