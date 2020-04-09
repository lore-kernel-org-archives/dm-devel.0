From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v2 00/12] Integrity Policy Enforcement LSM (IPE)
Date: Thu, 9 Apr 2020 09:25:57 -0700
Message-ID: <35afdffe-179c-aedd-333a-9dfc20635fc3@linux.microsoft.com>
References: <20200406221439.1469862-1-deven.desai@linux.microsoft.com>
 <c1466cc8-8a08-708a-4629-234485bb833e@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c1466cc8-8a08-708a-4629-234485bb833e@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, tyhicks@linux.microsoft.com, pasha.tatashin@soleen.com, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 4/7/2020 2:31 PM, Nayna wrote:

>
> On 4/6/20 6:14 PM, deven.desai@linux.microsoft.com wrote:
>> From: Deven Bowers <deven.desai@linux.microsoft.com>
>>
>> Changelog:
>> ------------------------------------
>>
>> v1: Introduced
>>
>> v2:
>>    Split the second patch of the previous series into two.
>>    Minor corrections in the cover-letter and documentation
>>    comments regarding CAP_MAC_ADMIN checks in IPE.
>>
>> Overview:
>> ------------------------------------
>> IPE is a Linux Security Module, which allows for a configurable
>> policy to enforce integrity requirements on the whole system. It
>> attempts to solve the issue of Code Integrity: that any code being
>> executed (or files being read), are identical to the version that
>> was built by a trusted source.
>
> Can you please clarify the "motivation" for this patch set more 
> clearly? It seems to define a policy layer on top of dm-verity, which 
> may be compiled into the kernel. In the motivation, can you please 
> also make it explicit why existing mechanisms cannot be extended to 
> achieve your purpose?
>
This LSM was born out of a motivation to provide strong integrity 
guarantees without a dependency on file-metadata, allow the integrity 
claims to be configurable on a hot system, and allow for the mechanisms 
for ensuring integrity to be extendable.

This naturally had to be an LSM, as controlling execution at the block 
or filesystem layer does not make sense. Existing LSM implementations 
use filesystem metadata, and since one of IPE's goals is to secure file 
metadata, it is circular to depend on the file metadata itself to make 
decisions about whether the file has been modified.

Additionally, IPE while IPE currently provides dm-verity support and the 
trust root support, it can be easily extended to other implementations 
such as fs-verity. At it's core, IPE is attempting to separate mechanism 
(dm-verity, fs-verity, etc.) from policy (IPE).

> Also, AFIK, the changelog should be moved to the end of the patch 
> description.
>
Thanks! I'll move the changelog.
