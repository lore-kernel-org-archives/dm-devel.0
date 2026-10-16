Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB8B599A3A;
	Fri, 16 Oct 2026 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173294; cv=none; b=O3BvTE9+zBDZJwmitWq51H0T2O5wl5flt99qTonU19utq3E8HK+BtmTIeptI1AHwNiQ3dBj53VcvuTlq2veGaZWTz2IXNerkLaVKipXfYqpr6zVz/C+gtkBM980VWq3JN+WmUdfi77wkVwPLDVxgYt0fd7kORa4n9dMFSnhBiWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173294; c=relaxed/simple;
	bh=Lr8HXziPZ7yxR7YsZWnN3Cnue8HJNbaRoribQsPn5G8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fqt1OXf9gMu69/wcz1mudGW1IydwSGy8ds0vZLaIC+szkeQ3bSAqLXMhXsE8QFih1nVaQB8NLc0RbJJdRgwyRzTMC/kVhtLbNjBZ5ea+fwMyV5AGNl++2ti6iHsJ9acZr4H/AUq2w6032yujMtPf7KNZuiOhLQ1BCzE5j6CjL3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLmAdbG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLmAdbG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4FB1F000C6;
	Fri, 16 Oct 2026 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792173293;
	bh=D/sWnBA2bYWhU+JV991uDV1oonDiGJkB2qsJ0VAfRvs=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=kLmAdbG/BKPeIVpfZ28dStTcQ5Cav+UXYp4MgPfoFmPqk5jG4QAX6fhoKUdZB0t1Q
	 1avgWL2ocgSjmE1ZIelqVqUd18oMoZcH7T0eCWAJjn2jhZceuUI/62M8DocUShs6aZ
	 0eigmBy/Ag+oxRL5gMgd7KvjZXl4jiGvWyMkdH5Lf9Sqozp+wVhmwnZYQOfpqtoa7E
	 7b8HLb4PpsGAA34TjdYqgU6cKVkR+2lzOirKj6e3/N5DxLTA2U046SPRiW9KxUZtDQ
	 m9duBrUfjUD+FCHXiub9nV9Eihr7DYOqDSSzYROJSJnPNirGlR7ocZG2iuRkJdveJo
	 3ukNWnv3vTjMA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity: fix buffer overflow in FEC calculation" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 13:54:51 -0400
Message-ID: <20261016175451.4040151-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-fix-buffer-overflow-in-fec-calculation.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e7a3e9c3804cc846b6a9b7303d74dd9a6da1c8f5
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
index 5073c93cf962c..a9e3d44980862 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -261,7 +261,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -279,7 +279,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
