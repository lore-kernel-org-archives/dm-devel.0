Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C5335BA2
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598242; cv=none; b=mduzEfTPE35tnB/jklC+ixHvTDo/IPP9fr4D7FIjzkAY5sE+7yRCtK99Qe3Ns6aFlrXp8GyUwSbNTkEP3pUfB9ND0SVDSPSwAkWIDEfo5e58pKHzIGmJmNZOjS44HaqbpHxDks7i7KvS6DZ5j64tuOhUQDzmy1zZDeQn+9hrxV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598242; c=relaxed/simple;
	bh=JwT5x7C/wPCh4WYFTS0hM/K1yAiCVR07guogwlkZ92w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tIBjd7q08AftfdiP5zsvH3jsEYZVLWH7Z7vThdd6eAp0ZR6wOGDD7HRn8Q+liMzs5VM2kGg9wkH5F6/zTuRURaW8DhQL45z8ibXLZ8gpCXflRn4ymbx/t/TkiWf7cyWvxye6/vECNqSE3GYdVeMH3TeLKk+15xqiPY622Xx+8aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k3f2kvQV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k3f2kvQV"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDQWSH029522;
	Thu, 11 Sep 2025 13:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VTm8IX
	hyW5jfcdDPPGYgCJ0f/Z1VJi4U0B7+MWRUy1E=; b=k3f2kvQVpWVfIZM9ZIgRa8
	bb5o8dQljd05/3K8rX0uW3HQLrtgH9Ffw8/WjmsLm4GRuqjQgyqLHwibAFcB8XE8
	v9beO7O+Mnf8BD7OTSjCF+dbuOP5Wv1yI4RJVIVZCTnMjcqsPPBFl7WzxqA3e8Z5
	yPlk3d4pxbUxdRxmZZraWrHKCoHgZAhKfCFgQPWggGNBWHW5ZEOYsewMkBszcb0X
	c/mR7XYdfiMnGiAxps275PbbR/BrJ5DQvXvyw8wrVUj+203hloywVnn+xuRSe5mA
	jqtG9Ui7wGkzMTC5uJZ0qj/eWZKgdI01FGoEAIbjlMTXJ+0UwVtCsrCPHOGwNmBg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukespbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:43:52 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58BDhpmo010997;
	Thu, 11 Sep 2025 13:43:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukespbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:43:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDIEcB007965;
	Thu, 11 Sep 2025 13:43:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109px273-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:43:50 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BDhlIZ44892588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 13:43:47 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29D4620043;
	Thu, 11 Sep 2025 13:43:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E98D520040;
	Thu, 11 Sep 2025 13:43:46 +0000 (GMT)
Received: from [9.152.222.171] (unknown [9.152.222.171])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 13:43:46 +0000 (GMT)
Message-ID: <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
Date: Thu, 11 Sep 2025 15:43:48 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
From: Ingo Franzki <ifranzki@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, agk@redhat.com,
        snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX6nonVTPfY8Fr
 oNVkUa5zFRIkRw4+1Zhl4eO8pvFz8fGbhdcGfAvxFq5aL53IBhARB1seLGCdowZHffSyO4nkVOg
 MH9myPw0NC8rGlMK67DGIO6Fh/M5JNpDcOwRarusu/TkBJVCGbk+aHC36bibXdZurZ1oZPNLEdY
 puvhllu12zprCHcDgvoUUCmPXNzTSmOGL+3KVIeWmk2HuQYl4c5Q648bqfaPTTRe21emyHpxmS1
 4kgDe8ef1W5vQ4i5TKLYh43OMWEMsAjdR97JTWOQUMs0ibJlI05o/RXuXztYzqR29DRAzu8Ch7I
 sBpCkm+OfTQgRhZ2xaUNyMRH+ro2LN4qbZ/Ei/vtNHqVC1FxPVGotCfiWzlnaStz1h920h1qudS
 3NAxrV3z
X-Proofpoint-ORIG-GUID: JQt5ptMFCNPSMesyvCjxuRHfyGC3Fegb
X-Proofpoint-GUID: AW7zYFci1Q9icBaLCBeO02FkBDM41MAd
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c2d218 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=EqtPgdm2cdwaLoSOvQsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On 09.09.2025 13:18, Ingo Franzki wrote:
> On 09.09.2025 11:42, Mikulas Patocka wrote:
>>
>>
>> On Tue, 9 Sep 2025, Ingo Franzki wrote:
>>
>>> However, combined encryption and integrity seems to have problems. Not 
>>> sure if this is related to your changes in dm-integrity, or if there is 
>>> still something missing in dm-crypt, or the interface between the two:
>>>
>>> I did:
>>>
>>> # cryptsetup luksFormat --type luks2 --master-key-file '<key-file>' 
>>> --key-size <size-of-encryption-key-in-bits> --cipher paes-xts-plain64 
>>> --pbkdf argon2i --pbkdf-memory 32 --pbkdf-force-iterations 4 --integrity 
>>> phmac-sha256 --integrity-key-size <size-of-integrity-key-in-bits> 
>>> /dev/loop0
>>>
>>> # cryptsetup luksOpen /dev/loop0 int-loop
>>>
>>> The open step succeeds, but the following errors are shown in the journal:
>>>
>>> Sep 09 04:54:50 fedora kernel: crypt_convert_block_aead: 12 callbacks suppressed
>>> Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
>>> Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
>>> Sep 09 04:54:50 fedora kernel: buffer_io_error: 3 callbacks suppressed
>>> Sep 09 04:54:50 fedora kernel: Buffer I/O error on dev dm-1, logical block 43872, async page read
>>> Sep 09 04:54:50 fedora 55-scsi-sg3_id.rules[2378]: WARNING: SCSI device dm-1 has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules
>>
>> In this mode, the encryption, decryption and authentication is done by 
>> dm-crypt, not dm-integrity. dm-integrity just passes the tags around.
>>
>> So, it looks like a dm-crypt bug.
>>
>> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just 
>> to verify that the patches do not introduce the bug.
> 
> With your patches reverted the combined mode fails the same way as with your patches.
> So they did not introduce the bug.

Mikulas, do you have any idea what could be causing this errors? 
Is it that dm-crypt is not properly dealing with async-only HMAC ciphers? 
Async-only encryption ciphers seem to work fine in dm-crypt, since LUKS with PAES (but no integrity) works fine, and PAES is an async-onky cipher.
LUKS with sync-HMAC ciphers (e.g. clear key HMAC) also works fine, even in combination with PAES.

> 
>>
>> Mikulas
>>
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
