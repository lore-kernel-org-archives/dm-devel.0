Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E6425333F
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 09:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526223; cv=none; b=upxxPmOipg+V9robr9xgsclN9GYz8r7aiZ45pLJl0dGInT1+7t1C1UW0b+yo7Sq48kpfEM5Let5a/RRNd6nYjIDfc+prg1GVtC1k4XnQr2ZPV/aUyK+Mt0OzLX/48i3qwZJopgRU5PSA+rjrBWzSkvk65tB+gbMv2HyrQxKfATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526223; c=relaxed/simple;
	bh=t/vAO66ayvydR/GoxDzPl7BGpra12aCA2DzMMuOicWQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=IIuw/exozQtaTf7HqnpzUhVvaTlYq5sH4GFDDehfTR/74uUphn96q9GCiMvD9CYQV1SC1CHAstwb0se7TAmcMyzUkw1Ryg8HkgX8dG+9YvgVYXdqL4EGW/jlT3DPlYSORDBEeUtpnstzDf6Q0yrk565EengNRg31gVCRXX/UzOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aXdrDDqN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aXdrDDqN"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E7X5gR026534;
	Fri, 14 Feb 2025 09:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=Sch7KeSW3TsmEUD2wSGSSlhZjsBwk6HpfdNW2+1UVGY=; b=aXdrDDqNxvMg
	8ThHNk7YVjJYhkeecpCW7h2cAPFmIDLi070mD1ZBDjYBysKlD5HYF1G7a45zIvkE
	Kb7qMdcaVWhSOvDghCmRQq/p4dgYre07Vj5Qx1HoEs1nD90tNitIdIS80yz+XGQf
	ofeqpNaB6IIsobTfs1hKkWKo70mvsyjIE16M19Q7Gy6zoGLIu1NqEHA/prQerdH8
	sQTzAPghMLIXPJQDN7AsmL5VFzvIpB4eHaA0UU4K03mf8FqurED1pAIhGl/Tog8X
	IcGmL11BJ2BhP3f3itPIPsNmWgTrB1uvmbiSceEHGoSpsGo1VRxgiJKq9S61oW0e
	OpOu+Ngo0A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44t1hprj5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 09:43:35 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51E9hYOL013286;
	Fri, 14 Feb 2025 09:43:34 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44t1hprj5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 09:43:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51E9CvFm028758;
	Fri, 14 Feb 2025 09:43:34 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44pma22haq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 09:43:34 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51E9hXTC31851132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 09:43:33 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D09E5805D;
	Fri, 14 Feb 2025 09:43:33 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 014B058056;
	Fri, 14 Feb 2025 09:43:33 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Feb 2025 09:43:32 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 14 Feb 2025 10:43:32 +0100
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
Message-ID: <bd809181069f87626c0bb5d41695600d@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OhD-mtlSe_T-DSLxO0-5k4kCP6FIt9x6
X-Proofpoint-GUID: 91Sx6j59CyyN_C6T0Gzlr-xTXyX518wj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_03,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 spamscore=0
 mlxlogscore=982 mlxscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502140067

On 2025-02-05 21:23, Mikulas Patocka wrote:
> Introduce ahash support for the "internal hash" algorithm.
> 
> Rework the dm-integrity code to be able to run the "internal hash"
> either with a synchronous ("shash") or asynchronous ("ahash") hash
> algorithm implementation.
> 
> The get_mac() function now tries to decide which of the digest
> implemenations to use if there is a choice:
> - If an ahash and shash tfm is available and both are backed by the
>   same driver name it is assumed that the shash is the faster
>   implementation and thus the shash tfm is delivered to the caller.
> - If an ahash and shash tfm is available but the backing device driver
>   divers (different driver names) it is assumed that the ahash
>   implementation is a "better" hardware based implementation and thus
>   the ahash tfm is delivered to the caller.
> - If there is no choice, for example only an ahash or an shash
>   implementation is available then this tfm is delivered to the
>   caller. Especially in cases where only an ahash implementation is
>   available this is now used instead of failing.
> - The caller can steer this choice by passing a NULL to the ahash or
>   shash parameter, thus enforcing to only allocate an algorithm of the
>   remaining possibility.
> 
> The function integrity_sector_checksum() is now only a dispatcher
> function calling one of the two new functions
> integrity_ahash_sector_checksum() or integrity_shash_sector_checksum()
> based on which tfm is allocated based on the two new fields
> internal_shash and internal_ahash in struct dm_integrity_c.
> 
> Together with this comes some slight rework around availability and
> digest size of the internal hash in use.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/dm-integrity.c |  350 
> +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 252 insertions(+), 98 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================

...

>  static struct target_type integrity_target = {
>  	.name			= "integrity",
> -	.version		= {1, 13, 0},
> +	.version		= {1, 14, 0},
>  	.module			= THIS_MODULE,
>  	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
>  	.ctr			= dm_integrity_ctr,

Mikulas, I am still working.
All the straight forward tests where successful. Even my new phma-shaxxx
was running fine. The integrity-compat-test also found no issues.
However, as you wrote, I enforced using ahashes in get_mac() and
catched some weird kernel crashes but had no time to investigate 
further.
I'll continue on this as soon I have some spare time and will report
the results.

kind regards
Harald Freudenberger
