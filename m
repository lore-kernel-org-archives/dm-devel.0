Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27823815CC
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779711237; cv=none; b=nAgVVIoShYEE8wLYZv0nBZ3wJdJCWBDM+qQS60zuPF7VsB5bwDAlLRAcS+ONCYCaOgS40ADO0O76yfi7uEPeB6ca4AX8iSfA4pYyUkMJuVmlP5moyEq0TSn+83f+9LFE4KKl3YMz/GDL/Ob5OqHBJQ14x/LqHu2opjT12n/VZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779711237; c=relaxed/simple;
	bh=NNwqaWmZFUL9B7uTYLOvaNjIRA7B0v4wCIYhdsEGGeo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SGfk8UJQ3wj/D5sm40nxKqHbR/LiwK+1WFISJa7WiM2kzy6VvheO1SwpC20YoCyStrLeW28KK6e7TJaeT+h2XI0k2HMtJJ/fIzoqmC1jqtFAbxa6usULPtcARH5L2vTdCGu+VY5/6RMnmuQ0Dh5a5cth0ZLmev8wfo9B8QznOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GrlG7VrP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gl67dZeW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GrlG7VrP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gl67dZeW"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64P9EKMq079206
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=NYsSJx3CwFiaNBGqEFC7vnl9FN7yiN+8T0J
	7Yrgyy3k=; b=GrlG7VrP+QiU3ZgBbsTvoWwnyGKclC9v84IyEsLcCqN1+NTeEn/
	DoOeyUV1WXkHgLi5bRTFYsdM1HlA8fcllcb4qUu0lOw9ydHB+cVCvY8UvDZmL7+R
	js384vhQPl8CyyCVnYc4hvZfTvEYzJ5dJ4MghjYCZcbUPDb9N+kePNYx9BMdvLKx
	fCndCLmCTqOZsUfTiEntpUdI68D6I0WmN2nux0DaSLFtbBwFRnAs5eojDPES/SAt
	YLBI810fyCNfsjja5p5P6o/XoxkmFFbNLre7dOTUF0WGMOQUwDfF5uNgjfGk05BX
	cgtVEa6dVcIjwQCPPApzVjnr7svki5zMoEg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eckma8jp9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:13:55 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-304627c66ddso945398eec.0
        for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 05:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779711235; x=1780316035; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NYsSJx3CwFiaNBGqEFC7vnl9FN7yiN+8T0J7Yrgyy3k=;
        b=Gl67dZeWCIJiTv1WxR9GR2odRoOyZj8Mo+RHOGLxunOpFF9YdFFnQCFbG4sOnP5V1b
         KJgQR7yEH4VgK7J0wBiwPk117ZPQRNcXm0AFjE+MLHXmzbZz8ewzhdtMXgL7kcRtoPzz
         PXO9NP/Mp/n/7kQZky/hRrSqA98I9wSGKFKZ1oPmJYBqL68gHYbWhN1moS19JyT7z51R
         GRBPS5qa5Fp4hqh+9dA0exjlBXbCw9jsAZMUORiLK34DQ/teL5EDS7E5gf93lJ4EAZk2
         joakNr/bFBLg2DCdaf5QRMfTgtiZpaCqHsIxNq8YOnShBnBf9Ra2lpqdk+FH7+OPi/0h
         j1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779711235; x=1780316035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYsSJx3CwFiaNBGqEFC7vnl9FN7yiN+8T0J7Yrgyy3k=;
        b=H+mrKfqHnQFqrwPwzB5L3TIIUL+ISD48puWrCGN9hR4MfWVslgFh35froKyoGYZVl+
         TG3CViLEt0g5sy1u7IfZ9bqJRTOvQCEatlV6jbY7BLu0Y8AdvUGxQ5nPWCsxzEIa4N0H
         jwySloIcq6JDnPYm9e9IcZd9Z32HG+06yw1iQvvF6gP4xAlgX7uqUhTFDjgzy+XcnK3j
         5/woGyqufpQMsdbDugVv88dpSZOF/9KrkEYJpZViQ0dcx8m5MtSEmwSd6mkEcXVdw4VO
         yKcYDlNUx21wcj08pM+muZ+ggMDSenuww2ulnI/hU/E3zUoePuo/sPO3T++CKJ/g9XYU
         LJiA==
X-Forwarded-Encrypted: i=1; AFNElJ9zDUmvohLBe7N5wZNurD9zXnkYhlUw209MryO7qiVmM62gfLk2Rl+wBEz8c7bS0R8ASLRQCSqyhA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzeJ8fg80VJrYAa77wsKs0DmDFIBkUuMRIlLHA/7zQoWKs38Yzn
	qyH9AZ6v5SYYJBRnk1J/d+VqyEXc7wrM1ZrAnSjwYogWbhJSxt/IScZYEjyGFAOyYPbH15yXTEg
	NsUnMwPGSPzc8ij+ZFac4lwlIDfAN/bkZ4xRZupUT5H1EpgithpjD7f6aP9a0gg==
X-Gm-Gg: Acq92OHa9Zg+21zummI1XV6yplCV0uCiqKCF4LA70sCVJuq5miYFDtdddg+530ztAiO
	uTMq06ik01h/Ig59Lu0UlSvSgxwWFJIj1lOFhLFrnO8HE/Ed6YvxrdlfIrCytu+vWiUGBjMMdzD
	CLpXliS36B6HBgKHEGM0bo0EnN+Z0tie0Rbh12Fak45k2JPh4uAXsUgNmLdfT/lAJ3eFxH9B4wZ
	A+Pnbi560Dgw2R61BEL0Yc51DRfGnmgPxIb+EZJ0yaXBWvA9fi3zbg0oWtbQpQpFkLhiDqOaql1
	OjOWW9mWsaxuZ6IXehP606KbVqa0/xXokd3rckuVtVtAUXYAt4EcM5eIGWhorO0a68g4tmAoqO+
	fA9EYUSNlkzq78IdSqb1Ve1WrolbTBJSU78ia+jRB6mNuJ1dFzxE7hZixYbeli1QIMHnABBLLB9
	EoIZCW
X-Received: by 2002:a05:7300:b214:b0:2da:7e33:9261 with SMTP id 5a478bee46e88-3044919c02amr6664853eec.27.1779711234636;
        Mon, 25 May 2026 05:13:54 -0700 (PDT)
X-Received: by 2002:a05:7300:b214:b0:2da:7e33:9261 with SMTP id 5a478bee46e88-3044919c02amr6664831eec.27.1779711234130;
        Mon, 25 May 2026 05:13:54 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304535ae870sm7552264eec.19.2026.05.25.05.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 05:13:53 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/1] dm-inlinecrypt: add support for hardware-wrapped keys
Date: Mon, 25 May 2026 05:13:47 -0700
Message-Id: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=cL3QdFeN c=1 sm=1 tr=0 ts=6a143d03 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=5GvnU5ejbKCXAMTFHSIA:9
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: N4nC794tOc3MvE5ONQc9ku_ncQv9vpQI
X-Proofpoint-GUID: N4nC794tOc3MvE5ONQc9ku_ncQv9vpQI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDEyNiBTYWx0ZWRfX5MlKSRn/NK+Y
 D/80VoTTI1mlzaV5VpE6HgYJOzn23zuM9PMTyGdmYfPGR+Ay2WE5iCj02b8zhjY1aNktp1thJuj
 no3y630UK7Np11KPoWXFipqI/8YMWShS+MvNAGLTVIwTM4GfOIruL8VbRqEcAgSIF8ki7AVw8S8
 sRY/1faGgychknrKP3hBaX8FN1EIQ6QGPHzL7TxgvYHziKuSZ+fo+6+FQcW+C8ngznA9BDyQmKg
 BHc1htoR+KIErDFUE3+fYLbaqcNFhhxabmBeL8+4ZYFzRyOEToH9Em7CChc4Z/hv4IMa+8xcm7H
 5dUZ0PaPwWzIylZW7NPyUXcFYf/nYqRarhMcNUZnIM8raNEMuzvsoZUFKkg0RcjcaBeU/tak5Hz
 RjrrA5oY+JjQ8RKZmvcLJLPV5U3bnV8pXcQalzePt3nFScccfS46UH/l2kgQRWs1ENcgecC4wRq
 WTRxvC6AxsCfOWWkU0Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605250126

dm-inlinecrypt currently assumes that all keys are raw software keys.
That does not work for platforms where inline encryption expects
hardware-wrapped key material managed by secure firmware/hardware.

This series adds support for hardware-wrapped keys in dm-inlinecrypt by
introducing an optional <key_type> target argument. The flag lets
dm-inlinecrypt select the proper blk-crypto key type at key
initialization time:

- 1: BLK_CRYPTO_KEY_TYPE_RAW
- 2: BLK_CRYPTO_KEY_TYPE_HW_WRAPPED

With this change, dm-inlinecrypt can support both raw and wrapped key
deployment models without hardcoding one key ownership model.
The series also:
- updates target argument parsing to include the new required flag
- propagates the wrapped/raw state in target status output
- updates dm-inlinecrypt documentation and examples accordingly
Linlin Zhang (1):
  dm-inlinecrypt: add support for hardware-wrapped keys

 .../device-mapper/dm-inlinecrypt.rst          | 20 +++---
 drivers/md/dm-inlinecrypt.c                   | 63 ++++++++++++-------
 2 files changed, 54 insertions(+), 29 deletions(-)

-- 
2.34.1

