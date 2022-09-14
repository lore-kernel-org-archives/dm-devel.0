Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04B4ECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663175802;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7awn45VlImIgrpkhZ81ZI92dvp4s+vwva8XZPJBPVn0=;
	b=VdnkIl78RlUk92k43WcRaQAD0iNvqDJI5Rv1wUWE+MSP0sW9Ti+tGQo3QFHkkxIUcoeHp8
	SfUs+QV7XAIEVGh2k2WhbRH6x6O7C1EfE7NjUHDtffy1NctbKVa4bdlQ3bDHKlyf4Ct/gv
	KN4xTSI1auUP1MI7jIiwRmLi76U3368=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-onplGd_CNead3tSBS7dJzA-1; Wed, 14 Sep 2022 13:16:39 -0400
X-MC-Unique: onplGd_CNead3tSBS7dJzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDDD28001B8;
	Wed, 14 Sep 2022 17:16:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6DF2040C6EC2;
	Wed, 14 Sep 2022 17:16:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FD101946A55;
	Wed, 14 Sep 2022 17:16:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E2891946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 17:16:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 30BE649BB61; Wed, 14 Sep 2022 17:16:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C59849BB60
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:16:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 118393C11728
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:16:34 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-CtrmXUPxNxqLt17K5uI1iw-1; Wed, 14 Sep 2022 13:16:32 -0400
X-MC-Unique: CtrmXUPxNxqLt17K5uI1iw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 17:16:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:16:27 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
Thread-Index: AQHYxoEEfkoL2N3az02viUUiX825YK3fLnCA
Date: Wed, 14 Sep 2022 17:16:27 +0000
Message-ID: <435aa30a-9d1e-e8e6-6a14-6f5f612cf083@nvidia.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082210eucas1p2a27e358b12b0e4b06a7e00938251c90c@eucas1p2.samsung.com>
 <20220912082204.51189-5-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-5-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4052:EE_
x-ms-office365-filtering-correlation-id: 28fcf567-af3b-475b-9bb7-08da9674dbeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WkZEtKCDZTFfvgfZZo4ShG4c5vfjcxkTFnBPS8KejEyQ6NNKmrvZ18O0xTKBCOlwvTDWi3Dv++YdR3HDKDIAoT22+ClqyMd7bQpTwZO9HOYgUo+i3gk89L1ly75yxA8a1f2IFAM/9uSaGVfPZ6HWrgE7Dlwc4zhpO52AUlWiXSEJfUowLp1RvSYRq0uPgpHr8/2zQt2ZAQ2Up7rTr++9KK91GFL9Mca3cwPzojUhDb79zB9qu+AgGDD0YLFvhN7hR2+aBjmw+N34vb7y6KxeUBY/IkpMUoZOYvb6uNN+HPKXRWJ2gQWW8LU2/P/CTdDMu/LuwcoLLGXr6UlpjrFlGHuTSUDtTzjIF+HWPlB4DEOwRwe2pmE5SPVzWDVA0avegDJspcW4vRm3gT7ReNZ2z6wIN1miIX9p2ob9r7Atxs9oZJ41euvh/SGv35fqOyACQy3uhxSHsjZ8kY0DnK9V4Zn3z4F6v77MJrpKM3iDulO8qzXc0KI5bM03xK/XBlieE76tg0i8vGoke+UnR0T4bCvo+snKEnNdOiHOYnnOrP9HEttjPcsYaO+E7tibCmtxEkhAXYnzcuE1K3ac7dV5LJxiUK6nb4urTtKefSEtOvgxQwmAqpdTOJsSoVy1+DdE2F6a5Y7z1j2pZo8nFzq4RSHHr0JHazOgsJJjpT2AL3T/nujyOvao2Rsx46vhqn581B9nBUc7hql6CUqxcefqwhYTHmtw44GNPGYmjmokUCOGAJnoLDvcENDFDhUDO0aCD8TiYJfDChAe8kR5qQg1wGvRM11BreOnFYT2XLfYX4J6Gdur9UnHiKcRqyorldzCWejjlFAPUe1PktAg3POaug==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(8936002)(71200400001)(110136005)(6512007)(83380400001)(38100700002)(8676002)(26005)(31696002)(38070700005)(478600001)(66946007)(6506007)(4326008)(86362001)(7416002)(66476007)(66446008)(64756008)(186003)(76116006)(66556008)(6486002)(53546011)(5660300002)(91956017)(2616005)(4744005)(54906003)(36756003)(122000001)(31686004)(2906002)(316002)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTByVElJaEF2ZWRsZXRybzVZRGtHWEJFL1hZWUFJc1JTL084RkNmWnM3dlFj?=
 =?utf-8?B?MkZXZ1RJaXZ6UVR4RnpidDZXOTlGYnpNMFBna2h1UE1seFdPNXZtMTlqT1FH?=
 =?utf-8?B?d1NxSXdBOTBmWjBpblJDVW0vcCtSYUw5STc3NTlmaUhCa1ZQbDBseS9SRDVF?=
 =?utf-8?B?QTBHT0U3QWpiSjc0MlBUVGtyMjcrdGpiTlJJUEcxWkRCNWxFWFlLU1lwcW5h?=
 =?utf-8?B?OXlsQUZlekp2LzJ0a2VJWkt5R2x4c2YvNDkxd2hndlJ5d3FtSkh2dFNyRnJn?=
 =?utf-8?B?b2lLMGZBa1U1WEZSaUNjck9sL3NUSks0VjJ6aE5SR2hFNUFnOWk5R2tvMnVO?=
 =?utf-8?B?SFJtQXI0Y2d0S0dQN3RPVldpZHhWREdyV0VETVBHVzZmSjRXWWRVemtpVDBC?=
 =?utf-8?B?MXF0ZEZQcWQ2empqWThxbEpXTTkvYWpQaFRkNEFpMi9LWUhMQ1ZxdFpOVlh4?=
 =?utf-8?B?TmdoWVJoeXFuNVdRNEVsR3NFbjZmZkY0SWduMnkramxQaERaSTBRUGVZZkJ1?=
 =?utf-8?B?a094VVFHWXlqdmVyWm5lS05sVWg2ckVCK05ubFI2R1pBT1FjWVlVaVBpYytP?=
 =?utf-8?B?NUZvYUtIYmJjTnJ3ejYzWHFVQjkvQWZFbEh4VGZJQ25xcE1WR01WV3p1T2lX?=
 =?utf-8?B?Qm1UR3hjRVozNmFHdmZLTVR4ejNielNyUUVhR0dFMEFEd0hXSE1OWkpsWjR2?=
 =?utf-8?B?dWZTOUpQOXkxcFpmNTA0dHk0VkJ2d0FKWnhDckM0R1pOOHFCUnJlRlpNNEI4?=
 =?utf-8?B?TDcrS3cvdEZpMDZPZFZVY3R6dS8wSEVjdFNTNjZUUWJMMXJBU2tlN3IwTStY?=
 =?utf-8?B?TlQzWmw5OENkVGtSczludW9vQ0pmeWUrL1Zma0NkWUpoaEZjN0ttazVLenlZ?=
 =?utf-8?B?QjlIUkFJQ0xSNDBEY25FUG1qaGZNRWRvT211WDhqK01WR2k1dlE2ZXV0RWxV?=
 =?utf-8?B?dmt0Z0w5aUdxL0VSemM4aUxZUGErZ2xhUElMZXE4RVlHZENkOHV3MVNwTWdx?=
 =?utf-8?B?elRMNmprMG1rMnMraG5NSytQbGZBRHZWeThkUHloUVhkTkozN2o1WGlYcmw5?=
 =?utf-8?B?YnN6L3JmOUpya1A4YncxVzNCZk5MNEdhOWdGUG1FOEZxVm9wb3JiOURNU0VD?=
 =?utf-8?B?dmlSOWpSSFVFLzBRbjBBaldSRmZZNXVtV2o3RnJ6VnI1M0s2UzlITmZFanhB?=
 =?utf-8?B?TnRXQWJTWlZWeEE3bkMyeDM2MlcvZ0VqbDBwM1pJQ2tSd3grSjlneGlSeFRS?=
 =?utf-8?B?enBJN29rQmxhdS9mWDhNTVlLLzEvS3lCd3lCNVMyYUo1SDFZTEZzbTBqVFor?=
 =?utf-8?B?SFlNU0wxbjhRY21RR29GYzMreWwzQ0wwNGxBR2gvUnUzaUE5UFl1ZDVxaWE3?=
 =?utf-8?B?TjkzY3BGaFROMlJxKzhQRU9WbC9pM2c3VFhJam01QW9OaTFoM0tYeDc2S3g3?=
 =?utf-8?B?V2Z6aVp4VVNKb1BiejRXbmpTbEFndUZjMEhzbXFqS1k4UWdMZ0hkZXBUcytC?=
 =?utf-8?B?TTZ4MTNydHFtS3VKOFVhcmt0T2ZPQjdqNVJtOXVydXZIbjk4eDZrVnE1c3pI?=
 =?utf-8?B?ZEZwS2ZqZU0zTnBVY1VSRHZlU1ZTMXR2U3kvaGh5Y3JRMHUrQXExdDBLci9h?=
 =?utf-8?B?eEplMG1mWFNORlM3djRSRWU5ZnBtVGJ3OGcvS3hHeEVCejdmV2l5TXhiU2lw?=
 =?utf-8?B?QkNaS05FeXMxM005M3ZneUlCUWUvOExHdHBFbkVDZUd2YTVGZWkwQi9La1g0?=
 =?utf-8?B?ZFIxajJBYVFnTk9kODFESGJtQmJrYnVlM2pSc0pQM0hrTzhKZkc1eUJoWFlO?=
 =?utf-8?B?RGJ5Q085RXhXcGxtdVlZK0s0QkJCRjlNQlRlM25KaDdxMXpWRnptMU41L05U?=
 =?utf-8?B?NFNrQ2JPTkRBWTg4ZHlKVTJtVktYWURTcm5iK29zZk4yeWw3UjR6SzNiUkUx?=
 =?utf-8?B?ejhpODdaY2pKdzRlN2crOEdkbUx5QytVengwckFuNmRGVER4Sk1wTWhlRlBV?=
 =?utf-8?B?c29rZ2wxb3padzR3OE1zYTZZZDRnOWdRTzdIc0hpRGczRkZ4VnNEMkc0V3Ji?=
 =?utf-8?B?bEZhUGQwUmFkU1dnNDNYTG5mMUV1QVZpbEdDTkFOUXBsbk0vT2NtWnk2SHJu?=
 =?utf-8?Q?VpDOf3vFDw9IWe3QD2b+1K9Of?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fcf567-af3b-475b-9bb7-08da9674dbeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:16:27.5901 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NySOkDQZHkV1J3ZfMW0NeDnMPVbh8zyvX8FW6QogRO8sTGQznsaNUG1BruMzGshvPq0MQbgZNj/CWYD6c9ESuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4052
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v13 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CC7046F66C2B584A80F843CE77E93CCA@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/12/2022 1:21 AM, Pankaj Raghav wrote:
> A generic bdev_zone_no() helper is added to calculate zone number for a
> given sector in a block device. This helper internally uses disk_zone_no()
> to find the zone number.
> 
> Use the helper bdev_zone_no() to calculate nr of zones. This let's us
> make modifications to the math if needed in one place and adds now
> support for zoned devices with non po2 zone size.
> 
> Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

