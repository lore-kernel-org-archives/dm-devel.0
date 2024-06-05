Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D01957E3
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 12:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717591226; cv=fail; b=P//ysVNG/Dfe0qspYvQWNbH+Fbu/OtIcQHHhiGNyC+va9jzRKqIUlG5QR81x7cQf9Rubzg+87tJS3PrVgfsT8jQ2wBpON7tTWQWzrKsIe/n6rzuA39h4orKV1sfpTwvc7iGWA22AaoEBaAbyd3AXF1L8dH6bkrVR3unkRh7L6xI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717591226; c=relaxed/simple;
	bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=krj9PzUZtYHeKT7pyIZ/nZbyARLA9qrKaThETDI8i/M+IF0DXcwjdVhDAoZVtIGi/QvCEa1desYPOxfqqIItargmv88STYIFt8MGRO/2aji/vc/0I+HmrNIuKhxfjKkKykcDRyUPDqSHt7jwKl6/9YD7CRn/7/ogF9k+VLXyymU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ART4TSX6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=m0vbu6+g; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ART4TSX6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m0vbu6+g"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717591223; x=1749127223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
  b=ART4TSX6aGNxuq/ErsZi5nJ1rzlTDvHxO03F5ZdxzYzErUkD5+N7JFsN
   2uJ1Z5PYJRQ7AaeHBQiMNdle1Q6IPL0hGwNxVxSe7Lzlc+zI6RsMCTpJt
   KKgRXCIMnP5KASl3ltT+NC5hSqMLYy3bw6uWw7sNRbCUCzAIIZ6RaT/Az
   0Fsvlb23zp9JpxpkmCXcRbcb1H//DQVYAzJICzrGnHHNCi4v3cwQTGyVP
   HZ1PjyeRWIUVqCfTn0uKnVCWMF4kS0/FpAYhLT8GBQRkF61HtEo0wtBlB
   9zoGenliNw0/YxijNxMSNHSpiXEZM6/8HZ8NSSjAGXXFIx1kcygUZd9v4
   g==;
X-CSE-ConnectionGUID: 95DA4DxNRM2bU1rr/W2GIg==
X-CSE-MsgGUID: oKh2hLc9TSGTn0y2iY81Lw==
X-IronPort-AV: E=Sophos;i="6.08,216,1712592000"; 
   d="scan'208";a="18319238"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2024 20:40:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeskTPvpGSZOFf6mc/eBH4n+YcTWfhRwtqtasUqV5smgm/6XGvWbqntRNKwRvb1ycQgVWYQcAg+MKb2+SDuRyThqW+EPhA6KX30ZbI/8FtguoKm/m4HJ8I5/xTx+gbRf6sV96fBIhk14j+3hG7cUHaaGXx6GyU2+m/Gf26JW0mDEzkX/xYhfs/W61dV7i8OkPrYAl8u6UGSL7aj06p3EjGmQ/NEB+ktV2r3dmRylbYi/nJMu/G7VhDOj1ynuHetfAZck8VbvsklLUvL8oH1T3e9gq4t+D18PNwf8nS5wRLCV/GQCqdD2Z3ju+PSGApPuNuvyXS7EcrWAgrmNa5aeRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
 b=hu/KWa/2Czkingx0Ph4YaJZ1hQgMytJwRkEHdKZ0C2akuj8scKWNd4LxflFCyOTP6YXtsm06KGuhwpDnPkV6FL53RAbRVAHz6eRdFU8rqdpZRO8x7cePOjpSDLiAHmoDRDnPfP4CGzUh2syZsfx8g2P+Fe0vdw1zcfl7veTOvwO0TW7Qo8FOddD+bzYynnb1vz6AU4fu80uinZbar2dfuXPdQlNRaijfgszcYuO4Z3AwzNTWoZ8VoOBqV4KRBBD5srNbpzHnOinceowKVZa47wCj/tR7E8lj71ZIHT830iJcYFC9UuAmSe/xtFlFdzBLg9DLEzAt81zdooQC+DVZ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
 b=m0vbu6+gkdWy8gkx2MXZdAUvwK9Zc0B6YIYvGcuI1Ccf1xuJjHY20JX2JGF6P+VmeeoN/jAQdWHoulGXZW92jEWyyijwnm6u/wkv6Bu4VMUF2e3gmDt8k5iwe0O1gB5w3df7BK2iBBl6C9tSEJm+rDqR7fB3anuKU9X5oxDWIeQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7438.namprd04.prod.outlook.com (2603:10b6:a03:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Wed, 5 Jun
 2024 12:40:19 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 12:40:19 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v4 0/3] Fix DM zone resource limits stacking
Thread-Topic: [PATCH v4 0/3] Fix DM zone resource limits stacking
Thread-Index: AQHatx1LowUW9IfEnUGGSMCRWOxPgLG5HNGA
Date: Wed, 5 Jun 2024 12:40:19 +0000
Message-ID: <aa290fed-b70f-406a-91e9-7f6946d9941e@wdc.com>
References: <20240605075144.153141-1-dlemoal@kernel.org>
In-Reply-To: <20240605075144.153141-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7438:EE_
x-ms-office365-filtering-correlation-id: 879f708c-9a67-4a10-87f5-08dc855ca8e7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?T3JpT1JFTGxOd0puS2dYZjlWQVU0aW5wNXFhK09BMDBuOHl2WE1tOTk5TlFT?=
 =?utf-8?B?bWZYWW1ld0dEMGRmR3diNE0zVGcyUG9KQk1NREo1MysvVlpkN0NtVFZKaHNa?=
 =?utf-8?B?TzYvWkRFK2swZE1aNHFPRC9wNzQ1Y0hObHgvOWtENTNiOHZWZHBSN1Z4MDg1?=
 =?utf-8?B?TVArRUpWcHlKdTBvNmJSRjdxRm5udnkzWTV0M2VpVkxQOFZ1ZFhLd0gxSHFw?=
 =?utf-8?B?NHgrdFdQQms2c2doR1BuREh6U1V2azBJd0hNTXV6RTZyaDJXblBRbVVURUlw?=
 =?utf-8?B?WDBRNE5rY1lTZDdkbURZWEwxVUI3WE1iUGswZXNpaEdWSzZDNENsdWJaQXlU?=
 =?utf-8?B?cDVNak5iUG5ZakF3RTdqMnE5cUtTcmo5MFBBWkFPT3dWMDJ1TE44cFJDS1hC?=
 =?utf-8?B?bTNtSHpwQ0hCZXpJdmwwQVh6VGV4VEZEaU1kSnlQOUlDa3RrNng1V21FOUds?=
 =?utf-8?B?dlFXMTJ4NTFVV3BhNEpROUxTd3YzU2lvSUFwQ1pVQXNIZUFoY2NrbUs2SkR3?=
 =?utf-8?B?THdjQktWY0YzdDdYNXE5VjR2ZHR3bTljbWZsemd5ek1wN3h0cW13cFNCZ1NW?=
 =?utf-8?B?UUtCaEV6L0JDNjBTYXd5V21XbmRXN2NKMjZqUitRWkpBcC9tdUYvZFlEUHNK?=
 =?utf-8?B?ZDBESDE2c21YditGTU1mVng2QTRyWk8wWWluREVqUWRPYTlvMW9BWFlKK0lO?=
 =?utf-8?B?SmFaaUdVa2hHRTJTSUNqQWlUbjc3ZkhpNlRuRHZWc3dsQlhveG84a1lCaUZM?=
 =?utf-8?B?T2pFMitUaXBseU53NnEwZDFsWS85WDFoVnI4Y2JpNkhZelVlelVLdjhzekl4?=
 =?utf-8?B?eHJkL0oxVHB3cUFXQXBKN1FJUzNheUhDL2JnRm1HdGg5amZqNlBMV2V3UXBx?=
 =?utf-8?B?M1haUWcrKzQvTXJJbmNWeUhuVE9QTUNRMlJGenlHRUJGTFlhQTdxZ0hjbjcv?=
 =?utf-8?B?WW5XbHJhdU0ycUs2ZkxJM3FQNityQ1pkZDhWeUFyMVV6S01PZGorVHdvK0hY?=
 =?utf-8?B?NFp0MlhBQno4dDNSWWEvSDh5TENoQ1hNS0J0TUdlNjk3RUUvSlZXNDVvZ2dL?=
 =?utf-8?B?ZjJGeEdFYVZLQXFLbFJUYmUrcEdLaFdzWEh3N3dGUWZQOTg0cGFqbGQyWVdK?=
 =?utf-8?B?SnBsYkVaaVNJcXJ6R2cwL0ZpajY3YWg4TnVEemlDWEpkTVcxdVNoaWJpZkZV?=
 =?utf-8?B?aFlkUGJMOGYzcGFOUC9sNXk2SDVPUDViaVZvZGtNRUJhcGJsWUtXNEwxTlBR?=
 =?utf-8?B?Y1p5T0xHY2hNb01zMENqTjZHSnd0Vk1xUXNLeFhlUWswV3F1d0tFaTNyenZu?=
 =?utf-8?B?Q1lRQzQzUVRhQ0QxYlNUSmUxZ2pLVi9LZ2p6VFlpQzlYdHlJZnZDV2xjY3hp?=
 =?utf-8?B?ZHEyU2NqUE5aZXFFNUE4ZVVtRXRkYnNhQ0JhcGVZeGdEUE5ZL0o5Z1pjUkpn?=
 =?utf-8?B?NXo4dktaMUtoTFJGblY2TkZFMTR5TkZaREVnK1pEb1FLOGdvZm13TnJzNUY5?=
 =?utf-8?B?emVFSktmc2JuaU5GZEk3K3RvalYvMTJhMTMwczR3RFJ3QkxyQXJkZkZPWDFk?=
 =?utf-8?B?WVNYcVZJb1ZudzF4WGlya3JjTGt4VE1EWFU5VjlQaDVNTHROcHVVQnFpY0pL?=
 =?utf-8?B?cGVDdGRZZ05EZC8zRVZoaHdDOVNuYmdDUHc4U083WUF2WnFLQ0VuNmpOMHlN?=
 =?utf-8?B?bTI3ZDF1azNXZWEwQUlUMWJKcnBIOWF1THRkRmZqYkdUc2pUNFR1NllxQVhU?=
 =?utf-8?B?Mk8yakVsb09NWk1RZHl2RWx6RUJsc1MreUJkbXlXQjdmRkdPVmg3VitPYTdZ?=
 =?utf-8?B?enkrYy9VRmh1TXE2aWZwQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Nzd3YnBQUUJTVkN5N0hqY0Zpejg1VGZSNTRFRjd5Mm8zQ0pBODV2UDlONVk0?=
 =?utf-8?B?elBrWUJUVVJtMzlRSlc3L0FUWVJkUklEMXMzREFoSUdVTHNwL1ZjQThwZjNJ?=
 =?utf-8?B?a1pxeCtZZVlqYWVBRk5nbnFZSGpZUW81SFJBamwreHN5bkEzVExDcWZseTA4?=
 =?utf-8?B?VExJc0h0TjM2OTZtRzZRbit1UXlBQnhjT1A2RlkyYklSa3BxUldaSWt4emU5?=
 =?utf-8?B?VmRXZGFydm9KYkdSbXVjUU5JemRhWDlDRzdxTmdqNTZFZVhJOFpjaWhGby8r?=
 =?utf-8?B?Vk1YUnAyVlljZDVEN1JmdEVJdnY3bEtGdmFHUzFOMTJXaXc2OTl6bnpTbDY5?=
 =?utf-8?B?V002bnZDWmFpVEgzZU4xWlVhc1gwK0hYQTJlQ25xY3RVTDVPdTJPRWh1OEM3?=
 =?utf-8?B?RXlKZTdYVStOREdOcEVYakJFd0JmWFp5SU8rU2Z3VVdxeERwTExza29pNjF6?=
 =?utf-8?B?RHdKVHcwZnJSWUFxNDJzRXFRR0NSVmpNaHBTKzBEZ1hpKzRRTHh0KzRpd2Jy?=
 =?utf-8?B?blFFeEhGQktPNzdKN09LUk1tMnFUVFRZM2dRZjdqdzFvQ3NvYVVOZWp6V1ZN?=
 =?utf-8?B?L2hDaldYSmJwMy9MUTlac25Tdm1sRmxMRmFheWhzRWpTSkMzY09qUmVYSXFW?=
 =?utf-8?B?QjYwcVpFTUYrWlVJNThBd0REbnkzc3Fqbmx0ZmZYaGgyZU9qaEU5aUxGOWRE?=
 =?utf-8?B?aStQUllqVWcwSFV5UzdOcnRIK21NVTdxZXNkeW44a0MvOWRaK0N3M1d1QkNS?=
 =?utf-8?B?WmhFNkQ5eHJqRStkODI1NThvVGxQZjRRSWR2N2JTRUpobzhqSWltaFF4Qjcv?=
 =?utf-8?B?Vld2MnBFOGcxL09lNy9uNFAxWEFidWREUVQ3SjM3Q3NxSG9vTVdrdGxCaDlo?=
 =?utf-8?B?OVFYQU8rY1p3YUJPaVpjdVo0Um16ckRLR1JZTlZkRUM3VUgzalprWWNZbjVK?=
 =?utf-8?B?VXZWZTc4Ulp6K1JaNVM2R1o5STQ2M2ZHaldGZlF1T3B5cGxsczJ4MW9vZFpB?=
 =?utf-8?B?dE1XRmxjUGR3MkVvRkxiU1F3SWdjVm5YZ3VDZFZmRGY2dk51SHo0REZhc3Rn?=
 =?utf-8?B?dWQ1SDhSeDcrVVV6QVg2c2I4di8rWU1ybzJ4eERsMGo0cXV5MnJ1WTFSVU5h?=
 =?utf-8?B?L0RlQ0tSRGF4eEhNc1hMSDVFdnpkMjB3Y1J6aDcrWEU4SXY3cnltTDlFbUwy?=
 =?utf-8?B?WmpCRnNqQUVZTW96dmMvb1Q2eGNGVVNVR3dYVy9vYXlXU0RpQ09QTm5ZV05B?=
 =?utf-8?B?eWZMQUtJZ2EzbEhJZG9qUmx5SUxHOU1TNm8vOVFYNWhxUjN1ODQvMERyNjhw?=
 =?utf-8?B?QUlyL2R2MkU3eFMyRUhvUFc1ekt2YlJXWGQ2blZhd2VHamRXMmk3ZVlDNm96?=
 =?utf-8?B?TFFIQWxnZ0M2S21TNDZRSE0wdlRBVGRpM1hZSk1HR3ZGelBWbWt0NU9WeXd1?=
 =?utf-8?B?S0NtTXNHZlI3TVd4TmZQeSt4Q0M4Q3YxODlXUmxWd3Q5TXFZcDNiRVUxK0p2?=
 =?utf-8?B?QkZheE40aFpsaEFSVnRydEVOckwzR2lCUStBdTdVRDNkRmFOVVVJTDQrSXlP?=
 =?utf-8?B?SlR6QmRoQ0RidnpoUGJYMHVnWWthSmlzUUVXZ1drYjlJTHhBeEhZRFh2SEhD?=
 =?utf-8?B?V2VubDVyMEdoRUVjb0JGajJSNXk0M2RaUEZnTmNVcHkvc1pNVS9JTGgvS2RL?=
 =?utf-8?B?akVGV3N1RlFMZG9LNjhhZWRqQUlZQTdsSGNWTEVvbXphNk5nM01iK3FJSmkw?=
 =?utf-8?B?czRFN2xROGlLU3FxbnNkVmx4V0pocEtPSzQwaUljQ0FjV2Z1N2F3cjZzeW82?=
 =?utf-8?B?amcwUURzeDZIYWhFUG5GSmZWL2V0WmYyOVJNSVV3UkYyZEw1aGNaTTRLcGlM?=
 =?utf-8?B?WVdCaUpBOXRYKzkvT0l5NkQ1RlBHSUFGaDlOSG9nRmFvUkYwenBZQkNMRWVE?=
 =?utf-8?B?RVRyRkFSM1M5Rmc3UVYxc0VnVW1raTFDcVJUWHlsNVdQZ3VydG5kUmVGSXpy?=
 =?utf-8?B?YUdSWFVmS3M1eDJnRVJIdU0zTlB6SlV1d1dmWlpaODcwMjlXd1czdUd0ZGpF?=
 =?utf-8?B?Sm1oOCt5eXpRMC9vU1F5dHFoSTN5RGZ6LytlcXZEMGNlNVVUTHVweDJvN3Mw?=
 =?utf-8?B?cGNySUtwRTBTeHpiVFVvWDRPbW1EVW04bWlkOHZFak5hcUpreTZ3Z1hwOEdx?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BFAC4DF765C1EF498D2EE0B23A1273C2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ba97pRrweIIKDwY78j5nrwxxJGMa+k+ADdEnNfJHWQxEqhCrRSRRZQm4MQJiPAwxZlo4c6wgeV/AQkxLZonWtxJanDp4aaarjgudKW9dS64trnK6p5d/dx42HcElLpB8j1/m9uFbLSoathPp/3XkOS4bVWA8NNjhPo1Jnqu3fYLI/jhPdVgiiOAjGXoYWGEzYgEk0AVMGz8PailiGwxzULuqa+psYzh6KDwOS7BYWW50IdivqrHZMWlnXbKSSKpmtsJfudxdcT1ctXkomYfbKMsIWkD6LpUej5u0H7TqLLGIeALz+BKpSVgFcrCgVRpypPV8Q7VPlwVZEIOH+atzucC8rt1rZAalyXtG+F7KOB0dm/GIF0BeTy6nDgCqWbTMDkGA7dINWx3ZCN833EyBQzQH/8qf5ciyY9l6WuZUjUTuRF3iB0zwGceRI7eUbPNMiIca4raCpy/JO8iv2FIPJiA2ca2XTn1sh4fTwlFPuxnWYjBwmhvVNSgsZRk6BVz9hqN4rDW5PRNWEwFrvh4GFlT6hkNNzWNtihpIfwnLOlen1ncz0bVCQ0FjluMDsIEvBgFONrB9CfwsfWksTj6q6crY3OThbtz4fcXrguzRijx6MHuA+KmGicN/732x3U6G
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879f708c-9a67-4a10-87f5-08dc855ca8e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2024 12:40:19.6558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KawlQfZ6klFdGkQ6Hoj7pR4L4t1Cm+KLCx+gR5U+HHL8aaGuUE4Ns2xs6exkEi9qq4bX574h2gQG0+CAQILabVdQL9ezUbxHUQU/PuL9gE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7438

Rm9yIHRoZSBzZXJpZXMsDQpSZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5l
cy50aHVtc2hpcm5Ad2RjLmNvbT4NCg==
