Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086FBC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 11:03:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-qzjdTIdBPoOVer4o4bi2sg-1; Wed, 13 Apr 2022 07:03:11 -0400
X-MC-Unique: qzjdTIdBPoOVer4o4bi2sg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 212113841D22;
	Wed, 13 Apr 2022 11:03:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25D30403178;
	Wed, 13 Apr 2022 11:03:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC4821940373;
	Wed, 13 Apr 2022 11:03:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BEE241940340
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 11:03:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 934CA145BA5B; Wed, 13 Apr 2022 11:03:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E315145BA59
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 11:03:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37060101AA42
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 11:03:06 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-AESxvLW9Py-GPbkhudcFbw-1; Wed, 13 Apr 2022 07:03:04 -0400
X-MC-Unique: AESxvLW9Py-GPbkhudcFbw-1
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-D0Dao7noNLSmh3q0wqGGpQ-1; Wed, 13 Apr 2022 13:03:02 +0200
X-MC-Unique: D0Dao7noNLSmh3q0wqGGpQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM6PR04MB4630.eurprd04.prod.outlook.com (2603:10a6:20b:17::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 11:03:00 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 11:03:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 0/9] Add protocol specific config subsection
Thread-Index: AQHYThEKdbrAhr5xHE2kaVKyN3MnN6zsn24CgAA2MEOAANpSgA==
Date: Wed, 13 Apr 2022 11:03:00 +0000
Message-ID: <e514db74f56c6ebb71dc18094afbccefd893cb99.camel@suse.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
 <20220412184728.GF24684@octiron.msp.redhat.com>
 <92f53b4d9679a2d958643fe3cc72a09bda4c73fb.camel@suse.com>
 <20220412220125.GH24684@octiron.msp.redhat.com>
In-Reply-To: <20220412220125.GH24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9166c528-6809-4ca6-42b5-08da1d3d2c88
x-ms-traffictypediagnostic: AM6PR04MB4630:EE_
x-microsoft-antispam-prvs: <AM6PR04MB46308298072D6CA8585300BDFCEC9@AM6PR04MB4630.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MvbB62ywIm+AcLXjMC2Chjps/tj1w94Di0ymR1w4CjDCTSqPMzv1VF8VpOfvG0Fr0P+LVLC4pY64XGzjFQbja63xCrkGyV8VDPxjAaJzb+5NMEPatueMNbdwpdKcm3p40LCFztrefkZHYB9OGGtf+JJWHe3IvRVibW2wYnRDR2gylOT23cVht0rQrJ63JCVQohwmRKS7Mp4TAoTTcucYUpb4YqPomxGiU4l3j6yQfRWNOOjGD6HAoKuvOQi5rei+9LptCkhEZ7SUDQrCuQ1mR1tyljhtf7a9I/qYK304CSiOSFIjCrGyHj21CVjXeQtjakHteWZzELmK5karAjfrVlhIn5yZCnVm5l0fsbG+5REqGMnEPoTf3ZopgIHXRuXWN6vQBRomInaiyLxZmiIaV1a1YKKssqKlZzg+hjW7Vt5Kj08m/FJF3pr817qgBZqm78AsmoNzq+nbrtiSscf9ee5Yz1zu1kuOyrsZhlVEbF6FG8i/Zj9CUv9BYFKB6RLgXeaetz60KvxwoSqgLe6wdq3fz5kA1IapBUiYS2UgGaYMJGWb2+SuSSyxWiPlz1m4Sj52RQkCJQjM/x4x13Q5OIhVoGTLqwjF58slYOX8ujn9oddD9UcR+HovoVHyr7mTkoTis3W58lNpiU8WOSM6xakbqSiHcyqKgDW+N8jM0nemWw3uKiEIoZOB8ppbJ0Aacc3+WEZ9+SRTIeOsIpg/9g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66446008)(66556008)(38070700005)(2906002)(38100700002)(66476007)(66946007)(91956017)(76116006)(86362001)(186003)(26005)(2616005)(71200400001)(6506007)(6512007)(64756008)(8676002)(44832011)(5660300002)(8936002)(4326008)(122000001)(508600001)(6916009)(54906003)(316002)(6486002)(36756003)(83380400001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?B8ggrZcgefh4Gnu4Midl6+k9xSudVABPRGRw7GDJ3mA8spTcDP4eKBtUK?=
 =?iso-8859-15?Q?1h3XALR6waXhv7USl+0TGb5G5bOIjiGOSJQIkRIxYwSYZ5hRoV3vpTqAo?=
 =?iso-8859-15?Q?9ZYOIaYKSk5YAnqyooPOwYm23zAZO3H55UGSuAk50hPSkWVlqg3i2HteF?=
 =?iso-8859-15?Q?aoI0mh9pkmPeSqfGoUFgUO3x4jW0ZHDgmVvxlRVQYShuJrHU8zfvbeKwJ?=
 =?iso-8859-15?Q?JMib4LPWmFGKBhyhzlEJC62YOeQbRhJiYOUuxk4aofFUaIcCaqQbCKH0E?=
 =?iso-8859-15?Q?MNzUmkxohyEwiOzavNFKg+VSHBkMmaIwb6D7y5dQQCfIIubTenIgzCG6x?=
 =?iso-8859-15?Q?ST2Kb7xazvVI7hJsLoemJnONVHKw4WNTIdS3s0XHBjdAtkRBGT7yP8jTw?=
 =?iso-8859-15?Q?415Ba4jIXkXRspPKiall8NqZlii9YY1DedFaRkJktbNOJM6ruZkiQeYTp?=
 =?iso-8859-15?Q?tcYQLbJIUka4/gS4i0bIffIbaiP4U+SjfKdRVXLL7mzHupOie1vqbCcYh?=
 =?iso-8859-15?Q?k3b3xltlkPwcUouEYxV4mxhqIp8nAShukbQRDLkZWuWfogjG73v8JiCul?=
 =?iso-8859-15?Q?ON97XkvbiSEVpu6kzcgr2W3/a5Wr6znCdsOfSs8qRUMbVvQNAmzn/oSCZ?=
 =?iso-8859-15?Q?8VVLv5rhfi291wQpHCEz6rHYqee+963seR9FAco7HtgkODbkriEE0jHEm?=
 =?iso-8859-15?Q?LyV1GPxEk9UF63G1ji8sPn634cVRufevJ4eGz7JvONNRXHT51BLQz9uLC?=
 =?iso-8859-15?Q?sIKYm1VDuuJQ9AVBeW8z5Pbk7ks3Htp2pn7N38REYi1r4Viy9kEbrnevz?=
 =?iso-8859-15?Q?JufWSONs3k9uZ3wxPc8YzY1K+GILJ14cIEG8CHRtTr0I3BhTdAS8KC4Yo?=
 =?iso-8859-15?Q?WplTks6MOtqT2s4tbW/kRvNYoTs01f5TeXNL4B9sqvC7kbbfO54G0bX/I?=
 =?iso-8859-15?Q?WZHVVPh/b4XolYiWGsEAbmbTO2PLJk72x7q+WhufXVvo3seCq8d0CpA/c?=
 =?iso-8859-15?Q?P+7z8TWYtt9W8yNd9f0MQQBO0uNyUucUJ9P6PxAMFhUVUbvpzxstS1At1?=
 =?iso-8859-15?Q?40/cxJw3Lnv6XChwtpaacbse5Zd0gwLvjwD8urozntrUfwsRqMZXGAk/k?=
 =?iso-8859-15?Q?V9epJt+Lhjc5ClKN7sar2Bv8U76wysug3odaKKfSpNUJ69zDZQL6+fkbG?=
 =?iso-8859-15?Q?ngNBJzRfM2hHLqOn31NdFdGuQDeC7Obcif1TmXMOiML+BHCA7/qBNGNTk?=
 =?iso-8859-15?Q?HxTeA+z/W58qB0cwO0nm1YjpxWanB1rcXZuYlXvM8d5VgMZiXzjTLb8/m?=
 =?iso-8859-15?Q?oHizNzJVKiXVxDosKeZ33hqdT0bs0ssqMaha5bUd+1F/2SXHjjzilrrnj?=
 =?iso-8859-15?Q?6pOS0UMiCMPmOTcZYU5hxRNWha8lNExNHxjWqUnhBc3Deo9Yo7k/DgnB3?=
 =?iso-8859-15?Q?PcPYv7sr17EUlSBOPnrMZi28u/xOX1nIdvlrFaYY0Z5Apd6Je8Ev4IXKE?=
 =?iso-8859-15?Q?vLcgXOwG7yt1bTjxfoHe8qo3ZdXjGOvzwr5bKr+bnggb2kosBQF3WNH6x?=
 =?iso-8859-15?Q?SucyFzn/H1WOsOB3xyndzO0prAfptP3sKOGV3+QA1VwsN+U1lcRFvvDX+?=
 =?iso-8859-15?Q?cwWqFvAgVs1mUxVB9irlCJm4HtqfyJuHEf/H0TlIRJ5OFiU52gZl/4/Rk?=
 =?iso-8859-15?Q?GNFBdHhapUgzWqZs5l2YskjUNDT/7X9pBCwDuR8h5PI1BXDyhn8DojRxP?=
 =?iso-8859-15?Q?JKgzSsnPGYo8XK80lijwlN8yP6ZAB7EI4DOOaDyxdTzj+2DDgOUg6oyPz?=
 =?iso-8859-15?Q?NbW1ivxVHZrgquqXBAcGPCUxd3TFNODb2oAoAPbhPkiIV1Ajyf+Ikg4pE?=
 =?iso-8859-15?Q?vtFQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9166c528-6809-4ca6-42b5-08da1d3d2c88
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 11:03:00.2590 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BIW5yCmFi4bZOo5tMxr7Q9SRQOgAlbg8NbGTo1WjCZJjHvfEnZFauKEu9hbONF5pNdhHznGigo3Ku59CGJPLkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4630
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 0/9] Add protocol specific config subsection
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DDEE1AE09A396045A816B5AA5F5A7E99@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-04-12 at 17:01 -0500, Benjamin Marzinski wrote:
> On Tue, Apr 12, 2022 at 08:47:38PM +0000, Martin Wilck wrote:
> >=20
> > To clarify once more: this is what I meant, built-in configs would
> > be
> > overridden, user configs wouldn't be. This is different from
> > "defaults", as "defaults" don't override hardware-specific built-
> > ins.
>=20
> But what do you call a device config that is the result of merging
> (via
> merge_hwe()) a built-in and a non-built-in config.=A0 Do we really want
> to
> track that some of the values of this merged config need to check the
> protocol section, and some don't? We could remove merging identical
> configs, but that simply makes it harder for users to figure out how
> their device will be configured from the configuration output.

Yes, I figured this might be tricky. My vague idea was to track the
origin with sort of a bit field inside the hwe's. Never mind now.

> I understand your idea. I'd just rather that it worked on all the
> device
> configs, instead of only the built-in ones. I think overriding only
> the
> built-in configs is needlessly complicated, both from a coding and
> from
> an explaining point of view.

I think that users are able to distinguish between built-in defaults
and settings they made explicitly. Being able to differentiate between
these in the "origin" log messages would also have a certain value.

But I said to you not to over-complicate matters, so I suppose I
shouldn't do that, either. If you think just using "overrides" is
sufficient, I'm fine with that.

> > > The biggest reason is that some of the builtin device configs do
> > > things
> > > like set no_path_retry to "queue".=A0
> >=20
> > You don't need to use "overrides" for that:
> >=20
> > devices {
> > =A0=A0=A0=A0=A0=A0=A0 device {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vendor .*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 product .*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no_path_retry 75
> > =A0=A0=A0=A0=A0=A0=A0 }
> > }
> > You can follow up with more device entries that define exceptions
> > for
> > the general rule above. Am I missing something?
> >=20
> > AFAICT the only thing you can do with "overrides" but not with the
> > trick above is override actual hardware-specific user configs, and
> > I
> > have a hard time figuring out why someone would work out detailed
> > device-specific configs just to override them again with a big
> > hammer.
>=20
> Fair enough. I added the overrides section before you made paths have
> a
> vector of device configs. Back then, there was no way to have a
> device
> config that would work like your above example.=A0 My original idea was
> to
> be able to have a special device section like this:
>=20

Right. Didn't think about that.

> device {
> =A0=A0=A0=A0=A0=A0=A0 all_devs yes
> =A0=A0=A0=A0=A0=A0=A0=A0no_path_retry 75
> }
>=20
> that would get merged with all the device sections. The overrides
> section was the compromise after my original idea was NAKed. We
> probably
> could deprecate the overrides section now that we have a vector of
> device configs. But then we shouldn't go putting the protocol stuff
> there.=20

Well I guess as we have had the section for decades, we might as well
just leave it in. Sorry for distracting you with my rant.

Still to be determined whether "protocol" should simply go into
"overrides", or into a separate section (with the precedence semantics
you consider appropriate). I fine with either, so I guess it'll be
"overrides".

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

