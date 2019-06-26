From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v5 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Wed, 26 Jun 2019 07:48:49 +0200
Message-ID: <e0cb17cc-35f9-46e2-ca1a-1c942989ed20@gmail.com>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
 <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com>
 <20190625182004.GA32075@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190625182004.GA32075@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, scottsh@microsoft.com, ebiggers@google.com, jmorris@namei.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 25/06/2019 20:20, Mike Snitzer wrote:
> On Wed, Jun 19 2019 at  3:10pm -0400,
> Jaskaran Khurana <jaskarankhurana@linux.microsoft.com> wrote:
> 
>> The verification is to support cases where the roothash is not secured by
>> Trusted Boot, UEFI Secureboot or similar technologies.
>> One of the use cases for this is for dm-verity volumes mounted after boot,
>> the root hash provided during the creation of the dm-verity volume has to
>> be secure and thus in-kernel validation implemented here will be used
>> before we trust the root hash and allow the block device to be created.
>>
>> The signature being provided for verification must verify the root hash and
>> must be trusted by the builtin keyring for verification to succeed.
>>
>> The hash is added as a key of type "user" and the description is passed to 
>> the kernel so it can look it up and use it for verification.
>>
>> Kernel commandline parameter will indicate whether to check (only if 
>> specified) or force (for all dm verity volumes) roothash signature 
>> verification.
>>
>> Kernel commandline: dm_verity.verify_sig=1 or 2 for check/force root hash
>> signature validation respectively.
>>
>> Signed-off-by: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
> 
> Milan and/or others: could you please provide review and if you're OK
> with this patch respond accordingly?

Stand by please :)

I like the patch, I think all major problems were solved, but I still need to test it somehow.

Anyway, for the time being, I keep all ongoing patches that need some later
userspace support in my branch
https://git.kernel.org/pub/scm/linux/kernel/git/mbroz/linux.git/log/?h=dm-cryptsetup
so at least it get some automated testing.

Milan
