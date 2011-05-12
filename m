From: Chris Lais <chris+linux@zenthought.org>
Subject: Re: dm-crypt on RAID5/6 write performance - cause &
 proposed solutions
Date: Thu, 12 May 2011 08:07:57 -0500
Message-ID: <BANLkTi=8+hocztMdJ=Q0_Lp7CSC_DJhr0w@mail.gmail.com>
References: <BANLkTin82MipJ1t3uExAHkgVP_09Q7+eWQ@mail.gmail.com>
	<4DCB9E9F.7040000@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DCB9E9F.7040000@redhat.com>
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

On Thu, May 12, 2011 at 3:47 AM, Milan Broz <mbroz@redhat.com> wrote:
> Hi,
>
> On 05/11/2011 09:11 PM, Chris Lais wrote:
>> I've recently installed a system with dm-crypt placed over a software
>> RAID5 array, and have noticed some very severe issues with write
>> performance due to the way dm-crypt works.
>>
>> Almost all of these problems are caused by dm-crypt re-ordering bios
>> to an extreme degree (as shown by blktrace), such that it is very hard
>> for the raid layer to merge them in to full stripes, leading to many
>> extra reads and writes.  There are minor problems with losing
>> io_context and seeking for CFQ, but they have far less impact.
>
> There is no explicit reordering of bios in dmcrypt.
>
> There are basically two situations were dmcrypt can reorder request:
>
> First is when crypto layer process request asynchronously
> (probably not a case here - according to your system spec you should
> be probably using AES-NI, right?)

No, the i7-870 does not have AES-NI.

>
> The second possible reordering can happen if you run 2.6.38 kernel and
> above, where the encryption run always on the cpu core which submitted it.
>
> First thing is to check what's really going on your system and why.
>
> - What's the io pattern here? Several applications issues writes
> in parallel? Can you provide commands how do you tested it?
>

The I/O pattern is a single dd command, using a block size of 1M or 2M
(does not produce a substantial difference).  And before you ask, this
/is/ one of the more major intended workloads, not a failed attempt at
a benchmark.

For the purposes of testing, I'm inputting from /dev/zero, but
normally it will be from an attached drive, which will sometimes be
slower than 180MB/s, and sometimes faster, but will always be
substantially faster than 30MB/s.

The I/O is being submitted by a dirty background thread, which is
jumping cores periodically (and which I don't think I can set the cpu
affinity of reliably).

I don't know why the caches aren't able to cope without very large
cache sizes (and *still* fail to assemble full stripes frequently),
unless the switching is happening very often and is splitting between
stripes (very likely, with a stripe size of 1MB).

Even with perfect splitting (as in the case with a parallel workload
with no reordering), the cache size for merging stripes will have to
be at least stripe_size*threads.  I have to think it we'd get far
better performance (for any media with large physical block sizes)
keeping the bios for each block/stripe together starting from the
upper-most block layer, but the system doesn't seem to be designed in
a way that makes this easy at all.


dd if=/dev/zero of=test bs=1048576:

submitted to dm-crypt layer (top-level) [dm-5]:
254,5    5      419     1.019698208  1533  Q   W 761892040 + 8 [flush-254:5]
254,5    5      420     1.019699440  1533  Q   W 761892048 + 8 [flush-254:5]
254,5    5      421     1.019700449  1533  Q   W 761892056 + 8 [flush-254:5]
254,5    5      422     1.019701510  1533  Q   W 761892064 + 8 [flush-254:5]
254,5    5      423     1.019702466  1533  Q   W 761892072 + 8 [flush-254:5]
254,5    5      424     1.019703528  1533  Q   W 761892080 + 8 [flush-254:5]
[snip]
254,5    1      418     1.030607158  1533  Q   W 761959960 + 8 [flush-254:5]
254,5    1      419     1.030608679  1533  Q   W 761959968 + 8 [flush-254:5]
254,5    1      420     1.030610084  1533  Q   W 761959976 + 8 [flush-254:5]
254,5    1      421     1.030611534  1533  Q   W 761959984 + 8 [flush-254:5]
254,5    1      422     1.030612991  1533  Q   W 761959992 + 8 [flush-254:5]
254,5    1      423     1.030614446  1533  Q   W 761960000 + 8 [flush-254:5]
[snip]
254,5    3      423     1.062605245  1533  Q   W 762049928 + 8 [flush-254:5]
254,5    3      424     1.062606044  1533  Q   W 762049936 + 8 [flush-254:5]
254,5    3      425     1.062606853  1533  Q   W 762049944 + 8 [flush-254:5]
254,5    3      426     1.062607616  1533  Q   W 762049952 + 8 [flush-254:5]
254,5    3      427     1.062609579  1533  Q   W 762049960 + 8 [flush-254:5]
254,5    3      428     1.062610503  1533  Q   W 762049968 + 8 [flush-254:5]
254,5    3      429     1.062611306  1533  Q   W 762049976 + 8 [flush-254:5]
254,5    3      430     1.062612079  1533  Q   W 762049984 + 8 [flush-254:5]
254,5    3      431     1.062612851  1533  Q   W 762049992 + 8 [flush-254:5]

submitted to LVM2 logical volume layer (directly below dm-5) [dm-3]:
254,3    1       34     1.055642427  6282  Q   W 761959960 + 8 [kworker/1:2]
254,3    3       39     1.055676830  6402  Q   W 762049928 + 8 [kworker/3:0]
254,3    5       35     1.055707355  6349  Q   W 761892040 + 8 [kworker/5:1]
254,3    3       40     1.055720657  6402  Q   W 762049936 + 8 [kworker/3:0]
254,3    1       35     1.055720737  6282  Q   W 761959968 + 8 [kworker/1:2]
254,3    3       41     1.055768875  6402  Q   W 762049944 + 8 [kworker/3:0]
254,3    5       36     1.055782164  6349  Q   W 761892048 + 8 [kworker/5:1]
254,3    1       36     1.055798939  6282  Q   W 761959976 + 8 [kworker/1:2]
254,3    3       42     1.055813807  6402  Q   W 762049952 + 8 [kworker/3:0]
254,3    5       37     1.055858505  6349  Q   W 761892056 + 8 [kworker/5:1]
254,3    3       43     1.055858595  6402  Q   W 762049960 + 8 [kworker/3:0]
254,3    1       37     1.055873828  6282  Q   W 761959984 + 8 [kworker/1:2]
254,3    3       44     1.055906790  6402  Q   W 762049968 + 8 [kworker/3:0]
254,3    5       38     1.055937878  6349  Q   W 761892064 + 8 [kworker/5:1]
254,3    3       45     1.055950798  6402  Q   W 762049976 + 8 [kworker/3:0]
254,3    1       38     1.055950939  6282  Q   W 761959992 + 8 [kworker/1:2]
254,3    3       46     1.055999370  6402  Q   W 762049984 + 8 [kworker/3:0]
254,3    5       39     1.056011893  6349  Q   W 761892072 + 8 [kworker/5:1]
254,3    1       39     1.056028144  6282  Q   W 761960000 + 8 [kworker/1:2]
254,3    3       47     1.056044505  6402  Q   W 762049992 + 8 [kworker/3:0]
254,3    5       40     1.056088439  6349  Q   W 761892080 + 8 [kworker/5:1]

http://zenthought.org/tmp/dm-crypt+raid5/dm-5,dm-3.single-thread.dd.zero.1M.tar.gz

> - Can you test older kernel (2.6.37) and check blktrace?
> Does it behave differently (it should - no reordering but all
> encryption just on one core.)
>
> - Also 2.6.39-rc (with flush changes) can have influence here,
> if you can test that the problems is still here, it would be nice
> (any fix will be based on this version).

I will test both of these when I'm able (should be in the next few
days), but I suspect 2.6.37 will perform much better if it's doing it
on one core with no re-ordering.

I'll have to let you know on 2.6.39-rc*.

>
> Anyway, we need to find what's really going before suggesting any fix.
>
>> Using RAID5/6 without dm-crypt does /not/ have these problems in my
>> setup, even with standard queue sizes, because the raid layer can
>> handle the stripe merging when the bios are not so far out of order.
>> Using lower RAID levels even with dm-crypt also does not have these
>> problems to such an extreme degree, because they don't need
>> read-parity-write cycles for partial stripes.
>
> Ah, so you are suggesting that the problem is caused by read/write
> interleaving (parity blocks)?
> Or you are talking about degraded mode as well?

Yes, it seems to be caused almost entirely by multiple partial stripe
writes to the same stripes, leading to extra unnecessary reads and
parity calculations (I do suspect that the reads themselves have much
more impact on this system, however).

I'm not talking about degraded mode (I don't expect that to perform well).

>
> Milan
>
>

--
Chris
