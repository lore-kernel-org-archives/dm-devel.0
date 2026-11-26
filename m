Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795681605;
	b=fjpAzQDHyPsCMH/IVm6w/V6putat6cnw95RL4a4QHcb68roOJS8atxJWbGrd5SkBCrq7
	 N5VOfWN8latVYGy9yFPWRTNRGCVGycOvnHpwig0YCJXOc/oQ2sA38iTZfhX1Da58PxLAs
	 bcWfiOf/wNan5ZOmsxKOASmdeOjw2szsG+dnj214ebljoznqxs+D1Ldx+D1PB51WuBh+t
	 LyWu5Ih0huDMbgL3BwZXToYdKdeZshpyXR/FOsNzibG6a2V2PBTgvFXbQESD25ocRSqMD
	 rQED8dr2zairly/sRk+r3qCGbICJhfByInNX9Jb8+X5oCZck5fba9qj2e+w9Z/Xkq0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795681605;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=nMb0vrZtB0rCGRBMD5Szuw+BH4dPouiVXcf115w+KNw=;
	b=1E3XgEbG71TpdIqwnb+g96mn0dU+6IduEwbGHREA9Be/C4DFhLs7xBsNXQ7q2HZD4912
	 Dxv5BQSUkwdhjtpg4c1DOMddfGVYFgSC7ca58Xs5TG44xJqS5ONPtjk6oWuc2d0DWImI5
	 Pf0maJPqs2FV4w0kuXpVYYEHCkN15koJvw6+R6uIuLmT/th9UcH67EZRNT3uuYxuqhgil
	 MHnt/UJ6JeqtSbmJU27/7IDvpImfS/DRdifNcyuCZ23TSAqBA/DZRcwgBrGou1feiQF5k
	 HvF7Z1fQnSDlk8pgnCQTcbjiemfDsqehWobSfRvkFN1ANL6wm1sQ2gzbeFJCeryHhpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=c1UESQdY;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E55606A31C
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 08:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82E55606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=c1UESQdY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=nM
	b0vrZtB0rCGRBMD5Szuw+BH4dPouiVXcf115w+KNw=; b=c1UESQdYYdl8ML0ayl
	TR1i+ed15Q22nTaEcsNSQPkwVb2Wi6fHLrtoBHsLjxR+nDOcveoYsIuNi22n+1JW
	+uMgvfbLt6dC5+rFpIUdgMRbRG/KFQGF+x5yVOeaCfewDpS091+deDSqVUP+Ua6H
	qssZZBQGJ5+Ipfczff8r+NI4o=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgBn7+Yt7Qdr9WuKHQ--.46746S2;
	Thu, 26 Nov 2026 16:26:22 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: dayou5941@163.com
Cc: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	liyouhong@kylinos.cn,
	magiclinan@didiglobal.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	song@kernel.org,
	stable@vger.kernel.org,
	syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com,
	xiao@kernel.org,
	yukuai@fygo.io
Subject: Re: [PATCH v6 2/2] md: fix sync_work vs array teardown races
Date: Thu, 26 Nov 2026 16:26:21 +0800
Message-Id: <20261126082621.194246-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126081030.150032-1-dayou5941@163.com>
References: <20261126081030.150032-1-dayou5941@163.com>
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
X-CM-TRANSID:PCgvCgBn7+Yt7Qdr9WuKHQ--.46746S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRMUDXUUUUU
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+g4j0WsH7S4yjwAA3U

Hi,

Sorry, this series was not sent correctly (the patches were not
posted as one continuous, dependent series). Please ignore it.

I will resend a corrected v6 shortly.

Thanks,
Li Youhong

