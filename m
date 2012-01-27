From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dd to a striped device with 9 disks gets much lower
 throughput when oflag=direct used
Date: Fri, 27 Jan 2012 19:06:55 +0100
Message-ID: <4F22E7BF.9050303@redhat.com>
References: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
	<20120127085226.GA16520@infradead.org>
	<CACyXjPz1mKXtCnRnzVDotOES9QaD0kLKBP_r_GWe_FrgZq0g3g@mail.gmail.com>
	<4F22BFBC.1000709@redhat.com>
	<CACyXjPw0a8EhCSz=9tr4VN5r55c3L3jexpH3eCuWxnm+7MAQFg@mail.gmail.com>
	<4F22DDCA.4000201@redhat.com>
	<CACyXjPzwto1fRuDjmbF=currfkUeXJMHsjWkOnrv9Q+eH-RM1Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACyXjPzwto1fRuDjmbF=currfkUeXJMHsjWkOnrv9Q+eH-RM1Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 27.1.2012 18:48, Richard Sharpe napsal(a):
> On Fri, Jan 27, 2012 at 9:24 AM, Zdenek Kabelac<zkabelac@redhat.com>  wrote:
>> Dne 27.1.2012 16:28, Richard Sharpe napsal(a):
>>> Actually, so far I have not used any thinp devices, since from reading
>>> the documentation it seemed that, for what I am doing, I need to give
>>> thinp a mirrored device for its metadata and a striped device for its
>>> data, so I thought I would try just a striped device.
>>>
>>> Actually, I can cut that back to 8 devices in the stripe. I am using
>>> 4kiB block sizes and writing 256kiB blocks in the dd requests and
>>> there is no parity involved so there should be no read-modify-write
>>> cycles.
>>>
>>> I imagine that if I push the write sizes up to a MB or more at a time
>>> throughput will get better because at the moment each device is being
>>> given 32kIB or 16kiB (a few devices) with DIRECTIO and with a larger
>>> write size they will get more data at a time.
>>>
>>
>> Well I cannot tell how big influence proper alignment has in your case, but
>> it would be good to measure it in your case.
>> Do you use data_block_size equal to stripe size (256KiB 512blocks ?)
>
> I suspect not :-) However, I am not sure what you are asking. I
> believe that the stripe size is 9 * 8 * 512B, or 36kiB because I think
> I told it to use 8 sectors per device. This might be sub-optimal.
>
> Based on that, I think it will take my write blocks, of 256kiB, and
> write sectors that are (offset/512 + 256) mod 9 = {0, 1, 2, ... 8} to
> {disk 0, disk 1, disk 2, ... disk 8}.
>
> If I wanted perfectly strip-aligned writes then I think I should write
> something like 32*9kiB rather than the 32*8kiB I am currently writing.
>
> Is that what you are asking me?
>

There is surely number of things to test to get optimal performance from 
striped array and you probably need to make several experiments yourself to 
figure out the best settings.

I'd suggest to use 32KiB on each disk and combine them (8 x 32) to 256KiB 
array. Then use 512 data_block_size for thinp creation.

You may as well try just 4KiB on each drive and get 64KiB stripe and
use 128 blocks as data_block_size for thinp.

For 9 disks it's hard to say what is the 'optimal' number with 3.2 kernel and 
thinp - so it will need some playtime.
Maybe 32KiB on each disk - and use 128KiB data_block_size on 288KiB stripe.
(Though data block size heavily depends on the use case).

Zdenek
