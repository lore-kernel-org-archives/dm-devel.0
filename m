From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [ Regressions ] linux next 20201008: blk_update_request: I/O
 error, dev sda, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
Date: Fri, 9 Oct 2020 01:35:47 +0530
Message-ID: <CA+G9fYseTYRWoHUNZ=j4mjFs9dDJ-KOD8hDy+RnyDPx75HcVWw@mail.gmail.com>
References: <CA+G9fYtwisRJtN4ht=ApeWc1jWssDok-7y2wee6Z0kzMP-atKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA+G9fYtwisRJtN4ht=ApeWc1jWssDok-7y2wee6Z0kzMP-atKg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, drbd-dev@lists.linbit.com, "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" <linux-ide@vger.kernel.org>, linux-raid@vger.kernel.org, linux-mmc <linux-mmc@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids

On Thu, 8 Oct 2020 at 23:41, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> There are two major regressions noticed on linux next tag 20201008.
> I will bisect this problem and get back to you.

Reverting scsi: patch set on  linux next tag 20201008 fixed reported problems.
git revert --no-edit 653eb7c99d84..ed7fb2d018fd


>
> 1) qemu_i386 and qemu_x86 boot failed due to mount rootfs failing [1].
>
>         Starting Remount Root and Kernel File Systems...
> [    1.750740] ata1.00: WARNING: zero len r/w req
> [    1.751423] ata1.00: WARNING: zero len r/w req
> [    1.752361] ata1.00: WARNING: zero len r/w req
> [    1.753400] ata1.00: WARNING: zero len r/w req
> [    1.754447] ata1.00: WARNING: zero len r/w req
> [    1.755529] ata1.00: WARNING: zero len r/w req
> [    1.756630] sd 0:0:0:0: [sda] tag#0 FAILED Result:
> hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
> [    1.758622] sd 0:0:0:0: [sda] tag#0 CDB: Synchronize Cache(10) 35
> 00 00 00 00 00 00 00 00 00
> [    1.760576] blk_update_request: I/O error, dev sda, sector 0 op
> 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
> [    1.761534] Buffer I/O error on dev sda, logical block 0, lost sync
> page write
> [    1.764158] EXT4-fs (sda): I/O error while writing superblock
>
>
> 2) the devices boot pass but mkfs failed on x86_64, i386, arm64
> Juno-r2 devices [2].
>
> mkfs -t ext4 /dev/disk/by-id/ata-TOSHIBA_MG03ACA100_37O9KGL0F
> [   72.159789] ata3.00: WARNING: zero len r/w req
> [   72.164287] ata3.00: WARNING: zero len r/w req
> [   72.168774] ata3.00: WARNING: zero len r/w req
> [   72.168777] ata3.00: WARNING: zero len r/w req
> [   72.168779] ata3.00: WARNING: zero len r/w req
> [   72.168781] ata3.00: WARNING: zero len r/w req
> [   72.168786] sd 2:0:0:0: [sda] tag#5 FAILED Result:
> hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
> [   72.168788] sd 2:0:0:0: [sda] tag#5 CDB: Synchronize Cache(10) 35
> 00 00 00 00 00 00 00 00 00
> [   72.168791] blk_update_request: I/O error, dev sda, sector 0 op
> 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> metadata:
>   git branch: master
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>   git commit: e4fb79c771fbe2e6fcb3cffa87d5823a9bbf3f10
>   git describe: next-20201008
>   make_kernelversion: 5.9.0-rc8
>   kernel-config:
> https://builds.tuxbuild.com/pOW-FELX2VUycejkuyiKZg/kernel.config
>
>
> steps to reproduce:
> --------------------------
> 1) qemu boot command:
>
> /usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net
> nic,model=virtio,macaddr=DE:AD:BE:EF:66:06 -net tap -m 1024 -monitor
> none -kernel bzImage --append "root=/dev/sda  rootwait
> console=ttyS0,115200" -hda
> rpb-console-image-lkft-intel-corei7-64-20200723162342-41.rootfs.ext4
> -m 4096 -smp 4 -nographic
>
> 2) boot x86_64 with linux next 20201008 tag kernel and attach SDD drive.
>
> mkfs -t ext4 /dev/<drive-partition>
>
> Full log links,
> [1 ]https://lkft.validation.linaro.org/scheduler/job/1823906#L688
> [2] https://lkft.validation.linaro.org/scheduler/job/1823938#L2065
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
