Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7712DC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 18:56:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2A2822D04
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 18:56:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2A2822D04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=northeastern.edu
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-pn9D0GtBMbOaN2msdsIH4Q-1; Tue, 05 Jan 2021 13:56:46 -0500
X-MC-Unique: pn9D0GtBMbOaN2msdsIH4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 434EB803626;
	Tue,  5 Jan 2021 18:56:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22F0A10016FB;
	Tue,  5 Jan 2021 18:56:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED9881809CA0;
	Tue,  5 Jan 2021 18:56:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105GGY0p022716 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 11:16:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4F45C112C275; Tue,  5 Jan 2021 16:16:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 458B81004050
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 16:16:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 215DD811E86
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 16:16:32 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam12on2116.outbound.protection.outlook.com [40.107.243.116])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-teJ2_IJfN5Wbzz-dymEejQ-1; Tue, 05 Jan 2021 11:16:28 -0500
X-MC-Unique: teJ2_IJfN5Wbzz-dymEejQ-1
Received: from BL0PR06MB4468.namprd06.prod.outlook.com (2603:10b6:208:29::21)
	by MN2PR06MB6638.namprd06.prod.outlook.com (2603:10b6:208:1f4::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21;
	Tue, 5 Jan 2021 16:16:26 +0000
Received: from BL0PR06MB4468.namprd06.prod.outlook.com
	([fe80::f0f5:3e54:dbcf:3e59]) by
	BL0PR06MB4468.namprd06.prod.outlook.com
	([fe80::f0f5:3e54:dbcf:3e59%6]) with mapi id 15.20.3721.024;
	Tue, 5 Jan 2021 16:16:26 +0000
From: "Desnoyers, Peter" <P.Desnoyers@northeastern.edu>
To: Bart Van Assche <bvanassche@acm.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Christoph Hellwig <hch@infradead.org>
Thread-Topic: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
	BIOs to userspace
Thread-Index: AQHWzxb+zDFhaF7NmkqPy8x71otHxaoZWRew
Date: Tue, 5 Jan 2021 16:16:26 +0000
Message-ID: <BL0PR06MB4468B018111B0FAED922485D85D10@BL0PR06MB4468.namprd06.prod.outlook.com>
References: <mhng-97fc5874-29d0-4d9e-8c92-d3704a482f28@palmerdabbelt-glaptop1>,
	<6fb5be2d-c6ca-c21b-dddf-9b314973dcfe@acm.org>
In-Reply-To: <6fb5be2d-c6ca-c21b-dddf-9b314973dcfe@acm.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [65.96.162.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b79f730b-0df5-45c1-4a73-08d8b19540b0
x-ms-traffictypediagnostic: MN2PR06MB6638:
x-microsoft-antispam-prvs: <MN2PR06MB6638795E8B18733192307F3C85D10@MN2PR06MB6638.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zWO7cZ4NmTQNN5btCTWjnGj6lJIeRKkyXEH2IibOsIQo42LT9fOgH/fs2c+sRAiwEq+eYnJuVbF4lh9PR67JV77E1a96rHtms6+dkK5lsiHfGQX1mdD3WpA/YtoMOKHg3R2E3J/4gt8SnZVu62lR/ugeaC7R+pZboTMHZG6P2fj5bNaRBlyWM02OP0KfHtm/PmN+eESRf5XxzbcR6rAjhXawoos33wUW/Ii+EdVk/hXHqRO18FkPZbHN78f9zrJdT7LCtdYxsqjUFZ8ebw27xBQ4d2GMWk/sbxx7ObgVgInu5KMuNbV6wYyzvQUOtGJ0uONzQUvtu5zdU0oiZmM+2oJfCQL7T243BYDEuiDoeFwBmIBIU+BIYBYYXyCH/G2/UhsTRuTZyDsyMEtYP4idHg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR06MB4468.namprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(8936002)(7696005)(66946007)(5660300002)(71200400001)(76116006)(316002)(4326008)(66556008)(66476007)(66446008)(26005)(55016002)(7416002)(83380400001)(75432002)(64756008)(186003)(9686003)(19627405001)(478600001)(2906002)(33656002)(86362001)(6506007)(786003)(53546011)(54906003)(52536014)(110136005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?r7mObrMw4HKoRgEP6yJfdlVDxjjSA+lQYYAwZfA/cKkvnCrsm1RqvG2ofu?=
	=?iso-8859-1?Q?Y4ZvaDKeMmy/3DiW8OUx1qMM3jPnRVCLU86k4W0aOiIhgjloqBTkD2VxQD?=
	=?iso-8859-1?Q?LS+9haCREEDiA0+Zo8fl28ps721ivzsNBIDa57elgPLU3LmpKOwNQzi7hD?=
	=?iso-8859-1?Q?LfxyZ25GfxjwQvA/ePg+Ny6XLvMbLCRgCQRiEsAydQH//w3DtKeeGf/v1a?=
	=?iso-8859-1?Q?2n/gNBGc/t1dneKzwqlyPxNvOlp6HoysmTRNAvluHkF+mGPJhnRSE0ipE6?=
	=?iso-8859-1?Q?humRIHF5vnpMviAvToW8QH3ygN2XqJZgOQ0XKEk8eTEcNaMlZSyVfs4V0+?=
	=?iso-8859-1?Q?PKCN5ZmZecd36iPrqeecWQgoCS0biI5eS/jEbpeIqKnOid3Z2ISXT8SGcj?=
	=?iso-8859-1?Q?d4ub2nkonA4nGtYgbKvCVKe1dl1RkaFxrHiNhbwnNvR+9L/foZWZfvH1c6?=
	=?iso-8859-1?Q?wf727PxL65vnyyP+RDgdM5jfIdjSVnum8oSxXWmmwRmLD7e2rEfCblEkn6?=
	=?iso-8859-1?Q?RiYnUJgykxE4OkjA5qId8Bg2MQr5Lrd+dQ0gCPPqLH89alr/5V40dk3xUt?=
	=?iso-8859-1?Q?h2Lf9y/prd6eVyA2b0qhFgJfPQ4nu4PAZc6ky133W15t3R5jYoO8dvrBlc?=
	=?iso-8859-1?Q?6ee6Kh+l1bpjpsfYpw2299jmJXUiiDVMDhLbXQ+8nDMcf0KMVyGCzI8LW9?=
	=?iso-8859-1?Q?sYfw1e8MdfwRCG7uVSCFx/D2JuxoBH+/1aE19yLx9rdMTntPH86rg/Og2U?=
	=?iso-8859-1?Q?uG/SwfN9roPaYyP+TM5b0hPXMjYbI8K1kbjPL2d3ykUqINLmXYzCf+qEsa?=
	=?iso-8859-1?Q?fs+YYAWVFsAZxSUBNsBMtd+BdAwaTJToh3AkZ+M9k98kdUB8mZyWcxVvr8?=
	=?iso-8859-1?Q?3l4yKFX5tFZt1MARPkepThpo6Dsvq8H41/6pBqNtg1sPAO/lO6Xu5JW/Y3?=
	=?iso-8859-1?Q?Lh9suO3/lnRPmyTKUcuikjf4pUwxH8mGab+rx3McgqXnIvZwVgvszOyBHA?=
	=?iso-8859-1?Q?KNLWoyu6px3GIcVo0=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: northeastern.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR06MB4468.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b79f730b-0df5-45c1-4a73-08d8b19540b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 16:16:26.4854 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a8eec281-aaa3-4dae-ac9b-9a398b9215e7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qif33IOHHtVJA0K9QOnR4ACpU5gW73Pld2IPNZcEXh04IHc+gORL69XyR9c/ib2UMME2cE9MUuV7Ah0zrLb9km/ScV1hVMyTCmrfwcsAvsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB6638
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 05 Jan 2021 13:56:30 -0500
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"kernel-team@android.com" <kernel-team@android.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>,
	Mike Christie <michael.christie@oracle.com>
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that
	proxies	BIOs to userspace
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
Content-Type: multipart/mixed; boundary="===============9082468260063687575=="

--===============9082468260063687575==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BL0PR06MB4468B018111B0FAED922485D85D10BL0PR06MB4468namp_"

--_000_BL0PR06MB4468B018111B0FAED922485D85D10BL0PR06MB4468namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I seemed to have missed this during the OSDI and end-of-term rush. I've imp=
lemented a couple of user-space block device components for research projec=
ts, so I thought I'd weigh in.

In particular, does this offer significant advantages over TCMU? It uses th=
e UIO framework for a ring of SCSI requests to user space, and seems to be =
quite efficient. The differences seem to be:

  *   dm-user is at bio level, while TCMU is a SCSI device, so like NBD you=
 get request merging. Depending on your purposes, that either does no harm =
or is really useful.
  *   TCMU requires either accepting the entire tcmu-runner architecture an=
d philosophy, which may be a no-go, or writing your own SCSI implementation

(I'm actually really bummed that I didn't discover TCMU until recently, as =
I think we would have used it on a few research projects in the past.)

I have no idea whether you can hand things off to another process - I don't=
 think the UIO framework would have any problems with that, so it probably =
comes down to whether the target_core_user module would allow its memory re=
gion to be mapped by multiple processes.


I've got the world's quickest and dirtiest SCSI implementation that I've ha=
cked up to use with TCMU, although the only real experimentation I've done =
is by hacking tcmu-runner. I'd definitely be interested in talking to any p=
eople who are interested in this, to develop a proper SCSI library that wou=
ld allow you to use TCMU outside of tcmu-runner.

________________________________
From: Bart Van Assche <bvanassche@acm.org>
Sent: Wednesday, December 9, 2020 10:38 PM
To: Palmer Dabbelt <palmer@dabbelt.com>; Christoph Hellwig <hch@infradead.o=
rg>
Cc: snitzer@redhat.com <snitzer@redhat.com>; linux-doc@vger.kernel.org <lin=
ux-doc@vger.kernel.org>; shuah@kernel.org <shuah@kernel.org>; corbet@lwn.ne=
t <corbet@lwn.net>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.=
org>; Josef Bacik <josef@toxicpanda.com>; linux-raid@vger.kernel.org <linux=
-raid@vger.kernel.org>; song@kernel.org <song@kernel.org>; dm-devel@redhat.=
com <dm-devel@redhat.com>; Mike Christie <michael.christie@oracle.com>; lin=
ux-kselftest@vger.kernel.org <linux-kselftest@vger.kernel.org>; kernel-team=
@android.com <kernel-team@android.com>; agk@redhat.com <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies=
 BIOs to userspace

On 12/7/20 10:55 AM, Palmer Dabbelt wrote:
> All in all, I've found it a bit hard to figure out what sort of interest
> people
> have in dm-user: when I bring this up I seem to run into people who've do=
ne
> similar things before and are vaguely interested, but certainly nobody is
> chomping at the bit.  I'm sending it out in this early state to try and
> figure
> out if it's interesting enough to keep going.

Cc-ing Josef and Mike since their nbd contributions make me wonder
whether this new driver could be useful to their use cases?

Thanks,

Bart.



--_000_BL0PR06MB4468B018111B0FAED922485D85D10BL0PR06MB4468namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
I seemed to have missed this during the OSDI and end-of-term rush. I've imp=
lemented a couple of user-space block device components for research projec=
ts, so I thought I'd weigh in.</div>
<div>
<div id=3D"appendonsend"></div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
In particular, does this offer significant advantages over TCMU? It uses th=
e UIO framework for a ring of SCSI requests to user space, and seems to be =
quite efficient. The differences seem to be:</div>
<div>
<ul>
<li><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif">=
<span style=3D"caret-color: rgb(0, 0, 0);">dm-user is at bio level, while T=
CMU is a SCSI device, so like NBD you get request merging. Depending on you=
r purposes, that either does no harm or
 is really useful.&nbsp;</span></font></li><li><font color=3D"#000000" face=
=3D"Calibri, Arial, Helvetica, sans-serif"><span style=3D"caret-color: rgb(=
0, 0, 0);">TCMU requires either accepting the entire tcmu-runner architectu=
re and philosophy, which may be a no-go, or writing your own SCSI implement=
ation<br>
</span></font></li></ul>
<div><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif"=
><span style=3D"caret-color: rgb(0, 0, 0);">(I'm actually really bummed tha=
t I didn't discover TCMU until recently, as I think we would have used it o=
n a few research projects in the past.)<br>
<br>
</span></font></div>
<div><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif"=
><span style=3D"caret-color: rgb(0, 0, 0);">I have no idea whether you can =
hand things off to another process - I don't think the UIO framework would =
have any problems with that, so it probably
 comes down to whether the target_core_user module would allow its memory r=
egion to be mapped by multiple processes.</span></font></div>
<div><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif"=
><span style=3D"caret-color: rgb(0, 0, 0);"><br>
</span></font></div>
<div><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif"=
><span style=3D"caret-color: rgb(0, 0, 0);"><br>
</span></font></div>
<div><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif"=
><span style=3D"caret-color: rgb(0, 0, 0);">I've got the world's quickest a=
nd dirtiest SCSI implementation that I've hacked up to use with TCMU, altho=
ugh the only real experimentation I've
 done is by hacking tcmu-runner. I'd definitely be interested in talking to=
 any people who are interested in this, to develop a proper SCSI library th=
at would allow you to use TCMU outside of tcmu-runner.</span></font></div>
<div><font color=3D"#000000" face=3D"Calibri, Arial, Helvetica, sans-serif"=
><span style=3D"caret-color: rgb(0, 0, 0);"><br>
</span></font></div>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" co=
lor=3D"#000000" style=3D"font-size:11pt"><b>From:</b> Bart Van Assche &lt;b=
vanassche@acm.org&gt;<br>
<b>Sent:</b> Wednesday, December 9, 2020 10:38 PM<br>
<b>To:</b> Palmer Dabbelt &lt;palmer@dabbelt.com&gt;; Christoph Hellwig &lt=
;hch@infradead.org&gt;<br>
<b>Cc:</b> snitzer@redhat.com &lt;snitzer@redhat.com&gt;; linux-doc@vger.ke=
rnel.org &lt;linux-doc@vger.kernel.org&gt;; shuah@kernel.org &lt;shuah@kern=
el.org&gt;; corbet@lwn.net &lt;corbet@lwn.net&gt;; linux-kernel@vger.kernel=
.org &lt;linux-kernel@vger.kernel.org&gt;; Josef Bacik &lt;josef@toxicpanda=
.com&gt;;
 linux-raid@vger.kernel.org &lt;linux-raid@vger.kernel.org&gt;; song@kernel=
.org &lt;song@kernel.org&gt;; dm-devel@redhat.com &lt;dm-devel@redhat.com&g=
t;; Mike Christie &lt;michael.christie@oracle.com&gt;; linux-kselftest@vger=
.kernel.org &lt;linux-kselftest@vger.kernel.org&gt;; kernel-team@android.co=
m
 &lt;kernel-team@android.com&gt;; agk@redhat.com &lt;agk@redhat.com&gt;<br>
<b>Subject:</b> Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that =
proxies BIOs to userspace</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">On 12/7/20 10:55 AM, Palmer Dabbelt wrote:<br>
&gt; All in all, I've found it a bit hard to figure out what sort of intere=
st<br>
&gt; people<br>
&gt; have in dm-user: when I bring this up I seem to run into people who've=
 done<br>
&gt; similar things before and are vaguely interested, but certainly nobody=
 is<br>
&gt; chomping at the bit.&nbsp; I'm sending it out in this early state to t=
ry and<br>
&gt; figure<br>
&gt; out if it's interesting enough to keep going.<br>
<br>
Cc-ing Josef and Mike since their nbd contributions make me wonder<br>
whether this new driver could be useful to their use cases?<br>
<br>
Thanks,<br>
<br>
Bart.<br>
<br>
<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_BL0PR06MB4468B018111B0FAED922485D85D10BL0PR06MB4468namp_--

--===============9082468260063687575==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============9082468260063687575==--

