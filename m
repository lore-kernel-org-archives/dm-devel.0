Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF8A0C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119810;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nJVdJPeQHgbvNELskUayNyzvycU/EgoDNyeeuEXfJXA=;
	b=AD2q8xvym0x/6LRb2XWA/AZ9j8Ukhwb6VUevnp1a2z3E36gFMgXxmsazLhTiWoIlR79rwQ
	ln+CQPl91D5YH4Q5WqSOQtW9++RxX65hih1ApAxIuUepHZ5sR7subFHp/LLMTuXHSi09zG
	V5LjU+cjr0JiGfpCq7yVSAQpRxRL3E4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-Mz9jrhMUPEW1IEWQEIIPsQ-1; Wed, 06 Jul 2022 11:03:29 -0400
X-MC-Unique: Mz9jrhMUPEW1IEWQEIIPsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 230243C1015E;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09F9BC28133;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E190194707B;
	Wed,  6 Jul 2022 15:03:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 86C80194704D
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:28:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5287E2166B29; Tue,  5 Jul 2022 06:28:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D8072166B26
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:28:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3279081D9CC
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:28:52 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-9ls_4pzONGWHlXhSPJQg-w-1; Tue, 05 Jul 2022 02:28:42 -0400
X-MC-Unique: 9ls_4pzONGWHlXhSPJQg-w-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1134.namprd12.prod.outlook.com (2603:10b6:300:c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 06:28:40 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:28:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Thread-Index: AQHYj6P6hHKlh/ItWkKUsxlAzU2th61vUaeA
Date: Tue, 5 Jul 2022 06:28:40 +0000
Message-ID: <f8a7665b-6faa-e07c-7f21-c4aa5c6fa1ec@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-9-hch@lst.de>
In-Reply-To: <20220704124500.155247-9-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6979d963-d9f3-432a-fff7-08da5e4f99b7
x-ms-traffictypediagnostic: MWHPR12MB1134:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hZ2M6nhNiVmKgCcn/AJqu5MabN2jqXSk5bc475CoMgX3CZySbikau8uq4/6cmMU4ABZ4UP05d6TJAX/F9KwKPGBNcURtmuSIQ8/5SDE8Hij9sVnO2EKsbYLGIyyz5zD1DRzOQarYzA3hsrMf/Vi6X0Ftjcfv6jSyAhUM9TKk8UjHONLbWjknGCGfSQCud0U6SdAa5/BNX3m+46GnY7IS3HxbN3pVLojWCyavHmceObuNs1Oha7ocmTHxbACH118VvxsdP6oTAzY2oYw7txQKXJKDH1q29fc++LppXLvD80G1NRcvtWWV+q0or1CyhUxNUGjM5YWZg6OVCID2oVn+Dp01/nPuNFXMN8VDTEHnurQmKWqeOKBLmVZkpRt7oHS6uPVTg4zBRGjXHepZaYHaKvejS+EitfiUz7z2yk3e8clJONVKUA9kpH5n8iVWv/e+Zl53EPZp+l5dTEeNEXYJvOvFO6toag/QXgxHJepy9INQ0oa5kCHXFbjuY/X8plrAPOt09wuwshg5UhdiEHrtuJzkvzHF3Dnq6UqNPipdntOe8QYdiV58GQzB+vHI5CkNWMkzz8bh4fv+cNrdHanb2yCOhhO8hVvzo3zkTbmA/fSIyuFDH5u7fOEOVwL5659HZLC+HiQ+1XDl8TZA6+SbWCB+ReRPxGqzO6275C9NMYJTMKFgqsPPcOMoWaidkDmQ+Xe7iF8Fex1wnxeQs4Mzoq6gzF4OvTxtPzkAQDxb8gzO3U+6I12lM5QXaA/bItOllsnHhvq4AnEi/nJuTTnV35JXA1L04eo+Sqyd/Miy9c/cDDyGlMLntnq2C378zoQS8lkwaHSDsEyV14XavFOAxkE8LQpMEma1EU5rKmlCn6ztjscBUVvviL721g+lz4+Z
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(8936002)(31696002)(38100700002)(6486002)(86362001)(478600001)(76116006)(122000001)(66946007)(6512007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(4744005)(5660300002)(2616005)(71200400001)(91956017)(186003)(53546011)(316002)(36756003)(31686004)(54906003)(2906002)(41300700001)(6506007)(83380400001)(38070700005)(110136005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTAwUi9mZWxBU3FQMUtSSWh2dnM1ZWZsZG9FV3VQQTdqQ1dja0FXOUxFRXoy?=
 =?utf-8?B?YzNtWlcvbTY0SWh5S0pSV2tKVGluVEtyNnduczBhWEJyRTRTc1VycEFMam9P?=
 =?utf-8?B?bjBRdy9GalRUNDd5S080TmZyVE9pWmRFWEFOSnJDdW1sVXFhVHNFdHROUEN4?=
 =?utf-8?B?emNHbUVVVUFxU2UxVWd6ckFOYkRkZTNwcHZuL3VSOHUxcHUwYTFwUFNaQjV0?=
 =?utf-8?B?N2hoTVhNVEVtamVEUnRhNm5hN2c5TVBSb25VNVVTYTJkRU1UZHFOL0xiNkp1?=
 =?utf-8?B?MFR3NlhsckZadmpSeVQvQjRkcUl4NXRSWUZML1NSZmZodGU4KzlMUmpNdUZX?=
 =?utf-8?B?YUdxT1owdkU0dVBVVWYyUlZlL0x4MHpYbFJjOXRyRVVTYUtWTFFoVmNsTGU0?=
 =?utf-8?B?RTMxOTh5bWk4akpIcm5GM0RqV2doblE3MzQ2TWFKWmYvRHNpUUY2ZnZJajkx?=
 =?utf-8?B?UHhJK1k0cnZkbWZkY1IydVp3TUdURzdObEMvMkYwWE8xSGs5alNqN0JFNlZM?=
 =?utf-8?B?UVlHblc2UTF4Umh0aFp5cXpDb2YvNDc1QzlZenkzbEJoMXYyWVN5REtCazlG?=
 =?utf-8?B?SGhpT1YxekJqdk1NejhmT05UbUJ6T0dIQVhibmZUWS9hcXpmY0FMSUtIcjFL?=
 =?utf-8?B?S1JiRzROSkgrd2hRRGpJUUNkeUFwcE1MOGtDU3dudW5zQ3NZa01NRjJEYS9W?=
 =?utf-8?B?K1E0eXZuMDJTZW5YMFNLeThBVE5BWmNWRzZiQ0hzRi9WVFFSSkRjcGt5S240?=
 =?utf-8?B?bklRRlRpWG4wZ2tWMlQyK1RLNVlobjU1eTFVcm5pVTV3Zk8xVTJVc3Q1Ty9X?=
 =?utf-8?B?aElzSUpBTzk1eEZqMkJFRzN1RkxseDFxYklyN2t1RGlEbUpPdnhCaU51Q3kz?=
 =?utf-8?B?TG42Y0Z2alE4eDk2NUFOUmVxY1duTTlpMklyalE5N21FNzJxU2hhcnJWTFdT?=
 =?utf-8?B?bXh5L3RkWHI2YW1wVlpxWW9lYWpicTNsUnd0aFJzL0lrK0V5dWtVNjhlSExa?=
 =?utf-8?B?VGpwMXdRekRCMm5tcmpkc2dpeTZiSStzWnBGMVl2c0NiK1Q4TXhMOW4zbDNx?=
 =?utf-8?B?WTNnNllKSjRiWjFPb0ZlbVJzSE5YcE5NVUoyUzlCcS9IV2JoRktJYjlkSzRK?=
 =?utf-8?B?Y2tmSnVYVldXUjJNck91YXpiS0w3VmM0RC9neE45V1k5Ky9nK1NoSDlMME1r?=
 =?utf-8?B?dSs0VG5qOVZOc3J6TWdCYmJvUzBRa1NpdHFUNy9hdndRS3ovTnFncFFTMWxo?=
 =?utf-8?B?V095SnFRc2V3YTZlZ0dsbStOeDJrcGEyQnpIL0tHcTkrazlEVTlxMzNqanJ0?=
 =?utf-8?B?T29XYVpsQ0tMaW55VVJybHRuaFhLS3c0TC9EbzNyTXFONTRDUEd5THg3RW9B?=
 =?utf-8?B?ME1TdXhuSml3TE5RZzlXaU1mU29YT0ZHUEVQalNzUzBMMEJHWHdWSy9FZHNN?=
 =?utf-8?B?czN0NzJuMWJnWUg4QTdVakJIWVVpZXV1UDUzSzlmYlJyaWNuNGFBbkdXRFp2?=
 =?utf-8?B?QlZsblpLVkUyeTZieHBtVmlobXFtY0IySVJlcWw3MEtoNnJNWVFIQWZIVUpP?=
 =?utf-8?B?a1c0d2gxRytvNFFIeW5HOUZhM1p2Y3ZRSHNNOW9jZUxoWnNpZnRYM0VlWm1l?=
 =?utf-8?B?WkNMQXZoeHRwVXhNMWpLWkZ3bFlMWXN0cUZFN3MycmdHZ0pCcXd2dnYwdDJG?=
 =?utf-8?B?Z0xOaXI1TjVCV3RRSzE0VDhQQ1pncERXMWZnYmJwU0lUM0lEelBreXRaUE1Y?=
 =?utf-8?B?TTVycmRnaVd0TWxSQlF6WWt2ZGNYeFJQK3JHVVdrY2d5b2lSYndFMkNVMVpx?=
 =?utf-8?B?dzF2dWVicmNCVnNuUXJLYlhhclJ1VmQwcFZaVUtXYTJoMFlMcXNpakkyUEVK?=
 =?utf-8?B?SC9kNzhoRjJPTFNUWUQzVmlVVFdwNUtWSnZDMzdGb0t6V1Z3TExFOExGR1FM?=
 =?utf-8?B?UWc1R054clZRT0IvT3d1R042cnpIemtMWFlqU0IybGYwdzNTSEdKZ2srMWEr?=
 =?utf-8?B?OENpM0taSGM5M1hrd1ZnQlpTQ1dZcEZsSFhzNmhlbUpJaXF5Q1BwS1NCUGRU?=
 =?utf-8?B?bnFyZHZmMjN5ZUl1NHhvS0QrQThBTVNTQmF5UjdGQitOaEdSYXhrT1pXUlRX?=
 =?utf-8?B?dWpSQjdRMUJjU0pkeURFa0liVDhXdEFNaWxCaWpKZFJrQUdOeDY3T3dkOWFq?=
 =?utf-8?Q?9FMPh77EQCuHaIIO0e/qYaYnb/9jWRLpzBpG1TZxvFT+?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6979d963-d9f3-432a-fff7-08da5e4f99b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:28:40.0434 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tC0bM13cqH66RnMtYsdm+v4vHttQd/gfRyJ8s08sZXMMPh3vg4M1ZL6NEiAkQaRew6qwAMh9ZDM639h7c61w2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1134
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 08/17] block: pass a gendisk to
 blk_queue_set_zoned
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8688BAB62A6A4D48B38ACCD565C9444B@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Prepare for storing the zone related field in struct gendisk instead
> of struct request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-settings.c           | 9 +++++----
>   block/partitions/core.c        | 2 +-
>   drivers/block/null_blk/zoned.c | 2 +-
>   drivers/nvme/host/zns.c        | 2 +-
>   drivers/scsi/sd.c              | 6 +++---
>   drivers/scsi/sd_zbc.c          | 2 +-
>   include/linux/blkdev.h         | 2 +-
>   7 files changed, 13 insertions(+), 12 deletions(-)
> 

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

