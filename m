Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CB025A359
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 05:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779429474; cv=none; b=JdavJbus2YSa5gezWRWnGBpHZW8EAZOExYmQK1qMh2xwjvfkIDMYfc77dBlExgFraAxQeCNTYJYzWFNJNiStquUc92i2EiiKzsN8As+pDgsb39zbjJxo4GOA+oeZlXBgURNHqlC8BSZYUiO8C+uut6d+rpdLBoRFn9GUPn1JEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779429474; c=relaxed/simple;
	bh=hJhn/eLEY2sTvwCziztqRUu5YYH7/pvQ2MtAlR51IiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0lKR6q7fC1qHPt1vdCZYmOpl0c5N9YYlX7+/KPzXU2NSqiOPoHP6x+uMy2PjMDhHQ3aHFOfy8SYQpT/q0418u4PKNABoOpK/f3/3nT0+pQQcrZIAwe5M+7na5HEbw01EVQt0tQAnU1igWaToj4Z/dBKOwfqWhEE5ib44+HSP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mdot7CP+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BC7GBHYr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mdot7CP+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BC7GBHYr"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M3w5HZ186612
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 05:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/runryRip9TcHkyLieUmStSMwcicxsH5P3t77krCWL8=; b=mdot7CP+oD2Pb59+
	nG3KRtJQhQDQ7FmOF/yjKmmKG7zLn5TBu5cBggYX/CsssERPFoSKLqqlLJwDq+2e
	dBnLmrRGuMR4mZn5itadJvshhcE7klRIzRapCUKxnJzDKMoFHz/CReLaB+89xAem
	EwBzctWLzArezM22Mpwlrly3k+e7ed/Bz+OaDu5Z7B8dhXmNR3L/FL898n5TSEWo
	14EUZ1ZfiXD6eSX7kNaHGduhYdkbHL4GLZ6P19BYeAmihAMr9E9XdYog+RZHGraf
	O2h0I5uoJzHptn6CeyxKI13D66xJZeXcW1+gzISsGXCzc0uCVDdFX0e3MrdxMpO0
	XWm7kg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e9wahw31e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 05:57:51 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-304448ab58cso1953568eec.1
        for <dm-devel@lists.linux.dev>; Thu, 21 May 2026 22:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779429471; x=1780034271; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/runryRip9TcHkyLieUmStSMwcicxsH5P3t77krCWL8=;
        b=BC7GBHYrXfhZ9iJSt/xibbZ0/ZmtzbLXVrENv/0Xjxa+oab2H/yUzBtd1lt9iLzJmf
         tnFATvzqL3Okgh/C2J73V/vtpYDeHMD+s4r0TYmdFfLtX8ssHhF6YiUDm2fwHPNigytb
         fef6WBCBrlfjEoUUg4E2OXp+YOkQn0A7bRNn3os3wsiZ53raOnAIdeIpLsvi19KmQjAO
         fvWb3ge2V3DfpT2KL/7XKR8l6Hj9TU1gREYj4u3x7rc2WYPZfu6xAIcst8Patbs9z5O5
         7nkJkZFqJeLJVbX/UhFqn2czH+qxAluvOFbZ5SUqHyfaDIsVrcaJiPx2lJKA2i8aDFNh
         JA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779429471; x=1780034271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/runryRip9TcHkyLieUmStSMwcicxsH5P3t77krCWL8=;
        b=qmeRnIbmWW8eQHms1IjCzJLtfo4kHN8NSc3fkwQS8LoX0VTew1Qswll147/mQRwREu
         oR7VNsELblijLQ1Es/9eb07Afj/wUw0a2A62hc8dRqJ7NmsvSbwlWNwNgzHT7AGi+hyu
         Oedy0YbS92NYUKX+VsT4uZm7XiQJKVzfvJSRg6GRi22uW2SKTDvKPQjg/NVsDoiM+CBu
         JvOw+0PCueYkffYrQXo75Xo2zt5S6IWjKhDotTmDrB5KmRe+g4qzBKBRhyh/INezVbYf
         UfUkXjl0zQY1HrF975oOnryObDgvMvvwcGZ4A/oMRaawkSLtBDhRV3/oKYBVR9rZa0ns
         fGuQ==
X-Forwarded-Encrypted: i=1; AFNElJ/7I5E6bHhBMUEexS2zXqHt4L/aQvVUnLaV7ARTTD7lhDk08zULw0JZ3N3kvKOtc2/alfN6g8zRVw==@lists.linux.dev
X-Gm-Message-State: AOJu0YydhAZpOn/syVBMnkvx8qcncB9oVeF5N6OQGXIh5SMjZok6Z/nR
	VbS0R95g5GZsA7pNc/dickMNSR0DZMfIDmJONz7n6GcXxM3wHTepcDzAaf9YKUoGb3B06LD1Kkr
	uJ2mWq0h/i3JvMM4al/OQAOVcra7sBVsd3kGnieahEJwa7yKyN7MzCqE29KErJbYXlz6QD3r2
X-Gm-Gg: Acq92OH5XGCm7yQLhnxR9ujlYYlRMcpGSH/KsN0mgZtYvZcD2IuV+omAqAony05NpUL
	CGXJNnGoGX/4k6q1MrFLNWlGCEwVed9cDlziHhBRLt998Wg78SK8YKQfJq8aYDWtqdL2NvudCaf
	axl8O5RQf2dymtkY4dtPbrJfw0i+EJ3DsbWEfgHvQslmkdQaUA8aeuLABX4mITLDH9VGh3fBPqq
	7lYRUwzJ3HfOKbCsRa9b5UfJt1o4aoP29ZSGDMMlyao/ZBr3WZWRL93Ha+ZFOwSu1PdxvOEbE9O
	6YHgrte+oVTaFXo0cZxCBhUduqz0T/mIKE4+zDdMevet2qwfzDIB3cab5EkEn2xHS3BCAbFjoJ6
	rbbhiJC0QjKrekKQuyaMNlQ3+luc+djiwj0a9tqFpafVxOzITVP+OToW//Br4qPEQ95PkpQ8s7M
	LIj/Eg
X-Received: by 2002:a05:7301:6589:b0:2ed:e17:d50c with SMTP id 5a478bee46e88-304491fb381mr1175602eec.31.1779429470822;
        Thu, 21 May 2026 22:57:50 -0700 (PDT)
X-Received: by 2002:a05:7301:6589:b0:2ed:e17:d50c with SMTP id 5a478bee46e88-304491fb381mr1175589eec.31.1779429470285;
        Thu, 21 May 2026 22:57:50 -0700 (PDT)
Received: from [10.110.121.192] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30451f20e71sm268109eec.12.2026.05.21.22.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 22:57:49 -0700 (PDT)
Message-ID: <87dff78b-c075-48d7-83cb-810694617ba2@oss.qualcomm.com>
Date: Fri, 22 May 2026 13:57:45 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
To: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
 <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
 <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com>
 <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
 <98f9f0e3-964d-414c-a329-254c141c8d48@gmail.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <98f9f0e3-964d-414c-a329-254c141c8d48@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDA1NyBTYWx0ZWRfX0FwmoFhYEQjg
 NP+Qkz8HtctaKn1X6Uece2zIaYw3sc5B8JPtLlNJPP4575/NJTzmZwxIuCKdyOJke4uyrFIvlOD
 uSXVUVm4pnswEpJux6FrVzJvSatc90aEUNjdAPYP9uLmS3yUg6Wh87bzaTBtVyfDBWAp+4kz3RY
 UM72mA6gH/yBuR7dJIt6JbDX6fTu+mVwHzVrSNPNrNC8ifnAS5stZl6OxnjWV/QEiE/66igSfHi
 6nZUEF7hg2qvmMb/7rJjqgb/F21TNYcHAqUu7WXylUjPw1DBecFh5QsXzGv1breeTFNYiipO+rg
 dRaEso0MxHN39Gp1GHNcWGE8szfMp5MnudAGMdeCCeA2j0kq5rAxK4TU3sworAMllbLd47Zk4wg
 fTRjFeGvers5OvQVQlE8efcnDwTGfb2tDVM7MKc3TPoAlQgGU/uhebsmPoFLzD+h47tYGSE26un
 VRAP4WE4NYDrrm1I/Wg==
X-Proofpoint-ORIG-GUID: ay6kkNcMwjenfrxjtoPe4e9wBIBxtpFx
X-Proofpoint-GUID: ay6kkNcMwjenfrxjtoPe4e9wBIBxtpFx
X-Authority-Analysis: v=2.4 cv=H8LrBeYi c=1 sm=1 tr=0 ts=6a0ff05f cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=XU54WYprocpNAOCwec4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220057



On 5/18/2026 8:49 PM, Milan Broz wrote:
> On 5/18/26 10:11 AM, Linlin Zhang wrote:
> 
> ...
>>> IOW the mapping will look like this (1 is number of optional parameters):
>>>
>>>     <cipher> <key> <iv_offset> <device path> <offset> 1 hw-wrapped
>>> or
>>>     <cipher> <key> <iv_offset> <device path> <offset> 1 keytype=hw-wrapped
>>
>>
>> Thanks for your suggestion!
>>
>> I agree that keeping "hw-wrapped" or "keytype=raw|hw-wrapped" as an optional
>> argument helps preserve compatibility when switching from "crypt" to
>> "inlinecrypt"
> 
> Just use semicolon as separator as Mikulas suggested.
> (I mixed that up, we always use semicolan as separator.)
> 
>> My concern is that, in practice, this optional argument may effectively become
>> mandatory for certain configurations. For instance, "hw-wrapped" or
>> "keytype=raw|hw-wrapped" must be set for a wrapped key. This slightly blurs the
>> original intent of "optional arguments", which are typically expected to be
>> truly optional for correct operation.
> 
> It no longer works this way, it is normal that in some scenarios "optional" arguments
> are required. For example sector_size - once you use non-default, you have to specify
> it always.
> 
> IOW no problem with that.

Thanks for the comments!

ACK. I'll send a new patch with such modification.

> 
> Milan
> 

