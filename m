From: hank peng <pengxihan@gmail.com>
Subject: Re: raid failure and LVM volume group availability
Date: Tue, 26 May 2009 00:09:25 +0800
Message-ID: <389deec70905250909h79c599b2gfd2229520f5a8ce0@mail.gmail.com>
References: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Connors <tconnors@rather.puzzling.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

2009/5/21 Tim Connors <tconnors@rather.puzzling.org>:
> I had a raid device (with LVM ontop of it) that failed through the di=
sks
> being disconnected in a long power failure that outlasted the UPS (th=
e
> computer, being a laptop, had its own builtin UPS).
>
> While I could just reboot the computer, I don't particularly want to
> reboot it just yet. =C2=A0Unfortunately, failing a raid device like t=
hat means
> that the volume group half disappears in a stream of I/O errors, but =
you
> can't stop the raid device because it still has something accessing i=
t
> (LVM), but you can't make LVM stop accessing it by making the volume =
group
> unavailable because it is suffering from I/O errors:
>
>> mdadm -S /dev/md0
> mdadm: fail to stop array /dev/md0: Device or resource busy
> Perhaps a running process, mounted filesystem or active volume group?
>
>> vgchange -an
> =C2=A0/dev/md0: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0Can't deactivate volume group "500_lacie" with 2 open logical v=
olume(s)
> =C2=A0Can't deactivate volume group "laptop_250gb" with 3 open logica=
l volume(s)
>
>> vgchange -an rotating_backup
> =C2=A0/dev/md0: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/md0: read failed after 0 of 4096 at 1000204664832: Input/o=
utput error
> =C2=A0/dev/md0: read failed after 0 of 4096 at 1000204722176: Input/o=
utput error
> =C2=A0/dev/md0: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/md0: read failed after 0 of 4096 at 4096: Input/output err=
or
> =C2=A0/dev/md0: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 644245028864: Input/o=
utput error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 644245086208: Input/o=
utput error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 4096: Input/output er=
ror
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0Volume group "rotating_backup" not found
>
> The lvm device file still exists,
>
>> ls -lA /dev/rotating_backup /dev/mapper/rotating_backup-rotating_bac=
kup
> brw-rw---- 1 root disk 254, 5 May 10 09:22 /dev/mapper/rotating_backu=
p-rotating_backup
>
> /dev/rotating_backup:
> total 0
> lrwxrwxrwx 1 root root 43 May 10 09:22 rotating_backup -> /dev/mapper=
/rotating_backup-rotating_backup
>
> however lvdisplay, vgdisplay and pvdisplay can't access it:
>> vgdisplay
> =C2=A0/dev/md0: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0/dev/dm-5: read failed after 0 of 4096 at 0: Input/output error
> =C2=A0--- Volume group ---
> =C2=A0VG Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 500_la=
cie
> ...
>
> but the raid device files don't exist (the drive I plugged back in la=
ter
> was given a new device name, /dev/sda1) and obviously raid is not ver=
y
> happy anymore:
>
>> cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdc1[0] sdb1[2](F)
> =C2=A0 =C2=A0 =C2=A0976762432 blocks [2/1] [U_]
> =C2=A0 =C2=A0 =C2=A0bitmap: 147/233 pages [588KB], 2048KB chunk
>> ls -lA /dev/sdc1 /dev/sdb1 /dev/md0
> ls: cannot access /dev/sdc1: No such file or directory
> ls: cannot access /dev/sdb1: No such file or directory
> brw-rw---- 1 root disk 9, 0 May 10 09:22 /dev/md0
>
>
> Does anyone know a way out of this, sans rebooting?
> I don't suspect I could just add /dev/sda1 back into the array becaus=
e I'm
> sure LVM would still complain about IO errors even if raid would let =
me (I
> suspect raid itself will also fail to add the disk back because it is
> still trying to be active but has no live disks so would be completel=
y
> inconsistent).
>
> Is it possible to force both lvm and md to give up on the device so I=
 can
> readd them without rebooting (since they're not going to be anymore
> corrupt yet than you'd expect from an unclean shutdown, because there=
's
> been no IO to them yet, so I should just be able to readd them, mount=
 and
> resync)?
>
Only one of disks in this RAID1failed, it should continue to work with
degraded state.
Why LVM complained with I/O errors??
> --
> TimC
> "This company performed an illegal operation but they will not be shu=
t
> down." =C2=A0 =C2=A0 -- Scott Harshbarger from consumer lobby group o=
n Microsoft
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
