Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E255FBBA
	for <dm-devel@lists.linux.dev>; Fri, 23 Aug 2024 07:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724398023; cv=none; b=ci1EkAt9WtYHrr5YeKTTuyiThAkOCKNekIwGzv6Hxz3Kv1J2KECBd6Q0+c2XWxxwHN2ruIyYkE8d3ynEC0CSbGPhBRfBmvni+mlrtL2hWvzUUlY+YyTPA+g5qUS2egr2E2MzQ1XLtFeMzDilJ6B3kCug4wlXM9xGlxjbMTBdDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724398023; c=relaxed/simple;
	bh=ATGGberMd7bVhuaVObjf2skA9k1eTN+zR5RFAbfVLbU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uweP2aJ1ieRFmnHrWHst92dqDQFUGHpVaETztMPdKA1SSDP/AGRxdTegwuU5Kc/tpK0jS5nLzBNx9ioRM/329syNZVHbIB8Sv5zjnIFyxyj/fgZB3dCFDGFZAECY1cq4AqAV1GE7PHFj/cc0ZKiY8jvBbNwbf/RhVhU1Kq6lh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RaljX9q3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RaljX9q3"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N5wmau014700;
	Fri, 23 Aug 2024 07:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	w/tYqoSIifI7NOeERHQBCiDFnJm29qCiBNUals8a3AI=; b=RaljX9q31nEc/QHy
	5WqGK+O8ZnY1Wwb/0e6lMRkI/8Zuam4FtzMEVXmJY/ZTD2W15PdM4g9OrM0LY92E
	fbGhlhI7FUDRxI47mgoyvOh3IaE61czWma9Nikvv6009i0wC/PGP483YH3hH0ska
	THH/M6afQLm5fuuUu/burTcunnqJh/bk7bsSDCEeexPHLHWNRUaI3AqN7lWHn1q4
	qhChe8hboyIq/PP6Tt/fqYf6LpCut1MD63wL8SdlClMZKT6IGtANf/SkKN04xa2K
	cnD1ORLF7GH0Y1eYAokrvv0Lx2u9VKblHmd9gakH8QlIdH47v69k+ISDC93LCOVV
	N5smDg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 412mcytvdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 07:26:55 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47N7Qto6025762;
	Fri, 23 Aug 2024 07:26:55 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 412mcytvds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 07:26:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 47N6Ctx0002215;
	Fri, 23 Aug 2024 07:26:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4136k10x30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 07:26:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47N7Qokp55443712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 07:26:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD47420063;
	Fri, 23 Aug 2024 07:26:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 963612005A;
	Fri, 23 Aug 2024 07:26:50 +0000 (GMT)
Received: from [9.171.139.164] (unknown [9.171.139.164])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 Aug 2024 07:26:50 +0000 (GMT)
Message-ID: <b16f93d6-9d4b-421b-98de-e07f0fe67086@linux.ibm.com>
Date: Fri, 23 Aug 2024 09:26:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: Allow to specify the integrity key size as
 option
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org,
        gmazyland@gmail.com
References: <20240816112133.2100537-1-ifranzki@linux.ibm.com>
 <d75574e8-a829-0f48-2a99-8d79b0fdfb00@redhat.com>
 <5d1ae9a8-67cd-4787-9faf-2151f6b0fa4f@linux.ibm.com>
 <4a5bb6f7-0ef8-eee9-21f3-3885923d9c21@redhat.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <4a5bb6f7-0ef8-eee9-21f3-3885923d9c21@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R4iVx0AxXVYo0bu3wYMPxfh0ZpCj58PC
X-Proofpoint-GUID: CKkB3K9JI9Twd58fLsskuCaz290QBvpX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_04,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408230049

On 22.08.2024 18:21, Mikulas Patocka wrote:
> 
> 
> On Wed, 21 Aug 2024, Ingo Franzki wrote:
> 
>> On 20.08.2024 17:56, Mikulas Patocka wrote:
>>>
>>>
>>> On Fri, 16 Aug 2024, Ingo Franzki wrote:
>>>
>>>> For the MAC based integrity operation, the integrity key size (i.e.
>>>> key_mac_size) is currently set to the digest size of the used digest.
>>>>
>>>> For wrapped key HMAC algorithms, the key size is independent of the
>>>> cryptographic key size. So there is no known size of the mac key in
>>>> such cases. The desired key size can optionally be specified as argument
>>>> when the dm-crypt device is configured via 'integrity_key_size:%u'.
>>>> If no integrity_key_size argument is specified, the mac key size
>>>> is still set to the digest size, as before.
>>>>
>>>> Increase version number to 1.28.0 so that support for the new
>>>> argument can be detected by user space (i.e. cryptsetup).
>>>
>>> Hi
>>>
>>> I know you already discussed it with Milan. I'd like to ask, what's the 
>>> reason for this patch? Milan said that you need it for mainframes - 
>>> please, describe the specific configuration when this patch is needed.
>>>
>>> Mikulas
>>
>> Hi Mikulas,
>>
>> thanks for looking into this.
>>
>> In short: Yes, we need it for a new function on Linux on IBM Z platform 
>> (aka s390x), but the general concept of using wrapped keys is not 
>> limited to that platform but can be used by other platforms as well. 
>> Furthermore, the proposed change can also be beneficial for clear key 
>> HMAC integrity protection, to allow choosing the size of the integrity 
>> key.
> 
> Hi
> 
> Thanks for the explanation. I discussed it with Milan and we concluded 
> that the patch is OK and that we can stage it for the kernel 6.12.
> 
> I added the patch to the device mapper repository. You can get it from 
> "git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git", 
> checkout branch "remotes/origin/dm-6.12".
> 
> I fixed two bugs in the patch:
> 1. crypt_status must report the new argument in its table line
> 2. sscanf(opt_string, "integrity_key_size:%u"...) should really be 
>    sscanf(opt_string, "integrity_key_size:%u%c"...), so that we report 
>    syntax error if there are trailing characters after the number.
> 
> Please, download the updated patch from the "linux-dm.git" repository and 
> test it.

Thanks for fixing these bugs. They all make very much sense. 

I have downloaded the patch from https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.12&id=4441686b24a1d7acf9834ca95864d67e3f97666a and tested it successfully on my system. Works great. 'dmsetup table' now also shows the 'integrity_key_size' option. 

@Milan: I noticed that now that dm-crypt also reports the integrity_key_size param in the status query, I need to also support that in my cryptsetup changes (i.e. in function _dm_target_query_crypt() in lib/libdevmapper.c). With this additional change, luksFormat and friends work fine with the updated dm-crypt module.

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
