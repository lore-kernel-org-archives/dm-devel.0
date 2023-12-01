Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE27820314
	for <dm-devel@lists.linux.dev>; Fri,  1 Dec 2023 11:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NkDiC/u2";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Rpp0UwxI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1701429022; x=1732965022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OqIimT3jZfD/7iALZOkwt0n40eMClsHY+yPr3Gz/EeU=;
  b=NkDiC/u2ZBIy2kESiwF4f6ejVqhAvW2DJP2DCnfnfm5a/LBNMzQ9fuE3
   52nNjgoIaFppVvlZrgTJN4rvFZViFmK9QpEbLTMZQTpdfPW3ynBsAUAdz
   Ya43cR1slmskp4rx+j8MwR+yLBP6VyU4HcatwBG3Fe+WEP/hEuYPJ5atS
   i/xP29iyg0Oya8PSVFOoBpp6uMOGvzlJadGdgm2mk9eJn+rHBYpnYG3u5
   I6ZKlBiBHwZcl9e8t45CZw2puGjRm2lc7zVAcSZOUoB3cJXP4cIp5x+CN
   ZpRX5zdpoSZCVByAyXM/7CcdTq4/2YTDJFCkDl68mGGpq1WbkqmpBJr40
   w==;
X-CSE-ConnectionGUID: 3NPLKFVCTHWpU7zxTy8cBQ==
X-CSE-MsgGUID: UUT2sFweRQ+5R9Ue5Xcoxg==
X-IronPort-AV: E=Sophos;i="6.04,241,1695657600"; 
   d="scan'208";a="3758168"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2023 19:09:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leIRbJW3slEY1uLw3sHx/55daGB1mPqGy2fJ+AazBbB0t1MvlJyIG8D6/8sz3cgNQ1jqQ1gtbOFn2nEzfWr3/8yHmA3+/YWzmsAprgj9NWgecIGUZDcEN4VPsGpjRng8j7GBpJQtLLlL3fy8tfPbG2mfIKdKKZnTon8W1jqCTgtjiPcQyQYznYZpuo/XyBGGrCN/Y2xzKlWamssapiI6T9V44z76Rd2P69ZLqzHZyi/PncgcwuOYWqxteBbIcpek+TfNFtnx0I2ky6jU5ia1GMJseFNwvU5cyGvJsojrwGtYpaiaa47jxvKBNGIo6bzJZKEy4dJpYg1eGfJg/N4uow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqIimT3jZfD/7iALZOkwt0n40eMClsHY+yPr3Gz/EeU=;
 b=b7tJrflwmpAKfuWh6BKkNZ6ucTieoAZhvUBy32IuSzWcXbzWAnj3jWfmd4kwheq5WsnneK77rCsfiUIwLa4eCl3uPcNNJ+0g/FF+Bf0i7BqfK0T6wM1RK1r2T/lUhccZ+cOTk4s3DfqmvrjH4Me6Q+ADafyPRuCp8qXxfnR/gRJTPmRRvkr30UQfG3rZnPqTvALaowXbkRrped6ax2kRzXWS9H+kgxwKyYDa/di/hyg43o8dnDbsYvkyi8KBNqoxE8nhEkC/9vDKbD70B5nWO8JHc3oOhiXyDjR5AhMn6SUyNHnirDDtOH9RYmTc9Xh1nUpPRYIppttRA0ScvR8R+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqIimT3jZfD/7iALZOkwt0n40eMClsHY+yPr3Gz/EeU=;
 b=Rpp0UwxI019Hr4303+oSaO+6ObU46AcpbYJm3wkTv6gszlZH8JJwHZW+y00kC0ju/LVP01Q0rYwUy3tCb8HlnjpML0rZwiBI0XYA2/uVmAmEz3HZVCwFfd36ClkRjXMKz0IVrKE5xDbE03u3152o8AItT++7jGsOUAKxRkGQEh4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6700.namprd04.prod.outlook.com (2603:10b6:5:245::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 11:09:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ea3:9333:a633:c161]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ea3:9333:a633:c161%6]) with mapi id 15.20.7046.024; Fri, 1 Dec 2023
 11:09:11 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH] dm: Validate zoned model of devices built with zoned
 targets
Thread-Topic: [PATCH] dm: Validate zoned model of devices built with zoned
 targets
Thread-Index: AQHaI/qdb+picwZWPECitrc2mSrBFrCURagA
Date: Fri, 1 Dec 2023 11:09:11 +0000
Message-ID: <53550076-f1ac-4f74-8d8f-6f3f8a05a230@wdc.com>
References: <20231201020329.273592-1-dlemoal@kernel.org>
In-Reply-To: <20231201020329.273592-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6700:EE_
x-ms-office365-filtering-correlation-id: 447d31a0-1095-4f3a-b5ca-08dbf25df250
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 soXjDdjoEqPxeWC7AFgBm5dwcTPgzUJIzfVaC0T4sJoGHxkoXVUvJJNZiJT1t9/Ozfobt9uFU6YNLWpOxPez9ZmEDsFUu7JV02Ej51ScdCC4UBkDaJ6IMLKIrwEjckUNi2ard8N2I1M5t6p4NN+vk/xG2TSV36Ili75RzJiXLZVavrU6ALJyNr2wdps1D7ODxvahYgqvtBhYU5NhSYLJ4rUJUK4evC2d9gr868XPbaZWXTOasZiZr5QAqGQlmxCrcgvUDiDr7UzOKK0dv0J3mUqjqGgsXeFA18twxKf7OCD/KVc9Hp0jl/tnT7HzD2a0nbhNP02CoXiEoVYdo5h9nOICfNzz97up414frQf8Uxxt+P2rOcHmu5XD85GQdGQRt5jNRJD5+IWtqBzjWFhugmgAiXJBIfuLS50m8N1gsrmTTxqrCVPkUCo8CdfS4yJs7LDqVmI7m/+ITwADTeeJR4v+kUWBYf70PtRI7q723zGAe+GqfeSsjYqOXJSynon3r4SSMb782/KrFmQwWQjf11I0V7r/9IOdlLPbOr2hySrP+qrCXpvqpq8HhQKx7tmqXj5B22vF+ZnQRpDAxJEcmj+PnNDa6J9WTuc7jpciYew4YK+xZm7mY2Mi/HJzjBlHvo/gIzutGkpbNrFPC0Q+OwTKJteLHKD2ZCZ5Ww9zBzUyE1MLhaLCAx4Era3iwm7V
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(36756003)(41300700001)(2906002)(4744005)(5660300002)(31696002)(86362001)(38070700009)(2616005)(53546011)(6506007)(6512007)(82960400001)(83380400001)(26005)(71200400001)(6486002)(478600001)(38100700002)(122000001)(31686004)(4326008)(316002)(54906003)(66556008)(8936002)(76116006)(66446008)(66476007)(66946007)(64756008)(91956017)(110136005)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OEpvdVozU2J4eG1QZi9qUGh3bGIvc0w5MEJORVA2eDBFSkNWNjdzR1JRdVBY?=
 =?utf-8?B?aUg4ZFZhcUpEU2dLN3h1NVpCVTNDM3BRaXQzU3IveWNJNmQrVDhCU0NaT1Ex?=
 =?utf-8?B?RjRaalUzaGt0L3RRYUxOb3dzKzdla3NKODVVY2xTTG5aUndQOWFMMlpHcVNr?=
 =?utf-8?B?VnRDZzZvL2VzMnlNaUxzTTBmTFJ3ZWR5TGxMU3d3S2ppSXdUNFFFTEZSMnpY?=
 =?utf-8?B?K09zemFncklSdmpyRmpEM09qY1EwbUxZK2VjdE5Cejg2U2RzSS9DV2liQnVt?=
 =?utf-8?B?bVA5bm1iQklUd0owUkpCVldZV1doMjVCSnVWY2tHUjFUM1ZVSGFKaXEyVGVa?=
 =?utf-8?B?RVFFZ212NWZURWZrRFlGU3NKWlY5RFpiUVJDU0tDZkhyL1pqWWJ0Q0wwZkdJ?=
 =?utf-8?B?OC9UZzNta1dTZVNYSWtpUkkycHh2OFJSSlI1UzBTN2FqWkNkN2xoU3k5STJD?=
 =?utf-8?B?R2krMVBtN2J5ZUdZR0ppNWJQdDJCWFU1MkVTRFN0UDJtWU44em92YjdsenJs?=
 =?utf-8?B?VXMvc2VyWGNMVGJWdmNiSEk4S1R5d2hqK0phbHlSSzFJcTV1aThYSjI3T1dI?=
 =?utf-8?B?Z0JwMStVVGJDZ1dZeHllNHAwaHdBSElWUStLdnpBWG1TU1lWTDhIdVppTzgr?=
 =?utf-8?B?REpnYmg2QzBpU3o5QmFhMjRMMmZkUTRLV3FrWU8wSHhWMXZ3QVhnTzFmQlJz?=
 =?utf-8?B?QllTNCtqSVZ1eTFYUnVXUGRQY1BnNVdLNTNBaVNpOFkra3pZMzJuNEdFK2N2?=
 =?utf-8?B?RWNwWkpTYWQrYlJPcU5WQURUMnZlaXFnUUlYckE2Z0dMSFp4U0tHVlRwb3dW?=
 =?utf-8?B?RGpYYzBpT3YvaWkyT05qMGVGZ0kwVjh0aU9yUCtCY1lEdndEV2I4Nm45VTU1?=
 =?utf-8?B?STJuZCtLTTlSZituZk1xL1hTTkNNc1cyQlg2emh1cWU2NEIrSER0RDhsUVVo?=
 =?utf-8?B?TnFndG1XU0lWN21FdmwrUHVaOStsRzZhQzZnS3RlMEgrQVVEYmczeFg1TUZL?=
 =?utf-8?B?NFE3TllJYTVDc3lINUVtUEF3eDd2Yk9nMitRZGNHcTc5MnZnN3FBZVh4NURB?=
 =?utf-8?B?NnV6bDF3blZvZWxWenRsR3F2QnZpMDRBK3BlbFgrN0JqU0d2T2NuZ0NTaHdo?=
 =?utf-8?B?WUVtS1djU1gzamJzRmQvOVozYU9NVkxObVQyRnBHM25Gc2ZKeWRCYVVNK3RT?=
 =?utf-8?B?dmo3OXBOVzRCUDFSQ1d5NXhCais1WnhYeFpVNTJ3L1VTS1h3U3FLRWZTTGhV?=
 =?utf-8?B?M1plMHFaTGJJcVVzaktGaGZFbzR6aTJnTmJ4MU00RXBnbTBQdUxoMXdSakls?=
 =?utf-8?B?OTZXOFdZWjlZUHlqZVVYYjdEbkxSa01HeGI1VUt2NHhxUEJiVHpGdEJTN0gz?=
 =?utf-8?B?U3JYb2RlN3NJODkrTEx0aUcwSXF6TnVEenRZYzZWNXNRWi9RUklHWTluZ2dU?=
 =?utf-8?B?azZyVFB5cjhjU3JyMzc3MC9FMmQwd1pyV2YzSDk2b3YzK3BPcCtTTWVoK2ZX?=
 =?utf-8?B?MHFJY2V3b0FlNldLZERRWmFCMVVHZVl3dWlXQW9aQmdCOCs2Y0ZNNm4yN1dR?=
 =?utf-8?B?YTJEdDI0K2c1VlJzNDRxUUtaUlJONkl3ditSY0VVeFdRNVdDR1JyRWVaZnBW?=
 =?utf-8?B?V2dQTk5NNUppdXNFV3d0bklVMk5yTGZ1bW0wZEFPTnc3S3NWQ0Qzb3lGRXZx?=
 =?utf-8?B?ZmZkOTVHaGtzMHBYR3ZjY2ZhNWo1bFJpcmtkSGVDSWVjUlgyZmxHL1JaWVNO?=
 =?utf-8?B?N0dlZGVKZmpQaFhtMzd0L2YzdElBWko4UjVnVWdrVU9hTE9sUDJmZVpPWDVs?=
 =?utf-8?B?bXhJbUtWa3M0MDcyaTA2VXFZUjVtOVllOWJRaEpIMzkxSnNwRUw4ZHkzakxS?=
 =?utf-8?B?TmlaSmxvL2pGN1RIUjZsM0JIWjN2eisyNDFrTS9SYmZkK1RqdXZlTVFxdzRq?=
 =?utf-8?B?Q2tjaHV2MTE3OC9FUDdIZkZpQVZlNVIvYm1mbGVTMGNnMWdDaVhMYzJ5UUNE?=
 =?utf-8?B?Q2l6bHNJMU9maEM5VUdGVnRLUHU3a2RwSVRVSG82bnlvOEp3b0lUV3dkODBv?=
 =?utf-8?B?d1VhbzlhYURuRWJ1SUQ4VzdhYnhHVTgrZ0tTY3lRdGNHMVdaR2plQTFDZjhN?=
 =?utf-8?B?MzkwVGU5Sk9FcTJXUTk0QXdQKzE2cEhXSFRlbUdRNFRQd0Y3M2c2ZUZqY3Bj?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C5128C299C1914F922083A19C27A66B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9EBbYyP3qYRCEP2QoXWpQA8vVKNWdJbIuQWwlTLLNoI9GOuHGtevYZtfRsj+kJFRS09NlvQt1A6TQOXB9RLbzKpwnvBTZb4on6R9bFzH72UAPclR3ekRrzQa99RMn8o+TTdswbFw6+zbputVIj2xfx3Gvi2fIL+hgbu3ab8QRih3+kAM5vV/+JmvVMD5uoyJkOz2oNJdhQbjFH7LSvEP8CPvztPCy05CfueGup2WborSeSnXwHsUuwLNWVkIW9OjygtN23jlMunm1FHMIyX+79OyqmfiZFLilnqE84hW68zRKtRl0/GuTJH7uqiy/nO3rv+cYtjA9CIBUXOQghAIEGNUg5ochvaXeoBSEuVYxrtLf/bKbeXBycoL/gwSSVm/eRKkS4NAqKbAiZXxFFKyZF6FX/3RwvTLSWuDOBzpgnJEyryl1BEAEzi/ixwIc1i0CCtVTQ/qqxveXb07K8aRmV2UgxGJYpA2zfZNfvTJWyHVe98y/xLhhNLjaBPA7LSeoYXzNFy0B7C+CTh2oIqUCRyYFfQT7lQ5Bvohb2WsHCtwfjCiLh4F5+C58oA7vRbY3ceUYulvUpxTvXDuQp6DtO0iY9XXNHCXZe2njp/1+jmrI4t3A6vThX4vwQZut2uBpR1tdt0cyMlHP6Y3U72h8WuaDq8EfenIQ3GnZ9BzCrBHxQAHCzBKnModF+9+819oaORFi/4rl1aQDPwbulJe1pwlXJti1U4lx5FRhzAdM76+TaBvTDOV20x9HVbsv4KvQvz+lTyyJDZ99q8d4TpY5CuDNsdFo1iSSho0Ht+MbjPKUPUR7SZISs8bMxXsdkko6PV2FrtA4Ki7qxmqkoXzuQKq79+PwmAdUXqQbwrVgSw=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 447d31a0-1095-4f3a-b5ca-08dbf25df250
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2023 11:09:11.3898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gFSDNNJ7um8q0Yn4awII9k3SYKfH+Hz7NGKzkZ+f4dmC+Tcj83HKd+kCoiDFikP3s2Eu6GfypCcmA0scCrr3FsF9GAZ0KoFlcCMzlv6ab+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6700

T24gMDEuMTIuMjMgMDM6MDMsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiArCS8qIENvdW50IGNv
bnZlbnRpb25hbCBhbmQgc2VxdWVudGlhbCB6b25lcyAqLw0KPiArCW5vaW9fZmxhZyA9IG1lbWFs
bG9jX25vaW9fc2F2ZSgpOw0KPiArCXJldCA9IGRtX2Jsa19kb19yZXBvcnRfem9uZXMobWQsIHQs
IDAsIG5yX3pvbmVzLA0KPiArCQkJCSAgICAgZG1fdmFsaWRhdGVfem9uZWRfbW9kZWxfY2IsICZ6
Yyk7DQo+ICsJbWVtYWxsb2Nfbm9pb19yZXN0b3JlKG5vaW9fZmxhZyk7DQoNCldoeSBkbyB3ZSBu
ZWVkIHRoZSBtZW1hbGxvY19ub2lvIGNvbnRleHQgaGVyZT8gSSBkb24ndCBzZWUgYW4gYWxsb2Nh
dGlvbiANCmluIGRtX3ZhbGlkYXRlX3pvbmVkX21vZGVsX2NiLg0KDQpUaGFua3MsDQoJSm9oYW5u
ZXMNCg==
