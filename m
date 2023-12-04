Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357C9BE50
	for <dm-devel@lists.linux.dev>; Mon,  4 Dec 2023 07:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SKaQ/ygY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yiN+I2gx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1701676158; x=1733212158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lOEjn+t457yVCpweJbm0A8AP7VnzEyaBZiPkoXzVH2o=;
  b=SKaQ/ygYtZsE+RIVlTW4yQBldyCK6/4UmsxwC8ihf+6gPnb6WptE5KBR
   Md5GgBWABN1Sj8Z1ZUs8A+NMh7jLAlU/qke8z/ZLvO3MS2oJDAEBr9aVY
   3t7t9ICRqar5MSxVnQ0sbpcXvmQJHyVLwZIQSRqwdmWDdylyHKR1TNNSn
   yNScHyhm38+zsGn1SKDeIxaONhFvDoVSk/rg8ilgMmIN2z3htIylzPtsF
   nD1lwlzqeBHMkdEz0lVvY/8zPPJRFBZHkWPtsecaNEUHEaHIzkLRsxmyp
   Rh3g/0pAd7zEqR7xz2BXOb4ike/KV29fZBHde8ZKRWhwh6J4uSrsLMDQw
   A==;
X-CSE-ConnectionGUID: b8gjGK5SSHmAtj7HhXDT2w==
X-CSE-MsgGUID: SuZDmyMeSVKSCRLUxsHQJw==
X-IronPort-AV: E=Sophos;i="6.04,249,1695657600"; 
   d="scan'208";a="3932758"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2023 15:48:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtLLYyy65xSfycAdxk544t5lBTsa//RP3pQAzzBW0VhWAp5hNQzDtgLqnzRRNqXBxCEk3EH6xwaN6FijdZvyN4qfhNGXCyZp/o1NPGBLRmzxHqZ3oQnnX+qIjjfG6u5ss37kPXWBIwUV7iQFBW6kImC+IaIyWD6LVaetIgZ8wxv6mmMETcUyArS+u+8/OvofdGMrRs9CsPMzR74VN+bO4Gt0+wtvoyGgFoPuOjdZFZi+tCiP5x9glTxJCYocg0amftrxxHfpSvKmhRqMDstTHlOsfvCM6CAEDR1m7gcjPPSMsUYZrzdMKkwz16RdCMliMO4v/Sb4g4iAdNUlDIgBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOEjn+t457yVCpweJbm0A8AP7VnzEyaBZiPkoXzVH2o=;
 b=SRGoge28t6ukMcCK7Z0UmM6WQgxx46+BW1doiLDYhhBgiBuFmEWb/hmaRc3Sp4nt8OEJQmZBqV1QcKFhoojgXyNUu9c0swa/cRPTpW8HGTSU+4nuWoUZm72IDn8WmIheKHMoyX+EpCOYhapIrUg8167zL5jUMwMzLnmjMbh94/rUawR95juTl+P03foEZR+FvfA8BbQ2UeK3Ug5nU85yzSgyxU9T8+hShKy/PNvQZGummi12oTyHYAHHNh8K9z0F/KpjPSJ6EBmip2z8XaJv1ZZ8tfTQM4+kwoNZJfo03bGSKIXZQ1ROMhJUoG76/VKR5RNQc54QH8Hk/oDfZ1P8KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOEjn+t457yVCpweJbm0A8AP7VnzEyaBZiPkoXzVH2o=;
 b=yiN+I2gxOnTAscYPsMidxF81W7fUPvlhDFSrVNNHPFkkSLz4kYvA08lwNtTdkwYqE60QrxFmHugR+f1i4ku2ZCvMWA+okrI7OK0BXsDlHHzSu5Gko86h4dy684WQEVpROUfPaDvAoEF0xl2li4InbT6m6tHxCcHcbJm7ruLd4NE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7678.namprd04.prod.outlook.com (2603:10b6:a03:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 07:48:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ea3:9333:a633:c161]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ea3:9333:a633:c161%6]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 07:48:03 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH] dm: Validate zoned model of devices built with zoned
 targets
Thread-Topic: [PATCH] dm: Validate zoned model of devices built with zoned
 targets
Thread-Index: AQHaI/qdb+picwZWPECitrc2mSrBFrCURagAgAP/ooCAAH8sgA==
Date: Mon, 4 Dec 2023 07:48:03 +0000
Message-ID: <8d23ab8f-7ddf-4763-af94-d0b145655ee8@wdc.com>
References: <20231201020329.273592-1-dlemoal@kernel.org>
 <53550076-f1ac-4f74-8d8f-6f3f8a05a230@wdc.com>
 <0d40686e-786b-42f6-962b-e4806e3b7914@kernel.org>
In-Reply-To: <0d40686e-786b-42f6-962b-e4806e3b7914@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7678:EE_
x-ms-office365-filtering-correlation-id: 3b74944e-29c5-45ec-e8ad-08dbf49d589e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 zxkXIsunk/HfIXN89R7DBg/u+HFEcH3jh39URPMrKcw9jXoU2hSB5Os0WYZX4iELa6kQCwsPbRTtTh+n0dDflu5o1d/y/KSPn/K66XBrNnTDkg4Cs/ZCYI1wcSO+GJe7WQ3DFocGO4voRHRfU9rOs8uGj95IY51E3VJjccbMQNCgji6W56ofMvlM3cN8CdG3l0CZ2EaxeHYjolUjzjb1qGRNpSzLmQ4XnHDMMwRXwiSwoNGVDunv7O6ckZTY4cUC+KooLYT3lu1xbdYQK57/4B+LCGRffJkfAMWXdE9n/a5jaHhSiKunS937Ua2V+3iRic4TxUY8PiKb8GIhMcuOJm6FYMe1lYcxIUbVX5LEdnbA1LC+PvtV/5BTC8EuR1g680O1LvRdfhGOB8OVFmQoiVzQSQL38DVdaeJVULoQFj5X8GNYDjoWIKMishP0cF5H0Fh5Js3DLy2CZ13Gj/VRdWBpmaDN91zm3HlUAXbaedlGUgKHMuADGNmdSPEqxj8/dx1BAfq/w+SakwiRoWo0rX8lWORy1yli8nM1elHRuByNw9cYpKFapF5HHfqmh/FRdz3Kxo25pImCS4VGn45jPpuFDuac5cnBBTteTV2d8gPXn4C0PRPB00eeZGdM7l2oCAW1V9zPjqxfAd18YwX89u4YA342s5FOUGrYYzUy3h3Sc2EpOyQUMLIoLlodXm0t
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(376002)(366004)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(31696002)(5660300002)(4744005)(86362001)(4326008)(8676002)(8936002)(2906002)(38070700009)(41300700001)(36756003)(2616005)(6512007)(6506007)(82960400001)(53546011)(83380400001)(6486002)(478600001)(71200400001)(38100700002)(31686004)(122000001)(110136005)(316002)(91956017)(54906003)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TkJ2dis4YnhTdXBvRG5yTjFmcXkweDhRbXJUNUc1TzlnajI3TXhpc0tIVHd1?=
 =?utf-8?B?emJuMWxBRzE2VFFpdm0wbExkcFdDaTNZL2tXSndlMjlKL2RxWTAyMDhUeTlU?=
 =?utf-8?B?Z2ViN2dXamJzWlVXbG5yc2hGOHVFWnR3eVZjV2swS0NhVS96TlVHNTVQcDFz?=
 =?utf-8?B?dXRKajFaTmlYcEtlTVRodlVsNE9uS1J1TG5JOXNzenhrQllVV0ZwOUlRMHpL?=
 =?utf-8?B?TDBHVzZOOGlXNmQyM1BVZFVnSWYyS3hYV21aT3VRMklLMUpyUUZMdFdST2lH?=
 =?utf-8?B?dEc0MmdVcmtDVnJoeU5iOVMzc3BwOE5KUmlnNDZZRVRvOE1rMXZhNGQ5YVBy?=
 =?utf-8?B?S0xIdVBBZE82TnhBQm1NZmI1d2ZuQXJYUFAxMnhDNFhPS09rK20zQmtZT290?=
 =?utf-8?B?Zm9mbVRiU3RTdTdjSlRSSlp2ZURtekNIYzlaWWtmRnByayttV1lvejBFMXpx?=
 =?utf-8?B?Q2VTM3dyZzRJNW5HZ3VmUEg5NnF2bS9hMVQ2Mkl6dGxybU9rR3ZFM2s3V0Rv?=
 =?utf-8?B?NitFOXAvY2RuZDY3QktDeXphaE9Qamw3YmtHMWhwUVlNbElQbzRkTUlrdkQv?=
 =?utf-8?B?Rk5PRms1TWRKQVE1SU9aMHBkTmllNXZtVTRKdHN0UGtZYXlidGdyQ2FMcGhy?=
 =?utf-8?B?Vmpva1NLc1ZsVGpVUnZEUk15bWN2bFVXbGdSclB1YWFTaGF5cWJ5OUFhOElE?=
 =?utf-8?B?VmE2d3lERWU2SWlyNFVkMEExeVFDdWRRazZPeUNXQ3NFT25KT2xYeWRURDBv?=
 =?utf-8?B?bXVKdyt2SDZaNEJENlFnOVUyVWZWMFRRM2RnREZ2RHcrWmwrRDlvUjBpaTRl?=
 =?utf-8?B?dmJUWWdFMFFkUURxajdsUmFIS24yN2taQTlpTHNXekRzaGVxVnNlZlF2ckUr?=
 =?utf-8?B?dGJvTnBtK1J6ZVN4WUp3eWo2Q2FGZGVkK0xTeGNjT0Z2cFZoVExUa3pyeGs5?=
 =?utf-8?B?NVdaWSs3M28zZmFrdWI0S3B1eUxzdXBmUStja3NRSWRlamR0TXNqS2VSRkl0?=
 =?utf-8?B?a29nT09xVzRTcVdOSmtZRVV4UnVFejNUbFdxa2t5eGp6MFRsTEp3Ym5adDF3?=
 =?utf-8?B?ZkZ5eHpNdkhYL3M3WWdoMDI2QXVieW5HbW83RUhjMDFkMEp1QUlDdzVNYlZP?=
 =?utf-8?B?aUZEaFNMeEJGS0NWc0VOSU9YRTN2K1o5UzI0UjRyRFlYYVJnRjcvMzlQSmxJ?=
 =?utf-8?B?YTRrcG5EaXRuYWVycG1TT29iRXlYYk0rRTlkUWh4RytXVU9HTVpHN1haenE5?=
 =?utf-8?B?Qm81Ynp3WG9BV2NVSnBuU3c1ZmdKYm1abkFXL0w2VTl4Ykwwd3ZaQ2ltNUhP?=
 =?utf-8?B?QmVPZWxHSStRTURmMnhEWTBMZlQ2UlkydmxLSGN0M2V2TDdMb0gzd1Y2b01I?=
 =?utf-8?B?bytVNVFDQjRMZ0toQWlrQnpXazIwWmpyL09uMFd5RVM3aHl1S1dMVDl6VFJx?=
 =?utf-8?B?M3BNTWNhcGc3bnExdFhOMHpXZHp5Zk5WOEIwUHRGRWRoV0RHbC9BM093K2hO?=
 =?utf-8?B?QTY1RDljdWFML292OHF5MUw0T0JSU0VUZ3RKNHZYRjFSc1h3U01QckhEb2NE?=
 =?utf-8?B?bk5xUFluZWZlTVpYZ2FGQSs5anZVVHdwUEI1VDFia3lEemhyUUlsTEYwbEtr?=
 =?utf-8?B?OFRGTGtkM214YW41RmR6QzFtU2tFR2k2bUZQd2ZHM3JGK1ViQ0lwSjNOUFg4?=
 =?utf-8?B?Y292aWY1Q2F0UGdCT2FnMmNsSEJkc0FZckJsaWxSMGt1Wm5nYkpHMm8yMGZi?=
 =?utf-8?B?TTl5Zm40VHFyc3hidGNyeEZBOTlzclpZK2R6YXk4Y0FpWno3WStYQUZxMlNr?=
 =?utf-8?B?dElJR3pRTXVGM01DeEUxRFRIZjNWcGE2eVVzYWRucmU4RDByZ3F3eTZUZEk5?=
 =?utf-8?B?cEp2OFpSRGFpclBzM2RjRUxuSHRQbmVJSE1sYUNGK1IrOEFnRFB3TjVxVDEx?=
 =?utf-8?B?ZXR5UjNLUWcrMWMrcVdVSUxPN245c21WME5VVUVUYXNjekk5MTY5cnBncGNH?=
 =?utf-8?B?OVlWNUcyTCt5eTBxZEN1NlZ0YmZSNEgxMnlGNzg5VXkyQ2VzSlZHKy9iREVi?=
 =?utf-8?B?N21YdWV2enVYSHdBYXpia05tUGN0dTJSUnAxRzQ2aElUZEhhVGxHcTZ2alp2?=
 =?utf-8?B?SGRSWmhWT2E2TEtTY3VKMlFyVUhCMzh4YmxOYTJuZ2NSZndGZVR2eUJ6eTEz?=
 =?utf-8?B?bG13YXl3UUkveEFlbjdkdW95Z2NUVDlxWlE0a0QvaHZoMUZnQW4yaFlwUnk5?=
 =?utf-8?B?eS9hRWxYL09QS0U4ZTlOTzFOSHlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E27B66F6C0BE9F40818A71A7C1BC57F8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h64aQfs9jq+Yx5W+2IUJQkS9SYqAQ7JleF026P90Bsxugb6TR917CQ6DgoBAlfNv1Mdn7skOTvx80JP4fvqubgUjYUuhAsA6rug+nXko1DvLih0J1vlaQ1/FbNY9dIE0jePWOkuyfLhm8/3rnAKh5yIs6lQeKIb5YiIRFJWEM+xf/JiFK5bttCx/VQjyHlRxCsaNTPl88a0wlE5vZXmC+2vaITfFwBQIKsOlMTqiu/k6S645YAOX3fL/lOnEyk/Zb+gCXBWylZuKu0dfVIxzQmYsuWhlJapZlpTMCWizQzhiqWJz2/BwAlP0/JL/GG6IkIvaLglwJosc0mchjrNLxOUzp8V6KzhpjLmvfM9d32jJGoTYUyojQdzqzg5TuQebrz2F6IQdiOgVCEp0la/3HpLJKIhGS2E0cMtAuSrWEVVza2tkLchZnq6SpB5zfbX2wXuFpgMLDSUD7feCC3czhDJcPbDI7r8TkHxKc+CxuzJG8w7qrUBMg69bFZJ7reFUGm0WbdhfADQe3LUQzDXEvR6cDLI6jbkLb3v3GThS/SzAgDxS6nALZ4EfhGOhqlsT9GHwQhpg4915e82FRyYha1wMlO6m0uNb+IDy2HtkgjQ4Wx2EWx3/dQp/mX3vi56dQkeyfeWG05iTqoqe0LBvEgdZMIt8Nst0/cgIyU9M3QLgGxaHm7ZNuGhGxUD8lto1nFAd1mErhpe751dMB06CQrn0IsDGw8Its9o1yuhCSbmZ2gnE7CnxxAKdjD1wFtDu7oZtKw08m789xcoO8HdkpF126ER8YzSEARivJEAIMTWyE4gAhUXA8sBIj43JkUxvhyisSrTb/WRvbuxEWPzPndqh8uT2UpFiy6f0eAuKnCs=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b74944e-29c5-45ec-e8ad-08dbf49d589e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 07:48:03.6802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuC9M1GJi8b75hpwzzxlZml8XfGeiO6e1+OfQvjN45vpNdBg/XGous6rzecSrO+1wtIAXT/iD4Jlj2xDyDMm4lNSgi9ydpIS5dA3uAhQ3jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7678

T24gMDQuMTIuMjMgMDE6MTMsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBPbiAxMi8xLzIzIDIw
OjA5LCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6DQo+PiBPbiAwMS4xMi4yMyAwMzowMywgRGFt
aWVuIExlIE1vYWwgd3JvdGU6DQo+Pj4gKwkvKiBDb3VudCBjb252ZW50aW9uYWwgYW5kIHNlcXVl
bnRpYWwgem9uZXMgKi8NCj4+PiArCW5vaW9fZmxhZyA9IG1lbWFsbG9jX25vaW9fc2F2ZSgpOw0K
Pj4+ICsJcmV0ID0gZG1fYmxrX2RvX3JlcG9ydF96b25lcyhtZCwgdCwgMCwgbnJfem9uZXMsDQo+
Pj4gKwkJCQkgICAgIGRtX3ZhbGlkYXRlX3pvbmVkX21vZGVsX2NiLCAmemMpOw0KPj4+ICsJbWVt
YWxsb2Nfbm9pb19yZXN0b3JlKG5vaW9fZmxhZyk7DQo+Pg0KPj4gV2h5IGRvIHdlIG5lZWQgdGhl
IG1lbWFsbG9jX25vaW8gY29udGV4dCBoZXJlPyBJIGRvbid0IHNlZSBhbiBhbGxvY2F0aW9uDQo+
PiBpbiBkbV92YWxpZGF0ZV96b25lZF9tb2RlbF9jYi4NCj4gDQo+IEl0IGlzIG5vdCBmb3IgdGhl
IGNhbGxiYWNrIGJ1dCByYXRoZXIgZm9yIHRoZSB1bmRlcmx5aW5nIHRhcmdldCB0eXBlIGFuZCBm
cm9tDQo+IHRoZXJlIHRoZSB1bmRlcmx5aW5nIGRldmljZSBkcml2ZXJzLCB3aGljaCBtYXkgYWxs
IG5lZWQgdG8gYWxsb2NhdGUgbWVtb3J5IGZvcg0KPiB0aGUgcmVwb3J0IHpvbmUgKGUuZy4gdGhl
cmUgaXMgYXQgbGVhc3QgYSBjb21tYW5kIGJ1ZmZlciBhbGxvY2F0ZWQgZm9yIFNDU0kNCj4gZGlz
a3MpLiBTbyBJIHByZWZlciBzdGF5aW5nIG9uIHRoZSBzYWZlIHNpZGUgb2YgdGhpbmdzIGhlcmUg
YW5kIHVzZSBHRlBfTk9JTy4NCj4gDQoNCk9LLCB0aGVuIGl0IGxvb2tzIGdvb2QgdG8gbWU6DQpS
ZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNv
bT4NCg==
