Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA46C4321E
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-pkzboJP2MgOoNuUBd3ydIA-1; Tue, 19 Apr 2022 02:10:44 -0400
X-MC-Unique: pkzboJP2MgOoNuUBd3ydIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5DFD94902D;
	Tue, 19 Apr 2022 06:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9074C40FF41A;
	Tue, 19 Apr 2022 06:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48574194EB98;
	Tue, 19 Apr 2022 06:10:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 414F31947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:21:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3186A454D6E; Mon, 18 Apr 2022 21:21:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C1A5454D6D
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:21:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1023D811E75
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:21:49 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-vIPKWtc2POek50hEpJzqrg-1; Mon, 18 Apr 2022 17:21:47 -0400
X-MC-Unique: vIPKWtc2POek50hEpJzqrg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB5101.namprd12.prod.outlook.com (2603:10b6:5:390::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 21:21:45 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 21:21:44 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 08/11] loop: remove a spurious clear of discard_alignment
Thread-Index: AQHYUuBa8QWBZz9aDUOa5Tmj7psG5qz2LtoA
Date: Mon, 18 Apr 2022 21:21:44 +0000
Message-ID: <a60f5fc2-fad3-3e82-00b2-46126c7844ed@nvidia.com>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-9-hch@lst.de>
In-Reply-To: <20220418045314.360785-9-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29c292e8-3de4-4b82-65bd-08da21817097
x-ms-traffictypediagnostic: DM4PR12MB5101:EE_
x-microsoft-antispam-prvs: <DM4PR12MB5101905494492F3B3B1789BBA3F39@DM4PR12MB5101.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VTdOHMLOgj5nGlVqc9NJF8HcI54YZvuZgAg95udf3adOomd+wnZvnFAnda6i9vsfcSdwvXzHOCeeqxWt9aMlrMjRWF7Xv9ySzuXME4VPhTN6b7ns2yrqA075agaZdGinqKpCILKu86+pqIbpUNB7ihfkTGMgUI44TM4j8mL5K+wRdRnDOux1aCIyo85Wi24KeN8TisGUyr2oIbkV7/Lg+6ZyC/+btl7c36JMnsxIoHus4s5Yj3TIe51AJhZxWcFEv5Wj+I7IkVe2aWIIFQ6gssIKIt46n0J0ldMlDfh6Y+MFdRUEZ8tppl2ALPOjxZvB99il+VWZ5X4bLWTWl6JwR0Gty6B5Bfm/6c2/uDwv7PD3USn3AXdA2X8HK5mb5ibCpFELSYp1vTg5bBr8XnpgAClHXDU66lJrPlW1e84y4+nf0j3eHfsO3i7DYZT7tulSMSyiTJSBPkV9mCKI2W93bwqfY5s7gNZ2RdO2/4Qg7mNhPkiqdJdFo7Yeotx1Yz7emda/qftdc6e8vNGM5VUFW43ZFvdL3NsiG6P8Uwra5wmEkVFYZz4Bc6PRf568LaAMP3B23aCWHIB7AxBI2Nmm90JPG3Pv94gJxiMzjH+o+oECMD0A/cdho5FbbDmKZz1VGs1WIQuwUCqcIk1syuc8uQj9uZ0XiZoXSS7IH3MsjfaGsnWX4U/Njp053kRrHzoG7aKMPQ9OClMuvLfpWMh0gLOw9Z04aQgHxVy9ekz0n+4gnIxtkwrlMl0Xl7Ap0YqtO9luyWBM5+K1Ke+FJuKVBA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(38070700005)(122000001)(38100700002)(5660300002)(4326008)(6486002)(186003)(2616005)(54906003)(110136005)(508600001)(6512007)(71200400001)(6506007)(7416002)(66556008)(66476007)(64756008)(8676002)(76116006)(8936002)(66446008)(53546011)(66946007)(316002)(91956017)(31686004)(558084003)(86362001)(2906002)(36756003)(31696002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UE45SDBjVlIraVRQaFkxSXBFV3dQaGFhdzNpYXhoeFp5Q2QyZzBTR2dEUm5E?=
 =?utf-8?B?WEs4NXVhT1orNTZheFBQcytBanZXTjN4ZS9Tdk5oNERRbnNXQlNuV1BjSHNU?=
 =?utf-8?B?NC9jTmZKalpaRVRMN0MreC9qVFRLY0JCMytKTzNhVzRoeVRGMjF1c1Q5VTVJ?=
 =?utf-8?B?UURCZWZMQ1Y2eXc4WGJPczFLRW1zWHlGdlU5WU1UK1pwdzcwMjQrOENTM1E2?=
 =?utf-8?B?bU11TnVVakFOc0pvRHBqQ2JTb3FBK1B6Q2FWaGVIRlkwVmRKNGIwY1V1N2ph?=
 =?utf-8?B?RXFjR2N6YW9UbUdYTkNSNm5tYVBwdWR6MWNPWlBDVVdPQ3UvdmdsSVFHOXl5?=
 =?utf-8?B?TGl3VktDNFdWRG9SU2xUKzV2Rm9KWUFBdzdZbldDOGlncFhzbnRYdWNJQmow?=
 =?utf-8?B?aFdFTGQ1cjhvUS92NmN1RmlDSE1kdWV0YktBZ2dkS2J5U1dteW5GTW9PSzNO?=
 =?utf-8?B?UW5JZlFqSjVPREtQTWdScHZKaytXckxnejFHNUYxOXozUWdqNW9ibkFBUS9u?=
 =?utf-8?B?TXFORU1kUDkyVWpZNElQUnoxSi9XTEFQNnJEellVSXcybnNCT2FWWVNMeHJU?=
 =?utf-8?B?MXcvZXlTT0krUmlhVVFkQ2Q4OGVrYjk4cjhsVm9Ibm1xTjdMdGdoVWcwbTJE?=
 =?utf-8?B?bHFtYXVXeHp0cW41eWI2VTVBQkFjcmJWZGJQbGZKeDdQRnNyRjVaVlB2NWk2?=
 =?utf-8?B?MnVFSm03V1dnUXNsTm5ubWEvUjRnb0F2cDhXemFkaEtnYzJibHh0d3RFSHV1?=
 =?utf-8?B?RmlqdnRRWWpFVEVBNUZNWjFmODFLNkVmWE01akFmUklpTzNhMjBIWXVIZDF1?=
 =?utf-8?B?Q2pGTjlibERiNkpkeTNQYW14RVVGaWJISU5CdUNWTW5icXU0cG0xQVJ3TkN1?=
 =?utf-8?B?cGQ5VWhzTnNZSmtIblFyVVJuaEp5cGRpeXlTNU5oMmRRdVNBdVQrVlFWNEdY?=
 =?utf-8?B?ZlF2ZUtYTUVwRjRuN3RPVkxCY0ZIUURkdlJGRUkzdnByMGJoRDcveGcxbUFL?=
 =?utf-8?B?T05ZY3M4bktoNXlIdGkxZXk5VVM1STJrZHMyTDF4VnQ1UXE1bVc2V1Z6djcr?=
 =?utf-8?B?VFp6cW94RmhFZzRUdXNGdDkyVWlRRUhPR1JZUnNJSEdndHpHSk1lZ2ErVHl1?=
 =?utf-8?B?SS9LbzRjVlJCQm9IMk4rWXZkbFIzUnlZVUVWdXFHUFdLekUxeHg3aUVJcE5p?=
 =?utf-8?B?ejJKdDhVOTU3S20rNy9FOG14N2pCc3FDNDQvVk5YamhkMmt3RkYxMlJQaWRL?=
 =?utf-8?B?NWJnRHJKYStzam1OTTBxUFErdjdyTkl2QjF3Nk1sL3FFVFJRS2RVeGVLL1hy?=
 =?utf-8?B?NWtMcEVPUURwMk5aeHJCZ0d1U0xOQWFxRWYzL1VDZ0p1enAraGwyeG9LOUo3?=
 =?utf-8?B?Vm5senFER2FTUmttTGdXOEhqL2pwK0RvTS90UVpOK09xMzFGcHhtODhHYUtz?=
 =?utf-8?B?aEhCcXBqVUxMWmZmNEcrYzI0emJLN1hjbmlyL2pDOUtBSldyMDFWNVh2elpi?=
 =?utf-8?B?NHJqTE5vRmYzVmswQVYvNFI2QkxyRUw3V3ZzN2Z0QjRHRkZnSGJ4UG45SlpB?=
 =?utf-8?B?TmNiNnpYVVkzczlQWGE4bkF0UzNnZHFtMFkzTjg3d1grVWdBb1pweHZ1TWpl?=
 =?utf-8?B?WEljWGlNUHFFZ2paUmR0WFY2RVRFKzZOTTRkblltL04xNVZ5b1R4NmVMN2t5?=
 =?utf-8?B?ZDJQYk9iQ0tGOHFnUXdNWXNxTlRZTEtzOVN0MktwUTBUd01oREFlSURkQWVK?=
 =?utf-8?B?R3h1SUYvNmN6U2tadGU0U1dKRiszczhLYnhhSXNXcXFHL29HcVRpRGVBczNH?=
 =?utf-8?B?Rko5aVBIblhEdlB4TGJRay9PbkkwWVNXNi9vdnYzWkkwY0lKQWk2bjd6N0JO?=
 =?utf-8?B?VGR0NkxSUjJHeHo0ZU5lRkt2N0dHVVdocXgwaytlVlo0Qmp4dlB4Ym0waGhL?=
 =?utf-8?B?MWtVQTlyWDd5SkUyR0E1c0d4QnIxMWxYbUUvOUVFWjk4Sy9hTlJIbkJ5a3FC?=
 =?utf-8?B?N3hvYzRUMlJ5M2oyRzRnYVcvTzc2a0dqRnhKUXVTY2FDL3NMcnZ6Q1BkWlpU?=
 =?utf-8?B?VEE0OGpEdDlBN3RKMEFWR3JiUFJQMnAySTMvbHBSbFBRcXU3aTVXdXlleHhI?=
 =?utf-8?B?Vm80bmE2RGsyN0d1WnZ3VThXRlVoVG9vS0lLbWJjK08vRE1JUHhvbklUcU1C?=
 =?utf-8?B?TnlBMXJBSzlBeGtoTjdwUnVmaXlQMFZIMDIvR2ZzN3ZXRVhIT0hpZkk3L21n?=
 =?utf-8?B?bnZzZWlTUUtvVVFTSUg2d1BYTjVXM0s5R3JkQXMrcDA5bllLS3FpdWlYdmNX?=
 =?utf-8?B?cFFLRmdGSkxHd0ZRY2tPdHdKdk1aVEs4TDE5S2x3L25EMzZrUnFKOGR6ZTRi?=
 =?utf-8?Q?PQoUgCYR9P1+D+Oo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c292e8-3de4-4b82-65bd-08da21817097
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 21:21:44.8408 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XFN+DIrHwXW4dMMfM+xmFlg+tyVkcF7I1h6/S9n/Q2biCyaj6At7SnFy02ZzrCvM3Xc6fVux9dDTKsDMn+vhYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5101
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 08/11] loop: remove a spurious clear of
 discard_alignment
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, Song Liu <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "Md. Haris
 Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 Richard Weinberger <richard@nod.at>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 Mike Snitzer <snitzer@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Stefan Haberland <sth@linux.ibm.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Martin K.
 Petersen" <martin.petersen@oracle.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <41D9387E299FEA4DBE85A4EDA24D0FFB@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/17/22 21:53, Christoph Hellwig wrote:
> The loop driver never sets a discard_alignment, so it also doens't need

s/doens't/doesn't/

> to clear it to zero.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

