Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102C22BD1B
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 01:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753925309; cv=none; b=OfZfwsGtw69pshDbGQhI2aaEYeFUyqgMYREAWOuBxtBFQzbqhMMvu3ggSkL8bG9XD5xu8w1FWnXpW+hHRCpaHxPMk0+bHnpM7gpu4uB1AiG0qtPw7eFrqN1yrWLU033DpjUozt3RRqRln+rKMwpYPUaKPiwu8TTWx91CYNJ9hsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753925309; c=relaxed/simple;
	bh=soRlVWTU+S3Yjtj+b/Yr1nADmTNgP+F9kx0R2EjrJGw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=occrZWWTzQfRSW4eZbTdpQk17EO5tuqXaoTrX17R9qZrpV/N0q++H+zrLLZleJXkRGB5Wim2iinncpPGpgpviKPuLorKir6oP0MLMKDUm5DyZK75Is9aDjbiw8uQmbE4WKDYe36nVUMtcpCxY7fC59eIAEUZ9Tax8VvcE5OtGrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bss0m1kxfzKHMXr
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 09:28:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 28B321A0E9C
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 09:28:23 +0800 (CST)
Received: from [10.174.177.163] (unknown [10.174.177.163])
	by APP1 (Coremail) with SMTP id cCh0CgBXE6+zxopojqYOCA--.18579S2;
	Thu, 31 Jul 2025 09:28:23 +0800 (CST)
Subject: Re: [bug report] dm: 'tried to init an initialized object' error
 triggered during device creation
To: Li Lingfeng <lilingfeng3@huawei.com>, agk@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-block@vger.kernel.org
Cc: zhengqixing@huawei.com, yangerkun <yangerkun@huawei.com>,
 "zhangyi (F)" <yi.zhang@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
 Li Lingfeng <lilingfeng@huaweicloud.com>
References: <83591d0b-2467-433c-bce0-5581298eb161@huawei.com>
From: Hou Tao <houtao@huaweicloud.com>
Message-ID: <f9c385b3-2426-13a1-bc4b-54c3fb402704@huaweicloud.com>
Date: Thu, 31 Jul 2025 09:28:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <83591d0b-2467-433c-bce0-5581298eb161@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:cCh0CgBXE6+zxopojqYOCA--.18579S2
X-Coremail-Antispam: 1UD129KBjvAXoWfGr13ur13Gr18Wr4kKFy8Zrb_yoW8Jw4xZo
	WfKw1F9F4rWryDKw1jyr1DJry3Wr4UK3ZFgF12krnxAwn7J3Z8t348Ja40y343Kr4xKayx
	Zr1ftayrtayq9395n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYv7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI
	62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026x
	CaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_
	JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r
	1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8Jr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/



On 7/30/2025 8:00 PM, Li Lingfeng wrote:
> Hi all,
>
> Recently, when creating dm-mpath devices based on iSCSI devices, we
> encountered a 'tried to init an initialized object' error triggered
> by one DM_DEV_CREATE and two DM_TABLE_LOAD operations.
>
> // DM_DEV_CREATE
> dev_create
>  dm_create
>   alloc_dev
>    blk_alloc_disk // alloc gendisk for md->disk
>
> // first DM_TABLE_LOAD
> table_load
>  dm_get_md_type // md->type is DM_TYPE_NONE
>  dm_setup_md_queue
>   dm_mq_init_request_queue
>    add_disk // add md->disk
>     device_add_disk
>      add_disk_fwnode
>       __add_disk
>        blk_register_queue
>         kobject_init
>          kobject_init_internal
>           // set kobj->state_initialized
>  bd_link_disk_holder
>   // return -ENODEV since iscsi device has been logged out
>  // skip setting md->type and leave it as DM_TYPE_NONE
>
> // second DM_TABLE_LOAD
> table_load
>  dm_get_md_type // md->type is DM_TYPE_NONE
>  dm_setup_md_queue
>   dm_mq_init_request_queue
>    add_disk // add md->disk
>     device_add_disk
>      add_disk_fwnode
>       __add_disk
>        blk_register_queue
>         kobject_init
>          // dump_stack since kobj->state_initialized has been set
>
> Resetting state_initialized after the first failed DM_TABLE_LOAD might
> resolve this issue, but it seems weird — I think state_initialized is
> designed to ​never be reset during the object lifecycle.
>

cc +linux-block

The disk->queue_kobj is initialized in add_disk() and is uninitialized
in del_disk(). And it seems that blk_unregister_queue() in del_disk()
doesn't uninitialize the queue_kobj completely, because it doesn't
expect the queue_kobj will be added again. I think the right place to
fix the problem is blk_unregister_queue(). How about just memset the
queue_kobj as zero after deleting the queue_kobj in blk_unregister_queue() ?

> Any suggestions would be appreciated.
>
> Thanks,
> Lingfeng
>
> *Reproduction steps are as follows:*
> Base:
> master   4b290aae788e
>
> Diff:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index abfe0392b5a4..b41f5a6f3e72 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2598,6 +2598,9 @@ int dm_setup_md_queue(struct mapped_device *md,
> struct dm_table *t)
>         if (r)
>                 return r;
>
> +       printk("%s sleep before link disk holder\n", __func__);
> +       msleep(10 * 1000);
> +       printk("%s sleep done\n", __func__);
>         /*
>          * Register the holder relationship for devices added before
> the disk
>          * was live.
>
> Procedures:
> [root@nfs_test3 test]# lsblk
> NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> sda    8:0    0  10G  0 disk
> sdb    8:16   0  10G  0 disk
> sdc    8:32   0  30G  0 disk
> vda  253:0    0  20G  0 disk /
> [root@nfs_test3 test]# ifconfig lo:0 127.0.0.2 up
> [root@nfs_test3 test]# ifconfig lo:1 127.0.0.3 up
> [root@nfs_test3 test]# service tgtd restart
> Redirecting to /bin/systemctl restart tgtd.service
> [root@nfs_test3 test]# service iscsid restart
> Redirecting to /bin/systemctl restart iscsid.service
> [root@nfs_test3 test]# iscsiadm -m discovery -p 127.0.0.2 -t st
> 127.0.0.2:3260,1 iqn.2019-04.jenkins.disk
> [root@nfs_test3 test]# iscsiadm -m discovery -p 127.0.0.3 -t st
> 127.0.0.3:3260,1 iqn.2019-04.jenkins.disk
> [root@nfs_test3 test]# iscsiadm -m node -l
> Logging in to [iface: default, target: iqn.2020-05.com.bdqn:disk1,
> portal: 192.168.240.250,3260] (multiple)
> Logging in to [iface: default, target: iqn.2019-04.jenkins.disk,
> portal: 127.0.0.2,3260] (multiple)
> Logging in to [iface: default, target: iqn.2019-04.jenkins.disk,
> portal: 127.0.0.3,3260] (multiple)
> Logging in to [iface: default, target: , portal: ,3260] (multiple)
> [  275.687170][   C10] sd 3:0:0:1: Power-on or device reset occurred
> [  275.708911][   C10] sd 4:0:0:1: Power-on or device reset occurred
> iscsiadm: caught SIGINT, exiting...
> [root@nfs_test3 test]# lsblk
> NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> sda    8:0    0  10G  0 disk
> sdb    8:16   0  10G  0 disk
> sdc    8:32   0  30G  0 disk
> sdd    8:48   0  10G  0 disk
> sde    8:64   0  10G  0 disk
> vda  253:0    0  20G  0 disk /
> [root@nfs_test3 test]# ./dmtest &
> [1] 2742
> [root@nfs_test3 test]# DM_VERSION 4 50 0
> [  294.101770][ T2742] dm_setup_md_queue sleep before link disk holder
> [root@nfs_test3 test]#
> [root@nfs_test3 test]# iscsiadm -m node -u
> Logging out of session [sid: 1, target: iqn.2019-04.jenkins.disk,
> portal: 127.0.0.2,3260]
> Logging out of session [sid: 2, target: iqn.2019-04.jenkins.disk,
> portal: 127.0.0.3,3260]
> Logout of [sid: 1, target: iqn.2019-04.jenkins.disk, portal:
> 127.0.0.2,3260] successful.
> Logout of [sid: 2, target: iqn.2019-04.jenkins.disk, portal:
> 127.0.0.3,3260] successful.
> [root@nfs_test3 test]#
> [root@nfs_test3 test]#
> [root@nfs_test3 test]# [  304.185384][ T2742] dm_setup_md_queue sleep
> done
> [  304.280823][ T2742] device-mapper: ioctl: unable to set up device
> queue for new table.
> delay before second table_load...
> [root@nfs_test3 test]#
> [root@nfs_test3 test]# iscsiadm -m node -l
> Logging in to [iface: default, target: iqn.2020-05.com.bdqn:disk1,
> portal: 192.168.240.250,3260] (multiple)
> Logging in to [iface: default, target: iqn.2019-04.jenkins.disk,
> portal: 127.0.0.2,3260] (multiple)
> Logging in to [iface: default, target: iqn.2019-04.jenkins.disk,
> portal: 127.0.0.3,3260] (multiple)
> iscsiadm: could not read session targetname: 5
> iscsiadm: could not find session info for session3
> Logging in to [iface: default, target: , portal: ,3260] (multiple)
> [  307.357847][   C10] sd 3:0:0:1: Power-on or device reset occurred
> [  307.372301][   C10] sd 4:0:0:1: Power-on or device reset occurred
> iscsiadm: caught SIGINT, exiting...
> [root@nfs_test3 test]#
> [root@nfs_test3 test]#
> [root@nfs_test3 test]# lsblk
> NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> sda    8:0    0  10G  0 disk
> sdb    8:16   0  10G  0 disk
> sdc    8:32   0  30G  0 disk
> sdd    8:48   0  10G  0 disk
> sde    8:64   0  10G  0 disk
> vda  253:0    0  20G  0 disk /
> [root@nfs_test3 test]# delay done
> [  314.938868][ T2742] kobject: kobject (ffff88810c27bb90): tried to
> init an initialized object, something is seriously wrong.
> [  314.940322][ T2742] CPU: 6 UID: 0 PID: 2742 Comm: dmtest Not
> tainted 6.16.0-04405-g4b290aae788e-dirty #21 PREEMPT(none)
> [  314.940331][ T2742] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.16.3-2.fc40 04/01/2014
> [  314.940335][ T2742] Call Trace:
> [  314.940339][ T2742]  <TASK>
> [  314.940345][ T2742]  dump_stack_lvl+0x5b/0x80
> [  314.940370][ T2742]  kobject_init.cold+0x43/0x51
> [  314.940380][ T2742]  blk_register_queue+0x46/0x280
> [  314.940399][ T2742]  __add_disk+0x385/0x5d0
> [  314.940413][ T2742]  add_disk_fwnode+0xb5/0x280
> [  314.940425][ T2742]  dm_setup_md_queue+0x194/0x1c0
> [  314.940434][ T2742]  ? mempool_init_noprof+0x16/0x20
> [  314.940443][ T2742]  ? __pfx_dm_setup_md_queue+0x10/0x10
> [  314.940476][ T2742]  table_load+0x297/0x2d0
> [  314.940484][ T2742]  ? __pfx_table_load+0x10/0x10
> [  314.940489][ T2742]  ? _inline_copy_from_user+0x6c/0x90
> [  314.940499][ T2742]  ? copy_params+0xa6/0x330
> [  314.940513][ T2742]  ctl_ioctl+0x2a2/0x480
> [  314.940520][ T2742]  ? __pfx_table_load+0x10/0x10
> [  314.940528][ T2742]  ? __pfx_ctl_ioctl+0x10/0x10
> [  314.940564][ T2742]  ? __free_zapped_classes+0x70/0x120
> [  314.940572][ T2742]  ? exc_page_fault+0x61/0xa0
> [  314.940591][ T2742]  dm_ctl_ioctl+0xe/0x20
> [  314.940598][ T2742]  __x64_sys_ioctl+0xc7/0x110
> [  314.940605][ T2742]  ? rcu_is_watching+0x20/0x50
> [  314.940616][ T2742]  do_syscall_64+0x72/0x390
> [  314.940624][ T2742]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  314.940631][ T2742] RIP: 0033:0x7f8ce1106577
> [  314.940639][ T2742] Code: b3 66 90 48 8b 05 11 89 2c 00 64 c7 00 26
> 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10
> 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 018
> [  314.940645][ T2742] RSP: 002b:00007fff58708438 EFLAGS: 00000202
> ORIG_RAX: 0000000000000010
> [  314.940652][ T2742] RAX: ffffffffffffffda RBX: 0000000000000000
> RCX: 00007f8ce1106577
> [  314.940657][ T2742] RDX: 0000000008355010 RSI: 00000000c138fd09
> RDI: 0000000000000003
> [  314.940661][ T2742] RBP: 00007fff587084d0 R08: 0000000000000000
> R09: 0000000000000000
> [  314.940665][ T2742] R10: 0000000000400e00 R11: 0000000000000202
> R12: 3120312030206874
> [  314.940669][ T2742] R13: 6563697672657320 R14: 5f65756575712031
> R15: 61705f6f6e5f6669
> [  314.940686][ T2742]  </TASK>
> [  315.026828][ T2742] dm_setup_md_queue sleep before link disk holder
> [root@nfs_test3 test]# [  325.177205][ T2742] dm_setup_md_queue sleep
> done
>
>
> dmtest.c
> #include <stdio.h>
> #include <stdlib.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <string.h>
> #include <errno.h>
> #include <linux/dm-ioctl.h>
> #include <sys/ioctl.h>
>
> #define DM_EXISTS_FLAG 0x00000004
>
> int main(int argc, char *argv[]) {
>     int ret, fd, index;
>     int in_data;
>
>     struct dm_ioctl *param = calloc(1, sizeof(struct dm_ioctl) + 16384);
>     struct dm_target_spec sp;
>     char *target = (char *)(param + 1);
>     char *last_param = target + sizeof(struct dm_target_spec);
>
>     struct dm_target_msg tmsg;
>     fd = open("/dev/mapper/control", O_RDWR);
>     if (fd < 0) {
>         printf("Failed to open device /dev/mapper/control: %s\n",
> strerror(errno));
>         return -1;
>     }
>
>     // DM_VERSION
>     param->version[0] = 4;
>     param->version[1] = 0;
>     param->version[2] = 0;
>     param->data_size = 16384;
>     param->flags = DM_EXISTS_FLAG;
>
>     ret = ioctl(fd, DM_VERSION, param);
>     if (ret < 0) {
>         printf("Failed to send DM_VERSION: %s\n", strerror(errno));
>         close(fd);
>         return -1;
>     }
>     printf("DM_VERSION %d %d %d\n", param->version[0],
> param->version[1], param->version[2]);
>
>     // DM_DEV_CREATE
>     param->data_start = 312;
>     strncpy(param->name, "multipath-dev", sizeof(param->name));
>
>     // clear
>     memset(target, 0, 16384);
>
>     param->data_size = 16384;
>     param->dev = 0;
>
>     ret = ioctl(fd, DM_DEV_CREATE, param);
>     if (ret < 0) {
>         printf("Failed to send DM_DEV_CREATE: %s\n", strerror(errno));
>         close(fd);
>         return -1;
>     }
>
>     // DM_TABLE_LOAD
>     memset(param->name, 0, sizeof(param->name));
>     param->flags = DM_EXISTS_FLAG;
>     param->data_start = 312;
>     param->data_size = 16384;
>     //param->dev = 64514; // makedev(252, 2)
>     param->target_count = 1;
>
>     sp.sector_start = 0;
>     sp.length = 20971520;
>     strncpy(sp.target_type, "multipath", sizeof(sp.target_type) - 1);
>     sp.target_type[sizeof(sp.target_type) - 1] = '\0';
>
>     memcpy(target, &sp, sizeof(struct dm_target_spec));
>     strcpy(last_param, "1 queue_if_no_path 0 1 1 service-time 0 1 1
> 8:48 1");
>
>     ret = ioctl(fd, DM_TABLE_LOAD, param);
> //    if (ret < 0) {
> //        printf("Failed to send DM_TABLE_LOAD: %s\n", strerror(errno));
> //        close(fd);
> //        return -1;
> //    }
>
>     printf("delay before second table_load...\n");
>     sleep(10);
>     printf("delay done\n");
>     memset(param->name, 0, sizeof(param->name));
>     param->flags = DM_EXISTS_FLAG;
>     param->data_start = 312;
>     param->data_size = 16384;
>     param->target_count = 1;
>
>     sp.sector_start = 0;
>     sp.length = 20971520;
>     strncpy(sp.target_type, "multipath", sizeof(sp.target_type) - 1);
>     sp.target_type[sizeof(sp.target_type) - 1] = '\0';
>
>     memcpy(target, &sp, sizeof(struct dm_target_spec));
>     strcpy(last_param, "1 queue_if_no_path 0 1 1 service-time 0 1 1
> 8:48 1");
>
>     ret = ioctl(fd, DM_TABLE_LOAD, param);
>     if (ret < 0) {
>         printf("Failed to send DM_TABLE_LOAD: %s\n", strerror(errno));
>         close(fd);
>         return -1;
>     }
>
>     // DM_DEV_SUSPEND
>     param->flags = DM_EXISTS_FLAG; // continue creating
>     param->event_nr = 6345265;
>     param->data_size = 16384;
>     param->dev = 0;
>     strncpy(param->name, "multipath-dev", sizeof(param->name));
>
>     ret = ioctl(fd, DM_DEV_SUSPEND, param);
>     if (ret < 0) {
>         printf("Failed to send DM_DEV_SUSPEND: %s\n", strerror(errno));
>         close(fd);
>         return -1;
>     }
>     printf("DM_DEV_SUSPEND sent successfully\n");
>     close(fd);
>
>     return 0;
> }
>
>
> .

