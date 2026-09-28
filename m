Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128D4E66A5
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626370; cv=none; b=rgRjUxMnyFu4koLxpJT5pEd1cu5EXKUDahX2DNkw9FdvYSYKKU3ac1X2nZLYCQOIcwu1sTWel7460bcU3t9ZRKyCI/SVznb3HtlYQECNy8g8ets65F9gZwYevH2Hl27pMk6r1wP5yj3gJDnTiUqwo2Ahpz9G1tTrFj9H++at58Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626370; c=relaxed/simple;
	bh=6Dp/hhMzy2cZom8NGxLWZtptCrgvBGm+SG+vfodARZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M8mCBc6cfPKY9JQNlMeLEsE+a6kF3fh7oWfgz/HNyQJShGMm6cXqPP+EsbNjGeOe2jEirX8zn21I897BcpvknRmabBlck8rU/Kl9lUhS+8W78M0632zGZDxWanA/Y0nV0AOAJ9WzVtmB4M7YvFsRwdDEp6FDdE/94aZ/eG1HW04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnBczZCy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnBczZCy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a003bd18e5so8148795e9.0
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790626365; x=1791231165; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xiagLwmOxbDGI/iupLudQ2PVS19f/NOJ4+VSuZuRNvA=;
        b=RnBczZCy6vjlOLd532VTdRo0BfxBAUKjynFDfiAbTDZUgc7nZuNlhTvmP+wbqIYvKe
         fh+xTirZmpPAeKPan8E2wD4ZrxmTZ53iMvNPNL6sE5PHs3HsCZ7DM2MbhRLkFuqrZRpX
         CYrdS1R/ecqmCH4tyW/vKPDM9E1Q6QH3Rq6eu1SnRUoJspAQJei/5X+HLtrZtpc9k7IL
         9LavKI9tQfoXAZqa6GTW4mprhsxpaDLVZfKk0UJnFlDlRFU1qOnMAPF3VR1Xno015Tur
         FOYlScYPajJrj7ccJEuu1TZN7Z2Q4E0H8D0vJ5EVGCDv6Ul3xVvxot5Fv/n8KmEWvIPt
         e9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790626365; x=1791231165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xiagLwmOxbDGI/iupLudQ2PVS19f/NOJ4+VSuZuRNvA=;
        b=FoDU+yIc5w67MtKZ1PUZvxmYobUffZXSvGrO7WlArxBx34+Xu5ah6ucjzCsFGHdI5/
         mkC+Bi4QpC/v2f6clXuFluJ9nAPMgeW4TQFukANA/p6Cru6AZ9opbDGUpDQcb29exzRu
         m1jjPgzIGvgYrIb6F35O7FMA7XsEmNlRLShfcUEu3U3T/qeVSXbY6nTw1i9GzHYc8hsL
         OP13vcWZy2LffabLaR6Bh2PSl6udg9V5BEVz4/Qqv8xLRD3Z2TBICRsvFqS5xefNoamG
         5Z+YAo/Wt1nFF6kgspuxu4O/UjWua10aLRy1Hpc1L8XPfBZNgXiaIU0Sw/aTJLSuYCg4
         QjWw==
X-Forwarded-Encrypted: i=1; AKwUvBzicpoywKTEJNgIDyyOHMmFaI7QWuQJGWmTDrJi0DQzIqe8A5Lz9ybdlM9NKL8j1g6EBg5dRtS0Ug==@lists.linux.dev
X-Gm-Message-State: AFuF++kTFfZ9c50WRtPflrEi4xjbul2TltY9/lC7Tx/UEZ2jw94FOm+e
	4qapJZ9EYA7u8lbmvsOWu4A0uAC0r6mccNgBFdu8rv3WGzaREFxWu36u
X-Gm-Gg: AYBFou2Fr5fkpDviMbMAq0ctRrzVZQBubJ8z3sYpdEpSbMTzSeoQD54vXNKdUW7MIhA
	BWp5AMy7kx1bFPY6p+ok1MlxMKUrZWMrvTsu0D+jl1qIgeCGZWQXAZye2t4p7ItcMI3I043r7P9
	Yg4trYhIlYY8BKgJceO/CwVsvSXV8x8C79H6RbEKmPMiYYIf+32qM0IvzRcZVNCuGJWa0gWhLcB
	9gNat522fu76ibUkaJWMdw205zCQUM5g/SfAm3nAshL6flvy71TgtgS0baGmJDE2MQ/qwOnMxoc
	XyTG4mCxv+Xqd7Mki5cj3UPcANZkZjoETdtAvNmOVhRxXvhMiN7frFyvr4JHa4X16rJ3KqbQ2sV
	35mNXWk1Yr/S0mZUgVl2A5oDlKLuS0Epg0cPRzsSYTQGi1nlg57p22D/6SedEnSAyhNbeu/HXdh
	vvCkbngXhZi2rD0EuZVREPpyZ4s07VNg3ev6vXtNRaQm5yKohj6HNqRaE6qtbpfw9G6RAkfBVQi
	uh211+wtx1TpZLLF36dAyOAecfUUxAhGZK7h/hnHOM/Df5AA4HPUV29ww==
X-Received: by 2002:a05:600c:348e:b0:49e:8191:e5cb with SMTP id 5b1f17b1804b1-49ff06b2ef6mr188592985e9.5.1790626364553;
        Mon, 28 Sep 2026 13:12:44 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c11a9d2sm30457755e9.3.2026.09.28.13.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 13:12:43 -0700 (PDT)
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
Subject: [PATCH 0/2] md: add a control device for array management
Date: Mon, 28 Sep 2026 20:12:22 +0000
Message-ID: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
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

The mdadm tool has been updated accordingly, and the mdadm patches will
be posted to the linux-raid mailing list shortly.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

Abd-Alrhman Masalkhi (2):
  md: make mddev lookup and ioctl helpers non-static
  md: add a control device for array management

 drivers/md/Makefile            |   2 +-
 drivers/md/md-ctl.c            | 597 +++++++++++++++++++++++++++++++++
 drivers/md/md.c                |  41 ++-
 drivers/md/md.h                |  10 +
 include/linux/miscdevice.h     |   1 +
 include/uapi/linux/raid/md_u.h | 119 +++++++
 6 files changed, 758 insertions(+), 12 deletions(-)
 create mode 100644 drivers/md/md-ctl.c

-- 
2.43.0

