Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61212C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 09:59:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDF6661554
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 09:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDF6661554
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-5TiadDyjNVqgbDmUQ_ixRg-1; Mon, 29 Mar 2021 05:59:14 -0400
X-MC-Unique: 5TiadDyjNVqgbDmUQ_ixRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 674FE1005D54;
	Mon, 29 Mar 2021 09:59:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68ACB60D79;
	Mon, 29 Mar 2021 09:59:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07F761809C83;
	Mon, 29 Mar 2021 09:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12T9wxAE016711 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 05:59:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D59492026D07; Mon, 29 Mar 2021 09:58:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF7A32026D7F
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 09:58:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89615811E9C
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 09:58:56 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-380-PUJubdOtNfic28x0XL5Mjw-1;
	Mon, 29 Mar 2021 05:58:54 -0400
X-MC-Unique: PUJubdOtNfic28x0XL5Mjw-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-fADNTX6MOKCaZ8Vl5fZV2g-2; Mon, 29 Mar 2021 11:58:52 +0200
X-MC-Unique: fADNTX6MOKCaZ8Vl5fZV2g-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8347.eurprd04.prod.outlook.com (2603:10a6:10:245::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24;
	Mon, 29 Mar 2021 09:58:50 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.033;
	Mon, 29 Mar 2021 09:58:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com"
	<jejb@linux.vnet.ibm.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>,
	Hannes Reinecke <hare@suse.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXJIIevKqEvjcbJUy9Ai14uQzKmQ==
Date: Mon, 29 Mar 2021 09:58:49 +0000
Message-ID: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8549d9c-b607-40fd-c3fe-08d8f2994091
x-ms-traffictypediagnostic: DB9PR04MB8347:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB834743787C009DCCEEA1B60AFC7E9@DB9PR04MB8347.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /anSMDmjRI9sCB8BxY0XzEc3UQUuxD7WIo1UJf5fCqPr6Pd24km4NLfvEjRv5P8SbbDcJ2GfEa4I3uVhLbnG2I/WcI0hrpgCwaH4y3swBR/u2bEqQVocgYt/Uwg5K5IWsWCy7Lhyy+1jbvNBQCEI6BGlWBmz8oXsIRw4ytOy9+dq4Fvd3UG1yKd09OqY1vxiozWkjKqpkEye5qg88Vh4aT0xUGd8pxJ51NVVPBJUt+H45qLjqaVM7BsYv1J6IBf8AJdh5bHlGHJb3ptytZjb605yWK49VDeihewLtJUdDl3tD7k8PcnKsqEI7CVNU0DZ/LuIQAGf68ntSQoc4X3dMkBVxDUTFj9hu2Ji4Qsh7c0iha+89QLQjCc8QR9dRh1bUzwx2TpD0CYMKD64wkLjVS6n0iM5ISNrtuMswcDMm57Vd4PUBE2Q/bHmTetuCAcd9EvV1AIlqSlerkiY3vvumXb32JYnHYkpqYyRaDwB79dB2ZxMzDUZl6rL16gAf6iYBcf9MyPhuS99xC7S6EIC8TlgCEMJjiBDTv6gzwkVZJP4+y2EtCraO8ZJdy9k8r3aZ0lZdrkI6i2XZDsWV3Q4N2AnLXEgTleayf0O9sAF3jzfaL5VpuOEcwghG9sAYajXjbymlULDC61U6UvyIkejRVrYNyJsAx0FLkvlxdlKuDVM8xhTBzqL1k0D7UaKWjSVOMBN5MgXedpdVUjV3T1VAVdNGcabKG5Aat+b4UJMLU2qmqnhCzgUmz7ASKdpXp/T
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(86362001)(8676002)(6512007)(44832011)(76116006)(66946007)(6486002)(6506007)(2906002)(54906003)(110136005)(8936002)(71200400001)(316002)(83380400001)(66574015)(64756008)(2616005)(26005)(186003)(66556008)(478600001)(966005)(5660300002)(91956017)(4326008)(36756003)(66476007)(38100700001)(66446008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?CdEUoOEY8TM7H5wOCDDzFmSD0kNkmEtpTvZ+WEuJ+5JCMo9i+HFPJh3lR?=
	=?iso-8859-15?Q?+OGC/ixeHaEWh4zv5aRiWa31FDGa+5wicJTq6U0gsoU+nUT2Xv8RfYL/F?=
	=?iso-8859-15?Q?X2h6hgMomAyJZKcoAQZOSNRvbVDci3T5rkZXY6V7hWlX6CO/Vj5yl9Okw?=
	=?iso-8859-15?Q?p7MYrvT5UyidBVVKOhD41MMjnomJEFDTVeWb8YbEB9CzR7o0MhSX+y4d/?=
	=?iso-8859-15?Q?eUKd2vTCDzGc2ZVW8yX/4t0c186qEZ8o1ZUXKl6LIHShP6k3LPZCAPle0?=
	=?iso-8859-15?Q?ZMLnMiB3eeCmTZJAnU3uG5X/ZiRwjYftXLc47FtAEGNTzuHcob+TlnXVV?=
	=?iso-8859-15?Q?b5mtni9Z0D+ShsptTi7Ss0N/9v5RdkKyW9TA5i+y45C1kucgXK5lmxI3H?=
	=?iso-8859-15?Q?SPUj5S6v4cHVzmKOZcZkv9iLr0rDX8zHJzbwRg/Xk//lskUTBfkCLPxF0?=
	=?iso-8859-15?Q?aw6vV9nJtYE43FPFusUmAutEIl+9g4oD+n3h4jHYuLpWL3/S8wz03Tt2F?=
	=?iso-8859-15?Q?T5XwGHLY4CkvNMI5Y4ctWEsxOcRwNypj2wszXPsWtpcBbvoJq1eF10Dv7?=
	=?iso-8859-15?Q?3jRarUAAE74qhlPnQN4+jpuZLVrQUeuEDqPYkuuhfpwupVnICSzFxxalb?=
	=?iso-8859-15?Q?OMFXNHrO0mPlhoSjH/4ghA9lv7oVFlVPrpDZtERUaLi71idPDJP9NPGfK?=
	=?iso-8859-15?Q?hGWh+o9zigpWXx0hW8xflZMMP/DdmBp8t2jW/0/6lE/r2ONP4TnE53rPR?=
	=?iso-8859-15?Q?C1UrcCt9uc4RLGua5FfIn2tlhpqPVmN/O5gBGvFnYkgw0UJWmWFG/8vs0?=
	=?iso-8859-15?Q?FkGEQsZKzcpXQxwUmmKtNkIJxC7CZ9Iq9M5xcBSSb0vaQTVrB6xjXir12?=
	=?iso-8859-15?Q?7zBYrKTHbGpHcO6C3PWSJ1pESNnEo3ned+PDUyd0GYiGgkScJ164e+Y9e?=
	=?iso-8859-15?Q?JVFZml7qQl8l73i10k/vCR6+CaiJwR1EmtXH5nt774hdUuo51yVeIMuEm?=
	=?iso-8859-15?Q?o+bce2bqwTgo7R4R0fELCesDNGnT58TCrwfInuXzlMcHNFOyWKFBtXfjm?=
	=?iso-8859-15?Q?3a5IxgwrrHobCXXZI4ECotJ6Vz/xbBSGOoR+HnzOFNdqhH90oy5X1FIP9?=
	=?iso-8859-15?Q?3+IM5bkDHSCNkvd+t2U0D+9+lf4f0Ji4uEG94WkQ4y8HBrLhpJpcEEjz3?=
	=?iso-8859-15?Q?pVJCZF9maxkiyoqfI2ba45i60aIq0DrfEWVXAlopFZYK1BDHlWlXfzEBb?=
	=?iso-8859-15?Q?gvSFJr0cyoVXpYAu9w5v5TQ+8R7v6uCd1EMgUAuhRmD4+kc6mm222zk4v?=
	=?iso-8859-15?Q?TUreJieKji5DqpcJeuPQNVhwo8GYMy9xXMun1DAKstaPucEUqbMTMA61l?=
	=?iso-8859-15?Q?+NWubLfju5CYRniWoB6QI+fZXqtz1TkLc?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8549d9c-b607-40fd-c3fe-08d8f2994091
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 09:58:49.9678 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjmZR8C+vOv34CiLQqOOqyGbtcbsZWam4DE8yZZOqYaVu//yo0AkdBnsBJeYZ6v2a7fdpKHMzSSMpGzlhyMFrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8347
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12T9wxAE016711
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>
Subject: [dm-devel] RFC: one more time: SCSI device identification
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
Content-ID: <B74465EEC83557459A05A1E61BDE7C0B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

[sorry for cross-posting, I think this is relevant to multiple
communities.]

I'm referring to the recent discussion about SCSI device identification
for multipath-tools=A0
(https://listman.redhat.com/archives/dm-devel/2021-March/msg00332.html)

As you all know, there are different designators to identify SCSI LUNs,
and the specs don't mandate priorities for devices that support
multiple designator types. There are various implementations for device
identification, which use different priorities (summarized below).

It's highly desirable to clean up this confusion and settle on a single
instance and a unique priority order. I believe this instance should be
the kernel.

OTOH, changing device WWIDs is highly dangerous for productive systems.
The WWID is prominently used in multipath-tools, but also in lots of
other important places such as fstab, grub.cfg, dracut, etc. No doubt
that we'll be stuck with the different algorithms for years, especially
for LTS distributions. But perhaps we can figure out a long-term exit
strategy?

The kernel's preference for type 8 designators (see below) is in
contrast with the established user space algorithms, which determine
SCSI WWIDs on productive systems in practice. User space can try to
adapt to the kernel logic, but it will necessarily be a slow and
painful path if we want to avoid breaking user setups.

In principle, I believe the kernel is "right" to prefer type 8. But
because the "wwid" attribute isn't actually used for device
identification today, changing the kernel logic would be less prone to
regressions than changing user space, even if it violates the principle
that the kernel's user space API must remain stable.

Would it be an option to modify the kernel logic?

If we can't, I think we should start with making the "wwid" attribute
part of the udev rule logic, and letting distros configure whether the
kernel logic or the traditional udev logic would be used.

Please tell me your thoughts on this matter.

Regards,
Martin

PS: Incomplete list of algorithms for SCSI designator priorities:

The kernel ("wwid" sysfs attribute) prefers "SCSI name string" (type 8)
designators over other types
(https://elixir.bootlin.com/linux/latest/A/ident/designator_prio).

The current set of udev rules in sg3_utils
(https://github.com/hreinecke/sg3_utils/blob/master/scripts/55-scsi-sg3_id.=
rules)
don't use the kernel's wwid attribute; they parse VPD 83 and 80
instead and prioritize types 36, 35, 32, and 2 over type 8.

udev's "scsi_id" tool, historically the first attempt to implement a
priority for this, doesn't look at the SCSI name attribute at all:
https://github.com/systemd/systemd/blob/main/src/udev/scsi_id/scsi_serial.c

There's a "fallback" logic in multipath-tools in case udev doesn't
provide a WWID:
https://github.com/opensvc/multipath-tools/blob/a41a61e8482def33e3ca8c9e363=
9ad2c37611551/libmultipath/discovery.c#L1040

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

