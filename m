Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC481248894
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 12:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496730; cv=none; b=FThpaCKnCDLT09j91ZYOA4lQEH9Ok0h/YzGMGy/KsGaVFyQxjlBv3KBJq0MiWOH+SIy2dkva/MsEu/rwXqyJSTxVI1u94hHdRn+GlmBtURNTtG+gdHtXbSxDQFeNuKv8CUMx38Q9LOGuKV91xySGgGgtFBGgzESN3MBBuXRZmyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496730; c=relaxed/simple;
	bh=6Q7hmrtCpT4S6lQIX3WPUDwZXcyFDHCsex0+PnKME8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TD6YTZEzP2JX47oEoBaLH3tklLntJNjpPx5p9282fAeUlq+O1xZHijBsMNQnYZoSMpCwS4/fHsn8gklk4YukqQJojnwjX1ZFzuVrhvXZ9WLXfS3u4VOo0kJ8tTL/0FaUKlVTUxDmsfiPYF8wWqLUxIfGPtm5MNEaUsouB5ybwyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IJ6ntx5j; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IJ6ntx5j"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E9U9Dm021452;
	Mon, 14 Jul 2025 12:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6Q7hmr
	tCpT4S6lQIX3WPUDwZXcyFDHCsex0+PnKME8I=; b=IJ6ntx5jfA59OmlKsemJyf
	7HQxM65yEKTa0wJVye33xg/vwSROA+QogTQDr7eDgek/5Ra8itkKHp4HnA/Wlcbm
	6Z6qg8QXwruuILk60TJHIR5qK/wA6MhfVlHP/kWfPhVFtuRgIDVGx8PIuk8yAh3T
	TPuVheEUIhK8TZj7QpyhwkgCZO3TLqFxFgUhEgiKW4ppb3UDjcLr//5Q0UM485n+
	tBpDT3AvWRLhCerg5HcF+jxlPYlCD+YOxDlfpwxplRXfm1WmpfBYOvdxemwsQIj/
	qZiXc6slYmCZvcRd5sAtTqyBqt5MEGWNiueIVrSar2nqg12BJ9oYcfqcWmf7SGXQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47vamtmwkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:38:45 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56ECOuaC011592;
	Mon, 14 Jul 2025 12:38:45 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47vamtmwke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:38:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56EAXlKX000733;
	Mon, 14 Jul 2025 12:38:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 47v48kwnf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:38:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56ECceiw23724674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 12:38:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9063820040;
	Mon, 14 Jul 2025 12:38:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0340F2004D;
	Mon, 14 Jul 2025 12:38:40 +0000 (GMT)
Received: from [9.111.33.153] (unknown [9.111.33.153])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Jul 2025 12:38:39 +0000 (GMT)
Message-ID: <d5e08375-211d-405b-9a00-f44c857cedac@linux.ibm.com>
Date: Mon, 14 Jul 2025 14:38:39 +0200
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
        DM-DEVEL-ML
 <dm-devel@lists.linux.dev>,
        Nigel Hislop <hislop_nigel@dell.com>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
 <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
Content-Language: en-US
From: Stefan Haberland <sth@linux.ibm.com>
In-Reply-To: <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0RKsPZfdmyXRgMYgJkmfK6irQp8gD7cc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDA3MiBTYWx0ZWRfXxwZALbx34sIY OwvQEWLF+1mAp0c8cUtZl4Nxx48MNZGBSFTvZsJU+Co6sp8J7V82bhdiIBRNhlwKpM79mI9UmHe C5M+6O1i7dUL3Q4BK+jj500U+3Xt+cuG4ixyHfiCu+LvASk6lRFun+SS/gxCdjBCJ6kK6ZglaeO
 q1GbLV5myQkVYEi8heDGhufkxJxOdbk/qDzjKzTuneHKQX28r29rEQj3GaRBDwS1ab46dRmwWvO 7gnEQr/QrQVvrMJigSXVppzmU57MtCJ/HgI/DOhXr0BxqFHplzX0c1CUlzDsHl59Vu/xh/Zml1V sSrhC6/oRy+Y9SsQU96JVJvBITR8p7uEC0DfXEALsu/h+jPSw3sBk0OXhU5wNdv8OOORbLbB7s7
 2YhfX7swI6WCGnX4HPI5KXEWnxWMmw1pD0b40hTIfhDnF0dtswKlYvJVyPSbnN6KTspxp5kP
X-Proofpoint-ORIG-GUID: lNsPPq21UF3JHmnMwdvay8s-DWf0s_X7
X-Authority-Analysis: v=2.4 cv=dNSmmPZb c=1 sm=1 tr=0 ts=6874fa55 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=lrwpKlflkNZv4iE10zIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=934 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1011 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507140072


Am 13.07.25 um 00:11 schrieb Xose Vazquez Perez:
> On 7/12/25 10:14 PM, Xose Vazquez Perez wrote:
>
>>   libmultipath/hwtable.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index 081d119c..4ca4245c 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -687,7 +687,7 @@ static struct hwentry default_hw[] = {
>>           /* PAV DASD FBA */
>>           .vendor        = "IBM",
>>           .product       = "S/390 DASD FBA",
>> -        .bl_product    = "S/390",
>> +        .bl_product    = "S/390 DASD FBA",
>>           .uid_attribute = "ID_UID",
>>           .no_path_retry = NO_PATH_RETRY_QUEUE,
>>           .pgpolicy      = MULTIBUS,
>
> Is PAV really supported on FBA devices ???
> And other than 3390 and 3380(3390 model 2/3 in track-compatibility mode) ECKD types ?

Currently there is no support in the driver for PAV with FBA devices.
But the devices itself are capable of PAV.

