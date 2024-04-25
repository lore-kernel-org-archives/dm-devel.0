Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C8D22EE9
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714043667; cv=fail; b=EgoVMNtbHPd0YeYbGeY+3Af+ipyZdQ+pZ8aCg7D7k2c2jXT9mTcO6gVaohGmvmLyWsys8ZVUc5LjzQLx0IZtA3K56Fj87ioEIrB2wyFTOfkGxcleYbzbTQ7AVXOGamCuZFpzwPbRlne1orHWYrHx0QtKcBk8GAcYZA89keo5jz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714043667; c=relaxed/simple;
	bh=M/hozrzqh19Yo2URC9XkpymXMTp/2AUe1RD89aQ5mvc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ilw4xtbk6aLQZtHWX0zQuH9bdxkBE8ze3uLy3GqPaiM/x2KeiS/YCu3DhxfXbWgw9Tqd7lqZTgIFyvEz6jXUkd78VDhH5X3Og/C1whePLLrewgrA9DBQgZxGuL3hdGEVCcSxRfw8vD5CKJF7kUGmu2uiJzjJyWxrthXUmDOzGbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=o8E22Iis; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=iPRGMq56; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o8E22Iis";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iPRGMq56"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1714043665; x=1745579665;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M/hozrzqh19Yo2URC9XkpymXMTp/2AUe1RD89aQ5mvc=;
  b=o8E22IisqGUvf9GA5ug3/rqHcvlqiUJxCD6ClyhkVQEP6Fbi+/62WNzU
   u3+cpmvWzyAayiWdxaq44uvVAmrbQtlrTzTqVjYz+VWWfMhqMFjjhAgW/
   Sjt6Cd6ncDWRGWR5uiIcutDYMcm9u9FPAk4Befs3+cs1NKphcsa1bKMgR
   aFoJ4SyWzmuSO0P/PvCqpkgeAzbc2H7/NxJJCoQbPM9UDFdNXzA+1ZvAg
   EtqqEEH5VDzE6xsP4GlMNaJUp5mbqBKoIHT/7d0SYCTzkotcO6FT2qEZq
   h9tw4EqkVLwF7F5A/wPaRxDO1C+z8vW4qwuAQzS1Fx+40VVvmO3bNc2vL
   g==;
X-CSE-ConnectionGUID: aJjl83S0SNiCyRn9KZE5tA==
X-CSE-MsgGUID: sHO1lx40QtqciSfhZ2SsWg==
X-IronPort-AV: E=Sophos;i="6.07,229,1708358400"; 
   d="scan'208";a="15575717"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2024 19:14:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijvFuEL7J7+qkkL/1nzi9aHdojj270wULbOTR1A8JIyJQp+zAEVUxSZAj//XzmH/PMDpO6FJV5ly0zsvmlIgS5+wJ1nUKmkQoDJzzXCg3SEOSjbHiktAgzhso1wn2UMxnFt1TgdSRFCm8XA2bAmJqJ1W9+yjJ9imxBvWgweGCBW9yuPzV37JziX2WLkDSZaPmJfFocrOE7aSqEWpxWkKE0IkE4oYg9HnfM8YeNSMRpvyBguyToffpJNgOwYKcZ7ZUuAi0nC/1443bczuLBsG/crySanI6+400+TNWruDRVLjKV6rj/jto9epVZZX+vCTXchxMutrL/bSMz99DHXSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngXNRdjLpVw/qEaTnMDGG5xEM8JiFNrBbN060rI4Jro=;
 b=UUnsaTrrSGplZJQZWUGm+8ZCczff0vljC1EIN1MYPMOWOPWiAQ78dKsCPY8xQOO2mVpl/LPK+ruBl1oJkZev9He0s9EEut01r0C9oYsvL3eirD246H6vtPdvPnP1ank4OSbVF6HE8geG+E0uRMNL3BOSi51y7zQcLMb6yXLBxyxVVpGN8RHB/ksntNpABZkphGMjYZ0sPWwemWN2c4pAWqcZ++hSFsYnK5Q3SB0X35qrUDzD0rFeYu6Z886aXYhgRjlUuErEKdT50Q7Xvvx5wmFNuNTs3cdkuaKiKMncQKhrqwZonFWrknCd4CXaWrJz1Khq9GQJxEJKeNsBkEqw0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngXNRdjLpVw/qEaTnMDGG5xEM8JiFNrBbN060rI4Jro=;
 b=iPRGMq56fPWdehY/1zzGtkeRm0gKBqdPgwHHQeQwMGs25PaWFO3rWiRUFJP1IbCtcIoiSQQORJqCgIcyXKtlakWs9xILrdJTA2xdjN18UbzmshIXAjrywgOawjHMq2cQETtB9pWzhRN//t+/iUnFa589GzIBRkOij7pL8VzXu4c=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB7896.namprd04.prod.outlook.com (2603:10b6:8:3f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.46; Thu, 25 Apr 2024 11:14:17 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f%3]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 11:14:17 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Tejun Heo <tj@kernel.org>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Thread-Topic: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Thread-Index:
 AQHaiyN3MAt3ravZkEmOdAHOryyyUbFhySCAgAC00gCAAmiQAIADu1wAgAx2dgCAAQiqAIAAh7EAgAAyEgCAAhJjAA==
Date: Thu, 25 Apr 2024 11:14:17 +0000
Message-ID: <z2xd4nr42remngtlea7zpkt6vwkh5onsltvo2zsngbhp6374mw@ofw4w2mwtxce>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
 <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
 <ZhlugLZbFk8xUbJ8@slm.duckdns.org>
 <nl3ys53xadoca2qht2r5ikjh2vrxyrlwvs7n5nbitzxuxx4maa@daejezc4mr6z>
 <ZicERHDW2w02sJQA@slm.duckdns.org> <ZifiSILH9MlSDjxw@slm.duckdns.org>
 <isfz6pnm2l6aizihmdrksktlcpkkbnkmxgc55ar4akkrmggecc@lxu4tko3ht5k>
 <Zih-HANo8RV6L-4Y@slm.duckdns.org>
In-Reply-To: <Zih-HANo8RV6L-4Y@slm.duckdns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM8PR04MB7896:EE_
x-ms-office365-filtering-correlation-id: 0e6519e3-80c4-482d-14eb-08dc6518d8f8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?YbZeoYS11cnnn9WFbZBmHSfr8fKmazAyGLJFAb/qh9UuT2XPh2MDf09mazzC?=
 =?us-ascii?Q?YG6Q44HdYo58VOEjrnQueEQ4BohoKkmA7bv6Gmy9ujV5s2qKIH0tmONEENC1?=
 =?us-ascii?Q?E/qi3YR0ffTTZ05haTtfFWmuEVaxRPdMoIMHWFLuPAg7dytFfT/zPptDxggO?=
 =?us-ascii?Q?QcvAT0OsRxBatdE8DIRIY1yg60dmMwZkqn4AozX5Sn+PK0RzxyEa1aWo6mj4?=
 =?us-ascii?Q?WsQ0uaclSiXC0/bU4T2Pjs7Pqn/XjeYcuH9mpOhEkF1MPqZZK3E8RPHkarO+?=
 =?us-ascii?Q?peT/0HmrsXnrZwZwpP/RQfYwjSDUyJH1X0kdH1AbVtmM8za0HQ9TwLTT807j?=
 =?us-ascii?Q?j+GRNHYUpc6zvjTKID4LnU+TweVkP9kGgrF++m3f8S6bbNovbBBFWrVTdWoP?=
 =?us-ascii?Q?EWLEm6C2P8EenjEN8Jy9Q/QQ8k2ETwX/r2YI1muiNvsaAdZYWTkw4SI6NudU?=
 =?us-ascii?Q?Xg1Sns5ksGihu/+1RMk5ApAwp3szMfRPlTe9LD2mLvvfxubzEIt7aF+3GqnD?=
 =?us-ascii?Q?tJqOJvo8sG1tWwngS84eFf3JJTkXBpKVGdB3et+Sdqf1rU+eJvA9xMKQ2WWe?=
 =?us-ascii?Q?0lLH4IFdpI7jAL/zvscTWGMR/jYmOwGJlqTatAUXZmEX7no6DYSM9UM/0wUi?=
 =?us-ascii?Q?ZHfN035TFv2kyqdg7tuxFlnHSehh8/IxbkxMe6WDb+wMAeEpjv8POf/xkPcI?=
 =?us-ascii?Q?eXSF+AV1StxSVaE3SEjMeIrycgnD2u6WVdyFySZFdF9FPSbM6zsAzTlfKYSc?=
 =?us-ascii?Q?JwK1DzUwhDNV3uf9tuqWcCCWQ3qEA3MbckbDO3T6pzrOL7m8Mt9aRZ6b71Mp?=
 =?us-ascii?Q?24nyuZfBDiMu9CZ2VveGH6ZJrYH6v8TC2RZqpiaUIoteDmeuAsP9Cm/Gck8R?=
 =?us-ascii?Q?nuYZJOBZHuWq3rd3fDrZmZ5DuQ8higRAfA6Lob1RApTASskqGoN6k6RhK8Tg?=
 =?us-ascii?Q?kY4LnbZibiYN+eMgldE5TF5bw5e7suC6LZu1GN9IrDKZFD4rJGzhjQ0G3Wp+?=
 =?us-ascii?Q?JPNPP1pvNPTzW7T68AVTyJn8xWl6af+aFX/zcXVhJwgaLS9KpmqzIo8ObVqk?=
 =?us-ascii?Q?AGN7cdmwIvt7ARn1v4ZpZmfgi7D8Ve2Wcq5NGokjiHkmJPpSv7fdPeY8z5zs?=
 =?us-ascii?Q?QOnuxXCKb/Mqsa843Y77wK6UErRLTHotMs1gtF8GC4ZQLNkkCCCmMTs9WqNo?=
 =?us-ascii?Q?i2mtM1zdrUjzeY5857PgJPcOw1gBcJi9FrtcQ66FtMLZG/Ch8J8DcGUhiqQf?=
 =?us-ascii?Q?hSsmH/6wVMFR9MIul+S1E7O8i1y82MQ6DnxJ4jlqjHzrlCojfETO47JDBLoK?=
 =?us-ascii?Q?fBZ2JT/2NPRLgsqR0+cIT0VOSf/Dk3/E9l+3FdBPJPUtIA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Pg5777pia1ALNqVi/Ur7Ll9fmoES6gj78Dcmy1IGepfu3DQmzt1l9Z0IqubJ?=
 =?us-ascii?Q?L428AqLRtLfVnwBReVMyx9uf0GuBL7CMr2+7GdP9mZi5S2Sx/Pc4hcP/1Y/6?=
 =?us-ascii?Q?wcBPagUvjUfgcZe9Osz+5GjeFCmK2KOq3MtRSkkk9ZjflFXyQASYLq2PZOr0?=
 =?us-ascii?Q?sD7LdlTsMIoXGrx3pLDC4M2MhJ1AkbEuz/uL5D6KCuQ/2pHaJXs7Sc196ScW?=
 =?us-ascii?Q?SLmU4jKzRRWd2LoI7shpFTqbTo7Iaxq6+IT+kIaYhnSqQw95M3SqaqB5yuNI?=
 =?us-ascii?Q?H9/DXFE/a6gKQFP/RC0ndYwY5QvKCPUECnOlchw72m5SZ99zWTDRrI+RezsO?=
 =?us-ascii?Q?rDnQm+DS5YAiZeHdJQnQEECjhf3rAzyqIhlhGJdYaUHCZD9ac4K+dCGoALsF?=
 =?us-ascii?Q?TdLf5beMy1qwv05jEDk/qIztUyNWbx/jANGNH7sSH8hRSG3CLli+c8/KVSB/?=
 =?us-ascii?Q?M434jYAyf807OlzLEBi20Sc7NcESu0J+0IGtLErr7EigYEFJ8T4qmCV8quG+?=
 =?us-ascii?Q?B2ZV7mwwB2CcUmbszHmLYzLxsyMWwT5u9qzvLZwKx+QHUFJ2I2W6PQ5/P2Tv?=
 =?us-ascii?Q?BMo7iTrUU7Ka3MPnoVJ7rQteykUf5xE3i+Mz2Lhj+OiWJAsv8W52MnR74Jrl?=
 =?us-ascii?Q?RXVwuUDsCt6UxbTZf6Kga7aROK9JomZSrJYE94dNQiRmJ4bApqr0sBwj0JCw?=
 =?us-ascii?Q?rbJdMrn/Az8XIUPClT0Epvzoalp3Ufk0vZteIbbTYUHpfUmjD1jnoenmfw0F?=
 =?us-ascii?Q?J17q4Ka6i27HhSuYV0SuYN+id3pSAaOba8vwwUnEcR5hJHxj5U7KQEqV79SP?=
 =?us-ascii?Q?ZMWVC2qQKPyTZHAQ8BcF69d7GAOYJjGn+Em7uuCF0ZW1xOJZfdum+QlNIgp/?=
 =?us-ascii?Q?AOGcZrovvD/n1qTCeKwB57pgDpzBKqYhWoQqdVpCqaDlNF0DmiVUaTFJWkwh?=
 =?us-ascii?Q?8r7+9AISGfddDKvxRrehq5QJj6snmxvWIBu4EDBT402VQU7EXGcfw+9BGwbG?=
 =?us-ascii?Q?PctxToZlCPO1geNLztwG9Mp3mhGsAntewxCdA6ylZyE6aMRfrHadK6raxy8W?=
 =?us-ascii?Q?qaa9gKbyK/lB5ZXU8btdDg6JWyd+utlAG0nHgI5m6t8CRE/vdXWUGrRQcrLB?=
 =?us-ascii?Q?BshRLDDDiuIjFa1bd+Jh2S0zCMYBHRyu4KvMb1cSLIN740PQ1kNVJ0d5akHR?=
 =?us-ascii?Q?ilzGUFE5HSNX+49CtI0WebfjEVI4bmkl9tbk90CjvOGMZTOKDixTC3RMNK2C?=
 =?us-ascii?Q?TF8S9Ed1J6jd9heNfLpYjE9cZDwSYdbtyrymj/XdltDCtxNC9FHA+aIswsN8?=
 =?us-ascii?Q?KTNuDfEfRAKvivaTGRt+ApZYtyDdOh6UZmKftpyukl02mzuOywTrRRKxveJb?=
 =?us-ascii?Q?kKEi0dzXCkCRhRPOaUp4kmrfxLbnZjlLRNgA8vRHaZg59XF9A8PP8fVsv9x7?=
 =?us-ascii?Q?skmmq7Kp/cBnSytwjvE7O2+FA6TuT98QVqBBeCsfc3FuH7T18lQtPrLGbLhX?=
 =?us-ascii?Q?U+dt20RSZ4hrKgIjzaWSyWsVmD2XfvDFXTZm+WxQmuo02xQs0TwIuIqtbHab?=
 =?us-ascii?Q?FiX/JYL6TiIhhUEVWm7fDwwSChDAIdIseMTjr0Lw5l3+Jr9rmbIdW8QWCO8q?=
 =?us-ascii?Q?80i/PRvNsAKeP2nGAu6twdI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9EF9EF8419C5564586488F1220DAC7E1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E8fZBKhXGgLxNJhyXoBuy1jT5fKms4EXWfF2QeV9LGXAGVVQZq7giyl5sLrG1Pn+xwf60cVra5B+G9Ssq6d7SqROOg7ZMuoOCcEVR8QQQyKcXGEoaeqOwbZji+8D4wSOBVNh52pteQsffQJhVNqFrOaQfgdFq8Le3mbNivC+mCT/oWtjl7HQENjACZVeWxLdhlcHZh7GXK1zgL3AKa/IjYK993W1Z+Ci62QlSbbDj1+0RVIwjqkMWg7tc3Yxjs9MdugAHW/gu/vRvaB5rOvcyralZxw9QNwcPScTbXTdG+Fh0+751mdYI8YRYFpOrxdnLPMs+kZ66267gS7frnkU+dvrLCgOhZ6xz56ceP8vGAKSEbW9As9v92IHiV7pYNX2vhxKHMZ4SAPWuO/kfeRFJimkwvBGXfsBJItrDE7QRCYI7YFemrryNv6M9bjSsYKwQ4qyndjtIHxCn+Ki+csICD2WM975JUFmbh0xukMnmazhqepkpzEHjzvd/gyU6MZbjgzoput3NmeiQrjPSQCmYhG0G8mBJTHcqZEqBqg2I2Oe8n2icMvikEIVCktIn0vv4IXJRddQAh77oz/bZPXNB4Cmb3PiWqF5lpbhb3SLbiukaDBPNHdVYMudLYTM4s1/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6519e3-80c4-482d-14eb-08dc6518d8f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 11:14:17.3442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KFxdz4hb8/RgemmVzOVCq0wlLxgXA+HrQQxFImXV32WcDISrfPSS+OpoX30q7Bje6/lblwpKu5vPQIdmaShyvS/K76fija280phREioyhdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7896

On Apr 23, 2024 / 17:35, Tejun Heo wrote:
> Hello,
>=20
> On Wed, Apr 24, 2024 at 12:36:45AM +0000, Shinichiro Kawasaki wrote:
> > Hello Tejun, thanks for the fix. I confirmed that the number of in-flig=
ht works
> > become larger than 8 during the unmount operation.
> >=20
> >                             total  infl  CPUtime CPUitsv CMW/RPR  mayda=
y rescued
> > dmz_cwq_dmz_dml_072           613    33      4.6       -       0       =
0       0
> >=20
> >                             total  infl  CPUtime CPUitsv CMW/RPR  mayda=
y rescued
> > dmz_cwq_dmz_dml_072           617    33      4.7       -       0       =
0       0
> >=20
> >                             total  infl  CPUtime CPUitsv CMW/RPR  mayda=
y rescued
> > dmz_cwq_dmz_dml_072           619    33      4.8       -       0       =
0       0
> >=20
> >=20
> > Also I measured xfs unmount time of 10 times. Its avarage is as follows=
.
> >=20
> >  Kernel               | Unmount time
> > ----------------------+--------------
> >  v6.8                 |   29m  3s
> >  v6.9-rc2             |   34m 17s
> >  v6.9-rc2 + Tejun fix |   30m 55s
> >=20
> > We can see that the fix reduced the unmount time, which is great! Still=
 there is
> > a gap from v6.8 kernel. I think this gap can be a left work, and hope t=
he fix
> > patch to be upstreamed.
>=20
> So, v6.8 was buggy in that it allowed a lot higher concurrency than
> requested. If higher concurrency is desirable, you can just set @max_acti=
ve
> to a higher number. Currently, the absolute maximum is 512 (WQ_MAX_ACTIVE=
)
> but that number was picked arbitrarily probably more than a decade ago, s=
o
> if you find higher concurrency useful, we can definitely push up that
> number.

Thanks for the explanation. Now I see why the gap exists between v6.8 kerne=
l
and v6.9-rc2 kernel + fix. To confirm it, I tried @max_active =3D WQ_MAX_AC=
TIVE on
top of the fix, and got the xfs unmount time (10 times average).

 Kernel                                          | Unmount time
-------------------------------------------------+--------------
v6.9-rc2 + Tejun fix + @max_active WQ_MAX_ACTIVE |   29m 27s

It looks comparable with v6.8 kernel :)

At this point, I think the default @max_active is enough. If anyone request=
s
better dm-zoned performance, I will revisit the improvement opportunity by =
the
larger @max_active.
