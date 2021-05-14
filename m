Return-Path: <SRS0=HAWy=KJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B92C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 21:02:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACF5B61446
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 21:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACF5B61446
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-X9bLKnmOP4SUKskYB0O-aQ-1; Fri, 14 May 2021 17:02:13 -0400
X-MC-Unique: X9bLKnmOP4SUKskYB0O-aQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8D71801AE6;
	Fri, 14 May 2021 21:02:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8066E1001B2C;
	Fri, 14 May 2021 21:02:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2253D55347;
	Fri, 14 May 2021 21:02:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14EL28Gm016012 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 May 2021 17:02:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 491EE210EA07; Fri, 14 May 2021 21:02:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43388210EA2F
	for <dm-devel@redhat.com>; Fri, 14 May 2021 21:02:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC058868921
	for <dm-devel@redhat.com>; Fri, 14 May 2021 21:02:05 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-562-uI8jpbDjPrqc2lCNSlTsfA-1;
	Fri, 14 May 2021 17:02:02 -0400
X-MC-Unique: uI8jpbDjPrqc2lCNSlTsfA-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-12-gxA7I5rTM8SG5bdJpfsEvA-1; Fri, 14 May 2021 23:02:00 +0200
X-MC-Unique: gxA7I5rTM8SG5bdJpfsEvA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6844.eurprd04.prod.outlook.com (2603:10a6:10:112::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Fri, 14 May 2021 21:01:58 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4129.028;
	Fri, 14 May 2021 21:01:58 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [dm-devel] [PATCH v3 6/6] multipathd: don't rescan_path on wwid
	change in uev_update_path
Thread-Index: AQHXSP1QdvCIB7jeT0CZa6xh/X9fIqrjdsYA
Date: Fri, 14 May 2021 21:01:58 +0000
Message-ID: <83dc04f45158798e4f9866fa7a7cfb4be01958a8.camel@suse.com>
References: <1621023060-20011-1-git-send-email-bmarzins@redhat.com>
	<1621023060-20011-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1621023060-20011-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c28d0e48-71af-46e5-65b6-08d9171b8391
x-ms-traffictypediagnostic: DB8PR04MB6844:
x-microsoft-antispam-prvs: <DB8PR04MB6844FE384466D9BA605B6D17FC509@DB8PR04MB6844.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2atnzWJynAuoIJgcHlIhnxN+3+CJ1a5f101NYoGO6+jY+7XzlHlbLNMFYp2ekr3oFQFKO4nMJK5GYXAeaGqYLvrDdOfif/G+ZgqlK4DoYAbZWWOYc+cSXLwtFYAEygCS12dfdlNeEGe0AN9kvgoAQktE7K1EsQ4BbRmqEnhptW+nROcezu9LKIFeIYfQV1neCpNt9mIK+NWPuKpp+HH6semd3Yq0UD7AoMwEOS9YpnFl1QavupdzudPuU4v93akYDW1Wd5Ex7DrnNueFiXEr/oCY61RBN72CyJgwIOqNDd6dhzwJ5EjpH4qIPqFqBU7VjAIYfuo8iMZ3jGSC5yLfAOjxTJ95qDbFC00rQWN+dql2lagQqjp1UBVKqxFQt3gjifJNS+agQLDUQ3PEKkkMtObd/8y0a5TwWRR9L2cpi6jQE+GfIKS8/glfyCTJy9AjL+i4CzbUBKwQQauOkUm+u/YdRmxPULe888K+RtBm2Fu9ZSWcQix/dn52l8S5B5Ky4X9cXUdpHl3AZBvReIr98xAgYHDJELIcMqTN6w+9J+s5Uydd1dZptGoRlNMoK+AK/hARWqyuRpGlPDNmwW8FTDMmQeJPxLF0aGHfTmrL83w=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(39850400004)(136003)(376002)(366004)(346002)(66556008)(38100700002)(91956017)(76116006)(66476007)(36756003)(5660300002)(66946007)(110136005)(66446008)(316002)(478600001)(6486002)(2616005)(26005)(71200400001)(6512007)(6506007)(4744005)(64756008)(8936002)(8676002)(4326008)(186003)(122000001)(2906002)(86362001)(83380400001)(44832011);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?j3N+o4YAwH//rTbfB8adE/D+50/fgOxeZyglLQ/f6A4SftHMi0QK3Ac8n?=
	=?iso-8859-15?Q?YfR1c1DXjSOUuMgs7imodssoYPQrW0j6lIlAB3HzaGm8FHtt9vOaR5HIL?=
	=?iso-8859-15?Q?0lsUtKwBUV+iUMMQj8YWHisje6gJASQ8egEAWiDiYg9mXape1RsX2x+f9?=
	=?iso-8859-15?Q?ngUSzL9Z0g/QS/PloSFL0SSAg8tOzKYzey814Iqx9zALNLQ+YNEeOAFoG?=
	=?iso-8859-15?Q?rIrDJeRDfmGvNDafN/1geZPhRTqD5d9b5Cs6w8e/p6gBF1xvDntuxsL8z?=
	=?iso-8859-15?Q?E/L/Y0Mj2ut7LApQkUZQrtg6jOlDnXvUuJuMfrmlqO9lIftaboe3dSfUe?=
	=?iso-8859-15?Q?d+qwxUqf2xEL/bkdnbvRmkNC4rrwKcNfi00HvKQU9+CPuPgqV030mlk+4?=
	=?iso-8859-15?Q?w0eVDpG8euGgOIG2edJfDJvDlFXBjnMThJX+tEl4I/qG3YNKTL+LeAIsB?=
	=?iso-8859-15?Q?7D5X7IlIo4fLWXzp+Sm3DK5LYAHKqLw99uSoNKKoYqf/HQp4MXcZPFvrH?=
	=?iso-8859-15?Q?ioXysctGJ4Hb3Yq9OVicDj2hwvSlp8XcZhOeraQl3hVItr9vUZhloxSRc?=
	=?iso-8859-15?Q?WvOJbyhtKUV/oeyuPITCZDXPckUUp+W7qMS5bIpMuTF6Vdi3mADQjKdHc?=
	=?iso-8859-15?Q?ocTV4koo5rmij/HIO+xL1ZoCf0uTZkOWo3PaHfJufpQrBLXHSFwfG9+QV?=
	=?iso-8859-15?Q?uyatCEV2U/yDxn7Zt+M6cE31Xsb1GAHFwBNro8SlxU9LV6L9j4c92nhBP?=
	=?iso-8859-15?Q?/c0bDh7HFZtOkdPgZqIc7O//xo22R/owNzYR1Hq8zrJJ1CIvaf57A164t?=
	=?iso-8859-15?Q?stgaV4G1nfRcRFOyEvWTgOoo2ryqCGem+zNSuDwOltzrJK+gVOI17GqUY?=
	=?iso-8859-15?Q?O+OaEQhcZevjfRe6UsUrgfdctFXwHI5P1CqxFOlV8wi6OY5W9R855yAjW?=
	=?iso-8859-15?Q?jEg5jDJApcEGbjmtUQOfvj/3i1CVFkS8sPNG+EHxiw1kn/uMMOqlKeTjj?=
	=?iso-8859-15?Q?Bde2RJn/LLNTbxNCGO3fEyWVfWxJwAW+Fmxd1W19FoeyS39/H8/0dCppA?=
	=?iso-8859-15?Q?e83fYbaMruT90iA/ylCQIYILKvh6I4Gd6ZYQpttZXhCIv8r0ZVC2Oe7WC?=
	=?iso-8859-15?Q?qUh5z+vsVpz/X0IPCHZOGk2fAFtEdLo1qU15WkpchPel66A1Obe4RyBLZ?=
	=?iso-8859-15?Q?40bCoZI0qSy6iCqAa+jOfMSRVKwma1SuehR+NkVqvFJZC411rNkFH8lLI?=
	=?iso-8859-15?Q?nwTy91hysq/8TNV6x8pTPCTh1bDSB22JhZqU7KvHIJtYIpdVF6hl+ky5r?=
	=?iso-8859-15?Q?4W94udganHcsh9nRA9AvrIb5Jg2ZYNvBu/KTQ2QZLpuZyTp5DNpBl3Ik4?=
	=?iso-8859-15?Q?HYEa74vL9871PHKskj6c+er9m/ueeT8Ic?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28d0e48-71af-46e5-65b6-08d9171b8391
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 21:01:58.7286 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u/U+Z3wJF5wsIOuy2r8OCUu7s6KTR4clt3X+XMt5soQdQU8J2AYzWCYkn2EpkVwOPXfDpHYSjDTiJ+86nsnPiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6844
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14EL28Gm016012
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 6/6] multipathd: don't rescan_path on wwid
 change in uev_update_path
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
Content-ID: <C7FA3C5679EAA149882B03D094B9DA73@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2021-05-14 at 15:11 -0500, Benjamin Marzinski wrote:
> If get_uid() is returning a different wwid in uev_update_path(), then
> the uid_attribute must have already gotten updated, which was the
> purpose behind calling rescan_path() in the first place.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

