Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD06C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:29:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F08D610E8
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F08D610E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-kmP6W-YPOg2bFKjK4hrSTw-1; Fri, 16 Apr 2021 19:29:13 -0400
X-MC-Unique: kmP6W-YPOg2bFKjK4hrSTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D36C10054F6;
	Fri, 16 Apr 2021 23:29:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D22A360C0F;
	Fri, 16 Apr 2021 23:29:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C58B3809;
	Fri, 16 Apr 2021 23:29:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GNT1X6016329 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 19:29:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 309701054E4A; Fri, 16 Apr 2021 23:29:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B5A91054E49
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:28:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 467DB100E643
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:28:58 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-137-_a8VcihVPDipwZVnqHN04w-1;
	Fri, 16 Apr 2021 19:28:56 -0400
X-MC-Unique: _a8VcihVPDipwZVnqHN04w-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-3-buz80XcSMNO3nEf2d8w6sQ-1; Sat, 17 Apr 2021 01:28:53 +0200
X-MC-Unique: buz80XcSMNO3nEf2d8w6sQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8348.eurprd04.prod.outlook.com (2603:10a6:10:25c::7) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16;
	Fri, 16 Apr 2021 23:28:50 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4042.018;
	Fri, 16 Apr 2021 23:28:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXJIIevKqEvjcbJUy9Ai14uQzKmaqm92EcgBDwGwA=
Date: Fri, 16 Apr 2021 23:28:50 +0000
Message-ID: <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa1bd9c2-5edc-45a7-8919-08d9012f6438
x-ms-traffictypediagnostic: DB9PR04MB8348:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB8348FA3AF1B8AED5F4AAF943FC4C9@DB9PR04MB8348.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zzafQcYEMwRnC8iK3/N+wL+fKW/Jf2A4MiR0u99BjaYAeAOkkih8WYBNaH1+Jh68CAJ+pzuE+4AfJn5hh3VwOJuLG671bLK/vWKAKfXVx8AR5rMi0JRqFxGNSa7AbwMaW2qPAZt80uWOI4t4P6BdVzn6CLL0Fivw8LL6A6ONYuHfmd+Eef3wTadpjrh9xFuU2Qwr9XPq/4ggzGR2I40yZllHSUlFjbdsbOK4y5vLQ5xYcC83Mnv+wyt1Rxiam2vUgiz8C2rnLUZICnC743d8wM6lL1HvMXXCn6r+0ocQdj48m733DdFblRLg917hMJ01k2QdISpI4q6wDR3nV7e8bHRLiP6Px9jtejcJURJUDLQyDrb9ddp1iBnj0NE8w7y+Ezky/qrvAxt/fNDAgKHQx/PQDPs0v8X/BluFe2GKqOF8Y+Fq2AXKgvHUqis1d20s5DvdBBRhBKLzVvkCkJ3CKEeUrvFl7f1Cgu50Zru8DmfHeWv4PjeesmUZKJuk3UYdkSM843eOEIDC3a/Tek2sSogahawPzrigG6YIM4Nokl2d7UYAeBMSC4EJPT/+GraeLavAuUAixVACElMEZ2FTukEZjNiJbyvjI6FovyG0nq8=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(316002)(71200400001)(86362001)(6916009)(26005)(186003)(122000001)(66574015)(5660300002)(2906002)(36756003)(4326008)(6512007)(6506007)(91956017)(8936002)(478600001)(6486002)(8676002)(83380400001)(64756008)(66476007)(66556008)(54906003)(2616005)(66946007)(38100700002)(76116006)(44832011)(66446008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?1Ec+6vpX74kxHOfy+g1ayEC83Eo9nxeAvUyf2M8J+0Del2+EhsOtmVpTr?=
	=?iso-8859-15?Q?s8Vo+ELCZsY7qYiOaBXMhuBXG3vwoLOGTNAWMM4AkIxmGvcnUooXTL2J3?=
	=?iso-8859-15?Q?TbHG0iGJ9t8hZ42g6sBXKHvRxjb4IYiww8dXTj2J3pfS8tqUHatMypTHy?=
	=?iso-8859-15?Q?gdTEaknesyvKJz/Y1tQQjp3+kwTQKmQ7Mb83vKBB9iqvibMqqwu3GzBhB?=
	=?iso-8859-15?Q?BHSJOCSCfIhy64We3bC8Yliv6Nf2Ly5HZCfxvAEYnehaC1I+iW+1zvxZx?=
	=?iso-8859-15?Q?FMU4MXu91IPlc00/o/JqUXZy94EIjKrJt5uKS+/MxBNJjBJ5PPdGzV/yA?=
	=?iso-8859-15?Q?09nUJmSyYe2R2cMfLoZqkuwK40O/+JJ2ABiCAZNm2va9y820Q+pvcg9f9?=
	=?iso-8859-15?Q?Orv3+qPphEnfGNX5wRo/1OSC0XXrf3koAJ9cXnh9Py77IoUFVf3gvQr2h?=
	=?iso-8859-15?Q?Yt90+3cNpi7OAuaZRGEJ5SMP4VOBjAiKuMpDAFhCsTDiGSig+LW6HsbLH?=
	=?iso-8859-15?Q?nc3/yS4vVCnY3o8w8QMRabvlG//bapNgv+jYa/Xi37Y8iWZQsj5fx7s8U?=
	=?iso-8859-15?Q?QAQp78lyNpd2uaRghy0TC1CgKNypDmajHTxoYjD6KhuHxKSmi23ShyjAm?=
	=?iso-8859-15?Q?fquJmzIt7tnJnSVj+D+odA611xkTh/Rp2ALdNLAh0ttk8EBqNvP0qnbKZ?=
	=?iso-8859-15?Q?SKD3un30WDtyIt1YH7/jUoxEBInQs7dHTmGDMGaUmcGyWsFwZjnuSIRdr?=
	=?iso-8859-15?Q?urmIZ/ELm/LysEf+RgA1JkfLHlwf6txfY2prw7lX79MMCZ8ETAJycG3VT?=
	=?iso-8859-15?Q?pgW3APHiC9AhEZHaZVTpoO1TqAnZgS94UoJsg1cbircKX3Bxht35OvR7q?=
	=?iso-8859-15?Q?G4Rga0WJ2I+eVVL2lRBZY7SBPSA/p6/+aoIzpA3kCr6hYJB3ZNzyCzQ/m?=
	=?iso-8859-15?Q?HtFMBUUXikXsfv0e8QA1PfSKTJ4fd2fq9VaFYN9xQdzEemv6+cGeNB6JV?=
	=?iso-8859-15?Q?GdlLhnotrZgEs/19IVQV6hyscpCJb4rALjF4JbBXPD5YgDPlVM3tKysUz?=
	=?iso-8859-15?Q?jK4T7EiExrdXq0Jo1LIihjsMpmRHA5Tfe/suqjRCv6XqympHdd/zc1RL4?=
	=?iso-8859-15?Q?kQv7t8gLnOcw+RZPp8sr7xGtkjyJ4GUjDWdOBrJU+utDku/sCqt4Ylldt?=
	=?iso-8859-15?Q?Po1S6EbDQYtjPH2aC/HuMxR8cPKBAytZqNKNbswPyPg8V5pBLiTeT4bFA?=
	=?iso-8859-15?Q?DJNSKo2jGYKSjwidYVtChdACiJB+JDpsGQUKiSWbiQlayIgsWBAaT/kyV?=
	=?iso-8859-15?Q?Rtvv3YsqpctCot9TtRQjwlX0DiADmwmXdOfaFohTVq/8L1vQGuoBzPHVN?=
	=?iso-8859-15?Q?XsXiEn1/V0+M9dZqNyv3TUeAXf119d+g+?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1bd9c2-5edc-45a7-8919-08d9012f6438
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 23:28:50.3794 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TCwzTV4IBEz3M59YrzaCrWbd+sxfl37BA6vzUqj2ZthehzG9Bl57hFyy5261P5LZxU0KMwIwXadze4LrvMGenA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8348
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13GNT1X6016329
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
Content-ID: <95D211C502429440A0E0EB11EB618115@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Martin,

Sorry for the late response, still recovering from a week out of
office.

On Tue, 2021-04-06 at 00:47 -0400, Martin K. Petersen wrote:
>=20
> Martin,
>=20
> > The kernel's preference for type 8 designators (see below) is in
> > contrast with the established user space algorithms, which
> > determine
> > SCSI WWIDs on productive systems in practice. User space can try to
> > adapt to the kernel logic, but it will necessarily be a slow and
> > painful path if we want to avoid breaking user setups.
>=20
> I was concerned when you changed the kernel prioritization a while
> back
> and I still don't think that we should tweak that code any further.

Ok.

> If the kernel picks one ID over another, that should be for the
> kernel's
> use. Letting the kernel decide which ID is best for userland is not a
> good approach.

Well, the kernel itself doesn't make any use of this property currently
(and user space doesn't much either, afaik).


> So I think my inclination would be to leave the current wwid as-is to
> avoid the risk of breaking things. And then export all ID descriptors
> reported in sysfs. Even though vpd83 is already exported in its
> entirety, I don't have any particular concerns about the individual
> values being exported separately. That makes many userland things so
> much easier. And I think the kernel is in a good position to
> disseminate
> information reported by the hardware.
>=20
> This puts the prioritization entirely in the distro/udev/scripting
> domain. Taking the kernel out of the picture will make migration
> easier. And it allows a user to pick their descriptor of choice
> should a
> device report something completely unusable in type 8.

Hm, it sounds intriguing, but it has issues in its own right. For years
to come, user space will have to probe whether these attribute exist,
and fall back to the current ones ("wwid", "vpd_pg83") otherwise. So
user space can't be simplified any time soon. Speaking for an important
user space consumer of WWIDs (multipathd), I doubt that this would
improve matters for us. We'd be happy if the kernel could just pick the
"best" designator for us. But I understand that the kernel can't
guarantee a good choice (user space can't either).

What is your idea how these new sysfs attributes should be named? Just
enumerate, or name them by type somehow?

Thanks,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

