Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDAD5F869;
	Wed, 27 Mar 2024 11:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538923; cv=none; b=T6bqmtTV6VJmbrL0jRaPSnR91Wg6qrvWKMLAqp66L6vVQNuUr6QHYmIJNwTssElUcExV8gol9kwqxmcgn7d2Ur6Z/3ZFCI3N4FkiVW/tQE005uYgewD9ZfPRe/Biges/3ZO0QXCAvPX+OLW9r7N/fFoVUlBEHx6UI/I+cJgLo0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538923; c=relaxed/simple;
	bh=oK2WNGk3bL7/M5b66hzamH9aEeU3/7BOwNC5Zg8F9Is=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E8V0Ldh95hbVQXdTcgLWCNo+NGnxDIGcYYx43XerzSvQYPoXvGtb8Fr+uemr8Bh2iFvVCa1plP9WYAdI1ERLNe8R6YJDfP/Uwt+c8JYWmrF01tXZcKbDtOqDE/oekGjxutJ+m9Az9rXtJljNXfPyjjvy4wIrPrWZcZ8aCsJxhY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3dlSiPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3dlSiPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181DAC433F1;
	Wed, 27 Mar 2024 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711538923;
	bh=oK2WNGk3bL7/M5b66hzamH9aEeU3/7BOwNC5Zg8F9Is=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=l3dlSiPBGTgrJ91rQF0FhhJfjE2XjBVFC3uBt4foKs1Syowgxa1ocDOzwj6IUyIw8
	 hLduWY1GkOiJA14lX/kNspRjgjTJwi1icaQ+Y5cdFmq1vXhEgvP11EhgPrluj3q4Fc
	 79quKLxoxXnPTGVXuze4MKeE8ifr9x/6L7Y9j0/n8BO/QVJ50bCytQ9Tz73L+C7P84
	 V+SQnLSopdnPeo7Ne6JbyUWInZDEM2IGrJUpRgJUJ9HEu5Vv/GvcB8EnPjN+oAOlBp
	 K3Pg+woDy38iDf0gLMiQFvBnCxoz9seJZF5zTxqmSCVBF4vsqT5DLX1nn4An9Aqbsa
	 inviKrKpy53nQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm snapshot: fix lockup in dm_exception_table_exit" has been added to the 6.7-stable tree
Date: Wed, 27 Mar 2024 07:28:42 -0400
Message-ID: <20240327112842.2790561-1-sashal@kernel.org>
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

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-snapshot-fix-lockup-in-dm_exception_table_exit.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 4efed027117efdd074872bef8ccf1c42786b2582
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
index bf7a574499a34..0ace06d1bee38 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -684,8 +684,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);
