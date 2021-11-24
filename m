Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19658C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 06:44:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-1CqR8BO2NZSiFDBy6Mq0Cg-1; Thu, 25 Nov 2021 01:44:12 -0500
X-MC-Unique: 1CqR8BO2NZSiFDBy6Mq0Cg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02DDA100C662;
	Thu, 25 Nov 2021 06:44:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 013C160BF4;
	Thu, 25 Nov 2021 06:44:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 597541809C89;
	Thu, 25 Nov 2021 06:44:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO7QiEJ005482 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 02:26:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D101851E4; Wed, 24 Nov 2021 07:26:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9E2151E3
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:26:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D46F98007B1
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:26:41 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-465-jJKbApinNRS78GxDjEq5YQ-1; Wed, 24 Nov 2021 02:26:40 -0500
X-MC-Unique: jJKbApinNRS78GxDjEq5YQ-1
X-IronPort-AV: E=Sophos;i="5.87,260,1631548800"; d="scan'208";a="186502848"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
	by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2021 15:25:34 +0800
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com (2603:10b6:a03:300::11)
	by SJ0PR04MB8257.namprd04.prod.outlook.com (2603:10b6:a03:3e4::8)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Wed, 24 Nov 2021 07:25:34 +0000
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com
	([fe80::4d43:a19:5ad0:74ca]) by SJ0PR04MB7776.namprd04.prod.outlook.com
	([fe80::4d43:a19:5ad0:74ca%8]) with mapi id 15.20.4713.025;
	Wed, 24 Nov 2021 07:25:34 +0000
From: Naohiro Aota <Naohiro.Aota@wdc.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Thread-Topic: Any bio_clone_slow() implementation which doesn't share
	bi_io_vec?
Thread-Index: AQHX4DWagfYGiGANCkycB3FNd97XzqwRLFgAgACQ9QCAAIs2gA==
Date: Wed, 24 Nov 2021 07:25:34 +0000
Message-ID: <20211124072533.tleak7xavj3tqxly@naota-xeon>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
	<YZz6jAVXun8yC/6k@infradead.org>
	<133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
In-Reply-To: <133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
Accept-Language: ja-JP, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb93da80-2dcb-4edb-5f96-08d9af1b9acf
x-ms-traffictypediagnostic: SJ0PR04MB8257:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR04MB82578A2CD30256A70FD5EBE28C619@SJ0PR04MB8257.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EFqG2o91mL7ILFma9jyzJVm4t56jOpYl7wKc/p0D8Wi9N7oXl4Tm2QtkAnSVChL6zMXyVVetuL/nF89YgTi84+dMg0aNglNRIRGFreV24svaWTfmUZBV9TWZTT97yoeREKN/VSHQqykPfqERgQtuxW7Akw4J6+yF9aHRBjbee9bscXiIeumEtBdhukrdZS8+J/s9D3ZVTmI00EYsYh4GczsetY2aPv4VhHPHipmujLWPKTD4dfAyy/Gt1BJY8dmUJywRDQRTnHLf4EVs+bHsVBSxfUdtGgwiuShx4kCdQ6BKVjUywqAalV02dUB2GwJJBQbzcGpUiqov8yLl4AB6KJRfD1vfAGvI4GRcaHrkG1aqmU4YRHEd4MMUBKY9NsiKqk76aM2SB5G2+cBJxqvi3ZvIz/FHx8mlOmmiO0acTkPP7uSeOqnLO9ojQkQ2F+5hb+awyDSUun/+sfJktEitxVLTz9assOg2ar2EcjVduEe2kgt7u2gZjGvSDfZ107AtCMXYtu2gGjgW59kwrvWsUuL3+szBJCZuKwtKetEniFeTJwDBGcEHHFM8cqSFzsBKUcfyTWlyx06ksT2OlBaEZb+zXwwDQEMKxtie8m+JRsKa2R2wK1hSIy4ZRVVoxX/VuDUF9tpQX6KzXdsg1v/1Y9FDRM//Y31ZU+W+Ewi39HdQ1YlK57ueYsfJyYeMWnKMID0s8CjujvehcgykSB2sEA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR04MB7776.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(7916004)(366004)(38100700002)(122000001)(1076003)(66556008)(66946007)(38070700005)(91956017)(6506007)(86362001)(54906003)(64756008)(66446008)(66476007)(82960400001)(508600001)(2906002)(83380400001)(6486002)(6512007)(71200400001)(8676002)(186003)(9686003)(5660300002)(8936002)(316002)(4326008)(26005)(53546011)(76116006)(6916009)(33716001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HwQJaDLrJ/feGqKVOycaamV+Kvrg6AFKMcX6G3ObIHtHXG8CLLrVhcRMQVUp?=
	=?us-ascii?Q?M0jL4ik15gsFZdih54FBDvqcbxSvZSwTf1adhnASLx1tC38t2R/RPg83KI9v?=
	=?us-ascii?Q?vNg4gaGrslbvFZBZrM896VB5l+7X0NRt1irfRpJqDw0UOXP3ftavQS5YawI1?=
	=?us-ascii?Q?LNqPPmJOsCRpj/pp4nTadHeyelCBzm8j0lCpajRU0LmSrEh+lRJan24XtbwK?=
	=?us-ascii?Q?EE/HCle/wh6Qn2tdFEjfHfD3oLnLdoTdUxaEn05uRfW7Dj4rmRu/+uNAgeFJ?=
	=?us-ascii?Q?rjaD+XbBrUQKseaVRpYCjwQJ8016rEedvq+uFLQlwJbhqkvsjysH0zMrPZ7p?=
	=?us-ascii?Q?AJdaQ9VNqNO3kUVgODlbZWqcZ0V40PIbfrWaz8QjKcba5gDMk2PaYjQXicNt?=
	=?us-ascii?Q?A7nXgQwSddj2rbLejlAsP+1spQO5JwAR/l4BL2t1JtIXJJcrdBdWUYwReZZH?=
	=?us-ascii?Q?TUrgsTt/QVx32tTGZlcV0iiEsl8+19LnSkWJyCQtAQ0wPNjbpoyExLyXGUQH?=
	=?us-ascii?Q?07Acd29UbqEyKadKrURPXTem2wlSdUthhmXVq/6F6EGeA2Wi/oNpaAe36Juw?=
	=?us-ascii?Q?Mv2+xgUIHEvfJBsSYFn2F9AsFK9HdB5SanDqq9j+K8ejpGIH/xePRn/WLaUQ?=
	=?us-ascii?Q?f+77n/sfYGAvwsTB8Pr6/9UgF8uwnAoliyJCJeHPfKXbTjMJN09sbT/W8xvJ?=
	=?us-ascii?Q?s97Wwi99eTAFBwRKiSldhg6gL4VrVghTpldkegD+u53C5bJpuAsEcb5oKfBI?=
	=?us-ascii?Q?7ggZwGAWczu+zuqVygBb8zhmZFwgLBbhds3VDMBKi2OEn66XqiDSMkMXg4Ir?=
	=?us-ascii?Q?yhJKZUDGq2ZxUSHG2NJla4LPayCBsP6k5VNKVP8KNZCCavfBLLSFnImAqD2l?=
	=?us-ascii?Q?FmGqm8kjmR9LXfErJUg6TpML1nJVIeaqAZmHj+37LXGWMf35IIu2b+5o7nr1?=
	=?us-ascii?Q?4wdsUGdAlwoi022TYZtn8PNP3bgijeGfcsCWxwzIRSg/wFqs3jv5gbAi6HpW?=
	=?us-ascii?Q?d19XtKuemBrZ+BOwSVEEC9PqwmEBFcSIK/IrSd6lkULrBvzbTM2vkW/gGmBS?=
	=?us-ascii?Q?dvL1047FUStYRQlSSG6zVpZovg83MoQxznw4a0uXFcCBiL2t+sIdL1lCp6sb?=
	=?us-ascii?Q?eSitZJA9WDSYBOEb9FX4kqcNENcFajDw5NJExtNt0RwMZsz82g7qJrQPD3xr?=
	=?us-ascii?Q?D2EmGR20R5lp77BCmvBFvI7IrwNv4lSUqfcA3bK7fFsridiFttugczmOOpM2?=
	=?us-ascii?Q?1Ac6K7H2zKjstzJvkC7sQ/MlZn0wPsVsxfgSGc8wNXK6B3QRXokZ7RkqUYb4?=
	=?us-ascii?Q?u/CELGdlUTpkSdIK0G4fMsOVoKRN533parnZjlxOAAM6WXXNlUkktOdwk88P?=
	=?us-ascii?Q?yQlBXUVMPnB+D/v9j8FRYgXUbcMjmTnE+cbcWXt9o871NggDJUy9DRgRZHcl?=
	=?us-ascii?Q?tgzLWhtsUqiysRw/VtP/ruzM0DQcTl2YUsCWUUK9hdyobvMSEdMljIGv+fpF?=
	=?us-ascii?Q?nmQFjzhX+vr6At2vaBAGspLK2HGbACRqbaOH/kBJzlBCgyQ9ilK/5z01W039?=
	=?us-ascii?Q?Nu/50JmP5o6S7ghGck26bc+qPM2OD1Uie4Qcr+O2FO3y3Z4p6tD7468ycDFk?=
	=?us-ascii?Q?PIg2NLyn/XSleRqYPVsUvbU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7776.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb93da80-2dcb-4edb-5f96-08d9af1b9acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 07:25:34.4222 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IkyryAaz+MUbZq50RPDlp1ZvCDdEDR6/2JUZsLRyHMRZXd+eyEPk7+djbaOuHt32QGNt0nyoY3LfGGjlWDhuvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8257
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AO7QiEJ005482
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Nov 2021 01:44:00 -0500
Cc: "hch@infradead.org" <hch@infradead.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3DCCC3811F5AE949BD9FC57B17CF67D4@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 24, 2021 at 07:07:18AM +0800, Qu Wenruo wrote:
> 
> 
> On 2021/11/23 22:28, hch@infradead.org wrote:
> > On Tue, Nov 23, 2021 at 11:39:11AM +0000, Johannes Thumshirn wrote:
> > > I think we have to differentiate two cases here:
> > > A "regular" REQ_OP_ZONE_APPEND bio and a RAID stripe REQ_OP_ZONE_APPEND
> > > bio. The 1st one (i.e. the regular REQ_OP_ZONE_APPEND bio) can't be split
> > > because we cannot guarantee the order the device writes the data to disk.
> 
> That's correct.
> 
> But if we want to move all bio split into chunk layer, we want a initial
> bio without any limitation, and then using that bio to create real
> REQ_OP_ZONE_APPEND bios with proper size limitations.
> 
> > > For the RAID stripe bio we can split it into the two (or more) parts that
> > > will end up on _different_ devices. All we need to do is a) ensure it
> > > doesn't cross the device's zone append limit and b) clamp all
> > > bi_iter.bi_sector down to the start of the target zone, a.k.a sticking to
> > > the rules of REQ_OP_ZONE_APPEND.
> > 
> > Exactly.  A stacking driver must never split a REQ_OP_ZONE_APPEND bio.
> > But the file system itself can of course split it as long as each split
> > off bio has it's own bi_end_io handler to record where it has been
> > written to.
> > 
> 
> This makes me wonder, can we really forget the zone thing for the
> initial bio so we just create a plain bio without any special
> limitation, and let every split condition be handled in the lower layer?
> 
> Including raid stripe boundary, zone limitations etc.

What really matters is to ensure the "one bio (for real zoned device)
== one ordered extent" rule. When a device rewrites ZONE_APPEND bio's
sector address, we rewrite the ordered extent's logical address
accordingly in the end_io process. For ensuring the rewriting works,
one extent must be composed with one contiguous bio.

So, if we can split an ordered extent at the bio splitting process,
that will be fine. Or, it is also fine if we can split an ordered
extent at end_bio process. But, I think it is difficult because
someone can be already waiting for the ordered extent, and splitting
it at that point will break some assumptions in the code.

> (yeah, it's still not pure stacking driver, but it's more
> stacking-driver like).
> 
> In that case, the missing piece seems to be a way to convert a splitted
> plain bio into a REQ_OP_ZONE_APPEND bio.
> 
> Can this be done without slow bvec copying?
> 
> Thanks,
> Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

