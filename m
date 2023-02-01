Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5CAC05027
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238402;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fee3izSOvQqumM/wNuaSa92UO09uwHBGrMLzZKWNFgQ=;
	b=LVAlxnpEGQdDY/1gvDSyzb5xbvkQ7KZU1Fjn/Xb3BTh+Qt8JmWB6Gp+MCqLvNonzMJcgYo
	9ACEtuJLBbN7QwfpQs8XXNIw285qj8vew6GGUfTXL0MoI5QxtNl4k3fn58GAEpgHXnJ7oN
	shVh/A6X5vvB1Fo/zNYxFDI5/5yjZiM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-9F440W54NLCW8qqRh1tv3g-1; Wed, 01 Feb 2023 02:59:58 -0500
X-MC-Unique: 9F440W54NLCW8qqRh1tv3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA7BA3C02546;
	Wed,  1 Feb 2023 07:59:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9379B2026D4B;
	Wed,  1 Feb 2023 07:59:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7AE7A1946595;
	Wed,  1 Feb 2023 07:59:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C26D1194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 07:59:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 808B540C2005; Wed,  1 Feb 2023 07:59:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7846040C2064
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 07:59:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5938B3810787
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 07:59:39 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2050.outbound.protection.outlook.com [40.107.13.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-6SDWyviIPXGqzUfHLxzh7Q-1; Wed, 01 Feb 2023 02:59:37 -0500
X-MC-Unique: 6SDWyviIPXGqzUfHLxzh7Q-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM8PR04MB7202.eurprd04.prod.outlook.com (2603:10a6:20b:1da::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 07:59:35 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Wed, 1 Feb 2023
 07:59:35 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/4] libmultipath: use select_reload_action in
 select_action
Thread-Index: AQHZNasJZbiIQiqzQE+ch2py3fixPa65uuUA
Date: Wed, 1 Feb 2023 07:59:34 +0000
Message-ID: <4265cdd94754fe5ee698c4f3b731951179eec8f2.camel@suse.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
 <1675193661-1147-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675193661-1147-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM8PR04MB7202:EE_
x-ms-office365-filtering-correlation-id: cf09799d-46e2-4f7a-32c1-08db042a4244
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LHrwECQiDOQfSBGcgm06BgTesR9+7D2zjnqt3FPlY9uymcqqEyMPSEIPYhmAPrZFrMDc5GjHjm1/hbPf8XjamNLliWbmcDMaw7bg4KouePAVKA30oVQK2mzvyFmB0inDVUyo+bgyT3MErM7EKPqfFYzRK10PwjTjDC6zXKACe0I6O9BEfKk1S9DkXvBr8xZ1Cw0Z1JBTkxD5uA/lY/jsqchbzTt+TI+3Q4s1H+OWGYlvyy8k3JgXKU3tDs5vxRf4C6Nz12AncMqZEOiB2hONZ5mtqxtICmqV2ZS5ZFB1ciJCor95FygMZi+6u6pOajMdKI7YUsTnJCrypXGJRtlbaSt2FgvP1IMXB6V6pl62b47dWRMhSeXyUSKbSUKE1ftEAQnrQpbaaO03DO7eJvrr9h+VFHD+3Ep8oG+cibx1lnyfB1PepYXEQhcxgv8Ees4McpVZWsQI0kaPzYUo0vST4SoEfPB3MOMHF9v/9JZWgqaSOPeMSKslA5Orgxudp/JxBVbpchKQZx2woMxeXawD94Pv6R3XJkuXs/VfXbEGfE9iyT0to9K/FUz3gCXZEw6ZE9BW+TFwhPTbGA4bNdRdn4hS/Q5cg6KM0K3qI1dVllFM/InIX3V2Z+j8zuN+JI5tRjNjFuKY573Oy6ZWFNvaMyL0FP6Y5F6fTefJQYgHSFqmWn4kWyx945iOWfO7pbq382AawKcy8sWNcc88yUaQig==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199018)(38070700005)(36756003)(86362001)(122000001)(110136005)(66946007)(66476007)(38100700002)(66446008)(66556008)(64756008)(8936002)(76116006)(41300700001)(316002)(8676002)(91956017)(4326008)(44832011)(2906002)(5660300002)(2616005)(83380400001)(478600001)(186003)(6486002)(6512007)(26005)(6506007)(71200400001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?gTW8c48xAs+V87vDRL4MLMS7Ensxllyve4c3R6CE9R82aDpoV7jc6VjpH?=
 =?iso-8859-15?Q?5XEldkdth+nhuYNOrDfl1Adb0AtnFD70/n37zFmmpvaCKKR/Mgf1VYOGy?=
 =?iso-8859-15?Q?ig2o2h0et9ssq+MonHIRPEj1pyWOXwep9IZExumQ+LhEWMIALAae3Hvaf?=
 =?iso-8859-15?Q?p5PgSa7j/0mDYjjaBW/3xzDmnN8DIVMHgibpiMVlLLaagVDMKeYNV2uzo?=
 =?iso-8859-15?Q?GgzqBpAp+KGS3WguaVAUtQuDGDs77sekJ1qqv7xZrIf5TIYSCyS0zvjrr?=
 =?iso-8859-15?Q?7a+MBC5uNNh+1qN+jB5iMJr7JyT08BNdaH+MjD2fubc3yLxBUrQMYjy9p?=
 =?iso-8859-15?Q?NCItvYwH0NKVlBx/WbqdUyhkBIh7Vw3GjoKhbHbTcrH7Bpsr6o8xfUJat?=
 =?iso-8859-15?Q?HO0B9c20Q57YJbPoBG2a6qfx2m4y03m/wK7kLfOxoo9uGsGE3mZJ/IPy9?=
 =?iso-8859-15?Q?xlQgEeGUkjMPvk5kwD8K80dFNXZ5MtyglJXFLgy+nxnuvjAORwe0XiBdb?=
 =?iso-8859-15?Q?6/E8VqayEvaGSbte95+ed5ZjjuceBuBeL1U2aDjeXZXAdxpy6vkru1OMh?=
 =?iso-8859-15?Q?E8D+S41if/tANVlqXs23cbVbP9KRXLbxzA1I2sxUsF7UNZcBhja/XeYwe?=
 =?iso-8859-15?Q?FFqna6+5P9Rxqo3znVoJYOgSJ0fh90hTfLk/RaMhS6dWrSGKjBLrq6G8W?=
 =?iso-8859-15?Q?iiZJZUe1iiC78MnKFS2qlDlYMxyELuvTR2qglCeTZHSljKA6iYcb0wpU+?=
 =?iso-8859-15?Q?bBx83Oad9uzRXqPhbm/cre1h9RofjSA2huCOvZ9ZforN93vQ0AdKft3oJ?=
 =?iso-8859-15?Q?Hd+5GMjhUs23L+kMQ41MQlIob0DnMeZQLyDuAEl/w/dIhS0ADUvFt8cGD?=
 =?iso-8859-15?Q?TU+Osp34BDE/aBPlNbPGlhqTpfuIQe+SroqhbjBtrUZzr8o2BnFGoa0u2?=
 =?iso-8859-15?Q?G5NOl7UBkTloTaG7hem5TyqDg7vsooVo/vS0IOs6XaXxDVZMf/QV+jeiY?=
 =?iso-8859-15?Q?vBBq8sGkYidzBQrtMKEJMxYbW2eb5nF1dvjSR1iT8OASXit+6ig7MvAXj?=
 =?iso-8859-15?Q?xs8i+kGvyPJyPsLz1HKYgJJdq4Rigv5JRptiURP7ghSiSet0rnEIMWMZE?=
 =?iso-8859-15?Q?uDN0ZA6BqMgWOf+H6XzO3wesdtKXiuNm0a5jqHev9Obb/rJHRczrIeMWC?=
 =?iso-8859-15?Q?8L+MpVHvgmkQ4R2cKvBjonrEqqyVEKJsKjkWsyp3Z2FHfr8jPKy1vHXUk?=
 =?iso-8859-15?Q?g+EhTQI+gFSAQQENqBxb3GpOp/ZHQ4V5x07QOYzuKTA1IpMdlFkKNwSB5?=
 =?iso-8859-15?Q?eVc9dHKI3pTkxyFEVnbhQQxedAsjKZDFLAC2BGQ1WOYEJvGXx8MXXC4KR?=
 =?iso-8859-15?Q?At563ayi6B94Q219JJ/F9ZPRMv7lOZv42NDEt23xLbVgpUNNwYxZkrcNg?=
 =?iso-8859-15?Q?+HJzGi365gvjWKLbcNnCjtV/Ft4uP9QOinF2GVvN08/wrXjDws3oBbdfY?=
 =?iso-8859-15?Q?BQzs1cZZfdlA9wyQ3EOXY9dssZMo6eVUbQGhwH2m6/i4yY56hbjHUp59c?=
 =?iso-8859-15?Q?1YdCaarunupW6foir/xPr268C6vi1/P89QpOfdXsA1htOW2rsOs8EOKaQ?=
 =?iso-8859-15?Q?P3NfqgdoGoPH+4xBjYcdPzqWs6ylAxIxcxboPjFAHTz70c540+LJys4Uo?=
 =?iso-8859-15?Q?VrYboOW0eHEefYbHKPd69vEmAQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf09799d-46e2-4f7a-32c1-08db042a4244
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 07:59:34.9335 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c9wQHgOJB+9qP58z7RZvpMqk/nNijBPS8WJUIiT6VfJLwco/YNjJATd45M+xcl/KbYpdMprjSxctOyBNCxNBjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7202
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 1/4] libmultipath: use select_reload_action
 in select_action
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <55D80BDC6A9CE841ACBEF695B86E3071@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-31 at 13:34 -0600, Benjamin Marzinski wrote:
> Since we have a function to set the action to reload, use it.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/configure.c | 8 ++------
> =A01 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index e689f8a7..050b984a 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -729,9 +729,7 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (force_reload) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =
=3D 1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RELOAD;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_REL=
OAD (forced by user)",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0select_reload_action(mpp, "=
forced by user");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (cmpp->size !=3D mpp->size) {
> @@ -744,9 +742,7 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!is_udev_ready(cmpp) && count_active_paths(mp=
p) > 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =
=3D 1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RELOAD;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_REL=
OAD (udev incomplete)",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0select_reload_action(mpp, "=
udev incomplete");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

