Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3732AC43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:48:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-hCO7rwYTNaukhRxYsCqt-g-1; Wed, 08 Jun 2022 12:48:53 -0400
X-MC-Unique: hCO7rwYTNaukhRxYsCqt-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAC80833A21;
	Wed,  8 Jun 2022 16:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B31D09D7F;
	Wed,  8 Jun 2022 16:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45844194704A;
	Wed,  8 Jun 2022 16:48:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6EFC91947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 16:48:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44F881415102; Wed,  8 Jun 2022 16:48:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FB411415100
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 16:48:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 212AF101A54E
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 16:48:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-SaraI1b_M-acAV86G39iWg-1; Wed, 08 Jun 2022 12:48:47 -0400
X-MC-Unique: SaraI1b_M-acAV86G39iWg-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-Xo-Y4q9MN7at535iOJ5qqQ-1; Wed, 08 Jun 2022 18:48:44 +0200
X-MC-Unique: Xo-Y4q9MN7at535iOJ5qqQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by PAXPR04MB8222.eurprd04.prod.outlook.com (2603:10a6:102:1bd::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 16:48:43 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::80f9:38c4:1d69:7886]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::80f9:38c4:1d69:7886%6]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 16:48:43 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: unset detect_checker for clariion / Unity
 arrays
Thread-Index: AQHYesBA6PR50V8MFEqY2TtKCigfDK1FubcA
Date: Wed, 8 Jun 2022 16:48:42 +0000
Message-ID: <4a77132aa99cc9a6ffe53695b252b3897c3f10f7.camel@suse.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fffa5b79-fd9a-4683-4edc-08da496ebf41
x-ms-traffictypediagnostic: PAXPR04MB8222:EE_
x-microsoft-antispam-prvs: <PAXPR04MB822211CBF5F4516553994905FCA49@PAXPR04MB8222.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 63Po5CJrJhIqyQ0g91DV9Tn+pCXROzqI/AEoJPHD6UZEqEyToiDcSQKqsk0zdRSUicOWdP+yH8gwQf4KCeizoh4O4EvJlnM1ZW5u/qfdZ4gkcVETLrPck5IzfFXCdWq9gWFHK52IAy/y6D8mrCtvKYIdjOJB8W5a2ruitZNm5ojATo+K5gv5ScdMKyROkNveo+6kdyw6Doj8D9dOnukaG4s/IaD2ZtQOXIaZNASXm1AWNBxrcdQn9DHL8vz9hcUqugLDm726NPmi/ZMRHY57WA2DFn59+lMaWRQXxnhkQdDgi//uDtPdOyQMBMPCcvy35J5voyh7X3wWsVmZOPPDoos0Z367LXoU1KzM9Az52gH7JRAtl4pLjxRCJCKiLa6rzDIF9AMBaWr76nePp6JVxvfQkln9YbkxyHz2mHiXb8UKLFOrw4Z3TErbMpNrZiLBfUbb9sYMf9CiyUYolzBqWIh8HI27u7CwnOj7OEQne+3H/JW5w8l2C5KgGExntfWUpw51N6CfiEQd9R6ufRnp8LODtr2RF6W6lUjQT0g5Jp3uZvNL0vySZwosehfl3dBOq+yrb3SLJLn8vFBUTd+3W2065gUSKqycQAXcltMyVSB2YAlHKvqlTTnOqcucd7PFEtZgSjS8sG1Xg5HbJguJfMFdqN+wvBxxToiLGGEPJ9XJeeZwQ/Wn1lPM+tld98BTypSVn0jDNSYlHPRhzGUWOQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6512007)(26005)(71200400001)(83380400001)(38070700005)(2616005)(5660300002)(8936002)(66476007)(44832011)(508600001)(6486002)(4744005)(6506007)(86362001)(66946007)(66556008)(76116006)(66446008)(4326008)(64756008)(186003)(8676002)(2906002)(36756003)(91956017)(54906003)(110136005)(38100700002)(316002)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?haZoMgGWAHFQXSmmnyc+Z80C+VCIFs0YQmjfCkDw0D0B5Kc98E2JAJZwO?=
 =?iso-8859-15?Q?6IiSy3PckIFdFMU3Yk+2zwKv3vuJcSo31+rJYyxPblfh0usPuik5woDOL?=
 =?iso-8859-15?Q?tM+v/gWkREvG8IuW2cxfAIp2hBcNg2eCnAIoShpHAaZa8STXscCjZ+l2V?=
 =?iso-8859-15?Q?CVbSwLjhVg5S1/cDcvoTXmv3D1wRixWWCrUNoG80/ZJ4Ix1qMqsz375hl?=
 =?iso-8859-15?Q?al4Hp1if/JnvC8XUAYDl+4vzVc/8mQW5/uLC8D4GakBZjPB7dqF8Tl+pG?=
 =?iso-8859-15?Q?0vg19hPBd3TTbZZDhpl3oV6CRdd07nwlG90OBoLhHIvfOjxMAQw9ZVWJi?=
 =?iso-8859-15?Q?w/czf3fsHuMDjKgYBNHrn7hNfEfXCXtkpe8z5ajz5ya98OhoBwhJ5NxJw?=
 =?iso-8859-15?Q?4Krb9Y64ZmNAglZuZk5mG422UDGdrBgLRFAxrER8/Bkd7L2v9lW/tX3gI?=
 =?iso-8859-15?Q?6YpVxMvqZx6hPJiH0bvnCoDzXAfhq2pePWznRfmtNAkLt6tKv2/nBkiUb?=
 =?iso-8859-15?Q?njzJV7Ax9TfgVTg4binSVXvYvQVSQX/imzljtTabc5nw9ob5QmKAtdE+A?=
 =?iso-8859-15?Q?niSaxmPr/BxXSACE5gyVLBHpqgRDLZB3//dpy8dBO5k46tQvw/VyrU7jQ?=
 =?iso-8859-15?Q?gyokWuYuLvKq8IhZ2vUdYiulPo3WEzX1o4NakfGIvqt9IU0l05n46399W?=
 =?iso-8859-15?Q?/q0mdOPvltBD4qxiWd3X+3wFuWLA2pIVAxJ1uWlPhGrP4QBnLh8vXj0ln?=
 =?iso-8859-15?Q?dtXx2WKav/Tl79EXE5hBPi9684EjqePK27UJD0O9/UJ6oKOCSTY/t+Fh1?=
 =?iso-8859-15?Q?lXSoFiRVu61YZXe0R14dsAVb+q3FNLOyR6INwdjR1aMdu5e4V28MoE+fO?=
 =?iso-8859-15?Q?PJ1rki+FHOOjSb5SkeaaTJIukt19a5eHLAgV2JsMS+VWNPvFj5N0+Ibpk?=
 =?iso-8859-15?Q?t/xonZlUjb65Xxqt+8aOMwQYHZyYjFMOjOdMGdhzjE1cyvo48caijzKZZ?=
 =?iso-8859-15?Q?5Km9p6QtceWx1C49CeTRSthchkJvG90xyhY7MMOCjCuvZUpYT2lrAZjkc?=
 =?iso-8859-15?Q?U9cqwYIm0c2SWiYQK/SCh0JLEovjMIZtgO2Z8gnLUsjpaHsbR2ZWd5yrh?=
 =?iso-8859-15?Q?f4HZc45pMfyLO84JBozhvVF3NWy/5bH4Gy4d3QgWpuhZMU20bPERArcXa?=
 =?iso-8859-15?Q?I9iiSYMVAo6x4K1Cwt9HBUMWtFddvya3RxVzYKILTo5pXcasrkvTB0LBh?=
 =?iso-8859-15?Q?6bwcJmcZLHb1ZvnkNnuyXouLhc83DJ2urqixeQe46Zt8ujn0YWVrouiT/?=
 =?iso-8859-15?Q?1UbiPcAp5E87CZMduF7e019HnBhzExMJjqj+TRbICsOiIRQPvKIXliQWC?=
 =?iso-8859-15?Q?AZNA1tcpQ/KNEkrTN72hp995Wi9AAAS2mBWRmi4zVljyluFkScv1Tyqzu?=
 =?iso-8859-15?Q?PbTEbbIPZKONq5N9v3MIb4KRqY95qZiqr6HNlY2xPXWr/uEtNaxKFqq3Z?=
 =?iso-8859-15?Q?FRINSHjmDysp8/Fv13MJ9itRs7NFQWAr8aauWhp3OhIFaJAtkqTBigVRO?=
 =?iso-8859-15?Q?YfeoEHoZIM+yPtXHFAFDqddt5GP3tH041rkKoC9mUG+BPXs08xiEJ1lfY?=
 =?iso-8859-15?Q?3+xZr7BmuTLdfUmdTQVX2A/xbMHr316aZgi8em4gGctZmQOWgnlEpzBse?=
 =?iso-8859-15?Q?zRqDHihMHJ1hjuhPcycSajKuhZXNnHCqDvWJzPEBeIL5yHuWkecF1nkta?=
 =?iso-8859-15?Q?vsYm8UN2C7s13fn5N/dJdFPyeOHYagOg0jQt/0Iroj4ES/qXFnGQ9vFiV?=
 =?iso-8859-15?Q?Z/AAHknrWxnKmWjMSIQG7J0fM9t2hRtD3V60uBkf3ef/GPUwxq4FI4NoZ?=
 =?iso-8859-15?Q?joWw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fffa5b79-fd9a-4683-4edc-08da496ebf41
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 16:48:42.9680 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nXZdHNs1gSWQV1bX7C3FWHyLrxmGYA80gnwVOABXRl0+AoEKGEiCdwDHrO5volLpHa+LDDS7ybe+5mOctvKiLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8222
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "vincent.chen1@dell.com" <vincent.chen1@dell.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3DDDC52D2129D14A93A3771F96820B97@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-06-07 at 17:45 -0500, Benjamin Marzinski wrote:
> Dell EMC would like to always use the emc_clariion checker. Currently
> detect_checker will switch the checker to TUR for Unity arrays.
> This can cause problems on some setups with replicated Unity LUNs,
> which are handled correctly the the emc_checker, but not the TUR
> checker.
>=20
> Cc: vincent.chen1@dell.com
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

(while we're discussing possible alternatives)

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/hwtable.c | 1 +
> =A01 file changed, 1 insertion(+)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 39daadc2..415bf683 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -350,6 +350,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D (300 /=
 DEFAULT_CHECKINT),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.checker_name=A0 =3D EMC_=
CLARIION,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =
=3D PRIO_EMC,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_checker =3D DETECT_=
CHECKER_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Invista / VPLEX */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

