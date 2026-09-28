Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861403AFD06
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 20:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626383; cv=none; b=IPMjgbR5Gh2Y7VhAlVVIq0LNCAveIGzXI6f3yF/iYZs9PNPVl0khUBPR74mA3+vuAn6XEJgTtDJfZr8QMhzcN2jw+1uwQh3w1AjuJ+bX0HASghzFXK4XZOSvLJoU8Z6GOaKCQkC0+4nsUHR/hDgCHk1dmZGu89L31yrkkRFqOM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626383; c=relaxed/simple;
	bh=Cqwve463B5Vq8d7fNTCmT8rVT7G2OsRaQaNkypIY788=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK83u5yysOzgv6xzlwE74YZWbdElrkg4PDNedeO2KMeymLU0ZI2jvdn/c2EvsFKidhWgVucotWcNwchGWWyJNMEtmJi4OUI11/jjdH1DnEd110vO1M33gtZH8WFWKZDUu5gsrpEP0lZ6a9L5jgMe9X+70wFPhemMI4H7ZqJTPEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F6gxsD42; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6gxsD42"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71cdb22bso25801725e9.2
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790626379; x=1791231179; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NM7rqlE5Zzjc0um0UXrH1bx/k5jNJl9oa2U9U1VxnIE=;
        b=F6gxsD42ujqW+JQ5AQjavVv/oJ452qVfIkkW9MHrTxOhBMvYSi1LU0wZR6f4JLUhgh
         pISYaDRk9V8qHcllSAiqGqaWsCiuBZvms3xT/F+Y/zNXVkyFQvTfv3Ad+Y2vw1mEPm0/
         Aw6xfrlhVlGtqRFmyhA+J4xrT1u0RrUCQqSVZ/HrOHlVgOLEIi3zh5G81da5HtsFC0Ro
         qz4MZmZMzDdOtA2rsPneqgsmkpHQl6YOBG9jiieJEEIKf8FFm1Qt7XDdz17ec+zK1Fgc
         o31NqIzb0mDBXAtc9VuHlshM57JQzfrXFivDSjS+mSuipheIcboPaXvVV2KJJYcWkzFF
         0Kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790626379; x=1791231179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NM7rqlE5Zzjc0um0UXrH1bx/k5jNJl9oa2U9U1VxnIE=;
        b=lQNjUWch1E1Q8dQWz9LAP3KZYyo7L5c+WQKYyIGuK4lQKvYpNWLqi16zVWCGEmmJBR
         MQYtQS4B1Z3XOvV8uxMek7HZFFi8ZuKqoebhOYBxdu6xHUBL3VNuf1NUe0JHbE7QmWRt
         E0ur9XvGM5SIAvJvQJWt40aADjMdBYUTUiKGL4Sxo/YWclrU5xZjKlqOXyNkoDk03mwc
         5D4qdWasBP28OEK02cDk79aWmMi/Alkuc/OJQHkidB8pTW6G1c9frCyPWE/zVThIHtIS
         J4e/tC4rQ/Colas7N8B6pMqTzPa1ApmSbkNUnwhj5y5w1zIip1TVceKkezvPKtHHk6Kl
         o0nA==
X-Forwarded-Encrypted: i=1; AKwUvBwbrXKkFJFEbgybny+Az0Mih1hJnjscN69JEOr3oioUEJDPs+3E1z6/3H+M1plgWKlqmn/VdkDmvA==@lists.linux.dev
X-Gm-Message-State: AFuF++mFHIBgiS9aNUc1axXIcAhM2AUMeh6nLLCVtyaQttrnxXdhW3oU
	b6bJVAE2opawW141v2eFRkj3vXElHvnr9Ly61wKU1LPhmDTeKxhcXW1a
X-Gm-Gg: AYBFou1ScIIps1S949FT3XI/7ygmJqTT3xvZ3xFkd9FRJcGifN8gt+AgH80IbCJjyYt
	yRP1UT/RB2vzWRiv3TUaOocQyFiZhfu5VeQCDsjchsKnYIrkU5Rp5U0BmIxoBJt8WOquYkWihma
	BiRxgw8recisdFEPY1ZvUfUpTJISZoD3qOcIgJ/5hAcqVKzir5uwwpC0+7uNDLiD++wFFVnbTIa
	fd24G8G65dSvAXQ4hikk3tla0twCLuZ0xcftSl1FZfZyuLPWo9k/cFE/gSTdIWKpldqxz2MBacn
	cnAz+AK9dY7z/3wrCY4yaEmXzzBAkIO695zVBShn+Ek11H730pibt7Q6tDeTtlgxQWk3sfrt4Wy
	+yBx1cr0TZzha+myIbPyU4TBxmd7mmHj2p6y/ivgxpHIqWy3u3NquWgw7zRco41xXFKPtlot54H
	wA743WQWWtk44uaRR6R1Ylipe6MaFbQDPuY7Eq8yVaO43r8Re8NwjsirwHN1xcw6/IzbljGIXxp
	JswTHZpnRWTF1MCh7RcQJbMnJujyJ0kXOLRJ+/V4q4CgSw=
X-Received: by 2002:a05:600c:a4c:b0:49c:fa20:cc08 with SMTP id 5b1f17b1804b1-49fe67060cemr241657725e9.31.1790626378588;
        Mon, 28 Sep 2026 13:12:58 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c11a9d2sm30457755e9.3.2026.09.28.13.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 13:12:57 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 2/2] md: add a control device for array management
Date: Mon, 28 Sep 2026 20:12:24 +0000
Message-ID: <20260928201224.3602262-3-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All md management ioctls (SET_ARRAY_INFO, ADD_NEW_DISK, RUN_ARRAY,
STOP_ARRAY, ...) are issued on the md block device itself, so the
caller must hold the array open while it configures or stops it.

This is a problem for STOP_ARRAY and STOP_ARRAY_RO. Before the array is
stopped, the page cache must be flushed, and no other task may have the
device open or be writing to it. The issue arises when several tasks
share the same file descriptor table, as they count as a single opener.
Consequently, one task may still be writing while another task flushes
the page cache and stops the array. A write within this window can race
with the stop operation.

Add a misc character device, /dev/md-control, with a fixed minor
MD_CTRL_MINOR. The control device is not tied to any md device, each
request specifies the array in the payload, either by name, by UUID or
by device number, without the need to open the md block device.

The new ioctls use the existing MD_MAJOR ioctl type, starting at 0x40,
with an MD_ prefix. Every request structure has a flags field. Unknown
flags are rejected with -EINVAL.

Each new command matches an existing block device ioctl with only one
exception. The STOP_ARRAY_RO has no separate command, it is handled
via MD_STOP_ARRAY with the MD_RO_FLAG set.

New 64-bit structures, including mdu_ioctl, are introduced
(mdu_array_info64, mdu_disk_info64, mdu_param64, mdu_bitmap_file64,
and mdu_version64) to resolve padding and overflow issues in fields
such as size, ctime, and utime.

The existing ioctl on the md block device is unchanged, but a
warning message will be printed to recommend upgrading mdadm.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/Makefile            |   2 +-
 drivers/md/md-ctl.c            | 597 +++++++++++++++++++++++++++++++++
 drivers/md/md.c                |  31 +-
 drivers/md/md.h                |   5 +
 include/linux/miscdevice.h     |   1 +
 include/uapi/linux/raid/md_u.h | 119 +++++++
 6 files changed, 748 insertions(+), 7 deletions(-)
 create mode 100644 drivers/md/md-ctl.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 517d1f7d8288..8831df81e34a 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,7 +27,7 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o
+md-mod-y	+= md.o md-ctl.o
 md-mod-$(CONFIG_MD_BITMAP)	+= md-bitmap.o
 md-mod-$(CONFIG_MD_LLBITMAP)	+= md-llbitmap.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
diff --git a/drivers/md/md-ctl.c b/drivers/md/md-ctl.c
new file mode 100644
index 000000000000..84923b0a2fa3
--- /dev/null
+++ b/drivers/md/md-ctl.c
@@ -0,0 +1,597 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/raid/md_u.h>
+#include <linux/raid/md_p.h>
+#include "md.h"
+#include "md-bitmap.h"
+
+static struct mddev *get_mddev_dev(dev_t dev)
+{
+	struct mddev *mddev, *ret = NULL;
+
+	if (MINOR(dev) >= (1 << MINORBITS))
+		return ERR_PTR(-EINVAL);
+
+	if (MAJOR(dev) != MD_MAJOR)
+		dev &= ~((1 << MdpMinorShift) - 1);
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (mddev->unit == dev) {
+			ret = mddev_get(mddev);
+			if (ret && !mddev->gendisk) {
+				mddev_put(mddev);
+				ret = ERR_PTR(-EBUSY);
+			}
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret ? ret : ERR_PTR(-ENODEV);
+}
+
+static struct mddev *get_mddev_name(const char *name)
+{
+	unsigned long minor;
+	struct mddev *mddev, *ret = NULL;
+
+	if (strncmp(name, "md", 2))
+		return ERR_PTR(-EINVAL);
+
+	if (name[2] != '_' && (!isdigit(name[2]) ||
+			       kstrtoul(&name[2], 10, &minor) ||
+			       minor > MINORMASK))
+		return ERR_PTR(-EINVAL);
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (mddev->gendisk &&
+		    strcmp(mddev->gendisk->disk_name, name) == 0) {
+			ret = mddev_get(mddev);
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret ? ret : ERR_PTR(-ENODEV);
+}
+
+static struct mddev *get_mddev_uuid(const char *uuid)
+{
+	struct mddev *mddev, *ret = NULL;
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (memcmp(mddev->uuid, uuid, sizeof(mddev->uuid)) == 0) {
+			ret = mddev_get(mddev);
+			if (ret && !mddev->gendisk) {
+				mddev_put(mddev);
+				ret = ERR_PTR(-EBUSY);
+			}
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret ? ret : ERR_PTR(-ENODEV);
+}
+
+static struct mddev *ctl_find_mddev(struct mdu_ioctl *md_ctl)
+{
+	struct mddev *ret = ERR_PTR(-EINVAL);
+
+	if (*md_ctl->uuid) {
+		if (*md_ctl->name || md_ctl->dev) {
+			pr_err("md: only supply one of name, uuid or dev number\n");
+			return ret;
+		}
+		ret = get_mddev_uuid(md_ctl->uuid);
+	} else if (*md_ctl->name) {
+		if (md_ctl->dev) {
+			pr_err("md: only supply one of name, uuid or dev number\n");
+			return ret;
+		}
+		ret = get_mddev_name(md_ctl->name);
+	} else if (md_ctl->dev) {
+		ret = get_mddev_dev(md_ctl->dev);
+	}
+
+	return ret;
+}
+
+static int get_raid_version(struct mddev *mddev, struct mdu_version64 __user *user)
+{
+	struct mdu_version64 v = {0};
+
+	v.major = MD_MAJOR_VERSION;
+	v.minor = MD_MINOR_VERSION;
+	v.patchlevel = MD_PATCHLEVEL_VERSION;
+
+	if (copy_to_user(user, &v, sizeof(v)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ctl_get_disk_info(struct mddev *mddev, void __user *arg)
+{
+	struct mdu_disk_info64 info = {0};
+	struct md_rdev *rdev;
+
+	if (!mddev->raid_disks && !mddev->external)
+		return -ENODEV;
+
+	if (copy_from_user(&info, arg, sizeof(info)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	rdev = md_find_rdev_nr_rcu(mddev, info.number);
+	if (rdev) {
+		info.major = MAJOR(rdev->bdev->bd_dev);
+		info.minor = MINOR(rdev->bdev->bd_dev);
+		info.raid_disk = rdev->raid_disk;
+		info.state = 0;
+		if (test_bit(Faulty, &rdev->flags))
+			info.state |= (1 << MD_DISK_FAULTY);
+		else if (test_bit(In_sync, &rdev->flags)) {
+			info.state |= (1 << MD_DISK_ACTIVE);
+			info.state |= (1 << MD_DISK_SYNC);
+		}
+		if (test_bit(Journal, &rdev->flags))
+			info.state |= (1 << MD_DISK_JOURNAL);
+		if (test_bit(WriteMostly, &rdev->flags))
+			info.state |= (1 << MD_DISK_WRITEMOSTLY);
+		if (test_bit(FailFast, &rdev->flags))
+			info.state |= (1 << MD_DISK_FAILFAST);
+	} else {
+		info.major = info.minor = 0;
+		info.raid_disk = -1;
+		info.state = (1 << MD_DISK_REMOVED);
+	}
+	rcu_read_unlock();
+
+	if (copy_to_user(arg, &info, sizeof(info)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ctl_get_bitmap_file(struct mddev *mddev, void __user *arg)
+{
+	struct mdu_bitmap_file64 *file = NULL; /* too big for stack allocation */
+	char *ptr;
+	int err;
+
+	file = kzalloc_obj(*file, GFP_NOIO);
+	if (!file)
+		return -ENOMEM;
+
+	err = 0;
+	spin_lock(&mddev->lock);
+	/* bitmap enabled */
+	if (mddev->bitmap_info.file) {
+		ptr = file_path(mddev->bitmap_info.file, file->pathname,
+				sizeof(file->pathname));
+		if (IS_ERR(ptr))
+			err = PTR_ERR(ptr);
+		else
+			memmove(file->pathname, ptr,
+				sizeof(file->pathname)-(ptr-file->pathname));
+	}
+	spin_unlock(&mddev->lock);
+
+	if (err == 0 &&
+	    copy_to_user(arg, file, sizeof(*file)))
+		err = -EFAULT;
+
+	kfree(file);
+	return err;
+}
+
+static int ctl_get_array_info(struct mddev *mddev, void __user *arg)
+{
+	struct mdu_array_info64 info = {0};
+	int nr, working, insync, failed, spare, journal;
+	struct md_rdev *rdev;
+
+	if (!mddev->raid_disks && !mddev->external)
+		return -ENODEV;
+
+	nr = working = insync = failed = spare = journal = 0;
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		nr++;
+		if (test_bit(Faulty, &rdev->flags)) {
+			failed++;
+		} else {
+			working++;
+			if (test_bit(In_sync, &rdev->flags))
+				insync++;
+			else if (test_bit(Journal, &rdev->flags))
+				journal++;
+			else
+				spare++;
+		}
+	}
+	rcu_read_unlock();
+
+	info.major_version = mddev->major_version;
+	info.minor_version = mddev->minor_version;
+	info.patch_version = MD_PATCHLEVEL_VERSION;
+	info.ctime         = mddev->ctime;
+	info.level         = mddev->level;
+	info.size          = mddev->dev_sectors / 2;
+	info.nr_disks      = nr;
+	info.raid_disks    = mddev->raid_disks;
+	info.md_minor      = mddev->md_minor;
+	info.not_persistent = !mddev->persistent;
+
+	info.utime         = mddev->utime;
+	info.state         = 0;
+	if (mddev->in_sync)
+		info.state = (1 << MD_SB_CLEAN);
+	if (mddev->bitmap && mddev->bitmap_info.offset)
+		info.state |= (1 << MD_SB_BITMAP_PRESENT);
+	if (mddev_is_clustered(mddev))
+		info.state |= (1 << MD_SB_CLUSTERED);
+	info.active_disks  = insync;
+	info.working_disks = working;
+	info.failed_disks  = failed;
+	info.spare_disks   = spare;
+	info.journal_disks = journal;
+
+	info.layout        = mddev->layout;
+	info.chunk_size    = mddev->chunk_sectors << 9;
+
+	if (copy_to_user(arg, &info, sizeof(info)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static inline int ctl_ioctl_valid(unsigned int cmd)
+{
+	switch (cmd) {
+	case MD_GET_ARRAY_INFO:
+	case MD_GET_DISK_INFO:
+	case MD_RAID_VERSION:
+		return 0;
+
+	case MD_RAID_AUTORUN:
+	case MD_SET_DISK_FAULTY:
+	case MD_GET_BITMAP_FILE:
+	case MD_ADD_NEW_DISK:
+	case MD_HOT_ADD_DISK:
+	case MD_HOT_REMOVE_DISK:
+	case MD_RESTART_ARRAY_RW:
+	case MD_RUN_ARRAY:
+	case MD_SET_ARRAY_INFO:
+	case MD_SET_BITMAP_FILE:
+	case MD_STOP_ARRAY:
+	case MD_CLUSTERED_DISK_NACK:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static inline int ctl_flags_valid(unsigned int cmd, u32 flags)
+{
+	switch (cmd) {
+	case MD_GET_ARRAY_INFO:
+	case MD_GET_DISK_INFO:
+	case MD_RAID_VERSION:
+	case MD_RAID_AUTORUN:
+	case MD_GET_BITMAP_FILE:
+	case MD_ADD_NEW_DISK:
+	case MD_HOT_ADD_DISK:
+	case MD_HOT_REMOVE_DISK:
+	case MD_RESTART_ARRAY_RW:
+	case MD_RUN_ARRAY:
+	case MD_SET_ARRAY_INFO:
+	case MD_SET_BITMAP_FILE:
+	case MD_SET_DISK_FAULTY:
+	case MD_CLUSTERED_DISK_NACK:
+		if (flags)
+			return -ENOTTY;
+		return 0;
+	case MD_STOP_ARRAY:
+		if (flags && flags != MD_RO_FLAG)
+			return -ENOTTY;
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static inline unsigned int try_convert_ioctl_cmd(unsigned int cmd,
+						 unsigned int flags)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case MD_SET_DISK_FAULTY:
+		ret = SET_DISK_FAULTY;
+		break;
+
+	case MD_HOT_ADD_DISK:
+		ret = HOT_ADD_DISK;
+		break;
+
+	case MD_HOT_REMOVE_DISK:
+		ret = HOT_REMOVE_DISK;
+		break;
+
+	case MD_RAID_AUTORUN:
+		ret = RAID_AUTORUN;
+		break;
+
+	case MD_RESTART_ARRAY_RW:
+		ret = RESTART_ARRAY_RW;
+		break;
+
+	case MD_RUN_ARRAY:
+		ret = RUN_ARRAY;
+		break;
+
+	case MD_SET_BITMAP_FILE:
+		ret = SET_BITMAP_FILE;
+		break;
+
+	case MD_STOP_ARRAY:
+		if (flags == MD_RO_FLAG)
+			ret = STOP_ARRAY_RO;
+		else
+			ret = STOP_ARRAY;
+		break;
+
+	case MD_CLUSTERED_DISK_NACK:
+		ret = CLUSTERED_DISK_NACK;
+		break;
+	};
+
+	return ret;
+}
+
+static void ctl_convert_array_info(mdu_array_info_t *info,
+				  struct mdu_array_info64 *info64)
+{
+	info->major_version = info64->major_version;
+	info->minor_version = info64->minor_version;
+	info->patch_version = info64->patch_version;
+	info->level = info64->level;
+	info->ctime = info64->ctime;
+	info->size = info64->size;
+	info->nr_disks = info64->nr_disks;
+	info->raid_disks = info64->raid_disks;
+	info->md_minor = info64->md_minor;
+	info->not_persistent = info64->not_persistent;
+	info->utime = info64->utime;
+	info->state = info64->state;
+	info->active_disks = info64->active_disks;
+	info->working_disks = info64->working_disks;
+	info->failed_disks = info64->failed_disks;
+	info->spare_disks = info64->spare_disks;
+	info->layout = info64->layout;
+	info->chunk_size = info64->chunk_size;
+}
+
+static void ctl_convert_disk_info(mdu_disk_info_t *info,
+				  struct mdu_disk_info64 *info64)
+{
+	info->number = info64->number;
+	info->major = info64->major;
+	info->minor = info64->minor;
+	info->raid_disk = info64->raid_disk;
+	info->state = info64->state;
+}
+
+static int ctl_set_read_write(struct mddev *mddev)
+{
+	if (!md_is_rdwr(mddev) && mddev->pers) {
+		if (mddev->ro != MD_AUTO_READ)
+			return -EROFS;
+
+		mddev->ro = MD_RDWR;
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		/* mddev_unlock will wake thread */
+		/* If a device failed while we were read-only, we
+		 * need to make sure the metadata is updated now.
+		 */
+		if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
+			mddev_unlock(mddev);
+			wait_event(mddev->sb_wait,
+				   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
+				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
+			mddev_lock_nointr(mddev);
+		}
+	}
+
+	return 0;
+}
+
+static int ctl_add_new_disk(struct mddev *mddev,
+			    struct mdu_disk_info64 __user *user)
+{
+	mdu_disk_info_t info;
+	struct mdu_disk_info64 info64;
+	int err;
+
+	if (copy_from_user(&info64, user, sizeof(info64)))
+		return -EFAULT;
+
+	ctl_convert_disk_info(&info, &info64);
+
+	/*
+	 * We can support ADD_NEW_DISK on read-only arrays
+	 * only if we are re-adding a preexisting device.
+	 * So require mddev->pers and MD_DISK_SYNC.
+	 */
+	if (mddev->pers && (info.state & (1 << MD_DISK_SYNC)))
+		return md_add_new_disk(mddev, &info);
+
+	err = ctl_set_read_write(mddev);
+	if (err)
+		return err;
+
+	return md_add_new_disk(mddev, &info);
+}
+
+static int ctl_set_array_info(struct mddev *mddev,
+			      struct mdu_array_info64 __user *user)
+{
+	mdu_array_info_t info;
+	struct mdu_array_info64 info64;
+	int err;
+
+	if (!user)
+		memset(&info64, 0, sizeof(info64));
+	else if (copy_from_user(&info64, user, sizeof(info64)))
+		return -EFAULT;
+
+	ctl_convert_array_info(&info, &info64);
+
+	if (mddev->pers) {
+		err = update_array_info(mddev, &info);
+		if (err)
+			pr_warn("md: couldn't update array info. %d\n", err);
+		return err;
+	}
+
+	if (!list_empty(&mddev->disks)) {
+		pr_warn("md: array %s already has disks!\n", mdname(mddev));
+		return -EBUSY;
+	}
+
+	if (mddev->raid_disks) {
+		pr_warn("md: array %s already initialised!\n", mdname(mddev));
+		return -EBUSY;
+	}
+
+	err = md_set_array_info(mddev, &info);
+	if (err)
+		pr_warn("md: couldn't set array info. %d\n", err);
+
+	return err;
+}
+
+static long md_ctl_ioctl(struct file *filp, uint cmd, ulong u)
+{
+	int err;
+	unsigned int old_cmd;
+	unsigned int noio_flags = 0;
+	struct mddev *mddev;
+	void __user *arg;
+	struct mdu_ioctl md_ctl;
+
+	err = ctl_ioctl_valid(cmd);
+	if (err)
+		return err;
+
+	if (cmd == MD_RAID_VERSION)
+		return get_raid_version(mddev, (struct mdu_version64 __user *)u);
+
+	if (copy_from_user(&md_ctl, (void __user *)u, sizeof(md_ctl)))
+		return -EFAULT;
+
+	err = ctl_flags_valid(cmd, md_ctl.flags);
+	if (err)
+		return err;
+
+	mddev = ctl_find_mddev(&md_ctl);
+	if (IS_ERR(mddev))
+		return PTR_ERR(mddev);
+
+	old_cmd = try_convert_ioctl_cmd(cmd, md_ctl.flags);
+	if (old_cmd) {
+		err = md_do_ioctl(mddev->gendisk->part0, 0, old_cmd, md_ctl.arg);
+		goto out;
+	}
+
+	arg = (void __user *)md_ctl.arg;
+	switch (cmd) {
+	case MD_GET_ARRAY_INFO:
+		err = ctl_get_array_info(mddev, arg);
+		goto out;
+
+	case MD_GET_DISK_INFO:
+		err = ctl_get_disk_info(mddev, arg);
+		goto out;
+
+	case MD_GET_BITMAP_FILE:
+		err = ctl_get_bitmap_file(mddev, arg);
+		goto out;
+	};
+
+	if (!md_is_rdwr(mddev))
+		flush_work(&mddev->sync_work);
+
+	err = mddev_suspend_and_lock(mddev);
+	if (err) {
+		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
+			 err, cmd);
+		goto out;
+	}
+	noio_flags = memalloc_noio_save();
+
+	switch (cmd) {
+	case MD_SET_ARRAY_INFO:
+		err = ctl_set_array_info(mddev, arg);
+		break;
+
+	case MD_ADD_NEW_DISK:
+		err = ctl_add_new_disk(mddev, arg);
+		break;
+	}
+
+	if (mddev->hold_active == UNTIL_IOCTL && err != -EINVAL)
+		mddev->hold_active = 0;
+
+	memalloc_noio_restore(noio_flags);
+	mddev_unlock_and_resume(mddev);
+out:
+	mddev_put(mddev);
+	return err;
+}
+
+static const struct file_operations file_ops = {
+	.open = nonseekable_open,
+	.unlocked_ioctl = md_ctl_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
+	.owner = THIS_MODULE,
+	.llseek  = noop_llseek,
+};
+
+static struct miscdevice md_ctl_misc = {
+	.name = MD_CTL_NODE,
+	.minor = MD_CTRL_MINOR,
+	.fops = &file_ops,
+};
+
+MODULE_ALIAS_MISCDEV(MD_CTRL_MINOR);
+MODULE_ALIAS("devname:" MD_CTL_NODE);
+
+int __init md_ctl_init(void)
+{
+	int err;
+
+	err = misc_register(&md_ctl_misc);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void __init md_ctl_exit(void)
+{
+	misc_deregister(&md_ctl_misc);
+}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b5027d65c6d8..86610e20ee39 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8339,8 +8339,8 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 	return err;
 }
 
-static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
-			unsigned int cmd, unsigned long arg)
+int md_do_ioctl(struct block_device *bdev, blk_mode_t mode, unsigned int cmd,
+		unsigned long arg)
 {
 	int err = 0;
 	unsigned int noio_flags = 0;
@@ -8348,10 +8348,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	struct mddev *mddev = NULL;
 	bool suspend;
 
-	err = md_ioctl_valid(cmd);
-	if (err)
-		return err;
-
 	/*
 	 * Commands dealing with the RAID driver but not any
 	 * particular array:
@@ -8541,6 +8537,21 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
 }
+
+static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	int err;
+
+	err = md_ioctl_valid(cmd);
+	if (err)
+		return err;
+
+	pr_warn_once("md: ioctl is deprecated and will be removed in future, please upgrade to mdadm-4.6+\n");
+
+	return md_do_ioctl(bdev, mode, cmd, arg);
+}
+
 #ifdef CONFIG_COMPAT
 static int md_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
@@ -10774,12 +10785,20 @@ static int __init md_init(void)
 		goto err_mdp;
 	mdp_major = ret;
 
+	ret = md_ctl_init();
+	if (ret < 0)
+		goto err_ctl;
+
 	register_reboot_notifier(&md_notifier);
 	raid_table_header = register_sysctl("dev/raid", raid_table);
 
 	md_geninit();
+
 	return 0;
 
+err_ctl:
+	unregister_blkdev(mdp_major, "mdb");
+	mdp_major = 0;
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index cb8760521764..2c0e53edd6f1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -975,7 +975,12 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev,
 				      struct md_rdev *rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
+int set_disk_faulty(struct mddev *mddev, dev_t dev);
 int update_array_info(struct mddev *mddev, mdu_array_info_t *info);
+int md_ctl_init(void);
+void md_ctl_exit(void);
+int md_do_ioctl(struct block_device *bdev, blk_mode_t mode, unsigned int cmd,
+		unsigned long arg);
 
 extern struct list_head all_mddevs;
 extern spinlock_t all_mddevs_lock;
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index fa9000f68523..0bf2870dc191 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -71,6 +71,7 @@
 #define VHOST_VSOCK_MINOR	241
 #define EISA_EEPROM_MINOR	241
 #define RFKILL_MINOR		242
+#define MD_CTRL_MINOR		243
 
 /*
  * Misc char device minor code space division related to below macro:
diff --git a/include/uapi/linux/raid/md_u.h b/include/uapi/linux/raid/md_u.h
index a893010735fb..ce4ba1f10b89 100644
--- a/include/uapi/linux/raid/md_u.h
+++ b/include/uapi/linux/raid/md_u.h
@@ -12,6 +12,8 @@
 #ifndef _UAPI_MD_U_H
 #define _UAPI_MD_U_H
 
+#include <linux/types.h>
+
 /*
  * Different major versions are not compatible.
  * Different minor versions are only downward compatible.
@@ -30,6 +32,10 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+#define MD_NAME_LEN                     32
+#define MD_UUID_LEN                     16
+#define MD_CTL_NODE                     "md-control"
+
 /* ioctls */
 
 /* status */
@@ -61,6 +67,29 @@
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
 #define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)
 
+/* ioctl commands for the MD misc control driver */
+/* status */
+#define MD_RAID_VERSION		_IOR(MD_MAJOR, 0x40, struct mdu_version64)
+#define MD_GET_ARRAY_INFO	_IOWR(MD_MAJOR, 0x41, struct mdu_ioctl)
+#define MD_GET_DISK_INFO	_IOWR(MD_MAJOR, 0x42, struct mdu_ioctl)
+#define MD_RAID_AUTORUN		_IOWR(MD_MAJOR, 0x43, struct mdu_ioctl)
+#define MD_GET_BITMAP_FILE	_IOWR(MD_MAJOR, 0x44, struct mdu_ioctl)
+
+/* configuration */
+#define MD_ADD_NEW_DISK		_IOWR(MD_MAJOR, 0x50, struct mdu_ioctl)
+#define MD_HOT_ADD_DISK		_IOWR(MD_MAJOR, 0x51, struct mdu_ioctl)
+#define MD_HOT_REMOVE_DISK	_IOWR(MD_MAJOR, 0x52, struct mdu_ioctl)
+#define MD_SET_ARRAY_INFO	_IOWR(MD_MAJOR, 0x53, struct mdu_ioctl)
+#define MD_SET_DISK_INFO	_IOWR(MD_MAJOR, 0x54, struct mdu_ioctl)
+#define MD_SET_DISK_FAULTY	_IOWR(MD_MAJOR, 0x55, struct mdu_ioctl)
+#define MD_SET_BITMAP_FILE	_IOWR(MD_MAJOR, 0x56, struct mdu_ioctl)
+
+/* usage */
+#define MD_RUN_ARRAY		_IOWR(MD_MAJOR, 0x60, struct mdu_ioctl)
+#define MD_STOP_ARRAY		_IOWR(MD_MAJOR, 0x61, struct mdu_ioctl)
+#define MD_RESTART_ARRAY_RW	_IOWR(MD_MAJOR, 0x62, struct mdu_ioctl)
+#define MD_CLUSTERED_DISK_NACK	_IOWR(MD_MAJOR, 0x63, struct mdu_ioctl)
+
 /* 63 partitions with the alternate major number (mdp) */
 #define MdpMinorShift 6
 
@@ -146,4 +175,94 @@ typedef struct mdu_param_s
 	int			max_fault;	/* unused for now */
 } mdu_param_t;
 
+/* structures for the MD misc control driver */
+struct mdu_version64 {
+	__u32 major;
+	__u32 minor;
+	__u32 patchlevel;
+	__u32 padding;
+};
+
+struct mdu_array_info64 {
+	/*
+	 * Generic constant information
+	 */
+	__u32 major_version;
+	__u32 minor_version;
+	__u32 patch_version;
+	__s32 level;
+
+	__u64 ctime;
+	__u64 size;
+
+	__u32 nr_disks;
+	__u32 raid_disks;
+	__u32 md_minor;
+	__u32 not_persistent;
+
+	/*
+	 * Generic state information
+	 */
+	__u64 utime;		/*  0 Superblock update time		      */
+
+	__u32 state;		/*  1 State bits (clean, ...)		      */
+	__u32 active_disks;	/*  2 Number of currently active disks	      */
+	__u32 working_disks;	/*  3 Number of working disks		      */
+	__u32 failed_disks;	/*  4 Number of failed disks		      */
+	__u32 spare_disks;	/*  5 Number of spare disks		      */
+	__u32 journal_disks;    /*  6 Number of disks used for journaling     */
+
+	/*
+	 * Personality information
+	 */
+	__s32 layout;		/*  0 the array's physical layout	      */
+	__u32 chunk_size;	/*  1 chunk size in bytes		      */
+
+};
+
+struct mdu_disk_info64 {
+	/*
+	 * configuration/status of one particular disk
+	 */
+	__u32 state;
+	__u32 major;
+	__u32 minor;
+	__u32 padding;
+
+	__s32 number;
+	__s32 raid_disk;
+};
+
+struct mdu_bitmap_file64 {
+	char pathname[4096];
+};
+
+struct mdu_param64 {
+	__s32 personality;	/* 1,2,3,4 */
+	__u32 max_fault;	/* unused for now */
+	__u32 chunk_size;	/* in bytes */
+	__u32 padding;
+};
+
+struct mdu_ioctl {
+	char name[MD_NAME_LEN];
+	char uuid[MD_UUID_LEN];
+	__u64 dev;
+	__u32 flags;
+	__u32 padding;
+	union {
+		__u64 array;
+		__u64 disk;
+		__u64 param;
+		__u64 bitmap_file;
+		__u64 arg;
+	};
+};
+
+/*
+ * If set, MD_STOP_ARRAY will switch the array to read-only mode instead
+ * of fully stopping it.
+ */
+#define MD_RO_FLAG              (1u << 0)
+
 #endif /* _UAPI_MD_U_H */
-- 
2.43.0

