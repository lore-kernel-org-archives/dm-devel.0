Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B91BCD37B0
	for <dm-devel@archiver.kernel.org>; Mon, 18 Sep 2023 05:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695016476;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+vHEke65DTYApxuSLE1DOFG1ypzzvoCgWDLVmXk8/3s=;
	b=Uxv0iQG8TRO39nFIvcGJofbl25ghQs80jWP6DSB5p1knTjq8WY3887ZYMdfDapo2m+adAG
	aUha0zE/elbR5wm9lFIKSCk85kZpemEnF5z7Q2+k+kFVSbVEBsG0zMXOH89JxtLzk3NHDw
	X3hIIS+oHJv8+ZTF0tbue/H+aA8eAnw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-kOumSK3TPG-DxAGRDTOBJA-1; Mon, 18 Sep 2023 01:54:32 -0400
X-MC-Unique: kOumSK3TPG-DxAGRDTOBJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5724A945927;
	Mon, 18 Sep 2023 05:54:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04B2920268CD;
	Mon, 18 Sep 2023 05:54:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8295919465B7;
	Mon, 18 Sep 2023 05:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E685194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Sep 2023 05:54:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0EB372156701; Mon, 18 Sep 2023 05:54:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 064D12156702
 for <dm-devel@redhat.com>; Mon, 18 Sep 2023 05:54:25 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8142945923
 for <dm-devel@redhat.com>; Mon, 18 Sep 2023 05:54:25 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-gE-32uEkMyKXv_G93ZK3iw-2; Mon, 18 Sep 2023 01:54:24 -0400
X-MC-Unique: gE-32uEkMyKXv_G93ZK3iw-2
X-CSE-ConnectionGUID: I05WGTgKR+K1lcdcl+s0ew==
X-CSE-MsgGUID: W1jjmc6YTsmJolze1hdijA==
X-IronPort-AV: E=Sophos;i="6.02,155,1688400000"; d="scan'208";a="244536900"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO
 NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
 by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2023 13:53:17 +0800
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by PH0PR04MB7653.namprd04.prod.outlook.com (2603:10b6:510:5a::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.15; Mon, 18 Sep
 2023 05:53:15 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::eaec:d76:ea35:5df6]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::eaec:d76:ea35:5df6%3]) with mapi id 15.20.6813.014; Mon, 18 Sep 2023
 05:53:15 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, 
 "agk@redhat.com" <agk@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, 
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "hch@infradead.org" <hch@infradead.org>, "djwong@kernel.org"
 <djwong@kernel.org>, "minchan@kernel.org" <minchan@kernel.org>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>
Thread-Topic: [PATCH v3 2/4] iomap: simplify iomap_init() with PAGE_SECTORS
Thread-Index: AQHZ6CZFAFi/HsILf0ybFrdkPv7jG7AgGIcA
Date: Mon, 18 Sep 2023 05:53:15 +0000
Message-ID: <99cd384e-ce04-483a-9bf0-01ba8233cb49@wdc.com>
References: <20230915224343.2740317-1-mcgrof@kernel.org>
 <20230915224343.2740317-3-mcgrof@kernel.org>
In-Reply-To: <20230915224343.2740317-3-mcgrof@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR04MB7418:EE_|PH0PR04MB7653:EE_
x-ms-office365-filtering-correlation-id: 57d49a7e-c076-4dad-4fb8-08dbb80b8d1a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MTsgPyIzqzQEgiTrbKY0/vLnseoqn4IiuDfnNhGPS1dA1v/QVAO9xavJanyy0J1Rb8soqp1Q5X5XoEgZ2is4725ZI5fEf8sMZezBfzK2D14zl+L+eEy6ngptwqM5jiE4N81wMs1/bvFdlPaSBYOEYfMNOu2uKCnjPp5L9tGKCzIUi2XwthIBZWjjAle+vz/fMEp9Nl0AFKimibZDlbl8f97TxwJCF19Q/MwhZICP+vQxd6/WQ7hTqi0jifqHg87zfHb9l2S2l9ZmMA5pjkGSikzvk15CMvmfP8AsCLNpme5VPBAdP8ZmaqW3xkprq1h6M4FhBhBOcKtHSy71B5ZVJmkIXzqZCIQ/8RCNyd6BQvvXDmQTA9sB5sTL8Ejfj1X5HwxJK1RXGewCKj9TvsBTXTpS3VYwG7XLGq/kOv6HLKWXfyYmZ+irxRH9HZbALxLDNXEfZ07+jgBbj38nivnSeAR9sg2BIjwshcYJEgoO3Go8u+xhZFW7pazK+ovYXAr+CsXDBxRlWnpKBBM404/4k7U/yJGZR7L4tq9oVMYqNel44uoUcIvbZBaPw0waikSzuG+o4hT+EN28CU8nOkUfTxP1KlKKx0guhlrA4oilZzHMIUNyLsjGJu0GDc3qAwKTrZSAJTAn1ppIOoT3TlafQqjvv0LXAvS6X05tFqk564D7vUTwY6xLEB2NM055xLO9ah+w+MhfpNtr4wC67MDHXg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SA0PR04MB7418.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199024)(1800799009)(186009)(31686004)(6486002)(6506007)(38070700005)(558084003)(86362001)(31696002)(122000001)(38100700002)(36756003)(921005)(82960400001)(2616005)(4270600006)(19618925003)(2906002)(71200400001)(6512007)(478600001)(5660300002)(8676002)(4326008)(110136005)(91956017)(8936002)(41300700001)(316002)(7416002)(64756008)(54906003)(66446008)(66476007)(76116006)(66946007)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnZnZUk0cFQvNkNSZ2NOMnNJTFVCWkxabytZYzl4ZzRlWTltb2pXTjhMMzZI?=
 =?utf-8?B?MEs4Y0VZZlhJZlMwSGRPSEVMMmxkb242RmxSdE4rNmNDVWJSSG9NM3pFZnZr?=
 =?utf-8?B?VUxVNGVRZWNESVpNT2lEdFFFbE1nSkdXZW4yU21LWVZrcTErY3o1Q2NWb2VS?=
 =?utf-8?B?eFFiTWlaMTd2c0dhOXNZRTdtZEN3eHBWSHBnTlJoWDEyYzJyUUNSdk54N1RN?=
 =?utf-8?B?bWUxcnVIYTUzcm1hZEZaT0NSandldlM0dTUrdWIzQkpERHQ3REVNRFhYMVhM?=
 =?utf-8?B?aFZNZkVuamJTTmNMeWt1NHpuR2I1ZS9zbXJ2cndFRlZEOUdGY2hDMVNqRGs4?=
 =?utf-8?B?UWoyMlp4ZEFBc1R2Wk9UZVpzQU1MekRkZXk1Z3VwTzFaZkZEc2dlRXdJZHVU?=
 =?utf-8?B?TlpycUJEUGo5WmlsS0YrZlRRNHQ4aUlDcVJCME9rbFkxVEwzNWxRN1B6M3U2?=
 =?utf-8?B?V3NsektUN1hMNThDaWxLVFpyUksxdlFsZys1QmQ3MGlQeW5zM3ZhMHZJbTE5?=
 =?utf-8?B?UER3VS9RcWc5bjFTc3JtZ2c2ekQxdnVhM0ZtWUNXZW01Y1JqQ011bVJrVkVY?=
 =?utf-8?B?R1NuRTJQTU1BSnVORkhvdEN3MncxejVlOE85Q29zTFd1ZmFzSW1yU3RYbDNk?=
 =?utf-8?B?c0sxZWRvTXd5ckhVS1d4V3o3M1krcHMzU2J1dU01aEhWNnh0eFZvME43Y1Bw?=
 =?utf-8?B?dkZOdHUreS9mMno3OGpXb1BOaTBtcC9ZeGVVNllLb3ZtcVV5Y3dYT0JMNFh3?=
 =?utf-8?B?UC9wZFV2LzhWd0dLTHNzNS9rY1ZKN1dIaURRcjgveWpKVUxhKzRyaTJvdURj?=
 =?utf-8?B?YTNwYkxMb0ZpSUpXRjdZQXZQc1RrZTF2ajAxdXMrdzI4S1JycS9vZ0IyREl6?=
 =?utf-8?B?L3dGTHdSMGVBc2E4cFppVGpoTFU5YU1JUDZRWitMRmgvY3oxZmZ3SURTS0dq?=
 =?utf-8?B?V1pnRWVlZ3JyV3IxQXRKUlVMQmxLRnNtU2NhWW5ZSk9LRHV6ZjZkVnlnQlRK?=
 =?utf-8?B?d0VOY0NkaWEzcmxZV0tJNmlpZWo1d1RqNHRoTmhBanU2ZkRCdStnN1lQRjhF?=
 =?utf-8?B?YUlDcHM4UTVOL2JYQXZVQTRqVVhDSGRiOXV0WnRja3JzWGd4WWpleHpFMXdF?=
 =?utf-8?B?cEhUbXZQVUluejR6UnNteG51T1lPZUlQL1BCU2RSZGRvdi91R09QbGRPMG5Q?=
 =?utf-8?B?aHBzNkE5a2J5MkZ4NjVudXFUOFFISEsxcGVIOG1TU2JET2owTE5XSjdLZmpR?=
 =?utf-8?B?Nm92YlRyL2VGb3doTFNXNGVudE5aaDZnaGlUM1YwaElLbDBkUUdsQlJyK3N0?=
 =?utf-8?B?T3dMZHJnK0piNTVlVG5UU0VpZzlpbnBPdlprODlyTEJnRXBOZnF1TkdqYTZX?=
 =?utf-8?B?ZUNnc1VnUksxUlJWYlg4ODJzQ3hicVhiS1BkY3ZaMVg1RmlYaDZ6UVVITnRO?=
 =?utf-8?B?b0lHZDlRUEhtZFVaa2VuNFVVbXc5a01jeHRrdTZjY0Y2c2FXeXBkR2RiYjM5?=
 =?utf-8?B?SHZGMnMrcjRoK29INFBBTkVsRDgwNUZCbVRGVUxlNEE3ZHFtUDZ3Sm9mdGc1?=
 =?utf-8?B?bGFHdjJuMXQ2cUkvZUlPZGVraU81RDVOL3c0UFRKSHZDNGc3QjZJSE9JNmNy?=
 =?utf-8?B?MmZSVUxHc044Mm1oTmNWS25yckpDS2h2bmxvWENqYVhtMTR2WXNuRDh3L2Mw?=
 =?utf-8?B?eDBUNEkyT3Y2NHpIcENFQ2xGbzVZTmhkaVVzend4cDFBSkpqN1ZKSnBLTlgw?=
 =?utf-8?B?WkUrMHFKWUJXMUxMMXFjTFZpWTFWb1M3OTdFdzRlRTlOOHJ6bHN0eHBlU253?=
 =?utf-8?B?ZzRFNW9Wa0ZRNmF1ZGVLcW8xckZNL1oxYXd2L1JPSHM5dzMzYzYvUGFZZ2xG?=
 =?utf-8?B?eGVtTUNqV0hwUWxMUGJkZmdFNDlqWTVZalVPem1aaWU2S2hyVzdSQ09YRmlv?=
 =?utf-8?B?elVEUDZjY2JpS2dJYmhhRGFhTHdNU0FrK3RpUUxyR0ZJNnhma3BTbHErbEM3?=
 =?utf-8?B?bjhUQUtReEtDdlEvU1g4SFdxWllkQnkybHc1OVJjclkrdUMrb3MrUkErQk5F?=
 =?utf-8?B?Ulh4U0l1b2J1M2phVWdMcDBZZTNOdHltWnpvT1I5aGo1a1dOcWR6NDc5Mkxr?=
 =?utf-8?B?ZDY3ei9sbDBmcE83WHlJUE5ISHAwZC8wVUZNOVdGWWs0UklQZ2IvTDhDTlI1?=
 =?utf-8?B?QnVIS0FqTGlHRVByTk9pV09TRmRmNmYwQS80UmNNWitxKzRpUDVxOEI3U0kw?=
 =?utf-8?B?aWttZm81NFZTcXJOQUtZbHRSaDlBPT0=?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NGVVbTk2Q0c0MStzaWJuRFZQWU5SdHBPalNVUFcrZ3ZTSEFHVlZ0TzU3R05Z?=
 =?utf-8?B?MnJYVTVFWmZHbGcwMjZXMFRWNkNLWG56QlpIYkFlbklySnJBbGJ1dnRtcDY0?=
 =?utf-8?B?ZGdPa3l3TWFCbzlHczJmWHN4M3VXY2R4WHV5RVUvMUNPdS9GaXVsd3lneisw?=
 =?utf-8?B?QUxwRGtLNXRSV3F2NjlBdHpzZGZRNUN2Zk9EUEI3YVMxelY1aHlFZnZpc2Ju?=
 =?utf-8?B?b1NXb01LZGNmM2Z1VXZCaUZJQ1dsUnkxdnFqeFVDUW45QkNyVWk1NXhwSHZG?=
 =?utf-8?B?aDQwS1pDWVU3K3VRUm8xN0EvMFNtSnVtMW9UcTJjaHRGQVhFRzYxcm5UTURE?=
 =?utf-8?B?aDMrQVp4c2FUVjgvdFpyQ3I0Mi91TFVEM1UwSU9VTlpoV1lWaWhoQXQ0L041?=
 =?utf-8?B?a2hGVHhTK1FNKzdaK2VhbmlFbTNTb1lNSUt4dXRtRFU4WE9wMk1RaklCc2N0?=
 =?utf-8?B?c2Y3UDl2NnVBSC8zRHQ3d3VVZkw3OUlFTEZzVzFMSEdVWnNua2hCMUNQRHpY?=
 =?utf-8?B?V2IxV2IrMWQzckZWU1BRUzVjbFR2Q05TQ3F0YjFOUXJuenZHWlR5c1NMZFhQ?=
 =?utf-8?B?b0lEWExGdkkwTGV2SXptUCtQank0anZwdUpqZksyaFJIUnVCTjh4ZjdWcUhJ?=
 =?utf-8?B?M28zTVRsQTZ4TmZPTktLM1FmTjBmdEY2NW82azQ2MTgyVnNib1BLaTk2dmRw?=
 =?utf-8?B?SW1tRnNscGlZRkJxMEtyTnd5eWNEajEzWnlYeHNiY3dIeEQzZjN2dVdSRDNW?=
 =?utf-8?B?STV3THJMcmZWRkkxQmU5SnJIN0lrckdhQ2RyN1lQcjdudTFOY2tkTGJXVnFM?=
 =?utf-8?B?eUJ4Q2gxL0RONEMwUktrbkhkSWgvejIwczdMMkNpT3lrdTdXZXBsZFl4YVo3?=
 =?utf-8?B?UGFwYmRxTzFsS2hYSnBYMnU1YU5SeDFBTjRDVW9UQzN6Y1Y3T1N4SGJReGxM?=
 =?utf-8?B?UENxSDVCUXpjaVE2RHRVcmdtd3RxdFJXcTh0VG84eHJMR1JjY1RMNUdCSCtP?=
 =?utf-8?B?V0xCOHk4dk1PbXA3Q0tqWXRhRklBbjQ2NHdMRXBSVXhKc2pRby91a2F6TmF0?=
 =?utf-8?B?OHUzN0puNUVwNGcwNWxuVHZjMUU5bWc3NCsxMHBaZVQxS2VBbTVidkdyd0JG?=
 =?utf-8?B?aytDSnEveXNUNjRTWngyZDlEb2VOOGM5REg3MTh3ZnlSYXk0aXlXeC8rc2tD?=
 =?utf-8?B?OUl3RWoyWkRCRXlBRm5SSnUxemY5R2dJdVQ0Wlc0bXE4SnZPUWo1TGM2MjRK?=
 =?utf-8?B?Wk8yMGdzMllaTWN6ZFo5L25tcVBuVWM2OHpjKys5TEZHRUpTVWdHK1RuTGkr?=
 =?utf-8?B?dGE3N1VIbWRxMWMrN3RtUHBLYVUyQk1uM1BSOFIreHBrSDVadTV3Q1RGRkpF?=
 =?utf-8?B?Z2loajM3WU0xOU1HNmVWU05NRmFrMUhwUERnTG5vaGlpcHBwWEJmcFUwMTl4?=
 =?utf-8?B?ZEhSOG91VHkwZUIzOE5JemZ6eHRNZmxzaklXeTFhTS83dXFFTTlIaTU1ZWVF?=
 =?utf-8?B?VmhodXk1cUNRNFp4aWdaZXhwejROQ3ZsQ24vRTF2My9HcUhGZTQvVHBobVNN?=
 =?utf-8?Q?rYgRWxjQvOcvWwDd/Kfu0qGBs=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d49a7e-c076-4dad-4fb8-08dbb80b8d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2023 05:53:15.4000 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtimGiD7P3k1PCoHgXHnB13YJ9LV4YzYjZR26JBbKOH0yA22WgM320KplWJnamCdAWXBBwzerkeWQ8CAUoiA6WdjXMSAeR5gkN+9fEpMK5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7653
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3 2/4] iomap: simplify iomap_init() with
 PAGE_SECTORS
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "p.raghav@samsung.com" <p.raghav@samsung.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "rohan.puri@samsung.com" <rohan.puri@samsung.com>,
 "da.gomez@samsung.com" <da.gomez@samsung.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "willy@infradead.org" <willy@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "rpuri.linux@gmail.com" <rpuri.linux@gmail.com>,
 Christoph Hellwig <hch@lst.de>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <C7AE1ADE406AA740BB49DAB1B104F238@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

