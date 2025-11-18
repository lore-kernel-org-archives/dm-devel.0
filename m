Received: from mail-m16.yeah.net (mail-m16.yeah.net [1.95.21.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48B9366561
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=1.95.21.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763480780; cv=none; b=tdRWwI9BSA/U99841PUJLhBTUMH5BdozYFlJ2mwhHWBBidNKNNn/EMrGph+99ZWqgqGW0Crt5DEgvyCmXHkBXMJck55Hkt2RPFIGzVKcfkUErqvgo+T0rxuQUjedFJGBO4uX9AEJ6RTo98lAgOH06Dg1X6gcRLU6M+44/1qUA74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763480780; c=relaxed/simple;
	bh=3Th9M0sKkO+y/7+L1BxYuFjBZmhAeLks+ySTS/k9WU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/IFAGSKat10CHiCQO0/+Pd8egcKb2fg2TWjSnn9GMqOsOgnU+VpnCuahg7luqG3EKBZcNMNFUcu+QboJn5rEwN1G2XHRQSTx537J+GsYSOb8FJ9irES4tDEAhDE1NtzGtzkiKo1eIEvoofJDJCF7mlcVl5tdb/2KL4b4/YMoMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=adGNfqTC; arc=none smtp.client-ip=1.95.21.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="adGNfqTC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4V
	caZJrlXgCHaMN5GaIYyAIe1nIjom38ExYw09p+y/o=; b=adGNfqTC8kJLrMuRgL
	C9qw1diDAp6PuArp3ob4N0WgSl82SDN+N9EL8Ki7bj1x6z64NvfMh5kEAdKzfsT2
	VmJzkGPXTQA8gRd2ylbCDHWEqiwoKhJ167Lb2Ti7UZvB7L4lF3mJIcRN6AD/ywRm
	4s5/75q8Txg5PkkaO3M3Ewd54=
Received: from ubuntu.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id M88vCgDXPyqElBxpDGk7Ag--.60695S2;
	Tue, 18 Nov 2025 23:45:44 +0800 (CST)
From: Aiden Ma <jiaheng_ma@yeah.net>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	Aiden Ma <jiaheng_ma@yeah.net>
Subject: [PATCH] dm-verity: correct the name of verify wq
Date: Tue, 18 Nov 2025 23:45:06 +0800
Message-ID: <20251118154506.17647-1-jiaheng_ma@yeah.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:M88vCgDXPyqElBxpDGk7Ag--.60695S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr13try7GrWDAr43Cry5XFb_yoWfWFgEk3
	98Z34xuFWDWry2va45Ar1fCFyIvr1kXFn7ZFZxtrWay39rZryfAryDWrn3WF9ruw4j9ryD
	CFW8KryjkwnFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8MqcUUUUUU==
X-CM-SenderInfo: xmldxv5qjbzto61htxgoqh3/1tbiNAiwx2kclKiVJAAA3z

The name of workqueue verify_wq should be "kverifyd", not "kverityd".

Signed-off-by: Aiden Ma <jiaheng_ma@yeah.net>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 66a00a8ccb39..e8f1300f5f25 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1549,7 +1549,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * will fall-back to using it for error handling (or if the bufio cache
 	 * doesn't have required hashes).
 	 */
-	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+	v->verify_wq = alloc_workqueue("kverifyd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
-- 
2.43.0

