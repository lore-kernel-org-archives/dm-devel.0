Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14BDC05027
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675257770;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N23ZqxLonDyfgsZBZJTRH7jSpj/Ay+sKE7yUJYo4Y28=;
	b=Ej5eyGI5mQy/rUvZ1d/5WEpteoPjRqzFrHKKe0203J8zbA4Qk4yJXg8GriF572ddGuBWfJ
	fTg1k1WM6Z46eiSbzCVO7mpAm8jJ4WRtTYTx8Vz0Z7za9pMn+Bz6/+3D1VpUQ5evpAkft1
	cVv0gD7rAx3aYATpnIDEVrpNGtkBhh8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-lU4NQVeRPiOxfvhljPF3_A-1; Wed, 01 Feb 2023 08:22:47 -0500
X-MC-Unique: lU4NQVeRPiOxfvhljPF3_A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B29985530C;
	Wed,  1 Feb 2023 13:22:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DDDB492B05;
	Wed,  1 Feb 2023 13:22:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1312E19465A2;
	Wed,  1 Feb 2023 13:22:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 122B9194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 13:22:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7D53422F2; Wed,  1 Feb 2023 13:22:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEAC9422AE
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 13:22:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8B1B101A521
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 13:22:39 +0000 (UTC)
Received: from mx1.veeam.com (mx1.veeam.com [216.253.77.21]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-uyCUM4b5OYyQkJEcW504Zg-1; Wed, 01 Feb 2023 08:22:38 -0500
X-MC-Unique: uyCUM4b5OYyQkJEcW504Zg-1
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mx1.veeam.com (Postfix) with ESMTPS id C033941C37;
 Wed,  1 Feb 2023 08:16:30 -0500 (EST)
Received: from DM8PR14MB5221.namprd14.prod.outlook.com (2603:10b6:8:28::14) by
 DM6PR14MB3388.namprd14.prod.outlook.com (2603:10b6:5:1ee::9) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Wed, 1 Feb 2023 13:16:29 +0000
Received: from DM8PR14MB5221.namprd14.prod.outlook.com
 ([fe80::4af6:fd64:925:e3b4]) by DM8PR14MB5221.namprd14.prod.outlook.com
 ([fe80::4af6:fd64:925:e3b4%8]) with mapi id 15.20.6002.026; Wed, 1 Feb 2023
 13:16:29 +0000
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Mike Snitzer <snitzer@kernel.org>
Thread-Topic: [PATCH v2 02/21] block, blkfilter: Block Device Filtering
 Mechanism
Thread-Index: AQHZC9njQhPExPGzik6+OOTOrKe/8665iB8AgAENSwA=
Date: Wed, 1 Feb 2023 13:16:29 +0000
Message-ID: <DM8PR14MB52210D6056B32061C629E5CEF5D19@DM8PR14MB5221.namprd14.prod.outlook.com>
References: <20221209142331.26395-1-sergei.shtepa@veeam.com>
 <20221209142331.26395-3-sergei.shtepa@veeam.com>
 <Y9mrJJDFnMNWR7Vn@redhat.com>
In-Reply-To: <Y9mrJJDFnMNWR7Vn@redhat.com>
Accept-Language: ru-RU, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-imapappendstamp: DS7PR14MB6905.namprd14.prod.outlook.com
 (15.20.6064.010)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR14MB5221:EE_|DM6PR14MB3388:EE_
x-ms-office365-filtering-correlation-id: 65c7ef75-65ce-4aa5-f8ab-08db0456878b
x-veeam-mmex: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GhXP8N/EGVLplhpNq8mlkjfrnqpi2BasG/+ikoC6EO/jWr2OlPYW+luypFUTvc3qPTWC8AWywCMPKdTrISp1LskQsExWlZWOrMmaSbd5uD7HGYJxjbEbytQ/S0fM8S3FEvQfN2HjsKpna0isgYQzyM9R2cT1/mRjLLRz1bCXXMtY0YksVWJvzAX1XmFsRiWxKwNt65N1T2VF30hJl9Pj+EmhgptkuEpdCRnYbh5PffngfpzSe+7wL15xLSH9LM0yZHaUrARdYUjgj7xv90dmMWeXL1jA+pF7awESfCaF3KkFT5dUq9EXM1xmuscAxX0hhAYVal2pP5DpAXvloI3hI5tfbpXkpt1qlcLMh2Lj5B5dEMYT6QwCXFmQRFp6g/icPvUNI6P1X5A6HsLOS63YZGmUVqHNWOlTS+Q0gZn5KnKzF6OjSqxoeoL8/5pi+lXRRZsNGM1GqmWyBVfp/WhYdygRrFB7V+U3OcX6SLKk31PPmVjFn+m5/xHCBFzw38d+c9S6sPpVGz3Cr+i3DIK5owaPCXys8y5Fs3fZCaNj69ju1ybziqDFYEVaas1TZ9N+Hrrb2Y3fpJw69Gtkc4iQT+Dwsome+ikZ8o4Z5nkFn1ttL096Le5axaAJB6wmgMOv8BnGApaofskSTXGXu6rAlmUI2U9n912M8T3ll/4XCktwxR3IjubTHhsvnkoBGrKHvH334gcaw46iWTLPYpaCLY7QpdvH40yJ/aJ2kvQaVWxm8GLK6RhdVXQESHBB82UwJujLuR05jz/sG+qy9BozdTeVVM4Rg6IBosTx9nYnm/s=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR14MB5221.namprd14.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199018)(41300700001)(122000001)(64756008)(6916009)(66946007)(54906003)(316002)(8676002)(4326008)(66476007)(8936002)(66446008)(66556008)(76116006)(5660300002)(52536014)(38100700002)(86362001)(33656002)(38070700005)(6506007)(66899018)(186003)(9686003)(966005)(26005)(53546011)(71200400001)(2906002)(55016003)(44832011)(7696005)(83380400001)(478600001)(65966003)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2xWVjVnMmtUdElWOVFDV1ZTM1pjUWRCOC8yNCtIREMvZFBLR2t0VG5abFBD?=
 =?utf-8?B?MVdyUzVvQVJoZlpHNzNZdjN1bWFXK0xCcm5tTzNmVTByNVc1aUI3TXp4SGhr?=
 =?utf-8?B?YTZZSDFUaStwZkdMOVlGZVZrdlRZeDVXdDNva1NVa3N0V2xsWTdvMlRTSFQz?=
 =?utf-8?B?Q2FPTk5PcWJENytDL1N3ZVRvYk1ITmp3QktoY1d5TERobXJqNHFyQnJCdjlM?=
 =?utf-8?B?RW1VVms1VW9sQTUwMlcwYTRacWtzRFBNSlhXaDJzUW9hOWVxdXVNdjZjdGN0?=
 =?utf-8?B?S0J5Zkk4T3pVdEIzUzFqRDVjK0ZUUitjMWtVbU8vVm1ITWxsc3JxdW56ZjhI?=
 =?utf-8?B?Y0did1RCZCtWVzJwTUtDNm1FWDZVRGxvN3I5UFVhTkVDL3laUXlZOW1zcGJm?=
 =?utf-8?B?Snp5dUZCZm1Ncm91aTlrR1gzL2xldHJxYkxxaG9jQmIyeHZYakVGeUQ3Yy9R?=
 =?utf-8?B?QlNNZ1I5LzFNK0lrOTFHSk1vYzcvSnFzZ2NzWGg3cHYweFRVNy9vOWhKQnNx?=
 =?utf-8?B?NDJVTzMrM1MrTVByVlNKb081K2k5cHdNSkVkYVlxUWhHdjBCRDM3SmlTYkNv?=
 =?utf-8?B?NGVUUnJQanZkSS8zbjBMekt1RkptQUFUMHQzc1g1d1U0NkdFZDYxRmxjZ3lK?=
 =?utf-8?B?WGhPWkJKZDNScUxYY0ZEbzUrdXZoWnVCNmdDNzVqeHZFN1NSMTBERDhoNDRt?=
 =?utf-8?B?L0Z2d1c3QWh1a0RzREFCL1l3ZW5UbWN4Q1lyWnVpU0dtK1Q2ZCtyZllvN2pM?=
 =?utf-8?B?M1N4eXhlNjFoc1FXQkl1YXh1UnlmbEM5WW9MYU1NL1huQnUzYlVIYkNCakVV?=
 =?utf-8?B?a1BKK3huUWFrWVV2cDRRa2ZyRS9sVlBPV1V4MmhycVk2amxVaC94dHYrWUJD?=
 =?utf-8?B?b3p6ZHpQSVAxUnJ4eWhKYmUwT3VLOSttT0krN3RCMUFPbEdqWUFmL2FrU2Ja?=
 =?utf-8?B?djhBWkR5L01QYWNsSUlMbkp4R1gxNGxFM29Gc0Q3WGdseDVPblBoSWhMODNI?=
 =?utf-8?B?M0RLcEgyNFE2TjlYNTFuWUNZL1FnTHllYXlocE40Y2JGTno3MzdhOFEzVDFY?=
 =?utf-8?B?d2xpMXdHVDZ6K2k2cmtDSXlQT0dXM2VuQWlpM2dJMFV6blYzbEM3RkR1RGVF?=
 =?utf-8?B?QlZjKzZUcWtKUzk1L015NWZ1Q0xkRkVZV2granhkY3I0TlZPbDlCUGVGMi9y?=
 =?utf-8?B?NDlwWitwZ2s3M1RWVU9NWHp3bkhLMzBacWlHZ2Ryd2pJNDBkOW14UFdnZUNK?=
 =?utf-8?B?WW5scTZEUElYUGsvUDQ5c1dUeXRvQkd2VDdFdHFwSTgvcCtLb0cweXpiMUUy?=
 =?utf-8?B?UFFEbDFidmRzcjE0M1BUaDRHOUc1NERXWHU5Z0hwa0t2cWp6dmFMZk8zVjZU?=
 =?utf-8?B?TEZsQnZWQm5jOHBHaUJiUnBGUWk4WWxYSXJXTkxmWU9iM0lPTDRNd1ROZjY1?=
 =?utf-8?B?UU9WcVVJWFdvV3FsNHNxYmlCSUhTb0NsTDhvYWpQdjNHY3d5M0xYMCtGakNW?=
 =?utf-8?B?a21hRWxCU0RVMTZrVTZTT0RxcUtUNnB3ZlkyZkZwNE1iOElmQzNGWjhPR2ky?=
 =?utf-8?B?K0ZPY0QzZ0NIRlJLa2tVQWVQY3FRMGFSMWRJelV6WDRseHg1ZENFbHVGcHRD?=
 =?utf-8?B?Y083YkJvUjViNWFhS2s5Z3ZWdGg1Wm9BRjhRQllhQkRsYVVOUkJKdDZIMWhv?=
 =?utf-8?B?Mlk0N2xKOERIbys4QnhGWitRQjJWNVdVNFhRY0p3ZDVwYVRhS0V6R21ITkZu?=
 =?utf-8?B?blNORHQ2VlZwMW9TRTY5R3E3UVpweUplNWVsMEM5S3ArZ2t4ditwSHBDQnNq?=
 =?utf-8?B?dzBQc2Vpem4wR1B6N0xYZkhselZLKzMwU2ZLNHQ5VGlJRWFxVjFVUW5kVk5W?=
 =?utf-8?B?eWFhSFEzb1gwNzhxVXJhZjFyTDM1TSswNnk3RjF0cVhDSUx1YjllbC83V2E4?=
 =?utf-8?B?N25UdEtaUmZyV3hraUNkSWVYTWhpay9kRm9kNlFzeWl2S1ZvOEVibnNNaEdB?=
 =?utf-8?B?Uk5mb1V2QktkVlN3NmoySUwvSUFjRm5XbGkrNFFOMkR3bGV2WXd6TFZQWFlL?=
 =?utf-8?B?Ri9vd0ZWdjgxYktHS0xMU0FrUmNxRU5PalBpdk1FZ242aGVPK3R2QTFmK1hy?=
 =?utf-8?Q?1IlQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: veeam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR14MB5221.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c7ef75-65ce-4aa5-f8ab-08db0456878b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 13:16:29.0540 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba07baab-431b-49ed-add7-cbc3542f5140
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AL1q6t6IKWhR4V3t955s4D7VDrrzUJ9+76ixpnXDZjcaTflVbzmBePGbxdzViFHh9jQkW5/Ctzj0Rx9TJXT4+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR14MB3388
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 02/21] block,
 blkfilter: Block Device Filtering Mechanism
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
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "corbet@lwn.net" <corbet@lwn.net>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <90B6F7CCB8C1614F8B050CC51FA58D3B@VeeamSoftwareCorp.onmicrosoft.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On 2/1/23 00:58, Mike Snitzer wrote:
> Subject:
> Re: [PATCH v2 02/21] block, blkfilter: Block Device Filtering Mechanism
> From:
> Mike Snitzer <snitzer@kernel.org>
> Date:
> 2/1/23, 00:58
> 
> To:
> Sergei Shtepa <sergei.shtepa@veeam.com>
> CC:
> axboe@kernel.dk, corbet@lwn.net, linux-block@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
> 
> 
> On Fri, Dec 09 2022 at  9:23P -0500,
> Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> 
>> Allows to attach block device filters to the block devices. Kernel
>> modules can use this functionality to extend the capabilities of the
>> block layer.
>>
>> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
>> ---
>>  block/bdev.c              | 70 ++++++++++++++++++++++++++++++++++++++
>>  block/blk-core.c          | 19 +++++++++--
>>  include/linux/blk_types.h |  2 ++
>>  include/linux/blkdev.h    | 71 +++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 160 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/bdev.c b/block/bdev.c
>> index d699ecdb3260..b820178824b2 100644
>> --- a/block/bdev.c
>> +++ b/block/bdev.c
>> @@ -427,6 +427,7 @@ static void init_once(void *data)
>>  
>>  static void bdev_evict_inode(struct inode *inode)
>>  {
>> +	bdev_filter_detach(I_BDEV(inode));
>>  	truncate_inode_pages_final(&inode->i_data);
>>  	invalidate_inode_buffers(inode); /* is it needed here? */
>>  	clear_inode(inode);
>> @@ -502,6 +503,7 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
>>  		return NULL;
>>  	}
>>  	bdev->bd_disk = disk;
>> +	bdev->bd_filter = NULL;
>>  	return bdev;
>>  }
>>  
>> @@ -1092,3 +1094,71 @@ void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
>>  
>>  	blkdev_put_no_open(bdev);
>>  }
>> +
>> +/**
>> + * bdev_filter_attach - Attach the filter to the original block device.
>> + * @bdev:
>> + *	Block device.
>> + * @flt:
>> + *	Filter that needs to be attached to the block device.
>> + *
>> + * Before adding a filter, it is necessary to initialize &struct bdev_filter
>> + * using a bdev_filter_init() function.
>> + *
>> + * The bdev_filter_detach() function allows to detach the filter from the block
>> + * device.
>> + *
>> + * Return: 0 if succeeded, or -EALREADY if the filter already exists.
>> + */
>> +int bdev_filter_attach(struct block_device *bdev,
>> +				     struct bdev_filter *flt)
>> +{
>> +	int ret = 0;
>> +
>> +	blk_mq_freeze_queue(bdev->bd_queue);
>> +	blk_mq_quiesce_queue(bdev->bd_queue);
>> +
>> +	if (bdev->bd_filter)
>> +		ret = -EALREADY;
>> +	else
>> +		bdev->bd_filter = flt;
>> +
>> +	blk_mq_unquiesce_queue(bdev->bd_queue);
>> +	blk_mq_unfreeze_queue(bdev->bd_queue);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(bdev_filter_attach);
>> +
>> +/**
>> + * bdev_filter_detach - Detach the filter from the block device.
>> + * @bdev:
>> + *	Block device.
>> + *
>> + * The filter should be added using the bdev_filter_attach() function.
>> + *
>> + * Return: 0 if succeeded, or -ENOENT if the filter was not found.
>> + */
>> +int bdev_filter_detach(struct block_device *bdev)
>> +{
>> +	int ret = 0;
>> +	struct bdev_filter *flt = NULL;
>> +
>> +	blk_mq_freeze_queue(bdev->bd_queue);
>> +	blk_mq_quiesce_queue(bdev->bd_queue);
>> +
>> +	flt = bdev->bd_filter;
>> +	if (flt)
>> +		bdev->bd_filter = NULL;
>> +	else
>> +		ret = -ENOENT;
>> +
>> +	blk_mq_unquiesce_queue(bdev->bd_queue);
>> +	blk_mq_unfreeze_queue(bdev->bd_queue);
>> +
>> +	if (flt)
>> +		bdev_filter_put(flt);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(bdev_filter_detach);
> What about bio-based devices? (DM, MD, etc)
> 
> DM uses freeze_bdev() and thaw_bdev(), seems like you're missing some
> work here.

Thanks, Mike.

We are planning to add a freeze_bdev() function call in bdev_filter_attach().
But for the bdev_filter_detach() function, it doesn't seem to make sense.
I think enough to call blk_mq_freeze_queue().

As Fabio already wrote, I use a public repository on github to work with
the patch: https://github.com/SergeiShtepa/linux/commits/blksnap-master
The current state can be viewed there. Feedback is welcome as usual.

> 
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 5487912befe8..284b295a7b23 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -678,9 +678,24 @@ void submit_bio_noacct_nocheck(struct bio *bio)
>>  	 * to collect a list of requests submited by a ->submit_bio method while
>>  	 * it is active, and then process them after it returned.
>>  	 */
>> -	if (current->bio_list)
>> +	if (current->bio_list) {
>>  		bio_list_add(&current->bio_list[0], bio);
>> -	else if (!bio->bi_bdev->bd_disk->fops->submit_bio)
>> +		return;
>> +	}
>> +
>> +	if (bio->bi_bdev->bd_filter && !bio_flagged(bio, BIO_FILTERED)) {
> Shouldn't this be: if (unlikely(...))?
> 
> But that obviously assumes a fair amount about the only consumer
> (temporary filter that lasts as long as it takes to do a backup).

Yes, at the moment the code is being created so that only one filter
is possible. In the summer, I offered a more complex solution, in which
there were altitudes. See:
https://lore.kernel.org/linux-block/1655135593-1900-2-git-send-email-sergei.shtepa@veeam.com/
But this is redundant code for this task at the moment, since only
one filter is offered now. I think it will be possible to implement
something similar later.

> 
>> +		bool pass;
>> +
>> +		pass = bio->bi_bdev->bd_filter->fops->submit_bio_cb(bio);
>> +		bio_set_flag(bio, BIO_FILTERED);
>> +		if (!pass) {
>> +			bio->bi_status = BLK_STS_OK;
>> +			bio_endio(bio);
>> +			return;
>> +		}
>> +	}
>> +
>> +	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
>>  		__submit_bio_noacct_mq(bio);
>>  	else
>>  		__submit_bio_noacct(bio);
> And you currently don't allow for blkfilter to be involved if a bio
> recurses (which is how bio splitting works now).  Not sure it
> matters, just mentioning it...
> 
> But taking a step back, in the hopes of stepping out of your way:
> 
> Myself and others on the DM team (past and present) have always hoped
> all block devices could have the flexibility of DM. It was that hope
> that caused my frustration when I first saw your blkfilter approach.
> 
> But I was too idealistic that a byproduct of your efforts
> (blk-interposer before and blkfilter now) would usher in _all_ block
> devices being able to comprehensively change their identity (and IO
> processing) like DM enjoys.
> 
> DM showcases all the extra code needed to achieve its extreme IO
> remapping and stacking flexibilty -- I don't yet see a way to distill
> the essence of what DM achieves without imposing too much on all block
> core.
> 
> So I do think blkfilter is a pragmatic way to achieve your goals.
> 
> Mike
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

