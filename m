Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A15C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:09:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A16D464F85
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A16D464F85
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-A8WCQmddMFeP3Oy52eWUsg-1; Thu, 11 Mar 2021 15:09:41 -0500
X-MC-Unique: A8WCQmddMFeP3Oy52eWUsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C1FE92503;
	Thu, 11 Mar 2021 20:09:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED05E100AE4E;
	Thu, 11 Mar 2021 20:09:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B2FB38E1A;
	Thu, 11 Mar 2021 20:09:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BK9XXj006808 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 15:09:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 99A6610CD6CF; Thu, 11 Mar 2021 20:09:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93FA610CD77E
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 20:09:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1064D800883
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 20:09:29 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-360-lvpwvUiwOVGHyZ918IiPVQ-1;
	Thu, 11 Mar 2021 15:09:27 -0500
X-MC-Unique: lvpwvUiwOVGHyZ918IiPVQ-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2057.outbound.protection.outlook.com [104.47.2.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19-IaVnyCEKPCuJE5JC6S4nGw-1; Thu, 11 Mar 2021 21:09:24 +0100
X-MC-Unique: IaVnyCEKPCuJE5JC6S4nGw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7849.eurprd04.prod.outlook.com (2603:10a6:10:1eb::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17;
	Thu, 11 Mar 2021 20:09:22 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Thu, 11 Mar 2021 20:09:22 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 2/3] libmultipath: cleanup uid_attribute checking code
Thread-Index: AQHXCnb/FjGEm6nE1EippvURWXdz3Kp/T+qA
Date: Thu, 11 Mar 2021 20:09:22 +0000
Message-ID: <2df9c569b5354c541688d14f80e076c1608ba933.camel@suse.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
	<1614148402-19847-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1614148402-19847-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c762d29-9224-42d8-5a19-08d8e4c98ff9
x-ms-traffictypediagnostic: DBBPR04MB7849:
x-microsoft-antispam-prvs: <DBBPR04MB784915111A49D9F8265B8991FC909@DBBPR04MB7849.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eV4x9dA1Z/vymmw+FKs0TiXQB5GBTza1NGtXwDZ/Sl87yhrarTjyIIPCpp9cWdGDhnYr9ep3x+tLsY28L/TrkMzLlpPfjAy4PVvPRvIqpUWyxHCUMtMTrEavBvO93twBMoynw+C/+gjzDL0g4aonMMm+rsaQU00plSY2IXP50whQGkKeH+ARFNEq37sXuf01i+04K1EDE9CddmXgSKTAEZ1FpyuvS+06ztyDypREufulxo6a/v5+QjoZ8KAIExX+j9W38AWt88x8pnrfAkkMYr2hxDekMGj1BUDjmCssT7vz6HwqoaUwIzrwJ5mMFPH82gPYp/mqlVMyKGLWjO34YV6Fk6kP9oCWXznqp70M0IqF2/6Jqhf0CwbU9BioGlyIPyUU6l2SEDfq1X5WuR2MmhbqaaHGo7Esu/TefTmYPagZ0PeVOVwKvBmChG7rwrr7tIDYNzmzy1LQi1PDXZO4WK3z3RCvH183JW6Ei3RFLv7wFP6jhSTng2o0g9Uu4Oyhf7z5F/lvNuFPbB91i9ASiA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39850400004)(346002)(376002)(366004)(396003)(136003)(91956017)(64756008)(26005)(66556008)(44832011)(76116006)(83380400001)(86362001)(2616005)(66476007)(186003)(8676002)(2906002)(6512007)(8936002)(4326008)(316002)(66446008)(478600001)(4744005)(66946007)(6506007)(54906003)(71200400001)(110136005)(5660300002)(36756003)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?86iKqF2f0F9QiTcGMceVTq79YOAdIZoiD2B6nuXhk7LOeiQ3niDxc+TZM?=
	=?iso-8859-15?Q?6D3naklCb062I1gq4y2lFJ+ARgTnBf5YYB7rKQMLyqxv4F3uhQodIGIYA?=
	=?iso-8859-15?Q?MDesoAh0hdLj7/94eboc8kb0RfId/7wvthcHwt4xy1heCu9IFLVhPcddJ?=
	=?iso-8859-15?Q?93mhjlRa7LYNie10XBWeFUm0VdVF4iFacncvdsM96IZoTTv0zNcpm4ggW?=
	=?iso-8859-15?Q?SwE8kB74jkOvZIa18XykwgYKkHg9/ejDJgVLqWDwHqO2RisE0LzcdkMHR?=
	=?iso-8859-15?Q?EyK+TZ9Ah+j0qVZsnRyQyrmDs08PF6tvLF2nD70ZGpAA99jq0Fq650+pr?=
	=?iso-8859-15?Q?UaApsjRqZVfwU19a7yaDq66yDhcfx6BsQM9omEtD0fir/b3DufcGOp3mp?=
	=?iso-8859-15?Q?lmTLLylko98Rk5pKZ6BqpHPFB9QZyHN5Hv2JD4oU214x0aoiuR8+Il3QT?=
	=?iso-8859-15?Q?+9V2dugAbHF65+1qkJZbIjDNyFDRwECaUEq6MDk6pXD7GIBE1AvmiwKgO?=
	=?iso-8859-15?Q?2ZhTfGtKVqHkNkLyQeeJ3a7mK0sI9LkpHEzPTkWkLMlRYT24co7UW1uGf?=
	=?iso-8859-15?Q?b2wVkgwGyoTDOL0A3Pq38QzOB2PDNAIyT9FBnkB6XjBszLu2hCGUZOnxG?=
	=?iso-8859-15?Q?dUiUDQyj+tbqLXIjooUv5w9L6uih6XPAgwLdX4MIEyma4519JQuW0lKmx?=
	=?iso-8859-15?Q?I7Rs6XawBZB81TXpUorlV9wJrfKuvVlS3ZIGPzY6stpdeTISh20wx5l3U?=
	=?iso-8859-15?Q?DWQKzrrac2zyJButmeodw9JRvjajql++6tXjsHolKKzwvBGH8FjqII3YR?=
	=?iso-8859-15?Q?SGBM8oFKSGPGc19TbHO/Dx6hU45rDahSMQGsSjTttzIJUjzXzQmPTiKhC?=
	=?iso-8859-15?Q?rQs1EAYH2p5IJZHs9plPqbs/Y8F8uFkLXRD5y0OjKeAfUep7F4Nb5MhuZ?=
	=?iso-8859-15?Q?q9xqmzUaYl6V55NJqwA1iRaJqIsCnEy90LkxbODXU+IwQjswvzFkYuKFk?=
	=?iso-8859-15?Q?WSoFOfEfJAP6SAJ7PQVyw0DdLpWPl3gpuDsnUQcnsiYpA5O84ZUJxKDIp?=
	=?iso-8859-15?Q?p9/HGCZXEE7GG8NMYXPd81ZVI5ThqkXNAG5vqgtsEDApNoLhM0Ze6On0g?=
	=?iso-8859-15?Q?xviA6GZFaUDrmVQpmuDRYfsTv/YIcqvOL9YLiji5NtHfQu2pO5zhMCN7C?=
	=?iso-8859-15?Q?7q/XQEdxWl0nKWofnTfPFVA0OTX0El4Pg1cVpDQzhaJp5S5sXf0Tz0Z3M?=
	=?iso-8859-15?Q?kNAU/xBDGX1AO7JnX7Pkf0iP8x3MvNZiRg/gBcwmgNz6A0gZadb3HWNav?=
	=?iso-8859-15?Q?pct0QjHIso/z8idi+iwYb4oNIYWyQ8Orwnf6QEo5HCzIme4dyZSo9S4hT?=
	=?iso-8859-15?Q?SILgaXIHmYpsywIkaSMJBBoByVEib7Wxf?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c762d29-9224-42d8-5a19-08d8e4c98ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 20:09:22.6788 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aL2H21xiGKHuUPY3XKH50dN++uihznaEmvxoXwy1Hg4szb4jrVKdXj7rCi4n0BoDsrQA+8J3i9JX4GkpiO99nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7849
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12BK9XXj006808
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH v2 2/3] libmultipath: cleanup uid_attribute
	checking code
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
Content-ID: <F626AB6B027D2E49B83BDE8A5BD79503@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-24 at 00:33 -0600, Benjamin Marzinski wrote:
> In get_uid(), if pp->getuid is NULL, multipath will check the
> pp->uid_attribute to get the wwid.=A0 If pp->uid_attribute is NULL,
> nothing will happen in that block of code, because both
> udev_available
> and has_uid_fallback() are false if pp->uid_attribute is NULL. So
> instead of multiple checks if pp->uid_attribute is NULL, just check
> once
> for the code block.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

