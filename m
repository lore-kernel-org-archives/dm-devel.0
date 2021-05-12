Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B74C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 20:37:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DEA8C611F0
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 20:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEA8C611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-A0VJlH0JO1mTEC07L9um1Q-1; Wed, 12 May 2021 16:37:10 -0400
X-MC-Unique: A0VJlH0JO1mTEC07L9um1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9EA01854E25;
	Wed, 12 May 2021 20:37:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FC9560D79;
	Wed, 12 May 2021 20:37:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5214C55344;
	Wed, 12 May 2021 20:37:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CKb0Ji014919 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 16:37:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 07C0B1055246; Wed, 12 May 2021 20:37:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 022A210FFE6D
	for <dm-devel@redhat.com>; Wed, 12 May 2021 20:36:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9153833959
	for <dm-devel@redhat.com>; Wed, 12 May 2021 20:36:57 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-224-bY49noW3PSCq38Q7jYKfVQ-1;
	Wed, 12 May 2021 16:36:53 -0400
X-MC-Unique: bY49noW3PSCq38Q7jYKfVQ-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-30-bdtSZwnSOFO2l1dLpNltDA-1; Wed, 12 May 2021 22:36:50 +0200
X-MC-Unique: bdtSZwnSOFO2l1dLpNltDA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2741.eurprd04.prod.outlook.com (2603:10a6:4:98::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25;
	Wed, 12 May 2021 20:36:49 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 20:36:49 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
	success on path removal
Thread-Index: AQHXRrx9QRn2HTqim0uQGVS/yH6it6rfuRYAgACKSYCAAAw3AA==
Date: Wed, 12 May 2021 20:36:49 +0000
Message-ID: <7e6fb44f90e6088f53a41396a7e210cd3009d469.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-4-git-send-email-bmarzins@redhat.com>
	<66c4ca02bb90a7a4c18819082d2ec554ddc56205.camel@suse.com>
	<20210512195305.GE25887@octiron.msp.redhat.com>
In-Reply-To: <20210512195305.GE25887@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3fcceda-7dbd-4947-31a3-08d91585ab50
x-ms-traffictypediagnostic: DB6PR0402MB2741:
x-microsoft-antispam-prvs: <DB6PR0402MB27410A8F08D89FB6A5D11938FC529@DB6PR0402MB2741.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: u4Eu1ufVA1gjmH40FmZXFlgVFWbiMHxz+ZifAWcwUzhzBMSHoM6uf3s+Nq0T883n4fsbDL7hwnuLUJtjcb5oyK4xPsk2Ny69xKLC1TQXxzyYfWx3qXCiDHROtmOA48kUCIEAdTwHaqhz+KdJbwZYU6QYVmCsHswSO3cdudsfaDpMtcZe2u9hcQn9IFEXTWNnIXO2gPNcL8t1LIV0qWL9aa+Qvs79kOZfVuS/BTNivZTqNwtwWkeZ3kBL+NkLtDXckXHrZc6+BSBx6kFBVW1tuKTMhKi8Bu2Z6fs+huNtyN1bwKd0ZSLrhUBb9EEJuo8Wjij78IjsWeExZSqddTW08T1K3q9gN5suFdZg22Q9skJsECZ2E0zHkr5vYywMPMgKvGAayCkV9atu8V6ONUKaVtCWT8PZ+uKa7ehvG0nBbjvGO3+Q/+OBpeMkW31lUmNq6Lz1DdpMhemiYpueugbGn09MMQvBNOi1OAWz++OMq1mPcf/vsUOTwqsP71/o1qZeLg/h4u4r/7HsSwQ3uRg6O3uZdNixWKqFYWFXg53FERiN3EHuga9rS+GBY9F8656iDXF4axQE/NikWe0CBrTvb16U8dtYk3/JkK8L41N9Rh3YnKhhvjnxxImD3D5FZzLmftEHlIWgthBZFWOh/kegfdFNZdQHotzH8KYGLiqt+HvoJy49yaagLwXxhdgIMw/4Om5ogCNEoeWRP004cu7NQQB0LBKTxNWo/kcdXOmhzOk=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(136003)(366004)(39850400004)(346002)(396003)(8676002)(186003)(6916009)(6486002)(450100002)(316002)(6512007)(478600001)(966005)(2906002)(44832011)(4326008)(6506007)(8936002)(5660300002)(26005)(122000001)(38100700002)(36756003)(86362001)(91956017)(66446008)(66556008)(71200400001)(64756008)(66476007)(66946007)(83380400001)(2616005)(76116006)(60764002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?MyDMfdPhwCPeldbuGQV4zeuzqMrdUXcjXoc3JjFvqgkox7N+MP7PAI/iL?=
	=?iso-8859-15?Q?zHTJ0973bvJsh89aHFUvCpQaHStOyFP+ggigoFL0kWI1VuVN5kwxCLzr3?=
	=?iso-8859-15?Q?f4fdWexz8lEskh9pWN8bwnKzwyuVnu16K//G+wkAOKxVDd+9Mdg+RRg8X?=
	=?iso-8859-15?Q?WG/1N6TKWea0Likm1Bfx68LehMetyrQIXfkvt5sFiIyJJ4hu56syiJBCT?=
	=?iso-8859-15?Q?K6FMt0kQs3kj4a1yOCDLWH3QAPvjViHUDfphISRJe3hjyvj17dAp5zzFX?=
	=?iso-8859-15?Q?FbFR8tiWxwpcPuB352i9wJ61OuVgPlOnRE4/GY9PftITHsP24Ed/TQ8s4?=
	=?iso-8859-15?Q?U90E3bmI0pHXF31Q5Gw7/+cQl40v5GxsIZoaJ2KJo/c60Tc88KVSBeoQA?=
	=?iso-8859-15?Q?jki9yIflTGcA4DXGCw/gK93NgIkODnly+1O7b19k19vi+O1Ggq//hPqKm?=
	=?iso-8859-15?Q?RsILwcoeSjlizVDtiRFhfkG3kVtjlKvGqYTSHn0zC5YG5la3m0RWhjQ5y?=
	=?iso-8859-15?Q?9p3KDr6vY5nTSD73K+e8XWJo8U2Xj2AZi3X03EX+KwaueBqw4pBpNrhCv?=
	=?iso-8859-15?Q?4kHYBp9N4y+HaJvgz7KA4Yjy3kJ1M5zLAfIGxlSZR5zvmFRgvbk4vVNaC?=
	=?iso-8859-15?Q?TvB/PYAX1B23aBpdxQmh7G0yXDgUqYqdY6QGIqD8qpA7rLR3bVmIqIX3b?=
	=?iso-8859-15?Q?wB0OXL+cmJDlX4N9vbJdEyteNdLvigddKzBrruWcAs7X7x9TGAQ11jboi?=
	=?iso-8859-15?Q?3NJ+yu4bjqNdXaItxtLvARbBgygwl4SGaiXZtEHHsmdCY3Z0L4cDblXnQ?=
	=?iso-8859-15?Q?ezxhBmKHBD41eKkQ39LJHFxggrQEMviB63uS5M0lvYpQ6DrkRC97WpNS+?=
	=?iso-8859-15?Q?TvICC3dwoa1gQRW/XTYikSJttMTBmTeTtnMTfgZ7gcIYT0ckM+etQKrcs?=
	=?iso-8859-15?Q?B3mjzqbOj0XxnJIxYogVj71cNISvGHtSKefyz0SkH36v2gyGMimfy36AS?=
	=?iso-8859-15?Q?8E8G8OMMTGb0rU2MjPFSpv8ZHsElfKKUKtFYvDsljYQzEQ1HLNCcRbaDu?=
	=?iso-8859-15?Q?4d/KYTeeXp7EeD5Z5GWqNpM+UBDZqJDnCAIFNyL8twllEGPXTgq/36pzC?=
	=?iso-8859-15?Q?DLihDUzzoxUI/wNdmd6o/cljGwo2IvWZcYo5kFJRngO1wd+GROi17D9CJ?=
	=?iso-8859-15?Q?Lm7rPcGJSLL4w/BxCc8NARX2UOxl3J2L2T0j2kp1SLIa/1DZjT720cEKV?=
	=?iso-8859-15?Q?c1H/qXfCWZvVHHNJkpbj6Tbqoj1pB3D1/bTFM7Mu0EST2PuQhQbUEwLmO?=
	=?iso-8859-15?Q?BvnS+zJIMIksGTWM7s5oulqrCiEVHxPDX6z1TlMLG7ZWVNkzXIzcK+Xuw?=
	=?iso-8859-15?Q?rBz9vw1oLbaQ+lnGpYWQG7lmUN1Tq6wfe?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3fcceda-7dbd-4947-31a3-08d91585ab50
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 20:36:49.8139 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 058U7SeCPwUhEGX7HQfoz3dwA0BSFiZynn1SBzCa8fpfm2AHeJul1KrULTxxMC5JB9DsA7MweE+5DwGoInUlsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2741
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14CKb0Ji014919
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
 success on path removal
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <63CE9032AA285240B4506ECBC76B1C11@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-12 at 14:53 -0500, Benjamin Marzinski wrote:
> On Wed, May 12, 2021 at 11:38:08AM +0000, Martin Wilck wrote:
> > On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> > > When ev_remove_path() returns success, callers assume that the
> > > path
> > > (and
> > > possibly the map) has been removed.=A0 When ev_remove_path()
> > > returns
> > > failure, callers assume that the path has not been removed.
> > > However,
> > > the
> > > path could be removed on both success or failure. This could
> > > cause
> > > callers to dereference the path after it was removed. Change
> > > ev_remove_path() to return success whenever the path is removed,
> > > even
> > > if
> > > the map was removed due to a failure when trying to reload it.
> > > Found by
> > > coverity.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > This looks ok, but I'd like to discuss it in some more depth.
> >=20
> > We need to clarify the meaning of the return code of
> > ev_remove_path().
> > We guarantee that, when ev_remove_path() returns, either the path
> > is
> > removed from internal data structures and kernel maps, or
> > INIT_REMOVED
> > is set. We can't guarantee whether the path
> >=20
> > =A0a) is not referenced any more by any kernel map,
> > =A0b) was actually removed from pathvec and other data structures in
> > multipathd.
> >=20
> > We have to agree on whether it means a) or b) if we can't make
> > these
> > two cases equivalent. Assuming multipathd has correct information
> > about
> > the kernel mappings, the only difference between a) and b) is the
> > unlikely failure in setup_multipath(), where a) is true and b) is
> > not
> > (because sync_map_state() won't be called).=A0Your patch assumes the
> > semantics of a), which is correct AFAICS, but should be more
> > clearly
> > documented.
>=20
> Well, actually because of wait_for_udev and !need_do_map, a
> successful
> return can still leave the kernel maps and internal structures
> unchanged. It's just that callers have to assume that b is the case.
> =A0
> > Actually, I think we can fix the discrepancy between a) and b) - if
> > domap() was successful, we should be able to orphan the path, even
> > if
> > update_multipath_strings() failed for some reason.
>=20
> I'm pretty sure that this is already the case.=A0 This comment
>=20
> =A0/*
> =A0 * Successful map reload without this path:
> =A0 * sync_map_state() will free it.
> =A0 */
>=20
> is a lie.

Indeed, you are right. I wasn't deliberately lying though, just failing
to understand my own code :-(=A0 We should fix these comments.

>  If setup_multipath() succeeds, the path will get removed by
> check_removed_paths() via:
>=20
> __setup_multipath -> update_path_strings -> sync_paths ->
> check_removed_paths
>=20
> If setup_multipath() fails, the path will get removed by
> remove_map_and_stop_waiter() via:
>=20
> __setup_multipath -> remove_map_and_stop_waiter -> remove_map ->
> orphan_paths
>=20
> So AFAICS, the only way for a path not to get removed is if you
> succeed
> with wait_for_udev or !need_do_map, or if you fail in domap.

Agreed. Let's fix these comments.

> > IMO we should consequently change the retval for the cases where
> > ev_remove_path() returns without deleting the path for a non-
> > "failure"
> > case (wait_for_udev and !need_do_map).
>=20
> So you think these should return failure?=A0

What I meant is that the return code of the function doesn't need to be
interpreted in terms of "success" or "failure". Rather as "path is now
gone" or "path is still referenced somewhere", which doesn't map 1:1 to
"success" and "failure", IMO.

> For need_do_map, I think we
> would want to distinguish between cases where everything worked
> correctly and we're just waiting to update the map, and cases where
> something went wrong.

This one is actually trivial, because it's only set to false by
uev_remove_path() if it's merging uevents.

>  Since wait_for_udev can happen in more situations,
> it's a lot harder to say what the right answer is. For cli_add_path
> and
> uev_add_path, it seems like we want to know if the path was really
> removed. So returning failure there makes sense.=A0 For cli_del_path
> and
> uev_remove_path, it seems like we want to avoid spurious error
> messages
> when everything went alright and we're just waiting to update the
> map.
> So returning success makes sense there.
>=20
> Perhaps the answer is to return symbolic values, to describe what
> actually happened, rather than success or failure.

This is what I meant. I didn't express myself clearly enough; I just
thought that 0 doesn't have to mean "success".


>  They could either be
> bitmask values or we could have helper functions to help checking
> for multiple valid return values.

I think the callers just need to know if the path is still referenced
somewhere. Acting appropriately is then up to the caller. You just
proved that my cases a) and b) are actually equivalent, which is nice.
Perhaps we need to introduce another return code indicating that the
entire map had been removed (e.g. failure in setup_multipath()).

> > Thoughts? Whatever we decide wrt the semantics of the return code,
> > we
> > should document it clearly in comments at the function header.
> >=20
> > Here's a quick review of callers:
> >=20
> > =A0- cli_add_path(): AFAICS this needs b) semantics. We shouldn't set
> > up
> > a new path unless it had been successfully removed internally.
> > =A0- cli_del_path(): needs a) semantics.
> > =A0- handle_path_wwid_change(): needs a).
> > =A0- uev_add_path(): needs a).
> > =A0- uev_remove_path(): the return code of ev_remove_path doesn't
> > matter
> > much here. This is the only caller that sets need_do_map =3D false.
> > =A0- uev_update_path(): we currently don't look at the return code.
> > uev_add_path() will make another attempt at removing the path if
> > necessary.
> >=20
> > Regards
> > Martin
> >=20
> > P.S.: The remaining failure cases in ev_remove_path() are the
> > failures
> > in update_mpp_paths() and setup_map(). The former can only fail
> > with
> > ENOMEM, afaics. The latter, likewise, or if the map is
> > fundamentally
> > misconfigured (which to me means that a previous call to
> > setup_map()
> > would have failed as well). I'm wondering why we remove the entire
> > map
> > in these failure cases. This goes back all the way to 45eb316=A0
> > ("[multipathd] DM configuration final cut") from 2005. It's true
> > that
> > both failures are pretty much fatal, but why is removing the map
> > the
> > answer here?
>=20
> I don't think it has to be the answer. There are other cases where
> setup_map() fails and we don't automatically wipe the map.=A0 I did
> consider changing it when I was looking through ev_remove_path(), but
> I've never known this code to cause any issues, and as you mention,
> it isn't wrong to do so, just not really necessary AFAICS.

Let's take care of this another time.

Regards,
Martin

>=20
> > However, this goes beyond the purpose of your patch. *If* we remove
> > the
> > map, returning 0 is correct for either a) or b).
> >=20
> > P.S. 2: I wonder if the logic in uev_update_path() is correct.
> > Rather
> > than calling uev_add_path() after rescan_path() directly, I think
> > we
> > should rather wait for another uevent (and possibly trigger another
> > "add" event, I don't think "rescan" automatically generates one).
> >=20
>=20
> Yep. You're correct. I'll fix that.
>=20
> -Ben
>=20
> >=20
> > > ---
> > > =A0multipathd/main.c | 6 ++++--
> > > =A01 file changed, 4 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 6090434c..4bdf14bd 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -1284,7 +1284,7 @@ ev_remove_path (struct path *pp, struct
> > > vectors *
> > > vecs, int need_do_map)
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0strlcpy(devt, pp->dev_t, sizeof(devt));
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (setup_multipath(vecs, mpp))
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/*
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * Successful map reload without this
> > > path:
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * sync_map_state() will free it.
> > > @@ -1304,8 +1304,10 @@ out:
> > > =A0=A0=A0=A0=A0=A0=A0=A0return retval;
> > > =A0
> > > =A0fail:
> > > +=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error removing path. removing m=
ap %s",
> > > pp->dev,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> > > =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> > > -=A0=A0=A0=A0=A0=A0=A0return 1;
> > > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > > =A0}
> > > =A0
> > > =A0static int
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

