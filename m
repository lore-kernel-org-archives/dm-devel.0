Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B388C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-uFby8PtrNG2ZJxNXCuyo_g-1; Tue, 19 Apr 2022 02:10:44 -0400
X-MC-Unique: uFby8PtrNG2ZJxNXCuyo_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 461DB3811F4A;
	Tue, 19 Apr 2022 06:10:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1483540FF41C;
	Tue, 19 Apr 2022 06:10:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65799194EBB3;
	Tue, 19 Apr 2022 06:10:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F87F19451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:43:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D0D0463EEC; Fri, 15 Apr 2022 05:43:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 18391463EE0
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:43:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECB84811E76
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:43:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-BE6ZXzeoMueieR0tHNpMFQ-1; Fri, 15 Apr 2022 01:43:55 -0400
X-MC-Unique: BE6ZXzeoMueieR0tHNpMFQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:43:53 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:43:53 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 16/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
Thread-Index: AQHYUITgGyb6ZxOVoECvHtCH20IFIqzwdokA
Date: Fri, 15 Apr 2022 05:43:53 +0000
Message-ID: <d4d70cec-aaef-27bd-4d29-7382a740f192@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-17-hch@lst.de>
In-Reply-To: <20220415045258.199825-17-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fadb5741-c217-4402-81c7-08da1ea2ece5
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB181587392FBC362EB9BA46BDA3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /zPE7EFfZCRyhrUuJ8xZg9ucWLWFwJmvS3SCCy3Gaw/2yxq3SLG9KlcHIP+uThF51l80EN6TZSRiTdQYGcRu0jCdhuALoVMKwS8W0pRofsGVFS2xSGj41t91O6b3SGy+xBhR0pwJvhvExxhfgFMeJv0kf4NLE3kzDlCKkQiUSHe9UUFRHRiu71HiTj9048fpgx+LMHahpSNX93/a0NzTVZSI34Jnz76e3Zbz5izJ0Btbe01tt33GWjvGm9MTZSXMrbEGKj+kS7mHGob6GbOEfPMtU9msKPzYGpb02V1m4UiygUdR2JLzyHKmSZ+Qk2YRKEOWnH51jj8kUevfIc6zuDr6NdNQR2dBO4u/kxc3pW86qOc/ly7+l5ASnifdFRNBlGObIMk454XaCAJCG8Lb/FzQnENxr3ByAWVaZjA2UUOU54L09Sro2bC+uf2XcSeLQgrUF7ONhLnwI5Fijea+cZY8H4fztMTlN3TZ/uEd9ApUgyy5udU1p9XTYcxj++ua7g47w3aeX7Y5VzkSGbmquc4wRnCJBKrD/sHPCbPVgvd6yujzP41M6MslnU2d/EfCPWdTo3HBEEduFrUZjh+X7HW8TYgvVDdXfTH06HgyG4GnRRnI9J8fUjx0QN7t1TNLvC52WnAi765Nyg1VPPBrl3i21BYZ901pgAkXDGXI2t1yUM7IV7ny9/ixyZZKXV53DwJDjsiEuGwzKQpZYABsQLuZZnLaLSXEfn2lkfqCxswy/6XXTaLwC7+nDFr/m7bYPN/eTEB9T3cxQN1Vc4nNqg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(7406005)(5660300002)(4326008)(66556008)(86362001)(31686004)(508600001)(4744005)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkhLTC9Hb1B6S3FOdlFHNnJDNWdpYy85WDdZZWFmTW9PalFZSXZBbGxNeDZR?=
 =?utf-8?B?OUI4WFg1M2twZmZuS0d5b3VmM0RJZm9KWGQ5V2VPUXlxNlFKa3VjZVVsUHRE?=
 =?utf-8?B?aE5KOUFKRXBHb00xSjAyUVhnUnJ4VzBlNlR2OTVqZTZCS2JlYkJaNXFmZk5W?=
 =?utf-8?B?QWtTS1E4ZWM0NkplMkNnSGJuYXEzYnZDRCt4UXpnN3QvYllydGZZS3JNUFJD?=
 =?utf-8?B?dzlya2l1cFROcHB0WG50YnRmOTUxZmtFcWJYYkFxR3IrTFJqTHFTbXdjd2pS?=
 =?utf-8?B?UHRhcFA5dTdGdTV4dGx3aGtwemlDbkxCYjJPY2Myc2tpYS9SdzdwWlBIc2pR?=
 =?utf-8?B?UDMxSUpKWE9qYzRmaTdKUXh3MjRyOWhXM2ZGNHdMajR0alRQYzc0eHNUekdm?=
 =?utf-8?B?Z1ZnRDVNUldxcm1xREFydEdSWnJJSitIZnpMMW9odGJPOEsrUFZKYUhGOTVT?=
 =?utf-8?B?WndnNG9hb0NPb1NTdjJwZDJNUGl2NUpSWUhoQjMxRDN2dzhOd0s1ckdvaDRP?=
 =?utf-8?B?OFZVQVRSUS8wVndOTytLcE8vYnZnQ244bGR1MHhvWGR5MFBoa0NVcm1DTVFH?=
 =?utf-8?B?MFBFWUhEeERFZmlINEpqV3ZPZ055cUVMcytyYWk4MEc4ZXpZUGtaa0l4YmFq?=
 =?utf-8?B?cVMycGhwREZhZXUyNkNqblZ1YnNMY0RBczd4djZJSlFCWmlNZGMreTVSL1l2?=
 =?utf-8?B?S3hDWElZaXZWYjJQQW1jWk5BTFN0VFhVQTRla1IrNWdKeTgwdTBIb3ZVOG9M?=
 =?utf-8?B?VFE2Tkp3VHV5S1ZPcXIwVUdwSDJ2bUhMMG9yTWk2VlEwQUpmVWVNNnJ3Rzd5?=
 =?utf-8?B?MjlzQlA4TVd3Y1ByVWZyKzZWQmQzdHp1V3kxNE5Zdm9EM0V4TjA0UVNoWmp2?=
 =?utf-8?B?czAvdUpiMERNeTU5UldlTlo5NEpHczJmcno5bGxaRXlzTklhV1lpVXU1T3JL?=
 =?utf-8?B?ZG90RzJKcHU2RCtwNDIxWWVqSjNCaFpNaXIvaHNZak9QOEVZVE5UT1kvTEpl?=
 =?utf-8?B?QUxhSlBNb3JUL3NWTHcwNG5OdU5haWdLd1BndU5MZTVkTUloRDU5aHNaeVZL?=
 =?utf-8?B?TEUzSkpaUEVTcThhdnI0dDVaKzhSckt2NkhJK25xSUZLbXhLVzdEcTJuQ1FB?=
 =?utf-8?B?ZWs3TFE5SXV0RXBWT3dXL2RLOGVVVFhEcklFbmRjU0NheHVadmRYSjc2VVRw?=
 =?utf-8?B?bHA5OVh6cmpEbjE5VnlncEE4UUgwemw0N2wrRSs0REp6L3o0bjNQRFRHYUlr?=
 =?utf-8?B?WGhqLzJJdlhoMUVjcTVVUm1WR3UvRDdra3BhZzQxK1VWTTd6d0ZiWDRhZjUr?=
 =?utf-8?B?NitvS2dtZExkZzVvL0prS0tPQkJtdnFjNlZ2cW85SzAwZS84dUhhR3NzT0VT?=
 =?utf-8?B?WWErM2hId0NrTkZ4QS84RVhBK2tnd0tmRXVsYjZrR3VwNWkzNGVmdUpFYTdl?=
 =?utf-8?B?NlpsVzBTbFlVYy9xMzBYUFB1a3JPRFl2QVJqRzFJWFl6ZjVSZ2VyQnZMYjlv?=
 =?utf-8?B?czhiZ3lZTmpzTXEvOFAwNldYb0FqYW9pWGVKZWkwckZOV2F4cFBCNnorcWxo?=
 =?utf-8?B?T3hxaC8xYW42SnFjbmJVZ3FaYXYrcjZiLy8vU0tLcXdTMzAwbUFhbGViMlhp?=
 =?utf-8?B?QjFaSVNhdXVvaUFvMWtDMnlJTG9HeHNkMXpXaStQOUpQY1RUbHpJN2UwM0lT?=
 =?utf-8?B?ZmcwcndhQS80SFZKY0t4SjVqWUpyNFJqU3BtMUVYM3ZjN1l4Tk5wWnZzYkxR?=
 =?utf-8?B?YlgxcTV1bWRMUEdMWWQ5MytFUHBsMXZSUXRwaENTaVEwL2pNOXNvYjJJOEZS?=
 =?utf-8?B?eHQ2dm1ySi8zZjd1eEtXWTFZOFFwdlVobitnUS9yaG9nNHR6eDA1Tm0xWkxt?=
 =?utf-8?B?SWt4Um9NMmc0WkFsTGFIbW5uWUY4Wnp4OGFCZ2tpMnQ2VmU3QVB0MVQrQ0l6?=
 =?utf-8?B?NUdmeVdPQndjQVRxWVlVUSttOE1CM2pyVDBoMGdObE00aDBxQ3hZNnMvRDgz?=
 =?utf-8?B?MGpCT3hNL1FPRkRJZEJOdlZZTXN3b0hSOC94VGYwa2lENDJLNzhsbkdycWtT?=
 =?utf-8?B?OFdFeldWWEpFN2s2Nk1wWTE1ZTZROXVPbWl2R0l2UEYrWUN2WkpaRG9Zbzlt?=
 =?utf-8?B?S3BzM3NmTjdreEFPMlIxQUh2dURrK3drbDZ6UzZUSUg2amNiZ2tLVGkya0d1?=
 =?utf-8?B?TDErRm1PTHNrbnRuQWc2M1BEU3hrSDNVQ0pyYzAyVFJZLy82ZHlrY09FOUR0?=
 =?utf-8?B?M2hTb2ZOUnh5UWN3c3cxK1o1dGpBMFFpdEpLZzJubGVDTGhsMEhPOXRTZEE4?=
 =?utf-8?B?ZDR5bkFrZWlMbEUwRHd1RFdybXdURFg5bGw1NFNvRzhEV29zTFZIL09qZnJY?=
 =?utf-8?Q?AYvHXapXcoGFw6Gj5LPtzLlzXjgd4w5ny2Ge1?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fadb5741-c217-4402-81c7-08da1ea2ece5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:43:53.2939 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z89R72UQaC+/+ZifCAazwywTUZEAu78qSqfzKG51E0QeCoJkksyXq4ipp5lT82IG6zIQc23xZHHhe3Sr5hGvgA==
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
Subject: Re: [dm-devel] [PATCH 16/27] block: use bdev_alignment_offset in
 part_alignment_offset_show
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
Content-ID: <082F7C538FC35349BB8BF71526006F64@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Replace the open coded offset calculation with the proper helper.
> This is an ABI change in that the -1 for a misaligned partition is
> properly propagated, which can be considered a bug fix and matches
> what is done on the whole device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---

Neat!

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

