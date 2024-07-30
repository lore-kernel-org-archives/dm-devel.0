Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8C8945A
	for <dm-devel@lists.linux.dev>; Tue, 30 Jul 2024 02:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722305184; cv=fail; b=gQdLmpK6+6s/owoBmJj7hSRcVGLDwPySFKCnpawIKaiceckcZXn3OX1zByKCDxHoxdFU6QiGWqGFWnsAmFOcT1jMHZp2rE1uQgUkJbSu+BSWL0Z5gene84ZUfMJzXnr8RAz8GF3h2oZ8QH3ku8ts5AHyKtN64n1JYONVopuepRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722305184; c=relaxed/simple;
	bh=vinoHGwp7XFk3wemo2LJlCxbiaL9HP2x5oPHTgyA0iM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NS5YPYsKP0Lg1OVoouK7aULcgSEGc5UISRb6mHrIjUTKlT8fjoWb3pKsBDmghmvgYogWPkU3MqR0jyZbdBJlLGuQ/i/PMDI+CAxb/mUw4i/RDal63y3eNEfrrGuS+zDOMe+aqgOK/WS9xgHD6Lu24z08jbHT8/J2BJKS2VFYitE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c2cEJx/v; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JI0kvPOU; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c2cEJx/v";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JI0kvPOU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722305182; x=1753841182;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vinoHGwp7XFk3wemo2LJlCxbiaL9HP2x5oPHTgyA0iM=;
  b=c2cEJx/vIBANLSIH9L96c94csdx+Cm4Ut4MFPnLLbU6OJCqGCMAqayAp
   Q1aaQcKfduwMpL68WQaXijN9Vo69XE3tfpLhscwD1YbIc3CIV2K/FnBP/
   yllHoYwvIkJTBDtaHJXqITMcNmVh0qYnelGkUtnH2Ktr4wtLh1vmimCJz
   rfoJOlKimKVnGsaPSCwKKULptC2NziCX+VSL7z7z4S9qjpco1FN1Obja8
   f3+kaoQjB8/C9c3rLbeoyEvLG+yiSG8Alms/fsh3ohcJf1BA1YOOTrXzI
   qy3LX2Z33L4IhMBevhJ3gJeXFlXVDbxWKer3x6nr/j/ZnUWvOgt9svQDC
   A==;
X-CSE-ConnectionGUID: J8VHn4iQRm6YEX2wXIalkw==
X-CSE-MsgGUID: Jus+T9hUT3yqhTRZSmgHuQ==
X-IronPort-AV: E=Sophos;i="6.09,247,1716220800"; 
   d="scan'208";a="23026402"
Received: from mail-centralusazlp17010007.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.7])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2024 10:06:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mf5khCpy3V4UpjpYlTTW+FMkbI+Rm8HY1gWE3Ls7GaPRMqb0R3KhJO7xrk097YoxGkt7QGafhMGVvUBx8W4Du1UkOPP+93wixY0amyw0TwTqL8wz8G/f1+YxhQykK5kqtGWB7hje9SchmMfv3kqZef5H+X/F1VejQCMsV/BcFpNvCaFxOFUaxj0vdReVBa0n8DMnvuJBiMNqZCvt+pJKmWkQaKLTmK30se+IfTLN0qA9fux01wAIRb4Lgnjl9UypA9pP3w7oSv7v5RfyEkmtxlD7JU+JSdk9p7FHnHfI4eL/KfBDNcCcmjqvtueQQUP177duY4ydnE4Cm4b2hgOKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZEdQr2eFLf2Ug45veUgwaJ0XhBJtW2sjlDP9revbAg=;
 b=Ewph0mJWT5R6YSNWPHZZRMr/CYE08/L1tgKOQijDlAOLA6ASBkM1fG0sZX0fWAFACl5hGcHdTKk/bpGxYkLcJK5g38abjGyPLD+Y0x5zGdg7X25fPmalYmvwb8jNfGw5FFRmHm5H8SBo0QH5cOB80dw7f29ZP2kzucTURd7IoM4xsAcGIMp4w+6dZGLfwSZrUs3rrdJrSLOEPAYlJMNFdZHVoDpfEVOBBms/8fiezpKejM92Vwy+1PoPJp5X9Kdw4aB0ezPw+7gFvEgHqPbl8VtaaunipxgZD6bfHvEg4+xYYaeixXqVLCHzGdh69Z3V9Ei6Lih5OpvORYHJHCljmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZEdQr2eFLf2Ug45veUgwaJ0XhBJtW2sjlDP9revbAg=;
 b=JI0kvPOUGaToL/34g6BllEE5MbNcxnD3d+nnrwvLrnyuqZcjgriOHS/2GVckY0vN0eFUolKDEKrGOB1x0wUpUidMpTNWpmm5XuoYh+PsyfHembDtQMl571wYYld94EdNh9pC8xwc9CE5F5Z7o5/DV6fFO5ENC1oAPZecydzLYv8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH2PR04MB6617.namprd04.prod.outlook.com (2603:10b6:610:6e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7807.29; Tue, 30 Jul 2024 02:06:02 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 02:06:02 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Bart Van Assche <bvanassche@acm.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Bryan Gurney
	<bgurney@redhat.com>
Subject: Re: [PATCH blktests v3] dm/002: add --retry option to dmsetup remove
 command
Thread-Topic: [PATCH blktests v3] dm/002: add --retry option to dmsetup remove
 command
Thread-Index: AQHa3L0KjbRSJtpijUqgl5KG7hIJbLIOkJKA
Date: Tue, 30 Jul 2024 02:06:02 +0000
Message-ID: <sjuuchp6fgxsa2apep7tfyhf5hcbovl4z6nxiwj3d5chk667we@zol3b3ezcoft>
References: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH2PR04MB6617:EE_
x-ms-office365-filtering-correlation-id: 4c343a60-6107-445a-edbd-08dcb03c29a7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?jPW6LKYw45+2XnFoCKpyf0DV/G1MJ13egYy+Y/bgLMHp6BXbF/oKFyuRNrUC?=
 =?us-ascii?Q?/f82TbR1PaXYb8UkRYP3Xd94l2rw2XSbM8AkeLrwHpc+Zlxc16Sz4D75wNaC?=
 =?us-ascii?Q?DluxvO/KDcNeyx5x1U8pWBNJDs2AzMENPDkAhafRvZIXeUQ/KHiZTbwLorX6?=
 =?us-ascii?Q?IURuTAtvXvpUenzbGHLm/btTjqauUAXiR2h9DwIx2R+r1Ofx1wIeXd5nvGsq?=
 =?us-ascii?Q?lDjrHNEs4/YTAPRGN3qgC/VGLNOrbJq+vKUyaNV+bwAgPos94mK3Ups3S39t?=
 =?us-ascii?Q?25iJMZ0EvE5VDkEzJTLFynBsgMv0gX3gFMJlxeoRiZ6KYCh+6mu0WCCl/JOo?=
 =?us-ascii?Q?/cZBxsdPYOyVWuVCCaxaowCljjF87PQrAPTWYJsIAttTHLcHwYiOud7j7kk1?=
 =?us-ascii?Q?zTPABcQ6l7VHWTTHaa8Nru9uKaFi+PPlsahKNLBu6hCGbuea5RJexerZFTXf?=
 =?us-ascii?Q?GiJH7mQstOQdSQl9nVPh9uHn8JJ0JOCfI9Ep/eeZnCqC6Msly3hFdNaOu5/H?=
 =?us-ascii?Q?iqCw1tFRhvwPmkHOpLgKlJsqef0ds79blx8e4ajvVvP/+hAhXWmKz3tN6Oab?=
 =?us-ascii?Q?7GYjQm1h7+N9NzOXPDTwz1cpUbkzhRygOZuIc/q+Qa5VKSSi+fv6pG4vsbSB?=
 =?us-ascii?Q?w6WvJXVF1kSzWJdKcig673RN7fikY3SrgxhMZIPciOuE5VO8Ah/OtTsztbEV?=
 =?us-ascii?Q?fgBa+x2O/z03+ZtxSYqXW3s7JoyZaabbeyzNd1bHcNUNdv5Cg+QRsfxSkteF?=
 =?us-ascii?Q?XaCD4vjGYVwsYZ8/me+m60JScZ7ebbBt0O+CWWksARKkQ4WWLTsU+3xkVZyM?=
 =?us-ascii?Q?NlcDnj7QkbX2CJdCW2CMwqXOeUqzOu9O/1QvX919SV44tMnYntO5i/FwEn5U?=
 =?us-ascii?Q?ZC102YjdpL+dHW3PihDFJdlpf63zmpkNJCWdsp/g86N1QGTRP7vtNHbl1jBq?=
 =?us-ascii?Q?Ce0sH7C9kPr4hm+WSRFVH2y2OzVEivZjJAWVeb0E5x2tzTMDQG0nreuCwUeA?=
 =?us-ascii?Q?5wa9bI6LxziQasefiPcpX+rmSd9O34wO/tNdzFgmWp30EIKSPbYFaR4E2Pv1?=
 =?us-ascii?Q?p7yTC31+eKiv7M8DYpw6ViE9hXVZzKLYrFq8bgGcD9aVnKb4DVXBZogD/ft5?=
 =?us-ascii?Q?p9WcmhwWlQs1hFhrhyMRKEy+M93YGIAalXhMXQYa7RpVu+Z3Bf4KB4aoeh3y?=
 =?us-ascii?Q?LY+lRjFvExEjHixXJfv2l1Ik+uZASAUJBNZM/TOXp1PyXjNQpkz3NCS6czB6?=
 =?us-ascii?Q?xUkGK3GHL9wpVZlQhzKktBl1uDoBl0wglgE+cft6BM3+ipNFKUCHfrhnDDBA?=
 =?us-ascii?Q?vvSpR1safCHXwZYw/5d590MNMd1sZgtL6zw7d9GkFLCbYgNzo+x658+0fOj7?=
 =?us-ascii?Q?8RTzmR6uEZ3yjj8op6PkwKpTi2oAwcaea045qpuw6LI27kdE9g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zvEvs87IwGrOD4HW1IJk7GyNRFPftq8wL/+GfORuNh7NQSJiUvNH/h/0Qpzs?=
 =?us-ascii?Q?BpdniuZue3DY62vkI6Pwt3iUk8SKvVBQaHCWNf45baNnXThAEaEb/9EHi43Z?=
 =?us-ascii?Q?sZtQ5AVT8XIF/uflM6/7K+8quTbYcu2W5hVnhu/CjTd5nIHjjyZB/Or55nUv?=
 =?us-ascii?Q?BW0owpigWoaBaIXbFzAklmI80cCs6KofkGvr2dv/V3AvWzS6PaUYy25irC3R?=
 =?us-ascii?Q?HnSrX50HH/JbFb4OX3GucFw/xIX1XHSKXzVQDlJyiugX4gT3Bf2gcwVXfuZL?=
 =?us-ascii?Q?pG0uf4Oyv2cUdXN+Zar41mqlv7E9xSUBcVZLf4fEjW9P/LGed0PzfPxloTmS?=
 =?us-ascii?Q?xApI+n+d4kh5USGUmuVwV4wxrXbHzYGLzIBs5CgKJFsVBHiamaZmYfzkJ2hx?=
 =?us-ascii?Q?Eo1zG9C7AaYOtXSevau5ABRhjTAoz1VLjWy3Ikh5dXUsU/+chaIhxhZcATTO?=
 =?us-ascii?Q?SxQ+rar5KYXCFCGeK4WTKnJ8+gIt6PEOT9lxxxQtGT9xaiKSnJo8PDxV8S6g?=
 =?us-ascii?Q?eci9di5trWlLbCGhaG897Vcdmr62f3b6EpS4qwYGcM2Nz/vp30s1/g8SFfG1?=
 =?us-ascii?Q?2l97d95JeFi4N7mS7gpOFLCFWWqtnuby2HAfFPLP5uOCXRepgE08dD4yT5h5?=
 =?us-ascii?Q?lgpjY48x15kUKEscwEiryDhYHRvzB3YdhmKOgiD6afONJpvicWY9doZe5sC3?=
 =?us-ascii?Q?M2WmOHTq735ZxBNaNj6VxXDb3+j5Tpl+APCOgb008evy4wrWd/M3QIH3XzyR?=
 =?us-ascii?Q?ex/34ZB8TP3NRglvnalK5JAoE2iMctSjM3cdNa6iL6VXqRs6+a+GRJh2zqgk?=
 =?us-ascii?Q?9+0PzHFXBWNX3evD8IH6E9yQyx10iRgHVmJgpjJ3PR+hldT5YW6sunLq8iyA?=
 =?us-ascii?Q?qEj6iyHKwJsrvZrStCeuWox8klcORuMCXvSGJZTM2MZVc9FaZZN7xu/jV+oQ?=
 =?us-ascii?Q?KTWVSebpWEvFQfTjiiyh2nrQCij3rSlSOn4LeQYBncDrD911cRV1F9ZM+F7m?=
 =?us-ascii?Q?Ew2iUs3+c3bS1h/5rPbvIML1ZRmRJhft7XiC09hyRomE3tqsdfyBCvkpnq5t?=
 =?us-ascii?Q?tbn7m9DbZo5iH0hJbEpUZeE6jFKwnn2c8NS52kSj6dlIjbStTgsU/TzT2TCn?=
 =?us-ascii?Q?gwlbPaNLaZ31NZnEYYqglvg+3BSjKlJa48UHOsG0clp19byprLdUkuwemcEB?=
 =?us-ascii?Q?7sAqZ/+TpH6foe8qESC6QmIuVdTsMpTSD/fJXyrKHpknxsVWxTq8yVPuxIEP?=
 =?us-ascii?Q?P72SCJiZExpWNmRrZobj7EnwPkm6EYLKxwFNmHhaThKZRkNw4/s42YTE+2Xo?=
 =?us-ascii?Q?E4RfTh37AIEAUPfZAItHUM3yhbg3sW6mv1Q5vgvu6Os4JRgb6Fw55xGEMsCS?=
 =?us-ascii?Q?FB2/Vew1IV+Qclkhn4DNOCg2jr0CeOa6BYUAUd/XLbC+dWKp8w34lvvU9nNG?=
 =?us-ascii?Q?XtsNyhHrTU5mqrr1dl/nmMrnKTWr/wfoIpw5MUQWRyTM3Sn7DoKV50QvSqNS?=
 =?us-ascii?Q?RMSadlm4QcPB25nGv2j+iFo/8SKSV/PduEJ5Fdf/4GuFOOZ3xJBF4qSw1ua1?=
 =?us-ascii?Q?0ZiRzgCWloEi1ykfv+FXCi/posZUrYPBA5MR1sTlEpShSiSOqMrpDsXPhWKx?=
 =?us-ascii?Q?gHIj188sQ6wxTAbvubuilVU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E44216F07B60AA4CBD9E7CB9F3F35B16@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iT5+tCp87z4Xp2eGvVn85GhpyDMk355ZW0IRDY9wu3L6Q2AU01W/GdRVpFd+kCMHbOO6rAycyP3s69Db8DiY67KdYAg4BfWnJLmrs22zooV5mpWHB25g8p/up1jHAfleDEUqFrlHaVsWZBnPG/X1eyMd5abOud4cFsOl9wfaFRZRg4RVPbVkr7JGX4SxJPvmgcacbOIyTGiUUffimXWR6JyQMds2NlMdvcUPErLLaM1rOPvxayZzL5un7xEw41GChcaTbIjnHnNu6dRIYGdMxGYKr83OZ0DQ/R1wV/5ecmazTzJlDJLJJMiQ71vHBi/Wvs19f9hOEl2ovpuDxLjvd84oTM7peOZ6nvkpDM+6f6vqGQ0dxui8z2JAOmTBymz+3OMZzLE3b2VWDcOEXoWuEhcfZdT+Tj/lEkJPBWHdjEaUWTpWJBwYcDUlx03a3Exb4s8XX34w0bWmGMdFCTZaIiTKdJaXNKbYSL9zlmRivIgCHdeUwWfa2P/2njystnXlqfPFL5+i36FHCFCQpWoMNs/Zyzx8qM3J1550INvZ84ZygT37pjHrMWra/5Bst/gS+exl7Zbz4ikFfNZplr4iQWeiyquu5VMpKsCEHmPdt4viLTJ9VQTjdWt/mF9cL+jv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c343a60-6107-445a-edbd-08dcb03c29a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2024 02:06:02.2555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HyFCtf7hmeLiXeoWksOPAeZyzGJZtqGSwRLc2zUT0ho2LS8njV7s37R9M2fKUWr1pX6zSAy1zn3c7TRkHm1MacC6pkqox5GbEmUXXr/tlA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6617

On Jul 23, 2024 / 13:58, Shin'ichiro Kawasaki wrote:
> The test case dm/002 rarely fails with the message below:
>=20
> dm/002 =3D> nvme0n1 (dm-dust general functionality test)       [failed]
>     runtime  0.204s  ...  0.174s
>     --- tests/dm/002.out        2024-06-14 14:37:40.480794693 +0900
>     +++ /home/shin/Blktests/blktests/results/nvme0n1/dm/002.out.bad     2=
024-06-14 21:38:18.588976499 +0900
>     @@ -7,4 +7,6 @@
>      countbadblocks: 0 badblock(s) found
>      countbadblocks: 3 badblock(s) found
>      countbadblocks: 0 badblock(s) found
>     +device-mapper: remove ioctl on dust1  failed: Device or resource bus=
y
>     +Command failed.
>      Test complete
> modprobe: FATAL: Module dm_dust is in use.
>=20
> When udev opens the dm device, "dmsetup remove" command also tries to
> open the device and fails with EBUSY. To avoid the failure, add the
> --retry option to the dmsetup command.
>=20
> Suggested-by: Milan Broz <gmazyland@gmail.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Thanks for the review and the test. I have applied the patch.=
