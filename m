Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1C21FBCA7
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757408692; cv=none; b=b8pT6AwRey0Iec13zFwyFHITItBDWDIoKEkXYgfkZQsPOwtApHJXnAQ8Ifctego2RILwN2ILYA7ccwDs1WfWIGgii+uzn/8frm02CdZV7JRwy4xOj80EHUSznH79Jw1ZBrms0NpYYMko4oqLioHGJMTRzn3rrZAW0s+oiguEIJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757408692; c=relaxed/simple;
	bh=zAmqUSZN7bVLeRF1WGMqBONRBG3tiPVvzZzObnF1esU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ICcgcm1rmMq0SLn3+aXLbz1+rsGjGGCyX9a/Y0Txf6NA44TKNnkyio9zuBxGhGMCT2MQcIyR+1pbgVGFB26bSdJ+ag3phsHozmGU4LqOBCSfeQcud2rfLHq75C3lI269LdLmUI0c84QGuQpv6iy4A8fJ4E6ioQvbcOnRmPL2nHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sVy19qPO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sVy19qPO"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5898uKjL024343;
	Tue, 9 Sep 2025 09:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aAExC1
	OParrU29A+nn+jVvvcz8pd8/kUh5CPZM28KF4=; b=sVy19qPOBV9+1iSWIdXnMr
	YCYyYfPeeE+a4qQu75IWr4uevyEpRq4ZUyL3aMWl+KtXvItHN5fgyMG7NTLdsK3p
	AcoqA6jsakMObhSMd7Koh9asViG+BdojNU2ayuvUrclJqfufjg7SHcu4w9vOYaER
	wkJApo9elHXvtXPgYJHEvA8fPhqHTH06zFNYQpEXrPyZvjK5pr9PtYSup/pWnfTW
	arnMQc0HZBP4FCTtYcFRe5AJXTbFoXb9EcrF9DiCzcIaRa0XncbBGNYcoDNA/3oj
	fAPbYNlj8gIluso+Zmgg8LGL692fHVvq1PiDRZLNXWEVuF2+DFsCNd6nnz6urhqw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukebv7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:04:42 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5898nD34032269;
	Tue, 9 Sep 2025 09:04:42 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukebv77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:04:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5896C6Zv020469;
	Tue, 9 Sep 2025 09:04:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp0tekh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:04:41 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58994btE18678222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:04:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AB2420049;
	Tue,  9 Sep 2025 09:04:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EB7E20040;
	Tue,  9 Sep 2025 09:04:37 +0000 (GMT)
Received: from [9.111.198.175] (unknown [9.111.198.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:04:37 +0000 (GMT)
Message-ID: <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
Date: Tue, 9 Sep 2025 11:04:37 +0200
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
        snitzer@kernel.org, gmazyland@gmail.com,
        Milan Broz <gmazyland@gmail.com>
References: <20250908131642.385445532@debian4.vm>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20250908131642.385445532@debian4.vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX54DPeltgMNXw
 Va84cDn6PoYwgtzHS+YhI9sP6Z+BZj270J0YncYPBaQL2//76v8eEGMh5JG70dn9JM+YK5byN6t
 apgiiXaEyLKb77nA9TYWraB+w73eI9N8Foj8xUWyYbtSlzGOGv7pSQQab7PZQSSpc4Fr840/tW9
 8kF/7KWn74hMR2GIc1Kik9WzByG9n4bZ6++BOqDOeeV1mWS9MEGTAImLNDbjWJCV4HkQpBwv0Y8
 IF23CUsygW72A0rahgCxdMvJgwiW+CnGSOA+uti1zEjY7DdBKMVeUy2IzZdvZ7Tbf09J+AK5mLT
 Q06/0CRkPQzBuZ7lHQZipyucJFEiLStMmhrzn3gmyZNpy+5p7bGKiE6fzyAagYRSOejydVb1vqu
 j4o3THd9
X-Proofpoint-ORIG-GUID: _UAuvqZzhzGr4aUl5IMWYfxz4lHuyBQM
X-Proofpoint-GUID: RthWEl9-Q7QoZV5lgwznMj5TZgHNhBB6
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68bfedaa cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=WaEvsw5kbN_QaESDcgAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On 08.09.2025 15:16, Mikulas Patocka wrote:
> Hi
> 
> These patches add asynchronous hash support to dm-integrity.
> 
> Harald, please test them, I will commit them if they work for you.
> 
> Mikulas
> 

I have started to test your patches in top of 6.17.0-rc5.
I am testing 2 scenarios:
1.) plain dm-integrity using PHMAC.
2.) combined encryption and integrity (LUKS2 with integrity option) using PHMAC (and PAES).

Plain dm-integrity using PHMAC seems to work fine. No errors occurred, but I certainly have not stress-teted it.
I did:
# integritysetup format --integrity phmac-sha256 --integrity-key-file '<key-file>' --integrity-key-size <size-of-key> /dev/loop0
# integritysetup open --integrity phmac-sha256 --integrity-key-file '<key-file>' --integrity-key-size <size-of-key> /dev/loop0
# mkfs.ext4 /dev/mapper/int-loop
# mount /dev/mapper/int-loop /mnt
- read/write data to/from /mnt

All works fine.

However, combined encryption and integrity seems to have problems. Not sure if this is related to your changes in dm-integrity, or if there is still something missing in dm-crypt, or the interface between the two:
I did:

# cryptsetup luksFormat --type luks2 --master-key-file '<key-file>' --key-size <size-of-encryption-key-in-bits> --cipher paes-xts-plain64 --pbkdf argon2i --pbkdf-memory 32 --pbkdf-force-iterations 4 --integrity phmac-sha256 --integrity-key-size <size-of-integrity-key-in-bits> /dev/loop0
# cryptsetup luksOpen /dev/loop0 int-loop

The open step succeeds, but the following errors are shown in the journal:

Sep 09 04:54:50 fedora kernel: crypt_convert_block_aead: 12 callbacks suppressed
Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
Sep 09 04:54:50 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
Sep 09 04:54:50 fedora kernel: buffer_io_error: 3 callbacks suppressed
Sep 09 04:54:50 fedora kernel: Buffer I/O error on dev dm-1, logical block 43872, async page read
Sep 09 04:54:50 fedora 55-scsi-sg3_id.rules[2378]: WARNING: SCSI device dm-1 has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules

Still, the mapper devices are there as expected:

# ll /dev/mapper/
total 0
crw------- 1 root root 10, 236 Sep  9 04:26 control
lrwxrwxrwx 1 root root       7 Sep  9 04:54 int-loop -> ../dm-1
lrwxrwxrwx 1 root root       7 Sep  9 04:54 int-loop_dif -> ../dm-0


# lsblk
NAME           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0            7:0    0   200M  0 loop
└─int-loop_dif 251:0    0 171.4M  0 crypt
  └─int-loop   251:1    0 171.4M  0 crypt

However, when making a file system on int-loop it fails:

# mkfs.ext4 /dev/mapper/int-loop
mke2fs 1.47.0 (5-Feb-2023)
Warning: could not erase sector 2: Input/output error
Creating filesystem with 175564 1k blocks and 43824 inodes
Filesystem UUID: 4a6d4579-0b58-4be7-aa67-1f76e4e754b7
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729

Allocating group tables: done
Warning: could not read block 0: Input/output error
Warning: could not erase sector 0: Input/output error
Writing inode tables: done
ext2fs_write_inode_full: Input/output error while writing reserved inodes


And the following messages appear on the journal:

Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 350976
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 43872, async page read
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: trusted_key: device-mapper: crypt: dm-0: INTEGRITY AEAD ERROR, sector 0
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora kernel: Buffer I/O error on dev dm-1, logical block 0, async page read
Sep 09 04:56:14 fedora 55-scsi-sg3_id.rules[2399]: WARNING: SCSI device dm-1 has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules

This does not really look good.


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
