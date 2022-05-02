Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93E5C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 22:07:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-gukXRAsxNJOwGXGj4h3PjA-1; Mon, 02 May 2022 18:07:21 -0400
X-MC-Unique: gukXRAsxNJOwGXGj4h3PjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23F0F85A5A8;
	Mon,  2 May 2022 22:07:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2431BC27EB2;
	Mon,  2 May 2022 22:07:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DFD9B1947049;
	Mon,  2 May 2022 22:07:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2EC511947042
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 22:07:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D71BC151F5FD; Mon,  2 May 2022 22:07:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D23691505944
 for <dm-devel@redhat.com>; Mon,  2 May 2022 22:07:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6F4780159B
 for <dm-devel@redhat.com>; Mon,  2 May 2022 22:07:16 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-UgbZYnieNf2axOkAHvDZ0Q-1; Mon, 02 May 2022 18:07:15 -0400
X-MC-Unique: UgbZYnieNf2axOkAHvDZ0Q-1
X-IronPort-AV: E=Sophos;i="5.91,193,1647273600"; d="scan'208";a="204240683"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
 by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 06:07:11 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB5181.namprd04.prod.outlook.com (2603:10b6:805:f7::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 2 May
 2022 22:07:10 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 22:07:10 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "jaegeuk@kernel.org"
 <jaegeuk@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, 
 "sagi@grimberg.me" <sagi@grimberg.me>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "dsterba@suse.com" <dsterba@suse.com>
Thread-Topic: [PATCH 00/16] support non power of 2 zoned devices
Thread-Index: AQHYWlBbVAcTcxyrHkCrWR4NhJ2aaA==
Date: Mon, 2 May 2022 22:07:09 +0000
Message-ID: <PH0PR04MB74167FC8BA634A3DA09586489BC19@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <CGME20220427160256eucas1p2db2b58792ffc93026d870c260767da14@eucas1p2.samsung.com>
 <20220427160255.300418-1-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 737a42a1-6be8-4ddc-e1f5-08da2c881a90
x-ms-traffictypediagnostic: SN6PR04MB5181:EE_
x-microsoft-antispam-prvs: <SN6PR04MB51816E48C7920B640CBD56BA9BC19@SN6PR04MB5181.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Kqd/h6p7qnADrAZ0vPTmp/tqhmWk3UMQKEFF0+hJzb98kgf35QW8bLHflCtDtmag3Om5qn6cXZfM/J/c7ucCBM0ubkLj/OxrJ4ymQ+OTRC2PtC7r7bc10NdXwmGN5aUN6Kt4qDuJV+6tFtZqiMjeiMwBbknXdm3Hx+S2IY75lJ7CiYDxEaq+yi8LYbTq7u05zyFqsZlh0qiWfCwp9EOU/zRS7VL3fkpzakifMHF6fRbRJUisM3vUQj2SjGt34mW5bb4+QlHQhsiz9LB6V3lIfdbvUZHFb9YkQxYCq4OTq8UnsAh/oq2xIpB1T6aHU+CE3aGXgDaxDagbqQr95SOJLwTnZH6ofmNXZB+DQ3NG2P3C2q3kW9osl3xk3aS2mYl/E26H9xHVtZx/e1PxlADY3BNjlKLsXyuH53O3hqatvwKzh3v98h2tdpTSENUX5gTu9YnTQ2pj4qRo8r3/Z68TAVp60ko0q+qJfKW3rZoXmBo2YM0f+Koa2o587XdAzRKrzv+Hrmwhp3NtNCJ6B30QiwPYMuutpurvoCOojQ2FbYW1/5zMqADUZGIUdHsir510h54VX7XLZXykdKJPVyLfV+Q1DmmQ27hEwbOC6Eg3sGlHyiR3NKNtSyhh7TBWyBtd/kTSK4rEcnxHMQ/yIFkzb8qylt9kq7aSAVORqb4h05iBnAP3uimjyZIEB2rzw4/abec2otGlstG5LyQFpTbx5ItzEa1w2ycIEQUhWfFbEh0Zdu36FOvxC+B5+WDkQya3svFZ2d/q3Ild8/YpSpb5Gx/1p4u3qNWreqEsACx5Oa6vkaXtvOM59K2HBAqBDUV+
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(110136005)(86362001)(8676002)(4326008)(33656002)(66556008)(508600001)(66946007)(76116006)(66446008)(66476007)(966005)(55016003)(64756008)(71200400001)(54906003)(316002)(38070700005)(38100700002)(2906002)(83380400001)(186003)(7416002)(8936002)(5660300002)(921005)(9686003)(6506007)(7696005)(26005)(122000001)(52536014)(53546011)(82960400001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?P6ofxjqdMTFATnV/5tCxB+leHjJbejMM+tFIMKgLJfyLd33uD0ZROxfmzM?=
 =?iso-8859-1?Q?bU11gSHxNkUCgkW1bG1IZcXHStFR5UNomn51aBeQTEmsG8MzeLgwxFCRso?=
 =?iso-8859-1?Q?mGMdLRsWC2YhkLUJgqNKuAzy/Dp4Zq/32Te9z2MH9ohQntXSEPrGctU/53?=
 =?iso-8859-1?Q?OKgmFCweNwiIpRrUw/uSH4SOvNIZ4vvbR2vTXwYvF7XVTm2My+5OgYOJhp?=
 =?iso-8859-1?Q?mUUGODEGXH91CVW4jQYttQ/Soue4ncP4stS6+ftqIcfdgN+6HHjlg4BFK1?=
 =?iso-8859-1?Q?nO5ExMdAIA88aeI2z0sV0+k4GGK/TlmPVNSd5G+nIu3i0uy5vGLk5a6VK6?=
 =?iso-8859-1?Q?2yMsYVlqCvH4GSWyJhwotwfNwlfzv5JaAIUV/eOWq6ZtdEUOmDlnKajXE2?=
 =?iso-8859-1?Q?AnKmZWLzmIDMgwTxLWzQXNZtW3Vs3TeKFKqSjdg5UVpUA7XAyo8KsyvS2d?=
 =?iso-8859-1?Q?bjfTQpdCheuAK3jPRG0UO9UY4S0KROvdev//xMAIVzvWSgubDgUoXXb7uw?=
 =?iso-8859-1?Q?qcufuB1+G2kXUozBN4qpsS6HS6+/Szef1sWEvfjZtJZL4FBqR8t5aAVuM/?=
 =?iso-8859-1?Q?2fiOUSApYsENbZ4OVann5Ih+koMjkyczdvpqlNn0AGYGwmKobNyxvlSauk?=
 =?iso-8859-1?Q?tLJJvyJYn7gpTM94mou5MK5gAqYRRW8War4ZcrEj83KlaqtNb8asIGIZ2v?=
 =?iso-8859-1?Q?qyJhF/SUJ06+r0Vcpc+LgpGtDqysMBZkROy/WlKlxPRKVtZ4EkSC05kb+j?=
 =?iso-8859-1?Q?5RX9kocnheUpZG7o+kA1BtYiF5L6fBZntPBSbRxtz4hLkg1dG3clMiPIgg?=
 =?iso-8859-1?Q?qdOm0frLxyDTuUAQf2npsgHO4FJykAD2F15eyczm8OqgQHilJCwF3GSRW6?=
 =?iso-8859-1?Q?mEQ30Ig6ug4drcyqeuj88ys5HRcxHqbxuDw3zV0Ou1yEJ4J5KfbXFQM0ki?=
 =?iso-8859-1?Q?MqsZH6+/u60C8+ol+UiagA4tKn5Mnoe5f7bss/153jEU4Og+b9k6gN20vx?=
 =?iso-8859-1?Q?FKRBfTaFHvuKqfB4r4RXRyhCeoEWlxThuVTmGPNauZ34ibZn3ezPFwBo5T?=
 =?iso-8859-1?Q?ipkqS2DwVlE5xk+8TagFipMVGHLNU8qsEi57wlxZlliFx1fBpWsnBL7TL6?=
 =?iso-8859-1?Q?o8WONe35+/H/IzidR9zFCVSRugEHBvuOXk9xg4VxWWW1ZzqZ2ROJiud9yl?=
 =?iso-8859-1?Q?MtQrPcWTv80YgQDuYofPVap5xCUKyCqD+vt+oipXJMXFsskNj6FYhwHyBm?=
 =?iso-8859-1?Q?GjvMWPi3jLwrl5dcr20g7/vap3c7z4HhKriu0GFETw9d7lh2/OC1X5H+fi?=
 =?iso-8859-1?Q?+kBm7F4gifcCHCxAYJCfpJVNK8Bbgr0bNldWJXD2DX/iAvnFMmxzi1G8qR?=
 =?iso-8859-1?Q?TxAekoWB148BPQOBeRySZyl0zNXeoOGVLf+2ej5Z2pFoFgCYxUpSrgochd?=
 =?iso-8859-1?Q?TtKwTx/ermFrGJfQo+1xCVVnjv/iitwvX7jl4cJ81ezNJJsK5A85q/Yx2H?=
 =?iso-8859-1?Q?/zbNsa6lkRUTVNJB4n8rJUmNNvl5XsBYwMkpzXXybtSMbUQ6kI+ZiKGwF+?=
 =?iso-8859-1?Q?yKqTKny4tAls78Or5YNqyyeiCWtj37f+P8RJ9KLcTk/hm8Vg80ZEvXdrqh?=
 =?iso-8859-1?Q?Y07uI+3ZbszSMGFZD/aUM7oCM7OiKq/itLfKRyx8lWkudzKz7Q5pNoR1s8?=
 =?iso-8859-1?Q?XZcL3swH9jP0WNKQf1KSWHZZ/08Ama1Lu167dfSvDnb6Bwt40y+P5LTg6D?=
 =?iso-8859-1?Q?YM4F6DRUXyH9/VkSg9/vIG2+7HbNWxtgnYhRiAPlYif7nsYCuKbq8NZ7lS?=
 =?iso-8859-1?Q?ybKrrTsc5zXcuCrfBWbPCW0LGiXuOuY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 737a42a1-6be8-4ddc-e1f5-08da2c881a90
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 22:07:09.8911 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXSrpwmMcyRTXNrz68EpBiuYw5Pa+tQrKzFBtB/vEuBvZU0/1YCUZGY85gPHrGWwgqhO24XrDnLv9PFZCzRHRd43nlRi4zPyiSYm28446/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5181
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 00/16] support non power of 2 zoned devices
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
Cc: "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "kch@nvidia.com" <kch@nvidia.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "chao@kernel.org" <chao@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "agk@redhat.com" <agk@redhat.com>,
 "jonathan.derrick@linux.dev" <jonathan.derrick@linux.dev>,
 "kbusch@kernel.org" <kbusch@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 27/04/2022 09:03, Pankaj Raghav wrote:
> - Background and Motivation:
> 
> The zone storage implementation in Linux, introduced since v4.10, first
> targetted SMR drives which have a power of 2 (po2) zone size alignment
> requirement. The po2 zone size was further imposed implicitly by the
> block layer's blk_queue_chunk_sectors(), used to prevent IO merging
> across chunks beyond the specified size, since v3.16 through commit
> 762380ad9322 ("block: add notion of a chunk size for request merging").
> But this same general block layer po2 requirement for blk_queue_chunk_sectors()
> was removed on v5.10 through commit 07d098e6bbad ("block: allow 'chunk_sectors'
> to be non-power-of-2"). NAND, which is the media used in newer zoned storage
> devices, does not naturally align to po2, and so the po2 requirement
> does not make sense for those type of zone storage devices.
> 
> Removing the po2 requirement from zone storage should therefore be possible
> now provided that no userspace regression and no performance regressions are
> introduced. Stop-gap patches have been already merged into f2fs-tools to
> proactively not allow npo2 zone sizes until proper support is added [0].
> Additional kernel stop-gap patches are provided in this series for dm-zoned.
> Support for npo2 zonefs and btrfs support is addressed in this series.
> 
> There was an effort previously [1] to add support to non po2 devices via
> device level emulation but that was rejected with a final conclusion
> to add support for non po2 zoned device in the complete stack[2].

Hey Pankaj,

One thing I'm concerned with this patches is, once we have npo2 zones (or to be precise 
not fs_info->sectorsize aligned zones) we have to check on every allocation if we still 
have at least have fs_info->sectorsize bytes left in a zone. If not we need to 
explicitly finish the zone, otherwise we'll run out of max active zones. 

This is a problem for zoned btrfs at the moment already but it'll be even worse
with npo2, because we're never implicitly finishing zones.

See also 
https://lore.kernel.org/linux-btrfs/42758829d8696a471a27f7aaeab5468f60b1565d.1651157034.git.naohiro.aota@wdc.com

Thanks,
	Johannes


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

