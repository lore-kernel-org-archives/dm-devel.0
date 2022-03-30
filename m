Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E5FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 16:32:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-_NOyd6ftMNO5lNBB__PO0w-1; Wed, 30 Mar 2022 12:32:32 -0400
X-MC-Unique: _NOyd6ftMNO5lNBB__PO0w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 986E22A2AD66;
	Wed, 30 Mar 2022 16:32:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D47742D3A3;
	Wed, 30 Mar 2022 16:32:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D4AB91947BBB;
	Wed, 30 Mar 2022 16:32:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83F501947BBB
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 16:32:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6266E40CF915; Wed, 30 Mar 2022 16:32:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D45640CF8F8
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 16:32:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 339D4899EC5
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 16:32:28 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-Cla37JO-OaC9Oi60tcI1QA-1; Wed, 30 Mar 2022 12:32:24 -0400
X-MC-Unique: Cla37JO-OaC9Oi60tcI1QA-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-5SyuT2RaPR-du8Mg1Mc2zw-1; Wed, 30 Mar 2022 18:32:14 +0200
X-MC-Unique: 5SyuT2RaPR-du8Mg1Mc2zw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM0PR04MB4707.eurprd04.prod.outlook.com (2603:10a6:208:c0::29)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Wed, 30 Mar
 2022 16:32:12 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::7891:cf1e:2bf:a180]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::7891:cf1e:2bf:a180%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 16:32:12 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [RFC PATCH] multipathd: Don't keep starting TUR threads, if they
 always hang.
Thread-Index: AQHYQ+Vdq04RXybMoUS5JBNbIEsFDqzX/qt/gAAg84A=
Date: Wed, 30 Mar 2022 16:32:12 +0000
Message-ID: <01a954f73ff7cdc68bd9c5f1a391af225beb7f80.camel@suse.com>
References: <1648610530-28526-1-git-send-email-bmarzins@redhat.com>
 <f17860010d25b1fa5abee0e6e3b98df2f8319647.camel@suse.com>
 <20220330143405.GQ24684@octiron.msp.redhat.com>
In-Reply-To: <20220330143405.GQ24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26f5693f-3d0f-41b9-a2d2-08da126ad813
x-ms-traffictypediagnostic: AM0PR04MB4707:EE_
x-microsoft-antispam-prvs: <AM0PR04MB4707F2486F7817B61AABF014FC1F9@AM0PR04MB4707.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Rei6TmBvOYFjxHCFopO7QeNJzY4lTdarP9IXYZsfzELrcMDhuabkI/RXdr4rgpg9YI6MiVO2HEkO3HE7ruMxRMkxkOEFDn0WqOK94ki9JqycbHR6D6s61Gk65yhngZykTDcsZbRmUsRDo1myLHS4nhYHueBwRfFLo3fMNchoZcZfoeiMARR+SZGbJPgBckSz4AgJw5eQ6BmGeBcCMcQH9jzDhSM+UDOMKDJQnXa8KTWL1LZiGe86rDt4BQBdtsuv/uNiReio1NU6NfDT6WmdHjf5OAbKJ+zFge9fDIcaFNuMpQ9DgdlvBqxTrDMj+m9pE+0Xsz6QvBDcef6hTLGuMTv/bN5QyQ0LHa4pe9ZuRumU4f2VdbfDF8+aZeGT9mLEwVB2HG9QqpCrbiIzk63ocINDCiHjr5+FNJOuFIYX76DdNf4iqKS+R9cxGVy1x53QkshIL7uNdK2TEmg85VBoxBkxiN2esodH1f6n0MSzq3Mv7vOD0Zq8IenX5QuQo6JfCxwQ5lYf5wCOEjQpyEm4flEQuWsv/HO2389jGyBQHb3WiCs8Te6SF2X8KpwzsXNP2LjVNt0sOtmJ90SSi/n1w7N4U2NBpaHETElvO4nzR8ttIYfAlN02dzsiEw3qTATR2CdRKLUMBvG48uPiRRQC/xgtCCIGmp7FKSDqdguUSG6vWG2+lXB/qqN8Jicl5k1Go8jOS8dMHD8VkjS1HLmcKg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(316002)(2616005)(66446008)(64756008)(26005)(186003)(4326008)(54906003)(66556008)(8676002)(76116006)(6512007)(6506007)(36756003)(91956017)(66946007)(6916009)(8936002)(508600001)(83380400001)(5660300002)(71200400001)(38070700005)(2906002)(122000001)(44832011)(38100700002)(6486002)(86362001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?ONyDv/2fRsNwsdr/mWiY9WChDBRR4S4oeOB716TCjOU/UeGIIk5GMXBVJ?=
 =?iso-8859-15?Q?9Y+BT0TcIYlwu6qjjHq7li4WWePj44YrtUqXFC6e/1U0JHVhwiCny8y4O?=
 =?iso-8859-15?Q?0Pcktnyg805OM+YOlaFlSH1gqdD3dt73VT8h2rXPekJXizjXWxNn8CvIX?=
 =?iso-8859-15?Q?FfE+cVPM3XFmNVZJkkjdypYPPsPbcOk9/bxyAZ2CzJlard0wAWhCJtZwD?=
 =?iso-8859-15?Q?QXCb4l1vfOo1y/tvazb0LuJVEpViBBohow3U2y7xUVy3okv3YvoAZqJ5K?=
 =?iso-8859-15?Q?vReiW8ZwURH9EB1SRd8CjE1TuqH/EW05bNXxAENKTQPUp1CYBvDksc+lt?=
 =?iso-8859-15?Q?jtSGYL+1xmV1N+hIqdNmrv5ufTS36gzOzrG5inxpxKfZHhthOLlJuXipU?=
 =?iso-8859-15?Q?fcfENzaqwIDmKhwpzEWe52rDceqU9G/7bj9+WBFFvJXtXK8gL1gTADX0E?=
 =?iso-8859-15?Q?N9Knq6tM2iJSGIhPgBwc7QwXpVFnLusM+gQnzh2+74UY/VKS3tn/Zb3PS?=
 =?iso-8859-15?Q?H0PLqGG61K4JIovIOomJxotw2jxUho1mYPawbOZRe5M4DFP/3hGVobSiX?=
 =?iso-8859-15?Q?qoIyadK09JxMXNBT/6fd9mCOXPz7b3o4pwjyovexPWXPVhOt8wyMe8X5i?=
 =?iso-8859-15?Q?uCvHn2qBVkbE8JMdoGFLsoeQRtcGRXHy/SItFBsOPL7amXxIpLm2iFCTB?=
 =?iso-8859-15?Q?ZGprj1QFZ706n9ximxeYPa7ZZoxlH3C63CVarBqacKa8wrAwzlDugVKkX?=
 =?iso-8859-15?Q?26mFuWhLcDwusCuqklmuvt7MjNGKewNTuayMmuc1+qJlgmXClVzWzWdX+?=
 =?iso-8859-15?Q?q/vnlyf+1AaRU54PS3/FXZ1OBYxflsXKTtWzTJZu7ZWaLdbOjA25f/gpj?=
 =?iso-8859-15?Q?YGRlr8H9PEDEJ8qOa7N9okRbkf4eldzcEesji9kIRbiuH2wypH6KehEdK?=
 =?iso-8859-15?Q?l5ZlwtFL6XoQ9Dn3oZH3zw0oezBWW0429hHg6pFbrPhePsAz0lF/N8Fg0?=
 =?iso-8859-15?Q?+wc9JikCUaq6lXRBzA8waX/3gd+Mkia7gBvmauP7yYnXV5m82vKFxxFvn?=
 =?iso-8859-15?Q?uDroWKXJMsu0ViB7quPxPDD9rdJr7kivonApe67XeJ3K+SiO++uEJg1oA?=
 =?iso-8859-15?Q?0uTNwkS7vje1dZZkRd6iblDSgeWJgwaGkpx0zqjGxAniOcSOUlyoCxZRB?=
 =?iso-8859-15?Q?v+sjyiPzDsxHFXLyQS2lfaFdopENzNT8jcSsn5Hgj631shzhNXIZStSYG?=
 =?iso-8859-15?Q?gunUANkh0L6teky6TeJF6q0fQSQ7geubFKdtwqOfzPBu9BPGETWdhZnFh?=
 =?iso-8859-15?Q?miki7SJBU2cK7PLsTTY+TWYlP2E/99qICfgTxtKOe6q25kk02TAJUUd0E?=
 =?iso-8859-15?Q?kaSLWnooaAbPbUTtyDf1UnGGhISw545s3wzsNzntDNn6xrVdxaai2wUmo?=
 =?iso-8859-15?Q?FLGuAYb7zDwzMs9F3k5ymManxa2wq/mlCx7g3JPWlTL7nJu0CQymQbETW?=
 =?iso-8859-15?Q?d4D88glM35ptdfObguYmxdTQrUne8jtuFUMXxwwxWOB0krKVw+FyLWPCm?=
 =?iso-8859-15?Q?PODG9AMwIENI4DrlN6WCPr0v8Ol/uTzVUNQIcoXwDWd6mcSAZbwtlGTpJ?=
 =?iso-8859-15?Q?FTvF6jPb2lx+HnqWKu4Uov9m5K3RijOk1/Z3AQ2aZj8Z8S+7tbfw37lDb?=
 =?iso-8859-15?Q?aZMninMfTyMPWZBAhYTGW0Ww21H+5g55ux5n2cTaV+RrZlaBtLWRglOCf?=
 =?iso-8859-15?Q?WsoYclVvhM8SaMkaILrhcDAc/RkCimyGfurNd8acVCmFIi8Z55kBke0Sv?=
 =?iso-8859-15?Q?blQh8Aiv00qRqgivHsroJOVC7N9nUMAfwIwsimcq4N6aYR9POTiOmi6zR?=
 =?iso-8859-15?Q?7H8I=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f5693f-3d0f-41b9-a2d2-08da126ad813
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 16:32:12.3908 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EEaWKNlXn+9t2EZt+l+BZMcNyatQcHQCN+aLmwJZicWYYMlUVYLySp6tsqoB7MABXAL17ctwb5UNYJ2pEMTWUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4707
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH] multipathd: Don't keep starting TUR
 threads, if they always hang.
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <13587239EBB87745BF7A2E9275936A41@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-30 at 09:34 -0500, Benjamin Marzinski wrote:
> On Wed, Mar 30, 2022 at 09:44:39AM +0000, Martin Wilck wrote:
>=20
> >=20
> > Why did you choose 1? Perhaps we should make a few more attempts?
>=20
> Oops. I forgot to include the Notes when formatting my patch (I need
> to
> make that the default). Here they are:
>=20
> Notes:
>=20
> =A0=A0=A0 I'd be interested in knowing what people think of this solution=
.
> I'm
> =A0=A0=A0 open to making multipathd start more threads before it gives up=
.
> We
> =A0=A0=A0 also could make multipathd save the contexts from the stalled
> =A0=A0=A0 threads, so that when it stops creating new ones, instead of ju=
st
> =A0=A0=A0 waiting for the last thread to complete, it could start up agai=
n

I wouldn't recommend that. We drop all references to the old
context for a good reason: to be sure there are no races when the
hanging thread eventually does exit. Keeping such references would re-
open a Pandora's box which we sealed and closed in 2018.

> as
> =A0=A0=A0 soon as any of the outstanding threads completed.=A0 We could a=
lso
> =A0=A0=A0 consider not stopping creating new threads entirely, but instea=
d
> =A0=A0=A0 having a delay before we create a new checker thread, where we
> wait
> =A0=A0=A0 for the last thread to complete.

I wouldn't do this, either. The hang check is not done immediately
after cancelling the thread, but in the following libcheck_check()
invocation. That means there has been some delay already when we do the
check, at least a second. And this cancellation happened after the SCSI
timeout expired, anyway. How long are we going to wait for the normally
instanteneous cancellation to complete? I like the "just forget about
this thread" attitude which has saved us a lot of trouble lately, IMO.

> =A0 If the delay doubled after evey
> =A0=A0=A0 consecutive timeout, the number of threads created would stay a=
t
> a
> =A0=A0=A0 more reasonable level until someone got around to looking into
> what
> =A0=A0=A0 was going wrong. Thoughts?
>=20
> But to answer your question, there was no obvious number to choose,
> and
> you can make the case that if it fails once, that's a fluke. If it
> fails
> twice in a row, then it's likely to keep faiing.

That makes sense. I'm fine with the patch.

>  But I'm fine with
> picking a bigger number, or any of the other possibilities I listed.
> I
> just wanted to throw something out as a starting point.
>=20
> -Ben
>=20
>=20
> > Other than that, this looks ok to me (assuming you've tested with
> > the
> > code from bdf55d6, or something similar).
>=20
> Yep. I tested it with the zombie tur checker tests, with different
> sleep seconds and intervals.

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

