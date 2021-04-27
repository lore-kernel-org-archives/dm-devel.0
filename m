Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4348CC433ED
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 08:13:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 82EED61289
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 08:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82EED61289
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-rp1raHT3MfOu61sBytjvFQ-1; Tue, 27 Apr 2021 04:13:20 -0400
X-MC-Unique: rp1raHT3MfOu61sBytjvFQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB858107ACFC;
	Tue, 27 Apr 2021 08:13:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE83619D7D;
	Tue, 27 Apr 2021 08:13:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2CBE844A58;
	Tue, 27 Apr 2021 08:13:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13R8B7aE021951 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 04:11:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5CABA208BDCE; Tue, 27 Apr 2021 08:11:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57AF9208BDD8
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 08:11:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 616DDA2880F
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 08:11:04 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-318-uim35-zbPPaRgMYh9uV_NA-1;
	Tue, 27 Apr 2021 04:10:59 -0400
X-MC-Unique: uim35-zbPPaRgMYh9uV_NA-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-39-khlGQZbdPQSsu-mgTM-W-A-2; Tue, 27 Apr 2021 10:10:57 +0200
X-MC-Unique: khlGQZbdPQSsu-mgTM-W-A-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7351.eurprd04.prod.outlook.com (2603:10a6:10:1b2::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23;
	Tue, 27 Apr 2021 08:10:53 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027;
	Tue, 27 Apr 2021 08:10:53 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Thread-Topic: [dm-devel] RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrqrHuyoAgABJRgA=
Date: Tue, 27 Apr 2021 08:10:53 +0000
Message-ID: <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
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
In-Reply-To: <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5068325c-fee6-40da-9d8b-08d90953fa56
x-ms-traffictypediagnostic: DBAPR04MB7351:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7351FA565CF9E2B05FAB89F8FC419@DBAPR04MB7351.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BEiRdmxBWsbbMTVd2LwrVtI4Wk5ufzmKMb2haN0qkl9cB4DMYBTJUF+XOb0hIl5rdPXb35RYsgWgmYG7P+2CrTHJTKG6Xj6NYh4oqtZVcPGku1jGsrWqlhQif/WWTXHySm9X4OAff6wuvlkrL5vMA6mDBlgFOYnC3thslpTqqfB1btP1bGjNiSZJZLHFbSN/81zZPqwUiNdbg2bLmXITndZkC3r+TehSPsKzfgJuOS1Ne0cOdOSjKO5kyOjxod+0Viz0qQGAXmMzCI1L0yx0RCUTyextg0npdT+Y1tTmlCQ3BM12mAV134Qjlw+c1LKqsVJh5059pPeV6YBPjvnfV8OVGdxqgiUN73MNx9xobBXX9XGlsTjQ04/dLyWfUYtqmYRpsTofY0X/cqTqdez8GOnD5UjU/4/8Q8Bl05V8qtNlq8gM338TJQ09wGw0Q2Fz5qR34mDrtXs0e0u3hQIFz9x/LW9clvTA402WoWGGMWR/8rhyvAy7/7zcBY4ty+A6jB9HfoqqlCcIHIH/LrpEhfxLcijbuS+GVd7K3tN+kaXdrULOnUIxyn21caI7m7seB5ZzaPC1o2fVahBWFHahecUUzS7eJ+s2EBRo+sg0cTbb4wUYY5KbD3z5OAn1zpVQWYtuKZV+R8kahOMfceIt2we4Lcmv21K46B8aCfdt4QzWN8CD+PfbQmGhT6zzmOm6
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(76116006)(64756008)(66476007)(66556008)(71200400001)(66446008)(6506007)(966005)(86362001)(8936002)(8676002)(110136005)(44832011)(54906003)(2616005)(66946007)(122000001)(6486002)(316002)(91956017)(5660300002)(38100700002)(4326008)(186003)(478600001)(2906002)(26005)(36756003)(66574015)(4744005)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?zEQ5SVNbkX6HyOhVAsAhxE4+Poe08aucPLSARyS4T/eucbziqeaAqgaFo?=
	=?iso-8859-15?Q?mfOBHsd/O8GZYDXzKZpW7OO7oYSNRnCJGKyH5hSYqepIxcVQcwiKpIpRo?=
	=?iso-8859-15?Q?BVDOReOZpLWXwABwu+BtIPnEL2ptL3GWJTqxksYT4mDuMbkC+iMl9RUyn?=
	=?iso-8859-15?Q?EMlyjKmQoCZB2dfz54ULBvWgPeq06XbZrrW+qy2AFzlQo+Gw62bGTh2PL?=
	=?iso-8859-15?Q?wcamLSiDIAE4cY4jqvZewXVqfTsXtwe1NzA4VBUNMRLgUZzclArlllBQN?=
	=?iso-8859-15?Q?tFKaFjrkwboqNf5Or99EF4UsGPUBt5TMlp4OmQyHuX3iWL//fOoaUYjF0?=
	=?iso-8859-15?Q?N8FkqNpaJy3AiwyNTU77FwN6OOZ+aqg13jCXSMkTWTHS2LIawJtjQQwlV?=
	=?iso-8859-15?Q?A7R4tKouF2Lk0AMcqmoyZ5W+lb1XdZuzm5aepCzb15F35EFKcajNWnKyf?=
	=?iso-8859-15?Q?NsHV1wvcvJHzPwEfd/fAGit8Rlb5sy7jyJGJMBSZMOHul0XEj5PsFce9K?=
	=?iso-8859-15?Q?VCcQJLDPmkESQuTcNZA3epil76pv3GR8XQKWP0BzjAjH+Jwdru8bqsC4n?=
	=?iso-8859-15?Q?vUgq4kAcyM3h2AJUQgBQ+ISRgmDRoj9vTQhKZGQle1hjaLgkiw51oxieg?=
	=?iso-8859-15?Q?/cgkFBVLZMNqMw1ZR6BueBCAGUjm5rXB36alQBJhHGBeYvVQCO9GU4crT?=
	=?iso-8859-15?Q?6n1tgSoJvwPpUhZyKdjzfkVr168lhUSD991+v7hA56frGzB6wR/XNSUC8?=
	=?iso-8859-15?Q?A7e3LoE2OCUqBwsPykh1OqjSyk2fQvjycL6tDIj18j4mYHSPNoVXBfBOO?=
	=?iso-8859-15?Q?xM1SzGXw9Sg+y/UqiVSW2yS5h/6tbCO9UrQu4JhgjSmmqxQcEEs2w2J/H?=
	=?iso-8859-15?Q?vIAV1jHMoQR7LbS5gzs32pLAjK5rga1VjWBBmgyX6VHWuhGTqk62bpfHm?=
	=?iso-8859-15?Q?85kprtyETyIfCfEMhIg9gXuTbZAPKfZB1a9JlO6/Sz3xJM6XKeY+efcwD?=
	=?iso-8859-15?Q?a87IPhFnEPP92EzayL936iTPlwojfnC80qT35eM/6+gZqKdoWMs0gWcWO?=
	=?iso-8859-15?Q?YdnRV7cPWcXnopJTN7B3cwDDmFAESCUmmkcJ7wOWeUDNCK75lO+n3dwpf?=
	=?iso-8859-15?Q?Z208VbJ/ilzLUNZVWTDS1m+OxlAYOy7kUiyjiSTsBAQr5B/hW4CHdTkS0?=
	=?iso-8859-15?Q?KQIFgo5BxbHAiFU590lpTsZoZkTQKWztfEGSfL76uP8OC4kanWRhV16ru?=
	=?iso-8859-15?Q?s0Fb1rkJVnYtqwgxT9k98TxyKWJCrBJ0DkTUH3R/op6+ItEpB1tqhApLM?=
	=?iso-8859-15?Q?KxZGnHyk40VZ5Stj9sqZWzj4r5HSFZvMa9Lzbo9CIlVxM2HNeYttG8vOa?=
	=?iso-8859-15?Q?B+tlJbKH6wbtp/AIVr5RUzkep8nzu7NC9?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5068325c-fee6-40da-9d8b-08d90953fa56
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 08:10:53.5912 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F/JzZKcgQHJp5tNYtLPR6dGxMzJFCF6LHQcezUve6j3xMSj7a30TClONtLhOkS8nGg8bU/tMr7QidmZN3xK4EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7351
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13R8B7aE021951
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <BABDA9403B6BC34E94FCE049E80F757A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-04-27 at 13:48 +1000, Erwin van Londen wrote:
> >=20
> > Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
> > afaics.
> >=20
> In my view the WWID should never change.=A0

In an ideal world, perhaps not. But in the dm-multipath realm, we know
that WWID changes can happen with certain storage arrays. See=A0
https://listman.redhat.com/archives/dm-devel/2021-February/msg00116.html=A0
and follow-ups, for example.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

