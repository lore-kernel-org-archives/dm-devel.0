Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347352AD2E
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 07:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619089; cv=none; b=IRZIvAQnmyA2DnPg71QNUg9CM64IcvtTUvFSOTBvZ/pe+mObNg5nMnCVM5LouvmNYpWlvlvdmzWNNLTRv6sOwpgaKlu4yPe0b9+76cVuL9wVO9JQfKE5NkkZLQNB22r2W7eSYTnuCSKmnz9Vy2tHeERkqTz3jJOYQjTaYzWiWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619089; c=relaxed/simple;
	bh=z0jUFR7YilNn9UBTRu26XfYX8Eez+V0dtskk4ByMydY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=EpCllOszFfxmBDQAbC4x0MMAaTqjMSKC3rsALJEdfDD9bN3+cStgq+gj3Lbd8DlsNiJlZFoa4LUdiYA4NmiVy4X1ddYFZbdmSfeyJbjhmNNe9yKLMcx93yx1x419kmv3mzn1Kg5ZiQRfJdxmqhxpd+EfWGh6vOnFyiDkQJ1iJcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=urzmZnkk; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="urzmZnkk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784619074; bh=z0jUFR7YilNn9UBTRu26XfYX8Eez+V0dtskk4ByMydY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urzmZnkk39gqEV2jnkTGY1SUrJavwTWpYfQGxKB+eBBZu26bgbN1uquLJpJh6PWVa
	 j4ZcAeFWQJxmk8sMr1BlD6YR9HBlbqR5eoYJziP2n9Z0ivP0hYCqXxvCcCKUdYIDjv
	 uFWyk11I0yPYyMvwrz4dIvAiTtqeudF6lMkiq5R0=
Received: from localhost.localdomain ([123.53.36.7])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 7CCB1CE6; Tue, 21 Jul 2026 15:31:12 +0800
X-QQ-mid: xmsmtpt1784619072tirnnz1p9
Message-ID: <tencent_F844D870D3F148010BDC4FA4F6CF612B3708@qq.com>
X-QQ-XMAILINFO: Nb9UDqaJEcgHVNjga55OKgsqvCzxlmZ0YyqovMmCvY7yENbxq8VHI8m4+ObBjo
	 sViPesANatr1VNrO0iiTOfAvb1b8DsDZ7k7brwZ4SjdKoxQpS0pb703h3oCwhV/r4IN9/YUTLFC9
	 yHTtc9LVHHZ32T/hRsbcP8X0Ul5RzoFitQRyAhXCxkqyd28ViyGD6dFUtB0LnwKc2HpdiNIjfm71
	 w9JX/xPz1J2xTzHbfk21ljhyJNgCtucctgmky3yCk0to1jt80bQQzW7K30l+jeoPx3aylr7qH9Gp
	 Sux+HrfczzqC885Z0B+QdDJMp36f72A+oleSAKFrpG6gTERdAMdTfm+bCZcaJ0tWPoKfUpaV1eZ6
	 C45JJDlyhvP+81ntLBRFGN7ZZ7kUiebGeuHmlGvLn9xTcS+yqmrJwdBFtw1u9FW09wMAYgz9ka2d
	 XbZp5UxCyUzcVaw8+n50VTHes2cbDWhYWgijG7NU7wzaAohCS9If9czai9gQSLjYrvep/PFvCuoc
	 +I5J1M0fElfL37LaQcdR20jrK6Y/RekjBW3a9/eREwdV54WKcywkbd9QPLtfbUId0Iv+bbyjol2e
	 keraLHvVurxuH+SUiqgEUnwAr4xISDE70IsetMpNuOK3vlC3l6k4kXm4h32FawbmM3ggS+YoyY8v
	 v1bpf5b4oErdrryOCf9HeGwDSyyKrWrfd5BmPeW634Lb6hPetYtg9ccvB3rwWjkC9izE80+Z+kkN
	 KfcKEmUWVDTehI/aUtxabrAiUW+ENEo7p5u1oYeCH4govIWSem9aoeUk+hxKArui7Tm+tEigyS7J
	 TVMKOH9eOyY3QnKlhB2VyxOcHX5LF6eZ4RiwNhK+Y46Ujk31RWpfhyRZzWCWwH4+6mZABONFTNCF
	 OavR7Fwve6GPRwLZiteqyScTbLBZTczDtBlXEoFpW2jVvzYF7jDhkxZI7hGosZU1UH8up6S/iFvw
	 zZ4Hqcyy6SfgRa+koxvtYIeRnIom/P9cAcjmZqKoGpJVkycIyR6gDPE6mmC7Al4yqDjjREmuhtcd
	 zO8EgBSG30NMezVq54zR/8Nm1K6jo=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: 303146950@qq.com
To: bmarzins@redhat.com
Cc: Martin.Wilck@suse.com,
	christophe.varoqui@opensvc.com,
	dm-devel@lists.linux.dev,
	kouwenqi@kylinos.cn
Subject: Re: [PATCH] kpartx: check slice size before looking for partition to remove
Date: Tue, 21 Jul 2026 15:30:50 +0800
X-OQ-MSGID: <20260721073050.3010-1-303146950@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260721062724.2478394-1-bmarzins@redhat.com>
References: <20260721062724.2478394-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2026-07-21 at 02:27 -0400, Benjamin Marzinski wrote:
> After commit 03071031 ("kpartx: fix crash and truncated device creation
> with long -p delimiter"), when attempting to remove deleted partitions
> on kpartx -u, kpartx started calling dm_find_part() to check if the
> partition existed before checking if the slice size was 0 (and thus
> should get removed).

You're right. My patch changed the order of checks in the DELETE loop,
causing dm_find_part() to be called even when slices[j].size is
non-zero (meaning the partition is still valid and should not be
removed).

> The problem is that if dm_find_part() returns DFP_DEVICE_RELOAD
> because the partition device exists, part_uuid gets allocated, and
> if the slices[j].size is non-zero and the partition device shouldn't
> be removed, part_uuid wasn't getting freed. Fix this by reverting
> to checking the slice size first.

I see the memory leak now. When slices[j].size != 0 and
dm_find_part() returns DFP_DEVICE_RELOAD, we hit the "continue"
without freeing part_uuid.

Reverting to checking slice size first is the correct fix - it
restores the original optimization of only calling dm_find_part()
for partitions that actually need to be removed.

Reviewed-by: Kou Wenqi <kouwenqi@kylinos.cn>

Thank you for catching this!

