Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7772C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 330BE610E8
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 330BE610E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-4MLjQkhxNP2inBxlUUufDw-1; Thu, 14 Oct 2021 03:53:35 -0400
X-MC-Unique: 4MLjQkhxNP2inBxlUUufDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E221801ADB;
	Thu, 14 Oct 2021 07:53:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F6F75F4EA;
	Thu, 14 Oct 2021 07:53:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D03BF4EA37;
	Thu, 14 Oct 2021 07:53:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DMY8dQ003128 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 18:34:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D61206D9EC; Wed, 13 Oct 2021 22:34:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CED106D9EB
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:34:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1750318A0161
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:34:06 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam08on2073.outbound.protection.outlook.com [40.107.101.73])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-85-4pGRnOylOuSNPLfw-YBZlw-1; Wed, 13 Oct 2021 18:34:01 -0400
X-MC-Unique: 4pGRnOylOuSNPLfw-YBZlw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MW2PR12MB2379.namprd12.prod.outlook.com (2603:10b6:907:9::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19;
	Wed, 13 Oct 2021 22:33:58 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 22:33:58 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 02/29] drbd: use bdev_nr_sectors instead of open coding it
Thread-Index: AQHXv/Fw+fZmcLtgm0ivWGuz5dJtu6vRhO+A
Date: Wed, 13 Oct 2021 22:33:58 +0000
Message-ID: <473988dd-f18a-3ca0-7b3e-f5ad34f1b045@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-3-hch@lst.de>
In-Reply-To: <20211013051042.1065752-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82b45371-cc14-405f-24bd-08d98e998c64
x-ms-traffictypediagnostic: MW2PR12MB2379:
x-microsoft-antispam-prvs: <MW2PR12MB2379E51F4C87ED93D1735180A3B79@MW2PR12MB2379.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: yc2rUiYBejKEb16Y8tfL5gzu0Ohbg9H7y9NStXHxgHhTYm6o6/HVrpYHPmg4ACugQAC7d8CqoVZb/wB3okQl5ZywXtXLj6N5du38klYVQXd9Gu+/RVUWDsQjAA4o5YaDXV0CYDaqPq3huJlQCnkEpii3r5mAFkJQ1Q6Ddotscy907z67twCV1nAFpIwTqWkBu6u7iBU0wb3K5PSYJhxxES8UPVToI/vRV71O3T6L1k1s+ZFbm7u6Nl364ZIjU6MbPC9yUFjaAWF6RbqUS36O8suOHsP9UuCfXmUe0UTGzqOmUud8UIr0S3Q1mz5HeE0gB08xf1rGQiTeh8G3d0YNzgb3afO7j0y6Ag258GUSvnenzm/SVfPyIMxiM7uCrEETvL3tT8XS/m+yiib1ZwON3WhGCMx01hPcob1voyJNpdVxi8LMhqfRlVD7RJo+/26xsEEk4OvTmpVK99dg4aDD5B6K/ebX7AJrzDovbHFFKy92C/aAIkrS8Rd7y0P/W+nY2b/IhmcVEuQ0cwK346JetkytHJck7Ko8x7agnKvNQB/I+jsdZIbPHhteUkraKcnNAMFSi3miKTgWTkKfareXVGMlj1TB7SBe2bdUNEjc4bC/WnE53d5VznJutxjVL6a0FjIw2y02GgSHW4phu+3EndafWQlKTgeYHKFTffGH+jX2ee16bs/es5ufpnEYsckB3HNc4SLqLIer9QdH9SXHPh3Sadum6tYMxdihWbX1u3oTZ4q55w6Ap1isqS9iM3DwDGRK8n9ic+TimKywGt5jrg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(508600001)(122000001)(38100700002)(36756003)(5660300002)(83380400001)(316002)(6506007)(91956017)(66476007)(76116006)(86362001)(6486002)(8936002)(8676002)(66556008)(4326008)(2616005)(2906002)(110136005)(54906003)(66446008)(6512007)(64756008)(186003)(66946007)(31686004)(53546011)(71200400001)(38070700005)(7416002)(558084003)(7406005)(31696002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2UrellEYXM5NjBPYzdYcjVzRTNNak5CY0VCUWtzc1lENDliS05XL1dZMnhk?=
	=?utf-8?B?dGFiVzg1WElIeGkzZm1RTlBBeFBmc2ZuR28wNi9kdVVoOTJIMGd6VU4rSS9K?=
	=?utf-8?B?TzZBSWNzclhFR2NFa2s3Sjl0UTVhQTl4Ylo4d1VTZUJaR2dBd1lKS3BTSW11?=
	=?utf-8?B?Y2J3Z2JxYkM0RHZkQityMjlzNE5kU0FVL2gwMWQ1OU0wNE9rak9FM3dmUjRR?=
	=?utf-8?B?VFJsN05JMHZZNmc1N3FrS0w4d3hmd3lGUGxHckY0aHdzMFZNYkJCQUkyWVhn?=
	=?utf-8?B?VHN6eCtZbndHQVlwQTRlWEQzZ3NiNm9UamdnZ0hlZlZ2dk1zSlVHeWhnOHpw?=
	=?utf-8?B?aE04ZXFiblhLYS9mUC9Dbk01Wm1LM2RUQ2hOa1pFRStiekhCVGdYRm1wem5P?=
	=?utf-8?B?aExYNFltZWZJbk90ZkY1U240NVRKbnRVdzM4UFFHSlB1RklnWXpCMDAxblZn?=
	=?utf-8?B?RTVzM1R0M2pFNUxGTTgxV2UyTk1qRjRXTUdDVzFEYnZOSnROQ2xhb1FUTkp5?=
	=?utf-8?B?WkhaTy9JcWZRTEZSTS9aNGpSZHNNMnZiWStnM1VXblM4SWozdHFURVFBQVlh?=
	=?utf-8?B?c1MxcXFLKzNINUpqZ2Yvemx4ejdDcXNYbFdqTisyVTNDbmViQ0lxY3hYeFhj?=
	=?utf-8?B?TVppaXd0OU1ONS9pYTZPRFZNb3R2cGVlOFk5OVZYb0s4WmdueFJpWXJmRWtm?=
	=?utf-8?B?d04zQTVOeUllRUFnQ2w3d2N5bmV1U2pTRmpQZ1hiOWhaWStZOVpFSFk2Wkp2?=
	=?utf-8?B?ZHpGMDZkUU5Ia3Z5WHJPTFpnT2NXTmhBajZPcS9OV2VhY2VSQm5PZkNhaHZP?=
	=?utf-8?B?Z0tKUGU2WkVHV3cxN2NkSGQweVJEaDI4N1FySEp6RkJBOUttVmFGbzc2UzE1?=
	=?utf-8?B?K1VIdGZMdW9zeFFVRFNBMC9wVEdXdzlYV0hGRXN2NzFDeGJ1aFoyTFVUNmQv?=
	=?utf-8?B?Z1M2TTVpQ1NJZFdZS3JCNFRiR2hlcSttSlVOMzVDbC9PTjlrTU1zWDN2TEdB?=
	=?utf-8?B?bVN4Y3VZbkxWM1hkSHpwcEhsVjVNbGd6cklyaldHRjVMeFIveGFzb3h4T0RY?=
	=?utf-8?B?M3REaUl2YmNIaC9oK2w1ZTVhcFQ5blU4OUJkU1hwSTBjYlp3WEhhTkdXT3Za?=
	=?utf-8?B?RkVHdE9Nek5XZlBVNVJmZmtMaEdVRXBjTGtEbEMyNEUzaUFBUmdadkNlOFQ1?=
	=?utf-8?B?K2NDbWJ3SHcxVktZQ1NoVGRRMXBEZWYwWlpKMjdVT1VkbDU1ZXhLUnVSdHoz?=
	=?utf-8?B?MzR2UEErOVlYY0lMbmJZQ3RGcVppa0tHZjVyaDhhT1Y1UW5NeU1PTnRIb1dZ?=
	=?utf-8?B?eHp6NDdYU0pzck91UEQzYURIT3gzMlp0T3VTQ1Ywd2dsVzY3S0RJNmZJOXVm?=
	=?utf-8?B?TjNmbHlRdnBiM04xSTU1alhNcTVKT0JIMHlMUm8xZno0QXRoQmpMMHJSd0Nh?=
	=?utf-8?B?MGRDN1pJRmkydzluSUhlQkd2eDFJNldKdzY1S0FTNGtlTlNzM29kWEUyUE4y?=
	=?utf-8?B?YUNrdnlVSjd0b2VKRzUveC9SQU1lSG1Jd2cySjdTeU0yWEJnOHNuTWc0ZVdj?=
	=?utf-8?B?OU11V2tpNmdWeUc2emd5dnBOdUVSclVDOXJJVTA5a3ljdmthU1lybVV6Mm5y?=
	=?utf-8?B?Z2hHYVZtcHcxWTl0ek5kRi9EdWFWT0RlaFMwL2plRlhzNXQzODlKQjNTVmt1?=
	=?utf-8?B?VUFQNUdmZElZZ3JrS293M0w5TU5XTElrWFR4ZDR1NzhuUndPUmthM0k4MHVK?=
	=?utf-8?B?cENaOHA5enhjcmRZR0REMlFaOFpIN0pDS1B5KzJINldGR1pGMmhWcm90ck0w?=
	=?utf-8?B?Y0Yyc081RUtKQWY0NlZIOEpOWTV1YUNoeUQzdEdqNmRNVUNCajhyRWNzOVd1?=
	=?utf-8?Q?LLSYYjlw9Pj/w?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b45371-cc14-405f-24bd-08d98e998c64
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 22:33:58.4460 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUXTUhN7+/pSfSk2Q8INU7sTSrLD8giM4dtXzKen74fxkniAVtH+59sgrSc9iRqeHqxYKyJSInGCb0g8228cXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2379
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19DMY8dQ003128
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Ryusuke,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, "linux-ntfs-dev@lists.sourceforge.net"
	<linux-ntfs-dev@lists.sourceforge.net>, Jan Kara <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	"ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 02/29] drbd: use bdev_nr_sectors instead of
	open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <43BBE4AA93E9954CAC870DE93CD2159C@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/12/2021 10:10 PM, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

