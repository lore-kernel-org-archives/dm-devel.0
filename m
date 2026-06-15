Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0783A785A
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 05:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781501984; cv=none; b=loupTI/gcth0dXmGGcqVUHy6qJ8UzPCQh80aHgUIBxOf0RH8SkAkpo3RxOV5aqEfNxca3KaaimToMSa8BrvYfuNsephFSaZG+eZI0a9dN6yPr8jyStIi8fuD7OZwu4Ufb2pJxDiBfzCDZKf+dPrASP/wZdDe8a20scjILQJqvDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781501984; c=relaxed/simple;
	bh=2v1FXROf2ObWJ5xY2SXVuKArLQN3hQZnwDWg8LJ/z9c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=orch48EQ+Hnm0vcH15EHTB2JjTqNNAfP8jLlhl/D9SsKoTjxXIvK4aReTRl/9QlZLv8FH5e17+Mzu9sMc2tu2/SGi6VrLF9aLZ/gtQSmg10Q4i0F4Z7Y0eVn7RXCEF/Z9+AkP+v7tp+4ZgeIvFOAey+U3gZpEDJf7J/YiYwn9EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kU69/Xzj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PQClGsO6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kU69/Xzj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PQClGsO6"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F1hrRs2738578
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 05:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6Poy+bOS4KS653+bQkMJcgdfZnGXMHnkW3WaDHONqSU=; b=kU69/Xzjr4DyTAYt
	low3QsngA3SwSfIJ/YTtfzr+xG9hDwW8tAJtW/iWs1vVVpUand59ccb3zgBGgKkn
	xyYrgwMNwMCkE4udSLhUnJoGuR1E4d5VCWDIOpmRcvvFxorRPDiKPACEBrTNb6MV
	QXD0HiGFRMJrJ/+cFnhlXrfUlFGywEZqZkzouKBnmYrLKetI+DMOsFkliE+3I1dg
	zMrG994sLHymQDc1OvMrkJq/g+TlTnsvmusaobfJ+tHvqbGfFZ+A+uyZJw0vcfub
	fa5ffuWEAvPjjSFWEKWw/N7tjqOI6/YCZP2hyQejA+l6LdFqgqKZT915uIwXLFl9
	9X9CRQ==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ery9fdqdw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 05:39:41 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-137e49e896aso2788350c88.0
        for <dm-devel@lists.linux.dev>; Sun, 14 Jun 2026 22:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781501981; x=1782106781; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6Poy+bOS4KS653+bQkMJcgdfZnGXMHnkW3WaDHONqSU=;
        b=PQClGsO6KZDD9YIv1/xiNu/TOfCE34pFaRer1VTx2QuYFoTvXX4dGg2RnGKAOfWkqb
         FIP0I+4xYkbRZ09GhD4JXRYBgfl8b+foaxNmQMi9wy/hOtIE35Twy4BZ8NBg6xTPQUry
         DU4arIxN0+5XHx302B78IihbZD+MXNsKDtOqrj0vlkHRYDO3ddCfHutJtN/mtwrGF5YR
         ka4DNeMSIMpC3C9y7l3WDNkFop8MYpjoBhD82zfl+mvtiK45Ucs6IdrCo3c9P72Y193r
         wXM50BN2HdKk8vw+4KUBTSHN8MM8iam4uggijT0IV+BIs6OssORi+CoaGbUlC6IR/FIc
         JNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781501981; x=1782106781;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Poy+bOS4KS653+bQkMJcgdfZnGXMHnkW3WaDHONqSU=;
        b=FzSxq+tDc8zHVRiUWqSb5wT5PCorAHj1Nmz7/YPW5GiTDYu096i8wufkaWKd+7duxi
         WwVOiVKYSNZoFHXHm24bG4y7WJbPFGiqZWObxvS9VLXGwUU9UjEolVCwxmhM2u/S9XD3
         SfFRP8iStflU3XqBts1FCLTXR+QuKHwE7LOTpChcvjKvi5YkTL9qxBx36cRzNO86V6VD
         6EEhqAaaJ7/thpOQhsudSNYTK+4lzvVaKXbtMgKHp9CZehwE7c8/n/xT9/z93mD95eyE
         jSmuGx26LakdESI5hGSzn4IR/OWq+qDzSqOMx9I7f9K3U5HuXcD5n4Rzu4IAcMT2ORtJ
         atjw==
X-Forwarded-Encrypted: i=1; AFNElJ/LRGoMKFDBJr7X1nLWlyXDV7gW6IBHh8bv8OhJzoRyXrfflpboxAG6UcsWq7+jgVOj59Uj2ArVVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/WrPCrh7prTg+gYcy0Yr3bZm2xfzCgOZ+E45a1/PS1snOro2f
	2srHZ8dJLQ3sOigkM1AwZLNH8/UT3jxv5RERPFQMmi5/sCYubslyxMo/LNplyfKRiXdI5lKfW+r
	INFPudxINuppVODetQFk9/63snaBsyJSn6sJks/42inw5zdSzx7P7ibPPXioHyA==
X-Gm-Gg: Acq92OE8OMcA7gAZjWA2foM4sPV0x+Pnj5/kFlwg6N/5BJrUOHoTPzkmVq7xtIvzSCM
	LvUwuPvjARWUYZDkk663jLGUpuOrWFmovTXe1bEPAzVHIM9TetcakG1RFC1mhAnBnpaKFee4wma
	L08DqLPS2lJw6gvHLqi3RjZ0rmafHzgv1FbBV9ZxiOSIzXpyqQ/UtOuU6X3dPcR+jOTvjBkOf/z
	qPfSeRjxxsVC7EqNnVpfrgGY5LPRvUU1F4rAcvR/IsNfS+MUsSuYKisZh0CrUv/x6vl3NyQ3iD/
	WGZLDVTJ4RSAlrRjbKZiCFVOR5v5+EbQFa31alK+ty23SoPQXpDlmU0OEAKgBT81yVJmCwVmKaO
	t/eTYjG8ow5DI8Kr6hXKKHlmPHYrhL1YIQ/Y1d65S1YaSt49hKQkuglJLpRUACFS0R+sp+aDuB4
	wuRA==
X-Received: by 2002:a05:7022:4389:b0:135:e781:74af with SMTP id a92af1059eb24-1384c153facmr5202787c88.18.1781501980729;
        Sun, 14 Jun 2026 22:39:40 -0700 (PDT)
X-Received: by 2002:a05:7022:4389:b0:135:e781:74af with SMTP id a92af1059eb24-1384c153facmr5202780c88.18.1781501980116;
        Sun, 14 Jun 2026 22:39:40 -0700 (PDT)
Received: from [10.110.6.230] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b910c51sm9319655c88.4.2026.06.14.22.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2026 22:39:39 -0700 (PDT)
Message-ID: <13febc50-41b2-479c-97f3-f3eecc648871@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 13:39:35 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers
 <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA1NyBTYWx0ZWRfXy/cyeB+nszel
 WdMFMuWGQD9XicvAsvbygTMmfwjXBop2BKUM4Hio1RXo8Cak0qowc1j/UY4OBOqMDdB4YMYp5S7
 ceQMoEbcd9qdIZY0owuveuplb4Lg0P1XS3eK89Mfqqdjs7LT8y/bUyVx+/H7XPUeLdI89ndylh4
 urRLDP9WnW30/KiaqeMkI2ymOcoSDu8Vjp2/moh/OMZtAsgav6pgplXNH+ZIj3qJ33+oBBed7qn
 +Eob2qH3Bubs5Iug4Ep+xZJrtInNiOIHbDQXjY6VMgXLGSNfCCcLzcw2/wX713FiyltX5PZ+Vhz
 AOMSxKVBpauMNynpb72n8KIB/K41vJ3TrxMhP9G/a7VWTZItjBG/OlyYdqz/U3apFl1O+mPsQoA
 Mv5l+Z0kHUlyGNHBZQhONx3/N8HqIO9h3Bl3Bxk5kgPhFyifxUYcrvrkkR+X6/o5rVSTxvrGsaw
 jl1+2OF7WRteXtPZamA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA1NyBTYWx0ZWRfX06pMHu3V42H+
 Kbo9AtoDyTGz4HZgYJm54fIzZ3rRt6Xng27Kdq2FVf+D/dqGb+eroFhDPlbLNWQDCTM4zAN4uPR
 7nS7ihzz9AH/TItthd1qedKgQ5V6lW4=
X-Proofpoint-GUID: pJe25WVNeWprb353DXW2UpoKhKoU-WVt
X-Proofpoint-ORIG-GUID: pJe25WVNeWprb353DXW2UpoKhKoU-WVt
X-Authority-Analysis: v=2.4 cv=ULvt2ify c=1 sm=1 tr=0 ts=6a2f901d cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=nN_db45w9kzvii0sCBkA:9 a=QEXdDO2ut3YA:10 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150057

Hi Milan, Eric and Mikulas,

Do you have a chance to help review this patch?

I'm appreciated if you can help give some comments or accept and help merge this patch.

Thanks,
Linlin

On 5/25/2026 8:13 PM, Linlin Zhang wrote:
> dm-inlinecrypt currently assumes that all keys are raw software keys.
> That does not work for platforms where inline encryption expects
> hardware-wrapped key material managed by secure firmware/hardware.
> 
> This series adds support for hardware-wrapped keys in dm-inlinecrypt by
> introducing an optional <key_type> target argument. The flag lets
> dm-inlinecrypt select the proper blk-crypto key type at key
> initialization time:
> 
> - 1: BLK_CRYPTO_KEY_TYPE_RAW
> - 2: BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> 
> With this change, dm-inlinecrypt can support both raw and wrapped key
> deployment models without hardcoding one key ownership model.
> The series also:
> - updates target argument parsing to include the new required flag
> - propagates the wrapped/raw state in target status output
> - updates dm-inlinecrypt documentation and examples accordingly
> Linlin Zhang (1):
>   dm-inlinecrypt: add support for hardware-wrapped keys
> 
>  .../device-mapper/dm-inlinecrypt.rst          | 20 +++---
>  drivers/md/dm-inlinecrypt.c                   | 63 ++++++++++++-------
>  2 files changed, 54 insertions(+), 29 deletions(-)
> 

