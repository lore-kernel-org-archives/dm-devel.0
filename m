From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v5 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Mon, 1 Jul 2019 11:41:37 +0200
Message-ID: <749ddf56-3cb6-42c8-9ccc-71e09558400f@gmail.com>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
 <20190628040041.GB673@sol.localdomain>
 <alpine.LRH.2.21.1906282040490.15624@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906282040490.15624@namei.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>, Eric Biggers <ebiggers@kernel.org>
Cc: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, scottsh@microsoft.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 29/06/2019 06:01, James Morris wrote:
> On Thu, 27 Jun 2019, Eric Biggers wrote:
> 
>> I don't understand your justification for this feature.
>>
>> If userspace has already been pwned severely enough for the attacker to be
>> executing arbitrary code with CAP_SYS_ADMIN (which is what the device mapper
>> ioctls need), what good are restrictions on loading more binaries from disk?
>>
>> Please explain your security model.
> 
> Let's say the system has a policy where all code must be signed with a 
> valid key, and that one mechanism for enforcing this is via signed 
> dm-verity volumes. Validating the signature within the kernel provides 
> stronger assurance than userspace validation. The kernel validates and 
> executes the code, using kernel-resident keys, and does not need to rely 
> on validation which has occurred across a trust boundary.

Yes, but as it is implemented in this patch, a certificate is provided as
a binary blob by the (super)user that activates the dm-verity device.

Actually, I can put there anything that looks like a correct signature (self-signed
or so), and dm-verity code is happy because the root hash is now signed.

Maybe could this concept be extended to support in-kernel compiled certificates?

I like the idea of signed root hash, but the truth is that if you have access
to device activation, it brings nothing, you can just put any cert in the keyring
and use it.

Milan

> 
> You don't need arbitrary CAP_SYS_ADMIN code execution, you just need a 
> flaw in the app (or its dependent libraries, or configuration) which 
> allows signature validation to be bypassed.
> 
> The attacker now needs a kernel rather than a userspace vulnerability to 
> bypass the signed code policy.
> 
