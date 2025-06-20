Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A403F1A76DE
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750429869; cv=none; b=QXkRs7gXdb+oQoK19qpazV3mTmTj2oJVa7Cs+0OR9+4GEixY+26bxnVQahpDRBG4aC5qeugnYtN2QPLHpTfIYrzIDTKtzxWUaGerdUkvDwz9MazwGVS2MkxLtMxNCzeWtOwgp09IMuyLyu/xtzAz1ME+rAxvQ57e9RkB7EiW3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750429869; c=relaxed/simple;
	bh=4Syv/oQOYVXX02YUbwEt1f7abuj9GUl66bvjXR9vAoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sz4VriLm2JJpUnU/Hpnnd68pVyKP6kKlAY5rcJHde3/LQ+HAID2HFqQpNOOyIZFfyj+fCSTFexLKekpPkouLTp+QJ0yad8cxoQs+hS/XND6Bg28oRHQ5hHTDG0wJ/55yRyjT+OUIXsErp2JWoAmuFW9Fi1Dz/EoyLLGh1J6KbjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mZ9VEU+5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mZ9VEU+5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K5id45002744;
	Fri, 20 Jun 2025 14:30:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2csQY9
	saqraqktAv4jrZMEx+GCE+vYMx/Z20dZMnR+c=; b=mZ9VEU+5ZYBmHqc4TLIvHu
	qYo5tlBP1NqYe637YziJEg0YGJVhwDUaJl8Lx0NSXuNZulJsKuVafNa+T72Bj44h
	TnenoVGQ+BMGaRJYwyOBJXcvdHxaX6ITAZCDII5jeprJzS6IZihSXw1n/0AhlZdC
	NOlD6M5E5tgEHJebZckdWtgEnMr7gkhYKfDZtkQkYxekE4grY/gQB6PZWmmeYM74
	cf9vsczBrKGlURbe7SYijXwG90RnfgbCr+NLat6vAiVcDbxSrBTIE2IezFC4k653
	tXwM3VlzFbH+lAYH7mxX1GHoql+j2aEgmawwDAqBx19G7Hhj/zSpCaYJpeU/tsTw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47beet9tpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:30:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55KBROWF014275;
	Fri, 20 Jun 2025 14:30:55 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 479p42u71b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:30:55 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55KEUs2F58130834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 14:30:54 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 744C05804E;
	Fri, 20 Jun 2025 14:30:54 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51C375803F;
	Fri, 20 Jun 2025 14:30:49 +0000 (GMT)
Received: from [9.61.191.218] (unknown [9.61.191.218])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Jun 2025 14:30:48 +0000 (GMT)
Message-ID: <919b4979-4b47-4170-afa6-e5c18c1f583a@linux.ibm.com>
Date: Fri, 20 Jun 2025 20:00:47 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] block: sanitize chunk_sectors for atomic write
 limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
 <20250618083737.4084373-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250618083737.4084373-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Iysv_F-t44mToKdjpQt_x7Hra67v3Q6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDA5OCBTYWx0ZWRfXy92gLmO8J505 RjBPeucbrBzB2EhdpFUDXwWKxIYTBz5Jmeh8NXYlGVb7uMh75apXjq91DfXExlW/2sQXygAQ8JN jcvQQOpATR+MwFUKrSNiyjRW0kEIXX9vBhi45lrrZF61H7NMJHTBaES0OT1BplHCFmH0iVY55BM
 MeuhTFC7VqZWc/1VAWSX1Ya6JP/kcjs1yqKl1PjH0Dt4wkeGQTVu1sxxY9iiS39/4wc7gXi5CyC /Wt1miIofrykBEYkPbSkxyyPmPvnk1KsATeCN91k5Kfy90juVulJeoYLWqMjhinWpyr/gK6lzOy ymqxrFcAk4q9bc9jnpFBywGFTBVAXhgKahqsVoXd3uF9WJNbsVP2oA6/uvzXtheUQkawa2EQu+T
 QI2goiFxAD4Ju8oC3JPApfgo2QiafyvNPyyRqgUw4jQa1ZO6Yk07nwVshyLv6DfWL6By/2J0
X-Authority-Analysis: v=2.4 cv=PrSTbxM3 c=1 sm=1 tr=0 ts=685570a0 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=PPXFKaXgsVZ31vgUiC8A:9 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: 5Iysv_F-t44mToKdjpQt_x7Hra67v3Q6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506200098



On 6/18/25 2:07 PM, John Garry wrote:
> Currently we just ensure that a non-zero value in chunk_sectors aligns
> with any atomic write boundary, as the blk boundary functionality uses
> both these values.
> 
> However it is also improper to have atomic write unit max > chunk_sectors
> (for non-zero chunk_sectors), as this would lead to splitting of atomic
> write bios (which is disallowed).
> 
> Sanitize atomic write unit max against chunk_sectors to avoid any
> potential problems.
> 
> Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good to me:
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
