Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128D42356B9
	for <dm-devel@lists.linux.dev>; Tue, 18 Feb 2025 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739903328; cv=fail; b=I7UbA0bTUE3rmWn2oEyEdhQOIVNahzHNhg2w/RCvTOPP/LWvSc4hIdWNcVQnsA7hSf5bmIjvB3RoLd77ZzdUFirOherd7ZjtDp4CrMYa+4tCfvndk90YwER6XR4jAEe+jVLE/t9Rs7N9h+OL13j6DZjDPfhFhSPNblj25SZa4IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739903328; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZOz4J24PNW0lHyYTBFMOlMviAagpmLSGc64GDGWXrV/0KhBzJQuBECoR8QC17ZYr/ZdYbENfl1cuhKTUirF9mM7/SkFpi3om34GZJDyztzp9xTCzpYjxNCXLE8KSsDrBcqmUTciW6CGG1AXQwsgYW4Zxx4Rq0s5/T4GINHRXoaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Gz4JINDE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kLdSAcYH; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gz4JINDE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kLdSAcYH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739903326; x=1771439326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=Gz4JINDEajW+cSCuVgumwpXtxCWmPzP/OzGimZFUaKsEC/8amzbgV+Eq
   M9C75j8QH8T9hkhYQginwEGV3JPD5zkiBQ8DTh28FPfnG0XBv4hjSPqkJ
   gafnKU5lmRgcv9xd0tG0MNnig8N0kr+8sqyMfXjN1RzlFhf4ekXDYz8r4
   cTjjDdHovqtPIgvAczyyCeyEzgBwCQqn2J4PZuzI3sxft2gQjTZpEctzK
   V36aD+c/mRimbwdehxU6qjiHtRS6o8qMVqVXn31aCRIU0rnHjcx1/ox4m
   TsGOGbM8xMO5Qs2ltyl6+Vf2miwhNR+IKa12r9zFiXVsb6c6y0kQGfQ7C
   w==;
X-CSE-ConnectionGUID: W/zW6V62T2SsWXZ66m6DPw==
X-CSE-MsgGUID: G2mty/LaSgqWnutzAZIMaQ==
X-IronPort-AV: E=Sophos;i="6.13,296,1732550400"; 
   d="scan'208";a="39439303"
Received: from mail-southcentralusazlp17012015.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Feb 2025 02:28:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDRVzNEU6lXaywzm/srrNSy9qWaEKdWp1B/9GDOrRM5orOc35a+RC6tOjcEOf5kmaKQ41wgTKtiZUM9jdoTr4Z71/wkNYtCbr9cVJOhIwC9lvPP8eYBge4MTVBTYBa4VQT0eBz9CzZFUPbhZQvO/TTRsCGBRo5eeBq8kkZF/p6fCYPdeoF1jsz8ttl6Vg3J+vdsZ6oTHKD2aM9biKOQSiJQaZlo+HqPufSml4miwTh1O1OeZsYH+eceofTu09GmWSIiPJTyEs3NYmtPkgeT/wtdsKwfNK2bUZUjXHALBaIg0Kiz4VX1czZ9Cq6awfds2z/oKMSXIOm630EK+eANYjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=NGltqH77aAaTkMpgYQQI95ipZ3JjInyxUGwL/rXls+yi+LtgGTjF3Fu0Ah3LwlhawzZjQ8iaKPm85YZpThD3Oy0RYV3CbblLixgSAGOvnmD0Tmyi4tzojDGKCvWQlc6ZIETSun5fXg/VpNiPIRtFkfI9ZGqcB/YLWluNuXWtLtvD6loQ7V7dlQW+IkKlurIw398u7FgHO0E/9U4q8UEsTA4pYYehc/A88mouPYK3CKaP8s+FUPN7toB5sk+AuL75ZGKppNfWRWE2AYbEjb8QWvMEgGb+lQnCm6ct09cvkXOgpQJpbJir3hXORp0qWLyRyAtQXhO1khg8jpI+1aLbGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=kLdSAcYHPE7b06xofeReDt4kH/p01M3hkA5VNEbbdrvG82WVraUEypAvSmcoMQ7wSJDUO5PNO38PaMFmPUlbF+KS5gv41sWVnSjjFInhtDHnbtvh2NDNiDxQ86qSaqP4rcLwBGmrM+zpTstjxvibRHUyPJL6rJkloZzFS1tPyJ0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA6PR04MB9640.namprd04.prod.outlook.com (2603:10b6:806:42b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 18:28:42 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 18:28:42 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code into
 a new file
Thread-Topic: [PATCH 2/3] block: move the block layer auto-integrity code into
 a new file
Thread-Index: AQHbgjJf4sPQbEACW0+JrTXO6V+SEbNNYXoA
Date: Tue, 18 Feb 2025 18:28:42 +0000
Message-ID: <1858aa46-570d-4e1e-bf18-e61ffa3247cc@wdc.com>
References: <20250218182207.3982214-1-hch@lst.de>
 <20250218182207.3982214-3-hch@lst.de>
In-Reply-To: <20250218182207.3982214-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA6PR04MB9640:EE_
x-ms-office365-filtering-correlation-id: 565338ff-808e-4c11-8e62-08dd504a1283
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?REhuQWYzUklpSUJUVEtpK0s3MEdtV1NjWFlYNHdlS09ZbnZoTWFLTnJ1WjV4?=
 =?utf-8?B?M1VlUGZlQ3JPdExtYklPenU5T2toeWpyN2lBUTVUU2lYM090ak82Q1JVTXEz?=
 =?utf-8?B?b2ZQQ0NxRDNNWUZzUkZrajQvbk5aZW9OY0JVK0FwYk0yZG5rL2NCU0N4aUUx?=
 =?utf-8?B?a3pGTFNkUVNZQWR0Y0JMa3JvdlNsaDRCVlk5WndFZHNnTTV1WE9DZFVLRGM2?=
 =?utf-8?B?ejNkcnFrcThEcGVLOGJDRlI0R2dsZWFaN1VIcXpJMTVOY1hqK2x0WDJPSDVS?=
 =?utf-8?B?Z1psSzVDcTRvVFAzRTFBU21WMUREYmdMVjhBTXlwU2luYTlrNW5KZ0FKbmxT?=
 =?utf-8?B?QmppbUwreUJlbitWQTdqWEVCWEpCdlU1S3Y2OGZFaEtnTVhrUEFuQXoyWmFD?=
 =?utf-8?B?TXVLY3ZEdG5rQ1hzL2MydEh5NTRDQ2ZPYllWcE5DRXF0RjJMb0Z6aFFHM055?=
 =?utf-8?B?UjhWckpHNVNXUVd6aW0rMTc3Q05Xd2ZRWGtQUkJJK24wNFBhdkpjME45K2p6?=
 =?utf-8?B?Z1BBR3l2dEM5Z25INDZYUEhsZW9ORzlzZmc1TkVUQ2o4Z1AySmY1SzR3RGxO?=
 =?utf-8?B?MGg5Ky8xU1padGVGeWZUbHBrRTdTYjBrdnJ3WkFzVjdkREZqVEhTSlpxZktN?=
 =?utf-8?B?V0dwWStpUmRCTWM4WkxGLy9LR0FyNGg1TmFZL1IzS0tlYjBsK0FITUlHMysx?=
 =?utf-8?B?RGIxRVVEQVB4QkxkdkJKK0RseXgyR3lTWmR0Q3VjTllySjYxQWJZUGdnMk1O?=
 =?utf-8?B?OWR6RWtZMlRpMWIrRVJRN0ZWYXNHVmhBYm0wU0JpcGFpdnpNN1dnMURqWGl5?=
 =?utf-8?B?RENtVUNCbVZ2OWhxYTNPS2lJRDI0S1BuakZHbGlPd0hXZHUvQy94YzRpU25G?=
 =?utf-8?B?Y2VlTlZaQlAza0p5VC9uWGZjOVFWWGJ3aFgrOC95YnFVb2VlaG94ZVFmdnFt?=
 =?utf-8?B?SjBQWmFMc3hBZHNiYk5leko2RDlHUENVa3daYmtseWtFTVFxMUJrcmE3U2Jp?=
 =?utf-8?B?OVA2MHRlK0FXaEJ5NWFxS244SUZNY1RUMDNOUnV3dklqd1hleEhGZEIrZlkw?=
 =?utf-8?B?YkN1NlRIdWhnOFkwZlo3c2xDcklYS1ZydXVlK29jdlN3Q29GNE1vSG5Sd3ly?=
 =?utf-8?B?VHVVQXFvbk5qVjhQQVk5dEs5TkdydDdaa1VPdE0vMDR1a1kyQTZxcmtOUDly?=
 =?utf-8?B?cmp5aU1mZWU4YURVaUN2aHczZUlhVi93UzdsZDFtNDZ1M0FXMDZSU3VPc1JI?=
 =?utf-8?B?ZVA3VU1HUkdGNmF3YVEyZkZqMElXMWhtQUxEV1RjOWZlK3RUaENna0dvUUdL?=
 =?utf-8?B?OTVCdEJhRE5tUVJYNkpSVzZwUlBQTFdFTDlHeHI1elo3RGpFZG1MWmFHcHRm?=
 =?utf-8?B?dlpQV3FWdzFrNjgwTng3WnRZT09mZ1lyeGlWQVZ0dnJyMkREd0lldkNsWjQz?=
 =?utf-8?B?VGROSlhkRk04WXgrNjlLOEZtTUFoYVBvNnZJcFlGTjlQSGNSeFpoMXY3bFZH?=
 =?utf-8?B?TnZCZHNnTEwvUndabHVhOTFtS1NMQUFJNWlvZTFNWm1IdThaSlNaVy9Id2l3?=
 =?utf-8?B?eWNIcVVlQzRvTGhkL1BnTEZjdk90aFpuVUNpc1llSUhXZk83UEM3OEFYQTJW?=
 =?utf-8?B?K2hiSXdkZk40RDhncWZ1Q05vY3pVSDRxalBaUkg3TW9RdE5yakhGYnZRZmZB?=
 =?utf-8?B?R0ZCK2kzMmdDKzZ2TG1jY28vMVNRK3JTV1RvUkVDR0lZVHJZTkx5WHF3aGJL?=
 =?utf-8?B?dVlnejQ5ZHRqUzl3bTlIMW55UFltMldwR2tRSnpmbzdkK0UrMldvcGZQd3R1?=
 =?utf-8?B?SzFMdHZYK2lFeVFXTmRRbDBLR1lHZUJNUnlvK1VodXlqOXlEOVlOVkNoU2p3?=
 =?utf-8?B?cnVUeFBQMmZNb1A3SkFlbjlkMnMxMkU0RGw4U2pXdGJGMWtUNEI1RXRRZjdk?=
 =?utf-8?Q?cgSHRA8U/ri0AXO2gan3NN3v+eMC9J7L?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NlI4bHl0T2xWK2U5allMSVNvc24weWlBUENVSlBZL0U2dlNJYXU3MUMxbitS?=
 =?utf-8?B?YzU1VjIrbjE5dTNOYmFocEYva2xKdnBwNEN0K2hnMnZHMVNPVUVZWnZVYVRM?=
 =?utf-8?B?Ymd4b1ltY215SG9wdmV2V0dXT0R1RU8zY1BNNlVXank3ek1McGVaOHdSVDZz?=
 =?utf-8?B?aGwxWnphU3E3S2gxVTM1OTZlbjJMYlhVeDNEc1JvczlHcjNjN0oybThKaUxZ?=
 =?utf-8?B?d2t6QTduaFZGM0MzMXlQbFEzMUdobXNudS9HU0lzT3hSL1g3SHhzaExIVkg5?=
 =?utf-8?B?ODl6WkRDb2pRZ3VsZXNIVWMwRTJhZmdLMk52NUVEbUNacXpUSjFaNHIzb2NC?=
 =?utf-8?B?SmpiR284UDNQcnN6OU5aMXRXOGVTUmdIMHVKMzN5Y25MNlVmNE52NXhJeUdv?=
 =?utf-8?B?ZzJsbUZYT28zRDZqMVN3RnFvaG5VZURSakhjWXpTOEsraWtMUFkzK3k1WjFv?=
 =?utf-8?B?ZkhlZUFMUGh5NTZMS3BqbDJQTGd5TVo0MjNrelBLSloybi9vRXJWRzc0YnFN?=
 =?utf-8?B?NlBuZkUzNUZRUlo1VVpSSTBXLzgwTDlJZ1N3QzgzWGZBZ3F5RGg5S3phZzZu?=
 =?utf-8?B?b0RlM2hxNmYvSzRXTTR4TjlmR1FzRFNWYVlVNFBEMW9NRms1T2dnemc1S1VC?=
 =?utf-8?B?RUVweWczY3FtTGZHMjlReTN2eG1UcThuMFNRMForZUhxQkhWbmNDL3NHaHB1?=
 =?utf-8?B?eWVQOXJSdy92SUx0MHlpQjBQUlFaUkkvRVNXeFRNbE5uZ3duT3ZjRGJHcW1R?=
 =?utf-8?B?M296d3VsU0VWYnFucnBrVmlWeE1kMDBRbDFhb1ZrUGVXU2ExRWhlODlRZG41?=
 =?utf-8?B?MVZ6eHU0L2tabWZOZVNEQkcyQURaQlQybXZNeERJVE9rS2Z6TjJuUWpiZEtv?=
 =?utf-8?B?cXAzTXZvRGxOSGVidzhTZXpibW9yRnVaK3Z1blBhQnV0NHpzamxEUW5rNHBw?=
 =?utf-8?B?cUJ5T3ZvcHNCbGJCaHNsVkp4TjZnd0ZJU0RKQ0lSdjl6WGJnQ214aE1VcUpk?=
 =?utf-8?B?V2JQMHN3aTUvQ09wb1h1MzdyZ3FsNEZqMGtTOVk2aU9xSzdYa1BiaTU2bVF3?=
 =?utf-8?B?NVFtRDRMcEpCTXFCZWFqaTN4VVhEVmJFM0JUNE81enFQdThEN2Z2Y29VbkVB?=
 =?utf-8?B?RWpVTHcyc214azJvRUJTOHFVYTdYa25aTW5ITnRGVmxQMmFtUy81SngwdEcw?=
 =?utf-8?B?VVR6bUdTS3R6bG51YzlHSm9RUFM4b0RVbzhOMVd2M3pTTmwybGJxUkJjaklT?=
 =?utf-8?B?d0RNMTUzNHNZVE1CMTFRUk5zT2c3M3A2elpkeDVSM0lvMjBSdHVQbC9yTGdH?=
 =?utf-8?B?dmpZOU45MTFzQzBaVEkwZTEwc0pOcDIvVkpmRy9YRExqWTh5MFMwOTdkRGpG?=
 =?utf-8?B?dXRIMHQ1QWtMSjFBeWhJSkU5SWFPR3pNVGlyOVNyc1lCY2x1QWtZZHRjb2NV?=
 =?utf-8?B?OUJqMHQ1SU55cU1xd2ZGVS9qeENuR0MzcTlMazY1ZmhPVEp3VDZSV3BET3p2?=
 =?utf-8?B?Q0dINlhJemVBQ00rVXNpWGpVQ0NrZ0wyZW0zNTAwVkg2YlpldnhKUXY2TDFq?=
 =?utf-8?B?Lzk3NTFkNHVsTkI1OXNLbWhiU2VKcFVRUEZ5Z1BSZlpVMnJMYm9wMjhUa0Rp?=
 =?utf-8?B?dFE0ZFRoQmdKb3FLdXgxeStDWVEwQk0rVTdOeU1TR0YzVVAzbDJFY0lOd0gx?=
 =?utf-8?B?bDg5M0RtN2t2ZSsvcVo0eUpYQ3RUZWh2by9ieEJ6THpFZ1YyZnAvbkE1MzY3?=
 =?utf-8?B?OEtiYjBNVWJZcmIxeUhWbWVnOHM4eFFYdjc5TitnOEJIazA4YzNNVDJRM1NI?=
 =?utf-8?B?bkI4RkRHVXpJQVE4aVdKVktSdjNRQWRhU1RBaUpkU1dMNnY3Yy9vejJWbnBz?=
 =?utf-8?B?U3Z2K0poY0haZXpQajY5alZreU5uUENuenZ6K3g5YXAzS0wrTjI1dFd1NGoz?=
 =?utf-8?B?YXZ1YzBKZXhDTERtOXh4cldOaHhqSDU5SStDTXRkS05OTmJMejRsV1hZOWww?=
 =?utf-8?B?ZEJrM2M3N3hXclpHVUxmRDZSWHNhRWtSNE52TnN6R0RDelpXeVlxaXUxc0lG?=
 =?utf-8?B?Q3dzRjVEeE5pNU50NTZlK1p3UG9oT2FMamNDSHFyMDY0MUErWDlYdk5RVkdi?=
 =?utf-8?B?Tll0NTZ6TVVtMEVzT3NvZTJCRGRmbFczMy92QjBiTHh6NW1TNWxMa1FrZWJ1?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A2DA46814E3704DAF636FC6D04CF129@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6KUpVExZT45uoeoqFjeQeg1WaslMNK7czeCSf57GMuxPr3H8B+GsyKRTEuXA2L94ovyeSjBolo6yhoYpJHbhESUkPyX9mYGGrESOo/zvy7Vn/H4S53srg2F4vFdRdYifsEfmFf1msWty9alstIYntFs9ZHTLSxKc2zZhRH8Yq+4+nq6G81nyPPisq9UWelg2CyI1KEbUKGtDn0DCE4KhwRPXHu2hWOVbj0aPwh0/M8dSfMUIGONWwRACn2x5in17S3rGPWQe7x2qSe25ypsggkPtUCv2XU8r0ArWUGlq/x+LdABOhui8AzY6gmSdVwAy25z4/aI4U3NGYrfgtXSzyVZJ+16BNnAsuLbiT7nHAENVo+QABsBMADPRjDRZJwWSDAPYnqyBETRWvQX88IrXbp3lxJqnBV9ywHTypmbF9wd/rdR4BlqCL1ySXGNkTkqlVJhg13XxFtObRUPKcSbbp/VffsdNqsrihTH25kU9+SJu+9mcHDpNQ+Sxi9uWeHIAKnw+pH3X8I38f5rTatAs6tyf67+0zvJaJEyYZlZC1lr/69R9E5kSCVKWVeWXEiXjz2Nayd32MuPnqk7pt9x4wWx83qY7I6g22qMuDAYPQmxYH5hoDh8qy+PyDON7uhdW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565338ff-808e-4c11-8e62-08dd504a1283
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2025 18:28:42.4565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1YSVCmPmrD0aMZPd60waNrvteavuxkqryMaUnECPWKxd6huFBQwXM27OQBd+PkoX6oslQ/vKHgJZnOp6jbwTxuX3nEkyvBJ2rI/oUlnGlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9640

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
