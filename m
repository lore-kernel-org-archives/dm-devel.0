Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F018175A80
	for <dm-devel@lists.linux.dev>; Wed, 15 Apr 2026 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776216669; cv=none; b=Wu1XVdEOjrNMHjuzMAH49F7QlHNx0I4o+V/KapKtUhSSO8FxDxddjNju/DmSnSHeqSvm93Yqikb5FeFIkeBobEs8crZkEtNWhAZANm1dzClbnxouOw+GfB6L3DnZ3bHvplxzgArYQGwcIk3OkajYQHouyAvSDQxD/H2vLA8fxkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776216669; c=relaxed/simple;
	bh=L+loQVx5Y+tfwBEJq+sKJJPg5ZN+4dCmIRpcWGILUkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mtem3S84IubRgswUwdG26Hfu0GSelD9aX9JwL6IyWdW/JE46PwNZBAeBKsBY/QFvdHwVWZKlYgGKnN3ZzBnu0OANIDqUxd83E3eI++ASyuvj7XVDaTwMYTbYMBlb31a12GrSQJReq+e2ESpZHrGndrVLE/adNO48t/+gnU9BwHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nmWj86jp; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nmWj86jp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=j0
	o59kTS/Zhg7PsIWgAQ7cAffxHUiiQn3ZNVavmjMkI=; b=nmWj86jpyTbdoI/s0J
	F9Yz2P3UNlYblQsHleHqDfxja7WK7n+rSjsk5VjTYXaVR13iPC28Vw4D5FOMmXQd
	cNSaEfWh8yFVms/VPw2GLfsgdUW7DAm9YwgLJxliNv6zQDy05FSwuxMtGFEkCUNC
	ZYxOR54T6y8YcVRee/06yzDeE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgC3ZrHG6d5phKZLAA--.155S2;
	Wed, 15 Apr 2026 09:28:43 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
	Li Nan <linan666@huaweicloud.com>,
	Song Liu <song@kernel.org>,
	Xiao Ni <xni@redhat.com>,
	Nigel Croxon <ncroxon@redhat.com>,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] md/raid5: Don't set bi_status on STRIPE_WAIT_RESHAPE
Date: Wed, 15 Apr 2026 09:28:38 +0800
Message-Id: <20260415012838.395439-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ad6FNUtSCS_zTrHW@redhat.com>
References: <20260413224556.1914504-1-bmarzins@redhat.com> <0e53701a-2471-9b72-eef8-27b168a0f3ea@huaweicloud.com> <717caf7b-03ef-41d8-bbb3-f6ce5d4a49fa@fnnas.com> <ad6FNUtSCS_zTrHW@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgC3ZrHG6d5phKZLAA--.155S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfJr13KF13Ar4fAF4UGFW3Jrb_yoW8JFWfGo
	Wvyws8A34UXwsFg3WqkF4xJw17X3yYgF9xWrW5Wr9FkFW7Jws8Can5Cr43J3y7Gw4v9r95
	K34UXayrCF48t34fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RMuWlDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Qu+T2ne6ctqHgAA3y

Hi Ben,

On Tue, Apr 14, 2026 at 02:19:33PM -0400, Benjamin Marzinski wrote:
> Yang Xiuwei, have you verified that this fix actually solves your
> problems? If a dm map() function completes with DM_MAPIO_REQUEUE, and
> the device is in a noflush suspend, it shouldn't set the error on the
> original bio, regardless of the clone bio. It should requeue the bio. If
> a dm map() function completes with DM_MAPIO_REQUEUE, and the device
> isn't in a noflush suspend, the original bio will always be completed
> with an error.
>
> To me, it seems more likely that what you are seeing is
> make_stripe_request() returning STRIPE_WAIT_RESHAPE when the dm device
> isn't actually in a noflush suspend. I have seen this myself.
>
> -Ben

I tested the version that removes setting bi->bi_status to BLK_STS_RESOURCE
in the STRIPE_WAIT_RESHAPE path you described. In my environment it did
not fix the failure below.

Sorry for the slow response. The earlier fix still did not solve the
problem in my testing. I am not very familiar with this area yet and wanted
to learn more before continuing the analysis, but other work meant I have
not had time to pick it up again until now.

I have not yet tested the dm-raid RFC patch from your follow-up message,
but I plan to try it when I have time.

The failure was observed while running the LVM2 shell test
lvconvert-raid-reshape-stripes-load-fail.sh. Below is the test log (kernel
messages and harness output), followed by the script contents.

Test log:
| [ 0:10.630]   WARNING: This metadata update is NOT backed up.
| [ 0:10.632] aux disable_dev $dev1
| [ 0:10.748] #lvconvert-raid-reshape-stripes-load-fail.sh:68+ aux disable_dev /dev/mapper/LVMTEST1351568pv1
| [ 0:10.748] Disabling device /dev/mapper/LVMTEST1351568pv1 (252:5)
| [ 0:10.868] [73439.222696] <6> 2026-01-20 13:59:47  md: reshape of RAID array mdX
| [ 0:10.868] aux delay_dev "$dev2" 0 50
| [ 0:10.871] #lvconvert-raid-reshape-stripes-load-fail.sh:69+ aux delay_dev /dev/mapper/LVMTEST1351568pv2 0 50
| [ 0:10.871] check lv_first_seg_field $vg/$lv1 segtype "raid5_ls"
| [ 0:10.886] [73439.231558] <3> 2026-01-20 13:59:47  Buffer I/O error on dev dm-5, logical block 0, async page read
| [ 0:10.886] #lvconvert-raid-reshape-stripes-load-fail.sh:70+ check lv_first_seg_field LVMTEST1351568vg/LV1 segtype raid5_ls
| [ 0:10.886] WARNING: Couldn't find device with uuid Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ.
| [ 0:10.910] WARNING: VG LVMTEST1351568vg is missing PV Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ (last written to /dev/mapper/LVMTEST1351568pv1).
| [ 0:10.910] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rimage_0 while checking used and assumed devices.
| [ 0:10.910] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rmeta_0 while checking used and assumed devices.
| [ 0:10.910] check lv_first_seg_field $vg/$lv1 stripesize "64.00k"
| [ 0:10.912] #lvconvert-raid-reshape-stripes-load-fail.sh:71+ check lv_first_seg_field LVMTEST1351568vg/LV1 stripesize 64.00k
| [ 0:10.912] WARNING: Couldn't find device with uuid Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ.
| [ 0:10.933] WARNING: VG LVMTEST1351568vg is missing PV Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ (last written to /dev/mapper/LVMTEST1351568pv1).
| [ 0:10.933] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rimage_0 while checking used and assumed devices.
| [ 0:10.933] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rmeta_0 while checking used and assumed devices.
| [ 0:10.933] check lv_first_seg_field $vg/$lv1 data_stripes 15
| [ 0:10.935] #lvconvert-raid-reshape-stripes-load-fail.sh:72+ check lv_first_seg_field LVMTEST1351568vg/LV1 data_stripes 15
| [ 0:10.935] WARNING: Couldn't find device with uuid Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ.
| [ 0:10.956] [73439.292632] <3> 2026-01-20 13:59:47  md: super_written gets error=-5
| [ 0:10.956] [73439.297679] <2> 2026-01-20 13:59:47  md/raid:mdX: Disk failure on dm-22, disabling device.
| [ 0:10.956] [73439.304626] <2> 2026-01-20 13:59:47  md/raid:mdX: Operation continuing on 15 devices.
| [ 0:10.956] WARNING: VG LVMTEST1351568vg is missing PV Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ (last written to /dev/mapper/LVMTEST1351568pv1).
| [ 0:10.956] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rimage_0 while checking used and assumed devices.
| [ 0:10.956] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rmeta_0 while checking used and assumed devices.
| [ 0:10.956] check lv_first_seg_field $vg/$lv1 stripes 16
| [ 0:10.958] #lvconvert-raid-reshape-stripes-load-fail.sh:73+ check lv_first_seg_field LVMTEST1351568vg/LV1 stripes 16
| [ 0:10.958] WARNING: Couldn't find device with uuid Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ.
| [ 0:10.979] WARNING: VG LVMTEST1351568vg is missing PV Xprpyw-NTcw-RDRr-HzMg-LDZN-ZDIL-0Q2LoQ (last written to /dev/mapper/LVMTEST1351568pv1).
| [ 0:10.979] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rimage_0 while checking used and assumed devices.
| [ 0:10.979] WARNING: Couldn't find all devices for LV LVMTEST1351568vg/LV1_rmeta_0 while checking used and assumed devices.
| [ 0:10.979] 
| [ 0:10.981] kill -9 %%
| [ 0:10.981] #lvconvert-raid-reshape-stripes-load-fail.sh:75+ kill -9 %%
| [ 0:10.981] wait
| [ 0:10.981] #lvconvert-raid-reshape-stripes-load-fail.sh:76+ wait
| [ 0:10.981] rm -fr "$mount_dir/[12]"
| [ 0:11.787] [73439.674065] <4> 2026-01-20 13:59:48  make_stripe_request: 24 callbacks suppressed
| [ 0:11.787] [73439.674074] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.674086] <3> 2026-01-20 13:59:48  Buffer I/O error on dev dm-43, logical block 1074, lost sync page write
| [ 0:11.787] [73439.681096] <6> 2026-01-20 13:59:48  md: mdX: reshape interrupted.
| [ 0:11.787] [73439.682723] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.691180] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.699766] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.708347] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.716934] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.725519] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.734099] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.734574] <2> 2026-01-20 13:59:48  EXT4-fs error (device dm-43): ext4_check_bdev_write_error:225: comm kworker/u388:2: Error while async write back metadata
| [ 0:11.787] [73439.742682] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.787] [73439.764081] <3> 2026-01-20 13:59:48  Aborting journal on device dm-43-8.
| [ 0:11.787] [73439.778040] <3> 2026-01-20 13:59:48  dm-raid456: io across reshape position while reshape can't make progress
| [ 0:11.788] [73439.778043] <3> 2026-01-20 13:59:48  Buffer I/O error on dev dm-43, logical block 740, lost sync page write
| [ 0:11.788] [73439.795025] <3> 2026-01-20 13:59:48  JBD2: I/O error when updating journal superblock for dm-43-8.
| [ 0:11.788] [73439.802674] <2> 2026-01-20 13:59:48  EXT4-fs error (device dm-43): ext4_journal_check_start:85: comm cp: Detected aborted journal
| [ 0:11.788] [73439.802673] <2> 2026-01-20 13:59:48  EXT4-fs error (device dm-43): ext4_journal_check_start:85: comm cp: Detected aborted journal
| [ 0:11.788] [73440.032568] <3> 2026-01-20 13:59:48  Buffer I/O error on dev dm-43, logical block 1, lost sync page write
| [ 0:11.788] [73440.040800] <3> 2026-01-20 13:59:48  EXT4-fs (dm-43): I/O error while writing superblock
| [ 0:11.788] [73440.040813] <3> 2026-01-20 13:59:48  EXT4-fs (dm-43): previous I/O error to superblock detected
| [ 0:11.788] [73440.047569] <2> 2026-01-20 13:59:48  EXT4-fs (dm-43): Remounting filesystem read-only
| [ 0:11.788] [73440.054948] <3> 2026-01-20 13:59:48  Buffer I/O error on dev dm-43, logical block 1, lost sync page write
| [ 0:11.788] [73440.069663] <3> 2026-01-20 13:59:48  EXT4-fs (dm-43): I/O error while writing superblock
| [ 0:11.788] [73440.076428] <2> 2026-01-20 13:59:48  EXT4-fs (dm-43): Remounting filesystem read-only
| [ 0:11.788] #lvconvert-raid-reshape-stripes-load-fail.sh:77+ rm -fr 'mnt/[12]'
| [ 0:11.788] 
| [ 0:11.789] sync
| [ 0:11.789] #lvconvert-raid-reshape-stripes-load-fail.sh:79+ sync
| [ 0:11.789] umount "$mount_dir"
| [ 0:11.798] [73440.145596] <3> 2026-01-20 13:59:48  Buffer I/O error on dev dm-43, logical block 82, lost async page write
| [ 0:11.798] #lvconvert-raid-reshape-stripes-load-fail.sh:80+ umount mnt
| [ 0:11.798] 
| [ 0:11.814] fsck -fn "$DM_DEV_DIR/$vg/$lv1"
| [ 0:11.814] [73440.162114] <6> 2026-01-20 13:59:48  EXT4-fs (dm-43): unmounting filesystem 86548d8e-e409-4ae8-b7d5-8b78a9b5fb50.
| [ 0:11.814] [73440.162336] <3> 2026-01-20 13:59:48  EXT4-fs (dm-43): I/O error while writing superblock
| [ 0:11.814] #lvconvert-raid-reshape-stripes-load-fail.sh:82+ fsck -fn /dev/LVMTEST1351568vg/LV1
| [ 0:11.814] fsck from util-linux 2.39.1
| [ 0:11.816] e2fsck 1.47.0 (5-Feb-2023)
| [ 0:11.821] fsck.ext2: Input/output error while trying to open /dev/mapper/LVMTEST1351568vg-LV1
| [ 0:11.821] 
| [ 0:11.821] The superblock could not be read or does not describe a valid ext2/ext3/ext4
| [ 0:11.821] filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
| [ 0:11.821] filesystem (and not swap or ufs or something else), then the superblock
| [ 0:11.821] is corrupt, and you might try running e2fsck with an alternate superblock:
| [ 0:11.821]     e2fsck -b 8193 <device>
| [ 0:11.821]  or
| [ 0:11.821]     e2fsck -b 32768 <device>
| [ 0:11.821] 
| [ 0:11.821] set +vx; STACKTRACE; set -vx
| [ 0:11.822] ##lvconvert-raid-reshape-stripes-load-fail.sh:82+ set +vx
| [ 0:11.822] ## - /opt/K2CI_agent_tool/lvm2/test/shell/lvconvert-raid-reshape-stripes-load-fail.sh:82
| [ 0:11.822] ## 1 STACKTRACE() called from /opt/K2CI_agent_tool/lvm2/test/shell/lvconvert-raid-reshape-stripes-load-fail.sh:82

lvconvert-raid-reshape-stripes-load-fail.sh:
#!/usr/bin/env bash

# Copyright (C) 2017 Red Hat, Inc. All rights reserved.
#
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions
# of the GNU General Public License v.2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA2110-1301 USA


SKIP_WITH_LVMPOLLD=1

. lib/inittest

# Test reshaping under io load

case "$(uname -r)" in
  3.10.0-862*) skip "Cannot run this test on unfixed kernel." ;;
esac

which mkfs.ext4 || skip
aux have_raid 1 13 2 || skip

mount_dir="mnt"

cleanup_mounted_and_teardown()
{
	umount "$mount_dir" || true
	aux teardown
}

aux prepare_pvs 16 32

get_devs

vgcreate $SHARED -s 1M "$vg" "${DEVICES[@]}"

trap 'cleanup_mounted_and_teardown' EXIT

# Create 10-way striped raid5 (11 legs total)
lvcreate --yes --type raid5_ls --stripesize 64K --stripes 10 -L4 -n$lv1 $vg
check lv_first_seg_field $vg/$lv1 segtype "raid5_ls"
check lv_first_seg_field $vg/$lv1 stripesize "64.00k"
check lv_first_seg_field $vg/$lv1 data_stripes 10
check lv_first_seg_field $vg/$lv1 stripes 11
wipefs -a "$DM_DEV_DIR/$vg/$lv1"
mkfs -t ext4 "$DM_DEV_DIR/$vg/$lv1"
fsck -fn "$DM_DEV_DIR/$vg/$lv1"

mkdir -p "$mount_dir"
mount "$DM_DEV_DIR/$vg/$lv1" "$mount_dir"
mkdir -p "$mount_dir/1" "$mount_dir/2"


echo 3 >/proc/sys/vm/drop_caches
cp -r /usr/bin "$mount_dir/1" &>/dev/null &
cp -r /usr/bin "$mount_dir/2" &>/dev/null &
sync &

aux wait_for_sync $vg $lv1
aux delay_dev "$dev2" 0 100

# Reshape it to 15 data stripes
lvconvert --yes --stripes 15 $vg/$lv1
aux disable_dev $dev1
aux delay_dev "$dev2" 0 50
check lv_first_seg_field $vg/$lv1 segtype "raid5_ls"
check lv_first_seg_field $vg/$lv1 stripesize "64.00k"
check lv_first_seg_field $vg/$lv1 data_stripes 15
check lv_first_seg_field $vg/$lv1 stripes 16

kill -9 %%
wait
rm -fr "$mount_dir/[12]"

sync
umount "$mount_dir"

fsck -fn "$DM_DEV_DIR/$vg/$lv1"

vgremove -ff $vg

Thanks,
Yang Xiuwei

