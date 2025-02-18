Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D172356C2
	for <dm-devel@lists.linux.dev>; Tue, 18 Feb 2025 18:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739903444; cv=fail; b=oQXgfVHdEBUXeETn1/UJRz4jXlMFMmBUYp0JX91MZWg4WCazlD2dNw23113WWA6NmN66jGqc+af3SgUMliSTiwtA47xf5ZBd70XFKLosckTo1adSrlOTgLL9er96eiieAd9MM5/U/zEqr0aXsJrJgsyV/sXNGZhRjIv3AE4MydA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739903444; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OOGJrJEqsqD32L7dFGedlmU5JzlrTIV0OIMRRClFbk9plfS6aw7Q1Fs91PdD1RWD/q141feSFf9Gv+7oJ9keIA805Utabb0BvcnZE0KrZL6Zp1jisDJV/cXiNppnSKzCwXITw9SBAOsIUTDm0iTv+H4+lLyShlK7dRGv/V2pPiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bkn85dAY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YJOLDziF; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bkn85dAY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YJOLDziF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739903442; x=1771439442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=bkn85dAYuohKMVXJda92pjx7m76hXYkVHyLr2DneLWDPoaOBZpZNgyxA
   vU5ILephrrcUi8S+enTwwzlhmoAkaMbFLFvBjvKdN9d7+oAzKItdZq5Lx
   B68ysKMNWedfk2n0HvHInzqRzbXWbO8O8xOLhSA7Szaih7UcuN78U3Gaf
   MnkunpyO91/VrQL+ODn+DrdeToMw92O8vQhusfQdA/YRfSozE8K5NlDyn
   BcxJw84tIMSrT3Mwmm4JDA+rMZJBtagILAvw3S6mSv3F+OMWjaQm+roV9
   OML6gKJrGsaRjippEZtQNfD04ciFe4xL0y/68Qjh8o0OfV4yjSnfwVfnc
   g==;
X-CSE-ConnectionGUID: DqREfVF7RweUKrhi0WxRVA==
X-CSE-MsgGUID: PriA9sDlQLG71w1I3jEgZg==
X-IronPort-AV: E=Sophos;i="6.13,296,1732550400"; 
   d="scan'208";a="39803616"
Received: from mail-eastusazlp17010001.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.1])
  by ob1.hgst.iphmx.com with ESMTP; 19 Feb 2025 02:30:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNBQGe+H+yP4pQjXm2CpSruIVy0D2ll56Sc55b3UvNEuIXT7nR6pthyosgokSrLqzrWcVqUSVNL3It2vpx52AVXDcGTfPoZfX4nQ3oLcZeOV9FVemTjX4Xx1jt/1wJNIhaB/l5WxwaLBuUJMWvzm3MgoUtQQRKygw75KoARIGUGh01XGiyIvDPIcKQy1dDqsLgYWrbcAiuV+l3ua16VNAYvSg82idd2wqSTygFZYpyUf1DQX1vFXRwSMX5Ln35CZ13RFGE4RU4mqRdBcmJlw9gD4vXT8oCPNKKUjp98QnFVgHqjrR0p+VI0TuwRcH2YEGzycNRTuIkmSpytV7OR7kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=IXxosEg7vabknjZAmB+xBFPTrgR1D+wlAl9U4BB/sKzCkDsdaZcfDhj3nWKmskk9jx+So16BKrlAGLMuoLypDilvBw/Gfg6liJTFfpX6EwbzJXashc5vd6YPsxPlDHBa+p1WJrV3fkrCo28PYEsud+lzn+Gi1fM0hSkrR2QLDfk7Guw1aDjmPMtE3s9yXXSGJEmTfnNSyIo6hVx2PB4Ov/bd/6VqFJsvPmrQ1BKWc59z2mqBp9KvxpesupAxO2owraH/Ra/a4n1r/gmOPjza9/jMtjasO3g+8DsZ58/2nUw1JfDvmM/pYdmLhN1ue8RSCD2Tgj+pIgcKcmPMnWuK8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=YJOLDziFRsM05hJ8npoaD6zDJV5blOQYf2KhhXooMK3EdK6g1DEfoHsilJOXKyJXYYAYXpjI1+UfRdLRkwAExKjlPv874M84eVm4iB28AEmqqxPyhCIcxlN5oVa3LAigr4TDVV9xRhLyKX7pdKHdmcbiJ8VOpIqGI9g8ire83uY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7439.namprd04.prod.outlook.com (2603:10b6:a03:29d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 18:30:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 18:30:35 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 1/3] block: mark bounce buffering as incompatible with
 integrity
Thread-Topic: [PATCH 1/3] block: mark bounce buffering as incompatible with
 integrity
Thread-Index: AQHbgjJJqNwPSeZLOEStFw+6l8VEsLNNYgGA
Date: Tue, 18 Feb 2025 18:30:35 +0000
Message-ID: <2051092e-e29f-4e38-a49b-8fa09029eb9c@wdc.com>
References: <20250218182207.3982214-1-hch@lst.de>
 <20250218182207.3982214-2-hch@lst.de>
In-Reply-To: <20250218182207.3982214-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7439:EE_
x-ms-office365-filtering-correlation-id: 1e19c15a-8495-4df8-ef31-08dd504a55c9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZUltUnh6SUM3cHo4RUFtcUpUWGFqN0hQMDFHc2pybDBiMWh2eHkzL05qcEFP?=
 =?utf-8?B?ZnRIaVdWaS9vQWZiRnVaZnJadWlGdlUzWWJxdUo2anJORERpQStPWllvaXJw?=
 =?utf-8?B?VE5Iak02WWRzQmkyRHNPbTlHbzQzRnNwRWg5dnJ4ZW9oanpyWjRMTUxZZElC?=
 =?utf-8?B?cGlIVFE3MmtSYzBRM011QU12VC83TW81amE4RmJQS0I3MWpVNytmZUNUQk9Q?=
 =?utf-8?B?MzZack9OR0xlN3BXdHN2VVBsamVRSlJDaEMzTjBja2ROalpRSGxyN1NDVU5q?=
 =?utf-8?B?VEltTFFRdFRobkdxeklMaTA5ZmVRc0YzblZBMkMvaWRGa3podEQ1bmxjbi9U?=
 =?utf-8?B?Z3lCTWpDdVZOZzU5QjgyaFFPelVWN1lnUElDTVFwYk1VdHQyUmkzMGFYZDBW?=
 =?utf-8?B?RzRJY0REZUl2dFZVZHFoTXNJRGVyQ24rZ1lkb3NGbXhkdFVwTGtmQXE1OUFh?=
 =?utf-8?B?eU52SXNSL2NsVEpueWJGRjlFTDZCSzB1elFMMHRJTXlTQzVCTGhvaHJTMFBt?=
 =?utf-8?B?a3Y3NGV4WGpwUHpFS2R5aG9IU1J2NkVmRDVqb2JuMmpCTEhXUTFoMjI4N3J5?=
 =?utf-8?B?b0tCdjNsZkM4cjVYQTdjbFNwa0RUQjAvcW1uY2VacFlOSk1UOFZrZ0QxZWF2?=
 =?utf-8?B?RjhGc3E4VjVNUGtkQWJ2NG5haHJVRG1KZzZtQXkzd3hYNW9FUlBpclg0RUow?=
 =?utf-8?B?ZFhBVEFlSDBwTTJTbXB4OTc0VGVlS1JLNnczR0ExNjRmamk3SkVqQ1dVV1h1?=
 =?utf-8?B?bGtiM29DYkFuTUE1YWZMV1Z5eXN1bzI2TDdocnh0RUg5a3hDOFZyNTNKY2RP?=
 =?utf-8?B?Y3dDSkFFdGw4M0dSZGVQQVdNU2RRbHpsTEJPTVZqaWl0YUVKRDBnZ2xaam9J?=
 =?utf-8?B?a1ltdm4zWHlCdFhhTXVCRlJQVUxJZFcwbENlREw3Vk1jR2lBWGdhakgxNE1U?=
 =?utf-8?B?bTNIRzdzMWxFczMrbmxpUExpQUlrNjhQMmFONGRmN3I1dFo2UEFudUhkVW50?=
 =?utf-8?B?RVRpN0swSUhNbHdrYVhvd0IvSTc1TUI0ODJhZ29TNHZEMkdBMDI5YnNkZTdI?=
 =?utf-8?B?KzYxd1Zrc2ZHeXU3OGJoalJPbzcvUVk5aWswa2VITk1pdk56WUtwM08xZDR2?=
 =?utf-8?B?NHFWbFE1SVBjcUxnMHZMcHBVa2NwN05scTd1Sk51Qm9BMGVQN3ZYWE10SDJX?=
 =?utf-8?B?bXYveDk1MkV5K2FtUXlCUCszSHp4ekxOYjdodnN5dmNodVpCeFNVYUFaZlJN?=
 =?utf-8?B?SldybERMNUN0aVhDQXNhc1dETkNQZnczS3RkWDRVaGZqUDJ3ejFqc09FdGZB?=
 =?utf-8?B?UUFXTWlhbDV2NUdMV2EvSEU2bGdQdUQrVFdkOGJPYVlkSWRWclRBKytQUFFm?=
 =?utf-8?B?bzZDVXNtY0NKQnBGMmQrdW9EMGdmTy8zeHI1ZDN1NnoraThEVE9LQUM1ZjFD?=
 =?utf-8?B?dVBQYlk5cktoS1I1VEFTZlRUZmJvRGdGK2t5L1RLU0I2c1FpQ1NvUEVBYXlM?=
 =?utf-8?B?dDQ0bVczbXg2L3VGdE93SkZXd3htYXVid2tmcFdvMkRnNHdyRURZazB3R0NC?=
 =?utf-8?B?T0FjRk5XVnN5RjROeXcrZURzcUwxbW9pWmZRbkxPZVBwY0d6ZU1MSjdNVU5S?=
 =?utf-8?B?c0ttdGhUbHJTT1F5UDM0S3Y0TGtFNkNCVmJUNVBnUGZzSEcvZFJ1bkxuRTBX?=
 =?utf-8?B?djAwOFYya0gvcU5yOHNreGpZWjdzS0l3YW5Fb0VTWmlzbmc4MDR0NzE2Wk54?=
 =?utf-8?B?UUdjVGhtUS8vckdiemlSSmxvZFUwSDRGcktCZVA1Vjl6WmkzdzQxYkJMeHlv?=
 =?utf-8?B?Ui9NekZ4bThYTDFCWjRhWjh3SFVvUFo0OTBVQnpMSm9RdjlSam8xS3dxRENI?=
 =?utf-8?B?ZDY2ZnQ4QkJONThza3c5Vmk2NUlIdVVjYnZldDFwS1JDbEFwdWJNNkdnejd5?=
 =?utf-8?Q?DKgu9eVw//lyNID6ty05hm8wKY1TAu0I?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YTE2ZFhoU0VLaWl2anZoa1YyemdiVHRNbUN1aDdEcVhUT1dIUkdsRnVjOWtw?=
 =?utf-8?B?VEpGcDU0S2NaYkQyOFl6WWdHS3JHOEhOTVlWYzBKQm9ZekhKZFlWV0RhbVZN?=
 =?utf-8?B?aWlNNVV5eDNScXowWEJCWktaM0hxWTIzdDFEU1hzcm9SR3BtRmE3VFFWYnFP?=
 =?utf-8?B?MG5xOVk0bW0xTy9ncVpBZHAwWUE0d0RGRGJ2V2NEUmhDSmNzYTRjQkpuUmN2?=
 =?utf-8?B?RWVGRDJaRHJ0SXo4OWRkbUxhVi93eEdhc3V2M3NqSVFDbEVSNXlRZUlHWGtW?=
 =?utf-8?B?Mis3NUdPTEVFNkFsVFZ1Z2hWS0wyYW0wMVdjMElJbzdJMm45dmlzMHhQVHBa?=
 =?utf-8?B?VlZvdXRPQkxIaUJMMU9mM0FacGY3R0QyRTgzNmxlRFhhOENjR20rWGp2WWZX?=
 =?utf-8?B?dXB4ZUgwM1Rtd3NEQkFpczBNUURKeURqbFRlZkM5VmppNm9FL1dldzJNY2dx?=
 =?utf-8?B?eGRadW5DUUl4bDhCWS9aR3NyYWZSRUhDVThlakVINjkzYUVXZXBSSVNSdU1Y?=
 =?utf-8?B?OTJ2eWNBdkV5bE1VbVhOZXlvai9PREJ6YVY0QUVrWVZIbCt2aUE1SEFLRHVU?=
 =?utf-8?B?WlpKRHNIMVBNVFl5QWR6cHpiWXNGS0ZXSFNkZXFnVlZTT3V1NENIRGZYSzNF?=
 =?utf-8?B?a0Y1YlVvQkFzOVA5YmdDYTU2Zm1NcGdiU3RWc2d5TVByRGR6UWNPUmExYys4?=
 =?utf-8?B?QktvaTNZT1crYVBOMXBpblhoMU5UbjJIWHJORGlnWTJmdFJJcmM1UmlDZEZs?=
 =?utf-8?B?bXdjc0xPc2pIMTZ6Z1RhTzcvejAybVlMWitYMU5XMnh2b3RxN2xYaTZPeDVJ?=
 =?utf-8?B?SkR1bEpvbDFGUlB5dDBwbUVxaUlheFBka2hzT2Y0Mm1qOUFhZUIyWnQzWUZH?=
 =?utf-8?B?bC9EWERJSmZVYUY5dmpBVjBoc08rRkVYU2lacXlieDJROW0vbXJSUmVJSWRa?=
 =?utf-8?B?Q1JCdDlEUTYzMyszWkpFdnpWWW84Slh1eW1QNkJLTnh3RzROTE8xNDd5YTM5?=
 =?utf-8?B?TjJsb0xiVGtmRHJyUHVGcEpic2hOWWxTRnhZckFMRllPM011M3NXbVR4dnpp?=
 =?utf-8?B?M1lSZHc0VkdhSE5xUWJDcGpyM1diTFo5amNWT2xVUnpGQiszcWlYR0t0VHVT?=
 =?utf-8?B?VDdZekJTdGFTdU95RkVNNm9ham9aNVB2NUljMzdxcnVxc3BJVk9aTlhwQStj?=
 =?utf-8?B?emVFaW1QN1BOWHVvWkptYVVjeGV6N0VtNlRVTGxBcWVhRUlNV2dDQTNPZmZn?=
 =?utf-8?B?bGhGc1kyVzNOSWsxZTQrM3dwSHdQb040U1JxRkRoOGJDRHd3R2RNRFFuK0Rx?=
 =?utf-8?B?K3V4VU1BSmZCU0xKbFlQQzJQakVWZWx5UnhPem5sZEtEaGkzSVFIaVNFUTV4?=
 =?utf-8?B?eTUzL1p4eERudGdEVDVlUzAvVDVaOVJnZWVOcG9xd05rbjFUZEY1Wkk2NTlw?=
 =?utf-8?B?eTR2TVVRVTd2Q1lKRm85cWtyZ3VuSWE5TFM4ZnZBOWsxZ3crVko1eHoxdTJt?=
 =?utf-8?B?R0U1T21pdTBmY2lqYjBjcmZXR1hOYmdoTHUrUGdZbEhTdUtyRTBOS1Jvd0Z0?=
 =?utf-8?B?SnFTZlBESFR6WHdyU0FVdWk5VmZkU0VuU2pGTk1YRmg5ZDFjOUlPMW5MQm8r?=
 =?utf-8?B?T3BFcCs3dDgxRFBqd21qaU84bWU3cEtpYjFMTDk2cHpMUDAxRFVDd2t6Sm5O?=
 =?utf-8?B?bUx4MlhHVlV6VkNCTERMcnhWeXJTNG1uUDV2VTg3bkVWRXBzYTFIdzB0TmQ4?=
 =?utf-8?B?YXNnZE1qTEtqaDBnMGhEMWJtVkRLQmpWa3hWSW16MFdoRXVrN2hFNWduTk1Y?=
 =?utf-8?B?ZkxsUWtjNUxES0kwcFZSQ2pmRmxocG00Ly9MbHRwYmxHVHMxU1NJQ041RUM4?=
 =?utf-8?B?UTRtMFdPT1ZEUXQvSlM4ZkJzeVE0djBiRXNpVVBSN2lScFJsVHFjN3I1aTMy?=
 =?utf-8?B?U242ckh5N01kWCtwRWxTcDNER2tlMTdwREluVTNIQkZPT2NmS1dDSGJZMjNU?=
 =?utf-8?B?WVlZSXdicnlibHJjU1FGSEFTUWZuZU9nMmtVTVkzSi9EdER1ZXIwRC8rYWVw?=
 =?utf-8?B?QjZyd3VmSmNqK25xOGtZUytubjRHRzhuVGdSUmVkV3JuOUM5ZjNHZ1hseUtL?=
 =?utf-8?B?VzBOM3ZHemZhZ3psOFVoYXVtdGRNRHFvZEtSTi95bHozZHpvdVZvUWlnNHo4?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AFAD016D71A574FA620159EA2EDCEB8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	woVFONOjvD9j+vblPVaH0d2b0zESv8QPWJIQR4RRvCicJOEeZ6nuKsF80OrojBBLZy3Gf8fLEira2deyLB24A5efVOPanK4Lkh12fWUh//+esDMS4ezyiWbliscD8XxjK5TztZ69ST/1fKVMJyUqG4v+tFr8ZsdtI+L7+w/1reDrh7RzxIwsJqfs3lupls89/Zx3mSXXQPHIUTp8L65xPr4LRQSVhzloNNyjTM+t2zZ4DDM1HRv1+NKH1YaQXTLzhsb4X7KzkSQB1yLCyzCjOABAH3WBiU+ZQmjpOEzMGMSiu5ijMkSuEGwdlD6wy4qd7/m1My/PYdhATlaa1rq3Agm2JghVgYZjIAq2j5II0SxKgHEQLec3CX2BNgxI2iOPc0wCQMKURSF3s10q3q3K9enV8hwv29xTd2/bjGobUNZa9gSQt7JoAmdqWOMaI5iR6fObbEyPFu7N8VH+aklGYr0kQ7ip6LzrJLqDpNTcBI8tW5Pkf/rBI56+2qF8gE2oyefM3+pmPst9sAPWSeOvpCvMKEiNatfhW0Ww4QG1USdMVkTubkFWQv03Wz2qVRUzKS6GSvtNI+H85ls4cdx4pdxnnJVq7HjO5WJKck0yPWIrW81Ze//X+yojR7wyMeIp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e19c15a-8495-4df8-ef31-08dd504a55c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2025 18:30:35.3485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbGairgsfjL13H953cdZG+5jhunzZAU/Jw+ERrhRwdzh/uHNyg6LnWDg6mlcgBBKD7YQs1DjSo09llpXyaEOluhNautqOIR/zviU7edaRCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7439

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
