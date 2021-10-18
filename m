Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ED1C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B4AE610A6
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B4AE610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-NqdyUGfEPl2EAv3Mh6feUQ-1; Mon, 18 Oct 2021 03:35:24 -0400
X-MC-Unique: NqdyUGfEPl2EAv3Mh6feUQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 335E619057A0;
	Mon, 18 Oct 2021 07:35:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 126FB101E813;
	Mon, 18 Oct 2021 07:35:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D88E24EA39;
	Mon, 18 Oct 2021 07:35:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I6N4eg010080 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 02:23:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A3DA92166B2F; Mon, 18 Oct 2021 06:23:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB442166B25
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 06:23:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B65FC18A0161
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 06:23:01 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-533-yBPmAKBONZGavsdD-fmCJQ-1; Mon, 18 Oct 2021 02:22:57 -0400
X-MC-Unique: yBPmAKBONZGavsdD-fmCJQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR1201MB0270.namprd12.prod.outlook.com (2603:10b6:301:4f::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16;
	Mon, 18 Oct 2021 06:22:53 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4608.018;
	Mon, 18 Oct 2021 06:22:53 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 11/30] affs: use bdev_nr_sectors instead of open coding it
Thread-Index: AQHXwciWG7jsGoCRTE+bLjlA7zp0cKvYTZiA
Date: Mon, 18 Oct 2021 06:22:53 +0000
Message-ID: <c3b7ccf9-21e5-144e-969b-1ce91ebab13f@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-12-hch@lst.de>
In-Reply-To: <20211015132643.1621913-12-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e72ae484-f405-48ab-12a5-08d991ffb7cb
x-ms-traffictypediagnostic: MWHPR1201MB0270:
x-microsoft-antispam-prvs: <MWHPR1201MB02707FE119F2A7C91CCA15EFA3BC9@MWHPR1201MB0270.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BRdr+CVyvHY2Raf/Lrv/9+AuR/2D7BesDkEzPH++L9NQcco5EBmM0qDKn6vT64OwhJXwxk5jQZzz4zsprcmhcKQ2nWSeKMnUBiWUA5Z1IJplS9Gp5cuxICX5BmlmTWSLSZhZo6hpuQSW65b9oKQyLJz7Qk0thP16P4d1neeqoxPXJm6M1ZllzHmshtXeKpaeoZUaAiT7CeFf2gnpQ0COCcZ5gqdTWrDz0h9ZE/gv9Yno/Tk3u7oYD2GJ7B5+PCzdxuex0aUiTc1UlE6C4W8wwdbZ06i/0vwHRrBLtAC38258viwyx2OukUDfS+6rbIaFtQRZLkwSF6NwbSEOrPxQoII5VBvGL7M1F8Hp8VgsVZ7FDLwl2Y7qptprNqirhw7IfQJB5Gp1AhwNAYnaU+b8xtTNEUXcENmVWsTxL/1+BuAmygzrrg/xFxzkICVGmzxwE7gNP1nGmXcaVYzTKk3BJcZ6KbO7I3jtA8EUg6p9zhaNX8on0nuCvchJwtvz8J1/Mt8dyhyeJNFhFt62aAsKyzMFcSYazGyMfCcs/oimALeJY27R8fLZ+m1kXRGx14oCU5QKLKDm6r7jSSDsRfHqkmtTgKTjcKgsKUHfu6MYE2ITJdNYE1JeWkndVYfLNN7V6/I/WALd6PZ+eLAc9EwHXJNSQvi9vEKgudUn9wAPrXFIZEuHL7ZbffQBMfOtThKOJpIcgL2BMG8yLf4FvSPn5PM1VwGpipKbMBQfo5HUH6F6wk00z2qRxjGXKyNt3GRIZCceitqke9vNuzAkWEIy+A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(6512007)(66446008)(36756003)(76116006)(38070700005)(66476007)(91956017)(2616005)(316002)(26005)(6506007)(66556008)(186003)(66946007)(83380400001)(7416002)(7406005)(31686004)(2906002)(64756008)(86362001)(54906003)(110136005)(38100700002)(4326008)(31696002)(8936002)(8676002)(5660300002)(71200400001)(558084003)(53546011)(6486002)(508600001)(122000001)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXVjMlNpWWFuNjVVUWpPbzl3NExzRjV0NldKaXRKN3ZLMHArRTdTM1RGeWhU?=
	=?utf-8?B?SnRSeFFSTWJXZ1JGc1VlbWtEQ3JjeU9SVUpPb3AwYURSWUVUQm9taVg5OXRZ?=
	=?utf-8?B?RjM3bTRtdmc2clhYdVJEUWU3cHBseS9jNGpRc0ZTaTN0QTF0WGJHUDcxM1lE?=
	=?utf-8?B?OHpISW1zUGxrSHJxWEd3R09TRlorb1E0WVdTKzZPTVdXcjlpWGFldWwwYWlP?=
	=?utf-8?B?c1BITWs1cXMvRlRhcG1Pb0x1RlVYTkY2VjB2Qnpwb1Y5cmV1SFh4NjNKZk5D?=
	=?utf-8?B?ZU1uWFhHajRRcE5WR3Q2TVE1eEZqY3k0UUswbjFVdzI2b1B0WlhoRk9VVThI?=
	=?utf-8?B?bjAyd1BzY1QwU3Y0bkgwZE0xSldJamVFTDFlUVM3UEF5bGN6cVk1OWtVQldJ?=
	=?utf-8?B?SXdDTTZ2RW51dWN4SjdUUnZ0WEVWUk9wb2trNWtZcldUajVqY254eEpMa09O?=
	=?utf-8?B?Um5jZVFBQyt2YktRYi8zbWNjK0l0bEtWQk9qcXJqdVBBdDN1Z3RxUHVka2Fv?=
	=?utf-8?B?YWlOR3hyTVdnSGhEdkVtbW9YM2gxZmQ1N0g0eEdHY1VDbFE1K1ZEZUZBd1d2?=
	=?utf-8?B?dG9nNlJUbGQ5NFVtQ1VwOTFONTF6MmUzMERaSU0rYzNwZ0o0M2p2SUs1Rjlr?=
	=?utf-8?B?cjdaSUJrMjB5OVVUTW1uK2c4d1hwWUhYZHdja0hCYXMyVUFtcm9Gc29NZ1BR?=
	=?utf-8?B?aDNVOXVhK2JYU1pNV0xsdmU4S2k0bm9hU2svOUduMTJPMFNuYW1jVHZyZDZi?=
	=?utf-8?B?NlFpanF2YzJyazRxajhUbGgvc21HaEhoZ3JUYTh2UnlpVmdVQThzTDFac1NU?=
	=?utf-8?B?RjlnWWxieFBaWDNNV3dZeVlLZzA3RHg4cHZNYnAvcVFGcHQ3eEd3bzBWWm5z?=
	=?utf-8?B?bi91aXp0VFVOUUdsU0J5M3V3TXdVSmpiVk5FUGk5NFZOMm9ETCs4bnhEMC91?=
	=?utf-8?B?NUgxck9pSVpUcUtKQWNRQVdZWTFFeU5TSkk5R082K3ZNeUZKaXVHNDhOSXM2?=
	=?utf-8?B?a2JzZ3IvSmRlVHZqVGF1WmU5OHNkWjVmQ1ZPYXlack9rbUMvUmRKUTNqU243?=
	=?utf-8?B?VlJqTGk0Nk5YZ2IzRXl0MHc2anZzeVUydm1xSllvMWRFcVdYRzdaT0g3Lyt2?=
	=?utf-8?B?Wjh4NDRhZXUxU1NLVHR4Z3oyOCtWQlBkdnY1emVnMFRJTGtSSkgwRUV4T1Uw?=
	=?utf-8?B?a1BkUnlrRFJvT3hzUjVQS3RLNHEzSnhCN2MzNXl4MGxpS0prR2lBM29lYS9l?=
	=?utf-8?B?aEtlb2hkQWIwb05pSGYxVW1MU1ozWkJGdlV5U0lycTgvc2MzKyt6cE5CV1A4?=
	=?utf-8?B?ZGtiUG9YUjdhRUE0SG9QeFBhQS9md2FJczMxMXUvR1JDNUllTms0QlZra1hD?=
	=?utf-8?B?YzVVaWkwdlRoRW5adjRTRmg1MDcxbkdVaDZmOXJQeXpoZjhISDV4bjZLVmRa?=
	=?utf-8?B?QUpVcERReEgva1YrUFBnTDFFc0VxcnFxZmgwbUdnRHExai95UXNHNll5bTFM?=
	=?utf-8?B?RTRpMVlCSkFVdm91T3V6Z2xsTndLaHU2YnBWdzR2dHFCSExTc1BzellWb3R6?=
	=?utf-8?B?b0g1U0JUVnd1VHFudHN6RnhGZVdacUNQazB1TWJGOHc5SUg4QkIvWm9ML3lV?=
	=?utf-8?B?YWFqSk9UYS90a0s4dTBwSjhDWDg0ZlE5R3d4akFWblRsYXcvZDk1dUNFUWxl?=
	=?utf-8?B?V2hXVDJLNnZTQWdsZDdNU09KSW1GYlpBTnZmd0M3YitVMlZaUm55SGpFdWQz?=
	=?utf-8?Q?Wc97SMsLrP9yEN3VBs=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72ae484-f405-48ab-12a5-08d991ffb7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 06:22:53.4843 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oHWw7cbrvZp2P+nj297e5XqkbyCy5tiOoNgFl/JQRP91hrHPR8O9ZtOCTxo115iKECYAwJMWp1iPVwB9RR/Wow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0270
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19I6N4eg010080
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Oct 2021 03:34:40 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
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
Subject: Re: [dm-devel] [PATCH 11/30] affs: use bdev_nr_sectors instead of
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <64D540410AA39A4599DCD51920BC3A12@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/15/21 06:26, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

