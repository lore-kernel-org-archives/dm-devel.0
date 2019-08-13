From: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [RFC PATCH v5 1/1] Add dm verity root hash pkcs7 sig
 validation.
Date: Tue, 13 Aug 2019 11:49:39 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1908131147390.95186@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com> <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com> <20190625182004.GA32075@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190625182004.GA32075@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: gmazyland@gmail.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, scottsh@microsoft.com, ebiggers@google.com, jmorris@namei.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


Hello Mike,
On Tue, 25 Jun 2019, Mike Snitzer wrote:

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
>

The v7 of this patch was Reviewed and Tested by Milan Broz. Could you tell 
me when this will be merged/next steps, if required I can post the patches 
again.

> Thanks,
> Mike
>
Regards,
Jaskaran
