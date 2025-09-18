Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0191C862F
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207634; cv=none; b=tjcp+rIiie0/E+jTwRWJl/Yfj96UWZULbYmYZ8hVr9v7snTT+zTF8Xnj4Yjh9FHCRVmx2m+zaHRXDAl0DDzvH+bP9HzVouInYOYo4Dl9geGwAWpWa4L06EV+/7hfqc4sqAo6tGZU9ZqcyWVPjsbSI+/2yWSgYvLsdjMnq8kHREY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207634; c=relaxed/simple;
	bh=FzP3gkHMGzBvkEbKfpzc9rf3NIDcsgVrFAGq2oFflTg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=RVf9IRx0lEip6mKyfd8jUbSkROYgGjwFAUMmrWE/EL+eIY6hAwKrqFtcd07rM2eo4HjzPpyT7ovc0PKO4M/7gqVxMRReugg5c42pa6PBAr3/ck5dz+JpYIz3OMvMmpu+46OrcnpGCsREeYzfz1Zct4BkWemXIr8IQZYlQ4LFIec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ivSeMbGf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ivSeMbGf"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7pI7I024719;
	Thu, 18 Sep 2025 15:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:reply-to:subject:to; s=pp1; bh=0/v79/ZrASxPC7p4VmMAq
	otH30rWg0h+3d7qa+CQpO8=; b=ivSeMbGf4J0gS/bk4Xjn+MDsCTaAqUSBdEOeS
	qSE6clbYfFifPX1H8B5gUlHMFsUlo7vCerxwkzEo6qbaP0mqtrG1wtcrVtt/OIQQ
	B4NRThSOfcXahlV/cleOR/U9F9iFCzTi0GavFjWcGVS4KK8AvFkukIgjQENpO6uk
	KWjCYkITqSnbrHFprposWC2t8Rv0vvuyxugBASkaVpJ7UsL83UFNKgj144pwvvLu
	SR4VdiSJX8h2XfDf6MN16MSQ7V7pNYkRjuNTDQygBeNmc5ZE72vKhf+s4uu10hGp
	TUbAIf5880ShXEvtakVc8ugsRAjNdrCas+M5c74iFEogKYH1w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qtgq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 15:00:18 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58IEp8XR029930;
	Thu, 18 Sep 2025 15:00:17 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qtgpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 15:00:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58IEeekL018637;
	Thu, 18 Sep 2025 15:00:17 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mpyp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 15:00:17 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58IF0FVI19071582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 15:00:16 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC1DF58054;
	Thu, 18 Sep 2025 15:00:15 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF55958068;
	Thu, 18 Sep 2025 15:00:14 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Sep 2025 15:00:14 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 18 Sep 2025 17:00:14 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric
 Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com,
        snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
Message-ID: <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: multipart/mixed;
 boundary="=_309fc60c81f6ca24e96f2701ad59d373"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YHOn3-nYdT9OBbSGK7Zq0oJlVe74qyoO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX+4HCXWuDa7qY
 BSYEGYBFmhdhB7OeIKt/Xu3bnAwqVzRUM/nw8ERtOO7uRdkpMI7DyqD44sBeBODWjEe8dhfmhEv
 fqLRR/iRfvKd+UqD+PEzWraBAtIBG/EB0IlABAWipWkA9+GK12dxG2nklzXphBhp0X8+WM/R/U3
 V8+u4+HMLY5WRhxPT5CEWyzYf8AfRfsG0ILm3+/yPj8PWOiscZsV9eQkEAZ6sMD1J54feTHe0kN
 g0UDFb5i6B2vuQZ/TbcS6z31hJq3QGzCHKPWukE9Ogv3yiNn7WxY+Qz1EudxsyWQOeMq18k0fxT
 s14pfiD4SumvvUFqDCzFWqq6Xr2mPEEaw5KgGGjWSSNwEjcJTauq0P6HZtpgHDx4+kQ7gggqGZd
 2HqL2WYY
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cc1e83 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=JtCyTSfHbpdswSVfQJYA:9 a=CjuIK1q_8ugA:10
 a=OgBtn7W-ondEbE5FY2oA:9 a=49ladYHvHUoA:10 a=mpd-woop7mMA:10
X-Proofpoint-GUID: 9gwXgtxXANiNL2ixyrSdYGyYupOoSIq9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

--=_309fc60c81f6ca24e96f2701ad59d373
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

On 2025-09-11 17:58, Mikulas Patocka wrote:
> On Thu, 11 Sep 2025, Ingo Franzki wrote:
> 
>> >> So, it looks like a dm-crypt bug.
>> >>
>> >> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just
>> >> to verify that the patches do not introduce the bug.
>> >
>> > With your patches reverted the combined mode fails the same way as with your patches.
>> > So they did not introduce the bug.
>> 
>> Mikulas, do you have any idea what could be causing this errors?
>> Is it that dm-crypt is not properly dealing with async-only HMAC 
>> ciphers?
>> Async-only encryption ciphers seem to work fine in dm-crypt, since 
>> LUKS with PAES (but no integrity) works fine, and PAES is an 
>> async-onky cipher.
>> LUKS with sync-HMAC ciphers (e.g. clear key HMAC) also works fine, 
>> even in combination with PAES.
> 
> Yes, I think that it's a problem with async HMAC. The bug is probably
> either in dm-crypt or in the crypto library.
> 
> Do you have some other (non-dm-crypt-related) workload that uses the
> async authentication, so that we can determine whether the bug is in
> dm-crypt or crypto?
> 
> Otherwise, would it be possible to give us a virtual machine on the
> mainframe to debug this issue?
> 
> Mikulas

So here is now an out-of-tree kernel module build which offers a pseudo 
phmac-sha256
for testing and debugging purpose. In the end this is just a asynch 
(ahash) wrapper
around the hmac-sha256 shash crypto subsystem implementation. It should 
compile and
be usable on all platforms (s390, x64, arm, ...).

I ran dm-integrity tests with this and all worked fine. Ingo ran 
dm-crypt tests
where he combined aes-cbc encryption with phmac-sha256 integrity and saw 
hangs
on cryptsetup open. He also reported that these issues are different to 
what he
saw with the 'real' phmac in combination with aes encryption. A short 
glimpse gives
me the impression that there is a job blocking the system's workqueue. 
However, I
could not find any indication that the pseudo phmac is not working 
properly.

For instructions on how to build and use the module see the README in 
the tgz archive.

Thanks to all
Harald Freudenberger



--=_309fc60c81f6ca24e96f2701ad59d373
Content-Transfer-Encoding: base64
Content-Type: application/gzip;
 name=pseudo_phmac.tgz
Content-Disposition: attachment;
 filename=pseudo_phmac.tgz;
 size=3902

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
VVmVVVmVVVmVVVmVVfmTlf8Au8riNgBQAAA=
--=_309fc60c81f6ca24e96f2701ad59d373--

