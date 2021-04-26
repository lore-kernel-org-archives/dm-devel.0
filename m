Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6F6C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:17:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3676D61359
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3676D61359
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-44iHDzEXPDGc8AdwR21fyA-1; Mon, 26 Apr 2021 09:17:23 -0400
X-MC-Unique: 44iHDzEXPDGc8AdwR21fyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5452343A6;
	Mon, 26 Apr 2021 13:17:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EE2560C4A;
	Mon, 26 Apr 2021 13:17:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 34E8A44A58;
	Mon, 26 Apr 2021 13:17:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13QDHAv1017570 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 09:17:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7D143110FBE5; Mon, 26 Apr 2021 13:17:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77B9A110FBF1
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 13:17:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 920EB8001A6
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 13:17:07 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-92-SQ2AxR8bM4mh9nI7hrARlw-1;
	Mon, 26 Apr 2021 09:17:04 -0400
X-MC-Unique: SQ2AxR8bM4mh9nI7hrARlw-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-YHU2edWvPvCFWWjT5Os39w-1; Mon, 26 Apr 2021 15:17:01 +0200
X-MC-Unique: YHU2edWvPvCFWWjT5Os39w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4618.eurprd04.prod.outlook.com (2603:10a6:5:38::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23;
	Mon, 26 Apr 2021 13:16:59 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027;
	Mon, 26 Apr 2021 13:16:59 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrg==
Date: Mon, 26 Apr 2021 13:16:58 +0000
Message-ID: <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
In-Reply-To: <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e55b656-3a11-40e5-55c5-08d908b5928c
x-ms-traffictypediagnostic: DB7PR04MB4618:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB46182435EDC00C095EABEE19FC429@DB7PR04MB4618.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lRK7FTyG/koDg4KnnBxASO2yX8bFw7YUBhW9saeFCheEj3jJkNq7inKgizeyvOMQZB15KxSIt3wq3n6p7C2vfEYaZGO+FyArfedGLkyWwchbWhOsoPK9XK6+sIwglX71vkLL7sGg/rUqbKxdB+1iUTblkMJKF0KLrdeWFsZViyeFxhp1g7bXFGk5644nB8qcf9RIAYDOQeV9tuWbPxdHyNSLsFaDgDdCdSAFDUzh1EUtMFsDoRrIFWzESCYpHsVxzO+4BosRtpXz7RWCtRzPJuIGoPpIvuGkoS+WQvNmNwrTh/B3iejEEzQIjkpNhsdShTYOme9MoSGlA6Ps0yxYF2e4p6dQYLxSwDkJc0lQ3KgvV7kjmqum1ZNjf7Y3kAGyEHdwPqLG2fBnEtCwG3gUap3ifzICfBY2JpFtyYGtmu0EqGpe/eAcX/IpcsOioB+tLLj7YwKr8lMmg6wMAVeBb9+0wxf9XXvPbQG7dRrQ9cpPVioFn75hsVulfyeljvWpWmQL7wERQf2pPsAY0zoPuW1DopUHRLBtLW3UNDtj5eeFpwflD+41ggos64yw7ww2fe43T6zf1sXUkFbgONl3IDkJlEj5u+lZ7abx+wevE4M=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(376002)(39850400004)(396003)(366004)(54906003)(6506007)(2906002)(110136005)(86362001)(316002)(36756003)(186003)(26005)(71200400001)(2616005)(83380400001)(4326008)(5660300002)(44832011)(122000001)(6486002)(64756008)(478600001)(66556008)(66446008)(66476007)(76116006)(38100700002)(66574015)(91956017)(66946007)(6512007)(8676002)(8936002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?V2HxDLFse0mqDy7Loy8lDpFT3tn12pTq9+Z12vqPcxv7t83dKH4WZSjCO?=
	=?iso-8859-15?Q?R+dgwLO/I8lDju7/1DSFmuAZaJqICE/L2CvO7k5UldM9hgiopMNXf8vrJ?=
	=?iso-8859-15?Q?l1Y4nfGe5uzBq4ZTua5OZb36QP5Gjcv/f4m8AzSKFJ7fCuv8280pMGOBu?=
	=?iso-8859-15?Q?3y4JNM+wrg+BOo0/YE0Ouq2nvviuMG46TNgDVZmNscL4F2hoxbxW6ReMk?=
	=?iso-8859-15?Q?JJ1Xl5KxGdf+G6drrtbwNFTnrJihRazqnAOntVKaX7NVmDnazfPcTxqi9?=
	=?iso-8859-15?Q?DTqKi15Ee1ZR6F1IDLeQeOx81W1/oqOQEJdqrQRlmYPcsKThKVpPX05Tn?=
	=?iso-8859-15?Q?Fm76HN3PoYwKCfKLdskF5oRONIKTbuxCLRPjSZvaQe0OOHReb4BUHFw0X?=
	=?iso-8859-15?Q?luBbjx/kR/PWGgDZLn2P+4+7yVGGe8Ue82A0R4knd6iMlxq9iMQBkVo+k?=
	=?iso-8859-15?Q?9PB2ORK0UxVkgWU0pW+XrNNc5PNjmKOmXEp08z275Wnviz0dWIIqJJtGA?=
	=?iso-8859-15?Q?aQh45bvbl0WtglfFE0GIk53FL314yizXsXALo9qpAEQrN9kO0mcXgesGF?=
	=?iso-8859-15?Q?q6HKLVBmi5MkTgzp5DWi028WNfKgrt1JyXsSzJ03qSIhHxvhGCw/+z2Ny?=
	=?iso-8859-15?Q?0rAf6yMvs/KEDnRsnU3zHq7cpVt7bEyKykjc2oLhfWyTHxIz7b8KVpv09?=
	=?iso-8859-15?Q?KTNUd3ARiOVoB2o9oRgMcllL1wlYpWS/ftQzPpD60NMLYumd6HuV6wb4N?=
	=?iso-8859-15?Q?0ziY8XjaQ5R+1hASQ85GkRcoCatKqixfXVqAkODkMQ7ibqmqlV066Rb2z?=
	=?iso-8859-15?Q?S4+anHcG5LiNqqXeyC8Hn4hNRof16NKJu7wkIZy5zv9+pkE6LCHNNNGvp?=
	=?iso-8859-15?Q?qabxfxMyOkIHCy7yChxpQ1b4IYK49AmGLOPBhDW6Eopq8yXH0ykoQIyFt?=
	=?iso-8859-15?Q?x/TRAfgTLaU59Xdvri3VuXkSJu9RpbUmet7Y0ldABa/jmQ5HVGo64aEDO?=
	=?iso-8859-15?Q?gQ2xAIJH7+c4vPVEJjQmoZ1PMUlmNYEGIz6sLq3KVacuAQii+TetdPk/e?=
	=?iso-8859-15?Q?qXWBWZrTac6jvnkwPUDYM3OsxYBPE9C6FA0rIE/US6vUAlM4l+ps+btkT?=
	=?iso-8859-15?Q?6M4AvCZIrDYolzCbN24UbN1g6tC9AFJGq3VI3IhcMiWyr1FHJoik8btrw?=
	=?iso-8859-15?Q?x3kGTMua+gXp5LzP3phDxprDNReay6wcKrS54mnXNMYGEveLW7l3Tie1O?=
	=?iso-8859-15?Q?yp/rAAMuH7V+opF2mg6ey+CHY5IcNp/dtFxDjl2w+TX6krK1zGsT37Mtd?=
	=?iso-8859-15?Q?dLAAjHQXi4ohf2N7x6OYrE98eBfI3t0Gb+OhQU7aDBNf8QiycDbaDjgRN?=
	=?iso-8859-15?Q?CQ/bptf6WnVHdcdgJbazRJujNhbC+dQ/q?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e55b656-3a11-40e5-55c5-08d908b5928c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2021 13:16:58.9329 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GP/s9mROFEQ1bcmmnCOyTF2fN7MK9Z73ZjZq5V9nznSz9GzVOyow/PBUBxDBAfaEtoG0CqVsQK6FyHIJESUN1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4618
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13QDHAv1017570
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F5CFB572D8BA14429034FDCFDD757CDC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-04-26 at 13:14 +0200, Ulrich Windl wrote:
> > >=20
> >=20
> > While we're at it, I'd like to mention another issue: WWID changes.
> >=20
> > This is a big problem for multipathd. The gist is that the device
> > identification attributes in sysfs only change after rescanning the
> > device. Thus if a user changes LUN assignments on a storage system,
> > it can happen that a direct INQUIRY returns a different WWID as in
> > sysfs, which is fatal. If we plan to rely more on sysfs for device
> > identification in the future, the problem gets worse.=20
>=20
> I think many devices rely on the fact that they are identified by
> Vendor/model/serial_nr, because in most professional SAN storage
> systems you
> can pre-set the serial number to a custom value; so if you want a new
> disk
> (maybe a snapshot) to be compatible with the old one, just assign the
> same
> serial number. I guess that's the idea behind.

What you are saying sounds dangerous to me. If a snapshot has the same
WWID as the device it's a snapshot of, it must not be exposed to any
host(s) at the same time with its origin, otherwise the host may
happily combine it with the origin into one multipath map, and data
corruption will almost certainly result.=20

My argument is about how the host is supposed to deal with a WWID
change if it happens. Here, "WWID change" means that a given H:C:T:L
suddenly exposes different device designators than it used to, while
this device is in use by a host. Here, too, data corruption is
imminent, and can happen in a blink of an eye. To avoid this, several
things are needed:

 1) the host needs to get notified about the change (likely by an UA of
some sort)
 2) the kernel needs to react to the notification immediately, e.g. by
blocking IO to the device,
 3) userspace tooling such as udev or multipathd need to figure out how
to  how to deal with the situation cleanly, and eventually unblock it.

Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
afaics.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

