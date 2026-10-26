Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.108.3.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792988511;
	b=a/S818xKxpAM9m5lY5q4zIxC1PNjOd1xPqZFXZvU7UAnOOecVY1GfGA0zDDIbtdpmEtb
	 5L0N3sBwbD7Xa6oKmTrhSe4WG6vLRv8qZTtwDoBwxNwPdtOE9xqK8zK6Sg41x5kM2H/uG
	 aIjwuWRA13R5Q8ppD8s+cYBPPM9mx4r4Lo8CFXnD7n4aB8iw/WrapLU1JMvrZmBvxOK4L
	 R0btvB0zVfwwQUHwoCO06hCtgPJmfPCP6GHc86AYYAz+wEmX3hJsl++i0bk3kHPND67C/
	 Sw/z9tdc5e1s5d5EMSiEnyOXaS/+rthHWKDbfAoyTLE1jIVHXhMW7ltEjX7Xr4q8H1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792988511;
	h=DMARC-Filter:DKIM-Signature:X-SMAIL-HELO:Received:X-Sender:X-Auth-ID:
	 X-SMAIL-MID:X-SMAIL-UIID:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CUCN+Yc9xrYZdlF3x/awRVSb0dFgGk0gG/fA1JFqvus=;
	b=znG2vaqFjMblncA9xs1Pt+XaktON0RGSI2DORCU9ePdcsXmuTqeFqNS34+vEXtmsqcRn
	 VDjbOanYjhK3JcKwxnTVaBNkP4oYT/zbeKmjyJ/BtOF5c0AyHq2lmyJorGjGmr4EnBDo+
	 HSOljEY7V6n1iCFLIobNrOanqMtYpEZdH8/wdmPTIEw+2X7XhqbAzKLM8reNLDBLAr1by
	 brhJUWK+6eGwYk4quBhEo0erQa+ytA/BvmCS/hTpfbaew8UL1qt1P7+knMlyIfUcl1KEi
	 +iQDJ6pIJsBB4Y0lgTmnxtKbtfyk0wfeYLcwq8gjVhx4ig/6hxncbNr2xFoUhbn3p6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=sina.com;
	spf=pass smtp.mailfrom=sina.com;
	dkim=pass header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=pxM64Bfl;
	arc=none smtp.remote-ip=202.108.3.19
Received: from r3-19.sinamail.sina.com.cn (r3-19.sinamail.sina.com.cn [202.108.3.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D791606A328
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 04:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D791606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=pxM64Bfl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792988509;
	bh=CUCN+Yc9xrYZdlF3x/awRVSb0dFgGk0gG/fA1JFqvus=;
	h=From:Subject:Date:Message-ID;
	b=pxM64BflpUjulUaJ71Z0w8mLH8In6j2YzVSZVOF2CLg2OH3oB649BCGx5nNBsE+Zv
	 2qx8GUgcZCG7KTonLXtbM+6nw6tbzMjK5R0rPfyUohTa6EXCuNdyEw0zVtDVMKmKhn
	 ET52B9WFy+Zd/3XWvNe1i6nzu+piJXaICk7KO55k=
X-SMAIL-HELO: lxu-ped-host..
Received: from unknown (HELO lxu-ped-host..)([111.198.231.89])
	by sina.com (10.54.253.32) with ESMTP
	id 6ADED5510000216A; Mon, 26 Oct 2026 12:21:40 +0800 (CST)
X-Sender: eadavis@sina.com
X-Auth-ID: eadavis@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=eadavis@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=eadavis@sina.com
X-SMAIL-MID: 6065414457132
X-SMAIL-UIID: 2283B7CF7A9F49A08C918F959AAAB6EA-20261026-122140-1
From: Edward Adam Davis <eadavis@sina.com>
To: syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com
Cc: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	syzkaller-bugs@googlegroups.com,
	ejt@redhat.com
Subject: [PATCH] dm: reject kcopyd client destory if it setup failed
Date: Mon, 26 Oct 2026 12:21:37 +0800
Message-ID: <20261026042137.178310-1-eadavis@sina.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6addec28.412b1182.196980.00aa.GAE@google.com>
References: <6addec28.412b1182.196980.00aa.GAE@google.com>
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

The value of cache->copier is -EINTR when failed to create a rescuer
kthread for wq kcopyd, in cache_create(), the code jumps directly to
__destroy(cache), it merely performs a simple check to see whether copier
is NULL, potentially hitting:

BUG: KASAN: null-ptr-deref in dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
Read of size 4 at addr 0000000000000174 by task syz.2.19/6560
Call Trace:
 dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
 __destroy+0x172/0x2f0 drivers/md/dm-cache-target.c:1973
 cache_create drivers/md/dm-cache-target.c:2604 [inline]
 cache_ctr+0x1674/0x2bf0 drivers/md/dm-cache-target.c:2649
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]

Set copier to NULL to avoid destroying a invalid kcopy client.

Fixes: c6b4fcbad044 ("dm: add cache target")
Reported-by: syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a2626a25eb2595e3ec3c
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
---
 drivers/md/dm-cache-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1a5072425c4a..b562bf59124c 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2544,6 +2544,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	if (IS_ERR(cache->copier)) {
 		*error = "could not create kcopyd client";
 		r = PTR_ERR(cache->copier);
+		cache->copier = NULL;
 		goto bad;
 	}
 
-- 
2.43.0

