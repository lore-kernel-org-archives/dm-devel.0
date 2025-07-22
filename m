Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C549228AB11
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753191531; cv=none; b=pNPteDpiMCErNf0X5oKQlGrPqsJstG2gdT/yG3VBmkgFBnJfWlTC6HrYUw344b+g61oqWf4uzb6ylotAiyJcE4fxlxt7eUqeqc0b3tSzBp/6H9OCFdU7RX1HIJAlpACyWqdEWJMdCvFM2Xr/Als3WkE6OgjJ0Pi889DyMJCbKOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753191531; c=relaxed/simple;
	bh=ZTwrbMpRt2TwlqPHozv8D0oMmy3PqsSJbMxASq+2NA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AgCA8Qnl07GTrkCAIwENUy2IOBfGaJ830+JBVd64g+MkifHTMN42Sv7CMgjJ9cfaQVg6Dfo6Rswyf83h8mC5vf5RiQcQt2CxiIAcRJMO7+cbS3M0224qpCB4F64dakYPEzFEDwV1RGzj+Gf6xyyPD5oYes5Rc0TfiG0YGT5Shh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dyA8nhOU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dyA8nhOU"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MB2ESi013034;
	Tue, 22 Jul 2025 13:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Id5JWIU73IkZ1UkEYPmHFMEGu96Kr6Bun+/sr3yjx
	Ig=; b=dyA8nhOUhwZxheC6AIjI/AlcY1pc4Efga7QLYGmMn/BvN7UehtiLV6Qo2
	3TwEGyFPHIHhhNhmNYCM/lZVRRH+lqJ2n5v5sb2tc+cj9JOOWD2RpYYPvVj8QKfu
	JxblROUw/PSlbXMuUyOAzndsvmJlsI/s9t9xJlHlQLTb2nvUm2YXzynx7k1ewbKn
	SEqxchQa7n4EC6Y0iG6WO1TnL7LklDB9KjM7mGD4Ng+P7p4sno+BejtrIAVcGH8E
	KjcEwtbW48b4cD4qytTIej9DLPynzGMgIDu2a5WJD8CCD5zLCl+Zsa46p/aW5mI3
	EyZKNQUsAeF7GpIYWnWtkW1YuF/gw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4805ut6k8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 13:38:38 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56MDUh75023343;
	Tue, 22 Jul 2025 13:38:38 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4805ut6k8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 13:38:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56MB8pHm014302;
	Tue, 22 Jul 2025 13:38:37 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 480ppp318t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 13:38:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56MDcXci52035950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 13:38:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C2D720043;
	Tue, 22 Jul 2025 13:38:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CCC620040;
	Tue, 22 Jul 2025 13:38:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.205.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Jul 2025 13:38:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, mpatocka@redhat.com
Cc: linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, gmazyland@gmail.com
Subject: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
Date: Tue, 22 Jul 2025 15:38:30 +0200
Message-ID: <20250722133832.319226-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDEwNyBTYWx0ZWRfX1ssNa3r/3EED
 5tFEqgOEFDP0kn+G97PUd14jZd06LDq4ig+qyP+eAoTK9BZWDHx0F3m/cEId24UHrMt2JI34zvZ
 6kt/Skf8LIIbOjsyf/d9ZP4xXmL7utPwY8VCDvAHzzI6rpe/rePgVAyXTtzFEay0i7pQKjgWsnP
 Mmcuj44tAGnM6IkPTS/F3eHrpqBBGsR1QLJt7VS1aFM20+FyAHZW/n2mhxdLHK4jXgdZkk906gM
 C181c7aErP3bSOripLggqxL5eBQ3ZMbtuARqIAOzOm/eBF71PLBHsdavqNFyFVfztB6CQbzQHSb
 VnchFvEyGp66FFgEY2nfe5yx4UK2nNtLy63MsBhejw7yYYmXzE9xd0gonQLa6vrzuhTGCTt8lAO
 Wg3+AuAda/2iQd6XzJoR+9DExs09HDhi/ok8ivEoZsgvyBcG41edh+Zl1hVKFza+ddd6pJu1
X-Proofpoint-ORIG-GUID: CgvJSxOoEVsgG6kjiLtFRzYkRAK3l_DY
X-Authority-Analysis: v=2.4 cv=cIDgskeN c=1 sm=1 tr=0 ts=687f945e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Wb1JkmetP80A:10 a=B6X9b4ZOBlqTjHcfn3gA:9
X-Proofpoint-GUID: 1TjSof0_umA3uPG-mTwajjLxEUhvg-EO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 mlxlogscore=742 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507220107

Support for ahashes in dm-integrity.

Changelog:

v1: First implementation. Tested with crc32, sha256, hmac-sha256 and
    the s390 specific implementations for hmac-sha256 and protected
    key phmac-sha256. Also ran with some instrumented code (in the digest
    implementation) to verify that in fact now the code runs asynchronous.
v2: Support shash and ahash. Based on Mikulas' idea about implementing
    ahash support similar to dm-verity this version now adds support
    for ahash but does not replace the shash support. For more details
    see the text of the patch header.
v3: The line to store the digestsize into the new internal variable
    did not make it into the patch set which was sent out. So now
    this important code piece is also there. Also rebuilded, sparse
    checked and tested to make sure the patches are ok.
v4: Thanks to Mikulas a total new implementation of the ahash support
    for the dm-integrity layer :-)
v5: Slight rework around the allocation and comparing of ahash and
    shash algorithm.
    V5 has been tested with the new introduced ahash phmac which is a
    protected key ("hardware key") version of a hmac for s390. As of now
    phmac is only available in Herbert Xu's cryptodev-2.6 kernel tree
    but will be merged into mainline with the next merge window for
    the 6.17 development kernel.

Mikulas Patocka (2):
  dm-integrity: use internal variable for digestsize
  dm-integrity: introduce ahash support for the internal hash

 drivers/md/dm-integrity.c | 370 +++++++++++++++++++++++++++-----------
 1 file changed, 265 insertions(+), 105 deletions(-)


base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
--
2.43.0

