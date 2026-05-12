Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FA49250D
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778579531; cv=none; b=jAY+Oe68v8XbswYhU6KvK35bmXQdgyMKojcA34/0hLWP2xFTZ+wIuhTUM9VEo6+q/rRAHSFv7PMU6Yey8hCPTn5Ag4X4NgLZicpk5WMC7P+2S8f6w4fZS+mH3/NPUoUFQUHLxbokt1QkiTQB1MCXhRoEuY/s95PGNTZVEMyD5w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778579531; c=relaxed/simple;
	bh=HCyYVTGN6Cbf8t3hOc8piA8NWcVyRHJK+jphv1f4mV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U+vquUlGirtK/0/DL3JVT2zOH8MxLOt8XIZVDEazqNwHoE06JMUCHo1wCLroXHymceB5I4Zo2g1jNQBt6PFyLbe7yC2GOo4iKVR/Wjn8TY2vReUnH8F005iimPnWa9ZtwyW9VLuQDyoMZLMjRVfdseSbkePsDWO//EceNWW6hsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B/QxkWIv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SH2W0vKp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B/QxkWIv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SH2W0vKp"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64C7XOIl3698411
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 09:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=LD5WUJ+s3N8
	WsiHaOGBLmG8YulMJ7+dhDgjVuuKNtZs=; b=B/QxkWIvpJMDY/BLDy8XcOkmy9K
	cAP+7J2eNoDPR07glVcAsrbDa8wgWccr0QfhtsshMNrLIn2rLyD1JUMH5sgPbZtk
	CU2PCva51vpNOWKZufgpHKMiQNXztrOdbOf5KoM11KbRYX91HPPQVVahr6fITwvc
	5Jv4Xz8KDkY2T11S9JVhsA2snmqmpyD4TDEQJH7yE7plyxIxwN6OflJ3QEqzAOMQ
	9zBdGR+aGkMmplvdOk5x9QG2HWtZW/k41GSPY7UWs4rTq0Q4QBCyYZIQUdIIcNis
	ZvfICiivG/KAjZTsUNm1tPJn97UX2sEZK0aG8s9tiJKi8/Gx6Bg5b/JDdRw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e3nuyjhv2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 09:52:09 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2ef37c3f773so6380622eec.1
        for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 02:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778579529; x=1779184329; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LD5WUJ+s3N8WsiHaOGBLmG8YulMJ7+dhDgjVuuKNtZs=;
        b=SH2W0vKpf/ilRJtec9CV8xmzJVNi5lG6PGyOvmqrxuZRrNyddCS7lvnIFM20wnuPti
         GKZcNON90F2DZZndulxZMSKbKNeRq8VPAknU5T+tJe+nwe7DkKbufGDKjg/yWbBziATq
         6XiEJcb5MFLVrcKwo1E31H1dNtmGnADM8pAr66X2WkEyz0rH37ULbQDYjlHyT1B6nTzw
         7SaOM9Md0BeyXQC89k4vnQrwJRlkLvxrytPtAYbaMdomyZAmfyISQzZCGmHSGobTPBvA
         7FwV77asYVPkRsmYJNzYOaJSht1XqVxUoTnhlDjX65TO3/BO/2NUV3P+8rbHuEC0hcdh
         mDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778579529; x=1779184329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LD5WUJ+s3N8WsiHaOGBLmG8YulMJ7+dhDgjVuuKNtZs=;
        b=m9uHdJ2uoSCHsvOaBUtctpmvRFMo7fUOOeUsfipUiOwJIBKWcqEhy7pCCKK++oJJts
         1aRSF7YTgBZ/2RmA7Q8a9+PAmeghFoVXDZzYDNj/sYfkddSar4YKwY6HtTPpVvzJp3gb
         cjAjLmKh/AGtlUNQakvB1sQCg0cdaUgLltbZFLWq4+6spm0F1lgmage9MS7CrKp8fWkP
         w7XAKxTKF6+WTKjY0hILWp+syZNVRTWEHhLyaM3nZn3LL/F9XtaREzvO7BnDkyyMXD4Z
         Db0vX7GouV/cHotMP7mT1TxsJMTdJLfcgxtx42ZdrBIVQtknKgso44/+qNkToUTcX+u8
         918w==
X-Forwarded-Encrypted: i=1; AFNElJ+fehuPskSbgrLfM0/HwDeKrcYKv1l9tX+6oMhJJ5zsdgW9H1IaMtAIRsCTE7YTAMBChAfsRxW2NQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyI4F1yfq4GYebCN1P4w2FvzSYynfEjrPxpzd+MJVyDQxkMSHmJ
	JdemGaR8uOEnrdhgl7VUOz9Ar0SeNDw9gn20lwf06ceokfTObLQLxtkInKnqhR5J7qY6wkKP+qO
	XQjD5WbHzBA1kkLOigGa7OSUOLZMzO9fThrBLX/nwfvPr1TL37gOCK/mUALKJNw==
X-Gm-Gg: Acq92OEfBXKTdg1tXRzlYa6swMg5orsTnVxOl1NYtcpP8y5bL5b+UkUXdUCIDDvwVcu
	YEjyOFBRMCz+y2BgSVCnDuYcq7jzyVDA5wFU8XL3SljvsvGvxZIGAWlq14DZxGU/JByyssQICZ7
	jSUVc/isaJRuSNXPdRrv58j1yTUWujH4FqQZpTDTvgw1/Wd1RtbHvg+lT9M1ucW4e7zIilYik3N
	0SG7B/zWkWMLrj+tMC/Go6eoBlwezDg+bRY8jBy+iNaHmkMxmT+sFWdNQf+0TiKfiYuaVu2K0LH
	cLnG0xJRJ4m0EWVAmrNfL/CqNzAgH+DxahGMvIbhfDGF+Ff2RcU3Qx/APfKlObZkaIAkOkEoZt6
	fqLu4h8Dbudlu9GL6RFYTFAh/yXPCr0XbLTXIedRH/K0rNAtsBzhHrfPha0ZNdd6FvGmb/DFMSj
	3WwiNN
X-Received: by 2002:a05:7300:5726:b0:2d3:f3fc:bb6b with SMTP id 5a478bee46e88-2ffd51d5d14mr1124775eec.1.1778579528521;
        Tue, 12 May 2026 02:52:08 -0700 (PDT)
X-Received: by 2002:a05:7300:5726:b0:2d3:f3fc:bb6b with SMTP id 5a478bee46e88-2ffd51d5d14mr1124761eec.1.1778579527981;
        Tue, 12 May 2026 02:52:07 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f88885b820sm16887442eec.20.2026.05.12.02.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 02:52:07 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] dm-inlinecrypt: initialize blk-crypto key as HW-wrapped key
Date: Tue, 12 May 2026 02:52:03 -0700
Message-Id: <20260512095203.3688708-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
References: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA5OSBTYWx0ZWRfX5auw3QZLjlcc
 ptrl7czGjo/bTIz4yDLwektwV9gc2ylWhlTd+Iu37nqgDtxDVeekge9d+m+kUmxOFaNlgqnVFnC
 1KbqLZlhbWsNMy3yCBzQ93r7J/d3Ul1oUvFaVnJ7QMQu87DrynbtZdv6E3YSmDi/N9RnaCH/KCQ
 4hnlqC+RVFz5J/4cL4ybh0e3SU8sdsr5qRjiGr0zdWihbinQ8+2WMmZk0zxd1SA35336jc/s6Rb
 WymCqe7BKuWp2KmfEQU2Y/JthoPHUV8vvPptzzy/sraZaE61fO95u6fTYRe4E/1Uh5KPj8bm9/e
 +u7B0C9l+NxEZjLp0Af5aEkYlp7aC3kFFY72+bNqdBxqxAFuD1Cw+cTTy7ueqKQNqS9FNbRdRA9
 LbdsaZorCGCxxU0jdDjrPbfeFyRZ/C7Zs65cUEoFPHUKPEj7KK73jluh7Fi5wNsUm326b8rYzf1
 PUGKWNcGyXrmBbxDvRQ==
X-Proofpoint-GUID: 5v406XALu23cHHpdROvHBWjl4jWcto4x
X-Proofpoint-ORIG-GUID: 5v406XALu23cHHpdROvHBWjl4jWcto4x
X-Authority-Analysis: v=2.4 cv=Y5XIdBeN c=1 sm=1 tr=0 ts=6a02f849 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=EusemhtJF9FVNhmqrvwA:9 a=bBxd6f-gb0O0v-kibOvt:22
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

However, on platforms where dm-inlinecrypt is used together with a
hardware-backed key source (e.g. TrustZone/TEE or other secure key
wrapping mechanisms), the key material passed down is already wrapped
and must be treated as opaque by the block layer.

Initialize the blk-crypto key using BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
instead, so that dm-inlinecrypt correctly models hardware-wrapped keys
and avoids incorrect assumptions about key ownership and visibility.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/md/dm-inlinecrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index bd8e58a028c5..bcbf363c533a 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -386,7 +386,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
 
 	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
-				  BLK_CRYPTO_KEY_TYPE_RAW,
+				  BLK_CRYPTO_KEY_TYPE_HW_WRAPPED,
 				  cipher->mode_num, dun_bytes,
 				  ctx->sector_size);
 	if (err) {
-- 
2.34.1

