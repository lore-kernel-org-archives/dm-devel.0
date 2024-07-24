Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124D824B29
	for <dm-devel@lists.linux.dev>; Thu, 25 Jul 2024 04:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721883509; cv=none; b=l/oGNLeAIRC/urhH7d2EiaEhkWzeehjGi+XdaUrBqrT0vpHTTWRhEzlsHwYodbjBO1Tk8ZyVrNMA7do8f/r/LQ5jucdJ122OW+n9nhtgpiZZOR0/kSdQWJrJfh0xFrO0G++YsboYUreNFmeU8D5jb/q6ddVJGMUfuuD5BTqwINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721883509; c=relaxed/simple;
	bh=LrinzDRt6dPz/chiwGnyu9iDQwMj3R8JpBKPysg8pPI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=IVXisImEjvQ/fKNLWyaSIA8/OH824IeMSb2eFF7upwmx7gz2cCKADfIM41cbpiIQ3KxEg08lEA6Rtmw0SnvB/RLNeD9v7slCY0EwiuLrbnYvhzHH5O6LKf0qatiUMiRbYaXG0zP9e8+ltAqPYR9pLdQbcFw8WtyOVLIYzGN8vlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TB2WcA5g; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TB2WcA5g"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240725045824epoutp034948e012cd01c1e52067642672ef60d4~lW_y8HeWl1831918319epoutp033
	for <dm-devel@lists.linux.dev>; Thu, 25 Jul 2024 04:58:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240725045824epoutp034948e012cd01c1e52067642672ef60d4~lW_y8HeWl1831918319epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721883504;
	bh=W4naWMM7dPSQ3+1LzanpK71B6slavNy1FiY1Ow1nhtU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TB2WcA5gJu9bXo48d1wnUI+ol/DqRLQBVdwSuM2WZXoFmhIoqElBvMpnfT51STNNg
	 gjffY0gwLnP5BxTzA8vCPvSwr2uas5k2RcgIXEqopVtL1aFiCjwDAd04eLP4AtKv3t
	 SkE+jlkIVLzm0/N32k0tXH8fzgs+GJa4Fk9nZVC4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240725045824epcas5p2723c72b0a972dcca5a4271f21f592fc8~lW_ykhlBD2901229012epcas5p2A;
	Thu, 25 Jul 2024 04:58:24 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WTzDH17bPz4x9Q6; Thu, 25 Jul
	2024 04:58:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.13.08855.E6BD1A66; Thu, 25 Jul 2024 13:58:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240724183644epcas5p4120e64a2de7faeafaa5995f68c710b86~lOgAcaSFF3133031330epcas5p4l;
	Wed, 24 Jul 2024 18:36:44 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240724183644epsmtrp2677b03bc900ccc3092fbdaf5e336a6dd~lOgAb2b8p1193811938epsmtrp2S;
	Wed, 24 Jul 2024 18:36:44 +0000 (GMT)
X-AuditID: b6c32a44-15fb870000002297-a9-66a1db6e1427
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D5.D9.08456.CB941A66; Thu, 25 Jul 2024 03:36:44 +0900 (KST)
Received: from nj.shetty?samsung.com (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240724183643epsmtip1a2e1e318fada5110c9c2d1917587bfc3~lOf-QLkeO2887828878epsmtip1o;
	Wed, 24 Jul 2024 18:36:43 +0000 (GMT)
Date: Wed, 24 Jul 2024 23:59:29 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, Bart Van Assche
	<bvanassche@acm.org>, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz
	<gmazyland@gmail.com>, Bryan Gurney <bgurney@redhat.com>
Subject: Re: dm/002: add --retry option to dmsetup remove command
Message-ID: <20240724182929.j6s6odzizlbs6en2@nj.shetty@samsung.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmhm7+7YVpBv+amSyeb/nMZDHtw09m
	iwWL5rJYHNs/i91i7y1ti4kdV5ks9s3ydGD3uHzF22PnrLvsHi82z2T0eL/vKpvH501yHu0H
	upkC2KKybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	DlFSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZ
	AhUmZGf0zVnOWLBcsOLTulWMDYwr+LoYOTgkBEwkmt9odDFycggJ7GaUaG+v7mLkArI/MUqc
	OL+cBcL5xihx5kUHO0gVSMO1R2eYIBJ7GSWWXe5ghHA+M0rcWLKHGaSKRUBVYt6bo2wgK9gE
	tCVO/+cACYsImElcOfaGHaSeWeA8o8Sh6RcYQRLCAo4Su1c/A+vlFXCWOL7iFguELShxcuYT
	FpA5nAJOEi/3yoH0Sgh8ZZfYeWolM8RFLhIbztxjhbCFJV4d3wJ1qZTE53d72SDscomVU1aw
	QTS3MErMuj6LESJhL9F6qh9sELNAhsS/NZ+ZIOKyElNPrWOCiPNJ9P5+AhXnldgxD8ZWlliz
	fgHUAkmJa98b2SBh6iHROF0XEihTGSU6bzWyT2CUm4Xkn1lI1kHYVhKdH5pYZwG1MwtISyz/
	xwFhakqs36W/gJF1FaNkakFxbnpqsmmBYV5qOTyOk/NzNzGCk6aWyw7GG/P/6R1iZOJgPMQo
	wcGsJML75NXcNCHelMTKqtSi/Pii0pzU4kOMpsD4mcgsJZqcD0zbeSXxhiaWBiZmZmYmlsZm
	hkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MB1d3qh5bkdRzVr2FRbMz6Ocu9Z2lRWsnHpN
	ceYuK/+qT2d/HwqYX1esPJfz6imWry/YFm7n/3zqczTPYunNt14fmLTFPkcm73LcLZ7+fj5h
	qwyjY5cbTqWxfnip+sbm5LQ38yZM2xq24PSNz0uffcmunf+l8sqN6W6/Z0gZv2V71yUakZm2
	NULEauFCVj/Gdq4o25NVoZxuE2NXL2s75cN/2tlD235V8KIrERUhVV1ndSo+8lg+D249Ede/
	oWRinlBrRfKOoClmMz6nCMfsCP7qV5d8MYCJeVXk31U/V/iqFC46P6m6cOLqGQuWqNlUHXon
	4BWXN+fm1U3sl+aFPjkT67N29/sGwVWmp3TDmdKVWIozEg21mIuKEwG7OmMLIwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnO4ez4VpBnfeyFo83/KZyWLah5/M
	FgsWzWWxOLZ/FrvF3lvaFhM7rjJZ7Jvl6cDucfmKt8fOWXfZPV5snsno8X7fVTaPz5vkPNoP
	dDMFsEVx2aSk5mSWpRbp2yVwZfyeZVNwk6/i+fkfzA2MX7i7GDk5JARMJK49OsMEYgsJ7GaU
	eDhRASIuKbHs7xFmCFtYYuW/5+xdjFxANR8ZJW6fu8UKkmARUJWY9+YoWxcjBwebgLbE6f8c
	IGERATOJK8fegNUzC1xklDg5pxdskLCAo8Tu1c/AbF4BZ4njK26xQCx2lGjaMpkdIi4ocXLm
	E7A4M9CgeZsfMoPMZxaQllj+jwPE5BRwkni5V24Co8AsJA2zkDTMQmhYwMi8ilEytaA4Nz23
	2LDAKC+1XK84Mbe4NC9dLzk/dxMjONC1tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeJ6/mpgnxpiRW
	VqUW5ccXleakFh9ilOZgURLn/fa6N0VIID2xJDU7NbUgtQgmy8TBKdXAVMTXpLolKnO9U4S2
	KveafVNSvG/NmaDIZhT5+c+xC91xq+TfbS1WXdOoI6N55cmxzvw9mzj2beNLnWW470TXVv+3
	hxsrJnSKNj4tebr74IHC/vgHxxu5eIrOC3YWbmw8lDtP5PcvgcSFzYWPO4SWFhl4Sh3x0bmV
	ndq2ZctblqMfaz0Frs19FnDu2rQ1H+fah5oFFPhdDxRL2scodO+r4r0w2y4e3gcLHl/cM9vT
	6vuzJaJmO/XPB51WuFO0XahSopBHL3bul1uOpqqZU76uOKn10f3/ktKYyalSG3yO/XbWW3Zl
	Synreca3T2SZuizl2ROnFIrwMv3gvvhx1eotWv4Zi298kzqkN+XZxquH9yqxFGckGmoxFxUn
	AgDpXwZL4wIAAA==
X-CMS-MailID: 20240724183644epcas5p4120e64a2de7faeafaa5995f68c710b86
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----RCuM6wVB48pawI-qxLd.rstOHb-XiW.9xtXF.Se3-DdujaWQ=_3e802_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240724183644epcas5p4120e64a2de7faeafaa5995f68c710b86
References: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
	<CGME20240724183644epcas5p4120e64a2de7faeafaa5995f68c710b86@epcas5p4.samsung.com>

------RCuM6wVB48pawI-qxLd.rstOHb-XiW.9xtXF.Se3-DdujaWQ=_3e802_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/07/24 01:58PM, Shin'ichiro Kawasaki wrote:
>The test case dm/002 rarely fails with the message below:
>
>dm/002 => nvme0n1 (dm-dust general functionality test)       [failed]
>    runtime  0.204s  ...  0.174s
>    --- tests/dm/002.out        2024-06-14 14:37:40.480794693 +0900
>    +++ /home/shin/Blktests/blktests/results/nvme0n1/dm/002.out.bad     2024-06-14 21:38:18.588976499 +0900
>    @@ -7,4 +7,6 @@
>     countbadblocks: 0 badblock(s) found
>     countbadblocks: 3 badblock(s) found
>     countbadblocks: 0 badblock(s) found
>    +device-mapper: remove ioctl on dust1  failed: Device or resource busy
>    +Command failed.
>     Test complete
>modprobe: FATAL: Module dm_dust is in use.
>
>When udev opens the dm device, "dmsetup remove" command also tries to
>open the device and fails with EBUSY. To avoid the failure, add the
>--retry option to the dmsetup command.
>
>Suggested-by: Milan Broz <gmazyland@gmail.com>
>Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>---
>This patch addresses a failure found during the debug work for another
>dm/002 failure [1].
>
>[1] https://lore.kernel.org/linux-block/42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr/
>
Tested-by: Nitesh Shetty <nj.shetty@samsung.com>

>Changes from v2:
>* "dmsetup remove --retry " instead of "udevadm settle"
>Changes from v1:
>* "udevadm settle" instead of retrying "dmsetup remove"
>
> tests/dm/002 | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/tests/dm/002 b/tests/dm/002
>index fae3986..ea3f684 100755
>--- a/tests/dm/002
>+++ b/tests/dm/002
>@@ -37,7 +37,7 @@ test_device() {
> 	sync
> 	dmsetup message dust1 0 countbadblocks
> 	sync
>-	dmsetup remove dust1
>+	dmsetup remove --retry dust1 |& grep -v "Device or resource busy"
>
> 	echo "Test complete"
> }
>-- 
>2.45.2
>

------RCuM6wVB48pawI-qxLd.rstOHb-XiW.9xtXF.Se3-DdujaWQ=_3e802_
Content-Type: text/plain; charset="utf-8"


------RCuM6wVB48pawI-qxLd.rstOHb-XiW.9xtXF.Se3-DdujaWQ=_3e802_--
