From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v5 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Thu, 27 Jun 2019 21:00:41 -0700
Message-ID: <20190628040041.GB673@sol.localdomain>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mpatocka@redhat.com, gmazyland@gmail.com
List-Id: dm-devel.ids

On Wed, Jun 19, 2019 at 12:10:47PM -0700, Jaskaran Khurana wrote:
> This patch set adds in-kernel pkcs7 signature checking for the roothash of
> the dm-verity hash tree.
> The verification is to support cases where the roothash is not secured by
> Trusted Boot, UEFI Secureboot or similar technologies.
> One of the use cases for this is for dm-verity volumes mounted after boot,
> the root hash provided during the creation of the dm-verity volume has to
> be secure and thus in-kernel validation implemented here will be used
> before we trust the root hash and allow the block device to be created.
> 
> Why we are doing validation in the Kernel?
> 
> The reason is to still be secure in cases where the attacker is able to
> compromise the user mode application in which case the user mode validation
> could not have been trusted.
> The root hash signature validation in the kernel along with existing
> dm-verity implementation gives a higher level of confidence in the
> executable code or the protected data. Before allowing the creation of
> the device mapper block device the kernel code will check that the detached
> pkcs7 signature passed to it validates the roothash and the signature is
> trusted by builtin keys set at kernel creation. The kernel should be
> secured using Verified boot, UEFI Secure Boot or similar technologies so we
> can trust it.
> 
> What about attacker mounting non dm-verity volumes to run executable
> code?
> 
> This verification can be used to have a security architecture where a LSM
> can enforce this verification for all the volumes and by doing this it can
> ensure that all executable code runs from signed and trusted dm-verity
> volumes.
> 
> Further patches will be posted that build on this and enforce this
> verification based on policy for all the volumes on the system.
> 

I don't understand your justification for this feature.

If userspace has already been pwned severely enough for the attacker to be
executing arbitrary code with CAP_SYS_ADMIN (which is what the device mapper
ioctls need), what good are restrictions on loading more binaries from disk?

Please explain your security model.

- Eric
