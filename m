Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1066C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:18:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-po8vjj5JMo6Unc_O5cn6Iw-1; Thu, 10 Feb 2022 03:18:33 -0500
X-MC-Unique: po8vjj5JMo6Unc_O5cn6Iw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FAD51091DA0;
	Thu, 10 Feb 2022 08:18:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 668F673153;
	Thu, 10 Feb 2022 08:18:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 985E01809CB8;
	Thu, 10 Feb 2022 08:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198jNig019570 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:45:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 29FCAC080A7; Wed,  9 Feb 2022 08:45:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25533C080A6
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:45:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C8D42A59544
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:45:23 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-338-uZ1c_f4iPFixMYCMj2cPSg-1; Wed, 09 Feb 2022 03:45:21 -0500
X-MC-Unique: uZ1c_f4iPFixMYCMj2cPSg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by BN6PR12MB1346.namprd12.prod.outlook.com (2603:10b6:404:1e::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14;
	Wed, 9 Feb 2022 08:45:18 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.019;
	Wed, 9 Feb 2022 08:45:18 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"haris.iqbal@ionos.com" <haris.iqbal@ionos.com>, "jinpu.wang@ionos.com"
	<jinpu.wang@ionos.com>, "manoj@linux.ibm.com" <manoj@linux.ibm.com>,
	"mrochs@linux.ibm.com" <mrochs@linux.ibm.com>, "ukrishn@linux.ibm.com"
	<ukrishn@linux.ibm.com>
Thread-Topic: [PATCH 4/7] sd: remove write same support
Thread-Index: AQHYHY8T9jYrDC5SwEqmFQpmV/XMQ6yK55wA
Date: Wed, 9 Feb 2022 08:45:18 +0000
Message-ID: <b38fb139-7c66-d69d-1194-d07ddf6daee9@nvidia.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-5-hch@lst.de>
In-Reply-To: <20220209082828.2629273-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 826949be-8ff3-42dd-970c-08d9eba8803f
x-ms-traffictypediagnostic: BN6PR12MB1346:EE_
x-microsoft-antispam-prvs: <BN6PR12MB1346F8C9DA348D81164BCD2CA32E9@BN6PR12MB1346.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:205
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jfriHkzZbGtwr+prq/sQ2TTFy1CDsfFaiUGoLyGFcVQWrcFaQ4TtjFEccdMlqsvYYX7w/vuJSsKLhZZTw300AEsautWmGwPEigCpIfwxNmJSy4e6PyCZyCZjWZAw76NuBK6mlTyFS0A36YCZEq69NiOJRzEBlF5tjnRfZ5Ul1IpfRUU30h3yv6r+7+l3InubTxCgVQ0FEPCtfNzHYsYoJ0LPlAncAiXpQgxVi2NKPwQSGHQlAv34v/IQC8gFQ71A7ZO1clBfwr0OdkmDJTtO10dlvRypWalDuENdcs+wjzxMLsacA6oohdE0LXK9giBuyV/aEaG9aCqF6RZPwyZhRB2MyQc0RKYIIPSpjBmlRQBM9ElAFpsLNjWNnbQVlJuVieiiH8fvLrjWleLQrX1xTvfD1bF3PuB3MBg9aSTCaz+P+fiOMNb1znclWCL4K2tJuacp7Xj0MftaVzRHc/VQgxz4hA5lVQLemeMPwygjieDPpl1NGwiTxbveNv+nR0UPzRw3rfZg2+FZFBAuAWkzf1g0/L1g4F27eOAjIOGIrX/NkpISyka0ueJzvTEZON/oPXoxpK6eHJa1OcUGK5+GQ24nek/4RKD1ZTWaiYkrVPF2K38Nu5fsmJj5xzZ2gRno5TsUc64lAUQeh0vb4TpdDUVkBDT3vTTOhMyJFqCAGVJDCZfclgwmdD75ifCJVLkp+fBrcDttSuRxUKE4pmwUWpHOEIP1F8rEq2MncSvSeW30hI2x4ECiIOo2d/cA2YSmZbfZEHcqgvpBSJrcz/UuMPxwdBKU4CqsugrNuBBsVfA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(54906003)(110136005)(122000001)(31696002)(38100700002)(921005)(6506007)(2616005)(8936002)(66446008)(8676002)(66946007)(76116006)(66556008)(66476007)(31686004)(316002)(64756008)(186003)(91956017)(6512007)(6486002)(508600001)(4326008)(36756003)(38070700005)(5660300002)(7416002)(53546011)(2906002)(558084003)(86362001)(71200400001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXpWVHBPSTVJRDZwV2Q1M2pFTitKV1JqMHFtU21Fd1RGZjEzSllvK3lwR1kr?=
	=?utf-8?B?SXBJekV6WjRoNHpwTU5ZT2pBQlgzNE1lWm9NOG1wenU5ajRGK28vSzNTQjdS?=
	=?utf-8?B?dTJqMW50WE15Qk5QRE5EVEhIRGFYN2ZMejlPZWZ6bnpLM3U5dHloQStscjBF?=
	=?utf-8?B?b25PKzBSN2tpMGIzWElEdXJWd2JJaGNzbFFjdm9IVlhRYjV4bmh2bVJxdFZq?=
	=?utf-8?B?b29BZEdjUk85Q0Rwd3N3UmxzeVh5eGJscnI4QWhrSGZhcUthL0xmTFRFM29q?=
	=?utf-8?B?Z09FWWJwRmhnWlcyTnFFUnFERlN2T0N6YUlheFFVdzNHa0d1V3poOU9rdnVM?=
	=?utf-8?B?OUEvNmJxVzVkL0dySTIwZjIrbFFrSlFuS1p6bk9LOHJGMUIvSGRsdFFpMHpn?=
	=?utf-8?B?Rk5kSHNDUW8rZVNseTljalBuczZnY0w1THhoYkpkbG1jNCtuRzBWWVFqRFZF?=
	=?utf-8?B?dFlmbGpYK3kreGdQSHFqTzJQRTdZeHpZN0V2bHRHWnVCVFhvY0tVQ0VVS3RN?=
	=?utf-8?B?aUtOaXRDdFV4dVVzRE9MTjh1d0lWUU9jcWp0UkhpdTVGUTB3QTc5YjNqSGxF?=
	=?utf-8?B?aUo4bC9FeC9wZWZhYU4wMHpVVHBMN0YvNUNFM2U3WjU2ZGZvM3praUE5ZnEr?=
	=?utf-8?B?dUdKNnlCOWpmem1RUWx6ckFmT0laNzZMVGZnSnJ4QzlraGZQVitBVWtHd0pL?=
	=?utf-8?B?WnFGUmRNMW9NbXUxcldKajdwNDJRZnYrTldpd0QzZlZBblRVcUNRR0grbXRz?=
	=?utf-8?B?V2hnWlhjcUVBbTRvblZOZ3QyN0Zib2cxRnhuTTVSQWk2LzFORk5Va2FGazNx?=
	=?utf-8?B?UERHQVlmWnZUd1VkcjI3VVhXLy9qUW9rSy95dTVFaURubmhvRUR2RHJNankw?=
	=?utf-8?B?Q2JpYTZ3UXQvL2FsU0hZZzhmQmtySjhwd0hDUjRpRDl0ZzFqZWh4aHRaMEox?=
	=?utf-8?B?L0ZUTnhBMWtCblZ6VjdqMnE4T2s1eWowVW9FbVN6dFk1dFdzbzFRL1lGbEZE?=
	=?utf-8?B?b2RvdVFjMFpxbSttZXp4VlNBWU5CTG1MMnRIMm4xVkxwaVRpejFxTlBSV2sw?=
	=?utf-8?B?TTNIdzlRVlM5aGhQMUpGUnRIYUUxcmhBT0VKUjF0UUw3NTExWVJyZm9IMUNh?=
	=?utf-8?B?YVZiQS9RTzcxTHJTWU5IVVhLdTNzSUFWUUd2dWtFMVhraFpqbTNwckdtcm1T?=
	=?utf-8?B?b1VLUmRJdVA3czBRT2k1aTkxQy9ZM3RTczhXbFhGcEFwbDFQelJxaWtPQ3Ri?=
	=?utf-8?B?dlE2T25NN0RKak9mbzdVZlgrWGdDYlpOdnFOMCtrVzA4cXdCMllmT2xTVTNZ?=
	=?utf-8?B?aityRVVVODlSTExUSXljb1BaUFBJa3VxUElTdE1POGZDdTVJNHNvdjhJNjRp?=
	=?utf-8?B?dnE3RWJGdFRGMGVVenBRYUVUODZ2Y3ZxOUJCa3JqNVNvVXhraVhrWk1Sa2ox?=
	=?utf-8?B?aWt6ZS9nRkphWUxHbzI5STJyRlVjb25jV24wSGxwcTBsTFNDMi9sdnFyMnRo?=
	=?utf-8?B?dGExazZNVE1aNzdMbW1aSURYaDU0NHU3SUlwSzI3bDcwdzZKdlpCRUVxWkR5?=
	=?utf-8?B?TjBDYm9sQXRqaUxESzR1cWdlaFRqUm5FeGxyQ1RtZ1NvUzU2b0R0UWhVcGJM?=
	=?utf-8?B?WG5qR1NCMU9UTkpHUGpmbDNmQ1dwUiszejFsSHZMUUhoZjVveWVDTjNnWHlC?=
	=?utf-8?B?bzJuNk1rUkZjU0NiOUQ3cWFhYnEwRGVxejR6TjNDSFVDbHByOXJhQThQc0lr?=
	=?utf-8?B?NHpkSlpkM3RZTkk0dW5oQ1BDUXUwWXM2T2l5aithMVdKYjVMTDBNY1kxVktC?=
	=?utf-8?B?TFY4WVAvZmozK1lYN0dmbG9DS0pUUGlWUDhrcVpDZWVjakJBalVtTUtLUWxk?=
	=?utf-8?B?WlE5alpjSW92b1dOMWxybjBEZnJIaW1HWVVuMXdHRW1FZ1AxRDlxR0RJOTI5?=
	=?utf-8?B?MkZyVllDTld1L0dQa0xxWDc4dTlpWVlsdlRac3JvcnhUL2ZLMVVibytNa29p?=
	=?utf-8?B?bUVLc0FNN2RteGpIdnFQcVBIMjAvN1F4UXRCZGR4ZzZORjcwY0Z4c3pYeDE2?=
	=?utf-8?B?TXcxUnViNERWL2l1YUJZenBzMTFFR2RlZTZDaEZmTVZJaHhheGNoRjl5b0xt?=
	=?utf-8?B?YVlvQVRLM3l6cUtaYzZnVmxWQld5MHhPckE4SlRDWUk0YkEzYkNWdVBUdVA0?=
	=?utf-8?Q?sVw5/MjX0QyD+ZelM8xMazC+vJogGd0q8SkgYJcoC/9D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826949be-8ff3-42dd-970c-08d9eba8803f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:45:18.7695 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M53i3zyy9ZKJzV2SQm+PXGStGdDSJotsDny5mqo4xq4eSqwLkZvXDnE0s05MSDUqiAk67utBaFDTSVGa+RvhOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1346
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2198jNig019570
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [dm-devel] [PATCH 4/7] sd: remove write same support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <728216C443012546948E7B66E8FB6572@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/9/22 12:28 AM, Christoph Hellwig wrote:
> There are no more end-users of REQ_OP_WRITE_SAME left, so we can start
> deleting it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

