Return-Path: <SRS0=Tzat=JZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9EAC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 06:35:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 901F06140C
	for <dm-devel@archiver.kernel.org>; Wed, 28 Apr 2021 06:35:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 901F06140C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-Rk6X8EVaOBSzcHOnk62QTA-1; Wed, 28 Apr 2021 02:34:59 -0400
X-MC-Unique: Rk6X8EVaOBSzcHOnk62QTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0D00801106;
	Wed, 28 Apr 2021 06:34:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 423BD10016F8;
	Wed, 28 Apr 2021 06:34:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBA381806D1B;
	Wed, 28 Apr 2021 06:34:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13S6Yqh7012330 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Apr 2021 02:34:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D7EB120287A7; Wed, 28 Apr 2021 06:34:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2248202879D
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 06:34:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79472858F09
	for <dm-devel@redhat.com>; Wed, 28 Apr 2021 06:34:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-418-G8FuoV5bNYS24m1jW75cjw-1;
	Wed, 28 Apr 2021 02:34:46 -0400
X-MC-Unique: G8FuoV5bNYS24m1jW75cjw-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-23-0JglE9r4ONyhIgXGgYEieQ-1; Wed, 28 Apr 2021 08:34:43 +0200
X-MC-Unique: 0JglE9r4ONyhIgXGgYEieQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2918.eurprd04.prod.outlook.com (2603:10a6:4:9a::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25;
	Wed, 28 Apr 2021 06:34:41 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027;
	Wed, 28 Apr 2021 06:34:41 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>, "hare@suse.de"
	<hare@suse.de>, "Ulrich.Windl@rz.uni-regensburg.de"
	<Ulrich.Windl@rz.uni-regensburg.de>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Thread-Topic: [dm-devel] RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrqrHuyoAgABJRgCAAALZgIABF3SAgABdJwA=
Date: Wed, 28 Apr 2021 06:34:41 +0000
Message-ID: <643e5f7eb3e2d48517a3288c07af001b30e22075.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
	<b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
	<15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
	<2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
	<ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
In-Reply-To: <ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e10ded24-c0cf-40b9-d4a8-08d90a0fb446
x-ms-traffictypediagnostic: DB6PR0402MB2918:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB29182E363482E4F5F807FB08FC409@DB6PR0402MB2918.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jRXvY6tGTIq61rJLeZbpTD5q0GvYP3qR4isIAssXxUWkUZFOppynf1gMuZs0IwWNPSOte+1RMuex7QuxTiXUl9IWX0ScXFeS06gIBXxxdOI4uFKWr/tzVQxUbNXlVxSpFHWkxjI3CYISJJJ5h9WfK+sNFtMCSF5DtE0SYx2TS3QLNwcx3smGmDYlirxP+5W/NvCFNQi67AFEJ7wCzkD41OaFO8j/yRtIqMvzjjZ7Eyk+JmDKz02F/HFh5iaNfauuAprbJY9ZRVwL9m8ZzD7ukpBNQBkZXT3e1dii1smkHehbkB4aG3jo/CoLfH73QEJvMYRu5C+FpfFlftKeNf0cppQ7o6kGhLruwAdXIjfKE6ioh6RfB0nk3kY+GFoAAIxK352nz49PB++OKRu+pfQn9TvrpLzU+65C70Wm9n5lb2E217J3H66GRA6pdmuRp9b3K/VTg+ai5bJcKTAOdd8k9v9Pl+PWLQQknIAvn6zw+8I97mAq73oVdM+cN1qUdCfviaF85r+1ODno/Vfn3faqY0qKl5dHIdFjEHtO1JZJnghsnADobZeICHkVot3iT/Mxapzt16BIbFg5S02/EWkDBcv0rbHtT2YX2zAUMKKLW8c=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(44832011)(6506007)(91956017)(86362001)(26005)(76116006)(8676002)(2906002)(478600001)(66556008)(2616005)(5660300002)(6486002)(122000001)(186003)(64756008)(83380400001)(66446008)(38100700002)(8936002)(36756003)(66574015)(6512007)(66946007)(4326008)(7416002)(110136005)(71200400001)(54906003)(66476007)(316002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?HmrwsJfIX2PGjpKLl0DnA33rjQNVMUPRMOHEk8DJZygXSCE75z4rdFIVM?=
	=?iso-8859-15?Q?rp3znzNBey55SiOyDOXFlhtm/weFo4L3BtwAPiyqtrR3heNtYjLiC9EeG?=
	=?iso-8859-15?Q?MltA6niEH8dfUbx5vxH34VTtfnXCZjWs6egKs4Y2WlJnJ9K5SNDtoKm4z?=
	=?iso-8859-15?Q?hxGi8u5sWB04WfVnlspjumyX+wWbvMARezQMyjSvESG4nCZqCX01Y3ZBo?=
	=?iso-8859-15?Q?mrRenOit4NsLBqteA0QQCsZit6MxaabO3iLZKNK4ts68al4oymv6DOUU/?=
	=?iso-8859-15?Q?09s/UQdril0xcyg9MS4OE1aueCzVPjZx6Mlgs//gdjyBTme6JqL29Otl1?=
	=?iso-8859-15?Q?HjVK2lUbemP+cyAOPoZ+g2iPCS9ZiMCFKEg+LLKXUm3QBb+ne50Qzlyir?=
	=?iso-8859-15?Q?W+RPunhO6iihwcEbtAqIBjGXYlzDKXpxxbuieWHMCBZ06IaSGS94aLiGA?=
	=?iso-8859-15?Q?F2rtQXnBZZbyNOyZn041ER7DJzIg0HcSvDPNf7v2bI9eNw47rzGkY0Z4i?=
	=?iso-8859-15?Q?vYYBkO8x+CV9N9bNjWr6qiJtXCphFad6HdkyBt+Hqj6FSGOUaFbKiZK8r?=
	=?iso-8859-15?Q?Emxyk4GnurJZ9Ef2NNdXGf0k+NhJr0dPuwH/5tf+1yScs8KngsYIHrVWM?=
	=?iso-8859-15?Q?ScZYo1Ff5TZbqYxn7oP6We9DbPSq0pBtJBQ0YFOdo2cK69NaJa37beco7?=
	=?iso-8859-15?Q?Zmx7cMoSMH4N7QiryR3Yaw/9m+V/QILuavaS23GRk2vy1LMhs0hFy329G?=
	=?iso-8859-15?Q?VU876667w2k9HW0m4lDfNpYv19RCcU2NbC4a+Or923wx0bkCtVrt+M7OQ?=
	=?iso-8859-15?Q?eUBJEEj4DHgnLlqyOxLjZfXvKEYo1UG0/Hxesaz66hqtBHUvSK/J7Rj1W?=
	=?iso-8859-15?Q?pTydqGr5ktZAeR8vjVOAdR4uMYCwnKmu4MnpQlKmvNRq5GjfGUS9T6oaV?=
	=?iso-8859-15?Q?YhmhpkJdh9yu9u1S5xwyTlHcetlTFaJQcNVt+N3qYM1CEivbb0eZMCIkN?=
	=?iso-8859-15?Q?l8laRHWqCWmseemjsQ0u22/spNmKdvYJWUTFnzEC1NhgrMcOyCVMMf1nh?=
	=?iso-8859-15?Q?5g2nwnRZ6/GnP3qoWxN9koVbEzRixs3Qg3BMf2WEMIyJ9l+fYolVHf428?=
	=?iso-8859-15?Q?I5GZ6af8PEMKTdrgKJLuTHD7SIHqxm0se4sI9g+Q97nmKsyb2XkZyE1mf?=
	=?iso-8859-15?Q?Nrys4+QQfi6euyJBS141OrsMs5Qxa+m4qe2kfZcWYJCoXVW4u6xSIf5fJ?=
	=?iso-8859-15?Q?gUdv/g0rB9GaW1QmFHk3lRy09QPZrujyjj1/1v2v+PMnx2lYnJsX+zeWP?=
	=?iso-8859-15?Q?OTmwi9v9FaiA9sv3DW5Afij8rvPDYG27u6CodXitYR/lUx6bjCpxj8l/f?=
	=?iso-8859-15?Q?jmf6BXLSJYDIqt3sSUpDf+APnKID3EBKn?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10ded24-c0cf-40b9-d4a8-08d90a0fb446
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 06:34:41.4184 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAiGi7vpj5cs3LjaAFsRZZBcbc+dLgvBpswnu3tr6mN9GYXkECzNx6ebBTsF2CsgL3XX3kz5Ly2J/fUDh+tvcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2918
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13S6Yqh7012330
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>, "systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
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
Content-ID: <DBACD37E038FFC46B694A487E602089B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-04-28 at 11:01 +1000, Erwin van Londen wrote:
>=20
> The way out of this is to chuck the array in the bin. As I mentioned
> in one of my other emails when a scenario happens as you described
> above and the array does not inform the initiator it goes against the
> SAM-5 standard.
>=20
> That standard shows:
> 5.14 Unit attention conditions
> 5.14.1 Unit attention conditions that are not coalesced
> Each logical unit shall establish a unit attention condition whenever
> one of the following events occurs:
> =09a) a power on (see 6.3.1), hard reset (see 6.3.2), logical
> unit reset (see 6.3.3), I_T nexus loss (see 6.3.4), or power loss
> expected (see 6.3.5) occurs;
> =09b) commands received on this I_T nexus have been cleared by
> a command or a task management function associated with another I_T
> nexus and the TAS bit was set to zero in the Control mode page
> associated with this I_T nexus (see 5.6);
> =09c) the portion of the logical unit inventory that consists
> of administrative logical units and hierarchical logical units has
> been changed (see 4.6.18.1); or
> =09d) any other event requiring the attention of the SCSI
> initiator device.
>=20
> Especially the I_T nexus loss under a is an important trigger.
>=20
> ---
> 6.3.4 I_T nexus loss
> An I_T nexus loss is a SCSI device condition resulting from:
>=20
> =A0a) a hard reset condition (see 6.3.2);
> =A0b) an I_T nexus loss event (e.g., logout) indicated by a Nexus Loss
> event notification (see 6.4);
> =A0c) indication that an I_T NEXUS RESET task management request (see
> 7.6) has been processed; or
> =A0d) an indication that a REMOVE I_T NEXUS command (see SPC-4) has
> been processed.
> An I_T nexus loss event is an indication from the SCSI transport
> protocol to the SAL that an I_T nexus no
> longer exists. SCSI transport protocols may define I_T nexus loss
> events.
>=20
> Each SCSI transport protocol standard that defines I_T nexus loss
> events should specify when those events
> result in the delivery of a Nexus Loss event notification to the SAL.
>=20
> The I_T nexus loss condition applies to both SCSI initiator devices
> and SCSI target devices.
>=20
> If a SCSI target port detects an I_T nexus loss, then a Nexus Loss
> event notification shall be delivered to
> each logical unit to which the I_T nexus has access.
>=20
> In response to an I_T nexus loss condition a logical unit shall take
> the following actions:
> a) abort all commands received on the I_T nexus as described in 5.6;
> b) abort all background third-party copy operations (see SPC-4) that
> are using the I_T nexus;
> c) terminate all task management functions received on the I_T nexus;
> d) clear all ACA conditions (see 5.9.5) associated with the I_T
> nexus;
> e) establish a unit attention condition for the SCSI initiator port
> associated with the I_T nexus (see 5.14
> and 6.2); and
> f) perform any additional functions required by the applicable
> command standards.
> ---
>=20
> This does also mean that any underlying transport protocol issues
> like on FC or TCP for iSCSI will very often trigger aborted commands
> or UA's as well which will be picked up by the kernel/respected
> drivers.

Thanks a lot. I'm not quite certain which of these paragraphs would
apply to the situation I had in mind (administrator remapping an
existing LUN on a storage array to a different volume). That scenario
wouldn't necessarily involve transport-level errors, or an I_T nexus
loss. 5.14.1 c) or d) might apply, is that what you meant?

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

