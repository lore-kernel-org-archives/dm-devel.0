Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56A2C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:19:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 193E623BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 193E623BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-4vV9O5zGNweYGJDdNT2fXw-1; Fri, 18 Dec 2020 18:19:15 -0500
X-MC-Unique: 4vV9O5zGNweYGJDdNT2fXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E37F6190D343;
	Fri, 18 Dec 2020 23:19:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DE7672163;
	Fri, 18 Dec 2020 23:19:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84082180954D;
	Fri, 18 Dec 2020 23:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINJ7do029438 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:19:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B42FB2026D48; Fri, 18 Dec 2020 23:19:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADD212026D49
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:19:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8565D811E78
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:19:05 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-473-dL4QegSTMjir4qpEDNwNyw-1;
	Fri, 18 Dec 2020 18:19:03 -0500
X-MC-Unique: dL4QegSTMjir4qpEDNwNyw-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-25-Rn8HXsCNNKWjykz0l_GXyg-1; Sat, 19 Dec 2020 00:19:00 +0100
X-MC-Unique: Rn8HXsCNNKWjykz0l_GXyg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7580.eurprd04.prod.outlook.com (2603:10a6:10:1f7::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25;
	Fri, 18 Dec 2020 23:18:58 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 23:18:58 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/6] mpathpersist: Fix Register and Ignore with 0x00 SARK
Thread-Index: AQHW1ZJ68fgq1vJIeU67DJ9is8MIiqn9fSyA
Date: Fri, 18 Dec 2020 23:18:58 +0000
Message-ID: <6b2c953cfdac027b2e03cc21929724c7349840bc.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 475f95a9-5da3-4664-a854-08d8a3ab4c50
x-ms-traffictypediagnostic: DBBPR04MB7580:
x-microsoft-antispam-prvs: <DBBPR04MB7580CCC26CCE4D472993D37DFCC30@DBBPR04MB7580.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zMmEeSox3V/Es/LVx98X1deABiyIFe0UcMIWJn2/6ULLwS9ibQMdERKGFk6DrthZoa2HoQ76wrb3PQ9ped2pnFqFmVwkQ6DKh9tWh4ejd8X43vBR6ob+dv7OGXfZXT6iXs6AXUh2iJ9mbCEsiQ08AZWBHZ7jdl3Q7G+bXdvX7QAWp/AXBVRN80XxZW9EgaxVc/nhB3+duik5RcQ00sxN/olSFRMu9sH6WNObAVpSB13E4JiqEsZErYSG8ba4+5nApz3qOwvx+W0MvhA5VYraWyNljub1wBViDsfjIq0M9tsp9VDEBzJSTolCYarsX6Mp07Y3L5Z+QFSya9Ak+fuBjwllmfnaXP+VV2Ia0ImljN7aUiU6ZxMjsPDMCu6GkatltYlcO1EE0oEpoJAe9rHeZQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(2906002)(4001150100001)(71200400001)(86362001)(4326008)(6506007)(91956017)(76116006)(316002)(6512007)(36756003)(6486002)(44832011)(64756008)(26005)(66446008)(186003)(5660300002)(110136005)(478600001)(8936002)(2616005)(66476007)(66556008)(66946007)(8676002)(4744005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?Eg1e2h6vMqn0xgOKNxe3xTeAdkHXAEI37fDUoxEnk1FZSEjV8QyjQnpKJ?=
	=?iso-8859-15?Q?FmxqdCvJ9ggnhfgbAilCNfCtGqVT/XMizOKLzSIDkwzzkwFld5nOzl7uk?=
	=?iso-8859-15?Q?v+mT9Wls+/aNEuQ13QYoz2Gs2K5bsKGYqxzNHcJC62ja3VaJbPCwCZrta?=
	=?iso-8859-15?Q?nCTK6CS6XWPySy3Pip1MbUOOeYl1JjdvGTbPTG2pq2ezhu5rjzmpP0Vm6?=
	=?iso-8859-15?Q?Su8M5fxB3K6qcjyCbPwNiLkNJvLDUT/s787q4DpuEoWGOMgi5F5Gjz6My?=
	=?iso-8859-15?Q?MKHrn/faYFxDo8gV7y4AFILp1vyjtnygn8+eilI+QxTa/zb49R2Z8mQ8R?=
	=?iso-8859-15?Q?ZPq9NZ7kSal3MHr9m4FW1vJBn2SeTFYjcVrDZ8ULfls6H7InDHqtT6hia?=
	=?iso-8859-15?Q?XKscbBEM52UJuTJ480Fn9aiyKXi40sGah9skhyNRHuiARK0XRcXTEaZjO?=
	=?iso-8859-15?Q?RndyCKvgdttUrJNeOWVHvKtvFOihfr62PLx38+KPqVJ9OFRFwnMqma0K+?=
	=?iso-8859-15?Q?X3315hLgApJpr0dykGCM850OJuRHhBNGsbpXtuRx+GEnWVf2aVmSQlt0h?=
	=?iso-8859-15?Q?KPRDquz8B4/ruOGJ/4bZ/bo5+HER4JKSuAgu64TNy9AayMPyhtroAzrX9?=
	=?iso-8859-15?Q?zDjYiCXXk7inQKK6/xyWfrlWVGAadzQ6kOxal2GbXqijvkVDROuXO0U5Q?=
	=?iso-8859-15?Q?fDjrnPmybFecIOgi9MZ/vyfBA3+5T1xcBvYcmVAk401CTOXB0B5svqSVI?=
	=?iso-8859-15?Q?xLwHCN3bgYd4ax4y2gw5ObUpaaSVDhqv7Ly3564X/uVXsZuPjgXAOnDif?=
	=?iso-8859-15?Q?pOiDjpaQGckMi6OXT9wQ94VzAVBNZbJbNhlKPn0Cx1ewVb/2/TOU+r5no?=
	=?iso-8859-15?Q?oIM24YBJTREtBshBXFMB9E3jBUPbQo5N5u5yM4YpzrKQ6V69uMd4flSFl?=
	=?iso-8859-15?Q?+74tT13cRvFmSyrVmPZNcgtB5fp1Ej/0KuXy/vQv3YSV+KvWgaBfjKvTM?=
	=?iso-8859-15?Q?xGrqowzNON9v7HUeMVcmpJp5iD8kveZx+EYMJYb09Kg4/nHJXxNksg0?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475f95a9-5da3-4664-a854-08d8a3ab4c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 23:18:58.7714 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHhtzHWpt7MBVtCLfdp2zSM0S5Mh5QbU/nz00lxidreUkC+oaD1l9aT2bbZ/2WG4wXn0zZqh5apxS09rf/40Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7580
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BINJ7do029438
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/6] mpathpersist: Fix Register and Ignore
	with 0x00 SARK
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <65972A7222441A4C9F0036BB2707B5AE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> When the Register and Ignore command is run with sg_persist, if a
> 0x00
> Service Action Reservation Key is given or the --param-sark option is
> not used at all, sg_persist will clear the
> registration.  mpathpersist
> will fail with an error.  This patch fixes mpathpersist to work like
> sg_persist in this case.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

