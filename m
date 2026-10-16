Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3AB375F65;
	Fri, 16 Oct 2026 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170142; cv=none; b=aeobRE0MzNNOPtwA69YE9wNyMF4ImoBWt1BhxDiESg4IGbG66EIc+CVZePQ5cdh5maxGzuQO9vV2XuXLdJe3iPzbzTssj8EuQ2N+3VWk02SdIjCoaVw2mZFrw9l93UQ4MAoSn/Zk3TN3EiAI8ZP4DoH+gP9JAfZRrtvOq50Qu4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170142; c=relaxed/simple;
	bh=W7EseiSt1ps+E1Jl0PKHdBXUYTRgpbff7qJM0rGJQQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JxQloB0QrAYo1ojVgMoCi+MPJLkQc/KPxXP2pzTHrQbGYZgTPdUEITv6ys+1xdRkf1ceaNJ7wMGWH9Hb0SrGyE2F6ecQnt8qisZy6dpu91o9xUMrWyAwZzTAHRd1WlzCU8Hd8kPw7Gm4txivdzCTKR1RCs7wHyJkwhwZUP5m4so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVzrc/el; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVzrc/el"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF58A1F000C6;
	Fri, 16 Oct 2026 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792170140;
	bh=TBXnO29IbsUDKrOKpJ6ldm17tt2H5HZmjTgZTjAVdaE=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=RVzrc/elOcpjPUPoIe8mVDBtPAyjKN3NlvoVr+KTccBOybMGqvLHEqUy+pBCp5ht2
	 wheoWUn7mRYSmjmV3poYZtomrSG0SKlNtLW+POrmxPMsoB5JlUIYPwyx2ZndS6ijub
	 BhXzsx1f5asBdiFnBnxWi8p6NFrPAJxQQDGCI2AEIPa1v0XtOP92vQqkch5iMCF0f4
	 eCtkpZulEe0tW2FJx14xzeW2hbFK2XeWWM7kSLgWQjFLd9PNv2pQRQ7hrpHlkpzJM6
	 qdAUQmPb71ikifSZQz9as+0/kgDx9Svybsp9VuCf3Wct+co0DUqVNeOrlnrqBLgarI
	 SX5uwoLxm+ocg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity: fix buffer overflow in FEC calculation" has been added to the 6.12-stable tree
Date: Fri, 16 Oct 2026 13:02:18 -0400
Message-ID: <20261016170218.3965554-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm-verity: fix buffer overflow in FEC calculation

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-fix-buffer-overflow-in-fec-calculation.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 411c76502f137eb1efc843e35d996e42eaa3db37
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Jul 1 18:13:50 2026 +0200

    dm-verity: fix buffer overflow in FEC calculation
    
    [ Upstream commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e ]
    
    There's a buffer overflow in dm-verity-fec:
    
    if (neras && *neras <= v->fec->roots)
            fio->erasures[(*neras)++] = i;
    
    This allows *neras to reach roots + 1 (the post-increment pushes it past
    roots). This value is then passed as no_eras to decode_rs8(). Inside the
    RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
    polynomial loop writes lambda[j] where j can reach nroots + 1 — one
    element past the end of lambda[] (which is sized nroots + 1, valid
    indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
    the syndrome buffer.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Assisted-by: Claude:claude-opus-4-6
    Cc: stable@vger.kernel.org
    Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
    Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 56813d02d5465..b6115ac9c8256 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -263,7 +263,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -281,7 +281,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
