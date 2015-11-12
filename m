From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 16:20:41 +0800
Message-ID: <CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111181813.GD12236@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151111181813.GD12236@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, keith.busch@intel.com, jmoyer@redhat.com, Mark Brown <broonie@kernel.org>, tj@kernel.org, bart.vanassche@sandisk.com, "Garg, Dinesh" <dineshg@quicinc.com>
List-Id: dm-devel.ids

On 12 November 2015 at 02:18, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Nov 11 2015 at  4:31am -0500,
> Baolin Wang <baolin.wang@linaro.org> wrote:
>
>> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
>> decrypt block data, which can only hanle one bio at one time. As we know,
>> one bio must use the sequential physical address and it also has a limitation
>> of length. Thus it may limit the big block encyrtion/decryption when some
>> hardware support the big block data encryption.
>>
>> This patch series introduc the 'based-request' method to handle the data
>> encryption/decryption. One request can contain multiple bios, so it can
>> handle big block data to improve the efficiency.
>
> The duality of bio-based vs request-based code paths in DM core frankly
> sucks.  So the prospect of polluting dm-crypt with a similar duality is
> really _not_ interesting.
>
> Request-based DM requires more memory reserves per device than bio-based
> DM.  Also, you cannot stack request-based DM ontop of bio-based devices
> (be them DM, MD, etc) so request-based DM's underlying storage stack
> gets a lot less interesting with this change.
>
> That said, it could be that the benefits of supporting both bio-based
> and request-based DM in dm-crypt outweigh any overhead/limitations.  But
> you haven't given any performance data to justify this patchset.
>
> There needs to be a _really_ compelling benefit to do this.
>
> Also, FYI, having a big CONFIG knob to switch all of dm-crypt from
> bio-based to request-based is _not_ acceptable.  Both modes would need
> to be supported in parallel.  Could easily be that not all devices in a
> system will benefit from being request-based.
>
> Regardless, the risk of this change causing request-based DM to become
> more brittle than it already is concerns me.
>
> But I'm trying to keep an open mind... show me data that real hardware
> _really_ benefits and we'll go from there.  Again, it needs to be "OMG,
> this is amazing!" level performance to warrant any further serious
> consideration.

Thanks for your suggestion. But let me explain it again. Now for many
vendors, they supply the encryption hardware (such as AES engine) to
accelerate the encyrtion/decryption speed with handling a big block at
one time. So if we want the hardware engine can play the best
performance, the size of block handled at one time need to be
expanded.

But it can only handle one bio at one time for bio based dm-crypt, one
bio has a size limitation and one bio's size can't make the hardware
engine reach its best performance. So we want to introduce the request
based dm-crypt. For request based things, some sequential bios can
merged into one request to expand the IO size to be a big block
handled by hardware engine at one time. With the hardware
acceleration, it can improve the encryption/decryption speed.

I think 3 questions need to be clarified.

1. Are there ways of enhancing the dm-crypt bio-based target to overcome this?
The focus is the size limitation of one bio, its size can not meet the
hardware requirement. But one request can have a big block size with
merging multiple bios. So I think the request is the best choice.

2. Would any sort of bio aggregation mechanism help?
The request can combined sequential bios by block layer automatically.
But for bio aggregation, I think it will be similar to that, why do we
need recomplement it again?

3. perforamence data
It is just a simple dd test result, and will provide the formal report
in future. But from the simple test, we can see the improvement.
Hardware environment:
Board: beaglebone black
processor: AM335x 1GHz ARM Cortex-A8
RAM: 512M
Cipher: cbc(aes) with AES hardware engine

(1) bio based dm-crypt with hardware accelarate:
read 64M command: dd if=/dev/dm-0 of=/dev/null bs=512k count=128 iflag=direct
67108864 bytes (67 MB) copied, 11.6592 s, 5.8 MB/s
67108864 bytes (67 MB) copied, 11.6391 s, 5.8 MB/s
67108864 bytes (67 MB) copied, 11.6296 s, 5.8 MB/s

(2) request based dm-crypt with hardware accelarate
read 64M command: dd if=/dev/dm-0 of=/dev/null bs=512k count=128 iflag=direct
67108864 bytes (67 MB) copied, 5.16586 s, 13.0 MB/s
67108864 bytes (67 MB) copied, 5.19338 s, 12.9 MB/s
67108864 bytes (67 MB) copied, 5.19169 s, 12.9 MB/s

(3) bio based dm-crypt with hardware accelarate
write 64M command: dd if=/dev/zero of=/dev/dm-0 bs=512k count=128 iflag=direct
67108864 bytes (67 MB) copied, 13.6852 s, 4.9 MB/s
67108864 bytes (67 MB) copied, 14.0873 s, 4.8 MB/s
67108864 bytes (67 MB) copied, 13.6649 s, 4.9 MB/s

(4) request based dm-crypt with hardware accelarate
write 64M command: dd if=/dev/zero of=/dev/dm-0 bs=512k count=128 iflag=direct
67108864 bytes (67 MB) copied, 7.27832 s, 9.2 MB/s
67108864 bytes (67 MB) copied, 7.29051 s, 9.2 MB/s
67108864 bytes (67 MB) copied, 7.28318 s, 9.2 MB/s

From the simple result, we can see it at least has a double
improvement of the encryption performance.



-- 
Baolin.wang
Best Regards
