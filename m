Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B08313CAA7
	for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718173165; cv=none; b=icERszymxkgSLjEuIdUPcCbiFeVsSqYZTc4Xw/k51WP50Bz0N7weKWLmUoDASrv+3yMHuIeCJPJwuV3mWRoDBQdSO3RGUf02wMvbDr3jepCG2uBnmba1KGHqSgZtf2iwJqBvnWq298f+pmhTBhrSI4mQdWsKNKBRiRiZiYEaRJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718173165; c=relaxed/simple;
	bh=rLR89pcCDeXOZyXMA5OMIoyk9zZvS6jUegquyT9rYUU=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=FMIGaFk72xzLjbNvEIFTU5ywZtrAFmB8erNnZL83QiT3cduUekYFF2z5dVzUPGVBSLoaxttHYeRvXhwoj1u8vA0diD2SSs39w73/QI7a/TqTgQMSb7zhUPI/bHsSfCQ5KNPLuQ0CgOQi82WyhUkXwdXPFpaFwLJWux5LuBQR4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Gnuab4LJ; arc=none smtp.client-ip=203.205.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Gnuab4LJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1718173148; bh=MDrbNW4fbT+LYEPotokNyHm+WAvMbodMYTf6IDC7q0I=;
	h=From:To:Cc:Subject:Date;
	b=Gnuab4LJvWV22khz4eMVxPGz1RQXGMQCdZG1o2I5X3WQIy2A1S3S4c1nOfiX9wn9i
	 +hvM+LlR+POjE3mAOGBwSVmPtnHySHsYj9UxwRvarhNMYiQmGLGC1XHfV9lbNkKMM1
	 sRpZwxaaU6VQo7ASw/jMJ1D9aaPTK/5BvQdNDWo8=
Received: from localhost.localdomain ([123.150.8.42])
	by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
	id 4C62643C; Wed, 12 Jun 2024 14:19:06 +0800
X-QQ-mid: xmsmtpt1718173146t971n1mzo
Message-ID: <tencent_28B810D5C1E1C6C30580729B90CA3CBFAF0A@qq.com>
X-QQ-XMAILINFO: NhpLzBn2I3XwFzGOdN+p4J6dYi1G2ZouiDpC0MmckH8ML0XyYJiRg2MYhxBjcP
	 VdA0i+iSdfVlCT5oUT2r05hFXh/ULpomyiKFqcrEcrKUwjwzwcG3k6w1Fxr1CX3AJ53+ttNMfhzc
	 4ncM9lfcKCQNDZNXRbuqDrxNuUBH/JDiGu4L6z5lA8xT156067XschV2HIayMklRiNYUFU5rV02k
	 TGgD5cMwXxpQmYFK9sdqkUN4cP9nKXgajPnuqZLB1GRGBDDl3Bnxj+07bmNjGPXx+x/1j4xmgcfs
	 w1+dUIJCWgJq1AcdOsrdL6JjwvPjfh3AgT5qs/4Sn9pDvlXGaMCAQUh5cVecuKHuAy81VAX7RRGN
	 Azw/LIoov9nnL2yOLjS5hEuc6z8PfsxQ8+aDjsFrs0kkZ56zmPC1DCYyfG2YFQJeK5M5Y/zaNSjC
	 JKtL68YwRUK0cqCL/GFs6ruQ/GVzPXuH6DKXcrqLAazU/QZumNC3ZJcFAPVlP7XchIsqbfYgEghi
	 lQKzlC+aoPcVYlX9EpPD9T5E9INNoHDcZivtynCj+Gn78QXgZffGbwNJo6fnBC6S0ODQCAB7Y03b
	 FacR8nK5WRGx4BB/DfUC8rnOf+wOTSolfHEN+01AdY+b0os35g1wYaOydsqbbHcPYoJhn2sjU1YY
	 UGTZZEDmlYcOVXgxOBZHSfZFFOtpj5uLSekhxIk8PNGCXUvD4779/Y1WagUbQsmenSuZlPqE7TdV
	 3OmgeNOzncHDsCsF0nS3DA3Eot7iA/yi0W3t8PnkzqzewycH+8ooyYJ5HAUJFdxxypK2fjgKXLbF
	 eYFRDvh6KOiFPKCMynlLCiynVx0rcMlGfV0qQNNoaz1a72e0QuuRD/tBoQ8mEFgoTSjPU3Nl/7pq
	 IoXeoAz7595JWigL09wfkh3+Fru5xL1V2n/znmxLN1XhtLENO7SRp93RVziMXOrRVLadKX7Y5hCF
	 gdoRY7wZ1Kg1/5co5lZ+pJLOz8F7nSM7zN739SfC6R6k9m8MuGNm7a1e0JfiiO
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: 303146950@qq.com
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Kou Wenqi <kouwenqi@kylinos.cn>
Subject: [PATCH] multipath.conf.5: fix the description of prio_args for path_latency prio
Date: Wed, 12 Jun 2024 14:18:37 +0800
X-OQ-MSGID: <20240612061837.68854-1-303146950@qq.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kou Wenqi <kouwenqi@kylinos.cn>

This aligns the description of prio_args for path_latency prio and
the actual code.

Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
---
 multipath/multipath.conf.5.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index c788c180..c4ebce97 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -437,11 +437,11 @@ Needs a value of the form "io_num=\fI<20>\fR base_num=\fI<10>\fR"
 .TP 8
 .I io_num
 The number of read IOs sent to the current path continuously, used to calculate the average path latency.
-Valid Values: Integer, [2, 200].
+Valid Values: Integer, [20, 200].
 .TP
 .I base_num
-The base number value of logarithmic scale, used to partition different priority ranks. Valid Values: Integer,
-[2, 10]. And Max average latency value is 100s, min average latency value is 1us.
+The base number value of logarithmic scale, used to partition different priority ranks. Valid Values:
+Double-precision floating-point, [1.1, 10]. And Max average latency value is 100s, min average latency value is 1us.
 For example: If base_num=10, the paths will be grouped in priority groups with path latency <=1us, (1us, 10us],
 (10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s.
 .RE
-- 
2.27.0

