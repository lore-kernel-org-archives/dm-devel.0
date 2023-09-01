Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D57CA0FEA
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 16:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693586434;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1UmQiDQu57M96sS9BhHnDKbw5t1ONZabZcLA46zYCpM=;
	b=IwgHggXmU0mD67426tWYPDoYXdXTy1yEvvtpuohq0qJOwNrUygFQg9Et0pSkYuaVoDcE7B
	TB7XZHE0qin0wxwQl8ggEjntIzmacmv1mda0OCZ5CZBlUL1A11DZQsivdofBUtAXEoD6nT
	387N+au/tBAT1HfR6mkcFecRH1KdyGs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-3dQkTJahO9O2TLeQrwyXng-1; Fri, 01 Sep 2023 12:40:32 -0400
X-MC-Unique: 3dQkTJahO9O2TLeQrwyXng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C05F23C0EAAC;
	Fri,  1 Sep 2023 16:40:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F5DA400E413;
	Fri,  1 Sep 2023 16:40:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B3641946A46;
	Fri,  1 Sep 2023 16:40:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C62619465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 16:40:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7A1BE49310F; Fri,  1 Sep 2023 16:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71CF1493110
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 16:40:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52045381DC86
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 16:40:28 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur02on2083.outbound.protection.outlook.com [40.107.241.83]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421--onrXMgkOtiCBCgnU0o1NA-1; Fri, 01 Sep 2023 12:40:26 -0400
X-MC-Unique: -onrXMgkOtiCBCgnU0o1NA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAWPR04MB9816.eurprd04.prod.outlook.com (2603:10a6:102:390::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.23; Fri, 1 Sep
 2023 16:40:23 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e%5]) with mapi id 15.20.6745.021; Fri, 1 Sep 2023
 16:40:23 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/4] Make prio timeouts work like checkers
Thread-Index: AQHZ3FYhX+2Lh6g1B0KrHPFyswCIMQ==
Date: Fri, 1 Sep 2023 16:40:23 +0000
Message-ID: <48d636874917dd037685a4ca74a2897ca7e188ac.camel@suse.com>
References: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
 <e0408fddb74d92e18bceb2e54af2335862365829.camel@suse.com>
In-Reply-To: <e0408fddb74d92e18bceb2e54af2335862365829.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAWPR04MB9816:EE_
x-ms-office365-filtering-correlation-id: 38fa9ebf-a41d-4575-1314-08dbab0a2356
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cE4727Ftx89vIi+8d+aTSYkP8a6s6/OWHrMYivkGJIKAitqbwYq17Nfr2uHxJmzAIwHUdTBUGeMBpciDLJ+Z9YR1TCkwo8Yi2C7YTiUunryzdc+Snm4yxxweBedPLFrlN0I1gxut1BmMVr7DpRZG1Y95kzD8wc8+Hf7ZO3E554LcFSUTx5Cn4XytPTiXIPnwsqMlX+4hDQW9wCg0gvKw4M5BxdQXJWvtNfYc/0jE3Ub2Yy1tIgX+wQS8llbCliMT8W+7z1L2hObwovRG4IJIQjvKV9NbKVWBZagW5QSwagumY5i0JYQi1qolX0PTccX+nhqVXYgGxBNIOGJDn0S5XUItbuV507Pc8UZoDRLWRaaLujDNOXxCk9Ko6+LPk704h34NDKY8F7d9kxuj0RA6k1NHIfm2AH2q9sLSgnykrmpize8skvl/Uqwp+8r9amFvb4oTGxLqc6KOkxiAVImzhd5Y+BxUDi0aQiQw9HMJ3ptE4MERaMhqSP4Ag5VTGWzvJnDGRZwX8oigL6c+o7LTWnW6Kbez5jePYtUoJiDNBEyWRh14Hc7HBBYVROrKdgZQ+SCyAbZldDNFbqCf4V+IdYEC8pZJXK4/+2jKH30TOIxaOX32/hua6uJkbsZ8pQS3
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199024)(1800799009)(186009)(71200400001)(6506007)(6512007)(6486002)(36756003)(86362001)(122000001)(38070700005)(38100700002)(2616005)(2906002)(26005)(83380400001)(478600001)(110136005)(91956017)(66946007)(5660300002)(76116006)(8936002)(8676002)(4326008)(44832011)(64756008)(66556008)(41300700001)(316002)(66446008)(66476007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?AS7MVwtQRNpKQm5hxB0KVY7qeLAJisWmX4NawpUsQzPEABzJNghmFthtr?=
 =?iso-8859-15?Q?exVmgwpK42fKHEo4QgOVg+Yjr5tCbkIs1xg4M9+j7pDt7MCxI4+HtNnbz?=
 =?iso-8859-15?Q?picMyZ/z/eAH1UNbsMdsyudz9lGymF356NQ9omMJ6xFiqZk/GHZjwlOGx?=
 =?iso-8859-15?Q?kw3LFQBD9rOIn4stY33kFvQn9n92Vth3Y+uPVwJPDtYy9mmj3gI4kMZWU?=
 =?iso-8859-15?Q?aiFySkuStZ/iBNM65crfWdbVibRDPlpb3NzYxbRrChXiYpa43eB+mYAcl?=
 =?iso-8859-15?Q?4CsQJOUA/qjT/T4XbHD8qQFdXocOXcC1nu0N1CjIhAcd5ko8jfOSyMj7w?=
 =?iso-8859-15?Q?TWzJmm1hKkGzWiEOY2BOM0sBqWaW0IhXpC9ux7BvM9Zax1iymQQch5x0u?=
 =?iso-8859-15?Q?2XG+0TKd8fCDbUsp/hRHGvZnBDXRw29T++R8xjq0b554IVinfO34jjUC2?=
 =?iso-8859-15?Q?0EgWydCqjVmaVmA6bhA1sB8BjXlPk8U4s+W581I6iTTvJRn1SZ+Q986bk?=
 =?iso-8859-15?Q?KRffwdhju10QJb8jMaQT5v1WCX/zN01FzctoMaVgTPnEfL8uXqodIXBLq?=
 =?iso-8859-15?Q?lNWCilsASzKOMUsC8un8l3W0Z6okwoDgefdelAwTYWw5b6E+lxcrHkjj5?=
 =?iso-8859-15?Q?/Xk50lm9xJ0ElP5HPQPki33mkZ3Xv5Rc5ECvgplxcMEnd06Nb4Br+hpYq?=
 =?iso-8859-15?Q?iTwP5jbfm6ghfDjSHcEC24FLEgVu6JGDzeyYwzgGh99CG1jSvVEGncz3E?=
 =?iso-8859-15?Q?KvJeccbK/1kWIk55A34AR6ujSqIf/Y3CG6X1nI4hCPYimGd2+4HuIK6LJ?=
 =?iso-8859-15?Q?M0hCaS1qoNZ9f3O+gsqsBcpS2JAhsfXw8Nj9wAP36deOuOi6A8pdwJyNw?=
 =?iso-8859-15?Q?IwkYUW83XGaCsuRu/DH6Ocy09hVUfHUJo1v2I8d76OvPFXT6O5qtHO8bd?=
 =?iso-8859-15?Q?37NsnsJaBJHx9abnrkrT2qkwinmjCiFrcxhdkhvkENT9hnhZTE/Of8FHj?=
 =?iso-8859-15?Q?dnSCI0TRfAFKuZy4B6e6Fila+ZrBAXmWarBAyHHX9dmPIRdDsdJHaIHWg?=
 =?iso-8859-15?Q?XVV54aB4XNcNbyC81T5TIBnKgWWms2OeMBHVPpPSH3KanHygBCrUytxUM?=
 =?iso-8859-15?Q?1Doz8b3Wt4mfqQZD8PiPNuBmJZaWveF7VBaZeknWyoKDy3qqF3MJDeAeL?=
 =?iso-8859-15?Q?W6KzYKo/xFaAeyYCRyQxu54FYiA1MrMtEsNgUOQRQ4rZCp6z+o7dFI7UG?=
 =?iso-8859-15?Q?Eqg43VDUd2E4xqhuBHCGDYM0w1dA6f+0N5TSefGpM+6DM8ECV7wfyONrs?=
 =?iso-8859-15?Q?GP2qmiHP+QVcxEXnp228sYUvTkTpq+Zo7BfpsFFl/eb5a66df5FPzmZ8Y?=
 =?iso-8859-15?Q?fgd+lCyVBXeEjF9f3vuL65t83+ajJ+gahiIZQcFECXWa45BbACR5vkQ1H?=
 =?iso-8859-15?Q?U4ofgugKCtNQRDMHJ4VhZdzTc1FRjv48CJX0h828Ne5X+b6f6fBej+zXa?=
 =?iso-8859-15?Q?WMryI0c3eVX0mBxaIHSm2znVXeVNcMzKFWC92dRmiBXqYygH3f0NSoP3G?=
 =?iso-8859-15?Q?CAHmPZPJRxj2ngynfSbMJBsEWVPISmna9E00cpCy1kBl0p/ot6HM6O4Ll?=
 =?iso-8859-15?Q?nPAQAjhwfkmUqkIzOk4uFsbOnyir5TlXEPHElh2OllQYxBXWFY+KVl+/v?=
 =?iso-8859-15?Q?Q8jztEzuZQzjcnWckWMJy5J6yw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38fa9ebf-a41d-4575-1314-08dbab0a2356
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2023 16:40:23.3842 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cTDctbtnESIAAdqDxa56y2A+LS8wDZ7CZMSAzJSHpaem9xSUNUgY41mHtJJ1zWCMf3ebDpZyW+ZrK5dbUSFGkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9816
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 0/4] Make prio timeouts work like checkers
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <7F220165907C4F4F89DAA02C6E443C4C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-09-01 at 18:16 +0200, Martin Wilck wrote:
> On Thu, 2023-08-31 at 16:57 -0500, Benjamin Marzinski wrote:
> > This patchset changes how prioritizers set their timeouts, to make
> > them
> > match how the checker functions work, and also cleans up some minor
> > timeout issues.
> >=20
> > This patchset has been entirely reworked based on suggestions from
> > Martin Wilck: Patch [1/4] no longer rechecks the timeout values at
> > all
> > in the checker loop. Patch [2/4] makes the checker_timeout a path
> > variable, following Martin's suggestion. Patch [3/4] roughly
> > corresponds
> > to patches 2, 3 & 4 of the previous patchset, except that it uses
> > the
> > path's checker_timeout variable to cleanup a number of function
> > calls,
> > and incidentally fixes the issues in detect_prio() and the
> > path_latency
> > prioritizer. Patch [4/4] is new. It makes the datacore checker
> > respect
> > the checker timeout as well, if no timeout is specified in the prio
> > args.
> >=20
> > Benjamin Marzinski (4):
> > =A0 libmultipath: don't bother to recheck timeout
> > =A0 libmultipath: make checker_timeout a path variable
> > =A0 libmultipath: make prioritizer timeouts work like checker
> > timeouts
> > =A0 libmultipath: standardize datacore prioritizer timeouts
> >=20
>=20
> For the series: Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20

It turns out that the series breaks the hwtable unit test.=A0
I'll see if I can fix it.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

