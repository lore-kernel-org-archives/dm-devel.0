Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11303C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119100;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Un8OYaDUmzafHUvNqJ6hpAFk/t0jcX+ap4mrZZmqAIs=;
	b=Q+8KqfpUvBQnd+JLViMVrhAK2gKoI54xJYFj0j97CTmwXzzgkk7lQPX+1pdLyXLQUWanH3
	y5FVZWFkxOc0yAWVgd7F+6ct0GN0+yeXoy2kf9Er/Fa+9ihAjGJimsuAQV91TjUO3uid4m
	OOyLqCYIUtckpGEVNr8v3fMppc7qFwk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-dN24j3FkOrOnBx6makIsYQ-1; Wed, 06 Jul 2022 10:51:32 -0400
X-MC-Unique: dN24j3FkOrOnBx6makIsYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42EA53C2F76E;
	Wed,  6 Jul 2022 14:51:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E6CA5202E4A1;
	Wed,  6 Jul 2022 14:51:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4FEB9194706C;
	Wed,  6 Jul 2022 14:51:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87B56194704D
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:44:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B5D440E7F29; Tue,  5 Jul 2022 06:44:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66FAA40E7F28
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:44:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E937185A7A4
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:44:47 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-FuM2unU4PrqlwiI9FPcKCA-1; Tue, 05 Jul 2022 02:44:45 -0400
X-MC-Unique: FuM2unU4PrqlwiI9FPcKCA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 06:44:44 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:44:43 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 17/17] block: move zone related fields to struct gendisk
Thread-Index: AQHYj6QRGzRPu2/7Z06qocsraRie/61vViSA
Date: Tue, 5 Jul 2022 06:44:43 +0000
Message-ID: <b57984f5-4a9e-3fc1-ca6d-ae9987250780@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-18-hch@lst.de>
In-Reply-To: <20220704124500.155247-18-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e97e9a79-f062-43e4-ade7-08da5e51d830
x-ms-traffictypediagnostic: SN6PR12MB2846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2UwKVUpB72RqKXz5y7E4+pKzwc6tc7D/htlYxdwRivtmDY1pse/AuM9MTyxHXo+kzCIvuhNLMqNUhIvjNAOqDfsXdMd0pWTgwM0SFgQWgW77RAe1lG2IGr4zQhBec0c4L8ow1ChR4YVXhikWsFH9IN7oIdPX0YuNmyiDXP6Nto+/9UmGroqxrSAumQl1DykDva1bxn7guGXZHeRiTNakgppeHDTP9+KnrGdyWwpyUszZNz4L/owEjIxVukN7Tqu8KP7APuadvnhmK4ypeh2JBwK26UB792xPGFFEJv3y77SWMFMf9QUC4WNXfdao9yAC+kcDpBLasdFB3SY929NwK+0C7yu+6tWzrNy2WXZjY33e6fPzuVhtd3GaU14mDWSQNPCZklsnztXBpTTRRcBKqgF/p14DzwuON7rJz5Gd0u8uEX45eogdgQ5FdOZFlPpp94K/if4MylNAeKeP9vZ9rn1FuCYQIYtu9NC97WMumC2tBlPXJ4qAAtOB7jZhO/JrgZrp/BahUpsMJ5/YM+6EZFblwsGP5xsSbDEJTkNeEC7H9eiBL27ZrlP+jWoWT2RwMTtEONygz1XyHOMOZamfsZqwzmACrJ9G/Xeo2UuW5ULQDCo3fIQpJphnYL4J6Wg2bnXwJBXeGGBt01rQiM+/bFdDAsroNjrpHTYWQ9KVSUy1GOnYcD4WZsJOzT+yln0DQMG3qEAlh1o/QC4LhvuesN0i3xjo+Pd0U1APTRuB0owUxdz6tvdNvVaL9ILtoxoX+4RInyahfXCtJ5ump57CXuhIrUKMYA80op1zEsz0Ghfv3/0VbsX9IhhP0DFJQkMNPeHh3KF9vaLA5ILXpwRH1I7s/jt4aqrZcOv9KQZnNk3doWpgp9/M2XLJXBBCmVIV
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(6512007)(53546011)(71200400001)(478600001)(2906002)(6506007)(41300700001)(31686004)(4326008)(86362001)(31696002)(36756003)(4744005)(122000001)(38070700005)(38100700002)(6486002)(8676002)(110136005)(186003)(2616005)(5660300002)(316002)(54906003)(8936002)(66946007)(83380400001)(66476007)(64756008)(91956017)(76116006)(66446008)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTA2UFNEVDlKTDRtY0dGRE5xMXJ1SFdqcmxNTlNjcWZURWFsSC93K2EzbTIw?=
 =?utf-8?B?NVFMUzBEajdoczluaDUvNE8yT0lRU2I4NjYva3FKc04vL01MVHNyeVVlVFNI?=
 =?utf-8?B?TW1hNDNJRVZzTTNaUFp2cW5uOXhtcVI0ZkJvOVdqbG9BTGlKcFM3M1ZQZHFZ?=
 =?utf-8?B?WXQrQW9tczZwK3J5dUpqZThWczg3TlVlUUd6S3kwQkZmcm1TVnE2OHM4bFQw?=
 =?utf-8?B?dStLVkY4MlRHYlZBOGUxNXluZ0s2OGpPTTFETFRGK3g3cVY5OStwczR1MExV?=
 =?utf-8?B?QkMrdU42ekRsQjRGdFRqUncxeDhzbXRMczlCSEFPVmtjRzdTRmhleVZzNHRa?=
 =?utf-8?B?bzhubU9oQ3RVWm83anJLNnV2a3FNdkRab2lrK2JIZHNTMnBYS0daZEFmYXF6?=
 =?utf-8?B?RXIyblllbmEyM0lKREcxaWFINGd6UnR0TlIzT08vVFU5NHY0OEsvZ1gyR2du?=
 =?utf-8?B?QTBpRWRrRzFYeFVqU2dDdlB6NzBpUHl3M2FVMHJQbENCQ0d3bisxcUZabXB3?=
 =?utf-8?B?UHppS3lCRmpYYUJmVHFpM3E5UHc0aU5xWmZqZjRQWkMvZTRBY09tOHV2ZVFB?=
 =?utf-8?B?alovK044alNwNG5zUSt3Ukord0JNaVh6NnNHOUpCRlJPSWxoTE1JRWhqMWx2?=
 =?utf-8?B?ZkF5T3NBTDJuTHBYcmdSTmk3eVJyT0tEb1RtYnhWQmFPcElrdk5jQ1hWMHRN?=
 =?utf-8?B?N0YvVG5td0ZuYUdaT1dpNzcrQW5hK2dqVkpVTnRRM2pPbDlWMkYxMXNkL0hy?=
 =?utf-8?B?TW5JTWZmaGh3blo4T0NzWEVtUSsxcmhOUW5yL2VZbEV0ZFBGY09ON1pNNHo3?=
 =?utf-8?B?anVualBDalBqQjJYMUNDeGI2Q2gwaER3UzlIcHVOSGNERkNaVCtqY3YxSkY0?=
 =?utf-8?B?V1NTRDh3L0E5S1NIL1ZtYzYwMWhHZ21mdGhxRnRPRVZJbTdjcXZiUDNGTjB0?=
 =?utf-8?B?eFhlczEzZ0x5L1VFeHBlaG9ra3JBVXE1NVBqZEdqUGxYTVZ0MnBiNnhUTGRX?=
 =?utf-8?B?bjYySUdEUWhMaFBJTitIU1pvVmkzUjQyTnM5UW9Wa25uTHNweS9ZSnQzWkc3?=
 =?utf-8?B?dmJtWHFWcGkwRjdwTFlXNHZ1ejc5RCtPNnNtSU91OTFvWmFaMHlsdldWWk9W?=
 =?utf-8?B?WEZld3pVWTJ6eVBnMlJlaEt2MDZVMFkyVkMrVmVmd3pjamlxUG10RFp3ZzQ3?=
 =?utf-8?B?UjhZdXNYRjg2UGg3WTFONjZhS3NaOW9xeXJMV2U3ZTBCREdrSVpVUVJjVkpY?=
 =?utf-8?B?VWEzb1laNlludW5aRFI0ZWJJczFlamdtVy80TDE3R2tyWWdkV0VBVG1GcmpG?=
 =?utf-8?B?bmNsbDRDbytTdlZTd1pkTFJGSVIvN0haMFQ5THJaK2pzczBrSk0yb2U1ajB3?=
 =?utf-8?B?L0t3OTlNbkdINFBNc211RlJlMTMxM0JkVlB3VjNNR3JEdE9ZUzRjUGZJU2FV?=
 =?utf-8?B?SnA3K1RIekd6Y2hZY1N0UUltU2VaUWpOOUtobm8wNm41R1ZoU2RHRXU3OVhQ?=
 =?utf-8?B?T0RWMEJpSmJZR0t3WkFyTFJzdnkyZUNIcVladDByaC9lbTcyL1NhWVpnYUJn?=
 =?utf-8?B?VVlqSmFBMmZldDhwMndGS0dqaG1xZUx3TTJZM1RDZFoyNVFmRWlCU2pPQjhX?=
 =?utf-8?B?KzRNK3VSbUN3cFJjejNyd21lM2FUTUFucnJOdk9RVEoycnlaK2l2cm1lWUtC?=
 =?utf-8?B?eWZxN2g0NVBKbmgrMmV5VU91bzd0dmI2Q0JydnQ5dGtjU05EUUs3THQ2a3RO?=
 =?utf-8?B?ZkhRaWI1Mkl5M3ZqQ2EreWtTT0ZCNzBTS3FFaHJHaytRUUNaeDhHYnN1MER5?=
 =?utf-8?B?b291Q2NhaDRNQ1NrV3FVWFpqQWpNS2RMdUhnMXVnMG5WVVkxYnZiaktFOGVE?=
 =?utf-8?B?cUFEMkU0ZEkwWEpnTWRvQUJUYXdMQkx6SzUvN2syZ014VkJKamFkSWllTXhH?=
 =?utf-8?B?TXBUaXZobWhtUWlCajZXbm9Pdld4QVhvcENWS0o1dUF1Q29sTjRkM0xGU25r?=
 =?utf-8?B?OEJUT2JvYzdBczh3VnlsWUJDbThuMlpxTWg3eC9iTDVpaW5EQUdSK2h0bTAv?=
 =?utf-8?B?ZzBoUUY4ZUtnQUJ1d3c2bk0yWFFQSnVQaUlOWWZnK1pkbWJlWHdqanpwUTBP?=
 =?utf-8?B?eTQ2aEJaRWMvSGNEc1RUVVhYU2NZeUltYkxrK2tYRFFJRW1DU0hsYVRXTVR5?=
 =?utf-8?Q?wikokQVForj7safWR/I11j08QW2SeYOFQcMQUbI/wsSy?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e97e9a79-f062-43e4-ade7-08da5e51d830
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:44:43.8152 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3yLDLVkNE6ALTDlfmUROpYjTxndWy6boY2eiB0idWZ7UPAdbI7zkUoecNYqrvAjfAzNQ+dAauP7uI5tZcMxMZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 17/17] block: move zone related fields to
 struct gendisk
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C4869BC309565142979971D7337C8046@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:45 AM, Christoph Hellwig wrote:
> Move the zone related fields that are currently stored in
> struct request_queue to struct gendisk as these are part of the highlevel
> block layer API and are only used for non-passthrough I/O that requires
> the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

