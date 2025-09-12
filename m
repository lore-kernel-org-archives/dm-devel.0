Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0CC1FBC92
	for <dm-devel@lists.linux.dev>; Fri, 12 Sep 2025 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757664509; cv=none; b=Kl2s1UhTHT602iuHCDRdE+rd38IBPoKtDGFCjWLrBNrqes6BbNjT7lt6uvC0xedVQJGlEPtmp7DEI026x8uaJdIiqN7czrZh6sWE6CoXzR+PfZHqjFhrY6Zz84cufNaWjYEHBRFy2mT6N0ncuaAqwEuhXUcuOCOgNWK/Myw0Opw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757664509; c=relaxed/simple;
	bh=s5EhtBLd8sSI1h4jBHBiJUPG5/5OMr9gAnYIBXvKxgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9oaRDHBBHOqYioHyD21D7GlM4WB0MSeYekoSRM85CKqSPoNEtnRoqFNTYyf7fqTnkFr5k4VELSrT3KDhmUj0MfZEoBsefGop+a2uvF0d05puntylRD4MDF/qiaKzgJ4yHRZhK4Tqghuzz12E5ncllXdQeJE2kkrpQYpkApkhpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gE8e6pX6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gE8e6pX6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C3GVQA017175;
	Fri, 12 Sep 2025 08:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6khb2W
	m5Be+GuvBITt/WR7/CN9zxjPmUPbh+efW077o=; b=gE8e6pX6Osy1kpo39hzqJm
	Uqg1h9f3SWE78IX+y+czJ2aF0rOcQ9YSE4oJ0RXQ8p5ASUQQOHY68UjfEUkIFaWC
	clhQnAcO70dEaX59EfGUx73jxK7/NybtukBm6k+NJzNc6du8fa+vfsD809BO+lZx
	Vx0eVy0NnMP0kSPs5XdSuoAJK1FHktnJUUW1BxcnU1rOnxl68uiFi02iTGnjvscl
	GS1UPXDuGxpNSVZauI+9WIVVA8XozG8P8IcA64jh+girGSsnJCThDysrOvTBmh4f
	fe99bowan2G8Lqd5Jz06Cxdv7n4ZjbmCm9D++D9/39H0t1XVmFpMqrPD3sAUixJQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bct8vqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 08:08:22 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58C7vslh015971;
	Fri, 12 Sep 2025 08:08:21 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bct8vqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 08:08:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58C5mkqd020492;
	Fri, 12 Sep 2025 08:08:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp1a2mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 08:08:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58C88H0N57606578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 08:08:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F003420040;
	Fri, 12 Sep 2025 08:08:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5AEC2004B;
	Fri, 12 Sep 2025 08:08:16 +0000 (GMT)
Received: from [9.111.136.59] (unknown [9.111.136.59])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Sep 2025 08:08:16 +0000 (GMT)
Message-ID: <88984b74-19c5-4e86-a4f6-0c8ef91cf4df@linux.ibm.com>
Date: Fri, 12 Sep 2025 10:08:16 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
To: Mikulas Patocka <mpatocka@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com,
        snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX3xnW6AZ6+gjV
 +bbz9MlLJ43iE0IA4WqD2+15qXBqRVQruCTMHOKLinCqB2IRDvOiRHlzlP6PPIbmNCbhA0kN7GO
 0BV4smWx9QFJsdjJG5uxRCUaIB81liQMe4Raxj+XSLhmTwRUFO8RcLQTHtZCEV6cCAts6mrg4XR
 e6VhZuN+lA3MRGzjVp+AJWhGEPZ0o4qB12ec9Tc21/TelRluvRHPCDO2nWgejllHIYA/DsoQw+Z
 8/OTYWVXe9KnoFB0Ls7TUuAmr4k3QpWpMgBl+/OSpLc4r35rNK91GezyWU6B+4C/Y9dXneRnmqZ
 wNtRJVvlneFW2q8nqVlrXI+3uCOBHUvmhQ2D36ZBQdWbIHqJ6lWWT65ajgO4wZAXm7PbjhybnC0
 1HHMhz3M
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c3d4f6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=gJglsiLFuNdxA89ab8cA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 19ECPnHVogpQcwm5yl866Ie9ExqY9lmH
X-Proofpoint-ORIG-GUID: v9UEWhE7__rmbS9Bu5EJXQrAVa7QaGFR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_02,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

On 11.09.2025 17:58, Mikulas Patocka wrote:
> 
> 
> On Thu, 11 Sep 2025, Ingo Franzki wrote:
> 
>>>> So, it looks like a dm-crypt bug.
>>>>
>>>> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just 
>>>> to verify that the patches do not introduce the bug.
>>>
>>> With your patches reverted the combined mode fails the same way as with your patches.
>>> So they did not introduce the bug.
>>
>> Mikulas, do you have any idea what could be causing this errors? 
>> Is it that dm-crypt is not properly dealing with async-only HMAC ciphers? 
>> Async-only encryption ciphers seem to work fine in dm-crypt, since LUKS with PAES (but no integrity) works fine, and PAES is an async-onky cipher.
>> LUKS with sync-HMAC ciphers (e.g. clear key HMAC) also works fine, even in combination with PAES.
> 
> Yes, I think that it's a problem with async HMAC. The bug is probably 
> either in dm-crypt or in the crypto library.
> 
> Do you have some other (non-dm-crypt-related) workload that uses the 
> async authentication, so that we can determine whether the bug is in 
> dm-crypt or crypto?

Well, dm-integrity can use PHMAC and this works (with you patches) as confirmed in this mail thread.
I don't think we have other non-dm-crypt or non-dm-integrity related workload.
We could probably come up with a test program using AF_ALG that uses PHMAC.
@Harald: Do you possibly have such already? 

> 
> Otherwise, would it be possible to give us a virtual machine on the 
> mainframe to debug this issue?

@Harald: What do you think, could this be possible? 

> 
> Mikulas
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
