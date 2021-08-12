Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E645C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:23:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BEF9760F57
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:23:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BEF9760F57
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-IOmC1D1dMquHTKe7Z8hR_A-1; Thu, 12 Aug 2021 06:23:39 -0400
X-MC-Unique: IOmC1D1dMquHTKe7Z8hR_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC64292500;
	Thu, 12 Aug 2021 10:23:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B36475B826;
	Thu, 12 Aug 2021 10:23:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 889304A7CA;
	Thu, 12 Aug 2021 10:23:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CANKMi012249 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 06:23:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E611E10FAC6; Thu, 12 Aug 2021 10:23:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E019010FAB6
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8D341066558
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-106-GRGybNbyOu6l1KK-F0LJUQ-1;
	Thu, 12 Aug 2021 06:23:17 -0400
X-MC-Unique: GRGybNbyOu6l1KK-F0LJUQ-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2104.outbound.protection.outlook.com [104.47.17.104])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-6imoxl59NTGsPCx6eWGY_A-1; Thu, 12 Aug 2021 12:23:15 +0200
X-MC-Unique: 6imoxl59NTGsPCx6eWGY_A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5385.eurprd04.prod.outlook.com (2603:10a6:10:83::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17;
	Thu, 12 Aug 2021 10:23:14 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4415.015;
	Thu, 12 Aug 2021 10:23:14 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/5] libmultipath: remove unneeded code in coalesce_paths
Thread-Index: AQHXhMMvIAPcCy7I5kmj6eOn2MchYKtvvpcA
Date: Thu, 12 Aug 2021 10:23:14 +0000
Message-ID: <af3f4f4cc8916670114c4284a4fc1afbf58d41ad.camel@suse.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
	<1627595165-19980-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1627595165-19980-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fbb7c4b-f516-409c-299f-08d95d7b31bb
x-ms-traffictypediagnostic: DB7PR04MB5385:
x-microsoft-antispam-prvs: <DB7PR04MB53853F2026044608B94A67C3FCF99@DB7PR04MB5385.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Vp/ffYOHe7yHjxUnpoTcCOM1LEij2Je+VUgcdLw/RuwtpftThwgEMHsdreqxKCGq6/83ioosYEYZqaAasxTgs2HuhXzIvcbZ8GJY+EpDOxXyGR+hU0ZbcCAY/cbfhh4vHfhrRG619S4nTpptQrOe84X6Cj8YlN22z4GMoijXrtavVz45BLR8ygfwFMT/HMnsEMT8nWtcuTnns1X/qcIUNqwXsBsrASBTZme9SISN9TUpur71kTMQZ1JfvNpGhQXV+prCMEh8AJtQ0d1jZSmr0cBahBJATi6OgC8j28hzok7sdNEz43EPiVOjjHDgSy/fBIixKrp3F+mUjcwxnKtuvZ1kW9WuU4qlFab7MHaS3jxOW2HK+b7Op2W69e3h7txT6FEDTYnmZvnjpFAYuNwEhW7l+G1jl6JWVfCh+AjZrzqfgVCvrMBm6g0qCPyx6C2rpN8hCz7tylHpmkrwRC83vZNb1pUpKxwWmWD5LOScc1aimBic0b8Fwk24NQTtBD1OwvWuO9MyI+/ABjxudzdHpzFHO3XjK+q5ZtYPjsnZcKU76h8dmvtrjMN9q7sfn1X8qJeyQuE3etqiuNYJJvRt/x5AEQojhoyoHeIhX0o0lvYJxYnrIeuD3xCDTbxcfAj9PvMJ4Y3R7YU5sBV2GzgA25FjDh3ZnFy0RMhscDryJdW/DbTHqX3jIZateQBs2GcqIEd5o2Ic/jzVXmXXT6a4+g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(83380400001)(66476007)(66556008)(66446008)(64756008)(66946007)(6486002)(91956017)(86362001)(4744005)(44832011)(2906002)(38070700005)(5660300002)(36756003)(8936002)(76116006)(2616005)(8676002)(6506007)(508600001)(26005)(38100700002)(122000001)(4326008)(6512007)(316002)(186003)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?GtGW4F9WN2cgPTwISqlSu/mja4yOF9w9gyRYZUlUt3HnuLwrxhYlFQHng?=
	=?iso-8859-15?Q?KcT4t96cDf1hvqa0M+oz+Jp2pdWQdeUbGTm1WthukKaD9oszTo3OGKmQ/?=
	=?iso-8859-15?Q?aKV6zICe2lz0+Urp0lLtwY466Qn/Pxb6atiT1qKH0JshdmaxXIgnd43VW?=
	=?iso-8859-15?Q?871Fj02M1jvlG6mdje5FXkwajJtEZSOdp6TZGJYZmh0kW09djPT8s+CSb?=
	=?iso-8859-15?Q?rDSAAEZBXIAvJbeBOvO0DOnmc3prkP9isDuWl7fn0vmU7NZFRWJoot/IH?=
	=?iso-8859-15?Q?lI9+SL6CrLPbhMYZ+JEO+o5okTFkay31iT4DWDs05EMfZecP38TfjhHie?=
	=?iso-8859-15?Q?tSGpexoufP7id0KSEO52OLzi83ECaLgobvtlYATOD4XiFj9KRAIdJ+L85?=
	=?iso-8859-15?Q?LR6eqgoxtsdnKy6eGv3H+bgjhwm/8hpMwVfnUQsXONVXWGEU7ziWlYkrh?=
	=?iso-8859-15?Q?hCSxWpY4xFy+N18n0JfS3L3UDTkIEN7VU/MqLldEV187RGwefKJz+e46x?=
	=?iso-8859-15?Q?ARLfoD3UxUrqvYSz/a5TWm/22osrnpb7LztvEvIjlK+v4mEfPR8BhMXGb?=
	=?iso-8859-15?Q?kM/e8F+hrjrC8eumoTVnEnScqO7iCr+g7IBuzB1bQC5XEO+pS+H8gLXi6?=
	=?iso-8859-15?Q?mKl3Y0qyyZKphZuu0epdMGIDaShkN5lwm4v/wTS6IMd5ovglLFay78c5a?=
	=?iso-8859-15?Q?LLyQV/Lgbuffm74Adj0cUedYrSacdQmgmp+ce1+AuxXOEsjgzVyjnwhu7?=
	=?iso-8859-15?Q?mXOGY4ki2akiE2yp2SIXZ8s44fMy8SktAj+APyLIbNOCHQD6gzlp8I85z?=
	=?iso-8859-15?Q?pCSCe9uP1ClKlsEPnRpLDGi3URo0W0pN+Z3COlkhZssgfKy1YnY2JX+IK?=
	=?iso-8859-15?Q?ayyXanuM6DO3hkMtJ7RPf6KODW8qHnvtxlUajriKG/1froqSUHbUirAm5?=
	=?iso-8859-15?Q?F7+ay/ApGqElyniofcD3H8Z3TAqSJSkH9ep+FsM/Q5mTfFLDcpjdiAHeD?=
	=?iso-8859-15?Q?r4wXhX3YcgVpqacNhrAinTSygFRvooH6kfrJh1P8uC0psDbbLAAwYqpcS?=
	=?iso-8859-15?Q?RkCw7RwAMiZCmbWmoQqySLdzMdNvB4By49q9R/pm5TLi0HAW7R3W41vq0?=
	=?iso-8859-15?Q?OsDTdzFyzvcGGMLenxwOTcGf0pZPaWS9RSGdZE39+JKnV4ih9AHGw7D53?=
	=?iso-8859-15?Q?JRX1MWXszueY3OHHbWaSD66FvBSTkn35tGLPNYR/quIKfTzBKXEeNH0I3?=
	=?iso-8859-15?Q?VmmLRVgrM1VpK/Hmt+avbzPkU8IK1b7tFlWNRMQ6kH9NTOKayQIkX5U1Q?=
	=?iso-8859-15?Q?Q4om1iGn0INVAaAf4iJXcG3bGypO95P8e66Nc/mGgz6DhlipxGRB/SMeq?=
	=?iso-8859-15?Q?8/IukqTrLov+Z3iNu2DaaPsehDvXDXcYJ?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbb7c4b-f516-409c-299f-08d95d7b31bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 10:23:14.5766 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M7SpWYPfNwSAGmwyfdUB1V8qClx+hMALtFv8AZdQwbiFhbD+X+N8BQNlhNwY1o/nTUpqQz4EdVBmaVL0Ym2voA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5385
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CANKMi012249
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] libmultipath: remove unneeded code in
	coalesce_paths
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
Content-ID: <09DC6A0A4722064286FEAF71CF2D5090@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Do, 2021-07-29 at 16:46 -0500, Benjamin Marzinski wrote:
> The code at the end of coalesce_paths() removes a multipath device that
> was just created/reloaded, if none of its path devices have pp->dev
> set.
> This code is very old, and no longer has any actual effect. Multipath
> devices no longer get placed in pathvec without having pp->dev set.
> Even
> if they could, there's no point in creating/reloading the device and
> then immediately removing it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

