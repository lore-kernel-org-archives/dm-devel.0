From: Paul Lawrence <paullawrence@google.com>
Subject: Re: [RFC] dm-bow working prototype
Date: Thu, 25 Oct 2018 11:13:19 -0700
Message-ID: <d00e361b-b849-3139-7e7a-02f05f3794c3@google.com>
References: <20181023212358.60292-1-paullawrence@google.com>
 <CAE8gLhmtrfprc93-XfomNEK5ZgxA_RFA0DnFrEnHjB0q31wkyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE8gLhmtrfprc93-XfomNEK5ZgxA_RFA0DnFrEnHjB0q31wkyg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: MegaBrutal <megabrutal@gmail.com>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, corbet@lwn.net, shli@kernel.org, linux-doc@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids


> The concept intrigued me, so I actually went on to try your prototype.
> I could apply it on v4.12 mainline (newer kernel versions introduce
> changes in "struct bio" in "include/linux/blk_types.h" those don't let
> the module compile – I think minor changes would be necessary to adapt
> to the new struct, though I didn't go into that).
>
> My test scenario:
> On a KVM, I created a 64M partition and formatted it to ext4, then put
> some random files on it and unmounted the FS. I then called "dmsetup
> create bowdev --table "0 131072 bow /dev/vdb1"". The
> "/dev/mapper/bowdev" file appeared as expected. I mounted it in
> read-only mode ("mount -vo ro /dev/mapper/bowdev /mnt") and run
> "fstrim -v /mnt". At this point, I tried to advance to STATE 1 ("echo
> 1 > /sys/block/dm-2/bow/state"), but I got a kernel BUG alert. The
> STATE did not change. I unmounted bowdev and removed the device
> ("dmsetup remove bowdev") which resulted in 2 subsequent kernel
> alerts. The device disappeared but it brought the kernel to an
> unstable state (various actions, like sync or trying to recreate the
> bow device, resulted in a hang). I could not get any further than
> this. I attached all the 3 kernel alerts in "dm-bow.dmesg.log".
This BUG_ON is caused if your file system writes blocks in sizes less 
than your page size. I will fix that before I attempt to upstream this 
driver assuming it gets accepted. If you can make your file system have 
4k blocks, you should be able to proceed (I hit this when I created a 
16MB ext4 fs on a loopback device)
> I have some questions about dm-bow:
> – How file system agnostic this feature is planned to be? While it is
> designed with ext4 in mind, is it going to work when used over other
> file systems, like FAT or BTRFS for example?
So long as the file system supports fstrim, it should work. If the file 
system creates a lot of churn say by running garbage collection, I'd not 
recommend it. And I really don't see the use case if the file system has 
any sort of snapshot capability - that will always be a superior 
solution to a block level one IMO.
> – Especially that BTRFS uses a CoW mechanism for even overwriting
> files (overwritten segments are written to a free area and only then
> gets the old data freed – except some specific conditions when
> NO_COW/nodatacow is involved). Won't BTRFS CoW mechanism confuse BoW,
> e.g. BTRFS will try to use space that BoW wants to use for backups?
> Note however, using BoW on BTRFS wouldn't have much point, since BTRFS
> has built-in features for snapshots. This leads me to my next
> question.
> – Why don't you just use BTRFS on Android? It basically provides a
> similar feature like BoW, and it is matured enough, switching
> snapshots are easy, etc.. However I see why it wouldn't be feasible
> for you, e.g. it is slower than ext4, which would matter for an
> Android device.
I'm not the ideal person to answer that question, but yes, I believe 
performance is an issue, along with the lack of file based encryption.
> – What if you run out of free disk space while updating? I guess you
> can just revert to the original state with BoW, but an update might
> require more disk space with BoW (and this is a thing, my Android
> always complains about not having enough space).
Well this question remains with any snapshot system, and indeed is there 
even before you have snapshots. There are really only two choices - 
throw away the snapshot and keep going, or fail the update and revert 
(with presumably the intent of freeing up more space and trying again.) 
Which we choose would be a policy decision - my goal would be to make 
sure either option is possible.
> – Can I really expect dm-bow to work on non-Android systems (like I
> tried it on an Ubuntu KVM)?
Yes, absolutely, but for the moment it's a work in progress and it 
contains an assumption about IO accesses being page aligned that is the 
reason for the failure you are seeing.
> – Do you have any prototype for the command line utility to be used
> for recovery?
Yes, and I will be uploading that. For the moment it is embedded in some 
Android specific code. It won't take long to extricate it though. It's 
actually very simple.

Paul
