Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210A01E485
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 13:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737120693; cv=none; b=Z0+07FpfvdjPM6iAqoOGPdsCzuYQtD21GgVuGwFxnQeoaJb11RMCSrIfus3ldanjz6WRPPDTN8e9Y5Yi2DkA4pAcfJAPyFgti6i+tLtiWjLpWQr7Hm5bGqCEoT2vubhxzYgpRpREa92Tk1yneHRqpyFVmPS/io6UsRYd6ni4dRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737120693; c=relaxed/simple;
	bh=FqM/fe7DMvkv4mxHduYo9juUxZ8VI6ZZLzqweeDH/nw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=aHSW6QDv+R9u16n0Z6j3OYaS9DEAMNGihbmYVBJWgbi/C0dn+F8bN0S1PGCf42+CtZSwv8NA/1ISreP394UCK5n+FRzDejgooEcgUoMavAGJQG8SCMsIQmPDD46U75xhYdOZS+xBOvHyWKggDjMZ+QMApAhHC6Znj2QZv56Rhhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mH2SeqVl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mH2SeqVl"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50H3qq53025512;
	Fri, 17 Jan 2025 13:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=ixZxt7FCYwDqO5dCQS6xwmbUE8xCx+yen2w15tSIJPw=; b=mH2SeqVl7YpV
	ilIsQGw0I9A1nIcdYL1Y3pYb6qsLDZXueumhh8HHyFvl+Vyn9vmGFpapVOW0QXy8
	bgszFYypEwwWUuAxpRx4lu5MkmgSjkf0wN/miRgY3fWdtzSsRDvPLHe23GUm7O38
	7hePSeycSHucAcvOOghcU962Le6fbrmlEAa/ptxUWly5VRHD04gjPVHiuQzIAh7A
	Dy4TeRUqXJpWf14Sxz8LTqz5E0Oh/iExpHYvItNU6UTnxxxTJD1cbCUEbxjdXw8a
	l+ZZXClCEUZEWcWGCeJxIO0oJuUm2puSeXr7jW54UBaI28660Bv/I8ojG7nnpKIU
	0wIip9sfZw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447fpcabwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 13:31:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HABHs7002734;
	Fri, 17 Jan 2025 13:31:26 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443byk6g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 13:31:26 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HDVPnY25363074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 13:31:25 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B86558052;
	Fri, 17 Jan 2025 13:31:25 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FA8E5805D;
	Fri, 17 Jan 2025 13:31:25 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 13:31:25 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 17 Jan 2025 14:31:25 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <b541f1bb-5287-7600-77ce-ceed5903e554@redhat.com>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <b541f1bb-5287-7600-77ce-ceed5903e554@redhat.com>
Message-ID: <3d8e8b33e4ade05a2bd0e99583444f0f@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ab0DSjqgpdY3lx8I6ZTf_mumuGheJsMK
X-Proofpoint-GUID: ab0DSjqgpdY3lx8I6ZTf_mumuGheJsMK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170109

On 2025-01-15 18:29, Mikulas Patocka wrote:
> Hi
> 
> The ahash interface is slower than the shash interface for synchronous
> implementations, so the patch is basically slowing down the common 
> case.
> See the upstream commit b76ad8844234bd0d394105d7d784cd05f1bf269a for an
> explanation in dm-verity.
> 
> Do you have some benchmark that shows how much does it help on s390x? 
> So,
> that we can evaluate whether the added complexity is worth the 
> performance
> improvement or not.
> 
> Mikulas
> 

Just a short sniff test on my development system (s390x with 32GB RAM, 
16 CPUs).
When I run a dm-integrity format command on a 16G loopback file backed 
up by tempfs
I get this on a fedora40 with fresh build v6.13-rc7 kernel:

   integritysetup format /dev/loop0 --integrity sha256 --sector-size 4096
   ...
   Finished, time 00m08s,   15 GiB written, speed   1.8 GiB/s

and with the same kernel + my dm-integrity async patch:

   Finished, time 00m09s,   15 GiB written, speed   1.7 GiB/s

However, I'll run some more sophisticated performance measurements 
during
the weekend.

Harald Freudenberger
