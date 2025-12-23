Received: from www.redadmin.org (bc043154.ppp.asahi-net.or.jp [222.228.43.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8C8F507
	for <dm-devel@lists.linux.dev>; Tue, 23 Dec 2025 11:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=222.228.43.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766488289; cv=pass; b=AjDyZHKa5aQiy58TKh2t6DSV5Xyw5sal1UF5TttkoXkqEVBycN/eCY4LrLs81zvHmfdvzFBnfA2IqKyTy7FF3lWWk7jnzUHqZQ2PiTkEaaiwbJYAYBMtrKsK6JCPv4CQEdXWIp441vDNds94sUrdkcfsoKb3asNoH5XgjteF9Mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766488289; c=relaxed/simple;
	bh=lMFcQltyr9xBhUDRNYzRClWWsFoNv+IBJVHnY0x4yQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q8xttse2BU61y8uSGdp6a5JELzvH0CG7PE80ZUDZVsexad+t5psEQ074Le3ow4qIU8El9yOZP6pskpkRLA+iJ5uxm+0jtHpUQMBM/ltwgOqtFwG50lgr6tynTezSJo35tXrNReUSytMeZTLqT5fiIMwgg/P4jarjYNNXBIaoqJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redadmin.org; spf=pass smtp.mailfrom=redadmin.org; dkim=pass (1024-bit key) header.d=redadmin.org header.i=@redadmin.org header.b=VYxPL5bg; arc=pass smtp.client-ip=222.228.43.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redadmin.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redadmin.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redadmin.org header.i=@redadmin.org header.b="VYxPL5bg"
Received: from localhost (localhost [127.0.0.1])
	by www.redadmin.org (Postfix) with ESMTP id 52A52109D5746;
	Tue, 23 Dec 2025 20:11:18 +0900 (JST)
X-Virus-Scanned: amavis at redadmin.org
Received: from www.redadmin.org ([127.0.0.1])
 by localhost (redadmin.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id ZMeFMDwI3jCA; Tue, 23 Dec 2025 20:11:14 +0900 (JST)
Received: by www.redadmin.org (Postfix, from userid 1000)
	id 07AAC10A0ECCF; Tue, 23 Dec 2025 20:11:14 +0900 (JST)
Authentication-Results: www.redadmin.org; arc=none smtp.remote-ip=127.0.0.1
ARC-Seal: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space; t=1766488274;
	cv=none; b=T8Fmn2Qu33A9roXXiNySWaIaN82ySA8fv7/MznswPY22TxHGtcYHfHdD3VxQxjQ3io+I0/k3hnVN3HTlxGWO+lHfck3Mycl0QLvTvFj5Ce8ZlOK2TgyHz8uaZglsaLXqbOklj+LbLJGIZDMkbP9Jx6idt0FNnL9k5ZXKQy+IWeo=
ARC-Message-Signature: i=1; a=rsa-sha256; d=redadmin.org; s=20231208space;
	t=1766488274; c=relaxed/relaxed;
	bh=8NmCfPxQCsjXlhHweqCgEOMd2Q/3f+CxRrkhfbkKwuM=;
	h=DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding; b=nwsw58wZVc5O7di6SqhOr8B/vagrYyeDSpdJBTAJjetWsbELdclNrhBkO0FKzGqIuPqqTedcMTTAZxWTUm7h3HC0Ow7JerXma/sFEs1SmDXXCqffOUd1MKYZX6PPB5DRnCW5gkhKd7XCbLSYL8jnjgJDp1c+YzrZXXAb3+wNqi8=
ARC-Authentication-Results: i=1; www.redadmin.org
DKIM-Filter: OpenDKIM Filter v2.11.0 www.redadmin.org 07AAC10A0ECCF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redadmin.org;
	s=20231208space; t=1766488274;
	bh=8NmCfPxQCsjXlhHweqCgEOMd2Q/3f+CxRrkhfbkKwuM=;
	h=From:To:Cc:Subject:Date:From;
	b=VYxPL5bggoM5Z3iaWrh5XHpb6TJwhtNlvEA06GTfTJVfu9etgS7VESHSu/FcO6/H4
	 HpGbemdedJH8HwvPNtphRpIgtEFt2afC3DUd0uC3RITk8jxhQYXAXi3zgg11iE0uLI
	 Xa5ye62n9EFVnhtLcI/SCZmQ3danOKl1qj+2zxqk=
From: Akiyoshi Kurita <weibu@redadmin.org>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	Akiyoshi Kurita <weibu@redadmin.org>
Subject: [PATCH] dm-raid: fix typo in documentation
Date: Tue, 23 Dec 2025 20:11:12 +0900
Message-ID: <20251223111112.2578336-1-weibu@redadmin.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
---
 Documentation/admin-guide/device-mapper/dm-raid.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-raid.rst b/Document=
ation/admin-guide/device-mapper/dm-raid.rst
index e11f10764770..3780f6e6b6bb 100644
--- a/Documentation/admin-guide/device-mapper/dm-raid.rst
+++ b/Documentation/admin-guide/device-mapper/dm-raid.rst
@@ -433,7 +433,7 @@ Table line examples:
   8192 1960886272 linear 8:0 0 2048 # previous data segment
=20
 # Mapping table for e.g. raid5_rs reshape causing the size of the raid dev=
ice to double-fold once the reshape finishes.
-# Check the status output (e.g. "dmsetup status $RaidDev") for progess.
+# Check the status output (e.g. "dmsetup status $RaidDev") for progress.
=20
   0 $((2 * 1960886272)) raid raid5 7 0 region_size 2048 data_offset 8192 d=
elta_disk 1 2 /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3
=20
--=20
2.47.3

