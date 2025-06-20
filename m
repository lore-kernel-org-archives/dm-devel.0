Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E527DA93
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 14:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750430020; cv=none; b=CIli76ppHVo2Tpxtr+qjrMmB0JeqmmTmCCoUsAfF1m6ohgRRofDC/3mU1EtScJXi24nzt42vYTe7uMDL8csOuAHx2NeTMjwn1pvgTD5deErkaNX8d8aEWA5glLOK/p0GFAHgLIIdemDcTJJFYl86GfOeQnnkxRI38Ef6PCpwOME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750430020; c=relaxed/simple;
	bh=TI+5LDC/0Boaaa2mFEGhq1MpCEpdgNy9e8C/z0AQV70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wh9NreqVvKqkMg+DV+P8lZ91TwKLrk4w0lYJfsBgdiYZ6w9MfF+XzlJILo2/lRdyKcDEX91RMw2x9cM4v2sadZ9urPdgk25eDH9e+e1McPMGy0PlTYCzryPAEULhx98UWSgeZEYndUufX5PfzGgWk7glLCMY4IoDhq3YemfSypw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T7ddrfcd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T7ddrfcd"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K9vZsD022855;
	Fri, 20 Jun 2025 14:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eK2JIh
	VJsbNFpG27/SudEaniFaBWxW3Hn9PlQCUOL7E=; b=T7ddrfcdsq5aH+ySgjnTTu
	jLUvwYQdgHBUif5j/pgKtpYwpS61TyC0Z1rU39LUshF4NiHdgTVIpjht5AQxv6Rr
	L5UqLkJi18c4dBH53Pn89AfaSvuyQcDMO8eKEjmR4oJM+7XgwHpt14gphgZGrmGU
	4NM1WGg6DhtemJPpRmOvPcLU6teeyQgtrraQBk/nRAxCzcoxBHQsqlxYZzcHarhk
	1WX4zvS1VtV4mrUfYrhMfTJshln4ZbRbHKl51KUrEWxY8NGsaWEP4Jt1Sb3spxZY
	JcoQbrDpYfdMso/kpTQWClKAVZKRk4oTcpGabVtMD8FCWFXQTTcn5U0AS3k3+GFA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4794qptw6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:33:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55KCGZUm011331;
	Fri, 20 Jun 2025 14:33:23 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 479kdtutd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:33:23 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55KEXMTH32244270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 14:33:23 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F48C5803F;
	Fri, 20 Jun 2025 14:33:22 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8120D5804E;
	Fri, 20 Jun 2025 14:33:17 +0000 (GMT)
Received: from [9.61.191.218] (unknown [9.61.191.218])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Jun 2025 14:33:17 +0000 (GMT)
Message-ID: <17d13cad-e205-43b7-835c-dfcf5f356399@linux.ibm.com>
Date: Fri, 20 Jun 2025 20:03:15 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] dm-stripe: limit chunk_sectors to the stripe size
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
 <20250618083737.4084373-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250618083737.4084373-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IEZjTd_vMC3GYjwOEcpVzAbtsmcnzGs_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDEwMiBTYWx0ZWRfX4+uh3Fp9cckg CnTfI2aY6ifad+VbC8LgV4Ic71pUA3VexVWbOzWLm8VQVKcfncvdiCeUHUz7Vj9phatBKS94zuO PbyeI/fsd+0VkZcrOuG+139ORvE+K1FItRgegLcun2GW+ZJaY0VzIR0B2QKLQqS03XCroscQ4bX
 uAQY3IWfB05pndW9jlXH5bNMbaGl/LcGE2utSfA53giHSUWNpdUAXBYp7PBKmjLJFEDh1oj1jkX xYtwjFXQegQ7DthaRIV/TF/+gQTK0wMNcaoyQBTIY+UvI9o18VYhw1VCzjD3gCPqZ694qtpTFze Ti1ZLL9hsnc6syazlU+5vm4adVEdL7G0LPZeYcebBTj3rIu5FCOXpy4cxY7YYNlHMdRPIvkS49S
 6nD87+ATdR8P3a4Un5lfjV/LTp6WPT0H9dCuAw3Omh1iv2vLkm+eDiYix4sLUFCqux8yZUIj
X-Authority-Analysis: v=2.4 cv=NYfm13D4 c=1 sm=1 tr=0 ts=68557134 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=wbLohENRK3cqXJ1mymsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IEZjTd_vMC3GYjwOEcpVzAbtsmcnzGs_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506200102



On 6/18/25 2:07 PM, John Garry wrote:
> Same as done for raid0, set chunk_sectors limit to appropriately set the
> atomic write size limit.
> 
> Setting chunk_sectors limit in this way overrides the stacked limit
> already calculated based on the bottom device limits. This is ok, as
> when any bios are sent to the bottom devices, the block layer will still
> respect the bottom device chunk_sectors.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good to me:
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
