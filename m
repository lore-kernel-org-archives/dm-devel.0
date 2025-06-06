Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2048C1A2C25
	for <dm-devel@lists.linux.dev>; Fri,  6 Jun 2025 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749223484; cv=none; b=VdZi3YIOgoB3gB/JBcX9nw/EfPw6ScoxqcOq4nKduNbF9MSYwaJUPn+cp8M17aomPbj2MHoGFF8GhH5V5poNEIj9aqZ7Gv8N67MOHCr9CJGUluRMyUTayRXwGAk466pDa4xE2ax2vvuIb+W6al5nKZj4djJWBiq1bgyVoW9ptkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749223484; c=relaxed/simple;
	bh=PGxsIoF6XolSXA0yz6NNwiZhEBrLUkM+cSRlgFa4b6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTXYY1Oho2cy8ILEaty3hIwJ0+F32SISvOMunlaUSs5lAk46ZJMpPPTmLLl7tzunpEoDIQgf2cy2TtF15+B2Ju4y5a/o5mBcDSn5+U07DPS/0LQGFRmpr7PRpYCML0l57KN6VgOrgxOlh1wrlJtQOqE4Axo+tr8uM2Pap7PtJkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QlKmfyvd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QlKmfyvd"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 556CZAZx030304;
	Fri, 6 Jun 2025 15:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=71jYEz
	zkLLgoJ5VbvpTNuDtlu7S8OnwL/GqbGzUT0bA=; b=QlKmfyvdBBpIXkO+fbv8Mo
	J0bAIS6e1OzWCyU/1M9HwXsjCnh17zKX2ajFv4XpfH5cCcpy3myaefUBzboG4wSn
	XErxht2lDnaMHsSWoQOLlyw2vYkPfCSmSMZoOGijkLyBANQ1x56I9xKhcNJFQq6k
	NFiTzfQTLU84F5FWYsv8hwL/nt1OG03Adt+L1MgDdKX3qqnEnkNkUqb+17nYgnxF
	roAo8ss3uOe9fqUBW/jYr4QpchLdd9dTYu2jkOLaYOuruE4mH46TUWosBN40p7fX
	RzIWp7Qf9RYLgaAEhxZOi7xbQJ3VYtYt9KBW/9oNcD1WlVVI9hXcdbK5L3gPtwmA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf07ahu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 15:23:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 556F0mVN024768;
	Fri, 6 Jun 2025 15:23:25 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkmsyj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 15:23:25 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 556FNOXA26280540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Jun 2025 15:23:24 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DFC05805E;
	Fri,  6 Jun 2025 15:23:24 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F282258059;
	Fri,  6 Jun 2025 15:23:17 +0000 (GMT)
Received: from [9.67.149.38] (unknown [9.67.149.38])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Jun 2025 15:23:17 +0000 (GMT)
Message-ID: <94718ca7-edb8-4e87-9b2d-586dcbd42690@linux.ibm.com>
Date: Fri, 6 Jun 2025 20:53:16 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
 <20250605150857.4061971-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250605150857.4061971-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Pq2TbxM3 c=1 sm=1 tr=0 ts=684307ee cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=FRLcGKbqzZ5yKL8xwJUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA2MDEzMiBTYWx0ZWRfXzd0EnRca5xVc 0uGyd1wyuBCUmYmpt3lJF8TqD/n7XVAFr1kakUSre9tzJhRqudUpqHO+5QVDAvNe2hTDshZLEBC UqkWesWm+fWT/FK0H+WAPly3a+73oagO18tDW9PW0MeIkQ30V62RPbkWuxJMwTaLgDTjUc+Cnad
 k+7cpcbuIkklaySQwf9dyyqkVW5vig03DayEyXRm5xP2a75SjyyokLgSScofh5PdoKsnQ0Vj+tW Fy1/QTR3wxfS+6RnbpcjQqAI8+9N4IFvg4iXcbSassLW35fdGusim5vjpiPrwEXCAXYpOa/OZV/ 6wA7JscWzdD1aKzwGbfO9/L64ijPCayCdArfFA1zQ23Dw7IfZjTy3uC06dYFqBNiKIu4Hg72V7a
 uP7/c2FS2oQvvcuL/93L1Vl8LBm+9b74sIT5ybVegVYDSP7exd9mj3uqjm8QjqG89MYlJr63
X-Proofpoint-GUID: 8j7_MUFoHJHOYQoVUE6ahr8RJfFrSiP3
X-Proofpoint-ORIG-GUID: 8j7_MUFoHJHOYQoVUE6ahr8RJfFrSiP3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-06_05,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506060132



On 6/5/25 8:38 PM, John Garry wrote:
> The atomic write unit max is limited by any stack device stripe size.
> 
> It is required that the atomic write unit is a power-of-2 factor of the
> stripe size.
> 
> Currently we use io_min limit to hold the stripe size, and check for a
> io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.
> 
> Nilay reports that this causes a problem when the physical block size is
> greater than SECTOR_SIZE [0].
> 
> Furthermore, io_min may be mutated when stacking devices, and this makes
> it a poor candidate to hold the stripe size. Such an example would be
> when the io_min is less than the physical block size.
> 
> Use chunk_sectors to hold the stripe size, which is more appropriate.
> 
> [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/blk-settings.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a000daafbfb4..5b0f1a854e81 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -594,11 +594,13 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
>  static bool blk_stack_atomic_writes_head(struct queue_limits *t,
>  				struct queue_limits *b)
>  {
> +	unsigned int chunk_size = t->chunk_sectors << SECTOR_SHIFT;
> +
>  	if (b->atomic_write_hw_boundary &&
>  	    !blk_stack_atomic_writes_boundary_head(t, b))
>  		return false;
>  
> -	if (t->io_min <= SECTOR_SIZE) {
> +	if (!t->chunk_sectors) {
>  		/* No chunk sectors, so use bottom device values directly */
>  		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
>  		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
> @@ -617,12 +619,12 @@ static bool blk_stack_atomic_writes_head(struct queue_limits *t,
>  	 * aligned with both limits, i.e. 8K in this example.
>  	 */
>  	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
> -	while (t->io_min % t->atomic_write_hw_unit_max)
> +	while (chunk_size % t->atomic_write_hw_unit_max)
>  		t->atomic_write_hw_unit_max /= 2;
>  
>  	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
>  					  t->atomic_write_hw_unit_max);
> -	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
> +	t->atomic_write_hw_max = min(b->atomic_write_hw_max, chunk_size);
>  
>  	return true;
>  }

This works well with my NVMe disk which supports atomic writes however the only
concern is what if in case t->chunk_sectors is also defined for NVMe disk? 
I see that nvme_set_chunk_sectors() initializes the chunk_sectors for NVMe. 
The value which is assigned to lim->chunk_sectors in nvme_set_chunk_sectors()
represents "noiob" (i.e. Namespace Optimal I/O Boundary). My disk has "noiob" 
set to zero but in case if it's non-zero then would it break the above logic
for NVMe atomic writes?

Thanks,
--Nilay


