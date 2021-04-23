Return-Path: <SRS0=sZ2e=JU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3489C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 23 Apr 2021 10:29:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 37EFF61396
	for <dm-devel@archiver.kernel.org>; Fri, 23 Apr 2021 10:29:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37EFF61396
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-1VhmDuMTNqqAx2owUAuE7A-1; Fri, 23 Apr 2021 06:26:11 -0400
X-MC-Unique: 1VhmDuMTNqqAx2owUAuE7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 506CB180E49C;
	Fri, 23 Apr 2021 10:28:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7476329745;
	Fri, 23 Apr 2021 10:28:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CC4A44A58;
	Fri, 23 Apr 2021 10:28:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13NASUT6003513 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Apr 2021 06:28:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 36D6711EB00; Fri, 23 Apr 2021 10:28:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3169D11E6BF
	for <dm-devel@redhat.com>; Fri, 23 Apr 2021 10:28:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77F17185A79C
	for <dm-devel@redhat.com>; Fri, 23 Apr 2021 10:28:27 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-189-SpbN5goHNMSqP7czz1SKWQ-1;
	Fri, 23 Apr 2021 06:28:25 -0400
X-MC-Unique: SpbN5goHNMSqP7czz1SKWQ-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-35-3Q5FEItBPDKpsFxQpW4mCg-2; Fri, 23 Apr 2021 12:28:23 +0200
X-MC-Unique: 3Q5FEItBPDKpsFxQpW4mCg-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2357.eurprd04.prod.outlook.com (2603:10a6:4:4b::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20;
	Fri, 23 Apr 2021 10:28:20 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.024;
	Fri, 23 Apr 2021 10:28:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXJIIevKqEvjcbJUy9Ai14uQzKmaqm92EcgBDwGwCACBMFD4AAakAAgAEV7ruAAJMNAA==
Date: Fri, 23 Apr 2021 10:28:19 +0000
Message-ID: <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c5ff3a9-bf40-427e-8673-08d90642841b
x-ms-traffictypediagnostic: DB6PR0401MB2357:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB2357BD5374644BEE0A13204FFC459@DB6PR0401MB2357.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BPiHfQg9wl1uMfV70yHujaA8DeQ/wuFGgjgwlyXjEmez23KlA0gJz4khCYR8Gn6wmdvWDu/tOSnXgTcLfg0EkPgTa3qbVoYrRi2BhnFSF2rDEyP8+pleOsV1VfKRMQdCKZu287bOuqrdGkgNZZYTERxu39yiNf6SSaCdySLCvgV57AQYGfROuhDCpadGexRNGrQwaUK3Jz9TU7CiVhp9VMRJHuF892sWt0nAuCwRkPOk57kNxJN29VEGGMroFkeFIw3V5PTQaB7VPqzvZvIZR9UclcxANrH0lHwkZ3zlDmpUoLpUfmipF05PezJzQ7u7xk5XqNYmVzqPvg2y0YLMjUo8XU1bA6MCHxfuBoxwZV8s9pm5FAiNqh7pLMUuca6McHJc/u07u5a9YBQvy7rdVrTZPU1qdZYEU0OO8lRL29APNZo4NRjPRz4p8aqwkbfdSqLSTTlyJthJeh9C3ZM8hhhgl+VWGJu6u7cJHbobua2FIMqPjZV2UmpRWiT+JYRLq1qYB9/CjmH/d+U7BmaDqTdI3EKBMNJ70xhlt4KDPqE+b2gAUiU3903aS/6gldeMqLDAr8cYTTsta0OpYV10WExxPr7Dq5bA9us73GM6yUE=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(396003)(376002)(346002)(136003)(39850400004)(66476007)(5660300002)(316002)(6506007)(66946007)(66446008)(36756003)(26005)(54906003)(2616005)(64756008)(76116006)(186003)(8936002)(71200400001)(6916009)(8676002)(6486002)(44832011)(86362001)(2906002)(122000001)(91956017)(38100700002)(6512007)(66556008)(478600001)(83380400001)(66574015)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?stkrOuKODbv5brXWkLe39I+t0HjIPURKhsfJoagiuv+cXrL+2ejxLcRlv?=
	=?iso-8859-15?Q?tcGNCgZ+CQRfDHjZm/Z3pF2RLTKc7SqfUnFweSMplZ0NG7e7SruW+2vEw?=
	=?iso-8859-15?Q?C/t8GR8aGZsQe3fAydSrvLBL63V7ZeSf2agrxEZ+CatOkLedspqsLHiLH?=
	=?iso-8859-15?Q?MtnMS7GRaTePSIfaYHBXW8xmbaLs/hfyyPWDt5rgsNkn/MLySt8QxehYH?=
	=?iso-8859-15?Q?v6HsFUJ+Tvd24e5GqimmdHMy9HNWKmMm+0CDIVHxcJf13m3FdV16O5fst?=
	=?iso-8859-15?Q?Oyq5qC1UUlmzNm/rV4ybTXiKdOXgTkPg5SpMN2+sylHTrPMhkU8JJbm0q?=
	=?iso-8859-15?Q?YZaCJd0Nue1JpWeo2lLcQ+jbrv0Pk4+gEWi+gki08Sfh6x7DgWAkhZRvO?=
	=?iso-8859-15?Q?pxlF3UQNcAsRUbbfid9tFzaRSWoYZ5HDc1f1Q8Uj/SuPZ9HUKUlSh+Hnr?=
	=?iso-8859-15?Q?JGjGKrfdWZV1rD5zkTM68xVeMiOmull0exh++RHmYzqbLCX1JuPT7SOWm?=
	=?iso-8859-15?Q?cTsWFsy44X3rKxZF5a+MVk26vftqoFPavqrK1KsNvusXm6H1MVvH9S0/K?=
	=?iso-8859-15?Q?8bnX68oEDu9wad3AbbZ+uUrOnk5g41uT87UiI4RkUXaIi9eLAW1K6JLpD?=
	=?iso-8859-15?Q?sXXSGDo4UcAbGewm7UbOn5g3afQNYmBfRXy9DjfU9Lw65JUKcaepMrhp/?=
	=?iso-8859-15?Q?f3FrtM6FRjP2n/sFpeitI8JIUazK3Iz3FmRwnLKzD6j0m04D5CoY2QCHC?=
	=?iso-8859-15?Q?P08CLOgkeeGgEamUjKlAPm1TSJuWSJO1v303JIkyROBznE8dRZF9WZqhu?=
	=?iso-8859-15?Q?NIvt+0ebZ2Fdr97wIZ+DpeL3vjgxo1lo9us/BbOSi3G4gqKvC/9DAvWLI?=
	=?iso-8859-15?Q?kHMilkDXqVKX5Az8kq1EMtfqOCkBTNw7tfAaIQmSmRCONuc6fwJpsRW0X?=
	=?iso-8859-15?Q?8rCYMYZc//ZZP+bLTLAIUwhE6DbPf9jj13uvaiAVQCqAzRY2XcUp7AgGK?=
	=?iso-8859-15?Q?dMVEytUphRipAWtRjWQbemIE6cYHTZxPsOa79dOha3MAPAwwb9rUKxhOY?=
	=?iso-8859-15?Q?cXZlC0OFFJSeJh8ofXOU3ONshoP6WPNXbM7U8w+ccY78a7GqnuVjTKXTW?=
	=?iso-8859-15?Q?/jZX6Sc/eRzoF95YDBbZp7zZgktce/9wp3h0CpZ6cKGWS9AGFMNrIb546?=
	=?iso-8859-15?Q?vecy57WloomKayGkjXrX7gy2jK42Cd+hQGHgh7U1igkBH2jwJIKwjbFwY?=
	=?iso-8859-15?Q?kCEd3bK4MqAn2N2HswPXVepP9A0IfKEfN0apir0UWMAt+1fPGgy3H5hjZ?=
	=?iso-8859-15?Q?1fZKb2zjSFjkDHU9nOoPH7CMrr0LZUfCMkOEohl1u0TEyXe01q/WEb6aH?=
	=?iso-8859-15?Q?bYIwJ0svkiY4htX8s68BsRxlaSmD4fH7j?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5ff3a9-bf40-427e-8673-08d90642841b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 10:28:20.0742 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eat9K0RpnmnhTfN8HqvNmqO4GvYABnaw5CKge2PMS8tu+WjhNv9DgQYZpHDTBy91dUN519rjkJb/Cc4Va5nGCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2357
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13NASUT6003513
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>, "hch@lst.de" <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <0AC1F877ABC8794990B252B663B4E9B6@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-04-22 at 21:40 -0400, Martin K. Petersen wrote:
>=20
> Martin,
>=20
> > I suppose 99.9% of users never bother with customizing the udev
> > rules.
>=20
> Except for the other 99.9%, perhaps? :) We definitely have many users
> that tweak udev storage rules for a variety of reasons. Including
> being
> able to use RII for LUN naming purposes.
>=20
> > But we can actually combine both approaches. If "wwid" yields a
> > good
> > value most of the time (which is true IMO), we could make user
> > space
> > rely on it by default, and make it possible to set an udev property
> > (e.g. ENV{ID_LEGACY}=3D"1") to tell udev rules to determine WWID
> > differently. User-space apps like multipath could check the
> > ID_LEGACY
> > property to determine whether or not reading the "wwid" attribute
> > would
> > be consistent with udev. That would simplify matters a lot for us
> > (Ben,
> > do you agree?), without the need of adding endless BLIST entries.
>=20
> That's fine with me.
>=20
> > AFAICT, no major distribution uses "wwid" for this purpose (yet).
>=20
> We definitely have users that currently rely on wwid, although
> probably
> not through standard distro scripts.
>=20
> > In a recent discussion with Hannes, the idea came up that the
> > priority
> > of "SCSI name string" designators should actually depend on their
> > subtype. "naa." name strings should map to the respective NAA
> > descriptors, and "eui.", likewise (only "iqn." descriptors have no
> > binary counterpart; we thought they should rather be put below NAA,
> > prio-wise).
>=20
> I like what NVMe did wrt. to exporting eui, nguid, uuid separately
> from
> the best-effort wwid. That's why I suggested separate sysfs files for
> the various page 0x83 descriptors. I like the idea of being able to
> explicitly ask for an eui if that's what I need. But that appears to
> be
> somewhat orthogonal to your request.
>=20
> > I wonder if you'd agree with a change made that way for "wwid". I
> > suppose you don't. I'd then propose to add a new attribute
> > following
> > this logic. It could simply be an additional attribute with a
> > different
> > name. Or this new attribute could be a property of the block device
> > rather than the SCSI device, like NVMe does it
> > (/sys/block/nvme0n2/wwid).
>=20
> That's fine. I am not a big fan of the idea that block/foo/wwid and
> block/foo/device/wwid could end up being different. But I do think
> that
> from a userland tooling perspective the consistency with NVMe is more
> important.

OK, then here's the plan: Change SCSI (block) device identification to
work similar to NVMe (in addition to what we have now).

 1. add a new sysfs attribute for SCSI block devices as
/sys/block/sd$X/wwid, the value derived similar to the current "wwid"
SCSI device attribute, but using the same prio for SCSI name strings as
for their binary counterparts, as described above.

 2. add "naa" and "eui" attributes, too, for user-space applications
that are interested in these specific attributes.=A0
Fixme: should we differentiate between different "naa" or eui subtypes,
like "naa_regext", "eui64" or similar? If the device defines multiple
"naa" designators, which one should we choose?

 3. Change udev rules such that they primarily look at the attribute in
1.) on new installments, and introduce a variable ID_LEGACY to tell the
rules to fall back to the current algorithm. I suppose it makes sense
to have at least ID_VENDOR and ID_PRODUCT available when making this
decision, so that it doesn't have to be a global setting on a given
host.

While we're at it, I'd like to mention another issue: WWID changes.

This is a big problem for multipathd. The gist is that the device
identification attributes in sysfs only change after rescanning the
device. Thus if a user changes LUN assignments on a storage system,=20
it can happen that a direct INQUIRY returns a different WWID as in
sysfs, which is fatal. If we plan to rely more on sysfs for device
identification in the future, the problem gets worse.=A0

I wonder if there's a chance that future kernels would automatically
update the attributes if a corresponding UNIT ATTENTION condition such
as INQUIRY DATA HAS CHANGED is received (*), or if we can find some
other way to avoid data corruption resulting from writing to the wrong
device.

Regards,
Martin

(*) I've been told that WWID changes can happen even without receiving
an UA. But in that case I'm inclined to put the blame on the storage.

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

