Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2F81DE2D5
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738167941; cv=none; b=IdHPzQ/gVFzLRKx6evWJMPoBVJhqRR7q1Mk5SZVusmwkcgEg/sUJnUkelAl70qkB1pnrEQpoyrdgFPE3DOvG9cwDvwvcuPtmCJw+PtkSQHCGF1Y+MyoBXTRMhgrIfVItKyuZ0F/zZ52cGXIhLs4mkiCjHGZBAENFk80Q5nrLWfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738167941; c=relaxed/simple;
	bh=Pcq1xP4ase3TR7+I7WC3Xk0oeGrravZbwvQwkweXK04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iIWdJ4IiibTenaPVM5frXb/5vvrPM+Px8afQvIDWqqPDYgHn1itsgcvF5T7mG382P/rm/SN1nRTk+6D7W3rkTC666miArpVgJNj+gjbww8p2COviZ6Bmf89HIelDHiSj5/3in/aML4KGHUagq4ebX0uFWsSrHw6zUcVQrRuxWiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B4KRoa3+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B4KRoa3+"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50TFdS3X008446;
	Wed, 29 Jan 2025 16:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=r2dGeDT2YMdi1knJj7IVMYQB+3u7OSG2GCkcgg921
	ss=; b=B4KRoa3+oQsjfAXdnQQCqQ2Vu5UanpRrPfIvntukQsmzAsM83q0gQ7cN8
	vqUN9Rm06mDq5CKPEwJv6niSjvR/dIXn5lgPZRtvQclfiCGgbc32jc1t9N6unTSh
	IWtWw6GGeVB26pI2t3HMHkfkZslL6HWan8wVahl0AdJ7kLyh7YzkCbPPj3Zo3UKO
	l/b7zlW2JKimArlYOaczjDfKnQqhFuU0BYDXqIcQHIxsWEl24Z8P4k1n2PL3N8c7
	72ZkddgY+W+Gji38Ag0MV+5EgM+9arV0L1YWT7Mb6E1+lnQTFiV0aPcjhmEuKQky
	B4Jcw75gIBE73uOudeQ+pzMX6gY1g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fq5tr99v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 16:25:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50TDCkAo019276;
	Wed, 29 Jan 2025 16:25:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9n1g2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 16:25:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50TGPTXm56426824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jan 2025 16:25:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECEFD20119;
	Wed, 29 Jan 2025 16:25:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A243A20118;
	Wed, 29 Jan 2025 16:25:28 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.56.44])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jan 2025 16:25:28 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, mpatocka@redhat.com
Cc: linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au
Subject: [PATCH v2 0/2] dm-integrity: Implement asynch digest support
Date: Wed, 29 Jan 2025 17:25:26 +0100
Message-ID: <20250129162528.57124-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EuKrmckJXge4HMZgJ239DZN4csRawlWE
X-Proofpoint-ORIG-GUID: EuKrmckJXge4HMZgJ239DZN4csRawlWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-29_03,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501290129

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

Harald Freudenberger (2):
  dm-integrity: use internal variable for digestsize
  dm-integrity: introduce ahash support for the internal hash

 drivers/md/dm-integrity.c | 237 +++++++++++++++++++++++++++++---------
 1 file changed, 180 insertions(+), 57 deletions(-)


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.43.0

