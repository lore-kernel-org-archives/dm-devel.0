From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH 0/7] patches: fix dm-raid1 race, bug 502927
Date: Mon, 30 Nov 2009 11:46:04 -0500
Message-ID: <4B13F6CC.5050305@redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On 11/18/09 07:09, Mikulas Patocka wrote:
> Hi
> 
> Here is the serie of 7 patches to hold write bios on dm-raid1 until 
> dmeventd does its job. It fixes bug 
> https://bugzilla.redhat.com/show_bug.cgi?id=502927 . The first 6 patches 
> are preparatory, they just move the code around, the last patch does the 
> fix.
> 
> I tested the thing, I managed to reproduce the bug (by manually stopping 
> dmeventd with STOP signal, failing primary mirror leg and writing to the 
> device) and I also verified that the patches fix the bug.
> 
> For non-dmeventd operation, the current behavior is wrong and I just keep 
> it as wrong as it was. There is no easy fix. It is just assume that if the 
> user doesn't use dmeventd, he can't activate failed disks again.
> 
> Mikulas
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

I reviewed and tested your patch set and looks good as a kernel side.

Reviewed-by: Takahiro Yasui <tyasui@redhat.com>
Tested-by: Takahiro Yasui <tyasui@redhat.com>

However, there are two issues found related to #8 and requires
improvements of dmeventd and lvm commands. This patch set is based on
the idea that dmeventd and lvm commands (lvconvert and vgreduce) fix
device failures and release blocked write I/Os. However, the blocked
write I/Os won't be released forever in some cases.

* Case 1: Medium error

When medium errors are detected for a write I/O and reported to dmeventd,
lvconvert is kicked from dmeventd, but nothing is done. Therefore, write
I/Os will be blocked forever. lvm commands will result in as follows:

# dmsetup status vg00-lv00
0 24576 mirror 2 253:1 253:2 23/24 1 DA 3 disk 253:0 A
# lvconvert --config devices{ignore_suspended_devices=1} --repair vg00/lv00
  The mirror is consistent, nothing to repair.
# vgreduce --removemissing vg00
  Volume group "vg00" is already consistent

# /usr/sbin/lvm version
  LVM version:     2.02.57(1)-cvs (2009-11-24)
  Library version: 1.02.41-cvs (2009-11-24)
  Driver version:  4.15.0
# uname -mr
2.6.31.6 i686


* Case 2: Sync error

dmeventd doesn't handle sync error ('S' showed by status) which happens
during recovery. When write I/Os are issued on out-of-sync region, they
are blocked, but dmeventd won't handle sync error and release blocked I/Os.

The error on the primary leg during recovery won't help and we need to
accept the system stop because of no valid leg. The error on the secondary
leg can be handled as the regular write error. We can fix this issue by
changing the error flag from DM_RAID1_SYNC_ERROR to DM_RAID1_WRITE_ERROR
so that this error can be handled by dmeventd.

Other idea is to change dmeventd so that it can handle sync error ('S')
on the secondary error. It is also easy to make a small patch.

Thanks,
Taka
