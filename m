Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7CFC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 10:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660042751;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xZRqA2J5Cpdt5/BazyrafaFIB5Gpn0E2azQnPx8xx8I=;
	b=cwcO2jotHXzUFjelAhsJF0EevsYEjH/3cIC8mfp3V+QUfAXdCU2+o+ZzJ571/MhlmDHXMZ
	4d4Uigeu0ReNRLO3K5iWzdVKJxha4pdZiT9zgwBNdlpFGGi9jmlrKVPPrMucki/r71WANv
	ou8S1fDiCGPfskdBETcuurhNZD4OXzY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-o2bUEPO5Ow2sylbHu5tGJg-1; Tue, 09 Aug 2022 06:59:08 -0400
X-MC-Unique: o2bUEPO5Ow2sylbHu5tGJg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 439A0811E84;
	Tue,  9 Aug 2022 10:59:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E19A492C3B;
	Tue,  9 Aug 2022 10:59:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E37821946A4D;
	Tue,  9 Aug 2022 10:59:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B7821946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 10:59:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C8801415129; Tue,  9 Aug 2022 10:59:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67AC81415125
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 10:59:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F2B82800493
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 10:59:05 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-ZTubru1nMUKuE8f5gC8p-w-1; Tue, 09 Aug 2022 06:59:02 -0400
X-MC-Unique: ZTubru1nMUKuE8f5gC8p-w-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 10:58:59 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 10:58:59 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>
Thread-Topic: [PATCH v2 13/20] nvme: Have nvme pr_ops return a blk_status_t
Thread-Index: AQHYq4P3yU1KFsg5r0m9GCayjBo/iq2mZwWA
Date: Tue, 9 Aug 2022 10:58:59 +0000
Message-ID: <7423e01b-0ee7-1827-9960-a6fff8f9fb3a@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-14-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-14-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f480f050-28f8-4282-1a81-08da79f629dc
x-ms-traffictypediagnostic: SN6PR12MB4704:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tVaF//hil9JQ3JgQa84uDUMUmYgrVSqDVNXHwY2NYY0Z/1qN/EmU9kSXHa7bKFlAjJwPCNlyHn3cHTGOjOgpDjbAydL9/jgjuhj9PCr60LHPUPbcNoIxPT87JFYVhZKWdKocMj34FBLrFwy4FLpFk8okwvf9yr1M7h9v8VodeJI47guNd/wPvPBaDzSK3T/7AWHtN/tbNcYR3f3WMimjT5LO1A0dWSoOVjshoG9qITD/N2Odh+0kkPf7M3wQTlfoiFSvZCFDxgXDb6+H/dEX7IEfUQTEo21Q+5qY7ASwjtzKR3kQzM1RefltjAO5cr+PgeAuResv4J1MlCSIrqHkvgoufDMKipJ7OqV1Eh55FbupZ+QdTCxvv93k6r8QX6vwoeV3jYbEm14dMV2zl49nF5AmCxzU2D5UFyPHLAxJ/eJOH0zGudz+sKRBEvPaw8SzXJy8UkA4Tmu6dvXiz2PYS/mdVAiDZstp1KDYmpPxfhyse8ffvCXtXt9VoLFvv3cMK9LmHxGv2MNt99Ggmld04j7JC7vtk4vzNRu41ippSJtaL5xMTHLiQOMNUORDkHGKXp8J96s1+cZKWXjvYrFDwZIkNBXR5M80Mf3WUEioUX5s7py3u28CAn9JP7WNig1B2rtNponj9LNd1oeAgOqwNgSNquLHLHspURuIWgaP03kk+XXfUzF2MH9Ic5DxLjBvfLlj+kumyFD1qtE2ukQocrFvZtvO1imkINX0H37GAnNcxKbtAdSekKW/HMVrwP/SpSPirRmYBm1tOJFz/cneUKr0a5pzEQ43dP8JsaMpr1UU7QqOg2YZtmwhLK2K7g6Dkob96xeBVVQ4qkY6LgboZs0yfGmtaRRKpz/+/e3RvXaVXWC+A3NpXTiG+CjVOIH8
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(316002)(2616005)(478600001)(2906002)(54906003)(76116006)(64756008)(66946007)(66476007)(66556008)(41300700001)(91956017)(4326008)(31686004)(36756003)(6916009)(66446008)(8676002)(5660300002)(71200400001)(6486002)(38100700002)(4744005)(7416002)(6512007)(38070700005)(83380400001)(86362001)(53546011)(8936002)(31696002)(122000001)(6506007)(186003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2JPbE1nOUtsUmNqZEFnNnRtY01tMHg4V2JOdGRrN1RjV3hjVXdmeVA2UUEw?=
 =?utf-8?B?dEdndTNwQTRFSE5DOU1LZ244cDBnZEpGRU83WExNYndkL0R0UE02U0JUL3I2?=
 =?utf-8?B?Z1hHOER6cHA0TmdMbFgyMmdUaEJuSHNiUTRpREEvRjBZSnhKS0NiVVBEMU1C?=
 =?utf-8?B?bVVBY1BJcnNJc2FtZENzOGJhTWRoVW5OTDlidmlnSUZkL2FhNHRLS3hRU2gx?=
 =?utf-8?B?UTBaWWwwejU1cEpwU05hRU9jc0FZYWRCSVlVUVB5SkdZNlVGUkQyZUdiaWtq?=
 =?utf-8?B?MWp4MXBibDdmYllZMitJTzM3aVlqYUhwU0U1QlRLZmxJV09JSXBudlVUZ1gr?=
 =?utf-8?B?VWlwZm5YV1IySllDUCtVZ0Y1R1RVOGdyOHdYL0l1QWhJNHNzOFJFNDVVNi84?=
 =?utf-8?B?ZzFBdkxZME1xYWJ0YUYyVmg2V1RWdGRvZTBzRjNNeW1zYjRnMXVmRHFGdGJz?=
 =?utf-8?B?bjJ6MnZsZUIyZ0tuZWVIU2k4elZub1FldExPR2pOc1E3Nk42ci9pZW16YnJl?=
 =?utf-8?B?YjZhMlY1OXdtVWQ4R0t6WlNpT1h3bFczNVFEUTRLaHhEbHl6d0IwR25USFgr?=
 =?utf-8?B?UDdUdlpZSUIrRWlwd1ptM0hsZmtEYSs2Y2pQTTlkMFFocmRkaGRwemVXSXdn?=
 =?utf-8?B?Mm44UkpOeWNUYjRxWkgvNmxTa01nc1hkNG41UXJvaDYrRlZUN0xyNE5abEZn?=
 =?utf-8?B?aXM5TEcvTFpLYitiR09BREN5NE4wRFdxampnSFk1bVkxTFp2dGltcTZndk9Q?=
 =?utf-8?B?amVOMFZ2QW93U3gyMTlHbDI2eUkyMzVKSHRaaXp5c2tmMnFHbS9URlFDY3hw?=
 =?utf-8?B?aDdnbW12Mmg2aXQ3amd3TTN4elI5MzJZck1QN2d4MFF4WkovUkQ4N3NSOWtQ?=
 =?utf-8?B?VDU5NXhBTTQ0TEk3K3pjd1dFdEF6QUtOQm5YdDhFYzBuSEt2aG93bWYzTm5j?=
 =?utf-8?B?SXo5RUsxb1BXVmRTcElMbnJOeUc5TUVrbmhZSXhVOFp4SElEU05zcy9jejRr?=
 =?utf-8?B?TjZZeFJ0eWV5cmFDS2psT01qbTFwTzhNU2xiM1dia1oxaTlKTXJGMkxqWW1a?=
 =?utf-8?B?QytQS3VvS2tqNDhXUWtMWjRaSnBiSDBzTmVJa29qNUpLb3dhYWh2bUxscWd5?=
 =?utf-8?B?aWU4OXdTZURDODUvVGlTaTNJUkRDa1BwRkx4OEVKNEFteGIvYnprVWxJckJl?=
 =?utf-8?B?bWgrVUFOMDlMNkliVEZWMHpSNGwyQUFXWllUaXVnYzFGT2l0dmtPK1p4b29L?=
 =?utf-8?B?UXV1aFAremtVaHA1eER3cXlnWGxyZGxqUGR4SHlzVG1ubHBjYmpjZ2tvQWg5?=
 =?utf-8?B?WDNTejlPckZDQXMyUVNpRTltVnQ0dXM2cEhYTmlRM0tLRXN0WUh1a2wvcUhV?=
 =?utf-8?B?ZGJVOWlyeGUydHNRRkFFR2IrRGwrYWJQUHFCM1hiYjNYM1VYQjNrV0dLMEtO?=
 =?utf-8?B?VEEzZmFqa2g2Ui90S3k2aGRGMitNVWZuWFdNdFQwdExaZ0V4UTV3WTZ2YlI3?=
 =?utf-8?B?NEtNK25LWmRKRm54SGlmRkRYYVRGN1duclpMTDl5KzdwVGtwUzc1NVlLRktL?=
 =?utf-8?B?a2QySUo3MTlBbVZTTW81YzhMc1N2VmJHQTBKSnFPMFE3MG1td3I1L1J5YlFP?=
 =?utf-8?B?a3lMOGhPM0NSQjR5VTk5UlJJSUt5VVRVTytjajJmK1RMQ1RwWGR6WWZWNEFG?=
 =?utf-8?B?MTZTZkF5VlpzSFpNcjBUWWtUTFdwdnFKNVNiZ2tTM2dhOEdERW1UUUI4cjll?=
 =?utf-8?B?UXRnRWljREhSMVFkcnk4aURUcTBMOUhXQkpMaFNKSTNpWTlRcEdVYjVHSVAv?=
 =?utf-8?B?dnRXL3p4RzZKRy80b3ppZWNHYjh5Q1EyNzNTblExcjhyVlhvdVcyM1ZjUkc0?=
 =?utf-8?B?Uk12eXZZTG9kTTN0N2MxWmJlaCs5WHdQMEp4OUxPUWwrNnZlbkRWbmtmOHBw?=
 =?utf-8?B?NG5iaWIyK0V0YkF0aFFOL2N3Lzd1ZGhxQXNacFdvTkNIN2FqVVVuVWpya3RQ?=
 =?utf-8?B?NVB2VnowdU9vL3ZmRHUxdzlaek9BbytSa1EvWWViR1libVB0azdJbWVRNlZh?=
 =?utf-8?B?dkJmZG9nTDBnRk5EdmlwWmk0QjNkMEZoU1MvODlDNTZYRkl0OWpxa1VsQjVs?=
 =?utf-8?B?K3B0MERLblZHOGdYMXBFTmdvZUNMa2RJSldXOXdkZEJlUVVHRnB1bTRleDl5?=
 =?utf-8?B?dkE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f480f050-28f8-4282-1a81-08da79f629dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 10:58:59.7396 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58lYG+ffPsQzBNpSlp8hfq7oaHdNUjKDlLBFI28EPZoha8x28s0eYVuRj85o6C+UqtIG3EF78VAoTlnGk6hVzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 13/20] nvme: Have nvme pr_ops return a
 blk_status_t
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <AE42A5E64608F64485667316FF043744@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/8/22 17:04, Mike Christie wrote:
> This patch has the nvme pr_ops convert from a nvme status value to a
> blk_status_t.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/nvme/host/core.c | 54 ++++++++++++++++++++++++++--------------
>   1 file changed, 36 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c

Again please consider moving pr code into it's own file,
if others are okay with it.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

