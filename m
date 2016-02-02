From: DingXiang <dingxiang@huawei.com>
Subject: [PATCH resend] [dm]fix NULL pointer when create dm device
Date: Tue, 2 Feb 2016 12:29:18 +0800
Message-ID: <1454387358-16221-1-git-send-email-dingxiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, DingXiang <dingxiang@huawei.com>
List-Id: dm-devel.ids

In some conditions(such as umount fs failed),origin path or origin bdev or both of the two is same
as cow's.If this happens, origin dev will be freed when get cow dev in function "dm_get_device" ,
then "s->origin->dev" which used by "dm_exception_store_set_chunk_size" will be a NULL pointer.

Here is my call trace

dracut-initqueue[2614]: mount: unknown filesystem type 'squashfs'
dracut-initqueue[2614]: umount: /run/initramfs/squashfs: not mounted
Unable to handle kernel NULL pointer dereference at virtual address 00000098
pgd = ffffffc038c3d000
[00000098] *pgd=0000000000000000, *pud=0000000000000000
Internal error: Oops: 96000005 [#1] SMP
Modules linked in:
CPU: 20 PID: 6389 Comm: dmsetup Not tainted 3.19.8+ #19
Hardware name: Huawei Taishan 2160 /BC11SPCA, BIOS 1.16 01/13/2016
task: ffffffdfb3e060c0 ti: ffffffc038600000 task.ti: ffffffc038600000
PC is at dm_exception_store_set_chunk_size+0x6c/0x124
LR is at dm_exception_store_set_chunk_size+0x68/0x124
pc : [<ffffffc00060b4d8>] lr : [<ffffffc00060b4d4>] pstate: 40000145
sp : ffffffc038603a90
x29: ffffffc038603a90 x28: ffffffc038600000
x27: ffffffefab3b7630 x26: 0000000000000001
x25: ffffffc000c9e030 x24: ffffffdfb2187740
x23: ffffffc038603b94 x22: ffffffefab3b7730
x21: ffffff80003dd088 x20: ffffffdfb2187740
x19: 0000000000000008 x18: 0000007fac97383c
x17: 0000007fac8b9cb0 x16: ffffffc0001ae79c
x15: 0000007fac9a00b0 x14: 0000007fac9a00b0
x13: 0000000000000001 x12: 0000000000000020
x11: 0000000000000008 x10: 0000000000000000
x9 : 000000000000000a x8 : 0000000000000008
x7 : ffffffefa95f4179 x6 : 0000000000000008
x5 : 0000000000000008 x4 : 0000000000000007
x3 : 0000000000000008 x2 : ffffff80003dd088
x1 : 0000000000000008 x0 : 0000000000000000

Process dmsetup (pid: 6389, stack limit = 0xffffffc038600058)
Stack: (0xffffffc038603a90 to 0xffffffc038604000)
3a80:                                     38603ac0 ffffffc0 0060b6fc ffffffc0
3aa0: 00000000 00000000 003dd040 ffffff80 ab3b7600 ffffffef 00000008 00000000
3ac0: 38603b20 ffffffc0 0060a944 ffffffc0 b2187700 ffffffdf 003dd040 ffffff80
3ae0: ab3b7600 ffffffef ab3b7730 ffffffef 00000002 00000000 0081e000 ffffffc0
3b00: 00cc6000 ffffffc0 38600000 ffffffc0 38603b20 ffffffc0 b2187b58 00000008
3b20: 38603bb0 ffffffc0 005f6378 ffffffc0 003dd040 ffffff80 ab3b7800 ffffffef
3b40: 00000000 00000000 a95f4150 ffffffef 00000000 00000000 003dd040 ffffff80
3b60: a95f4000 ffffffef a95f4000 ffffffef 00c58000 ffffffc0 38600000 ffffffc0
3b80: 00000000 00000000 a95f416b ffffffef a95f4000 ffffffef 005f62d4 ffffffc0
3ba0: 003dd040 ffffff80 005f5f68 00000008 38603c10 ffffffc0 005f98cc ffffffc0
3bc0: a95f4138 ffffffef a95f8000 ffffffef 00000000 00000000 b41b2400 ffffffdf
3be0: ab3b7800 ffffffef 00000000 00000000 a95f4160 ffffffef 00100000 00000000
3c00: 38603c10 00000004 b2187700 ffffffdf 38603c70 ffffffc0 005fa484 ffffffc0
3c20: c7e1d2d0 0000007f 00000000 00000000 00004000 00000000 00000009 00000000
3c40: 00000001 00000000 005f97bc ffffffc0 00000000 00000000 00000000 00000000
3c60: 00000000 00000000 ab3b7800 ffffffef 38603e00 ffffffc0 005fa758 ffffffc0
3c80: b7e82c00 ffffffdf c7e1d2d0 0000007f b87e6e88 ffffffef 00000003 00000000
3ca0: c7e1d2d0 0000007f c138fd09 00000000 0000011a 00000000 0000001d 00000000
3cc0: 00000020 00000000 00000004 0000001d 00000000 00004000 00000138 00000001
3ce0: 00000000 00000004 00000000 00000000 00000000 00000000 6576696c 0077722d
3d00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3d20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3d40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3d60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3d80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3da0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3dc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3de0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3e00: 38603e10 ffffffc0 001ae54c ffffffc0 38603e90 ffffffc0 001ae820 ffffffc0
3e20: 00000000 00000000 b7e82c00 ffffffdf b7e82c00 ffffffdf 00000003 00000000
3e40: 00cbb000 ffffffc0 b3e060c0 ffffffdf 80000000 00000000 00000015 00000000
3e60: 00000000 00000000 00000000 00000000 38603e80 ffffffc0 001b88e4 ffffffc0
3e80: 38603e90 ffffffc0 001ae7dc ffffffc0 c6e64c40 0000007f 00086430 ffffffc0
3ea0: 00000000 00000000 c7e1d2d0 0000007f ffffffff ffffffff ac8b9cbc 0000007f
3ec0: 60000000 00000000 00000015 00000000 00000003 00000000 c138fd09 00000000
3ee0: c7e1d2d0 0000007f 00000007 00000000 ac9a73e8 0000007f c6e64aa0 0000007f
3f00: 37770e00 3c220354 c7e1d300 0000007f 0000001d 00000000 ffffffe8 ffffff80
3f20: c6e64b90 0000007f c6e64b90 0000007f ac9a00b0 0000007f ac9a00b0 0000007f
3f40: ac9a00b0 0000007f ac9a00b0 0000007f ac9bec98 0000007f ac8b9cb0 0000007f
3f60: ac97383c 0000007f c7e1d200 0000007f c7e1d2d0 0000007f c7e1d300 0000007f
3f80: ac9a6000 0000007f c7e1d380 0000007f ac9a00b0 0000007f ac9a00b0 0000007f
3fa0: 00000000 00000000 ac9be000 0000007f ac9a00b0 0000007f c6e64c40 0000007f
3fc0: ac99e1d4 0000007f c6e64b90 0000007f ac8b9cbc 0000007f 60000000 00000000
3fe0: 00000003 00000000 0000001d 00000000 00000000 00000000 00000000 00000000
Call trace:
[<ffffffc00060b4d8>] dm_exception_store_set_chunk_size+0x6c/0x124
[<ffffffc00060b6f8>] dm_exception_store_create+0x168/0x1c4
[<ffffffc00060a940>] snapshot_ctr+0x168/0x5ec
[<ffffffc0005f6374>] dm_table_add_target+0x114/0x360
[<ffffffc0005f98c8>] table_load+0x10c/0x314
[<ffffffc0005fa480>] ctl_ioctl+0x1f8/0x4bc
[<ffffffc0005fa754>] dm_ctl_ioctl+0x10/0x20
[<ffffffc0001ae548>] do_vfs_ioctl+0x360/0x5b4
[<ffffffc0001ae81c>] SyS_ioctl+0x80/0x98

And I think the BUG https://bugzilla.redhat.com/show_bug.cgi?id=1195899
should be the same reason.

Signed-off-by:Ding Xiang <dingxiang@huawei.com>
---
 drivers/md/dm-snap.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3766386..ccf97d8 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1102,6 +1102,7 @@ static void stop_merge(struct dm_snapshot *s)
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_snapshot *s;
+	struct block_device *origin_bdev, *cow_bdev;
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
@@ -1136,10 +1137,19 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_origin;
 	}
 
+	origin_bdev = s->origin->bdev;
 	cow_path = argv[0];
 	argv++;
 	argc--;
 
+	/*check cow dev is available*/
+	cow_bdev = lookup_bdev(cow_path);
+	if(cow_bdev->bd_dev == origin_bdev->bd_dev){
+		ti->error = "Invalid COW device";
+		r = -EINVAL;
+		goto bad_cow;
+	}
+
 	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
 	if (r) {
 		ti->error = "Cannot get COW device";
-- 
1.7.1
