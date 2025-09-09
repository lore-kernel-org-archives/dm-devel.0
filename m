Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C2D54764
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416725; cv=none; b=hYZ+U1wqn1k04Yuawo4Jtarw9nvPiljwZKbg8lYH0GtOoj3EuSymGSt34h5q7OSGSIwql/+mHiySpicLJRqW7ce+y54OSqzMQ7imXyKf2Jy3RsuoXGwExk1qLMxKvoy3zdyN9UErQnsOGbnjKmFhPxn4oIcj9BUdrLZrvfa2h10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416725; c=relaxed/simple;
	bh=oNpmNIZrapUKVj8KRX1+lpJxJgbw5ZMc1yL4cZJ77wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SKdIzebXD/33L4WJ1Il+oCelBlfMgHNBQkbzPzS8BT1DjLo2pCGO1MVr7yH2roG1tRTKemqE9GsLwSWFUQBQhiwmU3rRIdcqPjQ2zrqx/bMg92xyuWPQERn7ZY0JJ6BLIGTODYAk/RQxO8KuvhYRbWJ6Hv7Y1lp7e08/lfvgL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gCsVd/22; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gCsVd/22"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5899OqSV007665;
	Tue, 9 Sep 2025 11:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hrspfh
	nOseUaB3gANwQz0/HN3voraup9Go1axrcqm4I=; b=gCsVd/2280MAGBlpSonsOY
	2t5jbXrVb7ADeQGB80+00gJqk8ktXJKLiUC0IfOejwhwn02+l2jAGgSRr1myXik4
	VAW+RisgPZ31W6yeE4p16T7jdo3s0T/DOqIDrlbgrv2hc7o74I8S4Q60cFu4pTEY
	kk08viKpu98pS87FGUJhM1UVCbYFrgstA3Bcy/CfIxkP9zVriVHp/Kz4xhO2ntfA
	wutdExL6sxhxByx+IpKAYSDSroFwUz4OP6/j9vz9w2jyhIhF9/2sXus/6x8qW+Cy
	94OG0ZDjb1Gyp5LHFJgfDeeOti93troBo28qWI2mRPrbJNGWVU804nJ13+b6C2hg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycv6pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:18:37 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 589B5W6H019976;
	Tue, 9 Sep 2025 11:18:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycv6pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:18:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5899fwKd020495;
	Tue, 9 Sep 2025 11:18:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp0txdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:18:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589BIVDJ20971936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 11:18:31 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9FAB20040;
	Tue,  9 Sep 2025 11:18:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DCA720049;
	Tue,  9 Sep 2025 11:18:31 +0000 (GMT)
Received: from [9.111.198.175] (unknown [9.111.198.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 11:18:31 +0000 (GMT)
Message-ID: <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
Date: Tue, 9 Sep 2025 13:18:31 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
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
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EZHg3_dkJJBQM695PsrUjnzxXiAGcccl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX8wJnLtoBi9wD
 vlnt2HAf59EQIV/+pq6QCXLiugrwaoxCmg6Kb9lRLEEmDPzaeZv3U7+9CAemK/HjJFVBII2feF5
 hzTGu/jQOlCX5fH/mF1UrWrsNUV5G5FGrTnx239/zMz7jNNQqojvJF2U5422fhq33ZPwXd3o4r1
 8bhQc/yIf0a+GbamwIHLMTGWwarHYuKymMcZbutp1DxIGl1Dd89BjuOPE/EeJQ1Ni7RnXqD6hqc
 k9RNo3OgQzPRmjx0++20xTLNwd0mLCja8/yPvRdxQ0pFD018GST+Ysl3uuK1/Gv9DJIwvWPEL4Z
 Hmmp+GqsliHWEn4aGdR62QlJFxYkXj270t6yC3yfEvp3HmAu6CKKHhzKNsr7zyqTebQ+KmGcgYy
 mW1xlsdu
X-Proofpoint-GUID: lb_4rkQSB5M3xYKzZZuFZylbEVACLhS6
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c00d0d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=6HZ4xBWJqg8YpoXi22EA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235

On 09.09.2025 11:42, Mikulas Patocka wrote:
> 
> 
> On Tue, 9 Sep 2025, Ingo Franzki wrote:
> 
>> However, combined encryption and integrity seems to have problems. Not 
>> sure if this is related to your changes in dm-integrity, or if there is 
>> still something missing in dm-crypt, or the interface between the two:
>>
>> I did:
>>
>> # cryptsetup luksFormat --type luks2 --master-key-file '<key-file>' 
>> --key-size <size-of-encryption-key-in-bits> --cipher paes-xts-plain64 
>> --pbkdf argon2i --pbkdf-memory 32 --pbkdf-force-iterations 4 --integrity 
>> phmac-sha256 --integrity-key-size <size-of-integrity-key-in-bits> 
>> /dev/loop0
>>
>> # cryptsetup luksOpen /dev/loop0 int-loop
>>
>> The open step succeeds, but the following errors are shown in the journal:
>>
>> Sep 09 04:54:50 fedora kernel: crypt_convert_block_aead: 12 callbacks suppressed
>> Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
>> Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
>> Sep 09 04:54:50 fedora kernel: buffer_io_error: 3 callbacks suppressed
>> Sep 09 04:54:50 fedora kernel: Buffer I/O error on dev dm-1, logical block 43872, async page read
>> Sep 09 04:54:50 fedora 55-scsi-sg3_id.rules[2378]: WARNING: SCSI device dm-1 has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules
> 
> In this mode, the encryption, decryption and authentication is done by 
> dm-crypt, not dm-integrity. dm-integrity just passes the tags around.
> 
> So, it looks like a dm-crypt bug.
> 
> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just 
> to verify that the patches do not introduce the bug.

With your patches reverted the combined mode fails the same way as with your patches.
So they did not introduce the bug.

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
