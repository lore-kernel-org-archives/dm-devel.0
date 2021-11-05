Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCE1C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:17:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACC4761076
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:17:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ACC4761076
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-5D4qhkf6MDO-TZEwyoLkYQ-1; Fri, 05 Nov 2021 16:16:58 -0400
X-MC-Unique: 5D4qhkf6MDO-TZEwyoLkYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10D6310A8E01;
	Fri,  5 Nov 2021 20:16:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91DCF7944C;
	Fri,  5 Nov 2021 20:16:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 567AD1806D03;
	Fri,  5 Nov 2021 20:16:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5KGpf3020813 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 16:16:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 38AC2400DEF8; Fri,  5 Nov 2021 20:16:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 329204010E8A
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 20:16:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 129DA8007B1
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 20:16:51 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-183-Zrn5gET-Mf2OGWfvSSbRlg-1;
	Fri, 05 Nov 2021 16:16:48 -0400
X-MC-Unique: Zrn5gET-Mf2OGWfvSSbRlg-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-32-2hMdyA3-NSue15vS8Txa2A-1; Fri, 05 Nov 2021 21:16:46 +0100
X-MC-Unique: 2hMdyA3-NSue15vS8Txa2A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5067.eurprd04.prod.outlook.com (2603:10a6:10:1a::28) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18;
	Fri, 5 Nov 2021 20:16:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.013;
	Fri, 5 Nov 2021 20:16:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 8/8] libmultipath: cleanup invalid config handling
Thread-Index: AQHXuu1oU5QnbE7ggkq7MbG1lPGjJav0CzwAgAGBTwCAAAGzgA==
Date: Fri, 5 Nov 2021 20:16:44 +0000
Message-ID: <f20eb26f9f0ad2181ba38f047912f0c4490fb08f.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-9-git-send-email-bmarzins@redhat.com>
	<c93fc9dcca43a0f385b2c172266ab58cfbbb4767.camel@suse.com>
	<20211105201038.GL19591@octiron.msp.redhat.com>
In-Reply-To: <20211105201038.GL19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8195d7e9-f7fc-4abe-867a-08d9a0992ff7
x-ms-traffictypediagnostic: DB7PR04MB5067:
x-microsoft-antispam-prvs: <DB7PR04MB5067F0B1C74D98F1F6C402F1FC8E9@DB7PR04MB5067.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /yAOjPGiXquztm/eXXUpmCHwOo92ZjzVe0IjBvDfEcYh2Lo9XrqGZKslPpDcebkC8teG10hTi1IbG8h3S7U2pjiswGE8snpyNvDZug6qUWvaDT/sgiQexyyAkNBGUYNkHrvaRi4sQ3PkgkL8IlpsTHPSi1W4tK4Cu34hePtFDsYg4Jf8+stsIFfbOeed0tz4W0WOZnvnliPRDITb9EmxZ3jg+ftqJBUKoSoOwuIaKf1tEWZejG2AOF24EjjVN4egNLG6sGoOci99ElegsAh8igzhmS5uVMZ80gHKsar6kFclSDpi/aRf/jklxrzso+JvwTllSMT2Cw1EdvaEAAaea4RHkrBFOAJ+G/t3mGmMKfn9vbB8XLj7MCANX+gGxP/4UGCt3qhW5qwPBC3Ybbp95f09Fre38QxXKNb+d375bgKoTfTAkIXyk0/elB8mr/8pKNyMC2YindCNYCs5CWdYFGJXG44xn9XAX7YqxpN/CYmgKkZd0qvKVo1q1FXQ2hTYTB6TAo2Zy3z1tKWDJe2NV0xvZuBc7ZndEJz4YuGdh2Jyih6bD6g2xYZmIF9fVy70bvFvm6HS1WqhTt203rmG18aNHJfY6IER+4303oZg1yZ7aqcQcYTo24GqfOU0slO+b5p/Ho9SP5Dtz/yX3iSZaVN7rdiFksqKccZhXdeukUR1IPWzs+P8m7K2Ye0pIkHnARs76GHeiL8j5e8Eid0rnQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(54906003)(2906002)(316002)(26005)(4326008)(6916009)(66476007)(6506007)(186003)(76116006)(66556008)(91956017)(66446008)(8936002)(6512007)(86362001)(122000001)(38100700002)(6486002)(83380400001)(66946007)(64756008)(44832011)(36756003)(5660300002)(71200400001)(2616005)(38070700005)(8676002)(508600001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?dI3wkk7kjDZbkQviOr1v2XPYml+2th546jeZyWVd/hZvMDbQrP+FYds7A?=
	=?iso-8859-15?Q?06yt0GRFKb3mQ107lPYyBuxm57bkRYmcfhIYNdxVGOpYjBhZjJMtCPDX0?=
	=?iso-8859-15?Q?iQJ/OcCxFubYmzOV7OLvxV9CMOWi/6w3jqb2uq4Z+UZDKxg8SVsVQumhw?=
	=?iso-8859-15?Q?rCY9pBarkd665ZyjpIflppO7V2sZSqcKEdFt9z/344eXyiO1apauPlBNi?=
	=?iso-8859-15?Q?k0NMOJ+NowgJkVBK8bxlhYuVn2iz8iLaV9u4bE2tnJQwj6YwfwewSH2JI?=
	=?iso-8859-15?Q?VN1StAbQZ5ApjO0EbYPUg6la+3xHmv/NMg5ajG5oBPRQ2AMn1Ot2549s3?=
	=?iso-8859-15?Q?Od0H+iFaJ95Pg2qCsEdQ4s63bJdex5OdWeAGZqd1Jz129SIR5L3qkpI2U?=
	=?iso-8859-15?Q?YHAu9ehofj8uPM0cWhZEyOTC9mJL8iB57WNGjuHwuGyMZRIF52qcQSKD1?=
	=?iso-8859-15?Q?Bf/Jb/2SGaa/uB3x3MqiwOIV04sWhXJOHm1Xf6eUtAz0TrWC5OEXHTTAu?=
	=?iso-8859-15?Q?YxiUJDifPoA7GZosoLRfnuieivTSAafTl+D1ChGv09DyA+CmiVE2UGH1g?=
	=?iso-8859-15?Q?ST3PeaoLX6UZr3pwuP/zXVn2PUjGshbCHilh1tRQSCSNOoBjjLep82mn0?=
	=?iso-8859-15?Q?VHLHXnjioRraG5QngM5zB33l4VYhAkgjXkNPrtWY8zxydW7D/bMMImPNW?=
	=?iso-8859-15?Q?vVQn7Z4viJaTUaqw1jPncyOEdWZP7kEWxbTKWBE7In3zS6VvFZxsOiaHz?=
	=?iso-8859-15?Q?v3m/G7HBUZ0ClrXmUqZgo9l4RtLBxEkCpBTE0hYeqj/P5HkiecQDmOxOq?=
	=?iso-8859-15?Q?AFtDv58DMqaqvBV5DOSgeJHihefpi/UviDA8HCWBBALMX9wfabmf+GPQ7?=
	=?iso-8859-15?Q?MvS6iNUOfzMPHeIbDLhIqDLDcvo3IgAU9DMWHVS191r/hNElyltQ5IaSu?=
	=?iso-8859-15?Q?2lTxX+q5SAhjmTfM3DJUwBgoLKKyVKR0G2UWGdL1/oUovSPFebMs578bb?=
	=?iso-8859-15?Q?PNytDvezY1geYLaZE/nBtpkgsZ5oLDQAW+tBrOPd2WnEUHmtVhYTvMqLi?=
	=?iso-8859-15?Q?P+t5FI2Byi8v3FaEZwbBXyyBSIflTsKIROcN1dsy/43MOShvsQCrDiGMg?=
	=?iso-8859-15?Q?54GNKdV9mpaFhEqPzyft591sWqQ5QqoSLgUj9UA5PwCBE5sFr3pwdMwGV?=
	=?iso-8859-15?Q?b+YF9rsEnKt+Ko54pCl9kfzQYlAMOyZ7DX+fSdYaWWJCh5NJIVQw8TRuV?=
	=?iso-8859-15?Q?0BDEavFNHouQ8uKbWNJKszLlmDxUq5DsCmyqRRuL+8feQHn0cjRFc5jkc?=
	=?iso-8859-15?Q?Vhm88NmHqfOoX4AxpCKvBe8y6iBO30RJPvF7nAV7vrH89wcMbuWt8YINa?=
	=?iso-8859-15?Q?pkXLtZlQkN4P5qCVTvEv2fZjO3TVUvfh3GupiUejbczdC46A5Ipj0Nsf6?=
	=?iso-8859-15?Q?akSH6ofMYGnuwfZ9tp8a9deaopfbkYIMxt9f2gRbrYYSxYSwZYN0tyLIq?=
	=?iso-8859-15?Q?NyNjcxvro/KlwMChWceIoJJBadoc/JG6EL2AKrL+4km8XrHbpI6tasVPJ?=
	=?iso-8859-15?Q?fikVe/A2/qMH8NxjqqfTYiZV53szSaww8DAPPNHBBWj7I84gZ2JrBJiO8?=
	=?iso-8859-15?Q?H2JdOjpczax84cViSjRRSGXEEC9EesYr59988kZ0u8l+H0g4kjhLbQgqs?=
	=?iso-8859-15?Q?xAvjLNWVPnj80f0GRgZcDlNEqtlJ89s/eGEMnepE6fN0g+A=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8195d7e9-f7fc-4abe-867a-08d9a0992ff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 20:16:44.3877 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L844hXujAlGymYLzb9cGLwQ6m8e+JJ1EpabvfH6bNoO5zgDTZC5NL9OBTLYS6gAmpO7Jf7btqwEws+alyCvjdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5067
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A5KGpf3020813
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 8/8] libmultipath: cleanup invalid config
	handling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A8A561576DC17744B387A34C1E981F80@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-11-05 at 15:10 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 04, 2021 at 09:11:34PM +0000, Martin Wilck wrote:
> > On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > > Add error reporting to the remaining config handlers. If the
> > > value is
> > > invalid, do not change the existing config option's value.
> >=20
> > Like for the previous patch, I'm unsure if this is wise. You rely
> > on a
> > reasonable default being set before the function is called. I
> > suppose
> > that's the case, but I like seeing the "invalid" value substituted
> > right there where the validity is checked. That saves us from
> > searching
> > the code for the default value.
> >=20
> > Maybe I overlooked an important rationale for not touching the
> > values
> > in the case of invalid input, please explain.
>=20
> Since these handlers are only called if people put the corresponding
> option in the config files, we had better have sensible defaults if
> they're not called (or if they don't set anything).
>=20
> I admit that I should take a look for cases were we cap an out-of-
> range
> value, to see if it would make more sense to treat it as an invalid
> value instead. Also, instead of accepting strings that are simply a
> number, we should convert the string, and the check the actual
> number.
> But I don't see any harm in simply ignoring the invalid values. It's
> no
> different than if the user didn't put the invalid line into
> multipath.conf
>=20
> Not setting the values on garbage input makes the handlers more
> general.
> If you have two options that work the same except that they have
> different defaults, then by not explicitly setting the value to the
> default when you have invalid input, one handler can be used for both
> options. set_yes_no() is a good example.=A0 Without my patch, it always
> set the value to something, even if the input was garbage. But the
> default value it set was "no". That had nothing to do with the
> default
> value of the options that were using it. You could do extra work to
> make
> sure that it would correctly use the option's default value, but you
> get
> the same outcome, with simpler code, just by not changing the default
> if
> you have a garbage value.
>=20
> Also, many of the handlers never set the value on invalid input. I'm
> just
> making that consistent across all of the handlers.

OK, you've convinced me.

Thanks
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

