Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A4BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 87BC761019
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 87BC761019
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-QJwzunGyPJWzDpaWkZOpgQ-1; Thu, 14 Oct 2021 03:53:36 -0400
X-MC-Unique: QJwzunGyPJWzDpaWkZOpgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4497391270;
	Thu, 14 Oct 2021 07:53:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24DFB62AEE;
	Thu, 14 Oct 2021 07:53:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA2C71806D03;
	Thu, 14 Oct 2021 07:53:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DMYjUX003159 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 18:34:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6A3B710F8E3C; Wed, 13 Oct 2021 22:34:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6510B10F8E3D
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:34:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BA7C800C00
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:34:42 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-474-VYhrNGrvM6qBuYamVtLOSQ-1; Wed, 13 Oct 2021 18:34:38 -0400
X-MC-Unique: VYhrNGrvM6qBuYamVtLOSQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MW2PR12MB2379.namprd12.prod.outlook.com (2603:10b6:907:9::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19;
	Wed, 13 Oct 2021 22:34:36 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 22:34:36 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 23/29] block: use bdev_nr_sectors instead of open coding
	it in blkdev_fallocate
Thread-Index: AQHXv/UY3+v30jgLpEyzTPRn+nXvE6vRhRWA
Date: Wed, 13 Oct 2021 22:34:35 +0000
Message-ID: <929af081-c794-dd38-21da-32d585680194@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-24-hch@lst.de>
In-Reply-To: <20211013051042.1065752-24-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a4ae89f-54c0-4ea0-7a8b-08d98e99a2b5
x-ms-traffictypediagnostic: MW2PR12MB2379:
x-microsoft-antispam-prvs: <MW2PR12MB23794BAE24DAC36C038BE554A3B79@MW2PR12MB2379.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hUP331YAayu3mNKM5yn0kE2WHAS16PcbYBgOlfTvyn7XJ+BzSWQ2s7AF0iR/p78/WpYeDM/avouMwd7xHlmxqCokKQ9lADCBWKcYCn1rnuWy5+JdCSTpRzgg7uCgk/GIhD9RQ1QoumRh91VKq0U/Fefi7BzU1/rEfxOxwjpFIoLd+SPJpKQoc+PGKR2jztQFEznOdb07NS3WfuwOVYLRZgjXrnQQLbWTlEFqKq8xluirJEozRhBDW9jL1je9Np0kOOSXiAp/JEgGenoWvC/wo5M1hH/Y7SWTBUk1qrjYAjP154cI4PbeqoJEArNsNDjSSwqFOXiuw8BCxv6vjTCeT5ZaqHNT7LI2w3IY+Wr4v4gOxXCz4+YCicSzUwwNS2/kcw3/Su7N8D7zkQ40dLukutv0o+K3L0ioNOyQTQJ+b/9CojlU8Pikr+ZezSVhmM3hpqDfXUMFAucEkloy8YDnzCIhyc8IKDUwjNWTkF8anKap5cOBD68AgGtB0jPlEZEKDV0XMB3xjS3HEs8BuRUnNY86+P3IPqq5x2s6mZASTZSEJ+uuvcC499aU1TTXswhRXizCl/+UaduEitR66IBgvnMmipNNeURp1mO5SU4w1hgaFHH3ib1TrR6lNSoP/3q6vE+nOZWe5FZEBlSyJd8pQ0OrK91VKd/tsJSJDtQB6cexYmaQAqA+6/IZmrJ21lwSgqZloeN0Ohustp1zulOLDK5IIU1mzY7xEk+lPoy/RSKFS9QYWpkVDGhFtJYrxaxIBL3+hyARGMdSkkUYHi2AYA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(508600001)(122000001)(38100700002)(36756003)(5660300002)(83380400001)(316002)(6506007)(91956017)(66476007)(76116006)(86362001)(6486002)(8936002)(8676002)(66556008)(4326008)(2616005)(2906002)(110136005)(54906003)(66446008)(6512007)(64756008)(186003)(66946007)(31686004)(53546011)(71200400001)(38070700005)(7416002)(558084003)(7406005)(31696002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVNWS0xyM2laa1M5RFhYaDJJTFFsK1NONlFIUFVVbVZ1RjgyejIrS2hsZnpt?=
	=?utf-8?B?b1R0SlIzQ3N5MDgzV2g2SFNHWU42VjhGVERSeGxQakE0UUZzbTZQSXJUcFVV?=
	=?utf-8?B?eVR2R2Q3d2ZwMWpiN1VTQnd5TG5xL282dlZOV1lGUnJ1TktvZmU5bEJxR25a?=
	=?utf-8?B?eStFcVVJUkw2Uy9IZmcxQlc2SmVReU94d1ZnOUVITnZpZ01zOGhwUEltVjN1?=
	=?utf-8?B?Rk1WSTlldDRoL3ZncG1Ub2tvQjRYdUFWOUd6OTJXd2lEUGJDSC9NMTRZeWZW?=
	=?utf-8?B?MkxTOWIxUlJhOVZ6dEQxa1U0NytNcEI2Yk5ZZk1telpHeEJTMjR0ZUJidXhy?=
	=?utf-8?B?QnBkaVJIRFY5dEs1NEozUmZmRHF1QkN3ZnhjdnV1N3A2b3kvZ0pXckh4Qy9F?=
	=?utf-8?B?Wi8yM1RiaVhmTnVaNXpzRFBYbHVQcGtYRXluU0VBaHJpdXVuVVA5VzZmVVhQ?=
	=?utf-8?B?ZlpDZUh4UHFlcDlhMnpIQlpzaWluVGZSb0RQNzhuMTZLalhiT3VZVy83MVEr?=
	=?utf-8?B?eURieXVueXVKSytZclMxaUxYMzlFaU1HUXR1WDgzQjlZMVRrQ0VVeGMrSFdO?=
	=?utf-8?B?dzd3SkFKeWJnWDdncjl0YWdkR1NvUU1mSHRSWFZIbDhmc1Y4OUxLVGV3ZGJv?=
	=?utf-8?B?em9mclB3TW9xVmVScDBYWEdZbk1Xa2NDKyszUWIrMXlKdmxhcGllVHN3MXo1?=
	=?utf-8?B?UzNFenBzS3paTGVWVThOZURLcytaNi85VkhHZXJPN21HTURaSS9Ia1dULzU0?=
	=?utf-8?B?bTNxYThOaCtKaW5zK0Q3N1R1YjJnWHR6UlZJREMvQjJEdWtUWTk1S2dhd1lD?=
	=?utf-8?B?a2JoVE9rZ0RJUVRNbG1zb0RURlMzUi9BSldmcTNlTWZ3NE1KelBYdTUyeUxs?=
	=?utf-8?B?d2thTmx0UzJhZlBybSthVWVqcjJWSndMQ3Vobmp6VWpxdUdNRHZjR3VtQVhy?=
	=?utf-8?B?TnIrVHBGWlVWSUVOR3FtalVpaTVmbHFqbkpITDlEb1c2Y2szUEhKY2tiM0tq?=
	=?utf-8?B?bXNROGtBSTRna0dONytIVlAvQ05oNmR2TGFFTFBHb21Ya3VxRzJCbW1PaUhD?=
	=?utf-8?B?SzV6UGpwM0lDZUpPVkJaUkNBeWpxNmp1eDBwYkMrelh5WHZUOXJieVd6VmhK?=
	=?utf-8?B?NzVtcElhMXM5SDVOYktkeFl5S3BrMjBuY3NrQTRHcGkvbjVZRE10dE9mZzlj?=
	=?utf-8?B?d0dqN0xMNStpWUpvQitQOC9RZFhUeXppdEova3JvOUdCSkpQZkFLSVVMdFpB?=
	=?utf-8?B?SEZvd3hiT1lvMmFzMGVjN1IwbitZajBHWUE5U3hhd0h4a0ZKa0xHOXpNU0xr?=
	=?utf-8?B?akFxeW5MRnkwaUh2ZnhKQVZQZC8yYzdxL2NUcnpTQTdRckhZc3RSbjlTN2Ix?=
	=?utf-8?B?cGxxOG5lODYrN3pVL1ZXeWdaVGI0NTBKL3E0R2s0bmlvUG5LQlVseFhJN09j?=
	=?utf-8?B?MzhVRFZYM2MxSXZUaFo0V3hqenExM0NnU1dTa2FpTDRaajArUGFjNHRmeU5Y?=
	=?utf-8?B?VjBSQ3pTMjdhanpWcnpSdTFmZHNvSWRIY3BYZUxsdVpleHVtS09FdVRIRWgr?=
	=?utf-8?B?ZVpMSW50b1ZNZ1k3dlRaQUIzdkgweUJpOUpHbmgwemU1NjVTME1YYzNmNWh2?=
	=?utf-8?B?TXlBZ0ZxdzJabWpuMnZvWjFhNEJ4Y2ZQSkRuV1ROTEJLb0pkMjZjekc3Q0tJ?=
	=?utf-8?B?U1VWWUtvajVZNzVKM1VEekhxeHpxNTJLNFdmWUFxV3VRYXFSb2pkclJlR1ha?=
	=?utf-8?B?cE1DYjg0OTl0UXBHMUZPUVB0QUV0US91di9lRmEyNldqZ3JVS013S0hHbDRT?=
	=?utf-8?B?WHpQSFNBcFZaYUFCOG5EMHJGeGFGeG5wV2U3Z0VON1IyZEhXV3laYW5Rc3VP?=
	=?utf-8?Q?QX0UEnENZE393?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4ae89f-54c0-4ea0-7a8b-08d98e99a2b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 22:34:35.9219 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s40RYjePxKgxd5rYX0Q+hYk3Gr9drH2ZRzVjrCzbJepqiyyzRopp15cbaDopGq8+1P4IhjP3ix38CXsymGdTNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2379
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19DMYjUX003159
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
Subject: Re: [dm-devel] [PATCH 23/29] block: use bdev_nr_sectors instead of
 open coding it in blkdev_fallocate
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
Content-ID: <DDDFDB2C29E4994CA98FF6A1B819685A@namprd12.prod.outlook.com>
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

