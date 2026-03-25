Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277A535F60B
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 07:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774422251; cv=none; b=dNFWa9cEsfcSSoNiLEYXNr/gBtJi9utolzEE//6MTMEZY+nC2EPsMsCiX0NIzLYm2rqk7Ada2qDW0uC31zB2H7V8N7oNgrjoKu9i09n58/XOaIBKGNC1lfUsvneypH3vwVW5jcJJyvTg68Ql+5p/5i7vKoIgbskfNtMPnRMPKGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774422251; c=relaxed/simple;
	bh=EqBOs0jRrwD3FbMvrXgC+4DO4UvpFLji0qZZL0gGPdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ciRs+ySqvLCVF+sj3IWmUSI+e7p33MoLjxP47HpzEqk6Afdp0ufP3GC3yPKxjca6V/TN59ZC0lSV8smJeRyn0Ti0OHdljXp0QZSBv2VDKlavstshw7NH4wVymrzkw78qZ0M/7XRKLRpVL+o4f2Qqd1KXLHJRO+mgodKiPiWjXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iBMeEJie; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PtOB9WvK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iBMeEJie";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PtOB9WvK"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P5Nh811862825
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 07:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wL2rYIimLmWWyyTP/wOfbukZyeC2GNRpjfItV9cVfng=; b=iBMeEJietAg1y97q
	qhdsajuTN8VYuhVBVnuBss3JMk2cFTYYWXWBdCJUNUMrSZHNT0qwr12h9JbhkSOg
	OQu3aYGSOQdS6TcP/p67oVBDP5gOEHsRZEGu377z9fYCloNKz3c+18MVoXLhaNnH
	a7y/jz+P1KoTs6h/wOUBZWUs3HKENLsOXJc13yqs6VB44e4EA19gD98Oemp//e1p
	JD8PGReAmQh+KkYtV6BxUABm4FAIlZqgLrcfPhFxEotxCtdRcYJnP010ct9VTYMM
	Eb81Fq6Iz++x7X0FjNPJN5pP6A7+Gy6ecu2y2YpBhV3MAhJy/HgF0GWnWHWIl7gO
	NH2znQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d40rasv2b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 07:04:09 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2ba9a744f7dso5241213eec.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 00:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774422248; x=1775027048; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wL2rYIimLmWWyyTP/wOfbukZyeC2GNRpjfItV9cVfng=;
        b=PtOB9WvK9Fco657aDREOESFcuMjeJ/88m1WxhbPtIGnldCq/2VxWg9Ma/5aDbBFINC
         DMMfgfGxsirYq7B3QJAtZYDHkEnVs+7WmJU4H9vqUwoHUe58pAp8W/ILQ5LlPtuCbNNZ
         oEkC8rQQqn73COXWO/r/J5iXDUtJ/9VPSyl032S4C+OZfc7FHm1rM1ntKHmTx+CPKmic
         UpyS9WM3uedjTB4mP3kSuMu9nVE0q+WO75Zp7Qb6IIevN636/jZ370jgmS+Le4ybUQvW
         7gIFZHryaeEOR1UJXI/nIQtf8nP0SBqUpU7Sl9wayrQyDZKOfNz8LjoZpSK8omgFs98j
         q3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774422248; x=1775027048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wL2rYIimLmWWyyTP/wOfbukZyeC2GNRpjfItV9cVfng=;
        b=nkR3lxSJqm6WjJ82D5cENiqDxady1WpcDdtw69eCv1gWRDmn3TNfIoL2MIgznOo6B7
         FwnUSNRgLZRmOTuNdZCD+LSkubO6Xm1OO1EAMAQbkWDjWdZRGZogpzOsYC+njlpYTMD9
         rJuoRP1LYqgeGz/IY4H6VAeHRrzJXXKm7G9ul4d+bw82N2ZpMnSH26arJdtbiTTLPs9q
         AJ1WpMbh5fVd7FYi5u6Eyq/4kC3OVjRpodSMzHHJzLC5NSj0plFsVts3kW5xMsRUkYql
         ELP+bg2JlJTAkfoYyXunUruXrTkF5D2DmkJLsV2I8Tch5KE5yg62YznGVvC5hqbsTxxF
         0+Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWQIF9mRdtdjKKkBkPE5tH91cA6V4939jJcBOJykbd4PwqFs+3n4N2YvlZQyvRIXOb94/XsszAiYA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwyDHgKyIicXsqduIq8uHeAi0umSpEaRCmfLr+Bm0+65WWp2Dn4
	O9zmAFKWHTONvpnJrzsUhWqjT7hKgcDepJlD2ftrWYSrn2ZRRwXx8xG8hYKe9iBIH5blXLezn8Y
	lXYCTuXNvODFKaesdyKK4B+9e/AuDEul3dvrglmfamXHC55EL9ywIFhoZSvNYiQ==
X-Gm-Gg: ATEYQzx0GiYGqZWYbSgrksVn7Nu/86GWsrKyX9Uh6Z2WeZNuHvatAqozmKUaPjT7b0y
	FmzOKVgFiXU+0KFPDRV/s6eZnuuz7vkqi0gdUkC0ejSe2RAaN7D4FG+nQ0RsVCgitSc7A2+nDOg
	r3rc+nbs4qvtOZ3sF8BS6ONWTvWyprC272aS+AOmZ5E2nxfPtDfkP8OLEQPcDi3kgbeYfpVhwVL
	qPSuOZbusEg01T2DOjlhT1EJf7DWdbr0omaziPbqCjpL6IOyeDpCpCkUe4SkNfrMc98ze7ifs01
	KHPRhrSPu1JTkpxI29uJfi0DpiddyzxDwZ2xV5nnGCPurWij2LfCySgNoCoAoAE3y22z3xIl0mA
	Y/wogXK3FesJBEr6kJfMAv93rrVveR3JkljoRrqLrNZCndRuFSHr9qPYIa6GNQMLZwYwJCfXmE2
	BwcvI=
X-Received: by 2002:a05:7300:6405:b0:2c1:571f:b824 with SMTP id 5a478bee46e88-2c15d4177eamr1370257eec.30.1774422248255;
        Wed, 25 Mar 2026 00:04:08 -0700 (PDT)
X-Received: by 2002:a05:7300:6405:b0:2c1:571f:b824 with SMTP id 5a478bee46e88-2c15d4177eamr1370239eec.30.1774422247741;
        Wed, 25 Mar 2026 00:04:07 -0700 (PDT)
Received: from [10.110.19.183] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c10b1a88e5sm22144015eec.13.2026.03.25.00.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 00:04:07 -0700 (PDT)
Message-ID: <996ba1c4-e91b-4a04-9424-7c262d45ce0a@oss.qualcomm.com>
Date: Wed, 25 Mar 2026 15:04:03 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Christoph Hellwig <hch@infradead.org>, Adrian Vovk <adrianvovk@gmail.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com,
        mpatocka@redhat.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <aaguW3p3_LOeM_Dz@infradead.org>
 <CAAdYy_mSB4U39Onwa=V2e2XB0sJXV6tCGkzwV2-z7ZtMcm+8zg@mail.gmail.com>
 <aamVXAqlWGcPXCDe@infradead.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <aamVXAqlWGcPXCDe@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Jvr8bc4C c=1 sm=1 tr=0 ts=69c388e9 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=fqon-WgCYBziNm8ShXUA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: IH7_FSG72K0QiiiMgrPDBEGkqtBhyhvE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA0OCBTYWx0ZWRfX8KOXS/3anbWc
 8haRJXOe1mQWIlL+UW0weuV89hBXZIpKAy9hprP5jEmEhnxuTfElBnE360SHlUr4IwUaGZgr0PK
 k8wKuuFljv40o7cQG4BCe3HnYsVdaGNVdhlKyN/xJU9deRpj3Zrr+cbRCice7UVNNcXHdkbGYMN
 DTpNXB7OTHFrBDTLMDUfUpwsUDS+rZ+uICF+D+cPNExnnaufl3WGVfpGheKqtBMCAP1a/d0DmWq
 pBBDLygpwEpCAQiMZAJXbrdFY01z0W2CoIl0jcWpoHGW7IVz3R2A87jM1XUZTmzOE+9BSQR1OfS
 3kV15QFebGW32iKdtRWVWSRc/Zu/yaJgcfCWI4u0vFlRqAjCB8N69MvvQScYCvXcz1WhZfsPeYe
 e18oz3EXAhlFR7dHao2nPOshaoIPnb4SprIaCIPe5PAXHxKC54cRJ1C7VMbHBuqkNoRfBNScbSV
 1gj5NW0X2KAO9CGs/Zg==
X-Proofpoint-GUID: IH7_FSG72K0QiiiMgrPDBEGkqtBhyhvE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250048



On 3/5/2026 10:38 PM, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 01:02:41PM -0500, Adrian Vovk wrote:
>> Hello Christoph,
>>
>> Maybe I am misunderstanding something, but this seems orthogonal to
>> fscrypt? Userspace would use this to do LUKS full-disk encryption, but with
>> the hardware acceleration provided by the inline encryption hardware.
> 
> Ok, if people really still want to do that that should be ok.
> 

Thanks for your review!

Yes, this new dm-target type is designed for the Full-Disk Encryption with
inline encryption hardware used scenario.
I believe it's necessary as dm-crypt only provide software encryption, the hardware
acceleration provided by the inline encryption hardware for Full-Disk Encryption
is always what the customer wants, like File-based Encryption with Inline Crypto
Engine supported.
