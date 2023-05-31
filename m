Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F04C77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685550523;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vCkQG1t1n7TVzxdRribMANB5MC8u5TJdNkNWxhd1zGE=;
	b=BpHuPwQc9YoVCd/23WkqjC7F5n3561gPxyMt68KrrB2RjTnkjwQccMdxLGJwThZuuvtgu0
	lsR6dVMPy9Z/XvaYNdaA2fsFsZythWkh2XI2KkiFlDj2fKYgwTDk7aM+KjP7JiiPk3G5KU
	bVEo6gObqqr2IDG5gQSr1E/p6jfG1H4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-kEXQdW9lPDipxknjcLJWCw-1; Wed, 31 May 2023 12:28:40 -0400
X-MC-Unique: kEXQdW9lPDipxknjcLJWCw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71A521C01508;
	Wed, 31 May 2023 16:28:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55D75492B00;
	Wed, 31 May 2023 16:28:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25EBC19465A8;
	Wed, 31 May 2023 16:28:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 414E51946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 16:27:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25506202696C; Wed, 31 May 2023 16:27:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D96F20296C6
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:27:33 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB76985A5BB
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:27:32 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2051.outbound.protection.outlook.com [40.107.8.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-MwJ_JpewNkuVG3O_HrGUHQ-1; Wed, 31 May 2023 12:27:29 -0400
X-MC-Unique: MwJ_JpewNkuVG3O_HrGUHQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB7493.eurprd04.prod.outlook.com (2603:10a6:20b:293::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 16:27:26 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:27:26 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/5] multipathd: refresh all priorities if one has changed
Thread-Index: AQHZjpZ1G8oSaoEUM0GGDORqDmb+r690nGIA
Date: Wed, 31 May 2023 16:27:25 +0000
Message-ID: <83a2e2ce4669e4c031a49ac9b9ebc064a25c42bd.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB7493:EE_
x-ms-office365-filtering-correlation-id: d373d493-6c20-4f73-181f-08db61f3eb7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Isco8p6mzcIJWZ0z+yvHfgqsnxCCdGWuTHNxkd3OlE1NEI1PV6ph6GaAxicU22PC8i8bIFfQs9t2JNq8/DhAWWqEzSnPxAx8WbMzk0vjIY7kZB1u4v4CguUiVg0yeMMonEuif4eYO0bdtKmFfTUk5J2L+mD6+aDU0uhCgtXxYeDwUk+45PT0tTKCCSbucHXVQTIXpktzhdzIxzz6mrYsWeN9X+32sdoNHo8vq7p3IKk7xstxNITalF7wLbqX+pxXHgPRLCiUWzW7Jhxs7cdDdCr+bnpcmlJWFaD9C+jHAWfdafpKylEUczKf8NpkhtLesJof/FdrazKhopCaklM04E8t5//8kXFYWv4kalC1ZmiE7uJLNYtZ9bYtUcy2iwW/lwbxeyGP9dMuzF/fNNcOA8U/LplYb7UCEYS8ayUsX7YXB8DZnbO4o8oj1UqtYWk3SkMmqSGAc3KMMnHbTWtqCz1SIonkgs1FDkmJkSUMo8NCDfwrnkRM6EUMNmktPE86gIkDPcEgmPF1CjSaQcfgK+YdvZaX7WH4plj/DajyyATx8WDPUxZeyWV8Sli7HwN9cKTMQY1luD4eIrHNtTsQuEfg5E2PdS3ye2LnMEUB0sNE6djKNB5/TuUB2bFW0ZKM
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(186003)(2616005)(110136005)(6506007)(26005)(2906002)(6512007)(478600001)(44832011)(83380400001)(38070700005)(6486002)(86362001)(8676002)(38100700002)(8936002)(122000001)(41300700001)(5660300002)(316002)(76116006)(66946007)(66556008)(64756008)(66476007)(36756003)(66446008)(71200400001)(91956017)(4326008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?E1db+hbbaxlRNne/Beo4gNwXThRb0maMjehIfUWFI1BzO8OK6qTUI5Q5J?=
 =?iso-8859-15?Q?dELOD+x0ZhO94FJPgtlUjImdymo1Gb4ZVGnzoNvvyM8W0Q5N9Pdg2jEEj?=
 =?iso-8859-15?Q?Vj66Apsz/5um9JdLPaUNwtOenHXPYKqZdlR1/4EqTbKOnCQWgQufprbFD?=
 =?iso-8859-15?Q?5zlUX6Sr1Lfwg0U0ebkW9YWGHCgLOf/t/oRCCSfPeDJYJ+qzFmd09plWv?=
 =?iso-8859-15?Q?aGGKY+RG33Qj/06t7MjIujpNy6Ez09ZH5swlj+eat9X0oCsw7fK3ovILs?=
 =?iso-8859-15?Q?pVbiq9ECAa2UKJaikoSHR3eShqa5hTKUnIHPDSOX95dow1NiWfEHivo8o?=
 =?iso-8859-15?Q?gEITqzt0JjgV6/gqDAMI6eRAnXjPI5p4m4I7BvRlUuttevFjN2xSAJ+j8?=
 =?iso-8859-15?Q?1wureWxITjgeJm7vdDedTzSGYk+WTRPoRvnsQ+h8yCMfzZRfg/PBMAOgU?=
 =?iso-8859-15?Q?VnEAwm15KpnWJHdIXZAy+YhxPeFNk8Fimf5k49yK3c+I35yglEHxxD4/K?=
 =?iso-8859-15?Q?/bdD+CtXbyWvD0y37xcmSFPnBeAU6lNX7aA01A0SIaSTHP1AryB5Z6ri8?=
 =?iso-8859-15?Q?QGVQabx2bfKlUmlD7tWasDtOOB2BuXbKzUu3fPu2ZckonbRuJEJALUhPf?=
 =?iso-8859-15?Q?2fnonFefQhqgacvovRUjGNeCLEsUz8y3/m/5/tt2P1ZoO4WdRGKhFyiHE?=
 =?iso-8859-15?Q?b2uHp0uLbvHynwu99D7Teibpl9N1tBXt7p+9bJYhIKifPnqutoPYGvsb5?=
 =?iso-8859-15?Q?kDjxSNcv+mhyH1Hj4kVrC8lYRDJn88gv9NXVsDJRGHlOnasEx0n9PAvVy?=
 =?iso-8859-15?Q?hrmoxlNnVOhKqdpymOOSgzU6qImeCLN7AzkIupwYAmhUafLpsmkz2Nx4s?=
 =?iso-8859-15?Q?LXT96XpIstWp6GxSMySdyKsugqv4icCW58IP+RbJmNK05dmUZ3ickdvwU?=
 =?iso-8859-15?Q?mUJYoAdxzFTAaUup0eIOm1T+ZVzkLvY/57Kfgk+VGp2gWAQquSoASO5nV?=
 =?iso-8859-15?Q?QytuYgJ0lXoxZsEvWQTjYlbTWLY8a5cHIEyu48cD9Yz0DPzaN+YV0zPyF?=
 =?iso-8859-15?Q?8jKAJIVgVEHopP/bFBUd5rjYy/2S/2vL5fSgQ+74O83w9O540oC46tvsv?=
 =?iso-8859-15?Q?EI0pic4zqUYXbFGfIJvesh9cqDMVGEDxEAyYtFBwanmbyBQgqrmFZba0C?=
 =?iso-8859-15?Q?f8lyKPEXkwCIS3E2Or163OMt++BsVKMK3R+YaFDlyIjwMiOOBUBSh2sI0?=
 =?iso-8859-15?Q?mbhUzKr76Jm/aenhUgu1OMidMUd5id8BugNrLNXnBhOS1jXtbUllYsXVN?=
 =?iso-8859-15?Q?UbM/oNuuSMEwMWCMiOKxg/7eh+REWQTISJsrrgY2ND2Xo6gS3wqGssIeV?=
 =?iso-8859-15?Q?XPUell4qndJKvc33a2wdGxoGdq4aYbznGRSspWazk0CSidxNnyyINQIUl?=
 =?iso-8859-15?Q?hk2naDTs0fCGTD6D/XwBb/I2tpCkgZ+WA4OgGgmIGxL0IKc0vgk6BwHU3?=
 =?iso-8859-15?Q?v+48SCefYZA0RMdTvtVznQLzKiK3a61nJ+PC/KeXST8AI2XfdzDgAc89s?=
 =?iso-8859-15?Q?X+e32/jzWsXyI4r8uUj9ukaYApaI+kpzIzoqB3std/H56HpzmeRgYQwSn?=
 =?iso-8859-15?Q?TIS1OWJuWNSb2nZFvVCpFxLUPeU67u5tj8QPli8hqfFh/lcGsXK4Ra1KP?=
 =?iso-8859-15?Q?N/ca?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d373d493-6c20-4f73-181f-08db61f3eb7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 16:27:25.8471 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PqslzcbZV8vl6OHe0xL2iAo+53aINX+7LA9I3+98gRXXwmFC4YMDh7fBueWKPDlJuZG3RN0mfMjgi/NQEhtGyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7493
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <D1B85C7003F964418E6F36F7DA887C9A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> For multipath devices with path group policies other than
> group_by_prio,
> multipathd wasn't updating all the paths' priorities when calling
> need_switch_pathgroup(), even in cases where it likely was necessary.
> When a path just becomes usable again, all paths' priorities get
> updated
> by update_prio().=A0 But if the priority changes on a path that is
> already
> up, the other paths' priorities only get updated if the multipath
> device
> uses the group_by_prio path_grouping_policy, otherwise
> need_switch_pathgroup() is called with refresh set to 0. But if the
> priority of the checked path has changed, then likely so have the
> priorities of other paths. Since the pathgroup's priority is the
> average
> of its paths' priorities, changing the priority of just one path may
> not
> change the average enough to reorder the pathgroups.
>=20
> Instead, set refresh in need_switch_pathgroup() if the priorty has
> changed to something other than PRIO_UNDEF (which usually means an
> error
> has occured) and the priorities of the other paths haven't already
> been
> updated by update_prio().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/main.c | 35 +++++++++++++++++++++--------------
> =A01 file changed, 21 insertions(+), 14 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index bdeffe76..e7c272ad 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2575,20 +2575,27 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (marginal_changed)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->m=
pp, vecs, 1);
> -=A0=A0=A0=A0=A0=A0=A0else if (update_prio(pp, new_path_up) &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (pp->mpp->pgpolicyfn =3D=3D (pgpolicyfn *=
)group_by_prio) &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgfailback =3D=3D -FAILBACK_I=
MMEDIATE) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path priori=
ties changed. reloading",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>mpp->alias);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->mpp=
, vecs, !new_path_up);
> -=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp, 0)) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->pgfailback > 0=
 &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new_path_up || p=
p->mpp->failback_tick <=3D 0))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>mpp->failback_tick =3D
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (pp->mpp->pgfailbac=
k =3D=3D -FAILBACK_IMMEDIATE
> ||
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (c=
hkr_new_path_up &&
> followover_should_failback(pp)))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0swi=
tch_pathgroup(pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int prio_changed =3D update=
_prio(pp, new_path_up);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_refresh =3D (!new=
_path_up && prio_changed &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->priority !=3D PRIO_UNDEF);
> +

I have always found it confusing that we recalculate the priorities in
two functions (update_prio() and need_switch_pathgroup()), passing
boolean flags back and forth. IMO we should move this logic to
update_prio(), so that we don't need to refresh any priorities in
need_switch_pathgroup() any more. after determining the prio of the
"primary" path device, update_prio() has all the information
it needs to figure out whether priorities of other paths must be
refreshed.

That would even make the code easier to understand, IMO.

Regards
Martin



> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (prio_changed &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgpolicy=
fn =3D=3D (pgpolicyfn
> *)group_by_prio &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgfailba=
ck =3D=3D -FAILBACK_IMMEDIATE) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "%s: path priorities changed.
> reloading",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->mpp->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rel=
oad_and_sync_map(pp->mpp, vecs,
> !new_path_up);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_path=
group(pp->mpp,
> need_refresh)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(pp->mpp->pgfailback > 0 &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 (new_path_up || pp->mpp->failback_tick <=3D
> 0))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->mpp->failback_tick =3D
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e if (pp->mpp->pgfailback =3D=3D -
> FAILBACK_IMMEDIATE ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (chkr_new_path_up &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 followover_should_failback(pp)))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

