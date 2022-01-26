Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAFAC2BA4C
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 15:39:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-ifMz8MD9MD64A_DVyR-bJQ-1; Wed, 26 Jan 2022 10:39:35 -0500
X-MC-Unique: ifMz8MD9MD64A_DVyR-bJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 054E0839A57;
	Wed, 26 Jan 2022 15:39:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 605B82C1AE;
	Wed, 26 Jan 2022 15:39:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC4A0180B654;
	Wed, 26 Jan 2022 15:39:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QFdMY8019522 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 10:39:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F4BE1457F05; Wed, 26 Jan 2022 15:39:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 999E71457F04
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 15:39:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8012A8011A5
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 15:39:22 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-454-1JbbBb0VM6qXyWMSgY1fgw-1; Wed, 26 Jan 2022 10:39:20 -0500
X-MC-Unique: 1JbbBb0VM6qXyWMSgY1fgw-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-24-R3QJW4vwP-Wda1XVQMDahQ-1; Wed, 26 Jan 2022 16:39:18 +0100
X-MC-Unique: R3QJW4vwP-Wda1XVQMDahQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by VI1PR04MB5744.eurprd04.prod.outlook.com (2603:10a6:803:e4::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15;
	Wed, 26 Jan 2022 15:39:16 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4909.017;
	Wed, 26 Jan 2022 15:39:15 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: use asprintf() to allocate prefixed_uuid
Thread-Index: AQHYEnaUzlaN917bKk28ov5rb+SJhg==
Date: Wed, 26 Jan 2022 15:39:15 +0000
Message-ID: <cba3a2973b64bc55137887424ab6cb132fdde9e0.camel@suse.com>
References: <1643175325-31046-1-git-send-email-bmarzins@redhat.com>
	<e42ba93e5423fd686470c2ca47555792b6ccf7c4.camel@suse.com>
In-Reply-To: <e42ba93e5423fd686470c2ca47555792b6ccf7c4.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 630b2a64-a700-415b-557b-08d9e0e2027a
x-ms-traffictypediagnostic: VI1PR04MB5744:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5744077984C28F4D21F68DD4FC209@VI1PR04MB5744.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Lwq3ZrKSTspLbqsyPdEoJ6C4bDN7yMbj/5ckNTyh267yZXEXpqJo74MKH8qqfpjnZ1hmSEcrk2T1tRFH6NYlElat7cr+rj3r7zsk9uYnklTHgk/zCEsZjJlalEUuu5xwAZMTiOrXzso/Mf8ep3XEF11qwjxrbQ6CYZjm+G7Opt/MPJ0HfZMtuvb/l2S9LxSssjf5ZwurDKALZf/+CWbyp7paeWjP6EbXP8vMSnB2rE3mM0be/TRbj2RDNwVDv5nKO0g0b1ID98gBGItPyHtieYsTM8fhLxpphZ3WVxfs3fC4r2H2QCS2iRO7oYSFFii0HbVFN5pDTQjmXV77VEnjDES+TvvdSzpnqRbrjRlawxFeZy8On/1lJNZvfDqYwMWiIazdU6Wf2N1ZmtkUZP8vmfsTBR6U8uOh6chMYw3Rmk8gVLoNlQZ9DgOMEkK6twuCDcwLcUW9ei/3ytSoWzYyq+WDWTdi1hSwjX769qfNi9DcW2xw9AHkH8zXbF+IJ785Ad33eIZmbZUcmmBLha3ZiEhCl5HsIcdPX427Aqml1nodqtN0VKeWek8SWL6YLObDf0jOgXpxnf+RCkbAhzxpznYT6/x+ol7gic3SW3p19HA8oo63Kz/ZSpufTyGAg/Fkw1c/fmLFrEO3mN8ncbKnuvfjICinhjUa69bovX1GvhhgMXiJqA7hwxHNoe/PAXN/TUmVzWjRS9BhU1bNj1zY1QwhfPAs2UVM8hSNxWwwhgqBNETq0FTN4QXQEan1qgh+Hs4TD9qyfPV0qonkjrXqxILNvNsUf+Gyr79APr7AskU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(2616005)(186003)(38100700002)(2906002)(66556008)(66476007)(64756008)(66946007)(5660300002)(76116006)(4744005)(91956017)(8676002)(4326008)(36756003)(66446008)(26005)(8936002)(44832011)(86362001)(6512007)(38070700005)(6506007)(110136005)(508600001)(71200400001)(316002)(966005)(6486002)(122000001)(20210929001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?avNeiVCd3ZokJDnNWAcLi2h//QnutHoHCd4V+bA8k3Nn0zsTedJ/jbwhb?=
	=?iso-8859-15?Q?Za+6GcxhXizQcHPxxod2DtXmBZJ4068zIDSvu+0spUFh/YK2C4S46ne+R?=
	=?iso-8859-15?Q?X9TainB6wa9GbdG0LsvrHIKmHVmiDrf4l8MXvmKi/BidvXE/bKQpkVPwx?=
	=?iso-8859-15?Q?0s0DXmhVvFRSBFQj73gYqHpvZwocMBYub+HfSb27EZJA8TBxu5tWfEzDU?=
	=?iso-8859-15?Q?Z1h55dQOyNBPdis9kBZ0NOSrRsa0scYFn9wySxNaQgEmc5XEdZKQGtpFv?=
	=?iso-8859-15?Q?aQKnK7ATr1xIFEV2MPscAJuqsSgMysVDTSh7zYqnKIQWFGPhQylkdL+zg?=
	=?iso-8859-15?Q?96feOPg3/dLfH+PmuGRusDajaO5wOWEIZ3+wJaQhvBWIQCa2N80t32zyG?=
	=?iso-8859-15?Q?pdJWIu7Msz5keGGFLjPFMZ224M/BJGpWZVPfQVKQApkscvA6hlnNWFw5e?=
	=?iso-8859-15?Q?S6o4VMlQ/SXlGY0aCagRdfekLUREbR2eG4VPIzj+0LfYRYLmq9nU9yuah?=
	=?iso-8859-15?Q?TJv0t0e4QrUCDMWYIBHukkm8kSb/HZo/PjFta7TGlCXQcTatYIMo1bjp/?=
	=?iso-8859-15?Q?bhY2htQRp2sqK8kojZ2FVRV/J0Cy7HmFYVTFSkiaewu9IjRJTaot/DOW9?=
	=?iso-8859-15?Q?WxhITsrAaxe2AIDQEtjzfSdiht8pxHAmhQ49Nnx6tsuzKjRQwunYbNDLr?=
	=?iso-8859-15?Q?BNfhr43FLDeD8C89xk78nxmdGtZuWioWw7PrDqacqhaIsg7D7vZsHJyR+?=
	=?iso-8859-15?Q?RaJiTGtROYqmZ9Yt0J2PG6G7iGUDgvVUbmXm6jP/T0uIWHLymsETxDmIU?=
	=?iso-8859-15?Q?x7NNgsclea16OTAN3zp9B4HwtYfBjAPoL8WMdWSGWFA2KINxVENsZsO0o?=
	=?iso-8859-15?Q?uvRKTL/jaQJPH5NO0WBuloH/DjzeSiouZB2Bz2Bnc2aMmIHI2fVZplGJw?=
	=?iso-8859-15?Q?iu5NOvtVXqg6rdWgb3VwltAZQtg8/QmgwyV2CQ/CrvlC12IFXk82e5BGt?=
	=?iso-8859-15?Q?SSgxncRyIc7h2DsR3khWErNj4SqVspmUZJXv1lCUGwSpMaWTVOjLVjWb1?=
	=?iso-8859-15?Q?SABNJymnTiBk3FXEtTdfURQ+dtgqze1YnpQMcTklz4VBK/WW7SQE2mT7W?=
	=?iso-8859-15?Q?o+Z9JB9ygOV0YkBvX3GsKrLUc/tWHdK8udOtQFp8CmfO4UQMbTWtuJn3U?=
	=?iso-8859-15?Q?Ahpy6aAK/6m/XToE+ToBA04hl1wrhIeNsIp7odCrJ/0ZnhpZHs1Lct4gs?=
	=?iso-8859-15?Q?OnUqVlTlcU8ReJRvnnmyZduSrGM3At/BF9y202I0YiANvM2LSUHD4KUJl?=
	=?iso-8859-15?Q?9Wd15TQu67QmIyq4UgNV20eQVkv6Bxjh5OkQPDVZyT0GtH7EAGMc3YVhO?=
	=?iso-8859-15?Q?YAYlTaDYHiyVRdV2gY93IlzcbqHZTT/+UqqHNcDmBjY7yj0AwPsK7fplX?=
	=?iso-8859-15?Q?jTpE1tSrssfMltdhMXCfywv8zkVrTXqJtTXdDGu6LMOd01MWvZgGU5hO/?=
	=?iso-8859-15?Q?XJV52uAfFcim2b7DWDVh/JnxdUSPvtgAyQrNL12qCFvfau0Vf2IMGA/W2?=
	=?iso-8859-15?Q?dw3xtPvnOWAmM2Mtttrz9nJyS2dwUUP3wlgd6DCrdpGRGDiSCuELHnj2W?=
	=?iso-8859-15?Q?06+qtXq+xqYFtgvwu14wxWG+TafMF4yidpagIBxVv9IKfbveU7BvGBQvQ?=
	=?iso-8859-15?Q?QLOP3k6AekeWmXVJfS9PDWRp4ATDd7IyD808JgT4mXc/BZM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 630b2a64-a700-415b-557b-08d9e0e2027a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 15:39:15.6789 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w7xVJk3RzRWVApbudMe1mIElN+a2lHBAxZlsATv0PTS2QyuITyc4BilaOgb+xTLB9Lly2Ab7HIzUb4CmMdsnPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5744
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20QFdMY8019522
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: use asprintf() to allocate
	prefixed_uuid
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <966D3756A535CE468434F0F2F3FEE4B1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-01-26 at 08:46 +0100, Martin Wilck wrote:
> On Tue, 2022-01-25 at 23:35 -0600, Benjamin Marzinski wrote:
> > gcc 12.0.1 failed building libmultipath due to a format-overflow
> > false
> > positive on 32-bit architectures.=A0 This isn't so surprising as
> > format-overflow=3D2 is very aggressive in the assumptions it makes
> > about
> > the arguments.=A0 Here, it assumes that mpp->wwid could take up all
> > the
> > space that a pointer could point to, even if I add code to this
> > function
> > to explicitly null terminate mpp->wwid to fit in WWID_SIZE.
>=20
> This sounds like a bug in gcc which should be reported.

... and that bug exists already:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D104119

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

