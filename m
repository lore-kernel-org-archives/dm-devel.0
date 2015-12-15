From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 2/2] md: dm-crypt: Optimize the dm-crypt for XTS mode
Date: Tue, 15 Dec 2015 19:35:56 +0800
Message-ID: <CAMz4kuJg=rH=T4uM=zEsYGRDMwHDXv8mjCN1LFmMaPi=z3ysCg@mail.gmail.com>
References: <cover.1450080755.git.baolin.wang@linaro.org>
	<02be0f42bf2d3c3d27b43bc050a783582b7af733.1450080755.git.baolin.wang@linaro.org>
	<566F5168.7010905@gmail.com>
	<CAMz4kuJn=2xE7XW79=fCa9qKRT5df9q6H0xNBnhYQveAZrF4ww@mail.gmail.com>
	<566FCD57.3000507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566FCD57.3000507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, Kent Overstreet <kent.overstreet@gmail.com>, keith.busch@intel.com, tj@kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 15 December 2015 at 16:20, Milan Broz <gmazyland@gmail.com> wrote:
> On 12/15/2015 03:56 AM, Baolin Wang wrote:
>>>> +     /*
>>>> +      * Here we need to check if it can be encrypted or decrypted with
>>>> +      * bulk block, which means these encryption modes don't need IV or
>>>> +      * just need one initial IV. For bulk mode, we can expand the
>>>> +      * scatterlist entries to map the bio, then send all the scatterlists
>>>> +      * to the hardware engine at one time to improve the crypto engine
>>>> +      * efficiency. But it does not fit for other encryption modes, it has
>>>> +      * to do encryption and decryption sector by sector because every
>>>> +      * sector has different IV.
>>>> +      */
>>>> +     if (!strcmp(chainmode, "ecb") || !strcmp(chainmode, "xts"))
>>>> +             cc->bulk_crypto = 1;
>>>> +     else
>>>> +             cc->bulk_crypto = 0;n
>>>
>>> It is perfectly fine to use another IV even for XTS mode (despite it is not needed).
>>> You can use ESSIV for example, or benbi (big-endian variant of plain IV).
>>> (And it is really used for some LUKS devices.)
>>>
>>> How it is supposed to work in this case?
>>> If I read this patch correctly, it will completely corrupt data in this case because
>>> it expects plain (consecutive) IV...
>>
>> The XTS mode can limit maximum size of each encrypted data unit
>> (typically a sector or disk block) to 2^20 AES blocks, so we can use
>> one bio as one encrypted data unit (we don't do it sector by sector).
>> It can generate one IV for each separate encrypted data unit. Please
>> correct me if I misunderstand something. Thanks.
>
> How this will help XTS-ESSIV, if you have to recalculate IV on every fixed
> encrypted block?
>
> TBH I think the whole patch here is doing something more than optimization
> and seriously touches cryptography part.
>
> Isn't in de-facto reinventing how the full disk encryption works today?
>
> All currently used systems use always disk encrypted block size (usually fixed
> to 512 bytes sectors like in dmcrypt) and these are encrypted independently with own IV.
> (We can talk about supporting larger disk encrypted block sizes but the principle
> it is still the same.
> And we played with it before already  http://www.saout.de/pipermail/dm-crypt/2013-January/003125.html)
>
> Every encrypted disk block here has independent initialization vector - IV (or tweak).
> For some modes (like XTS, LRW) this vector can produce just predictable linear offset,
> usually just block number (it must not repeat though; exceptions are legacy/compatible IVs).
> But it can be also something else - pseudorandom sequence like in ESSIV or so.
>
> If I understand your patch correctly, you are trying to use the XTS mode for
> the whole bulk request (there is only one IV for the bulk request and this bulk request
> is larger than currently fixed disk block size).

That's right.

>
> Isn't it even incompatible with the current XTS (aes-xts-plain64) encrypted disk
> per-sector where for every sectors new IV initialization is used?
> In fact I think that your approach would need to implement some different
> IV name (aes-xts-bulk) or something like that so userspace (cryptsetup)
> can be backward compatible.

Yes, that sounds reasonable.

>
> BTW the 2^20 block limit requirement (the XTS block size) is strict limit in some specifications.
> For example, NIST SP800-38E (XTS-AES) says:
> "The length of the data unit for any instance of an implementation of XTS-AES shall not exceed
> 2^20 AES blocks."

OK.

>
> There are a lot of badly implemented hw crypto accelerators where initialization cost
> is quite big and that performs better if it encrypts large blocks of data
> (it applies even for CBC mode). These are simply not designed for FDE use case...
>
> But IMHO this is not correct reason to patch it in kernel, moreover on dmcrypt layer
> with side effect of hardcoding another kind of crypto logic into dmcrypt.

You're right, this patch is used for hw crypto acceleration. As you
know some hardware engine may handle the IV for one bulk data, so the
software just generate one initial IV. Qualcomm's implementation for
xts mode just use one initial IV for one bulk data to improve the hw
engine efficiency.
(https://github.com/major91/Zeta-Chromium-N5/blob/master/drivers/md/dm-req-crypt.c)
So like you said I can change the IV name as 'aes-xts-bulk' or
something else to avoid the ESSIV, cause this can really gain big
improvements for hw engine.

>
> DMcrypt should be completely independent of used symmetric block encryption mode
> (that's the crypto API job). There will be new modes in future, there can be requests
> to switch to different IVs (similar to preventing CBC watermarking attack with
> predictable IV) etc.
>
> Milan



-- 
Baolin.wang
Best Regards
