From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v5 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Thu, 27 Jun 2019 14:17:24 +0200
Message-ID: <568f2532-e46b-5ac7-4fc5-c96983702f2d@gmail.com>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
 <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, mpatocka@redhat.com
List-Id: dm-devel.ids

Hi,

I tried to test test the patch, two comments below.

On 19/06/2019 21:10, Jaskaran Khurana wrote:
> The verification is to support cases where the roothash is not secured by
> Trusted Boot, UEFI Secureboot or similar technologies.
> One of the use cases for this is for dm-verity volumes mounted after boot,
> the root hash provided during the creation of the dm-verity volume has to
> be secure and thus in-kernel validation implemented here will be used
> before we trust the root hash and allow the block device to be created.
> 
> The signature being provided for verification must verify the root hash and
> must be trusted by the builtin keyring for verification to succeed.
> 
> The hash is added as a key of type "user" and the description is passed to 
> the kernel so it can look it up and use it for verification.
> 
> Kernel commandline parameter will indicate whether to check (only if 
> specified) or force (for all dm verity volumes) roothash signature 
> verification.
> 
> Kernel commandline: dm_verity.verify_sig=1 or 2 for check/force root hash
> signature validation respectively.

1) I think the switch should be just boolean - enforce signatures for all dm-verity targets
(with default to false/off).

The rest should be handled by simple logic - if the root_hash_sig_key_desc option
is specified, the signature MUST be validated in the constructor, all errors should cause
failure (bad reference in keyring, bad signature, etc).

(Now it ignores for example bad reference to the keyring, this is quite misleading.)

If a user wants to activate a dm-verity device without a signature, just remove
optional argument referencing the signature.
(This is not possible with dm_verity.verify_sig set to true/on.)


2) All DM targets must provide the same mapping table status ("dmsetup table"
command) as initially configured.
The output of the command should be directly usable as mapping table constructor.

Your patch is missing that part, I tried to fix it, add-on patch is here
https://git.kernel.org/pub/scm/linux/kernel/git/mbroz/linux.git/commit/?h=dm-cryptsetup&id=a26c10806f5257e255b6a436713127e762935ad3
(feel free to fold it in your patch)


Thanks,
Milan
