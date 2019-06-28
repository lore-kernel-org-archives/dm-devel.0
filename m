From: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [RFC PATCH v5 0/1] Add dm verity root hash pkcs7 sig
 validation.
Date: Fri, 28 Jun 2019 16:27:28 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1906281552350.26685@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com> <20190628040041.GB673@sol.localdomain> <alpine.LRH.2.21.1906281242110.2789@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter> <20190628203450.GD103946@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190628203450.GD103946@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mpatocka@redhat.com, gmazyland@gmail.com
List-Id: dm-devel.ids


Hello Eric,

On Fri, 28 Jun 2019, Eric Biggers wrote:

>> In a datacenter like environment, this will protect the system from below
>> attacks:
>>
>> 1.Prevents attacker from deploying scripts that run arbitrary executables on the system.
>> 2.Prevents physically present malicious admin to run arbitrary code on the
>>   machine.
>>
>> Regards,
>> Jaskaran
>
> So you are trying to protect against people who already have a root shell?
>
> Can't they just e.g. run /usr/bin/python and type in some Python code?
>
> Or run /usr/bin/curl and upload all your secret data to their server.
>
> - Eric
>

You are correct, it would not be feasible for a general purpose distro, 
but for embedded systems and other cases where there is a more tightly 
locked-down system.

Regards,
Jaskaran.
