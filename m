Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7708334A797
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778579530; cv=none; b=bKqzNjE+nfKSM0KkOjEdQ88529R8qFZcwWWvbNlW7ma7/ihe0QoaqB7Ua1b2CF4mpTqKPwNs5x6jFnKXfuj9XQX3Q/NYgJI1Nir6TxQKkiSl1TeMa8oJc8Iz4QU0tcWxXQayT4yaaM2w8rXSZh/bmu/JlxX73l5CjshYt6cbKyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778579530; c=relaxed/simple;
	bh=L/P7Z8N6UYSu6FZPTHLfbqz5MZOHjuF0H/DA1EvI7XA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L5z2ggedPccY0AyjOSEva48U7uvdEdYoyDMCkfmpQH8haZuxsDA8DZxBfCE6mshWH8CIqKz67tNigBzVxGy+mODuZ6f7FrK3ZAhumyXfz1Gh2iPpmJzdBysqLs2sgDz9AjlkCHngYzDF8vxMoUinn4Vp1cWN5Da1JiLmD9CGn/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OHpLXSW6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TMOhjT+D; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OHpLXSW6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TMOhjT+D"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64C5Doee2202417
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 09:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=n7fM3SoLN72tH7cdgdQBLoWISZzglDtCstq
	VC6J6JxY=; b=OHpLXSW6XPqlcvRmm+5upvdxVrRXYx9ZYWnmsVLNiNxv2yuYpC/
	CH/xeOcuZizeDL91vV0Ua4pxdZDfXN1ih0oUBfkg9fUYDOTcqcLO87TRfbwzKUQq
	lVl69zREZlaD544CyiIDEymkpRiAVeUZcf7T+npSfTisWdsKXlD7T4aiVWab+fwp
	XE1lbWvLv8/zerhdmizDZQnydPl97BuvfSmUTf9oRufQgDDl0byPitlOdgeulRyM
	Nrgie1425JXQ64vEstE4tvbqyyciyg8Zd2PGJeiqJ3LkNF3ac0AuzQtUnbFJ+VaP
	2aMcsTBvjWpTEVlysLCChJmJNd9psLS8/gg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e3nuyjhv0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 09:52:08 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2ba9a744f7dso3876740eec.0
        for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 02:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778579528; x=1779184328; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n7fM3SoLN72tH7cdgdQBLoWISZzglDtCstqVC6J6JxY=;
        b=TMOhjT+DHL4K1diUxwulFW79zq4REOGMbghqs4r5ecPRA0Z1pAKFZ1Dme/WWOkz7V0
         PPQXM9B0rkvv7M0D56N6JYSJGRxlOMIbPEbgoP2ylq2Z7R+is2aFMjqxMTMaUoZoI3G6
         doOx+uIY5b3iZs/xZStvQ+QyIvkIYh722P1MMqnGJ3U+xiqhTALylomrT5NhclKzd9QT
         VzjLSIPUhoy6ymq2wnc5QCNcEzMshIetWT12LQV40WAmf0aQ/gDZqq2rCXDFYL2iizjG
         CiLiCajQcDSxrWp2fUpMGk/I/EQHNtUqiib6+Vrf7bQ+nf82ySMkkrfU1L8BrG/2MvCF
         /4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778579528; x=1779184328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7fM3SoLN72tH7cdgdQBLoWISZzglDtCstqVC6J6JxY=;
        b=kkbY8aPLHqyWhV6NtFk0/f0Nea5g9a4LCvMs+KdKQGuWlaA5iMhzTKZDfhFx1t4ZPe
         05AhrENUaSSX8rKgC7/algxbG5s/dqolH4mi20Po1ctsBHk8KRh+OzNh+6+rsDLjEk8E
         I2YWGbUgR9pnuGVF6bTzLOv6Tu7rovQ/CwWoUBfRiRwpK/BFuB1VxowwZkm9XClOvCY2
         TA7GAaw7ANZMesVNJP3bgoi/EZou4P0nfpCKP1SXV4FCzIkDCOlOZJn4Ko7xUyDn4LzJ
         8WWgcMdKffF0OsDCN67kQr1Be7ydG3BhQkfKMSIwLm8yZ4N2tZaZwBbp13p8yGokOoQX
         8sVw==
X-Forwarded-Encrypted: i=1; AFNElJ86rlvQ/8LCJSAgQbmz36zr9cgVkodBZUi8AiYICseSr9c5TXjllysBgyGpPj859Iv2k5gdCLdLAg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyeZjV6zLIMsnxKLkMTgEQfNLTkf7U5cdXhazMtbjQXzJl24tQy
	bbIclFvOdgvWLcg2SCe253pnQooB2WjK/Ny5xE8VaqSIVgHtKsfzpyYE8dHo3wwenghG4x71DH+
	PZ+wuVQmuW4pqQF1jgSYvaxuI67fDZ/VjqXwnhW8P4TCIf7leJ8QW5NXmc/odoQ==
X-Gm-Gg: Acq92OEE5p6QcfdVweP4wBJA4UtGq5SYt2MVuhjWxD2aGF92Rd2+S7PT7TWPyvxDygd
	fP3r6P8b6sAkTXxL0SBqcPHfWCgDCEUHZa4RBhIlNuGU2MvAbzj8YdbYpIQbCp6Z7XBBEhmQ6lg
	FfnGFQUeeWBHQKvqiGLAx/H2CQo3rXqSDSPYtZjC4ySy5fb+68ph6TIpge0tNZchgmH5/BMcEh2
	XodDkdfCSwrPOTFPdHiEMkXGoEm8h59bjLsfENfPU0bqnTuLxFE5wiNcuxlQwisatjeYg5g+Gti
	dLtymR2JfDp2FwMDigvOwG97ZL5+yoFZy++n5wrUTKKGlEfONcihr+vN4xXCa8goW5caCXzp2MA
	zvYOoiPt5yZLkArQ8L+mrrSZ7+WHkLdcjVVt98MxxaD7xnxNtCpEWXsIOwCVF41+To5d759KA+v
	+GcWxl
X-Received: by 2002:a05:7300:6d07:b0:2d3:2983:c87c with SMTP id 5a478bee46e88-2fb4b923d2dmr6761973eec.1.1778579527793;
        Tue, 12 May 2026 02:52:07 -0700 (PDT)
X-Received: by 2002:a05:7300:6d07:b0:2d3:2983:c87c with SMTP id 5a478bee46e88-2fb4b923d2dmr6761956eec.1.1778579527214;
        Tue, 12 May 2026 02:52:07 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f88885b820sm16887442eec.20.2026.05.12.02.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 02:52:06 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/1] dm-inlinecrypt: move to HW-wrapped key
Date: Tue, 12 May 2026 02:52:02 -0700
Message-Id: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA5OSBTYWx0ZWRfX99/nBWEdxXEo
 6WgHWAlOdhvkdZHC11zY1KCr/yT08+erQ68FONtI9pb1IMgWN8R5u+e9eBVOy16Q2PBCKKmdSf6
 tsThtnwD5zX5VwciECsAoZWdq43IhCnmgubGFlI5kt9c+XXVpGkhdPsFZGFwPkpWv+LyyToIXTl
 TItXzEojlkqUxuGko85IvU69oDAihOJ1x+ar24I4aX5x1kadOqGFtKTSsf0Bk/PNgIt+lHKxeQn
 VJfgxLUiTRy6pY4XGWCAyXZntDWh6LwYer+PGnL4L4mNyMnDUsBXKpmg3RhYQETtfwVWUxvQ/Aw
 N6J40LwaIT0KLEHTPPvl1VYKw/4UyZFZS8HGlsDbxif8/3KNjANigTwAKIwdeaGhLnX3fB0ovtn
 0723N06D3xnl8HW11HRsh1s+isWPhX4Fbc1xDw039SAqcXYUKRaru6jfYrkP+f0GXPOcUgDNGRp
 p8WHxBlp1EszHGGO5HA==
X-Proofpoint-GUID: PT2I9BOebuC7YK6wodN3-xd6RTZJL0Ca
X-Proofpoint-ORIG-GUID: PT2I9BOebuC7YK6wodN3-xd6RTZJL0Ca
X-Authority-Analysis: v=2.4 cv=Y5XIdBeN c=1 sm=1 tr=0 ts=6a02f848 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=TSe6Oj_gPFDMQzTpqJsA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605120099

dm-inlinecrypt currently initializes the blk-crypto key using
BLK_CRYPTO_KEY_TYPE_RAW, which implies that the provided key material
is a plaintext software key owned by the block layer.

This was requested as the first version in the link
(https://lore.kernel.org/all/20260312070110.GD2359@sol/) to have a
a easy way validating the patch.

However, now support for wrapped keys is already upstream and
on platforms where dm-inlinecrypt is used together with a
hardware-backed key source (e.g. TrustZone/TEE or other secure key
wrapping mechanisms), the key material passed down is already wrapped
and must be treated as opaque by the block layer.

Switching the blk-crypto key initialization to
BLK_CRYPTO_KEY_TYPE_HW_WRAPPED aligns dm-inlinecrypt
with hardware-backed key usage models and avoids incorrect assumptions
about key ownership and visibility.

Linlin Zhang (1):
  dm-inlinecrypt: initialize blk-crypto key as HW-wrapped key

 drivers/md/dm-inlinecrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.34.1

