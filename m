Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A2AC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 19:57:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA51064EE8
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 19:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA51064EE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-ZnsReLBIN7aTPRnDENkk3Q-1; Wed, 10 Feb 2021 14:57:27 -0500
X-MC-Unique: ZnsReLBIN7aTPRnDENkk3Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E608DCE642;
	Wed, 10 Feb 2021 19:57:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4FD862467;
	Wed, 10 Feb 2021 19:57:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 610D918095C9;
	Wed, 10 Feb 2021 19:57:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AJvI1f008252 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 14:57:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6FE2CE2A65; Wed, 10 Feb 2021 19:57:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6950ADEE7C
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 19:57:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3866D8032E3
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 19:57:16 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-148-2e1T0O1lNeWBoXjWgRTi7Q-1;
	Wed, 10 Feb 2021 14:57:13 -0500
X-MC-Unique: 2e1T0O1lNeWBoXjWgRTi7Q-1
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur03lp2057.outbound.protection.outlook.com [104.47.8.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-ijOELds3PAerSfL8KcLGjg-1; Wed, 10 Feb 2021 20:57:10 +0100
X-MC-Unique: ijOELds3PAerSfL8KcLGjg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4924.eurprd04.prod.outlook.com (2603:10a6:10:14::33) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26;
	Wed, 10 Feb 2021 19:57:08 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3825.030;
	Wed, 10 Feb 2021 19:57:08 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bblock@linux.ibm.com" <bblock@linux.ibm.com>
Thread-Topic: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
	to verify the path wwid
Thread-Index: AQHW/qMuQs93dFGIW0CwQCKCag2SdapQZg8AgAFMbICAAB4QgA==
Date: Wed, 10 Feb 2021 19:57:08 +0000
Message-ID: <cf6a5910c2ab53e710c6692c574b3e2d3b78a4bb.camel@suse.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
	<YCQhW4uHx4j+xXmL@t480-pf1aa2c2.linux.ibm.com>
In-Reply-To: <YCQhW4uHx4j+xXmL@t480-pf1aa2c2.linux.ibm.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9714758a-d602-4383-4d12-08d8cdfe0c6c
x-ms-traffictypediagnostic: DB7PR04MB4924:
x-microsoft-antispam-prvs: <DB7PR04MB49241390E8F47C08BC0B5E9EFC8D9@DB7PR04MB4924.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: V6biFF0UmDYTzwMNX5BphI+bA4t2CSMkNaD+b3zNETNpH5Qc2pEiJKTP7NyefOaPY0lATDQ/98rAisogi6NrgJvwRJrY9PcdA3dMDEtF+wdv8b2Cd1KGfLfB8DSCt+sBjFLRx5/6dvcQ9ltTQJs2bkMGHFF+47GuiR95nUE/ACwI1expqNXxIDA22bsSkeW5ErOdi+QI57UjTgJbeTbcwJlXEy4ITK19avGQJMkzyuyHEhzpb5/Ghmv/pGsZFdfiwdebJ13Y4K3N0lAN9altmzSdo0E5JTRDvPq/kFxfD7mKgXnlkFZd2W6cyIdp1TUQZ9XzTOpk8rdxpAKiVBg4A2cwp71JgvD+2TwjclsvcLshQ6TbjBMSNfQaPm1N9UjFDjBANLe6mrFFjTSk6fqVtfmCP5Z0115BwcTPG1qrs4fBvkLiSb3uiV8oK3psmFx5h1hGJ3qNdUnjaPUIIgsIcB5bbyU3wFUw+1hJlwF3yyb/i4M6mycPdCSuotRpZBK7pGqwCvxJ/jR/c6LfmpTU1GhY+v1nfx9DOOTgUbX4ZOCOemLM0ZX7MFEpk7VE9Hj46tM6kjENXW83AnmSPmKfU28eY1zfBOMwif4jei4SY9I=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(39860400002)(376002)(136003)(366004)(396003)(26005)(186003)(54906003)(5660300002)(86362001)(6486002)(4326008)(478600001)(44832011)(6916009)(6506007)(2616005)(316002)(966005)(8936002)(4744005)(8676002)(83380400001)(66476007)(66446008)(66556008)(64756008)(66946007)(91956017)(76116006)(6512007)(36756003)(71200400001)(2906002)(66574015);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?8UOSMR1Wge/s5d49C4ruUr0sq3S+qq/8UVqazb4ExCkuSWJF3e1yMmvqP?=
	=?iso-8859-15?Q?6+Zc8LYl2wYQrrLzBfIT/t4vnaBBGyTN9jlt5f40jQGhotXPJBGA84k6h?=
	=?iso-8859-15?Q?/YxInYgEV2iWQS0s1DWxoIkXCRTeWg9vT3RAwhmK5/tNbIwwJ8g+q186W?=
	=?iso-8859-15?Q?KnbiAi8djtwzCSgkHUO4PY5MNOSJLv8gCPW2y+3CmltHIHEGRWbhJmI6x?=
	=?iso-8859-15?Q?O1ghtVvhRO7DHZg3r8QH5zT/LXpxNYWqSYBINY/0QIRZCanIWZRfaD9Yw?=
	=?iso-8859-15?Q?Ag6nLJWrxE2qhDlmffeW8oKv8n/j/oe+bMVRp+QoFUgxVH7HOokUn62n2?=
	=?iso-8859-15?Q?cXhRkLzjnS2AF5YUllZnm0b5pF8Vc8xQkw5XGvC4pPMTH/zzWAktuzIYJ?=
	=?iso-8859-15?Q?+hjMkNmUFpW/bNpi+REbcgdx1vyliyGAZVzHg0l7+CuXjdQWeKnorFcah?=
	=?iso-8859-15?Q?N2pYnchc+cEB0vNuJGvPvdgw1AQ8BzBsUa5G4acBxLog2ILvqt1PZ9fyA?=
	=?iso-8859-15?Q?yUv/HqNXpziieOvRrT83MrD1vVNkHEy5CpibsAPU8oa+8p5BrjoCWIWT9?=
	=?iso-8859-15?Q?PZPKdL/0n/mUnzPQNAbbfulJ+fLD9YfU4ZExM/XL/7mRSp1o8jQEQS5gA?=
	=?iso-8859-15?Q?/BPsiE7jFBuuO9Hr3ffY1ESmg9YnRftIGfn7qHSX5lU2hikvbIRELOG9g?=
	=?iso-8859-15?Q?2uVTAdBwNRWm1IXDvwght38hBPGSmC+mR0b/TwjWl/U5kLSncZj99ZWj+?=
	=?iso-8859-15?Q?i6VEbEUa/xmjPJZCXEOY4DrCXM64CBvkECWldEoP6N/vjg8QfIen5ixyt?=
	=?iso-8859-15?Q?IOZWtDg7zvw7EAUENl8RW7KD4jBgAJ6IAMf/QXEq0iL12lkW6OiiYNBWA?=
	=?iso-8859-15?Q?fjkoSeSskayoT8J/aCW7M9InXQ8+sQ+Bc9N7Qu5FIrq84cXzdInwzBNgf?=
	=?iso-8859-15?Q?W/HSjwf99Wpgr3G43RIyLlyPcHnu/QEl8Db5cH6lE+17QUzayixutQA3D?=
	=?iso-8859-15?Q?IehvcDKdP6a9C1FsBp9UbxQ4zYNIRJ7/C1UK9t6aLDAoTcN6Kk8yxProp?=
	=?iso-8859-15?Q?KbV3WRNDWYOUT6jVGVM+GQvL0P7Yf/3fTicLQon7DlMZAGekcZ19fYcM3?=
	=?iso-8859-15?Q?beABPn5LkCbuj6SZq+9VY9fYsNBttN/oHbt+9Cul20Z3fEL0e8AHKaPmY?=
	=?iso-8859-15?Q?JJcTO+7HjvqG8aDFiba0pB3+/Esd3bcKQkt3gCN5Phv3pLgEOSwNFd2pD?=
	=?iso-8859-15?Q?JSbXCmLFSVkvkroqMkohlx5cKbwDmMk546FdAyzvGs/cie5Lw8m8zF/WM?=
	=?iso-8859-15?Q?QIEaZ6qrjsgexMx4xViuQF416Ne6Q0hjRzZ460k+/+4QQAwNR3ovu74r0?=
	=?iso-8859-15?Q?2DWrSifhS/Pcc8hclA+E6innkJG5CQ5sV?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9714758a-d602-4383-4d12-08d8cdfe0c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 19:57:08.5607 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3vtWzCTOJWa2O7j2co0see1/Ad4HwRStM6mLq06txGoqMhtqcRSpq1UJEvCuD7EMnReqp+DP7xete4oUGcR32A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4924
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11AJvI1f008252
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
Content-ID: <8E6776222C3B1348905A570FB0CD6AAF@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 19:09 +0100, Benjamin Block wrote:
>=20
> Yeah, just for reference, I saw this happening in practice when
> something with the LU mapping changed on IBM storage - IIRC I saw it
> with capacity changes. You end up in this code in the kernel:
> =A0=A0=A0=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/scsi_error.c?id=3D92bf22614b21a2706f4993b278017e437f7785b3#n416
>=20
> And from there you ought to get an uevent for the sdev.
>=20
> The WWID in sysfs might still be wrong though AFAIK. The kernel seems
> to
> ignore the UA after it delivered the uevent.

Right.

We could trigger a device rescan if such an event was received. Could
be done from udev rules, or even from multipathd itself.

Thanks,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

