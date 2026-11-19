Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795068876;
	b=h7uJaVWGIW2CaPQhY2Cd83jvn/4m3uR6eJgOeWVO6xY+qhvvLoU9LBBBjcgcmlQJX/Ys
	 Vbn885xksDIytuEcS+OGArqeBhDBJkD3r02+lzbUglWNLVBfRk3LTBnBYWpUCHOrYZMhy
	 Z3C2UVyqP3SOw/hPtVbKKuNwNDFMa1PFNv1N8B7ONDJZcEZaRklEozI9+r+sBrlonAqLL
	 UvyqhxJQJjviFkIt0vtZ1GTqZ0XzX41omMusJ7er3oBhDiDG4BZxWJWuBbpa44Htpz1K0
	 wC4o00vvGJ9wf75FHPwicjlBwrRP//PcaCwQDbPxHlgD1gNWgBOrgGDck9exKenXOTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068876;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uyNcIWU98Z5sXldk3rimj6Mr8PsEsaCViQ4vLgBGmJw=;
	b=HV4GaT3rvomRbG8WAMx/2lx0WwUwFb+DIMT5/u8V1Z9hgtwqT89xiVDgTQiQSlnA2pqB
	 Vbt1ATNRe1O+6CBFmaUJFP1skK2f80AOGuvPO8nJCQj7eu9C0ylD1cKxAwa2Uq7rO6j/+
	 BebYXQbg5QGyz1lKzHVAf/1iSmt7oqfngzWy0sQkWqF1iRmYMB7uDWGSPp0JNUu5hO+Rk
	 MVNCPA1LiDPZaERoEVvDJmZ2bmC3UYywEFBwrtf6XtFL80tRBPUcdIp4bq2q5mfVvlzlS
	 CpN61rV6rg3ZOEG5LineHUcOi/YhFvxg8LOgahJgVc73JYfcc6eiulcMHgonP+ug+jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="hPwN/lA7";
	arc=none smtp.remote-ip=91.218.175.227
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE3B606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 06:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFE3B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hPwN/lA7
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GA8YRDDsX8w23iFpR9GtsbDqe3i45tsbQcbqUbsfOKM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795068873; v=1; x=1795673673;
 b=hPwN/lA7cwV/TyubzqX4Kt0ZBTSjwvSvAMdr/GKewP6kQ2VP56fIeS7GFCzkL3B58v2NlPhL
 pp+m/0OBFrUCjuZl3Tbl+iNbn+Boz4Uam95Q0gYKmIY0z4HXXtrbo+9dItZpk7q7nxNWLcJrijm
 WsfEKIvenbwOhfLova7bXg8A=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id baff99afe0cb7e01;
	Thu, 19 Nov 2026 06:14:33 +0000
X-Mizu-Trace-ID: baff99afe0cb7e01
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm thin: free thins with kfree_rcu() instead of waiting in thin_dtr()
Date: Thu, 19 Nov 2026 01:14:27 -0500
Message-ID: <20261119061427.1452945-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119051620.507189-1-bmarzins@redhat.com>
References: <20261116-bug-dm-thin-rcu-gp-v1-2-14ed3567da3e@linux.dev> <20261119051620.507189-1-bmarzins@redhat.com>
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

On Thu, Nov 19, 2026 at 12:16:20AM -0500, Benjamin Marzinski wrote:
> Qiliang, does this version work for you? Could you rerun the timing?

It works. I applied it on top of mainline 63fdb511c27af plus v2 1/3, the
thin_ctr() patch, with a test-only 3 s msleep() added to the pool worker
after each thin it walks. Thins 1 and 2 of a three-thin pool are
suspended and then removed while the worker holds thin 1:

- With your patch, KASAN reports nothing in 5 of 5 trials.
- With v2 1/3 alone, the guest crashes on the first trial; earlier
  runs of the same test reported a slab-use-after-free in
  get_next_thin() in 3 of 3.

A 300 s run of thins being created and removed while the worker walks
the list, on the same KASAN and lockdep kernel, logged no kernel errors.

Removing 100 thin devices of an idle pool with dmsetup remove takes per
device (same boot, mean of five rounds, min-max of the rounds in
parentheses). All kernels are mainline 63fdb511c27af with the patches
listed; the change is against "v2 1/3", the thin_ctr() patch alone:

  patches on top of mainline           remove (ms)        change
  none                                 17.0 (16.6-17.6)
  v2 1/3                               16.8 (16.5-17.1)
  v2 1/3 + your [PATCH v2]             13.9 (13.1-14.6)     -17%
  v2 1/3, 2/3 and 3/3                  14.1 (13.7-14.4)     -16%

Thanks,
Qiliang
