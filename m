Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541BC80C07
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 23:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721345004; cv=fail; b=eKeMo5brBHM4DS4Dn8E6e2fcGASVfIDQprRTMEsVqy/tnGjZgOuc6vC2aOnD4pXQYXHizsd+GUNanrOjWV8Lx8roxddSc9zE2BUqr1zidlZ5PPjCm2+j+BESXVprJFRu51s5F5eVmmL6lPiHjrTVYy0OlG+cgVT2E4L0kP4ik18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721345004; c=relaxed/simple;
	bh=Us7mvwMGWY9PqNALaEQD0Q5Q+hzIAdDxvSlctwsmKV4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qBKR7vK5OCpODm82WfQcUyfIL2TIcMoIElfS+trmB/GX6E1YzExdogoevuJYEf/OWpZ2NX4ugaJe9uzBQkpO1npTs2umtVYcIL8zxd76NeZvldAez3WXUqutn4X0MyMUg2b89VvZ5qL/bnY8Y9gTW4X8fF2Anzl57aMmbuYGxhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oTgOl2YU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KUMtheK6; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oTgOl2YU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KUMtheK6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1721345002; x=1752881002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Us7mvwMGWY9PqNALaEQD0Q5Q+hzIAdDxvSlctwsmKV4=;
  b=oTgOl2YUogw5pdOVc37940A804rL6eOnSEjOqszwYnKRTYT9+hV1n7jx
   qZc1HabthaRbvy8sMX2NvaLyjpidGNUDjlEclbxUV/Klbw/rpO11rpLsI
   SYI88a3mD0SPe33BYh8ytPaTjdfyCiEcwPv09eJ0LnA38keAi3DmffxaG
   Qm23RT7cfUT+155xMJx4OtZu9fhiARYdstz7pOWs7RFIlI4gFubQiO5Xh
   6m7t3LBzzC+KHNxGIg1yP5TMoSL1UB5ivIZN//cJ8KAWSgsaS8wkN3FYr
   R+6KpB7Sj9V+aAn4f6UJZQjW5NsQZ5ex7W2sB0FAwWRbJzfzewXBCITKe
   g==;
X-CSE-ConnectionGUID: axqNFA4NT9abvpZtMPGoLA==
X-CSE-MsgGUID: NgK/W5LgTaKPjrhFJEyxgA==
X-IronPort-AV: E=Sophos;i="6.09,219,1716220800"; 
   d="scan'208";a="22225864"
Received: from mail-centralusazlp17010007.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.7])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2024 07:22:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=paDb9F+qGheO6/WfR8b5Ovgnn9TWNNYGOHyz6C3zjZGomkOLOt+UFcaOtf/DQWJK011A4C40BdLHvzauJUFf+hErLquhAZl3yv0ZyRKvC2IXt5CZWsTPnom7+/0STKm9x9WqmBpQaVrxzVz4YBtGze0zcEU3Qtf5Ru55ht/0CPsTiEIuV9ySMfoxRlCjF+8DwQmP55Mym+GZyIBwSxHZkieBaQAJ8S47kYPaM9XqTvPM5ZmBAj7NQHMDfQ7wX05AxngqQEyRn673rtwBZSKWNZJbxupqYKZX8NKtCTQuXCwOsSMKIXZ3+fevkRLuXOrD8ZNx/kSwLXGyFCYrYMnyAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Us7mvwMGWY9PqNALaEQD0Q5Q+hzIAdDxvSlctwsmKV4=;
 b=OWFGZa2xH7t5Ll0KEp2VZN7AUPDAu19REA2RZMjhQ1CEjC0S2sBYl2r7O9R9HmxP1Xp9vjp5xfPi3AACpZU6ojBQsqDvLq1ohGvgps9tplcAGhBmx5sX8Q2XZITIZGrpFHG/BtgjF4A4E6qx/kVxTIYWfHbZhx1RjmmXhM6OaavrcEIp2MJS/LUmO8aNjn8W98+Km2l4g6ITEmCxq6BkLFg69lgVMK693h6BC/U5EPo/RsKj8+ZsK9rzcqt59RI+HXX/yUUoFZ1Sog4OSrkuv1LPLmmOJ+4eUa6qdo5yzhmLSAN7OZ9slUgxrwDFUHobbtZA9/6hFwpeAaYH85d3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Us7mvwMGWY9PqNALaEQD0Q5Q+hzIAdDxvSlctwsmKV4=;
 b=KUMtheK6+MTR7clk0+yxCU5Hnjw4Hd5oTaNjni8m4rjGzXXjN1LUN1ZHUWwfQT9L7p7S/TNwU2sJonFf6Q7d7ZFXsHxWC3Kj4/mc5Dk0YpkqdeTKBhPc2rrgvq3E/Jy5xg9sxeWIxHBqcWilBb8BETbdhjiuh+FvVWXBGmHDYKQ=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6667.namprd04.prod.outlook.com (2603:10b6:5:247::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.16; Thu, 18 Jul 2024 23:22:09 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7784.017; Thu, 18 Jul 2024
 23:22:09 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, Bryan Gurney <bgurney@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "snitzer@kernel.org"
	<snitzer@kernel.org>
Subject: Re: [PATCH blktests] dm/002: repeat dmsetup remove command on failure
 with EBUSY
Thread-Topic: [PATCH blktests] dm/002: repeat dmsetup remove command on
 failure with EBUSY
Thread-Index: AQHa0f3JF69jGThgokq1G+bfO/sP+bHv+mCAgAAiRYCAATywgIAAetkAgAtadAA=
Date: Thu, 18 Jul 2024 23:22:09 +0000
Message-ID: <o5wik4yvo2teffpjlwycbaek6znrtde5kml3hkof5r2w5rxttj@bhokt2ksdcbj>
References: <20240709124441.139769-1-shinichiro.kawasaki@wdc.com>
 <CAHhmqcT6F_b8ZJMbm9jbL0Zg-vv6zq9oxfMttzf1K4GH-zz=NQ@mail.gmail.com>
 <e767864a-7ecf-8459-30d5-daa654b4c0d2@redhat.com>
 <nmildf5tauvp34aeibmzwcxao4ujbwnkkkesollifa4w5uwf2v@qi3pzxidduca>
 <bba377b4-16f8-4a28-9177-bcfec2f75c89@acm.org>
In-Reply-To: <bba377b4-16f8-4a28-9177-bcfec2f75c89@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6667:EE_
x-ms-office365-filtering-correlation-id: 360ffb6d-f964-4409-6ec9-08dca7807245
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Wi4Lj12t4fsf3HE+8FYpNviSJ01CmoOZEGJS8Eyws7Vt+4qaj7dnmkZf9VP1?=
 =?us-ascii?Q?yoyyheNFKP7wf/WItJ4sBYKehG9bmNMQKECnoq0f7nnbxu2UNHlPSt374DvB?=
 =?us-ascii?Q?RU3fOZUzsFtNEBmkdIrzZ4Zy082fQZYV4ipHZuZY/4XZeSYgdzFxRgGM4OFe?=
 =?us-ascii?Q?ENCr4DrP/kCf1Xi+LPpuvouQjSsGM1XnKK2KqLxAIHLtILseMbTLaEvgyZwD?=
 =?us-ascii?Q?UekF/H+pcgV/QZzcJj6LYPPsEIg88hLAQS8sOQfzlM16MOyCWouqcr5GsYJs?=
 =?us-ascii?Q?++YwVwJEb3nr8AIdISrk6KK30AqRiP94Dtw5t2d7NlemdlFrQlEMg2UFArub?=
 =?us-ascii?Q?wi6yo/EMEpK42eARLgEAnJgIfS7dlMvO5rD7dAkwCv1rK6ooxEFU//P5S0QY?=
 =?us-ascii?Q?DFwOeqJEpVMqNmShvMCSroQcMBYsVem83o3mbTexYA3MfeliS4N8pJtrCeQA?=
 =?us-ascii?Q?9Tfm6M9F2Qo9vwozXeURKLVdNXedDWINXo6cGe1k6w9vtVjdT/DkEERBh+BU?=
 =?us-ascii?Q?7E4WuRKN060NkLtbVfsYCxyAVvagFOEILAmJKbEBrk1uvyLn1/NbEO8Urr+x?=
 =?us-ascii?Q?+1mYJ/xr7hb2yitxbBvOTdZRErVx2oVTP3ot7L4PFW90SYaVqfCwLzExAio4?=
 =?us-ascii?Q?7FyMZsSl5Vzy2zUOWp55aAhdzf15PCJFZRE50I+VaGhVV7mPRGceDq6PjWiv?=
 =?us-ascii?Q?XFQ1CKTe8e18uqKpFJZ6HM12YUEFfTe8Gx65JrdM2TuCk+LaJZ8KthC7s/ey?=
 =?us-ascii?Q?2djg0F5rnTlkM4FQcvFxklMXd/v4PRem6vBokCTUliKWtP1sVhO+Q2v/zZVB?=
 =?us-ascii?Q?oBhgmio8Z6QI22X0Fx82rSYxuSnWPierwO0l4wNmkw5GR5B6rsXM427he6Cy?=
 =?us-ascii?Q?LB+MJZScf8vpomGm5U0xLfNQWpHE0EqC4uoTiKZK5f592AUygKCDykx4KtR3?=
 =?us-ascii?Q?4VjckufKK1U6w1Ylw38rOHCFgzjqSH+a7EAWGllZmw+x78nw9kH/+AaR+ntX?=
 =?us-ascii?Q?/M7hnRnghYJQzYSv183ITChhXO5U/+T2B6HHo0s5kDdQZqBaHrfmP3FmjYrj?=
 =?us-ascii?Q?dvnsHINz+rOSn7o806jkJGTSEDKdYmp4aJXuFJ5EJKvZsDgl+Jn3YCSUbi7v?=
 =?us-ascii?Q?Sqe9zY6RGq9DsqrOkQUikxvvs4/G8Pk1mNX9z5mk/VG/aUNb/jaqjPkPF8u+?=
 =?us-ascii?Q?jG2ZXshlzWslXu4ERMrkVQUlqjHc2HHtk3qRIm4M/CLw7BPE7hFx2gyevCzL?=
 =?us-ascii?Q?JHlgxzr8ejNO+d4JYCCnGfgKhVEEpzjAlSxV6+wKz/tuKydPRm+jP6A/z4/V?=
 =?us-ascii?Q?/9/f5Up0WszbBvJbDIqg2ZZYZpVaG9kObjjW4ch2vOlxK3NKRiCqRBExTsT4?=
 =?us-ascii?Q?UkaeTmYI/ToQEyrhthJDYfiwY68LL/HaAPUrLtTg716EQqBUAA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zJDZq5S6qpMLaZrfjCIH93m8ooTCzdUBrv68AratDFKyIvqd106vQz4M3CcY?=
 =?us-ascii?Q?PgImKcIhYS6jfQLxPZwZjJlUomypbnpjnKZ5PrhIs/TKkyykrbGQu54fubVK?=
 =?us-ascii?Q?SQlPmjqdZnVVtsMpLp/LTzhr/oQEQe5/U1CvSOgBGwooeQewh3MFaO3nEHwk?=
 =?us-ascii?Q?+sJSGOIDsD2iPU7OxiDh00kPXTdKgQeS7zXgwRkTWXfPSth9Pqa6PuAeNWVU?=
 =?us-ascii?Q?on9ab3xGkQ9dRh2SzzlV9Pg6WvLHfvO3dFqjJQrlLgJXpug01qbs+M+UzVN0?=
 =?us-ascii?Q?RiTfib6zcceDIEXqtzOYRPF6l2SVgKjHllTEj+v0Tp3LCXJw7zfmeJEF0z9u?=
 =?us-ascii?Q?AifgLBdnVy4eZjMIGLk8VGcQjXLmY51eavQuByIPokW0tZqWw7KkxdsCoWBa?=
 =?us-ascii?Q?N1FAO8pEn0cmwar4HoRKGzGct8vjJP3Do0pMv+HPFwjv9ln/AOB/WbK7qYs4?=
 =?us-ascii?Q?kQYb5TtNpqN4LsAY+atX48IVX5VFBWtZJX/IdhrP0ySvNk2rFh2PiKywjsBh?=
 =?us-ascii?Q?RlRUdrmUrca6qAd1Xed8Pe3CJrgEy9cDAVgwBNnqhJtqDFQD1XJ9N9m+aS75?=
 =?us-ascii?Q?Wl6+j+94EDUz4CJhAlmxQLiNpEWL+5BOA+RDxkZ7wQBj/gGmrg1V9BCLIRu2?=
 =?us-ascii?Q?DWNKGfGoqiAj93N3lN+02AeYEkcsH36dC4Mpj9bG+V1NF9698pyvvmWIfvXk?=
 =?us-ascii?Q?tDxKamn1yOlQkRtfIAk5SoqioPcnrRi+35klPXJWY1pkCouXooF++8RS6SEA?=
 =?us-ascii?Q?Y5msKlSxHBDIXqmK47CWgtdoiHMtTLFc3qthjCo0Q98uCx2Hno4SpqLb+TsY?=
 =?us-ascii?Q?nCdSioA69+rIzJeBpplIlErdPyC2fgQ/kr8pq1oIFPTnC/3+F87Cr+S+kHCw?=
 =?us-ascii?Q?BohLAictLcqeCc6gqqISK46B5Ny5aa+Rw0qyHmvO5LsyfqQ+oHQRd43YdruJ?=
 =?us-ascii?Q?TLkr7vmaNje2pRH/4f1JIdhNAjwCqOmIv60U0dPcfTUM65QKfdd7x34vst5c?=
 =?us-ascii?Q?aEgJ/70pAvvMSkl7eYx4aqxt4tMNtya8L5m6pqkQeLU6jT8uA11usYHU/91y?=
 =?us-ascii?Q?gHYG/zHjCNC5J0TF4KxRZpMP8X1/ipEY432K+KnRoeg40LKxiIangqHxWM9D?=
 =?us-ascii?Q?om3RLK1nkeXygDWKlxmsb0KZdBpJJy+998L6V6Lc/aFMAWd1PguGmzo20Cer?=
 =?us-ascii?Q?xaKCHKNRQhq9qLERU40eCvG3KaWxiqskPE0RAthcMv/AvPwqSoG8J/y03GkE?=
 =?us-ascii?Q?ew4SLsCEbZw/fBpo21c4JUaZ2rdCVTVsYtOm5UX9K0O+7t+Z1Oj+hphjCFXD?=
 =?us-ascii?Q?UhUa5CF2opbTdt5v1qnbdItETByK1q8nfxOOTeWu4eUA9eXu8E0bxcXn47qB?=
 =?us-ascii?Q?4nwGsu28tzrKI+oXNYeTTfepB/8qxUG5Skfs2FFJLvROJ2cPefzTGAMqdqSB?=
 =?us-ascii?Q?sM8cuJIHO1njYrMvkL1KfM4Ltz32tO/Sbs9m12o3myCeSSv3v7CCYpfItHMy?=
 =?us-ascii?Q?nwah6EDNLzwh2JIjfBbCaccFMTgtAUQYt58M02bIEKiHGp+HyQpxyAGUqWkb?=
 =?us-ascii?Q?pjekb50A0dezPwkTO+eGsOQE+n9Iyvv0YwFv5QMHV5skB4OvdrDVWUmA/C6a?=
 =?us-ascii?Q?VjdHDK1o5OzlCy0dTUFomjk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6580A0C1719E045BEDAE028015ADBC8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j/QEZhgt8rSNqJQ/ZOFZebGjyNL2N4A644nkBnRxSubZpE/wFcf96uKFtnfl0FvAR0DJqKe+qUj7eP5ACMb1YTzZ4GWzWOuIZdqTmCWTRQFhkAznLhaIHXdVrWIy8N00zYL/JhgXzPKBsVF+tARQ+0sUmtokZfWKfCe9aBs+G5XVEowpRnNYegtdPzE7hcYMAoszPhiGtD7uuDEvXOkOS44cxCXB+tISzqFaf2M32qHxyQpfuHCYiYPiWB0JkQMB/QkFI9nwq36et2VnQNKJpkesrEHLFEByTIzVfjF4XBd0xlo6hmhwRXAcIoVchIGOjR9JiI9vedNjxS8pez/1n9fwSVPO72NM6qXvHMF6D90wDXsA3umrCRjOX6Je7HVQLtAarQFk+/JIFiGaIDuYlgucjlS5/9HEbsStugpAu+6wZooyL9Ku6EbQ+tH9nXpOPEiCnZ27FapvrAuaeJak8U2QiPgtT3G41HrOiq9n2Mbvf/2uP4duswL3+jedAEgqvtDfOvKX616ojacPWlIAMF1FB+Ktfs0/xoMcupduKuEi8P1tALYzA9gMBvNqQeqwnfiQrLAutP++4cZbTUu/sxCUUJWY8YbRlCFqVS0EN9CJ91OOOvypbjpu+IVMvTN3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360ffb6d-f964-4409-6ec9-08dca7807245
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 23:22:09.4174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8588irJgBeNYRJGcRjb6ZDBPZgPfAX2ZH97kkUlIun8fCqKRYXIyIPc/K9E/A5xw7QIxJ1SQMX6fLBL+0ASkS309dZI3dNUTjMSRiiu7pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6667

On Jul 11, 2024 / 10:59, Bart Van Assche wrote:
> On 7/11/24 3:39 AM, Shinichiro Kawasaki wrote:
> > It showed "Comm: (udev-worker)" is the process which keeps the DM
> > device open. [ ... ] Just adding "udevadm settle" before "dmsetup
> > remove" will avoid the failure.
>=20
> I'm OK with either the retry loop from the patch at the start of this
> email thread or adding "udevadm settle"

Thanks Bart. I think "udevadm settle" is the better. Will post v2.=
