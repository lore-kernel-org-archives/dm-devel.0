Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE42BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:23:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6EF826126A
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6EF826126A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-nMTERkEqMl-PCplEmGswiA-1; Thu, 18 Nov 2021 10:23:49 -0500
X-MC-Unique: nMTERkEqMl-PCplEmGswiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3081A102C8D7;
	Thu, 18 Nov 2021 15:23:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F07A66788F;
	Thu, 18 Nov 2021 15:23:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F81F180BAD1;
	Thu, 18 Nov 2021 15:23:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIFMRp1021578 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 10:22:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DE2892166B26; Thu, 18 Nov 2021 15:22:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D638B2166B2D
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:22:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7E5B80A0AF
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:22:23 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-162-h-TFoTZNOBWdZlz35CIrpg-1; Thu, 18 Nov 2021 10:22:20 -0500
X-MC-Unique: h-TFoTZNOBWdZlz35CIrpg-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2104.outbound.protection.outlook.com [104.47.17.104])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-28-wy9xEwA7OTS461p-HMV-sg-1; Thu, 18 Nov 2021 16:22:18 +0100
X-MC-Unique: wy9xEwA7OTS461p-HMV-sg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5228.eurprd04.prod.outlook.com (2603:10a6:10:1b::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Thu, 18 Nov 2021 15:22:16 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Thu, 18 Nov 2021 15:22:16 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH v2 0/4] Add "reconfigure all" multipath command
Thread-Index: AQHX2/JtREPPydXWd06vt5l1CDRr26wIMbsAgAAd0ACAARizAA==
Date: Thu, 18 Nov 2021 15:22:16 +0000
Message-ID: <1e941b63a3997a001caf8261581f357ad704ccba.camel@suse.com>
References: <1637181217-4423-1-git-send-email-bmarzins@redhat.com>
	<c78729cd320b2a8dec4414c389922ec1e41ff13d.camel@suse.com>
	<20211117223736.GC19591@octiron.msp.redhat.com>
In-Reply-To: <20211117223736.GC19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2abd64ef-095c-41d6-37bc-08d9aaa7346b
x-ms-traffictypediagnostic: DB7PR04MB5228:
x-microsoft-antispam-prvs: <DB7PR04MB522871875EB417BC2C732F48FC9B9@DB7PR04MB5228.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Drcur43mEEDkOGWxaG3Q8vX9Nv5hcqcDoVSBg10pLnSJB/6Yf1fHWE/mqxrTm6tDOkCJJzW1aQRsTUOg04lHHT9bIs1DBeZLUMcy+HuN2e/i7G5JTCO+FF9AvGk41APSw/TdxXPVPxnoTopuzhj+JkDzTMFAnn1ajdP39xaOLWroRsM+hKB9TvL5H2GgiFyz369dKeiSrIILb4vlBWODnags9f3ZrK8ETCxvr/lJhxbUd2MkHsknKhkKNGQAvfpmLrEbMujqioyTeTKJ60rRyepePpI+nVLuMAqKxm2H9dfEoJoDHX0876rzM82MLqZ9L8gXZowKuiaYCgjk+KDrtJTTNeFGUttkmF9JE51F3Q1WGEQwjUIO6CCXn/MGCubbaLPXOqRr+KAmv+k+5QN5t+B5Hoy/C5k55s1YPLJ4oIXpvv1wWsT0CvdBEqalMH+C1E2Z5OMdmIhtFwmtX5DCrMnLSE94zLt0dnq9pe9pKz+OMBKzS4xSlRoVt00dC3aHnHkAFsPVkU4Zurm5fe7hihW6kG7JpcppmtqDCK3ZUtOtVIGrDNrD9x03p9ACSceRhAmgnH9/GeqphUJUXB6MtalsBCBvf3pzWUswbH9kcBpQfh5haCgg82hTUX/45YEYyfcduggWp7cSTTk1tVLAzCZYt9K0q218kn08bU6klj//YSvso/z73mI4s1a6Hif2mF/6mqXZF4W5R3mJvXqx/g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(508600001)(36756003)(54906003)(86362001)(6916009)(316002)(71200400001)(5660300002)(38100700002)(91956017)(83380400001)(122000001)(8676002)(66446008)(6506007)(66946007)(38070700005)(66476007)(2906002)(66556008)(26005)(186003)(6486002)(4001150100001)(44832011)(4326008)(64756008)(6512007)(2616005)(76116006);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?aiAgAaIfI5klFz9dpZl8hsNk1YUXMep84B8FJa/P5+uJpftjRGt05PTDh?=
	=?iso-8859-15?Q?WI9LaPBCm0S03Fiz0AVKNQxiYYkuBLEOM/7g4Rd2OaEiJ8MqzRq+mIyRs?=
	=?iso-8859-15?Q?LsqklsqeaZ0bHTjptANeruIB3r27Uvsusooo7c6EXTh+eu2cBdzei/dSH?=
	=?iso-8859-15?Q?0tD+SrrO3prxIKklJ0vj5PVJ8rcFojI6wS2ESviHEyMhG5uLi33SBX24l?=
	=?iso-8859-15?Q?43DUX1W4GfR4PsjbTAzaqOi8E2WevQY4R/8/DxAkrrGEUOJQ19Bfmn2PB?=
	=?iso-8859-15?Q?WVu01xJERdy43Nmh8FW870zvpuPqd/dId+DJ+DKI45fxFW23qfePA61x2?=
	=?iso-8859-15?Q?z59aYi8KCW90ffvwPgp76TEeqoKC7eAFToQfpivE7554wX0PK+ZjGsTKW?=
	=?iso-8859-15?Q?/nVOdwCbZRfzjUa0ZXbaVoeOBQ6RA6qfyY7B975o+yWk2tx/ArSbTCdeo?=
	=?iso-8859-15?Q?Z9sYpobPQMNwa2CqHcnyR0MbPBDMt0djOOmUWHaOOqzrwPwfQTod99zZ6?=
	=?iso-8859-15?Q?KMfEemTqs/blVebdwb7sKYc7/1em4WwlbYyXkhb9/D/0v8jX4qOQFpDsM?=
	=?iso-8859-15?Q?mXf8c8iYYkL+ePm/dBLfC9fk6CkLWyROZOZpKQjdvC/sv8zYkwSKJCruN?=
	=?iso-8859-15?Q?0GdkHnA6et0YPAJsQPLvpcHYrR1y/arD4N5mTqSbTqKJFlqV/f3mUVT00?=
	=?iso-8859-15?Q?UjlLDWvX3WQRcH0v7w9kqS64eobw8EBDvpxGouDPHQ6RGCgMCejP1WtPm?=
	=?iso-8859-15?Q?q+yqkr6Umi6VOi+y3DEu1CtafHc37vwyCejZjhjN2rfK8qH2StExSSbYF?=
	=?iso-8859-15?Q?92BSZ2zUhCAwSN3bj7tF3aCUg2EMcdU4C0PTOOuMcnAHE7anAdPwWUDcb?=
	=?iso-8859-15?Q?/P6N88BYJrRfHqnNHKr1xZxeibnX47wGsniN+/0mvvh00ioA+AeNcH+hp?=
	=?iso-8859-15?Q?+iXazqQMjWo/g7++17P4uL8H7wFGMIN98ENPGuXdCESII3EpBYHLNNSHD?=
	=?iso-8859-15?Q?nAd0GUW4+4hNem1A1nOEWhAlrLVc4afSaPerevUQ/pMmNMTGVX6jBPq3Q?=
	=?iso-8859-15?Q?QX2N32X0HfdLT+H3mkKU5gFqxABc2BUrfG9bfw0R2ya2C4QLExJ80xk+C?=
	=?iso-8859-15?Q?NX9YK1fJP8SnrLcI0oYOmMdn91sho+1vq4oPwlBuzAy3Trhem8xrIujzz?=
	=?iso-8859-15?Q?xJA3YIIJ7BrXbKDBascx8GgZnupKz3Z4xJoUyIlbbDDv3kHVDD+OzoSJe?=
	=?iso-8859-15?Q?CZlHjAqc8rh3EFRzsW0aKrG45glnaCNjaltsM6yUxxY/DXUwMZ1E9zjQw?=
	=?iso-8859-15?Q?PF6G0XfziDaA/3M6n3EGqzg+L3TDTTK7n+2+U6yecy9UWt9sadDyaSbNu?=
	=?iso-8859-15?Q?sgF7tT+U0294UYfmtVVRuIqCjVWxw/ZVsKnRV7hO6Q2tgvwqJzEQFKJDx?=
	=?iso-8859-15?Q?BNwp1G/pjGkvkWw8yDosT8cOUEThMt3Frs2riBT7yhPHIFtaQwYMkk4kp?=
	=?iso-8859-15?Q?hHIHHIh7eJECAHJxozIRM58Qw3hOlff+wPIxsPNBOoUsfOmhfkPXL3Ln0?=
	=?iso-8859-15?Q?RRtS8OCKgkorG6lDcenMMoy7dF5mM8GkWBy2nlpF5+ZVudAcLvWGHkpFq?=
	=?iso-8859-15?Q?kjp7PaMJX2N7nooWGGMsKltt3j1TStqLAHUVyYgagksbCiS8nIejh90mz?=
	=?iso-8859-15?Q?V/1u03l7xBhpKgzyTP6DZ1m6//oJv9yc5LMs8opZgkUs7/Q=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abd64ef-095c-41d6-37bc-08d9aaa7346b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 15:22:16.4888 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IpOwq+pGSZ4K8bLlX2abjtTov4xO2DsnQ5D9wNuSMCuE2wOjt70rM386KHEl7ku/5Goh56phwv2OpI7iihT1jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5228
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIFMRp1021578
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/4] Add "reconfigure all" multipath
	command
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <071108B5492E4345AE0033B3049CD86B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-17 at 16:37 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 17, 2021 at 08:50:55PM +0000, Martin Wilck wrote:
> > On Wed, 2021-11-17 at 14:33 -0600, Benjamin Marzinski wrote:
> > > 
> > > Changes from v1 as suggested by Martin Wilck:
> > > 
> > > 0001: update libmultipath.version to handle ABI change in struct
> > > config
> > > 0003: Clarify commit message
> > 
> > Did you overlook the two other comments I had on 0003, or did you
> > deliberately ignore them? Just asking.
> 
> Now that I look at this, I'd rather not change the reconfigure() and
> configure() argument names to reload_type. That's the name of the
> global
> variable which has serialization concerns, and reusing it as an
> argument
> seems like it would lead to more confusion.

Right. My point was that "type" is too generic. I didn't think about
the name clash.

> Actually, since reload_type can only be changed when switching to the
> DAEMON_CONFIGURE state, and you can't switch to that state again
> until
> after do the reconfigure, it's safe to simply have configure() access
> the global variable, reload_type.

I'm not a big fan of new global variables, but this should be fine.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

