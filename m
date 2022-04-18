Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F3A2C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-yj5gtEATNWWno2-igePmCg-1; Tue, 19 Apr 2022 02:10:44 -0400
X-MC-Unique: yj5gtEATNWWno2-igePmCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26D591014A6A;
	Tue, 19 Apr 2022 06:10:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3A2940FF41A;
	Tue, 19 Apr 2022 06:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F0A21940374;
	Tue, 19 Apr 2022 06:10:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CA141947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:23:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 317BA40FD37D; Mon, 18 Apr 2022 21:23:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C85E407E1C1
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:23:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FE463804072
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:23:12 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-EXp9GNwuPouroZzWI5suvA-1; Mon, 18 Apr 2022 17:23:08 -0400
X-MC-Unique: EXp9GNwuPouroZzWI5suvA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BYAPR12MB5703.namprd12.prod.outlook.com (2603:10b6:a03:a5::32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Mon, 18 Apr
 2022 21:23:05 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 21:23:05 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 09/11] nvme: remove a spurious clear of discard_alignment
Thread-Index: AQHYUuBcFEm/XfqSQ0uW2E3HX2krVaz2LzqA
Date: Mon, 18 Apr 2022 21:23:05 +0000
Message-ID: <66df636c-b98a-23f7-20f5-f124109b81c1@nvidia.com>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-10-hch@lst.de>
In-Reply-To: <20220418045314.360785-10-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ea33572-46a0-4def-4816-08da2181a0a0
x-ms-traffictypediagnostic: BYAPR12MB5703:EE_
x-microsoft-antispam-prvs: <BYAPR12MB57034654840D806181EA4705A3F39@BYAPR12MB5703.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wZRIafoMZ+RNEv0jR3059UeyDTFK32ryaMGSLWdws/jWK1ZLHE9hYQAuxaagMVs/LEd/tpZiQVJDQf1nmESaKq+E5Cog4yW9qJs+ajxMRBm0ihATE22BxMXT67QvxcLPHLKUxtogqLjr2S3bccK0HG8KLBQgdD7S4N1dtflpco/vndZ9fHtv8ZVS44KE+gAB7iIu1cFQeZX00WRBwVkiIPbxklRZ7reZXWoinrMqonA+BbWykmn9TA6hOVhJkz+a4LV2zrC2nBas3p2lgORI24Re5BSDJaXDU71ZPwsW/FJY3K58yAj/q3xPJWAvcAzpClVyBI/ieTTMTanbP75jut6qk8WNQb7/Vn0m7SA19hWgKnRK/K+ONQrHCQR5N78AMkwuS+Fsl48/Y0Om1/cP0nF7aWaKnJ6dhQvQgK1wY+Lnmvoy+BE6li5iHNeJW1nlfWQ/A3HXyZ2MKDaObYA841BmXGhg3Fy4GVlTz/bkvccGcD5D0u5ncn7CJd9BRyI9HT4voIcBXJZEfYvnhiMQWgI+awGaihUto+et5YyvXTdHpJX1lg0tU6U3DQPO1sdLiez5LvX+/BVai9Rkxh846t7jct1VZnTXRVGqZYkIamc4I66l6G1W2ypSWvc6XABmk2hgEj3iAZbAcCsedSHS6h5dAxJXHpYA9nR2zGUkWfm0HSdv/eRAd8LZ6qz4Zjq5pVf670aNRxbNeWA42OmJ1kRJ7dXwgG38AMo2qb1kid+PSZXlzehAFA+FXLA4LD+7+h3ile31o23bjx8fvRA7Nw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(558084003)(71200400001)(86362001)(5660300002)(66946007)(76116006)(31696002)(186003)(316002)(38070700005)(6486002)(38100700002)(2616005)(122000001)(66446008)(110136005)(7416002)(54906003)(64756008)(91956017)(4326008)(8676002)(66476007)(66556008)(508600001)(8936002)(31686004)(6506007)(36756003)(2906002)(6512007)(53546011)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3JyUHJGTk9VOGd4ejRtQ2k2SktOU0RoODU2STdRZ2Juc1lvMFFsRzdBUkRm?=
 =?utf-8?B?b0hxTGpHME5nWGs0bkxZRE5KUUpLZjg2U1NmY1VLUHNRVG56YXVEMnQwWHRL?=
 =?utf-8?B?YXNGQmNISmNxQjRxV2F5am1VZU5sV2hhb0ppSGtUT242b0U3OWVyUTE2eGt5?=
 =?utf-8?B?cnhLeHpNRC9uQ2hQNTFJNE9vWTkxUVRndmpnYmYwVjdqVDJnMldhVFhxVmhk?=
 =?utf-8?B?RTAvbm9yZVYxbDBDdlpWblJxRldKMVk1OVcwWi8xQWhxd1JVN0kzeHpsRkZC?=
 =?utf-8?B?M1YxMEoveUpVT2YxZFB2T2NmSkNBOGRlV0p5ZG43STJBMW1vVFJMdXNHUXVK?=
 =?utf-8?B?K1UrL21mcFk1Z3Nta3N2Y0xncE9tZnB0S1FKTzF3OHQ5VkNvYUtxUEgvYkVR?=
 =?utf-8?B?Y3hnWmY3ZGdQZEVuL2JaK1FndE9iaEJxbkJuSmFkZGFxckEyMTJkdEJ0VUFh?=
 =?utf-8?B?M2VlbUxXTVgwWUh5TGxqbkQyNUVTU05QcHRBcm1XQUNla0VKTzY0UUFYODAr?=
 =?utf-8?B?MjZucUQ3VDRpazRZRTFWeGt2QXZDWXhrdWowTjBUUHpwYUVvK0dYVnpiVE5l?=
 =?utf-8?B?Q2NKNEo5Z3ZuSlN4bXVvK3FvaHlUdHJTZVNLenBEQm53ekpiekxNeGYvOXZh?=
 =?utf-8?B?WUZLQjR6dWlXczl5VXFmVXg5TkplY1UzeWdVMGFzTmlaaGlBZjJETEhVbjhx?=
 =?utf-8?B?eFU0SXdBZ09zOEZtQU1rc2tIR1NlRTFzQXNzZnpWM3RCdE5rOXZKV1FwMksy?=
 =?utf-8?B?NFBralNBei9kOG1PWlhCZmFFa0szY1I5WHlZR3J2am5FMEUwRkp4Zk42VTc4?=
 =?utf-8?B?N3J6L1Z5YURoRVphVjMvdmxiR0NwMForU21QblVXUWN6Y2hOVTM4LzBqeUM4?=
 =?utf-8?B?NXV4aFlLUFFrdHpza1RtN3A2TkhDYnN5ZEZuRnlQVWRta0JiQTd1aEVQL2d0?=
 =?utf-8?B?ZlVXVVUwdllzTzFYN2dqQWVhNjYxVGZ5bUJEMXM0NGZHdnlsUUFSRFVVU1FF?=
 =?utf-8?B?TzhJQmhpZ0hZSG1oVjl0ODhsRXlYOC9lVVBETEZlaEZXWkhhNENnbytlYlJP?=
 =?utf-8?B?bnpyVXlMaE5XNzhUMFVYclF2aTFFQ2d4ZkUwTFhuUWxTRmpiSmYydnFYdHhh?=
 =?utf-8?B?bG9BWFp3TFcrVW1KN2xBWm84dnY1N3FoZ0NQcFhYRGtIeUM3ekxrVGFXL2Fk?=
 =?utf-8?B?NWRZQkVHZm1xb1I4RUt5Q0lKb2d4c3NSNkdlS1ZhTVptNjBQUUFhZHdXS09H?=
 =?utf-8?B?ZGxINlE1WDAzOUZNNlJObnVuaU93ckY1ZzJpMW9rYWN6c1RNdkZJdTBLTXZK?=
 =?utf-8?B?S1BJZnF1YXEyWmpiNVhNNXZ0d0FxZ0dDZHFOVm1URi9YUzMxc0VBMWFuSm94?=
 =?utf-8?B?L0xBWDhTUldOQjJZOG8xYnVzOHhWVzBvcDN4UmJmN0VadWd6OTZIVE16TTF1?=
 =?utf-8?B?OUxVbCtOOVRZR0oySW8raDhLalh6SDhwZXV4ZGI1aTVFWkh0ZTc3MUwvS1lC?=
 =?utf-8?B?UjVRdE9NWDJrRWdMKy9iaXRMMTV2c1VhLzBFVW4yU3JTblpicHQ4cDVPNC9n?=
 =?utf-8?B?b1VpTVN4b0VHalZVTzJrNFpTWHBreHU4L01IZE1VOU9LNHh4TWRBcXFtY1oz?=
 =?utf-8?B?RWVvVDYvYmRzUCszVE1adk4rNUp0Y3JSOHRNeVdOd3lvZCtEcTdWMFMxQTFM?=
 =?utf-8?B?bWNHVytkWXVjakNmKzgvV1RzZ01EWGFZdFRHYlVHSXNFSGxFODZqOTJJN2xI?=
 =?utf-8?B?RllFTHBybk1zeUxnU2FEbVBRa2tGWDNWcTRScTE4TWtvQ1R2bEQvQ25SWFd5?=
 =?utf-8?B?d0lWcWw2aURlYzR0VDZpay9SZy84VGVSU2tCSnlLOE9ZZ3ZseExMU2pUM1ha?=
 =?utf-8?B?bzg3SjJSc3I1V21Xc0FPOUVrci9LQmx5SkxpZThDRjdkTTEvdVk2ZWF4RXp4?=
 =?utf-8?B?NEhlK1NKdjBiU1gxT0k4UFA3U1l2cWRpNlprSnd2cVQ4SG5aWWIrdTRKVkto?=
 =?utf-8?B?QnFNU0hucTl1QWRwKzJaUFMzNTN2aVh2dGRJZEdkYUpKVCtPY21sVUtWbHor?=
 =?utf-8?B?L2ZRSkZBYjVQK1Jpd3dzcTNQRmltaDVXbVp2Zm4yVUE5azdFUTc5MEtWdVJ2?=
 =?utf-8?B?Wk1XQ0NmTEJHQnptT0tpNERWdXVzbk9xbG11VDBjMFpQNmhqK05tMkNKaTAw?=
 =?utf-8?B?T0tkbVhwSjZrMDEzR0lnMDgwak8zZVlXMXg5OVNlOWdBc0trSnpyellyWERK?=
 =?utf-8?B?L1dtT3FLaTYvUk9RdFU1NEFOSHFhOFNHcTJHQ3hBMkNDbSswUkd2K1JBMUNS?=
 =?utf-8?B?R0dUWEt1eTJXWExteGIrczUzWXMvVXE3eUIxejVJdVFneEQxZFR2SzBJVDc5?=
 =?utf-8?Q?3ThODCQ/tQz/cwX0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea33572-46a0-4def-4816-08da2181a0a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 21:23:05.4140 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bX94/9AH8QVpG+ra0QBfSC7XQkW0/5sNBc2d1BEGlO4VFk0lgNSO6gOFfRnduTdTtrVmVUtGs0aqwIqvFg029g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB5703
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 09/11] nvme: remove a spurious clear of
 discard_alignment
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, Song Liu <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "Md. Haris
 Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 Richard Weinberger <richard@nod.at>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 Mike Snitzer <snitzer@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Stefan Haberland <sth@linux.ibm.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Martin K.
 Petersen" <martin.petersen@oracle.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2261F5F6E0810744877DAE4E412E6B80@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/17/22 21:53, Christoph Hellwig wrote:
> The nvme driver never sets a discard_alignment, so it also doens't need
> to clear it to zero.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

