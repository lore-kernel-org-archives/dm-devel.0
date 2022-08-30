Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF468ECAAD8
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 06:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661842657;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VzVqeYz/Wc7XYztsSsw5xF5sb6MO4HSb1/4seM4satw=;
	b=V/Etno8tr6557z7Zr2nTS5vBC3O2VDc4A66jOht0ff+cQ3htRjlJbippPf71YezzAICurc
	I34zT0XCG9wy2j9aQu/I+BGHh3okwPL0wFviZPKQnn/O/Vgh6JOmJUgPvgQqKeuZILSRNV
	LBt+r5tgoD9Vf+I0SYWlRB4ZSvM5g2Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-IibPG7aDPhuSqm3Awi9Srw-1; Tue, 30 Aug 2022 02:57:34 -0400
X-MC-Unique: IibPG7aDPhuSqm3Awi9Srw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1963E802E5D;
	Tue, 30 Aug 2022 06:57:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6168E2166B2A;
	Tue, 30 Aug 2022 06:57:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 340FE1946A42;
	Tue, 30 Aug 2022 06:57:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 805081946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 02:53:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A5B32166B2A; Tue, 30 Aug 2022 02:53:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25C3B2166B26
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 02:53:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0426280029D
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 02:53:47 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-QHycA3q8NpiA0VSkq2CNuw-1; Mon, 29 Aug 2022 22:53:44 -0400
X-MC-Unique: QHycA3q8NpiA0VSkq2CNuw-1
X-IronPort-AV: E=Sophos;i="5.93,274,1654531200"; d="scan'208";a="314269035"
Received: from mail-dm6nam04lp2044.outbound.protection.outlook.com (HELO
 NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.44])
 by ob1.hgst.iphmx.com with ESMTP; 30 Aug 2022 10:52:38 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Tue, 30 Aug 2022 02:52:37 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c7e:a51:e59a:d633]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c7e:a51:e59a:d633%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 02:52:37 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Thread-Topic: [PATCH v12 13/13] dm: add power-of-2 target for zoned devices
 with non power-of-2 zone sizes
Thread-Index: AQHYvBuPaQNCPIoJM0eY4KBRnLcQhA==
Date: Tue, 30 Aug 2022 02:52:37 +0000
Message-ID: <20220830025235.vesnxh6xw6j2vvsu@shindev>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de@eucas1p1.samsung.com>
 <20220823121859.163903-14-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-14-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c94247c3-3e0c-4fd3-4ecc-08da8a32b288
x-ms-traffictypediagnostic: SA0PR04MB7433:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YDXeNlPfh4rS3fnBodeI91BduTPUboQ9/jD2sAZo+Qz2nfgI8qhQlwRdf1tF5/8ZHYUHuzVuFZB+Fdcc9LHGfzYPgeze8euJhbuTK7S8CYWosjdOyO07L2u6yEP2vEWzjHhIb92w1+tWX9bNj4bjqYdXoSgiSptkiLcaoMuiw/0Iux2+IWvw6c97WmoNDAxOr37eCfNrx5Wneck4Ju+NKGZrCr7gCmY3VJGFCkJQoxxfRSzNwcHJT6JOqRNara9cluYGJsCmCN15RIJHlXYcyTlT0+oYv2GL9EefWR5obiCk5zSgXb5xzeQiwKCAe3EWD0ciRpMwXTPFx6a72dqbiZdAlBvQMFTvMd+QIZ0mBg2YjcT3zmL+0EsobaXGRO+H//fb0YGT2KV1h4vwgG4W3YUgQ3uFCTNydHh9UF6nax0xkP4/T91aRjOqPlIsXx5F5kmV4RwIJi+l3vfzBWtXSc87DEukWLiO3DZHFAJrUZ3gNgzzy0lv+EVyqdfvC2nnGwSUV7NdLmjPj3IjaTYZkRYi0kamVt81jknQL9oy1+e4lyUUjOY5qU/V09tBHYZEl2H8B1/w0Rs0DuhujludV1bScOsoo9que5rwZoAZobvqxS3qfij/HjeXXc9Z9r0kj6d2C5gWBN93PyVRWkccew7tyc6bpo5sI8HePpih/6mIlZwpdwwgtHdZW8dPT0Aav7S2hx1Xw6htfubVjW4wOnpOKOg2c3gTxXxPc+YuuaG9ugjZ9jqVCFpOV4ULUxU4x3SaQbtZCbE9jEXEkcy7CQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(7916004)(136003)(366004)(346002)(376002)(39860400002)(396003)(91956017)(1076003)(54906003)(6916009)(8676002)(66476007)(86362001)(66556008)(6486002)(76116006)(4326008)(66946007)(66446008)(64756008)(71200400001)(5660300002)(82960400001)(7416002)(41300700001)(38070700005)(478600001)(316002)(8936002)(33716001)(44832011)(4744005)(38100700002)(6506007)(122000001)(2906002)(83380400001)(9686003)(26005)(6512007)(186003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZXluAVRXn7EC5yVgpTN82pTohwVK/t5x3Tnyxtfb/mZt3/7jtOKyUEJQwI?=
 =?iso-8859-1?Q?ziAbikPxNdycOwM3EjEEujewjX1ZH0jk1Lv2/LlGDyVg6OTt5sFWv3B3S4?=
 =?iso-8859-1?Q?7Mmookj5fhJrvngN84RzmChCV5kgQ6sZ8OCnlE0+mWbNSMMpCnqwDvRwT6?=
 =?iso-8859-1?Q?VDRlucrAcCDAkhsI21k0o/Q0CYuG8vslmh7lD4AyVLbTXtVZVM08gBfoDi?=
 =?iso-8859-1?Q?kSdtxfDWFeQmkVqjgPsX/NYaRBXv38ZhTHayMeR3n+8AWlP2vXyd2zLfss?=
 =?iso-8859-1?Q?nWh+JOa8VDHQX/Ga2wpT/bg+x85ymiHCLIhQDCTRNFrqTwVNM4s3AOD6UI?=
 =?iso-8859-1?Q?c5qfCFRTXuf6/BCsa3Z4g9NC5esxqiQZXGS9lRJ8VDGDEzeAplIhuPGUi+?=
 =?iso-8859-1?Q?LBFVb1mQrHbpQjR9uVkRQSXhxTU9DAHBXiP3p65miK4IIzKK12GfkyWI17?=
 =?iso-8859-1?Q?Iq3KVkngsiooWS3h6v+FNKcNoNqQ7qQYoTDFT8N5FeLkwNnYJ/X+8KabqN?=
 =?iso-8859-1?Q?RJwfzlcbJSqMxEEFfYRmdTa5DwnpcVxyMwe0pY2WyKOy4dixed8ciAM+tP?=
 =?iso-8859-1?Q?XL7432FLYc99st6jMKGrm3YT2KHIoZpJPZ3uCOB1M81RzuaGU4PukXunLp?=
 =?iso-8859-1?Q?78+/GX5C99ROTmYAXEu1/IFjgYJQ/rfZ3MjrVRCjktG3GlC0fDnaM6YNn7?=
 =?iso-8859-1?Q?OexiZDRm4OFvjx+vvKVKH25ec3tzgD4GSDaC85m+3mGvXG65JTIyrw+ICQ?=
 =?iso-8859-1?Q?m1OnZBaUVha93a5dnX0rhb+UgNM6cjqidZFEBkdqtjS8me0JmWQ5xfxqg7?=
 =?iso-8859-1?Q?PhK1GK11HmI2igAKiEnH83ctRIveW/6rRy7YhCeE0V9nuz5f3LfS+RHDJr?=
 =?iso-8859-1?Q?iwLuNXK7A5SoJP3ZhzoaEkok51pUPsUfp6Pfi/yUDO9tFlR5Vo/B0qheA5?=
 =?iso-8859-1?Q?5VwgRlIa4ZthyAoQy4IkTpwkiAE94dwi+CdJcqkhWipebrwbQU8hW0TNiG?=
 =?iso-8859-1?Q?Qj+nlKTsEqcjDBtVwCdU/WOrJ3P36wQXpAKNbt1E6wqkdxjqUsTDA4bk31?=
 =?iso-8859-1?Q?kbzo6vUHOhFoVBssOoMYMAmhkxXRU2UyF0vV4zvQVN7noSu3X2A3YTdXZR?=
 =?iso-8859-1?Q?zVglGHWSvn7LYgY/dLQxVSeZVn9W6zsDnqRm6yBL6ZxZy5hgKUBZMChEs1?=
 =?iso-8859-1?Q?0nglIj/jGdYqNhg1dxlEwIlZDbXYQq+t1qMxwWDwCPVbaQLyX2U1exqSpU?=
 =?iso-8859-1?Q?SVv0yila+4ptmRmrAb/X+jF7oQ+h/A+A5xGH+5jDi0agBNW+jSgzJYyJq/?=
 =?iso-8859-1?Q?NPscSmnfjm17PK7eDuXxZY1AiOvvcPDAgdJreEy03AvPZTAkXnRDTetPW0?=
 =?iso-8859-1?Q?5E3XiXajCxqxoaqPHD4+pLCQRnjDonf9QXEqf7awDbRs8Sn12dRVx+DJ58?=
 =?iso-8859-1?Q?MMSDMOexWGxC28F4LsKH6Kh4o+DZ2Xbvn9r4Yg5eQ4oDtj9C+OAMzxNC+u?=
 =?iso-8859-1?Q?xhJdOJR8AWKXxcVRq2i4lnFJmztG0v4y1Folw5lWgF9yV8sGwJZGkt7voQ?=
 =?iso-8859-1?Q?WuF+1ABOKBSQ8o4JCoX544BUBqB0DnP9hAUAEw/cra6OEeN508rawXqi+E?=
 =?iso-8859-1?Q?ve878bo1cOJ08swFTNBMiJngPFXJqD9XovbEvrmpziewOY/xkcCLgdZbdP?=
 =?iso-8859-1?Q?6lZSROV/O2/5L7AxjC8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94247c3-3e0c-4fd3-4ecc-08da8a32b288
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 02:52:37.4309 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X43BsAi1OoeVoyjiSFPgW0ARbXpI5BBOZABehKWWBJYqO6VLYChDj+OUd7tsUcn1687lRzwLXVaq7CqrCJzjjNnaCQ3ebZ7OLxApHXsFOX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Tue, 30 Aug 2022 06:57:27 +0000
Subject: Re: [dm-devel] [PATCH v12 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <42404C1EAA114F4B887B69257D54658C@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Aug 23, 2022 / 14:18, Pankaj Raghav wrote:
> Only zoned devices with power-of-2(po2) number of sectors per zone(zone
> size) were supported in linux but now non power-of-2(npo2) zone sizes
> support has been added to the block layer.
> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zone
> sizes, it was suggested to create a dm target for npo2 zone size device to
> appear as a po2 zone size target so that file systems can initially
> work without any explicit changes by using this target.

FYI, with this patch series, I created the new dm target and ran blktests zbd
group for it. And I observed zbd/007 test case failure (other test cases
passed). The test checks sector mapping of zoned dm-linear, dm-flakey and dm-
crypt. Some changes in the test case look required to handle the new target.

-- 
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

