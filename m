Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756FDC7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686060588;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pbdOynQEYUSD/rgBnesmfLOa+xAVSMlaE0VisDYjM7E=;
	b=Hi58ALmCXDbSuZnrq/Ugk1m3Ph2wcLH4jbbTuGWcfUcrvAhqhgCEWkxQAm/t2JvSI5zMHf
	CIbmm/A6w/tyiQL8IAw05xhrlrkJJ1FoNfpqtrS9bi9uSo8a7l7ea5cExKCYAxyyuGqe7Z
	ewEGxO5f4KRL/5S4saCCkOAgBg+4tWI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-B4DYe24xMeKAOybSWn_Lew-1; Tue, 06 Jun 2023 10:09:42 -0400
X-MC-Unique: B4DYe24xMeKAOybSWn_Lew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 199EB1818CC1;
	Tue,  6 Jun 2023 14:09:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 056C340AE1EA;
	Tue,  6 Jun 2023 14:09:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9AE6419465BC;
	Tue,  6 Jun 2023 14:09:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D9F319465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 14:09:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EB174021AA; Tue,  6 Jun 2023 14:09:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66014492B00
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 14:09:24 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88B451C03DB4
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 14:08:20 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
 (mail-dbaeur03on2073.outbound.protection.outlook.com [40.107.104.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-cdY1HJUTOC6zyjUy5IDwHw-1; Tue, 06 Jun 2023 10:08:15 -0400
X-MC-Unique: cdY1HJUTOC6zyjUy5IDwHw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8516.eurprd04.prod.outlook.com (2603:10a6:20b:343::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 14:08:04 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 14:08:04 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 3/5] multipathd: refresh all priorities if one has changed
Thread-Index: AQHZjpZ1G8oSaoEUM0GGDORqDmb+r698mFgUgAFLGIA=
Date: Tue, 6 Jun 2023 14:08:04 +0000
Message-ID: <2086808fcdafd070a65db00805c3b9beacb4fed8.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-4-git-send-email-bmarzins@redhat.com>
 <83a2e2ce4669e4c031a49ac9b9ebc064a25c42bd.camel@suse.com>
 <20230605182252.GS24096@octiron.msp.redhat.com>
In-Reply-To: <20230605182252.GS24096@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8516:EE_
x-ms-office365-filtering-correlation-id: 8ae46a63-e314-4bcf-d090-08db66977239
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fQ75GazFLKhvv2i9dMrjQDtOl3HnLP5MD6GuF2EvdKDQ7RqxSLlZLSUHJhm5CHJlF+IPYPjfsXOfdVn9w2Xw+hMyMkQloEHt935cb2AvnC6BLIicTP2QxH1Pb10IPDAmPS6KrHJOXFbO2f1U6jOVXdke3dPb+CqwsUNM+0JOgbO7gCzdhVSdaspe1TlRyCbl+2rYPTMTONDSovX+Nb/LBng8h/z8wZ1CLoV9t3fI0UhQ5wnikHKPEXrVEi9a00YzWigzsiDJTxreS6bOca2quLK+cAQ9AWGZF4mEzPh87p/tzKFJuF4SpC5jM7j9xgeOq9lWXYbPA6QtFkkrfncaMyBfe+SQEBMvheKIb729SvC1/g5Yj5DVGC9wqDPt0gy3h1MV+5PFYUEkrUEIi7v07ZCtDaPVPdouOHWWo2TiX8w6Yt2vv+uNYXJiWVXuZSOBzvxCbXOCfC97/scdhgNGGl3uAfSV4pC3+rdWgdZVIpZKlWEXv8heWj0K4jlVcgiIzXwCTTO0TBxvVyhQjFyDW+7WM91gtSS/ha/BIzqZbKriUG93uYizjX6TsbdzbAJp9wjjSG7HNRqiYCNapl1stl5er0HHPtm2EKgqlNKyJKsZ8ml+Od42PsnQ58cX3hPg
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199021)(26005)(2616005)(6512007)(6506007)(83380400001)(38100700002)(41300700001)(6486002)(186003)(71200400001)(478600001)(54906003)(2906002)(66556008)(66446008)(66476007)(64756008)(122000001)(6916009)(76116006)(316002)(66946007)(91956017)(4326008)(8936002)(5660300002)(8676002)(44832011)(38070700005)(86362001)(36756003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?8r8g1q6pGOYXNr1wW612T0bXquTY24FKZUmpA2peI1ciZ0NPI8FC26hw7?=
 =?iso-8859-15?Q?KM+saUhjgFWcWRPzg2kwQzYtNBS591d0Wvb93s/ZOpIaQS+9D/ECelmmU?=
 =?iso-8859-15?Q?HpW5hEkI17SsQ9F9b+1gb5a7ylzV7RVl4ykpJSYpwejf5TeS8ELpVb7vh?=
 =?iso-8859-15?Q?w+HskgX4POeAyOX3MDNY5rAHSjG4+VO1XaHfY9XYEPnh54lvbXO+dr4os?=
 =?iso-8859-15?Q?DI1wBWafSknHeHpGr5/LE3Edf6SqWt8NBVIspWNj/jWgRh5aQeRmpPYnH?=
 =?iso-8859-15?Q?iUyu3fK8ucJEAG24svvEmpZKvOo79X2dl+JP465LIlGT9hjbMC0g4EGjM?=
 =?iso-8859-15?Q?jRKIY++/HoPEmTfCroEpS7tGZPNAdMCaGMvTqmUolXXE7wcfUhJx7klAV?=
 =?iso-8859-15?Q?sumpbk5Cb95C/3IhePRLsFwwGCQTgKLzqHsEPtdto6+ae0JX7zdgDtZt3?=
 =?iso-8859-15?Q?yfWC8TSawCkSy4YRdw1+Csq1ReArhSpvA8cutiU5c+Pjkg9ZhcwUOds1u?=
 =?iso-8859-15?Q?LKoXgw4uK83FaHgJz9j0blEWya654Z/C4wIvXx8G0Hp/D4G8ef2m+L2HF?=
 =?iso-8859-15?Q?ALWKUIBGRsJA1XoPq3lLyskXZwzJfwcSUQz50c5rO/usgzOKzFxb2Ko4i?=
 =?iso-8859-15?Q?V3gPsvLGNYzq+goW1624LD3dFfygB2Ey/x8zA57yiy28LmpVW16CQOGN8?=
 =?iso-8859-15?Q?ekXzdUlWzFiax+Eb07xZ36bPWHprnIczdqVlYJyxxfZ2mTKP8laR6XMrQ?=
 =?iso-8859-15?Q?TNsYrnjBk+gyPAU3a270mHVFJilENZnGo+2gHL3OyNESvemIOThRv2KXc?=
 =?iso-8859-15?Q?kDqXsfNRc/8GBDagQS5eZ6F2KRuJV2UosF9B8kqcucCiwVa0ElWsYZAHY?=
 =?iso-8859-15?Q?+f3cmb3WgNg450Z3nfFLaE08U4uqrWpV4vcmYPgSgMUiV2mQ6ushZK796?=
 =?iso-8859-15?Q?K6VSyJTE0Mb8vCZEaH+2oq4UVJNdjU4E6dmMgpBo2PYF9/RqGY7DqeruK?=
 =?iso-8859-15?Q?PhtUAkrMSHfkE5wWLXVvOv2seu7aChGT3PwoaRlmYtvW+fisNZTwbnvV4?=
 =?iso-8859-15?Q?2LjCMzXGljTgyraLoUY/tmy26s+RrAGmRtiZwvLTw0JakSHcWZiweAe6Q?=
 =?iso-8859-15?Q?leqtBVrFeDnHD476O36xeKtIMMQYh6PLZHIsVNxe/PG8oZqWA/k8+Q+wQ?=
 =?iso-8859-15?Q?bR+O8nTtaeCNasFBRt7nX7QJS2He4H0wFQrNrhrlFClLyot6wlctVmLmp?=
 =?iso-8859-15?Q?jiD/+6dZepqHpJkl1b3MOsDph0Q7VpXSv59i20gv/HwAMbAXaTVs2xoee?=
 =?iso-8859-15?Q?GbAX4pLluESi51ynvxWTzRbttxjOAzdNreFKa0xuNZp9DiXCBDTuVDhFG?=
 =?iso-8859-15?Q?Viz/hZ6/XPlSlci3BCAhMAPNTuiKMu9lfZn/2dx9Lm4ixK0ura2l3qhGq?=
 =?iso-8859-15?Q?EW9OFqgQQrb3FYuSZStxytcnVF8AzVrAUzLvOUrMIMlnvbrjQn8ZBvC1J?=
 =?iso-8859-15?Q?K/fXu4OFlji+hZuQvz7ykxZQsVBk4VcPIQR19Uz/kivlWd1MqhB0qMsTr?=
 =?iso-8859-15?Q?hn45hxIFqtYdegW1v9crXUVhPlnjtxTLbfCZxRJW41OaLrgHPCedQeys4?=
 =?iso-8859-15?Q?LiuTDKFp0A7On7eU4nfBrzv5w+RNx6MlhREaZiCnE6USDDUxojxgZFT4r?=
 =?iso-8859-15?Q?YPp3?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae46a63-e314-4bcf-d090-08db66977239
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 14:08:04.5320 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: axB1N0VBnh/ETRZl4o13zgItnFOvzIyHIxJdVi/wPfkaklW0kWnMa/hyG2c70z2sz3wdPj3tLdISOVs21c1EPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8516
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: refresh all priorities if
 one has changed
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <F57F80A301912E478671485611A70191@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-06-05 at 13:22 -0500, Benjamin Marzinski wrote:
> On Wed, May 31, 2023 at 04:27:25PM +0000, Martin Wilck wrote:
> > On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> > > For multipath devices with path group policies other than
> > > group_by_prio,
> > > multipathd wasn't updating all the paths' priorities when calling
> > > need_switch_pathgroup(), even in cases where it likely was
> > > necessary.
> > > When a path just becomes usable again, all paths' priorities get
> > > updated
> > > by update_prio().=A0 But if the priority changes on a path that is
> > > already
> > > up, the other paths' priorities only get updated if the multipath
> > > device
> > > uses the group_by_prio path_grouping_policy, otherwise
> > > need_switch_pathgroup() is called with refresh set to 0. But if
> > > the
> > > priority of the checked path has changed, then likely so have the
> > > priorities of other paths. Since the pathgroup's priority is the
> > > average
> > > of its paths' priorities, changing the priority of just one path
> > > may
> > > not
> > > change the average enough to reorder the pathgroups.
> > >=20
> > > Instead, set refresh in need_switch_pathgroup() if the priorty
> > > has
> > > changed to something other than PRIO_UNDEF (which usually means
> > > an
> > > error
> > > has occured) and the priorities of the other paths haven't
> > > already
> > > been
> > > updated by update_prio().
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =A0multipathd/main.c | 35 +++++++++++++++++++++--------------
> > > =A01 file changed, 21 insertions(+), 14 deletions(-)
> > >=20
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index bdeffe76..e7c272ad 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -2575,20 +2575,27 @@ check_path (struct vectors * vecs, struct
> > > path * pp, unsigned int ticks)
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (marginal_changed)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(p=
p->mpp, vecs, 1);
> > > -=A0=A0=A0=A0=A0=A0=A0else if (update_prio(pp, new_path_up) &&
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (pp->mpp->pgpolicyfn =3D=3D (pgpolicy=
fn *)group_by_prio)
> > > &&
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgfailback =3D=3D -FAILBA=
CK_IMMEDIATE) {
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path pr=
iorities changed.
> > > reloading",
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->mpp->alias);
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp-=
>mpp, vecs, !new_path_up);
> > > -=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp, 0)) {
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->pgfailback=
 > 0 &&
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new_path_up =
|| pp->mpp->failback_tick <=3D 0))
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->mpp->failback_tick =3D
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (pp->mpp->pgfai=
lback =3D=3D -
> > > FAILBACK_IMMEDIATE
> > > > >=20
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 (chkr_new_path_up &&
> > > followover_should_failback(pp)))
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0switch_pathgroup(pp->mpp);
> > > +=A0=A0=A0=A0=A0=A0=A0else {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int prio_changed =3D up=
date_prio(pp, new_path_up);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_refresh =3D (=
!new_path_up && prio_changed
> > > &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->priority !=3D PRIO_UNDEF);
> > > +
> >=20
> > I have always found it confusing that we recalculate the priorities
> > in
> > two functions (update_prio() and need_switch_pathgroup()), passing
> > boolean flags back and forth. IMO we should move this logic to
> > update_prio(), so that we don't need to refresh any priorities in
> > need_switch_pathgroup() any more. after determining the prio of the
> > "primary" path device, update_prio() has all the information
> > it needs to figure out whether priorities of other paths must be
> > refreshed.
> >=20
> > That would even make the code easier to understand, IMO.
> >=20
> > Regards
> > Martin
>=20
> So the difference in this code between when we choose to update all
> the
> paths' prios for the group_by_prio case, and when we choose to update
> all the paths' prios for the other pgpolicies comes down to how we
> treat
> PRIO_UNDEF. I didn't change the group_by_prio behavior.

My comment may have caused confusion, sorry. I just wanted to point out
that we could make the logic clearer by moving it into update_prio(),
on top of what you did, as in "while we're at it".=20

>  So right now,
> for group_by_prio devices, we will update all the paths' priorities
> if
> the checked path switches priorities to PRIO_UNDEF. My question is,
> "Is
> this the right thing to do?"
>=20
> In the best case, if the prioritizer fails on one path, it will fail
> on
> all the other paths in the pathgroup as well, so that they stay
> together. In the worst case it will fail on paths in other
> pathgroups,
> so that incorrect paths get grouped together. Granted, I'm not sure
> how
> much of a difference it makes in the worst case, since the other
> priorities would get checked eventually, and would get placed in the
> wrong group then.

No matter what we do, it's always just the state at some point in time.
If we update all priorities, we are as close to the "real" state of the
hardware as possible, at this given instant. We don't know what's going
to happen next. Paths could quickly recover and provide useful prio
values, but they might as well not. Or their prio could change, and the
value we just obtained would be obsolete. It makes no sense to reason
about the "future".

> Perhaps it would be better to treat PRIO_UNDEF like PATH_PENDING,
> where
> we will continue to use the old priority if we get a PRIO_UNDEF
> result.

Let's have a look where PRIO_UNDEF occurs. Unless I'm overlooking
something, get_prio() returns PRIO_UNDEF if no prio algorithm is
selected, or if the prio algo returns an error *and* the path state as
returned by path_offline() is neither DOWN nor PENDING. From
path_offline(), this means the state must be either PATH_REMOVED (no
point in trying a assign a prio, UNDEF is ok) or PATH_UP, i.e.
"running". The last case is strange. It can mean a very short-lived
failure, in which case=A0we could consider retrying prio_getprio() from
get_prio(), or a general problem with the prio algorithm for the path,
in which case UNDEF would again be ok (but then, how did the same
prioritizer assign a valid priority previously?).

I think that none of these cases really justifies treating UNDEF like
PENDING, except _maybe_ the "running" case. If that's agreed, we should
probably just change the way this case is handled in get_prio().

> The choices are:
> 1. make both the group_by_prio and the non-group_by_prio cases
> recheck
> =A0=A0 all paths on PRIO_UNDEF (this keeps the group_by_prio behavior the
> =A0=A0 same).
> 2. make both cases NOT recheck all paths on PRIO_UNDEF.
> 3. keep the destinction between the two (make update_prio() check the
> =A0=A0 pgplicy, and act accordingly)
> 4. Make paths keep their previous priority when they would have
> returned
> =A0=A0 PRIO_UNDEF, so we never switch to PRIO_UNDEF.
>=20
> All the choices except 3 seem reasonable. 1 keeps things how they are
> for group_by_prio. 2 leans towards moving PRIO_UNDEF paths out of
> their
> current pathgroup.=A0 4 leans towards keeping PRIO_UNDEF paths in their
> current pathgroup.

I agree that 3) makes no sense. I argued above that I don't think 4)
does, either. Wrt 1) vs. 2), we should realize that the checker loop
will eventually run over all paths anyway.  With 1) we are as close as
possible to the kernel state at any instant, but we may recalculate
priorities (and possibly regroup) repeatedly during a single checker
loop iteration, which is suboptimal [1]. With 2), we might never have
the map in a correct state, not even after the checker loop has
finished.

I think we should go with 1), and consider a later change where we just
set a marker in the checker loop, and do prio updates / path regrouping
once per map after the checker loop has finished. This requires more
changes for the checker loop though, and is out of scope for your
current patch set.

I wouldn't worry too much about group_by_prio. Regrouping is by design
with this grouping policy, and it's expected that this results in
incorrect grouping, at least temporarily. Where this is undesirable,=20
your new group_by_tpg will come to the rescue.

> The other question is, what do we do for the delayed case. Right now,
> once we finish waiting for our delay in deferred_failback_tick(), we
> automatically refresh the priorities of all the devices in our
> need_switch_pathgroup() call.=A0 We could add an update_prio() call
> before
> it to keep this behavior, but if we are already refreshing all the
> paths' priorities when we need to, I'm not sure that it's necessary
> to
> do it again here.

Well if we calculated priorities in update_prio() only as I suggested
in my previous post, we'd call update_prio() in this code path and
change the way need_switch_pathgroup() works. But I admit I haven't
thought this through, and it can be done in a separate set, anyway.

Regards
Martin

[1] it seems dumb to reason about "performance" here, but we both know
that execution time in the checker loop can become critical if there
are lots of path devices.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

