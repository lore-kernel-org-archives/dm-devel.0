Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E224B311975
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774439838; cv=none; b=TY6VXdpjnR0eO3ZqF8Tzh9lxORNAD5p8YyODgPbFUX7A/DijNDmO/AoNnsULaU30Ck+9eF1Q48yrLwn7qZBe+PVxYM4Y/x3k5SWhQrzXhHIjC8xMUdIwdBKcsRW2PhDu/Kgg/pyAd+xOzDMmvAqhqgS802lI3CxfhJC2uGXIS24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774439838; c=relaxed/simple;
	bh=rGUXkPwSkQ89I158wBw/9XHF84KlHiIQkhQ/gUtbYRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBITSDHgA+uX/aQA7Ti1JRaDkNEGZGa+llzjav/ibeDXtE+ulFPfFO3jHXB0p7NUzkdyB8lQTKE+CqhpWHYww5BF2/9XauQ1MUJO8xKqlCP8MUHK4eITpaKyr13V3n1/1Ku9PPtAVzSCBnrk4/hv2MfKdupc7TuGlcR9RDjDsC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R6Q9LAS6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JwAeZTNc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R6Q9LAS6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JwAeZTNc"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PBGO6S3922623
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 11:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Gr18nfu9JJ8gSoYFoxnvVAHkTdc2dAzT6iMHWG8h1ww=; b=R6Q9LAS6EO7rrk50
	nW1Leqjq84qwf6cfDWMfEvVB4SOmxhkM0NpHrN+1l91gUTrNS125PoWtaEJPWojr
	/TAiUYD7Xved23H2r2ytnowG440qLoHxLB1wHcv/GWSYZM94ubTb9rrnRFOCW8+c
	Kapivy3iI1oh3iJwDRmn+XANH/v5K2NGH1+gIe4xtBHnibrd1OGnZ1STNHrKFXjR
	fJXuuRg0x/oJpzeJBpMv+YuvT5TQq2PdTNs1Zns0mET44fu3iklMPdOmx0xqVN64
	1/Gq0g8l/xwGOJgWVLEYyEyXC7dnKHtugChDRiAyCuXg5PyDrmhmqg41mJBkvrLO
	rMMwoA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d40ratynt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 11:57:15 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2c0d15416b3so28567199eec.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 04:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774439835; x=1775044635; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gr18nfu9JJ8gSoYFoxnvVAHkTdc2dAzT6iMHWG8h1ww=;
        b=JwAeZTNcKLc/z4W0Z0XjRtNxvdoN4D1A6oXIIYUJJ1yDQ/EBcLIyNzd0555RTqDDH4
         5mTjaZ0fgKNe647Le9HDApyaJoTKyiZzPqJO18DLfJA53OQBz3zKI5TTcZ+eYvhabuuk
         6h+7T5CAVTmgh5Hv7Bg3mYMrwRIH6rdyOtJad5r5nO+M+KQo97xabIBqF+nFkv8eTSxA
         22QxN3fUono49wCs2X4Y5FjyI7HgztrM15srF8QGYQsteDvez4OXnJM1DcJregNE3KkJ
         MLAeG0qf+zueFW8JFoKzfv7vSiRwSNhxG0TIMbVv7Gp6m+nAfki5kfZyLm16KME1H3Ff
         jaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774439835; x=1775044635;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gr18nfu9JJ8gSoYFoxnvVAHkTdc2dAzT6iMHWG8h1ww=;
        b=FacllAUsSOV1txoZ9Rap5vMZhBhd3K3maE8PgsFVeIw1VYRbS9zbE2wjstxO/E3sub
         1f7rOIjVuT4YDz/N3/iGiPRbwnmyzpDtdA/D8jyd29aJIIl7fihJvcLcpi4rQ5XBJoqW
         biRAf/3lujHJBxe/9gDKQecTFR0h6bNsMy35fc9PW5nJxrhugHh0dkh+d93Ct8U8k0O0
         hLO1lSZ4+BJ9Y8hj+Lje54vcpENQLEkle2idt9hDGl22Vzmy//PWRh6xLrqVyW1DxOfE
         YIOnqNHOZhxohQYYFDUlan4uLmxBrMOMWyoHygA75V+TpCF9PUBA3AbTA4zRpthVIqRw
         NmQA==
X-Forwarded-Encrypted: i=1; AJvYcCWP9y0658FB4YW1ulQpA7R3iNa43qfxcu+uXzZ3sNwcUUFRjRRnm0i1jJSixit1KpiXKOC88wD85w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0k2ozliCt3aexCIthAuCP0JkX7T94xC8t0JMFbqRkgAu+vCWd
	qOakP7fDoQxsKFMlQhHUiYuLEQeIuB5cJU7njYu9yBWcvP14RibfiD/rvkA8GTYKOZkLcYvEWrH
	NIPKYnsURKnHgcgtZ+oQt7aC47m4sF4s6ogaUmRQLvhSxWiMPw0v6uCdIniXGEg==
X-Gm-Gg: ATEYQzxQiq9dHxniQEgFsxpEqOhfFLRN7Y9yuY0X4i6Nhx286DnvD9GjewxMkYs4REN
	UyvPfEGrEawNjw2pl80SRDxBgOE2aNDREtWYPbXVqdevSiROCBH38CH038f7+og2PjIezTTGXqw
	F8aOsDDdkOozqiXN/gpu+3CHbeQs35Jum4fjfnCY0K7WamVx2d0dbfZJfXdXgSr4uOLsmgKiJRs
	fhEo3voa/cRwpkcANu51XQ0J3EVjz0Z7FeI2hNK/WkQ2YjIvHSABhNDvLUPEq1JvUu2e4LJvMeb
	4TqwWZtPWn22dzTPlK44KZv1ZRQXGsTzq5UlHB5Mo5VMN3nQbjDB/bxD2PrlivYSfEs5VmsadRJ
	SRkBVGsOi8PwCE/sLfQ0IA7xYVzrSbq7ctjNK9dBnfxgAYZorEy8TAsGbTh0slqFrEv4LS+sPhy
	q9Eh8=
X-Received: by 2002:a05:7300:7ba0:b0:2be:e4b:60a8 with SMTP id 5a478bee46e88-2c15d31dbfamr1990504eec.7.1774439834841;
        Wed, 25 Mar 2026 04:57:14 -0700 (PDT)
X-Received: by 2002:a05:7300:7ba0:b0:2be:e4b:60a8 with SMTP id 5a478bee46e88-2c15d31dbfamr1990491eec.7.1774439834282;
        Wed, 25 Mar 2026 04:57:14 -0700 (PDT)
Received: from [10.110.19.183] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c10b14c99bsm18187680eec.1.2026.03.25.04.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 04:57:13 -0700 (PDT)
Message-ID: <c86ff571-092e-4181-9bd9-3e99f7c4b1b2@oss.qualcomm.com>
Date: Wed, 25 Mar 2026 19:57:09 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
 <20260312070110.GD2359@sol> <5a310122-bd7e-d10e-653e-bc7e09681478@redhat.com>
 <7f613001-fc2b-44e3-ac14-7e661cf52fdd@gmail.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <7f613001-fc2b-44e3-ac14-7e661cf52fdd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Jvr8bc4C c=1 sm=1 tr=0 ts=69c3cd9b cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=Q6PVb_SgueIFlp-ES8wA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: YoQrYLubSohfAYuVPh9jrontwPx30r7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA4NSBTYWx0ZWRfXygw1Bi8yGuhb
 mVLQLRcZe3/8pf4fuOu3CFp5woG8HRSd1PzTEGarhS3AdNQUftClq8d3UpVIOqy+DInInyXycu/
 F0ckXn/T6YImUyUyUMAaSgqjXo4syiJMb3bb4ygVN+KKDRyqxk8Bz3MJ0X/iRaZ7nkpASeXyWhO
 hP+LRN5TqTMnv3PhX3lfwk1zGZFj4S9l0t/bKfZgH876YRnOIxccqTnJZ++SDeFBOUofdYD6ZDw
 7CaqCulY4X1U9/DN5kyZogOCAqbYgUlZKhe3SdYmXnuz+Co0OXiSAhK64L3tK3IBMJUYWXfTlh3
 nG7KR7lAFEMXvXF+PaF4oVUXlNux5aUUFBOzf43cZJyLkpUEn6J1tav8nmA+YKHtUEnllXw4i/C
 THU5sLd5SK3ZQzlVEjAOts4j9K1Sod+cx45thjmfpWCTezI8mJac+aoRDLe1wgASqbh1PO94LGg
 QrlwA2DWs4u57vE9Zow==
X-Proofpoint-GUID: YoQrYLubSohfAYuVPh9jrontwPx30r7g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250085



On 3/13/2026 11:27 PM, Milan Broz wrote:
> On 3/13/26 2:25 PM, Mikulas Patocka wrote:
>> On Thu, 12 Mar 2026, Eric Biggers wrote:
>>
>>> On Wed, Mar 04, 2026 at 04:17:27AM -0800, Linlin Zhang wrote:
>>>> From: Eric Biggers <ebiggers@google.com>
>>>>
>>>> Add a new device-mapper target "dm-inlinecrypt" that is similar to
>>>> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
>>>> This allows it to take advantage of inline encryption hardware such as
>>>> that commonly built into UFS host controllers.
> 
> ...
> 
>>> I don't think it's plausible that this new patch was actually tested.
>>> The version I sent in 2024 was tested at the time
>>> (https://lore.kernel.org/r/20241016232748.134211-3-ebiggers@kernel.org/),
>>> but I see at least two things that would make this new patch not work.
> 
> What a waste of time... thanks.
>> OK. I dropped it.
> 
> Well, the inline crypt has some advantages to proprietary internal
> hw implementations (like self-encrypting drives)  - it can be actually validated
> comparing to sw version.
> 
> Anyway, Mikulas, if this dm-inlinecrypt returns one day, please be
> sure that we do not have security-related "regressions" like not supporting
> keyring. There is no need for dm-inlinecrypt to keep key inside the mapping table.
> The keyring code is in dm-crypt, it should be easy to adapt it here.
> 
> Thanks,
> Milan
> 

Thanks for your review.

I understood that supporting keyring here is to ensure no raw key exposed to
dm table. As implied by the name dm-inlinecrypt, the key used by dm-inlinecyrpt
is a wrapped key, rather raw key. Can we keep the wrapped key inside the mapping
table?
In other word, can dm-inlinecrypt support both keyring and hex key(key in mapping
table)?

Thanks,
Linlin
