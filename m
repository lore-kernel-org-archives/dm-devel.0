From: Andrew Morton <akpm@osdl.org>
Subject: Re: Data corruption with raid5/dm-crypt/lvm/reiserfs on
	2.6.19.2
Date: Mon, 22 Jan 2007 11:56:52 -0800
Message-ID: <20070122115652.1f7862e1.akpm@osdl.org>
References: <d00698fb0701181211l480966e5o6f10db9300d4c8aa@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d00698fb0701181211l480966e5o6f10db9300d4c8aa@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: noah <noah123@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

> On Thu, 18 Jan 2007 21:11:58 +0100 noah <noah123@gmail.com> wrote:
> Hi!
> 
> I'm experiencing data corruption in the following setup:
> 
> 1. mdadm --create /dev/md0 -n3 -lraid5 /dev/hda1 /dev/hdc1 /dev/hde1
> 2. cryptsetup -c aes-cbc-essiva:sha256 luksFormat /dev/md0 mykey
> 3. cryptsetup -d mykey luksOpen /dev/md0 cryptvol
> 4. pvcreate /dev/mapper/cryptvol
> 5. vgcreate vg0 /dev/cryptvol
> 6. lvcreate -n root  -L10G vg0
> 7. mkreiserfs -q /dev/vg0/root
> 8. mkdir /.newroot; mount /dev/vg0/root /.newroot
> 9. mkdir /.realroot; mount -o bind / /.realroot
> 10. tar cf - -C /.realroot|tar xvpf - -C /.newroot
> 
> With Linux 2.6.18 (it's broken, OK, but there's still something wrong
> even in 2.6.19.2 so keep on reading) I started getting warnings from
> ReiserFS indicating severe data corruptions.  Reiserfsck confirms
> this.  It usually happened while extracting the Linux source tree.
> 
> So after asking around I found out dm-crypt had a bug[1] fixed in
> early December.
> It got fixed in 2.6.19 and the fix was backported and included in 2.6.18.6[2].
> 
> Fine, so I upgraded to 2.6.18.6, rebuilt the array from scratch and
> did the whole procedure again.
> No messages from reiserfs in dmesg this time, but reiserfsck still
> revealed severe data corruption.
> I also found compressed archives and ISO-images for which I had
> md5sums to be corrupt.
> 
> I then upgraded to 2.6.19.2 with the exact same result as with 2.6.18.6.
> I even verified this on a fairly new computer with different hardware
> (Intel CPU and chipset).
> 
> Figured it maybe was some kind of race condition so on my second try
> on 2.6.19.2, when recreating the array, I let md finish resyncing it
> before copying over the files.
> This time, reiserfsck didn't complain.
> 
> Just for the sake of fun, I did the whole thing again, rebuilding the
> array from scratch, let md resync the third drive and then I started
> to copy over all files again.  Thinking the cause of the problem was
> heavy disk I/O I tried to stress the other LVM volumes residing on md0
> using tar during the copy.  Everything seemed fine; no problems arose.
> 
> Did a few reboots and confirmed that reiserfsck didn't have any
> complaints on any of the filesystems residing on the LVM volumes on
> md0.
> 
> Started using the machine as normal, and half a day later I unmounted
> the filesystems and ran reiserfsck just to make sure everything still
> was OK.  Unfortunately, it wasn't.
> 
> 
> The drives in the array are three brand new drives, 2x250GB and one
> 200GB, all three IDE drives.
> According to SMART there's no problems with them.  And they worked
> fine in my previous RAID1 setup with dm-crypt and LVM, by the way.
> The computer itself is an Athlon XP with less than 1GB of RAM on a M/B
> with nForce2 chipset FWIW.  No memory errors were detected with
> memtest86+ (I completed the full test).
> I haven't tried using another filesystem as I've got quite a lot of
> faith in reiserfs's stability.
> 
> Is anybody else experiencing these problems?
> Unfortunately I'm only able to do limited testing due to busy days,
> but I'd love to help if I can.
> 
> 
> [1] Here's a thread on the recently fixed data corruption bug in dm-crypt
> http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/1974
> 
> [2] The backport of the dm-crypt fix for 2.6.18.6 is here
> http://uwsg.iu.edu/hypermail/linux/kernel/0612.1/2299.html

There has been a long history of similar problems when raid and dm-crypt
are used together.  I thought a couple of months ago that we were hot on
the trail of a fix, but I don't think we ever got there.  Perhaps
Christophe can comment?
