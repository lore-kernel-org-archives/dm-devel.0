From: James Morris <jmorris@namei.org>
Subject: Re: [RFC PATCH v5 0/1] Add dm verity root hash pkcs7 sig
 validation.
Date: Fri, 28 Jun 2019 21:01:25 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1906282040490.15624@namei.org>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com> <20190628040041.GB673@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628040041.GB673@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, scottsh@microsoft.com, mpatocka@redhat.com, gmazyland@gmail.com
List-Id: dm-devel.ids

On Thu, 27 Jun 2019, Eric Biggers wrote:

> I don't understand your justification for this feature.
> 
> If userspace has already been pwned severely enough for the attacker to be
> executing arbitrary code with CAP_SYS_ADMIN (which is what the device mapper
> ioctls need), what good are restrictions on loading more binaries from disk?
> 
> Please explain your security model.

Let's say the system has a policy where all code must be signed with a 
valid key, and that one mechanism for enforcing this is via signed 
dm-verity volumes. Validating the signature within the kernel provides 
stronger assurance than userspace validation. The kernel validates and 
executes the code, using kernel-resident keys, and does not need to rely 
on validation which has occurred across a trust boundary.

You don't need arbitrary CAP_SYS_ADMIN code execution, you just need a 
flaw in the app (or its dependent libraries, or configuration) which 
allows signature validation to be bypassed.

The attacker now needs a kernel rather than a userspace vulnerability to 
bypass the signed code policy.

-- 
James Morris
<jmorris@namei.org>
