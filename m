From: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [RFC PATCH v4 1/1] Add dm verity root hash pkcs7 sig
 validation.
Date: Mon, 17 Jun 2019 13:39:52 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1906171338590.64763@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <20190613010610.4364-1-jaskarankhurana@linux.microsoft.com> <20190613010610.4364-2-jaskarankhurana@linux.microsoft.com> <ab346931-1d1b-bd2f-8314-ee4779bd44bf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ab346931-1d1b-bd2f-8314-ee4779bd44bf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, mpatocka@redhat.com
List-Id: dm-devel.ids



On Mon, 17 Jun 2019, Milan Broz wrote:

> On 13/06/2019 03:06, Jaskaran Khurana wrote:
> ...
>
>> Adds DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE: roothash signature *must* be
>> specified for all dm verity volumes and verification must succeed prior
>> to creation of device mapper block device.
>
> I had a quick discussion about this and one suggestion was
> to add dm-verity kernel module parameter instead of a new config option.
>
> The idea is that if you can control kernel boot commandline, you can add it
> there with the same effect (expecting that root device is on dm-verity as well).
>
> Isn't this better option or it is not going to work for you?

Seems like a better option to me, I will make the change and remove both 
the configs.

>
> Milan
>
Regards,
Jaskaran
