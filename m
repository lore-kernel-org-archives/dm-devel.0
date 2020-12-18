Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E84C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 16:07:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5B8423B6C
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 16:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5B8423B6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-HkGMXCEwODyHULi3Q1e4sw-1; Fri, 18 Dec 2020 11:07:21 -0500
X-MC-Unique: HkGMXCEwODyHULi3Q1e4sw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B41188042A2;
	Fri, 18 Dec 2020 16:07:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B3305D769;
	Fri, 18 Dec 2020 16:07:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 801AD4A7C6;
	Fri, 18 Dec 2020 16:07:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIG7AZ5019514 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 11:07:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E3C201111A70; Fri, 18 Dec 2020 16:07:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEF9F1111C6D
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 16:07:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25BF2800183
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 16:07:04 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-431-UPSYar05ObS_sKemE3xyhw-1;
	Fri, 18 Dec 2020 11:07:02 -0500
X-MC-Unique: UPSYar05ObS_sKemE3xyhw-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2054.outbound.protection.outlook.com [104.47.4.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-9-yH8rw-nSMk2hn6qgM2GQRg-1; Fri, 18 Dec 2020 17:06:59 +0100
X-MC-Unique: yH8rw-nSMk2hn6qgM2GQRg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7802.eurprd04.prod.outlook.com (2603:10a6:10:1f0::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.26;
	Fri, 18 Dec 2020 16:06:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 16:06:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v3 0/5] Misc Multipath patches
Thread-Index: AQHW1McgT96VDOLqXUuQ8cUvfwYby6n9Bg8A
Date: Fri, 18 Dec 2020 16:06:57 +0000
Message-ID: <9db5a69f31da0ff9d205db25aad3584fb6cf04e8.camel@suse.com>
References: <1608245463-1746-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608245463-1746-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdaa0005-715f-4eb4-d270-08d8a36ef211
x-ms-traffictypediagnostic: DBBPR04MB7802:
x-microsoft-antispam-prvs: <DBBPR04MB78027D6D7B2EA1D6B4B72B41FCC30@DBBPR04MB7802.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: m/g9GENQmvRK/+34lYy3tU4ndSM+K19bK8eD8OgElH/Yz1MgLZ6B4UUAteMH//LloJXIuQyoJ0FF2S9WD8xp+5c2wsJ2nKJ3uAro/k2MCQ7qxGVLAJomck8jSDj7niGsRLfkHcRd8s//kDkinuHWsoItHJrz4wtoSpfezR0fnOq8QaOwZtIe7Leh4i58NrbrUrRXh/o0/HfJ3PCiYoO1KoKVlRIZ91yYBz+o/d+Zv3xuosWWkPkchayBVhDr5BcVl2pZ99UjHsgLHbkmkIp8kWRiPb+tUhXNfb9alfUXAfU9eoZ+xmxQlc2hNslWR07yj/zIPC7D2vLv9bKk6/HuIA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(39850400004)(136003)(396003)(346002)(366004)(2906002)(71200400001)(66446008)(66556008)(86362001)(76116006)(6506007)(2616005)(91956017)(66946007)(26005)(8936002)(4744005)(478600001)(4326008)(5660300002)(316002)(44832011)(64756008)(66476007)(110136005)(66574015)(6512007)(8676002)(6486002)(83380400001)(36756003)(4001150100001)(186003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?7xK9cyMcrpDs6ej07ohG5BNLK+jGvUDoTD3RY3zh2Hur9nmvSsMNex3xY?=
	=?iso-8859-15?Q?FKtRMtCyaEHiOW4JZOsy5ceegqcERb08gCi0ca+LFTiKqen0LYd2UtmcT?=
	=?iso-8859-15?Q?zxUEl52rYCz/KJRhT2qvtuH9eiYiTnL34s1UMH9MPHlMzLM1MmLTP3os1?=
	=?iso-8859-15?Q?UxUyiAF230hC6LBursAY5H+UlK/mwU6hQZtiKZPoI/qZaSmoEDGku0gJY?=
	=?iso-8859-15?Q?uUp9VhhTYfnznDBeQpkKJmv9C1MWV+UFbOO/cMUR4v368GkVuZM85ISYi?=
	=?iso-8859-15?Q?qOpY19B/bMChjJRQdZbug0SfueA270gB3vNqbx5VoTdwbU6aQhPJfjSwL?=
	=?iso-8859-15?Q?ym8CDpXp+0QbJhsotdMpipY7eTN9ZGvIRZ+byBC27BzEs0FjDviW6SzXQ?=
	=?iso-8859-15?Q?8hh08Wtd8ZHipFuOpseK++E4CpjHc9daUqTCm+V86yv9xddTGMW3p45lo?=
	=?iso-8859-15?Q?MHPxv1kLtwVAPHAlSjWJItPz+V7KHB8Jzs8l0QOKmFoNOoKlzPX6R4rb6?=
	=?iso-8859-15?Q?ZmTADj+FCRqjFeV6vGHFHM3y3tKfh+1nIM3jLkfYh1Ft4qzlNCW/X+JBk?=
	=?iso-8859-15?Q?O5nsgbmz/RR/++45AUksg0q88rip3mOgnW47xROPioJgKgAdoGVb77CRY?=
	=?iso-8859-15?Q?h1IvneBbuUUT6v888BLceq8/eKEWhWqd4wGDyCjlAsdY3JUPoreQD2yB9?=
	=?iso-8859-15?Q?bvwN/87GZrxWYrngcSBusFKwLnebLmE2wbZNixHDnb1ay28c4iw6zJJbh?=
	=?iso-8859-15?Q?fqLeeTaXFZWJvkSmf/T1X5qc7pnJrJVPzQ1LJX4EuLtWFiObjtWo7EfRd?=
	=?iso-8859-15?Q?sN3ijBOCXA7Vc83GGtpVUVS17sWwbqObjlwhve7u4oD9K2MTzvofhtzjt?=
	=?iso-8859-15?Q?neUgsw/6++lg8/6Ta3X3EFfAzYn4GSfbVSwcIkJSb7JcdiSgEBwCg1v2b?=
	=?iso-8859-15?Q?KcQEzyxcBUufOm00glBYr9xyh46MhUDr03fD6Uh23e1TW6RHbtumEhJXq?=
	=?iso-8859-15?Q?cY+iXuTo3AZqxz0SeDcwy1RzHNjHFyQ82gyc4RTgZYLpR2KC/nW2Sbg?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdaa0005-715f-4eb4-d270-08d8a36ef211
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 16:06:57.4390 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AhBx9q5g8VrUekhjym7hZy1zwo4eUjwudU46Ve44Irdxj0NNgIxl6sAMZO1dbQY3b9ZPL5JJfaWgkLp2LFHnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7802
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BIG7AZ5019514
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/5] Misc Multipath patches
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DBA528256459C54BB0D70E169211CB50@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-12-17 at 16:50 -0600, Benjamin Marzinski wrote:
> This is a set of unrelated patches, based on top of my previous "add
> library to check if device is a valid path" patchset. The first two
> patches add a new config option, eh_deadline, that sets the scsi
> sysfs
> value of the same name for scsi path devices. This has been requested
> by
> multiple customers. Patch 0005 is a change to detecting rdac support
> requested by Netapp.

For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

I will push this to upstream-queue now, together with your
libmpathvalid series and my recently reviewed patches.

Please have another look at the result.

Cheers,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

