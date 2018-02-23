From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: Integrity checking fails with Atmel SHA hw
	accelerator enabled
Date: Fri, 23 Feb 2018 10:53:51 +0200
Message-ID: <CAOtvUMdwtUg4dRq6=bcRjvtuJByQPUhJLGrLvF-Dxxt3fc1iJw@mail.gmail.com>
References: <CAAm399SnigNFoHgNL4v4q167K3NheyYHzRp76Lxi9xpu6W0YPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAm399SnigNFoHgNL4v4q167K3NheyYHzRp76Lxi9xpu6W0YPw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gigi W <gigitekwork@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 23, 2018 at 10:30 AM, Gigi W <gigitekwork@gmail.com> wrote:
> Hi
>
> I'm having some trouble using dm-verity for a squashfs root file system that
> seems to be related to the
> Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATMEL_SHA
>
> Some info about my setup:
> * I'm using a board with a SAMA5D4 CPU.
> * I'm using Yocto rocko for building an image for that device.
>
> The idea is that Using the 4.14.14 Kernel, Integrity checking using Kernel
> crypto fails with Atmel SHA hw accelerator enabled in kernel.
> By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=n`, and using the software
> sha256 algo, integrity checking works as expected.
> This is my kernel config [3]
>
> Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled, everything was
> ok.
>
> This is what triggers the error during verified boot:
>
> status=`veritysetup create vroot $root_dev $verity_dev --hash-offset
> $hashoffset $root_hash`
>
>     mount /dev/mapper/vroot /mnt/
>     mount_ok=`cat /proc/mounts | grep mnt`
>     if [ -z "$mount_ok" ] ; then
>         echo "Failed to mount $root_dev on mnt/"
>     else
>         echo "Switch rootfs"
>         exec switch_root -c /dev/console /mnt /sbin/init
>     fi
>
> The mount operation fails:
>
> device-mapper: verity: 179:4: metadata block 2 is corrupted
> EXT4-fs (dm-0): unable to read superblock
> device-mapper: verity: 179:4: metadata block 2 is corrupted
> EXT4-fs (dm-0): unable to read superblock
> device-mapper: verity: 179:4: metadata block 2 is corrupted
> EXT4-fs (dm-0): unable to read superblock
> device-mapper: verity: 179:4: metadata block 2 is corrupted
> SQUASHFS error: squashfs_read_data failed to read block 0x0
> squashfs: SQUASHFS error: unable to read squashfs_super_block
> device-mapper: verity: 179:4: metadata block 2 is corrupted
> FAT-fs (dm-0): unable to read boot sector
> mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output error
> Failed to mount /dev/mmcblk0p4 on mnt/
> reboot: Restarting system
> Reboot failed -- System halted
>
> Using veritysetup to verify the integrity against the hashes is successful,
> as it's not using the kernel for that ...
>
>
> So it looks like it something changed from 4.8.4 to 4.14.14.

If I am not mistaken the Atmel SHA hw accelerator is an async (read:
off CPU) crypto accelerator.
 Up until 4.12 (I think...) DM-Verity did not use async crypto
accelerators (even if present and have high
priority). I've changed this is commit d1ac3ff008fb ("dm verity:
switch to using asynchronous hash crypto API").

Is it possible that whatever issue you are seeing has always been
there and when DM-Verity started using
async. accelerators it was only exposed?


> Using the 4.14.14 kernel, I removed the patches that were applied on the
> atmel-sha.c file in the kernel, one by one, until I got the version from the
> 4.8.4
> Basically I reverted the changes from
> here:https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/log/drivers/crypto/atmel-sha.c?h=v4.14.14
> until I got this:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/log/drivers/crypto/atmel-sha.c?h=v4.8.4
>
> It still didn't work. I assumed something there broke the hashing, not the
> case. It was still not working with all those commits reverted.
>
> Furthermore, using the Cryptodev-linux module [1], and the sample [2],
> adapted to use sha256, I tested the output hashes, with
> CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then disabled.
>
> I got the same results in both cases, hardware and software algorithm. So it
> doesn't look like the SHA hw accelerator is broken.
>
>
> Any help is appreciated !
>
> Thanks in advanced and have a nice day.
>
>
> [1] http://cryptodev-linux.org/documentation.html
> [2] https://github.com/nmav/cryptodev-linux/blob/master/examples/sha.c
> [3]
> https://gist.githubusercontent.com/gmircea/6e1cc029ef5ed7a16b0fedb8b9524f66/raw/eece8a8faadd2de9373e150ef1daf3cf25f4135c/.config
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
