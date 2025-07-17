Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA726AE4
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765491; cv=none; b=pvr4S6BLBZV/pXOq09FQlqFHuJ9wa6JcSus41Sh0q4Uhh4PeWQbcWw8eMH2xZKKRujwmM7O+sGoQzXkkyK5zr0W4uzT5RKoh2P2CyYko+EHxqHojsIKI1UgtzXlNmqalo8+wLXNVmsQ4H+L/c9NqaqihDSc/A9IVk3N7TtzRTnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765491; c=relaxed/simple;
	bh=iFSBrwv1TbSOx/vvsQuD9W3iV6kqDQrTbHO2R3cfZLI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=JuSdsWdDbt5WQYnnurO+vTngjt6tbWTkPgqUB5NTT1mpjoAGPrXAGjbcR6SjX6NQsJP0v+FtfVEMAc+x3yuCK87TrFxei0nOgG6MkdZcShe+som7iPSVr6gbqZOCqG8n26iaz7IEgpiZpw4YBSgc6zEpgcq7mnHWEBQ4nXPkZeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rCV1f4CX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rCV1f4CX"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56H8xPxf026978;
	Thu, 17 Jul 2025 15:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=vaA/jPd9BMYcIbkQnvJiQmco3UvFFgfnc/uXiJ4paxY=; b=rCV1f4CXvzOx
	e1H1UBT8R8yicVTrVDsFLZH2GTK3qvmLuv+v8HuQ4c+2tx71PhUtQK95xhusd270
	M0Ml5Y4dANFfMlT3b/i7HRYpbPLw3OcGxNPz//f7Go0OOx+6yXcMaAbXkX85hLiI
	kQtZ15+rLtoy1KWpE9zpcqV6SpEVnXaS46l7ck7Rqpl8qmtMMf+ol8aguh9KkS0W
	V5tDopWauhZBmiNeAYA+bRpFltednqvQ7Xx0VfQwwr0UFja9dSIxDpL+NutMAGMc
	gvPTtFb8I5DAoQdyb6c6cW1icp+GacMVRv/ll5pqmraJmhr+vcRA+hlTwidRJdiY
	RhezmLgByQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47uf7dbvve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jul 2025 15:18:05 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56HEwgdK020702;
	Thu, 17 Jul 2025 15:18:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47uf7dbvv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jul 2025 15:18:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56HCr87p025788;
	Thu, 17 Jul 2025 15:18:03 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47v31pvw2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jul 2025 15:18:03 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56HFI2W72490984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 15:18:02 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B92158066;
	Thu, 17 Jul 2025 15:18:02 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55D8B58065;
	Thu, 17 Jul 2025 15:18:01 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Jul 2025 15:18:01 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 17 Jul 2025 17:18:00 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, linux-s390@vger.kernel.org,
        dm-devel@lists.linux.dev, herbert@gondor.apana.org.au,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v4 2/2] dm-integrity: introduce ahash support for the
 internal hash
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <50a28342-9d3c-b4e4-de13-40304eabb8b1@redhat.com>
References: <50a28342-9d3c-b4e4-de13-40304eabb8b1@redhat.com>
Message-ID: <7c019761106ce58f2e833c38d2a77063@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k4sHELeTaAV1tc-jPFvZyczy6WZVbMny
X-Authority-Analysis: v=2.4 cv=LoGSymdc c=1 sm=1 tr=0 ts=6879142d cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=xhkaElq_hg_zilitdiYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: pFRjF0OzQnpeh798dwO3FiuLQohwBWb0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDEzNCBTYWx0ZWRfX38cQGmNrUFwp O1LV7UydeMqeS+MC88QMzc95626bZYIzjXwfZQZhRzWrgd2UpC5puPpesyK4hL6fQz88lifaC5c 0qTYSNzDXXaYp8XOp3g5Kl6OmkEJF0lCmEIAHsUqrtjgCPRdH7+4KIRlcQyCgk5iTFKzpZFVQjb
 KjtBpAdgTLTzU66cK7V1PtrP6v7zDNhF6+JO5a73tilVMVoP4Bh8199ghEKAzazZNMfwTgigD4Y B0xIo9WjWpaiRyOjhHVLMjYUNNKeNyW9NIi3t8ndtywACFdHn1VX2pm8ljr67ftAcekM5LU7+j4 UARSomG8Ry5tyOYKJUSnZlvoesLlHUIN0zOiQ0Fmp2VKuldkyblcnR5rLM9tk94LjgCiAAlslFy
 bkSGTnVsJb/I8Mcm6JHrHOFUElxIsCd7DcGdj3UbI+XKzKZdT1BkKC9gF0Kn2vnby2hAPMDr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_01,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1011 phishscore=0 mlxlogscore=608 priorityscore=1501
 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507170134

Hi Mikulas

I just want to inform you that I picked up my phmac / dm-integrity work
again after the phmac implementation is about to be merged into the next
mainline kernel 6.17 :-) It has been a long long time to get the phmac
integrated with all the pre-requirements...

There where some issues with running a kernel with your ahash patch
causing a wired kernel crash. However, I'll set up my development
environment now and then let's see if these crashes still occur and
maybe investigate and fix them.

On 2025-02-05 21:23, Mikulas Patocka wrote:
> Introduce ahash support for the "internal hash" algorithm.
> 
> Rework the dm-integrity code to be able to run the "internal hash"
> either with a synchronous ("shash") or asynchronous ("ahash") hash
> algorithm implementation.
> 
...
