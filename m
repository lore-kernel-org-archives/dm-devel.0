Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793352113;
	b=SN3S7RvKAYrnZEFDOytiim7PithIjxZDKEkw8+W+ZpcLwHBCWzrzAWrSn4hpdbfTrRsL
	 YQOYfhqVdLFdAhZUqDKL9KPjldRtIf7KuzF/Dlz1vFmHL0Ql6B7WZqDcgnZshmJrrEFFf
	 dnLwJ8U572LLRypIJpPpqVMrouarvZktXGlD9br3ineGuxfiB0g3qCZF+RbvF2osDHbrc
	 PoyBMSVgS6zIodkN1j0aA/z+qB2QQqWLrwx+syTgtW5KqRw4KphiPVOSt0J3tDaeXG6Ve
	 gk3PEOK+dCDSQE0yceKi2o1SyXRAgL6wGAHbdK8eZvnHxUOD7R+meJ4TWGaCxwq18qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793352113;
	h=DMARC-Filter:DKIM-Signature:To:From:X-Original-From:Content-Type:
	 Subject:Message-Id:Date:Received:X-Lms-Return-Path:
	 Content-Transfer-Encoding:Cc:Mime-Version:X-Mailer;
	bh=Rl7hUBDgjTnfIzu7sgeiF6Xol7EVQjp53Fwucyf1OiU=;
	b=adQxBe4bP7a2vDaMmzgjFe0Cha32Un5w/yqKmumO9+SP2CYlAqdTgGtQ60UQ9xD18xO9
	 MZv5HJ/fueTIzMgCn9WqgO20lVUmDOKv4oIA7kfJVP17x1hfc3Yy481bR/bNoFTnlW5jE
	 qdFb5fW05ct3sHyxe1E/2B111eEQ2AhLfaeSgmAw7BMt1vC5rylemfsA4zkfo4UtLpT7n
	 AhwMSLvgd8Nz7J/1zY/GQK2LdhCVNsHFGQX6UnvXDWnQaqB+CiSn5hMUcw+0VGaWrKKNZ
	 uVYvOQgmwEZha3WxiFarhAtDS4sJ7bCUmcSoSKGfHVx0MbAWsUSx+uvfjoFYSbKkvzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fnnas.com;
	spf=pass smtp.mailfrom=fnnas.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=lGNkKn2J;
	arc=none smtp.remote-ip=209.127.231.46
Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F09606A33E
	for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 09:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0F09606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=lGNkKn2J
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1793352102;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Rl7hUBDgjTnfIzu7sgeiF6Xol7EVQjp53Fwucyf1OiU=;
 b=lGNkKn2Jcnm+rXW1N09WfZMiHsjLY2HMRR9TKyNzIA/wKaBj73aRvw4oi6E2WgNRvMQE2i
 aIKPm6smnHPkVVHsdH1pTgVIXNMkdrXa6r7aLbCdbYeLrJUoZmdStwZZsAl/BHCxW6Vj3X
 6iWdFtq8dyNixVMg/rc3hDUTPK7e7J47gk/NjDKZtlAqSNlrMc3BJLnKRQkMwQuWG7GMPm
 OaJ675xPeciLNRedZRuFz5dpIlz7/e082HmvTcwWxPta6GLTJBdBK9PJ4sZ4/PPRkISH12
 VaIF9T9dPi2Gm3YkepOaNILEood2pLIIpNJEQTwpJQdQ3rvS7sdLyjrPzTkWdQ==
To: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>, 
	<bmarzins@redhat.com>
From: "Chen Cheng" <chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 0/2] dm snapshot: fix discards spilling into the next COW chunk
Message-Id: <20261030092129.1671254-1-chencheng@fnnas.com>
Date: Fri, 30 Oct 2026 17:21:27 +0800
Received: from fedora ([183.34.162.132]) by smtp.feishu.cn with ESMTPS; Fri, 30 Oct 2026 17:21:36 +0800
X-Lms-Return-Path: <lba+26ae461a1+b54ece+lists.linux.dev+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Cc: <stable@vger.kernel.org>, <yukuai@fygo.io>, <chencheng@fnnas.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0

From: Chen Cheng <chencheng@fnnas.com>

Hi,

dm only splits discards at a chunk boundary for targets that ask for
it with ti->max_discard_granularity, and dm-snapshot never did.

So a discard can arrive starting in the middle of a chunk, or covering
several chunks at once.

zero_exception() zeroes the COW chunk using bio->bi_iter.bi_sector, which
remap_exception() has already turned into "COW chunk start + offset
inside the chunk".  The zeroing window is shifted by that offset, so the
head of the chunk we were asked to discard keeps its old data, and the
tail spills into the next COW chunk, which belongs to a different
exception.

Patch 1 sets ti->max_discard_granularity, so dm hands dm-snapshot
discards that are split on chunk boundaries.

Patch 2 makes io_overlaps_chunk() also require the discard to start on
a chunk boundary, and completes the discards that don't cover a whole
chunk with bio_endio() instead of sending them to the COW device.

Thanks,
Chen Cheng

Chen Cheng (2):
  dm snapshot: split discards on chunk boundaries
  dm snapshot: fix discard writing into the next COW chunk

 drivers/md/dm-snap.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

-- 
2.56.0
