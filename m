Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27559C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 10:57:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-HvyEcF3GO06EPibQDU4aZA-1; Thu, 03 Mar 2022 05:57:48 -0500
X-MC-Unique: HvyEcF3GO06EPibQDU4aZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 269B9824FA6;
	Thu,  3 Mar 2022 10:57:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D1AA76C2D;
	Thu,  3 Mar 2022 10:57:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52CCE1809C88;
	Thu,  3 Mar 2022 10:57:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 223Avdr7008675 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Mar 2022 05:57:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 74CB2C27FA7; Thu,  3 Mar 2022 10:57:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FF65C27FA6
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 10:57:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52221185A79C
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 10:57:39 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-434-LPb5Oy5FObaqEAPZnneWYQ-1; Thu, 03 Mar 2022 05:57:37 -0500
X-MC-Unique: LPb5Oy5FObaqEAPZnneWYQ-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-20-ofK-WgWiPiOVfeKG9U1_oQ-1; Thu, 03 Mar 2022 11:57:35 +0100
X-MC-Unique: ofK-WgWiPiOVfeKG9U1_oQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by HE1PR0401MB2604.eurprd04.prod.outlook.com (2603:10a6:3:83::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14;
	Thu, 3 Mar 2022 10:57:34 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::357f:742:c1c7:8fe6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::357f:742:c1c7:8fe6%4]) with mapi id 15.20.5017.027;
	Thu, 3 Mar 2022 10:57:34 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"ritika.srivastava@oracle.com" <ritika.srivastava@oracle.com>
Thread-Topic: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
Thread-Index: AQHYLu18Ivy+w7tBtUy+DPFJz1H8iw==
Date: Thu, 3 Mar 2022 10:57:33 +0000
Message-ID: <455157a88c1087de6cc5c1350e64e1a49eb371b1.camel@suse.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
	<20220222193143.GW24684@octiron.msp.redhat.com>
	<441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
	<20220228224435.GY24684@octiron.msp.redhat.com>
	<1C4A63A7-0ABB-4A26-9C4A-4BD4EA192B1A@oracle.com>
	<20220302183854.GA24684@octiron.msp.redhat.com>
In-Reply-To: <20220302183854.GA24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f946865-7e69-4059-f7c6-08d9fd049f14
x-ms-traffictypediagnostic: HE1PR0401MB2604:EE_
x-microsoft-antispam-prvs: <HE1PR0401MB2604157051A9373047152154FC049@HE1PR0401MB2604.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 48+Dg2qnxQ6ua/ZFYW7feVM3JpYoLpZMCiiY/9fnr6JBvsJXEmGtpYe/uG5uDuTD1sRyaLLVQ57ghxHggRESavdGZM8KYiTS+e4Hc3pmS8hny+iOqmpx0IPoPVW9Y0S6hL3yDAqJv5kw1IDzPbaJurkPPcejDLWa+PmD64fKwDLSIl0vm9etec973HUCbf2FwGcENkn7fFeYnrdrsZ647m+WPI0vft1Mgkh8cyG9Y4kFDI+QK5Qp8pyFPOwHnj178JtPu8W+j+SRlB+gtoGh91CJJLYYIGACtYyE922jOmy6mZoX54VScz/GMC1WC1feu7Glt9OtZkrdk1jNDUhVubzgouz1Sm4J0dviOa6rnrENRqB+ARIqF5seTyGdma0SKDaCHIcPBleGxP3sNT3XpbXQMdcsi/kZ6H/pP35Tbwn6tL98Ceqxkl+QHlY2/1uBX/pAYdV00dd+YW+4tlE3WQ3C1dQspr+ASAm7nimRPRKKnLdeOMP1MLgxI4I2rOPKyrrUF8SLCQEi7NYWFgtDT5ITn9/upzLps5BvqwQ9WoU9RrN3j3O0LMTmvckuTAkDAEnZ+nReHEk91kF8UMful0OEw2zoMVdr56Y6L1awRas/3RVFFkyYkqlZBDhei+rG1Kg6CUjApqYLjr636Vde7LRKWDTgLKVjk4EU49stAw/yiCqq3Tx4J8/iS7U79BNjZkhMvcz/4JP/3cs0fSzBOQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(508600001)(26005)(186003)(83380400001)(6486002)(122000001)(38100700002)(44832011)(2616005)(53546011)(36756003)(6506007)(6512007)(64756008)(66446008)(66476007)(66946007)(76116006)(91956017)(66556008)(8676002)(4326008)(5660300002)(8936002)(2906002)(86362001)(316002)(110136005)(38070700005)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?9bFj2zwPrGQ3etCDEAlJfn+ZNVOQZ6D99o5UkrsemcVcKz7YCFrvk0nsn?=
	=?iso-8859-15?Q?BIXqXxo1uvbVQPh1aLXFDSt2wXJkVW2U6Nlah0ao+o9184eZoCCsToL3w?=
	=?iso-8859-15?Q?Dasi3L+ED6Zg8p6kPgRSJddb+FoXYoK3sYVH5OIaYMLneQ1HTv/qzyZqV?=
	=?iso-8859-15?Q?a203hiwEB+lyR79fTjNwCaakrL0fReDN1H3woFfAEqAuRfT9qvowk2TZA?=
	=?iso-8859-15?Q?z/E4E/FBTuMdZyJYILtXwfOS0/3ERNx0pGBlP+2AmHzNlKoktJTDh5vrS?=
	=?iso-8859-15?Q?142ywaSWXVhsU89DGaElvZ8/nl/vk/0ojz/1fwX+4mMF4bTiecKIaPqAp?=
	=?iso-8859-15?Q?Fy9ApMzUyK5RkntxPERwp7a64Sx29cDAciyKkorYanUsTKh58wWvxASEO?=
	=?iso-8859-15?Q?vL/VldH0fZWCxgkz6hWDEvuZlgVDqX93kri+nzkBxGR3q4tJYTH19qmAI?=
	=?iso-8859-15?Q?4NBGVFW8CiRZ/xUVhTyhoCQh6QsIAc5r4M8+b/3j6SJ4km4OeRv3lmi6L?=
	=?iso-8859-15?Q?BeOSsrYmSX26icDhdb2ud+YeaUsM4kCoWlzIqtq/ZHJDVZBfRyc/AWGEJ?=
	=?iso-8859-15?Q?G489SucJrJ1KSQn8kICzJAnWCrmFDZyXrPA9V2qP2ejxt7iLsIym+VM2F?=
	=?iso-8859-15?Q?lNwko0hpb1emDXP/Kp4zuE0+6KCfw2EDjnLUGdjkBXquAOlvz5Xsmyn+c?=
	=?iso-8859-15?Q?g//HcKgjQpzX0vKM3/8Fc7WJsOLWhPvBIooh/nmyu88dyOpvgsvUUTi29?=
	=?iso-8859-15?Q?BpIL4iPRmBvt/SGiw7Nu0TFGrKelL1rpG+tEXFiw+eXJJ7BORBlYg6wDo?=
	=?iso-8859-15?Q?OgI4SCHzHjWQXedxnIxY/akRcBV1yuR7jADxIY0B+ST+rbwaY9LaxX9Q6?=
	=?iso-8859-15?Q?EUPc2cli5Zx9gFt+XU3AUTxCcfuos8eO/UXA9O9eUNRbNBx8p4PxFf7MK?=
	=?iso-8859-15?Q?Gv/V9efTYFMSwLKVd+RvK8Jusik+HFfkcCJHSS5q644ooTfGmYqUwM/OC?=
	=?iso-8859-15?Q?O4AllWKzVq/1XxrLIdu7szy93RhjkQ6VBUTot9WMKGK1MRHEo/0W+qs/A?=
	=?iso-8859-15?Q?7gfbrduYHNqDc2Wa9fDwNizuLXXFjnV+IGs+6KSXGtj4AxBxQ4J+269BS?=
	=?iso-8859-15?Q?wAR8bimWXXjdYIx6U85bnNsKd9svljIAAhSGnAwGhbBUkF4yZ9UiYamgY?=
	=?iso-8859-15?Q?O7hAX/5yn2etKh87ihOOnGgnzbzBGm8UEr3MnPQE/Qw6wHn7dICiaRtgO?=
	=?iso-8859-15?Q?kZ3eEARnPzlnrGhlRGtARItYJfHU9xfxWslc44L4tdmxniiNbjnLVwUcC?=
	=?iso-8859-15?Q?oeZJgV8rhepc9eDZVxneaTHUOYFTj27tp2qTQ2imGHqhG7NhU5MuyfJVT?=
	=?iso-8859-15?Q?yU8F1QdakJ3NU+3IXdLEQ+jGoCPQTvJsPM8KFZUPeqmQweaitmYet/HvA?=
	=?iso-8859-15?Q?eRvWP4jS2M5agrbtKGGXhS7kHNU9OZx0lAiCdkXTdSM6WeoTzj+R6u4db?=
	=?iso-8859-15?Q?Y+OsJvPaBUXY1pq/TY7kxsmjMz8mq0I06Rd+iNkjJceg0Dnj5MYQHySjv?=
	=?iso-8859-15?Q?H1j3vkoxA69ZS4cHu8P2wVTR9tPVMSutpvlA5PgKkazl3nm9jvfi7nGwK?=
	=?iso-8859-15?Q?8x0AmDSuiQGNEz9Do/ngVO3jTFAPoBJqzjV6W1JsRkwBCi0SgSabbiXtl?=
	=?iso-8859-15?Q?DuWqnrCFIOp/Az9JDovwr9wfR4Rm+BQRdBes1t0HdybKRlw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f946865-7e69-4059-f7c6-08d9fd049f14
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 10:57:33.9658 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1D7hb9EdMVD8zfGIlxtT6kHTruF6UveyTFLNEL8OXcjc54pWm9X5eRjjC/V/RFT36bPdCEihiRvudWpFgn2W1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2604
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 223Avdr7008675
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D7F2C0541ABF1F4588E525609A8A95B8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-02 at 12:38 -0600, Benjamin Marzinski wrote:
> On Wed, Mar 02, 2022 at 12:07:11AM +0000, Ritika Srivastava wrote:
> > On 2/28/22, 2:44 PM, "Benjamin Marzinski" wrote:
> >=20
> > =A0=A0=A0 > So unless I'm missing something, we'd only really want this
> > for removing
> > =A0=A0=A0 > a kpartx device, in the case where somehow you have
> > /dev/loopXpY
> > =A0=A0=A0 > partitions without the LO_FLAGS_PARTSCAN flag set on the
> > disk. That
> >=20
> > That's correct. We only want this option so that once PARTSCAN flag
> > is set,=20
> > Kpartx -d can delete /dev/loopXpY.
> >=20
> > =A0=A0=A0 > seems like it shouldn't happen in the first place.=A0
> > Obviously, you
> > =A0=A0=A0 > showed that it can with parted.=A0 But I would argue that t=
his
> > is a bug in
> > =A0=A0=A0 > parted.=A0 If parted is creating partitions, it should set
> > =A0=A0=A0 > LO_FLAGS_PARTSCAN so the partition nodes get cleaned up.
> > =A0=A0=A0 > I suppose kpartx could check if there are partition devices
> > for the loop
> > =A0=A0=A0 > device, and if so, it could set LO_FLAGS_PARTSCAN before
> > doing the
> >=20
> > Would removing all partition nodes (/dev/loop0pY) on kpartx -d be a
> > better solution.?
>=20
> Like I said, if we fix this in multipath, then checking for
> /dev/loopXpY
> devnodes, and setting LO_FLAGS_PARTSCAN before deleting the loop
> device
> if they are present seems like a better solution.
>=20
> But again, you can make a pretty good case that when parted creates
> those partition devices, it should set LO_FLAGS_PARTSCAN so that
> their
> devnodes will get cleaned up.

I guess that would do no harm. But parted, too, is agnostic of how the
loop device was created, so I wouldn't call it a bug that parted
currently doesn't set this flag. Arguably, the flag should be set when
the device is created, using "losetup -P". I find it strange that
Ritika calls that a "workaround". IMO it's the one and only correct way
to set up the loop device.

> Leaving devnodes around doesn't cause lvm issues. But adding loop
> partitions can cause lvm issues.=A0 This is why I don't like the idea
> of
> kpartx creating them.

I agree. kpartx is a tool for creating linear dm mappings that behave
roughly like partitions. And it should stay that way.=A0We (made the
mistake to) add convenience functionality to setup loop devices when
kpartx is called with a regular file argument. That doesn't mean that
kpartx is a generic tool for handling loop devices or partition
devices. We should stick to the "do one thing, do it right" philosophy
here.

TBH, he usage "kpartx -av /some/file" just to create the loop device,
if the file has no partition table, looks like an abuse to me. I
wouldn't recommend to rely on that behavior. It might change in the
future.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

