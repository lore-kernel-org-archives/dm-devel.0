Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AADC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 20:43:46 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-3Iryk7i3NemIl2PSdWMLNA-1; Tue, 15 Feb 2022 15:43:42 -0500
X-MC-Unique: 3Iryk7i3NemIl2PSdWMLNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A4F1091DA0;
	Tue, 15 Feb 2022 20:43:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 038ECE2C9;
	Tue, 15 Feb 2022 20:43:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 130384BB7C;
	Tue, 15 Feb 2022 20:43:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FKg3ZZ007163 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 15:42:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9457F202699A; Tue, 15 Feb 2022 20:42:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DD892026990
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 20:41:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BDDA800B21
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 20:41:58 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-190-QqwdCz9gNKCx_CUIEFbX0Q-1; Tue, 15 Feb 2022 15:41:56 -0500
X-MC-Unique: QqwdCz9gNKCx_CUIEFbX0Q-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-39-NnFA8BCyNXi-KnEL8sEkLg-1; Tue, 15 Feb 2022 21:41:54 +0100
X-MC-Unique: NnFA8BCyNXi-KnEL8sEkLg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB7122.eurprd04.prod.outlook.com (2603:10a6:208:19c::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19;
	Tue, 15 Feb 2022 20:41:53 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Tue, 15 Feb 2022 20:41:53 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, "maier@linux.ibm.com" <maier@linux.ibm.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/2] libmultipath: support host adapter name lookup
	for s390x ccw bus
Thread-Index: AQHYIdSXlneEaAZ3oESYoO1IvMaoxA==
Date: Tue, 15 Feb 2022 20:41:52 +0000
Message-ID: <225eb45b2f6b14743b0ace392679964912b188d9.camel@suse.com>
References: <20220214185559.28363-1-maier@linux.ibm.com>
	<20220214185559.28363-2-maier@linux.ibm.com>
	<f122514cab837e0e613a105c90335a91f60a72d0.camel@suse.com>
	<33ffe0bf-7ffb-4ca4-91d0-fc55ea67c751@linux.ibm.com>
	<b862a5941dcf0fbe6dbec1798c983e4d649393be.camel@suse.com>
In-Reply-To: <b862a5941dcf0fbe6dbec1798c983e4d649393be.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b77ff9b-cd8a-4ac9-11b1-08d9f0c39940
x-ms-traffictypediagnostic: AM0PR04MB7122:EE_
x-microsoft-antispam-prvs: <AM0PR04MB712294988BB118DFE83FE762FC349@AM0PR04MB7122.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zYNyTk8CAl8oRjikkn8NXq51qUzOewmo6F6lsk3j1bGF9Mr3YAuptZcOXJNa+OB7KQ8StPwV90G+Bm/itwCfPV7RFCYLF6EP6v28TVGQDcxNQpguTUmwdLJKCVHibl5TiYDuiAl/Y9BNxIrBYOl/RUaFtFjNOT1PrYuUFHjXQ62eF7PQJ/Ghd6u8sNrQNOGmBtpyPKTJXXIvsmfGEddSpEPda1b4pCzJehnNRjg//CV/ecUdXS0BiV6S8TzHKatAchbWl8nPnWus0FR3PkJW9s6q5lGH0A4mdbePaxJTf179gVvSa9Ctrzr+xncKkokhgtIbsw8EvSvmRg+ypFDQmQi7WJ06NjbnSCAVzvwdR4H/KQ29PSjnZ+9Ea1IZXfnsTH+W0qzumOmkqC2kXocfLvMZBJ7/AohdE/7AVUV9zA0OaiTeLwuRr+074XhTICFz5OVvPStUcPOY9P9xwhxUPrFdiLO5YB5oKj+LlitgwMytS7ApsD7OaaNRBWgfTjCon0oXNpSHmv2xMJg3tA/ccYMFGsAITj0FPsBlSLl4wspzxLiQXdmq6J9KkB6dozX+m/xbB72qXrYn6RvFxqb/YUIxthQB6dNXbyQJZD+dQFlWs2E1YOQYyNumvTUtFuZpMV2AfbriRMVFLKOeeHT5SV0mL8wDiWMGaF3/wfu71Ves/lneOpwNIFPZ/s0iF/+cnn14lUG0lQkOkPR4PFB6yQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(122000001)(38100700002)(38070700005)(186003)(8936002)(316002)(5660300002)(4744005)(66946007)(91956017)(8676002)(66556008)(76116006)(64756008)(66446008)(4326008)(66476007)(2906002)(71200400001)(86362001)(110136005)(36756003)(44832011)(6506007)(2616005)(508600001)(6512007)(26005)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?BwDxfuakL7uJ6xRazTVDj4fV7ha0LUZAcb0qqSY0mj7IyncGc1wff0+C3?=
	=?iso-8859-15?Q?qJIRIunbZwhTQxtduz7gCu5a8OdR3btmSWudb9+1ZSR7hPtf5I7VFv9sH?=
	=?iso-8859-15?Q?OrTvJyfIuox60j2hXWa3+EsU9dVqATKG8aQKTaM48cQsqAfkfmDboXYY2?=
	=?iso-8859-15?Q?gNP6AQCqUq9fj0PcJtL7MfmcF6LzUPCs7s7Wh++Tnfg1iSJo3rEmKy3cW?=
	=?iso-8859-15?Q?7prT1EFO9/88xKd4eozbtq4nosoYL6V3+xO5woAQm9m5f7jQsx/JS/uYg?=
	=?iso-8859-15?Q?oJckkw4RbeLy9spjg2js4FEuQ0hskSxTFYyNLrcmFEi6q4DFJzVOK7FKe?=
	=?iso-8859-15?Q?0gXLMvYyvG8xZscHfkj6JVWi26u8t3n0c22RZjv0mQnZOwjVXzebH6mtx?=
	=?iso-8859-15?Q?751NBF8ytrOhyGW6JU6KjoEQPgFRi7p3Zr4R0ah1TrCZ9hFFunZQatNcD?=
	=?iso-8859-15?Q?hoN/Byqg3TNRF44kPa6wNMyjKQ9H1qr62y/pyuzCy25u1VpP/mcFwUb4T?=
	=?iso-8859-15?Q?MGJae6uvHKbQn9mwJp39AN2LipeiI7fWDtpUjrobpjvAEyEJQoje477hy?=
	=?iso-8859-15?Q?1EDKrAc5eEb8iRpaHKeoyarLFvpa02ME75ZcN0xQaojX1W67OPv+1p37u?=
	=?iso-8859-15?Q?9eDfXnVDDs8N3ipU5Y1RYF8x3rDV0+PdZgXYzxEHk8QXbHPwCeT+Vv8j+?=
	=?iso-8859-15?Q?47A4jMWOEnJtiNwsL/9W3tefnDoJceUJPHKO+pGyxWBXgV2Rhjm9gmX1Y?=
	=?iso-8859-15?Q?GDKhzjP8PkvyKu9ZLZ+gqPZIJ426TxW5F/dUzYSge0uw+1EBMWLRLF/Hj?=
	=?iso-8859-15?Q?AQmPKl2uJabHxgLVBTQk3CmZfDrJ0WB3bcoEMHtugM60OpgvjG5NIyiQ/?=
	=?iso-8859-15?Q?2BG8kJdz1lcsTWJYyEdYZF0QBa0+zXg8qAY3oYu6RaLDpvN68XRDdt3xu?=
	=?iso-8859-15?Q?ScxUyr5jYvSZGRCe6yj4PZlax4/xwviZrnWQG1om4gXkSSCR5pyWsjoos?=
	=?iso-8859-15?Q?ZlhSZ0elG0K7tsYcmsSD9yABeswBVPx8mc0aS+lI69l4SaZe/FGsFGtI5?=
	=?iso-8859-15?Q?5s+B/1ataoUWYmVlPJFV1ciwf8Ta8+nwH0Ti9+6UrhWYCKjEwy1mSQd17?=
	=?iso-8859-15?Q?TgGp4qCCE3ya1Tq/epKfo7bWV+VIT4ylpJzwuPKHC8xfPLNdRZE0Njjdn?=
	=?iso-8859-15?Q?6fg5V9TormWwAh/WioBOWHC3jhxuC3d3AowNtwgLCbBvF+CjJPNnokyGg?=
	=?iso-8859-15?Q?b7p7M/AH/hHEbU0qKPRfvlMFkm4XAjY0O/w+135EIkatv8NmUkEa8GcfM?=
	=?iso-8859-15?Q?txbU7OTGUXKeNoleFzT8JldqYOOLBqXws9+ZVYpjSjYs1HB7m3oRXrZmk?=
	=?iso-8859-15?Q?YFbHGAlEjMrfz+AWW5ZBIRm6KshDJH/EQ+iU5diIBkc+leRM9OaZjNi0j?=
	=?iso-8859-15?Q?ooXTpjoFLcTRqgCr8vjbJESxj8fxYBEVceDyelVDX5eQ9joQUVsv72IlP?=
	=?iso-8859-15?Q?vwFDjlcMA2PM0VbfZBcGP2NAEkgtmKZGW9UFLDqhKXsa8YPAlHOYo68Od?=
	=?iso-8859-15?Q?dqbgfBpV73AuXHZ/1EZghjOgFnaJhUGRDWDoNK48d0lij4201nwUf7VNf?=
	=?iso-8859-15?Q?4J8ssz3bZ2EqVF/DgoqXKAtv+MktqSFJcoO20XGgJ0/ed1IiHw7/RrCo3?=
	=?iso-8859-15?Q?VsvTNRasazq6OaodrleJl7HHiEc3uhSYuBCUq/fvYJbzslE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b77ff9b-cd8a-4ac9-11b1-08d9f0c39940
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 20:41:52.8787 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K70O2A8htdoJOQU9VGp0Kg04zqj06J2O7oCUJi9W/kX/KYBQMYsK1sKSQsGeqiluJsPGhvrdSlhu9onLk1/Fzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7122
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21FKg3ZZ007163
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/2] libmultipath: support host adapter
 name lookup for s390x ccw bus
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
Content-ID: <884CFA9AD50D8249B3C4FCE893D3A505@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-02-15 at 21:38 +0100, Martin Wilck wrote:
>=20
> I was thinking about something like this (untested):
>=20
> for (parent =3D udev_device_get_parent(hostdev); parent;=A0
> =A0=A0=A0=A0 parent =3D udev_device_get_parent(parent)) {
> =A0=A0=A0=A0=A0 driver_name =3D udev_device_get_driver(parent);
> =A0=A0=A0=A0=A0 if (driver_name && !strcmp(driver_name, "pcieport"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
> =A0=A0=A0=A0=A0 subsystem_name =3D udev_device_get_subsystem(parent);
> =A0=A0=A0=A0=A0 if (subsystem_name && !strcmp(subsystem_name, "ccw"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
> }
> if (!parent) {
> =A0=A0=A0=A0=A0=A0 udev_device_unref(hostdev);
> =A0=A0=A0=A0=A0=A0 return 1;
> }
> ...

So you did exactly that in your v3. Nice!

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

