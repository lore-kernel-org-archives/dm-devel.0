Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDC4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6EF1361027
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6EF1361027
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-U0fjxQEtMiiXiLnpcfIV1w-1; Thu, 14 Oct 2021 03:53:41 -0400
X-MC-Unique: U0fjxQEtMiiXiLnpcfIV1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1910218D6A2C;
	Thu, 14 Oct 2021 07:53:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF34762A44;
	Thu, 14 Oct 2021 07:53:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C13DA180598A;
	Thu, 14 Oct 2021 07:53:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DMabWK003296 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 18:36:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CC5EF2166B2D; Wed, 13 Oct 2021 22:36:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C60392166B25
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:36:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F262899EC2
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:36:34 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-326-ERltgrpWPlOXqgQ_VUxouw-1; Wed, 13 Oct 2021 18:36:30 -0400
X-MC-Unique: ERltgrpWPlOXqgQ_VUxouw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1472.namprd12.prod.outlook.com (2603:10b6:301:11::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25;
	Wed, 13 Oct 2021 22:36:26 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 22:36:26 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 11/29] btrfs: use bdev_nr_sectors instead of open coding
	it
Thread-Index: AQHXv/MJov1VVTRZAkC+g1lS+pf5Y6vRhZsA
Date: Wed, 13 Oct 2021 22:36:25 +0000
Message-ID: <9e275603-359d-4492-98b5-520bbd15cc92@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-12-hch@lst.de>
In-Reply-To: <20211013051042.1065752-12-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6111eedc-9aee-4185-445e-08d98e99e43f
x-ms-traffictypediagnostic: MWHPR12MB1472:
x-microsoft-antispam-prvs: <MWHPR12MB14725CD4191503C5349D3BEBA3B79@MWHPR12MB1472.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: r9HHMvsQJYFSQtKV3kK7co+vYX8pX/cREePkY7WrcNNoNNKOdjKvYqDpPhj4tUoPAgYiwxMEQsJPmUoht0DBLO5Uo8QHTvcjfM27Y15U6/BmztNrG6zVyLBP4Dp4TOIfyNXWt2n0R5dZq53rPYzkRGDqULQiUU+M1XGyCivhfHCh3FrBHyxiTWwJPjkAHaqJ8Dy/UIl3t7K2uWhkFlYk7SlPpiPm7NVAR4gibjjo9qs1M2ZCO7z+MleFIaNlGjfBAQDKPWT6ToLtcSAH4vwmfyJe/6NQG1qEBZi3i6GLTKdAhHhZx7ZHCZD6g/fzmQVnQvL///9IWbJLmeprCTMQzk8eZCRmqLZQu+gZ9VQqQ2TJE//o0bdt32+Ny0ciQbFof2QZSsdHq86pESutAOp80uzN4OqLt1CWvwiC9obK6+mvxBhDGRcqX4zZpyKaoRXAWW2fe/VcThQ1ePGvZosBBHO5DSUHPn/9UEQYvWVRruCFGk/3nD/VPeyXWVxBHi8NRQArgLJxeRj8gsxbMPtLh0WplZZrU1JKhqKzV5OZesC0egcQyDdKAeE3jwN9qcJQaJm0XX651GOGwnNFCkAF/VXEHw7ulm2/9d7zu0TUJVqmHrUrbBIyn8BFTnGz9zG17kiaO51ECCpHBaWVsHAGc/cK/t8fHIwrzXbDI3ZM3ts0NsUzYEI9uDO1fsu0HFB1/fDHfdy4rIAD93V0S06dAmudxtA4xzF9OjXUTA4sKShPy5MXeiPAH9VETzBMQQ60U5DT0E8p4CNKYF5RolIR2Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(7416002)(66476007)(558084003)(66946007)(2906002)(186003)(66556008)(66446008)(64756008)(31696002)(508600001)(91956017)(316002)(7406005)(8936002)(31686004)(36756003)(8676002)(53546011)(6506007)(5660300002)(6486002)(71200400001)(122000001)(2616005)(38100700002)(54906003)(4326008)(83380400001)(110136005)(76116006)(86362001)(38070700005)(6512007)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0pYcjg1WEVZaGFsVXBkdmdQdUlLa1Jic2hwb0VjZUloaHFWSGtZRlpQU3VD?=
	=?utf-8?B?TVpwcnVqVDliWU1YWE5TLzFZaW92VGNzVHUwZUVUV2U5azFHTktYNEdpdXMv?=
	=?utf-8?B?TEx5Z1ZRS2ZaNmliWlYyeVVRTGhKU0NSNW15L1RhQWdENjdqRCs4STNEVmVw?=
	=?utf-8?B?SWFidkgvSE5ucDBHVytFcDZQa1VsckM1dDByK3czRzRVN0J4Uzg2VTFISWNR?=
	=?utf-8?B?bkE0TW56Y0NiREF2ckpFQjBrYk9SS3I5RHl1QmxrOXZVZTNyVExaMFRZR1JS?=
	=?utf-8?B?bEpMSG80S1Q0TnMrS2lJdWRKaENuRHdLcjg2eXBjNzdxb3lyZzNuUmJhc1p5?=
	=?utf-8?B?dll1TjVjQzBmTmRiVGkwVGVWWUx5UXBaeUtxbGg1YXI1Q2poR3lEaUpGUXpk?=
	=?utf-8?B?alloSWJKRE9mNVFOWGU0UDNjbEdlaTg3amc2SkhKN2oxb0hXMVNuUE1qNlZn?=
	=?utf-8?B?VjN1R0JDM05PTllONndJMTJlM28zYkN3NGV3MThKMDV6Z3BRa0JyOE9zelhX?=
	=?utf-8?B?Y3U3NnVVangzMTNZUmkyVXJvK1pTYlJmaFR3NEc3RTNjSXByMU5zNFZsZXJn?=
	=?utf-8?B?bDFDQ3psL0pUa2dQSXFHRFBhL3NuVHlzTk1DVEtSME5kckRJN0h0VHF3MTYw?=
	=?utf-8?B?Y1JKYzBYSHdvUHQ2ck5FTExGeThQVFZBVVdkL2hSTXQ2VmY5VlREcjBRMG9O?=
	=?utf-8?B?TG41QXlDSmtTbUcydkIwRUI4Tm5QYVRBNkRTaUtRN3F1Qys1TmxQdlc3Mm85?=
	=?utf-8?B?dkZ4UDVyZGI2SUtLdkJkOXJ3TXNmaUM0ejFqWGI5elBtU2dKTFFYVEkzQnpJ?=
	=?utf-8?B?VEh6NEpBRG5JcG8vRkhwRmRiVnp5SDN3aDR4Vk5vNW94SWppNDQ2UHJDemNO?=
	=?utf-8?B?VXBPTE5zelFYenA2b0NGRVF5TVdaRXVvQVliQ25NMzNoNE9qT0dvZUVyNkxi?=
	=?utf-8?B?bmJtbnR2L2RCbndPWGZ2WFU5OEUzelBKL0toUFNBMjg0eXRLb2ZDM2lHcVNs?=
	=?utf-8?B?RitEYmx0UkdvRzcycTZuaXAwcDVQSmJOaDcyWUZVakJnVXpqaHVjdC9OTFlE?=
	=?utf-8?B?TXprREFGd1czUklmVjYzR3lMdHBOREVmOVAwOWw5UWdWTWZtN29qVnU3d1M4?=
	=?utf-8?B?Vlprb3FvMUJTRUZ3ZmkrbExMSkZjbG5aT1dwdHNiZVprWVBPYUljSThHMnB6?=
	=?utf-8?B?ZDc0eHZRaEdEeGpaUlh2Ly9KZVc3RDYzNHdld3ZsbkdkT3JYUUdYTTdsODBC?=
	=?utf-8?B?Z2pWcnV6NDMxUlVmNEVwbnFkUnhBT0dYaFNzK1JXNDFIZ3dMS3I3aWJNYW9o?=
	=?utf-8?B?L1M1aDBDb3I3MDlOQUc0Sld0dWs4NFNnMVJMY05RZEo1aFZQbTdabkVOa29a?=
	=?utf-8?B?MTNDa3B5UFpFdmdaMG5VYkNsV3pleUJPTmNlamZ1YUUvVGlYd3VCcVVpVVBv?=
	=?utf-8?B?VmYrZ2NYczZUMVZwNmxuT1Z5MDNVcnlCVUppVjc3ZDFDRENnZVJRUEhIOTlr?=
	=?utf-8?B?K1Q4UC9zbVBscHl6MDFNcEdRZ1BkWnpLUHJBMUVOSUxxcW43eVNVcmMrdnVK?=
	=?utf-8?B?eWRwaWExcG9naE82Z0FiSktPVkVIajVVR0VRWEIzamNIbHVpSDRCWitUdXJF?=
	=?utf-8?B?NC9nSWdLQjAwNnUzUmkvbzFkb0Z3WTFRUUtycFBnMUNzQ1JYMmJ2a2FjRkpn?=
	=?utf-8?B?dUV2ZHBwMFZHU1ZVTVFDdHA4b0J4WnpKdDJuVjZZeVRrZEkvRlc3bkhGNWZx?=
	=?utf-8?B?M0pxalN1aFY0Tkl2bmFNTFZ0ejdsWGpUVkRaVHh4L2lQaGtjVU1sWW5ma0Ju?=
	=?utf-8?B?RWdydGU2OVZ0Z05wQ0dTcWorYWlLQlhEdExYc0VLQ0R1Zjk2Tjd5WlZ2MHZn?=
	=?utf-8?Q?F1HetC2Ixhil0?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6111eedc-9aee-4185-445e-08d98e99e43f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 22:36:25.8338 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 505xP4APZsyB6qWx2lT1fvQKpgSGtn9qKFqZAZ2XgiNLdpXMuDegy2TXycvJ01ru4RNezUNVKw8LUXzh9SGpug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1472
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19DMabWK003296
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
Subject: Re: [dm-devel] [PATCH 11/29] btrfs: use bdev_nr_sectors instead of
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
Content-ID: <0B96D8945A56EF41ABFC6A6B96A751D7@namprd12.prod.outlook.com>
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

