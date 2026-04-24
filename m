Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD73C3D6494
	for <dm-devel@lists.linux.dev>; Fri, 24 Apr 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038814; cv=none; b=MjuxTi0MGMzKI5G00PZKzA1RbAOEDj4ZtB2M4jqJzSoTATEuvpmoVCnv2OIlgi5BvC6/BUQL2ryd77VcWD+oYVmbE7lWJu6BEw79Th+UBzfZyGVpRquYq4VBXqkBEVmpv7UGoj6bGpkoXLFRjuiul9Lpw0XTBsbCbmZyurDsKEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038814; c=relaxed/simple;
	bh=Ew/WV0PUTr0b3usbEk/Lg6XKBeQ1rjvblixshSrvBb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPr2Qjvc14reR19/TJEAwK3dlT6OF5qRa/9IVZ3a3fxthB0kc8OZ8vPzbh/P7U/6Jbh3cSziSFala7Z6N/QXQ9OqI6XggT0po9dWmoUg8shk0YtHb26AQaIPx9uKOtAAftDyclB/2yrEcYpX/39xqg5ahxhYzZyFvWWrK79G9q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D6Zvbauf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kMQdDQC5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D6Zvbauf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kMQdDQC5"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63O9W2le756614
	for <dm-devel@lists.linux.dev>; Fri, 24 Apr 2026 13:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	F8PoJPEsRbQRU9RB6wNnJ9EpTGXTP8HI8ZOx3/+rwVA=; b=D6Zvbaufpi1byZhs
	x1fHDUi3wN4G/kJT1JMgu4Oc4XtfHQmkNuMPGg7GG+qXMeLXiCfoB1s/Ecj5QsBL
	MfmlhkrcBP/9/3N2DGulHpYSNQVC/BtGggdBIffc7IY8JkSk/CmCQP/0WarBqVyF
	J/0P7XvGWfqCO9EmCoPvhnTe4LQH+osWDmuM7HOHtOv4eJdsim2pTyCz+gZkaw3T
	5g3yh1xkj9Ks9Yu2nqZf7T3T1LmKYyYjX9+kfLEM014W+5EJYOcTLV2fY//bcDEE
	Nisztc9D/K/EJMWmhEfaoQh0oB+6iAye9iOq4LLuisGIp+Gr/EQ16JSwk2vVxDoT
	8ro3ow==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dqr4bmbud-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 24 Apr 2026 13:53:31 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2ddd8ef5343so7574423eec.1
        for <dm-devel@lists.linux.dev>; Fri, 24 Apr 2026 06:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777038811; x=1777643611; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F8PoJPEsRbQRU9RB6wNnJ9EpTGXTP8HI8ZOx3/+rwVA=;
        b=kMQdDQC5z/TAnM4ASwVMbhB6a8L6Pess21p/p3YVReBck8GPx4Uu/PpXROKTz0sqqQ
         F6UcHhORXuMDt1nkHPxdFUZeBYQs4HJhEA93wjdS+UFxfJj2N3fmMDnFr9/Y3Vp6mgYJ
         ppLc+UciW+CqLA2Rj5WR37FnJYBREFrldoVOdLqdnkt0R0A5HLy8izdNWtfCkCuMtjJy
         LNB6zKzjIDlPFt+faEPKO2eoMeVKz08Zl4jCeVPNymHI729cgqza1Sof7GEgMbFtcVQ2
         L1L9/tK3fr9POTmLo8UhVTpv2JKaEZVCcEblvsimT4uIQQtaMRjn6vWuPN23UQH/GpKn
         0X/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777038811; x=1777643611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8PoJPEsRbQRU9RB6wNnJ9EpTGXTP8HI8ZOx3/+rwVA=;
        b=TtfCE1NpwO+/TpkpKRvPIDI6WAiZBbk/2PMfZRTQwOk+aL2rl6hE207LW2ZiIx0fjC
         GU68lY1Xqrjf6MToSt/SdkhRwDxIS/6jC8Ev1+7A3dozQtKoOsO8fxg9bzQ7qvwCqvb1
         Sc2UBG2HGAazaTOaWKc5kHTvfzKUZUlv14mYHhmt+tx4EEu7LurFCMQcQEswcshANlbG
         MxYZqd5YBrq9kKnrZeknwMslzVwxv1+F1UThsI2EcUkp2gliKGRFPcXBUk+enk1ldIBw
         QdC9dPQaBFC3imdff85VU+L/2DhnhHiyDjzixeNubqWfVM0J2OdY6o9E3qntv4C5b+Kz
         fXmQ==
X-Forwarded-Encrypted: i=1; AFNElJ+0mDmKZP2WHiDSGJk0sMcxEXBp48oc3v9s5Lb2UXdQVrb8GLZP31IA4ZKPIUDVmB2tWs2EJuLi4A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwbAP+JipU0OBIBL6JdoPGuejv9RhPG0xD0Yzerhnt/0J1CDxHp
	6nlCLHhlPyy3s5edsAK5JZtc0QDbwo8m8ji8zvXNWxTnMD6YeVNQDgo7FK/iUJdloebys7Zi/oz
	Pd3uZ0Y7epbIsZe9M6OVE3ODy3ItyNgwZkWg0ENpLxcyU5sLu7rSF0BBN8smOag==
X-Gm-Gg: AeBDieuZOpVth7XkDoOLhRaNMhsBI5pm6S+HuDmxvj2kreIzGmmkr0OXgja/k8sX/97
	5+dhw3lhD6V1Ow/1Pf9AA95LMZhA6mpenMcBaDT3kG1l2odg43Vhk1dn3eWQO6M5dn+TFZxBvo2
	PBkdyCzefrwM2eBQsezW3AzNPn/zNfQ6qN4y0HAX9jYg4qNJOLLJMGJtSnVrnarqtfsOzmIKQXZ
	OPCKx3Kzenh/lJPwV01Nufucdkt+uswDZy6oZUdLHevl0FLmScrRHd+WsBIchBcgpv3PSljxQyi
	Es2KSGnOQgxapsKcgfBdP5/WeRuyOLF2GdvHDQKppyv4x0TmmvBSbwI2yAHH8pN/qBP5H2XS2Vi
	5ISk5Xed3uvbdphj1EQ8UhRutUdTk10zZ1ZtNiXZ4Bt/DpIdIxvXqxxHuHlaBzAHvGHY7LTIfe6
	KTxmFaDW+Va6WNvA==
X-Received: by 2002:a05:693c:8005:b0:2dd:144b:6c2 with SMTP id 5a478bee46e88-2e478e28c50mr12950275eec.27.1777038810411;
        Fri, 24 Apr 2026 06:53:30 -0700 (PDT)
X-Received: by 2002:a05:693c:8005:b0:2dd:144b:6c2 with SMTP id 5a478bee46e88-2e478e28c50mr12950239eec.27.1777038809634;
        Fri, 24 Apr 2026 06:53:29 -0700 (PDT)
Received: from [10.110.109.54] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e79c2954f6sm34425608eec.30.2026.04.24.06.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 06:53:29 -0700 (PDT)
Message-ID: <dd833ec9-9e9e-417e-8a6a-688987a499e8@oss.qualcomm.com>
Date: Fri, 24 Apr 2026 21:53:24 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] dm: add documentation for dm-inlinecrypt target
To: Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
        ebiggers@kernel.org, mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-4-linlin.zhang@oss.qualcomm.com>
 <1a36c5e7-5fd6-4923-926e-65bb04c33b04@gmail.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <1a36c5e7-5fd6-4923-926e-65bb04c33b04@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDEzMyBTYWx0ZWRfX0YviUKuTb9w7
 +schn8k0Vp3PBYRNJYAgpEpTTsDCSK4Cb83j6p4MhUfiK2AKFy4ztg1vzQ4QgKgVVxNzWM6Jin4
 EonnvZ3gSBHIZE8kbnQwJdQHr8fuAbJLNZ3BAJa3TDSTIRz42zt+thDNN5x3HML6gvzYhUpWlhv
 MUxxUomIEHp95mbLC0VwQXYhk1sTNpOlbK0+xA4LO2iUoNlLLMOWXLmcVjw/JI2pkno+EtCxXT6
 VKpT76qAP6GmPCLz2BPugHmbflyN6gqdRyynbCWfj/ROMnG0DkSV5sONYwYw90D3WAgnfmfU4I6
 sozulzNWPQl//YUsjimNyXqeTaoq0GVySKFVd4IgkztQ7E+qdAJQjdrI0qA6CCsb5T/e7DbWiNT
 vCYUg/sBTY3ujavskcVqkbt0QR+3jfqH6vHKTy9UmyF662XOd4uIkymDNtMW9zg1Wo4NEvixOTU
 xypf+yDBjUx3XxbpXgQ==
X-Authority-Analysis: v=2.4 cv=TtnWQjXh c=1 sm=1 tr=0 ts=69eb75db cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=p0WdMEafAAAA:8 a=EUspDBNiAAAA:8 a=9XuA7vtyGULosQ0LkOoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: wUwRwZ722QdoKhBf1fVu9-4xwTyHYDYF
X-Proofpoint-GUID: wUwRwZ722QdoKhBf1fVu9-4xwTyHYDYF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-24_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604240133



On 4/11/2026 1:07 AM, Milan Broz wrote:
> On 4/10/26 3:40 PM, Linlin Zhang wrote:
>> This adds the admin-guide documentation for dm-inlinecrypt.
>>
>> dm-inlinecrypt.rst is the guide to using dm-inlinecrypt.
>>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
> 
> ...
> 
>> +
>> +<cipher>
>> +    Encryption cipher type.
>> +
>> +    The cipher specifications format is::
>> +
>> +       cipher
>> +
>> +    Examples::
>> +
>> +       aes-xts-plain64
>> +
>> +    The cipher type is correspond one-to-one with encryption modes. For
> 
> ... with encryption modes supported for inline crypto in block layer?
> 
> In your patch only BLK_ENCRYPTION_MODE_AES_256_XTS.

Thanks for your insights!

Yes, here the encryption modes refer to the inline crypto modessupported
by the block layer. Currently, this patch only supports
BLK_ENCRYPTION_MODE_AES_256_XTS. 

I will reword it as:

  The cipher type corresponds to the encryption modes supported by
  inline crypto in the block layer. Currently, only
  BLK_ENCRYPTION_MODE_AES_256_XTS (i.e. aes-xts-plain64) is supported.

Could you please let me know if you expect more than that?

> 
>> +    instance, the corresponding crypto mode of aes-xts-plain64 is
>> +    BLK_ENCRYPTION_MODE_AES_256_XTS.
> 
> ...
> 
>> +iv_large_sectors
>> +   IV generators will use sector number counted in <sector_size> units
>> +   instead of default 512 bytes sectors.
>> +
>> +   For example, if <sector_size> is 4096 bytes, plain64 IV for the second
>> +   sector will be 8 (without flag) and 1 if iv_large_sectors is present.
>> +   The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
>> +   if this flag is specified.
> 
> Is it true? I see this comment in the code:
> 
> /* dm-inlinecrypt doesn't implement iv_large_sectors=false. */

Thanks for your comment!

The example is describing the general IV generation semantics of
iv_large_sectors versus the legacy behavior, i.e. how plain64 IVs
would be computed conceptually with and without the flag.
However, for dm-inlinecrypt, the comment you quoted is correct:
iv_large_sectors=false is not implemented. When a sector size
larger than 512 bytes is used, iv_large_sectors is mandatory, and
the legacy 512-byte-based IV behavior is intentionally unsupported.

In the code this is enforced by rejecting configurations where
sector_size != 512 and iv_large_sectors is not specified, so in
practice the “without flag” case is not usable for dm-inlinecrypt.

I reword it as:

  iv_large_sectors
      Use <sector_size>-based sector numbers for IV generation instead of
      512-byte sectors.

      For dm-inlinecrypt, this flag must be specified when <sector_size>
      is larger than 512 bytes. The legacy 512-byte-based IV behavior is
      not supported.

      When specified, if <sector_size> is 4096 bytes, plain64 IV for the
      second sector will be 1, and <iv_offset> must be a multiple of
      <sector_size> (in 512-byte units).

Do think it's enough?

> 
> ...
> 
>> +Example scripts
>> +===============
>> +LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
>> +encryption with dm-inlinecrypt using the 'cryptsetup' utility, see
>> +https://gitlab.com/cryptsetup/cryptsetup
> 
> Cryptsetup has no support for inlinecrypt and it is question if it should have.
> It would require additional options and maybe LUKS2 metadata flag to make it persistent.
> 
> How did you test it? Please remove this cryptsetup example.
> It can be added later when userspace get this functionality.

You are right.

cryptsetup currently has no support for dm-inlinecrypt, and the example
would indeed create a dm-crypt device instead. Supporting dm-inlinecrypt
in cryptsetup would require explicit userspace changes and possibly
extensions to LUKS2 metadata to make it persistent.

I did the testing using dmsetup directly, not via cryptsetup/LUKS. And
I'll remove the LUKS/cryptsetup references and examples from the
documentation and leave LUKS integration to be documented once
userspace support exists.

I reword it as:

  Currently, dm-inlinecrypt devices must be set up directly using dmsetup.
  There is no userspace support yet to integrate dm-inlinecrypt with LUKS
  or cryptsetup. In particular, cryptsetup currently only supports
  dm-crypt, and cannot be used to create dm-inlinecrypt mappings.

  The following examples demonstrate how to create dm-inlinecrypt devices
  using dmsetup.

> 
> ...> +
>> +    #!/bin/sh
>> +    # Create a inlinecrypt device using cryptsetup and LUKS header with default cipher
>> +    cryptsetup luksFormat $1
>> +    cryptsetup luksOpen $1 inlinecrypt1
> 
> ditto. This example will use dm-crypt, not dm-inlinecrypt.

ACK

> 
> Milan
> 

