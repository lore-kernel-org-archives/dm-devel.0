Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF27C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 09:57:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-mAGJV121PMWWXCMRIrnA9w-1; Wed, 06 Apr 2022 05:57:32 -0400
X-MC-Unique: mAGJV121PMWWXCMRIrnA9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7099D833964;
	Wed,  6 Apr 2022 09:57:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35D7D40D1B9A;
	Wed,  6 Apr 2022 09:57:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E65F0194036B;
	Wed,  6 Apr 2022 09:57:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B752C1949763
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 09:57:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 822D41410F3B; Wed,  6 Apr 2022 09:57:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D295140EBD5
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 09:57:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38028811E76
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 09:57:27 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-p3zzurcaO12GK1zqJ1ToXg-1; Wed, 06 Apr 2022 05:57:25 -0400
X-MC-Unique: p3zzurcaO12GK1zqJ1ToXg-1
X-IronPort-AV: E=Sophos;i="5.90,239,1643644800"; d="scan'208";a="202070882"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
 by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 17:56:16 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6607.namprd04.prod.outlook.com (2603:10b6:5:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 09:56:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::a898:5c75:3097:52c2]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::a898:5c75:3097:52c2%3]) with mapi id 15.20.5144.022; Wed, 6 Apr 2022
 09:56:17 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 07/27] btrfs: use bdev_max_active_zones instead of open
 coding it
Thread-Index: AQHYSZhFjrFhkOtPTU+vji2wK2+0AA==
Date: Wed, 6 Apr 2022 09:56:17 +0000
Message-ID: <PH0PR04MB74169FBB31E68E76E34DDAC59BE79@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-8-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcb98ed4-cc62-4a3f-8a01-08da17b3b1bf
x-ms-traffictypediagnostic: DM6PR04MB6607:EE_
x-microsoft-antispam-prvs: <DM6PR04MB6607721F18B062BF57BF16C19BE79@DM6PR04MB6607.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Nk2MJlm/r7uGtMIckrZ8/20DB84cHxXsyMPbPfGUVCbeLXDLxGaUBQM+iMbI0TIDMo8ybZcbg05B1l9oYxnCRDXiZkCfwL3sn98KZz49BhXqro2r1QD7cS1mUSAk52FIyznZ4v0Klb7TdN7t9KQcVo5GmjUcoyVro/T9NgdLhj55YUmzdMDKplWtvSR6br8YGC4S6tSCcTufSCuVvWT4UQ8n1zjpHCFVe4BHJ9HrIIcshXSnzVylfjU4RVUlTcWWznKi6E4q39IhnKk5tf0BjqmepnIOk3fA/n3MYk5dt47VBb3YFRTpkcX4/AFxtQC6VeUbKz9kKrwIxEi0zkZzLqmByyavkn9KDz7K1VUmM/IBgoJr+SdhhFpqcVBbjI34GNuS4i+tZ7mVmk3cHDbtKp8ZKZQB9EbL4QTCET7woB2SFLYFet5MlheD4eympyeAVgxzOTRGC0mQ7sBtQju+XlfkXIn0knIcLEYqswn28rGiCm+seMTcuTaukFfRvCjLv0fCsdkgIkp1enerhTohsdwWdDbZ+yq1L0ErZ2hSg1TGMszTXRTYRgoHxgKx6q6lnVf/EjZaac5fApQ86UVZVvJk2ZmXDrDAHY9W8X5FhQ65nRgId2WPz7Iaafh/jz8PnSfbw8pn8JGOOzrL06MADBo07mPq7omMiRg4rfqsamruR3NxRnLLR0oUXZQi/Ur9Rb8aQlEHzL6upjizBkGf+w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(4270600006)(9686003)(508600001)(186003)(6506007)(7696005)(2906002)(7416002)(5660300002)(55016003)(8936002)(54906003)(19618925003)(316002)(71200400001)(110136005)(66946007)(52536014)(91956017)(66476007)(66556008)(4326008)(8676002)(64756008)(66446008)(76116006)(122000001)(86362001)(558084003)(38100700002)(82960400001)(33656002)(38070700005);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OcznZgIADteDPeFOUq+CN6sBYP+/kmW3D5j7xx/K5X/J7+64nNzLXNZa+5ah?=
 =?us-ascii?Q?0ZgohPpwD570vI6niIUBqcq2mCCC4bPs3HF9If0pDTXYMHbI5tpo+6uU1ajy?=
 =?us-ascii?Q?GGFzW70IH51vjuIirLPrIWVPk5C5eXCcUNZzJcSEIE6PNPIKJh8vD3O1Gvk4?=
 =?us-ascii?Q?1JMEcCgnGyp8YHCCJNHAPDicTDwIRgbtUTLad92MTeu9qzZjwWCkwywcvQwt?=
 =?us-ascii?Q?MQCZ8nki7Ux40zqnfiHYW+AhE2QGn4PDo5ixzVfwJ5/CUh3lM+9R2CPt1KPy?=
 =?us-ascii?Q?xMEWdeuD60BMfglDOIbAaCEfUj65VFnSDiAftlXQ+XaObFIxp/QPxtBkAMAk?=
 =?us-ascii?Q?rjtGO6aBO8v/hwlPRrlzKYyRMFzUupk4CNGmWt3Z2IlK23bdO/HzsNLxTdvx?=
 =?us-ascii?Q?F/ab1WHMG/SfMEs+/cPEMU62hGIc40jgnlkSc4dGNIFAdBiguKYZaGG40axo?=
 =?us-ascii?Q?QLghxYfv64zM0N2OzXk9KtGnE5SAQwTZzdmHpSj/wkFPfGDPZSJcP/D8E5q6?=
 =?us-ascii?Q?e4ZjHnyW0TJ/kaldqrqvKSXkAYfCuDulEO9Ab8xhUwNp4Z6iVdFGrfFukliC?=
 =?us-ascii?Q?l+OkRH0ECfZcpim6uUsWVelANXXl0CYIxLtvhYnbWq7F9uER2Gkwgy7QJsaF?=
 =?us-ascii?Q?a628Srj0r2WumyRX4DssaZU2WCZdNF3VVjs8bZD1nIlEGU9begPUu+HJu5+k?=
 =?us-ascii?Q?x1i/41euwTUu5uPNfIvdcGf9IExlDD8h5yt9mzd1KFjeMoll1jNgV6rNH27u?=
 =?us-ascii?Q?n5RoeaGlsbgmvdc7mJ/LXpfVAwT4SqZjDcAintezx/IwTSs1nMq0ijtjMwj5?=
 =?us-ascii?Q?ktv0vvU+Seq3y6wA12FQwXNEnpCfZv6o3c9BSVhlkXduwFn0p9Qt/8y9VCoL?=
 =?us-ascii?Q?XSPsZoCBzzT2ubGt9sHwVpS1BkHCBUBhQoQewbrEeCa29DVl3ed+DkaZ8ob+?=
 =?us-ascii?Q?Nc5IThF/mXr1dysBDqiFaJyPY8uUJxrJOYRV7lKrRp4UsCFiyI+7/o2Rgpmr?=
 =?us-ascii?Q?fTzaqvAujVgknGtvFcFfmCIjItgOkWsyLomudA7hPeq4uzzkCKSK0pOdMohG?=
 =?us-ascii?Q?X0UwxPRIaa0N4ZT+pMwBlMt5dzNpoaPZWDDf4JU4m6hNClFZ/x+wQyKM7e2y?=
 =?us-ascii?Q?UJsUD6GGV4bwKlrdEdWAOgCxyxpiC2djuoWWy4g85tnBZ+XqkQfUw0RZXcbQ?=
 =?us-ascii?Q?fK9KiSv+3KpPfWsDnOvBYOPszdjmONcj+hhzHBnSIYEbG21zO8z5mklY9mQg?=
 =?us-ascii?Q?7oYXPYninSoU/jB0VOwqNhE0A0vfGE6us35k0t6QTwwy7q5O+N4/zEl0qjI/?=
 =?us-ascii?Q?1I+wpUkDObvtm8TDU0hWXPgNkTPh8rsoO8KSJKQNVkU+ZozXt2Tscv8yBG1R?=
 =?us-ascii?Q?W6JpbZs64SuI3PGS7YENHXSzLCdWvwvbrl1brK2kEsB9pZAdOVRNpYXpfZk4?=
 =?us-ascii?Q?jkdiLxCmn8+Pcw+yl9h2w1w7W/ZHIyg9ueLehxJUo/iNEEGOuZzyejQK+rxe?=
 =?us-ascii?Q?crCPwopA2pduPyJjACdthNl8guUPhrkN6l9z3DswDYdOLK8XUOmi1J6cRYPp?=
 =?us-ascii?Q?YQE71i+MmFCGHlMV5PsmiLWXzSqROnXLPiyWMThDmeKTHGbO4cWOsQUXdgcw?=
 =?us-ascii?Q?ThDnH0E0c6RYiqUF0XGnbh/5zrSNZ67EW1UzQM2DDgrbheYQZNPfPnwzrsX7?=
 =?us-ascii?Q?wGWLt6hh6RYPBUxbuI06xXGPdpEjZtYHTk9G2Z1PbKhVxooLrjGgvlZepxHD?=
 =?us-ascii?Q?ESS+vxrYZAlXP1aqBsNdF0KHRkGfUwam9adbrdHQogei2n0gj35+KZLyAQRJ?=
x-ms-exchange-antispam-messagedata-1: srMZBCvbXKwnVy/kz7Xcntl/ozUqZq/HpIw=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb98ed4-cc62-4a3f-8a01-08da17b3b1bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 09:56:17.3333 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lPW8HtDsBeFYCtcSfoUiCOuBbQaewM1lFtcu2MbVcViHTWVnuqNjO14Ik1QVllpEu4CmuoDpR6lIPDCOe3F2OgQTSlM/31m3s23SGbVrgRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6607
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 07/27] btrfs: use bdev_max_active_zones
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
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

