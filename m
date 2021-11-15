Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604B0C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:11:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DFF4061BFA
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DFF4061BFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-Dowln57UM3aTkem-d3alJw-1; Mon, 15 Nov 2021 11:11:01 -0500
X-MC-Unique: Dowln57UM3aTkem-d3alJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E93BAF91;
	Mon, 15 Nov 2021 16:10:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E80565BAF0;
	Mon, 15 Nov 2021 16:10:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D288A4A704;
	Mon, 15 Nov 2021 16:10:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFGAg1u027376 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 11:10:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3547F404727A; Mon, 15 Nov 2021 16:10:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 306164047272
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:10:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 182EC801E6E
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:10:42 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-272-CUDdrd6-OtKY5Fc6tzgPqQ-1;
	Mon, 15 Nov 2021 11:10:40 -0500
X-MC-Unique: CUDdrd6-OtKY5Fc6tzgPqQ-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2112.outbound.protection.outlook.com [104.47.18.112])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-12--hE1s2CSNd-imxmIjpRBDQ-1; Mon, 15 Nov 2021 17:10:38 +0100
X-MC-Unique: -hE1s2CSNd-imxmIjpRBDQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5065.eurprd04.prod.outlook.com (2603:10a6:10:1b::33) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26;
	Mon, 15 Nov 2021 16:10:36 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Mon, 15 Nov 2021 16:10:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/4] multipathd: remove reconfigure from header file.
Thread-Index: AQHX2jtTThNDoHWyFUiF9fUd/PVNnQ==
Date: Mon, 15 Nov 2021 16:10:36 +0000
Message-ID: <e99e35dd5f744dc5a5501f5599045ea5d5e0601f.camel@suse.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1632180076-9294-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20d1fec9-dec5-4f1e-b698-08d9a85275bc
x-ms-traffictypediagnostic: DB7PR04MB5065:
x-microsoft-antispam-prvs: <DB7PR04MB5065572157AA09D5A3A6EF10FC989@DB7PR04MB5065.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5Yr/SCVuBCv2+ZlTyTi6E5Qtc8L0WWFgmky7Spj/pWbdk9esS/3Gu2ljyr7op53qIbnPHgfZWSa5W8PCnrRf5XI8aMmEBGeAylaO7s9P1Adsh+0hXRJxVnSdED+yaljwc1qyModjYuKwrmSdez7E+t/waV3YnsFrjNBAmvs8THHswMc6TGyC6GbZaoVZkVV1+Cc/4+SjLYdqJ8Ag9ziTUfp+CU7cu9o3FYTHJ0Z/zg3d0naKCSnY3BUfhu6fN2mxQUmP80T4f5+SHCLFG4U57UAP2gu059keqaTmmbELorLegF4Gm+3c1mtxMWt7da/MMmq5HDISKiuVPHt9aPWlFS1mnCKLvYF+N4fylEw5+d5DTeME8KcpxG2c4R2x2mKfX9I7Mxj8Bubc+l6Psz9vR817Vw+dCK2FTjSPUZyhQFUbxMbCMNs0nCYpe2UKf4L7X3atDdhet7WQU7Do9QZfRGhNwmamSilGrvsNY4knmbn1iPYC4LdXqlMOPvLWl4jAP2E1a9Y4feflVXfHiXHF1k15m95gZ9hU1fG1l3M/wXA7RgwFhq101z+tMlX+mTSZL59Z7UkKnZHVTym54FgTBNDRQtUQTJgRfmX9egPNZVua5vrDAu0Vc2d0+XwJtbChx3AwmPT1jYa/HhFY9MYrB++AEUqAU/og8bj+V9xiuxAslhXItYlmTLsKaAfqz38VI4pfdRXAx6m1Sld1Lu5vvQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(26005)(508600001)(6486002)(2616005)(86362001)(38070700005)(186003)(558084003)(8676002)(5660300002)(122000001)(36756003)(8936002)(4326008)(6506007)(38100700002)(64756008)(66476007)(66446008)(44832011)(66556008)(66946007)(6512007)(110136005)(2906002)(76116006)(91956017)(316002)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Kj7mQ9SZkn0JIX/8GWncKbclgYlycXWa4eVDTUeDF8pE75sJ03ROLFu9Q?=
	=?iso-8859-15?Q?pprUynIDAqgmvKl/ilQFsSiHl6tWL2eSXqMoDEVfIFrh47VwbtOYskfRw?=
	=?iso-8859-15?Q?1QXExuCplVqBqPgIDRmtw9d1wHcAEo9dYiNAYOEOTa3lVbLyCg83VmEIh?=
	=?iso-8859-15?Q?llX3nNDYPHUG7oj+7HaAQ77DOSMePJASHkpMIA9inPFKfeZn522PISGLg?=
	=?iso-8859-15?Q?HbgBK01q/BDCd3O3O2T0iaVQPRScu0l/TFikt37645NtoVt24W4rBsOtO?=
	=?iso-8859-15?Q?E+Z71ej0r+PygRsn/8bVE46Zefrx4Bv7MS7Cp9w4uqDcJadzmTTfcrA4r?=
	=?iso-8859-15?Q?f7ZhuM5hQ3JbaqX8ddiy1nXjFz94OXJMdTTwIjyf5QYZ+G2U5pVP/0Ljz?=
	=?iso-8859-15?Q?ePSZF3/XU8h99YmONhmfOiOAqErS32a/dIUJGd4z5itIs3nQO7RpT1dLM?=
	=?iso-8859-15?Q?v2p6Pz1Yw2p+hZYCh2m3tWskTtXeXZBYO1Mly4FTDBSPcHFdpIYtBJZoh?=
	=?iso-8859-15?Q?ANPzSfL6TL+R5J6QPHd4Vom22oqugbZnuDHti2k9+RBC55Wo9bRuIpWjW?=
	=?iso-8859-15?Q?8PGI0HgTitRSfk8LHEqDkQN4cmMC11cOgguMAKYPzWngREerVw4en3GDa?=
	=?iso-8859-15?Q?COg5E5q+QzXRr1559BekyvgR2+5PgK16v5hfcv1LkkMLrLTx+Lr5jmlqz?=
	=?iso-8859-15?Q?yTHOLZYmAxd2d9ZBe9Zfq19YJPUfSsRJ6KEhjN8Ref5dlaOxomnN78sFd?=
	=?iso-8859-15?Q?ciTO4cUJRbLUArTwkf9d1uxfXjvaOhfpMMXPC31VmH5/gKcj9ozCDO8A1?=
	=?iso-8859-15?Q?AD3LFe6prXx9w4QnkU2+NDtNPvEoyDVCF1Umr1bbAp3+I03PckHvh8SQa?=
	=?iso-8859-15?Q?XO0nxwj7Mlfc6EESAX6kLS9PWV+aXmM2bgjXNVQyOpKSHLz1Q1/vJgN7u?=
	=?iso-8859-15?Q?O6v7QJHqVMFo8z2byhLVf7RqBMP2JReo1mPNY1eVVmDaMPvAhtZVJGdNz?=
	=?iso-8859-15?Q?RDO4AX7+I2QaD8vW7siZR0KBbeaKZA0yCFQDfK0tjJzZeVobcwyiOuGHQ?=
	=?iso-8859-15?Q?qS7z6Y9u3NMGpmaf2j3iU9B5z360quTclhMLUnL6ZJGHBVULXf5zcPX+k?=
	=?iso-8859-15?Q?UWr6C2Q9tSAwjBXlg6B4jU+sj7+k2RGmsdOHTHtjIU5lmnkA+XlMQTXw0?=
	=?iso-8859-15?Q?W6Pst2oKMPGjIC0RYbi6waAVSDT1me3W8xehRGezFhcZt+8wcu/ydkOeP?=
	=?iso-8859-15?Q?GOvk5IEBDR3lm9TexIrgMRk/vGdMEWvXGUu7egiATrggXj0SeOBXL4eKd?=
	=?iso-8859-15?Q?n9sxfLviSpJG+7OFlKP+W8M3HaF9NzX9MaL7YVX2qNI88n+++Zl5M3JSD?=
	=?iso-8859-15?Q?8qGSLf6wd7jmv9KhrIQfP9/A/JXFtBvY0DJHpculliXqrYVZW66Y+eYcM?=
	=?iso-8859-15?Q?o7dPAG006koa9Oe3AuUi8SGZ/6kyqcdkVCtvWL6Qo0yUud2Of+lCfNUqk?=
	=?iso-8859-15?Q?uNj1Nn6LwXHHa34u1WvhXyPvNsfpqH0ayd2PMZplNAQ/8dbTfge3CprQq?=
	=?iso-8859-15?Q?ea3exAUjeB7yTEEKirn3HgbE1uaM0zR2O1B8AbRIDvQFyNKXrTMZybgQv?=
	=?iso-8859-15?Q?XJeaAQOg3Kvs7BdOlwSV5x28BAwYWHfg33W8LBKEvrszGA1aqvGHf/sSw?=
	=?iso-8859-15?Q?xj46Y2OXUwxndaVIx3p9WV0gZZTEtzv1T/cFbtIj2z0f+A8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d1fec9-dec5-4f1e-b698-08d9a85275bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 16:10:36.4742 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jpB1ZVGb7JptFwydQ4pbmfmSI5+BsybbjB3TwYOCXq3DKRIRGocEXm4EOTzZTbm9h+ff/uToAS6O+AXAFt9TYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5065
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AFGAg1u027376
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/4] multipathd: remove reconfigure from
	header file.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D396B6894AE60D498CB059D93F6A1A65@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> Only multipathd/main.c uses it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

