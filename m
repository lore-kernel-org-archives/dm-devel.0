Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F29AC54EBD
	for <dm-devel@archiver.kernel.org>; Mon,  9 Jan 2023 07:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673250195;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6tqXF7LpcI4njpQgNNvmPXT4tk8a2hRPeS/FGh41/sk=;
	b=B3wZkRt0nj7ZhHhAQomCFp3uGOCNUJE837qDU+4Y1pSybVlih0kE4hL4mbqVbwb4WiRvSy
	sTHIGrX5om1XmWtJR/Y6REvvUP1BHfnFRO9lFKE94wWk/G1XKbxJtz2YOkB+hBAGehc6lo
	bD1U5z4hx87bykmJ0t4rwJEDfQlbwSs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-XVlTUbCQOQqkusH88h_nUg-1; Mon, 09 Jan 2023 02:43:13 -0500
X-MC-Unique: XVlTUbCQOQqkusH88h_nUg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7548100F904;
	Mon,  9 Jan 2023 07:43:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3D2C492B00;
	Mon,  9 Jan 2023 07:43:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1BEF19459E6;
	Mon,  9 Jan 2023 07:43:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E12351946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Jan 2023 07:42:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38977492C1B; Mon,  9 Jan 2023 07:42:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30283492C18
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 07:42:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 151AD857A85
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 07:42:57 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-Ia-AEmUCO1qpXUfNLgdEYA-1; Mon, 09 Jan 2023 02:42:55 -0500
X-MC-Unique: Ia-AEmUCO1qpXUfNLgdEYA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB7250.namprd12.prod.outlook.com (2603:10b6:806:2aa::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 07:42:53 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 07:42:53 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Thread-Topic: [PATCH 3/7] nvmet: introduce bdev_zone_no helper
Thread-Index: AQHZIamn2aj4i0XyhES6jLMlPxx0J66VuKKA
Date: Mon, 9 Jan 2023 07:42:53 +0000
Message-ID: <5b6d70ab-c04a-2411-7f7c-37bbcb50608a@nvidia.com>
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1d23de4ad21d0a7aecb74c549ebc7757c@eucas1p1.samsung.com>
 <20230106083317.93938-4-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-4-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB7250:EE_
x-ms-office365-filtering-correlation-id: 8dd22294-75e0-46ab-b7c6-08daf2151dfe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ar4iOVu2LkECF8VMAXCHDCuKPPkb+MFOSaTntG5d/GB3vRh3h6kNS1jRBo08ooXAxwY69fCku7b2QBxM38MepnGtHRVaFY4r5fwK6Gztez+BTh527c8GFeph5bgACnadvO5PtvhZIjcacA2WxB72sPafh036tdACXkDkqZDR7XS1EWqEqabMrHwocynjMWzMnq07r5vSnbcoE4bQvbAI/GcxoW3D8lrAL3C8t/eTgm9d8VhUURnokiQoviLOyeNHkO6BrQ4V22Np8UIya6fvvehdTCFRQ4XCUEZPMqG8US2DaHJHGdAfEmlWCky81BEUN7/gVEOVILoUGoPlcu7bCz6LGO+KbL9Ctk6s0ULWr7cy58L4P/0fcTkVOD3PU50fTMnEqCs1bVdUBfiHN3Ggi838lXxdeNRbn7JnUTymVZDmnQb7DMGPf3qLhzmWHBQKP+HRmhswiPPV7Cqp3iiPQjLt9l2gFHRwNT5CM+ZQPLAcSHVo7ni64WmGilz6gzKCSm3cf2PaL5PvPX0j0IC79mop0IlCmtjvDKOqBLptq5VzZwCrGB7d3z3dsNPvt7E0E593N4VP1w+o29IxKT8rSP+m1MbbN4/POzBIDOJmyBCojyHPXbbmVilYzxthXWQSfWszb4YY8nzoGMiPIRzWNcBn+767Hn6HHYD+OUqUxU+I1FiWvXpEtGcgJ86hb7C9OPiajdaMgUemaKThJdkVwHl6aQBxYRwN48V/3bvESX0+meHYMVmUXKoDDylVGVS1
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(6506007)(38100700002)(122000001)(53546011)(31686004)(2906002)(6486002)(478600001)(2616005)(4744005)(186003)(6512007)(5660300002)(316002)(71200400001)(7416002)(83380400001)(8936002)(36756003)(38070700005)(86362001)(31696002)(41300700001)(110136005)(76116006)(66476007)(8676002)(91956017)(66946007)(64756008)(4326008)(66556008)(54906003)(66446008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEk5NFNKQThUeVg5ckdDeFVzWXhmTURsd2JZczRFeE00VnVMRXFEUzEwVHZX?=
 =?utf-8?B?SEFlRjZYMnhkRm1SMkJ0ZTh0aGhvWkxKZzRDVmVmTEJFbUp5SU1nWW8xS1Yr?=
 =?utf-8?B?UXZYbkU3Q3dPVy9qVEw1azMvSmhYUlZOOTN0cWZJbVJSS2swcnFtcTI3UC9i?=
 =?utf-8?B?VGdkby8yejcxaDFKcmRweTNrbC9DMGVVUGxLcGxQa01pdzdxRHRjeWFlRDQ1?=
 =?utf-8?B?UHRDU3Q0blhFdHFncEZrTGNuamhNTkxGSDROcmJzOEwxWHR6R1Z1VHpFZ0NV?=
 =?utf-8?B?SXNiNXlNU3ovSGpNVGdwT3pSUlYyL053a2l1QW9mbHBSTFhHSFZGRlNIRVVa?=
 =?utf-8?B?WFJXeGdUcGxtM1pjWUJBWFUzR0FRK1NWUkJtTG1VTkRMcjk3YUNHc1pXWExo?=
 =?utf-8?B?Rzh1TU1Obmh1aUtEWnA3VlJuU2k3ZFNtbi9mc1pkcmZZeFJBYTNXSDhBWEVE?=
 =?utf-8?B?SUcxbDVlOVA4Y2NzeXJ2L3pzU2V3aTdQMG9nczhkWlBxOUtjWEx3YUw0emc4?=
 =?utf-8?B?Ykh5TkhybnNnbTgrUDBjNXJGd1l1VnhEMkpTN0RIYW9CUWVzR0poTWpZTW1r?=
 =?utf-8?B?WnhSWFZiL210V1JOVHl0Y3grbUQ5QnM1T3UzY2FhdnQxcGR6TXU3QjFaL3g4?=
 =?utf-8?B?Zk5Qb1d2V0E1RkUxVjRsOEVHd1N4c0dNZ2YreGNKbVM4M0wwdTZkNHpvdDQ1?=
 =?utf-8?B?TGx5N3k0UE96K0RvZVNjSkJrVjJXcGlBbHdFYW1wUDVRL05jSVJRbFUwdTRV?=
 =?utf-8?B?ZWNxMXhKQjg0MVI4YWMwOUdJRitTM1YxTE82SnNaTGhXcnA2aWZ0OGhsSXVi?=
 =?utf-8?B?M2NaaVdCOVNSQWd1dHl4ZXpuUWhCVmVROWhYUDVHRTVLTE5nMUFMZ3VuRUIz?=
 =?utf-8?B?ZnluL29memw1VXZWMitXZVNGUVRpbHAxYW1mK3ZjZThQSDlaVW9acHRoQUph?=
 =?utf-8?B?ZHVqeUNvUXFBbVN5SWR3NERtVWxTeEE2cFBMTzhhQVZlU3ZUM0FmMHVWZmUz?=
 =?utf-8?B?K1dMS2xPdHRkZTBnNUdvNEhzQkdiaUpqT2VXRklaeUp5ZjBhNXBtNEZVWGJj?=
 =?utf-8?B?UkRBcUNoRG9jS0dSaUVPT0taRCtOM05iQkpDM2RzWjFRNWtYbkhRamVZZE9Y?=
 =?utf-8?B?cHd2OSs4NkNNbHhacUMxeE9mamtVV25FdXJEazNWbElRS0dpdXFRallkVG1q?=
 =?utf-8?B?M2JVbTd6V1JONE9UTTF1RE8yWS94SWNHcGxKQStnTmpJSWsvcHA2bkxqZzBo?=
 =?utf-8?B?MDYrdjNkNmZlKytveStOcDIvOWlXcW5wWXhyUlZaRUs3MVNNSDVLdDJjNlVT?=
 =?utf-8?B?TTVtYkNrY2hyRVU0Mys4Mm9pVTFTRmRYS3VXT2U0VTZDUGt1UWk3QzNha2F4?=
 =?utf-8?B?MmhJeVpxZW9Od2p6Q2tFZGZQbUdYdUtMWTdKT1g0bTdvMDFsSm5idDhHT3Vz?=
 =?utf-8?B?b1o2ejEva2xMODlCSy9tdkV1L04xYk03dy9JMmRlTkhXMjhUc2ZUTWtqYkxq?=
 =?utf-8?B?eW5oRXhEQmt0UHZIMm4vOXVyMU9BeFB2Z2JxYUEvT3ZwZUxLZmVwRnFubmI4?=
 =?utf-8?B?WHFCbTZRaW9SaVdKMWx2c2FnNTJuTlR4bExiR1VWMWZDbmtNNFR4T05UbFc5?=
 =?utf-8?B?RmhOOEljbVZXT25CMnUrb1FUUnV1eVBEMHpHdHFiVGI1WjNtK3lFNkhyeEpO?=
 =?utf-8?B?Y0VJM3J5RXZCMEF2NDFLeElMRDJ5VDc2cURJcExJaU91OEUxU0pnWDVoakZx?=
 =?utf-8?B?NWdhbzd2RGI1OERHWjVPcXVFSERrZ3RYRWlhbGwzamI3ekZvZHFNN2Vnampp?=
 =?utf-8?B?aHE3dWRJWG5KNHRuM2xuLzE2ZEdoVGw4Q1h5ME5qc0s4b3FINFp2RDh2Q0VB?=
 =?utf-8?B?QzdLdFJPR1Fua2dmbFcvSHhNTFV4R25JZVAwOHIrKytzNjRoV1N5ZWlmZGoy?=
 =?utf-8?B?MmlYdnBJbU0vWEJXMUx4NTYzYkJIa1VONTEzc0pudlZYVHB3eFo3OGJhQ3Jn?=
 =?utf-8?B?SGJqRU53MTdNeEJRZlZra3g5ZU5mS1pXbUUyMS8wRER3bk9DSEk5a1lKWHd0?=
 =?utf-8?B?MTNlY0lRWEFlSEhIK3BsL2JNTS9TMXAxS3ZMQ0xHNkxxcW1zWkc4NVpzWkRl?=
 =?utf-8?B?c3BsTGlWT0FZNWM2VXRqSS85a05BRFFtL2dpMVBvWlhKakJSL0R1UXdvWUMw?=
 =?utf-8?B?a2c9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd22294-75e0-46ab-b7c6-08daf2151dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 07:42:53.7188 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZ2BkQ0VwuvZ/ey178tEDMfgRwcM4mAoO+NJKHwUrU9bVB6vrcYuokbpv1O3r2NZ3gVLS2ttP0SbCLVuFw3BLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7250
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 3/7] nvmet: introduce bdev_zone_no helper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6BE6FBAD7FCE734483E09D35E9ECF185@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 00:33, Pankaj Raghav wrote:
> A generic bdev_zone_no() helper is added to calculate zone number for a
> given sector in a block device. This helper internally uses disk_zone_no()
> to find the zone number.
> 
> Use the helper bdev_zone_no() to calculate nr of zones. This let's us
> make modifications to the math if needed in one place.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

with Bart's comments fixed...

looks good....

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

