From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v5 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Fri, 28 Jun 2019 07:12:08 +0200
Message-ID: <264565b3-ff3c-29c0-7df0-d8ff061087d3@gmail.com>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
 <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com>
 <20190627234149.GA212823@gmail.com>
 <alpine.LRH.2.21.1906271844470.22562@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <20190628030017.GA673@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628030017.GA673@sol.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>, Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 28/06/2019 05:00, Eric Biggers wrote:
>> Hello Eric,
>>
>> This started with a config (see V4). We didnot want scripts that pass this
>> parameter to suddenly stop working if for some reason the verification is
>> turned off so the optional parameter was just parsed and no validation
>> happened if the CONFIG was turned off. This was changed to a commandline
>> parameter after feedback from the community, so I would prefer to keep it
>> *now* as commandline parameter. Let me know if you are OK with this.
>>
>> Regards,
>> JK
> 
> Sorry, I haven't been following the whole discussion.  (BTW, you sent out
> multiple versions both called "v4", and using a cover letter for a single patch
> makes it unnecessarily difficult to review.)  However, it appears Milan were
> complaining about the DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE option which set the
> policy for signature verification, *not* the DM_VERITY_VERIFY_ROOTHASH_SIG
> option which enabled support for signature verification.  Am I missing
> something?  You can have a module parameter which controls the "signatures
> required" setting, while also allowing people to compile out kernel support for
> the signature verification feature.

Yes, this was exactly my point.

I think I even mention in some reply to use exactly the same config Makefile logic
as for FEC - to allow completely compile it out of the source:

ifeq ($(CONFIG_DM_VERITY_FEC),y)
dm-verity-objs                  += dm-verity-fec.o
endif

> Sure, it means that the signature verification support won't be guaranteed to be
> present when dm-verity is.  But the same is true of the hash algorithm (e.g.
> sha512), and of the forward error correction feature.  Since the signature
> verification is nontrivial and pulls in a lot of other kernel code which might
> not be otherwise needed (via SYSTEM_DATA_VERIFICATION), it seems a natural
> candidate for putting the support behind a Kconfig option.

On the other side, dm-verity is meant for a system verification, so if it depends
on SYSTEM_DATA_VERIFICATION is ... not so surprising :)

But the change above is quite easy and while we already have FEC as config option,
perhaps let's do it the same here.

Milan
