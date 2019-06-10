From: Jaskaran Singh Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [RFC PATCH v3 1/1] Add dm verity root hash pkcs7 sig
 validation
Date: Mon, 10 Jun 2019 16:27:21 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1906101624350.31134@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
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
>> The verification is to support cases where the roothash is not secured by
>
>> +	key = request_key(&key_type_user,
>> +			key_desc, NULL);
>> +	if (IS_ERR(key))
>> +		return PTR_ERR(key);
>
> You will need dependence on keyring here (kernel can be configured without it),
> try to compile it without CONFIG_KEYS selected.
>
> I think it is ok that  DM_VERITY_VERIFY_ROOTHASH_SIG can directly require CONFIG_KEYS.
> (Add depends on CONFIG_KEYS in KConfig)
>

DM_VERITY_VERIFY_ROOTHASH_SIG selects SYSTEM_DATA_VERIFICATION and 
SYSTEM_DATA_VERIFICATION selects KEYS so we should be OK here.

>
> Thanks,
> Milan
>
Thanks,
Jaskaran.
