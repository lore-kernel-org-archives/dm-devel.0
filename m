From: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [RFC PATCH v3 1/1] Add dm verity root hash pkcs7 sig
 validation
Date: Mon, 10 Jun 2019 14:22:56 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1906101411520.15431@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <20190607223140.16979-1-jaskarankhurana@linux.microsoft.com> <20190607223140.16979-2-jaskarankhurana@linux.microsoft.com> <54170d18-31c7-463d-10b5-9af8b666df0f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54170d18-31c7-463d-10b5-9af8b666df0f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids



On Sat, 8 Jun 2019, Milan Broz wrote:

> On 08/06/2019 00:31, Jaskaran Khurana wrote:
> Why is this different from existing FEC extension?
> FEC uses ifdefs in header to blind functions if config is not set.
>
> ifeq ($(CONFIG_DM_VERITY_FEC),y)
> dm-verity-objs                  += dm-verity-fec.o
> endif
>
> ...
>

The reasoning for doing it this way is that there might be scripts that 
create a device mapper device and then mount and use it, with the 
signature verification enabled in kernel the scripts would be passing the 
signature like:

veritysetup open params... --roothash-sig=<sig.p7>

If later due to some reason the DM_VERITY_VERIFY_ROOTHASH_SIG is disabled 
if we do not recognize the parameter then the scripts need to be changed 
or else they will fail with INVALID argument,
in current implementation the parameter for signature is always parsed but
enforced based on the config being set, so the scripts need not be 
changed.
Let me know if you still feel I should be changing this and I will be 
happy to make the change, just wanted to share my reasoning for this.

>
> Thanks,
> Milan
>
Regards,
Jaskaran
