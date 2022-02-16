Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF9DC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 08:35:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-qQWlO0IdOg2VDnbvb8QUCQ-1; Wed, 16 Feb 2022 03:35:02 -0500
X-MC-Unique: qQWlO0IdOg2VDnbvb8QUCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C01614755;
	Wed, 16 Feb 2022 08:34:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 990CC4F85E;
	Wed, 16 Feb 2022 08:34:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A53E4BB7C;
	Wed, 16 Feb 2022 08:34:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21G8YpdI030039 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 03:34:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 542C91121334; Wed, 16 Feb 2022 08:34:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CC54112132C
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 08:34:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B1C0899EDA
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 08:34:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-319-6uX2aZzBPFGpi0YHUM-vOw-1; Wed, 16 Feb 2022 03:34:46 -0500
X-MC-Unique: 6uX2aZzBPFGpi0YHUM-vOw-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-36--SSLyN_5Nqanf6b3aZWfAw-1; Wed, 16 Feb 2022 09:34:44 +0100
X-MC-Unique: -SSLyN_5Nqanf6b3aZWfAw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM5PR04MB3076.eurprd04.prod.outlook.com (2603:10a6:206:5::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16;
	Wed, 16 Feb 2022 08:34:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Wed, 16 Feb 2022 08:34:41 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: fix printing native nvme multipath
	topology.
Thread-Index: AQHYIvw6MZwJGoeoFUeZAzxgHrQv66yV2hyA
Date: Wed, 16 Feb 2022 08:34:41 +0000
Message-ID: <6e8e8941d6c63139004b42f79836f3ccb6b72de7.camel@suse.com>
References: <1644991949-7748-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1644991949-7748-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cd659c3-83dd-4bd7-ab3d-08d9f1272d89
x-ms-traffictypediagnostic: AM5PR04MB3076:EE_
x-microsoft-antispam-prvs: <AM5PR04MB307672442D4584D57B841877FC359@AM5PR04MB3076.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:187
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GFAu1QMYA1HK2tEVFr9sEGAYyoxplItF6ATvRjrYVdIV6tiQYrjymTLPk8FoslhCCsrVk9RCJ1i3TDl1+JyAsCUkBjyFLpPuaW6GbbMiIkI6Jvzn2rCUAEey/QQ6nk4ql8+NyB7XLompIDCRise+kZJEaf//uWhfo1FUYuA8tKrquQvDQBTWRybucQ5IycsUoBrMy6tpU3B6eGvCzi2h+mYC94El5VNTNFRFYadAc5yuO1jL2AmBYY2CF7gPFMJGzM2byUyfFHxX4UHsfrQdew7sj0UYNAQI26hfrcufsxNpxo/zdBeBqbC3bd5KmcWZ9tKzzocaExmJ3/7tw1k1Bx8cHHT/lsbGkCA8CVBx1ch+U0toYa7PlqQj83TjO+0RFjzsg6fhr9C51GXCGyWWZZM8O5I7YazMqq4df1Q1Z6RAf4Kt8EvXf6cHLtuTy0jqc2VH27d8n2t2JjouufYPERBhQWTDzDxVVYpA/jQGUWFITsLlUaNaqAY0i1adFpzVUfcqtxC4ifDoEL9zJvKyPhiXOhjlzJWRYNd4J7kANjBjbENzW3vfufY1D0daLTC1rWsXI8x7ilyzUkbUrXQRMnFYJ3+cWjH1B4dWPJcOcQTiXVd1V3Zr1//G7xdzYlixVDvvo53MFfKkcDeC7R2W9B95+iYWx34kL8jdrf1m1SG13qTQqd2nX45V4dIv6/3k6s8uW737h8aJNHr7W9NIhg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(5660300002)(110136005)(44832011)(122000001)(38100700002)(316002)(36756003)(6506007)(6512007)(6486002)(2906002)(508600001)(2616005)(4744005)(8936002)(26005)(186003)(71200400001)(86362001)(38070700005)(91956017)(66476007)(66556008)(64756008)(66946007)(66446008)(8676002)(76116006)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?4Ii3RwHQZ+CTwQrWkjxjkjplddbzAg/UAe+yHTcyQCAFfJS7TKDrBXhX7?=
	=?iso-8859-15?Q?JBgK7MC70jGpXw3T5QRg2CgE1JYhQd7NP7pCAwSk7JBaqYjQXPq+vR7Hs?=
	=?iso-8859-15?Q?YAPFMJB00ZoRm+6X4OcfJoUCALQ59lCk5BadHz2qJA5QZr1pyuAn+xtad?=
	=?iso-8859-15?Q?+TSWyHIIinyRx3SXV/BNQ0IDa2HAGfpjL4YF5ogJZCRlLiJZkFSJr1H9f?=
	=?iso-8859-15?Q?lcVOl3efJkcNnN6uPmVm26l9lonZTE2Zj94lE7OHozeBWDSn3TO44kl7Y?=
	=?iso-8859-15?Q?++vlC9t16TGvQ6rEkAqHd+ke102zLlbr6Su9MDuUxkt9TxqcqA7ZP0c/G?=
	=?iso-8859-15?Q?OWb9x8EPD3NAZ1XOI27fI2hkFtn3Vf39sVwtZwfLkcDOaG47yYCBCd3nJ?=
	=?iso-8859-15?Q?vPjw6Df9d7NK46FhZ3EbaEVgMu9iaXOr1e2yFwx2qSVWV/vzgQYbWehJH?=
	=?iso-8859-15?Q?GiUe4DtPYara+HUZNM53EDzxf/s14ik1qj/gIAzu+u9uNCl3DN3xk+L9O?=
	=?iso-8859-15?Q?RkbpyP7whqX8VPdR0NmzMw1RaDZK+zjtMYVy0qENAuCo/CNSuyXoj+A8+?=
	=?iso-8859-15?Q?5k8uwWgUiPR2kJYt6F/REd4z7Hdjkc3rX/lmaunqnB8npmwQL3ZmbKpC1?=
	=?iso-8859-15?Q?TJUkEO4pBZjh5QuOkH2RbdfGZawdsKZM4yI/V/ggC/zoXHFuY1n92H2Qm?=
	=?iso-8859-15?Q?STzi0LNBCgbH/mJ5pEQ6ERravpktL49PtwoSOL8M9O46b+88O0WHosJbr?=
	=?iso-8859-15?Q?X/aU/Il/9AXxB/N+d/OjTyT2ONPBjUZk78wgsmcMwTauUj4NGEB3GFydD?=
	=?iso-8859-15?Q?yd2XYiuQ45pFzS2OB3yIbTqTdl0viMamGDjO+CQW270TRL+shy6YXxOdV?=
	=?iso-8859-15?Q?tMNWqRNws84ece2UxLRL6/21gcAhj+iEl6YZ5VO7sIa5rQBOwR214+giD?=
	=?iso-8859-15?Q?bfikVbMgga92tzichU44wV/5c5r/kP27t1VqwWctwOU/nk6dgCjtqBEag?=
	=?iso-8859-15?Q?AWGVQ8EiiXygR7ODG5JI8OFhomlGUS9HFyblS20kQ274KOVankXBEydH7?=
	=?iso-8859-15?Q?8mCDV8xYoQYPrLX56J52CZllE1ysBGXyU1n6I0vl491JT8Q+jmCV6cSma?=
	=?iso-8859-15?Q?BsPCKiBEIDmL8HNHc9WyNtFxtUSpPXoi8Tp0c+6sgKtvCYK87EuPIHz4q?=
	=?iso-8859-15?Q?iURdKZdFLfDX6oBKwcsLYtfIRfHFGSgxYic/KD/0sFA6rjK4C4bV/FTlP?=
	=?iso-8859-15?Q?RhRtIglFbqpAeuVdaxWb3KtLSS0ez4z7uXUteiEonwNJV0AOLvzLEgXg8?=
	=?iso-8859-15?Q?wjKKFRFNo606mnzYzxMrFDU6kXvi/jtxv3ujvoGPQD9Hab6eNOaOXgXSV?=
	=?iso-8859-15?Q?UtSbuHhGM/2yjjqHIdk7PLRpdXDWIoE/2wJ2ZTMAGmhnms5gKU4LpqlZj?=
	=?iso-8859-15?Q?fpJJc5Ob+PVCbYzsmRfkhCjKhoit6mmomiA+ZAUzh4c0aYvI9SagiII60?=
	=?iso-8859-15?Q?UJV8rznrP1XCAOCLSHGJTSLSraVJN2R/sNB3XPZj/wFEUYz31YE0tOaPU?=
	=?iso-8859-15?Q?QHwGF3zCVOlWWxcv6vpdVIEOK6eNYbTh5TTZT0PZyckJHbaqx6ujXMW7j?=
	=?iso-8859-15?Q?YLVRR+VoP1XXnnWh6Oh/QVdDvRZYFMV6/UYQS90p4CRv+AOt9aR9xXT2m?=
	=?iso-8859-15?Q?TWud7rapZQ9YVotlhXmmKLH3XNzurs36V3JR4IcF34iurXs=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd659c3-83dd-4bd7-ab3d-08d9f1272d89
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 08:34:41.8557 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ON2559ukl8lRg7Rz0fISqtHmKy6G1H2iZgAapWgd2u4YxPuJN4BR5Rg0QasiF0ADClhrZtw5yAJHPHrBIVxSdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3076
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21G8YpdI030039
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: fix printing native nvme
 multipath topology.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <7DBE130CB3784D49813A73B2A11F99C4@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-02-16 at 00:12 -0600, Benjamin Marzinski wrote:
> Since commit 2f05df4 ("libmultipath: use strbuf in print.c"), when
> multipath prints the topology of native nvme devices, instead of
> printing the multipath device information, it prints "w [G]:d s".
> This
> is because nvme_style() switched from calling snprintf(), which
> supports
> format specifiers, to append_strbuf_str(), which doesn't, while still
> keeping the same string, "%%w [%%G]:%%d %%s". Remove the extra
> percent
> signs, since they don't need to be escaped in append_strbuf_str().
> 
> Fixes: 2f05df4 ("libmultipath: use strbuf in print.c")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Oops, thanks a lot for catching this!

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

