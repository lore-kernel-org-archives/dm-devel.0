Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F915D5BD
	for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 11:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716809739; cv=fail; b=kRYWhqJxIu22atZju5GvRnRyng8/1wEYHetMQW6Au3fgPwzmYSMg+ihAW7KkVc5Yh46+CY3boi4kYPDSKUqCFQ2hMitnVsaqV+FHSfgB5GwLER3x3mNlfw1o3LEgzBqyv+RA4VON7KOnKi/2ku5ZxoxPKQU+lsQ6JzZkl9g4OuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716809739; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZmqOmN9fp1159tiG6DCM+I4ALlp+PvVDn/GRSjHpd7VNTqVZGRY9AhFfGr8X5xNHTX2TWJ8pw3pXRwjId833FCwAwaWip7rBj4eh6NVzII4pxRUZkYPODqQ1nVw2vVJ0zzyZji446B1LsOdh+n4fTdJAuTQPOUYUxA8qvJUbqSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F03x0ee5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BWw4a27S; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F03x0ee5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BWw4a27S"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716809735; x=1748345735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=F03x0ee5EbYtdf6Tm4vtD2VVMLtz1oyRXik4JHFQQXbI4RTIZdnblRss
   GvECbqA+PQ2ENRO9hLrswDqoLqNhKLVv2vgQ4YfoRa7maXkDU+Qyej069
   LlGYdpUOq+P8VjLxwtDaWFyPc/s+RdZdfd5CDldtO2U1tflMCZJxx34O/
   g5vMKXTdrljXGkUnLgR35c2BXUgdevGFAW6CfKHpvkjAWYHIRDA1hcBOl
   3qKBWnJGJsAqCvwpLmTJK9T2CvMSuFHV1XDQQ5HNyvUJdexzELr3xDAIx
   EBq1CEEXqRM9sQKX4jogBlyithhW/XzIWFfl9b9dwAU3KLBff1T1HcGHd
   w==;
X-CSE-ConnectionGUID: dTJrEYp2T4ecSmXUB7Ks4A==
X-CSE-MsgGUID: vmjWtmwHT8m7oqeN8yQY3w==
X-IronPort-AV: E=Sophos;i="6.08,192,1712592000"; 
   d="scan'208";a="18190329"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2024 19:35:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRKp4UC8JM2UsUJL63xBGL7ojaT7CVArqRhi4ZQzzcMCHpP4FLjWMHKFSt1EzVY3Deop+d+vGrpdA3yu9TPnDsPeF6nwaqpUENUPihrX9mlFocTjpA9L9zsuylk5MRLYTgfTdiDNVM5mADvkXbZNGeLAf1VdYxEAA2DuEi+1LVw+VRCyYNO1tegi9ce0b7aA7n8Ej3JN2vGXRHbp/rwLkNlrPpBpMdt1LbOW5nzSCZYG/BiteFH7tw3SM3Ek9YPDug+FJCOhX99qfcGGAy8obnvgIrBroSJ49m22rxCvP2EJLRHBzNtB2R7Olz5HTbkmzzR5XRkV0DIeo5Ga0F2gyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=oAmy0kUO8y9YT10vlgNCoWYgwwe6WoFUj2CA11EzYYae8P1Xk1I7KjKryxGEbUhj+f1PDS2M4PtX2SRpQi7jzImHfM5xR94NHI4rZjpHNewC8kx4jwssSJF0/F5lHXgK1RXSaDPMeyKhIzY0oqXGpc43lv5ed+UYDEK232k1/GOnLmAj43kdIfdpInalE5jPBlI0OIOW4Knn5MwqRtpqbwzGtFjWp5P9U0iAM0cf8+/ZaceknHaVcH1wc5g8MOcZgt1xuadTBy80jc7DKqJ+PBsK7h+YlylWctoXxoGl2pO/yRaSYby6UQ8g245a1mLQfFz8MMGY3raAmJowXPShZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=BWw4a27SoBA3cwrQCo5j1YRigrMMdY//GwfUl3KvsTMIPODfXW1rpP9PYUcG5zQBbKYmIA8p7LvSgz6I9CjS+ZzOuwhTBmSYJ3UKzPjIfDR07bRd4fjzlzardlapdnZ5i7PY/tlzT70xDKJRQ8ODrQOMctOjHocGX0hS+/RNe0M=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7884.namprd04.prod.outlook.com (2603:10b6:510:eb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 11:35:33 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 11:35:32 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Damien Le Moal <dlemoal@kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] dm: make dm_set_zones_restrictions work on the queue
 limits
Thread-Topic: [PATCH 3/3] dm: make dm_set_zones_restrictions work on the queue
 limits
Thread-Index: AQHasAykKjOaclj2MU2YsYQve7Pi9rGq890A
Date: Mon, 27 May 2024 11:35:32 +0000
Message-ID: <0736a7bd-c134-4c7b-8aec-414dab175e34@wdc.com>
References: <20240527080435.1029612-1-hch@lst.de>
 <20240527080435.1029612-4-hch@lst.de>
In-Reply-To: <20240527080435.1029612-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB7884:EE_
x-ms-office365-filtering-correlation-id: dda4267d-ed32-478f-f993-08dc7e411e7d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?RzFEYWpNdGpYRU9LcXREYjk0UXVpbktYVW16RkNRUnRvWWUwK3pQY1pRWEoz?=
 =?utf-8?B?WEhGbm9CT3hlMUxUOEtxSk55WE4xM2VWejZYeHluZ3hSemx4eXk3QUxLTEtZ?=
 =?utf-8?B?SXFlRDFEZzQxeG0yMTA5bnRYUzZwMytXMmNlaGFlNUlQTTVCZS9aM0wycVlo?=
 =?utf-8?B?empleDZ2WnlmSkdidjJpNWZ0TGlvdkdSWHpEZ1RjLzY1L3YweFJMS3hXR2tm?=
 =?utf-8?B?Z2piY0VKMGpheW9GSGZ2cTF0eUMybHQ4dmU2SU42TCtKbTJJc2FXT2cxRkZX?=
 =?utf-8?B?bVZaSy9STnNPUjVWV3hjbmREeHAvM2ZncmowZ3hRa0JGVkUvUWZJeVFzODFT?=
 =?utf-8?B?RzFOTm1rMjAwK2hmSmFtbHBHLzdqbkNlcTVyUWxPYnVkRWNybzZvTzViWEdj?=
 =?utf-8?B?UnNhVVJ1c1hNUExBYjZlS05BUk8rL3hVVVh1aUlJWFFaRnJrWWJJV2Foek9N?=
 =?utf-8?B?OWtQSjA1cDBOaURuZ1FQZjk2N0d0dndHbi9QeFI5SVI2RkltUmVHVTlRUXM2?=
 =?utf-8?B?UXFFeFowRlNIQnVoekoyN1RTYnlPZGY5TnZlOTNuK0JHV3pKNXlaSWI5TWJp?=
 =?utf-8?B?LzZLVlpKdThJNnBFMVpHdnROb2p3bmdlV1Zuc0RNUUlHd0ZXTDA0b3dtZ2NX?=
 =?utf-8?B?Y0FHR21mbnBkZE0xTm44aUNCTnBZZWRiR1FOOGQ0YWpXTFZ2MHN6ZTdHNUJq?=
 =?utf-8?B?U2hPYlRwTGdNSGlGb0s5a1c1bnNtYnZRRDc0VkZGenNMVk9TZzlnNkY4c28z?=
 =?utf-8?B?aFh5T3A5bzk0T3I2akRwVXB3K2czdjRHM2dRN2JOdjJKeHZmM3FhSm9Cdlo0?=
 =?utf-8?B?UHdsYlI3SFhuUjBtekVDeTlZYVc2c0pGVGg3Njg2Vnh2S1FzTU12a1JvL08r?=
 =?utf-8?B?MHVJRWs0TXkwdGRDOXJ6NkhRYkVES29HRFRvVTIzczRzb0ZFTEh2ZGIyYlF3?=
 =?utf-8?B?SVo3bUh3WmQwRjhTajdkZVp1M1JGUkg5YnU3djk3WHpQUmYvTmZvd0tFZzly?=
 =?utf-8?B?cHphU0hYQXFxYUxqNHhSRnJEQ3FxSDRYWVVKNjJyZzZ2L3JueGpxODN4T044?=
 =?utf-8?B?Y0hSYWhKRDRMRi9PU0ZYKzhaUTZ6aHMyRmRET3N4THVvcnNZek54cG8yTUNz?=
 =?utf-8?B?bFJFOTMxU0VYQTA5dUtHNytNVnpOeXVKY1JVR1NqTWdJK3ZhZ3JDSEltbS8x?=
 =?utf-8?B?Y2xlMzZPWEhVbG1MbTNNRFBET3h2V1YxN25mQzNRcTZkOUFJdjU3dkdVSjUr?=
 =?utf-8?B?OThyWnVyaytPaUgwL3g2VGFnWUtwQlg3RUV3MnpEVSs0VndGVDdOSXF6TjdE?=
 =?utf-8?B?WmViL0UxNEtLTnJZYVFXTFJ1em0yNXlSTThBSy9OQURoN0RSMVEzNzR2dWNi?=
 =?utf-8?B?NTJhMnlPUFhJblRMWXFHN01OS2tuWHpwYzBXS2pMS3c1cFNteXNETkk3NWtD?=
 =?utf-8?B?US9nbGF1NnRGT01UeXdtVDloYnA2ellWZHd2dDhCaHRQSkhqekQ3YkVhcEhl?=
 =?utf-8?B?ZmtjcStzVmg1RFpOZUI0MGpuOWtUenpVWWZCK3VLMmRUZzNLV2UyMTB2cmxz?=
 =?utf-8?B?U1Q2c1pBMTNYWXJrYlZyOEZWNEVMR1ZrRVpXYmRENnBVK3NUc1ArTmxoc2Fh?=
 =?utf-8?B?djM4NFpSU201Q216VzF3czROendQQi85VnY4YWpzNDlnR1h0OUFGenhkWU40?=
 =?utf-8?B?bjVrNWxMaGgycVAvR09EWWZ6MzZMdVBVWHoxVXJwSFZNd0JnMkZCVWl0UXlZ?=
 =?utf-8?B?cHpCMkYrMmp4NitSd3grNnE0SVpwWUpucXREekZZaXJHQmlGOUdESVVzRzQ1?=
 =?utf-8?B?S3QxdE1wRHFJVXhLRUpHUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MDdSa0RMQXdQNkVuaHkyY1pvaXBwSmtvNWFKSzBFSlhFcys4QjVPeVhIQVor?=
 =?utf-8?B?NkhBeTM0Q2tDZElmTy96aXFuRUZpRjBHTGxCOVZxcUo1R2dGYUtnaFBISndW?=
 =?utf-8?B?bm15LytERFd5ZlpHM2t5aTFXS1JvTDhyTjJ5bVFKalNpSDdTdnE2S2tOK01m?=
 =?utf-8?B?cW0zN0tUcExGcEcxVCt3ZGtMOTBoQkQvL0ZxVUEzZUdTVUcyN0p1TGhoVzNC?=
 =?utf-8?B?N3cvcHlhbE9sSmpKWXpZcThFQndBeU4zcVRvdUt2WXdwUzlycWFYdUZEWjFs?=
 =?utf-8?B?WllPTEVzNVk4RnBoS3ZFWHJueWZsbi95WVByTDF4OXJQdDdRWDZCUjcrTVBq?=
 =?utf-8?B?YzdqNUl0V00wWXdKNTlkZFZxTXVldUFlYk9FZGhHc3F0dFNTc0UzQ0d1ZktT?=
 =?utf-8?B?R0NtSkVmVHpaU1A0bGgvVzkybThYRTI2Y2FmM1BvZ3NXSXJSakRlOW5FN1pU?=
 =?utf-8?B?dXpIbHUrVHRUcVBTTDVJTG5tTlo2MklEdFppenBTWVBFSUxsVk9MWmhadkcy?=
 =?utf-8?B?YjNRL0g4TytNckR3V0tqZFNISnJpQnNVK0lLR0lwenljR3ZtekZ0eHUvZU5D?=
 =?utf-8?B?VVJLM3FtTk5VRHFOOG94aVExL0xTWlorTWg1MTNnNTNkdFBMeFdkS1BnelRD?=
 =?utf-8?B?T3VCZVY3L21YNW5KM0xJQm5jZER6OUp6TEtOYUZ2d3FDZG9RMW1rcndPbGdG?=
 =?utf-8?B?TE1DOVkwdzZkU3RyZ0xack5GSThOelJrTjRxeWY3bDVhK2hmZ0lTS2hTTFhG?=
 =?utf-8?B?cS8zRXJnNC9BTUsycXQ1Smh4cHVoY09mUmxSbEdPNE9BMG56Z1M0Ulc3UG5X?=
 =?utf-8?B?VGpTbG5rQ2hlSnNGNUVPV2xZc1M5VHluK3hsMmlFT29OYTRaYnZRMmtJM1Vn?=
 =?utf-8?B?V3Vjc2NKNjNDR0FtK2JOYmVMRDRuYitDUWUvYTdpTk9UMDRwSFFUb205S0t3?=
 =?utf-8?B?WUJNeENncmFyVThOZXFnTTJQb3VCSjdLS1NPS1RvNDFqcW15Tm02VGMwNEVl?=
 =?utf-8?B?ZEhyOTV5eGpyaFhabFhseW5kQytzdi9yclFLRnhqVno4NXVmN3lPdzJoTG8v?=
 =?utf-8?B?a1JGcnZiZ29JcCtHV2NDTEZJOFZMVStiMnNMZGRhWEFGU0tsRkxFdW1CV0Vr?=
 =?utf-8?B?aUlxSU9jUGNzbEJRMzlmbVp1eHduTUxXdHVISm1hdVY3aGR4YXhxTm1EWjZG?=
 =?utf-8?B?VlVOM1N2NVlxaUhaWnp3bE83MTQzN3p5UUoxTnBlZkRPMm5jTzZlTUxMcmJ2?=
 =?utf-8?B?MkNVUEc4VDJnc0plajFPQmJHY0JuZWdvVzdnTnJ1MzU3bWM1RURXWTk4YVpw?=
 =?utf-8?B?T3hJSkNodnZBK1g4ODJnZ1hvbXZndGMrK0o0OHlvTjQ1WmdadU4wUkk2WFVX?=
 =?utf-8?B?QkU4Z0xwN3Ntd2pwRFVSWngvNHMvbG50T3ZpTTljQzlQbkhLWlZoU3NCbTJz?=
 =?utf-8?B?UFdlQ3ZWYmtCSklUclRVZVgyN1gwZEQ4TWpuS1BIM3VLaHoreGJjc2pHbENN?=
 =?utf-8?B?NTg3S2lMRWt0SWFpWTYwU3AzZEFJSTU5U29OcGJ0QUhQRndEVmVBOFhVcHNs?=
 =?utf-8?B?aHJXOE5RanpFRVFqT3V3bThaQzYrbFQ3MGxxOWxyNzY3OGRtWU0rSzdtem1D?=
 =?utf-8?B?cmhmVmphZWJoMXBQME1BVmk4Z0ZrSjhNYWZSdmZvL2xhRWNHVTJ1VjlnRHRh?=
 =?utf-8?B?OG5XYlZkUVFwOSt2Z3E3SVY0eTFzMXpSZ3JqcGFTOXh6b294SGwrT25LdlQx?=
 =?utf-8?B?blZNUmhsd3dRb2RUempUcVkxR1RGbkNIOFEvTWsxQ2NySUtiL0Z4cEE5K3BT?=
 =?utf-8?B?cFVYZVpzRTF3UWNOVlhRUTRNTmxCWVZucVNzS3YxL0xPS1BrbWNGcndHOEdh?=
 =?utf-8?B?VFIvL2JYNXBTYzIrUDZxU2lqd3FKZDduRWxGdjB4QVlPQTdrb0tuTXRIZHIr?=
 =?utf-8?B?Z0Y5L2tMYllCSGpyb1d3bm9mZlZsK1l2V1ZMbTMzYnIzVGdBZ3ZPOEpyOWs2?=
 =?utf-8?B?UktHZ1ZjaWxuQlFEWG5yM3l5a09LMTJ0M25Ud3VTUUQ0TTB6THh6T2RManhT?=
 =?utf-8?B?UWR4UHJ6T2EybDZRVVlrcUxLcEhZa0ZxS09wcW1iNjBGelhDMnZoUFRpbU9z?=
 =?utf-8?B?ZGVHRkUxWjEwdmtBT3pZSFcyM1FwVENZanpXYXY3MFBneWxRNDd4Qld5Zzly?=
 =?utf-8?B?RTFWZnpCK3RkYkJKM2MyNnZ3VVJGRk4vbzVnazBEbHltSjZwTENrdmljUzFt?=
 =?utf-8?B?cGczM21OWVFjdTBwTFdSSUVIZjNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D30184F1777C5E42A5DF26B86DD664AB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z+zUjNOq1Qa8N2v8PYwWlrNYanBt6KlQbyYG6AKQuz5VnmTqWgSrBA9PGmm4k+hCMsXjnxqV1qxb5oqjdp+NPJI+r8DJzvqAEtbIfyr51GS3fRjgFgfSP/a7ggJxJEjIaQduwBeEmfQ12YTDkEOBee3OyZs6aGLsT4LFlChJkTDo8elR3IFzOPyGw0WpUzHsgJmIhC/rc8HQ7J132koeSoZ4zw4L3IpxgR4U4nLryBgb5Czitq0kD6eNK7MjtFw22meTigpXcn0+t0wapvs9g1oVkMRtR3ZKxim5EYhxfTZW3VsKSZZNqc8w4KlD7hbQAijWWdizFnqH5IrfftDFhGcWi4p9/gk+ho2D0u0M8MiiBaIF220zKRKn582e0Q4CxqZQwUdFzqBEXK2sYfaBXNIlHcO9GvcXv8HsdoRvvBI3WzyVRUPg3Fvx/X9dvaerhWunBzMbCeTBpO6fzjCWROZ45th0dBKmF4kadEagS95O9ROrPBUgqp5tyKsQ98N99SnGGQOAFSzWLUt59J589bhJN2g5Geew3H20GaiLrU1rN5xh2GmZ+Jmd2KGIkfF3x7KSShSJ81OWBAxZdzQFm4+otcCSBTpg7MY5LZDOW2DpzfNmyPValQvwTqFET8CY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda4267d-ed32-478f-f993-08dc7e411e7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2024 11:35:32.9128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Xg8w6sZWfrOqCxapO6jXxznp/iWc2gSnjOr7UbRvVJAb8lsV9ZpkGHoXNqiPvdHbub4Xk6mqnfegEn4W7VglZ8qYAwSeCk8/d42dsPg0V0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7884

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
