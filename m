Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.43.8.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200557;
	b=A/VrInvkJpB4D9HeLPPLSBQpaLP56W/H+nMr0azl8Q9FDQyZUCtG2fWljgOX4mNv/+em
	 HJRAdXJeCmyZoH/cDsA3Ygr74s3jOA62BnXz7YtwiYVXip5FqyXj+jogKc93DpEuZezHB
	 tAeC3DuVglLS0a0tZiVexQj9rtM9NuXM4hxCp25nHAkIPo1Q6mS31Q2av+QXpZT0NoKa/
	 zlzbzXx8wAJ+/hdrrdeQtoCgyB8YUZN6NUS46dno8xKz7eEtTPTc1Q2NUZr0CKlkKRnuO
	 r6PPmH4b7cmpuP8+dUQ5QQNHg00yDYdqwMGDuMi7sT2+EyY0gk0spAGKdFtYBa+x60g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200557;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Spam;
	bh=x8H2tKO0C0PdsM1jNymnO3uaSjF7/flYmxM47M7+lu4=;
	b=BAf3I42P6K33FhOhZO1pbtHh239iIj7R3fE+96Djf9esxkozauM+qN/TgLJqn0jOqsYF
	 Kt7aSVfmsyQkqyMNuQOGmXpJ2d9bEbIt6HdWDH6nJ9WXjJEQiOstpJX5kg3qEAcWhbDWh
	 5fuYW0kdkxw/iMWlKLgFhZFXT77P5SzdJT0CjRCjrT2mpxWLgBp714vuQJyl908SX/mjF
	 iDQejrVX47li86ZLp0vslapeb3Yi94NmoA7u5Bo3LRuB5jcY3t6hAUnwh7sw8uC9RUBs0
	 P/+hxqxtKP05J2dal64A+o5S8Jp37DL5si/0nuKJ575vqP2MWaIKUe+u5AEU2TgrOzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=altlinux.org;
	spf=pass smtp.mailfrom=altlinux.org;
	arc=none smtp.remote-ip=193.43.8.18
Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C3160A2614
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 18:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23C3160A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 184BD23372;
	Fri, 20 Nov 2026 21:49:09 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH] dm-unstripe: terminate the status string for STATUSTYPE_INFO
Date: Fri, 20 Nov 2026 21:49:08 +0300
Message-ID: <20261120184908.614271-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes

unstripe_status() writes nothing to the result buffer for
STATUSTYPE_INFO. retrieve_status() then runs strlen() on that buffer,
which still holds whatever the caller passed in the ioctl payload. If
the payload contains no NUL byte, strlen() runs past the end of the
kernel copy of the ioctl buffer:

BUG: KASAN: slab-out-of-bounds in strlen+0x8f/0xa0 lib/string.c:402
Read of size 1 at addr ffff888109690566 by task syz.1.18/1420

CPU: 0 UID: 0 PID: 1420 Comm: syz.1.18 Not tainted 7.4.0-rc1-next-20261104-alt-syz-box-drivers_md_bcache #1 PREEMPT(lazy)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xc2/0x120 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xce/0x640 mm/kasan/report.c:482
 kasan_report+0xdc/0x110 mm/kasan/report.c:595
 strlen+0x8f/0xa0 lib/string.c:402
 __fortify_strlen include/linux/fortify-string.h:218 [inline]
 retrieve_status+0x483/0x8c0 drivers/md/dm-ioctl.c:1442
 dev_wait+0x1ba/0x210 drivers/md/dm-ioctl.c:1496
 ctl_ioctl+0x4d2/0xd70 drivers/md/dm-ioctl.c:2221
 dm_ctl_ioctl+0x1e/0x30 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18a/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x630 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x00007f6a853ea829
 </TASK>

retrieve_status() then also reports a data_size past the end of the
payload, and ctl_ioctl() copies the bytes behind it back to userspace.
The same happens with DM_TABLE_STATUS.

Other targets emit at least an empty string here; do the same as for
STATUSTYPE_IMA.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 18a5bf270532 ("dm: add unstriped target")
Cc: stable@vger.kernel.org
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/md/dm-unstripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 770a9958def0..708640a8f6d4 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -150,6 +150,7 @@ static void unstripe_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
+		*result = '\0';
 		break;
 
 	case STATUSTYPE_TABLE:
-- 
2.50.1

