Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E058C77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 09:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685092849;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+vHEke65DTYApxuSLE1DOFG1ypzzvoCgWDLVmXk8/3s=;
	b=Nb8PO7xe8OErM8jizcFP7iEEX+I2iF99aeveFSyf8NrO9QWBtP9AyaX4dwGozSwT+a9lUf
	XCgMUghKgf+Da8ZsOieLvKLuey5IN6N5k9TP5ylM+mQrAwGCd5uLmXZKDayAtNDNDM6wUA
	U/lCnBKN0H8nbyOKL8WgVrklbCEXegM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-2JFomciMMiqzF7sm_0f7mA-1; Fri, 26 May 2023 05:20:44 -0400
X-MC-Unique: 2JFomciMMiqzF7sm_0f7mA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0CCC3814950;
	Fri, 26 May 2023 09:20:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 267AE407DEC3;
	Fri, 26 May 2023 09:20:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C655719465A4;
	Fri, 26 May 2023 09:20:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5ADE19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 09:20:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 72ED1140E961; Fri, 26 May 2023 09:20:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69D3F140E95D
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:20:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3349C1C0ED09
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:20:39 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-1LMAm0o7MKmSjzIbRIrnQw-1; Fri, 26 May 2023 05:20:36 -0400
X-MC-Unique: 1LMAm0o7MKmSjzIbRIrnQw-1
X-IronPort-AV: E=Sophos;i="6.00,193,1681142400"; d="scan'208";a="236653891"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
 by ob1.hgst.iphmx.com with ESMTP; 26 May 2023 17:20:33 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7389.namprd04.prod.outlook.com (2603:10b6:a03:29e::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 09:20:30 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6433.018; Fri, 26 May 2023
 09:20:30 +0000
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
Thread-Topic: [PATCH v2 2/5] drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
Thread-Index: AQHZj6Rz8nDS9HDQm0ConYF91ttygq9sR1YA
Date: Fri, 26 May 2023 09:20:29 +0000
Message-ID: <8e50995b-1e28-fb03-d5b9-d05fde200887@wdc.com>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-3-mcgrof@kernel.org>
In-Reply-To: <20230526073336.344543-3-mcgrof@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7389:EE_
x-ms-office365-filtering-correlation-id: d2bf3548-cd0d-4517-dc66-08db5dca732b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: L3hhGIFga0YdL4sjnL3WnC+nb5rrsT3j8YzjKR91H7DoUI5BDj3bI2PkL9jw8eBUs/YFlpN0bJq4j2JWaQvaCYgbKhIFibkg2NFeC50zhQ5FuyG/UvsiGyN/XseLKWbagVmH+JFm1sqapfujDPb2y36r5eWO866LmtPwf0rFibgUDX45irhm3ZyqLDtShL4YLSjx6PaRMbhSHbTYR5leMVG0NtSWwUsvlXaJsq3yzYpAcyKNOhsU+H8z/XAZ1GAep9iyZZKkKV2JYcsXIu4y9+f3UEPl9Y3BJWLTEHh7TWuCAlB9Q4INvLzjyIqRRxSy8lP89QZ40POMoVhN/rsibfC5RSFdY7qeCuwkI7UWxV5LDNFvKHByjd4eDdM3hMOKyqHlH9b9KJGm7UjOT6AEdrz/oHYgL/KpZ+ATawVyiMdwK6B8Nv++aTx3DrurZVaUBUObry7eXg/52Ey7VAjQdz4roNJOVN57m1M0onh62I7Wg0ikR9NWBUOtCmhmSDbZgyvMjr65f/lUhD/xclTlCRkeSZgdH9Ezs2nuBGBhBFfc2UCRAPlEbMANkKMmUjXyPwdSTcZhsm7J4S9N/Gfyrw3FNC/5vI+HcHEbPHybgyyzOeUs3NiYKwDBNOimKs86tiQfJZv3miEE1fKuIq3A4mLr+L0nDUaw+lICSLJjoDBaW6tBrJssk08G89S9AWzX0FfjCGrIJkdpuKLSEzC4eQXX4+WOeuq+6r9NoU1TTEPKeMMeXQsaiyHsla4zLIBU
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(31686004)(6506007)(186003)(41300700001)(2616005)(6512007)(8676002)(8936002)(7416002)(26005)(86362001)(38100700002)(4326008)(558084003)(36756003)(2906002)(110136005)(66446008)(66476007)(66556008)(64756008)(478600001)(5660300002)(66946007)(4270600006)(76116006)(316002)(54906003)(31696002)(38070700005)(91956017)(71200400001)(19618925003)(6486002)(82960400001)(122000001)(921005)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXZPaW1yQWxNRXo5NHFXZmRlMjlSTnFGUklPY2NXZDgzL213a1lhdXVBWGlt?=
 =?utf-8?B?bUw5dThGdStHRkNWeHZNVEN1UTVidFUrMU9qNEV5OHFwWDZHQmI2Rm1kYWwz?=
 =?utf-8?B?SkRXeEJGZEs2Uk5DSW9yVnp4T2t0NmlqYkVaVUxJZFh0Mi85dXA1QXhwN1E0?=
 =?utf-8?B?T2lWclQyWXRLcEkzNlBYTEVaWXJlbjdTSjd0ZU1TUVFaQnFOT1BRUndxbmxn?=
 =?utf-8?B?NlBtdGtpRU0rMVRUdTZtb3NWR2p2Y2NIa3pZUFkwQjRJOFM2THRtTnlocXRG?=
 =?utf-8?B?QWFKQlVHZVBaMWZQeW9jaE5DZXlJQnRQcFlzUW9KRjJacGh2RytOQ09EU25F?=
 =?utf-8?B?a0lJV0c5dnVxQzFDNkFHNUVKb1V4SXZvZWZXV2JqYWdSaWU3STQ4WFJlYW1H?=
 =?utf-8?B?SEQ2M1VNTzhIYm8rSFJjeEhBREtHaytnSWhFN3BTWm12TCs2a2xuSlZiOHNm?=
 =?utf-8?B?bjRIYktSUWpJRE1MbTd5YXJsa1FtelFKUkNkSEc4ODJNRHE5aEVBeG43RmxG?=
 =?utf-8?B?Q2JtcEZCVkEvM0lJR08rR2Zka1NVdkYydG9ZSm43T29nQ0Z6b3ZDVENyQnE2?=
 =?utf-8?B?aEl6L2RqVFA0ZmlvMHhIdlVyS0JRazJ6YitGbWpSS240V2JmR21XMWR0cmhR?=
 =?utf-8?B?V0t0QUhFR1BBNW1iRTVjZWxWejRSKzY3SVdwcm5KSnE4RmpORnQwTVlGTkQz?=
 =?utf-8?B?VzBPWVIxL01mYS9oN1AzQVFmOFUwRXRJYzZJcGNDbll3bHg3V3NWUzh4Qld2?=
 =?utf-8?B?QWVodTA2eVVxa2VvV1lGMFZ4bXlTSjFNakNvWmxSSUNja2FsV3dPM1B0UnhL?=
 =?utf-8?B?b2xQVWY2YXAvV05yRFluRHlsamRzOGs5M254S25hZEtOa3hhT1czc0NTWE9l?=
 =?utf-8?B?TlJiLy9LYzM0M0tXM0IveHVjZFk2YXNOclpadEloUkFRc28wR04zZ0pONmIy?=
 =?utf-8?B?a3VDS2w3KzhpQjZHalVScXU4UU9KeVZLTCtwU3BLZEgrQmJFbDFKVGhHNjZu?=
 =?utf-8?B?OFpyS1lpMDB6U0hvU2RJcVgwNlBXeGZYSTl4QXlSS3RQWEl3T1lBblRPL056?=
 =?utf-8?B?bm1rbTJrZDVGWTRQRm83NnkrcFdoWm8zR2NpY2tLRks2c0hKV3RZcmpuZ2I0?=
 =?utf-8?B?UmU1cUYwcFZRMlBSdFRLK09QQ2Foa1hleUFvYm5PbE5WYmlpY01MUDU0ZjNt?=
 =?utf-8?B?aFJUK2p0SzZuUlZDcjU0RXVjSFJJZGo5dW41b2s1LzRFa3RQVm1tZ1NLelg1?=
 =?utf-8?B?VVVyYitsSXBCR0FsUGlYRHNEbWVhOUtUbElBRGFsRVFKZDBTN0FaNFVlQTJ1?=
 =?utf-8?B?bWZJRE1zMEZUTW5qNjlWNVhtczcvTG0xU3NjM1RPeVlucGhvSE1LN2h3N01O?=
 =?utf-8?B?b1pjM0lLaUlKSElEbWkvdHpmbXlKRjl0b084cHlPSVE4VS9FR3RpTjNxT0xH?=
 =?utf-8?B?ak4ydnJtVGJ2WGJCWHNKYlZEMm83TC8zaXZCdHcwdUo0ZVFPaFZ1OHJnL3hP?=
 =?utf-8?B?RXEzK0dNSmxBTFlkdm5GUmpVYStGRWZHbG9UYzlLbC94UUNwWkxGeXdLTk9F?=
 =?utf-8?B?a2JlQzhpN2JpRFE3aEtKcEdoeFJTTU5RNE1aWEEzRkk2YVJuTm4wWFliY3Zh?=
 =?utf-8?B?SnIvUXpaeGxqN2pMNENnVDNnOEhZcVArTTY4eDd4WjVncDBtRnI5d29OWnlL?=
 =?utf-8?B?RWxqdWxiUmZOSDZIRFpSSlNST3VPaitvM09aaWFNSWhqRnUzbTRhZWpUVlJs?=
 =?utf-8?B?dDlPd1dvbTRoTnJCd1pHcHNTQnhuYTgxR0J5MGRQQXcrNGNxNkovL0R5SkpQ?=
 =?utf-8?B?Tm43R3JVelRQQlpYamVuRHhJa3VONzcxdEpWdnFoZmMvaEM5VEhNYnN2OEFC?=
 =?utf-8?B?OEtnbWpiRmJLMC9GMjAzVDFiMzIrNmpIeFJxdVhGTDZDeW5qSWJJM1RkWHA2?=
 =?utf-8?B?VFZuRjhxTmdKVjV3dng5YngrY1FDYlRCVFdVejlsYnY5T3VxbEQ5U1hQa1dX?=
 =?utf-8?B?Q1BPb3AxQkR3Qml5VWVsLzBqS0lDV0tuclEvcUJkNFo0ZCt0UGNremVHdncy?=
 =?utf-8?B?QitQMHhhNHpTTFNPU1JydldRMmlrVkJRU2o1VU1ycXFMT2FaVTcrRzNiS1JG?=
 =?utf-8?B?TFprbUE5WVRrdkNHc0FQSERJZVVsTmQ5dGFMQXZGVFhYNk9xaDN1bkdKRnY4?=
 =?utf-8?Q?rYohvhbk4MbmZCuZZ641j5E=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RlRTQzE0dklwZVhWeFF0NzFiV3RNSW11Rk5QMmU4cytvM3RmYXI2ZE5IcGIx?=
 =?utf-8?B?bUpRWlhYRkNxZ09oMTJsbWZEQkJ2Z0swZTVmOFhqM1IxZ203enNsaFBHbEtp?=
 =?utf-8?B?S2grcG9sbXFrN2Mxb3RlRit0QlpUdkpjR00xVUgwbEdueGZJT0FaRm1oRlM2?=
 =?utf-8?B?ZytQR0JyQ25kek14aENJUmVRMDB2bVlyUXhqVDVnRy8zR0xDNXowTEpTZWVG?=
 =?utf-8?B?eFJwd3gwSWltT3FFMWY3S2ZnUXBrWmJ3anFqT2RmYnVEVjNkTnVDUEdOUDRr?=
 =?utf-8?B?WStIWEM3R3hmMU94TTdzQ1R4SXBuMlZFZnd5dFhJVHlZQ212V3JpVmpONlE4?=
 =?utf-8?B?eGk2MnBRVDVhUzRwbTdIbWZjTXo2Y2k1MnJIVStxZ3l4dEJYd1ZqQTArcU0v?=
 =?utf-8?B?bGlCaDBkQ0JhRHpLaU93OFlEeHZreENYckN0TmMvUVdLZ0VqTzRpc0lwVWZZ?=
 =?utf-8?B?U2VGcHl3RHVlcnhuZjhHK2ZRRTdWVzYwaCtPVEpwY3psa1A0c2xub0FTbGpU?=
 =?utf-8?B?WTBWN0xTVjI3eEJwNlhYMlA0ZUJSQkJncERmUkNyUmU1TjVQRW5RN3BnZzh5?=
 =?utf-8?B?TktjVHBSem5pTkZKbk5XUTZyRC9vbTN1WDJVMWhxYkJvazYrQ3BVQ1M1cFVT?=
 =?utf-8?B?T3FVT3VSUHc1bXJmYXRpMWxTUExZcVRpZmQ4VkpZMkRaeGRkN3NkclpyVDR1?=
 =?utf-8?B?MHU0dlE4OUhRUkVXRWEwV2k0OXE5cXpVV2VrVEEyNmhIK2VmcXVUSHhKVVNm?=
 =?utf-8?B?NWNRWEt0Ti9pVUJjekN2VkhFeHByVE9IRnJUWUh2U2psNVJUaTVqTzQ3K2Zn?=
 =?utf-8?B?dVFtVTBIc1VmSzZpeVVOVGVETThROWtkTloxNGZ6NUtlcjNMZkIydnFIaTJY?=
 =?utf-8?B?NE50Um1PaDVQWUtzbzRjNFNPWG9zejNoUEpNTkM3WlQ0dXIwVm8yaVpmRHFq?=
 =?utf-8?B?Zitzd1lVTE5ud2VGUk9hUDVrWTFFc25mcUNXb1dsRldiS3htSkYzeDRoR1dK?=
 =?utf-8?B?TTBJKzVQU3ZqRlAvUEFtUEJtdERwR28vczVSaFQxbW56Q0JIMVpvSWYzQjU3?=
 =?utf-8?B?d3k3d0I5Zk1HaUhzYUJveVhDN1lnTG5GMGsrUmhvdC9jU3FJdTUyT3pkSVRw?=
 =?utf-8?B?WFlBRmhEVmhVTkZXb1dTb3hsWStNV0Roek9LSFFKOTc3a29sSHRpK09lWVVu?=
 =?utf-8?B?TXM0Kzc2akx5TGlNN1FNMFVuN3Q5UXVndkRwbTFjSmZsRUhIMExGdGRodDdm?=
 =?utf-8?B?SWplV0lFREljWmVoMFJ4aW4xeHk4TmFiQ0dnQVZIcnBHNFEyTzZ1UUgwb21a?=
 =?utf-8?B?c3Rtc2tybnhRUEhnN3BPamlOU0g0b1VaZWM0eFpPWnZxbXV4ZUFQMlMvQlYw?=
 =?utf-8?B?VlQ4bmlBTmRybGMzcU1EQVlhaS9ueVliVUx0N2wzSmR1TTRvNVlwVzBLOHMz?=
 =?utf-8?B?akxpRWp2MlRUdFFhbkZZNWVzY01CU29TS3J6Mk51bVJpSGJzL3BOZklKSWti?=
 =?utf-8?B?RU5iKy9KM3dISk11T1pWakppbWI5Z0JLOVpaRVNoNEdWQzdGMU9BWWxla0JD?=
 =?utf-8?B?RGdOZz09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2bf3548-cd0d-4517-dc66-08db5dca732b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 09:20:29.9784 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QuN3bN9tPWaf+Z2gJtRmt72CVyZFKz0KrYSAijpoOV3ePjDzbzY7iO58ZGZswV/wgXeSB9OHUSQR/Ds8okWuBMPFEMBeISwnP7pMSwkMPkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7389
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 2/5] drbd: use PAGE_SECTORS_SHIFT and
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
 "kbusch@kernel.org" <kbusch@kernel.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <BC9476B5D6505B468D2588A91AAB322E@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

