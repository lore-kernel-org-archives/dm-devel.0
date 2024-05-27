Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13392131E41
	for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 11:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716809665; cv=fail; b=XX9VBDhbqJ3MKzp+kjXjjOjswrI7Pkf9sWw1fbsbw4lhqGFFDf8glYVbhgq37y2ozSg+FzJnZtwOZuVaeyOGVYI0Zb/WjdSYKzAgfFHZKUvpR+d2SNdPMST6ngbI/1Uih11wAS+nCBQxrs0TspLjrafGfjwlJXxi0SUgC8nfHQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716809665; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nlm//uK7APY/i1JN9Rl+vUR4lvfvKKIfmcQYtmCE55yhAQh+ZMfHcrT8lqSV9yZ66Q1RDDSGgxQNshTO2lXoVWMmfiq+oc/H+NhjobjSnkhmf+LRLILo/5/g8xDAnkP9GPsm9/ehnjulqWnOduUWfOkn5GNyBcri5v+et+VGQbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P7L7ysFi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zVEb89uZ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P7L7ysFi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zVEb89uZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716809662; x=1748345662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=P7L7ysFinept7Tlqyi8wX235QocPe4BwzO+dp155otlTFvkkCUEfMx7y
   7pVdUlWYzf1Q9wqBsZxHnC0igp0bpktaKZyEyC/QOSqb+86pLCHFQ9Mla
   sY7liYWYy4aH5VJAvJI/SI1WzgR8e/94SYD3guOaxZJwqeBB1vchBJaLW
   yRo4w6/Ck9OqL4Fkbl9S7fRxRGNjN5kvE7dQawQhelYldyt/MQWf6LYus
   Ze3npReYdcYCL/WqrfTrzu3SzBpD1ZcwMifdhAZByrOiJwp8Cdv2zo0Zh
   OzxF2JPZj2H9FtF7DtC0KuOvK7JgassiwcYA6IWcqcV0afV6XlQ21MebR
   A==;
X-CSE-ConnectionGUID: ERv4SaCFQvOSgeYreKhHhw==
X-CSE-MsgGUID: tVAiUu/HRZ2i1inY/qBD2w==
X-IronPort-AV: E=Sophos;i="6.08,192,1712592000"; 
   d="scan'208";a="18190272"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2024 19:34:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idzfKzJnrhBzbCx6B7wkmrt5XgpVCObtSy8q/tKT0rdTOgW8InzZkiQu6StbMHLWuBEbG5Fiftk2h7YaLEQOLk8y/AIDYlYO6GH9Yfk1H9vlhkbNJw7Rr+pDY85n8ssNTDK8Ed/c/y8uMtXJ9qHMGJqAP9vzLgHD8j6KX7nEsTlW7swa9sa4cpKImBAyRh+CTqaQq1h8vSjq3alc2o49yaopQ7WwYl9dEfDTupXpChwmL812ZqEYlHB7WqyEjZgHSqMEVhmYd30KXWFb2GfyIEQH4IRht3NlQG8WATMXSCMI7WWFmWkzBi/ZkPNvItn4ZHXGS7nMEmgH1kAMGlcBLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=amiin5YVyiN5UDbRHK/oE+EYMizWy2ZeGFuW4Ys280ii1ED4EoQixDV7awrXpC0XTX6Plojr2+fgH7SyZe1EfuOZytc4YKAOlkzd9FmkiQcoUK0Vp//qG7iwSWbYgQ57RPm61J0LP1g8vNWvKMdURcUNu495Pdi1nfo3Tm2uNHy4BD/MZS7AYVbME9PHk9DpoTjSs8hOS9pv0hXbjzEnAaQ2l/9WG8tZLCZnBZqCkDuM8vamkoQcYglYIrgSYkjpvE10dEw9BZIeTG+P0hTIpHfzGUSYZkKWNvkT3H+bIGxLMO5QQjytkuIDeDO/E9OqDLdryuK0Oq+ik8pEeMNrEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=zVEb89uZag5fFqFu4b4a7iuwA9PZKJMeOOWHScDzZIUp8QUw11VGuF5qiZnIzGnFZ9Bn/W7nN8La/8xCLMr5oiQxx/ffH22BfC9AbFfTZhtzRu4cHNc4AI2XsSwBVjD22Sn0WAFbHTcBQmw+o3x4vbqGZNRQz9rjQdEZOqgKA7o=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7884.namprd04.prod.outlook.com (2603:10b6:510:eb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 11:34:20 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 11:34:20 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Damien Le Moal <dlemoal@kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Subject: Re: [PATCH 1/3] dm: move setting zoned_enabled to
 dm_table_set_restrictions
Thread-Topic: [PATCH 1/3] dm: move setting zoned_enabled to
 dm_table_set_restrictions
Thread-Index: AQHasAyPj0G1LLSOqEukZagt9N8ev7Gq84aA
Date: Mon, 27 May 2024 11:34:20 +0000
Message-ID: <659b4ee2-383d-4b4a-a1de-9cb5f7bb319f@wdc.com>
References: <20240527080435.1029612-1-hch@lst.de>
 <20240527080435.1029612-2-hch@lst.de>
In-Reply-To: <20240527080435.1029612-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB7884:EE_
x-ms-office365-filtering-correlation-id: 3e24d968-f06f-46f8-4554-08dc7e40f317
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?RHV2VFJvQXFiWVFFY0duaXhBdDlLL0pUUWtMSFJXTGJTVEhhNDZIenE4TE8y?=
 =?utf-8?B?cVJGeittejdGaG1DSFVTdXllMHFXWUVVSnlYRUp1K2pVY0xJdUVDYldqUFRz?=
 =?utf-8?B?ZkM0aU5ta0xXRjc4VFZGT00xR2tUclhoWDNJUUVPR2w4T3p6WGkzOTJYNG1D?=
 =?utf-8?B?T0JEbEJsZmdlU200cnJHekdnd2ZzN2hiSWdUTkx4eEg3NEZLSHp1VHVHVm1n?=
 =?utf-8?B?dkNQaXptelk5TlJ0ZW9wWVZBWklKVkJlUWUrWVlKMG1yY29MVzFESlJOMTRs?=
 =?utf-8?B?c1BCZjBuZXdpZXVTZ05KaWF4TFZudUZpRW14U2IrQW51SWVqR1BkSytXNHNa?=
 =?utf-8?B?V25RWGpiVVVPc2xVNVlPbzNJM2NqTERPdmRzejlDVGdsY2xMK3B0L2pVQk1I?=
 =?utf-8?B?bU5HRE9MbmxsT0ZwK1AyYkFxQWZ2WXlSc0Jydk9aN3FqR1MrN3doaEpRUmJq?=
 =?utf-8?B?bVE5amM0MU1UaGdITVRYL2hXMzBRT1ZmSDBDS0h0TUl1R0ZsQlNNbEF4QjFo?=
 =?utf-8?B?YTNqN2VOSWlxM2xCcGgzL1F2eTgyOC85TmZIUFI5TVFydjVjTjM3VHRZd2Vw?=
 =?utf-8?B?bzRhTGoyazg5YXdSbFBXbHY2SmM1YUF3SFNzdDFVR3J2MExmMzhwc1B3QjdT?=
 =?utf-8?B?YWNoMzVwdEpTUU53SGhKd1hmTTFWTEUvR21YTmVTNW1RWDg0SG5qOTFUdDVi?=
 =?utf-8?B?bXZEekFkZkZBQU1wc1pJdjd5NUY4aXVMQ1RjaEZJbFNXVVdOM3V5eUZlMm43?=
 =?utf-8?B?eDN6RkZIYUN6UmNkWjdsTjYwZjd3QzhCTldDZmFpbmpuZDYyWFIwSlgxdFhG?=
 =?utf-8?B?R2xCeFRuVzY2dmxYalVYTnlQSThPeHBLc1VhUDY5VXQ1ZVE5TFNKTVZJcEt0?=
 =?utf-8?B?U05sa2J2SFhTOVJLM0ZKN0JXRzRNTUt6TlVmWVdTNFdpVFg3RDFoaDRpdVE2?=
 =?utf-8?B?NDY1d0oveHpjV2ErU2dLM3grdDgyYWdzYUZRc1ZpQkt2WEZhZzFhR1k4UkNm?=
 =?utf-8?B?NkV4ZnFzZHo1ZkppTCsxMHh3N2JYL0hzTTNQZ2xUN3ZiTTVPc2p0dlZXMllW?=
 =?utf-8?B?alhnSUJ2bkt0eE54UWFjZWRHdDJzNFRNRytDTUlXM0RLS2tZQlNXcEV4ZFM3?=
 =?utf-8?B?R2VOVE16OE5WWXA4aUpzWmpiNWtFVDRHc2tCVldvdHlTenZuM1Z6cEhDZEI2?=
 =?utf-8?B?YWpDUndKSm15c3hBcDYvVEZZVWI5QmdFZ2I1SnZicnFlblRZVXZBaklHU0hY?=
 =?utf-8?B?REFiYzRXS2E3cC95bWdLYXV5enJIdytpMUdwK0pnRitYRStkTEZYYk0vT2Nr?=
 =?utf-8?B?dnBPSVAxbWtxOGVXUWllRFBHOHVOYXUzMEliU0NCK1dIRnlpSUZVT2xLbWtl?=
 =?utf-8?B?UFlQbTZ2cFdwNzJSMVBrdGluYVJBV01FODYrQ1hhdWcyQlkzbGorTWJUTjNH?=
 =?utf-8?B?VDFuL2hKdm9QNU5VVy81aFkrOGw2OVpPYzR0VjFPeGEvbE84MUVKbVFqT2hr?=
 =?utf-8?B?WDA0M1B1a0lQK3RlS1NUeSt3VklyK3FQblQ1YnpQeVNyYm85TjliNnlqYi85?=
 =?utf-8?B?VUtNaXMzWmwyS2xkTitxdjhZZ1gzSEd0dUJYNk9pRzB2WFdtYU5DUEY4UE5h?=
 =?utf-8?B?aHB1dHFUS3J6djBhOUNMQkZaaEpPZWlNZHl0cDhBSEpmUFVSaGh4bjhOa3hx?=
 =?utf-8?B?RThvN3UzUUt0c1V0Qk45M3RkSnUxUEFEbTdFbnlXZ29Qc0pKN0lYK0x1dm1v?=
 =?utf-8?B?aHRWOEdXQWgxblF4cXdkbis1WHpxZEhySnozWUZkakkrd0xzbkNnYlFmakJY?=
 =?utf-8?B?ZkpiZmozM08vbm1jYkZIUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RlpreUMwNTdGOFJ1bEdxSmNodkRub1ZZa2RGdStzZlhURjBoZ09mWW94b1hq?=
 =?utf-8?B?c0g0ZnVqbU9KQ3ZEV0t5TUc0aUVZUVUwWjhKTVc1STY5K3lrTGZnTWw5NXB0?=
 =?utf-8?B?bC9xTWNsb0x3TEhqWCttell6aHZuMllvc0EyYUF2RWFmNHd1QTR0YnZ3amtv?=
 =?utf-8?B?NjZKUFNMT0grWEhEUWl3L014ZTg0NmlMRXpxcXg1eG1yNG0yMnRPQkxxcnhi?=
 =?utf-8?B?SDZqT2o0VjFidFRkTVRsaS83eVBsTFRoQ1oxZFNsbFRESlNxZWZJVVJqbldN?=
 =?utf-8?B?blYzWkdxLy9YRWVpK1NzZW13KzRtZU9mV1NGaGRNU25EaDJFR3NDb1kvMTBM?=
 =?utf-8?B?RFA1eDRHN1NUK2VETzZSZUJ1UTlLa3lwcEVPaE9hekNvd0p6ZnFCdHpOUEpT?=
 =?utf-8?B?M3M5UXovWVdONGhucUNtOHZiUHFNbVQyTjRSdEU1ZHJCRkNUOVNhWFkvSXJH?=
 =?utf-8?B?T29qT2srR01zWGhDS0FuMC9nUWMvQ0JscDVEcmdFZ0htYkVybkZ2UmFSUkZu?=
 =?utf-8?B?eDhKcGVYa3V4QlpwNnpxMk02dUl5dTNZemt1WmVQTTdYU1BLQkd3Z0JWY0lY?=
 =?utf-8?B?VmJ5WlpCcWVYVmorVGV5RkJTTG8vQWxVZDY1MENkcU9LMlF6QStnYms1Uk1F?=
 =?utf-8?B?aWhzYnVrTUt1S09zQjdtZkdrNEhTeUovNEprS0x1QXk5NVlxa0NpbnJTUTJ4?=
 =?utf-8?B?M2VVOU5Ba0I4S1JSYXhSdkFnTW1PZWxJUEpZR05SL3JucnltWmUyMVNncmdo?=
 =?utf-8?B?TjhhQVQvZWVaZjZnSXp4MU1hWlprdmErK2JMYThZcGFKTVMzL1pqOUc5TlFq?=
 =?utf-8?B?R3VHeXU0NzRRU3oyM2w3QzRqOGZnTCtqQjFyZXZDS09TME9YMEpoeVBhNnNI?=
 =?utf-8?B?UEZVeUR6QkVQcHJiVW9kSTdaU09OeHBmcGZ4QjNwTHA3cWMrVkRBU1RzTXZi?=
 =?utf-8?B?TFlZK0d6VmU5VXkrZ0VycGxTY3BhN1pHd0NTejVlUzQ5QkRtbEJJcnBkZWQ2?=
 =?utf-8?B?b0ZFUmlIbVdlL21hRzFML0hub2l0NFVCaUtHamVwTk90RGlyaFJab3FXQVdr?=
 =?utf-8?B?TisyK1VSTk5ZVi9TOHBSL3cwbXczaGt5ZG5kUVc5Q2Z4OHpyNlRUSG81Z01F?=
 =?utf-8?B?Y0h4bm9wdHlKVm1zRSthbFk2VWJLQUNMUndsYlZ1ZDFieGRrNmNRRkJ6L2xH?=
 =?utf-8?B?RHdBbWoxbFNuL2dDSm5CSVJuWnkrN2hFYTc1VzJCSGhWMHhpNVo1YlptTm5V?=
 =?utf-8?B?NkZSVFB3QWw3MGVFc0Fvb2lWa3MrZlNwdFd1SytvQTk5dUN0WXlScUlHSjBx?=
 =?utf-8?B?ODFSb3FEblRHaWw4SldsL2hDOFIrSlJSMVFIS2UveE40MFloOC9zNE9keENZ?=
 =?utf-8?B?VUVwRENTZHZnZ2NURWZBbTNjNnd3MTFuWnpoTTc3TXR0dWM2S2NLL3drNGwz?=
 =?utf-8?B?bXNsTW80d0tSaGU0VDJva0pkaU8vN1JVdVc2U1RSWG1LdGprMEo1MFZBak93?=
 =?utf-8?B?aDYza1JIa1lXOGxiM0gzS1JuRWoyQ240YjQyMGliUnE4UDVGYzNQRWYySXMw?=
 =?utf-8?B?SjJFM3A3cEY3cVFGNXpHaHd4L1NGYm43VTFVbFN6VXdaKy9HWnJSa1RJTVJl?=
 =?utf-8?B?Sk9KWGVZeVlHQmxXWFo3UFNnWVNkZ3RUTlg2a2orb3MzMFhWN2pnQXZ0SEZr?=
 =?utf-8?B?Slh4UVVKVjRKRG51TUI5VFhWMWdvNE56bDc5amYyYXhzNlVMWUliSDV3QjZL?=
 =?utf-8?B?TldRZi9LS2p0MlN5bmFiT08yMTJIV3hWWGlpVHl5ZDhObWhYSG8xY05xanZE?=
 =?utf-8?B?clFuaUwyQ005UllEQUt5WmpTekh6NkdhYVhJdUIzeWFrZ24zWEhlTVNVL1dx?=
 =?utf-8?B?SlBuSDVBRjhXUGIwMk5uUHhaY3JYTTlhU1hjbDBOVnJGTzc5Qmo2T1M0TlVE?=
 =?utf-8?B?eVVIbjRoSlNCWXRtdUY3N2VKZzZRNndDMml5Nkp6YjBFY0poRE0zVHlENGk1?=
 =?utf-8?B?VEcwZGRVMGwzRG03ay95djFIQjZxTTFEZUpja2FTbVVhSUpDYkdzdWhCV2Qw?=
 =?utf-8?B?cnRERmtYNGh3SXQ4NHJFTkRvZ2N0TitjKzdVbGVaRVJzbG4yclhxbXpPMm9x?=
 =?utf-8?B?YmM2S3NIeS8vSGtFeW5ML3hjSVpBR1paY1g3RjJoQ2dLbWJtWjJUS3RJRysv?=
 =?utf-8?B?M045amNYME4zbzNyRTNCL25vdkswZUh4aGNvSVF2eXczUTZpVVdWWFhUR3JX?=
 =?utf-8?B?YjBkV1phWTh5emhEdHNSS3c3UDN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28F43B65BE67B34EB192C9BED3AA8150@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	msZNH9rEk7UzJiAyk3/aUWfvoW3OmyUVeCq6ANyhDr6+cN4z2xB4M5WSToOefO/jWuMaePBpGcndLY6pb7k5vO83i5crnWlamqtqTkt5NqW7AibuAqcqcHyY/JdItfga37PqLqq99QAA2iI8v8Q6GPYMHDw+2aWqnSA7Oe7FKiTGUT8oBmW3hh2vxDvucCfhoHi7nBe8PFj8f+tVx/QSv1ADc4QzaQsL8qSRrOAN9TwTUVt5A8JUkI6LLfn2CMq2HEVANQ2UAnWsfubvtJWKvqnM6BWO9RJu76YyRJsHu8rZjP/P2klrQDEMKN6w9c+7EcLScz+5KhHXiWTNG85NwUFMkPB5eQ0C6qIOTkBphaDMMKeYy5FT+DNFCzhsYjC+VVCvVjLhucnjxJv5lgNTsp1hrXv+ROKmJiWnUfyDdVwentOBVbNyK9RYN7ydCDRtwBmlSK8CowV220QsZYzWVqg8N1XSI/udnMFXsRBVUxA3Smt4s2a24Viu8ZYDSDnR0TlYurU4g5vP+9OYSPU3sDFjetvqDLEdiuDs5JI2KwdYI4S3tCEbKG+BS3kut4MTQTWjxoLzcq8ZHFsooDBXA1LvUxJQYr2DIJQJFVu0Wx3vEoSpO9tr5ryJNI7aXnuX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e24d968-f06f-46f8-4554-08dc7e40f317
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2024 11:34:20.0888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5qqQY1sIHNxiRwrKQUVyksme/y9hwWtwxHrnkpRcxp0vpfsM5/FhjX2yJQaqtIZ4z1f5cPG6AcT2I8ZCT/6YWBq3sc+OMjc9oHubgP+i2VU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7884

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
