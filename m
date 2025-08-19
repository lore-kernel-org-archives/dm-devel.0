Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB7B2522B4
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 03:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755575050; cv=none; b=ajfWzo3K5VCmLjc/M+ts+sjHQsViD3qgJuTPvw1WvV/svialxTyFXJ9MrqH8WdLbdVUm2zIkQDdLju/sdWBunC7+LKkxa0ro+aeKhUDqUwwBrsERH4hKrTyvpW8IBZAn2aHiktFGC4uzbkiSZK2dUOleJpMUI7W01qvaxfCSXGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755575050; c=relaxed/simple;
	bh=Oo+RjMN5Cn+jJzxlmhNj0PErzbw17xSHc/XcryERHx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ntFCtW9uCFIhW13YuOTCnd/N6HpKsETmvj0JTpictbWp5hjMMGEyTLozT4NsqKemTEiy1vYCHicE5Uc5k4C3xXCo8MT/JQmN5mSnyp7b2lduT4ki/9BRIJNHXph8dy6Zl2Pq5FvU9cYg/4mjBzYMDCo9wkaoNHC8tGKiCObBM2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xFMmOkOm; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xFMmOkOm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755575044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/oVPW1vfg/A5ssTqm2pcPNQ1FScIunlO56ebD05WzJk=;
	b=xFMmOkOmrvXyYveKeyu9m5JBTiDcsL+Ek7i8DTFc59dCEplVCtJnY68rn1wUpWBWZVrnLy
	AT4Z4Xlw4rZFrBrsI4DidPncgC3AcIOY8oQ+aXq75YQHp/tlo6DvD+HOU+x9y7gBiMCk54
	p7JCqMoDhgSRmmyoB+ZDfqDteEx+7Jo=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	dan.carpenter@linaro.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 0/2] dm-pcache: fix warnings found by smatch
Date: Tue, 19 Aug 2025 03:43:18 +0000
Message-ID: <20250819034322.4109073-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Mikulas,
	Please help to apply these two changes into dm-6.18.
It fixes two warnings found by smatch.

Thanx for the report from Dan.

Dongsheng Yang (2):
  dm-pcache: fix uninitialized variable issue found by smatch
  dm-pcache: fix an indenting issue found by smatch

 drivers/md/dm-pcache/cache_req.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.0

