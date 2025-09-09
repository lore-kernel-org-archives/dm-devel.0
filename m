Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2C4350D6A
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425012; cv=none; b=rqR7tCgHTZ4ipSD7JswJcvfcjhZH1B0E2Jv/udv1L5UbHzTCsT0EYjRECNncsXYxaXHXwSgVifJ/YnOHMiX8GqEZ0/83bBkgai/+xv4M4awSBj4b8WWv9TqqquOh+XAu8Y7D6Cfh6Euxqhk0kce6hLMUriPRk2lA+pboSSjpAL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425012; c=relaxed/simple;
	bh=/B9MHrYt89h+/2Nh3ACvJ9eneJhU8BS2k9RI2wkepGw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=EZpDDCH4kBJXH0awKnwDx9W5HvguzNYtewzK+s2LVdS0FOpPe5/7ZdO6hp21NazxsR5WiId5RBab76dRuQxTvvuzR07qYqp5fugadtwKuSkoe11bKkfpWJ03vGW40oU09YjRopZscHpY1hrAj3X6v20p+See877B7vfu0nUWaC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TGO0Re5i; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TGO0Re5i"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58995GZ7012159;
	Tue, 9 Sep 2025 13:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=i/PkpkhNmP5vV0GWrXsPvBO32whvDl/xfv/m5vyElY8=; b=TGO0Re5iP1lx
	vHBJoUM/IWtdKEAXG2VqDK2whlBu2QDXdqwSebbMYlA750D7sspHKaRqIXMKnk12
	O1YRypgGbWl2ljHesZ4vI50csXy4Ju7f67cel0k39J8wqFxlfvfOt/Nj+aOXmSuE
	oKnnSsgqYo0dcsCXouSpqJApb7oCNBBKKUExJSXUknq7PIX2A22kRbbht5eIEqWB
	7rZgdnb00Oh/qk6IrSZpqWtp8zHGoPaoBS96xHJoaoqnVxS5ezDvNWiepQUosr5w
	qU/rTgB7p3zLs2eUrwEasD+0TLoHIgvmI08qTzr7lEDzBcVNgApRnhL+1S/YoOky
	Z5JS96FLkQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycvxss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 13:36:45 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 589DaiCJ000736;
	Tue, 9 Sep 2025 13:36:45 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycvxsq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 13:36:44 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589AxGMW017219;
	Tue, 9 Sep 2025 13:36:44 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmb5wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 13:36:44 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589DagGb32047752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 13:36:43 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFF825805F;
	Tue,  9 Sep 2025 13:36:42 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7FF058058;
	Tue,  9 Sep 2025 13:36:41 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 13:36:41 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 09 Sep 2025 15:36:41 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
 <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        ifranzki@linux.ibm.com, agk@redhat.com, snitzer@kernel.org,
        gmazyland@gmail.com
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250908131642.385445532@debian4.vm>
References: <20250908131642.385445532@debian4.vm>
Message-ID: <de2fdad52ae10edd771f5abd01542394@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tGtECSzhjfLvHtqb-Y5Ut_MdAKV0FDpT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX5Kr6oMID2YCO
 MZ3PUgom9y3wrXspnBA3SDtIuax1/2+sJrdvmlOj5GnQGmJC6FQvU7dp3+7Ocn3XevJQGbS5b/4
 dj0yAjInHNOe5n59JE7kUUct4xHVJKEjt55a6spEx7wa2E/RIwvP06XwMv/w5ahw2y0PxL1Y/EV
 yglNsOtAv+CVDs5vw/XmdgV6TrC6lW9RWdzhmIHSx/kf7mGHhfTqEBUHidJZo7/+VvzVs6VCMCv
 UwSEj3jja4qhWi6d25yxtQaMcn2bRxtRXpiGjMODl2obTcTdvPgd/zRI8dlFpkPioxJo8qcO/LW
 zqT3Kwfn7EpeYIXmOs+eLlA2kvmz7ZGlooDghpOotbgoIi0px+JY6T2htCvJ0I0IstVJrxpoOoF
 l/eTexNi
X-Proofpoint-GUID: Ki4XuTyG5iNB9iAQcv7VcvEd8Xc6cNBY
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c02d6d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=AM_j9JD8UJ2nTDWlUrkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235

On 2025-09-08 15:16, Mikulas Patocka wrote:
> Hi
> 
> These patches add asynchronous hash support to dm-integrity.
> 
> Harald, please test them, I will commit them if they work for you.
> 
> Mikulas

Back from vacation ...

Applied your patches to the latest 6.17-rc5. Git complains about an
whitespace issue on patch #7 but other that that applied without issue.
Kernel build and execution of my simple tests show no failures and all
works fine with an phmac-sha256 and phmac-sha512.

A modified version of the cryptsetup testcase 
tests/integrity-compat-test
(where I added the phmac) ran without failures:

Integrity mode tests:
[INTEGRITY:blake2s-256:32:512][FORMAT][N/A]
...
[INTEGRITY:hmac(sha256):32:4096][KEYFILE:4096][FORMAT][ACTIVATE][CHECKSUM 
OK][REMOVE][OK]
[INTEGRITY:phmac(sha256):32:4096][KEYFILE:80][FORMAT][ACTIVATE][CHECKSUM 
OK][REMOVE][OK]
Error detection tests:
[INTEGRITY:J:crc32c:4:512][FORMAT][ACTIVATE][WRITE DATA][CORRUPT 
DATA:315392][DETECT ERROR][REMOVE][OK]
...
[INTEGRITY:J:hmac-sha256:32:4096][FORMAT][ACTIVATE][KEYED HASH][WRITE 
DATA][CORRUPT DATA:270336][DETECT ERROR][REMOVE][OK]
[INTEGRITY:J:phmac-sha256:32:4096][FORMAT][ACTIVATE][KEYED HASH][WRITE 
DATA][CORRUPT DATA:270336][DETECT ERROR][REMOVE][OK]
Integrity mode tests (inline tags):
[INTEGRITY:crc32c:4:4096][FORMAT][ACTIVATE][CHECKSUM OK][REMOVE][OK]
...
[INTEGRITY:hmac(sha256):32:4096][KEYFILE:4096][FORMAT][ACTIVATE][CHECKSUM 
OK][REMOVE][OK]
[INTEGRITY:phmac(sha256):32:4096][KEYFILE:80][FORMAT][ACTIVATE][CHECKSUM 
OK][REMOVE][OK]
Error detection tests (inline tags):
...
[INTEGRITY:J:hmac-sha256:32:4096][FORMAT][ACTIVATE][KEYED HASH][WRITE 
DATA][CORRUPT DATA:4096][DETECT ERROR][REMOVE][OK]
[INTEGRITY:J:phmac-sha256:32:4096][FORMAT][ACTIVATE][KEYED HASH][WRITE 
DATA][CORRUPT DATA:4096][DETECT ERROR][REMOVE][OK]
Journal parameters tests:
...
Journal encryption tests:
...
Mode tests:
[MODE TESTS:crc32c:4:512][JOURNALED WRITES][DIRECT WRITES][RECOVERY 
MODE][OK]
...
[MODE TESTS:hmac-sha256:32:4096][JOURNALED WRITES][DIRECT 
WRITES][RECOVERY MODE][OK]
[MODE TESTS:phmac-sha256:32:4096][JOURNALED WRITES][DIRECT 
WRITES][RECOVERY MODE][OK]
Recalculate tags in-kernel:[CHECKSUM OK][OK][CHECKSUM OK][RESET OK]
Recalculate tags in-kernel (inline tags):[CHECKSUM OK][OK][CHECKSUM 
OK][RESET OK]
Separate metadata device:[CHECKSUM OK][OK]
Bitmap mode parameters:[OK]
Bitmap error detection tests:
[INTEGRITY:B:crc32c:4:512][FORMAT][ACTIVATE][WRITE DATA][CORRUPT 
DATA:315392][DETECT ERROR][REMOVE][OK]
...
[INTEGRITY:B:hmac-sha256:32:4096][FORMAT][ACTIVATE][KEYED HASH][WRITE 
DATA][CORRUPT DATA:270336][DETECT ERROR][REMOVE][OK]
[INTEGRITY:B:phmac-sha256:32:4096][FORMAT][ACTIVATE][KEYED HASH][WRITE 
DATA][CORRUPT DATA:270336][DETECT ERROR][REMOVE][OK]
Big device:[OK]
Deferred removal of device:[OK]
Fixed HMAC and legacy flags:[OK]
[INTEGRITY BASIC RESIZE NOKEY][FORMAT][ACTIVATE][SHRINK][OK]
...
Early check for active name:[OK]

Thanks for this work :-)
