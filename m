Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9811369B4
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565239; cv=none; b=fMt9gi+cEZHj6U3q1Wem1HYLM7Cb/g6GEfg7uyqEOKpafgc/52Zuzp8znEG4h2NnDePgBEtm2VPQgr5IFqmXkA4nY0woKXXaEN81hbEsSHsKi1zXco5cg6z9yayxPxBGhOe/wHH6oCyKhu6cSkIQUCUNdEpjURr5VSRE9XH/2BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565239; c=relaxed/simple;
	bh=h67XZZ5BeVjdu7Js8a+o4Yi06Tufx+fnexA9XMWw2A8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=QSas7jAbBfH5U+1cCF9a6b/69DnlqV01FzUaa08OlCm4UnM83Is7uZhcqvzVgSNA4cEiGq2zGc+KQ5RtsfXtlrODDNUZn0TgyZRsB7bt2MT5N1WIcR9eGTt3c8xhF0BSq5f0izzl+xGOhBTxf5YlRSHpvSsmILmahHBXF6zl2Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PFpgrJwv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PFpgrJwv"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50MFdXR7016933;
	Wed, 22 Jan 2025 17:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=W4gP+K9F4UCt2y9K/DfO4yUbHfb1rdpjakUW3NTjSAk=; b=PFpgrJwv8Ty+
	YaQvlhZ5eQequO9wqNl3R77FY+Me1bvW/5ygIG+G9sqGSSSWRZ1HpE2xVahwt7ZS
	04FUvD9ud2ZYhMmQXZ1wMrK0aP93Pt44acE8VDDRCEMuxaXDbF4Knu94JXQr6oma
	oOL0qlWeva05+9nXtZQwYrZt6wmvaG5u7s8jRkrgfdI8A3L2s0wFrG2I8I8iiUjM
	XV0ASBvai2uVe0S/ZYfbXZ/Z7VmaPxvD3St1CtgeAG4n5Bt+/Yn7oF/bfKdjvKCa
	A0id8zqlgQm4ssP5idggA+z8D0o4VFRapJOo0IjmPre51ROK/qi/cgktJN4egKLe
	Q63MaAjb/A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtrdj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 17:00:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50MFfvjK021063;
	Wed, 22 Jan 2025 17:00:28 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1h0um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 17:00:28 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50MH0RnS30015892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 17:00:27 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BE6758055;
	Wed, 22 Jan 2025 17:00:27 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2CDB58043;
	Wed, 22 Jan 2025 17:00:26 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jan 2025 17:00:26 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 22 Jan 2025 18:00:26 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <b541f1bb-5287-7600-77ce-ceed5903e554@redhat.com>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <b541f1bb-5287-7600-77ce-ceed5903e554@redhat.com>
Message-ID: <5a8a09387c0fef59629707937297a0a4@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6pT4E4ijpoetzdmAQo9Ih1EsjWTK3p-b
X-Proofpoint-GUID: 6pT4E4ijpoetzdmAQo9Ih1EsjWTK3p-b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_07,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxlogscore=720 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501220125

On 2025-01-15 18:29, Mikulas Patocka wrote:
> Hi
> 
> The ahash interface is slower than the shash interface for synchronous
> implementations, so the patch is basically slowing down the common 
> case.
> See the upstream commit b76ad8844234bd0d394105d7d784cd05f1bf269a for an
> explanation in dm-verity.
> 
> Do you have some benchmark that shows how much does it help on s390x? 
> So,
> that we can evaluate whether the added complexity is worth the 
> performance
> improvement or not.
> 
> Mikulas
> 
> ...

Hi Mikulas,

So finally some benchmarks measured on my development system:
A LPAR on a z16 with 16 CPUs, 32G memory, with a fresh build linux 
6.13.0-rc7
kernel with and without just my dm-integrity ahash patch.

For the dm-integrity format measurements I used a 16G file located in 
tempfs
as the backing file for a loopback device. The backing file totally 
written
with random data from /dev/urandom. The dm-integrity format command was

   integritysetup format /dev/loop0 --integrity <alg> --sector-size 4096

6.13.0-rc7 with dm-integrity using shash:

sha256		Finished, time 00m09s,   15 GiB written, speed   1.8 GiB/s
hmac-sha256	Finished, time 00m09s,   15 GiB written, speed   1.7 GiB/s

6.13.0-rc7 with dm-integrity with my ahash patch:

sha256	       Finished, time 00m09s,   15 GiB written, speed   1.7 GiB/s
hmac-sha256    Finished, time 00m09s,   15 GiB written, speed   1.6 
GiB/s

In practice the read and write performance may be of more importance. I 
set
up a 8G file located in tempfs as the backing file for a loopback device 
and
dm-integrity formatted and opened it. Then I created a random file with 
4G
via dd if=/dev/urandom which was located in tempfs. For the write I used

   dd if=<myrandomfile> of=/dev/mapper/<dm-inintegrity-name> 
oflag=direct,sync bs=4096 count=1M

to copy the 4G random into the dm-crypt-block device.
For the read I used

   dd if=/dev/mapper/<dm-inintegrity-name> of=/dev/null iflag=direct,sync 
bs=4096 count=1M

to copy 4G from the dm-crypt-block device to /dev/null.

6.13.0-rc7 with dm-integrity using shash:

sha256
   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 45.5 s, 94.4 MB/s
   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 19.2137 s, 224 MB/s
hmac-sha256
   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 45.2026 s, 95.0 MB/s
   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 19.2082 s, 224 MB/s

6.13.0-rc7 with dm-integrity with my ahash patch:

sha256
   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.5273 s, 103 MB/s
   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 16.2558 s, 264 MB/s
hmac-sha256
   WRITE: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 44.063 s, 97.5 MB/s
   READ: 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 16.5381 s, 260 MB/s

I checked these results several times. They vary but always the 
dm-integrity
with the ahash patch gives the better figures. I ran some measurements 
with
an isolated cpu and used this cpu to pin the format or the dd task to 
this
cpu. Pinning is not a good idea as very much of the work is done via 
workqueues
in dm-integrity and so the communication overhead between the cpus 
increases.
However, I would have expected a slight penalty with the ahash patch 
like
it is to see with the dm-integrity format but read and write seem to 
benefit
from this simple ahash patch. It would be very interesting how a real 
asynch
implementation of dm-integrity really performs.

If someone is interested, I can share my scripts for these measurements.

Harald Freudenberger
