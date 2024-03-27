Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1F1127B4C;
	Wed, 27 Mar 2024 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539787; cv=none; b=fXbTbkHID4dP+R5wgweSFEGJhcGqmkh8eRNR6R3D8/YVwFitz5qyUslgXsOyQTP7kZOMCgtNkf9Xl4bUpz9Qqrl5VofAePMMDBjpihP5wpeTtKfIsJSr79okQi6NmC7vGLlirgbDZEiYO9/+p9sjtSuGJKqMG8isvYSu+dEko5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539787; c=relaxed/simple;
	bh=OMuAAZMyVWQRxOK7mD2Yzg9cdsr1JLcy0lcs9c4WQ1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FC9FqZim5sontbN8SAWu8FRRCdmvIm2kusYZaNsCXpp0q6j4ftcUJy48kAVWv9HLYReb7Xyqk4m4WJaVBawgSV0Pl7qR7Jo0oRXWAeVTjEeaI1wamRL4rS+GHnswn0OetxuRN0KPsG3W3m+snVthrziw+/xKhR9HJn/Ef6cyJc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJ9Rw+q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJ9Rw+q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF83FC433C7;
	Wed, 27 Mar 2024 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711539787;
	bh=OMuAAZMyVWQRxOK7mD2Yzg9cdsr1JLcy0lcs9c4WQ1w=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=iJ9Rw+q569j3GyNtapNEDJ2HQgAcD2yhzaw60tRUNDFktW606YFFayzo+DhQ6c94f
	 5tr4ISCoEQqfb38XFmw6VeFOFnMd/dXNCdxoZtQUjUNOjy2BdhHY81KY/+8Mh+xz3P
	 u7/LGDPwlcejp8qbb+rPpVTGy6ZNwlTcqGkCDAXrKme0eMVTbfZYIrl9v7PYf43rH0
	 Pd9qpeAGoMl62G3lWwB06Vz6qemPB7/TEMSnmCpBJY/kzjodY5lNQ3s3J2v9Pdo6Jp
	 eH3vjVBHRMR89iTUTdbgS6VTbGVAz0C8p3sEcCBgCSOkxwhDO6DhSBuYPuBuBg1O9c
	 j9oF62/s0yHKA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 6.1-stable tree
Date: Wed, 27 Mar 2024 07:43:05 -0400
Message-ID: <20240327114305.2807628-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Reply-To: stable@vger.kernel.org
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm snapshot: fix lockup in dm_exception_table_exit

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 7917bc412a91720d1fcde6e8a51c563f68f603b8
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Mar 20 18:43:11 2024 +0100

    dm snapshot: fix lockup in dm_exception_table_exit
    
    [ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]
    
    There was reported lockup when we exit a snapshot with many exceptions.
    Fix this by adding "cond_resched" to the loop that frees the exceptions.
    
    Reported-by: John Pittman <jpittman@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index b748901a4fb55..1c601508ce0b4 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -679,8 +679,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);
