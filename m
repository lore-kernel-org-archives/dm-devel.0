From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Thu, 16 Apr 2020 17:46:31 -0700
Message-ID: <c76e89f4-6f39-f2f0-6459-a723df67c75f@linux.microsoft.com>
References: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
 <76a9556d-b141-d26f-7b3c-3887d3a4ae16@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <76a9556d-b141-d26f-7b3c-3887d3a4ae16@gmail.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, linux-integrity@vger.kernel.org, zohar@linux.ibm.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, dm-devel@redhat.com
Cc: jmorris@namei.org, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids



On 2020-04-08 9:28 a.m., Milan Broz wrote:
> On 08/04/2020 12:19, Tushar Sugandhi wrote:
<snip>
>> Proposal:
>> ---------
>> A. Measuring dmcrypt constructs:
>>       We can add an IMA hook in crypt_ctr() present in
>>       drivers/md/dm-crypt.c, so that IMA can start measuring the status of
>>       various dm-crypt targets (represented by crypt_target struct - also
>>       defined in dm-crypt.c).
> 
> Hi,
> 
> I do not think you should just cherry-pick dm-crypt here. What about other
> device-mapper targets? Apparently, dm-verity or dm-integrity are obvious
> candidates too.
> 
> But device-mapper logic is based on stacking devices, so in generic case
> (not just in some very special embedded configuration) you need to measure
> the whole stack of devices.
> (Just imagine a target stacked below dm-crypt that decrypts the device or so. :-)
> 
> Moreover, dm-crypt allows some specific actions like wiping and reloading
> of the encryption key through device-mapper dm-crypt message.
> If you check parameter only in crypt_ctr, this message path must be disabled,
> basically crippling dm-crypt functionality (it is intended to wipe key in-memory
> during hw suspend).
> 
> 
> IMO if you want implement something like IMA measurement, I think you should
> implement it in device-mapper core, and provide support for all targets.
I agree that this needs to be implemented in device-mapper core,
rather than highter applications like  dm-crypt, dm-verity, or dm-integrity.
Functions like dm_table_create(), dm_table_destroy(), 
dm_table_verify_integrity(),
dm_table_complete(), dm_table_add_target() etc. in drivers/md/dm-table.c 
look like good
candidates to add hooks for IMA.
Please let me know if you have any other recommendations.
> I guess some new target specific callback is needed and some flags that
> could enforce/disable stacking if a IMA measurement is in place etc.
> 
> Milan
> 
