Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2111.outbound.protection.outlook.com [40.107.255.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EF718E744
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 10:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728469274; cv=fail; b=D7P6Da0o57vJajCFSVCruaN31rwEsj+WeLga4xkhwXodmaxk57UcsoJmNSB6KGahuYTF9llduVrfMfWEubDITbKeUFt2zcsBNAnE7jo+lOcYaB/5CUIc0X9LDpcKDy5qkpGzT17hrc31bDD0+I8SQWhxiYX6aMhsUvqi2S9rp9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728469274; c=relaxed/simple;
	bh=CTlLGSLCZTaZnUEUQ/xQbciCB7QgIsKfOefb6ycXsao=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XPohsBPZMw7CtvDqJiImjF205NUbM/O3VztZhY6vy8d1eLryaFVPVaMIYbT4dcoMFQp6ngc481L6cIS76twb2XE+YTuwW2ystj3kqIqHIlrH3rEI57i9jF8CvI5oQPW+XQKr8mX6MPfBTlmND18oPApwScV98Kv6DMYIntcB+W4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=HKZp3Hc4; arc=fail smtp.client-ip=40.107.255.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="HKZp3Hc4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ov/1+EyVIpemVYsTVFzqJzhGqppYcUu5HGbc1jQK7OVM8nAHQTYvzrHIIlqBrddz+obl/aIIY2i/C6/xRUVflU6R6pX5YE8P1ivH5eThjM3Luk/mjgXiQ2rs3g/XKfirNtO2Su/JMFKYdwuYn4bDBSk2ZxR3bI0WoQLQMCiLDCpcJxtApVI7eJLqdQuXl8jFWO9zycO7xn5Ax8npv6fYQ6WTYBNGTksmASQGmmVAvtWdvEIDnCerdSPwRXrq5nYHzaI4s3d/sF9/cg4ffCTFLv/8lCKg74M91qKzRUHv3kPbuP1zVT8/7dw5mojWyvy2BGDqdDBX0ASK+ywXEgz+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTlLGSLCZTaZnUEUQ/xQbciCB7QgIsKfOefb6ycXsao=;
 b=V3l+rMrtoIFgLkVmHAB1kwT6r9rY0FZ1cKIJaLzcZiHfLo1OLh9XbgyO1eSiSYjVYO9GxLYkBWp1AppKQ1PQr8CTxAHlSioXbWIJtX9O3sGCjwQKBpxADrol3+JnyQ++U5o/NjSw9lS+7zdVsefzlgHVKgyQWFZ4xKehvJeCh3VJbWzJ8/3M5tcIKm+OTZLX7S7pnfxTM+ENEI8uTeecBRdl2h5/bcoF9xoUtTBGFRekgOl6+7cRNckeIgZ1U5ap/TizDbzapnNInJ0Z/AVZWVuyS2EsB/ZZBUHd1bRVB7EXYrCG9iEunDn6rZYeUbAF6YPq+KzqIHlCk9G2nlA4wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTlLGSLCZTaZnUEUQ/xQbciCB7QgIsKfOefb6ycXsao=;
 b=HKZp3Hc4eqaWoRWr9nM5oIPd9v05nWhjbBzawPEQ57MXSQerN78T8yNlmdoSLC+UzfZHGM5MLvQKexg8bNFiRZuH+dkJzuUNMMr10A+mCDKyL0hU0jJqwJ+N+yEiufKDLf4xho2QlX/Ej1rQJpLng/JA7QZt+733/E3UWWHziaBv8gaAlfQmsQn9JyO+c47/aC8FzJaUUwUAqWP8Q5kHR31EiEbRVc/UEjtklRwp+3vM+9kOvxP7aj1ZYpmmlb1KPGF9/FdrlANN3gjrJSt74n9NopKwuzI64CQh7hh3y3mHNDUnKPNVno0Sw1NZO/Z8BHmijYegnQuldZqKtL/xUA==
Received: from KL1PR04MB6804.apcprd04.prod.outlook.com (2603:1096:820:db::8)
 by JH0PR04MB8153.apcprd04.prod.outlook.com (2603:1096:990:a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Wed, 9 Oct
 2024 10:21:08 +0000
Received: from KL1PR04MB6804.apcprd04.prod.outlook.com
 ([fe80::c36e:5c8d:e0ec:9d9a]) by KL1PR04MB6804.apcprd04.prod.outlook.com
 ([fe80::c36e:5c8d:e0ec:9d9a%6]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 10:21:08 +0000
From: =?big5?B?UnlhbiBIdWFuZyC2wLrNv0E=?= <ryanhuang@qnap.com>
To: "ejt@redhat.com" <ejt@redhat.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Possible to assign the unsigned nr_allocated_this_transaction a
 negative value
Thread-Topic: Possible to assign the unsigned nr_allocated_this_transaction a
 negative value
Thread-Index: AQHbGg7fFwLiC1dZIUij76kOAaIZQA==
Date: Wed, 9 Oct 2024 10:21:07 +0000
Message-ID:
 <KL1PR04MB680469752FC520A8DB5BDEA1CA7F2@KL1PR04MB6804.apcprd04.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR04MB6804:EE_|JH0PR04MB8153:EE_
x-ms-office365-filtering-correlation-id: 641ac700-bfaa-43fc-b1ff-08dce84c16f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?big5?B?L2QreURpOUJJanFtWmk0bGsxR2U5dVFwSDNlVDh0VnVBdEFlZDE3QWxEcGhCZ2pU?=
 =?big5?B?WjVKUXQySkh2Q1pvc1pkcWlvc25pWVRVelJBSEo4UnA1YUxXWGp6NzBTcUt1bVZ2?=
 =?big5?B?VkcxdnFNamNmaXVzTEZCM09tSzRpd0Vrb1B2VnlXTFJ0Y0Z5SzhHa3M5WUkwa0pO?=
 =?big5?B?R3BlcGRVOTdaYURNNG1GdC9sRnhOYkpIYkliaHMzWDI3TUg4MUtLeFNDRmVGd3h2?=
 =?big5?B?N3NHN1dnbktCV3J2amJFVk1hZG82VWE2OEV4Titib2FSNnFJaXhpL29GbWZNdHJ2?=
 =?big5?B?c05WWEJ1VXl3UFNPcGQ0Tzh1UDhxZXVnZHJWSzJELzZoYlF5NHNxWHZ0SVNLVmxL?=
 =?big5?B?Rzl3YTltQWd2aGR4b2R5bFJlN1VVNmZ3TG5pTWFTdHhSRVZGRldveUVuenBRSzgv?=
 =?big5?B?MFRvblI3T0JXRTZDU2dIRzlvRVQ0ZzNKUTduZjhpR2JjeXk4d21YZlVMMGJCVU5z?=
 =?big5?B?YmlBeDUzbDlkci9NSDg3b0ZONVRlcWhRYnFVMTRNVHY5NFA1ajVaOVNJV0syeXRw?=
 =?big5?B?anVyNnlzMGwyaGs2d2I1c0RTYVlFeEdNSEllKzYyNlVJSlVDdzZjNi82L0I2TXRi?=
 =?big5?B?NTBlRHhiZElCc2NsU2ttOGdnWGN1dVVBVTlFTkgzeGlRUElUejExaEZQRWRXTzhH?=
 =?big5?B?cEhpR21LR3BlMFMydzBsOXcrN0FTd0xFTTB6eVFHZXI4b3VUSTNCQ3VPaW1UcEFP?=
 =?big5?B?SEw0cW5tNTVYTEZjcXBrVGVrU2NKWTNVVXYvYUt0NzdTMzFweWpaQWgzQWdkNEo0?=
 =?big5?B?YVVSNVd3bzN0QTFSeFJObE1NWG9aTVZFV2pHaTc3RDNCWlNBQjJBUDF0OXpXdjUw?=
 =?big5?B?UnhMakZzNU94VUV4K1prbjVRNktET2tTOGlqSHlpS1B0RG5zeWlsczl0RExSODRO?=
 =?big5?B?ekk4aStLeUtwSC9XZ0FkeXIrN0Z1dTQzOTB0RmFqMTIyQWNxdFFja3VsdFdXR3JH?=
 =?big5?B?ZWRoaDFYN2EyUFlZVldodUZ0MmFHTXVvbm01MzNocmRVV3BIbVZBMVFhUldHTStP?=
 =?big5?B?RVVDWkY4RWkxUnZaNnZmRjhLRHdXRWh1d2E2YWNiTmEvUWhHTVROdTliOUFuTzht?=
 =?big5?B?RXZzcmtzOUJCUkc5dnk5UGU2aW12c2tMTzVPRHl0WjlUQUxpTHNNMTNmZ2p4cWMv?=
 =?big5?B?VUJQMkMzK2lyVGtKNUpGZThLVmpZY2dtNEdpU0FRWEhXSmlvaHM5MFJjZk1qbXkw?=
 =?big5?B?YmN6Wk1jNGZEeHcraUxFQkY4VTZnaG95R2d4SWVza0pjb2RJeWtoWWYwSGZMVndZ?=
 =?big5?B?U2R3b0pZQ2xuRzdQL01wdGpwSkltWnVyQ3oxK2EranhEQVhjQjNpT3lMbThtV1ZI?=
 =?big5?B?Z3NOYVNGYzJyRlh0Wk1jbmVpUHdQNzJmeExFeWdqTTRmRzhsQmpDLytaQTIxSlg2?=
 =?big5?B?aFNRWUpwVlhxNjB2UDQ5ZUNKYTVYaUxNZS8yNVB0WjNZazg5c3NmUXhVNDJxeU1o?=
 =?big5?B?WW5xdUlQNTcySHphOG1Zd3hSMjFvaTF5aDA2UDlVVzhZb2tsbEJSZExMQjJLb1hH?=
 =?big5?B?Wnl1bEluVXY1MEU4U0ora0ExUm1xekhXMFl1bEVjUzU2eXF5TzhJUXN0WHp6OHhS?=
 =?big5?B?ZmIrNUVQZzZwMUV5VXkveVdPVSs3TlhpOXQ1YUtmeGJOZFJwNW1ydmxyUWVqbGpT?=
 =?big5?B?ZWVvdlF0RTQ2N3dvWGRuMk9rNTUxRHZBcFoxZzZQSkJOa1l0RXJDVHkycStvSWxU?=
 =?big5?B?ZmpmVkN2YlhvWlFKYjdjWVFyUE83Zz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR04MB6804.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?big5?B?UjEycmFnb3VxQjN0SnhWTmEvTVpnNCtMVXZNbTc0aUpETTVxVEpRNUxvVWh6dmVL?=
 =?big5?B?N252MjhkTVRhN0txSEYzYnhFcjRxckRTbFRwcnd3VUlZZ0U5N2l1em9wT0EyRmJs?=
 =?big5?B?byt4MU02Q2FickhVZERseVVXNnZNTG5jekY4RmxUYnNmMDB0c3ZBSmU0cG9RN2gr?=
 =?big5?B?RXVzL1JSWHQ1RG5rd1A2aXF1bXRqWC9IYzJpRW9TTVNvNzNGN1M5VVJpMnRPekVi?=
 =?big5?B?dEdmV1lYaDFmSC9OZG9vQWJyVmFMR1gvUjFSd29RamtWdjBDaGYzWUI1SURacmpw?=
 =?big5?B?ekZ3SkFXMnl2aVJ2TmZDdFRacHJlMjJLWDJGa2Z3OXY2MVcvOTA4cXE3TFpQSUMz?=
 =?big5?B?ekpTSThFQnJWbVNWYWN1a2IxNGJGdzFQR0RZd1lmdUU4L1ZOeVpiSm5HVE5OWnBP?=
 =?big5?B?YkRvZjNxancybldraVMvMnl6dE5VL3RPSjRGTmNrdVI1Rk9KRjhuWVBKRFozWHE0?=
 =?big5?B?Sld4eW1GeTV4ZkdtanMrYVdEeStCaWNXVnVrT290Z2RkRndqTWhtMEpuOWtqL1pE?=
 =?big5?B?MURzUGQ0dEJZNzJoMTdqUmRuYXh4UU0wQ1ZCTXc4bXZkdUhOWHpHM290Tk5BYnUz?=
 =?big5?B?NG1GSEc2YU42S0o3bUdHb1BDZ25XVGtGeFVhR0ExOFZEVkpnalhkRE12SWo5dTFu?=
 =?big5?B?RXk4VHdCTXNJLzhFQmIxV05FVllaaXlyNnJrNlZHU1dkbjhWYkFsUVE3YkNZakFE?=
 =?big5?B?dzI3TWRLbmgrNStTTDB1MHY0VEx3QUg0bnkvcWhYVVZPR2FYS0lQZkNvb2pqV1hn?=
 =?big5?B?T01rVThwSGs2TXRXTUFpVUFKNm5IMGczUDJXU2dRVlorNmdNRkl0L3JLMi93VjI2?=
 =?big5?B?SzFMWmtibW5oZ0xzMnVpeFl2QjhrN1h3NExjY1A5cHJYQWVzMWNXMFUveXlCa3BP?=
 =?big5?B?dmF5cmdtZVhROTJ0bnhCcjZDUjc2R0xMT3JldHlrV2NqbE1STHhwcEdOOWNuS3Vw?=
 =?big5?B?VWdDcXlGczdiQU9aMG5mL0tQOWhVNW5qQTc3ZUhYSUJhZFo5dnpjd293UHlML2dM?=
 =?big5?B?dUZGamEzYm42WWxNeDFCUjN4SXVWU0dSY1VzeWsvbXk5cVNndnBkVFIvWmVsejVV?=
 =?big5?B?dU1pVnA3cTBXbFFSUzRLUzBSM0IxcWt2dmd5Y216YmlkOGdTNUhabTVwUmo1cW5v?=
 =?big5?B?K0g1b0pYOEZVRmdTYWRyVGo3dkk5YnUxYXpuQjNTTVBqNkZXYy9aVGdRMTJJbk1S?=
 =?big5?B?Vk5Ebzl4K01iMjBteGxGM0pQZFRtcCtkS2pmZ3lQUjhjUmpMMnZ2aDB5Ylo0TUpR?=
 =?big5?B?cWJnV2FBS0xvM2F6L3B2ZkhVbkdXOE02ZGVYVURmOU1va1d4ZDE0YTE0TVFDU284?=
 =?big5?B?SWxscGRJU2lOVzVqQlI0ekJMYTQyRk1kUGdiUEVnRG84MHJpNWtiMzd1WjVhSmZZ?=
 =?big5?B?MXFobUJzb2JUMGh2L3lqWHFhWFRjalJ6bTU5ekszSWtPT1JhZlVvY3lhMjh1UFZo?=
 =?big5?B?dExEMDFSZ1ViM0QzcEVwK1M3RnErL1J0aWJhYUtzT1gwVE9rb3k5WUtUQlVzQ3VB?=
 =?big5?B?dFN0dWpVcmdROU11SHMyTHNJMUI5aEpKbnNiaHl3b0crRStzWnN0aGM3ekF5WGhK?=
 =?big5?B?bXozeEhlYzZsalVQR3RYa2lzWC8rcU04enpJOTVkNDJEeHJPcnQ4SFBYWDdERHpJ?=
 =?big5?B?RWV2OGNWZmx3TE5Gbk1KLzFVZWFrRkxOK2cvUFVCNkoyMXZUaTZRNVdYRk10SXJD?=
 =?big5?B?UnovRUlqOFhZTE1jWEgyN0l2ak5RWWt1ZFNxZUxVblZmL2RHa1lqWWxpYmpQemp3?=
 =?big5?B?MHkzV01uTDRiazhJbXkvV1MzNUtVUGw1OHBKUXVLMUtWby9kd21SMkFrYytFMWJ1?=
 =?big5?B?VVkrYURoU3NtSHdsVk1teXNjc1hqS0ROQkpkSWthTnlZdWRBMFFTWXQ3YUFjT2hm?=
 =?big5?B?RGFQcVJqTVlMY2M1U1NOWWtFcHpKRG5jdHNHajk4U3dNb1d1SDlHck1tdndjNWlp?=
 =?big5?Q?NJ3uzSxUzEh/5MZ7RxgU9TZH0jjWeeDupNc7F6z4DZw=3D?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: qnap.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR04MB6804.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 641ac700-bfaa-43fc-b1ff-08dce84c16f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2024 10:21:08.0146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LMcR7zOTcx8hD470jLfM//rcQEjCkqk2yoyDlpqXZ6AdSW1tO5cngngH/HVRu6J6owBxLtGFpXuyb0jyKaRg4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR04MB8153

SGkgSm9lLAoKSW4gdGhlIGNvbW1pdCBiZTUwMGVkNzIxYTZlYzhkNDliZjA4MTRjMjc3Y2U3MTYy
YWNlZTBlLCB0aGUgaW50ZXJmYWNlIG9mIHNtX2Rpc2tfe2luYywgZGVjfV9ibG9ja3MoKSBvZiBk
bS1zcGFjZS1tYXAKd2FzIHJlZGVzaWduZWQuIFRoZSBtb2RpZmllZCB2ZXJzaW9uIG9mIHNtX2Rp
c2tfZGVjX2Jsb2NrcygpIGNoYW5nZXMgbnJfYWxsb2NhdGVkX3RoaXNfdHJhbnNhY3Rpb24gcmln
aHQgYWZ0ZXIgcmV0dXJuaW5nIGZyb20Kc21fbGxfZGVjKCksIHdpdGhvdXQgY2hlY2tpbmcgb24g
d2hldGhlciB0aGUgcmVsZWFzZWQgYmxvY2tzIHdlcmUgYWxzbyBmcmVlIGluIHRoZSBwcmV2aW91
cyB0cmFuc2FjdGlvbiBvciBub3QsIHdoaWNoIHdhcwpjaGVja2VkIGluIHRoZSBwcmV2aW91cyB2
ZXJzaW9uLiBUaGlzIG1pZ2h0IGNhdXNlIGEgbmVnYXRpdmUgdmFsdWUgYmUgYXNzaWduZWQgdG8g
bnJfYWxsb2NhdGVkX3RoaXNfdHJhbnNhY3Rpb24gd2hpY2ggaXMgZGVjbGFyZWQKYXMgYW4gdW5z
aWduZWQgaW50ZWdlciB3aGVuIGEgZGlzY2FyZCBpcyBwZXJmb3JtZWQuIFRob3VnaCB0aGUgcmVz
dWx0IG9mIGNhbGN1bGF0aW5nIHRoZSBudW1iZXIgb2YgZnJlZSBibG9ja3MgaW4Kc21fZGlza19n
ZXRfbnJfZnJlZSgpIGlzIHN0aWxsIGNvcnJlY3QgZHVlIHRvIHRoZSB1bnNpZ25lZCBpbnRlZ2Vy
IGFyaXRobWV0aWMsIEknbSB3b25kZXJpbmcgd2hldGhlciBpdCBpcyB0ZW5kIHRvIGRlYWwgd2l0
aCBpdCBpbgp0aGlzIHdheSwgb3IgdGhlcmUgc2hvdWxkIGhhdmUgc29tZSBwcmVsaW1pbmFyaWVz
IGJlZm9yZSB0aGUgdXBkYXRlIHRvIG5yX2FsbG9jYXRlZF90aGlzX3RyYW5zYWN0aW9uPyBJJ20g
d2lsbGluZyB0byBoZWxwIGlmIHRoZXJlCmlzIGFueSBtb2RpZmljYXRpb24gbmVlZGVkLCBvciBo
YXZlIGEgY29tbWVudCBvbiBpdCB0byBhdm9pZCBwb3NzaWJsZSBtaXN1c2UgaW4gdGhlIGZ1dHVy
ZS4KClRoYW5rcywKUnlhbg==
