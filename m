Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA80173351
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714496465; cv=fail; b=FDZXZEimKdUUV8+sva8RMxnXcfZiIKf1Dfi7RpLY9et8+aImq0NfRXRDEiOAX4OhhTPOP2BxCpBX+wpboeiVfo5rqKC/vd791ivcmmrpJwhZBuc9SAjekXuGxZS0kg8b/iUZRQzKeHdMAO3CYVvv13a7tiVeQAJT6ztTQ1Z/9BA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714496465; c=relaxed/simple;
	bh=xhnaNjaiMlZfmd3aVwPAM5Ae/PZNHtoGJZtmNhr0tl0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SIeEtKY4DTC5xd9XQqeq3r39GXxeQXmN8S1d5yOsEHhfkTiy+3w4B/e9sj8B+8JfdOfKrZGQeHger/LIg7RI6nsYL9+JAHHGIAnM0idfhj+rglWwNAPxZRgVLVBEDmrxqVolRk8PvU7Am6LQtSvpWolROWQXf+5QfLSNuuqnzCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HZVbsCcG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=s3jqhtGP; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HZVbsCcG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="s3jqhtGP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1714496461; x=1746032461;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=xhnaNjaiMlZfmd3aVwPAM5Ae/PZNHtoGJZtmNhr0tl0=;
  b=HZVbsCcG//Ho6KTWcj+tYRU2vNuxpig2JywMrjJ5CiOULOT4VKv4RhIm
   zfdZPw727HIO62uorORsmIP/KUCoF55CjzkCsHqxn4vJYy4QtD/hNBA3Q
   nj+lp6LHA3gWVYbD7kzIkIGbHpieMmNFEf7dH0DQe7LFbRIcpUMQijTQ/
   CYhSFFSUyUY4bC01wVqbIYEQnLpvhIy2dE4Y/jbu3RWNswrt3EmQOqCzs
   VDz3MLbwV7GcJzaG13KOPH2ZUXSTdtykOFiP5cw35ETisS/nveMhu46cf
   lkEQItjV9eIJTxSGlko8J+82IZ1SOk4CKX895kauOSUCFMmeYmf1hksSJ
   g==;
X-CSE-ConnectionGUID: vnB9w5o/RbqjwY4Irhm8pQ==
X-CSE-MsgGUID: 3O0YYJRDSE6kSPc92eEz2w==
X-IronPort-AV: E=Sophos;i="6.07,242,1708358400"; 
   d="scan'208";a="14623385"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 01 May 2024 01:00:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hr9SdUyCEOSX9wtblw5XWIF/jgUxOkKJLW+haQLLi7yGl41yIoB9P21Pi/FXk3cUah/PZNONqKHIH1vDOUXVobV6OHnA+6QX3eOa3uRs+pvAW0zdsm52o/YJpUOu3HMoU8e5H5KDsBfw1TFEBTCnFHAqJmfdjAeeUoupGIMvrm0qIH6hPOTayHI4JDJ3FDthNH4+/N/9/L0SVmndygAXBVj9Chj3ngBR1wtBNKNBDB6Mikif/Ja5ZSBzMvOo8xz3pxdDw3UFcosbphd5bOW5brilxKa9IslFXBRJJsXTYcv58rDp5W388C2f+QSiRfuztGCe22qJs7TBhw+d92TeHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhnaNjaiMlZfmd3aVwPAM5Ae/PZNHtoGJZtmNhr0tl0=;
 b=CqviTnwdrJ0fYy72oge0tLfElSyU6Ir7QXJoJO7Z8C2kFkO/cUYBZ2iiehkc+gBOFJXIgQ0pUbkkNXaUZo/BlTz8E/z307WWAA1KjUwh49e1icMIGcRWpXTAbivcyvoM2UOd8bocfkcfsKupz0T8jMc6OPNcQPFfljYV63ZPU/Ph6ej4EF1LtFYvsfNRWje+z2FOybE2W8HhAx5XT5YAwjbJAKye1UuxfA90nyAb165l5RVZQFdSeTD+BKxfcv+wmFZoPVzApuJnMdr7CaRLX8Ibwbi1WZXGb7awGbUIVWIoHgn70ffuiYQcVFHUJfvMapUagkkgIEu6RfLtb2q5dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhnaNjaiMlZfmd3aVwPAM5Ae/PZNHtoGJZtmNhr0tl0=;
 b=s3jqhtGPp4gCES7r9HP+vLWdhL1uLGjxexB+u0mlANXUguAogTFn/7bHU18iV5QV5HBtCOuA9QcvMwlWydSDcdeDZ+9bHBH3vSFl7CjzFZVDdu/NQurD5uFcYG3fhYKhPQLE+WnKbf4+hjJKvudluKc5WqB/TgiZ621DLxsxSTg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL3PR04MB8106.namprd04.prod.outlook.com (2603:10b6:208:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:00:56 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.7519.035; Tue, 30 Apr 2024
 17:00:56 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@redhat.com>
Subject: Re: [PATCH 00/13] Zone write plugging fixes and cleanup
Thread-Topic: [PATCH 00/13] Zone write plugging fixes and cleanup
Thread-Index: AQHamv0rROZ9/v2NQkqTk4ezJ8wDObGBCfQA
Date: Tue, 30 Apr 2024 17:00:56 +0000
Message-ID: <3e7d5b9e-30b5-4c90-9eb9-b3079d129109@wdc.com>
References: <20240430125131.668482-1-dlemoal@kernel.org>
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL3PR04MB8106:EE_
x-ms-office365-filtering-correlation-id: 7fc9cec7-b6f2-4ec9-db72-08dc69371a5b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?U0diMDk3cWJBRHhTODJJTC9FcDltbVhLOUNKelVtakV5MDFiUXlndXhCalpN?=
 =?utf-8?B?UEFuZ2h5WklyS2NSeW00UTVBaUNiWWRJbnNNRkxpWWZSVVVLTHRiTEZkMkVC?=
 =?utf-8?B?OEcvN0Z0NWhIUFpmU0o3VkIrbUVKY1dBTzRnR3J3djNNOG40S21zeWZjRCt5?=
 =?utf-8?B?SytoRUZNYXRaRE9kUnBsalQyeTBwZmlXUytwRURyOG5YNStEQjBCb0NodUNw?=
 =?utf-8?B?cGorTnhtUTZad0kwRG9nbnBQa3VwQjhoZ2UzK25NMlZBRDIxSjNaakxvOVRK?=
 =?utf-8?B?Y2RXVVRCYWFVNjlzZm1RV0d4MEVibk9mTjA4OTBEUDZVVXh4WTQxWkNGSGFH?=
 =?utf-8?B?UEN2WWNnZUZXRHpudmR6M09waHFnU2dHeEl6SzNDNVBaMjRzaFk1cnltSTF4?=
 =?utf-8?B?RUhUTCtPOUthUWFnZHhITVRnTE1iK25zaVVYS09KTjNEMTB6L1RDM0lYYVR0?=
 =?utf-8?B?Yi9lZFJ3WmlReGM5dFA1SjZ4VnB5a2ZkMVZaQTh0Ym02NDFuU1VGRzRRM3ph?=
 =?utf-8?B?OHNRVHRLRmZRNVpTMThpTUlUZDQ4K0NQeW9NMWI2M0FRZExwRi9mRjcySVpj?=
 =?utf-8?B?azZnOHFTWXlhTU13NEY1RjhzS3hHUDk5eTQ2djRsUGZzcklUc0VveXJFS0Yz?=
 =?utf-8?B?U1o5cURjWno1T1I4SnJQb01sZnRsWE1kZHg3Mm9QcG04c2FTdDdjbjc0cHhq?=
 =?utf-8?B?c3hZczlOWlh3L0wxdTlFNThkL3VpNmdJMHZzOWVKaHRHakxacDQxNEV5bldN?=
 =?utf-8?B?bVNBaHRsb2pKUnB5elBGd3dxbllKZWhaYzU0SXQrc0ZmZjEybnNQWEVmWFBh?=
 =?utf-8?B?bFcvamVjdU9CaDlVUEVoYzI0VkJnelZkWXh0VGk2bHdiY3dXVzlqYkVMV0dn?=
 =?utf-8?B?ZHRsYndnbnhBaUw2clZ5cEJRcDBnVDhYRGJqNXl0MkN4dU54ZW1nWHlOam96?=
 =?utf-8?B?QmxlbjNGSXJNcVdJWEpsVCtiRG9KaXNmS0RoOUw5UmY3RU1OKzh5dkVkd0Nu?=
 =?utf-8?B?QnNGUUJvb0tEeEFRNVVDanhEWTJZVEFOQTRyTDA5bSt3cllhMlhZMHlhVXhj?=
 =?utf-8?B?Vy9ta3EzaGlIQlpYY2Y2Y0R6SUplVlJzYXhkWnRCcUFiSjdMRUdsVzNLb0tC?=
 =?utf-8?B?TGJGa1JWaGwwbmthWldWampJcUZzOVFPelVPS210RWZYeEtCVjJscXV6TUZU?=
 =?utf-8?B?VysyWDdqVnJVZjFFQ0VKRnVnTUZva2FTMlNkQ0EyTy9KNTBqcHlqTWhZejIr?=
 =?utf-8?B?RmdsRWlJOW5kUWMzT00rR2FzUjNBdWhLMEFQekFuT29qdGVQYVNrY2hjMFpl?=
 =?utf-8?B?bUtqN1JyR1BJeFB5Y1FYbkd5c3JmTWRIdCtKWElaNmNlMk5QbTJlSkpia05a?=
 =?utf-8?B?RmxWYzhCbXBrZ2V3Tkp1SWVvMnQ3WDRjWW1tWkFtaC9OeXdTRlhhN2RwVjVM?=
 =?utf-8?B?VnI4OTY4TENBOVhVQzZxMGZVZVJrZVZ2NUFlYVg1cFYwSGxxRTY2VUc0K3Qv?=
 =?utf-8?B?TUd1MEROTExxbDlQMTBkY3oxUHJ3SDB6YVQvZzRlU1I2MTZ5bVlnZE8rcmdB?=
 =?utf-8?B?U0I0SUF5N2R3eHR2NXUwcVpJTThkL2lNeUJjTm5zamVLZDFpVTU3aDM4cnpK?=
 =?utf-8?B?S2xPTGtoTGpkSi80TWRaMnRNSkJ2NE9ZWE96aTdlUnY2dEVMUkZZUE9QeHIw?=
 =?utf-8?B?OHBGUmlKc3dOcFIraXBOSGg5REVVYmdpd0kxLzIwR3QwQXlSYkRZczdmQUdn?=
 =?utf-8?B?Y2hqdm9iallxVEtqRmNTb0xqYTlYOEhnWTNEdzNxbkhOeEZRSTJxNE9kOU85?=
 =?utf-8?B?ckFCL080eDdaU0x4aGlsZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZzJMRXhBUmg1NVl0MzZ2a0JiZ1pubUdHNmdhZ3lwb1JFcURHS2t3bW5idHdp?=
 =?utf-8?B?K2tENEUrRXJTWWJYeml6NE5NMWFIN3hLSFR2Y2d0TUxydlZJK0RGbExUZUtt?=
 =?utf-8?B?K1Jjb1Jkb3c5U3VMcDgwN0RnaEdkcXMydzVoVDNOcXFFbGgvZVllQ0tsRDZC?=
 =?utf-8?B?VVlabkd6ZU1kSmQrOUYza0p2TFNTNkE4dGpTNmZxRE9NNlBESUx4aU1BdmJv?=
 =?utf-8?B?MlBjUlllQzRNUXl0NXgrU0FlYWIrcTYwTndJK2JYQTVkYWdTOGJMdjI0cDl1?=
 =?utf-8?B?WnRsUWxtcGljRXV4L0JBUU9nN01PcnM4bnpuOU9ZbU95SDd3emduK0k3Y3Jn?=
 =?utf-8?B?RHR1M1F6YWhXSStoZW5tWWlkTTIvWTRzNXcrR3NqM3J6MVhKNHNxV0owd3dV?=
 =?utf-8?B?K2g4YlFFNE8wV1JqS2lPK3lNMGVHUUlsUmZlVjV3dXhldWxXamQrMGwzR3NZ?=
 =?utf-8?B?SzlaYzFIeDc5empZdDZSdjVIYVlOSkQwcGU3WTR0Lzc3dU9FOWxFU2VVYlh1?=
 =?utf-8?B?ZWNSMENXT3pKSkJMZ1NJYUZ5UGtKbnViRWhodUExd1hGSE9lZiszZjg2Ukh1?=
 =?utf-8?B?SndVQjkwUkhUVGR0ZU90VVplTDFOWjBWY2ZhMTFOazFiNVBjUEszUGNzRmNi?=
 =?utf-8?B?d2YrRXNib1dmclBYWVkwOENlS1ppU25SMVBBcXA4eGE1RVA4MWJYSDJiSWNs?=
 =?utf-8?B?d3RtL0pWemw5d0xxeVpjZ01CSFE1SmJ2NEp0RFdieVBDRExwNzJhZDh5TmVo?=
 =?utf-8?B?NnpGdlZYRzdNWml5UWY3WnFydEk5R3VlRUU4YWlGVWRkZytXemNNVXhRdlJZ?=
 =?utf-8?B?WFRITkhzc1d4MGk1aGEzWllEOWhLZXlNSVhDMVZMSkk5TVZOaU4wQUZRRzJk?=
 =?utf-8?B?RnlPSzBBSmR2TnRod0tVbUM4L1dPbWJUUUgvNE1qN2FoUVVVUG5pTHlvcEJr?=
 =?utf-8?B?RW5rK25VSVRCTGxzVkUySVZEMEVrOGY4U1B4blFIRUc0SklsemsxbVUvV3BC?=
 =?utf-8?B?dm9jdFF5ZVV4dFdIRXhqbUJQL3RnbUNzaWJpNmxsVDlvbzRjRjZ1STRHSTE2?=
 =?utf-8?B?Y25MOTR1QjBjc2tyM1ZINWdxaEpUUXJtVHJMRHplUWhlU1I4eStiYUQydGV3?=
 =?utf-8?B?NnVpT3RySnNQeG04VEthRkpYWlNkRGQySUNHVWNJM2pFOTBxUjZpeDAzRjA0?=
 =?utf-8?B?aGc4VlpFOVErOEpkVUE3b21zM2oreTBQSWtHZzROOUI4NlQyQXhhcjBNQUtG?=
 =?utf-8?B?aFJHcncwam9kVlhBMktzVEFSaHUybFo3Y01NRG5GQXNnK2s1RHJkcVZTMDRS?=
 =?utf-8?B?K01vTjM1VkhmQmlseUFJWDdrZnJzZU43dmtNaDYwM1N5Qk43MjQ0cFBrNU1r?=
 =?utf-8?B?bXZzWHlFR0Q5NHhTWkZNRDZncGxZVkwwajcxQkhlSkZkWHVTZ0ZHaHBXUUVr?=
 =?utf-8?B?QllSMzJEb3ZFNUF5Tkc2TEdHVXo3SlhqZUVGOGJ0cVBFYnJCZlVRT1l2SGFV?=
 =?utf-8?B?dFNZcFlFWHNaY2RwTVdMd0tuOWtIaFAwTXhubktYR2ZkaU1ZVWxCZjhERm5C?=
 =?utf-8?B?THN5K3JLTE1nd3B0NFgzYmRGT2xvY1FEQUg3TEVxZ1M1MWhpdU9taFBSUWFV?=
 =?utf-8?B?SUo0RUl6ZkhhRlhxcGtyTERDSFNtdUVENnNlU2g4RkhHVkx1TkxBS3BTTFdj?=
 =?utf-8?B?Um1OWE1CUHh5MjVqbXdjV3ZTTUpJU2t5RUduMDY3bGZXVzdYb0tHTHppMEFI?=
 =?utf-8?B?amRBNHdoRlRNSGZmNEFLbFZYWGh5eUtER1ZraFlJdGg2WDU0OWVjTzE1RGlY?=
 =?utf-8?B?MllMSnl6b3hLOW14cDRzYkJtaG15MVNQbTdaVWphUnJ6MVkrb0ZZcGpsUE5y?=
 =?utf-8?B?V2tmNHJIM3FRR2tIM1ZHSGVzdmFPQ216WFJ1RUlxWFp5Rk9DSzE1RHY1Uk5W?=
 =?utf-8?B?WjMzV05NN0szaXV0K1JlRkh2cVFkWXNDT1MwV3FTRXFyWllkNXEvM1JXeTVx?=
 =?utf-8?B?ZGdHeTNGZ3JmakE4WXVvUlV2S2YxMDJoSWtsTHg4V3pCVjY4YjFGNEJ3MWVs?=
 =?utf-8?B?WThyVmtCV1N6WDVmTnV6c0E2M2lyMUNIK29rT3c3bkxnbFpXSHgxTVNhL1Ny?=
 =?utf-8?B?bUI3L2ZiMmh3ZWNnWWRucm9kM2E4WGUrVE1pWWkzMDVCcStrckRycVBQa2hJ?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA329B9B43353E4EA5AB6E3ED213A5B7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7FICMvdH20imoQzWjYqcu6tbe/moJzDBKvkjhktK1BRn/VJ3v7iL6cX3Wi1T0EH85vK7Wsd6wMfjwxea3p829q88Yj74Hlb+r5B/aJ2M1GydvcTJWWp5+4xRt+Cok+D1Eoge6ezid/ArznBY86wId3tnCcjKHvkHjUAMkMh8y7gsrOr1+o3ycdymbkhRTELgQTBHVI3T8Pg5PaOLhEjqSXEiyn3IxSgoPp9tUvQQ1AQdv6XmsxTPitdZoEsritBOLHF7aYoo6hM7UKLaAo/sQSilYQSB2awIQ3YMlonlzV+DcStaGOdz8jFfMVKtjpyA0AwxPEKxoaAHCnWJhyw6dzbBG7gAXuUBuwH5PmG3HgWqVqGTwmC0Zgkum4YbSEc5sm3C5/7bBKJ/EV4RwHHL+fP0oO3zZcMYvpGcLSUULYchgllTBHEucmu0IDNRaaGf9fKHnLlG+XqZXzJ9xh/YJAJ6EX/AHbz0qwFQsMn2j8tslQCmio+Dj2TjW8PCsaCYPWLXpPirDJTGezP9IM2HoT5MFDRBRi/KCmilpde6DJChMt2C0aEtap4NLnnjheMjm6VJU/oH6YOofa23+ZaW8w+AoPR5uPP6D0Yl0NndWcR8NlTwuHbYBctu0cApL+hE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc9cec7-b6f2-4ec9-db72-08dc69371a5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2024 17:00:56.5636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QUU+jlkegQmpGOclvsaiX9NtbwAx7OolBELcwXm2hOyX+coOK6HNZ+mLS83wxDCOdcdcp4Bdvwb0fwMk8RkFzfMNXwvPUBp6uiy6HoRnHEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8106

QXBhcnQgZnJvbSBDaHJpc3RvcGgncyBjb21tZW50czoNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBU
aHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGlybkB3ZGMuY29tPg0K
