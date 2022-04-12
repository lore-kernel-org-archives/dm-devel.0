Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F771C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 10:38:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-jkADVLULMEuc_y_WkRWtDg-1; Tue, 12 Apr 2022 06:38:39 -0400
X-MC-Unique: jkADVLULMEuc_y_WkRWtDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D2F33C33B24;
	Tue, 12 Apr 2022 10:38:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE16C44B17;
	Tue, 12 Apr 2022 10:38:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9D571949762;
	Tue, 12 Apr 2022 10:38:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF11D1949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 10:38:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA7BF407E1C6; Tue, 12 Apr 2022 10:38:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4F5B407F78B
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:38:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA57E1014A61
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:38:35 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-IRkNBu5VM7a5r3Y-wM-fWA-1; Tue, 12 Apr 2022 06:38:34 -0400
X-MC-Unique: IRkNBu5VM7a5r3Y-wM-fWA-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2107.outbound.protection.outlook.com [104.47.18.107]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-jAPgZSrIN9GaeYDOWOSJ_A-1; Tue, 12 Apr 2022 12:38:30 +0200
X-MC-Unique: jAPgZSrIN9GaeYDOWOSJ_A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM6PR04MB4951.eurprd04.prod.outlook.com (2603:10a6:20b:3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 10:38:29 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 10:38:29 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/9] libmultipath: steal the src string pointer in
 merge_str()
Thread-Index: AQHYThEJs43pNpoczUqLnY61e9p4UqzsFsIA
Date: Tue, 12 Apr 2022 10:38:29 +0000
Message-ID: <ca96886df24846438e2d65fcf67c8d911898e3e6.camel@suse.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <1649728799-11790-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f849f46d-03cc-4850-6e5f-08da1c70954f
x-ms-traffictypediagnostic: AM6PR04MB4951:EE_
x-microsoft-antispam-prvs: <AM6PR04MB49511A3C4166C3864B2B6CF5FCED9@AM6PR04MB4951.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: se0FCYuo13GOIyJ25gyu1LG4+Jn8rCCHnTzyJ6i4DMO7of1O3j5hdKHTopBE26NdCJ9AcNXtUcBVg7BZM1hX+DKumWtb/LzpHp4NZqwgfxUrOjPlPnAT7IhD0Qwz9ZQ0pnVlX0iCzvxsUEmF3By43clr6E5oimWQTJoMr1pHacKkZKAYTOUzf3T50KvpRCdfHwfv510Zo0pHwgtENq+saNpmu8ckDqBGIabx/aa7CVYfEKM9Z4xseqO9D+D5ATMi4iXlYt9uFv/RdStzOUTT6F2Swcx/iM6K/Fqf2Awu15Alo64HMVBZ93SGtp1B2knFex+s7ta1uMhzaI9tnLFaKwGxeQFZGA/fRRQmkcd1AX3hYM87kzC10d05I97Z7X9o7VulS4/FrZW/3dWlBsfLlKPAPiA0txvzJrOAufM/IS2ERJ96p7w/ERMx7sy5t4PnkTczJ+p1xm9vSOsZsrIPgCUZMB7+apdXhazLJeP6Dl9+hvzk34Nm5kLBymZA6pUqSpyKlokuuE2BxUJlufBRiseZ+EPzRhcHs/5s2XpBBslZzY5IuhKSPyo/o4uzsRISR3ma9QkZfxRiW+y7eIa1ye/UlYDanSRz+ieiJ2Ifqd1/Dv63hNRLTBxNhjM9xSyf7HrNltxhNz6T0SSqxdGkCEIJ2tmGC5rV2zZRpRnN1YlJaDdygHLPqSVXT7uh046rXZZDX35XW1111awYOtOAUg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2616005)(76116006)(66556008)(66946007)(66446008)(110136005)(8936002)(316002)(4326008)(91956017)(66476007)(86362001)(508600001)(6506007)(6512007)(122000001)(71200400001)(38100700002)(4744005)(38070700005)(64756008)(8676002)(44832011)(2906002)(36756003)(186003)(5660300002)(26005)(6486002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?kwxD34DdGcZUXIjmGcAX7ZgjdJHxVy2qHvEkSzBzuzabj/DNmrKZn1rc4?=
 =?iso-8859-15?Q?cQEPYoy3BCEdGkkcX0FQlj8EHzEQMyidbpv1WId5PlQimw4uJ0F6W0f3B?=
 =?iso-8859-15?Q?CzQnyaTqmQx9SXCwC0wPIGLZr5lQedscmnrw1zE8Un8TamJeF/RfvNlQo?=
 =?iso-8859-15?Q?cQvbOsFy3YpFmv2dZWNAT26PCb4EnLiLQ/i/l9tzWzqNCzGWb0iG3nFEW?=
 =?iso-8859-15?Q?gyOSTi3wqhPmtmEdrkk3RJOeMfTLmTGqPk3t4GGZM7rLbYFXOWk4AkuRo?=
 =?iso-8859-15?Q?NqgrmTyyNizOs9a0MPkFWtbZbE7Bk1B9XC2BXAhNDxo7pJLWuNBmYu6Na?=
 =?iso-8859-15?Q?aMH3CvFCjvr4+tatEXGizrXcgDnJWtRmyVdGRAe5EB3yYNh1xgAbFv1io?=
 =?iso-8859-15?Q?dFsPZg8EZMJEJLcNLO0Js7nX7zf6x+8Ix64H3gjhgoO4qQo4W9yGlPTi0?=
 =?iso-8859-15?Q?V0adLZFaJg8cLw5UmC9aMO949o09uN+Zkj7+z+dWZFuGMKeOHTxn4EPgQ?=
 =?iso-8859-15?Q?VjIgJ/1hYSogeQ7cJgdDxMAXNw3JRmi3CVN89WfGJvmnjx1oWu1YVPqG+?=
 =?iso-8859-15?Q?pfMBNbCHW5ccIQywppt3a0BBqpLk6Ku/Q722A+fz4arSRRWj8G9AARiSA?=
 =?iso-8859-15?Q?v21JUDmvGGuFNaO5runnIMwT3imn+UBWNFYr3N+oywQoHbyfJMQT/Rly3?=
 =?iso-8859-15?Q?vsG4uRMnDsSc86dYwGZK8NP6RhuTdm0z+8Dom9eBcns3+E2sZ3qjkysTa?=
 =?iso-8859-15?Q?pFgEcUhOv3B8Yha0Qi3nmLtbqYhjzECaXJJH6MmaCFwF0bDmcivOtMka0?=
 =?iso-8859-15?Q?VdzaF1wuIx/umtC3p/wNcRsaIUAqtJv2423shvp5wl7P3kcq51inA9XDg?=
 =?iso-8859-15?Q?uzEwq7lzMYo6xrG9EuBGtS9dXDKjg+kRKy1ixI5B3UxjCP/NJimyQiuhI?=
 =?iso-8859-15?Q?Q70vHJazgTguaMpKHd5arld7Bd2W+yMqaHLIF6wrf0+1GRyEfnctj6w4I?=
 =?iso-8859-15?Q?ntBenabsaPohO01fQT5uqGRMOQ5S/YcJaYsiJ/I1igmHqwl/l4SIzCWlA?=
 =?iso-8859-15?Q?1PNaTxoRRMVrfFzznLwf9ACT8SkywKRyErjYEbvBk1q0/gbf6Q/txGjpr?=
 =?iso-8859-15?Q?B5wMKXv6Ei/Z65Nk7W6x/nafTDELv2S1a+dSci4PVdWTo/4pK9GYZsdnj?=
 =?iso-8859-15?Q?FPMZ3OLp56LTuIRgST1QKzVNXX09LbfW/1CimQYp0rh1/VPfcL3qQb+7w?=
 =?iso-8859-15?Q?VJjdLhV4wn1A//iaHaMcVyRIaQSIBNHO7IB4SUyJEX2Buhnsbv2iEA1No?=
 =?iso-8859-15?Q?hSnmV3lUPtn+m43XAkxKj6VWC9FFRcVGftvO4TTufgnhehAc5jTcGFdHk?=
 =?iso-8859-15?Q?cVr90+IEK0tD/pwX3A/lUmHqYKKLL6xQ2EGxJpUYb190N6FsMb0p2/huW?=
 =?iso-8859-15?Q?cL71DW62cS+jphFUBaZAYOQv4QoxlqeWDIRbnnt3wjaAVGvwXiPULTO5G?=
 =?iso-8859-15?Q?cIqe11ss5w1n2Ekma8GFIeywA03EFscRf2At8goZg/sPOCUtRAgY/nhWI?=
 =?iso-8859-15?Q?8EQg4h7fFWR3y2E8vi4aviX1/HrR4ckR70jfWzyL9yGAjGEgujLo1FsTe?=
 =?iso-8859-15?Q?T/31fUo8u2BL6HgqGL0Ssgxsf5/6mFzD06ezM233DKzvn0/AvGUef7zcC?=
 =?iso-8859-15?Q?2sIMIyKs/K/TL3NOIkuDJXDArk1P4Mg53dFAe0AgWRf5joOfKbFHI6K91?=
 =?iso-8859-15?Q?1RLZpNvkWGNE1L8zmISvZSiCoRysFs+MMcg5qYx9SDp9ULssOfGPa+hoK?=
 =?iso-8859-15?Q?i09VEwWIc4E/WSkYpk6IfypIDtz+wgJVO4AJEkF8gPtIP3EsIvpdC29P5?=
 =?iso-8859-15?Q?UkwE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f849f46d-03cc-4850-6e5f-08da1c70954f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 10:38:29.2334 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiuYFJG9PyWpGHL5pMU5OkO0v46W5tNvRjRRJkU86dltKHiwLt54Q/f0n9xQQrJ22cGv47VsYHOAV66xhVFmng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4951
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 1/9] libmultipath: steal the src string
 pointer in merge_str()
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A3017A48CE25BD49BB89A2D491FB8225@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2022-04-11 at 20:59 -0500, Benjamin Marzinski wrote:
> Instead of allocating a copy when the original string is going to be
> freed right after the merge, just steal the pointer. Also,
> merge_mpe()
> can't get called with NULL arguments.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

