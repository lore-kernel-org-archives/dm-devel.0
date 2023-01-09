Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 409AAC5479D
	for <dm-devel@archiver.kernel.org>; Mon,  9 Jan 2023 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673254595;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/x8vGhp2rSg70WIPJ4ZB7hoOex0ZwYg8dPptZS41YxM=;
	b=C2puCXXVHh8aax2bHwbXBVxjmzFJV7K3SJ11m4Ci7c2UBzt9uEJtu35o9ziTuolIoLnQwp
	g2CuNpoHGK5eALLtksBGgM8OKYnaEdoPiPTKiyZiTxdPuibOdlCo11J/kcrUFCFuhX/9s2
	jIAVtL1Ny1Z/kYvc6HdAkRKV3zWY1h0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-B2jLu3-1M5Ca7cWPlOfTeQ-1; Mon, 09 Jan 2023 03:56:32 -0500
X-MC-Unique: B2jLu3-1M5Ca7cWPlOfTeQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 485641C0754F;
	Mon,  9 Jan 2023 08:56:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 076B2492C14;
	Mon,  9 Jan 2023 08:56:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA86A19459E6;
	Mon,  9 Jan 2023 08:56:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32DF51946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Jan 2023 08:56:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1FD5B492C14; Mon,  9 Jan 2023 08:56:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 15202492C3F
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 08:56:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ADF53C3901C
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 08:56:22 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-3HEj4R1fOVqrGwfh6x5HPA-1; Mon, 09 Jan 2023 03:56:20 -0500
X-MC-Unique: 3HEj4R1fOVqrGwfh6x5HPA-1
X-IronPort-AV: E=Sophos;i="5.96,311,1665417600"; d="scan'208";a="218618577"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO
 NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
 by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2023 16:55:16 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH0PR04MB7971.namprd04.prod.outlook.com (2603:10b6:610:f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 08:55:13 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d4bd:b4ef:5bff:2329]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d4bd:b4ef:5bff:2329%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 08:55:13 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Thread-Topic: [PATCH 1/7] block: remove superfluous check for request queue in
 bdev_is_zoned
Thread-Index: AQHZIamszurSCek3k0urRtU5la86Ia6VzNcA
Date: Mon, 9 Jan 2023 08:55:12 +0000
Message-ID: <be10834d-4c25-d9bb-d942-445f60174159@wdc.com>
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038@eucas1p1.samsung.com>
 <20230106083317.93938-2-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-2-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH0PR04MB7971:EE_
x-ms-office365-filtering-correlation-id: 89e26737-e324-4e43-c841-08daf21f3867
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EWaqfbXaQ3ME0syttvqV0sxMZLNhGzFBTnb96DyhTIOxWX0kqd/YMc/kKVf9whO+UOvwytvMUD3z4wOkOgbuNQ91xHk1XPztJMZiFW3iUuObiFYugPYkj+q3LSHFfNKyZx+OkY8wW7Bd69AIZ5pF8KgozhQOu+12BqhWjxvdN/m+WMXwIyk/M0XuMMnVCsdgj8NImjcVUBEi18gRf9UNhBGdJ+GWGuu7PvLLuMInXFWR+1CLDXcY9ZD4NUOBhCdkMj3N6E8JWf13sjQCSHXv/Mgc3f99Oi2ITcSF/plO3pXYh0G9OBinGnC/383QtePh20aXEXKM25U114+z5YSYrG6M79xDtoe7g2vF86y/sltOiFaZ8u2maKH//R6jB6roYE4+K83/XHsAEUcEjAx2jy7nc6qXGr0ofnlPB7fIKj6iHlRARFbB1jhQmt6faTkj37EMH1JbyYWQOyJF7C0dnnv/fEKnJojmlVkn/gw58thODBeKUNRcI7EN6Cv7VSUeWD8ktDwXTmwDInYmYZZasKE/4eELO8/q81bFFvTx0OgfUP8iQ5Dx3qRc19nUrDz2f+8Sll77vr/+Dp0ixpauzhDdylYGEq9tRuhEhFVfoZAbwabd2bhq3Qh6t7qT56LDoXUEjbxpBx3KfMP7SZmjsE9xqiQu1g4Pfvyp6T+wQ+NQTaJQ9Q0pjPuqpx1KUvAQu4IZHtLmCdO69QsAZoi7SpTx+LtOK2vKqo78t1YpEW4BtDfZYQdkbfptexkPt2jnLgfs+Nk8ms3bN+Yfg2D1LQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(36756003)(186003)(53546011)(8936002)(122000001)(6506007)(6512007)(2616005)(110136005)(54906003)(5660300002)(66946007)(7416002)(66446008)(66476007)(66556008)(64756008)(4326008)(91956017)(316002)(86362001)(38070700005)(31696002)(71200400001)(6486002)(38100700002)(76116006)(478600001)(82960400001)(41300700001)(31686004)(8676002)(558084003)(2906002)(83380400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjFPcmxDTzEyRHZncCtiN3pZVXJ3cTNPWGxQcHV5N1dEdVlDUElyeWZSdWRN?=
 =?utf-8?B?S1pPUzhGK2NzMWNkVXFXR0NZZmZyUXVmUFYyMVBUL0ZWc1BrR0k5WlV0VFJp?=
 =?utf-8?B?Sy9ITG5STlFHenV6cDF2Z0M4Q2RNajg0b1N6bkEvNjNQOWlmYk51bXIrZzJv?=
 =?utf-8?B?Rzh6MjR6WTJPUjZJUUlpb3lYL2d5R01pRnhiQUd1d21MRXhOa1RySVBZRkYw?=
 =?utf-8?B?OW16djZvTUFPWnFISjhHaUdDL3BkVmZQNjRrdkcyeE1tTW5jZWF0RkVEa2ds?=
 =?utf-8?B?K0lSVHdySldiWUtzWUt3Y0lUMW9aNWF2YTcwbzFjOUFzc1M0VG16MWtqVG8y?=
 =?utf-8?B?VE9DOHR2c2lWUndMSzVDZlZDbGQvVEZMa2h5OWxTRE9jZXRVRzB0Ry9UTHVu?=
 =?utf-8?B?M2pkaldLZnhuSWltOVJRSXluOEJRSFdXVUEzQXphQThodmhQRjBiVHpXNjM2?=
 =?utf-8?B?N0x3WUJkd3MyU1RMWkhMamd0aElOVzVPc2NVbkFVZmV3cE5iUE9FeEZzTTBz?=
 =?utf-8?B?NnYzN1llMFlxUGJjQlpNTE4vMENBMUE5c3I0T2x5TEVYd1hIR0liRUdOQTRB?=
 =?utf-8?B?K2F3SnIxRTdPbjRYcThpRExIa2s1a1hNOWZGWURONzNKVlpNaW93MVo4bFRQ?=
 =?utf-8?B?ZnZ5NURTclBJN0xZNEV3QWJGOTVmUzBZUStKOU15U00yb1kzQ0hDWkh5TEdO?=
 =?utf-8?B?S01NT1J6UWphZzVqekZSZlZROFQ0YzlwVGVrTkhOVHFpSUpYSnB5eU0rZHB0?=
 =?utf-8?B?clFNcUw0c2I2Um1Zb00rL0hmek5GTWF0Y01rakY0Yk0vWGY3c3FrSFFNbCtn?=
 =?utf-8?B?VnVncFIvZ0dRayswYlpPbjBNT0NUYXVPTkFQOUtsczBYcnJvak02ZnhFbERt?=
 =?utf-8?B?WkZDMGRtVDVXdEthanFPRWpZMnIwSzNaOUJSZ0VDU09sb2tHb01UdG9pZ2JN?=
 =?utf-8?B?VjJGMFd3UGRDWGpYNlA3MFNGdHlYOExYVmFUaUdwT2pXaEFoUWM0OE5kd1BV?=
 =?utf-8?B?azRZUzJOQk9ScXBjZjJqbWEreDNBdkZWbFBIc3hBbElPdWkrQ2lyMVJRWm5i?=
 =?utf-8?B?QmtoNmhZRVErWTQzOGU0Y2VQb2NmS0YwT0dnL2hOYWoxZlFRY0NBQitKU1VE?=
 =?utf-8?B?YmZFc3gxelQ4L3Z1QWVTcHZTOGJtRld5VWpqaVE2MmxWMm44VlJjK29oNUhZ?=
 =?utf-8?B?NG9jYXNUUEdIOWxIRGM5UG1tT3VmZTNhSkE1MEdCYjRBcjVZa0p2QkRRaWsr?=
 =?utf-8?B?Ylpnc3plRmtyWUlRSnhzV3FONkl4b055R0xnVnBRaHEvdm1lRy9zVkhwVHdD?=
 =?utf-8?B?cVhaNVhvTmxnQXBoMU9PMnI3RVdFZktiZ1Z0ajBQVEw2bkZoMWxzQzBTaTJ0?=
 =?utf-8?B?M0RaUmN5aFdaTFoySk1CakJsaEJiaiszcVNGWkQ5TEduUE93aUlTRHFCb2xU?=
 =?utf-8?B?MmJwZ1YrNng0MFIzZXc1QTZ1aWNEUmp3Y2Z2QlNPanJ4Yy95QWphUWtTRXJw?=
 =?utf-8?B?ZDRldDJrOVNzSVl1dk51eFlsd0ZsSHFHSTJ5UDBtR0VhMnYxU2xQTy8zQklN?=
 =?utf-8?B?WGVBaEloOTIrSm5ZcEpWcFZqbVB0aURxOXA1c2xidmZCSDMvMndnQm1YTTRT?=
 =?utf-8?B?WUszWEdUQ1VDTHVyUkpEd05HMXFReEdhd1YvejJFTk5Td0J4RSswWnNMNFow?=
 =?utf-8?B?UlJ5V0JRVXpOUURRUE5QUXJRR2NtbkNLc3UvSzhydWQ2cVUyUlpGQVZZSWt0?=
 =?utf-8?B?NmJlR29NQWtQY3NHNllucWtIZHg4MWY3WEFOWGRGendxckM5SEZCVzIxTUdZ?=
 =?utf-8?B?WjYrREI1cWdhV1B1MjRjNkxrcDNvVkIxZzJ2SnZaY0ViMzNDSnJkMjFQSTNr?=
 =?utf-8?B?TTl3aHFtMDNwblZpOXlpdG9UcGM1WlRqd1VaZVpTRk1saFNCMnZFb29tN0FG?=
 =?utf-8?B?ZDNFSlorVFVKenYwMEE3dzhJODdrV2dVd1BFdzdmKzdRU3B3MnR2L3NNblhE?=
 =?utf-8?B?aUtuMm9WaDdxdXV6WjlBUUN2bjNabFhWeG5nTVBtNy80dXNybUphM2VJWUNu?=
 =?utf-8?B?aHZrV0xzVGhFc1BFZEgwdkNmU0Rmdm5NNVI1akdRc1JjMzlZZkE0SjlYOFhF?=
 =?utf-8?B?d3VLYXVyOUE0RFJYc3hEWWZhdFRMb1AyclBqUXh5ZXkvR2NFeUZLV2Z6VUVF?=
 =?utf-8?B?L1FaMU9IMWs0SXVGZGZDTHhTUzJCZUdpRzVpZWZBZE9FKzltTDBhT1YvamEw?=
 =?utf-8?Q?5HdvZXL1utT54LL1Gcx4Qr98haz7v3K6rSqeV7ZYDc=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OUlzMHZtWWR4Q3Y1T0k1RC8ralVMZDEzQ3F4bzhjVnU2dHd3bXAxK3lrRTRz?=
 =?utf-8?B?NGR4UjJBVk5NemhxMWNJVTMrUFYrYTFGN1RrQTZ1ckVWbnpwQjNoZzY1ejdK?=
 =?utf-8?B?UXlOTGZBM1pRaUwrK05WQXp0bzY0VGQwa1hYa2cwckhmR040RHg5aW1UaHlG?=
 =?utf-8?B?NkxWZ3lZREJsRksvVnhXZjNUMHhLT2cyQlRKcEhVd0ljcFloQ21tZWhzN1E1?=
 =?utf-8?B?MFk0UmdmRXlyeXhiQ1loRC9YK3lGcVJxdWRUMzc0U2hCdDh2b1J4R3FRUWs4?=
 =?utf-8?B?NGJvcnJYTHNEVi92ZHkzQmcvcGYzdVZ2b09UV0FYTUJjYzZjWHRHeXoyUDJU?=
 =?utf-8?B?aWd2V3pPL20wWVFJcXRYTTNFR0dGUHVWMDVmN1dKdXlvRmhxOEpqWDVrbE9G?=
 =?utf-8?B?WnlGQ3k4YUV3ZG9SV3k3QWVoTXVIUzlxLzhsYTZLVVNtNEZGUi9OZXZSNG1K?=
 =?utf-8?B?b29LdFVNaFo1UUVPbVgyWjhqc05qZjR3SllIYlhTdFZ3NTJ3UlEvRGFnc2pN?=
 =?utf-8?B?ZCszTXZlNnNMaURiMjA0V2Zva2hVVHNPcmRMZGZkK2J1cHU1TmlPOFUyVXUw?=
 =?utf-8?B?djNNeTcrcUg5UGNqRjF6aUtDMDJod21DV2xtWDlLR3o4b3ExMDlwQlg2Smd1?=
 =?utf-8?B?dGZIR3JmTG5nZ3E4TkQraTNxSm5Ld3hZZmlVd3hRdUE5eUY4V2gvQ1lKc3pk?=
 =?utf-8?B?dSs1ME9OdUlIbGxJL0RLOU5VZUtOZiszZGFtcFZqL1grSWVycUl4V2tVbkNs?=
 =?utf-8?B?ZHl6OFhGU0NoTlBXR1hXMll5UFhPaVgvRWtVTUpEMy9HbnNWMkhabGJTajBG?=
 =?utf-8?B?UlRObFR0VHI2TW9uMkUyMERacmJtTmpvaGt0bU9iOFQ3K3JreDZNc1l6Mi9E?=
 =?utf-8?B?MnRlS1NQbGwveXFockFwb3Zabk96MWFTNHg2M1BOTkZoMVZHekJMbjR6VmhS?=
 =?utf-8?B?eGFSYncxY1kvREpmSkFOY01lUC9GWDlHdkdrZE5WcmpBM2ppeVBiRW05cE5T?=
 =?utf-8?B?ZVZYZC9ON2psaTI4WkMySEk0Q1ZnVHM4OUVkeU4vK0xNWVBKc2F0UStRT3Y0?=
 =?utf-8?B?S0pBeTdJaWJ1OFBnZ1E3ZVRnem51SzFydFJxUks5VHNhdDlIUG9KSEI0N2Nq?=
 =?utf-8?B?WWN2RnNyRTZNSy85WW01MEVtalZkMnJLVEZVR0lYMmZGaGVjZ0trZ2FvenNE?=
 =?utf-8?B?RWRPWEt3SFdFMm9oRk10RjhRZFhmaWZyN2VETnY4L2RDMCtRWGJ1NWl6YjFT?=
 =?utf-8?B?clpiQlVYT2w1YjNPTVV5dHFoWWp4aTdITUNJcWRNKzRLSlg0Wk4zNkJhRWVR?=
 =?utf-8?B?T044YlJPV2RuVmtwclVhRkZXZXY1SzRrNWxXL0RiMkJQSkZINFAvNzhTcHBk?=
 =?utf-8?Q?45+Wah/VEUmwkWTsMbB6BkhF3/l/Yqt4=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e26737-e324-4e43-c841-08daf21f3867
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 08:55:12.9954 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Xx/hNI4CaeZJil//725KbEzXuABiBtxz+z1Xoz1wXEAnKxrvAbsnExFHUj0qIQywCpmbC7+77qqiDKXg2tqEDuAB8OoFerb5aSVnMKkN2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7971
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 1/7] block: remove superfluous check for
 request queue in bdev_is_zoned
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
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "kernel@pankajraghav.com" <kernel@pankajraghav.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <793D456AC31B2542B08285BEC0A9F7E2@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 06.01.23 09:34, Pankaj Raghav wrote:
> Remove the superfluous request queue check in bdev_is_zoned() as the

minus the last 'the'

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

