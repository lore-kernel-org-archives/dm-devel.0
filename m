Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6581B78F3
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 12:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757420617; cv=none; b=NWmhuEn3fJNpS59vnZe6y2R2CMxHZ+zHaqeRBdEJFSlp9AuulNVeVE3vCbeR0grU86CxeOHkukJ4IcMfDUU57zJqvsL55O9QMbZWy6z15s1kICZkwYzh/zPScwxsP2xhs2OINBP4L6n+agol0FxOQfuulhijLjGmY5Q//DYpksI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757420617; c=relaxed/simple;
	bh=zGnT0eFUfvHSwHDHvx2LpEActPR2SiS9cB7SgAFQOfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bNFilsVPosPqUgIQmmrbs8Ze7MklgKTIYjgaiwzweEkd2ITBXKXW1AM/5Zh03NdITdR/5YTrWj09fC5NWcoOT6/SmVoA6QBQNo3k5Qvstp0mPiBciiMiBcxyCI9f9EKe+lwhPrGkckVlgT3ATTzXCkI1WZw8F+2FNrMsLQ2qHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rr0YJszH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rr0YJszH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897LIDw003430;
	Tue, 9 Sep 2025 12:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VoSNAp
	ZfodZlqOXUp6Mw4s/XmFClAnSIhYBF38KW4XU=; b=rr0YJszHfrEqw1Kr9u9x6e
	XUngOWivrDliUwWohVp+Jkwu1yTxF2y8yTC9XEMMsTC96XIpxlZiZZ7jGnSG6c2i
	W5cmPViZxxJj0HWCOt8/TonXoMGHgFzTSp/SUD0cB4F4NGSWc8XzqMeXVeGhyhOg
	D3NeII24AwQbjR6NjlOQ+PCyAMIpFvEmm6pNg9p3jLicRjVz7KBEuuKVyYG66i0a
	Mzrhkfmy86u7i6/R/hMfEP6E72LicKOB+wKEr1aiQIt1MPukD7qM1uCR7vwAmyv/
	WEBdtGVNDHvab9X1SauNL+H15fV3c3u4jS4Qq7H/+D7RuL5rwfNxnuzpGDhbVyHQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cff7qb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 12:23:32 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 589CL5al013285;
	Tue, 9 Sep 2025 12:23:31 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cff7qb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 12:23:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589B0C4T017188;
	Tue, 9 Sep 2025 12:23:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmav2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 12:23:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589CNRja50594074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 12:23:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6C5520049;
	Tue,  9 Sep 2025 12:23:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB1DA20040;
	Tue,  9 Sep 2025 12:23:26 +0000 (GMT)
Received: from [9.111.198.175] (unknown [9.111.198.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 12:23:26 +0000 (GMT)
Message-ID: <3b506db5-1e6d-4ef8-a6a3-1b0db334d4b3@linux.ibm.com>
Date: Tue, 9 Sep 2025 14:23:26 +0200
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
 <b01c92bd-e00a-4c8f-803b-20d6a7db2ec3@linux.ibm.com>
 <bd535ddb-b9b0-4404-81ba-4e6f526429d5@gmail.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <bd535ddb-b9b0-4404-81ba-4e6f526429d5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gb8r6OO6bGyIOfSqruh-DCzHY4R0j0Ph
X-Proofpoint-GUID: yyu5z9o6YHgQVEMZ4TFsu99eEvKuXu5i
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c01c44 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=wor8Pe01KD7PdYA9PYQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX/3dwOrGk+y4e
 OHeb5+XFJyyUdHjErl+sR3mvn44g4GBsC/eEYTB9QTKZ+JyBz6puCMYxyCj+76cc+wxi1GeaK4b
 uLeEl0Ef/3jR/oGioFaxlKrQbpmsPXCRYY0zZApU3AD4RjnMx6n6LOdsM9bdkMEY2t0q56nzxTv
 aXHu6xwIOU4YRbQnapzuGh/3bw2siUgBTmXPTvgCJI9PzE4zxb0ehgZvSkncHwkjlkgzo4RnYgH
 q3yiOHPHMOS2oAszn/Y7VD3CMVXezwMyCAGD76oAZqUR5JZZAHV37HpAtjQOcQ4wQsq2QhrBXWB
 ftDoyRmr5VSYDhdvNELcbdbbhuffF8ZNJd3P3HHdiTAHrKe/nTdrPWEGfZMS+X/RjbN6vYHZIpz
 crpY1gQb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020

On 09.09.2025 14:15, Milan Broz wrote:
> On 9/9/25 1:50 PM, Ingo Franzki wrote:
>> On 09.09.2025 13:47, Milan Broz wrote:
>>> On 9/9/25 1:18 PM, Ingo Franzki wrote:
>>>>> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just
>>>>> to verify that the patches do not introduce the bug.
>>>>
>>>> With your patches reverted the combined mode fails the same way as with your patches.
>>>> So they did not introduce the bug.
>>>
>>> Please report it as cryptsetup issue with a reproducer so we can later check it.
>>
>> I don't think its a cryptsetup bug, its rather that dm-crypt is missing something to deal with async HMAC ciphers.
>> The point is that PHMAC is a async-only cipher, with no sync variant.
> 
> I know, but there is no tracker for dm-crypt and what I like to have some kind of upstream CI testing for PHMAC/PAES
> even without mainframe hw (we already talked about a fake cipher module).
> 
> It is not an real issue as PHMAC is neither in released kernel nor in cryptsetup yet, but we should have a test
> coverage once it is merged.

The fake-PHMAC cipher you use for cryptsetup's CI is not async-only, so you won't see this error with it.

> 
> On the other side, the async thing is a real pain, is there any plan to switch to something better in future
> (for dm-crypt and dm-integrity)?
> 
> Thanks,
> Milan
> 
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
