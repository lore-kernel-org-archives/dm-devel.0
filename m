Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516331CF96
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 06:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747636900; cv=none; b=hZ5TvCxLeYXq9rYzNco48nVv2jNoq8Y7vBBJWNr814mdAqTVtnKGryYquxl2sVGnApHwWRFdUK+mo/CBL9KeYlwwXoBp40DfDG/Vlyf5z79Tjri6rBPTFsnIll1fWzB6CvkmAKsaxm02wuN3LpFh2uI8rOrxh17R0JDNtHzPcmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747636900; c=relaxed/simple;
	bh=jDp7AStPqiid0R6r7dH5hXjmV3RYw1JmTKCddLc0/Jw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=K7SOpvvSNzDhnSctlTFK6MeQ6ZCb+rGLjeTCFlGxI3a77KzEbbNNeKK0Kcj6zRa2XkF3DErPdRkHcjhcl6zAAcmGyzyvjDN98ZwyitNMA49oC1udw6wWQ076yv211dz4Cy9YsyJWQZyAJv/zDFKnVvA+xFB5CK/blKBhWkOM56k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b17Pq4ngFzKHLy3
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 14:41:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3B8C71A01A0
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 14:41:34 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXul6c0ipodfFqMw--.29848S3;
	Mon, 19 May 2025 14:41:34 +0800 (CST)
Subject: Re: LVM2 test breakage
To: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>
Cc: zkabelac@redhat.com, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
Date: Mon, 19 May 2025 14:41:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXul6c0ipodfFqMw--.29848S3
X-Coremail-Antispam: 1UD129KBjvAXoWfJFyrAFyDKw4ftF48tw1rCrg_yoW8GrW5to
	W7W3W8Z3yDJw4aqrn0k347JFy2qrWDWF1Uurs2kry0gF47t3s0qF9IyryfG3sxXFyI9r1x
	CF97Aw48Za1xGFWkn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYh7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
	bIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/19 9:11, Yu Kuai 写道:
> Hi,
> 
> 在 2025/05/17 0:00, Mikulas Patocka 写道:
>> Hi
>>
>> The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test
>> shell/lvcreate-large-raid.sh in the lvm2 testsuite.
>>
>> The breakage is caused by removing the line "read_bio->bi_opf = op |
>> do_sync;"
>>
> 
> Sorry that I don't undertand here, before the patch:
> 
> op = bio_op(bio);
> do_sync = bio->bi_opf & REQ_SYNC;
> read_bio->bi_opf = op | do_sync
> 
> after the patch:
> 
> read_bio = bio_alloc_clone(, bio, ...)
>   read_bio->bi_opf = bio->bi_opf
> 
> So, after the patch, other than bio_op() and REQ_SYNC, other bio flags
> are keeped, I don't see problem for now, I'll run the test later.
> 

Do I need some special setup to run this test? I got following
result in my VM, and I don't understand why it failed.

Thanks,
Kuai

[root@fedora ~]# cat 
lvm2/test/results/ndev-vanilla\:shell_lvcreate-large-raid.sh.txt
[ 0:00.290] Library version:   1.02.199-git (2024-05-16)
[ 0:00.290] Driver version:    4.50.0
[ 0:00.290] Kernel is Linux fedora 
6.15.0-rc6-next-20250516-00001-ge4a42bdb48e2 #1064 SMP PREEMPT_DYNAMIC 
Mon May 19 14:18:47 CST 2025 x86_64 x86_64 x86_64 GNU/Linux
[ 0:00.351] Selinux mode is Disabled.
[ 0:00.365]                total        used        free      shared 
buff/cache   available
[ 0:00.384] Mem:          257561         576      256529           0 
     455      255165
[ 0:00.384] Swap:              0           0           0
[ 0:00.384] Filesystem      Size  Used Avail Use% Mounted on
[ 0:00.402] /dev/root        20G   18G  3.0G  86% /
[ 0:00.402] devtmpfs        126G     0  126G   0% /dev
[ 0:00.402] tmpfs           126G     0  126G   0% /dev/shm
[ 0:00.402] tmpfs            51G  952K   51G   1% /run
[ 0:00.402] tmpfs           4.0M     0  4.0M   0% /sys/fs/cgroup
[ 0:00.402] tmpfs           126G     0  126G   0% /tmp
[ 0:00.402] modules          14T   13T  1.4T  91% /tmp/modules
[ 0:00.402] tmpfs            26G     0   26G   0% /run/user/0
[ 0:00.402] /dev/nvme0n1     98G   56K   93G   1% /mnt/test
[ 0:00.402] @TESTDIR=/mnt/test/LVMTEST8522.QQ9T6A2cUU
[ 0:00.404] @PREFIX=LVMTEST8522
[ 0:00.404] ## DATE: Mon May 19 06:26:54 UTC 2025
[ 0:00.419] ## HOST: 192.168.8.196
[ 0:00.429] ## LVMCONF: activation {
[ 0:00.598] ## LVMCONF:     checks = 1
[ 0:00.598] ## LVMCONF:     monitoring = 0
[ 0:00.598] ## LVMCONF:     polling_interval = 1
[ 0:00.598] ## LVMCONF:     raid_region_size = 512
[ 0:00.598] ## LVMCONF:     retry_deactivation = 1
[ 0:00.598] ## LVMCONF:     snapshot_autoextend_percent = 50
[ 0:00.598] ## LVMCONF:     snapshot_autoextend_threshold = 50
[ 0:00.598] ## LVMCONF:     udev_rules = 1
[ 0:00.598] ## LVMCONF:     udev_sync = 1
[ 0:00.598] ## LVMCONF:     verify_udev_operations = 1
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] ## LVMCONF: allocation {
[ 0:00.598] ## LVMCONF:     vdo_slab_size_mb = 128
[ 0:00.598] ## LVMCONF:     wipe_signatures_when_zeroing_new_lvs = 0
[ 0:00.598] ## LVMCONF:     zero_metadata = 0
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] ## LVMCONF: backup {
[ 0:00.598] ## LVMCONF:     archive = 0
[ 0:00.598] ## LVMCONF:     backup = 0
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] ## LVMCONF: devices {
[ 0:00.598] ## LVMCONF:     cache_dir = 
"/mnt/test/LVMTEST8522.QQ9T6A2cUU/etc"
[ 0:00.598] ## LVMCONF:     default_data_alignment = 1
[ 0:00.598] ## LVMCONF:     dir = "/mnt/test/LVMTEST8522.QQ9T6A2cUU/dev"
[ 0:00.598] ## LVMCONF:     filter = "a|.*|"
[ 0:00.598] ## LVMCONF:     global_filter = [ 
"a|/mnt/test/LVMTEST8522.QQ9T6A2cUU/dev/mapper/LVMTEST8522.*pv[0-9_]*$|", 
"r|.*|" ]
[ 0:00.598] ## LVMCONF:     md_component_detection = 0
[ 0:00.598] ## LVMCONF:     scan = "/mnt/test/LVMTEST8522.QQ9T6A2cUU/dev"
[ 0:00.598] ## LVMCONF:     sysfs_scan = 1
[ 0:00.598] ## LVMCONF:     use_devicesfile = 0
[ 0:00.598] ## LVMCONF:     write_cache_state = 0
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] ## LVMCONF: dmeventd {
[ 0:00.598] ## LVMCONF:     executable = "/root/lvm2/test/lib/dmeventd"
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] ## LVMCONF: global {
[ 0:00.598] ## LVMCONF:     abort_on_internal_errors = 1
[ 0:00.598] ## LVMCONF:     cache_check_executable = "/usr/sbin/cache_check"
[ 0:00.598] ## LVMCONF:     cache_dump_executable = "/usr/sbin/cache_dump"
[ 0:00.598] ## LVMCONF:     cache_repair_executable = 
"/usr/sbin/cache_repair"
[ 0:00.598] ## LVMCONF:     cache_restore_executable = 
"/usr/sbin/cache_restore"
[ 0:00.598] ## LVMCONF:     detect_internal_vg_cache_corruption = 1
[ 0:00.598] ## LVMCONF:     etc = "/mnt/test/LVMTEST8522.QQ9T6A2cUU/etc"
[ 0:00.598] ## LVMCONF:     event_activation = 1
[ 0:00.598] ## LVMCONF:     fallback_to_local_locking = 0
[ 0:00.598] ## LVMCONF:     fsadm_executable = "/root/lvm2/test/lib/fsadm"
[ 0:00.598] ## LVMCONF:     library_dir = 
"/mnt/test/LVMTEST8522.QQ9T6A2cUU/lib"
[ 0:00.598] ## LVMCONF:     locking_dir = 
"/mnt/test/LVMTEST8522.QQ9T6A2cUU/var/lock/lvm"
[ 0:00.598] ## LVMCONF:     locking_type=1
[ 0:00.598] ## LVMCONF:     notify_dbus = 0
[ 0:00.598] ## LVMCONF:     si_unit_consistency = 1
[ 0:00.598] ## LVMCONF:     thin_check_executable = "/usr/sbin/thin_check"
[ 0:00.598] ## LVMCONF:     thin_dump_executable = "/usr/sbin/thin_dump"
[ 0:00.598] ## LVMCONF:     thin_repair_executable = "/usr/sbin/thin_repair"
[ 0:00.598] ## LVMCONF:     thin_restore_executable = 
"/usr/sbin/thin_restore"
[ 0:00.598] ## LVMCONF:     use_lvmlockd = 0
[ 0:00.598] ## LVMCONF:     use_lvmpolld = 0
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] ## LVMCONF: log {
[ 0:00.598] ## LVMCONF:     activation = 1
[ 0:00.598] ## LVMCONF:     file = 
"/mnt/test/LVMTEST8522.QQ9T6A2cUU/debug.log"
[ 0:00.598] ## LVMCONF:     indent = 1
[ 0:00.598] ## LVMCONF:     level = 9
[ 0:00.598] ## LVMCONF:     overwrite = 1
[ 0:00.598] ## LVMCONF:     syslog = 0
[ 0:00.598] ## LVMCONF:     verbose = 0
[ 0:00.598] ## LVMCONF: }
[ 0:00.598] <======== Processing test: "lvcreate-large-raid.sh" ========>
[ 0:00.612]
[ 0:00.613] # FIXME  update test to make something useful on <16T
[ 0:00.613] aux can_use_16T || skip
[ 0:00.613] #lvcreate-large-raid.sh:21+ aux can_use_16T
[ 0:00.613]
[ 0:00.688] aux have_raid 1 3 0 || skip
[ 0:00.688] #lvcreate-large-raid.sh:23+ aux have_raid 1 3 0
[ 0:00.688] v1_9_0=0
[ 0:00.867] #lvcreate-large-raid.sh:24+ v1_9_0=0
[ 0:00.867] aux have_raid 1 9 0 && v1_9_0=1
[ 0:00.867] #lvcreate-large-raid.sh:25+ aux have_raid 1 9 0
[ 0:00.867] #lvcreate-large-raid.sh:25+ v1_9_0=1
[ 0:01.082]
[ 0:01.083] segtypes="raid5"
[ 0:01.083] #lvcreate-large-raid.sh:27+ segtypes=raid5
[ 0:01.083] aux have_raid4 && segtypes="raid4 raid5"
[ 0:01.083] #lvcreate-large-raid.sh:28+ aux have_raid4
[ 0:01.083] #lvcreate-large-raid.sh:28+ segtypes='raid4 raid5'
[ 0:01.500]
[ 0:01.500] # Prepare 5x ~1P sized devices
[ 0:01.500] aux prepare_pvs 5 1000000000
[ 0:01.500] #lvcreate-large-raid.sh:31+ aux prepare_pvs 5 1000000000
[ 0:01.500] ## preparing loop device....set +vx; STACKTRACE; set -vx
[ 0:01.709] ##lvcreate-large-raid.sh:31+ set +vx
[ 0:01.709] ## - /root/lvm2/test/shell/lvcreate-large-raid.sh:31
[ 0:01.710] ## 1 STACKTRACE() called from 
/root/lvm2/test/shell/lvcreate-large-raid.sh:31
[ 0:01.710] <======== Free space ========>
[ 0:02.310] ## DF_H:    Filesystem      Size  Used Avail Use% Mounted on
[ 0:02.335] ## DF_H:    /dev/root        20G   18G  3.0G  86% /
[ 0:02.335] ## DF_H:    devtmpfs        126G     0  126G   0% /dev
[ 0:02.335] ## DF_H:    tmpfs           126G     0  126G   0% /dev/shm
[ 0:02.335] ## DF_H:    tmpfs            51G  952K   51G   1% /run
[ 0:02.335] ## DF_H:    tmpfs           4.0M     0  4.0M   0% /sys/fs/cgroup
[ 0:02.335] ## DF_H:    tmpfs           126G     0  126G   0% /tmp
[ 0:02.335] ## DF_H:    modules          14T   13T  1.4T  91% /tmp/modules
[ 0:02.335] ## DF_H:    tmpfs            26G     0   26G   0% /run/user/0
[ 0:02.335] ## DF_H:    /dev/nvme0n1     98G   64K   93G   1% /mnt/test
[ 0:02.335] <======== Script file "lvcreate-large-raid.sh" ========>
[ 0:02.345] ## Line: 1   #!/usr/bin/env bash
[ 0:02.384] ## Line: 2
[ 0:02.384] ## Line: 3   # Copyright (C) 2012,2016 Red Hat, Inc. All 
rights reserved.
[ 0:02.384] ## Line: 4   #
[ 0:02.384] ## Line: 5   # This copyrighted material is made available 
to anyone wishing to use,
[ 0:02.384] ## Line: 6   # modify, copy, or redistribute it subject to 
the terms and conditions
[ 0:02.384] ## Line: 7   # of the GNU General Public License v.2.
[ 0:02.384] ## Line: 8   #
[ 0:02.384] ## Line: 9   # You should have received a copy of the GNU 
General Public License
[ 0:02.384] ## Line: 10          # along with this program; if not, 
write to the Free Software Foundation,
[ 0:02.384] ## Line: 11          # Inc., 51 Franklin Street, Fifth 
Floor, Boston, MA 02110-1301 USA
[ 0:02.384] ## Line: 12
[ 0:02.384] ## Line: 13          # 'Exercise some lvcreate diagnostics'
[ 0:02.384] ## Line: 14
[ 0:02.384] ## Line: 15
[ 0:02.384] ## Line: 16          SKIP_WITH_LVMPOLLD=1
[ 0:02.384] ## Line: 17
[ 0:02.384] ## Line: 18          . lib/inittest
[ 0:02.384] ## Line: 19
[ 0:02.384] ## Line: 20          # FIXME  update test to make something 
useful on <16T
[ 0:02.384] ## Line: 21          aux can_use_16T || skip
[ 0:02.384] ## Line: 22
[ 0:02.384] ## Line: 23          aux have_raid 1 3 0 || skip
[ 0:02.384] ## Line: 24          v1_9_0=0
[ 0:02.384] ## Line: 25          aux have_raid 1 9 0 && v1_9_0=1
[ 0:02.384] ## Line: 26
[ 0:02.384] ## Line: 27          segtypes="raid5"
[ 0:02.384] ## Line: 28          aux have_raid4 && segtypes="raid4 raid5"
[ 0:02.384] ## Line: 29
[ 0:02.384] ## Line: 30          # Prepare 5x ~1P sized devices
[ 0:02.384] ## Line: 31          aux prepare_pvs 5 1000000000
[ 0:02.384] ## Line: 32          get_devs
[ 0:02.384] ## Line: 33
[ 0:02.384] ## Line: 34          vgcreate $SHARED "$vg1" "${DEVICES[@]}"
[ 0:02.384] ## Line: 35
[ 0:02.384] ## Line: 36          aux lvmconf 'devices/issue_discards = 1'
[ 0:02.384] ## Line: 37
[ 0:02.384] ## Line: 38          # Delay PVs so that resynchronization 
doesn't fill too much space
[ 0:02.384] ## Line: 39          for device in "${DEVICES[@]}"
[ 0:02.384] ## Line: 40          do
[ 0:02.384] ## Line: 41                 aux zero_dev "$device" "$(( 
$(get first_extent_sector "$device") + 8192 )):"
[ 0:02.384] ## Line: 42          done
[ 0:02.384] ## Line: 43
[ 0:02.384] ## Line: 44          # bz837927 START
[ 0:02.384] ## Line: 45
[ 0:02.384] ## Line: 46          #
[ 0:02.384] ## Line: 47          # Create large RAID LVs
[ 0:02.384] ## Line: 48          #
[ 0:02.384] ## Line: 49
[ 0:02.384] ## Line: 50          # 200 TiB raid1
[ 0:02.384] ## Line: 51          lvcreate --type raid1 -m 1 -L 200T -n 
$lv1 $vg1 --nosync
[ 0:02.384] ## Line: 52          check lv_field $vg1/$lv1 size "200.00t"
[ 0:02.384] ## Line: 53          check raid_leg_status $vg1 $lv1 "AA"
[ 0:02.384] ## Line: 54          lvremove -ff $vg1
[ 0:02.384] ## Line: 55
[ 0:02.384] ## Line: 56          # 1 PiB raid1
[ 0:02.384] ## Line: 57          lvcreate --type raid1 -m 1 -L 1P -n 
$lv1 $vg1 --nosync
[ 0:02.384] ## Line: 58          check lv_field $vg1/$lv1 size "1.00p"
[ 0:02.384] ## Line: 59          check raid_leg_status $vg1 $lv1 "AA"
[ 0:02.384] ## Line: 60          lvremove -ff $vg1
[ 0:02.384] ## Line: 61
[ 0:02.384] ## Line: 62          # 750 TiB raid4/5
[ 0:02.384] ## Line: 63          for segtype in $segtypes; do
[ 0:02.384] ## Line: 64                  lvcreate --type $segtype -i 3 
-L 750T -n $lv1 $vg1 --nosync
[ 0:02.384] ## Line: 65                  check lv_field $vg1/$lv1 size 
"750.00t"
[ 0:02.384] ## Line: 66                  check raid_leg_status $vg1 $lv1 
"AAAA"
[ 0:02.384] ## Line: 67                  lvremove -ff $vg1
[ 0:02.384] ## Line: 68          done
[ 0:02.384] ## Line: 69
[ 0:02.384] ## Line: 70          #
[ 0:02.384] ## Line: 71          # Extending large 200 TiB RAID LV to 
400 TiB (belong in different script?)
[ 0:02.384] ## Line: 72          #
[ 0:02.384] ## Line: 73          lvcreate --type raid1 -m 1 -L 200T -n 
$lv1 $vg1 --nosync
[ 0:02.384] ## Line: 74          check lv_field $vg1/$lv1 size "200.00t"
[ 0:02.384] ## Line: 75          check raid_leg_status $vg1 $lv1 "AA"
[ 0:02.384] ## Line: 76          lvextend -L +200T $vg1/$lv1
[ 0:02.384] ## Line: 77          check lv_field $vg1/$lv1 size "400.00t"
[ 0:02.384] ## Line: 78          check raid_leg_status $vg1 $lv1 "AA"
[ 0:02.384] ## Line: 79          lvremove -ff $vg1
[ 0:02.384] ## Line: 80
[ 0:02.384] ## Line: 81
[ 0:02.384] ## Line: 82          # Check --nosync is rejected for raid6
[ 0:02.384] ## Line: 83          if [ $v1_9_0 -eq 1 ] ; then
[ 0:02.384] ## Line: 84                 not lvcreate --type raid6 -i 3 
-L 750T -n $lv1 $vg1 --nosync
[ 0:02.384] ## Line: 85          fi
[ 0:02.384] ## Line: 86
[ 0:02.384] ## Line: 87          # 750 TiB raid6
[ 0:02.384] ## Line: 88          lvcreate --type raid6 -i 3 -L 750T -n 
$lv1 $vg1
[ 0:02.384] ## Line: 89          check lv_field $vg1/$lv1 size "750.00t"
[ 0:02.384] ## Line: 90          check raid_leg_status $vg1 $lv1 "aaaaa"
[ 0:02.384] ## Line: 91          lvremove -ff $vg1
[ 0:02.384] ## Line: 92
[ 0:02.384] ## Line: 93          # 1 PiB raid6, then extend up to 2 PiB
[ 0:02.384] ## Line: 94          lvcreate --type raid6 -i 3 -L 1P -n 
$lv1 $vg1
[ 0:02.384] ## Line: 95          check lv_field $vg1/$lv1 size "1.00p"
[ 0:02.384] ## Line: 96          check raid_leg_status $vg1 $lv1 "aaaaa"
[ 0:02.384] ## Line: 97          lvextend -L +1P $vg1/$lv1
[ 0:02.384] ## Line: 98          check lv_field $vg1/$lv1 size "2.00p"
[ 0:02.384] ## Line: 99          check raid_leg_status $vg1 $lv1 "aaaaa"
[ 0:02.384] ## Line: 100         lvremove -ff $vg1
[ 0:02.384] ## Line: 101
[ 0:02.384] ## Line: 102         #
[ 0:02.384] ## Line: 103         # Convert large 200 TiB linear to RAID1 
(belong in different test script?)
[ 0:02.384] ## Line: 104         #
[ 0:02.384] ## Line: 105         lvcreate -aey -L 200T -n $lv1 $vg1
[ 0:02.384] ## Line: 106         lvconvert -y --type raid1 -m 1 $vg1/$lv1
[ 0:02.384] ## Line: 107         check lv_field $vg1/$lv1 size "200.00t"
[ 0:02.384] ## Line: 108         if [ $v1_9_0 -eq 1 ] ; then
[ 0:02.384] ## Line: 109                # The 1.9.0 version of dm-raid 
is capable of performing
[ 0:02.384] ## Line: 110                # linear -> RAID1 upconverts as 
"recover" not "resync"
[ 0:02.384] ## Line: 111                # The LVM code now checks the 
dm-raid version when
[ 0:02.384] ## Line: 112                # upconverting and if 1.9.0+ is 
found, it uses "recover"
[ 0:02.384] ## Line: 113                check raid_leg_status $vg1 $lv1 "Aa"
[ 0:02.384] ## Line: 114         else
[ 0:02.384] ## Line: 115                check raid_leg_status $vg1 $lv1 "aa"
[ 0:02.384] ## Line: 116         fi
[ 0:02.384] ## Line: 117         lvremove -ff $vg1
[ 0:02.384] ## Line: 118
[ 0:02.384] ## Line: 119         # bz837927 END
[ 0:02.384] ## Line: 120
[ 0:02.384] ## Line: 121         vgremove -ff $vg1
[ 0:02.384] aux teardown
[ 0:02.394] #lvcreate-large-raid.sh:1+ aux teardown
[ 0:02.394] ## teardown.........ok

> Thanks,
> Kuai
> 
>> Mikulas
>>
>>
>> .
>>
> 
> .
> 

