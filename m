Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2C7EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686846996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IrHVeB8/tS6X9Hmi8TqK/Kfzc0hORYo1mMh3Gz1zQXE=;
	b=AO04unMZhyk1TcRW+m6g0sglucwLewtegb7ZpSbo1gO86GuGWtT8etwny8wpBztX9k11Jh
	XzHWDD0PqrIiNK4T2oUg1UMiJKhVvXSFrDlYawGuaUEXicbBUiYAAL2McsYv4bcHZZNa6G
	h7vVRFIUCy6EXDLd3A6f46AbVoczjGc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-1x44djRyM06IwKzFNgSJXQ-1; Thu, 15 Jun 2023 12:36:33 -0400
X-MC-Unique: 1x44djRyM06IwKzFNgSJXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 727E41C04325;
	Thu, 15 Jun 2023 16:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20F0940C20F4;
	Thu, 15 Jun 2023 16:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E0201946594;
	Thu, 15 Jun 2023 16:36:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFDBD1946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 16:36:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87F80141510A; Thu, 15 Jun 2023 16:36:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F6D81415102
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 16:36:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CED4101AA46
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 16:36:22 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2068.outbound.protection.outlook.com [40.107.22.68]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-H4V6tjEVNzOuG2XB00p55w-1; Thu, 15 Jun 2023 12:36:19 -0400
X-MC-Unique: H4V6tjEVNzOuG2XB00p55w-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8909.eurprd04.prod.outlook.com (2603:10a6:102:20c::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 16:36:16 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 16:36:16 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V3 10/11] multipathd: reload map if the path groups are
 out of order
Thread-Index: AQHZmYFhsXlCP3yjyk63O5FXdnYgza+MG/6A
Date: Thu, 15 Jun 2023 16:36:16 +0000
Message-ID: <442cb770723c44867d5b834eea21e6bbc916a250.camel@suse.com>
References: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
 <1686170873-5754-11-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686170873-5754-11-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8909:EE_
x-ms-office365-filtering-correlation-id: 0ab5a537-d296-4189-5112-08db6dbea3f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0iYLs419SNmHd/7/3kuDZvH5O40RebgMQO6HbCB8F+XEO1E4qFSumPHzXM4nE0cGTwG+JHZjY8vYOWfw2dGIEvWz+8cEhYLrGSbrzStelTHCDILoEr1EEfp6DWOnnnWmPmz7ESZPHIAeRr0jcKyod5mpehMO0AB//LVZK66Qs7ftLqEAt4HfHt2lbnquBNJwQcGipoCV3yFBeXhagQY4GhodrsB6+0FI6V464LjPoNfPD/uasN89yGNBG9Q256XPLZn2fYNgO2PyEph2PWR5Zq+abw3g1+i12bw4OcOU2JpLEgITfGA2C2CzJ9G+p22dVsgj07Cp3xKXSOkHyIH0lw18T5Gae95o7BfIiXrciJwjwkm7G3YsFiGIRajixPtwq5PwZ4a9xbr7AAOMzvfxo1xCeJoMu5On0s7IWo+UOQMwWl5EjEy1jiVZCtzi2YhwJ8JErbeHdLaIn6Tdag0zeeZYQObR4ulhK54UX4HttmfEZH3yKqrZ1ULiLON4/Iizn51Yw2JFx1yB7qC5bXKRhpth/ugLHSyFce/aOZrS7+aMOQrJgNgRR36CHrwBZcjxf+AwrFuVQwq29auMucL5t5n5H/AYKqSCEnF2JNxwy90=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199021)(6512007)(6506007)(478600001)(26005)(36756003)(186003)(71200400001)(6486002)(2906002)(4744005)(8936002)(316002)(41300700001)(8676002)(44832011)(38070700005)(86362001)(122000001)(5660300002)(38100700002)(110136005)(83380400001)(2616005)(4326008)(64756008)(66946007)(66446008)(66556008)(66476007)(76116006)(91956017);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?fAGMcYdSLvenmBF+F1f9OnvZ9kiEGF74UD3MHvbqhmpn+Ik2VGx9iDWjJ?=
 =?iso-8859-15?Q?Ztb5HCT5BeP0zb0Ay2BOzXnKHEieSYWrRUdRnyxTx+brhHeuCZw0+GGAc?=
 =?iso-8859-15?Q?nOAdWJ2HnEIMF3XQBI5qSwolVkUA8OqzgtSeblNnB/NN4ZkCMfoWGlLNe?=
 =?iso-8859-15?Q?nDyhWBXIxhDHMpErdriepl2zEmIDUlExgutAFJqGbo+/QgrXx0uue+qU1?=
 =?iso-8859-15?Q?b1ICSAqrcaPWD54wAUKPB5E1pGOWw8oK4b+8FTW6VyFadXaBSQsyAn3/n?=
 =?iso-8859-15?Q?X2h3IbcXXJlxsYImrd20TEnYbGwvULS9UsinnUf9NAWJNftRopDZbQnAV?=
 =?iso-8859-15?Q?bz+rPgXaK9HPFG3JDS6CfdHXYB3K8bsjwdi6pEEyTxAsSRjubJMJQa0gE?=
 =?iso-8859-15?Q?TwwxTKh5TTkR1oxRquJS/dXflxD9z3COuXZyfk1j9LanRtZ3HZd4B/vII?=
 =?iso-8859-15?Q?epyOGmlaUOGyzuqdT+YQoxgkAQS7cmRIVKRZCQOCY2WJ8DC7Lyp7MtQrf?=
 =?iso-8859-15?Q?QkCI5zzYsSqKYnZHR4A/rL2MJSCV5mm/vtwZVHq7d+/09SLPnE1LShD1s?=
 =?iso-8859-15?Q?euGXIDWLxpILDoMFs4JYn8nBIwGBK4REAtcJwXG5saiRJrF0CE1cNl8Dx?=
 =?iso-8859-15?Q?eYPVCGm2K6bR9GadF0AwGoVW6/Y0Yz3PvEaTWHQPykYaXoBiuZXz7hqca?=
 =?iso-8859-15?Q?ZNpk+cIK9TDY7yOmOM/k5CKsOeUVxgZ8W4wkNj4GlfVImaaSMbfrfsRTS?=
 =?iso-8859-15?Q?FOf/kUL858bohyIe7zIpXAHq+Ohr3DKj6ZSEvLMXvcPssGFBT+RHU1IIw?=
 =?iso-8859-15?Q?EU/yAEdzmkngxjUn18SdSWvLR4lpCxEBSDgkcniAFAmI9iJwmJncCNvN7?=
 =?iso-8859-15?Q?98SSJXEMCBrY14pzTgTeXaAWnhtZPNQLvNtnF3KyRf+nqiH8HCG1+50Ph?=
 =?iso-8859-15?Q?Kgm/fMhW39ZmPnyRexJAJgRVns0AJ/Mrsf6kGtXL4mzn6v1rxlFmMPl2x?=
 =?iso-8859-15?Q?IsdSWFR+HBZyu4YzJdwpYP6nG5udWuWDWhiWnnRJ7L0Jfm64y6tEwFht7?=
 =?iso-8859-15?Q?g043arKWSQZQMO5Rvp3wu1vJQzJvf4s3Ug8mwFa9NWUiy55CvPuzZjFzL?=
 =?iso-8859-15?Q?QbGxff2S1cRdeat5DUz/0u8NbXIGaV7s9+5adgy3pEhvORhyCA4DFneC0?=
 =?iso-8859-15?Q?oVRr1zQUXHoDvP2t16X7jGhtuJpTWen0UjFlXnZgZmMPBgIaQWeIj7Ibe?=
 =?iso-8859-15?Q?xLyRmJ8WS7ICEZcLbQR02NOGwMMfYqRZUVou8moclpMYVhTZ4Hr1XEnNb?=
 =?iso-8859-15?Q?OjNkwaDWLSkRHFjsXidfKnoWN934PzKOu41KV8J1bVQNg+nGJlN8WjwwB?=
 =?iso-8859-15?Q?wBwo20EtAMpcfS7G9S1eDz24hWqiq8tjN/0hcZuSfrC7s02YPgWfVrKi8?=
 =?iso-8859-15?Q?6Cg1+57AjdFVFs8OHLVnH1EU8CPdKQL0okRNOUzRtJ1yZS9DOt3c9wDl1?=
 =?iso-8859-15?Q?uSyj6+/o6VEwJSvf89g3XSzAms4wltOHcyIOevVb4HtUMmg/qjq3w7W6E?=
 =?iso-8859-15?Q?mRF4XHz0XccHESeigWnE4zaIuCeM0siqdXL/L79Q3i7XSD0UIL+Icg9ys?=
 =?iso-8859-15?Q?Z0dt+PhUzcGOZ+mHpzJQjeYBfkVCp8Bu3OhZv+kraRQqhOH/+N5lO5Zw4?=
 =?iso-8859-15?Q?iNWu?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab5a537-d296-4189-5112-08db6dbea3f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 16:36:16.4734 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PR8ivwcQiABs0qr6bthLBaZFWlOeRawrxyFLuNi7OEuzkRwMaQd1TA8Y4DDCeP2ruXl6GtSGbPh1SPlUwoL1Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8909
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH V3 10/11] multipathd: reload map if the path
 groups are out of order
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <BD7366E1FD7E1348ADFD44AD438120EC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-06-07 at 15:47 -0500, Benjamin Marzinski wrote:
> need_switch_pathgroup() only checks if the currently used pathgroup
> is
> not the highest priority pathgroup. If it isn't, all multipathd does
> is
> instruct the kernel to switch to the correct pathgroup.=A0 However, the
> kernel treats the pathgroups as if they were ordered by priority.
> When
> the kernel runs out of paths to use in the currently selected
> pathgroup,
> it will start checking the pathgroups in order until it finds one
> with
> usable paths.
>=20
> need_switch_pathgroup() should also check if the pathgroups are out
> of
> order, and if so, multipathd should reload the map to reorder them
> correctly.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

