From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v5 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Fri, 28 Jun 2019 13:34:51 -0700
Message-ID: <20190628203450.GD103946@gmail.com>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
 <20190628040041.GB673@sol.localdomain>
 <alpine.LRH.2.21.1906281242110.2789@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1906281242110.2789@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mpatocka@redhat.com, gmazyland@gmail.com
List-Id: dm-devel.ids

On Fri, Jun 28, 2019 at 12:45:11PM -0700, Jaskaran Singh Khurana wrote:
> 
> Hello Eric,
> On Thu, 27 Jun 2019, Eric Biggers wrote:
> 
> > On Wed, Jun 19, 2019 at 12:10:47PM -0700, Jaskaran Khurana wrote:
> > > This patch set adds in-kernel pkcs7 signature checking for the roothash of
> > > the dm-verity hash tree.
> > > The verification is to support cases where the roothash is not secured by
> > > Trusted Boot, UEFI Secureboot or similar technologies.
> > > One of the use cases for this is for dm-verity volumes mounted after boot,
> > > the root hash provided during the creation of the dm-verity volume has to
> > > be secure and thus in-kernel validation implemented here will be used
> > > before we trust the root hash and allow the block device to be created.
> > > 
> > > Why we are doing validation in the Kernel?
> > > 
> > > The reason is to still be secure in cases where the attacker is able to
> > > compromise the user mode application in which case the user mode validation
> > > could not have been trusted.
> > > The root hash signature validation in the kernel along with existing
> > > dm-verity implementation gives a higher level of confidence in the
> > > executable code or the protected data. Before allowing the creation of
> > > the device mapper block device the kernel code will check that the detached
> > > pkcs7 signature passed to it validates the roothash and the signature is
> > > trusted by builtin keys set at kernel creation. The kernel should be
> > > secured using Verified boot, UEFI Secure Boot or similar technologies so we
> > > can trust it.
> > > 
> > > What about attacker mounting non dm-verity volumes to run executable
> > > code?
> > > 
> > > This verification can be used to have a security architecture where a LSM
> > > can enforce this verification for all the volumes and by doing this it can
> > > ensure that all executable code runs from signed and trusted dm-verity
> > > volumes.
> > > 
> > > Further patches will be posted that build on this and enforce this
> > > verification based on policy for all the volumes on the system.
> > > 
> > 
> > I don't understand your justification for this feature.
> > 
> > If userspace has already been pwned severely enough for the attacker to be
> > executing arbitrary code with CAP_SYS_ADMIN (which is what the device mapper
> > ioctls need), what good are restrictions on loading more binaries from disk?
> > 
> > Please explain your security model.
> > 
> > - Eric
> > 
> 
> In a datacenter like environment, this will protect the system from below
> attacks:
> 
> 1.Prevents attacker from deploying scripts that run arbitrary executables on the system.
> 2.Prevents physically present malicious admin to run arbitrary code on the
>   machine.
> 
> Regards,
> Jaskaran

So you are trying to protect against people who already have a root shell?

Can't they just e.g. run /usr/bin/python and type in some Python code?

Or run /usr/bin/curl and upload all your secret data to their server.

- Eric
