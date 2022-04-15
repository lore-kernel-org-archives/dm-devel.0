Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19F8C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-sWEq88UROkaw9Jl7rE3w6g-1; Tue, 19 Apr 2022 02:10:33 -0400
X-MC-Unique: sWEq88UROkaw9Jl7rE3w6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21241811E81;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0ADED40FF412;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94D241940365;
	Tue, 19 Apr 2022 06:10:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9757819451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:42:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84170463EEC; Fri, 15 Apr 2022 05:42:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F5DB463EE0
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:42:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62FFC3803919
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:42:13 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-8TOGsqkSO32q_axMubQhMQ-1; Fri, 15 Apr 2022 01:42:09 -0400
X-MC-Unique: 8TOGsqkSO32q_axMubQhMQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:42:07 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:42:07 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 13/27] block: add a bdev_fua helper
Thread-Index: AQHYUITeWwsZSeujF02rS5YtUAwIEKzwdgyA
Date: Fri, 15 Apr 2022 05:42:07 +0000
Message-ID: <77dedfc7-d5af-4d87-0383-613b80139850@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-14-hch@lst.de>
In-Reply-To: <20220415045258.199825-14-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78d5bffc-1ecf-410e-e5e5-08da1ea2addb
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB181583C18B6F4B1306D9F075A3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EyB8hyf1JleddzYMugoCzU5pDkbuoBJ4pMtfwahP2ogCrshpAMwi/M3kryaDsr86Ji8Q9U4kHeq8opzY12HtfVHQnFhUIP4brKkdTIq4Y6ukil1eCLgOOYlrZ5o1P0nbImPP8bumuAkoyxQWEqr2pscBJl7suKAqCf+rn7r+oOenvqj+4obi/miPtobHImnRCiFqVQgtDsT/N32Ixv+yCvs7EJ/Hlgkoeim10mAXruT2vQpZWRXCIY71uWhnrRmvywzHl7+0ryrDGpRopaC4VXorwnKmlY7xCtQdT3mJrLKecVx4z1anmMntcRJN4vtQSorQWycnaL1JGitCMJ13sT7IUOpDp8A9esZxVNNwKoF5yroommwEp/ZWFV25t1L6NdLAVHxuUSTk2hLWvATU1xURTecgCIb0C+Nt7FJH9FgvN1phKoF3Jy0/LQ7Z2L5XS7q3Y2RTN4gd17beEyBfgw9bBAZ7KGjVbp0h4a/agz8f8JNJ14537BDPs6J4py2NSMmRbnayX1NHA9E2IbENVLOxyFwNhoNxoUeEk4M9KIZevesgLhYW+Jmz/E5nFz5VzA4tF30LXK/mutY8o+Q3ehw562gSxt3f8beQMVMuO4uH1b0XtHszv8e4ig5MbRiv7U7I69/l0BQK5qbz4DsvzlZdDK2gMlITuS6vpjPKMLETzOjcBDVIkDggnK+CZDCHTsQf7NR8pON2Gh1zpljGDLbLOiFSS7nCHuiYk3MYIrgjzUsd+XeEtmHZBqZVF24+Em7DxOzP3Z/CS72dLl3aOA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(7406005)(5660300002)(4326008)(66556008)(83380400001)(86362001)(31686004)(508600001)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(558084003)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rmh3d1NVRWtMeEFsb25ENXVPcVBIMC9EU1JnVHNBZDdqNHpPUDR3SGJFb1B1?=
 =?utf-8?B?WFVvOWJBVjFvWnNHOTdvQmVRQ2hHeHN3UlNEVHRuazZ5MFI2SVVraTQ5UEMz?=
 =?utf-8?B?VzZYdTAxRVp6U1RtSUFzUjdSaW5udmZySW9BenAvM2FZZ09hQVJ1SlVqUDJh?=
 =?utf-8?B?eXhCQm1lZExVT2pKSFRsNUt3RjlteDdQZk1LQkdUT2xNTDNoWSt2SThmMUVE?=
 =?utf-8?B?MCsxUi9lcU5OYTdzL1RFZ3kvMWVSa1Jjcjl5YVFJUDVyWGVzL1lmK2d3c3c0?=
 =?utf-8?B?eW5BL1pOdVp1SW92TzhlVzFJR3ZhVFFxYTdKRTMyN1ArMFVGZ01NYjZ5WnU4?=
 =?utf-8?B?SE8zQXdaWHkrclZZWWYxWWsyWEJMU0VSWFEzRldFU09HZUdock5xZGYrL3F2?=
 =?utf-8?B?VU1yN3FUYzk2Ny9JYXhNQVZqdTlCUkoxbURaUE54M29ZdXBVM1pWZGUvc3lo?=
 =?utf-8?B?em03MStETWlGekZqQXA2L3dHdjlWZThmbkk1VHdzMDN6eHo3YTNuZEc0cWN3?=
 =?utf-8?B?WFBvWDhlUTIwMCtjcVRqbjhUbGhCZTdRK1hFbWw3LzRSeHNQWGk4U1o1RG1G?=
 =?utf-8?B?ZEcxbGZlN3VkWlQzT2FZM1hlR0cyZVcreDYrU1ZpakhoS2V6ck1ka3pnSjV3?=
 =?utf-8?B?c2l3dVBUdE1mUVRnMGVYRGpSLzdXVTNRUzNHUitqbHVKaUNlb0RVcE9najdp?=
 =?utf-8?B?OUxqaFZXbzhZUXNNemhHd1lCcGRvQmlPSHFIc0tid3lPVlgyK083Z0ZuT3dh?=
 =?utf-8?B?SUVZdUxjb2lHRkNSRFhHODVKMklUYStkUDVYN2RVWDNLcUpaZmIvMk85WmFK?=
 =?utf-8?B?UzN1ekVRTnAwVVF6RXR0YmJSUXVnYlZSbmRSVTZoSHZrc1BKUXlVeGpVMkE0?=
 =?utf-8?B?dk5ram9IUTMwVXNZVFU1WmluR2NZZkIrSlNXQ3l2NEpXZUhZbXYzbHNDTnUz?=
 =?utf-8?B?UXNxM0JGUE1ORWFaQWphWEVIcEZpS1FzQUJZYUtmeURpa091SlJxMTJUOTFQ?=
 =?utf-8?B?MmIvMU1ucUVkWEFvblNJZHh6QVFmbUxSMUJzQ054MXdGV1h5eDJTSU5XTjZp?=
 =?utf-8?B?RkprY1hweDJlNDRnUGpIMEFYWkVuMERPUGk1b0FmTHRyNzFyRHpHemgzVHZp?=
 =?utf-8?B?RVZ0aXJxRXF4cGVmQkNYd3BOdzZjSWtVSVd0UWwxa1QrdFlNcEo3NjZZTVU5?=
 =?utf-8?B?L0Nid1ZoSkI5U3YvNkZNclY1dVZGaWZlTmROQ1lHUkJDa3AyYTZkWm1CaDNn?=
 =?utf-8?B?K2tWSy9va0hNcmRhZWl4SFV4RjNDSTFCaUdOeGVjNjNscmsyNFJUQWEreCta?=
 =?utf-8?B?dURReHdvTnplV3IyTWJzRjd0QS9mY0Z5b0hKQjhNT29MQnhYZXowZ1EySHZC?=
 =?utf-8?B?VWRRVEhGV1R2V0llT29Vcy9XZXBjemlQV0FpeXVnYXRPODd1NHczY2xiaFoy?=
 =?utf-8?B?cVo2WDV4UmF5TXh2M0R5TnVRY3dkakI2Mm9kOUNLaUhtRHA4M0plYlFuQ3hI?=
 =?utf-8?B?SHdkaldiWTRnUkx1VzdjYmUrdmZCMFQ0VHg3V0wxeUpJTy85Ujd5Q0hPc2Jw?=
 =?utf-8?B?YkFLMnE3Nk9zRENtY09wQXJkaUV4QmJVOElZb1pWTmNTUnd4NDZGVXkySU9T?=
 =?utf-8?B?UG1xRDVGMGhtb1AwWWo0UFJ6SmNiY1duYkQvcTBEY3p4OWREWVY4cXZtNzhG?=
 =?utf-8?B?dVNMcnU0ZVRCV3hjNG5kNGdnZlo1eGVwaHlIbWRtTmVXU0RXYWdRUnpReGJq?=
 =?utf-8?B?ZU4rZytpajlJdzJ0ZnNqV1lCYVlBNloxYUVYOUtmaUMwQ0UrYjZMMDVJYTUr?=
 =?utf-8?B?eHkzc0JVdnBvcmVabU9KeURONnBiRXZuN21mT2NJcVpZam93dXRDVFVyL3VC?=
 =?utf-8?B?UDF0cjhFU1hmaG1oQUlPdjluVjQyUng0YjYwUlhQT2x3MWVHOGxzc3BhYWdn?=
 =?utf-8?B?aWdCZ24xZmVselZnWTJtNng0Q2pvWGRUdXVBZVhTNlV2Umg0T1BxcjduVjRT?=
 =?utf-8?B?OGsvNnZKd1M5bXptRWdoNGNobDdTamxFbXNTMzhCOWxOSDZMTGZ6V0RHeHE4?=
 =?utf-8?B?czkxb2JnVnB0dHExUE9vODdBNWFJdlhqLzBrakJrMU1mSWlKSll4M0pTOWxk?=
 =?utf-8?B?SmZOTFN2cVJpdXB0UVdxSzFMVUt4RjFENFNIanNNWWovYTFkT1J4Q2c2SEhB?=
 =?utf-8?B?MGJKUk5PdUZyZHRSekVETit4MkZ3WUo2WmRZV2hmaitKYjRybnYySklQdHVB?=
 =?utf-8?B?dlBFMzlYdENUUHpCL3NXak1WU0FiZ091TGswZ1pSQW5ZZTlWN3lZWTJCVnN6?=
 =?utf-8?B?YlJEeHlaMnUzL2tuZ2pHM1lBN2g5T3hJVXJDSGdOeGhaSDg0Rm1Va2loa2c3?=
 =?utf-8?Q?1Z66E7GDw37e6nTgD+MH8VjpaJC1xSuIdTeG5?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d5bffc-1ecf-410e-e5e5-08da1ea2addb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:42:07.5188 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Ta0Zovff0U+n3TbFxVzpBAWYFvV5vI9cPj3l5EKpKj/yjyOIuU3gSYzhUD53UrhII2nt3yMopUhXs1a5HAr+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 13/27] block: add a bdev_fua helper
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DF997BF112FF594981505DC1D908FBEE@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Add a helper to check the FUA flag based on the block_device instead of
> having to poke into the block layer internal request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

