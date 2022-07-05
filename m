Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57C8C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2rIzYSFEHprTYOg/P4pxkrV+s/jf4MhGlUUdhE/UMQo=;
	b=IBVmbjleGm/us8E8Tn2Fnt3jxkCNMdvrNAaxMvrC5q3vjHjz8IyOJKVCjQ7kmA93ryEZt5
	b7GJ/kc3VlASj1JNvwjyKVEsgpXzE4s7/zqU9mN+ARnyRrnKMYVdsdPjWqOZ0b1HhgwCQe
	XyY8phs5sI0ZEw50bVbKrWXkNZjh8II=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-6U2I6L_JPgWg_Vn4DNMyqA-1; Wed, 06 Jul 2022 10:51:32 -0400
X-MC-Unique: 6U2I6L_JPgWg_Vn4DNMyqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 633F21C18261;
	Wed,  6 Jul 2022 14:51:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16B5D140EBE3;
	Wed,  6 Jul 2022 14:51:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2F081947064;
	Wed,  6 Jul 2022 14:51:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 431F3194704A
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:22:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E0784010D28; Tue,  5 Jul 2022 06:22:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 197FF4010FA6
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:22:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01994101A588
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:22:32 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-dIrvOgGmOBmlOC1PY7RRyQ-1; Tue, 05 Jul 2022 02:22:29 -0400
X-MC-Unique: dIrvOgGmOBmlOC1PY7RRyQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:22:28 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:22:27 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Index: AQHYj6PmRQtHxI9iX0OSVg/tgsQVw61vT+yA
Date: Tue, 5 Jul 2022 06:22:27 +0000
Message-ID: <3e073a6c-1fe8-97b1-aaa4-f6ece90222de@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-2-hch@lst.de>
In-Reply-To: <20220704124500.155247-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3083c985-27d8-4071-3a65-08da5e4ebbdf
x-ms-traffictypediagnostic: MW3PR12MB4523:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 8CXFjsy3jm6kUXH/OhNYYLfk41i8YpUZc1qvOjJhyX9tXd+c7fL96TrTvYxtu0cfzcExTj9xis8uuJy1IRnjwEXqsLKHIvWoHHT8PM45lHcdxnSf5Y9JOJvgUaUZ4vmvf1Kdxwe1wj5QaX1wF3f6tylqrzCTo/+Bv4v6AAzZUpgH8fBGHAxFdax4FwAeMxaQoNbwVB3BOerpu+hg1sZq4EPqnU5uqBF6yenScpDDpZzs1ZPPgUFgoIlfbADxwar0NgkNbLsc/rW5vQramuBTXDrLdY11769QRkK+P1wYq3QaED+0Z7c0f2sx1jo9cAdzm/8POLtPyL6NKQyFs2RoFDKeqWg5mS5nji1c8b1Bh4m4TwpQ6XFGOTkf7us0X7WH1Y/5oB8tX3q0R/G1GsSunaJsVbmp5NpgD3HzafVNS+qe/IFkiWQd4LtRq/fOA+0OUfL7zivhpvaKMtui5BxwNKAYXnVFlzYzSbbYfVLEOE/71fqawQTwMlqwL8mwDwkv5n9b8fNZX+J5nOOgdyldwMwInvi1oeteclBjrugTZyTYOk+8z2mgzV8hUOU2gtznMMxu6dkh9twBAWscj9g+LyRu1C9QnNUaEtZ473rqGcZKxFegWBVqLbZWQsloqHlJkCwibCfNLjPhF+DnEattWNySZfWQCaeMcL2DatXT8vdeHrIDaZXRLjo2+Y2At7/nGrR8n2+w+EnnRCw7WvNKF9dD9oIgrP8k3EY7HH0aOD1odsGN7Omjhjjg7rX2TS9mpR9ZhFMu01I+0Sg14XXbgDV4DqoEkHbsk6BaSY5bWFXeUNZ6yVpqAvxMbWxjRGAVYFapA2Sd+cN3DIkdhhjDR1MluYddY6CUo+wD6MgPISvAhnv327nMhVlEVQNgCd94
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(6486002)(91956017)(76116006)(6916009)(31686004)(8936002)(54906003)(66446008)(66946007)(8676002)(66476007)(71200400001)(66556008)(36756003)(64756008)(5660300002)(478600001)(316002)(4326008)(38100700002)(2906002)(6512007)(2616005)(41300700001)(186003)(53546011)(31696002)(86362001)(122000001)(38070700005)(558084003)(6506007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3Y0T0lOUUhqdGdXYmNIRzkwVjVRYmQySjVCZ295QnJlWkE0eXVvUlFMbGZn?=
 =?utf-8?B?Ry9HUnYrUFMvZlY5UHVBNmdmUzgxRkZYYjlZZnk2QnNUcXRNdVlGR2hMdlJq?=
 =?utf-8?B?Z2JlNUtMa3RWZ29CeGZJbWxXRDVQVFNxWUZTTWZMT0hzbU9ETXhmajd1UURO?=
 =?utf-8?B?VklWV05NWjJvcmtvQk9NWW9reGVIbG1wRk5FOUx3SlZmS1pvNXRmUXJOTVdz?=
 =?utf-8?B?UDRNUUFnd0I2am1vejNLNjZSZjNLSWt5dDkwcHZjbFRIaUlQZEx5Vkt1OU1B?=
 =?utf-8?B?cFdqcVZNTEt2Z05wWndLNmJGemdUcURCVGhiV3pneGdzVXFEdlcxSlgzcDgx?=
 =?utf-8?B?QVc3UWxlMDhzN3VPRGxUcEFLRjNmOVhPZnBjZDlPNUVmZFlDbjRmSnNZUTRv?=
 =?utf-8?B?dG9xelo2YUpiUzFoNXZseCtKUWRlc2I5ZXBaUFp3SGxVUkJZZmhVWGxjT0F5?=
 =?utf-8?B?T2ZrVWVKZVE1eEliT096VTJOQVFLZGdROFVmL1V0RURSejJ3Q2tCWDdxalRq?=
 =?utf-8?B?ay9jQWMxRkZSVUlKVFU0SENIVk9XSUNwejg0MElwWU1FTVljUHAwTURnR0ZQ?=
 =?utf-8?B?N0tmYitvYUkvbzc5TUpBVUhvemVIRklBdGFSMndudW1Td3lhRDhTN1EreDRo?=
 =?utf-8?B?dzNidklpQkZhNFdQNkxmOFM3WGl4dzhkTUY5RXl0bkpoK25FMzk1VTZ1Ymo1?=
 =?utf-8?B?OXpXK1pDUUdzOWF2Y3ZPOFFQb0ptUDBOMWkwR2tLeUhiYkkwSFQ2ZThMeVM0?=
 =?utf-8?B?aHBNZWVYUDkyY3IrZ0JxOFY3WHFrZjFlZ2IxZUZvRjlXWEVPYS9OZzZtUmJ1?=
 =?utf-8?B?ZmNBMWttRmhZOVVFZ2xrc29UY21neUhGUStHZ2kxaDd1Y2crNHJ2ckx1VTV6?=
 =?utf-8?B?aWRSNDNGbC9ZdXc2amNvWk9QNTgyeWp2emt4dHdsbmZJOEQ5U0JlNG5JQVEr?=
 =?utf-8?B?TU9GU0tQd0hZdHFIZVpaRklVOWZ4ZWh4cE9rTUtkUUJkZXBtZmFQOFQ4MHNO?=
 =?utf-8?B?cFFodTZHOUxqRER5bU5VdnpONC9JV21hQW9tSHpQU3lkMTc3Y0NxSkxOdjRT?=
 =?utf-8?B?R2FmNW5mK1ZpZ0xzbndHV2UrdTVCWkoyaHgrNmNmOHFXZVFxU2NDQUlqR0lz?=
 =?utf-8?B?VU04NlNYbGRhOHFjcVozbk5UU2FjRmt6N2ZlNzY3aGloR1dhNlkrLzNnUFFu?=
 =?utf-8?B?UGFiVk1Ta0Zic3QzSnNGa3VZbldZZ1Vqb245Y1JnN3ZURCs4YzdwbzRCM0pq?=
 =?utf-8?B?alJLcS9IcGhPSXEybm43RkE4dUF3Q3VYSTk4aUNMczhadDl2NjVtSGIvODlG?=
 =?utf-8?B?YmcrbGcyMHB3dzR3eTYycUJQSGNOWUVuZkJ2ekQ3dW1xR002SUtzZ3Jma1c4?=
 =?utf-8?B?aGplYjlhaForNFMvTERLSjRtcDg2azA0Rm1qeDZGc2gram5aZm51c3ZEd3FU?=
 =?utf-8?B?TWJUZDRCdHdna3dEV3VoajFLdDYwV1M3YWhhR1FpM0t2Z0JBeUZFSXAvc0FC?=
 =?utf-8?B?VHNOdGhwOW1hTDFRKytDMk5FdkwwL3NGWWtncEtoRk1VV2svSUlTaWdwTmJJ?=
 =?utf-8?B?YUdoMWFtRlhUNVg0QXg2cmNhMllybHI3SnYzTmNIY0hsWXZuM29vNThuV2xH?=
 =?utf-8?B?NXdPaFVWT0FCbFh0QmE4M1E5UHpKYzVMY0l0RG9MMDFvazZRV3h0TjhWWFRE?=
 =?utf-8?B?MFRuVWRoaTR4Smd6QVo4WklaM0ErZ2o3Rk9LV3RRdVhvdUVGenZFWDJzdGlt?=
 =?utf-8?B?Vy9Ya1JFNG9nRThIekd4VGlDd0MxWDNvYVhiaWdObm13TVMvOVZIRHdRTzMz?=
 =?utf-8?B?bFJzRjF1TGtVaWZ4aHN5K09KUmZSYTc3RlgycXR5L2dZQ1BHUk1kdzE0THV6?=
 =?utf-8?B?Yndzc2VpcFEwYTl2VnRLMDBqNFZsZnpiVnljL3JKWHNMVjgreHRXWHR6SlNx?=
 =?utf-8?B?Z1ZkNVBWK1lDT2NyM0NkU3M0SEpLUEZmQ0dpUGtnVDR3M1hyTkJJR1I2bEF3?=
 =?utf-8?B?ODVQMzF3Rk9BRmVjeVlRK1Z3ZDNVUTkzR09veHgvUzltc21LZEt2UVZSV3Jr?=
 =?utf-8?B?UjU0TmxtdXNJT0tYRnM2dXdUcU43MGRHcWRqQVFiWmFKS3hjQnZKalVMd1hu?=
 =?utf-8?B?blI5VHZpeGF1a2d3WDJNeGpaemEySUo1SVRRL2JVVFMvcHhCWWhGaUVic2Vo?=
 =?utf-8?Q?W7udhZoXlQVYXeJ0x0QhfdH7KxUK31VeADlMvgy2Lgks?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3083c985-27d8-4071-3a65-08da5e4ebbdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:22:27.8619 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEY/SedNJ/JgaEFL7amrHfr+Z5cmkgOAKBEzstUK9MWLu7XaQo6gWcGGxNk/ImOS5brrFAedRLuIVd5ekU5DEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 01/17] block: remove a superflous ifdef in
 blkdev.h
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8D2D1A4017B4EC4DBEB5E6A0EDCD5DA1@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> It doesn't hurt to lways have the blk_zone_cond_str prototype, and the

's/lways/always'

> two inlines can also be defined unconditionally.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

