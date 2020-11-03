Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7B3C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:35:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39FDA2080D
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:35:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39FDA2080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=netapp.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-hHTABBqZPXyNTjDaXomUMw-1; Wed, 04 Nov 2020 02:35:01 -0500
X-MC-Unique: hHTABBqZPXyNTjDaXomUMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AFFA1009E23;
	Wed,  4 Nov 2020 07:34:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4644621E78;
	Wed,  4 Nov 2020 07:34:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA9CB181A06D;
	Wed,  4 Nov 2020 07:34:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A3NFJkL029383 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 18:15:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4A4591134CBE; Tue,  3 Nov 2020 23:15:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45CFB1134CBF
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 23:15:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 149FE858280
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 23:15:17 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-200-vEQHDu2cNOmoh-WVfl5uZw-1; Tue, 03 Nov 2020 18:15:12 -0500
X-MC-Unique: vEQHDu2cNOmoh-WVfl5uZw-1
Received: from DM6PR06MB5276.namprd06.prod.outlook.com (2603:10b6:5:10e::20)
	by DM6PR06MB4027.namprd06.prod.outlook.com (2603:10b6:5:87::21) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18;
	Tue, 3 Nov 2020 23:15:10 +0000
Received: from DM6PR06MB5276.namprd06.prod.outlook.com
	([fe80::cddc:5456:15de:61bb]) by
	DM6PR06MB5276.namprd06.prod.outlook.com
	([fe80::cddc:5456:15de:61bb%6]) with mapi id 15.20.3499.030;
	Tue, 3 Nov 2020 23:15:10 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Martin Wilck <martin.wilck@suse.com>, "bmarzins@redhat.com"
	<bmarzins@redhat.com>
Thread-Topic: [PATCH 4/5] libmultipath: only read 0xc9 vpd page for devices
	with rdac checker
Thread-Index: AQHWqYGhCXEMRQe+r0GhhZnKHjbNT6mwr9AAgAT5lQCAAIL+AIAA7HIw
Date: Tue, 3 Nov 2020 23:15:10 +0000
Message-ID: <DM6PR06MB52762238E540739C940C62098C110@DM6PR06MB5276.namprd06.prod.outlook.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-5-git-send-email-bmarzins@redhat.com>
	<acd021d7918335d91fac742da1f7e604ed3e2ee6.camel@suse.com>
	<20201103011105.GX3384@octiron.msp.redhat.com>
	<9d8889ce2b6491ea58b83c8a3bdf326000e7878e.camel@suse.com>
In-Reply-To: <9d8889ce2b6491ea58b83c8a3bdf326000e7878e.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.187.40.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc9ecd51-4847-4c13-bb59-08d8804e4fc4
x-ms-traffictypediagnostic: DM6PR06MB4027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR06MB40276BC947980661EF3B5BC98C110@DM6PR06MB4027.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3fnEKfHfRaf1ykbep9Ait6QKn6PkwM7JBZJpcvkF4VhUyoNE8i8dtY5RC0CZQQfvZV6W1lfqUfq0sVgB/5jYdHvYSO8Nqr9niuoSiIszxiHF1J5amb6BQsEpINauAeIVmPUPi5rp/7nxHh5mbJiWaHLX6SA0GE5vNlMQUF97CXhpIfBbe2y3EOzd3F8nmmooGCqNbxYWlOGCfidp8wCM/X/Veh1yQw7Yx1TLD71RnY8RUXrx6c1SKaaXv9eowPpPgbM+ZSlNCRHsKdVrcnahEMvm8AK4BF7+PNYA6SqVnPskcY0yfmRxUS5xkq4ztGYGG66/+0NKw/I3drhaxhituw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR06MB5276.namprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(5660300002)(83380400001)(33656002)(2906002)(53546011)(55016002)(9686003)(8936002)(478600001)(71200400001)(8676002)(7696005)(316002)(6506007)(186003)(66476007)(86362001)(66446008)(4326008)(26005)(110136005)(54906003)(52536014)(76116006)(66946007)(66556008)(64756008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: +/Fe9ttKiqnErsJ5qd6FH79Ngjg+d0t/RJc/3C0w5Pur8b3ks2PqkqGXAGJUaCHU5MSr+mC7avl/vAH57SxnSViSRs/MAsSOK48RfysBw/mvgNmveOwTMuPKOqa1kaBAIkZBVnr+prl98u+efBgGfTIBb0Lnx1V8QM9OJNEJ0axSnwUbCvPwjkKbESwRCng4nN8OIhRFgSyG2L/5Zc7Otd0lXAaDDTskkAa6tzvAtYd8YOoD8O49Ah/Z+3BMpY3RzoGkqnKRHBeoiofnhUHdiOfgg96iXKsYh68FMozcNsJI+P53N+xoy5oZSt9vnL4pFMlk5DJct4hfFDHzBtzK5Y2aJ0y6s+f3qU/+HpuZQ7EXK3RajQH9tT//rsNHNbiOmHyIkjJMzz/zb+s/eeI2gkUEMYvtDLRSJX6V8TLvFzL/5rh8csalvd2AFbbtdrnvh3L/IuNGVjH/bkQZRiihdmwlUsSwmmguq+JWIZs1MNWGgf5gMHOVpq6mtbgdSxAwzdDiaV202kcYOMD1Ykx0EnaaJYUGvVAK3g3MVqAPdp5cR++khgtLIIsruuNkWHs/JUWYqLq0448+aDwRqCpJG4D7nqB5QMnIh6o+3rn+dt7WTfa6/6WSLlmEQfFiN/ERw37IVErxsq9/FsGmu7W/ZA==
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR06MB5276.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9ecd51-4847-4c13-bb59-08d8804e4fc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 23:15:10.5513 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zSYzcrTZhaR3cvu/FW9IeiKDx14MA60u9NX3kwx+zEeH4ybtsv2uAkvM+1oKV9JG4ocT6n5EwoZ28Vq0mx+5ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB4027
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A3NFJkL029383
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 04 Nov 2020 02:34:40 -0500
Cc: ng-eseries-upstream-maintainers
	<ng-eseries-upstream-maintainers@netapp.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] libmultipath: only read 0xc9 vpd page
 for devices with rdac checker
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> -----Original Message-----
> From: Martin Wilck <martin.wilck@suse.com>
> Sent: Tuesday, November 3, 2020 3:00 AM
> To: bmarzins@redhat.com
> Cc: dm-devel@redhat.com; ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>;
> christophe.varoqui@opensvc.com; Schremmer, Steven <Steve.Schremmer@netapp.com>
> Subject: Re: [PATCH 4/5] libmultipath: only read 0xc9 vpd page for devices with rdac checker
> 
> On Mon, 2020-11-02 at 19:11 -0600, Benjamin Marzinski wrote:
> > On Fri, Oct 30, 2020 at 09:12:46PM +0000, Martin Wilck wrote:
> > >
> > > Suggestion: we could try to retrieve VPD 0 (supported VPDs) before
> > > checking VPD 0xc9. That would avoid the errors on non-Netapp
> > > hardware,
> > > while still allowing us to autodetect RDAC systems that are missing
> > > in
> > > the hwtable.
> >
> > When this idea was brought up in discussions about how to solve this,
> > there was a worry that older rdac devices might not not support vpd
> > page
> > 0 correctly. I'm not sure how valid that worry is.
> 
> These old devices should be in the hwtable.
> 
> The algorithm would be something like this:
> 
>  A) if hwtable says "rdac", goto D)
>  B) if hwtable says nothing, goto E)
>  C) otherwise use hwtable settings, END
>  D) try VPD 0xc9
>     1) if it works as expected, use RDAC, END
>     2) otherwise, goto F)
>  E) try VPD 0
>     1) if it fails, goto F)
>     2) if it works and page c9 is listed, goto D)
>     3) if it works and c9 is not listed, goto F)
>  F) use defaults, END
> 
> I suppose "hwtable" means all built-in and user configuration here,
> including "overrides". But I haven't thought that through yet.
> 
> Cheers,
> Martin

I think Martin's algorithm would work, but it would also be safe to use
VPD 0 in all cases as rdac systems have supported page 0 for well over a 
decade. I think having "hwtable" include user configuration would be a
good choice, so that new rdac devices could be specified in multipath.conf.

Thanks,
Steve


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

