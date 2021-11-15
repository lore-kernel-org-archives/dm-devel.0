Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F17C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:27:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9003861BE1
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9003861BE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-2tkoRkpENWaNdSwKURizxQ-1; Mon, 15 Nov 2021 11:27:53 -0500
X-MC-Unique: 2tkoRkpENWaNdSwKURizxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 578A1106BC84;
	Mon, 15 Nov 2021 16:27:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34DEB10190A7;
	Mon, 15 Nov 2021 16:27:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B486F1819AC1;
	Mon, 15 Nov 2021 16:27:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFGRjVN029185 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 11:27:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A3558404727D; Mon, 15 Nov 2021 16:27:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EB084047272
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:27:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84A44802802
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:27:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-335-pxs9JRScMSWcN0FyWUjr1Q-1;
	Mon, 15 Nov 2021 11:27:43 -0500
X-MC-Unique: pxs9JRScMSWcN0FyWUjr1Q-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-7-7A92pcnSNbKjioKWyiSVTw-1; Mon, 15 Nov 2021 17:27:41 +0100
X-MC-Unique: 7A92pcnSNbKjioKWyiSVTw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2517.eurprd04.prod.outlook.com (2603:10a6:4:34::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16;
	Mon, 15 Nov 2021 16:27:40 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Mon, 15 Nov 2021 16:27:40 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/4] multipathd: move delayed_reconfig out of struct
	config
Thread-Index: AQHXrnY/3GOXmKaFekKzP/E2pyMR7awFGZaAgAAE6AA=
Date: Mon, 15 Nov 2021 16:27:40 +0000
Message-ID: <b908909b2370f188872b0da5e9d90524af848370.camel@suse.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-2-git-send-email-bmarzins@redhat.com>
	<6ff4fe373d52e282af83aa0ca7c116b71fe9480e.camel@suse.com>
In-Reply-To: <6ff4fe373d52e282af83aa0ca7c116b71fe9480e.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29066828-00e0-4fea-19f9-08d9a854d833
x-ms-traffictypediagnostic: DB6PR0401MB2517:
x-microsoft-antispam-prvs: <DB6PR0401MB25177B72743CBF9066AC7BB7FC989@DB6PR0401MB2517.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QnCs7f27yX8F0w+letxqOaySPCUxb8dg+D9tVMAJ0XaY60tVTBUh1k66gNVTNn4mfAAu4oOevGAq56XwREaXMK0uElu9Iyh02OoxEoYY1WXXoWzRj6jpXwCPotO214kIziGLJd5XMj4fx64Lbz8LISycH1mMVj1EmP6Ff81rE4eqeWhpGGh8n5oIqgTpIm6pRgsKn0fnHZAVFtCSz3Bp75KAw8oBAOuox9jcTrfPA0zUW0E8leeagosVVVjaKcfg6pGvWXEq93h9JywKX4b2mMapcQ8H7FQ/y5aQuUvXQBaAj+R08+L0mXWnixEhjd+EWOMqH0Cu1iaXYL8eUsYugq0DqkHhwFzh4QZqbgwZmPzulf4xmVn0JWTnoVW2/+cscAqj82YGvwrsExOaqOfT05cKGqUUuF8FQgElm/paUXvTXxPiQLBm9GpnK5vG8EaOZN+7sE5SxIFvy2uicL+xQhQLjpCw5mczhPIj9xfbaN/fP55LYNw6FfwGUO9c27J96eZO0P1d60eYbO2mwgE8J4D4ILBWuB8rJ0RA6pUgta0DCeu93gzCjizKT8mUWAbiwWmt6hApx+24GkXKw48ZKga27n/qjnAgcifBWWz81yPXrSpHmSkQok1DVGhzLxN6w5t7heUC1NN2/kQSr13lac3Ks+SOYsYpoZuELTGKutSjpa2C6/3I9YWfzglQx8lIvbbpmEZNY647Vr6BqxyKv8iMys6EDdm1VMRk+nTQnvHfXFvUAsJcJ7Nw8pOzu0oqzZXSdUqqzO+RwQw0rvNomo8G++6VivK3Zseymy4WckY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2616005)(44832011)(36756003)(38070700005)(83380400001)(26005)(186003)(8676002)(66446008)(4744005)(4326008)(76116006)(64756008)(91956017)(6486002)(8936002)(966005)(4001150100001)(66556008)(5660300002)(6512007)(66476007)(86362001)(2906002)(66946007)(110136005)(316002)(38100700002)(122000001)(71200400001)(6506007)(508600001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?XCm6LD+lYnAGgEapcZvxPRIfZ/cQeweKYy5gkm0TUojKYqyGyqZoaxpCS?=
	=?iso-8859-15?Q?7OnlKIll4gXOs8kUTFEzBpyWWXA3i5ei8aR6NjMfTF3mf2Yns25zm9cpS?=
	=?iso-8859-15?Q?kSjexJxczeug/jisV6qaMOzyuTlI0OAbLoT/sh55tGjDCt0Ex5KQsKHSI?=
	=?iso-8859-15?Q?e/1FXGV2auc2JWIYDUh44RFYFneGTrz9e5wNoC64pc0N3qt/ZA8Y1vx5q?=
	=?iso-8859-15?Q?5h2veWYd9y/rcTNvlvpOqq7TMVLPu9UFSU8tBJsahGy7i4c80fH4ieeul?=
	=?iso-8859-15?Q?/hAaBuaySy+DPv8a3aO/wDWA0+yKOQjTSx+0W0xt1AIltCzh/481lUNhB?=
	=?iso-8859-15?Q?PUdQ6HGDOTyGXLc5GKnC+0iKO4r/sRMoaoW6pq9DwPLDjUX4vGGx2qWOi?=
	=?iso-8859-15?Q?SPTiz1E/AKyX15gBcuNCthpIcdIGoHz2efDNNV2gKysz6C5o+Iqai+Av4?=
	=?iso-8859-15?Q?9ajMSiH0EX9PNM0Yb2iu4Sqi7RmRKcg25VsU7xpkmODqNd7O3zh4EdBry?=
	=?iso-8859-15?Q?8iT8rK1oo68y9BRN/PYvRJmswvYkhuhGDxVumIURNWANDhX+XgWmUrZn0?=
	=?iso-8859-15?Q?s2t7v45uMpP4sSHe76GC40NaT+WoK4EdM970BR9QDxo950EP+7xCPnh1X?=
	=?iso-8859-15?Q?/4WV5H4E8rB7vbeJQ7z6Cm82d2CK6KADYz6D+4wBoCBLmo5AHXIaARgsd?=
	=?iso-8859-15?Q?oFSrG+VlYyd3MmvL9oIK929J0uMJvqbRzT2zoRwGvklyoNDUz4NYiML9T?=
	=?iso-8859-15?Q?+y/d9GsqWB9wtB2XcQKcLFuR15Nc+B35K3KnrcOcmy1WRk4jp7TyCRHE9?=
	=?iso-8859-15?Q?+hOEW8csfl8PzlyAbZSbfstUeDs6PRwDKK5/uuyht6/U7G0/n1PVe24Xd?=
	=?iso-8859-15?Q?LJkXDkr5MDeBJm5KVw6g6xQOqamKVDGVp7kBAHcG+4BpyM5TwnCnZrnkh?=
	=?iso-8859-15?Q?gp+ZUS/2pjJEcpasvNy5ncPQLsdWTc8f6+59NpbWHdttQAerJbJ7o/Gnq?=
	=?iso-8859-15?Q?lpZV7YTChHgog2bQO9aXdBFfgtebhVaKZONpuDhRKoByUOSyJmejj4+Kz?=
	=?iso-8859-15?Q?HiRrkS32bLnvuwRskPrRKZkzWxZWkP3h3NylGj3jDXgaAU0+9CX1KkSKl?=
	=?iso-8859-15?Q?vCd8ef+QVOFEOObMzvbsyWiWCq5TZOBQE7xySnXkVoAwvpc9hClsNn1Pv?=
	=?iso-8859-15?Q?1XHP9sLVHYvpxZNdyxC0KKd6+l9kgEWJVX1mH6wbB6/572lohRFRm4Lhd?=
	=?iso-8859-15?Q?+Wu7Vf6Ig8Qdwix5Cc/ZctNVKFkairncVZgXmAy9EFHJRIsOTYepYy6ws?=
	=?iso-8859-15?Q?VaZy+8sXwOy6DTybQEqtswHupzX0WGVt4lVInrHonAI8RE8bNDiAi/9pt?=
	=?iso-8859-15?Q?v+HhiFMavQKaHwy3D9FoIRzYBUF8tsxhM66F5D8QPoO7C3mqQDgJ74Kb0?=
	=?iso-8859-15?Q?afifRxmYtztlwE0/ZH/u//EGdpJj6mDCLSnH908kFN4bRbo/jW0Xd12Ez?=
	=?iso-8859-15?Q?UL+kpm0U605eLzVeiyGWvbMZrEkc34G8Fq9SNWa0HrO4w9ZCHXUZicgaI?=
	=?iso-8859-15?Q?sPq/eaxv7wmqdwLvWkz1Kuu0udIrYo+7oyaMzjokTDvVRC9B/uJq9mpqz?=
	=?iso-8859-15?Q?UpE5aaZLFsPfzN9/6m4SDPYuI2Nn16BDDYiCzC658UJBMK4IKT2F8FODH?=
	=?iso-8859-15?Q?BIaPZxjlLYF8nFefC2GaKY6WE5rImVRwpODZzvIPfj7iy8U=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29066828-00e0-4fea-19f9-08d9a854d833
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 16:27:40.7072 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SFbBoXMyrhlmWg/gCfYOjNnZUiaA9SjiZharn2Q11TSu++rFGUY9oh8j53BSy4yxHdT0T4bOXWLLyEzPGO0hRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2517
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AFGRjVN029185
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] multipathd: move delayed_reconfig out of
 struct config
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1FFF2CF9E5ED85438D84F5F570D54C7B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2021-11-15 at 17:10 +0100, Martin Wilck wrote:
> On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> > delayed_reconfig was inside the config struct, but it wasn't updated
> > during an RCU write section, so there's no synchronization on it.
> > Instead, pull it out of the config structure, and use the config_lock
> > to synchronize it.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 

I forgot: this patch changes the ABI of libmpathpersist and
libmultipath. Not in a bad way, because "struct config" is opaque to
users of libmpathpersist, but for staying consistent, we should adapt
the library versions.

See https://github.com/openSUSE/multipath-tools/actions/runs/1455114454
(open the "abi-test" artifact to check the details).

Regards
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

