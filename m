Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC686C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 07:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666335939;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4zYEzShRHlYaCQxgfZZjHwO1XcZ6juu2fIs38hDGsxc=;
	b=VtfMUhkHa5+zpYEWWO+Af5Gax+vbd+bgX2iv4MTvv3SKxZdnIxi2851X0fMlue0563YHWi
	0a7hHggtV68XG3p8HB5JVup5v99dQCyp5jgxPmT0SBXXvX6GZ27nMEq5sRkQuiy3JNBazM
	lamnYnljIo/0y0Tjfz1OaZK4HU7ArXY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-DP3KVMnOOvS3241nSI0OWw-1; Fri, 21 Oct 2022 03:05:36 -0400
X-MC-Unique: DP3KVMnOOvS3241nSI0OWw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 667F5803D48;
	Fri, 21 Oct 2022 07:05:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C5C349BB60;
	Fri, 21 Oct 2022 07:05:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E3191946595;
	Fri, 21 Oct 2022 07:05:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07A4C1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 07:05:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E006D1759E; Fri, 21 Oct 2022 07:05:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5714FD48
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 07:05:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3A1A185A7A8
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 07:05:32 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2056.outbound.protection.outlook.com [40.107.22.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-R7Yrq7aGOq-jx9yS7GfICA-1; Fri, 21 Oct 2022 03:05:29 -0400
X-MC-Unique: R7Yrq7aGOq-jx9yS7GfICA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DU2PR04MB8693.eurprd04.prod.outlook.com (2603:10a6:10:2dc::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 21 Oct
 2022 07:05:27 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 07:05:27 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/4] libmultipath: don't print garbage keywords
Thread-Index: AQHY3bvc8C0BSE6cc0aU3lbugcRrEK4Ye4SA
Date: Fri, 21 Oct 2022 07:05:27 +0000
Message-ID: <d50f3f06e9c0d28c3452d0b51a4d3510c2cd1389.camel@suse.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
 <1665525183-27377-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DU2PR04MB8693:EE_
x-ms-office365-filtering-correlation-id: c316b038-45f7-464e-ae37-08dab332a1f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TsuKyt9tOgSJjEENina9hyTZuKLoyMZZSUnGY8Ov9TlcDM3eL5NN2MlybA2xUSN5NaCf/89vDBL2+Sw8lPbtUhvOSx74GWkclRdZBgtm4+YWK/KllfprrCWrnY0DMcgRlt6JveH35r3X/rQrxDYUaddDZOpiEdsTg+ePebPTQrX0iDv5YlDZA0UcSF0jIyrfywsT9/Ibce0AN5/8T2pTc0w9d4lGKE7MVP5Kj0Ka5JRwt7qBat7bKgVw65T2SWgErckx/jjJnZrgQmvzdpC13ov0SFYx6RzejWaUUOpaT6uzorAAgzW2DvJuFv7OrhccbDySoXvziTWd6d3/JbDubN/jafIjqd1v61CpVhuws5veBmKFPy4t5Hdn6HBVDzVfR7Y21SXhK4j8Qzmou6q0ovENBwK8S2lOHRotWXq2hCfby2OUnU+RQgl4scP150+1VQeemLqr7m84zNCJEjodNBN+414aH2mn60BKhHiZD7nKFkshzY+HHlHY3wMY7ZBMepO4AMWy/YeD0a9owC3Cxs46fxiSy8u/aINPAiUaGqkXhsT+j2+iB/95fjh1WktgB3/8jpif/C2IWZOcf6mhyC90IyK7H98LVQXLKuTl0HNtP+oUimEyeosItDW8pLMd57GUKEIgd0knCK6hzZT/xlvPPg14QO3hj3Tf09z9PIG+5DqU/OO2QxDPT6OBKplnsWbOGO+uk/jlNxO+SerjqvCFjw5qaWH7SkpHe8nWBmf5gaJ2EufSYEI+Axj18yTP/03nZNit9CWPGRdrQanmOw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(478600001)(6486002)(38070700005)(122000001)(71200400001)(110136005)(316002)(26005)(91956017)(66556008)(64756008)(76116006)(66946007)(66476007)(4326008)(8676002)(66446008)(6506007)(36756003)(41300700001)(6512007)(5660300002)(8936002)(2906002)(4001150100001)(38100700002)(186003)(86362001)(83380400001)(2616005)(44832011);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Ccen/H/dWedBdTCz7kMMEmKgnkpkUO3xklXCsnCrs6qOSHuv4sdwzKMhU?=
 =?iso-8859-15?Q?gU7N3e0UHi3P3Z9wYOoC7Rx/XhGK6VLIRCdMLKU8Y9idcp+nmkmToQ6Ho?=
 =?iso-8859-15?Q?iTC4d1I9+0NkMCUOows+J+QuV1QcHZgDK5XeVmUgNaNrCUt2aNljp2TKT?=
 =?iso-8859-15?Q?JQZ0EBGHMnf9t/1XDsuvRLgaLZoC10+IelKqQ+HCajfWo7yCLn9Pm4J9J?=
 =?iso-8859-15?Q?g3pkbD7ECYDPivKnqfdasORXEQrl9lvxkL9u/sVA6VyICK5iojXYVxQL9?=
 =?iso-8859-15?Q?nGvHg03dYhFB/vSly/RXEF1/OT2oGMbJSjdlDqbz2e1O0pprrGOt8qbRH?=
 =?iso-8859-15?Q?NddQeCNEGHngC+MHzjT9pAQ0KWOnpjEkkGYqwIrBHM58rxbxYC0iJvXJJ?=
 =?iso-8859-15?Q?dtse+5j3ieUamkqjcwFsazMEb6fyu7b5dWj5HfKOhuCyVHs/eL/3Z9t3q?=
 =?iso-8859-15?Q?LHAGDIqlsQ3JDiONXNBvcTaBrBD6KTyUa0n7IK+P1W54vhWx75i4f0zwF?=
 =?iso-8859-15?Q?BF0eJv1d4j96eRZ7shqC1218XGl4YQmyHiGTRTQyeGw2Kkfg45E7EkH7Z?=
 =?iso-8859-15?Q?SufhTHOHk4e50gwR0thnPRGM4jYc4iLnRWY0XfQ4Hr3offC07U80qw+fy?=
 =?iso-8859-15?Q?frUhC3bxcfLTaL59bjYTN4KaJnlNAb5r4OP2OThkfF6NCUDKtrEWaCqXs?=
 =?iso-8859-15?Q?3CoHunY04Vxi7eN+LyN0pjXjgWrcY5nXiKCgjwcscN68RVN98tQS/Z1xn?=
 =?iso-8859-15?Q?c7JKVTbLFD8rvf3mwu9UWh7z6a49vIm9gwsfnFg9HLEomnx/N+jUT6see?=
 =?iso-8859-15?Q?e0iWgrOTar6ISHaWq//iPY0lfB3jrL/0Mxko0r1bfGGaGOZ30pRSVMq+I?=
 =?iso-8859-15?Q?6u1QD+IMP08ud2AjGRkDk9BZ305P15jCGeE6h5IxUITameLIgW7zPfXtJ?=
 =?iso-8859-15?Q?bPZEzPpo4CLxb017iMwqkmZF7RsyPU9P1Duzc/QUGf27T8YhKV72aQyz9?=
 =?iso-8859-15?Q?iyWZlBmCVpte1TtFwX5LV9PAHjA3MNe6lgBi18yn1v4vAhYyhJuG0V45Y?=
 =?iso-8859-15?Q?CLsPoNKB+oxJvxcKszF3q9LPK1PoGQaUKTHN7sKLuyrgMFcjU1omNX2pu?=
 =?iso-8859-15?Q?oMVfz1xhXHF1fXgaXGyXI9gs4AdMbJFW8ugoW1PuFfbJT5msl0YncyrAm?=
 =?iso-8859-15?Q?oQMWTCIL6vKq//vdGBPmuwqKWCccENixYWPmOy8VL7+l6e2IDsi0ga6ni?=
 =?iso-8859-15?Q?85f4rQeTeIKQq0RZCN9MWKda8Y+j6tRA2qcorUyP5YpIe5LQD8GAZvwGu?=
 =?iso-8859-15?Q?9lBrnM7xynEsOtR0aDgVyXsmo66kW5SWJSTxwsCGgX3qjkQVQBNA7WwJ5?=
 =?iso-8859-15?Q?vORy3QZHXioudwMX8YlAhVg/Fidehq9CBmqiyy0mUIzp0UlN6uOgb46eh?=
 =?iso-8859-15?Q?ZkmopuAjopdyMGUU77eCQBsK6QCZw2k/zAoHDTYJJgBQDbZNL+zM9tdwy?=
 =?iso-8859-15?Q?AcPZL3mLwJGBL+4TnZl+tUY3yCLGAjscd0KRMNKgMYcP8zVyQkacEzyIL?=
 =?iso-8859-15?Q?RIAHtIK9fUGu3SBGXd/o/S2mKqPypP5gobmso2+WYGvnzBdoiW8YHtSqs?=
 =?iso-8859-15?Q?eGpRxVcOq8JgslqWnk5Z6nu4J+7EdCH97Ko/J/mJ07xjocz9b9F/beoId?=
 =?iso-8859-15?Q?OADDWPIA2tmqsCEkw9GB7qzgqg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c316b038-45f7-464e-ae37-08dab332a1f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 07:05:27.2937 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xkeGJHTV3gDFB6LkGTQDcSuX4nIiQl5vGrI8N15OzPZH1L11l7kp0iW1TfTF0u8VcPQv89T6kdQrnAsHwmbxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8693
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 1/4] libmultipath: don't print garbage
 keywords
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <51DBE052EAA17B46AFF3028B64540D34@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-10-11 at 16:53 -0500, Benjamin Marzinski wrote:
> If snprint_keyword() failed to correctly set up sbuf, don't print it.
> Instead, return an error.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmpathutil/parser.c | 8 +++++---
> =A01 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
> index 014d9b83..8d3ac53a 100644
> --- a/libmpathutil/parser.c
> +++ b/libmpathutil/parser.c
> @@ -152,7 +152,7 @@ int
> =A0snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword
> *kw,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const void *data)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0int r;
> +=A0=A0=A0=A0=A0=A0=A0int r =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0char *f;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(sbuf);
> @@ -190,8 +190,10 @@ snprint_keyword(struct strbuf *buff, const char
> *fmt, struct keyword *kw,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0} while (*fmt++);
> =A0out:
> -=A0=A0=A0=A0=A0=A0=A0return __append_strbuf_str(buff, get_strbuf_str(&sb=
uf),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 get_strbuf_len(&sbuf));
> +=A0=A0=A0=A0=A0=A0=A0if (r >=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D __append_strbuf_str(b=
uff, get_strbuf_str(&sbuf),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get_strbuf_len(&sbuf));
> +=A0=A0=A0=A0=A0=A0=A0return r;
> =A0}
> =A0
> =A0static const char quote_marker[] =3D { '\0', '"', '\0' };

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

