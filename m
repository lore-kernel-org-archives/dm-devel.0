Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BD0C3527A
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 16:36:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-QglPtKP8NVKs-HKz1rzilg-1; Mon, 14 Feb 2022 11:35:57 -0500
X-MC-Unique: QglPtKP8NVKs-HKz1rzilg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 986E218A0F1C;
	Mon, 14 Feb 2022 16:35:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04D397ACE5;
	Mon, 14 Feb 2022 16:35:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9EA554A7C8;
	Mon, 14 Feb 2022 16:35:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21EGZmlO027989 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 11:35:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 839535361C0; Mon, 14 Feb 2022 16:35:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EB135361C1
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 16:35:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63D1528EC104
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 16:35:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-563-TcGKWzqtO6Wq2-hGwcreIw-1; Mon, 14 Feb 2022 11:35:46 -0500
X-MC-Unique: TcGKWzqtO6Wq2-hGwcreIw-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2056.outbound.protection.outlook.com [104.47.10.56]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-19-Apr1zlyVO_SIRHcuAMjyyw-1; Mon, 14 Feb 2022 17:35:44 +0100
X-MC-Unique: Apr1zlyVO_SIRHcuAMjyyw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by VI1PR04MB6206.eurprd04.prod.outlook.com (2603:10a6:803:fa::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18;
	Mon, 14 Feb 2022 16:35:41 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Mon, 14 Feb 2022 16:35:41 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipathd: disallow changing to/from fpin marginal
	paths on reconfig
Thread-Index: AQHYIb9l3UccMF95MUaIz3EbpTh9D6yTPk8A
Date: Mon, 14 Feb 2022 16:35:41 +0000
Message-ID: <6338bec1a2be41aae59dcf57da09f2d3d070a0a8.camel@suse.com>
References: <1644855876-394-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1644855876-394-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d97f23f2-1676-4802-c8cf-08d9efd80a37
x-ms-traffictypediagnostic: VI1PR04MB6206:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6206C4142CA084D881DE0190FC339@VI1PR04MB6206.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: mBlFa/1BbI9FuR6io1QDYlP+XPAkY/21/W68sUGT6hjsmKU1MTRxqVV1cTRZ94EtPwds+WJ4M2PaBiQFRaOHNKXIjDpGfLQVp28x/EqzFRdMiJKUYCsgw79deW4/r/b/ebwcXq7/IZYY8WwM7SAWmeyhwvk4lrUldxYQV/mhgf/SRzG4Ksc0TGABldNzLiIcE9IYSD/NuCYgfYzIIM6h8c9akAS2LgLJZ73BPvCNGjptrxTr/fb0tnvBD0kya9WOEKN0WxVd2w+2QdKKdG9amTgiQz0FFMvssGWK5cIeMtT83g+TD1ftCP1bKwdhH7KeLjjmJ1rT20Z5s4RegCaSDFfqUeZ7nzxTrk4a/JE05/EOTASSsv1EW0FdwPIn+q+agphKQbsagai6VrIvBGRZgX3cKGudCfh3RjYBfxlVrOLyARvsS/a29Nh1w0M9pwupNtVQ8hiPeSIHKMN76S7lBAhGMxAA5rKrZXA73WDesoqxYR4/xFbwOckZmNi/pK0SCxHXdnWUvPtRdG7UfAPZfWk9z/45W8fbTr9PwlcHjKt8kgkkGaCUMNdU67FJEe4n6LSk8Gjar6spIfuJLSBrTK+dQa9wFd46lbag5B0DSwDzjkMqEkq2p2/PzgB5i+Lb+IVGPQOIiE9DaOMC+EYLQ+YJ/t0eeawHA223MbLZtJL80Ualh8Iyn9Wt6AKh16/lx5LbNWkUl4knJwMjwj1S+w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(66946007)(66446008)(38070700005)(26005)(64756008)(186003)(66476007)(66556008)(4326008)(8676002)(2906002)(86362001)(2616005)(36756003)(76116006)(71200400001)(6506007)(91956017)(8936002)(6486002)(38100700002)(122000001)(508600001)(5660300002)(6512007)(44832011)(4744005)(54906003)(110136005)(316002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?/5tB8ndK9Q4j4pSgnLAsXp5Pu8RIGqKE5nZOv73keq3DJff7Yf0/mF6Dl?=
	=?iso-8859-15?Q?lzW46tC65dyonYFmOrlRC9zxHRbxUSJy33mSvFwL6/L//yZbrz+8ZucF4?=
	=?iso-8859-15?Q?3JouXJ73dMZVL+vJjEt1MSHUuWEr2hqfh+FOKDqSwGO8rgr1tYdAqqEel?=
	=?iso-8859-15?Q?LJ7gzpBsrIbdQ08nrdMGTD3dQeYkmjFAXT6Jyab4PwB/4kQJ040Y9k36T?=
	=?iso-8859-15?Q?3Wf9ZlviqExX2m0KHXX8J/Wz6TA1dx1EyX00wt18urL9zcpUL6KHnyhxg?=
	=?iso-8859-15?Q?Qv7O6ScN2PCbuybm5qjw57Yht+LRMUfaGxILG3j7SPOqlnr7vOdyoLi6K?=
	=?iso-8859-15?Q?LeXmMH0V1/b8nQ46xgh70Zyc2YN8+Ndt3lH/kQhsNBRbPn7TdxtxzTU5B?=
	=?iso-8859-15?Q?8kQj8U0fRGCeL5BUVxYCMqQ0+TwGCbU1CD4yNEpY73POlRi6fRo2Kvwil?=
	=?iso-8859-15?Q?+/e2pSCJF1Ll4cwLk9FDvTz3I4aqzDbIVzYTJcYTFWWsc02kfqOB9GtZ6?=
	=?iso-8859-15?Q?ydvnVRSpfn+sU8Jp16O3NkXIv/jaaj8GYQ4H5dTvnRz64jmnRzoPjOcne?=
	=?iso-8859-15?Q?C6xOTvX27PvNvFhuuC4Jfs0OjFOpm4yrmGchLfuMut1itSlWeADhfd+e4?=
	=?iso-8859-15?Q?aQNGtN0JISwxcYP3AuR6R/dNqkLKmzsNh5+ZHnRHpTC64SDeXLeqkW1SW?=
	=?iso-8859-15?Q?MX8kTRQI9jbKqE6hE2oO5a/vZ7MEJKaEaf9ptXHVv9OgOQ1CVqRk8tVRD?=
	=?iso-8859-15?Q?MriV6XfA1cGaqu893lJBfxcIHpY0CrwmiASjhxppCOWfWTS+cw/ert9SI?=
	=?iso-8859-15?Q?L8o93oz5JuOg4fcRmL6QMyXKkOm1ReTiXboX7BfTRKp4uFhrurymFmGqt?=
	=?iso-8859-15?Q?9uFhcNN0QewRdfqNXTUnFEXDhO7TBi79upqZNnmgeNL1+N+KZEi5pKMEv?=
	=?iso-8859-15?Q?t7FoixJtyZpKXqCt9Eyze0KvWIlmSu7UfjPxhWSQAldFa5bzo2PGICOKy?=
	=?iso-8859-15?Q?OwJJ5rAxxdPN/6sElLq64uYTZWKHPubelv2P30O8jnMw3SyLyXKUm81nY?=
	=?iso-8859-15?Q?V9owD0VpJ64kVSfzLIwN7hpZBiQXctb8Ry5Yq//ox9f+U/D9joDyApCA0?=
	=?iso-8859-15?Q?pfw+V9oQbKnF8TARK1feML6i0IiKYigx95i8vcyAq58//Wy3ZnH0ozYIH?=
	=?iso-8859-15?Q?D2G92+QdGZP9vRLKGzBNXVga66kIL62OQHhAmT30EuZDlO83KokvxmAA7?=
	=?iso-8859-15?Q?xI7v5YjwCDmlD3wU4yZw1okoHIz9qEfoC6K6jTG12hF4lqFkA/l1A8X/G?=
	=?iso-8859-15?Q?bEhGo+iX1VMDjMXZ+DiKbL9Heovq7FRmq0bRhGwj0c+t02BGvF0AMeXaq?=
	=?iso-8859-15?Q?kIIMeXj5wm9mnF1fxJ3OT7iDxipVxU/nU1tmrjWWIPNaPZViUBnr0ZdXZ?=
	=?iso-8859-15?Q?azth+OGkqNNi2TGjZodKXthEA/U8I/5Tmo6yvsPanTFs0ub4ZztYLUiRS?=
	=?iso-8859-15?Q?fkf9+GoSglxjIQhtfg8SkwW/CU6n7WbO8NekFUKisAaoS5vxmeREBtZ10?=
	=?iso-8859-15?Q?LNXGRWu6QZKL2JNCS/LhNEumejkDQ04ameT/jBv/zRu3MYNtdjmQU26y9?=
	=?iso-8859-15?Q?1XJ+GazXDZC9PnIWYdKBeLJ+I382PVUcGxgFOClyu85Bk5JZZ9sC474AT?=
	=?iso-8859-15?Q?Qs/5XLId8zdoMDJDYWwp4jtJxdRVH9s6PudhFGyR9BtGd+A=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d97f23f2-1676-4802-c8cf-08d9efd80a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 16:35:41.2569 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CiAv0+4tHCUe49ewCFA7+mDyJ8sjrLmBIv0R3PzAymxIF/+JJ+KDH1rKIRaEgsbe0zCwEJeeNEOl/6NhQ87ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6206
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21EGZmlO027989
X-loop: dm-devel@redhat.com
Cc: "muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: disallow changing to/from fpin
 marginal paths on reconfig
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <0DB8E663B926E440B9465190248C9E83@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-02-14 at 10:24 -0600, Benjamin Marzinski wrote:
> Setting marginal_pathgroups to fpin causes two new threads to be
> created
> when multipathd starts.=A0 Turning it on after multipathd starts up
> won't
> cause the theads to start, and turing it off won't keep the threads
> from
> working. So disallow changing marginal_pathgroups to/from "fpin" on
> reconfigure.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

