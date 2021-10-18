Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66164C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB00D610A6
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EB00D610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-iQEVuoqXNnO53bYD9fGZOw-1; Mon, 18 Oct 2021 03:35:16 -0400
X-MC-Unique: iQEVuoqXNnO53bYD9fGZOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CCF89F92A;
	Mon, 18 Oct 2021 07:35:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B21A5F4EE;
	Mon, 18 Oct 2021 07:35:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96CF21832DD4;
	Mon, 18 Oct 2021 07:35:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I5kcpF006778 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 01:46:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7988D40D1B9D; Mon, 18 Oct 2021 05:46:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DE940C1257
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:46:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D3F6185A7A4
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:46:38 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-336-VWRUM-tAOkqrZdzo6zqWeA-1; Mon, 18 Oct 2021 01:46:36 -0400
X-MC-Unique: VWRUM-tAOkqrZdzo6zqWeA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1136.namprd12.prod.outlook.com (2603:10b6:300:f::14) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18;
	Mon, 18 Oct 2021 05:46:32 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4608.018;
	Mon, 18 Oct 2021 05:46:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 03/30] bcache: remove bdev_sectors
Thread-Index: AQHXwchkeC3IRJLxik+08glUYT276qvYQ3EA
Date: Mon, 18 Oct 2021 05:46:32 +0000
Message-ID: <b910c530-1aee-c9f3-c9f7-42c89084c83d@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-4-hch@lst.de>
In-Reply-To: <20211015132643.1621913-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60fa8628-138a-4118-83f3-08d991faa3c8
x-ms-traffictypediagnostic: MWHPR12MB1136:
x-microsoft-antispam-prvs: <MWHPR12MB1136576339658024B5ADA92CA3BC9@MWHPR12MB1136.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2Ovws/QzAIktCBj8yjmrkzjx187FWf75B1nkRjlq3IyfxHLJqc8SSctXjniRNgCIB3LIzUuyy5StZeesVE8hlG+GfkQ61+/FY5BnlAZEZHYILmR7A5GhhZjj90A5i+/EtyOncsqeA5w+T7MVNzvxkCka4nc2h6yUcqZAtiKKhkymezHkxGXOQjCLzwc609X8uqosHOKp1UbJgABX5jzbRgCNGsm5hehq1/fZizgTICineCIsbsZ0aOVR6aZw6LUGjidWrhW8dd6+fKUO1RYlLFcexQMB7UxVAqjLBN9KrI0j412uoI+e0e1AuQ4axYFUBmV+e+oNL/dMlWs9m6OF6V/EXKD+VSgx+t/pADG1lFY7My8ZL67e63hpgk49HPBMsV5j2n7dsZQ3N0QFkOTtp12Tq1RgyD6sPdNPzVxg1z3PsxwTtt56Sc6Wo9KLQj3UkibhHtPTmkfB+KvkHzSL8IcLJPJ0xcvGhC10dUjjR4juPC8+aqUL96QlKyp+VocmZjbD6U14oOJTsHIuiLfcLOrV3s8QEwoomRQhy+g3UMVK4O4VyfCmt6iKPjWrdoF7fm7GTD0hUhZFRxKlz28so4JwqdANYoT3BglQ85vtqjp2C1f3khFPDH5GVVShB3gY+1OApwRdE9BgkHmo9J94xzgaLWCopYMcayWYZK9RbW2vGMCpuSxynVxSWFsVub+DpjNxdBDsjVHRV94o5B7iotLY9qEqfvjYhgf/LpexeC8GNzm4+SSGb27CEP7+OSE9rU9nI31RCpCL2IMbvjltRA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(2616005)(2906002)(6512007)(86362001)(6486002)(36756003)(122000001)(558084003)(7416002)(7406005)(31696002)(110136005)(71200400001)(316002)(5660300002)(66946007)(66446008)(91956017)(4326008)(76116006)(53546011)(66476007)(64756008)(54906003)(508600001)(38100700002)(8676002)(186003)(8936002)(83380400001)(66556008)(38070700005)(6506007)(26005)(31686004)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1E1anAzb3hpVGtRM1Q2WTRzcXJ5ZjF2K1BsVEplY1NjZTlEUWowZnNUaUtl?=
	=?utf-8?B?T0M0V01Zcm5LcVQvUEF6YW1YZGFjVE9iZ3FISjBHL2lJdVk3V2s0cmwzeXd5?=
	=?utf-8?B?THY3Qm14VHNldHBOVCs1WG95em5nK3FzNU4xWmh4alNLN3IwdWxFUkRoT3ky?=
	=?utf-8?B?cGdDNlZmUUFxdk9BK0R3M1l4MjNYTzNBdDV2WHVVd3RHRFlkUXFqSE9lWVRO?=
	=?utf-8?B?a0kya09ycmFSbjZlbDBURHhuZngyRTd3VUV5V0w5Y3V1UWQxRGFldkxmYzR5?=
	=?utf-8?B?K1Nkcy9nS2tBMzlIOWUxN3BDWkJlTU5TenR0c1RWQWJDZ2tQMDZQckpWb1dr?=
	=?utf-8?B?QWQvWFFtamNiQkFOdjJkRnhVSFdaQm04RUowV2lCV2xLdUx3cVBFZERyc0ls?=
	=?utf-8?B?WTZ0dWtDZnRYNlVLZ0RvRlFMYytlYzk2Z3QrSlgvU0h2WEdnWjBJREVkNEJJ?=
	=?utf-8?B?TGlOdWlxZnNmeXhXbmw5UDlsNnYwN0hkS253TU9HU1czZFF3aGovZjk3MU9T?=
	=?utf-8?B?ZG85OUNON0VPM0g2Z0JXZzdkTUk1WStHUVRUa0UyL1kxOE5GVWRKMjZLQ0or?=
	=?utf-8?B?aG1LeVpzeUxvZm5GSzdIVGk2OHpQeCt3d052SnhZZ2JiYlkwcVJPV2hrZGl1?=
	=?utf-8?B?d1c2WDdaUG9renRmbGNLYmNpSVNGT2pTNXlQc0l5WUduVk5tWXplSEkzaHNP?=
	=?utf-8?B?MjFpYi9pV0RXcEJIQ3BGWFhVcFRvRE9odld2THVNYlp4MUhmYVU5cE5UZk93?=
	=?utf-8?B?MVRkQlZ2dU96cUE3bUFnQVFlN2RGYzZqZjNmTEFjWk9Nd0ZoS1g3NGw3L2Jo?=
	=?utf-8?B?SFBUZmhsZ3MybkdMU1FCZjA1UUluOEZjdVExZ0k2MUthV0NQY3ZmOWx5ZXlT?=
	=?utf-8?B?d05ZUzQ2RzNMZTlCVVpWTHpGRW1VdktWaTdaWkJUN013VFlWMGVqeWx5RDRG?=
	=?utf-8?B?ZXRGZGFXN3l4bk8zaFQ0YnJZdmhuU1VDVHUrQzhWYXZFbUQ3R3NhZkdaNW1V?=
	=?utf-8?B?RlBHeE5LeXc3S1hLZ1d5cy8zM3liQlRzRnBjcXlQTTEwbGdiaThFWjZLaWQ5?=
	=?utf-8?B?SGI5d3Z2Mm4zZms3WVpvUUo1NXU5alFFQzFlVUdHcXRydVZlay8zYWUzL1k5?=
	=?utf-8?B?RDBTNzhYcm5NRHRFY2ZJVkJpeEU1NHpYQUVDbUJ1V3hIU0lwVnRNdTRBNjd6?=
	=?utf-8?B?eXRyWkpwZDhLWHVpRDYrQ2xiRFdXd3dzU1h5YWtZSEpXU2c5VDNMc3FMNFEv?=
	=?utf-8?B?STR4YllhM2JjVGxLb1dXZ3lGOXJkMTM3VGlaZWM1a1ZqQmJDVFRoOXFEY2Vr?=
	=?utf-8?B?b2xydE9oMUlHVlBGc3A5c280VHU5dzNXNkRxVnMwcmJZS0tvUlVFRmpFY0VX?=
	=?utf-8?B?TnYvT3JDVjBza1oySGNyVDUzUnF4S0Exemp1d01WdEhZckRKVmFPZS9YamFn?=
	=?utf-8?B?WDlsTWpzUkllZ2dFMzRxdzM1RVBjZUZkeUxPNFk0MnYyRlh6RmxiekZJZG5u?=
	=?utf-8?B?SjlIZUpEVjYzQjFFL2pQVkViZ3Q4N1liL1ljbjZwU09YNmRwTEorRnltbGxI?=
	=?utf-8?B?S0RWeU05cThCR3hHYlk1UjdDOENVNHNkRGEwMUpGV0srSHVPR29NUG8wQ2da?=
	=?utf-8?B?cXA0Y0Y1REZhQVFwa3Rid0NSMkR0c0pBSyt3STNqSjRnWmRzbFNtUEM1cnly?=
	=?utf-8?B?aEZ2Q2tpSkZ1NG4wSVdkbmx3cXZDMEtLenJhSUQycXJyRlIrb3lNTHlza2kr?=
	=?utf-8?Q?eiM1JOOphQEHs30VRs=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fa8628-138a-4118-83f3-08d991faa3c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 05:46:32.3865 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cewEDTdIBUFBdh3Ewz5MXnO2NXTGZxza+AJJU7u+pIhg/FLIaPQZY93VmNCW33VEzRcWlzFBX+qel49RHX3Rng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1136
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19I5kcpF006778
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
Subject: Re: [dm-devel] [PATCH 03/30] bcache: remove bdev_sectors
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
Content-ID: <276A457CC12A29429674DCE72537FB49@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/15/21 06:26, Christoph Hellwig wrote:
> Use the equivalent block layer helper instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Coly Li <colyli@suse.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

