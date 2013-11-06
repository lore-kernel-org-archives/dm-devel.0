From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-thin: issues about resize the pool metadata size
Date: Wed, 06 Nov 2013 16:34:39 +0100
Message-ID: <527A618F.20402@redhat.com>
References: <CAKG=6JVTBPWNrFhvkFnkVT7=pihQmNm68Z-Jevyg3W4FpHEHiA@mail.gmail.com>
	<CAKG=6JUvgrRLxWnEOJoMCGCdhmD10Rwn+vvWwQ2_MnbR--R51g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKG=6JUvgrRLxWnEOJoMCGCdhmD10Rwn+vvWwQ2_MnbR--R51g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 6.11.2013 13:27, Wun-Yen Liang napsal(a):
> Hi, folks:
>
> Sorry for the insufficient information about my question last week.
>
> This is my environment for the test.
>      Kernel version : 3.12.0-rc7+
>      LVM version : 2.02.103
>
> I had currently done some test with the dm-thin targets.
> Here is my simple script to create a pool with 32MB metadata, and a volumn on it.
>
> $ sudo vgcreate vg /dev/sda1
> $ sudo lvcreate --type thin-pool --thinpool tpool vg --size 800G
> --poolmetadatasize 32M --alloc anywhere -c 64k
> $ sudo lvcreate --name lv vg --virtualsize 800G --type thin --thinpool tpool
>
> After formating, mounting, and some I/O test, the pool and volumn work well.
> Then I try to expand the metadata device to 64M with the following command
>
> $ sudo lvresize --poolmetadata +32M vg/tpool
>
> But I got error message on the terminal
>      Extending logical volume tpool_tmeta to 64.00 MiB.
>      device-mapper: resume ioctl on  failed: No space left on device
>      Unable to resume vg-tpool-tpoolool (253:3)
>      Problem reactivating tpool
>      libdevmapper exiting with 2 device(s) still suspended.
>

Yep - sorry about this one.

Kernel code has not yet been fixed - while lvm2 had left in expectation it 
will work with 1.9 target version.

lvm2 needs to be patched to disable support for metadata resize as it's still 
not yet supported online.


What you could always do offline is:

create some unusable empty LV and swap it instead of pool metadata
(lvconvert  --poolmetadata swapLV  --thinpool vg/existingpool)

then activate swapped LV (now with thin metadata)

thin_dump & thin_restore (or thin_repair) from this smaller LV to some newly 
allocate bigger LV.
Then thin_check this new LV if it's ok and swap it back again into thinpool.

A little bit ugly - but works for now.

Online metadata resize is not prioritized for now.

Zdenek
