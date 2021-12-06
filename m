Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C58C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Dec 2021 13:58:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-sw6-ycFyPsSzTHjYShJGvw-1; Mon, 06 Dec 2021 08:58:46 -0500
X-MC-Unique: sw6-ycFyPsSzTHjYShJGvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC2151808320;
	Mon,  6 Dec 2021 13:58:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D597760C81;
	Mon,  6 Dec 2021 13:58:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B53BE4BB7C;
	Mon,  6 Dec 2021 13:58:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B6DwapB019929 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Dec 2021 08:58:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B0F03C15E74; Mon,  6 Dec 2021 13:58:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB92EC15E72
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 13:58:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00C5D185A7B2
	for <dm-devel@redhat.com>; Mon,  6 Dec 2021 13:58:36 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-219-oeI9kT8lNZSwi9B6AAKZTQ-1; Mon, 06 Dec 2021 08:58:34 -0500
X-MC-Unique: oeI9kT8lNZSwi9B6AAKZTQ-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-2-gnH6OjXuPVqdxANXawHt0w-1; Mon, 06 Dec 2021 14:58:32 +0100
X-MC-Unique: gnH6OjXuPVqdxANXawHt0w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4218.eurprd04.prod.outlook.com (2603:10a6:5:22::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21;
	Mon, 6 Dec 2021 13:58:30 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%5]) with mapi id 15.20.4755.021;
	Mon, 6 Dec 2021 13:58:30 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH] multipathd: handle fpin events
Thread-Index: AQHX4cN3WHkLuxT/XU2rhrfCJFDyLw==
Date: Mon, 6 Dec 2021 13:58:30 +0000
Message-ID: <bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
In-Reply-To: <465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1baa14bb-2c72-4510-368f-08d9b8c07c4b
x-ms-traffictypediagnostic: DB7PR04MB4218:EE_
x-microsoft-antispam-prvs: <DB7PR04MB421816468301015CB3A6D95CFC6D9@DB7PR04MB4218.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: i7s/hcMneM1FLn3txImSEDHjxe+AW8bm/ZdmykzxvWbFBgh2ekLbKd/6YnjwR7Hj9lU9rgF2q0QSnPDphOKYlezgSjxFV99PjFibQo7o3za9hMig3LpvHMuzbHjA443KTl7E4zYgK0mm+fLnklEihfJntcAaO4CrQjiwBQKvvXRqAmMRYfAKcB4bFqSQLgX1i1cxmYAsVgwqZr2T0NHzZO3nvRYIQyuIXsCu4ACA1ucrJKhYvqqqj2OwuQwim05RnXjqX7wlYuCwlq/5iII/zYCouoNZ8Zun7+LZvqcu1jrfIchdze2KGDf7r5RsiU/C+84+DhjOr4xexDUaH2V2j6dkLpVk5JjyX7q2zkXgS7w9wDxi0oYEKh2iql+IzIj2CnuMdFkcZfc1vOg6yZ+KEDcPkdKhjbrVnwlDpI5954+3kitKl2OoCHghL9EwvSiSkY9w/BOllj6JLjkFj/xlyoBT9CZcu4S2K63moprZ/zUqe+wlBTsAANihFus2mNw9AzuT8Lm/tErtwhFFLEosZ5fQ8bbuQKbAn7yDH8VmHnYDDJlCoiGTP6dX/wZoc6nmHZEHIGuGbGqqZC5AwKQxqU7Q4IAIiAjpqlobXMH2oLqpOLzLZo+ejkRfdt3FtPCNQAg1WlurVlu2x9FmU/6dp9Be1Odft6b+033/ImLqLBNCS+JnXdMUNMIJhRdBldYpO+QAPSJzkHtMHeWaxXip3g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(76116006)(2906002)(36756003)(38100700002)(6486002)(66556008)(122000001)(64756008)(86362001)(71200400001)(66476007)(66446008)(66946007)(6512007)(91956017)(38070700005)(4326008)(54906003)(8676002)(110136005)(8936002)(316002)(4744005)(44832011)(2616005)(83380400001)(6506007)(186003)(26005)(5660300002)(508600001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?IzOHJxxiTWOxDFpTvOuOt8w6vB4GC+bfoWxpbdwGClrgkYaXoyCiuCHyh?=
	=?iso-8859-15?Q?eSOn5eAsPVwjsEXoCpH9AXhca38Le1YAjFjrj600MIqWD25dA3qbnBII7?=
	=?iso-8859-15?Q?EXthb2NF2rN2KYhgn3mxNhjowdo3AP5v9UDc68McCIcWAl5te26elCn8L?=
	=?iso-8859-15?Q?mbQRwpkyTl4PP4lWZXwSYyQFlvVtYf1o3sDYUH8DyNHJXkonnSbaihi9I?=
	=?iso-8859-15?Q?5FqmcLqTWnl7K95AyQfsLImG73Td2R6PiyU8WI1VEx1Myskn2jYBoDg5b?=
	=?iso-8859-15?Q?j8sm3FwZsRKbYm7+j3zUrNOEcLd82IqhKCUB/s7BlbHUfYDaI8e2m4g13?=
	=?iso-8859-15?Q?j/vBNIKyX+kBHdCEJ8xglSG8qxKVLAdiL5w23lggxVX3w2EXWJvvLpehs?=
	=?iso-8859-15?Q?RHgDg+4LQPjWP57LehKfCG5UhJK1YHYJVmC/ruU9dmYys2KVRoFK8bUor?=
	=?iso-8859-15?Q?59D7xL9isBuUk+72YDPBSW9juTdn6mnbQx2DNt+vKmkPrIv+GO35CTfCN?=
	=?iso-8859-15?Q?5hfnNlrGfDMNVxrDFb+x39xKG9oMnu6U9rrXwSzVAt1r/YM5UZDyE7qrw?=
	=?iso-8859-15?Q?6UE7G+50X0gOoO4X4RuNBrbKfiChN91fAwkIIN85y7SsYtRsJT+ImyIlm?=
	=?iso-8859-15?Q?tFkcx66tvxZ7LvImEvLj1PBJwJ4d8TaZPKtsz5mFkK97JJ0GuAFAm+su0?=
	=?iso-8859-15?Q?X22c1MB06+lHgw2HbnTpF00ULFwHXUToO/4JUlS2ekQ6k1GU3MRth/BTD?=
	=?iso-8859-15?Q?HNZd3piaZ4l1H7yioBauZoxrgS+enoAFwa+sNbOOSJEWIDb0Q/uxvT6bu?=
	=?iso-8859-15?Q?X6urL0VoT4HAoSFFpOX+cPMgO2nR3VbVHdem9rqvWujUoWFDSwDoaCHpI?=
	=?iso-8859-15?Q?26ie4qHZaMdyLu30BFvCA1EjStfEzQLmDmyhBKa9I6QmJ73aMcuwo12nL?=
	=?iso-8859-15?Q?DCJ+5SwWJ88coleOicP2kQBZpq0wtBEdtDrdn52sluCcWHSVHsBdJkWLt?=
	=?iso-8859-15?Q?YPSDn0At/bOTSR+9lPmZ4y3HZXLbqbc4tS01dmg67r/wF6/0FoTEytrY+?=
	=?iso-8859-15?Q?XIrh65rCpBmEIkXBB2hj1bg9ai+kRZgE6m3q1R+nIUzf9hNr5/MH+JubO?=
	=?iso-8859-15?Q?nRQUqmNGHto430kYjdnt5mdAycY/WTUiSmC8vcSk/dVjT8DRQFriOW3d6?=
	=?iso-8859-15?Q?vRnUXm2IwrQjFHMUQAXE3mqQhbK2t7KpzEc5PSLZWXwRIUN+6t/TFIgbj?=
	=?iso-8859-15?Q?wo8K+9+Pl0HzfSRm7gti9Wu5+VgFUyJiHbj9qiYf2t1FwYVVaIIq4NXmk?=
	=?iso-8859-15?Q?qqToRJM0TXPqL6J6TginTh+NJCuhpuRFYtS0dqvUTQa3u1XLardkhZ6DD?=
	=?iso-8859-15?Q?4TyHMuenNKvLoKyx4WWjNvuZ48DZLOI7Y+1FQY2PKaFR0Xzf8k1no+c0r?=
	=?iso-8859-15?Q?IeEa2Bx8TmmSD46ZTzryOUP9eXY+cBzGjoJQZR3MstnvGC3oZy8l01XjZ?=
	=?iso-8859-15?Q?mYQXQBbPH/4MkT0KM3UnXGsysrLwAMAlWKq9u+/3N/nL3WuYOAukGRS4K?=
	=?iso-8859-15?Q?NYfYMNrqz6/PFPKDKiQ45phM0kJdHDQPwZQ5Mz5PiVxtYAv+qZsmkW135?=
	=?iso-8859-15?Q?ccK5S2ZFXQgzBfNtSXDHNOBoSqIPAOnqmwJsogEQ0mv+f4mFA17cEwUdE?=
	=?iso-8859-15?Q?lxoHhJrWQ1Sgl2Fvt3B8nEn8AWI2DUdEk9mLXlIlrZkM4MA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1baa14bb-2c72-4510-368f-08d9b8c07c4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 13:58:30.7221 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oon0vgMlSkxSM4LxbBD3USrPDUj8FOrnOlf5FGtGfYaRdLLGC0PxqJY63yu1f6yYdUMDEVt1XvKUnY8/PgUnBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4218
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B6DwapB019929
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A93C1B127AD45045A059DC040AE39DA5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2021-12-03 at 18:02 +0100, Martin Wilck wrote:
> 
> 
> Rather than adding a new config option, I'd prefer to add a new value
> "fpin" to the marginal_pathgroups option. That would make it more
> clear
> that the two are actually related / exclusive.

Another thought that occurred to me over the weekend: FPIN is fibre-
channel only. What if someone has a mix of FC and other transports?
Would it make sense to use FPIN for FC paths and "traditional" marginal
path detection for others? If yes, we'd need to change the logic and
we'd probably have to add a 4th mode ("fpin-mixed" or whatever).

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

