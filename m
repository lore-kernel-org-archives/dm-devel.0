From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Wed, 24 Jun 2020 04:28:14 +0000
Message-ID: <CY4PR04MB37511A1673A58A2D66B4D6C0E7950@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
	<20200619165548.GA24779@redhat.com>
	<CY4PR04MB3751F148CCFAAC99A7F05CF7E7970@CY4PR04MB3751.namprd04.prod.outlook.com>
	<20200623150118.GA19657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On 2020/06/24 0:01, Mike Snitzer wrote:
> On Sun, Jun 21 2020 at  8:45pm -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> On 2020/06/20 1:56, Mike Snitzer wrote:
>>> On Fri, Jun 19 2020 at 12:41pm -0400,
>>> Ignat Korchagin <ignat@cloudflare.com> wrote:
>>>
>>>> This is a follow up from the long-forgotten [1], but with some more convincing
>>>> evidence. Consider the following script:
>>>>
>>>> #!/bin/bash -e
>>>>
>>>> # create 4G ramdisk
>>>> sudo modprobe brd rd_nr=1 rd_size=4194304
>>>>
>>>> # create a dm-crypt device with NULL cipher on top of /dev/ram0
>>>> echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0' | sudo dmsetup create eram0
>>>>
>>>> # create a dm-crypt device with NULL cipher and custom force_inline flag
>>>> echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0 1 force_inline' | sudo dmsetup create inline-eram0
>>>>
>>>> # read all data from /dev/ram0
>>>> sudo dd if=/dev/ram0 bs=4k iflag=direct | sha256sum
>>>>
>>>> # read the same data from /dev/mapper/eram0
>>>> sudo dd if=/dev/mapper/eram0 bs=4k iflag=direct | sha256sum
>>>>
>>>> # read the same data from /dev/mapper/inline-eram0
>>>> sudo dd if=/dev/mapper/inline-eram0 bs=4k iflag=direct | sha256sum
>>>>
>>>> This script creates a ramdisk (to eliminate hardware bias in the benchmark) and
>>>> two dm-crypt instances on top. Both dm-crypt instances use the NULL cipher
>>>> to eliminate potentially expensive crypto bias (the NULL cipher just uses memcpy
>>>> for "encyption"). The first instance is the current dm-crypt implementation from
>>>> 5.8-rc1, the second is the dm-crypt instance with a custom new flag enabled from
>>>> the patch attached to this thread. On my VM (Debian in VirtualBox with 4 cores
>>>> on 2.8 GHz Quad-Core Intel Core i7) I get the following output (formatted for
>>>> better readability):
>>>>
>>>> # plain ram0
>>>> 1048576+0 records in
>>>> 1048576+0 records out
>>>> 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 21.2305 s, 202 MB/s
>>>> 8479e43911dc45e89f934fe48d01297e16f51d17aa561d4d1c216b1ae0fcddca  -
>>>>
>>>> # eram0 (current dm-crypt)
>>>> 1048576+0 records in
>>>> 1048576+0 records out
>>>> 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 53.2212 s, 80.7 MB/s
>>>> 8479e43911dc45e89f934fe48d01297e16f51d17aa561d4d1c216b1ae0fcddca  -
>>>>
>>>> # inline-eram0 (patched dm-crypt)
>>>> 1048576+0 records in
>>>> 1048576+0 records out
>>>> 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 21.3472 s, 201 MB/s
>>>> 8479e43911dc45e89f934fe48d01297e16f51d17aa561d4d1c216b1ae0fcddca  -
>>>>
>>>> As we can see, current dm-crypt implementation creates a significant IO
>>>> performance overhead (at least on small IO block sizes) for both latency and
>>>> throughput. We suspect offloading IO request processing into workqueues and
>>>> async threads is more harmful these days with the modern fast storage. I also
>>>> did some digging into the dm-crypt git history and much of this async processing
>>>> is not needed anymore, because the reasons it was added are mostly gone from the
>>>> kernel. More details can be found in [2] (see "Git archeology" section).
>>>>
>>>> We have been running the attached patch on different hardware generations in
>>>> more than 200 datacentres on both SATA SSDs and NVME SSDs and so far were very
>>>> happy with the performance benefits.
>>>>
>>>> [1]: https://www.spinics.net/lists/dm-crypt/msg07516.html
>>>> [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
>>>>
>>>> Ignat Korchagin (1):
>>>>   Add DM_CRYPT_FORCE_INLINE flag to dm-crypt target
>>>>
>>>>  drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++----------
>>>>  1 file changed, 43 insertions(+), 12 deletions(-)
>>>>
>>>> -- 
>>>> 2.20.1
>>>>
>>>
>>> Hi,
>>>
>>> I saw [2] and have been expecting something from cloudflare ever since.
>>> Nice to see this submission.
>>>
>>> There is useful context in your 0th patch header.  I'll likely merge
>>> parts of this patch header with the more terse 1/1 header (reality is
>>> there only needed to be a single patch submission).
>>>
>>> Will review and stage accordingly if all looks fine to me.  Mikulas,
>>> please have a look too.
>>
>> Very timely: I was about to send a couple of patches to add zoned block device
>> support to dm-crypt :)
>>
>> I used [1] work as a base to have all _write_ requests be processed inline in
>> the submitter context so that the submission order is preserved, avoiding the
>> potential reordering of sequential writes that the normal workqueue based
>> processing can generate. This inline processing is done only for writes. Reads
>> are unaffected.
>>
>> To do this, I added a "inline_io" flag to struct convert_context which is
>> initialized in crypt_io_init() based on the BIO op.
>> kcryptd_crypt_write_io_submit() then uses this flag to call directly
>> generic_make_request() if inline_io is true.
>>
>> This simplifies things compared to [1] since reads can still be processed as is,
>> so there are no issued with irq context and no need for a tasklet.
>>
>> Should I send these patches as RFC to see what can be merged ? Or I can wait for
>> these patches and rebase on top.
> 
> It'd be ideal for this inline capability to address both Ignat's and
> your needs.  Given Ignat's changes _should_ enable yours (and Ignat
> clarified that having reads inline is actually important) then I think it
> best if you review Ignat's patch closely, rebase on it and test that it
> meets your needs.

We did a lot of testing of the Cloudflare inline crypto patch to understand
implications on performance when using a server with a large population of
drives. These tests used regular drives, but we already understood while going
through this exercise that inline writes are an easy way to support SMR drives.
Point is: all the testing went well, no problem whatsoever detected. I will
review Ignat's patch.

> I'll wait for you to do this work so that I can get your feedback on
> whether Ignat's changes look good for you too.  We have some time before
> the 5.9 merge window opens, lets just keep the communication going and
> make sure what we send upstream addresses everyone's needs and concerns.

I based my work on the Ignat patch that was available on github. While that
patch was initially developped for 4.x kernels, it was easy to apply onto 5.8-rc
and I used this as a base. I ended up changing a lot of things because:
1) I did not needed the inline reads, but they can be if the user want them to
be for performance  reasons.
2) I micro-optimized writes to conventional zones, allowing those to not be
inline, inlining only writes targetting sequential zones. The benefits of this
optimization are rather dubious though (read: hard to measure) as conventional
zones represent generally about 1% of the drive total capacity, and the tendency
is to move toward SMR drives that only have sequential zones. Dropping this
optimization is fine. It simplifies things and adding SMR support is basically
reduced to adding the report zones method and marking dm-crypt features with
DM_TARGET_ZONED_HM. All on top of Ignat's patch.

Please see my following reply to Ignat's idea of separating read & write
inlining with 2 flags.

> 
> Thanks,
> Mike
> 
> 


-- 
Damien Le Moal
Western Digital Research
