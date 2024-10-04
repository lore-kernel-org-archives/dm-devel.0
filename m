Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6011E96F2;
	Fri,  4 Oct 2024 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066034; cv=none; b=J7fM4bhyLCBGamku9YgtWrCZEpZ6/BhUnhxkrt1Qb+8N4VmYi2govKhxnjGM5Syu2H4hBWwszbxmRRl6NJnOITZAdcTAMPbSf5WfRKniK8IQrcO47JX1Jujhtj/3dZVoasXrTFF5aHLDxeojt83LjVWAAu99/ZqxF0PTtBkNKmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066034; c=relaxed/simple;
	bh=vvhWvb4c9e9c/D6XuT9QWZB4VOqVh+V14u4C5Nc21QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGHlMiCafhR22aDMY2VwftmRjqrTxJiuH+4WqDcmQSV7TrTo+lAmmQ9Vdt3dqg0El7IwL4gCtZf2hdUuGgKSmagdOKUKMri2ILeXr/g8wjsVE3KnPg9qRLAT02aMiRksOymIQo5jFI4wEcwDdiJrt+YbhVRIsoZuY6slViV2F5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qx5XTd35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qx5XTd35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8531AC4CED3;
	Fri,  4 Oct 2024 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066034;
	bh=vvhWvb4c9e9c/D6XuT9QWZB4VOqVh+V14u4C5Nc21QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qx5XTd35xzE3DlgJZJR7IxxlSwZcfjCjwa98K35yzIflFdhOLDfDzWPJjpbRTtX5B
	 dAP2a6d5zTCAlIlqVdonISro108AzLs+NQvVCiSs7zpPbvcGEkMjjkklGMhJyzBR2Y
	 Uy5R9gHc3LiVgLgeiR09BAEaMwJpkgCFgBuuGEaq6kIN3QJCdsQnBVFSH899/7ECg0
	 j061dsJR86OImGRDodNgH8TgKS/K2g6ia37e+Y8Tgc7FY/zJRfoh0Uyko4BcDmKeZA
	 uZxq2b0BvcDPF2+Dbtt7ghzq7GpQAkjVq5raMTnMCNBDuBSMGohkvze5Rrp2WjjngT
	 /EOdEWtW9b7CQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.11 65/76] dm vdo: don't refer to dedupe_context after releasing it
Date: Fri,  4 Oct 2024 14:17:22 -0400
Message-ID: <20241004181828.3669209-65-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
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
index 39ac68614419f..80628ae93fbac 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -729,6 +729,7 @@ static void process_update_result(struct data_vio *agent)
 	    !change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE))
 		return;
 
+	agent->dedupe_context = NULL;
 	release_context(context);
 }
 
@@ -1648,6 +1649,7 @@ static void process_query_result(struct data_vio *agent)
 
 	if (change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE)) {
 		agent->is_duplicate = decode_uds_advice(context);
+		agent->dedupe_context = NULL;
 		release_context(context);
 	}
 }
@@ -2321,6 +2323,7 @@ static void timeout_index_operations_callback(struct vdo_completion *completion)
 		 * send its requestor on its way.
 		 */
 		list_del_init(&context->list_entry);
+		context->requestor->dedupe_context = NULL;
 		continue_data_vio(context->requestor);
 		timed_out++;
 	}
-- 
2.43.0

