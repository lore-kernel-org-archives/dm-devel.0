Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023825DAFB
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 11:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750852061; cv=fail; b=AiqL7ueHwcnYJNFjik2DXKcXxjc77NI37SPAjuHO1WXNmL7jmLa5jk7HYDcWvabPqHSPF7HQ0AbdQ2WHhTO3k3ZA0Qeqb8mRID/fqIeVYICE+7ucppaHfQTIcgx6zFvcVpfmyN4ieBMp1JFV3T4Ik6VzUVSC2JB6l8/AgCSt53I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750852061; c=relaxed/simple;
	bh=uaMrDexB/DEHnVxsKziEfzchC/SVQRGNbpL7wbYGHXM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nNAj/hdTl8gOeZRepE9PsY3Xhe+YS2o/cqgbXUiB2t8LVN8TNPWdn+jr3IJQkStoCp9LkdNPn8OHBQhxNZHt44fi9f7JWCKsuMz+17UQv1YvNiFnp+OeNYSJO8mtGfaeW1MmpSJtRPbTYa0d5WymP4GPq/D/wkYifeKh7O8DZlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VubJagL/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oguW2pG3; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VubJagL/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oguW2pG3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1750852060; x=1782388060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uaMrDexB/DEHnVxsKziEfzchC/SVQRGNbpL7wbYGHXM=;
  b=VubJagL/q1i6wGVJkOhX1M90QWiZ8nmjBh+MpmxRFU+JyGqsQ16STSfZ
   J5o/5xNTUm61IssTQxrJdW1RMZtQyKic0D/xLd+4MyNETeleCu8gY8qHN
   sJoKIjCT3S2KwehIkv7hswFDlUWkkjZR+JLuQn4Fl3ZOG4NdmIUG/xi7j
   hhlnnW+25HsIRVka4ZWAQFHR7xDXb21jgSKcWD10PrQ91e+jFimy0WCCT
   ltFnefY74CUOeDgaGTg6YPuBHAp9QxW3S21MBumNx38cT0ANQVexouVK0
   v4cB1rOXtYB00eE5Ouupt4h7Oo4tuxtgZ1i030AZlNGe4avh8X1azpO7L
   g==;
X-CSE-ConnectionGUID: b7Evcq99SjWQAdP9t/c2vQ==
X-CSE-MsgGUID: SHF+6nEqRJObJZAifQ/eRg==
X-IronPort-AV: E=Sophos;i="6.16,264,1744041600"; 
   d="scan'208";a="90123037"
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([40.107.243.54])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jun 2025 19:47:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YQqxbNS8oM8g4es0yIr+5tc64N+EagqwUZSTh0zFeVT8XaO2O9+hRMEfOQGQ2p0Y+SgQhVLRv50/QXLY8IOw+QnXNdUAsdcZnKutweWIq+2SrG+1wRVu+jS9tNPl+MLAPu6di93XMGA3MZbg3YEFK9MsfJXdsXNKGJ1URQ2T98N/RcE3sGfNsv6fc7Nv+xbRgtTIgdzBgRFNsdg2IoI6g7uC+T3LbYsq/AbhJ4heqOsuT8jaa9LZeyXXpW8TgFqDgdrbcqf7OwCAWCoSoNzToG0Wr/9PDVahUvZzu/SF41JRAGMi943nc8gx80QSu2ouK/BLgS/Darf6jTRYrE3QKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaMrDexB/DEHnVxsKziEfzchC/SVQRGNbpL7wbYGHXM=;
 b=G5QujgYUcLTqV8MmPu04p2SBqoghPc9ZedfRHYDs9jdV18ZuzhziIxDr+fKBgHL7vXHnGC4z42gh8LhHd3p0db/MoKpSH/+B+hF1Qfu/GVRifzKY5RY5OhVwbkdkGyQZXD7SIxMjFYKlySmAmJ9OkxbdqnEX/zgQHdOqOQUFAidwro1F5VGSPUE56zzDMmcL9ZMpT6TEY37gd/aDz2eFAvS9J1lyTIQ59nai0DiHSr53XvjxJviUg9IeOBuib+tpFeMlcWQfUV5reh/rAbqGD3xhsMIQFY47c1jeB1bVUMFL8uXJHuYTA1w00WdYL8aD25r1kUBHPDLcy6t1cUpMng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaMrDexB/DEHnVxsKziEfzchC/SVQRGNbpL7wbYGHXM=;
 b=oguW2pG3kXBPqpJaqdUcdPsKcN7ItUSqETB5MD63O+E+4t4fpsk6OmT9qiCYbMhFzSeAk6xa4wji4ZQeQckT5hDVvRGsAB3ic/mm+KxH+07S8Ypn8KR11wS4/Dmjur/sUI5emH8KPIGkLsi6ofGiRDyECWsgViJgiMTsQbBaiGQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA3PR04MB8671.namprd04.prod.outlook.com (2603:10b6:806:2ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 11:47:37 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 11:47:37 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
Thread-Topic: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
Thread-Index: AQHb5bXFQozV6eiWT0epqQ3G7glIF7QTwncA
Date: Wed, 25 Jun 2025 11:47:37 +0000
Message-ID: <c57877ca-40e1-4f57-96d7-dfa2a4e8aef9@wdc.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-3-dlemoal@kernel.org>
In-Reply-To: <20250625093327.548866-3-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA3PR04MB8671:EE_
x-ms-office365-filtering-correlation-id: 1c25c308-03d8-45ce-2232-08ddb3de14e5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SGZPR1dvWis3b09mUjVmVG5IQzBzTWxWUml4RTJEZGZkQlNyUHBHeTdReXg0?=
 =?utf-8?B?bnNsc1RBbmQ0cmlnU0JWTEpKRzZ6ajh2N3g1ZDhWeHNKSGdIdGx5TXkwK2k1?=
 =?utf-8?B?bUM0NEZrK0M5NWtaUnZEYVgvSFlYOUE2MjFWUVJCYjdoQ1lwYkJQcHVPZGhv?=
 =?utf-8?B?MDR5NUR2a2ltUHIxbDQ1WUtNVFYvNHVFUXIyeWgyZGMwamFJUVltV3IzbkFu?=
 =?utf-8?B?UDlxQzY0aHZxMU91WTNhMXMvWEl2WmpEV0ZjSkRXSVRlZ1IwSGdvdjZucXZp?=
 =?utf-8?B?bHhEYUJ4Lzd5QmhTZXkwRzZVV3VxNDdlRjM1WXdxQ0Jsd05DN0FQMkdOMEc2?=
 =?utf-8?B?WXlXWm1KUEYvWkkvUWdoZGttTTR4Ym51QmRWQWF5VHVLOEZ0a0drVHhwT0Zj?=
 =?utf-8?B?RXpGTktEdGV6NWVJM1RHQ3FMbkEvVE1KOHJIYU8vOGZSSlZENy9UZlIyTW9L?=
 =?utf-8?B?M2Z2UndsK3psM2ZSWkVIL2M2RU5MNUNlVUg3SDNPd0dBYTJxK0luL0VoVWZZ?=
 =?utf-8?B?cXNKUjljejlXL1lqeHlrZmt6ckY5UkhTdTNYYU1kUlZLdDhSVVFha25CcC9x?=
 =?utf-8?B?dWJnQS9hUkxaUkhFMVlpMXZWVFpaY3R1MHlCeXN6SU93ZWdZWmxEUDlDUlNQ?=
 =?utf-8?B?SW5wWGVGUHg5Tkp6elh6YkdBT05Eenh3RGljcGRaaEJWd091ZDgvTjArWHp0?=
 =?utf-8?B?V3RwcFNzNnk4M05VZjBxWEFDeitqNGxaK0VjamVNelFlK2RjTElwb0NqUUpN?=
 =?utf-8?B?eXdjZ3pqWmtobTdXSTREejBoWXlKdm9CejFDWW5NRXBycTRuN0JxQ1dKZHds?=
 =?utf-8?B?bldrbXlVdXZyTHZZQUZoeE5uSmFJTkFqYlUwVWlmSFlmRURiN0puS1dwYnNy?=
 =?utf-8?B?T255Wk1Rc3JxM1N1WVBQOVg0a1Q5VTBZNkZCc0xZdGxtNnBMYTRGMWhYc1Ew?=
 =?utf-8?B?bUtXQ1hyN21wOFBVZURSRmJmQWdQQUQ4bXE5MjdjeGx5c01YZXlvdWNlOE8v?=
 =?utf-8?B?bmtVWFVaR2puYjBudjg2NnZlM2NrWUZrb0xFU093VnVQMW5YTkNYTDZjemRS?=
 =?utf-8?B?WXZ2Z1YrNldMK05KN2szbEpGcnRZYXQ0TXRMcHhpQm0zUlk4eEZaV3BpbXcw?=
 =?utf-8?B?Rlo3dm40eGtueHA2aEF5bGlhY0FJK3JzaW50cVRPUUN6MmEyam9iR3NSZGVl?=
 =?utf-8?B?bkZwQTFIUkRzWjhyaXRtajJsd1A4U3VzK3Nya3hldDJDNGFJM0dxVWpUd3Jw?=
 =?utf-8?B?SnhySklZK2l6cmEvN3Y5WUp2MkFodi9qN29uYTZxR3FMVWVpYThDM0RrQ21r?=
 =?utf-8?B?NGRxbnJDRjZqWHhOMllPZ1N0dzVsSWNpNWtFcjY2RUVNbXhZUVgzSVJwbXFP?=
 =?utf-8?B?L0s0UTFQRk1taVF0NVB3ZHlkZDI4N2dxZDBzWXhhRXR5YjZFYy90clU2dzNT?=
 =?utf-8?B?RUNsVmhHaUMxWXlxTXVjc3dxdFdNWTRzKzhnZGUwa0J5U2JiY1FlTkFHRThC?=
 =?utf-8?B?NVIzOW43dVpuVi8zaE5oMjBwTHNPUHlDbFAvcWZUQXFHVG5WekdTUXVZeGwx?=
 =?utf-8?B?VHIwMjd3Uk53R1VkaEFuRTQrd1ZjWWx1ekVtQVc0aWl6V0YwSStRMzYrd25i?=
 =?utf-8?B?Rm5ZOTFkV05Vcis2U1Z4T2owOXRkQUs5WnprMDBWeGJ5QUlFaTE3RVhYYm9L?=
 =?utf-8?B?TVFEQi9YZjJ5cFhxRzRQYU9pZGJVN1FlMThzOFRpM1l0RFgyZHJpcnJ6Mm9r?=
 =?utf-8?B?RlYwbmRWQjBnQkhpRUhZRjNBVEwzenBkZE1oa2JZNzZ3L1BVTVlTRmY4K1hs?=
 =?utf-8?B?Znk1N3pUdDF6a2haNERDK3F1andZNUw5U1JhOVRtQXRRZ3d6cGR6R3REVElR?=
 =?utf-8?B?bWlPejgrR2d4ZStqbVpWN3RaNXNzK1U4NzJoSDB5U2duYklxK1JzdU45TVl2?=
 =?utf-8?B?WXllT3NHeDhZSlk3OXdvY3lsaEZmbEQ3eEMwZnlULzdSeGY3bFc1NVBtL1c3?=
 =?utf-8?Q?BjoZrC6fJm+hpUCHJd0M4RjEw1dNvI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?LzJSVEhWUmlLbWhRNTROSUpBbHBibWdLd2orbXVIUlhqLzRnWWxid1NyWnRW?=
 =?utf-8?B?OThad2dMSFhTL3Q1MEVLVk9IZXdvbnhDY2c4c0t4U0N1UGZlWk01ZUhScHlB?=
 =?utf-8?B?L0pDMWRqOWFpZjBDLzNqcHk1aUh3S1Z6VW4zNmswVU1NNHhZaDhFRUVCeWlp?=
 =?utf-8?B?Uzh1QzFxVlA1SUFvT2FnU1NvV3U4dWVoWU0wSm5xUHpSMVpVUEwrblVyeVBw?=
 =?utf-8?B?R0hkb1FZUlg0S0ZnVUNpZlh3UU5lWVp4MUh2VExWZzBrdjFaNHdlSWRXUkU4?=
 =?utf-8?B?Nm1Gek5vQVdMN3hmZC9YMWp0elREdDFLcjZweFlYYzNnd1kvSWw4dGJqR3h3?=
 =?utf-8?B?Y1Bvcy9LUElZUzFidVVPencrTU53Rzc4ajBpSERnYTVmcVNnak5aVXRqMWtH?=
 =?utf-8?B?MmxITmNweDRuK2JWUHNpbWFmbUZwMDc1aEtJYWROdHg3RFdRdG1TQTMyNEZy?=
 =?utf-8?B?SngxeTZuYnZ6aG9qdzZPVGhWWk5lN1h6SW41cTJZZ01rVGwwYVNlYmFtUk1S?=
 =?utf-8?B?NWhLM3owVERSRXplSVoySG92MHVkZXlrcmtXakNzaGw3YXRyRGF1b1NjSUZH?=
 =?utf-8?B?L05pbVkyM0QxaGlqZytBbTlaS0UvR3UvVGRTWDN4N0d2c0FYRzNKVXBmOXZM?=
 =?utf-8?B?SGh5QjY4VHkwVEFUV09NZUhyZWduOWg5YmllS3pFY3dwUjY3SUJuM1RZb2N3?=
 =?utf-8?B?a2pTaUNrWE1JUVhFUVA4MW1YTkFoVnJyRE5lOFZKdlFGQ0IxcGw5ekRnM3Np?=
 =?utf-8?B?bjZzcGxna2ZTODg1VnNrUGdhVG5VSWsrUGlTYW5OSDRrcGt0MDFEbDdlT1Vi?=
 =?utf-8?B?MWJhM0Z5dTAzc0lHOUZaOVNLTlpBZGJFMEtkUVFWdHRaZVVyQjU5cTRjQmdT?=
 =?utf-8?B?VmpBcVViREZJRzNBcTJud201c2YrSDhPa0RJOTdBVFVSZXl1WUt5S3QxcW5M?=
 =?utf-8?B?RE9DQ01ydDBhMkd0dG14dTZ5THhHNkErdTRLWDY3UDFmWGNzQ2dpYTJuQVNP?=
 =?utf-8?B?TTJvUjh0Q1VZT0pvVDU0WVZmUHRSczk2VGM4WXlJUTJCZzd0dVY3TSs2WHhk?=
 =?utf-8?B?Qzl2OTIrM01QdW5XdFdxdWdXZ2I1d2pEa1hYUzJKTysvdmZ2aVF2cGp5cUFv?=
 =?utf-8?B?aFcvUmJrQTA4eWxuRlpDdVdNMkhUVTFFZ2FMZkJYNSt1ajBVdk9LaFp0NTNR?=
 =?utf-8?B?ZG1RMCtXdjIzVWUxLzJXMkFkTW9kN3M1Z1ZKOVQrS05EUzNEUEdpelZCUEZx?=
 =?utf-8?B?MFFHbit2SmtTS0w0L2d1S0FTS1A2M1hiV2F5VWF2TTMwZFFscitZNS90Z25F?=
 =?utf-8?B?aEVGRVkxM0JYT0tQU2Rrb1JwK21SUTFSQU9nWGJhcCtVRXhyUVg4M01WclFa?=
 =?utf-8?B?djJrTWpiUVpSWDd3aXFocE9LTnhWdUxaVWNjWVJvSDlTbFdWenJ0cjMwUGln?=
 =?utf-8?B?VHBUcE9FQXN1dkp6bkhtaDVMMkx5UzBLNm01M1dmSzRwQkk1RUo0d2JvMjln?=
 =?utf-8?B?VE1yRVpPQ2N5NWp6ZVF2eEhjb3lxVWk1SmxNNTUzZWxlVFcrRDBDTXhEU2Jn?=
 =?utf-8?B?SjVFL0VZZTAwSjFpQ0ZjTGM0OEVvUndRTXdKMmFCLzJ2VXFFZE8wa3JLUkJU?=
 =?utf-8?B?TFIxeXhLczFpQzFEb3QwNFFCZ0dONXVYbFg1RFVxTG1KRHN6eURjcUVBaHVy?=
 =?utf-8?B?T3BkbmU0T1RSM3FVc05IMHZrZ2VETTdjNURWNmZTcDRxaXNUV1gweWIrQVJi?=
 =?utf-8?B?RkFPNURmcWZPdGdHMEE4dGZxQzFCTlRSSzNyclZNN1FKMDVPQzNlYXZZWi83?=
 =?utf-8?B?QVFFOExYWVpkVTVvZWVvbDRQYWJUejYxZDYrZmN6QUNDMHl4akVRdXdYK05R?=
 =?utf-8?B?NG16dlhhRER6UGJ3MllQaDA4K2dFNHhaTWFORlpWWk9SN1YwNVJVS0V2VUV2?=
 =?utf-8?B?dWlyN2RES1c5eENKS3RBMHUxdGpsY0ZwZm5ITHJ5S3Z3Zzlmejl4K1BjUlJ3?=
 =?utf-8?B?Mkt6UHAvYjVHSFUzUjdpVC9wam1sNnNMakpDMXo1TSs1em01ZTRiYXpTOGhM?=
 =?utf-8?B?THc2QXMrY0grSjFGb0JHL0dpL1JIaGdkSndMMy9XdmhBVm1QaldBWi85cVBr?=
 =?utf-8?B?eXdnYUFBa3A4cDBkdkpzTm96QUhPQ1kweE5ZME9nL1dMcXBqVUJQdFpIcWRD?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB4DC5F0D04A794CA8DBBD5153701EEB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B5ov6ggCAhPdk9Tdsc+hNvZStbI5U4ES1UXT4e7Q9AYnBkb+gyoNEjSNn4iS6b6jtK84H/Hnn37DdPk8uccy+bX9EDPA+xTHULxLAd7FsXcQnElnBKYMlTJ4lvCwwvZeaxAxOOdl0oUFJK3E7YbVnfCb0EzDRBETdWoxUgyMI4ZCZgZR2asGa2uWwqB89pNCUyL1iI4MJCty0P/9JiH/XmN6fqWaW9Gx8a+yMRJXJtF8GwuED/jmW3/ZvRfSOQ5et4WD6TIjSC3JkApXuRBi1Gz7vXtktuWRTtzsafV8rq8IKb1rPeKKTjLYBdW8+mlG5L91FjYM416Xjdmh3z18cLpNmF1AfKPw2hqNQWGYtBzGBbuC/SYCPCD3XaIiCuHlMF0pdpVHTEN8ICXcEOXEOJfOmjBlthkKt98XAeGVnQUzYZoXryLJvILD36Z1dCzhZrOXNLUxcoU4VACgIhjmHMdxi60x0ZXw03jjECo9uUmh3M5uibqwtq0YeKJRE+aTzUHiqwpRWUyYROusQV+8gspq4K52ST0/kolV5SFaXXz5R814WQuAjc4dpYsrVirstGF8io+O+8w7qnh/k5/iWA2PZZW9tpkAVoDLtEa+wtXp/IoCTeLRNQ6iXv5MifIS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c25c308-03d8-45ce-2232-08ddb3de14e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 11:47:37.0569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BsV5xGIAEw5lX77yndfIF8CxQ/dQsgYILMjV6B3PkoVLjO7v0g/+xRnnCPUVIIxsnI+H16hFT97Wh7qQpweQqKwM1/BUeNXisbAZQTovWzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8671

T24gMjUuMDYuMjUgMTE6NDQsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBzdGF0aWMgaW5saW5l
IGJvb2wgYmlvX25lZWRzX3pvbmVfd3JpdGVfcGx1Z2dpbmcoc3RydWN0IGJpbyAqYmlvKQ0KPiAr
ew0KPiArCWVudW0gcmVxX29wIG9wID0gYmlvX29wKGJpbyk7DQo+ICsNCj4gKwkvKg0KPiArCSAq
IE9ubHkgem9uZWQgYmxvY2sgZGV2aWNlcyBoYXZlIGEgem9uZSB3cml0ZSBwbHVnIGhhc2ggdGFi
bGUuIEJ1dCBub3QNCj4gKwkgKiBhbGwgb2YgdGhlbSBoYXZlIG9uZSAoZS5nLiBETSBkZXZpY2Vz
IG1heSBub3QgbmVlZCBvbmUpLg0KPiArCSAqLw0KPiArCWlmICghYmlvLT5iaV9iZGV2LT5iZF9k
aXNrLT56b25lX3dwbHVnc19oYXNoKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsNCj4gKwkvKiBP
bmx5IHdyaXRlIG9wZXJhdGlvbnMgbmVlZCB6b25lIHdyaXRlIHBsdWdnaW5nLiAqLw0KPiArCWlm
ICghb3BfaXNfd3JpdGUob3ApKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsNCj4gKwkvKiBJZ25v
cmUgZW1wdHkgZmx1c2ggKi8NCj4gKwlpZiAob3BfaXNfZmx1c2goYmlvLT5iaV9vcGYpICYmICFi
aW9fc2VjdG9ycyhiaW8pKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsNCj4gKwkvKiBJZ25vcmUg
QklPcyB0aGF0IGFscmVhZHkgaGF2ZSBiZWVuIGhhbmRsZWQgYnkgem9uZSB3cml0ZSBwbHVnZ2lu
Zy4gKi8NCj4gKwlpZiAoYmlvX2ZsYWdnZWQoYmlvLCBCSU9fWk9ORV9XUklURV9QTFVHR0lORykp
DQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKw0KPiArCS8qDQo+ICsJICogQWxsIHpvbmUgd3JpdGUg
b3BlcmF0aW9ucyBtdXN0IGJlIGhhbmRsZWQgdGhyb3VnaCB6b25lIHdyaXRlIHBsdWdnaW5nDQo+
ICsJICogdXNpbmcgYmxrX3pvbmVfcGx1Z19iaW8oKS4NCj4gKwkgKi8NCj4gKwlzd2l0Y2ggKG9w
KSB7DQo+ICsJY2FzZSBSRVFfT1BfWk9ORV9BUFBFTkQ6DQo+ICsJY2FzZSBSRVFfT1BfV1JJVEU6
DQo+ICsJY2FzZSBSRVFfT1BfV1JJVEVfWkVST0VTOg0KPiArCWNhc2UgUkVRX09QX1pPTkVfRklO
SVNIOg0KPiArCWNhc2UgUkVRX09QX1pPTkVfUkVTRVQ6DQo+ICsJY2FzZSBSRVFfT1BfWk9ORV9S
RVNFVF9BTEw6DQo+ICsJCXJldHVybiB0cnVlOw0KPiArCWRlZmF1bHQ6DQo+ICsJCXJldHVybiBm
YWxzZTsNCj4gKwl9DQoNCk1heWJlIHRoaXMgaXMgYmlrZXNoZWRkaW5nIHRlcnJpdG9yeSBoZXJl
IGJ1dCBJJ2QgbW92ZSB0aGUgbG9uZyBwb2ludGVyIA0KY2hhc2UgJ2Jpby0+YmlfYmRldi0+YmRf
ZGlzay0+em9uZV93cGx1Z3NfaGFzaCcgbGF0ZXIgaW50byB0aGUgZnVuY3Rpb24uDQpBdCBsZWFz
dCBhZnRlciB0aGUgb3BfaXNfd3JpdGUoKSBjaGVjaywgc28gdGhhdCByZWFkcyBkb24ndCBnZXQg
dGhlIA0KcG9pbnRlciBjaGFzZS4NCg==
