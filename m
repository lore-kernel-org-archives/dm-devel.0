Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D44CC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-vWL6iwiYNRKdbcFQMfjQmg-1; Tue, 19 Apr 2022 02:10:38 -0400
X-MC-Unique: vWL6iwiYNRKdbcFQMfjQmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55ACC949023;
	Tue, 19 Apr 2022 06:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 414D840FF41A;
	Tue, 19 Apr 2022 06:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22B271940365;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00462194034A
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:38:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C147F2024CB8; Fri, 15 Apr 2022 05:38:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BC3E42024CB6
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:38:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74844185A794
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:38:09 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-RuA7EVAaP-iiXdEbS1Px1g-1; Fri, 15 Apr 2022 01:38:07 -0400
X-MC-Unique: RuA7EVAaP-iiXdEbS1Px1g-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:38:03 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:38:03 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 02/27] target: pass a block_device to
 target_configure_unmap_from_queue
Thread-Index: AQHYUITD/OVlel93skeY5tfftzV30KzwdOmA
Date: Fri, 15 Apr 2022 05:38:03 +0000
Message-ID: <c440aaea-6617-c26d-e2a1-2107bcc4559e@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-3-hch@lst.de>
In-Reply-To: <20220415045258.199825-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 850d74d7-2e5d-4ff4-4b90-08da1ea21c8b
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB1815493E0F03732F323B43A3A3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: A3hCZAZY5NLfauwUgZEygmJFzH+z9vEj9n5IHzXfUjAwOC7aY1NJ+fWONw+VhzISBKRT2kQd6RuEDYrytmrA3RqmZ96M0fmdbvUv8BbTmduTkUmofW7negpKepAE+Ih/ChrWBUxejTUY7+Qxkoyc8lMrls4PSOllylTxV8/EYp8cnkL+QF8VgBdTSBQPWrJHiK0TUCOgxHTAGD95g8RCpPY8jILgIqicd+ajjlOREo1PkeOgtowBQZnohbI6RXFPxlcgKTqU3oyQhXr5nyI5WOeIPv/cq7hPAQyBs+rVkm/ayUPqwbRYkOAgXVHW1QUw23XpdxjhRA1mSgUVHc7MaVoFQqcjRUsbwpj15Dkr1h2QgnQXjZKbXkOQuYoS+cS/8F95ekll0/wBcUiqPz9Md9H1XyNxYBurzLUekup30HLbT9b/g6By62MakJsyZiuygt1HzGUg8bSDPoBhGLvlLwfrW6FFaMWiLPE7RWp62HQCN5NfP/QbUc1S/bmqVlHvoyOgf6f4XlPvy7F4tIVTKpAMXDBLhnMzdlsD3WmsPeZdWh2LJHFu0VZ7UT7gn2YECdBx1lO+vvqaCWjJxOcDVuDneKW8hNzii48GgqXOMzFGPo6dGWRrWvWqJy6Dr81PttER/FV0TGZL8HUDcGuuDtTcJru/5nGIBepAzvzrK67Zas8joPvndBwvywdfGi5I3BWR4fYJ57JUn8CxkzVbR9eXvXjkRtiRSQykI+8KpStctDb6EcjAJuRnFF320MhFDh7wNe36Vbk8VoHcUI7sZQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(7406005)(5660300002)(4326008)(66556008)(83380400001)(86362001)(31686004)(508600001)(4744005)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dERYQXI3VmVSUVIyZlJVbGZsRHRpczdjTVpJZ1ZwbmNWRFQrQUsyOVRCYngy?=
 =?utf-8?B?akpSUFEvSXhtQ0k2Q3VRaHNZN0hQRVRESmJ5alFPVC93VmpZNVVaZFBxd1pJ?=
 =?utf-8?B?R1VPRTBleHNmb0U3S2dRYkdZQkhtcDQ2bGRiTDdpd2ZxbGdtTDNYN3doZmtm?=
 =?utf-8?B?UEZsTkVXSGM5dGVXVVVWN1Q5TDhPZy9mMms4dzVVcDFMNFAwbDRSeTJMeTFj?=
 =?utf-8?B?MDd6SnJ2cDFnSHFPdks1dEJ5MzFmbGtSRkNQMWJ1djl3SnY0TjYwd1pudWkx?=
 =?utf-8?B?blFQT2gyd3pzLzM3YWZwOXJ2bmFlYjBIY1ozUUNQVEU4NWV6bkZyenh6aitE?=
 =?utf-8?B?dDFNRlRpemdDeUxHWlY4QUptYVg5R25PaWJVWUM2a2lJSnd1VkFBZFBDRWJl?=
 =?utf-8?B?NjdXK3ppb1ZUNmo3bk1yNFJtMjRIa3FFQUo2djZVQXNod2paUzUyTm5IZExM?=
 =?utf-8?B?bXUzV1VKNFA0MjFhcnNXNGN0NnJ5cTQ2VWczeEFZUmdGdWwyd0FpaUFGSDlR?=
 =?utf-8?B?UHdCWnJUaUdzcmxFUmtFMzZjbGNyTGJ4YmlqZDRSczNFUXFWOWxnOXJEdXdw?=
 =?utf-8?B?UGs5cE5DUWFSWGtkQWovR0ZXQWR0cFNNRi9VYW10TU9OSTZVN1B1YkhlNUxv?=
 =?utf-8?B?N0Q5akZJSDVTRW9lQW1kbkdIeXpnaWF2eGxYVUFLVkk0dm1YNmFqaEVXa0Yy?=
 =?utf-8?B?TkR0Q1JER0pxd2VwWDVrWFp3SEowbnRORFZpTEhyKy9KSmlWMlI0OEU5V3lv?=
 =?utf-8?B?S2dCUzBPOGkzSlJaeTEzcWFObmw1Y240M3AvejJ6QUJHNGNNaU5hUTkzN3h4?=
 =?utf-8?B?SlRWYkZ2VWZhSzcxT1ZDbnpYWHRLY0JtZktCdnNRb2owQXN6MW81QkdRNjZj?=
 =?utf-8?B?TDc3WDBWR3ZnYmhXYWxEczNicVBGZ2J5OFRoMmd6SVA5N2xIdHFsSmo3dlVK?=
 =?utf-8?B?YXBBckwzZmFQZ2Fjckg2bnVkcEZWSXpTbW5vNXZWbVdVYWZHbVJvNkg0UGdP?=
 =?utf-8?B?blhndFNrQ2wrZ3lFckdicDJhNUJlTE9SeGM1R1BXeGY0ZHl0bXRDOXE5MGZx?=
 =?utf-8?B?ekNZYnYvNUxuYVlMNlNJWSs4RTRpRWxRaGRlKzBEcnZ1dnl2cVNxUXhjcnh6?=
 =?utf-8?B?LzB3bjlSMHVpYlFrZ05JTTl5RkJVUm5lcEp1cGtLMVJadldESmI2bEo0KzFB?=
 =?utf-8?B?cS9URm5IbkdWUzZhZlRYajFLNWlEc051WE1HT2xOa0dRTEJYZitGbm1zbFRQ?=
 =?utf-8?B?WHRPdjhVbUFVVDJxVTNCRDFXbnZRclYzR1E5T3VzTEdGWEgxQWV1T1I0Ritj?=
 =?utf-8?B?VWp1Zy9IUlhaR3BnbDJpckZDTll1d2ZrOXdKVmdqaDNoUTZxdk1sL2o1elNj?=
 =?utf-8?B?OFVBM1NoTzE4bmFzbnhudHFhYit6WGF3Sm1tRVpCWDlDM283YzI2YWs2NHZD?=
 =?utf-8?B?UUJzSi9UVEdza1BEUEhhdXRmbis5b2Ivclc5WndvVFVCYVA1RkZ6cVRINUo3?=
 =?utf-8?B?a0FrcEMwM0c3ZUI3c2F5TzdWV1kvdXNNSFVzbkw0TFV4L28vMzF0RUprKy8x?=
 =?utf-8?B?YVc3dlc2V2tHOVFFMVdZQkpSTlArU3h5NS9XMGlVSzFGRUFUK0ZFb3dEbktS?=
 =?utf-8?B?Y3hGNHdHTUtrV0tHN1Z2aHBaUjZwWndrRElQSS9xWklnZlcrM1k2THNDR0t6?=
 =?utf-8?B?NFA2Q1Y5U2V4OE5yeVdYOHpkbCtOK0dQOXlGVTROOUVaZ1Z6eEo2N2hlWmhI?=
 =?utf-8?B?bGF2ejF0c3AxaFNqK09oajVFbVNIbEhUMmJuNDRLb3dsNWhNdEZQVlNnejkw?=
 =?utf-8?B?NHNnc3dESWF2RUxJVnNYSndJcmlmTEk3eDdHYjBnSTFKK0t0K2V1K3ZHZmxL?=
 =?utf-8?B?c09jeGUwNE5NRnRFb1AzQy9RQkx3OFNXdU40aCs2eG03bkl4OTROR3p5VWdh?=
 =?utf-8?B?VXlSQlhQZFkwdDRqUFdFQ3AyTUFlZjB1T2xDY0JxaWJUeXBmcnlTL0FDNjZh?=
 =?utf-8?B?MGU0eUVJMHhveGZiSVRHcEdYSHZzVmtpMmRTZVBxamIwYW04blI4N3MyN08w?=
 =?utf-8?B?bEVXVllvcjUxTFEyVE9RQU9XdnVqbVRJRnFpZFFidzB2Q0Jjakszbi9GRVBT?=
 =?utf-8?B?ejh5VU00dXV6bWdjM2dpWkJpc1haOGpoaG13bGN6YmVBdFV1M1ZGVWI0Q3ho?=
 =?utf-8?B?WG5vaXRYSC9Ba2lVQkNFYWwxdEhHb05KWVg2M3pRcWh5dTB1WlZ0bW5Eb25r?=
 =?utf-8?B?bUdNbDRHWGJicDlJaVROV3N0cFU5MFFMcXc0eHUybkZSRXBNa21RT2Q2bko3?=
 =?utf-8?B?QzJ6SXRTYlBNT0poWnA0eWI1RUcvNXBKODVQRkE0SThmUWFyMGduY2tBY1dT?=
 =?utf-8?Q?m/yCMP1qLjJIhtJQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850d74d7-2e5d-4ff4-4b90-08da1ea21c8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:38:03.7522 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6CruZ+VHjGIkpw05IbkgEleUtBoACM2V9uU26iGSHl9Se6QjDKl3Po1E2i8YHFl3OKgmwiWmrBRrYL/qLnKXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 02/27] target: pass a block_device to
 target_configure_unmap_from_queue
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
Content-ID: <98CD87A15D6DAE479794C1E9643FCF3A@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> The SCSI target drivers is a consumer of the block layer and shoul
> d generally work on struct block_device.
>  > Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Except from split word in log "should", looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

