From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 2/2] md: dm-crypt: Optimize the dm-crypt for XTS mode
Date: Tue, 15 Dec 2015 10:56:58 +0800
Message-ID: <CAMz4kuJn=2xE7XW79=fCa9qKRT5df9q6H0xNBnhYQveAZrF4ww@mail.gmail.com>
References: <cover.1450080755.git.baolin.wang@linaro.org>
	<02be0f42bf2d3c3d27b43bc050a783582b7af733.1450080755.git.baolin.wang@linaro.org>
	<566F5168.7010905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566F5168.7010905@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

>> +     /*
>> +      * Here we need to check if it can be encrypted or decrypted with
>> +      * bulk block, which means these encryption modes don't need IV or
>> +      * just need one initial IV. For bulk mode, we can expand the
>> +      * scatterlist entries to map the bio, then send all the scatterlists
>> +      * to the hardware engine at one time to improve the crypto engine
>> +      * efficiency. But it does not fit for other encryption modes, it has
>> +      * to do encryption and decryption sector by sector because every
>> +      * sector has different IV.
>> +      */
>> +     if (!strcmp(chainmode, "ecb") || !strcmp(chainmode, "xts"))
>> +             cc->bulk_crypto = 1;
>> +     else
>> +             cc->bulk_crypto = 0;n
>
> It is perfectly fine to use another IV even for XTS mode (despite it is not needed).
> You can use ESSIV for example, or benbi (big-endian variant of plain IV).
> (And it is really used for some LUKS devices.)
>
> How it is supposed to work in this case?
> If I read this patch correctly, it will completely corrupt data in this case because
> it expects plain (consecutive) IV...

The XTS mode can limit maximum size of each encrypted data unit
(typically a sector or disk block) to 2^20 AES blocks, so we can use
one bio as one encrypted data unit (we don't do it sector by sector).
It can generate one IV for each separate encrypted data unit. Please
correct me if I misunderstand something. Thanks.

>
> Also how it handles 32bit plain IV (that restart after 2TB)? (IOW plain IV, not plain64).
>
> Milan
>



-- 
Baolin.wang
Best Regards
