Received: from zebra.cherry.relay.mailchannels.net (zebra.cherry.relay.mailchannels.net [23.83.223.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6779190477
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.195
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736293384; cv=pass; b=Q8if+0uLMFpeXShD1EorvUnwR6/vbmIsdACbSsvreGcmy/O5NF3UTE4e55RUG1rmJbA5ruPUr/AsJRP5iw0wjnTH4npduk+r7Q7n6RASGTkHMAHbVjOM8Whi6TEffJ7GI80y5jc04F6cBs/+RUZ+EPhrq25CUyRcsMizYo7LdSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736293384; c=relaxed/simple;
	bh=AKR6yQeMyI8pWEpUFghgsTPbpfw9L2AJnsqxVhL8/OA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OxMh9NqQVsUMAhtUGPo8a6cKkQ9uTxKq8WSuoTaYq0jsp0A9i5YSmpXdlN6BLXiQWYpQ9nvMW0Ldw67tS+Q21tja0YF84ebxkDKhoUfR0j3hPLke9cyhU+3QW+TPPtxjxgSPX6NkwKc6c3/Ex66zetjg1KhtsJhiXPdL/IRvjKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=OfKuSlg0; arc=pass smtp.client-ip=23.83.223.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="OfKuSlg0"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 81FD341FF7
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 23:25:00 +0000 (UTC)
Received: from pdx1-sub0-mail-a237.dreamhost.com (100-109-211-86.trex-nlb.outbound.svc.cluster.local [100.109.211.86])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2764642884
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 23:25:00 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1736292300; a=rsa-sha256;
	cv=none;
	b=e+lAVxnGqs9ekmkjaPBatcgvOrkJEVJr96DViN+cQAJQuFFDpLHytOCb+7fFf9nQRPPXBw
	QvEjkTBrbXTMcIBFFZpREoTxQh5OkqrhoGN29LC6+W/AC15Qn5RURaZVZ0afkCYzXogV4r
	gJfasHKLE4UXC/DWshYG04U6SNbngymxt8Rl6NII7V6tk16RN++rPbJspY0khTB7nAoGE9
	1iMquDBtAktzJk2Po1QlhMAwwi0jdpr2JfwNJBssAs1q4fFvVCv/42WLg9rP1W7JtYMy6V
	4Kf6AFeqauJ+ll+dA7dOald+SY4eoqscjmA4coGqZbuwJcih8HMHQ5XedJs3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1736292300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=FxI2Q15fIgwBOljl7Gtjuk5GSVlrgvaKmN7g/bRNT84=;
	b=poG1rPX3SnuBJcnGAjTmqoCS847WcevQM5XYDyctgYDJoRm/QSZYbp9M8AlVW6jmv5G/Qb
	/EMRvb/V9pCSsQ/3eWq1904rJCUdb3oddh9N8aNP1Art1DQt+OiLcjEczvbxWSKUy1oQKj
	fx3uUp3DukEKOB/OYNSM+n/qnjESpsAzJa2JcVfsUbY9qkk/h5It8Em/qL/V5CYzlYTsw5
	QDx4RtfOvF6/VOLzDEsbVTCdmQehlCa9fSO3Hgca73JKVMgYBn5p8Nuqojyh8ToQ0oMQqG
	wvhk00CfWZ/pCAGUsxpBGYxh9QDHwoazG5x0sl3boP4MQQ61r01ShV/2js1YiQ==
ARC-Authentication-Results: i=1;
	rspamd-b5645c5d4-8h4qh;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Interest-Blushing: 51380db555606b5e_1736292300382_1714335504
X-MC-Loop-Signature: 1736292300381:3817017066
X-MC-Ingress-Time: 1736292300381
Received: from pdx1-sub0-mail-a237.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.211.86 (trex/7.0.2);
	Tue, 07 Jan 2025 23:25:00 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a237.dreamhost.com (Postfix) with ESMTPSA id 4YSRwW6lfXzxx
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 15:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1736292300;
	bh=FxI2Q15fIgwBOljl7Gtjuk5GSVlrgvaKmN7g/bRNT84=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=OfKuSlg0U7zIYdxlyH2a4XtKq+6Btvu0J1hDzToqLEspoOPw3QaMw0s+eR6OR9RAX
	 v3qL3fpFw+m5jBkaS7SHi81VqNwdwcj+aU0PeJLiwd6tFlhG1FbFQd2DExbQjpOBIX
	 fr3kX3+LUzzheZ1Q02UOSYMHcxoywiXykjnkaNR+A//HWyrH0xOW1DgDmrXH1Uvknd
	 GyPhUvbRjBIgTPi1CpvScwQ3XSfoWrBVNue0Wdp0xShYLbOTqjiwoq4UpEN6wNenRW
	 UnsWE2Ka+8iJAaNMvE8LbqEWnLGjmQBaikBjAhapDYZ6ZgsIv9Q+X4HD/33uqeB7ul
	 BdtI4a8jXTsjQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0378
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Tue, 07 Jan 2025 15:24:58 -0800
Date: Tue, 7 Jan 2025 15:24:58 -0800
From: Krister Johansen <kjlx@templeofstupid.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, David Reaver <me@davidreaver.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] dm thin: make get_first_thin use rcu-safe list first function
Message-ID: <20250107232458.GA1860@templeofstupid.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The documentation in rculist.h explains the absence of list_empty_rcu()
and cautions programmers against relying on a list_empty() ->
list_first() sequence in RCU safe code.  This is because each of these
functions performs its own READ_ONCE() of the list head.  This can lead
to a situation where the list_empty() sees a valid list entry, but the
subsequent list_first() sees a different view of list head state after a
modification.

In the case of dm-thin, this author had a production box crash from a GP
fault in the process_deferred_bios path.  This function saw a valid list
head in get_first_thin() but when it subsequently dereferenced that and
turned it into a thin_c, it got the inside of the struct pool, since the
list was now empty and referring to itself.  The kernel on which this
occurred printed both a warning about a refcount_t being saturated, and
a UBSAN error for an out-of-bounds cpuid access in the queued spinlock,
prior to the fault itself.  When the resulting kdump was examined, it
was possible to see another thread patiently waiting in thin_dtr's
synchronize_rcu.

The thin_dtr call managed to pull the thin_c out of the active thins
list (and have it be the last entry in the active_thins list) at just
the wrong moment which lead to this crash.

Fortunately, the fix here is straight forward.  Switch get_first_thin()
function to use list_first_or_null_rcu() which performs just a single
READ_ONCE() and returns NULL if the list is already empty.

This was run against the devicemapper test suite's thin-provisioning
suites for delete and suspend and no regressions were observed.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Fixes: b10ebd34ccca ("dm thin: fix rcu_read_lock being held in code that can sleep")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bf0f9dddd146..05cf4e3f2bbe 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2332,10 +2332,9 @@ static struct thin_c *get_first_thin(struct pool *pool)
 	struct thin_c *tc = NULL;
 
 	rcu_read_lock();
-	if (!list_empty(&pool->active_thins)) {
-		tc = list_entry_rcu(pool->active_thins.next, struct thin_c, list);
+	tc = list_first_or_null_rcu(&pool->active_thins, struct thin_c, list);
+	if (tc)
 		thin_get(tc);
-	}
 	rcu_read_unlock();
 
 	return tc;
-- 
2.25.1

