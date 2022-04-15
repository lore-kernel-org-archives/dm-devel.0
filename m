Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7A6C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-MI5ddKn-MWin3aIuT4QnlQ-1; Tue, 19 Apr 2022 02:10:38 -0400
X-MC-Unique: MI5ddKn-MWin3aIuT4QnlQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B69993811F29;
	Tue, 19 Apr 2022 06:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DCF24320EF;
	Tue, 19 Apr 2022 06:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 475E21940366;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3415A19451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:41:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DFC29D7B; Fri, 15 Apr 2022 05:41:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08BCE7C28
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:41:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0328811E76
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:41:31 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-va9fm2T3NHm2NIb8rjl_tA-1; Fri, 15 Apr 2022 01:41:28 -0400
X-MC-Unique: va9fm2T3NHm2NIb8rjl_tA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:41:25 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:41:25 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 11/27] block: add a bdev_nonrot helper
Thread-Index: AQHYUITcvf8y733cvkGOzPkg1cM5pKzwddkA
Date: Fri, 15 Apr 2022 05:41:25 +0000
Message-ID: <eba999b5-e9fc-1522-67dd-e232b48be9c4@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-12-hch@lst.de>
In-Reply-To: <20220415045258.199825-12-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e3ace5d-eebf-4341-4b63-08da1ea294a6
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB1815A801B371E320ADF9BE64A3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2jzgUEHIrAsov39Nu4LyXYMxHaRS/0z/PqpjC27blY99b3mEjRApvUf7RTIOWU/4qQyQqWnA5g2AeWnuv1xrOzdSykyH5KKZe4+y8Pr4RYbQNJ9O9dXXzyd0bXePbajuD15BRouQVSX43IsFkMfzfawpEgHePKqgTOOFU5QariEIIFHfcefLo72/oopQxBzqq8fv6cEIHqcEdUB92BMHHRKLpYjbjKGt5iRjeqUPIfkLRUS68tVft4zXiyfScqU/+SmWdNXjjNEbzgSWiUfGWypf19LoPtzxsSWCqPSMGIaoZDvqfLekfdsjx2E9OxivGSVxoGnS6Vs4pulGCMByuDH2z3U4uBmAls/ATCl1XzRpxXqcts8YJftMpLGav6verm+fnj4amkU4kBjHeQ+xiHxAqryln8MQLJay7U4DYd/6nBihFw1hlVdwYN+EoG4kYrjI1m07gPMfdo4nYHqsyBdwAnUhyQmb3a02lL+tyi7+Y6RdYs2V9VtX2fkJjJ958pd1Issfg+1h7Ge9CpWYZaK5LuzNjEVgzHS/dACTdInBjbX0RwWQb1xxM6bmXCAJJufUobRrKaS++Y/Rng7ViTYyXqZiiY4dCeUhUqwNvVgyGvFlyzQGrCMNLcVlGxSSiFHUUXZyseGiJxV1PMhhX+lPbu+2ARSOpnFoJ36tnbWt/4UJkqdMUyF9vCtVv1cZ0j298rxtDqBdov8UxjpUqSnYlKWIZaNYAoE9zWy2lWqx1H+COPtTfVBA8fi2uomChpfWPJ5XSLiLyJDd8/txjw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(7406005)(5660300002)(4326008)(66556008)(83380400001)(86362001)(31686004)(508600001)(4744005)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUhHeUZ4SzZMVTFrUG9WeUlFYjNoekFLVW4zVG1RUVd0cVpGY2ljdmpTcGlu?=
 =?utf-8?B?S0M4OTVyNzZta1o4STZOSXBkU2lGTGloMXY0aVQzOUNLRWJ1cFZlc2loV1ph?=
 =?utf-8?B?eHEvUzhvb3M4NGo1eDJQbGxjMXJCZUVWWHB4dEk0YVh6UUducCs1Wk1EVFZM?=
 =?utf-8?B?MU5VZ0Z4N1h0dVlPYlFBcTQ3eXRwODZTUi9QSitDV0FqcytvbkhOV1ptNHR3?=
 =?utf-8?B?T2U5SlNuU1pRMy8zYTBTSlNzOFBOTkp6bXhtaklGSmhZQ2hnbG94OE1EUHBJ?=
 =?utf-8?B?M3pjMlJVNjhnMllDMm1ERUR5d2x1a2lyYStucm9lU1ZTNVZ6a2FhNXh2RDAx?=
 =?utf-8?B?cTNGcnhTYWFRbWdFZk9KaTJIR0xCYmMxZ0pSQ3pTcGlmdWd4QTJiV1EzcU1C?=
 =?utf-8?B?cURMejRBZjJYRzVzMjdOVFNJa1RKREJWcCtVL2wxaVVvdi9Sb1V2dHAwRS9r?=
 =?utf-8?B?Q3VtQ1UvdXgwd3dlRGlNdDZkQjZ3OUxGMjVJQmI4MXBTMHFTYXQ2ck1xYlNW?=
 =?utf-8?B?b0RmaE1IZEVFZC9ZaWVwcW96Rk5SZ0FjY2JoSWxSSXBKWjdjaVpISWlZM1c3?=
 =?utf-8?B?THorVUZFTHVmU2wvYXMwb2dDS0ZYOXh6NWxxSHFEWTlENDIzbXlEc0ZSYzhD?=
 =?utf-8?B?Rk9vSURWZzVZcDZXU1c5dHE3dG90dlFYbTM5NC8wOEtJMGpFcEhES1BaN1g4?=
 =?utf-8?B?NWN3aGpvQXpKRmdYK3VkVTd1MFllcHdlelZ1SWY0c3Y3SFg0ajNkMWxFb1dx?=
 =?utf-8?B?cTZacVJZY0N4ZlgvRVV3dVkrMjkvajQ2SDZuT2Vnb0FQUDFGM0lOVmpHUU1Y?=
 =?utf-8?B?eEhhZFp3WXh4UUxzWXNnYXFkRkZCWGtVMEhhaGNOanFHbEh4QVRlRUJhak41?=
 =?utf-8?B?bncvQW9wZ05KOEl2MkJscitvWStRVUVQNWVleEZBWGM3MFdxU2pHaHB0ZGNv?=
 =?utf-8?B?Wk1vWjNCY24vUndxdjlObFhoeXRvT0ZjTGtrUnZDNEp0MnZhTHdoNWsvMFdp?=
 =?utf-8?B?RWpzaVFhT3l0TU9JaktBT1FJY09qVmc4a2xEOElNNGFnV1hoRkFmamExVE1k?=
 =?utf-8?B?Mk9MUmwyUUJYQVNRNUV2N1hkcXYyU1RlQW8yQXVlbFRIbkYveVJQUTRRdUZQ?=
 =?utf-8?B?dTU0aDV0YkxLVWhBTWYyS3M3R3Nka0ZGSjhsOVYzdmh5MGNIQjVZNWxpMFVO?=
 =?utf-8?B?ejFrMXd6ZTA1dFdzSWhKZmJaellZVDFBY2VpK3c4N1UwNTFQTlNmU1FiOEtr?=
 =?utf-8?B?cFZhL2t1aEpUZ21NazNNeWN4OWRKa3VuMzR6N3UxK1pBb21QamVxRzZnUGZG?=
 =?utf-8?B?OENPZDhBZ3BZWmdmK0dWRDE5V3dmNUNqZTJOenFuNzl5d1o4ZkFoajdXVGgw?=
 =?utf-8?B?TFplVnRrQUpyRitjTU5CMDFYc3JURThuOEljT1ZFYklwQTY3ZTNSeTFuL0VY?=
 =?utf-8?B?dVNtWmZkMjI3ajBjMzdJM05qbVUrQ25MSTRCMkE5RDBRYkJ1d2xkK3Q1RWJP?=
 =?utf-8?B?TkVGeWF0UCs2emZYblNIUkloZkZRVklLOHExdEFpbFNXVnQ2TFpNMEtoSHVG?=
 =?utf-8?B?UzIwUU9CQUU3RTJ4cWFvVHc2SDdhZW93cGZZbFNDbndqVkZVL01XK2g2bUdn?=
 =?utf-8?B?djVnSVlFenNiZGpsZzJGWDc4NlhUS29VTTV6WmE3ZlRzWFV3eHYxM0ZJRzFH?=
 =?utf-8?B?SC9YTFVhMWdlY041K3FMZ2MxQm1jK1B2K09Ua3NpQUNwYjRJREYrbk8vbDNV?=
 =?utf-8?B?VC9BTVBuS0dpT1llWXRNZ3JFNkROeEN0dkJhUy8yWkxXUlpwWnhzY0FrQmdx?=
 =?utf-8?B?U3l1bFRPUnVnVit4dzQrZWFuanlwekdybi85UDYxbjlqQkJqc2NmS1lrTUI0?=
 =?utf-8?B?MHpFSmpibFZtVU9jVHJCWWtDQmVXNkZWNFVzRzB2S1U4M1RmaitxeiswZ3NB?=
 =?utf-8?B?MDdMQVFheGpvTXlVeWg3WC9hdWEwSnNXV3lMYTVIT2c4QlNqUFArell1bE9i?=
 =?utf-8?B?SXNCNkRBbWdCbDJuLzdOeFVSVUEwMHJwc0NYZG1vOFRzQTRqZUM0TXIxbnlS?=
 =?utf-8?B?Nm9vb01haHJ2eUgrR29KUStMN3RpaktxRGZ3Y2VtUEF5aVRwK2N6N2FsMlFa?=
 =?utf-8?B?UVBNS1VSV20rSnEwT2pMbExSNldHRTV1Q0ZqdnBpODJ0TW5kQndKSFRkcUVC?=
 =?utf-8?B?QkFWbmZobUVLQ054WWdzcEx2SzExVTBEN3FRUjR5V1R2a3AyeDVmazFUeTFN?=
 =?utf-8?B?VlZ6QmRmK0w4VVlMUFpyVVV4ZkpNQTIvODJWejMvUWxid3NqRmh5OGRvZHhU?=
 =?utf-8?B?bVpFSEkyZkp1L0pKNW9iSTBMU2MrVTdqNzFjVHlaK2pkZ1FMUXlqZ0JHdHY5?=
 =?utf-8?Q?2LBvpDbn9ASM/rdI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3ace5d-eebf-4341-4b63-08da1ea294a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:41:25.2089 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sQnzIbBLTrp57c3vH8r48gJfpEIw9VzuFDfFpnwqaIrkuMKle22fiUk7xI+IyQciiM9x+KvS7whe2PMfw5w8MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 11/27] block: add a bdev_nonrot helper
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
 David Sterba <dsterba@suse.com>,
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <78329BCB58D5BB408C7439FBB9C8189D@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Add a helper to check the nonrot flag based on the block_device instead
> of having to poke into the block layer internal request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: David Sterba <dsterba@suse.com> [btrfs]
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

