Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D27C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 19:33:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 22DF06134F
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 19:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22DF06134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-njPWVHG2OkG1MHWiLL-KNw-1; Mon, 17 May 2021 15:33:53 -0400
X-MC-Unique: njPWVHG2OkG1MHWiLL-KNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02681107ACE8;
	Mon, 17 May 2021 19:33:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE78F5C1A1;
	Mon, 17 May 2021 19:33:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84C2F1800BB4;
	Mon, 17 May 2021 19:33:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HJXhCM021795 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 15:33:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AEAC62166B5E; Mon, 17 May 2021 19:33:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8E7A216FD41
	for <dm-devel@redhat.com>; Mon, 17 May 2021 19:33:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D3AD10334A3
	for <dm-devel@redhat.com>; Mon, 17 May 2021 19:33:41 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-194-8Eow_23pNBulQX3CHT1soA-1;
	Mon, 17 May 2021 15:33:39 -0400
X-MC-Unique: 8Eow_23pNBulQX3CHT1soA-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-b-kTT5GEMFOxCVrWnXDKvw-1; Mon, 17 May 2021 21:33:36 +0200
X-MC-Unique: b-kTT5GEMFOxCVrWnXDKvw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (20.179.248.148) by
	DB8PR04MB5755.eurprd04.prod.outlook.com (20.179.11.31) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4129.25; Mon, 17 May 2021 19:33:35 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4129.031;
	Mon, 17 May 2021 19:33:34 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v4 3/6] multipathd: fix ev_remove_path return code
	handling
Thread-Index: AQHXSzn99+6T/KIoLkS9WBxfb33JWaroBPGAgAALpwA=
Date: Mon, 17 May 2021 19:33:34 +0000
Message-ID: <7058c8c0c6a6ee765dc2772ae497071228658518.camel@suse.com>
References: <1621268999-6280-1-git-send-email-bmarzins@redhat.com>
	<1621268999-6280-4-git-send-email-bmarzins@redhat.com>
	<d18212229ca58f069af5a7489548ff228a3552b6.camel@suse.com>
In-Reply-To: <d18212229ca58f069af5a7489548ff228a3552b6.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d144459a-9ef5-414b-c7b6-08d9196aa976
x-ms-traffictypediagnostic: DB8PR04MB5755:
x-microsoft-antispam-prvs: <DB8PR04MB57550C5C0A6F448EF7C950BBFC2D9@DB8PR04MB5755.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: O7qgPd3FBEVZGrFxmo/WD00lueMhofICOmbjGX9l5QiBcmnzY7+bi1qro7NL59o1pEhs9unHdKGy+B9qXRhw2Pgd0BEQVrijdk3Rrgv8AZyLQqtIoOio+wjTvY4Wr4gPsX3phYfgzdZIf5K4ZxJffDVD6rR5jevCoV0/4eQrmP7Apu37UyuFXrpQAHMEoJsneSGRPY2T+cu1NnHqnGOBVZB6oynJJNEASz7nL/h9S5qmDm2akzrG6CKF+j3Rg5AnUwR0KJqL6i35UcIbBf7t9jBgFu2UqpEb9UhkfFqWhtB4FiIErd6qTwbyqtQhX9t6R8iVrj7NyRnt5Ozc3L7Z3qIreH2cwj5cX53QgeR48h3ADR1IVI4Byp3sXrXpb0kioEyoLBTBGLjjSt2mwq6TiboEIb4HASSOOjFlaF56b2CC5J7xillrDjbIvej4yy8CYiYX7qCluGxWm4AJ4+1OUuUYUMLhVWiW9U7n/Ckm+j+cPsOMcnbPwaqgxW+y22jQQzzyvVtdRjB/Qap2wFIu/bvXPC1zGiwz8ysMWaFaqlUb/hRYc9C3oJRC8LgYaOeKIs3rmmWsKJOEmHjLgPAKfke70tJkrMeZHSKdmGz1SDk=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(376002)(39850400004)(396003)(366004)(136003)(2906002)(5660300002)(66556008)(66946007)(26005)(6506007)(44832011)(71200400001)(4326008)(8936002)(66476007)(66446008)(76116006)(186003)(122000001)(6486002)(38100700002)(316002)(86362001)(36756003)(83380400001)(64756008)(91956017)(110136005)(2616005)(8676002)(478600001)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?Mn4l37KcgTwz54aJAySS/1JnQKsrcu8UbDKj0kXw6oaJLuHJ8r16eOp/f?=
	=?iso-8859-15?Q?jaMehnJdEP9+wh25tu28WfnmRgO+nE3ByCpEyQ5VE830iXdAxLrQ09d+V?=
	=?iso-8859-15?Q?d0h7Fp17In5ZdG/UKpR5zzi+4EfOPORw+0+3YMu4PixfEFFu5CzlYR4tA?=
	=?iso-8859-15?Q?nGtOu70N14Bhjbl1YSxNFWXEMS6sfNSZiy6+2xO3vNOSH5gOskXcDMX7D?=
	=?iso-8859-15?Q?9066U3qAOb2HBpSnXvGvlLLvR/xT/XXUMS+VJ1sz+ztJDfLJT3DS4D4SE?=
	=?iso-8859-15?Q?tDAjIX7H85DzN6409j2eVxuJFZ7Sl3ATTvCjUlP1wTSXVo+xs7QLzO1dz?=
	=?iso-8859-15?Q?3PlPiH2cc/0J5F+/wxPDVa3/y9mOsthMu01L4RDiULzGcWOK6+3j4on50?=
	=?iso-8859-15?Q?bH/WQ/jHk2/Emj7zCMx+GeeoZ1tvqAsIE7ft8fCSW5psdIfesSqni7utM?=
	=?iso-8859-15?Q?+LKpAxlCbTZxVJ45VXEzy0dtbFTzzQKBgJDHXINauOeQapbtaRd3j+eFh?=
	=?iso-8859-15?Q?dREZz9FAfkkJknQgQGUWY5m7Rfl9zHnFmB1wl9pVRfoz4Hq3SXajfaJ65?=
	=?iso-8859-15?Q?RKg3ZjdUPwihrOZ6Aky/2iNmmwb+Isce4Qc3ycp0+H/v1Wa8wzDIVY2y1?=
	=?iso-8859-15?Q?DeaxApt5OtL92Mcyv97Hco0vcLzrfcrSIXTgtI265aAu53dE39BqbRrcH?=
	=?iso-8859-15?Q?3jKD3y0e3Dka8DEBfyQfiXxtInK5NPQA5CCWdkFr+1zAPnnmCHevEteyK?=
	=?iso-8859-15?Q?y/KeKZIZCrMdScZw7fWlfN5tdCB534EHPx7M2zO3uwCdSFbeI7wbpXNrq?=
	=?iso-8859-15?Q?Dj/KNcqTO0lB9OBj7blaU618whg88LWCYud4obdfQVwdYrFFB4s2vfmHP?=
	=?iso-8859-15?Q?toclurD/RyrPzBbHmkihLLMX8wSp5o8vki1pVuu/K4yJCyNMO/btHI/Pt?=
	=?iso-8859-15?Q?eOMkGcwCxp3d2LLb6ARHKfzH0x6FgWSReh5PNvi8O59/P0E0EsNRi21ov?=
	=?iso-8859-15?Q?Vm4W3oD8P+my5me9yrXgsu4ruJ0ivRPXxA3PaZWICrYQeVySOpxafHVr+?=
	=?iso-8859-15?Q?7zuSR94uytoavp8lnkvCeL8iH+PnEc5x88B6FHP7AR58z4GcZrBapNAcw?=
	=?iso-8859-15?Q?IjfW48n7K3BAU+YzljQ8LSw5UOyyWkwp8ZkHmPPrSt1OdWUXvpY9tzoug?=
	=?iso-8859-15?Q?5pgLlPV20AhCn71H+/5FPuM1v4beLXpV1GMt5Xpmroq7R0aZ95WmK4qfl?=
	=?iso-8859-15?Q?TuFrQb16ykgEije5XfYHvN5OwFtw778Vpu9yJYrYEcR75w0ExfqBxVGN+?=
	=?iso-8859-15?Q?0qSGhQWxGtpLzOShJcmSet2iKaguXkHl5pvweXa7aVJUMT0uC0EIGst2D?=
	=?iso-8859-15?Q?qaNP3h404JKljNsLR3bVVBC4P8WouWess?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d144459a-9ef5-414b-c7b6-08d9196aa976
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 19:33:34.9357 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qN0nijK1KJaNIIT8U3uoSuntRp7MVbeAm5yJVQLXfRxxwrFHIEZb2TSUcr0RAY+/1foIUwcVPEtnsngLquMdGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5755
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14HJXhCM021795
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 3/6] multipathd: fix ev_remove_path return
 code handling
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
Content-ID: <B293527985D7A142A5056B073AE2626A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-05-17 at 20:51 +0200, Martin Wilck wrote:
> On Mon, 2021-05-17 at 11:29 -0500, Benjamin Marzinski wrote:
> > When ev_remove_path() returned success, callers assumed that the
> > path
> > (and possibly the map) had been removed.=A0 When ev_remove_path()
> > returned
> > failure, callers assumed that the path had not been removed.
> > However,
> > the path could be removed on both success or failure. This could
> > cause
> > callers to dereference the path after it was removed.
> >=20
> > To deal with this, make ev_remove_path() return a different
> > symbolic
> > value for each outcome, and make the callers react appropriately
> > for
> > the different values. Found by coverity.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>+
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20

It just occured to me that we should probably not have set changed the
return code of cli_del_path() because of a strdup() failure for the
reply string. (It was my suggestion, I know).

Anyway, I've pushed this to "queue" already.
We can change this in a follow-up patch.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

