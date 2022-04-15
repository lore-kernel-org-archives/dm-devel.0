Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2BFC4167B
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-VcS6IiJkN8CeMvOvleRBjA-1; Tue, 19 Apr 2022 02:10:45 -0400
X-MC-Unique: VcS6IiJkN8CeMvOvleRBjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 236993811F47;
	Tue, 19 Apr 2022 06:10:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EDE0145F94D;
	Tue, 19 Apr 2022 06:10:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 93D671940347;
	Tue, 19 Apr 2022 06:10:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3CEA219451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:40:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19DBE404D2FC; Fri, 15 Apr 2022 05:40:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1534F404E4B5
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:40:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC2F51C05AEA
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:40:18 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-ScNabr6FPSqw5fEwJ6HleA-2; Fri, 15 Apr 2022 01:39:35 -0400
X-MC-Unique: ScNabr6FPSqw5fEwJ6HleA-2
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:39:32 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:39:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 03/27] target: fix discard alignment on partitions
Thread-Index: AQHYUITFeHwvXEjzw06+32xoV+0XX6zwdVMA
Date: Fri, 15 Apr 2022 05:39:32 +0000
Message-ID: <883810d2-c170-388d-a031-63a9792fef5e@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-4-hch@lst.de>
In-Reply-To: <20220415045258.199825-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f75ff33f-773e-4acc-6d5a-08da1ea25175
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB1815B6BBB70B3A16BD279E14A3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ct2OLeRIuik4P+2DUeO5AU8gZqPN6uyQIUnOB8Te+jtyDQNy6aUS+2wsUCMu8u05rWrtf0DIc95cYzd/uLaKTLCrJxxQtZnGGKhUTdcGX6GSWCuCwxkxGsNEG+qJSr9MwUJ7XV9Zvf4FJqe7DdIfzabcBJWl0widLMYk4wFdipWIDEgBVwlNKStVB4Pxswixw3xwANpWRJg7bFt0bQFSjiUuJkSR7z0bjIDhBvb4MU32HFtiyMZF6OWyg8DId41GzQeNxLyflykrZEg7zoRuIKYYiICmpgkAzJFBYYgV5mxIh0ODt8HLe8voQYI34dMRJ2q1zzDO9N6AvHzhbTWTMdsKs4T3CR07noro0Q+qb1WlHpYDdG9DvL2DCoCaarkL1zCHAUJkxEAyMDkzxdV7YkDlSMmau8i/g2y9w9JUbyO4YMAn8IbGR+TdxlqOSApiqh5rCevCWXCyj8q6unx+vib0nG0MK7JxHb7cag3lx4NrOlh++otAdbNAgAhRpzSgd6zLuYF5yoCgnE5OXtwW2xmmSbbIl4IfBfZxZ62Uz72R7UeZkrvDAbKwM+q8p0QzWNVE7+Tj5+OAiwUQj9ZN21aoKS/qM0isH1HffCwIA7CF4XxbqGl9FtgJ3gBe0gt6S6dX/NceavBgo1VeL9RfL1LcflQn3Q3aQvl4LqXD+sV+VQ99i4CuOr/ZuVcFtZnN8LvB0jGsL2I6mgWwy/cIGsBz+W3FIUOiMubueCem4c0OQc3RUQ5rHinqZ5V6IZeWEMz+VO6hBed+QWX+vJJ+Xw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(7406005)(5660300002)(4326008)(66556008)(83380400001)(86362001)(31686004)(508600001)(4744005)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0tlN1NsN3ExRHNGOTQ4NWpMd08vcEpCWVpOcnFEZTR0TFJXY29qR1V0a2JY?=
 =?utf-8?B?WG5DZWtKRC84VCtLd2xrUnIycjlveWFGbTNuRGY0Tjhqd0Nxc0JrVFZNRGpB?=
 =?utf-8?B?ZnplU09JdGt0elc4dUlocWNGQnZqZGJnVEljUlN2SjZDL0tvMjRDdGJ5V05i?=
 =?utf-8?B?MmVNdHRCZWRNVEduYmxqREl2Y29zdTg0d2NlYW5NQU9ZemYwRDJWMVBwY0xQ?=
 =?utf-8?B?Tk5lUXdJd2dCVlBZczlVNWY2S2o0cVB3ZEdBbDhzeFA2a3lrR1czWHEyUGZD?=
 =?utf-8?B?blBCN0N0QjFpQVlyOGNuNVhFMmh1OXROOUhNTHNGRmE0bDFUeUdxZUJNRWJB?=
 =?utf-8?B?ajdyUHN0aGNuVHlCdTE1cEZhVmVjam1KbGlLbnZwaW5HWGlySUVnY283cHhw?=
 =?utf-8?B?VUNTclhzYTVBNVRpeFNRNWI4RnFUYW1HM21IZCt1anJTTVRoR2xpZHo3TXBW?=
 =?utf-8?B?cWN0YjgwcjZTMGlnSFJlbEowZUNITEhGN3NNV2YyRUh1OHFQbUZ4N2hhcnYy?=
 =?utf-8?B?SDZBaUx2MWdwZ0kzME12bi9hczJKUkpobDhJNC9WbnJKelhRbytKYWNpQW0v?=
 =?utf-8?B?Q2hJQ1dSdnVnT1lEOGFHd0FGSE5RQ2UyRFErcEk3WHJTanlRZWRtUDhVcE95?=
 =?utf-8?B?QzRwV1VLYkl4ZEpYSExkTmRla0gzb3UwK1RsbEtpNVFLdDJPNlVxNXF0K1VS?=
 =?utf-8?B?d2o5d1FxOTh2M05JY3ZyQ0ExQU52LzVLVlROcG4xUUtJWkVQL2cyaWtvekcx?=
 =?utf-8?B?aCtpNy8zZnBvcnpyR1NMSUZyUEJzNVBoeGtydWpnNCtzWUgvTnZQSjdQK1lL?=
 =?utf-8?B?bGtzWHBoYm5SM0pmQ3RJY1JDbmkrTElnZXFOWVNRVmlEOTR2N2FmTFBydVJO?=
 =?utf-8?B?eGY0T1l5Vk9sRU9wcWI0ZDEralBTOUs2RkpXTlhmOUluWXJmVnVJaGxuV3pm?=
 =?utf-8?B?dkh0bElzTTBvc290WGp6WXFxdDZic0Y1N3c3ckQ2Rm10bUlwY1dNMUxnQmNh?=
 =?utf-8?B?bXozSVlGTXkrb1AybTN5aGwxU0hWNUNGd3B4V05LcjcrMmlHNFN1NTRkRU9h?=
 =?utf-8?B?eDR4aFppVVVqVXk0cGdDNVJvUjh3Qjc3OXJIeUpHL2lNWWtURVpUWEpkN1Ni?=
 =?utf-8?B?bTVmWVBkWm0xamF5L0I1U3l4NkJqZUN4eE1zUWk2YlN5QmZwNklHR1diSHE0?=
 =?utf-8?B?TE5yZTVibENkcFdNeE8vZlgyS0NrWlY0WnVsNDBTMEZrWHdpY1NaUFpBby9E?=
 =?utf-8?B?UEJicGxvQm5uMWROTlZ6dWlLaDkzTUp1L0p6ZWUyOTZnT1REUkVxZyswK0xw?=
 =?utf-8?B?cU5UREIvSkxhQUtyZW1FT2pTaU5iWEhoamRscUE0Slg4NzNJQzlGUVAyYWVn?=
 =?utf-8?B?V1NOZHNUOVJFVTRRQTlNcDdGYVljY01mcStrV3lJMCtPWkVqNC92dzIya0tQ?=
 =?utf-8?B?eG8vamViOWdrRkF3eU5kVFViR3FZT1F5azdnZnBJUk1tUWp4QlF4NDBPN3Z2?=
 =?utf-8?B?ZDNXdlEzN1djbDErUlF3YnlCZWdoVjJaMVRRWi9LRFY1bzN5dE5mZjBjaHZo?=
 =?utf-8?B?M3lZakZkdk1DUk5lUmhOYUp0aEJ1WUZReVViY2kxaStQOVhFaWpIZFRGQjd1?=
 =?utf-8?B?Qm9SVklaYXM3QVNNUlVIZHVIVVBpUnpXaUxwdVdHL20xYUdOdkxYSzd1K3FW?=
 =?utf-8?B?Qi9SL0lTd3NXUldmOXkvNllsejgwbFJWMkNpVUQ0WDdCYm02ZDhOMjlTWG9R?=
 =?utf-8?B?ODJPa2d2S1d3L1RIMkQzaTlkd1R0VnA0NzhtUWNWYW5NTll2ZThYbDZ0U2Jz?=
 =?utf-8?B?b3o0MllMNDkxaVN2NTVYNnloRUl1V1NqV3YyNGdpdzRWdGhNMzdFZWNkbGlH?=
 =?utf-8?B?eEJBcU9USU9jV1cyd29DZnYzLy9sZ2Vham5aRWRnWVF0S096Nmg0UmlHVW1y?=
 =?utf-8?B?ckozbFFpWm8zSUVzR3RBRGl5S0hMbEsvcFRVNEdnVEhiSzB6RnpDYUFrVVBO?=
 =?utf-8?B?dlY0bkNrRWZYVElwS3JHZ0ZqK3ZjUThiUmtpQXBHamwzajBCb2FRZDBCWWxo?=
 =?utf-8?B?R1BrR29Ua3FDZmQvb3c0cmwyOWIwVFBVVW9VSTl4RzdDUUNWOGpiSWYvMHR6?=
 =?utf-8?B?SGxGdStidzNBK2l2WE5meldvK0ZtTFJxN00xeU1OeUgzM1gxY00wdmpxb2Zm?=
 =?utf-8?B?cWJFbGlkZ3dOZlp3QXpadGFKSkRkc2I4NTlwMXBYRDF4RWtoS0NNZVFUZi9W?=
 =?utf-8?B?dkI2N2ZVOFBNT1o1UFdjV3ZEOTNRVkU1ZUdwUWxDbDFuNThzM1ZJY0FwZ2M3?=
 =?utf-8?B?OHJGcVZHOXRtdkJiZmNOMjRXQW5ZNjFuQTJKM0I1eS9hNVRKMjZSTUlmbnli?=
 =?utf-8?Q?mwLvyuXNtT2dnZQ8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75ff33f-773e-4acc-6d5a-08da1ea25175
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:39:32.4969 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ODsOQS1Mue5lFCyrdhicFWU5WLi2FcJdfWJh4a+Hin5SswAuBJNfxrqbBcEL8rN3XrCR3LTTvxXQb4HjN73Pmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 03/27] target: fix discard alignment on
 partitions
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
Cc: "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <308F8700311C87409575E1C200FD2EC0@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Use the proper bdev_discard_alignment helper that accounts for partition
> offsets.
> 
> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---

Helper does handle the case for of partition.

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

