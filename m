Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEE4C433B4
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:34:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A74C5613EF
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:34:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A74C5613EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-PAAws2RDM8GritCZBaTQMw-1; Tue, 27 Apr 2021 16:34:00 -0400
X-MC-Unique: PAAws2RDM8GritCZBaTQMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F135219253C5;
	Tue, 27 Apr 2021 20:33:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 903C5100164A;
	Tue, 27 Apr 2021 20:33:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17F8144A58;
	Tue, 27 Apr 2021 20:33:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13RKXqlw031002 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 16:33:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EAC7D21CAC98; Tue, 27 Apr 2021 20:33:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E48DA202879E
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 20:33:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B22B8858F0E
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 20:33:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-396-jDRDgaqIPMmeTzPf7EIFng-1;
	Tue, 27 Apr 2021 16:33:47 -0400
X-MC-Unique: jDRDgaqIPMmeTzPf7EIFng-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-16--W6kZbI7NdKBBSSj81FEHQ-1; Tue, 27 Apr 2021 22:33:45 +0200
X-MC-Unique: -W6kZbI7NdKBBSSj81FEHQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24;
	Tue, 27 Apr 2021 20:33:43 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027;
	Tue, 27 Apr 2021 20:33:43 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "emilne@redhat.com" <emilne@redhat.com>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrqrIzsGAgAAFOwA=
Date: Tue, 27 Apr 2021 20:33:43 +0000
Message-ID: <488ef3e7fa0cca4f0a0cb2e9307ddaa08385d3f7.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
	<65f66a5e03081dd3b470fa9aeff9a77dbc41743c.camel@redhat.com>
In-Reply-To: <65f66a5e03081dd3b470fa9aeff9a77dbc41743c.camel@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27aa4ac4-9250-4b21-0e5e-08d909bbc007
x-ms-traffictypediagnostic: DB6PR0402MB2743:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27438E6BEAD15DDAF98B77D4FC419@DB6PR0402MB2743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ea4OG/5Su261FF38mzd80SHMAFKDvrKiR1Yqwjw4vnJ6N+NZi/pvM/I5iOup7Yi5v750mUY2CT26QP4ImyLWd4CiIGwNEJr4Q3gIhlsnTXTGPFEoUaGRpPnblMPrS9b3psOHk70I+M1XimaGlPrzV5M4F8Hcw+Vm2SKB3nCdNw5da4QjGgwugx0fL151Mjoi5YdHbIJqlo4wOd978vbc1I8L9ZdjWAzBUU6iafSN4pzPYN3aF5mxXuZXnd0tSymRAYh0veKAzfRQWlLg3Tb34R6z7ZG2Fcqu4qFTBSJWzF8VSksMJU4quAwFq0+uP8CkktVxh2EbdhF2SlAJ4Uxm46wounolCYDmoG+Xx+DumKV6geXjei45nExYKuY6OZfqu3JqpTdD+oLXcRB9v4uY8oF7NDosCCfwTltFi2x86ZyCSC+v898BsUOTH6DfI+NKumrGYOvYPWSZTUZPnZx4a4V526r9G8MyIDZrasoNREF9ntqo+UQi1q4Ve43BGGZaFJNsKYkiPZrSL05Eo+khAYYD6kcm1uqVGeI7wdl/zAnuZWUZaxgT9O61K1mB6xTSEuAr+hD7AJ0CMl55Rpz+70KJGhABQIGnim6ZOAQxFwQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(39860400002)(136003)(346002)(376002)(396003)(66476007)(91956017)(76116006)(64756008)(66946007)(66556008)(8676002)(5660300002)(66446008)(71200400001)(26005)(6486002)(44832011)(6506007)(54906003)(110136005)(6512007)(86362001)(83380400001)(4326008)(8936002)(186003)(2906002)(478600001)(36756003)(122000001)(38100700002)(316002)(7416002)(2616005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?ZEki8QfZi05NjRHE/RX0aneJh4BHyBDHaN8cwQQJygQGKB2Q9ZPUGQ3ik?=
	=?iso-8859-15?Q?1f/ltr0O6tXkznPrbk4IWN/e4ZYAxCDO8B52QaVKW6AJP9jY2KY92S5oe?=
	=?iso-8859-15?Q?PsZy58hf5ZhdXRAbu63nnSQK0V14mYhW5zcb6H4o7Y13esCQ2zZaWgbpK?=
	=?iso-8859-15?Q?1M4x61vXJZDH/JKEYkEoA6smyAaZfgwnkF5ztxNMvwQI0pdKPhyzL8hdw?=
	=?iso-8859-15?Q?R3M0ww2/hWYScmaNTQrIdfY9UOqoVXMMHFeXab4oJq1CBJKXGgGC3EkHi?=
	=?iso-8859-15?Q?BUQaqH02J4vFtSBAHNWbVEyUund723T0qg6saasj2kwsZPHqxjJHFpNEC?=
	=?iso-8859-15?Q?vsNDryACnqPfCNvjkdWgLG7V2/YAgqVpimnakKbTTYqxg5ROwgcguZjX7?=
	=?iso-8859-15?Q?2gsMHGeC5J5LtkmUBRxAtqzv4WdF7OQlj0/xaIaqW8GR/Y+KY+zkCJcQl?=
	=?iso-8859-15?Q?Ym3Q23Sz2dlewJtF4XpOB3dxjL5Kd9LHocMLwbu0ciifGcFTVlF9BwK7E?=
	=?iso-8859-15?Q?OgVPNQtKGjDmlDDOl1bnPryn+4XF+Dn/y/K7aZeMGLEDIhMSLQnUS2ydD?=
	=?iso-8859-15?Q?zM9RUIrn7E+cs7y1/qkuvgY6DZvpdC6w5sfASH3z6QHhIbrWxYIPGgqZA?=
	=?iso-8859-15?Q?RpMpp5sCeIAZfaX1d9HJVbeqUXesi3TgkHlnkH4ggNHfmJCw2yzfV7P2G?=
	=?iso-8859-15?Q?LMCGF6pwuPtp9ZGzCzVj2jCykBwiDngF8gL2ZVIk32B5nd9+kJZe+bLJ+?=
	=?iso-8859-15?Q?pC4ympfLm25x7FBp5i2zTbLTkU9PxL2xPA9eleZmXuTnW9ix2tG/0aHP+?=
	=?iso-8859-15?Q?ZMrR4jNhxwmbUhuMt17Sa/ytWcvNDnR/G1LwzbzU92Hx+brn+g4/m7KIq?=
	=?iso-8859-15?Q?gN20ap2SaVkNmSXbdgc2hGhVSg/5ufRKknv9uKa0swKAYJVcyA2wJBAJG?=
	=?iso-8859-15?Q?fsoOJFVcxcPr3jYerpYjafvb/sDKI6KayOBsPhTx9wrbhwbilUlvWo5gz?=
	=?iso-8859-15?Q?7lkqxIIwuNOHLL5Sq6qdX2zT6uD27OXIrYeShIu0LnTDxbxh8YA1kirP0?=
	=?iso-8859-15?Q?bkQ/2Inyrh7tmnQeOB1FpeXJS6+rYntrGIY3fh+ewjsxXvVfVLsxG0LR5?=
	=?iso-8859-15?Q?huTf7jHv2w5ij9tQqAldphDgmY4h+cD81BodhA5GSoMUtLPw3gbK21xf3?=
	=?iso-8859-15?Q?zSKciIhWbKo+XBdcz6st9pk73iWOh6XOOTlfy4FvZkWC756Y5VzW8vT+D?=
	=?iso-8859-15?Q?jkBmTrx5QMvhmKqWcbDxA6vROq+DQQ/vamkEUrEXSeT1expKqQqFDOVUt?=
	=?iso-8859-15?Q?2kkvHszhZNORp8SHojM7uElcoDEfEQa8HXXxPnsYUxWaVtWtJcfxnsg1Y?=
	=?iso-8859-15?Q?WHb6g8hE9pntMZaqJ00SQ0nHeC0nLsnuZ?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27aa4ac4-9250-4b21-0e5e-08d909bbc007
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 20:33:43.3518 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: chAIqTQQwVCyMAUH+qJ6EaDJLBv/OEL/uzW+VcQFDm0XckkKAffu94ypFXWpgy8jRsTygIaiYAQpjy6d5IXwfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2743
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13RKXqlw031002
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <29595AF932F67949944723F3EBADE338@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-04-27 at 16:14 -0400, Ewan D. Milne wrote:
> On Mon, 2021-04-26 at 13:16 +0000, Martin Wilck wrote:
> > On Mon, 2021-04-26 at 13:14 +0200, Ulrich Windl wrote:
> > > > >=20
> > > >=20
> > > > While we're at it, I'd like to mention another issue: WWID
> > > > changes.
> > > >=20
> > > > This is a big problem for multipathd. The gist is that the
> > > > device
> > > > identification attributes in sysfs only change after rescanning
> > > > the
> > > > device. Thus if a user changes LUN assignments on a storage
> > > > system,
> > > > it can happen that a direct INQUIRY returns a different WWID as
> > > > in
> > > > sysfs, which is fatal. If we plan to rely more on sysfs for
> > > > device
> > > > identification in the future, the problem gets worse.=20
> > >=20
> > > I think many devices rely on the fact that they are identified by
> > > Vendor/model/serial_nr, because in most professional SAN storage
> > > systems you
> > > can pre-set the serial number to a custom value; so if you want a
> > > new
> > > disk
> > > (maybe a snapshot) to be compatible with the old one, just assign
> > > the
> > > same
> > > serial number. I guess that's the idea behind.
> >=20
> > What you are saying sounds dangerous to me. If a snapshot has the
> > same
> > WWID as the device it's a snapshot of, it must not be exposed to
> > any
> > host(s) at the same time with its origin, otherwise the host may
> > happily combine it with the origin into one multipath map, and data
> > corruption will almost certainly result.=20
> >=20
> > My argument is about how the host is supposed to deal with a WWID
> > change if it happens. Here, "WWID change" means that a given
> > H:C:T:L
> > suddenly exposes different device designators than it used to,
> > while
> > this device is in use by a host. Here, too, data corruption is
> > imminent, and can happen in a blink of an eye. To avoid this,
> > several
> > things are needed:
> >=20
> > =A01) the host needs to get notified about the change (likely by an
> > UA
> > of
> > some sort)
> > =A02) the kernel needs to react to the notification immediately, e.g.
> > by
> > blocking IO to the device,
>=20
> There's no way to do that, in principle.=A0 Because there could be
> other I/Os in flight.=A0 You might (somehow) avoid retrying an I/O
> that got a UA until you figured out if something changed, but other
> I/Os can already have been sent to the target, or issued before you
> get to look at the status.

Right. But in practice, a WWID change will hardly happen under full IO
load. The storage side will probably have to block IO while this
happens, at least for a short time period. So blocking and quiescing
the queue upon an UA might still work, most of the time. Even if we
were too late already, the sooner we stop the queue, the better.

The current algorithm in multipath-tools needs to detect a path going
down and being reinstated. The time interval during which a WWID change
will go unnoticed is one or more path checker intervals, typically on
the order of 5-30 seconds. If we could decrease this interval to a sub-
second or even millisecond range by blocking the queue in the kernel
quickly, we'd have made a big step forward.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

