From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [PATCH v3 4/6] IMA: add policy to measure critical data from
 kernel components
Date: Fri, 11 Sep 2020 10:29:17 -0700
Message-ID: <0dc88680-eb1c-4343-ad8e-18b0df8d5142@linux.microsoft.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
 <20200828015704.6629-5-tusharsu@linux.microsoft.com>
 <652406e1a08d855a5d9a3e3815835653a12df411.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <652406e1a08d855a5d9a3e3815835653a12df411.camel@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On 2020-08-31 11:15 a.m., Mimi Zohar wrote:
> On Thu, 2020-08-27 at 18:57 -0700, Tushar Sugandhi wrote:
>> There would be several candidate kernel components suitable for IMA
>> measurement. Not all of them would have support for IMA measurement.
>> Also, system administrators may not want to measure data for all of
>> them, even when they support IMA measurement. An IMA policy specific
>> to various kernel components is needed to measure their respective
>> critical data.
> 
> The base policy rules are wide, but may be constrained by specifying
> different options.  For example the builtin policy rules cannot be
> written in terms LSM labels, which would constrain them.  A policy rule
> may measure all keyrings or may constrain which keyrings need to be
> measured.  Measuring critical data is not any different.
> 
> Please rewrite the above paragraph accordingly.
> 
Ok. Will do.
>>
>> Add a new IMA policy "critical_kernel_data_sources" to support measuring
>> various critical kernel components. This policy would enable the
>> system administrators to limit the measurement to the components,
>> if the components support IMA measurement.
> 
> "critical_kernel_data_sources" is really wordy.   Find a better, self
> defining term for describing the type of data, one that isn't so wordy,
> and reflect it in the code.
> 
Will do. I will go with "critical_data". You also have suggested it in
the comment below.

"critical_data_sources" also seems right, but that's more wordy than
"critical_data".

Some more options we considered, but they don’t sound right.
Please let us know what do you think.
1. "critical_data_sources="
2. "critical_kernel_components=" -or- "crit_krnl_comps="
3. "critical_data_providers="
4. "critical_kernel_data_providers=" -or- "crit_krnl_dt_provs="
5. "critical_kernel_data_sources=" -or- "crit_krnl_dt_srcs="
6. "security_critical_data="
7. "protectable_data="
8. "protected_data="
9. "vital_protected_data="

>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
>> ---
>>   Documentation/ABI/testing/ima_policy |  3 +++
>>   security/integrity/ima/ima_policy.c  | 29 +++++++++++++++++++++++++++-
>>   2 files changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
>> index cd572912c593..7ccdc1964e29 100644
>> --- a/Documentation/ABI/testing/ima_policy
>> +++ b/Documentation/ABI/testing/ima_policy
>> @@ -48,6 +48,9 @@ Description:
>>   			template:= name of a defined IMA template type
>>   			(eg, ima-ng). Only valid when action is "measure".
>>   			pcr:= decimal value
>> +			critical_kernel_data_sources:= list of kernel
>> +			components (eg, selinux|apparmor|dm-crypt) that
>> +			contain data critical to the security of the kernel.
> 
> This original policy definition, for the most part, is in Backus–Naur
> format.   The keyring names is an exception, because it is not limited
> to pre-defined kernel objects.  The critical data hook is measuring
> things in kernel memory.  As new calls to measure critical data are
> added, new identifiers would be added here.
> 
> For example, if SELinux is the first example of measuring critical
> data, then the SELinux critical data patch would include
> "critical_data:= [selinux]".  Each subsequent critical data being
> measured would extend this list.  At the same time, the list of known
> "critical data" defined in patch 6/6 would be updated.
> 
> Normally a new feature and the first usage of that feature are included
> in the same patch set.  Separating them like this makes it difficult to
> write, review and upstream.
> 
> Mimi
> 
I agree. But the unique issue we are facing here is there are two
"first users" of this new "base series".

One, SeLinux work (driven by Lakshmi); and two, device-mapper/dm-crypt 
work (driven by me).

Both of them need to be reviewed by different maintainers, may go 
through several iterations before getting accepted.

That’s why we wanted to keep this "base series" independent of the 
"first users"; and called the "base series" as a dependency in the 
dm-crypt[1] / SeLinux[2] series.

We would appreciate your guidance on how we can better author these
three series - 1.this base series 2. dm-crypt series and 3. SeLinux
series.

[1]dm-crypt Series: https://patchwork.kernel.org/patch/11743715/
[2]SeLinux Series: https://patchwork.kernel.org/patch/11762287/
