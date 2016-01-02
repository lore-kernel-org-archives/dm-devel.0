From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2 0/2] Introduce the bulk IV mode for improving the
 crypto engine efficiency
Date: Sat, 2 Jan 2016 23:46:08 +0100
Message-ID: <56885330.9080801@gmail.com>
References: <cover.1450233399.git.baolin.wang@linaro.org>
 <56711C0F.8030105@gmail.com>
 <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, Kent Overstreet <kent.overstreet@gmail.com>, keith.busch@intel.com, tj@kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 12/17/2015 08:37 AM, Baolin Wang wrote:
> Hi Milan,
> 
> On 16 December 2015 at 16:08, Milan Broz <gmazyland@gmail.com> wrote:
>> On 12/16/2015 04:18 AM, Baolin Wang wrote:
>>> From the dm-crypt performance report, we found it shows low efficiency
>>> with crypto engine for some mode (like ecb or xts mode). Because in dm
>>> crypt, it will map the IO data buffer with scatterlist, and send the
>>> scatterlist of one bio to the encryption engine, if send more scatterlists
>>> with bigger size at one time, that helps the engine palys best performance,
>>> which means a high encryption speed.
>>>
>>> But now the dm-crypt only map one segment (always one sector) of one bio
>>> with one scatterlist to the crypto engine at one time. which is more
>>> time-consuming and ineffective for the crypto engine. Especially for some
>>> modes which don't need different IV for each sector, we can map the whole
>>> bio with multiple scatterlists to improve the engine performance.
>>>
>>> But this optimization is not support some ciphers and IV modes which should
>>> do sector by sector and need different IV for each sector.
>>>
>>> Change since v1:
>>>  - Introduce one different IV mode.
>>>  - Change the conditions for bulk mode.
>>
>> I tried the patchset on 32bit Intel VM and kernel immediately OOPsed (just tried aes-ecb)...
>>
> 
> I've checked the code and I guess some macros I used with different
> definitions on different arch. Could you please try the new patchset
> with some optimization on your platform? It can work well on my arm
> board. Thanks.

Sorry for delay, I tried to compile it.
It doesn't crash now, but it also does not work.

You usage of IV in XTS mode is not correct - it cannot just work this way,
you have to initialize IV after each block. And just one write not aligned
to your large XTS block will corrupt it.

Did you tried to _read_ data you write to the device?

See this test :

# create  device with your patch
$ echo "test"|cryptsetup create -s 512 -c aes-xts-bulk tst /dev/sdg

# prepare random test file
$ dd if=/dev/urandom of=/src.img bs=1M count=16

# now copy the file to the plaintext device and drop caches
$ dd if=/src.img of=/dev/mapper/tst bs=1M count=16

$ echo 3 > /proc/sys/vm/drop_caches

# and verify that we are (not) reading the same data ...

$ dd if=/dev/mapper/tst of=/dst1.img bs=1M count=16

$ sha256sum /src.img /dst1.img 
5401119fa9975bbeebac58e0b2598bc87247a29e62417f9f58fe200b531602ad  /src.img
e9bf5efa95031fdb5adf618db141f48ed23f71b12c017b8a0cbe0a694f18b979  /dst1.img

(I think only first page-sized block is correct, because without direct-io
it writes in page-sized IOs.)


... or just try to mkfs and mount it
$ mkfs -t ext4  /dev/mapper/tst 

mke2fs 1.42.13 (17-May-2015)
Creating filesystem with 262144 4k blocks and 65536 inodes
...

$ mount /dev/mapper/tst /mnt/tst
mount: wrong fs type, bad option, bad superblock on /dev/mapper/tst,
       missing codepage or helper program, or other error


You approach simply does not work. (It will probably work for ECB mode but it is
unusable in real world.)


Anyway, I think that you should optimize driver, not add strange hw-dependent
crypto modes to dmcrypt. This is not the first crypto accelerator that is just not
suited for this kind of use.

(If it can process batch of chunks of data each with own IV, then it can work
with dmcrypt, but I think such optimized code should be inside crypto API,
not in dmcrypt.)

Milan
