Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83811A683D
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626659; cv=none; b=gFlgheOp4+27hrFF7jxAxckIRb+8bQIl35l0TfHP9xSmTQEJzBYV2lWoYfbNMabWBclksHUidtlhUzy6aGw08fEsxkmZ2UHfFk21DU3fEdVpIlkAwv63aFxlHD+PcGpBK0Zdjy3+D8gs4F6kLK0XsO2ffbH0zbdCXcwVQ0gcQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626659; c=relaxed/simple;
	bh=Gi8vIjmxw30nPsVfY5h1SYrFPO/Lza1eh9E6GrQ4rtk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=MnO8HU9liOEa58w7fZ89PXuLbNU8CApuqnkl4ofBcxdNX8Xaz3bIZ7Q/QE/UH59v3/owrs6aKJYQi09HooMyX6rLW1ZYVRGaSSOLXPEUChsuzuqdV4tKZfey9L18rtZDMOMeP1/yAcTV61GFpqG2t7PcKW3cNMgMbuvS46fbL/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UBnoObBy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QnU5DrBe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UBnoObBy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QnU5DrBe"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6246D9wf1203248
	for <dm-devel@lists.linux.dev>; Wed, 4 Mar 2026 12:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=LUNISlqFvuqnxUOZI9HzNX
	Af4XHNKIKzsl1pT9nO+Us=; b=UBnoObByL4ZxXEE5LhlbH4Rr6fXjJZCjp4Clvv
	rDAiMZhWEgGneIRJA52g2soGrhK+GhmQCdrrybfGCUopAxoBn1YFgstmheFskHCb
	B7B6yJA5k3VkAu1fmEJGlWbFBB/Cy5gsGSX4Idh+0o1OqxH/vqcB7CcGgBTPAvpa
	me6N6CzZbVa+0O/Q/+jxM2EAz0D14ddGQvfr3N/jyHMS30t8C0Zl6SRe4x4i/DcV
	svizXjD+zU1ahBhOTalnknxDE9ThiYrOxdGYs8aSSOrChehadtJhdlZ1OeK83l2n
	DKNE/MW5fm1ZYoaS6UopoKpewLMNP3WWY3F7zLCQ6smV+YOw==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpf9c15np-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 12:17:37 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1277896014fso118511966c88.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 04:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772626656; x=1773231456; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LUNISlqFvuqnxUOZI9HzNXAf4XHNKIKzsl1pT9nO+Us=;
        b=QnU5DrBek1aDUL3M2/gR6s0TQCZG/ffBuxqIBOmf6ah8n/p5Q7B9MLeDpeN+NXebgX
         meAR0ZIMga6NYf9jiYXRe7+DhC17VEJi2mfF3PMnwctZI68z8an4LdJuYDbDhjHJxnCT
         QSmiTmQOjjVCXj7GJ0WWlLtT8KQsJNy1CzAgPtbjdafpE8OcMxpsARynKR6lyU3st1gi
         zMFM7nMOMIJ0VaPcmnDg21GpXdbdGX/Fltf7bNFLWD2yixcOi6AFXMB15D/ZBpA7wfml
         +ZsBGn3L2/byrPlTnuaTcw2DjrigYRwO1hxkpk0cM44bEMOIQdcKxzjUB1J8xYVXJ0TP
         0gEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772626656; x=1773231456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUNISlqFvuqnxUOZI9HzNXAf4XHNKIKzsl1pT9nO+Us=;
        b=Yz1TnEJxruaP5PzXFpCC8UOb2c4nhJY3+XI+bw3jf33DR+MTCPaKoesD0iFiQe1fzX
         yKz2clR7xpNdiZKsk6QaLxverqXPL/xlLKsbsMdk1Pv9TMFkhz/NmicJlEt6RvMxKhS5
         RKwglFGuedM4LHICGoFiZc+TNAxlwt8DpRCFE4KZ2a7CPvNJTQyqt7LGx84bqtCWo373
         U7PHR43GICO9jaKjMbWWS5oxH+AeQwY5jgLy2sxIN22CE2dXxTzTbVG+1joVc6CW0qSZ
         5sXkuKUniJkAm6vhjSRcP/tq+7EX2zXC0oShVJJjsNAjXgFs/UiNy4wzVmLtnwlSwvJd
         avfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlovXbQOR84vG0lHQwahRlN7TAgWsKoOw//SKhkuqH14uf7Dy/CLERDRKhnOyQ8XNuo/vd2yJPyw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5q+q9Rv0YldpFC0bEpgzoqvoreTY98n/IFdqQlgv8p7y5Wy/W
	IPlu7hK6oZpEejC1bRFMkfi0cFnECUHGSXzXa+h6V3fv8ulXvT7PaWe24uu0lICSZQy4vXMzeh1
	K+SYFGIx+Z7JcxHUl/tUqFIXvbFyAJa2qYmdzYRlJc/hKwNBP591Pw4FZTrlIYA==
X-Gm-Gg: ATEYQzxVv0sUtf9WjXpGt3vpNDdTE4eKLZnAq0nmFQNv+0gMNzzPhAWDcNDKeQ0g1nC
	HJ8UASVFgMaVDdFhebRL+FIwA0sAYuXgW/l6tkpqkWWbszQ8ZiF7r7cGiITwge9tjzwP7UhC4rP
	OdYYBzFl4CGjQLrPhmz8QkQJd9Wnq7cnGRPC7SpeUVhec9UVp1TqiHKZwUT4JL8Du1toyoID+On
	EHHbBuuTHTENw7qKR2ZL0qvoRVwk+4YqWyt0U8H/T8/pN9VRpPizzcLzwMPMp72i4XpfxDZLvu3
	dGl2iMCLqM5mPl+QbwPRj1tjsiIDSJNip15oaDCSdWfGcYRYyWeVrigOAIJ3yiLHSVlEzxGD1nB
	BmU/vQlyH2jzbUySdZGH072jxjoKbiR0yq9tFLx/n4WoylFyjXt25yRH0wUF/1ppb3/lnaY939C
	suXZWW
X-Received: by 2002:a05:7022:6ba1:b0:124:9acd:3b15 with SMTP id a92af1059eb24-128b70eb80emr744128c88.39.1772626656405;
        Wed, 04 Mar 2026 04:17:36 -0800 (PST)
X-Received: by 2002:a05:7022:6ba1:b0:124:9acd:3b15 with SMTP id a92af1059eb24-128b70eb80emr744109c88.39.1772626655800;
        Wed, 04 Mar 2026 04:17:35 -0800 (PST)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899dfc47sm22171276c88.6.2026.03.04.04.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:17:35 -0800 (PST)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com,
        israelr@nvidia.com, mpatocka@redhat.com
Subject: [PATCH v1 0/3] dm-inlinecrypt: add target for inline block device encryption
Date: Wed,  4 Mar 2026 04:17:25 -0800
Message-Id: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA5NyBTYWx0ZWRfX0Io/lAEM8lG2
 DjNEsGn6bc9HaXunubVhnr+3FdQXbJly2+m+PiFtFyDjuQjoWuu8dUHxf+wURZQlxfuMZilSg5T
 90Aecjw8k0FdnVT/xK23occ8+smT6CzIv+qkQ40vGErsFO1pQgIIwP8XNndwdPylU2hNDyPsJg6
 vdEt3BALC5J23LEwgtDkm53YriM/d0YH7JhzMEhK3zIx+ZJ3ndwsLIltGp6+/BUNue/wQjkTxmX
 7gkXbPjwKW+3mYKPnUyQl8zXHNjnRtyOiw9ooH4DFPH9SxVji5BT/5P34mVErKvh6GC970xAstp
 KeVNZbXYRDC/ud8ZhTU9n6DNXd6IwiT8FlEue+ThDeVlhay9yh8GBt+KSNmdWXZWC4WN42ALO7C
 hJJNx1Oryp2KEZFEhTWIHBFYx6fQekiU6HUD6ChfHPn9NSlDHnR3eJzMKGtrlSHTpu00xK9JJQh
 vNtlJSBbQmKWNhOMtWg==
X-Proofpoint-GUID: Zizj6LnYQYcv_y5Ef5bgS4Jku12QWTGl
X-Authority-Analysis: v=2.4 cv=S4LUAYsP c=1 sm=1 tr=0 ts=69a822e1 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=RSN1029XlG8FoBkqcK4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=Kq8ClHjjuc5pcCNDwlU0:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: Zizj6LnYQYcv_y5Ef5bgS4Jku12QWTGl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040097

This patch series is based on Eric’s work posted at:
https://lore.kernel.org/all/ecbb7ea8-11f6-30c1-ad77-bd984c52ca33@quicinc.com/

Eric’s patches introduce a new dm target, dm-inlinecrypt, to support inline
block‑device encryption. The implementation builds on the work previously done
in Android’s dm-default-key, but intentionally drops passthrough support,
as that functionality does not appear likely to be accepted upstream in the
near future. With this limitation, dm-inlinecrypt is positioned as a
practical replacement for dm-crypt, rather than a general passthrough
mechanism.

On top of Eric’s series, this patch addresses a limitation in dm‑core: the
inlinecrypt DM device does not currently have a block crypto profile
initialized, because only DM devices with passthrough support can be associated
with a block crypto profile today. However, dm-inlinecrypt consumes inline
crypto capabilities itself and does not pass them through to upper layers.
To support this model, this series introduces a new consuming‑crypto flag.
This flag indicates that the underlying block device exposes inline crypto
capabilities which are consumed directly by the DM device, rather than being
propagated upward. This allows dm‑core to correctly initialize and manage a
block crypto profile for dm‑inlinecrypt devices.


Eric Biggers (2):
  block: export blk-crypto symbols required by dm-inlinecrypt
  dm-inlinecrypt: add target for inline block device encryption

Linlin Zhang (1):
  dm-inlinecrypt: Expose inline crypto caps to the device

 block/blk-crypto.c            |   3 +
 drivers/md/Kconfig            |  10 +
 drivers/md/Makefile           |   1 +
 drivers/md/dm-inlinecrypt.c   | 416 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c         |   3 +-
 include/linux/device-mapper.h |   7 +
 6 files changed, 439 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-inlinecrypt.c

-- 
2.34.1

