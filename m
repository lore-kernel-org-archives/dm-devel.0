Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363B41991B6
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 12:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496864; cv=none; b=MgvHHauaiX0zXOvahL2F9WUxdIt0mPcEKFL2dDRxM9FVXppDJ3EvB9QVC7x4duhWJYQRnAZUDz7AcwHStMf++kPkQG6HBpItlYggWGg7pqdC/VnvT0zpmSytiXOn6QXZ8+EPvYmupZb5rfN6eP077P4C4qg8hun+VEPgQsrPDp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496864; c=relaxed/simple;
	bh=gLlxaBFAjAXm8IAoonxaRI3yf3e97ScXgTzdsSqiLPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TVT9yz70osUC0IJ1ZUJLUvua7ODOzwJeFAvlhuXv/htR4A7Zbvm8vxBXTzKQGJ8D6n8v3ROLfb73BJBXOU4V+z6KJYKaWw6HPFnl1zzHWM7DuIrZZbKDZcurieGE/sg/AIdNyxmlx0eAUaZCcHz5IqBXvE6bapOghVpAK5SL3tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iE198p78; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iE198p78"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E7Mdxg012723;
	Mon, 14 Jul 2025 12:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gLlxaB
	FAjAXm8IAoonxaRI3yf3e97ScXgTzdsSqiLPs=; b=iE198p78QtElS8A55QtzyG
	FcU6dBQZxTvmxbawfEhPOTRl3FSeo/AdQcO6VnAnoZAVHS96E9FVnJNoTxeGnEya
	zttQHGQgTYnxKdvNyLTS5OVoPupramSYdilBUnJXbuyu/uJpYnyupy+kmnsUkKfK
	iamhzvE8WzjJ24UMBHzWxrRGlae9Xs9sOMWLoSmd6QqXpWXo3O7u3Qjr6tscIfjV
	vfUJh6p6ihVzNI98mphwqGXDUmlkWyB9ah4K8/Z6i02ysSYKsA8+TN7V+LvU1PI7
	9CfMdPhEFixa96QJhcuZqlJW9tWWTVjB6MCDmRmtH0XIvXh+eOfbYrwY8lC7UrOA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ufeesprd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:40:58 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56ECWvkN029228;
	Mon, 14 Jul 2025 12:40:57 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ufeespr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:40:57 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56E8VxbY031904;
	Mon, 14 Jul 2025 12:40:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47v21tx3nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:40:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56ECeq5J48890148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 12:40:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F2AA20043;
	Mon, 14 Jul 2025 12:40:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A531920040;
	Mon, 14 Jul 2025 12:40:51 +0000 (GMT)
Received: from [9.111.33.153] (unknown [9.111.33.153])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Jul 2025 12:40:51 +0000 (GMT)
Message-ID: <22ddcdeb-7cd3-4d26-9ac7-25570ac0fef3@linux.ibm.com>
Date: Mon, 14 Jul 2025 14:40:51 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] multipath-tools: fix default blacklist of s390 devices
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>,
        Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        S390-ML <linux-s390@vger.kernel.org>,
        DM-DEVEL-ML <dm-devel@lists.linux.dev>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
Content-Language: en-US
From: Stefan Haberland <sth@linux.ibm.com>
In-Reply-To: <20250712201454.215404-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDA3MiBTYWx0ZWRfXxLO55zMArkbp EXsmPa0mIx3PB9wFOM9vG8d6Yk+5BjAuGoWyzM75G9XNrBftxVwkIgCQSdWjajN+M5KpBBGes+U 45ANSAmwzH8jLR3WQrxOQPgaUAQj9O6HEqnHavPkXve+oiTuYvCgAXPznCpAbqLiHWRfqshVw95
 9Tb/uBt1noYL/+Wl41XMvnmCRGpr7U/2NmqKa0CP/Q28qxKzvqgCSyrH5OfiwoQwPTLNcx/MZCJ OtLk2/6RooCeJa0jDpBauYaDTHzOSEEt+3STSl2z3fPFsF317dkJWUYHOrM+ErFSJspnQBlmY2M 2H+B87Aq4ropkzLpN+vhmzfyrG779P8ihgt9GUj7l32CQZzOgPqpxGjVIq4/4NUn/A84ejbEMUY
 sCQvletfVGAXx7x4Ak6uDMK2d2BHTmHQCC1BgLVcHfpSp2j3lk5Rh8nK7g4IkqVAUdevzc5q
X-Proofpoint-ORIG-GUID: LyUoVM0SW5z_bPzjpsXEZmV6mG3qrilt
X-Authority-Analysis: v=2.4 cv=C9/pyRP+ c=1 sm=1 tr=0 ts=6874fada cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=NEAV23lmAAAA:8 a=VnNF1IyMAAAA:8 a=G0_B3m8xAAAA:8 a=3Up_VBsHAAAA:8 a=iox4zFpeAAAA:8
 a=20KFwNOVAAAA:8 a=J4EkDXhdAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=9iZY6TRnBY2AT0LN0igA:9 a=QEXdDO2ut3YA:10 a=gBgTPrObzSPeouD7eQ2s:22 a=p-kn8v_atdPrL5O0KNWa:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=XV5PuULvsUy3P8kbSbK6:22
X-Proofpoint-GUID: U6Uam8mJM5UTNDjbX0aOmTfLxmS4s1TU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 clxscore=1011
 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507140072


Am 12.07.25 um 22:14 schrieb Xose Vazquez Perez:
> Each blacklist only their own devices.
>
> Cc: Stefan Haberland <sth@linux.ibm.com>
> Cc: Nigel Hislop <hislop_nigel@emc.com>
> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: S390-ML <linux-s390@vger.kernel.org>
> Cc: DM-DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> DASD devices been blacklisted twice, since:
> https://github.com/opensvc/multipath-tools/commit/a6ff4f957c78bd15c49278ad359671a705eaf4b5
> In the current code:
> https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56ebf44c8f0ee60b8/libmultipath/blacklist.c#L233
> ---

Reviewed-by: Stefan Haberland <sth@linux.ibm.com>

