Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CA837475B
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 11:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778500141; cv=none; b=KVqx1qYiX3AQzoeSAI6V5zEQRSukmQIABkX9L1lre2EGWUvHN6x9UahKUfPWx1RqzJXqZ9R/DK3DCnz0TgoehVHmDOJICzrhNl/XpuzX3wpeAWqG5jYvzQoGCAUfWJZYOn4B5YrXobHzokc2Ix+gc63lNhMrFv286nJEkflJGsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778500141; c=relaxed/simple;
	bh=nJ4P0zLvcB9xEXPl5CG/UuyX3T56IDSGGEqB0uawGos=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eN6xhW74OqkJVXDDBWaowuPBDd1PFa6mYtFO5HrmzAFy+1Iu+13a3XhHhO0iu3KAbemooGPBUEwPmtflpznSihV+obpVSBB95OGe9esBmf59AEHBNtKKz97K6MedLrpGSCaORzlEM0ghZyOX/4sxGV8XONP/3tMR+L/HIG9lTIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WV82gP3c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LuO8tag/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WV82gP3c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LuO8tag/"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64B7AP1L453387
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 11:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=noqsgcclwsEXSoiCpQuylteOkPpqrli7SNy
	/mofrCZM=; b=WV82gP3cdHnmRcaePPnQsTBpFCz5W09j7rqrqUiwE+6oY1ok9kI
	cX7IU4zseL9WL3PAT0jX1dw1k9Eu6joDEDMHxv0KSwcdXuia3U3dAgg6zMQC7fut
	BnRjOxj9lSsSjUfev9WTh0w0EhE0VloiuY7KF37QjLKw5XHLxtkHC+LnsOYQBbHT
	3iCaYzWqDzeM1LhYKfhAmUTPYITapFGkM9r4D371TcB8waFOaQu8is6ac40c4h72
	53xBUkSvmjM359rYjX1+0ViAFFWWYhEuOViTVBl9S0cCNABYAdB6NIm/VIiR7T9/
	ClYrhXP1en1MCzVRfwS6uuU0f8fsXACTzTQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e3ag6gy7p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 11:48:59 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2ba8013a9e3so6652445eec.0
        for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 04:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778500139; x=1779104939; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=noqsgcclwsEXSoiCpQuylteOkPpqrli7SNy/mofrCZM=;
        b=LuO8tag/PEZu/WaLW0h+2YMSjg+sF0ANxc9HF14q5jj4GNyh0rVPu1pc5S6fZ/CyJV
         c0f5MJiQ9HVNmwE0BWKuFmvuzvtAaVs9/VogOC2Sl1k1gXMu8Ct8aTshTC3KEszcGyFA
         F32PAvFfSRYL2x8JdLtqC6LQMrxnkwjesJuwoo4Uv4nt6nKzbdKo1Q1lwkOhaksHcUJD
         mhGN3OEwCWpuRxfCKSuB+/Js2sO8Q2wZGzOEFbkTl0esco7U9YPUikVBPObf4NfQQzkg
         sxsA1bw7dQjoyG+wsgkE0Y5d0GWku+nbc/fPZXXDelWOqXxjHd+zuFwwJnDI6dU/SmrD
         lcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778500139; x=1779104939;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=noqsgcclwsEXSoiCpQuylteOkPpqrli7SNy/mofrCZM=;
        b=Inh5fwPdey+bFG66WswcqozPsPiyK3/3R9JogAbPTo90zDIQ0NvAYDAM7Z5iAssf3c
         2XkPZSPjEbDx49AF3ZFSnO3Ymx9J2/uoqbucLHRtzUbRQtCunxJZeEpuiQYZRj+4HFyf
         oe2HfnRo+yNIexwituvVRtNjTJNTMcbnIt1s8JDAtNdXjdl6boRw3YvUP4VwK0xqfUlc
         R6QhcA1Dl9wcLQgbIGxsUosw0KHIO/lzsW6+yMOiqacLuvORhyK9rMiOqpKq9nuSU4FF
         gYUzJ9vNEX2EFU8UF06IT4tl5tPjiWe1X3+QFjmn45cdheHhpA+8jFcS2e17RIySsrxf
         PfsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ol4ovBHljRNgI89KFnLpsuUjxm7YLFxu3qn2rNs61jqXeP5JG2B9+mpkDVuTWoF5mHZYqvCYbVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfwCwKa6403O7QqeMtDmzCkB/xmxKjxy+9J33TQbGDcwETk4ki
	uemRB9RvlXvP/Lc713xXPfAzOLQbaR2x8lnlELLWU15IAwut4I7E6Fn+7okj8+s3jaTB/+eu2iZ
	3qe0Gd+lM6RGEvD2DVUZPR3FN+srAOq0MMKzRLcuOXM6VkmqIuyIIfS2GxWP87Q==
X-Gm-Gg: Acq92OGbwQ/SXJTAJbtfXEB63sjc/zWY5xveYql3U7c8of1pcVr3NpL61jDtedFNgTI
	qFBcUmHhyo6mzOYHO+zfFco6vsaWN4ZpyjoLHRW1+n7zJWsQYBXtHIpzLXJsr8gsLNVKnSnu4xY
	I6LBtUHM/fKlpaO1HMX1aSF/zqvZ2UE1Rq++i/AX75MrQYYUaoFRuxZG1LO6ISlYGmO4ChdkKcA
	JG0NDE4xXE9o5ajG99syDAiAqj/QpeWgBz9eIvUC4lEtVzi8C7iepaW3Ohzs17mHLcmt0lLcQPj
	wo76G1KNUB8GexTstJxqLDHJDWcqf/BUbaDdm3X6/mMUGq3Ll6Wz+FMcx45UT1w87UatXOqDwne
	6zMNWo7Gv1t/63CCw54QlKtD0zbwF7M/rPIhdIS40KmHweSX3i5CEq/NkAhrArwfHQtg1IEXzsW
	cBLLb+PPA7/tE4nVc=
X-Received: by 2002:a05:7300:2202:b0:2ed:e14:7f58 with SMTP id 5a478bee46e88-2f54e483fe9mr10304720eec.34.1778500138560;
        Mon, 11 May 2026 04:48:58 -0700 (PDT)
X-Received: by 2002:a05:7300:2202:b0:2ed:e14:7f58 with SMTP id 5a478bee46e88-2f54e483fe9mr10304692eec.34.1778500137962;
        Mon, 11 May 2026 04:48:57 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eafacsm12910032eec.1.2026.05.11.04.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:48:57 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH] dm-inlinecrypt: document inlinecrypt_ctx.key_size
Date: Mon, 11 May 2026 04:48:53 -0700
Message-Id: <20260511114853.2687249-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fOsJG5ae c=1 sm=1 tr=0 ts=6a01c22b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=j51-9ZwTzf8Tm1CF7P0A:9
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDEzMCBTYWx0ZWRfX8yMAJGNHtCey
 ueXA9mNg2OdRpiiVXoAPVEH9BkJ+DEvPOt+3UD+3cZablHkScvG3sMNPYeE5hkAJmFGWhRqz0P0
 PfzvhGTVoUOu7X6EkCl0JiI4nVDGfxKdqqoNtmBOsfLPpyfLMKCx3XTk74L52rjM/g9W7p+Wfx5
 2LcObY3sicsJhDIIwZzzSav0GSY0D6d5Cb8cQb/XRbRQ1dFC+nVgWKjUB6nQ6QtgvGuwyzs4iJZ
 HbxeaPmHM182VEAKU+kKtKs+RALD73uhntn766zdi+OeuEVxr7Wu/LBDbaxi5GAx6yZ7r0jo4q4
 WZWIfeTMTPc42ogm12Z85ztTVhzsbsQW7BQwECMXCURbERyfZzzt0AOqGfvBTw/4kH/T8xCDRjr
 GbljNU4A9B6WXMQ7hJhdazSMD83XXMvhKGvc8Y3cRtz3nHxvERqg2NYl3UTZN8Gt+6t/NNvrrAz
 leVwnhzvIx9U1v9tnEg==
X-Proofpoint-GUID: Y_5iADgLz3JHebykbISFygcFpBvmgIV_
X-Proofpoint-ORIG-GUID: Y_5iADgLz3JHebykbISFygcFpBvmgIV_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_03,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110130

Add a missing kernel-doc description for the key_size member
of struct inlinecrypt_ctx to fix a W=1 documentation warning
reported by the kernel test robot.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605071534.rxF5Bw5W-lkp@intel.com/
Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/md/dm-inlinecrypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index 40d48ba73e23..bd8e58a028c5 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -28,6 +28,7 @@ static const struct dm_inlinecrypt_cipher {
  * @start: starting sector of the range of @dev which this target actually maps.
  *	   For this purpose a "sector" is 512 bytes.
  * @cipher_string: the name of the encryption algorithm being used
+ * @key_size: size of the encryption key in bytes
  * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
  *	       preceded by @iv_offset 512-byte sectors.
  * @sector_size: crypto sector size in bytes (usually 4096)
-- 
2.34.1

