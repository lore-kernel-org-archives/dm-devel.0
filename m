Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B5BC3526F
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-chh9NQYgOkmfS8Jw0eG0nA-1; Tue, 19 Apr 2022 02:10:41 -0400
X-MC-Unique: chh9NQYgOkmfS8Jw0eG0nA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C9F800B21;
	Tue, 19 Apr 2022 06:10:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 107E314583D2;
	Tue, 19 Apr 2022 06:10:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 86B7F193F517;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D813194034A
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:40:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FADE404D2FC; Fri, 15 Apr 2022 05:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AD3940D2974
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:40:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4018F86B8A3
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:40:28 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-yFU7zmCKO2uEVvJgUyCOIQ-1; Fri, 15 Apr 2022 01:40:26 -0400
X-MC-Unique: yFU7zmCKO2uEVvJgUyCOIQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:40:24 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:40:23 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 08/27] btrfs: use bdev_max_active_zones instead of open
 coding it
Thread-Index: AQHYUITWCcMUA8bLiEua0LAPQuFUBKzwdZCA
Date: Fri, 15 Apr 2022 05:40:23 +0000
Message-ID: <f4851d27-c4c6-7fc2-9c32-ee1ae891c598@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-9-hch@lst.de>
In-Reply-To: <20220415045258.199825-9-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d43f1e0-5642-4bc0-dae4-08da1ea27005
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB18150B7B7C6465355214E778A3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4ZPhtRNK+M5DKU8YWmTcN1yGt63cADpKaKfCy/SEb0ur+bnkBgj3MlbsUf87YdTU/lEwo1kpqxgFgtH8fApnw+l4mJQzPxaR2it9Negil3/1unaOyHoHqsB2RYc4eAWOy7TjHI0V9XtWp0eq8Q6nFlIrU/IQA9ny/AGrRroqxVS0UYCUUBfTbs0OQFL+twKXYYhUOdUF5NGxpRRf/UU3HQ3855viSwY41opIcAH5MN3OiLTGmxOY6qgrUbpyq7SaPp9g3wS1wvUL8ahdr9Vr+8Ua8vSbrn31OnQniKki7qIPMfi/VQGYNLn8wpC/AYXmcfm9Aui0kTzczK374wimI5S+9mGdcIUUXnQpLNxt6pa2ycSh1NipecEHR5kDNNYMMuezpb2BqWkDPjZJk/xmFSuN9RZlpk/Rt45rCQp/6Q47VSXKYSwvB43vOFYqSmdFzhmlkwnsmw5gdzMnd6rLw3wo9ykjXTmv8oOCNpOU5uUOI6nsMvLtFifgR0AhkO41VtGfwUFo4fkHTCfFmMDK2bOrVNRiAnkNSeg4knlHo1ce02U1FgrWfBtIbv6KlV5VDeKgDhTmzeyQrZYwoS3D84S56snOINbURrksogAlCBvSi4vfWgD9y6SpMsQTlr8KXJ4PJnkissEDr0GhMG96/mFk85ei8zPqQg0jPKDCHnTzGWFmG7w+BtU9ztBkWW99Sf8RB/aqb5cuMtiZTpMjDHrjlwVnor19WwImHXrimuJjSYpjbfrMSB1YXRasRs/xLdqtS6uovYxboYtN85dQ0Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(7406005)(5660300002)(4326008)(66556008)(86362001)(31686004)(508600001)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(558084003)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXNVZ0s5eHh2SjU5OFR2YUlhcVk1azI0dFRONmRyZW1XTHo5REpvbkJ1d1JS?=
 =?utf-8?B?N0JCV29aalFmajl6eHg2aVZJY2t1dlQvbzJxV0lNOUJJSHE4bXE5am91cjR3?=
 =?utf-8?B?NEd6b0YvMTZhb0ZUU0UvSUMzL3BYNEZ1Ny9YeSt5LzZEUS9sMWFYSU54RTlm?=
 =?utf-8?B?VFRKdC9ZclFITE8zdFhJL2YzTmZVYzEvU2J3anBxZlk2TmgvSjhESXhDbmQ1?=
 =?utf-8?B?OWNUUTVzUExzYVdXRlZZTTl6Vkd5dWlPMEt3LzZHUEt4b2xPSmR4RDVkWThH?=
 =?utf-8?B?WlE4RHduVjJBam13c3IwV3JFcXRFZzd5bmlEZEFybjlZRVI5TStGbWl3RnRM?=
 =?utf-8?B?MytzUFlUanAwOFpHR0RFbGY1YUljTnhwSHVBQ1drUkE3K3dkVjNBU2g0YXl6?=
 =?utf-8?B?QWNoZ2sxcTd6a0NJN0RkVmNGYWRMeFZpZ2Z5WkJvWHpiYUJPVE9EMTc4Z1pi?=
 =?utf-8?B?ekJMVmt0bSt6YXFkeTlyK2szVFhIajE0V0ZhdWU4V1g4VnczbVR3R3FMTjJn?=
 =?utf-8?B?U3A3RlR6SS9uRU54OHZUL1VBUit6ZFFJTndwWWRBc21nUlN6cGcvUVNRSDRw?=
 =?utf-8?B?U1JHalNFQVhDcEpETTBWclhhVXFMejBCTGFWT3I2WVFwMUJvSHBlaDdqeFdu?=
 =?utf-8?B?TytkVSsxRWdjUTFnVFFKOVd1QnMrL2Irb0ttMUxUR3FCVEVKa2kvek5XaEJY?=
 =?utf-8?B?ZWt2RHF4UVJzMzdqVmM4OCs5NnhhejZsYm1jbWJMQ3dyMGxUMzVWUGpRekdl?=
 =?utf-8?B?Tk00K01KY3JvZktIZGh0ejIraWxYN1JlZm1aVGxyM1IwVklhbjhlWlV1dkJq?=
 =?utf-8?B?ZWExcERaVldteEgxWUpuSHB1U3FxMUw1QnUxcUEwQVlpYytIcXBTMmk0V1VL?=
 =?utf-8?B?U2prRFBOdEFEeE1jTmFlb1lRZVBJT1JVUFdLOFAvTjJhWEZjK1VlZjVEcCtq?=
 =?utf-8?B?N1daVC9MQVg5WHRSTTlYWXpxMWIvQVNvdVcyVTJ3R1lZM0p2eC82RkdmZ0l4?=
 =?utf-8?B?Z0UySFJhM3R6OEY5aWxsMW0zWnJIM1A0SmdJcVhlaGdodXpCOVhneHNtc3Nz?=
 =?utf-8?B?SkZ1dmp0dlY2R0pqaGJIM1dJNE5ZNmhlOFJiLzlyVnVwNXBsNExUVkZGK2l6?=
 =?utf-8?B?OUl5UkdETTR4bFI2NWhXYktRYWtoUDVvaGpoRmkwSEZxeHFZR3VLSkJiZ3pr?=
 =?utf-8?B?aXJxUXovV0h4ekROWHVyOEVvTTBtN3MydE01dWV3emZTaGxxMGlqTU43NHpy?=
 =?utf-8?B?Mzg2UUtKTjQwRGNWUGovdlViSXk4TmthZ3dQTXNHQ0pCa1VzOU55WGZzcjBi?=
 =?utf-8?B?M0VHWHBKTngzYy9mR0xkUHhZT0ltdW9aS1VEUlNwbHZMZ2RQR1FNYU5KNHlz?=
 =?utf-8?B?cG1SeFJVdkRaTTFDek9xTi9mM0kvLzFKbHVveC9GUVZlOXkxdWNaY2RyTnR1?=
 =?utf-8?B?VXFxYS9US2dZWXhBZ1EwallXUUlmdE9ZRVN1S2xTdm9vbkdtWHAzRjRncStW?=
 =?utf-8?B?RjYwT28xdm9wVDZwMUpUSEZpR21GeG0wdVF4K1FSL04xdDY4SDg4RmcrVFhv?=
 =?utf-8?B?U2FsWmREQnpoTWMrTmI4bjl5MVRPbFZlWUdIN3FJSWMweHgyV3BlbVNWSFo1?=
 =?utf-8?B?QUNsY29PdFNjS1RBL3N6VkI3OE5kV1J6bFpnc1JiYUpyUHdzNjBhaENZalg2?=
 =?utf-8?B?aGtsWXJMbnNDS29IOTBNK3JJYkRxVFpxbUs3aUxLVS9sVmpaWS9tYndJTzN3?=
 =?utf-8?B?RkFEY3NyakFKQmVTamNSc3BwbjlaaTkzem96SStSUUtXQ1JwYXU5YXliTVM1?=
 =?utf-8?B?YWlrc0RJV0NIL29nMXVUclExaS9yOXU5MVhNdGpFTEJPNXUrREwrQ1lvSW5a?=
 =?utf-8?B?eWdYaCtqekswbHltRUtmNENEdURDU0xVdXpTVVdkYWlxcTVvTzk5ZTQ2YTJJ?=
 =?utf-8?B?TWloY1dVSFdwbUhoOTN4V0dWMDBTSXgzUUI3Vys3WXpMU21JaUpqVFl2Tnhh?=
 =?utf-8?B?cmZNa2wrbGpnMUJndXNQdzlQZml6K1NvTm9nc1IrY1A5a0FFeGtPZTMzaVFh?=
 =?utf-8?B?cE5zV29sN1Z4c3pUTXNrT2JCZDMyRy92VFlKMnBiSHZGYkNsSUFic0x6ZXNW?=
 =?utf-8?B?QW55aDBDYUtrWGp6OXpJOWJMWUorUlliaWJ6YmQ1dzZtdEVOUFdFVUNFNUs3?=
 =?utf-8?B?UjE4MlFnS2Mrc0JmQXJjYWgwa0M2L0dVUktFb1lnWXArRjFaQ3I2VjFOc090?=
 =?utf-8?B?UUlWRUh6Y1Qwakx1RTVPekhBN1E2SGU2ZDYxU3ZJekVnWGNsdlUvYlFOdDVR?=
 =?utf-8?B?dmFxYk9RcXEwWEJnWEdwYzhGYlJpelJnTzVPN3N4Tnl5MXgzZzAzd3FJL0ln?=
 =?utf-8?Q?LoY5Xge/tXZoe4cU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d43f1e0-5642-4bc0-dae4-08da1ea27005
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:40:23.7751 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mi5Z+Cd0ksdzCO1rvE8Hu0ta8qQXfT/P1tA5VxBskatP8RIWaggzSdjfKrbZb/7EXEjVORAi8kufABb00rwpzQ==
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
Subject: Re: [dm-devel] [PATCH 08/27] btrfs: use bdev_max_active_zones
 instead of open coding it
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
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
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
Content-ID: <3BD681E83CBB8E4A8EA752EE0A94BCBE@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Acked-by: David Sterba <dsterba@suse.com>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

