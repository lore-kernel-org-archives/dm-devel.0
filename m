Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B235C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:23:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDB2960FC4
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:23:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DDB2960FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-IXIsdQxXPlaiqMXa_H2bnA-1; Thu, 12 Aug 2021 06:23:21 -0400
X-MC-Unique: IXIsdQxXPlaiqMXa_H2bnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C49B92506;
	Thu, 12 Aug 2021 10:23:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BC3E5C23A;
	Thu, 12 Aug 2021 10:23:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F364E4BB7C;
	Thu, 12 Aug 2021 10:23:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CAN9Sv012213 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 06:23:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6441110FAA8; Thu, 12 Aug 2021 10:23:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E27A10FAD8
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 471C1185A794
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:09 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-62-5TUZMTi-P2K5_HObeZOqCg-1;
	Thu, 12 Aug 2021 06:23:07 -0400
X-MC-Unique: 5TUZMTi-P2K5_HObeZOqCg-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-20-_dlNfgcFN9ai7Z9Ut6ArSw-1; Thu, 12 Aug 2021 12:23:04 +0200
X-MC-Unique: _dlNfgcFN9ai7Z9Ut6ArSw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5385.eurprd04.prod.outlook.com (2603:10a6:10:83::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17;
	Thu, 12 Aug 2021 10:23:03 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4415.015;
	Thu, 12 Aug 2021 10:23:03 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/5] mpathpersist: fail commands when no usable paths
	exist
Thread-Index: AQHXhMMvHkXDWlMem0GiHC+61TKpx6tvvokA
Date: Thu, 12 Aug 2021 10:23:02 +0000
Message-ID: <fa08029d698afe4069b2d8f445456db1c553cea8.camel@suse.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
	<1627595165-19980-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1627595165-19980-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2245670e-844b-48f2-0b6c-08d95d7b2acc
x-ms-traffictypediagnostic: DB7PR04MB5385:
x-microsoft-antispam-prvs: <DB7PR04MB53851ECBEA9699472AEF19EFFCF99@DB7PR04MB5385.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2ymM6RvobS08U2/JJwhMw935niR+DMe+z81nZ9ZKJOFvCU1mwgyLLydNcR0GAcAzlwz+tAanelUj61DSbW8wf4TbwgUJqlM8+T+P8b1WsL5WBK4nv3NVBm+5zl4K2lMyn0/qS7uKDjaXsCEN9ScoFSMP/kqWJ6EnWp8BN06xB6n8wX/79vEWpPXzNiItd+871ES1PJ39lV9MOElNIrzSerf+mBIs07Q1mn1tQdvIc/YxsQuvcCKPxmyLtHXUsHSy5ly8UqQ4hqnBA2mF3Gmuod/4QsakwO+qmSKJbyDTGlAi8ITjidgj19zu/D5DGafVIPRix9l+6Bn0L0Yzi2jrSxzjLv1YPPUPMlslpIL+h3jjTFOqql846ur7qERuykHGBrKC99UZ3ZwWHkxBeTJxlBS5nvFXK+FhE/8uiI+qfawH50Ha03DUyqH+24UI8U+VfQtNvs0edLoSjHvV9zMVD/MrkmcIPodsNNgDvXVffZ0u00oFy6WUb4/cCv2JsNULXpz1Iqkg8Na87tm6Oep9wmPS385+tbpPVWDk/MzppzjDQ0GDUOCf5pzcDthGkINanUHV+JCeyhVYh+CvDSD4AvGgx8allEb1Pmz+AI/s+jbyhnlz9j92he57S6gGzzf3UF/919M/1Fpv9gblA1zepPIrGg3JbXccPq/GKbZLlnQhYmCenjakfQ6u1300gYQv/n+kXtu0J3R6QkCkDvK/FA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(83380400001)(66476007)(66556008)(66446008)(64756008)(66946007)(6486002)(91956017)(86362001)(4744005)(44832011)(2906002)(38070700005)(5660300002)(36756003)(8936002)(76116006)(2616005)(8676002)(6506007)(508600001)(26005)(38100700002)(122000001)(4326008)(6512007)(316002)(186003)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?A7eEfAxFCbznz9Sg/CmMB3iJaRIJq9pkiuGWxp0+3+1OPel1zk5SvOkBv?=
	=?iso-8859-15?Q?XOkVHFHdzwm3QrHTRaixa1NLXMoRJ38PZezmX3AshxpuLzDAmFEepF/A4?=
	=?iso-8859-15?Q?oUsXqMqLkKqyEdtxZAea06K/wn3Uzu7FspTGWwxzr+QWigBiknvmjzK2x?=
	=?iso-8859-15?Q?VFejMgFNlG/ArWn5hYAx4YOrcVw15HuELkSXBswH/eBX1p+YVBDEFfNU0?=
	=?iso-8859-15?Q?83QLLYu82FxtiQXhCi/QjLUyagc1JvrO2wpfHevP8kK3czfZ+OHPqBfPs?=
	=?iso-8859-15?Q?EdhBo3Dlv74VhFaCH2Rmcp7CBwaGjVKNsCY4QN2ZYUsgRu4RCjSdW+0ia?=
	=?iso-8859-15?Q?jOcjL87hhMFdrWDSDa6libt4FfBrWigOs6eARL+C0mjxdESa92j+kq0cz?=
	=?iso-8859-15?Q?CPd+jWoD0tbDtft1Ut+3LZIr7hRQwi9AgSo9DKQMP8rL2WgS2CUJLnFQP?=
	=?iso-8859-15?Q?7aqueX8C8t+ls3pGonPGS6Px63HErfgZ7Nk2QuhpVbZj9K/HJR2ZH7bie?=
	=?iso-8859-15?Q?pL74FwFIuRGpUdYXFX0s5bqfx+M3yPWDOPImm8xG9Z21fFy73pFq+1OVz?=
	=?iso-8859-15?Q?4AZnYG6yjZbELbjlMXW+usLbhdp9+zTn5qSc43LLODGG1crcM0kNfWoMj?=
	=?iso-8859-15?Q?/cLW3jc3TatfyKg6jr6BAg02TLPtbSxvYzri446PZhm2brjbnfFKN9oST?=
	=?iso-8859-15?Q?Mbo/8S3bGR5BNMOSw+tjpKPy0X4YaaCBM7abkXxb0STPZCSftZGvSAcpB?=
	=?iso-8859-15?Q?IdkJJImg3YSmvVtEouVux8Z2Os0rq9Ijr0Cl7wjfU6f+QFFvM+h/1eyAm?=
	=?iso-8859-15?Q?gZDLSEzk+Vg0jBp1rhLv3rdVVw27+1RB3rRRh0cufvoen0DWEWAuR+Qq0?=
	=?iso-8859-15?Q?0uJ+gwVQ+DVJ+Tz44BarPha5u99UdfQaj6YMfSCRLSSn2u7d9z3Cblf9k?=
	=?iso-8859-15?Q?XWW3CfZ+OmW1NTWhsFmjF3onTu7eFR/9Ym9whbYSMI7RfPNm9Le9fxuBi?=
	=?iso-8859-15?Q?Aiiau1rkasY3MTz/PobtT+OLq1SRYbHodvvZJuqyeEwaqiJ8UPqJnX5+T?=
	=?iso-8859-15?Q?/jxxqx1+UYOqMLbOQZZdsrhcifLRmRKXdyfeqtMaFPUbjTK9mQnaYuZEI?=
	=?iso-8859-15?Q?KwFjCe5vZvia/fwQz6mgkjIXJm+wwQ9kN0zjNQkA/WvtMhCNvrlqqGjJ9?=
	=?iso-8859-15?Q?qxGux20+7xQT0bUUEobjez3jAWGTQ7/d3+BGnogf82IfghICuRL8PcqT9?=
	=?iso-8859-15?Q?AXLKp94z275OIKD9ExvR5+DS1YKB4zw/Rr+//1Cc34Jq6/HGJjVJx2HQg?=
	=?iso-8859-15?Q?RyJLH7AcC+nwVk+cG4Af7HLLxJwvORnc1ozrR5TISudQpjItTSUScafeU?=
	=?iso-8859-15?Q?F7dKYWqAd7aFH9TuGBG69AT4DrqFlN/bh?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2245670e-844b-48f2-0b6c-08d95d7b2acc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 10:23:02.9242 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ITtlvfhLvSIW6Qwv3AX7km2kEdn7+cTLXBdVc84mcJdUzhE0yJkeGAgovnG7nQ+MKhL//2g0xL5tiHFed03lw==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CAN9Sv012213
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/5] mpathpersist: fail commands when no
 usable paths exist
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <01AC22AE1E8B4842AE5D1BDA658C5492@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Do, 2021-07-29 at 16:46 -0500, Benjamin Marzinski wrote:
> "mpathpersist -oCK <reservation_key> <device>" will return success if
> it
> is run on devices with no usable paths, but nothing is actually done.
> The -L command will fail, but it should give up sooner, and with a more
> helpful error message.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

