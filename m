Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD92F3C2B
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 09:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757928390; cv=none; b=rKLfKKtuxAis1T1CkJ6DpYc3wBFhYIW7iF3el3N0U4xozn2CzL0wa2eZeqJCJlclEgSL4ULph6bMzJjtbiUHz0WSHxORlsGeF95Kc3WZC5o1NwQ5hQK4SxGnuvQJJ5AgGFIQ3eEooVgzXPI5JOcJC8JosrotaeDupXGoOwJ2ICM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757928390; c=relaxed/simple;
	bh=IOQIp4N6SHHFZVwJDFDEohmmexDoxgKEkLnOFFgcGHw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TSWRd9WFPoQwonnNta2hPR0m3F1EHTzKrt9l2WEP/WnTObeEf0zAZbDpzHWPmA/xwmzv8oPK2yZ942LsGLx/U320lTnWGuZY/rNBl5XYgv+YI/ab5u4scVPdCRcYyYVsy2yKLSlr5PLMARkn0niukAJOrULOB4u3/J6oS3sUkKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hM/lDGLh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hM/lDGLh"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F60IYB023508;
	Mon, 15 Sep 2025 09:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=VOy+EgFY09Elc3H9CqUHhHvprlZQYgViyrR6QFP455U=; b=hM/lDGLh4esK
	TMk9P8+nFWNROQyabSM//D6OR4iCzxOJy6I7QIKmvbpiHqOpbeScthc6nKz2tCPV
	su8187zRuZjsE7x1MMQyETTG7hFr76c2hnNnJ+LI1jAcMMIlindckH6VJ6qNfAjG
	LhSbJDreVgZeBPFGc4vMacryKuw8spStKlNy/cRSJTSMFRH2lq+fiEkLnhG95piL
	D+NnzLaJDqjK0pvpoA8Zt85bPVb4V/G6CfzFPOiWSzN20r91T1DB7NlVBgU6F5ji
	+mlTO9yjpiR11JeN5j6ovEiDNLHA2E5ylAQsBGMqYoA3bgEh5A4sJ1wmjFIAzMyr
	fM7X6nPopg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1t99yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 09:26:21 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58F9Hvgv021987;
	Mon, 15 Sep 2025 09:26:20 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1t99ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 09:26:20 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6W3jU005935;
	Mon, 15 Sep 2025 09:26:19 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxtwv0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 09:26:19 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58F9QHxw28049984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 09:26:18 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B837758065;
	Mon, 15 Sep 2025 09:26:17 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 267F558056;
	Mon, 15 Sep 2025 09:26:17 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 09:26:17 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 15 Sep 2025 11:26:16 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
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
In-Reply-To: <88984b74-19c5-4e86-a4f6-0c8ef91cf4df@linux.ibm.com>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
 <88984b74-19c5-4e86-a4f6-0c8ef91cf4df@linux.ibm.com>
Message-ID: <8660bfcbe617c8f49cdd17d58e21040a@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c7dbbd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=pd5FQHo6G-gV790HS4EA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 2kkaSR8pMKeMVRsscmyCTfXaCgwfHWh_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX3KKl0ShwMQE4
 /a7WGPVfKnMzE1hZXsbf7NDlLqRebjmr+xQ7gz6j1FN0Sxkn09c6v9mP59qNx2u/OmirjrKw8RB
 s6daWWJoRIwL2khRcYSeKinNdNDv3N0NQ08kc7AZbT1MGspwt9lJ4tpSDaOsRApqteCjysgzUrs
 hqOMjIHIN/i62d1EdWVXJR13qIwksAg7BWc0RKkv2QFAV0M4do+Ixc+7dDmfZ4cSugE3R97/0GO
 Ao1wJWLfOMOOpxDfcSTF+O5TC3+KuXYRreQZ7uiJy50h8aepqyxDVqg2btZoaWQTilZ8Mk9TNPG
 SwMgyNN1/i3Z85gsyatcy0Tma21X/jWhJUF153oTYHiu7tbDH8g+ealFVIY2lYsbtRldnkgCOhA
 py8/06l2
X-Proofpoint-GUID: iI6bAUjpBPIqkz6hSV0cGKCCACdFW-kh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_03,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001

On 2025-09-12 10:08, Ingo Franzki wrote:
> On 11.09.2025 17:58, Mikulas Patocka wrote:
>> 
>> 
>> On Thu, 11 Sep 2025, Ingo Franzki wrote:
>> 
>>>>> So, it looks like a dm-crypt bug.
>>>>> 
>>>>> Please, revert my patches and run the same test on a clean 
>>>>> 6.17.0-rc5 just
>>>>> to verify that the patches do not introduce the bug.
>>>> 
>>>> With your patches reverted the combined mode fails the same way as 
>>>> with your patches.
>>>> So they did not introduce the bug.
>>> 
>>> Mikulas, do you have any idea what could be causing this errors?
>>> Is it that dm-crypt is not properly dealing with async-only HMAC 
>>> ciphers?
>>> Async-only encryption ciphers seem to work fine in dm-crypt, since 
>>> LUKS with PAES (but no integrity) works fine, and PAES is an 
>>> async-onky cipher.
>>> LUKS with sync-HMAC ciphers (e.g. clear key HMAC) also works fine, 
>>> even in combination with PAES.
>> 
>> Yes, I think that it's a problem with async HMAC. The bug is probably
>> either in dm-crypt or in the crypto library.
>> 
>> Do you have some other (non-dm-crypt-related) workload that uses the
>> async authentication, so that we can determine whether the bug is in
>> dm-crypt or crypto?
> 
> Well, dm-integrity can use PHMAC and this works (with you patches) as
> confirmed in this mail thread.
> I don't think we have other non-dm-crypt or non-dm-integrity related 
> workload.
> We could probably come up with a test program using AF_ALG that uses 
> PHMAC.
> @Harald: Do you possibly have such already?
> 

I do have. But still it only runs on a s390 platform. And for the qemu 
s390
emulation - all the cpacf stuff is not covered. I think the better 
approach
is really some kind of a pseudo module which offers some pseudo phmac 
for
x64. Let me see how this can be done.

>> 
>> Otherwise, would it be possible to give us a virtual machine on the
>> mainframe to debug this issue?
> 
> @Harald: What do you think, could this be possible?

Hm - I have my doubts that this is possible.

> 
>> 
>> Mikulas
>> 
