Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D65C1B1D5C
	for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 07:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724226530; cv=none; b=K0gRZqYiQfrttZTlmT181g+wlBSfuk5Mdw1mJfxIFiiy5ytQ4/eqcd0XEGrztJIVNrg6dntsyZ75S+rks9PNM5cQs6A/Ov/ZhhibZMNujU/2XxijdmqVWghEFuA1kjiwQXtXvDjJYG5D7qHY2IIoH3B++gYOCSOGsOAhayiM2qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724226530; c=relaxed/simple;
	bh=krN/SC7Chn2yHaMdn7tn0BwKUYoFzAz0sfTybmvJtV4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G8yRPgtjG1tPx80KJoHeTIJMnbf1QrbrPPEjUGaT0Y7Tvpyez3gDNpnri9363fzPpi7LYZwmsrEXBrdHj21zyk0fmxS8P4Ar4CvGQNNpwbuq5z902ToEdQp459+XpfEOMC2+zfsa+uqrUBwRSDEtQcRE6lHgp/AfB8QFOT/xffg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dNtTuP8x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dNtTuP8x"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L10adC001446;
	Wed, 21 Aug 2024 07:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	qMbK/yyA/LXki1AQE6D1/Xtb5YS0snsHvhJ/5RVpHKk=; b=dNtTuP8xCLsyW/4q
	hIkkfJKNY+XswVECTD6qUnOmU0gC0GM/d+ldftMf4IA2Ah4IUadSc8EESxYVe1Qq
	tsbBjcjDZpTQoZcphLp5UxxczbhTxoQZhcEc8YIsF5krbAcEoDFQChfLv8zoPwZl
	YQlOXRgCg+8b85EfqTl1IiTlNqcdYZ7bi8WVqIrPuXEpwY2BW7iLItug3VP2pSaC
	l2+CAN1KUKOq4EF5iw5Xv8/8lEX1HK4HHuDdQUPIax0kW0XtPx+ySU9EltoOF7b9
	H1LrWBKmAZglmyMQf3lDZn67qPcfwPeL768dF4FFuEocbEW8lpjXLSudSmsbqHIH
	DZAvMg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 412mbg0wte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Aug 2024 07:48:40 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47L7meNK024008;
	Wed, 21 Aug 2024 07:48:40 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 412mbg0wtc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Aug 2024 07:48:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 47L6bV5Q017698;
	Wed, 21 Aug 2024 07:48:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4138w36cct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Aug 2024 07:48:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47L7mZZv59048206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Aug 2024 07:48:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8C162004D;
	Wed, 21 Aug 2024 07:48:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB29F20040;
	Wed, 21 Aug 2024 07:48:35 +0000 (GMT)
Received: from [9.171.168.28] (unknown [9.171.168.28])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Aug 2024 07:48:35 +0000 (GMT)
Message-ID: <5d1ae9a8-67cd-4787-9faf-2151f6b0fa4f@linux.ibm.com>
Date: Wed, 21 Aug 2024 09:48:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: Allow to specify the integrity key size as
 option
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org,
        gmazyland@gmail.com
References: <20240816112133.2100537-1-ifranzki@linux.ibm.com>
 <d75574e8-a829-0f48-2a99-8d79b0fdfb00@redhat.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <d75574e8-a829-0f48-2a99-8d79b0fdfb00@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HMNwtQJNJh_bGBetq8vX8x4AJXXxC--F
X-Proofpoint-ORIG-GUID: MGSud0LntUJ8Zm4V13vzSjstkPtnQny7
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
 definitions=2024-08-21_07,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408210050

On 20.08.2024 17:56, Mikulas Patocka wrote:
> 
> 
> On Fri, 16 Aug 2024, Ingo Franzki wrote:
> 
>> For the MAC based integrity operation, the integrity key size (i.e.
>> key_mac_size) is currently set to the digest size of the used digest.
>>
>> For wrapped key HMAC algorithms, the key size is independent of the
>> cryptographic key size. So there is no known size of the mac key in
>> such cases. The desired key size can optionally be specified as argument
>> when the dm-crypt device is configured via 'integrity_key_size:%u'.
>> If no integrity_key_size argument is specified, the mac key size
>> is still set to the digest size, as before.
>>
>> Increase version number to 1.28.0 so that support for the new
>> argument can be detected by user space (i.e. cryptsetup).
> 
> Hi
> 
> I know you already discussed it with Milan. I'd like to ask, what's the 
> reason for this patch? Milan said that you need it for mainframes - 
> please, describe the specific configuration when this patch is needed.
> 
> Mikulas

Hi Mikulas,

thanks for looking into this.

In short: Yes, we need it for a new function on Linux on IBM Z platform (aka s390x), but the general concept of using wrapped keys is not limited to that platform but can be used by other platforms as well. Furthermore, the proposed change can also be beneficial for clear key HMAC integrity protection, to allow choosing the size of the integrity key.

As a little background:

Quite some time ago I worked with Milan to add support for using HSM (Hardware Security Module) protected keys (or in general wrapped keys) with dm-crypt and cryptsetup.

HSM protected keys are keys that are wrapped (i.e. encrypted) by an HSM master key. This increases security because such keys can only be used with the proper HSM being available, and the clear key values of such keys are never revealed in clear outside of the HSM. LUKS does a very good job in protecting the volume keys, but once the volume has been opened the key appears in clear in kernel memory. When using HSM protected keys, only the wrapped key appears in memory, but never the clear key value. 

Such HSM protected keys usually have a physical size that is much larger than a clear key. We usually speak about a key blob here, because only the HSM really understands how to use that key blob, for anything outside of the HSM it is just an opaque key blob. The point is, that the physical size of such HSM protected keys are not directly related to the cryptographic size of the key they contain.

For the Linux on IBM Z platform (aka s390x) we provide a special kernel cipher named 'PAES' that implements the AES algorithm but takes such HSM protected key blobs as argument. While this works transparently with dm-crypt, it needed some changes in the cprytpsetup tooling, because cryptsetup assumed that the physical size of a key relates directly to its cryptographic size, which is not true for such HSM protected keys. Milan was so kind to make the required changes back then in cryptsetup to make this work. 

So, with this, one can now setup an encrypted disk using plain or LUKS2 by specifying a cipher like 'paes-xts-plain64' to benefit from the added security of HSM protected keys. If you like, you can read more about this here: https://public.dhe.ibm.com/software/dw/linux390/docu/l5n3dc04.pdf 


Reasons for the proposed change in dm-crypt: 

We now want to provide a similar functionality for integrity protected volumes. Similar to PAES, we provide a kernel HMAC cipher named 'PHMAC' that implements the HMAC algorithm but takes HSM protected key blobs as argument. So, one would use a cipher like 'phmac-sha256' to setup an integrity protected disk to benefit from the added security of HSM protected keys.

The use of such HSM protected HMAC keys work transparently with the dm-integrity target (only needs some changes in the user space tooling). However, there is also the combined encrypt and integrity protection capability of dm-crypt, either using HMAC or AEAD. We focus on HMAC based integrity protection here. And for that, we do need the proposed change in dm-crypt.

In case of combined encryption and HMAC based integrity, dm-crypt gets a single key blob and needs to split it into two parts. The first part is the encryption key, the second part is the integrity key. Currently, dm-crypt assumes that the size of the integrity key part is the digest-size of the HMAC algorithm. With this, the integrity key size is known, and the 2nd part of the key blob can be split off and used as integrity key. The remaining first part is used as encryption key. 

While with this logic, the encryption key can already be an opaque key blob (i.e. a HSM protected key blob) of any length, the integrity key part can not, because its size is assumed to be directly related to the HAMC digest used. 

To support opaque integrity key blobs as well, the size of the integrity key must be passed to dm-crypt from user space. This needs changes in the cryptsetup tool as well, I am working with Milan on this. If an integrity key size is specified in the dm-crypt parameters, it uses that size to split the key into the 2 parts, otherwise it uses the digest size as before.

With this, both, the encryption key as well as the integrity key can then be opaque HSM protected key blobs of arbitrary sizes. 
So one can use a command like the following to format a encrypted and integrity protected volume using HSM protected keys:

# cryptsetup luksFormat --type luks2 --master-key-file <volume-key> --key-size <encrypt-key-size-in-bits> --cipher paes-xts-plain64 --integrity phmac-sha256 <device>


As mentioned above, the proposed change is not directly related to a specific platform, although Linux on IBM Z (s390x) is the first to exploit this. It could be utilized by any platform for wrapped key ciphers. It can also be used for clear key HMAC integrity when one wants to use an HMAC key size that is different from the digest size. 


I hope this answers your questions. 

Kind regards, Ingo


[snip]


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
