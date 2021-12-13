Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A536C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 11:44:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-VShBt1WrNjmn928soUEJnA-1; Mon, 13 Dec 2021 06:44:35 -0500
X-MC-Unique: VShBt1WrNjmn928soUEJnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6952910247A8;
	Mon, 13 Dec 2021 11:44:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A662B2B88B;
	Mon, 13 Dec 2021 11:44:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5E5DA1809CB8;
	Mon, 13 Dec 2021 11:44:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDBiOPG019820 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 06:44:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9308B2026D5D; Mon, 13 Dec 2021 11:44:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D4E22026D46
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 11:44:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FF53811E76
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 11:44:21 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-58-4j2sp4vzMPOktCAR9SqCPg-1; Mon, 13 Dec 2021 06:44:20 -0500
X-MC-Unique: 4j2sp4vzMPOktCAR9SqCPg-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2059.outbound.protection.outlook.com [104.47.6.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-29-38o0mGARMPe_od58Ao2nwQ-1; Mon, 13 Dec 2021 12:44:17 +0100
X-MC-Unique: 38o0mGARMPe_od58Ao2nwQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17;
	Mon, 13 Dec 2021 11:44:17 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4778.017;
	Mon, 13 Dec 2021 11:44:16 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [dm-devel] [PATCH] multipathd: handle fpin events
Thread-Index: AQHX4cN3WHkLuxT/XU2rhrfCJFDyLwJKGHWlAW73NagCE2TiGQExJ+o3qxbYYFCA4aS3gA==
Date: Mon, 13 Dec 2021 11:44:16 +0000
Message-ID: <f9638b1eb78c1ab597c42a3d799cfdcf8c197184.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
	<f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
	<b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
	<266050393293d390e4252f0220b7a8cf@mail.gmail.com>
In-Reply-To: <266050393293d390e4252f0220b7a8cf@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82a490b4-bd2f-49bc-3c95-08d9be2de48b
x-ms-traffictypediagnostic: DB6PR0402MB2743:EE_
x-microsoft-antispam-prvs: <DB6PR0402MB27438EEC6E83831E0B0423E2FC749@DB6PR0402MB2743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: sh3+tt4W0yJaxdrui/TA/DA/efWw41mgHa7o9nhcINW72/GaDwfpwlL+Vw9DvSvo1aqEfx2XBVpIrEmGAjOc8P6anzI3UwT/biYP8Ru8l+nuJHPmzLEywdmaY3//c1WTKwRs2W8kDTQPnNmjvSzUPMopP6XEIZ+6sAwDqMBvJ8At5fcxKqbRWO4sBGrtzzKu7o1bLfNuSYCSLDy5RA3T89lIJUYAzeJVD1zFK30VhraMlKLZZQXQWmoFt+37ZUF/cgVxv6/+wCDA/D7BBXS419lNKgLv67u2Mc0ceTsuve0tcX9nmxFl2WjyNYa82OU62xTukWkKu72WKwdzLxq2qL6w0UzMj5BI826jifelWG/dK2n0jvFj6OhbPRbQIOMTd33GOD42Zwaprtri5vkZYRy0DnXC6rLwFuGZxLwJ23M6j6sRibb53YZ5kbO0ykTG1hvT5FdTfEpwgGMlFEmt62t/KXM53dhqkMeT5q7QGPxQa7fCD6cKSX6X3KJeLKRGAh18MGwIZxuqfUVWBmWi3cdnhc75NqaOOdy13DDrKuyiCxSnP31ZXSdHAIJ8C01P+s7yD5SUvR7954DofS079IHIpZSGFlWqIBTQMj4nU6oBJwRi3p4KaXqdJKgJEnyQkzOa/oo7T8VXhi23P24ZSzhCPLC6PXuHNgoh3fEHXBOYyEnTY4t2dLh2kKSZlgi51Fga1PQcwPQnID8U6/hzpQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66446008)(86362001)(66946007)(66476007)(8936002)(91956017)(186003)(508600001)(66556008)(76116006)(2616005)(71200400001)(5660300002)(26005)(44832011)(64756008)(110136005)(2906002)(6512007)(36756003)(38100700002)(8676002)(6506007)(122000001)(38070700005)(6486002)(4326008)(316002)(4001150100001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?emSIEjMGB1eJjIRlD1xVVKAGzW2FD9kduB+kfCd2KK27dNY6UcSBDYv5J?=
	=?iso-8859-15?Q?I80cVsx6spYBPT7VUlSl2ibLXFJgWuCAVZ9W7W4VIKfGAsz2oY8fuSwQD?=
	=?iso-8859-15?Q?8JQTGKvPFF2mMdyRAc3wQ2AKlf45FCc/q0lR31s7iIStf05B0cwydaRiW?=
	=?iso-8859-15?Q?YX0t5uAglePT77XitFi7/4uDoTQBybw4RqBnKilKM1LqgF/IwqmVhKzwg?=
	=?iso-8859-15?Q?RKfnWIFzgMJJeYoxVwWAfA6NoiXCyvkFnc2WiIKv9TPuFy8L57fnukd8O?=
	=?iso-8859-15?Q?6Uc5hgkYU6MDKMrV559cAgcU16Fke7M53s5+9mBMJ7kff3TcsVJZUO+kz?=
	=?iso-8859-15?Q?F/9+7yhy9H3K/xOtAXZ4ZmDcJK1HNcGeC4174zw3hqFXeCWv+d/vJKomb?=
	=?iso-8859-15?Q?2i3lhNhDm2gvGRUaqy/QbGF+sWUtPTQ+DrGG2H7uYHcS5xJ33HTndnNKU?=
	=?iso-8859-15?Q?bqG49GuN7ENGfe7NLm4+uYUItRW9AFmzqsQ1KMXkjuC7bSwT/66JVrowB?=
	=?iso-8859-15?Q?50k4FOqUtIx3CpSZquVRdn6fXvFVWtAhhD9CoT8NmXA//+X6PuNWn7lrU?=
	=?iso-8859-15?Q?Tu7Z/vWOQVdqlwuVbzdD0+cEmAqzxhmw2W7HX8Tl5zGYzg4HHwCzH37Vs?=
	=?iso-8859-15?Q?5TLBvqm4TiV8X3r13Dy7Fhq30hIVCqYduOHytH/JWZLI3bMUY6nwSqq+h?=
	=?iso-8859-15?Q?uehSSY3RqUxA0yMcBHys1ShllSwCuicYs7s3IbNQmEcQ7dtZaz3dQd8zQ?=
	=?iso-8859-15?Q?rkWU1UVQYNbJm+SuBUhwJT5KQsTzClPn+Z5LZqgK+7gEI5mrkX+k28RrY?=
	=?iso-8859-15?Q?4GqMe8NuF7G8nLScjvcAdN8frEZ42iJ6kuGe4umLdqCegfpm43+VsenAL?=
	=?iso-8859-15?Q?hobEXtPE2YeTMfICCNvv8FBvi7XWad4OvyBLmAWLvXSOLGUILIFJZUHPu?=
	=?iso-8859-15?Q?w6ltAN6ADcFIC6F33KLXlojeB2kiob/qBf84i4Llzf3DxgBQkYoexQTRO?=
	=?iso-8859-15?Q?ZKY8DWaYP30Nn74UWDC0NFOeFEg1usmGif6R44zxe6r0dIjzmpTtPmmdy?=
	=?iso-8859-15?Q?QJ5kjIv+uWhZLBWzcRaRdxqrMs7dQxkMOpMYtLUfyW90LD3flHeFuUc86?=
	=?iso-8859-15?Q?++TeY3kZ+o2Yc118euE7eDM1Oele4ayw1ECUc98xDgSPOsPNrias29P3r?=
	=?iso-8859-15?Q?GR8Zb8HGHRX+dOTVwxV7Fy4VLi3WDNIOzXq43Dyl0yuZgEs7R8xHHZdLR?=
	=?iso-8859-15?Q?ZSr4/RZ3reQYdJq14ZJvCBfZgztRI/N/HSo7t//nIJ4thrnM3XgccTzjS?=
	=?iso-8859-15?Q?nc7iYDPpE0Xs66vdB7QbNV5pxudPMsTbgxQazowyrakIVJ9gazEmBGf9S?=
	=?iso-8859-15?Q?++/T/NMQ5lIGVv9cdxoSxZsxmxJKqROuncnX4fZDpx4VzmMRkNIpRgOvH?=
	=?iso-8859-15?Q?9sATYKrUc1dGlntplPJofhEJLaHA+WrBq/w7tnxs4la6ZDADDngWPSEw3?=
	=?iso-8859-15?Q?PUC9mZ9XRB5oPK3iQLi6RN+cd8dmntIKFW71TYpBvtepc+fp7PXoSpBKm?=
	=?iso-8859-15?Q?GS40nx2NPDVL7XPBFA/z5UVf+DtK2eLHd1MGycS/aDS4x0gCbYUqIHV0b?=
	=?iso-8859-15?Q?BW5K/mYYu/uLPU+BPDPyo+odTFIcYkJgWwq40P9BJlvl4ursu7exB7GjH?=
	=?iso-8859-15?Q?y3oFGawqXUsMycz+EgtIblGW1T0bn0jK9CtQUcY7lp7M/RI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a490b4-bd2f-49bc-3c95-08d9be2de48b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 11:44:16.5772 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgSoW2IUM09sT+bnHHJ6n1VotbWDREcit8lcfJ5x2/4bcLi50u5NLb24jxKtf8KD25dEMyWTCq/JD8Pog7Gw/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2743
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BDBiOPG019820
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
Content-ID: <D693AD0676EAA84688E61E0E5291B0CF@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-12-13 at 14:28 +0530, Muneendra Kumar M wrote:
> Hi=A0 Martin,
>=20
> > However I am really thrilled by the prospect of generalizing event
> handling and reusing the uevent threads for FPIN. That would reduce
> complexity a lot, which is a good thing IMO.
>=20
> I have a query with respect to generalizing event handling and
> reusing the
> uevent threads=A0 .
> Please correct me if iam wrong.
>=20
> FPIN events work on NETLINK_SCSITRANSPORT
> =A0=A0=A0=A0=A0=A0=A0=A0netlink_kernel_create(&init_net, NETLINK_SCSITRAN=
SPORT,=A0
> &cfg);
> =3D=3D>scsi_netlink.c
>=20
> whereas uvents=A0 works on NETLINK_KOBJECT_UEVENT.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 netlink_kernel_create(net, NETLINK_KOBJECT=
_UEVENT, &cfg);
> =3D=3D>kobject_uevent.c
>=20
>=20
> I am not sure whether we can reuse the uevent threads for both
> uevents and
> fpin events.
> In case if my understanding is wrong could you please clarify on the
> same.

Right, you can't use the same socket. But you can open two sockets and
listen on both using poll(). That was my idea.

Anyway, this is just an idea. I think for the time being we can move
forward with your current approach, using a separate thread, and
discuss merging the threads later. Please work primarily on my first
reply to your patch with the detailed review.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

