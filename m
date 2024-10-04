Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9B61FCC46;
	Fri,  4 Oct 2024 18:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066237; cv=none; b=flM6zWZMIWmC9OKwHA/WsKebphJlHrWZahn+Rph66yohVMsTWnKw8FrKcZpEj3vo/49dTV5rgPqbUhzOCVm+mb7wR2NFPv9GaP3gcgXkkdeWvKR7pQ6Dy28CA1vTSvgMtOGCFApUY5G90gWpGJax0boX18I37YI43grc2x9QbcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066237; c=relaxed/simple;
	bh=Efcfh40coe8lTYot+luTmyVmHaIjn/egYX0OcqlC44c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzdCyg+5jJSuw2vELj8FvpJraRLh06KOp7X9MniMf+XyCIeMiqX+q7cO7yEZznevRHTdnvexJZFMTvULR00PT24IqfpgLzQZgvy8Ni9bEDqkgXVvqYfgTp9xUjACGgR7HgPBKu/MbAZk0Cl7NwBKXUDNvwJin32oS6u7k6MKTOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWT2v7uB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWT2v7uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F336CC4CECE;
	Fri,  4 Oct 2024 18:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066236;
	bh=Efcfh40coe8lTYot+luTmyVmHaIjn/egYX0OcqlC44c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWT2v7uBRExG7bEW6MEbjfykQfoabjSH0/1qumcd0Ec0ozk0SjN+b2Mpdj3p7Gjn7
	 oJdy89X5X1akvJ/leLORJnR8l56N9aE0Ri+bHLEX7VryYRZ5rmdgBVL28MR51VrOwB
	 STgMKM02/D1OQg6rdx3DiyaWQ5DclDDmmXgOkChgbubUxEOrgV3p7qvwBlvk8ns9fD
	 2UOhlEumxGyydscJsFqb+We+QDEY8eeX4D5NfdxuE7us107rUKyyTSlQqAZf6uVhPK
	 ATKIKhTOaIibtLAhNjbUbZSIhvmC6GEOCqBO6IWUzHbaxQBND76uh4VxOmHjhaXwah
	 1uknenjZpjj2A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.10 59/70] dm vdo: don't refer to dedupe_context after releasing it
Date: Fri,  4 Oct 2024 14:20:57 -0400
Message-ID: <20241004182200.3670903-59-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182200.3670903-1-sashal@kernel.org>
References: <20241004182200.3670903-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.13
Content-Transfer-Encoding: 8bit

From: Ken Raeburn <raeburn@redhat.com>

[ Upstream commit 0808ebf2f80b962e75741a41ced372a7116f1e26 ]

Clear the dedupe_context pointer in a data_vio whenever ownership of
the context is lost, so that vdo can't examine it accidentally.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/dedupe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 117266e1b3ae1..28b41d5261f4c 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -734,6 +734,7 @@ static void process_update_result(struct data_vio *agent)
 	    !change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE))
 		return;
 
+	agent->dedupe_context = NULL;
 	release_context(context);
 }
 
@@ -1653,6 +1654,7 @@ static void process_query_result(struct data_vio *agent)
 
 	if (change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE)) {
 		agent->is_duplicate = decode_uds_advice(context);
+		agent->dedupe_context = NULL;
 		release_context(context);
 	}
 }
@@ -2326,6 +2328,7 @@ static void timeout_index_operations_callback(struct vdo_completion *completion)
 		 * send its requestor on its way.
 		 */
 		list_del_init(&context->list_entry);
+		context->requestor->dedupe_context = NULL;
 		continue_data_vio(context->requestor);
 		timed_out++;
 	}
-- 
2.43.0

