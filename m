Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781F7C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 22:40:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B86A820825
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 22:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B86A820825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-DNt_zdMaNMWbXf3u7AbfZQ-1; Wed, 04 Nov 2020 17:39:58 -0500
X-MC-Unique: DNt_zdMaNMWbXf3u7AbfZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4E158049CB;
	Wed,  4 Nov 2020 22:39:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32D1A10013C4;
	Wed,  4 Nov 2020 22:39:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B412A1833001;
	Wed,  4 Nov 2020 22:39:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4MdmRK012159 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 17:39:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1942D2157F25; Wed,  4 Nov 2020 22:39:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 134222157F23
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 22:39:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD2F0185A790
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 22:39:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-332-hQ4IPLrPPRa5v2v-lGxJgg-1;
	Wed, 04 Nov 2020 17:39:43 -0500
X-MC-Unique: hQ4IPLrPPRa5v2v-lGxJgg-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-8-BZrmAQTJOZ-vKiY34y0ZsQ-1; Wed, 04 Nov 2020 23:39:41 +0100
X-MC-Unique: BZrmAQTJOZ-vKiY34y0ZsQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18;
	Wed, 4 Nov 2020 22:39:39 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.032;
	Wed, 4 Nov 2020 22:39:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
	DSO
Thread-Index: AQHWqYGhMjFC8lt10kOGjZ1zvJEYX6mwsJ0AgASH7oCAA2sxgA==
Date: Wed, 4 Nov 2020 22:39:39 +0000
Message-ID: <589710d08d286f358a97044834550b7f9db47e67.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
	<095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
	<20201102182711.GP3384@octiron.msp.redhat.com>
In-Reply-To: <20201102182711.GP3384@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [88.73.133.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43f6b749-7805-403f-8450-08d8811283ec
x-ms-traffictypediagnostic: DBBPR04MB7658:
x-microsoft-antispam-prvs: <DBBPR04MB76586235FD2351871F806238FCEF0@DBBPR04MB7658.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: W4aw3cKXn8E6/WuBjcrMY+qPQL2irkLxNFhfWJepk01VDfzDnwPlLpUUI5HymINraPfKx5yVS8nHx0UfPHU7d//eazGrfLkljqJ5SF524JDQKbrdpMiJ+Q4Ycy80mYTAeF8za7T1tNWfrhB0+Qd1HtkeDpJeasiibvLR78hcZGWzYWsQV/q8zTSVdUVjXxBIHAdozTJLWanE7ybIMqaBKzaxhhuGjqZZEXQ4aDP3QYUOEnWxjW0x1cKHS6xkNueuCjWMTYk16f0g1cp3t5XP1JS0WuMtxG75WQuAE6ndlV6RUVcFMzqa6CH1M4ErXJE8+IRq8hPdYSXJgKieXN+J/g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(346002)(136003)(396003)(39840400004)(366004)(36756003)(4326008)(4001150100001)(450100002)(316002)(44832011)(186003)(86362001)(2906002)(478600001)(71200400001)(83380400001)(6486002)(6916009)(2616005)(5660300002)(6512007)(26005)(6506007)(91956017)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(8676002)(8936002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: EFR6B5ZEJdjadMnIuoIV9QAcdb3e7fOiViYIWKATn1gRVHfxbp1tsCyc7loodyyESsg7Ggee6yR+nhUXB1o8R2ukrigbGiUJpPmbFElPmXOabOCvts4+lIqvUS9Sz10wI1GJNSUBVsegYsYctKBw5s4O5pEbS2tDkkt/OZqDh97Nr20/2ZFWZ0aW7N8jK6OqJQedzYoRJMjwiXjrpjcVTOqTKn8auTDqAEfhuFlhcUoRzFktjYV+tBrzaA34oPXL2ep4Ma67YdrKmC22hmEnhK358XcLCMetNSTskajWtzWIdiB47gqz6DlN0Gjn3f/LHjFEC3QBOLVq8i/PvoQNLi0jtboQo9/kUIl9743ilsTBLErbVGfvKo6FBsxScvQxqCi+ag9iUUThJJ/xVbpdXVgPMvvxkkkyhVYz4j7TR2SU68wlnV2bcjcY6nIc9NUIfz8svP26BzzJxRrVqF85duAspKJO6d7qeG1Zy2hAzhQ3o6s3V7ZWpPJuwwZBNxyWmooIi4QoSZcTm/Yg362i7YXsM6uRm9IFGoBcN353U2YXxeCnepBHjKnC+5A/lWdzrpPVzN6Dr4nLjqpivp/e9Oh5b7ZR98lZsQ6guFv87lNF0pkWZZMvr4mSZCsm+dPEUIbEf8A/euceX+srmqZxEA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f6b749-7805-403f-8450-08d8811283ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 22:39:39.4326 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HApcyRVG+CdZE/jqcyIh5ln0vM4aKDi2SrgKdL3jg7QMpSUCHbyyreyO2Gul8J/x4pfP2omAaP3AnAZX/jKYVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A4MdmRK012159
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
 DSO
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CAE0C93D8044CD42A8587BD0AB938F03@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-02 at 12:27 -0600, Benjamin Marzinski wrote:
> On Fri, Oct 30, 2020 at 09:15:39PM +0000, Martin Wilck wrote:
> > On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > > The multipathd tur checker thread is designed to be able to
> > > finish at
> > > any time, even after the tur checker itself has been freed. The
> > > multipathd shutdown code makes sure all the checkers have been
> > > freed
> > > before freeing the checker_class and calling dlclose() to unload
> > > the
> > > DSO, but this doesn't guarantee that the checker threads have
> > > finished.
> > > If one hasn't, the DSO will get unloaded while the thread still
> > > running
> > > code from it, causing a segfault. Unfortunately, it's not
> > > possible to
> > > be
> > > sure that all tur checker threads have ended during shutdown,
> > > without
> > > making them joinable.
> > >=20
> > > However, since libmultipath will never be reinitialized after it
> > > has
> > > been uninitialzed, not dlclosing the tur checker DSO once a
> > > thread is
> > > started has minimal cost (keeping the DSO code around until the
> > > program
> > > exits, which usually happens right after freeing the checkers).
> >=20
> > I'm not against this, but have you considered using an
> > atomic  refcount
> > for the DSO? With every tur thread starting, we could increase it,
> > and
> > decrease it in the cleanup function of the thread when it exits.
> > That
> > should be safe. If the refcount was positive when we exit, we could
> > refrain from unloading the DSO.
>=20
> I tried exactly that, and I would still get crashes, even if it put
> the
> code that decrements the atomic variable in a function that's not
> part
> of the DSO, and put a pthread_exit() before the final
> pthread_cleanup_pop() that would decrement it in tur_thread, so that
> after the cleanup code is called the thread should never return to
> code
> that is in the DSO. I had to add sleeps in code to force various
> orderings, but I couldn't find any way that worked for all possible
> orderings.  I would love it if this worked, and you're free to try,
> but
> I could not get this method to work.

I've experimented a bit with a trivial test program, and I found that
it worked stably if decrementing the refcount is really the last thing
thread's cleanup function does. Could you provide some details about
the sleeps that you'd put in that made this approach fail?

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

