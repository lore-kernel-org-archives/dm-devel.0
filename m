Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2821ECCA473
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 07:22:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-gScShPlvP_istRWHD9KowA-1; Thu, 09 Jun 2022 03:22:09 -0400
X-MC-Unique: gScShPlvP_istRWHD9KowA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41420100BABD;
	Thu,  9 Jun 2022 07:22:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 701D21121315;
	Thu,  9 Jun 2022 07:22:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7793C1947074;
	Thu,  9 Jun 2022 07:22:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 266A91947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 14:44:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 087C3492CA3; Wed,  8 Jun 2022 14:44:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0415E492C3B
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 14:44:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBD7729DD99E
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 14:44:53 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-V0ren8m2Mxqst5eL23T1Yw-1; Wed, 08 Jun 2022 10:44:49 -0400
X-MC-Unique: V0ren8m2Mxqst5eL23T1Yw-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by DM6PR06MB6555.namprd06.prod.outlook.com (2603:10b6:5:255::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 14:44:47 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe%3]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 14:44:47 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Thread-Topic: [PATCH] multipath.conf(5): add disclaimer about vendor support
Thread-Index: AQHYdS6EGERvE4iBPk2+fffolsgNha1EkqKAgACeCACAAHE8oA==
Date: Wed, 8 Jun 2022 14:44:46 +0000
Message-ID: <SN6PR06MB4495E13CDC76B8E6976140718CA49@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220531203905.28702-1-mwilck@suse.com>
 <20220607223240.GV5254@octiron.msp.redhat.com>
 <1b00794e0d3d195fa1f099b0f8dc44846c2db66e.camel@suse.com>
In-Reply-To: <1b00794e0d3d195fa1f099b0f8dc44846c2db66e.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e46648d-83cf-43ad-8a4a-08da495d6f03
x-ms-traffictypediagnostic: DM6PR06MB6555:EE_
x-microsoft-antispam-prvs: <DM6PR06MB65551702E860BCC486DCE4E28CA49@DM6PR06MB6555.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7I0J9e4u7rjtzxsBfc2CJGPX/4p6HcOCxSTbJ4/lphYhmbn5ev+ATVp5Opefyf/OADoZt8oNJPk7Ooa+oFkxJJBs5wrVvBZOePGGK6noTQjp9rJYjsFdowia3loDSBqiZPXxNlSrQuRZiE5cwNgXhjX/VhgD23m7ba8kW2qy61K9HlNOgM7HG3n5dtAE9naJTMKovWV2tkimggyjYF4+fMvKqbBQWKd4swkbKLlylOJaCkFwXBt/hpoOkphoJSYYnYZuH64+Q9vHfJKxKLftFnRKW82uyUQwFMKIdkg1QMjgwGImHN8ANsc5Czbd4STVDs7OsM5Yz38TzjXqMnCdJib/vBpXQsSqNAwhCDBhK+cCJwEzixfMPtk39cLnPuVZMpu3Hoy/dvcCCemvlc+bbd68IdXUvVYQCokxLQQPwHfnui7Cj8WTcsTlhdU1oqJXcoAoRc2FLNerKLptZgqY1jBkVB61KmefoOF7qO9Dv5gbihK5+6cMzsHFg8gLQlgAYQAqduhElaCQlppgN5BUf9xMVTDZv1XKJsTBzrtYKYzWkCGwPKb8bKCtrjJavxFZ8BToSaGWq+OUXYx+0fOVtgvYbbiWJVRQhxfRaFxoFJVG/pqw1gzsV5CwAEe9rsgyBjGOhrYBKyR9RBddgHyY0gicoAtEhQE2pvIafEZpWvfbbfp/fuB+G8e/7loy4TXYJz/D2KbOpV5CGn5PBTRCsA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(8936002)(52536014)(54906003)(2906002)(7696005)(9686003)(508600001)(86362001)(6506007)(186003)(83380400001)(5660300002)(26005)(316002)(33656002)(38100700002)(66946007)(4326008)(76116006)(110136005)(66556008)(122000001)(38070700005)(55016003)(66476007)(66446008)(8676002)(71200400001)(64756008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q7j5Cvz0IDGEJoAG+XDrsPxG8MmPH0KSZqsqUPbx82p/8CEuC0jCBLi9MvzD?=
 =?us-ascii?Q?ciV900LpaQFEDVlDwMS6BA9gAdgT0GsCtjAwhy8UruafNS0ZUU0KLPddPUJa?=
 =?us-ascii?Q?4r74Tu7rPeUNC824uIH/hdRw6/lK3WIColrXjK2jFijCTV7KyhLBSkZdmqfA?=
 =?us-ascii?Q?9T4/zqu6A6VramtSdosRW4OacIVAam6LDXHJ84fv5aL40LAc/se1bKHTMA3N?=
 =?us-ascii?Q?oiLKVGgMJE+qYSvXlhH2etyKwkISTNwxJBxWR7yHQKbPoedmaIA02h9Uf5Pe?=
 =?us-ascii?Q?VxGx0m+VHoebeRLay5RJn8U6YawhwhNCkVGg+pKTiF2y3EtgNmx6G0uC/UDn?=
 =?us-ascii?Q?l9ssLWjLGTG/9/Vw1l+R3hqvskbpgsGIpDEP7cYrJLN2jDOKU/RN8JjqR4yz?=
 =?us-ascii?Q?QY86SKglBohEcJOa5zAomJgLXahhUQU4WzGWzZAtYQpuWFMYPYtZnm5INA26?=
 =?us-ascii?Q?BsAddnnzYBH1tHAouX2YyI3bX+Td1V4wMfbBAYctZShByXy/IeHsQhqyzFL5?=
 =?us-ascii?Q?xr4KmQtqYgW3s2w8c98Z2T+/o/FAApBidwBNXkKzkgubxSlw93jszsjgYMB5?=
 =?us-ascii?Q?QySxn4o5UMIaP1/FxuxVasQV6+VhOd+ZofyyhnyRB/9AiPwveRBU4DqsrYTl?=
 =?us-ascii?Q?WyasqnahIxQbivBwHOa1VQ25Serui3wFXCHmDHRfiCcTHWIUj/F5A7dxmEqm?=
 =?us-ascii?Q?KuouZGPuwlK1bXAkhmousNwB1UBKnPl0jFkXlNpc1bpLVFE92L3aTHBftM8Y?=
 =?us-ascii?Q?OecCtopyx4X8o9Xh+X+I22IRGsLnmQpW37ega/UQl8HD3AyUjCvv8AgJd3q6?=
 =?us-ascii?Q?hlQEDM+zzB8x4mYbzmxYdalE9ZQfdn7sGCIs1VAmFx7pRA2OiJsCHB5/BzOZ?=
 =?us-ascii?Q?WwSdbBmvfTEpB07TWAYridUpAFux1ZqGXZzxoxcDKTjR2bLGeDD7uZXSGr1P?=
 =?us-ascii?Q?zvRv0r+wT8MzCDjWFRrOBBUiGmGJVwBh2nvkvMHQZgeO5O8hyPhBiFTRt1mm?=
 =?us-ascii?Q?chaBPW/a0Jx44BCzPyjZWG30Xtq5qOu5nMWfCXUTrE1BQIHrWkO9GSAnICHn?=
 =?us-ascii?Q?pW/4tdvC5jUZfkRx5YkglSvWDbfxXMMnPsS/TOaP+6WminwNcJ7/z+pN/Yix?=
 =?us-ascii?Q?OWOK41zr6Yhk23jMuavHTB2uQCWD+EUs4l9E1sJTReS7Xo4KmT7b17+v4Is2?=
 =?us-ascii?Q?MkztCO9C9XP1wG8gdxJu+hd75ORxQfZ4lkt6bt/lOuACz21fF58e3tWp02Ql?=
 =?us-ascii?Q?sxxJ60ZyUYi78uJgmty+zlx1yY4RMPDOby+ZaOc9VdBGgzskEJgBHZGMuXbk?=
 =?us-ascii?Q?u/enkx0yDBqrMdWssK8/uaDAm+jXeQhSWAjmKo/yzBpkdHaEegavuxgBRiHw?=
 =?us-ascii?Q?ZSdxtDUWkosVAtdGf7ysdR9/cOJDF5d5YNFfbg0lulD3gi3+2Ki6AEIunDLm?=
 =?us-ascii?Q?u6qBos4xYDnpt/K3r5sivxfHRPjBBcQwxvVxSE3i4g+601HgbjbixXZjhdoc?=
 =?us-ascii?Q?osgJCA2LWxKfg9/EPBqV1xbP5cg8YB8G02W8kZg5v8IjrQHwHJSN99M09dsF?=
 =?us-ascii?Q?YcojNNHwSSQYSALJ691HNDPon/eP9N6ttVqJ5sxmehpC8VB24sbkHYNmPigS?=
 =?us-ascii?Q?uUFpaREAAMSHhHdojICG1IAsjSrAJhnXojeLhQeFKX0av4d1lFMw5K1QLPcP?=
 =?us-ascii?Q?/ebA2fQaM6TN7whdivItOG9V/kkj/mQVRdroTQ55txuW2iTT0gqJ7QVlO2vB?=
 =?us-ascii?Q?8SNCPWUcZQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e46648d-83cf-43ad-8a4a-08da495d6f03
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 14:44:46.9323 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tjd4dOaq9c7sahQ+je8BTVsLjgJE1R5rQ37v9gA1diSJtqzUvqWd68MTBOAAvJh2jU2Ds4W1z/e8yIv6csI1dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB6555
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Thu, 09 Jun 2022 07:22:03 +0000
Subject: Re: [dm-devel] [PATCH] multipath.conf(5): add disclaimer about
 vendor support
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> -----Original Message-----
> From: Martin Wilck <mwilck@suse.com>
> Sent: Wednesday, June 8, 2022 2:58 AM
> On Tue, 2022-06-07 at 17:32 -0500, Benjamin Marzinski wrote:
> > On Tue, May 31, 2022 at 10:39:05PM +0200, mwilck@suse.com wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> >
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Steve, does this address NetApp's concerns properly?
> 
> Regards
> Martin
> 

Yes. I think this is a good addition.

Thanks,
Steve

> 
> >
> > >
> > > Add a disclaimer to clarify that entries in the hwtable don't imply
> > > any
> > > obligations on the vendor's part.
> > > ---
> > >  multipath/multipath.conf.5 | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/multipath/multipath.conf.5
> > > b/multipath/multipath.conf.5
> > > index d57c810..c2d34f1 100644
> > > --- a/multipath/multipath.conf.5
> > > +++ b/multipath/multipath.conf.5
> > > @@ -1490,6 +1490,18 @@ section:
> > >  .SH "devices section"
> > >  .\" --------------------------------------------------------------
> > > --------------
> > >  .
> > > +.TP 4
> > > +.B Important:
> > > +The built-in hardware device table of
> > > +.I multipath-tools
> > > +is created by members of the Linux community in the hope that it
> > > will be useful.
> > > +The existence of an entry for a given storage product in the
> > > hardware table
> > > +.B does not imply
> > > +that the product vendor supports, or has tested, the product with
> > > +.I multipath-tools
> > > +in any way.
> > > +.B Always consult the vendor\(aqs official documentation for
> > > support-related information.
> > > +.PP
> > >  \fImultipath-tools\fR have a built-in device table with reasonable
> > > defaults
> > >  for more than 100 known multipath-capable storage devices. The
> > > devices section
> > >  can be used to override these settings. If there are multiple
> > > matches for a
> > > --
> > > 2.36.1
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

