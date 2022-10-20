Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99BD0C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666277952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SiLlS6ZUmCB9kZxgzKusdSc8a6QTdm2Itv+VtLtLyc8=;
	b=Q1O4EfmY1URxavKxFt1C6naKxVFLqHr+bcTop1nZ4tnjK0VxwjiSKeOE5RTbo8P8GjKKS3
	VXlwwPI5XhY4J9NghkUlhmlx/lHg6BO9k0/E/DrUJ2bZiSd5532EiRoRTUCKb6TPA/hX86
	hPe9JagVCpXmyINWIQfMqBmAIIjKs8U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-zjuifwCxPh-0EWRxf0xWBg-1; Thu, 20 Oct 2022 10:59:11 -0400
X-MC-Unique: zjuifwCxPh-0EWRxf0xWBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 913343C0F437;
	Thu, 20 Oct 2022 14:59:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BA99C15BA5;
	Thu, 20 Oct 2022 14:59:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A22A19465A0;
	Thu, 20 Oct 2022 14:59:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9FB421946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 14:59:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8DC352024CBB; Thu, 20 Oct 2022 14:59:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 857722024CB7
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:59:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6059F85A59D
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:59:07 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2080.outbound.protection.outlook.com [40.107.21.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-dIrJgVc2OWex8bfWrxG8Bw-1; Thu, 20 Oct 2022 10:59:00 -0400
X-MC-Unique: dIrJgVc2OWex8bfWrxG8Bw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 14:58:58 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 14:58:58 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 8/8] libmultipath: enforce queue_mode bio for nmve:tcp
 paths
Thread-Index: AQHY2nNEm2cELA8bUUazACNuTd4ina4XdA6A
Date: Thu, 20 Oct 2022 14:58:58 +0000
Message-ID: <43b18757d4792c0e02776960698ad662380b2621.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-9-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-9-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM7PR04MB6981:EE_
x-ms-office365-filtering-correlation-id: defbc9a9-1365-4cb4-96ff-08dab2ab9e01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: balYn0gIvIjxCr3W1oTidoB7K+XMX5+707372ge1Ot4oKxkpMbUyJpNCuc3BrUrIlKb6K81CcrvVxd/pgXysQYsKZ7zAehoG7h933/MTkiSrfO9No9WeOuwAIl5PxW+e1M/SfiLXR6O0IBR9CwxDUPo6OF+xjRoMGNnZlfk6oex4OQBt6lRM8RZ40piry9d4xerNog8C3T7FYhfVdNjpZd7sO8dKJ6lgqa2LynZiFfxpYZ2rZX3sFpG0BSUWIfb8P3t6YEKqAUICVZqNPivFSsjol2Z+xvmSuA3uvJfrr4qhR1tT0P/kIubVe7CWSc+hvPOoXlpT9Hen4Fgyzc2PtlRS4zFX/aPekQ7Yph4zTpsMCDWjMrF8jNpN3EJtTax1Z7PDtpYWnUq67dDkYjAKcjh5bVdkdkDEKuB0XtIc695HgoXB8dB7ZvhaAC6tQXSQaZrS94b8/F7eukKHx1qCkxch9dbUO6rPDG0/9HZZWbhW3GXmfekRta+jfF5od9V+xKYT+OTx6fsNbRcb/Pj/e0jAq00U4NjbDjSjYA1I9IJNJ0WXICwwydb29CsJPdRY0OUWY00knr9q7d7J/eBrozVzKtoPVHCJmMvFeHWD5ca/heyuyGauIgWjYdameZpmJW9FHrtPQ0MQ4YvlpVKAfFkbHSO7SxC4Ahy9qlbJbe1LEeTD8hmaeFHal3JwMn956wFrVFvKTrb8W41m/ycMgcJ7QmTAfS9NjX7GwKl/Ok2kyv3cpeLjEQU0vhwYJs9pikfWHr/QbHYH7mJ3UM7LaUrzVH0gp5nYOD0eW2B+YOQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(6512007)(71200400001)(478600001)(83380400001)(86362001)(6486002)(66946007)(966005)(66476007)(66556008)(36756003)(66446008)(316002)(110136005)(41300700001)(26005)(76116006)(44832011)(8936002)(4326008)(5660300002)(8676002)(6506007)(2616005)(2906002)(186003)(64756008)(38070700005)(122000001)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?vS18sCgM4LroObQIPj5dpnpEEIZCD+OJYW6z6v8Tf3HX8dl/cF0WIlwLW?=
 =?iso-8859-15?Q?NRL1vA6S+WjLCvpQkY4IUwMeW5mFiFdGSN0C6IfXqtHHEWyI5Vsd+/nYy?=
 =?iso-8859-15?Q?YA/O7rWdv4ZPGReklTKyy2mgp8vOCldQHbyIvPSo3cypfmdR4Tvsy2KPh?=
 =?iso-8859-15?Q?Xx2zdOsyh59BNkE0Px6r5ixQ5OVIznoicgz+DsFVzTlsXKEKeisx+u5Hb?=
 =?iso-8859-15?Q?V4HDzLqdI8fbmIHfgDdd4Lf9wObwqq2ZV+yOPqGq3/w51dkcsbEA+GVd0?=
 =?iso-8859-15?Q?KZhlbBKMBPvTXOI5cHM5QcGytOUWqSmVykSLQ+CAWc4zcu5oFb2NlzHpL?=
 =?iso-8859-15?Q?BqZpnxo/cWegb9xd2Hl7GipaoYa4CYT/JyHXeQq8yfkBKrHpDvWe0tzcp?=
 =?iso-8859-15?Q?Mw3+RdbCA4nsj6qn7bOQp8ITFn6DvQyf25eCMpgNOwVGvq4+VgQS9ShvA?=
 =?iso-8859-15?Q?L6Uow8VaNGDQ9iuZlcROwvAzO323Xm9VEuCLdrafdNJzHSkdZBQirYOAR?=
 =?iso-8859-15?Q?DWRaNize2aTfhzl3+vrKc58WP9pPf5cyaF2kiqtTTLoH9UEj8tu67ofzx?=
 =?iso-8859-15?Q?26OlmF0XZC2IDe/2Z/azyAqDKr0FyeqmV/T8YqnnvZalFYOMU+Cxr+ZQg?=
 =?iso-8859-15?Q?4IxvE50/mc/FQweo2PGj0f1LfZnSw7CrxqsJ8lo46ECrpMuW4sCB8uNW5?=
 =?iso-8859-15?Q?EUSAwOaJpfeK6q0k1KthRQeU4BLC8DZxevtDdwaOV0e4x46DUg50ErvQs?=
 =?iso-8859-15?Q?KdopzvrVLCuUuPf7Q2dtaj1uuGC0yzqnT8b4a33yD6VY8D+yv1HSRuBFG?=
 =?iso-8859-15?Q?gKUZbdzGAe65+VjzrEkZ/TwU81Rhtch3FYRp5ghnjmMQ5sbciBZ7wlhzG?=
 =?iso-8859-15?Q?TdQU65dYCQEFSXg4l0lNN3nXamsYwCWBdQThej5MA94DMQqc0W5J8dO6F?=
 =?iso-8859-15?Q?eze+hff/BM+QKB2FNrhBA+8z8bkQYz+wlagBXwiuuh+lVOA12mqTdhWW6?=
 =?iso-8859-15?Q?25qz4X9eT9H97Up1JImWwqWUd4m1uf4UgMRb3ISpYc2+YVDAa058u1+vp?=
 =?iso-8859-15?Q?JUj+wR5OWCK1oCOQA4dgDRS5KPcbC+hHcYHgWctDecYkf5DopFPz+DJ4U?=
 =?iso-8859-15?Q?Y4LIC8uSEV5y/BgIfbj0CpJQFgYTN1BBIC7oA0cJq2wC3hGC0dkRXkEZ4?=
 =?iso-8859-15?Q?/oo5aPPdBKTiB4CCYnM+bSZlAVuHex38CmNhPjYavRZ507V65LKSQT5Mh?=
 =?iso-8859-15?Q?BqRQQLW8YQEIj223UYwliUeKxR23WDWrPo3LR0HwJox2qHbIJjd6f214g?=
 =?iso-8859-15?Q?vCgzw8I5zMC6oP596HgSbl8OxvcNOsiGFYj26qb2oO1ISJr6wxMQ9k5Wy?=
 =?iso-8859-15?Q?fU6T6wRfmoo0ifqKaJ26c0wO0+M5Pp0vdbO8NHTlNj4uQTDoL5ut62UQr?=
 =?iso-8859-15?Q?buEhiL6Anq+n/s1ycisx017Z5VM4fSHO8PYTtOs28nb8ZByPN13f0+oPo?=
 =?iso-8859-15?Q?4tTd3Ndwkq+3sQdDoOtIOS1QGVnanhv/uE6piszsikK5axgyLEmGJmo0X?=
 =?iso-8859-15?Q?UDXg6cihNuxD6dgGpDHTiRlNRXJLzTinwU3zuvXH2ovxO2CVhNJFOUNlD?=
 =?iso-8859-15?Q?LYErXLL4LLGALg8WFeHjzE4Lr4mia6/WTkfKZEr1YeMc0FKc1xfcl/D31?=
 =?iso-8859-15?Q?/17SUgIF1eqy6ReDAMNMORlbYw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defbc9a9-1365-4cb4-96ff-08dab2ab9e01
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 14:58:58.5777 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBohGUF+4n0oiwcAcAzlO30z5hPjlX09m6rxEyOnCN9Pz547G6D8NZ5E3yqCVbpLDfBsdakZXFQKS00aebm4Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 8/8] libmultipath: enforce queue_mode bio for
 nmve:tcp paths
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <BF283E3B3FFEB14DA65E617319FC35EE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> nvme:tcp devices set BLK_MQ_F_BLOCKING (they are the only block
> devices
> which multipath supports that do so), meaning that block_mq expects
> that
> they can block at certain points while servicing a request.=A0 However,
> due to the way device-mapper sets up its queue, it is not able to set
> BLK_MQ_F_BLOCKING when it includes paths that set this flag.=A0 Patches
> were written to address this issue but they were rejected upstream
>=20
> https://lore.kernel.org/linux-block/YcH%2FE4JNag0QYYAa@infradead.org/T/#t
>=20
> The proposed solution was to have multipath use the bio queue_mode
> for
> multipath devices that include nvme:tcp paths.
>=20
> Multipath devices now automatically add the "queue_mode bio" feature
> if
> they include nvme:tcp paths.=A0 If a multipath devices was created with
> "queue_mode rq", it will disallow the addition of nvme:tcp paths.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


> ---
> =A0libmultipath/configure.c=A0=A0 | 17 ++++++++++++++++-
> =A0libmultipath/structs_vec.c |=A0 7 +++++++
> =A0multipath/multipath.conf.5 |=A0 4 +++-
> =A03 files changed, 26 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 7c7babd9..e5249fc1 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -260,6 +260,7 @@ int rr_optimize_path_order(struct pathgroup *pgp)
> =A0int setup_map(struct multipath *mpp, char **params, struct vectors
> *vecs)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0int i, marginal_pathgroups;
> =A0=A0=A0=A0=A0=A0=A0=A0char *save_attr;
> @@ -275,6 +276,14 @@ int setup_map(struct multipath *mpp, char
> **params, struct vectors *vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0if (mpp->disable_queueing && VECTOR_SIZE(mpp->pat=
hs) !=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->disable_queueing =3D=
 0;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0/* Force QUEUE_MODE_BIO for maps with nvme:tcp path=
s */
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->paths, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->bus =3D=3D SYSFS_BU=
S_NVME &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->sg_id.proto_i=
d =3D=3D NVME_PROTOCOL_TCP) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->queue_mode =3D QUEUE_MODE_BIO;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * If this map was created with add_map_without_p=
ath(),
> =A0=A0=A0=A0=A0=A0=A0=A0 * mpp->hwe might not be set yet.
> @@ -1148,6 +1157,13 @@ int coalesce_paths (struct vectors *vecs,
> vector mpvec, char *refwwid,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(cu=
rmp, pp1->wwid);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp && cmpp->queue_mod=
e =3D=3D QUEUE_MODE_RQ &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp1->bus =3D=3D S=
YSFS_BUS_NVME && pp1->sg_id.proto_id
> =3D=3D
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NVME_PROTOCOL_TCP=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0orp=
han_path(pp1, "nvme:tcp path not allowed
> with request queue_mode multipath device");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * at this point, we know=
 we really got a new mp
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> @@ -1186,7 +1202,6 @@ int coalesce_paths (struct vectors *vecs,
> vector mpvec, char *refwwid,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0verify_paths(mpp);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(cu=
rmp, mpp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->queue_mode =3D cmpp->queue_mode;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (setup_map(mpp, &param=
s, vecs)) {
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 645896c6..5a618767 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -264,6 +264,13 @@ int adopt_paths(vector pathvec, struct multipath
> *mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (pp->initialized =3D=3D INIT_REMOVED)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0continue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(mpp->queue_mode =3D=3D QUEUE_MODE_RQ &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->bus =3D=3D SYSFS_BUS_NVME &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->sg_id.proto_id =3D=3D NVME_PROTOCOL_TCP)
> {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: mulitpath device %s
> created with request queue_mode. Unable to add nvme:tcp paths",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dev, mpp->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0continue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!mpp->paths && !(mpp->paths =3D
> vector_alloc()))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto err;
> =A0
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 07476497..1fea9d5a 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -463,7 +463,9 @@ Before kernel 4.20 The default depends on the
> kernel parameter
> =A0\fBdm_mod.use_blk_mq\fR. It is \fImq\fR if the latter is set, and
> \fIrq\fR
> =A0otherwise. Since kernel 4.20, \fIrq\fR and \fImq\fR both correspond
> to
> =A0block-multiqueue. Once a multipath device has been created, its
> queue_mode
> -cannot be changed.
> +cannot be changed. \fInvme:tcp\fR paths are only supported in
> multipath
> +devices with queue_mode set to \fIbio\fR. multipath will
> automatically
> +set this when creating a device with \fInvme:tcp\fR paths.
> =A0.TP
> =A0The default is: \fB<unset>\fR
> =A0.RE

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

