Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C2221FF24
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425909; cv=none; b=VrHfyfkwUKJAqZAx+kbX/qQcBjyKSLJ2qzu6Mfwcrt4LXfssV6PeZ/nbrHBdp6FFbaSw5NFi2IJAoc/4UWqfPmiEhxrKDHo3Ft4OLDHwnC7f8H0aGcfaEAHqcl7PY8/AoNCTw4yyqeMgiQ7cxpp+hgWEyafvtpJZxVFCtz3xiDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425909; c=relaxed/simple;
	bh=Ra2ziyoRzaDncYLcWd6o29f18mYn+p/OfZ9NFhta0TI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lXNbgm5OMc5vLxtyQ5PgDuPlbbcvRJsWvCIURhjXTSMs6uF4GBeyrzQQhWH7l83IjsQqjFs5spQ1a0EOvOEI4jRGiYxgFL8k9AKqZ/im+m1WK3bCcwXg3Vb0bXtEFFoQZ1FpVLKng4QA67cI+pb3EFfLLd4iJwEzcGGdiXLxd1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oc5FMuoT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oc5FMuoT"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5898qftr009199;
	Tue, 9 Sep 2025 13:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=IRemyUypDbljzNJrzzBbvec+4GNRQ1uSCXmFvt8xglM=; b=oc5FMuoTGmuE
	aX+WoaO4bdVF71H25qjm8yb+WyE1p6tL8Aiu6J7TMxWHGpfBgaSpdKQZyQWJRzGh
	m54UhsCH+CyQWFt1ZNgMG5uWlVh8JTTYpsPBLoU2CapKlROSGhbN/TQKPCkFJhJc
	RM6v+QmoSXoKYtsMZjfRycA5h9tF3kQuk/0NfZSoquclrzP1p5W6DCQJrkT0elTE
	+r+uOcfkf9TVOF3CaCZYOyZG7z5c4OB+DZWPrl5K/vQoareFsDhN95n52s54W2Y8
	ITATfJqRCBQif69tYdIOhLQdLm/AtU1Ry+1G+0HGD+qz5ANR0vxlhe/zYPtcNjmW
	grD5AYsUfw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwr5wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 13:51:42 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 589DXsZO012161;
	Tue, 9 Sep 2025 13:51:42 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwr5w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 13:51:42 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589Akiww010594;
	Tue, 9 Sep 2025 13:51:41 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910smubjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 13:51:41 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589DpddP39125646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 13:51:39 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69D2A5805C;
	Tue,  9 Sep 2025 13:51:39 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0B6E5805E;
	Tue,  9 Sep 2025 13:51:38 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 13:51:38 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 09 Sep 2025 15:51:38 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Milan Broz <gmazyland@gmail.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
        Mikulas Patocka
 <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com,
        snitzer@kernel.org
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <bd535ddb-b9b0-4404-81ba-4e6f526429d5@gmail.com>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <3184e0b1-571f-4cf7-94ef-acca41c12b02@gmail.com>
 <b01c92bd-e00a-4c8f-803b-20d6a7db2ec3@linux.ibm.com>
 <bd535ddb-b9b0-4404-81ba-4e6f526429d5@gmail.com>
Message-ID: <76c330493c036317755838d2dfce2de0@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CTaeZ2wjvzPeZ_nslAMQjLgzHr9zWQE5
X-Proofpoint-ORIG-GUID: u44EgnCjlO9z-E7DEMigR8nXvpDrMOgV
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c030ee cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=4HVZ629U5ZEAqiYOUDsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX1D97KX8YwMVj
 LHFH4j1WZVIqv+2kwrrS6TqXSDTuAGFf9th35HIo3jSHm06KfSjxrAsNG00BGy24NUJrg4W8bAn
 5bkwTdBpaEiRS7kfvnpltsOAdXFfk3ZTLqLZ42wc5y0jbPRw/r507T+6LwNjEGvOgiWLm/Fj2Nn
 y2htBqozqmM6DZfG/0Ww8+JQ1trsA7aQMUpWWTzvVjCYOFYgPANihKEq623Qjh8+BmN4JLcmsLe
 IQC6NOLw+sieVWYUQxDeZVT8fJZD+3hyicr8mcEgMlZwiefTNcSyi9cuqsyOauXVdCiHO0lAH5o
 wHMmY6CPvaVL0gZaU1jEQfMdvAiJxc1DCwk7eMvgmptsU2D5b60mkelOk1Y1gGMM0bbvGm14ZXL
 MwNbnDK/
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

On 2025-09-09 14:15, Milan Broz wrote:
> On 9/9/25 1:50 PM, Ingo Franzki wrote:
>> On 09.09.2025 13:47, Milan Broz wrote:
>>> On 9/9/25 1:18 PM, Ingo Franzki wrote:
>>>>> Please, revert my patches and run the same test on a clean 
>>>>> 6.17.0-rc5 just
>>>>> to verify that the patches do not introduce the bug.
>>>> 
>>>> With your patches reverted the combined mode fails the same way as 
>>>> with your patches.
>>>> So they did not introduce the bug.
>>> 
>>> Please report it as cryptsetup issue with a reproducer so we can 
>>> later check it.
>> 
>> I don't think its a cryptsetup bug, its rather that dm-crypt is 
>> missing something to deal with async HMAC ciphers.
>> The point is that PHMAC is a async-only cipher, with no sync variant.
> 
> I know, but there is no tracker for dm-crypt and what I like to have
> some kind of upstream CI testing for PHMAC/PAES
> even without mainframe hw (we already talked about a fake cipher 
> module).

Let me think about this a bit... You are suggesting a test kernel module 
for
e.g. x64 which acts like the phmac/paes implementation in a asynchronous 
way.
I'll discuss this with Ingo.

> 
> It is not an real issue as PHMAC is neither in released kernel nor in
> cryptsetup yet, but we should have a test
> coverage once it is merged.
> 
> On the other side, the async thing is a real pain, is there any plan
> to switch to something better in future
> (for dm-crypt and dm-integrity)?
> 

Well, as of now all the s390 pkey things are by nature asynchronous. 
Which
means at any time the key may get invalid. It is in the end a hardware 
backed
key and thus if the hardware is changed (for example a 'live' guest 
migration)
the key runs invalid and needs to be re-derived or re-fetched. I don't 
see a
way to hide this and have a synchronous implementation instead.

I think on the contrary the need for asynchronous algorithms will 
increase.
More and more platforms run virtual machines which exploit special 
hardware
like AI accelerators and crypto co-processors and do support live guest 
migration.

Well, that's future. However, it would be nice to have at least one 
asynchronous
algorithm implementation available on a broad platform like x64 or arm 
maybe only
for test of the dm-integrity layer.

> Thanks,
> Milan
