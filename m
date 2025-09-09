Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941D92DA753
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418640; cv=none; b=a0tSQTQccWJfVaUnA1/gCPhSLYwirvZM04iHxJz5lc+qyfNSPYSyh3Vv3DbqFJhZ9Fu65WMOXN3hvI8uEN1tM1J9SbYSDVJVNNIqBVdfYy6+3en+jQCeS/RxUDAsUg9C3yJiAIdDVRBXwWAA+At3pgCSUMtU4Ai364cSE9nHa4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418640; c=relaxed/simple;
	bh=ONw33GbuutdXTEzcB1zE0MXy8WilPQXaqMkhSuQXEw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HhuP67CiQZ1OKQXIPq3SBQl+Go7OGG/byQI0J9gGxopoujOHVDjihRQHNtt9ZX1LJVbqskrgqQ4cGaCppkA7Lbp0M3dL0ni9Opyyuqi1mtsKHPozZD2tqxG22D0SUi2NbgR4y4sxNKVyogZNLLVKTF2d8fQ6sk0oUCKDMtwKY3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MdhHWHvO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MdhHWHvO"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896WdrO031713;
	Tue, 9 Sep 2025 11:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ESR/g/
	li9E+js8r7ev5NvbX4EsVuPC0JOnYw9a6CGyY=; b=MdhHWHvOm2v9inQZyHV47W
	BkTC98zRzgbPBBmd0mYhkJSzylxK7yXYL3EE6CVbUL1Hu5ghgBSTCiDxGtQWG8dX
	fcu9cigac7NIzcoBMDqtWmTFnROFwZsjrCWzka3BKnpg89RUou5WvDI2VxW03IfB
	/i5fz44YT8YlE9GPafTKNSTYRe64oUHb0hdZMve4jYjLmXWJHUFw5I6/U/i9aEw2
	vyg9attpOfxby3G0mJWjoA9hSNxnKUdv3GDqmYVY51yUtVpL8C2Uw/qOIV+43ST2
	lBAHDlmIw2xh2R3tBv84IDhXTLRxAoFPI5zjXsANwSdcvGHFGibzAnODGNs6bUOg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsq7we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:50:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 589BXoaY017015;
	Tue, 9 Sep 2025 11:50:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsq7wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:50:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5899AVnq020499;
	Tue, 9 Sep 2025 11:50:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp0u286-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:50:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589BoRVE53412134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 11:50:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BE2220049;
	Tue,  9 Sep 2025 11:50:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61F5820040;
	Tue,  9 Sep 2025 11:50:27 +0000 (GMT)
Received: from [9.111.198.175] (unknown [9.111.198.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 11:50:27 +0000 (GMT)
Message-ID: <b01c92bd-e00a-4c8f-803b-20d6a7db2ec3@linux.ibm.com>
Date: Tue, 9 Sep 2025 13:50:27 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
To: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com,
        snitzer@kernel.org
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <3184e0b1-571f-4cf7-94ef-acca41c12b02@gmail.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <3184e0b1-571f-4cf7-94ef-acca41c12b02@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX9TYMaYjCaAvY
 oVGVVU6t3hQek3oQ97QIAFfyOZs6La9FEh3PXvGtxe0pqUFPAiAahkRengWkBJfPeLxhvXj0MZU
 jkSNWNAlQyO9G2j9T+7DYpbjIi7nywpR1t6JxBVQTv6Ebuo4ik4SM0Pq8gaKgjw9vqo58jAQDk2
 9uBPBhNU5HrAMuYvaxz+yMJrkebAaUGGIkoELy6Ex9g3Rk9Mesp0LYbeGj3aFLPnFeWtdo0Gaak
 rSiADl2CqJV/5fVUt/sztDPYpMswTvWMM3jkcZ89bi7unuN2KX9Ps4RHYAFUZ+jIR1ZxTsASYDZ
 WqpP5N2IOtXOotIVEBZJVv6+ouqZ0SR+oG52DR+ItRnwCiAKfw8tPi94ZmDkVK0/LWreN8Mlbbq
 VUKhRahY
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c01488 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=BascJXSDbS2ylCxpsY0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: VSIB9W7812vXbdJUzR9KjULckIx_-S31
X-Proofpoint-ORIG-GUID: 7-bzkrt74YBq_jlXHJsz1utVw_eRA9B0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

On 09.09.2025 13:47, Milan Broz wrote:
> On 9/9/25 1:18 PM, Ingo Franzki wrote:
>>> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just
>>> to verify that the patches do not introduce the bug.
>>
>> With your patches reverted the combined mode fails the same way as with your patches.
>> So they did not introduce the bug.
> 
> Please report it as cryptsetup issue with a reproducer so we can later check it.

I don't think its a cryptsetup bug, its rather that dm-crypt is missing something to deal with async HMAC ciphers. 
The point is that PHMAC is a async-only cipher, with no sync variant.

> 
> Thanks.
> Milan
> 


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
