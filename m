Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51D3D525B
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932253; cv=none; b=klShETI1Vh9SwqfgmSVYqrW9O16FYG3XUJs4kbb52gF9zJfCjJxMDoRkafQs6S7KozASHUE1KxmT4Yj2U8YM9mQCC9soOdAmMU9XfvhT6z+mZ6uQXsKyc26Esy9lyq8+DjPHI2j/fP+r+ZRHhrkaceMAgAbhMpJL4dEbJXbW/U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932253; c=relaxed/simple;
	bh=0zVuvU0DEFqMUuBWazbipjd7ejokNvbJUVXxUtQaNU4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S0YPotKf71dF/pTRjgoh634vMk7+eaU1BZ73miocK7cctTbF3hhrKKuecLl99WKBTnu5CaYUZIm8wcNz1Sh+OWg0ObfJql2hR9IsmL5b590fA5r5k3nwTFBJDoZN+6hTdNAyM5a4cl4uOFp/djZZGcXogesS8/CJkGwe7Yjd780=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=feYskJqa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B4142V/d; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="feYskJqa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B4142V/d"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64G4e12W001648
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 11:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=591wW0cz4jKPEpWJVzEC9GxGm5HxycZ+Yq8
	xB3GJlPo=; b=feYskJqasqxjs8GhftHMlLJZ7d0l+nlnfE62ME7qbkL8wPtbGUV
	msbBHDH/Ak1cCGCc+D3ZEHUA0/OwvOIo55bvIrRYCtekYAxNYHnef+jHkuZiGHkX
	R06l43JOaNvOcfyexkXgDTB1F7qrq3sN8dlaP+T9Q2ZmO+k/jCGzieTxwl45SPQl
	5+TmzDbCWJtPK+dy9+Ayr4yw+nioe6r1Kjnv5ocGSHJ8mCK410C9fZmdJtACrVnY
	r0H9zzk7ZWQTpg4dhZdTEcD7gcavDlTo/ZPblXeH2vFd6YDNmM11uCjdHFvEZmin
	dyONWFjvKGxSx4ohAN0FxylK7YdTspz5MDw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e6hrggnv5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 11:50:51 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2bda35eab74so473605eec.0
        for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 04:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778932250; x=1779537050; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=591wW0cz4jKPEpWJVzEC9GxGm5HxycZ+Yq8xB3GJlPo=;
        b=B4142V/d0MM08d2tEHHHC3HgcjTst2Cf2+x73XOIk0hJdzLZuZ2L7O8DE7i5cy7ZfB
         8eLZRjaiC9UvV1fpft1RRiIMGqO/fiGVA2GyZ63bfbpuNdQJQBvtFJAbCAmBjDs26217
         cKNSTdzVJTRLs8/dGo8AM1Wl8EYEbQnY2Us60k3X/w/474Nq3XEBTODKfDhFRLLl+2JY
         PJQFt0B5izO9ZAjRbP6Eg1788u3OHPoPClBiu+xDggDWd1RPJ5yg/DHPwqbJYJOZW3rx
         BsHxCQMTaL7+zbELSvc1epwmsTHZ0G1qvFAACKHBn+sflWokjFx420MF1gtzHUEpLo0g
         QtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778932250; x=1779537050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=591wW0cz4jKPEpWJVzEC9GxGm5HxycZ+Yq8xB3GJlPo=;
        b=j+ACXRnRE1M4frpGgNz4Q9+l0JQKRqmwxew8Q4kVZ6W5ZHqER3jbDRQZZCrWi8EppI
         y87p5KumD3D5wMEQ41ZDzE/K4gdZFURH0zXo8mpPfH+BtSfkucA9toBGZg34KWkncwIR
         hZ2rfypsc6qk4qdJbx5+MZSz7SvyuHRuKBvhw9U27CZ7a3z1kwzItmD0BugHZaHiGW4e
         RRJVh1PkmfoBN530Jnnpl5IKJ+Vk4aDRktS4W7mDNDWfNMjv184l2Wwlaytv5x6By4lP
         NCHj7ZMO/4dK/TqdsrY3gcxiL7Zks8oKBahvfTVrtzL/+w/Mef/71W9JkNzEVIIZpN/Q
         eVPw==
X-Forwarded-Encrypted: i=1; AFNElJ9biiBvSytc+M+fdXDpHGjLfynK3VxBkWMNRifEirk8Mw5mWrdixv3OqENvXyLS40rvU2+DLTnj3A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8vfK4GFApHOPmRjBHPPuf5z6RUTBwcTVnZFNaJgvsnQLIiGJb
	+1MYhwNlZeOPMwqI7Z7bfLo1kK8NxAr4nDQpQ6PSyhShysCRElTimVnskuJaoawNCbsFfWYBPJq
	vcspODdTBuIP+cK+Ondh3wpxD+h8z+mmedcg1Jmky2SN0JAlwg2BAcshFsw0O+Q==
X-Gm-Gg: Acq92OF9+NuxTSaL6OQYTy3PXVFzVDyAcF/cL+NLnPtgBwSjp/b5oCJVcQ2Y3mCCUTG
	/LhWoxGT9MZQ9twT/cTpYaSlZvx+oeQ+5418Va+Wy09/ryKxs8MYUpCiljSllmFpgI4LC+xizZ1
	VFdcFE6+youJJeRIXtixp/s6uvs1U+q+JkbPd9QjCO2FxKt9rLqFA2a0VpcxAuquFk9xvm/a8S6
	0SaTM/yhaL0dY1aR0dkbhWJ/7vQBKRm3P8y3+xHl9O3Y3Sb3cIZfvrtH6VdNIU8KyXmvEmpUQV+
	upnc7u9bB2YeLhbuqlP8/cwbAJfzlkCxf29SnaQYM/7wUd949Hk9RKvkVRwVcjj1CM/zh6p/RSn
	X3nIPf/7zwfdphpP1gBuVw4ZPxzy9FFn8Ejs9O1os93HGTO8jDz1lbtUPUsiaDSQNrIxf3uwzYU
	2KsY9b
X-Received: by 2002:a05:7300:e28b:b0:2c5:c532:1fe1 with SMTP id 5a478bee46e88-3025eaafc6dmr5602960eec.3.1778932250195;
        Sat, 16 May 2026 04:50:50 -0700 (PDT)
X-Received: by 2002:a05:7300:e28b:b0:2c5:c532:1fe1 with SMTP id 5a478bee46e88-3025eaafc6dmr5602947eec.3.1778932249623;
        Sat, 16 May 2026 04:50:49 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2e69esm11782612eec.1.2026.05.16.04.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 04:50:49 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] dm-inlinecrypt: add support for hardware-wrapped keys
Date: Sat, 16 May 2026 04:50:44 -0700
Message-Id: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: L8rpmh6mi8GMZD8D77D-a4kbf5z5xyRh
X-Authority-Analysis: v=2.4 cv=ApLeGu9P c=1 sm=1 tr=0 ts=6a085a1b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=562HgMpRWxI6aWW4kWAA:9
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: L8rpmh6mi8GMZD8D77D-a4kbf5z5xyRh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE2MDExNiBTYWx0ZWRfX+hzoGnZN1RSE
 RPwkV9tHOuteYKtEGOnDvDWQC1yLkDscP0agBQex9OflaN3AAMmMiq9KIPj0NgL/fxwvxo4dBu+
 0OwopjUesOhuHqWhp0XYRkSS3J38aV1SBg2IuJGg6kFXIkpJZIlgDlS3sT3OKoen7MjA+yNSnde
 nHVhf7QYKjHU76hTeQuoxxAT7Dvn4Wt2XlFiHne3E3Gr+5+KmA9VAJ7clvQpFvMxS3VojMXZZaT
 JlBQ7E4MC6CW3G3Y/8xdKeSBzkIx3QKNz09tqBwcsVoDIUljw/RASLEkYvV7zSMFmiI/JacgDxh
 bM6yWSBL/MBGbBKyCp8GYmRpe13REpDkJEdjIW9BgfbpJCOL2JndpIxTll7Lcd934dW7J0/L1bD
 I9X3POa8VcDPCccWjI8JFDjG/SqP5O1yz4nvtVMgjRBYfPro2YiE/pVL+JTYcuSMxzHC4BZWqSA
 5rTWeViQEYrhCd56l4g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-16_01,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605160116

dm-inlinecrypt currently assumes that all keys are raw software keys.
That does not work for platforms where inline encryption expects
hardware-wrapped key material managed by secure firmware/hardware.

This series adds support for hardware-wrapped keys in dm-inlinecrypt by
introducing an explicit <is_wrappedkey> target argument. The flag lets
dm-inlinecrypt select the proper blk-crypto key type at key
initialization time:

- 0: BLK_CRYPTO_KEY_TYPE_RAW
- 1: BLK_CRYPTO_KEY_TYPE_HW_WRAPPED

With this change, dm-inlinecrypt can support both raw and wrapped key
deployment models without hardcoding one key ownership model.

The series also:

- updates target argument parsing to include the new required flag
- propagates the wrapped/raw state in target status output
- updates dm-inlinecrypt documentation and examples accordingly

Note: this extends target syntax by adding one required parameter, so
existing userspace table definitions must be updated.
dm-inlinecrypt currently assumes that all keys are raw software keys.
That does not work for platforms where inline encryption expects
hardware-wrapped key material managed by secure firmware/hardware.

This series adds support for hardware-wrapped keys in dm-inlinecrypt by
introducing an explicit <is_wrappedkey> target argument. The flag lets
dm-inlinecrypt select the proper blk-crypto key type at key
initialization time:

- 0: BLK_CRYPTO_KEY_TYPE_RAW
- 1: BLK_CRYPTO_KEY_TYPE_HW_WRAPPED

With this change, dm-inlinecrypt can support both raw and wrapped key
deployment models without hardcoding one key ownership model.

The series also:

- updates target argument parsing to include the new required flag
- propagates the wrapped/raw state in target status output
- updates dm-inlinecrypt documentation and examples accordingly

Note: this extends target syntax by adding one required parameter, so
existing userspace table definitions must be updated.

Linlin Zhang (1):
  dm-inlinecrypt: add support for hardware-wrapped keys

 .../device-mapper/dm-inlinecrypt.rst          | 10 ++-
 drivers/md/dm-inlinecrypt.c                   | 71 +++++++++++--------
 2 files changed, 50 insertions(+), 31 deletions(-)

-- 
2.34.1

