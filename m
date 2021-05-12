Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8EEC433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 12:42:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 695FD613EB
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 12:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 695FD613EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-u8UxLwE0OxiOSUkXClRh6A-1; Wed, 12 May 2021 08:42:14 -0400
X-MC-Unique: u8UxLwE0OxiOSUkXClRh6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDA24800D55;
	Wed, 12 May 2021 12:42:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C94AF5D9C0;
	Wed, 12 May 2021 12:42:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72B9E180B463;
	Wed, 12 May 2021 12:42:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CCdRB3025324 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 08:39:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E61DE106A29; Wed, 12 May 2021 12:39:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF569106A2F
	for <dm-devel@redhat.com>; Wed, 12 May 2021 12:39:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D257F18E0922
	for <dm-devel@redhat.com>; Wed, 12 May 2021 12:39:23 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-370-1p0ZxJNRPEyyna6mY12PLA-1;
	Wed, 12 May 2021 08:39:21 -0400
X-MC-Unique: 1p0ZxJNRPEyyna6mY12PLA-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2053.outbound.protection.outlook.com [104.47.1.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-25-aT7upv0fMM-QISvR6cBtCQ-1; Wed, 12 May 2021 14:39:19 +0200
X-MC-Unique: aT7upv0fMM-QISvR6cBtCQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB8026.eurprd04.prod.outlook.com (2603:10a6:10:1ed::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27;
	Wed, 12 May 2021 12:39:18 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 12:39:18 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/5] kpartx: Don't leak memory when getblock returns NULL
Thread-Index: AQHXRrx93xDRDd42AUWukrTHpa7A+arfyiuA
Date: Wed, 12 May 2021 12:39:17 +0000
Message-ID: <542c47bb8f0f45619fee8a01588a7c5eb308cccb.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620775324-23984-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b0ebedd-8554-4680-9975-08d91542f57a
x-ms-traffictypediagnostic: DBBPR04MB8026:
x-microsoft-antispam-prvs: <DBBPR04MB80266A3EC7F9C7BEC864F52FFC529@DBBPR04MB8026.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LsC0sLW+9QqaOOy7luvYom++QyOquzT8jLRuPnvimCHdFttTBmX4x9Qs9n+TNpLhYC0MtTQHPLGbedqQpvPIFr7lgOiRorwP0slIiFlF4PYTm5kvnLn9wHnuvKpejJDonnfH1llKQaW1CKzS0ppDu0u7di0cC1zpTnDUWxZHJ634gxsujrwa/ZZRJPe0IvLPzNPkljFx7uwugQFZKDP+S3f8p+cxP68mQiVn3yeIrODGu1eIxfGTbLU74IkrLcl9LB7lYDxaHSX46KkkGepLQWA0ItSPKfDA+rY4DOPNjUigwFcJq6zMeYBoy5nHqVLnXF8yNuOVYWJ7WXr1+o82KaJmkXnr+egAjwaX1eug6XXF3J0d2lNk+7paRQe7rB/UlDsUUO1tfGl46N6P7HcoocE/eKjL8inTFTus7wjtDl924GOen6wgy+R0fQocyMmcLfQsNt8e76pYZdqp1KA/UNJ98Xy86c7Q58+QrPmBZWDM1D0VaZlaMc7nTmG3w2ctEzPuZifHITkOxQbsoUWqjl+klUuBcN8WNRfZZ11c/ZVhUYyMCgLaKJlWFb+7ACREqq94xXjxQ2l7uwHdLNOajdFsP5YltB4qijBwGwdoT4M=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(64756008)(66556008)(5660300002)(38100700002)(66476007)(122000001)(8676002)(2616005)(498600001)(44832011)(110136005)(6486002)(186003)(36756003)(66446008)(2906002)(558084003)(83380400001)(26005)(6512007)(4326008)(6506007)(76116006)(71200400001)(8936002)(91956017)(66946007)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?sPGH0/oCGsR3YXTJ2eYElAl9eXQPkiNIj7K2xip4kasSfXUEB+7+ZCvB2?=
	=?iso-8859-15?Q?1dsIXUn8c2zbi7Raf6rNbyXMJCeSQ6BVqwrYNFTwr47MQ2IDhXeBvNQtK?=
	=?iso-8859-15?Q?aHM9TlyjsSfaxdPFuYc5pnUPm0LeRJy143kUi/x1kDkFR3ZPGLG8PWLnK?=
	=?iso-8859-15?Q?V7nivIPupSSw0rzNCGJMHpjzf3mKT6SoAuJGW63AygtraKKSwq7XyITNc?=
	=?iso-8859-15?Q?209TrwvO6Zdx7ocZU+rwkOY9ruCAFc+289YaWvqN9KJelgaE6v0iXi1lp?=
	=?iso-8859-15?Q?o+YqOgmtb4Uxj/Qc5/c8VBfdWoYOvTvx1qh0XcDcXVBVb/E2g8N8vm6q5?=
	=?iso-8859-15?Q?XT5HwKtsuGxxaRn+mQ4Pee0KsrYe5410N0/uR9LSP/WeoQVVpt7/5APG3?=
	=?iso-8859-15?Q?2JBlPP9f55jgOVC8D7TUe3umcGaqIYadZ9XzC/U85kpP8sUaJJXMOVbXH?=
	=?iso-8859-15?Q?X1IeFwmV4rniWQbCx/HopI/sBb2MD5n6YJTW0fgMbk6Irbkb7JObdqvus?=
	=?iso-8859-15?Q?1OhVbuI+GzSNvMA0y9k5AcZJ4NuEEoKyyPyu/XY9UBAP2Ke9f+am/PwAz?=
	=?iso-8859-15?Q?WADskA7DeaymSwWonIYOa4E9nUbRFrtYVRt2sYDTTmAtZqHUTzixLwTbp?=
	=?iso-8859-15?Q?lBmsxY0pSGBJRpfSzklsFCB63hWKGt03ov3MFYoGSak28PyqUwCvoEZdB?=
	=?iso-8859-15?Q?mRT0rusLoI7u0UQo2d1mbLlym5SJvf85lZVmcrsrJYWXFezp0tEY3oafU?=
	=?iso-8859-15?Q?X2Ww+1PxUokkfrtv1jJ7C7zyqz/ea/sg8lUKdrb+HD8UPozLSXu2BfKiM?=
	=?iso-8859-15?Q?EnaQS42UbbY8C0ggFNvf/c+ojhBbKC8smFjucqw7kfdhxxbF1QZD1OBpB?=
	=?iso-8859-15?Q?sqbLF6RO0FCvymRmb4If4AeJTTWF+QhGJAGjW3AV7lrzZsoITFymJSMCd?=
	=?iso-8859-15?Q?CUiqyxf0LrMRHsxeFe+9InZ9FuyjLzYy7XOcEnDi5s1MeUZxR2BBXF+/u?=
	=?iso-8859-15?Q?aZqmx6Ht03rVdbw/0Qcx3KhuHqOxhJrkkhBgDi80s3kQERDTjkx6erO7s?=
	=?iso-8859-15?Q?BvOPBCXdBBmVoDNc6yTPMQ2344YjIEBOibuUnphMCzm1shKlwyjoCSOdX?=
	=?iso-8859-15?Q?rtDxPmVOaeETab222eFIfaYLxrGzQ9rkO5TcEhmPwC9zDqP2wryU1MAq7?=
	=?iso-8859-15?Q?KS8mNT78u6Lj4a+z3iT0pTF8rwVEn7tG35TjKyJ2VKuBRm0IFO4yVd8ss?=
	=?iso-8859-15?Q?WbmJ3kozCeSkKXwwwTgACxzQE4XtXyW2UsTFlP0khf1fR34HxHzlvKnXA?=
	=?iso-8859-15?Q?eLN1vQHXwWMnDiMjK3kBB8NS50SlhYhXwHQO6r7/CrPH6zpVy/wpLyytU?=
	=?iso-8859-15?Q?84E+lAWVo7W3DYSg2C63hDCL5+T7qnAnz?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0ebedd-8554-4680-9975-08d91542f57a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 12:39:17.9133 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PurMlcf0YCj2zYTpHTF01/DxVDoB44zxwASjdbujFpBoy0IiPD1QNKmJAKpzaVGDz0TiFlgs26oPWdIsSSUdrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8026
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14CCdRB3025324
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] kpartx: Don't leak memory when getblock
	returns NULL
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <334EDB208D7E2B46B98011E06C143210@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> If a new block was allocated, but couldn't be filled, getblock will
> discard it. When it does so, it needs to free the block to avoid
> leaking
> memory. Found by coverity.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

