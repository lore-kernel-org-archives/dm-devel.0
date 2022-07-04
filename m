Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D5CC43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656940496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=c97JNawAgFoc3aQZfIVrm1CfmSzmVOby3UtIuYT3oTq8rxjfoWqtubEc1LJ8qyvXnF9h8p
	4qiUHgH+Qyc7cjeW5SRo+i9WHoLhXfLGtvaxnqWIkqjWQzxrY8hJZfFz/CKg9ZPvZu0Rlj
	AMI8XMv9Ii29wY/0VSEIzdv7lmevtq0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-_TeOj3LqOSC-A5T6uJUOyw-1; Mon, 04 Jul 2022 09:14:53 -0400
X-MC-Unique: _TeOj3LqOSC-A5T6uJUOyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3F973806729;
	Mon,  4 Jul 2022 13:14:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 775C840218D3;
	Mon,  4 Jul 2022 13:14:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A6FA194704D;
	Mon,  4 Jul 2022 13:14:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B0851947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:14:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21BD1492CA3; Mon,  4 Jul 2022 13:14:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CCE5492C3B
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:14:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7CD52999B54
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:14:49 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-cTF9LyRbNMKhXbSATRulOg-1; Mon, 04 Jul 2022 09:14:48 -0400
X-MC-Unique: cTF9LyRbNMKhXbSATRulOg-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="316885696"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:13:43 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:13:42 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:13:41 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 03/17] block: use bdev_is_zoned instead of open coding it
Thread-Index: AQHYj6Pwri2MXPrOL0awgQAqxq+ytg==
Date: Mon, 4 Jul 2022 13:13:41 +0000
Message-ID: <PH0PR04MB74165ED2BAAFABA4F936C6B29BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 724d90d3-e431-4d32-dae4-08da5dbf0451
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SeztDjb/TzuKKhAoh6aAMrzKv89wP2DDJwwOufCa301bultXd0/2h0jywTwYV2MYjTpQH9s6bGa5yxd1qkn/Z7NFWnXnrPEbcHkhO2DOVSuhevF+uFUHS5CLnLdObuxSGb8OFUGF9e6Iwxcf4s2fK4vTKWtHc9ekzO6Q+VkPCNxxKvUp9NwAIWjcTAe1t3YCp23tPp1U4Y1ANrDYmfV18YvARTnjyyvCbWMgJSrF7hrkiY3tuK31KDTZyR2cb6HCPjWlA7AjkZVGFlVFPaV2+yM/aTgQ6A/eVnf+K04r4Yc0YbNTHVufhyAKzhge4rJxDNhstRbxScG6DX2oKku/p2K76DONgLw8hBZGOOFiLAMjiWd4UwjBt/BET8fjs8ggxsonsY/zl2dLbhhwmnI497oyUhEA8NcQKT4XTFlNBJbGqAIGW18YIFnw94MSBC3uoV1PdJ79gEs30yNCv/blxId9VJccMILF6utrRnCghOimIxmvW7i6lBbn3ddiFSaRnysZ2MGuB08X7z25GV1XClaxgiA+ogSFiC2imCFEe7RV7O3pqi9+XzQ5znjUx9FKHG0SRO1XJqZCvCueONuD96AOmHAxewM0S5+uQyNxRGj8SlnB0swwowGAQPg/4oqlN4EUhwQWpHHOTbm7byKkHyubDmNuuv8Ob1gEhI6K5ts8ocYQVIc8+Ilkc0ad/vqk4DNQyF0LuD6pG7WTdpHGZqR92SYFeNpwQjVNiXfQRho7a1R/PrkEx/yaSVyP0iZgH/U9u9Fgw93VndN4+mofDNc8nklQzVd48m5rY9Oq4CllxM79jpt+TzkZwxteKMA+
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(2906002)(5660300002)(8936002)(82960400001)(55016003)(52536014)(19618925003)(122000001)(186003)(33656002)(4270600006)(558084003)(76116006)(71200400001)(478600001)(91956017)(86362001)(8676002)(66476007)(64756008)(66556008)(54906003)(316002)(6506007)(66446008)(110136005)(38100700002)(7696005)(4326008)(41300700001)(38070700005)(66946007)(9686003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NBriUyajM2TPl6b2DsBzvKAlbupxpOlOSGOTCKubbPqCqYau7XnHCLhUCXLk?=
 =?us-ascii?Q?aY+LYz1Mrgtm87ExPSB9W2mGcO3/b3yDwtn9U43nFZ8PAjjB7McDjg9O/2NA?=
 =?us-ascii?Q?6Ovenkqc6vjbKnAAjz7Yw5JA3+1Br1iaZz5HZrHDEa61vmYBF1IYGFCNlaCE?=
 =?us-ascii?Q?GJko+GeSY0UWDIlGNZXCklgLqolrKiezVTy+KMtPKnNEwoWvGVC4rLC/sFWf?=
 =?us-ascii?Q?q3EQ4CkYIq9WUExOpQKt7W4F2s0Gu6Og3qgQv8PG06zONNIcbVbnVMr5fXOk?=
 =?us-ascii?Q?kMYMjpFMArOIrgk+opwx6aUxWsTgcUO+ltzNhk7LdBAr4S/Ah27kprolEF5A?=
 =?us-ascii?Q?eorYvOpQToIKfRulfAyl5qcFRp0v5H9qcsrXsK3yTrkuze4P+PgNNcPoG7zY?=
 =?us-ascii?Q?7E/p3tPIhXwrFW7wwICM+pN8JD/um1NkQVnYNUKIt+BUgp4mVe+Rke/S0qit?=
 =?us-ascii?Q?JLu2EAYyEUsxE7l+mzRKQP7xP6doTNVmgAoANWcMiU+aDgxt+CrWsNh2Aj4d?=
 =?us-ascii?Q?e8164CZa8ZJsIOL5rCtmoEVOLhXeD+/uJjl3pa6YWm9BstDBpexrNsyPFoYt?=
 =?us-ascii?Q?JMCB4gdD1jgs4TEbsl9HmIRMio01y77zrcpYxHHSYcxxEW3zNxDhfMUogq0r?=
 =?us-ascii?Q?qptBNqPhHZjdaf/0y6jteLcgiZ/wxh3T/wOc6Fa2WIOeypzixCbN7WBDZHab?=
 =?us-ascii?Q?IhEbUrMwAvDKUOc54YpQwugV9jBQiz0tF8sh+iy886nMcWnC7FKmVpSTlTwd?=
 =?us-ascii?Q?9YplPTvfXI4WnL/RRtpYsPdoDAGN+eWw+1RmdPltc+a2ZK3948RMN2vpvaDl?=
 =?us-ascii?Q?ZKsrmHCdSpNMBDUGsTMIdbjCd4w1mUbdTGseI1EFYAdiZ9vN8rk2WY+5B4YB?=
 =?us-ascii?Q?ax19vXCClpXU7HmmWoKNvfuFRHy/wG34+1wOheE+kKsAHKEMsf9tNQAgTrtC?=
 =?us-ascii?Q?KpPgPU3Z/a9QR+1tN6tc+3faElhzdLDcjpOvVtwX031skNM4Bm0E+KIochm3?=
 =?us-ascii?Q?pXI0Jn66WpuZdOOuwCFJydlQT8heBkbw4u3xYGNWb3fjSJpnCHzOGFmn7DHW?=
 =?us-ascii?Q?zXSE2UY2etmM6gJUnaevaOn08uk9LSrFpMzo9LYg2RDkYFyEXVSE6sETf7Kh?=
 =?us-ascii?Q?+21bU22TAaghvel2GK5HK4WQbQUY2O+zuDHz5n29WRL2vugCHexAUrLL0mid?=
 =?us-ascii?Q?UpZVl5T1RTg7CkWKFFVHINjmrGZqhQldlQaVo6DsuJIUfsEPnLckWjCQchkv?=
 =?us-ascii?Q?Dc8VOC+EXzrBiSsjPGq3comYctNuCxR14vda0qpTe0scy5PKNuuAAuo2XcSx?=
 =?us-ascii?Q?zXJHTQfHjW2lyUiv7YAfPzGJc/b8A8DDg8gyLWxgatDBTzjcIeWeCQe90hku?=
 =?us-ascii?Q?qNBRXw4fFopN1/+w9G8Gl7Nm+PIFRywTtp/hrLpFcnr2DZHMznWYFPuJA3uq?=
 =?us-ascii?Q?0lkLwnYe8UYXDxgfQr3Gy7P/h5BZErJ/vRQBwi87gKO+xs3GeKFF21vI701H?=
 =?us-ascii?Q?Lozzc4+2UJGyaMlpJXIIkYHSFNvdRICsoYVZmyVzxonPGDaWjBAYEMMv+yXn?=
 =?us-ascii?Q?wR7/chkA1XtJFJ5jF794XKkuvS10WT6TwyvI0rqV2ujRTf2Dv43OGGo7jAgY?=
 =?us-ascii?Q?LE1mn/hgmYQKxvFCKOITisK7u1ALUbEYQnY+QHF/V8fq6Um7Px2ADfvRBm3z?=
 =?us-ascii?Q?8LBIxVUcAaZU6r6cJrXjHChs2aY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724d90d3-e431-4d32-dae4-08da5dbf0451
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:13:41.8331 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GuVvACM+lzs+Iiwf062d7tNxAU03YKt8Db9eUsvrIAcwN/SzkTAbYSSnI78sDRQstjqXg+7E2UbnNg7KyLYbaKWxUBhkKlGGkmqgmvRtDYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 03/17] block: use bdev_is_zoned instead of
 open coding it
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
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

