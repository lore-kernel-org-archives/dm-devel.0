Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74664145A18
	for <dm-devel@lists.linux.dev>; Fri, 31 Jan 2025 10:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738317797; cv=none; b=sSQJduSTB2/uh7tyajOYuKWp8s5rL5NZ094fT/JqcaQXsW98WGoEXX8CiazacOlCsuQi9lywnKPj7rWwRMX/ud9Vy2S+i3/z8ptgF2v/7aljolUxMCYERHA0etLLdmUwWVD/kOlQLNd1zsWKSIVRD22NcEETZjy1G2CBle14WV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738317797; c=relaxed/simple;
	bh=gnUcDOjx2/FypPBCMu8I+I+MklAW7ltHyx8+1CdfxgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JIgSZ0v+234UnpLUdC3/F6xAYrSH5a5qeLFuoRdNuqUmDeQXAQQ0CfsBS6MwOT73bbd2sVJ5TpvMf7vSyZMfY0tBHQ0DYzpLRJTGZQM5Hqgw45PtMK43pBWxOfpwbQSTzuCYMe/G4z4ztkgkEwA/ueUZ/MDNUaHLJBY9xJRRrRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Qw+woroA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Qw+woroA"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2ONWP021914;
	Fri, 31 Jan 2025 10:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=YE3731Ke4dSm3jcCIIqXviB/CmwuCXIaXdR990sG4
	aA=; b=Qw+woroAJ3RzMwhpVMN7aItApJ8janYroJ8A2tG31yt22viewk/V8Cfdt
	O3pEr5tUi5KixTJMIPeHWiXWOqJ0z8+gNuqReY2rZ+EOBgzWsvZRuhhQKL95sLb2
	GB0M1gpGJDBUDBiN45nhmLl/mMDjBkunUsig5KovEq+IDUAW06UEP7FMz1Phvk/P
	+odZ9Ul7MlNwztD1ENRugogLGKzzgG6zANkK0h/CSvXW80A8rbApf0+XIJZm594a
	BYbSQ0PLcP/KL0QNqIEkSxkiqqvRTlSz9E/FruL0/f7uhDLQyQRtvp2JxSokjF5q
	LYgr9XVFKOwfr5+IbFUZ44mDXF06Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gnby9n4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 10:03:09 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V873PS024576;
	Fri, 31 Jan 2025 10:03:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gf9131ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 10:03:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VA345b52494778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 10:03:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E284B200EB;
	Fri, 31 Jan 2025 10:03:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AFD6200E9;
	Fri, 31 Jan 2025 10:03:04 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.80.148])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 10:03:04 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, mpatocka@redhat.com
Cc: linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au
Subject: [PATCH v3 0/2] dm-integrity: Implement asynch digest support
Date: Fri, 31 Jan 2025 11:03:02 +0100
Message-ID: <20250131100304.932064-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: msnWmx-6azlgx6tYkoeLq2hqf0ydC0Pv
X-Proofpoint-GUID: msnWmx-6azlgx6tYkoeLq2hqf0ydC0Pv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310075

Support for ahashes in dm-integrity.

Please note this code is elementary tested but needs some more
test coverage before integration. I can't do that as I only have
a s390 platform but I assume someone from dmcrypt/dmintegrity will
run a more sophisticated test suite on this.

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

Harald Freudenberger (2):
  dm-integrity: use internal variable for digestsize
  dm-integrity: introduce ahash support for the internal hash

 drivers/md/dm-integrity.c | 241 +++++++++++++++++++++++++++++---------
 1 file changed, 184 insertions(+), 57 deletions(-)


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
--
2.43.0

