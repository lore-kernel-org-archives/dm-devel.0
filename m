Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1979C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:33:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C75A6120D
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:33:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7C75A6120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-FIBRjyTAPm2wiyf5-V9CPQ-1; Thu, 11 Nov 2021 06:33:15 -0500
X-MC-Unique: FIBRjyTAPm2wiyf5-V9CPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A849E757;
	Thu, 11 Nov 2021 11:33:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BEBD19C59;
	Thu, 11 Nov 2021 11:33:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9C0D21819AC1;
	Thu, 11 Nov 2021 11:33:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBX8AO009490 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:33:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC3FE404727C; Thu, 11 Nov 2021 11:33:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E72D24047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:33:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE2CC8011A5
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:33:07 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-112-QHLIg53wM6yDRnyecGcXMw-1;
	Thu, 11 Nov 2021 06:33:06 -0500
X-MC-Unique: QHLIg53wM6yDRnyecGcXMw-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-39-_meAkuW_NDmdCraPVRXt-w-1; Thu, 11 Nov 2021 12:33:03 +0100
X-MC-Unique: _meAkuW_NDmdCraPVRXt-w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16;
	Thu, 11 Nov 2021 11:33:03 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:33:03 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 5/9] libmultipath: make set_int take a range for valid
	values
Thread-Index: AQHX1phjFPGX3ukiJE2LaxyajKjxqKv+MpQA
Date: Thu, 11 Nov 2021 11:33:02 +0000
Message-ID: <8425c4b8d8341369444399f50e9f3320388fdaec.camel@suse.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2aa1b04-84f0-44be-7444-08d9a50705d8
x-ms-traffictypediagnostic: DB8PR04MB7163:
x-microsoft-antispam-prvs: <DB8PR04MB71635E69D32D0EA85F008475FC949@DB8PR04MB7163.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KDa6xipiuVQDe2mC8qKkKQwDiXbfF8AkpcSniO288YKKL0jbqQz0Ce+BLgpZpeEm79NcVqCOlZh/dUrxWWlhV/ej/uFygtHOCJAqjt+IL0fHkSpYA/RRFkSW47r17wE+JN6shGaF5rHDfFSXmzUcCZB0uqpGUOTSNr+KDsAbsu/jHTvcSuEnRJvyLg0GxIkoAzdyvTOhdkSsCzYikbqW8aDGkt8fMq9cBll9YJP5wkoBgOE/+WeSwyA0PYmHzWZik6w0b1WDjr8/w+g90YPbv2Q8MpOAFzGRioRdyZPLvTIgNeYNA80rnJch81qO9D5eoC2DgKMi2phDm4JLchF5nxyrsWU559PQp0DcjQVe91+rmV0ZrlHy0d2uC8/KQX9keaeIET9eXdFI903pZ2F2lk4iuNSR5buxyqm4PJgrbvjIOAkuhBxrIGu44XmIo98NJp6Vf4E5SEeyWuaYVqGz31P81DqTJupFRmJ+9QX9r7sudNdrwFE5adCczLg8TyBPKaPieGQhJgVS6wQz2F3F2LbJDQSH+mtSA+QAriKDi1EgbPcXyPt/jT1vUKS2rTD2yP+KCsGkmNxRpq2GwoPw72Dpar5e6PyrbOAbmo8kXOw7Mi3TNlCUmQGIvuo/0cGwskImYRYa2PJtkyrhyIKMtk0VOgATTUEDYv0HLhX7GgzHe6bFTCpTc82TSTQcPUDGUkrj30uQWxY2pLRvMqHbfQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(76116006)(2616005)(83380400001)(36756003)(86362001)(186003)(66446008)(66946007)(38100700002)(64756008)(122000001)(66556008)(91956017)(66476007)(8936002)(6506007)(508600001)(4001150100001)(8676002)(26005)(44832011)(6512007)(4326008)(5660300002)(71200400001)(2906002)(558084003)(6486002)(110136005)(316002)(38070700005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?ReRDAezNlyGn+9L6dfv8S7KlFlZgo1ze88LM7HiBwtbYNiMHyueFM3Acw?=
	=?iso-8859-15?Q?8qipIIO3AJoeU7MVrGmWpo4SquOsR0uZAyoOdPLa3AicsAEybo096MoN6?=
	=?iso-8859-15?Q?vZyoohKjhq8GYknSGxdWkHO66hR69bNY9LUdYJiHhGfEQJaOFczd1k7h/?=
	=?iso-8859-15?Q?CHGOTlQpagY3YITuydoFjB4Wh4zUQbh+MGfLBRczPPIQG+3gf/1I76Qjd?=
	=?iso-8859-15?Q?qCsYr1qZhpXOIJQNaTTdJYpk19W/egQAWrPreUBC5Vgjiux0VAogatnBj?=
	=?iso-8859-15?Q?8Xi/Kdq3J0rAcrdT3E/KPQaKbh1VBT0gx5n26zuvhgkCusneY99uR8lRo?=
	=?iso-8859-15?Q?x7Jhi6d+yZJWtKjACz8VqlbEZQzeXaEsF/DMXO4S21EOSHavyKjgzQdJm?=
	=?iso-8859-15?Q?lfbtjjGdRUO5+1YxRa67n4WLpZ7usMS7Aow8w5gsmjpznxr6dSzNFOvG2?=
	=?iso-8859-15?Q?SomOskuaFuRg8vqNYNSFbh3QHktAE87kssG0PeD+OKsZ+JR3tMcw0wkWk?=
	=?iso-8859-15?Q?HKWlwIPEaYhQZxcNCeTZZ3juyZQcY51Tw3UVZWmIr74Jt60Jpp7Bm/3Ii?=
	=?iso-8859-15?Q?7K2tZqw4RARLho75S4bmYiv+NWUM2Si6JB6ySQpe5Gjhn6pGIPbYDjqTn?=
	=?iso-8859-15?Q?fTUehrgSVPv48UQFD/N0v3k/u5yi5u+uaO/we87elF+AunPOoivZaSJ3q?=
	=?iso-8859-15?Q?mGw9BslGxdSm4iutvjxY1S4eE5YytJeTOu2Ba+S7/6ooCSeIlWNZaPwaF?=
	=?iso-8859-15?Q?9rMLeWSzuAfW1wwWSsatbp53kCwLxjATrf3ljmxBecv5zrb4bN9nwflE9?=
	=?iso-8859-15?Q?GUDgRIfeOIrOvTpRxVe0RzJkSEpFrPEum7mWDNSLQX5t5unrz6z7iht5I?=
	=?iso-8859-15?Q?fc5gVSDFrB8mPQHv0txs64j25EiVqwmM1Xueb46KTf7m0jo5PfPJyRIEQ?=
	=?iso-8859-15?Q?qOOVA/YD5b61bKkOaiqmURaiq40DhZINiRul43F1E+x72egj3DQIuSm8G?=
	=?iso-8859-15?Q?x4ANqEaj9UkHkGjxlmjr16CmvEQp5A26EscvUfNFiRuSxEBkS2qaIwCdh?=
	=?iso-8859-15?Q?SnUexUd9ry5onLcuWanjYITtWyiS+UvnStZtCFHiYWi4eWJ67zDqGc82A?=
	=?iso-8859-15?Q?/eqpm3cn4DPcdl0LtEsdZi/49qy+AY3Bo8UL8GOWRZFniDVMjANoKixtS?=
	=?iso-8859-15?Q?LqgWAuWWCp5RsaB1nD/z5ZoZsSebUe7WqVbIaNE+c/TKxVu25pQix0xaI?=
	=?iso-8859-15?Q?MqPLzGuKlW3wo3PwY4l+EAo69gCfug++iDHsWIFQsnHLusO9RHUszx3Az?=
	=?iso-8859-15?Q?hH0jCZI8jg8wkO0iGry04eegg2i/LdOWTNTrZIygVX5nHTAX5OxEun4by?=
	=?iso-8859-15?Q?eoMkTacTJ45KpBXMCjgA65FRwS7kUdvk6kh2Vxmno6RRaXlJrF351MW+D?=
	=?iso-8859-15?Q?Z4ANtyVlUcE99EbLnj3RrBnPMWYun0Wu7kNDY+mrDiL9hgtj5bvmLowL7?=
	=?iso-8859-15?Q?IoTh8Gu+s5AMazcfCs4KhUTIfGeZxaWkUMYKByshAq5LYfTYtuCiGODRA?=
	=?iso-8859-15?Q?5w5K6KIQ4ZEeidbEBYfEIm90kRXRDfNUfb8YY3LQ4mkdUi7y0/N6rtfBl?=
	=?iso-8859-15?Q?QHoRMmKa8NnAG+5JEyDukj+If5+fBkB2jq51KL6TU2ILcOSoh0nGNY1SC?=
	=?iso-8859-15?Q?kXF4sg+ChVi3yqO67HMxR5Ib6i/tyCadB7lgI3AcQ8jv2gw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2aa1b04-84f0-44be-7444-08d9a50705d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:33:02.8922 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHyJrCG0++fVX7oUz/1VsOpPDz681PujBDol132zceSIuwu6Ez0/wqdZaMUnqYHUeXp0Nq6F7X39bME8gVLNAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBX8AO009490
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 5/9] libmultipath: make set_int take a
 range for valid values
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
Content-ID: <AE9B2A659B609E458559F083B86BD33C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> If a value outside of the valid range is passed to set_int, it caps
> the
> value at appropriate limit, and issues a warning.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

