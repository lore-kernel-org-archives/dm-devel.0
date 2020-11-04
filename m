Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251D5C2D0A3
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 00:01:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5B78E206F4
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 00:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B78E206F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-X0bNd7Z5O7uWIaTMvvgxTA-1; Wed, 04 Nov 2020 19:01:38 -0500
X-MC-Unique: X0bNd7Z5O7uWIaTMvvgxTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B1641074643;
	Thu,  5 Nov 2020 00:01:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F88C5576E;
	Thu,  5 Nov 2020 00:01:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 404A358136;
	Thu,  5 Nov 2020 00:01:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4NuGHl019439 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 18:56:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0E0A510F1CB5; Wed,  4 Nov 2020 23:56:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08D6710F1CB3
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 23:56:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9880A102F1E9
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 23:56:13 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-442-98abfpOSMOK-tM1wVPPhQQ-1;
	Wed, 04 Nov 2020 18:56:11 -0500
X-MC-Unique: 98abfpOSMOK-tM1wVPPhQQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-30-LTvzz30FNyOw2ckagxrY6w-1; Thu, 05 Nov 2020 00:56:09 +0100
X-MC-Unique: LTvzz30FNyOw2ckagxrY6w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4618.eurprd04.prod.outlook.com (2603:10a6:5:38::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28;
	Wed, 4 Nov 2020 23:56:07 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.032;
	Wed, 4 Nov 2020 23:56:07 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
	DSO
Thread-Index: AQHWqYGhMjFC8lt10kOGjZ1zvJEYX6mwsJ0AgASH7oCAA2sxgIAADVoAgAAIBQA=
Date: Wed, 4 Nov 2020 23:56:07 +0000
Message-ID: <ce13eccf5ea69648ae6c814a330201bf521a9212.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
	<095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
	<20201102182711.GP3384@octiron.msp.redhat.com>
	<589710d08d286f358a97044834550b7f9db47e67.camel@suse.com>
	<20201104232724.GE3384@octiron.msp.redhat.com>
In-Reply-To: <20201104232724.GE3384@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [88.73.133.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e51eb232-e222-487b-8f60-08d8811d3273
x-ms-traffictypediagnostic: DB7PR04MB4618:
x-microsoft-antispam-prvs: <DB7PR04MB4618CC57053ADD24A6F0DD66FCEF0@DB7PR04MB4618.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OfbhbB7z7HXSOeS6szxeozQUu3dBi7z4Yku3Mpv05M2POmA41xReBO8NLIejL1XbPC4zqtoP5lT2DAPp2o1R/dHolwBBIow063ThL5sziEEpaYBwlyLW1csHo1AtN4NooZM8s0b37pr64dKK6dX5iEaCyDw9j45VS1qEpnlDVU42pQY/3tpttollT81UDL0OpmNBKpeRY7LmynsHouVu0szQKmIJZ9giQQQ2l0oKVemGYFSsOgRW29699p/ca306MKcimzv9PPB1Zp1sT30JJj9CDnMQUWy2j+AkdI9Z5Vn77l35ve0YsKw5TRUqOzQSOUpZbSe2kwvkjvDsOC0uLw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(136003)(346002)(376002)(396003)(39850400004)(4001150100001)(6506007)(44832011)(6512007)(2616005)(186003)(6916009)(316002)(6486002)(478600001)(26005)(66574015)(8676002)(2906002)(5660300002)(83380400001)(71200400001)(66946007)(450100002)(4326008)(86362001)(66446008)(36756003)(66476007)(66556008)(64756008)(76116006)(8936002)(91956017);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: KMc7lkUnF2zCUt1LZ3XH3qJtkMEETDydIQgaDgBh1XBpzS08E96hpf+5diHV9qyQhhgiuaOM7FUWM+v08dy/xC3oqtalfQChAfcvinYrZd9ZiZbs88MCp7QohktBnMDyVK4YctSxVNcNNG8ycfZNs5K+pCfkxiIPNZi0uNXE18ZSKQALhBrWCQnRyC6xdDkQ00c20bG/wdh91dgxGOI906+/NjvnruMwc0+j0PNa9wG1Ef4DUA+DtJxa1csnak2es5NgZ8vXnNaVN/iEYIr1BCpRpTQTSc41Ftx+ryDX+4CvOXMRnZNK2ydb0D+wAeeFTlyd/6eeIjFGbsNZcyY5BOv+DGQkyO+vhLcg68lIxvJpI7gY1W++yCsKl+N4v7+YBERACXQQ2QJz5UvDEkOC+ly6xPammxGXRwNWPrtc3HnsYvVtLZ14/MCqg/YEs4I9/hAfDm9SNNDz8DlIMmlKgUaYBtCEvP/bJS5vrdduWYDljvUEVXBX4t1Q0yF+aiVFmh9FxeQATSgpJ82KxtVDO2MH3rp52vp61FbjM1NkVYMvOo6u4z0fGwWrz9BzoxCxNtjsqtI1NQUni00Nel0LBO3S0tjVotVMuY7gckPMOgCHTU3cAgtMr8mVYNpdkGbdjLuB2ftVy4bFRKGGGaVFiA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51eb232-e222-487b-8f60-08d8811d3273
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 23:56:07.2924 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v76p/qFl6W/1HwwzUko7SbsMQWGLMhtsdI69n8MX4YJwLAi8PnW3v9V0sxewmyX1O3jTEsGnKFV/kmIEB3uZIQ==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A4NuGHl019439
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <353683CB176328438055DA2FFBEB1B66@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-11-04 at 17:27 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 04, 2020 at 10:39:39PM +0000, Martin Wilck wrote:
> > On Mon, 2020-11-02 at 12:27 -0600, Benjamin Marzinski wrote:
> > > On Fri, Oct 30, 2020 at 09:15:39PM +0000, Martin Wilck wrote:
> > > > On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > > > > The multipathd tur checker thread is designed to be able to
> > > > > finish at
> > > > > any time, even after the tur checker itself has been freed.
> > > > > The
> > > > > multipathd shutdown code makes sure all the checkers have
> > > > > been
> > > > > freed
> > > > > before freeing the checker_class and calling dlclose() to
> > > > > unload
> > > > > the
> > > > > DSO, but this doesn't guarantee that the checker threads have
> > > > > finished.
> > > > > If one hasn't, the DSO will get unloaded while the thread
> > > > > still
> > > > > running
> > > > > code from it, causing a segfault. Unfortunately, it's not
> > > > > possible to
> > > > > be
> > > > > sure that all tur checker threads have ended during shutdown,
> > > > > without
> > > > > making them joinable.
> > > > >=20
> > > > > However, since libmultipath will never be reinitialized after
> > > > > it
> > > > > has
> > > > > been uninitialzed, not dlclosing the tur checker DSO once a
> > > > > thread is
> > > > > started has minimal cost (keeping the DSO code around until
> > > > > the
> > > > > program
> > > > > exits, which usually happens right after freeing the
> > > > > checkers).
> > > >=20
> > > > I'm not against this, but have you considered using an
> > > > atomic  refcount
> > > > for the DSO? With every tur thread starting, we could increase
> > > > it,
> > > > and
> > > > decrease it in the cleanup function of the thread when it
> > > > exits.
> > > > That
> > > > should be safe. If the refcount was positive when we exit, we
> > > > could
> > > > refrain from unloading the DSO.
> > >=20
> > > I tried exactly that, and I would still get crashes, even if it
> > > put
> > > the
> > > code that decrements the atomic variable in a function that's not
> > > part
> > > of the DSO, and put a pthread_exit() before the final
> > > pthread_cleanup_pop() that would decrement it in tur_thread, so
> > > that
> > > after the cleanup code is called the thread should never return
> > > to
> > > code
> > > that is in the DSO. I had to add sleeps in code to force various
> > > orderings, but I couldn't find any way that worked for all
> > > possible
> > > orderings.  I would love it if this worked, and you're free to
> > > try,
> > > but
> > > I could not get this method to work.
> >=20
> > I've experimented a bit with a trivial test program, and I found
> > that
> > it worked stably if decrementing the refcount is really the last
> > thing
> > thread's cleanup function does. Could you provide some details
> > about
> > the sleeps that you'd put in that made this approach fail?
>=20
> I believe the situation that continued to crash was where the
> tur_thread() exitted naturally (so it set running to 0), although I'm
> not sure that this is necessary, or if it would still crash when
> running
> the cleanup function because of a cancel.  I put the cleanup function
> to
> decrement the count in libmultipath, so that it wasn't part of the
> DSO,
> and then I put a sleep(5) as the last line of the cleanup function,
> and
> a sleep(10) as the last line of cleanup_checkers(). I also had to set
> running to 0 before starting the thread, and then take out the code
> to
> pause the thread if running was aleady 0, to make sure the thread
> acted
> like it was the one to set running to 0. Then the idea is to stop
> multipathd while there is a thread in its sleep period, so that
> multipathd sees that the counter is 0, and closes the dso, and then
> the thread finishes before multipathd shuts the rest of the way
> down.=20

I guess the key is that the thread's entry point must also be in
libmultipath (i.e. outside the DSO). In pseudo-code:

entrypoint() {
   refcount++;
   pthread_cleanup_push(refcount--);
   tur_thread(ct);
   pthread_cleanup_pop(1);
}

This way the thread can't be in DSO code any more when refcount goes to
zero.

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

