Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A46ECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663175966;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2AwvTR9B1V8eZnxLjQY2tloxCHXF/iJiUdLz6A3Qcuk=;
	b=aQVd8nlZarL74uZBrbioLQXX9bVVAASH1JfcOSLvfnDsmdyFCbzPPN+xKUom4/JM/AJPfb
	ksTobPQux9DuKnVpzi6Ho3MmMFYreNzh6Gti+Ibt2dcRkdKdk62X5lHaQxdaHFA5j0E10X
	hUjSRHekHjBwbNx8YWIKgwhb1bGKbzg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-bFskU41jOkqcFr03CQLiYA-1; Wed, 14 Sep 2022 13:19:23 -0400
X-MC-Unique: bFskU41jOkqcFr03CQLiYA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1B14185A78F;
	Wed, 14 Sep 2022 17:19:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDF5949BB60;
	Wed, 14 Sep 2022 17:19:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD2961946A55;
	Wed, 14 Sep 2022 17:19:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 961BF1946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 17:19:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6344E492B05; Wed, 14 Sep 2022 17:19:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EDB7492B04
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:19:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43F7F294EDE1
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:19:19 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-xD2zMt2iNVW6c8JxuQ76vw-1; Wed, 14 Sep 2022 13:19:17 -0400
X-MC-Unique: xD2zMt2iNVW6c8JxuQ76vw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MN2PR12MB4142.namprd12.prod.outlook.com (2603:10b6:208:1dd::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 17:19:10 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:19:10 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 02/13] block: rearrange
 bdev_{is_zoned,zone_sectors,get_queue} helper in blkdev.h
Thread-Index: AQHYxoDj8lt8KCHqYkOsN5anCqHqtK3fLzIA
Date: Wed, 14 Sep 2022 17:19:10 +0000
Message-ID: <b0eee029-4e9e-e522-ddf9-295782d2f934@nvidia.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e@eucas1p1.samsung.com>
 <20220912082204.51189-3-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-3-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MN2PR12MB4142:EE_
x-ms-office365-filtering-correlation-id: 212a8f5a-090c-4370-350e-08da96753cee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JTYZaXZEok6uxgSkJAzEVVAWZ426PB4huM4l6NWJcO1sKl4sdG7xoQqZYqMx978n9LsYNKzeqEQXu/9gIEZK+zPHQvU1HtBmsfWykKe4md33ws0SwzqSrjtCWIWHk0q1BIL2RkIVpIVdw0QQMdNYokqbPOiYZBICJ6KLmMzxC+x7SfJ8u6bTjmFNkzbH4XJY8/H20sJt/by7CliDEEr8NvIQ5MkBpIXCuXv1G3L1eseN9yjs93VViU9OhgQQTSCs/hkXVCcZdoOVoqBXgNFU54DBeyKCneJCi/jBFMmITGO59ihOyYyUAOTSeYGHNePZAeU+QTqp0FYke2YZMJGGsLay7JJ/o4HcBdGRr52JdwWCGVCRM0EgJOwT2WL04hkvKHeEoIKwa7rNcQoiudWK/tDvULRh91IYiNh7FFdstQmFLT+O4L19p4S9T6+Jujn6ypDREsuLUE5qvXcAcZb7wWDOwrw0KRsJF4VMDfvW5x00XrKkXO+1iV3P6BQ3Pbct4xuPzyWOJap+m5AYgi75sXXxskeQZ69UDH/e5F1dVs2AcM9C0s2m256N/Q1Z2PPOukTOCXSqIyRn+FEE8t912d259fj0qEBTn3TQ3Rwfsn1LDKGY6sjnLNqVfyWBi+xfF9cHiDnD71VrnvFLhyL1Jkmes8QU3WaFqAq5xNcdBmDmENZy/pl2jSNXq4xlAC4Cwq2twS4oXJx4onTbXxnlSjfARHVbIZciUzkJol7xHEBGAQ3g9V4nSyNviKFJcCIO8k2Am8rHgKHifQzJJS3qTAPZLY1AnTaPaH0ZoUmUEbhBfhYu229YwS0/wkuPD22I8DLHo+1FkqDMpDBupDrX3g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(6512007)(2616005)(38070700005)(66476007)(4744005)(4326008)(31696002)(41300700001)(76116006)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(110136005)(71200400001)(54906003)(86362001)(53546011)(38100700002)(5660300002)(91956017)(6486002)(122000001)(186003)(66556008)(7416002)(6506007)(478600001)(83380400001)(31686004)(66446008)(64756008)(8676002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wmh0dGxKbkYxVnF6NFBBQTdxendSTkJCMWFaQmZGTjlKcUhXYUpYR09OYUQ0?=
 =?utf-8?B?MWtwZnM2Zit4U1R6bmZOSWJnQklsOEpvb1hzWFRmMmpoVko5OVFxSUo5MWNC?=
 =?utf-8?B?QVRFTjNxYUMyRkY4Mkk0elNxNWlNQ2hPSWpUMjZwclR6a1RReEVkTEJNMjF3?=
 =?utf-8?B?SmR5YUs4SUFlRTk3SytsNlpBNHlTZVR1UDNqeVJGcWFzQ1NjU0RPRWJ2cTVx?=
 =?utf-8?B?WkttRlNMQyticDhTRE9wRFRiamVOdFc5aGl5M1lHNEhrSFp4VVNpdFhWNlBX?=
 =?utf-8?B?cW5wUzNGZ0x1cUd3QjRGQWZtaTdCV2NFSlM3ZXBkWWVxamNZUk43TUtyRW1V?=
 =?utf-8?B?RWpBb05Pc3BFVHpzSlM2bHQyWUg0QzN4QmV3T05saFdGeE5XK09IcnBrRGRD?=
 =?utf-8?B?MHFjaHNHT2FBUFZoSC8zQ3VpNmVDRGgvbkw2RnA1cDcvY2hrTVNTeVE4UVFR?=
 =?utf-8?B?MCtnMDZRRFIvS2VLcXA2UjhXMkdwTENrMjUwVXBlVmJGcDFvNWFDOTJPUnVw?=
 =?utf-8?B?dWNaWG9xRzdmY3ZwWnhqcmlFblQyY2hMTDlkOHAwN0p1QlVhZk9SSUVjcDc5?=
 =?utf-8?B?WlFxN29mandnTE83ZTczSlhjNnJqSERzdWRMdzRoSm9mOWNqbzJmdFpMVERB?=
 =?utf-8?B?MERoQ3pQTE9CVFNlejVteFF6dnBQWE1rc2VZYUczWmd6WHhHY2NXcG03OExr?=
 =?utf-8?B?UEJrUGh4dThOTDRydGVlcENsTCtmVU1laS9PSFNDRkpjWlphUklTM3ZUTFRX?=
 =?utf-8?B?YTFTUVNJZmprSXljZWtJbEIxU3Vqb0FaWDhoSEtieEhpWWdlUzRERmN2Vnl5?=
 =?utf-8?B?K0h4WnBmYytSV0dYa2tPQ0YvdGJRZVVVVTRHbWcybXFGUDY4NC9PNEV4RUpY?=
 =?utf-8?B?SnNqUkNyMlgrMEhQSS9YbzZJYm1JaXlGU3JIMytCVGg3VGFMZU04OHpaYXAv?=
 =?utf-8?B?Q2hoR0k5UU9WdXZrMjM5Wmx2YVcxSHVBVlg1VGJFVk92Yml0WGhXZUNLZkVi?=
 =?utf-8?B?Y1hUQXRHbHlnLzdhNVMwR0NKTjNEOFVJQmxRc1N1b2tsUS9GTElub25HZGVl?=
 =?utf-8?B?VjZDMW5YRGlaZUQ3VmVaa0xacC91ZVo5K05TQXdhMGtEeE05azVhMnM0dTkr?=
 =?utf-8?B?RU53VXlRRjdJMEw3SW5nMzZoa2tPcmszR3RSNVdjWFZ3TU81ditVSDU2RmJj?=
 =?utf-8?B?RXVOMnhQbTloUE9yODVxOVdBbXk3d3hnbER6amQ5UktqQW1uTUtHYzVKOTNa?=
 =?utf-8?B?ZS9iYjdXQVcxSXZ2cmlPdEw3Qk5FVlBkVzJLenJuaDdJMVk4QjhING5RdDFx?=
 =?utf-8?B?TFpySXp1b3ZPODFMQU5VQUZ1U2JmbDc4WjVCQlNvZi92UzNLdXBPVlJ5VmFh?=
 =?utf-8?B?cXFrL3kzQmgwbFVpWC9nWWZ4QVBlVzV2T29TT3BSQlRkdys2NGhDeGt5TFZt?=
 =?utf-8?B?SHBhZjMvNCtuOWlINjJ3alFvODVTRGhvT29MaE9tY0lkQ3lzK0tuYmlnemt6?=
 =?utf-8?B?dWdjb2dpZ0ZlRFNmdzFnaGFaK1E1b09kdzVrSXNYakR1MnlHVjNPT1Nib2xv?=
 =?utf-8?B?dDN3ZXE4c200OUNpSUFvd3VVcU85ZFhVMzNNcElIdlBvamo2TkZJS1o2WjJo?=
 =?utf-8?B?cEhFT0NkQnBpWGdnVGU0ZUxBOE1MditIK2YxWjVjTUFOaEtHMlIyb1NsMVp3?=
 =?utf-8?B?ZWgvRVFJZ1dmaFE0bGdpQ1AzOXMyNEVxWlZWN0JGSUZGbnBxRFU5SmdyLytV?=
 =?utf-8?B?WXZDM0RzUGZ0RWJtRzZ1Um5vV0F4V3ZqQURudTMzU3dLaHdENGo5WXkvZFpN?=
 =?utf-8?B?b3VoazlVUWhJeGJvZXRmcnR4R1VnNUFaSnkxa003UGszN1dxVXE2Zm15WWNY?=
 =?utf-8?B?WFdBeHhUSjJDbU93a3AzTURhYkFuVmFROCtJNmNielNZL0V5MEVOSDNVa2Jv?=
 =?utf-8?B?QmlQem1pNXpEL2hNdkpmeFhMUEM4RjFFSEdEK01OQ3RrUjNxNThpNTNYTUtF?=
 =?utf-8?B?NnNjanBFSnNpY0ZEYTdRaU1PK0lHVVFJS2pTaFhvZkY1a1ZzMkg1dnpqRFc5?=
 =?utf-8?B?S1o1UXo1b096azBtd25BSnFpczNQTTQydmFTc3ZEUEx5UGltSXpDQVhFZmMy?=
 =?utf-8?Q?bsy4WK2kxd/g0Hcg/GmJhxb8V?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212a8f5a-090c-4370-350e-08da96753cee
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:19:10.3618 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PxbvtSmyVx79lnH+l9nujttOpvj04yV6Fnzbpv+ch3skPceCaE+NSxoFVsKv+tVHpVwBFkbRDdFo+FNMaDI7WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4142
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v13 02/13] block: rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helper in blkdev.h
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
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "Johannes.Thumshirn@wdc.com" <Johannes.Thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E7C952F745BFA542AA1DA88456448300@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/12/2022 1:21 AM, Pankaj Raghav wrote:
> Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
> in the blkdev.h include file. Simplify bdev_is_zoned() by removing the
> superfluous NULL check for request queue while we are at it.
> 
> This commit has no functional change, and it is a prep patch for allowing
> zoned devices with non-power-of-2 zone sizes in the block layer.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

