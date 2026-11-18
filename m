Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999767;
	b=3cOptVxYmHRpYpw2RQ8AhcRZr/t9boQNCU8+KFJAHe52OmJKvypcstV3cNIefchjd3Gu
	 eOP2lX/zdetRFkdXxtk51kQSGo8lpHuJmXQQGdBJFLN1myqLEaAM62TcJOtv9xfr6RWxz
	 EBopWjCWzgFBxEEYeBlnF9GL9Pl11/yNUul+i6s4dT4M0pChrAaQM4YxrtkJ47MD1/0cR
	 LFmJSdCY99fAAj/ZQTvYNH3839dfBWXhbfCs3ghav9TEdqg8ax4saLEXgrFYjcDgtHpYL
	 ipVRJOh7Km5JnkVoomSMmy/ratEYlh6EvceDfcvPI6Yk2Tgcf68ljHMk+NVxTBAKQ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SqV4Jv6wNfUGVd/YP57RFpsT3eJh+v6vOgo/2e6RqII=;
	b=y17Pw40BDc0SwB6G1alSLSDc2wjHw/fDrnwsyzeMVTLLB2A5RpP28Hnd3dD/LF1lxCsJ
	 iS2Ta4jPRxfGK1wYpq5eeG/CBPNLyJV8QIlE6d7x092Mmf3PBiCL9yhi+UVb4vbwfVGLw
	 +dEig9e6kKJRRk+jcBe/Y2D7gn41bIIS5A8KvjA6rH95CIRxRwWdZDLiVcK2JeCY0LYmV
	 n1cvcVBfPjxD2cs9KbGqv+mRZMFvtVlc1fifgbYZyWXhgRE0cILX9dfpqv5bEePHWqIg5
	 r09g/7tA9Z/PwDy3JjRGNoUl0iP2kmVj96CnOKw70vKn6DwMA2m2zcvwbzECRL6DvGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=VWUMt6pG;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9502B60A2603
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 11:02:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9502B60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=VWUMt6pG
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso5640995e9.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 03:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1794999765; x=1795604565; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SqV4Jv6wNfUGVd/YP57RFpsT3eJh+v6vOgo/2e6RqII=;
        b=VWUMt6pGG5PBGaprNo3TTAf2uB7wOOPm8mMIB/ZB9OqknFD4UTQba4TMzlOaf1J89T
         FF88ZVUWSuhIIByo3WoxN2lW1qWyX+lWxSnLH1SZFSWoAeibIPIQRL36jOlW03lIgijx
         Wioico+p9yh8zeeK0tq6LoTbaGxdzL+nF2zWLML2PLeA3GH+nSTfR1h3QN2nf1cRi0oK
         KI5TNI12oivMlhT6bBcaeUC35mZFTX5SOkO+oJciceOr8QZiSFRD4OyQrFseQuxijO9d
         xOvit7PDAFIeOfzVsRkNePF+pY9V8T+DP30C/hVQBWkFepHK/xSbgveM5bGh61i4KDR5
         dF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794999765; x=1795604565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SqV4Jv6wNfUGVd/YP57RFpsT3eJh+v6vOgo/2e6RqII=;
        b=afTLJYM45eK4h6ilzSb++CQkUM9hlLkhBEPJ+dl6urS9AVyf9QXPBR/mjk4Iw5a2bX
         iUHPLxTufS8xAm7C7YK6kcLsoX8v6a8UNJBi2346F5gRvBXjFifKVWVRDF/tf+Qmy6FE
         a2fcmu6OsMoEv8bCmvrK3uNTPQXahh3ae7RyUSP+1Vt/cwRdp8GRcNXC4A2BUqUzgb+h
         FkZ/KhYayDPQuV+6jyZcnpWs/hPqWtwBSu7UgIkBujdRUVbRpCO9Z/APYj6Hh23wASzQ
         oVA+fTc7XYMNEOcLwa9Sjq/JKjgwMYqkm0Wz5THPPWgTf6aUZT2Jr6FxQg3My8Lxj+TN
         XLnQ==
X-Forwarded-Encrypted: i=1; AL+hErEfGG3nE3K2c5ge+AU+pDuEs1foKbFKY54bwRYyCN2d2gMyqX2ZOn+MdURqpZKIF2L+8pNHm7TuQg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9RD1rnBfkglI/03eHT8m+TZtt+TeyyaZCxvvvU1De0R86/9AMw
	ym4nKLUu4fOdCYrAvg5XOjcimlnfvUEJkeOfAVMZ2k4g7+oqIcvYPj2fmALW0iojiF8=
X-Gm-Gg: AYBFou2bVtnKj7t6CAHsORC1uFvP3Z9u5E+LitIU+oPxbNO3BqZ7hzj2zGi3N/sQXBF
	OqlC99plM8kMxjwW9yDcs4PTM+y0Ichirez51HGjIDAl/yZIqN2UoTRi1bS5lNLHchcBe44P68a
	QHspZTS1Oh16H6RmTxnqQSWR+mTVlrGU9a1XqfUkHIfQlb/XRaFGm4rrh0K9ut1Hbd0NSK869p1
	SNzwHMEAVs2aRZRK3H0pWYob8eU9Y4C1zYhN7/d3mex3HjbdrWSWAdLdyZr3eyFosLKJRxn3NOq
	bVvJEeTr8S5re4OBr45l6Dw441823X467n4LeZqof2umd+gSu9pr72eH73I8RlTp/tDWIEZ6oQF
	VfUQkNsMfT42KzJDqzaAbKlW1fE6KT68f38BzDW9sYXLSRZDtimCGi3jbenbrn0s22Ho6xykL1s
	jlZaQSrRkKruJIJVJWUxdf/m59ioSsJQZtC10VNGxPNBqd9TtL+NzIUart8szV1fwxoknkuvLBx
	jjpSzoqn0jkb/4PfG6SDDdfZZue/0iBqW5IWiMCLzW6lxYoE+ICnT2fMTEdc7mEoYOB3U4hRWkT
	JHSqhXWyClXwXohGuQJV8Xmzk7wW
X-Received: by 2002:a05:600c:3b8b:b0:4a2:526b:d410 with SMTP id 5b1f17b1804b1-4bb7da1b581mr53254625e9.13.1794999764776;
        Wed, 18 Nov 2026 03:02:44 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8c09:3cc3:6efa:ac1f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c1145esm3943277f8f.52.2026.11.18.03.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:02:44 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH 2/3] dm era: refuse metadata rpcs once the target is suspended
Date: Wed, 18 Nov 2026 12:02:38 +0100
Message-ID: <20261118110239.2910290-3-den@openvz.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261118110239.2910290-1-den@openvz.org>
References: <20261118110239.2910290-1-den@openvz.org>
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

From: Denis V. Lunev <den@openvz.org>

An rpc reaches the worker in two steps: the caller puts it on the rpc
list, then wake_worker() queues the work unless the target is
suspended. stop_worker() raises that flag and drains the workqueue with
no ordering against either step, so an rpc can land on both sides of
the drain.

An rpc queued before the flag is raised, whose wake_worker() runs after
it, is never served. The caller waits for a completion that only the
next resume can deliver, and it waits holding the table srcu, so a
reload blocks in dm_swap_table() and the device can no longer be
reloaded or removed.

An rpc whose wake_worker() read the flag as clear can instead queue the
work after drain_workqueue() has returned. The worker then commits the
metadata beside the commit era_postsuspend() runs in its own thread.
Both commits allocate from the same space map and take the same block,
which corrupts it, and every commit after that fails:

  device-mapper: space map common: unable to decrement block
  device-mapper: era: metadata_commit: pre commit failed

Add the rpc and queue the work under the rpc lock, take that lock to
raise the flag, and refuse an rpc that arrives once it is raised. An
rpc that made it onto the list is then queued before the drain waits
for it.

Userspace sees one change. A status query on a suspended era device
used to block until the device was resumed, and now reports the target
in error.

Fixes: eec40579d848 ("dm: add era target")
Cc: stable@vger.kernel.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/md/dm-era-target.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ea499adca4ce..29b0602e7849 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1389,10 +1389,14 @@ static int perform_rpc(struct era *era, struct rpc *rpc)
 	init_completion(&rpc->complete);
 
 	spin_lock(&era->rpc_lock);
+	if (atomic_read(&era->suspended)) {
+		spin_unlock(&era->rpc_lock);
+		return -EBUSY;
+	}
 	list_add(&rpc->list, &era->rpc_calls);
+	queue_work(era->wq, &era->worker);
 	spin_unlock(&era->rpc_lock);
 
-	wake_worker(era);
 	wait_for_completion(&rpc->complete);
 
 	return rpc->result;
@@ -1427,7 +1431,10 @@ static void start_worker(struct era *era)
 
 static void stop_worker(struct era *era)
 {
+	spin_lock(&era->rpc_lock);
 	atomic_set(&era->suspended, 1);
+	spin_unlock(&era->rpc_lock);
+
 	drain_workqueue(era->wq);
 }
 
-- 
2.55.0

