Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C72C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 06:51:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-HOABt_RdPcqDz0EGM1KZig-1; Tue, 17 May 2022 02:51:03 -0400
X-MC-Unique: HOABt_RdPcqDz0EGM1KZig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A165804195;
	Tue, 17 May 2022 06:51:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64669400DFA0;
	Tue, 17 May 2022 06:51:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E283194705F;
	Tue, 17 May 2022 06:51:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 943821947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 06:50:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85A5E40316E; Tue, 17 May 2022 06:50:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80CDC403156
 for <dm-devel@redhat.com>; Tue, 17 May 2022 06:50:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF304185A7BA
 for <dm-devel@redhat.com>; Tue, 17 May 2022 06:50:58 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-pkRrG0JiN_qoWhhFLcnb-Q-1; Tue, 17 May 2022 02:50:57 -0400
X-MC-Unique: pkRrG0JiN_qoWhhFLcnb-Q-1
X-IronPort-AV: E=Sophos;i="5.91,232,1647273600"; d="scan'208";a="205395433"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
 by ob1.hgst.iphmx.com with ESMTP; 17 May 2022 14:50:54 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB3816.namprd04.prod.outlook.com (2603:10b6:a02:ac::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 06:50:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 06:50:53 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>, 
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>, "dsterba@suse.com"
 <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>
Thread-Topic: [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone devices
 align with sb log offsets
Thread-Index: AQHYaUWvGG/TZMkJWESbmBi0yiTiyA==
Date: Tue, 17 May 2022 06:50:53 +0000
Message-ID: <PH0PR04MB7416DFEC00A21B533E86110E9BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6b3a256-a096-41fc-a1e4-08da37d19607
x-ms-traffictypediagnostic: BYAPR04MB3816:EE_
x-microsoft-antispam-prvs: <BYAPR04MB3816133F9C79F22B15AAAA7C9BCE9@BYAPR04MB3816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ilEEZpH79JHFziUm8Q4NyZFseJATqR+wtA8xnQ+asOD93BwFwQ3u+sRGho7+TzVDl2Duzb11eeypdNyMgRT6Hrrx9uiqJFUaVuXF4I6e5S68QGnJnlLA4XaEs1zKRpyfpXKm0MhkZ8Op13CI0/NxVA88NB4FZyVVdd+Ncz5dfihtwSPTM9s8EQWDgDuUmnr9F9FVBoySwBSrKZhOxxp7xQyRKZjjvb+wfLCbhupbjQrRIGpRqBXq1rV5ciYf1CGicAgFVt99b8lE+HFxbxpijG32ja73OV+N1G0dFE+pn5ZJ0AUrMDLWU0roQ0I3sqGgGQOxEWfIcWPUxnRbAkVHFJOmq2vusFuCvLV034ndpW2CZQXob7Pw6urlZcgMiHbg0/xvTDuykxevhSCJYd5gzJ3vA5mNS2A9vPaPhMxFbMJD8ZQ2SInC0ZE51yGSCQZBc3bMJjx3Y+AbcZ3rwEEE0m+uAd3hnfs1ZcXEDqJ0XyW6PNa3GGpM+risnoDmIjkv9FMNCMnrduy1CMHG+8Zf2Pe50AB3clAAJILxFxauhJe3n3hvMBe444w4hunNHNSJkETIW6hijrwW1mw0PQ1AQX3UJY3kgBwEfcmpy7P5dFygzNBFrVrnQn9Cr6vuvQPNVD5TAoHK6Ic94hpeyZDrNZkOc+bQSWvdpZH64PGa4RKSrzNJKSR1NpOAfhpdt6cdeT5OxLhuvSG/LwSYE3KwuA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(4326008)(122000001)(38100700002)(8676002)(64756008)(4744005)(91956017)(2906002)(66476007)(66556008)(5660300002)(86362001)(76116006)(7416002)(66946007)(8936002)(508600001)(38070700005)(186003)(55016003)(33656002)(53546011)(54906003)(316002)(83380400001)(9686003)(82960400001)(52536014)(71200400001)(66446008)(110136005)(7696005)(6506007);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3LZ32nKeZjXeywVwc45a0jMJgEncxtOq8Y6/gge5jVaYLqzmeDqAcZ5eVhvY?=
 =?us-ascii?Q?ZtrC4a2YVcax0Na1WjvSYueRVK1Rhaq6cPLKVHWG0SqrOabK9v0e1PcVpcxf?=
 =?us-ascii?Q?KnyD6Dfsqd+Hpd6jraaUFJToEMBJTyFBjq9cWlGCWy/6Lyaefu+kPS/yR7jG?=
 =?us-ascii?Q?QOwlPWY5cUYq8h7jrrWScHP8woQOklg+aCG7TQhaRq/pH3Z5UNK9BKa6ZiU1?=
 =?us-ascii?Q?qYPmCTtEw5ZFIroMkjNGAsjTMjybZaPkLbn9rqPYgs9WxG+YNr+Wope3hVb3?=
 =?us-ascii?Q?LPo51Zw/akHtv3wI5ZHqGTMXmu+lKvVhcDXneHqu5C8/pCWdg2C/BnP6c3kh?=
 =?us-ascii?Q?UeThEGX/YpSGo+TsV6fb68XLb15TUYh9i6BEqcbyfUP7Kr/OUsSXdbGSq2sU?=
 =?us-ascii?Q?JwFMlMTuvN/P3jHuiVP7UMG79VsqphI9YdcWZtmZ3hQGXit0wsZrk/gk8kWu?=
 =?us-ascii?Q?FD+Xx1SY+XbI/BA1bQ4K8qp/XoaZCwmLNY9cwdKSh0gjzX3fkWGv89ldqwVb?=
 =?us-ascii?Q?8ROsPmMDGDmU2NUj2tlCjeTeLp3UO3OV7Sde99TvdW3wLefLoMf9Qr5tKGRB?=
 =?us-ascii?Q?ZO5zAle7f14jR57UUPPeTfA0W+ZYIiGBrIjtfSNuIFOP3uYupxVmDjzNYDMC?=
 =?us-ascii?Q?zx8OsXlvfX/CeVJ1+wBGSqFEk00VX7XEje3uRDAmxqDW90V2W37/C00YegGe?=
 =?us-ascii?Q?Z6JSWymjJY30gTdsP5XARtw7vhCyvSBYDznPjlAOWI4XSj4km67Cnc4kFcw5?=
 =?us-ascii?Q?Ki/Rytz/YNi8e7AZVYROSCpQ1aT6lTCvFJIbox0fKwx3vt4SiiUWhIv8FV2S?=
 =?us-ascii?Q?S6cohFh4G8GD+5jjhXbAbtW8NYnXH1lKNGC4QzZSaqx4ab8ghdMEh85+PO/8?=
 =?us-ascii?Q?eBWiCUtBkKMPd0QZcUyC+vN7fHuLqXsoBfMMhka8pUB5Yh7VsrdKNjwMajh5?=
 =?us-ascii?Q?D5t02VxhsT3JBqhI0VXpXM+FkhbAgDjPwsNAQx/139YEg1prTvou6z2eve/P?=
 =?us-ascii?Q?FjfOWcctOO/E3pId5oecBpKaOgJWOaXonyF9MDgPJKrXQRdDwPYevBSRDd+z?=
 =?us-ascii?Q?KdPxeY/s5WneMYSCnje7o+6xIcyjvpvhc97woy/e0Kdj0rDaQIcjxZQF3NfZ?=
 =?us-ascii?Q?qGD/nTfgSkPq5+jVWQen4pJ2W68Ccfg/IhrG7Xnhb+RI2ffEvdAZJ6/gyQpR?=
 =?us-ascii?Q?2EA2/cLyOnhADz1NnO3yH/YBOMQ0umvQvO07nkxrJ4HoiOHxUkfXwx4lI3wK?=
 =?us-ascii?Q?PoVsWM4h167VyrpmsOi5abFgBA0KgrP6nI0wvC8OPZ/UkrUs3UEpGKOCoPNq?=
 =?us-ascii?Q?UDzsNvMCAhQuSrZooXSsoNy4+lB2lsGHoEs+ZODrciXOwVjDPFx9chbuB3Im?=
 =?us-ascii?Q?q6Zc7jtRUga3oYmZXdKr79zxad6YEEVX8Y6W41UV+nan3zH5gwKgtPNHjl9Y?=
 =?us-ascii?Q?Y4NcDtcV9ui9VRXDFtuF6/v/7Emh1rBfLCUGxtbs+EJr1nuWsKXbi17of6v8?=
 =?us-ascii?Q?V9wqm3d/mpfqznatSkiTWlBbYjs48SfxzV5IAfsisnyJzoOATO+9SFRoDyjm?=
 =?us-ascii?Q?fhnwY/5Dqx86ESLafSnjrwwPOjTWFOaSBEECIzUtCgfYAnyNAx/5pf3aOU4b?=
 =?us-ascii?Q?52XndwHzXZRDy4jG1apMXSkblA2KzCx6bJi4Qqh+j8+pCQIzwb06YMcbAe4J?=
 =?us-ascii?Q?IADir7ln7T3S8DwK0oeBDd8JMkWhirXKxFX14zTdcsYQiYnunHw/nZfqZfVm?=
 =?us-ascii?Q?mmnrLRTrI+ceNeIVZKO4mPiFKmTFJsQjwJ7PQU1X/NFI6NuaqPo99GJk+azJ?=
x-ms-exchange-antispam-messagedata-1: pnBBFb1WuvaMgZ0F9Mv+JzYTg/j0JU6pPfhVkG/fAqrmhnqv7d5NaSLu
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b3a256-a096-41fc-a1e4-08da37d19607
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 06:50:53.0809 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qPBszXRcKXTXObgPvRC03m/V0GqF+ED729uih601hETzqTRx9MZrV3SOBzbgAl5kh+W8x8F1oRU0Q2qAwj2mjJ18LrKjjONQECiwNmrJxaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3816
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone
 devices align with sb log offsets
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
Cc: "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 16/05/2022 18:55, Pankaj Raghav wrote:
> Superblocks for zoned devices are fixed as 2 zones at 0, 512GB and 4TB.
> These are fixed at these locations so that recovery tools can reliably
> retrieve the superblocks even if one of the mirror gets corrupted.
> 
> power of 2 zone sizes align at these offsets irrespective of their
> value but non power of 2 zone sizes will not align.
> 
> To make sure the first zone at mirror 1 and mirror 2 align, write zero
> operation is performed to move the write pointer of the first zone to
> the expected offset. This operation is performed only after a zone reset
> of the first zone, i.e., when the second zone that contains the sb is FULL.

Hi Pankaj, stupid question. Npo2 devices still have a zone size being a 
multiple of 4k don't they?

If not, we'd need to also have a tail padding of the superblock zones, in order
to move the WP of these zones to the end, so the sb-log states match up.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

