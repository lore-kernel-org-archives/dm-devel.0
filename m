Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDE0C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 08:45:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E83BB60C3D
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 08:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E83BB60C3D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-AT-I9s69PIeDQ0_lPvYHRQ-1; Mon, 29 Mar 2021 04:45:07 -0400
X-MC-Unique: AT-I9s69PIeDQ0_lPvYHRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93D71107B7C5;
	Mon, 29 Mar 2021 08:45:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A8E95D9F0;
	Mon, 29 Mar 2021 08:45:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6EDD64BB7C;
	Mon, 29 Mar 2021 08:44:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12T8iuQs009415 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 04:44:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D4ADC2D44B; Mon, 29 Mar 2021 08:44:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCED22ED91
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 08:44:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8441185A5BC
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 08:44:52 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-160-NpTiv9feOhWpbKOO6XTCqA-1;
	Mon, 29 Mar 2021 04:44:50 -0400
X-MC-Unique: NpTiv9feOhWpbKOO6XTCqA-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-6-jThgnN5FOIatgHmpoA4zjw-1; Mon, 29 Mar 2021 10:44:47 +0200
X-MC-Unique: jThgnN5FOIatgHmpoA4zjw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5067.eurprd04.prod.outlook.com (2603:10a6:10:1a::28) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32;
	Mon, 29 Mar 2021 08:44:46 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.033;
	Mon, 29 Mar 2021 08:44:46 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 2/4] libmultipath: fix priorities in parse_vpd_pg83
Thread-Index: AQHXIdphHMXt7za5/0CjNSBmSMx0R6qWe/iAgACfY4CAA5B5gA==
Date: Mon, 29 Mar 2021 08:44:46 +0000
Message-ID: <31162621ac38601976bfa51db92989471fd4c23e.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-3-git-send-email-bmarzins@redhat.com>
	<1088f960e04492a26530385040b2485b3691c94e.camel@suse.com>
	<20210327021853.GI15006@octiron.msp.redhat.com>
In-Reply-To: <20210327021853.GI15006@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ec3bd1a-4d0e-465d-cfb8-08d8f28ee7e6
x-ms-traffictypediagnostic: DB7PR04MB5067:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5067E81B1F46AEB43547AFF6FC7E9@DB7PR04MB5067.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: m56oRECeXGS+yU/n58PbpuGURwagofdt4DT++J36VYs9hZGqfzBBHVKQHOed4+DOXtBCDZ/nrmNxN0TbEn4XJTJ7ZCucnMAFlzk3IWcbwZlI9NdJWyWluhHCwfQSXu4IYCsBe7FN6YsanoVQg/dt6n0CiKdmWsbbjHw04ibOvZAlaJrnLunba0jEUvBqKjryJwZddnP9Rr4MQO1wD0GGp0b/oSChoBEPAvFhsY5f12v3+FhqCYbp+Q2gOkSB6SGGMkd2cRkUFjszHWdE0VfihgND6HgrdjzaBoHoUO+S5QzC28JuVzniOI8ju0zxGfR3qeBAYgYgVjrSlOn6B2SqZnd5E9T2ABp07DDNrNq33OPwR/M015p6NfkAGJtRPt7she5asei/ghwrJc/Qpi+zii3W9xRqWZFF6es3X3YlAYg0K4eQtOehfBXDSc+I5Y/13+OM01Gw832GVUp0+8bvf4Li182F8CzRyhdyOZm89rGxot3lODcJlfdtRAZG5EHRMgcYs5WRBBFd4P4HdRF1VCqVN0XqVkHQt1zSoNLnhvoVWCZ0zgUNkPlIkUlT55+2HE0rcEzYCellkqU/6yAQJDVckYOVXBve2oB1YYu40WlYvU034eJ4wDnMguDWrSOlZcv/5m6xvXrdRGPRYP7zc6e6E2ekvglKRkLWDBPH0bXhy8N6hGUV65LWt/GWfMjQE0hU9HJ48Rj9q5pQ6iN0s0FbWwcxl8Ef8VNbkpYf1UU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(66556008)(91956017)(36756003)(76116006)(8676002)(2616005)(64756008)(966005)(66946007)(66476007)(478600001)(66446008)(6506007)(38100700001)(4326008)(54906003)(6486002)(6916009)(71200400001)(83380400001)(316002)(5660300002)(2906002)(6512007)(186003)(44832011)(8936002)(86362001)(66574015)(26005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?eZoupAnNwOVDH7vpoRfLBpPMAuhT2+2CZb07zJzJH06J5sRTt2ptJhG6s?=
	=?iso-8859-15?Q?dFHlXVKeYPUSNv1j1+4nNt04qYQj8+JvMMrZUmIbPID+QjmzQZymJOA8v?=
	=?iso-8859-15?Q?hWMMWSlqBeRbUffjYY+YMyrW16VCpl0lwqV5qssq0klZlJE1WB/N6A4o2?=
	=?iso-8859-15?Q?DJfpK2NNJ4CassMVslxQ/P3tsbYdtbaoLZMWycg2ckv7Z2RaGgsXETG+A?=
	=?iso-8859-15?Q?iDzh8AhxO2RPNffB2gPftDh9RDO1GJRl1LnZbBmq1aYBHRFuOOBNyvTsb?=
	=?iso-8859-15?Q?S9QGVLmI+dzmkgOHNncq4QUJsCxqQwx2ovs2mySPp5E0JPkGewvfiP4wW?=
	=?iso-8859-15?Q?rZIOBaiDAYiePcSBQLt8gojD43A8Bju5xJHrrzNnh2ToIBe7eqjMlduR9?=
	=?iso-8859-15?Q?ZrKNjmT3wCZkfgRGm0+oFtB5iD2ICldtANKAGA6icQvhi5Nn0Qew+hqOr?=
	=?iso-8859-15?Q?yckIUR5iNZ1Mh1CIvzwdrr6cFpGc8N+zKVKKYZuh4MloPIVWfWrunNvGI?=
	=?iso-8859-15?Q?f88sTW997JdAbRdbJmTXfILmRLLs9x8x4VAPpPG2iki3kcUaVBFtMHg//?=
	=?iso-8859-15?Q?mB+mloFdmWD9mL0krWvn+Ivpe7P1GEtZ7NFkPd0VNolZGzBMPmS6Q+Lfa?=
	=?iso-8859-15?Q?KMZ0Ch2u1M/BddB5c+emlQjn3g6u2ggMgbpGr8hjXdKIsuk2PRsr5sw8j?=
	=?iso-8859-15?Q?OGBLPAww009FFBpsITKpRqAZdBfEEhQC/CdLuFM4yFwFKz2lTANvKarjW?=
	=?iso-8859-15?Q?1jMr7godD30Aje2Aob9EI5RtO7iKAgj43OB91oahWyOe5sAugHRcfwmu/?=
	=?iso-8859-15?Q?ux//CCLsXY9mfcq63Q4zHk/UZn0ROjBjsvkFiRzzL+eaSIAgE81dYANVA?=
	=?iso-8859-15?Q?Q9JXvdv6aRck4TaL0TMlzzyIVpWZ1KsCpP0HrUiBpFM3B/PRKsXFqOD+E?=
	=?iso-8859-15?Q?tAW1bafBu/SvIAi+Zmo/ALQT4hXiCLuevLWRNFZjOdYaUX9oZOhHzDB/g?=
	=?iso-8859-15?Q?cTuw7uQiJofjz6ntLYJ+t60Ft7M2F4bCV/trCJ2JNzbykFh9ZnmVcLIv9?=
	=?iso-8859-15?Q?D0H90nIha5vTd8hQabcm+6kvwo46Ake0vcP++bizq9mcggOzcKK8FwJhk?=
	=?iso-8859-15?Q?VmdeVAMjDKxkzcCUlsdnex/VXL9w2ZZrpCV534141bCg3QuTv1RQPYLoo?=
	=?iso-8859-15?Q?3gsVE4fFdmxKEUG10CDtE3iLjUIGjqzixoaN46bfwYllYLiMDKu8Aph08?=
	=?iso-8859-15?Q?Gg9aVL4zVo9th9n8jO6zMVSbE8uuihAjUKmbDMPL97STU+wfyUXscIU6s?=
	=?iso-8859-15?Q?ZEN7Tf9/XIf/nmKpKaRBz5sUh/lHL6UWadXxjgbo53SoAWOup1HSKqQLd?=
	=?iso-8859-15?Q?FlmuIaawUdyWcxb8bJvm7MQGfBC2/y1jN?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec3bd1a-4d0e-465d-cfb8-08d8f28ee7e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 08:44:46.1197 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9gNsY3bi3N47EeZXXsmIAAbbiEOWIZdL3TAX2dxA2AhG+IJtzrbpuaXfRfHy/z5jc2hsci88LPPFkQLiqmlTxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5067
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12T8iuQs009415
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH 2/4] libmultipath: fix priorities in
	parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A53C8F3CD68EFD4F8DB8368B557807BC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-03-26 at 21:18 -0500, Benjamin Marzinski wrote:
> On Fri, Mar 26, 2021 at 05:12:36PM +0000, Martin Wilck wrote:
> > On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> > > The priorities for the EUI-64 (0x02) and NAME (0x08) scsi
> > > identifiers
> > > in
> > > parse_vpd_pg83() don't match their priorities in 55-scsi-
> > > sg3_id.rules.
> > > Switch them so that they match.
> >=20
> > I think we should rather change the udev rules file, to be
> > consistent
> > with what the kernel does:
> >=20
> > https://elixir.bootlin.com/linux/latest/A/ident/designator_prio
>=20
> If we were going with the kernel as a standard, we should also change
> scsi_id, since it doesn't match that the kernel either (or the
> priority
> ordering in 55-scsi-sg3_id.rules for that matter).=A0 The bigger issue
> here is that distributions would need to make special plans to take
> this
> change, because user's devices would change uuids, which could cause
> problems on existing systems. It will definitely do so on systems
> using
> multipath. Devices will suddenly change wwids, which will rename
> them.

True. (Although this would happen only to devices that provide both
type 8 (SCSI name string) _and_ either type 3 (NAA) or type 2 (EUI-64)
designators. I'm not sure how many of those exist)

I wish we'd been consistent in the first place...

The preference for type 8 in the kernel dates back to Hannes' patch
from 2015: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()"). It makes sense
in general: while the specs don't explicitly mandate preferences, SPC-4
lists the designators in what seems to be a "increasing priority"
order, and the "name string" format is listed last. Also, "name string"
has the same or even stricter formal requirements than the other types,
while allowing iSCSI name strings besides NAA and EUI-64 identifiers.

> The whole reason why Red Hat installs 55-scsi-sg3_id.rules as
> 61-scsi-sg3_id.rules is beause we didn't initally include it, and we
> don't want go changing people's device UUIDs, so is has to go after
> 60-persistent-storage.rules, which sets ID_SERIAL if it's not already
> set.
>=20
> On the other hand, it's obviously safe to make our fallback method of
> getting wwids return the same wwids as the primary method does.=A0

Ack.

> Since
> recheck_wwids relies on both methods giving the same wwid, I would
> argue
> that it's a bug that they don't. If we don't add this fix, then we
> should add back the code that disables recheck_wwids if multipathd
> doesn't see that both methods return the same wwid at least once, so
> we
> know that we can rely on parse_vpd_pg83.

I was hoping that we could eventually settle on the kernel's priority
list. By doing so, we could perhaps some day actually rely on the
kernel's "wwid" attribute rather than logic of the udev rules (IOW:
change the udev rules to simply use "wwid"). I believe being able to do
so would also be in the interest of SID, am I wrong?

For now, I suppose you're right - it's more important to retain
backward compatibility. So, I'm going to ACK your patch. But we should
try to figure out an exit strategy for this, if possible without adding
yet another configuration option for device detection in multipath-
tools.

As a first step, we could change the udev rules to set a device
property based on the kernel's "wwid" sysfs attribute. For now, that
property would just be yet one more ID attribute. We could make the
rest of the udev rule logic depend on a conditional which distributions
could control. I.e. "modern" setups would _only_ use the "wwid"
attribute and not set ID_SERIAL any more. Distros with major interest
in backward compatibilty can keep ID_SERIAL as long as they see fit.

multipathd could figure out the system configuration from the (non)
availability of certain properties, and use an appropriate fallback
logic for either case.

>=20
> Speaking of which, I was planning on doing more work to make our
> fallback method of returning wwids work more like 55-scsi-
> sg3_id.rules
> and 60-persistent-storage.rules. For instance, both of those will
> fall
> back to using page 0x80, if setting ID_SERIAL from page 0x83 fails.

Yes, that'd be a good thing.

I think I've made my point that I'd like to achieve consistent behavior
between kernel, udev, and multipathd some day. We should have a plan,
and should make sure the kernel people are on the same boat as us.
I think I'll write to linux-scsi to discuss how we can best proceed.

Best regards,
Martin

>=20
> -Ben
>=20
> >=20
> > Regards
> > Martin
> >=20
> >=20
> >=20
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =A0libmultipath/discovery.c | 16 ++++++++--------
> > > =A01 file changed, 8 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > > index 5727f7a6..f8044141 100644
> > > --- a/libmultipath/discovery.c
> > > +++ b/libmultipath/discovery.c
> > > @@ -1152,19 +1152,19 @@ parse_vpd_pg83(const unsigned char *in,
> > > size_t
> > > in_len,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0break;
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x8:
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* SCSI Name: Prio 4 */
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (memcmp(d + 4, "eui.", 4) &&
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "naa.", 4) &&
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "iqn.", 4))
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x2:
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* EUI-64: Prio 4 */
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (prio < 4) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0prio =3D 4;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0break;
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x2:
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* EUI-64: Prio 3 */
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x8:
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* SCSI Name: Prio 3 */
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (memcmp(d + 4, "eui.", 4) &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "naa.", 4) &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "iqn.", 4))
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (prio < 3) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0prio =3D 3;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> >=20
> > --=20
> > Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> > SUSE Software Solutions Germany GmbH
> > HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer
> >=20
>=20

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

