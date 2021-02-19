Return-Path: <SRS0=AGY1=HV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4790C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 19 Feb 2021 10:46:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21B8764EB1
	for <dm-devel@archiver.kernel.org>; Fri, 19 Feb 2021 10:46:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21B8764EB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-Zrs4hMQUPI-UVO5h40cmcw-1; Fri, 19 Feb 2021 05:46:22 -0500
X-MC-Unique: Zrs4hMQUPI-UVO5h40cmcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89950193578B;
	Fri, 19 Feb 2021 10:46:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 527D15D9C2;
	Fri, 19 Feb 2021 10:46:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 941874E58D;
	Fri, 19 Feb 2021 10:46:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11JAkEIS000893 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Feb 2021 05:46:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A975209ADA1; Fri, 19 Feb 2021 10:46:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13D0F2018035
	for <dm-devel@redhat.com>; Fri, 19 Feb 2021 10:46:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2AB08007DF
	for <dm-devel@redhat.com>; Fri, 19 Feb 2021 10:46:11 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-229-t3mBSoG6Ou-67O2bybo2-w-1;
	Fri, 19 Feb 2021 05:46:09 -0500
X-MC-Unique: t3mBSoG6Ou-67O2bybo2-w-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-Ksrt5nd9NrK2RRm60rj9jA-1; Fri, 19 Feb 2021 11:46:06 +0100
X-MC-Unique: Ksrt5nd9NrK2RRm60rj9jA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB8026.eurprd04.prod.outlook.com (2603:10a6:10:1ed::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28;
	Fri, 19 Feb 2021 10:46:06 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3846.041;
	Fri, 19 Feb 2021 10:46:06 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>, "bmarzins@redhat.com"
	<bmarzins@redhat.com>
Thread-Topic: [PATCH 2/2] multipathd: add recheck_wwid_time option to verify
	the path wwid
Thread-Index: AQHW/qMuQs93dFGIW0CwQCKCag2SdapQZg8AgAH+94CAAHySAIAKa50AgAIOWwA=
Date: Fri, 19 Feb 2021 10:46:06 +0000
Message-ID: <7fe1a67f01849cb514f4ce3130715ac6f5d7709f.camel@suse.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
	<20210211044833.GJ15006@octiron.msp.redhat.com>
	<293ad1261123efb63dcfff4d02440e1728b3c013.camel@suse.com>
	<e930e111-d98d-bae2-baad-501c2c591d02@chinatelecom.cn>
In-Reply-To: <e930e111-d98d-bae2-baad-501c2c591d02@chinatelecom.cn>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.223.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dee4873-2025-49b0-c69e-08d8d4c38f74
x-ms-traffictypediagnostic: DBBPR04MB8026:
x-microsoft-antispam-prvs: <DBBPR04MB802680FF98973DF509468B2AFC849@DBBPR04MB8026.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iQK5N77tUQZcmeSh6vFWmwMJ4yiWE4w37RCeSjhPTgG//xXXc0EZRMhvw32F+v7MfUax8NIYPSDNWvnsip57dOOJhZw/b+chkIMLCAOYaBxQKk9HfqR23NvWcF1sSsPLYurVIxEA6U70wCkz2CS2+lnl43iy9pzBLWM+cKnTMD5PbbylLpmz2ggs1MR5zl/TIJYB9iqqaUo+L/7An4F8TIDu7LFHtUDevCB2sSaRJnATJjckJP6qlHh/ZxRqu0udoNeUVvZ4o5sGnffbEeKy26d9Tpa6WmV6qhWww2VbJSslFm5z3xtNO2nX7S6BqPuMMWkS3DifiRl2pjshNOfg1x8er5uuiT1I1WfVua67r/d3nrfohpGMzRuFygOUa9rzNLna8LWCWcNnQo718Nhu6gDeX1X7G234c/F9lF9vthYz28wnOJlP/HIllhJtq18gvZN+h0IyWWhbI7vxViCPUsQenjTj4MFyl1+iWdp0Qj3pxZjoWDHqmTX7Wl5oJRFX26iyucESovcI+mNBPSYQHw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(39850400004)(396003)(376002)(366004)(346002)(110136005)(4326008)(66446008)(26005)(5660300002)(6506007)(186003)(6512007)(2616005)(316002)(54906003)(86362001)(83380400001)(36756003)(478600001)(6486002)(76116006)(66556008)(64756008)(66476007)(8936002)(66946007)(91956017)(44832011)(66574015)(2906002)(8676002)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?5oJ+6IRenLYP1b7rwlit2xOmzJv+m6C2lh9ebG7JV51lNDR9n1RAySQMH?=
	=?iso-8859-15?Q?C7dMMVJoeAByMrn4crJMNiGeJ3Mk7fvrDGlDMLb43yxbE1gNrscdyfUjn?=
	=?iso-8859-15?Q?OkStLgYBSw3qynSxJzKQy7Z0Zo8zOSm5S/QF2LEEWy5yd6n5FawC55in3?=
	=?iso-8859-15?Q?5pu53wxax31oCBLyMXEjbnPPicztkBy/ItvuQ7H7HC0RYEsy9w2phqnT1?=
	=?iso-8859-15?Q?M0eX905UO4B0vzmLFrq+4tZxAtZb9QHkLlhXAQdQ4K5xX48A2PyIdflx5?=
	=?iso-8859-15?Q?AVB5dm7zC+BAtzZ9InQ3u5oa1rQPI70fVj+LyFO/qFnAm4r9Jz8OzMaWo?=
	=?iso-8859-15?Q?yNNrwVmONng6makIofI1VeWkB9QVMhru2cv110U+I+joGHTVhq+cgwFir?=
	=?iso-8859-15?Q?CK2FIH2PJQ/B3XB/p7nxI0prt/mjspS/hypiOoAXN6dNhavfHWv+FY4bM?=
	=?iso-8859-15?Q?X/g1EuX+YszIAhv023RAbX06kWhbcDSzGPTKYQpluJ5fVry0qve8IpMvv?=
	=?iso-8859-15?Q?7t4BvoQhsdNY1vYc49dROb3pmqC+7BCjDOo1WunSeWDu4DrHn3qK7n+Ep?=
	=?iso-8859-15?Q?MYJg8dnYAAB0b9fDaOgdCFlMBKjZ9P7qwBpJWLQ8foYJs+438EFaxzx8j?=
	=?iso-8859-15?Q?V1tfc55wcKSoLRbKgFtXxA0zhC9xof78OHiUpuRFMTDgR6PmtOZ58gbvw?=
	=?iso-8859-15?Q?h8q1aBlVaQ7GMLqSyVySeEH1h07yGNoS6deKoel77HKL9ESHVyS4ajf0n?=
	=?iso-8859-15?Q?BoznOPjkWR4C9wBItqin1LkQ0UH72bWTFrFyC9d24ewBbQHy9CMBeHn3B?=
	=?iso-8859-15?Q?r0LbEq3ztArqCdDz433ERlIi+Fncu1/E7GVW7dDqOf4GjScvcku7zwXlM?=
	=?iso-8859-15?Q?Tn5AsOL2VzM2kDuNpK7hCBgiutbyZqZCVgRc4rMaV+ThGhWcw0imfkkL0?=
	=?iso-8859-15?Q?r8Oi0jnlzrOBOFZD2PfxAfqYWhsbwjqg6fHB5QZlXTHlZb0W4iMyECGp+?=
	=?iso-8859-15?Q?xMwq2ZaBh2E/l/62VymNHOCBo/qmUz5C642ZeNcT6gfqCKUrg024o46MV?=
	=?iso-8859-15?Q?cyBpwxNc3ramPQhOriaFBkpR5BmZ22q0HS6jWCQz8+t7V6yimbygha7Tz?=
	=?iso-8859-15?Q?8d80ywmgXzuuthg0F2XRcXp/NEdTz2aIvlFQQ1DhyVOluieLsaT2tgdmP?=
	=?iso-8859-15?Q?/LoTOnbTkLxnV73yHdu1c0PQOUnoRsFU3jvk6Q7AufvMkgBuY5nCnA5Ay?=
	=?iso-8859-15?Q?iWh+fQNlhuuuGM6Fm0VZqw2blGYE2GcOAzJtHbfwJXYBRlj2cPuET1Sfn?=
	=?iso-8859-15?Q?x2Rgk3k8iYlOSWy3KRJZsdTnAmhp5/gAQX18GSZW2r58bylibEdkcuZaD?=
	=?iso-8859-15?Q?Uw1rH8i6EImkyJk8b3stmGiuvZnj6Fhn3?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dee4873-2025-49b0-c69e-08d8d4c38f74
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2021 10:46:06.2242 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 32cr4bJ8hcLdZE66AlW/LLJSHlyvgZ8mta+qNgYwPtMAHccJeTGapVd8ilPpC1MncDW1VEsqrfPB0GP+IIlCng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8026
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11JAkEIS000893
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
Content-ID: <DA9DD3DCAE0C7549BE08FCA8BD1B91DF@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-02-18 at 11:22 +0800, Chongyun Wu wrote:
> >=20
> > I wasn't aware of multiple affected users. I saw Chongyun's post
> > and it
> > looked to me as if this had happend once, likely in his
> > organization.
> > It wasn't even clear to me whether production data were affected.
> >=20
> Had customers have made incorrect storage back-end operations during
> the=20
> expansion process, which has caused the destruction of customer data,
> which=20
> cannot be repaired using any tools. And I reproduce it in our lab
> too.
> Customers definitely hope that multipath-tools can probide protection
> in
> this case, becuase if it is important custmer data storage in the
> LUN, the
> loss will be great.

I understand that. My concern was that it's still just quite a weak
protection, because it depends on the check time interval being short
enough to catch the change. So in a way, this pretends to offer safety
that doesn't truly exist.=A0If the user assigns the wrong WWID 30s after
taking the LUN offline, all fine; if she is quicker (or has the process
automated / scripted), data corruption still occurs.

And of course, there are general limits to which extent software can
avoid user mistakes.

However, I trust your and Ben's judegement that by checking this in a
suitably short time span, the issues your customers have had would have
been avoided, and I'm not going to oppose the patch on these grounds.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

