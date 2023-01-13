Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35D3C678DE
	for <dm-devel@archiver.kernel.org>; Fri, 13 Jan 2023 08:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673599991;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pEB6k4xommCHVXwqzUtgrIqxYoE9utYwscN+mDWOHtc=;
	b=M88UZZ+Vhb/l2UuQS7v4svRx9m6+3xz1kYrfWa5hnEUXS2L+OF1CNwdW2nQb1O74bW1aWx
	YnkRNcU5aarF0W2UcdOMam2jsjyT0n326Pa6DXXTtMMUggK61MGj4lwzJAtt88+Ui9z35P
	6tLan4GqfQDxJO62xEkW3qhOtAfbkQM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-V958ucrnP42GFj-xeqdPzw-1; Fri, 13 Jan 2023 03:53:08 -0500
X-MC-Unique: V958ucrnP42GFj-xeqdPzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A6F51815CF2;
	Fri, 13 Jan 2023 08:53:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 280564078903;
	Fri, 13 Jan 2023 08:53:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07E5D1947050;
	Fri, 13 Jan 2023 08:53:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B0F441946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 08:53:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A20C2492B02; Fri, 13 Jan 2023 08:53:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99011492B00
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 08:53:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E935A3806107
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 08:53:04 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on2081.outbound.protection.outlook.com [40.107.15.81]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-d7ujMtBHMO-LtbT7wioAGw-1; Fri, 13 Jan 2023 03:53:01 -0500
X-MC-Unique: d7ujMtBHMO-LtbT7wioAGw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 08:52:59 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%4]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 08:52:58 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/2] libmultipath: remove pathgroup wildcard options
Thread-Index: AQHZJsSBNCK7JYcrtUW3WE79Cjo/I66cC1UA
Date: Fri, 13 Jan 2023 08:52:58 +0000
Message-ID: <d219c42472188ea365769aa8b261965b5ee5c05c.camel@suse.com>
References: <1673555329-9850-1-git-send-email-bmarzins@redhat.com>
 <1673555329-9850-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1673555329-9850-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8204:EE_
x-ms-office365-filtering-correlation-id: 4539325a-ed2a-48e7-254d-08daf543921f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 69HtGtg7ynHJgP9TcWVVLzViGfKpsgLyEcuM55FyAxUcusRq0W1+d590f6Zkxeffzd9vas40c43ftvzVN6fy1lrkgaYfFQTlRZaTSEZfQPqc3pX5BtpIEaDibm5zoeGQLxqzbPFzfN4ofrlAnajRdSs47s5Zo/9Z73yEDCKXKGaf8iv5ceFJtmwDGY584ILXdOPCYnEY2D8ljjH0H3C0W07HXZ5kMowS1HNrDF2PP2uqhRsuqkJqRxDQtTk8gWlnT43SOTFgZg09gXxc/QetBft9rqNv7QOjMpahtLIkQdPn9xsNUB040q73eQ3QU79Z5nGmzGlcJLliRoROVTwT66LjqKbAH05/aqzjVWogWDjaDlzuN9bll/mcXSBchHaeL6xHqKBNk/g5KfJ9zZUNdvZoTmv9+kkdxxjUotdIpajCJ2Cn4rLm+6QtMr8ruoYFmod+4ASCScwu7E/irZZLN+I5Af6B6eL9UbDZ3JtpV0qPK7nVXSEKtosDBAhD4H2xAwxj3D40RHuRYiN+6QnZUxOunGQKzLmjr4ujof4wgvmJmHP8UMU7a7Orw6R+4uM8ZQfBRM/NSNN92fplymniHI4spRYLEkK+qMt37sIVY69Q17UFHaXHJxJhrQ/yIVeeHu0Slxd2JE59rdpaI94tjp0DthiD/P8izcxpp29OC1BvmvP4smqEGiSypBSMe1tjbZTp2h7JKReo2mTSxnEnmQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(38070700005)(6486002)(478600001)(41300700001)(6512007)(38100700002)(71200400001)(86362001)(316002)(110136005)(54906003)(2616005)(91956017)(66556008)(66946007)(26005)(186003)(76116006)(66476007)(36756003)(5660300002)(6506007)(2906002)(4744005)(44832011)(8676002)(66446008)(64756008)(4326008)(83380400001)(8936002)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?mcyxGDZgyP5KeGWRBpv+DrznqDZ1BCKC5KbqpTkqLZqM/BnvqU9yxNLQW?=
 =?iso-8859-15?Q?WjD7dh6Pg+nAphsuN1YQpOsg9em+Hb+sFAqlalPhCoFfrJgqUww4o7yP5?=
 =?iso-8859-15?Q?IHB2IRUvq+lKrsIjw+u67u1BMXfQW3cXi0MyxKlyLsj4RRL6RdiIrFrOB?=
 =?iso-8859-15?Q?gicJILJsuZT0dTYLk76zyE+gtVhV2W/vySxulrbI2n333pXn9sDsMfoZx?=
 =?iso-8859-15?Q?5C5jvfpk3T9JpXarTIeCQNwwUm6sLKs//mH3ISITR9W/wDs5Wq3Bw63Nj?=
 =?iso-8859-15?Q?blnKoxmqWBqWxMttBfS82JgmZ7kXjA9Qm0P8cw6CE3RlKKiJGR8OsfK3Q?=
 =?iso-8859-15?Q?8lUZg4VGThQUPQ+EJNRmEjFhaKg6mIau3/alCyBgLC7bCJ0MgBmt7f7Cv?=
 =?iso-8859-15?Q?ajdbnZNhYkQ0R4xrkWCl6l2UVtcd8bOV/1cs79Zk33byPhBzAbDKYBFwa?=
 =?iso-8859-15?Q?TTIGnYouQ2fHHAalhSX2V5StwOxguoEE3slg1PXx1agUyRn0YxR3lYCEQ?=
 =?iso-8859-15?Q?C6flENBJmmQZEfPitWdvVSlNYzKzLayyUpEwhRzl7bSF4ScNRdZaENKMM?=
 =?iso-8859-15?Q?6Bk0nSKkNl51034mTUiZ+MRVOyuVkyY+fe9AzGF+SBUg5TF+HAWU23ygA?=
 =?iso-8859-15?Q?NEADIYULedreCrj9E2d3qayd7+R6LTIuzFkTPyfDJnih7HvcZ7gC4PIWh?=
 =?iso-8859-15?Q?4onnYUKJua0ac2TUmmGcAmZ0JN/LFNc3riLNSJPs/8Gw9+GXRFyMNKnoe?=
 =?iso-8859-15?Q?a4sgzpusJ6+0soo+ag2rDuNs2cDgUafwCas5TfN31cVjjiikrBarbfCro?=
 =?iso-8859-15?Q?bk9p1lzoBCKYIa31jpWArOg5ufspCCnHCsnkZVI7vIowrEt7JDgBP4M00?=
 =?iso-8859-15?Q?Y4PYmZuGx5z2TA7YCASN0UNnRkDEOoW/j3JGXk1zViUIrC0cMakvgZhjJ?=
 =?iso-8859-15?Q?oB/xRzdT7evCgYGHPdN5/vIT8whOlokDXCjzXmkOJoZq9AX7E88GWFqu4?=
 =?iso-8859-15?Q?GxNVeI1q03pOX7IWagzaJ0MvPP9Ti7aFmouVTwolfOnXTFIp6D0JrMFXj?=
 =?iso-8859-15?Q?hmuJCPC/sUQUEVfFbvkMJ0LEN+rUNt3zf5BKGLlRyoXG+K1XQ1Qlk31j0?=
 =?iso-8859-15?Q?a/10O4X37kSmqU7CiGEYWbJuSrQIy1byHnqif92243BlTb4WLTVV8ajrX?=
 =?iso-8859-15?Q?Cf6x9oPCrl1p7offR6w1A2oK57vo1AHLioGJCZrcCeTvj0ytKmBvBZVlF?=
 =?iso-8859-15?Q?Fp7wX0oAtvGR/Gn8zKpDZY6LQDkPIEvq/YcPh+j8TPWDwgPqNdpm/Ymz5?=
 =?iso-8859-15?Q?2q8mtwwrI0O/29Jc2FxEg4IhgF+yZigszYEGXYnDDfWi0topk+WCe6W+X?=
 =?iso-8859-15?Q?hvrVp5yZd3TWBfvlWA2jnJjEHsOH6NbQmzxhnSCJeZrJZV9+NlBaLJ3zp?=
 =?iso-8859-15?Q?N6fhAddw6rdtNLXQit+tTnDOON6iQMpLh0+jyb/esIeMbDikwy0H0atV1?=
 =?iso-8859-15?Q?qPOGewwLEMyZLysWWS2lELN0kCsrJtupVnsXiJ1NiHg9DjOoSfUHcLECd?=
 =?iso-8859-15?Q?Nym2xWL2HBlDkVVlH3xwW8W2SE1VVVhInSiR//RX1PyFs0X/O/JauZxyL?=
 =?iso-8859-15?Q?z2VjZ48tqZOd+pQpY+jshZSlp/gJe5L/40DLFKxqroAS6VoCBMDNLIIex?=
 =?iso-8859-15?Q?0cXR1TtU30CjiAMMWgvmPg8CTQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4539325a-ed2a-48e7-254d-08daf543921f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 08:52:58.8850 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OUsDet091Ez7twHuscQYpT0HLfOBzjHHCICk6du0PEx2bAdOyA3Gmcbe7/+rT5dre6HmreMj0sBg4trnOy1eFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/2] libmultipath: remove pathgroup wildcard
 options
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nyewale@redhat.com" <nyewale@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <410D5CF67B523E408787F6BFD1E40B64@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-01-12 at 14:28 -0600, Benjamin Marzinski wrote:
> From: Nitin Yewale <nyewale@redhat.com>
>=20
> The multipathd command "multipathd show wildcards" shows the
> pathgroup
> format wildcards, but there is no way to use them in a multipathd
> command.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/print.c | 7 -------
> =A01 file changed, 7 deletions(-)
>=20
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 3193dbe0..9df77247 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -865,13 +865,6 @@ int snprint_wildcards(struct strbuf *buff)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pd[i].wildcard, pd[i].header))
> < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn rc;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((rc =3D append_strbuf_str(buff, "\npathgroup fo=
rmat
> wildcards:\n")) < 0)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> -=A0=A0=A0=A0=A0=A0=A0for (i =3D 0; i < ARRAY_SIZE(pgd); i++)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D print_strbuf(bu=
ff, "%%%c=A0 %s\n",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pgd[i].wildcard,
> pgd[i].header)) < 0)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn rc;
> -
> =A0=A0=A0=A0=A0=A0=A0=A0return get_strbuf_len(buff) - initial_len;
> =A0}
> =A0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

