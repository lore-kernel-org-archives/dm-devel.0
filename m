Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3318115DBB5
	for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716809676; cv=fail; b=fLn/fx2KpT2R+gxl/E8YU5/iGNAqeReyM/eq8nN6QYRmETQ7ubH9FI5C8xqf9Jk0RD8rx+wfDnZHC9QqvKgHsLUzQy7Bw3M13syJbVb1txkwO5yICqTRtE6dqSFHR92FubGkrNvSgWm/naw9FS5xor17RQEwE2nNQy389Pyqn3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716809676; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A6cOyx9txwiwALSWIWr6NPuyAaotr7znmxeeTCIWPujYPb1SLLUDfrjkH7amol82BoY1UvNGrz3ubUGL0mQIpr0Bq547xX76+ijKPbGpNrj3pMhTYSTkeRO9KE60MIeqeSsmferUfxg0AxdK9M5e65GI+ybZ6GQYbNXYTkR6f90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oSVWsxgX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rsc5IhwQ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oSVWsxgX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rsc5IhwQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716809671; x=1748345671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=oSVWsxgX+4ikn7DVZiud8p0c8D0yqlQF+YnVzve8i82AtjqYdNZE+qv+
   gR7dzuYxaJJpDwK/owb4hQ5h2xkJPSr4H6FNfs2cwQGf4VWGR3cnNrSAO
   WLENHh8smJ+jgY+8AMwl/73Ct076S1wPhBqGYIj5gMrYftvjMDXiX4+B5
   Anj+r8CMgGUZ6kjTLTg5qCSiq4HXt8fL1zSEpR/AVgy+yX+EPqNlnVlPu
   a9tt4Bzin7pPdUJy2nUYuFh2FIjAXtFwsygwtAYyJQM8iws7IZXWXAtzr
   t1StGsj0rHmsT8fuAYgQtZ8PmQqiAzpfCPyvDD1trpjPLFYBA2+cQs94U
   Q==;
X-CSE-ConnectionGUID: Gasdhk+eSxerWsQUf54jQA==
X-CSE-MsgGUID: y+M08ylyRYOeh8/ERtkC0g==
X-IronPort-AV: E=Sophos;i="6.08,192,1712592000"; 
   d="scan'208";a="18190284"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2024 19:34:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4iYoWSbwf4kKiWEEf+191oe3AFY+Pb8MK1IPLOGzIsO+Yuk4Pei6boBf2ri7tMVQbX1c6h4NkYmCAqn1LUhjmAAEJegMFabuLqONIpvEQSzoMw9TUUG9TL7nNlIxFIZnTq2A8OLvUnWckq7rRwYi61jt7+FaUgNrAEeZB6VRectjPnJQqPGdErRxFUjCd8PNaBcmKmKrKAKHGrlxPsd/7YTasQ+Fenaj24Lh47ccuroYwYlpeQ7SbzsRs7NsucODCnXnTEx4TCE9acy31K6PCkfkSzTbogYO3V5amznfz2DpboH3a+nJDuKcBulUhYHxoeUuF93mN5e+RnGlWAyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=Menq4xQJQoVldOVf/SbrwL5p5zLNgndmUz9mos0q71HxbIhb6ZPve/zktacnSGBcOHLZdY5t/nTBLZm8IGXsDNqg7YyNIHCYpTF/U70CE6FFL+hh2/MC1O+A3/I5olDo95WgOQrjaZOEeJsnFCun8qSo3pl6E1+k1GuRf+Nir7tq/Tg98hgqfRxrUELYrxGK68kYNLV0meCaq5DasavH1QreApsnnWftMK6HVmO/hQWo0iJSBJeDI+kNrCWpJ2WC2Mt4/qPZFHrxTF8jkQleZktnpIn+DIYnLf7Psl+uEX4xo05OgpRX6X9QBM6OpxDOdSS4PkPeWBE8Cmv4vcblig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=rsc5IhwQ0aizJzTKe6Eqc31P8tRf9nUkE3Gz7aNiebaNDygpKNiYpnAR9zYx24HKNys73IxEjiKqS8YCh9utBoju3sFd2e/l9fS2NsHpd5ExzvX/494VfSq/2tC7jAJyrlMAhejhOrBKe7t5/KzwFIrznQW0l2EgvJ1fsMsrSdI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7884.namprd04.prod.outlook.com (2603:10b6:510:eb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 11:34:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 11:34:29 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Damien Le Moal <dlemoal@kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Subject: Re: [PATCH 2/3] dm: remove dm_check_zoned
Thread-Topic: [PATCH 2/3] dm: remove dm_check_zoned
Thread-Index: AQHasAyV+N1R8KlASk2hub7bt1qNmrGq85KA
Date: Mon, 27 May 2024 11:34:29 +0000
Message-ID: <5ac82d65-7e39-41f3-9fa7-8d115bfa0824@wdc.com>
References: <20240527080435.1029612-1-hch@lst.de>
 <20240527080435.1029612-3-hch@lst.de>
In-Reply-To: <20240527080435.1029612-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB7884:EE_
x-ms-office365-filtering-correlation-id: 7ddfc991-0749-419a-904e-08dc7e40f89f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?bllmKzlWaUt5TGh3V3Jsc2hvV3I3UGV4SXM2bjVpVlRNdTlZOERGMENqYUdZ?=
 =?utf-8?B?ZWhHUS9oVFZpQVlSVzhEaUtJanBXc295OXpaRkRxN2J6UEpDa2h2aStOT1lG?=
 =?utf-8?B?MG9ENEhNNGM3VGhkb09MdHNiZGZlQmp5WlVKQ3YrMUpFZlZCbUdlZTBQaVdJ?=
 =?utf-8?B?VXZleE5jeXR3eWNJRENXY0tkU0w0cDBOSWx5TEpWM3piaEhiSHhyalo0Yml3?=
 =?utf-8?B?YzFIb2MwcDBlbHJ4aW5ZbFZveHBYdFNRdDg3VmlWdjNtRkVPdkRpZWUyUFhv?=
 =?utf-8?B?N25XbWFEaGtNcTYxZEVRR29hQWE4aEF6YTc2alY2OWVBZGVQbEU3aW9RaFNz?=
 =?utf-8?B?L1A4bWZrSW9wVHdzV0lZclloMG8xV2lqUnNPM2lqZEZjMUxHYS93aklvV1Zh?=
 =?utf-8?B?dTllNzc2NHRJejJoNXRVZzEvRGpoRmM2MnV4OVZGb082UWIzdE1wTUljL0NJ?=
 =?utf-8?B?NWR3dy9oeVR6SUFhVGJCRHdPZUxpYXVuZzJqcXlyeVROMWkrMDBJNDU3ZVBj?=
 =?utf-8?B?cm1JR2RXSHZQT01veFdhdEtoVzNLOEkxeGt4UUxlSWw4OS9rbCt5OXIvdUJF?=
 =?utf-8?B?UWFNUFIxTjdxb1NNQlNWemZQRzB4WUpaRmJnNE9SKzBNUVc2QVk4S3Rpbmd3?=
 =?utf-8?B?WmJYWm51Q2ZNcm5oSWRNbjFqM0FtS1crU2F5NXlRRTM0djIveGoyRWRWRUts?=
 =?utf-8?B?SXVkNDRmRXJrRGJGL21ocDdnZGEydEhjYlkzcVRiQU5JU010STljRy9KRGJU?=
 =?utf-8?B?QlpaczdPdHIyRGxUZStSUGhQYU9ncjNsY1kyT2dLNjVncEVtMFdrdWYzOHJO?=
 =?utf-8?B?Q00rb2VXRldnZ2NEWkJJY1VaeGxZK29RU3dXUUtNMC9wY1ZFYkRqSDRQYmlZ?=
 =?utf-8?B?eWtkMmJtaExhSHRsWStNaEE1NlJNanpNUzNsT0dwbzRWOTdUZlZvMGRYdHM5?=
 =?utf-8?B?NkZEeUJYQ1pVbWNvMlMvM0VVOHlVZzY5UGo0ZlJqQ2I5V3BnMW1ob2lHRTVs?=
 =?utf-8?B?SlYxanZIZGh3NGl5YzJTemtJY3liazRXajBTTmpEUnJxTEFFVkhud1JmNWRP?=
 =?utf-8?B?c05xb3d1ZE8rMXFSK1V6RzNMSnZiaVk0SVdUVnhzL2JaQXFFZVVXSm1pb3Uw?=
 =?utf-8?B?TTdkK0IyU1NhaVVrVGNldUpDbzZtcUZHT1NiTzlEMVFhYlBVemlBNjhKZXc0?=
 =?utf-8?B?YUhMOG5xWVBNZFhSaDFBdEtnRWk5VXo1a0ZwYS9CRzl4eUk1NWVsaUdIelJx?=
 =?utf-8?B?aXlSSXZEYU5DM0Q3cGRpeCszNEUzaG1xZkJFL3hrU2ErVmRoN1hWSDl5b0xU?=
 =?utf-8?B?ay9wZDJZN2VMMlhsRS8xN1lXNWFBUWR3TEVUQXdDck1FaVN0eUI0QmZXcGJE?=
 =?utf-8?B?WVd0Y1lZSEdIelJmbk5RdmtNamlIOS8vY2tOc0xXOGZabnNWb3p1VkdDc29m?=
 =?utf-8?B?bkFsVDZ1QzQ3djJzRnNnM3JMRCttYndLdEo2S3h4Nzhxb0kyL0xaL05YUHdG?=
 =?utf-8?B?OVcrdzZIV0lmSFc0RW9OekphTlpwcXFDY21vVHF4OUhKTmcxbUZadmRFbjNn?=
 =?utf-8?B?YklzRHc3UEhXUkdmOVd4cnN1TVBWM1Z3UTFOaEw0ZlpYWlErUkt2a0szTWJo?=
 =?utf-8?B?QldPT2RrejFtQ0lTZS91blk4czBRUVZaQW9qcjBoeWhRTnptZ1ZsMTBWbkVY?=
 =?utf-8?B?azBacXRtc3JuREI1ZnptWlNsR3Z6VnNKcEZ6MXhENSsyZjhYMlRhUVpyNllJ?=
 =?utf-8?B?RlpkK3JnTHJLdkduT1NnelV2eVNRTllSaDVYNmVXZk9rSWlrRDJJRjZQOWVV?=
 =?utf-8?B?bzBDVmhFVDRhSzF3N3dwQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OUU3QzJPY011UXlNMFJTQWNmN0crQytvMm9rUWIya1hkNUc4amxSOXR3QmZE?=
 =?utf-8?B?cnVJd1RpYVhMR09LMkZoRVorL2dPdVJYNlZ5S1Jqayt5RnRUSzZDZGNVU1Bs?=
 =?utf-8?B?bE9sV3Q3ZDYxUkwxMDZmWlB5TnZicGp6NjVNczRSbHgyZldLWFdtWGswdnli?=
 =?utf-8?B?WlhLSkdzM1ZCODdHc1UwSUJLd3hCdlc3aFVIa1IwOVBadWdUdEFkenR1WGZY?=
 =?utf-8?B?d3oyY3pEb096L3pvWU90YzZURlZOVkk1djBvMDhLZUdBeHg0YnB4c0pLMld0?=
 =?utf-8?B?WGUvdVArdStEc3NvWHVvTXNqOVNldjRRK1RzeWpvZlBVMWRKVHA2MmZvYnBL?=
 =?utf-8?B?Ujdoc2N0djFvVXVUSEVrZEtCOEN6SHBwbTZ1b0FqZEw3WEczcG5ZcmhaNk9y?=
 =?utf-8?B?UEhMVWFoT3BPWkpaVDdxeGdLNEpDT3B4UThheWFkMGxZVHZ2aitocm5UTnBR?=
 =?utf-8?B?V0drcTZnQ2pSUFJXQ3lJNGx4MmZiSzNKZms1eFdiZ1VQNUhVOC9uZmZ1Q0hu?=
 =?utf-8?B?UjlUcWt6b3EwT1FQR2pXUE0zaFlvZlZmdDdYOVROdEZIcWpJbEVNdFVzTTNV?=
 =?utf-8?B?TzFFRXJSYm56UDdRQkQ3VHBlR3poWkhvQkZTRVBGVWcwYmZTUFhCdWxhRGpB?=
 =?utf-8?B?NXkzWklTR1hDWVk3NStQY0FiaFBoQVVkTlBKQU51STFhMXNTeFdtanJEVUw5?=
 =?utf-8?B?cW5LNkxFOWl6SWx0WmV2blpzRmg5eTFKaFh6cERBMHd4dmdKL2xvUHA5NzNB?=
 =?utf-8?B?aWUxUFhUSUVHWXJsOXJzdXM3L0pSZ2liMWFMZlMwRUd3OWJKb0N1Ky9Bd202?=
 =?utf-8?B?UWlEL1ZKSnAxemo3SEt2NUpZVllzWXlYcVJmTlpUVFZReHZpY0I5Q2R1N2Iw?=
 =?utf-8?B?Z2dnYXplMnViY3FYb1RUN1RoMlIvSWgxYzJ0QVhpTEJ3bVNPZkhmSTF4anlS?=
 =?utf-8?B?Z1YzdUZwNTJZbWkyQ3JxUGZXN1dMS1Y5L1lvaWtjendXRkxYMWlpb0Y3c3l6?=
 =?utf-8?B?RXBrSDI4VC9DckVWanBZUTQ0WDRQczFsa1RFb3NCeGEyNkpFS3A4eitmUVU4?=
 =?utf-8?B?UXdxVjNhNmpXSk5sd2x2dTdBbWxmK2RESlhpczBFUkpFNVFLQXdscy9EeHp2?=
 =?utf-8?B?VGwyYms1SVY0STVzVVZrQmo0WjlUMmJ2aFZxWmdCZ0lMbkdLNis4ZWJ3b3BC?=
 =?utf-8?B?d3RVOHczWjJ3SmhMdGphOFArWkZQUk9RQlZDK0N3R2IyY2VlQXV1OTN3blBq?=
 =?utf-8?B?KzNDTHNQY2t3R0duZ3BBczh3ZjhPMnA2VnRIWWZXVGZvODZZb0hnNlRwY0Rs?=
 =?utf-8?B?YnNHZEp6b0RmK0IrU2RrLzJFTmFZaDlWa3ZuVXhwWld1eWUxVVNqTTgrK1Mv?=
 =?utf-8?B?SmdOUmJTZVNYcTRCaFJaZ0R6Q3VoeWs0UE9oalNrWE00NkhLSURnYVdRd3Bv?=
 =?utf-8?B?MC83TzBSOVZidnU1alpQait4dU5GdU9wbnhMMjhITStxWmZ0cHpWYUVwRnpD?=
 =?utf-8?B?WkIzNS9jOHVFR3lVN0VORU1YdGJVR3VRT3pSdmhoVWp0elBvR1VZODBhQ2dD?=
 =?utf-8?B?RmZablBCTEl2U2h5bFdmQVdmeFRBMW5FdWI0QlVQTXpTblpmZWIrQ2RNd3NU?=
 =?utf-8?B?YXR3RWtCUUZLVUpkOU5BRmFGbFRoSjYwUzBva29PR0xVQVVTMkE1RXlESVpo?=
 =?utf-8?B?UzN6M2ZLMlNqcU1RRHp4OG9tQ1lrYTYyTVM5NzB3UTFIR09YQ2VCYjAzRlhi?=
 =?utf-8?B?eTF6OWJRUjQzT3BsT08yM05zV1ZVQzVHckZaOWRMSUJHOVNSczFUYTN6R0Er?=
 =?utf-8?B?cmovWEhvL3NueVlpcUNjdkYyZTFZTmIzR1I2R1NrdHp4eTl1UTJnTFFxaWlr?=
 =?utf-8?B?Q2l5Uldvc0lCSnJ6S3VJOWFjTmZyQzRYcjF6TkdPeVd1ZmRZbm5TWHd3aVVw?=
 =?utf-8?B?d0hqMGdBVnBFV0czZ1ZlNWNkL1VROTRNM0RuNCtSWDlFMHhTdmJEdmpzMll6?=
 =?utf-8?B?UVk1ZjJHSjNaVXhDUjdYdWs5VzdqdFVwSlF4M3Z6aEhMcTJIUStWUHd1SklT?=
 =?utf-8?B?bU9NWmlaUXJ2NzNjdWV5aTlaWXptT3FQVk42dTRyNG1tT0UvSlV1TTlZM3Qx?=
 =?utf-8?B?TVpiV2cvQ1VFUHU3TXc2VXpNZWRUUkV1YmtiM2VWZXppYlBHd2Y3b1dKV1hx?=
 =?utf-8?B?Y3kvUTYrS3N1Q2IzWWlZTURJMDBlbVI0am5ScmR6cUNvVloyUkhzTzhvY2JN?=
 =?utf-8?B?T2Rhb09rc0hIRXBLdEVwQWVkRWN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA6AC70638769D438ACE460E718E8433@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7OgSrQ70KP3nDwnZFRX7UWfNADwY4Vs0Mlbbf0HR8RC1+bdWnZIgnB4kZ1mTB87cQUHvuu70GwZNI1vTcSlVVr6pneoMhqjjIyzxqkr7vnZyPsEZVLT9VX+NpK9+xbJ4F+4IAaU6CfmROAnF6SrAWE9LIv9Ts/wB6OHYnu5inLEjTrq7Kc5WseSv98dexG/eBkgn8XvV9Bly+vCe3LyL3iUlyaOBgLsWpwRnVg7gLK4X88BBfnJ19WdFsue+VbAz0rEA7nWt0BW6HEjlfJ0e95cuaQYdA4MEZcjF4LqFMXuj6YsabEqUQbzpZbL+MBoDiDnyj5KTdU0GuRAx8oN2RoBN/SWlentnLdVRzfLIeTzu76aOSkbkebgXkGtAccWCStxZbBgyrqeTbO6YVh88s7aWameKvraixNWQes2lRJTu/RhslGoh2stmhlQO7V4JwfX6heKa+zNaBVyy3N32OzsUcn9JoAVszv3YzOF6TW9lTg3WGu7nsRLsXGx/I/woHPJgC9CFc6P636+nDDqdEmoloV+AziDxlo09T4YLpVc6CdYOZDAhqd+64uqhSF+zOUsNypUX++C1L718JFg6koFnTeRZy1ljm+zB5GCMacwu/J92NVr6VLcNEWGL5dwr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddfc991-0749-419a-904e-08dc7e40f89f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2024 11:34:29.3594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mO8/Yu6XBV/VQq1LVMfsO/jyuxdbp/1kkmrGKN7mfcpSL9wNJryMUgiyVR7une2eTXgG3JXkp/u20v2PcXtPFCcmIxfBawi7QUK6xtuNOT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7884

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
