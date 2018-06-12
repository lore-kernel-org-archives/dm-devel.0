From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [Query] Failed to create dm-crypt device when using AEAD type
Date: Tue, 12 Jun 2018 14:18:32 +0800
Message-ID: <c11a89dc-6ea9-20d1-0b0c-1fc7659b6560@huawei.com>
References: <33220afd-9a26-6133-ebf0-83b1268c34b7@huawei.com>
 <9aebff4d-71b0-9fe0-2ccc-38c80fc2179a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9aebff4d-71b0-9fe0-2ccc-38c80fc2179a@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, agk@redhat.com, snitzer@redhat.com
Cc: broonie@linaro.org, arnd@arndb.de, joakim.bech@linaro.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Milan,

Thanks so much! It worked. No integrity errors are printed after I wipe the device.
I am stuck in these errors for about a week. Thanks again!

Regards,
Xiongfeng

On 2018/6/12 13:50, Milan Broz wrote:
> On 06/12/2018 07:37 AM, Xiongfeng Wang wrote:
>> Hi Dm-crypt maintainers,
>>
>> Recently, I was testing the dm-crypt, but I failed to create dm-crypt device when using AEAD type.
>> I would really appreciate it if you could give some help.
>> The error info is as follows:
>> localhost:~ # export SIZE_INT=997376
>> 8 J 0"ost:~ # dmsetup create integ1 --table "0 $SIZE_INT integrity /dev/sdd2 0 2
>> localhost:~ #
>> dom \host:~ # dmsetup create crypt1 --table "0 $SIZE_INT crypt capi:gcm(aes)-ran
>>>  11ff33c6fb942655efb3e30cf4c0fd95f5ef483afca72166c530ae26151dd83b \
>>>  0 /dev/mapper/integ1 0 1 integrity:28:aead"
>> [ 1746.631559] device-mapper: crypt: Integrity AEAD, tag size 16, IV size 12.
>> [ 1746.649796] device-mapper: crypt: INTEGRITY AEAD ERROR, sector 997248
>> [ 1746.656382] device-mapper: crypt: INTEGRITY AEAD ERROR, sector 997248
>> [ 1746.662826] Buffer I/O error on dev dm-3, logical block 124656, async page read
> 
> These errors actually say that it works as expected! :)
> 
> If the underlying device has no integrity tags initialized, *every* access to device must generate
> integrity fail (because integrity tag is just not correct).
> 
> And the errors above are perhaps udev scans that are triggered by inotify when new device appears
> and it tries to find some signatures on uninitialized disk with blkid.
> 
> If you use cryptsetup, it will try to wipe the device, alternatively you can use
> dd (just be sure to use direct-io, page cache can generate some reads that fails as well),
> so in your case something like this:
> 
>   # dd if=/dev/zero of=/dev/maper/crypt1 bs=1M oflag=direct
> 
> should wipe the device (and store integrity tags).
> 
> If you activate your devices again (with the same parameters), no integrity errors should be present.
> 
> (I will write more documentation in next weeks regarding all this stuff, we have now better
> AEAD ciphers in 4.18.)
> 
> Thanks,
> Milan
>  
>>
>> I tested it both on qemu and hardware, and it printed the same error.
>> The error seems always on the last several sectors within the SIZE_INT I designated.
>> When I change the SIZE_INT, the error sector num also change.
>> I think something went wrong in the software, not the hardware.
>>
>> My board don't have AEAD accelerator, so it uses the software implemented cipher.
>> My kernel version is 4.17-rc3.
>>
>> The command is as follows:
>> export SIZE_INT=997376
>> dmsetup create integ1 --table "0 $SIZE_INT integrity /dev/sdd2 0 28 J 0"
>> dmsetup create crypt1 --table "0 $SIZE_INT crypt capi:gcm(aes)-random \
>>  11ff33c6fb942655efb3e30cf4c0fd95f5ef483afca72166c530ae26151dd83b \
>>  0 /dev/mapper/integ1 0 1 integrity:28:aead"
>>
>> This command comes from the commit information of the commit which introduce AEAD.
>> (commit ef43aa38063a6b2b3c6618e28ab35794f4f1fe29
>> dm crypt: add cryptographic data integrity protection (authenticated encryption))
>> I only change 'aes-gcm-random' to 'capi:gcm(aes)-random'
>>
>> Really appreciate it if you could have a look at it, Thanks!
>>
>> Regards,
>> Xiongfeng
>>
>>
> 
> .
> 
