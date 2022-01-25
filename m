Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732EFC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jan 2022 21:56:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-C3y1a51ANCmzKh1df0iJbg-1; Tue, 25 Jan 2022 16:56:35 -0500
X-MC-Unique: C3y1a51ANCmzKh1df0iJbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE8BB92500;
	Tue, 25 Jan 2022 21:56:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D1445D9D;
	Tue, 25 Jan 2022 21:56:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 766B51809CB8;
	Tue, 25 Jan 2022 21:56:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20PLqgoA031489 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 Jan 2022 16:52:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C14E61120AC2; Tue, 25 Jan 2022 21:52:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC8E81120AC3
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 21:52:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4FC5101A52D
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 21:52:39 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-381-a0XFk7DQOfew4RXNEvhoDA-1; Tue, 25 Jan 2022 16:52:38 -0500
X-MC-Unique: a0XFk7DQOfew4RXNEvhoDA-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-37-1MO5IUVgNei0klTQtJ2brQ-1; Tue, 25 Jan 2022 22:52:35 +0100
X-MC-Unique: 1MO5IUVgNei0klTQtJ2brQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB4884.eurprd04.prod.outlook.com (2603:10a6:208:d0::26)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.19;
	Tue, 25 Jan 2022 21:52:33 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4909.017;
	Tue, 25 Jan 2022 21:52:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/9] multipathd: remove udev settle dependency
Thread-Index: AQHX2/kcqYz9XADO80u4JTNgHS2rlQ==
Date: Tue, 25 Jan 2022 21:52:33 +0000
Message-ID: <dbe9bc8583d4954add51ec4fad8ed8d718a1dfeb.camel@suse.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
	<2d4c46dcaee54eb39e96831c0ee9bf88204cc819.camel@suse.com>
In-Reply-To: <2d4c46dcaee54eb39e96831c0ee9bf88204cc819.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87bd621c-8a29-418f-8408-08d9e04cfe15
x-ms-traffictypediagnostic: AM0PR04MB4884:EE_
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-microsoft-antispam-prvs: <AM0PR04MB48840BD0A7EEB1012A3C74FEFC5F9@AM0PR04MB4884.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 23ucJgGvaDKncBgDytbDdqMPXr4OhpyInLwfZAUW/f6v2KiIXdRgOApJfzxXqYDGer/VHZjqoaR6G2FcfcKMsES1U4pQMQtyDy5Epd2Us/QiqKS36R0X+LQyaWoMuQdCvfoE3LHxVkU16gCDu62HDBeYLM4WJyQ8cEy7zeBBPuzRgK/IlLHboeMvpQvPhO1Ik91EneYRcYGCQZ2YSat0wmV7yWvxzYXx/pr3WU0JArQkYL0BSzd0sYzAx4LcrOHQkdQNvdRgwgOWpL43pGJTfQsvK3aj5D2AYQkZRM8fe9MfPFxGx7ZiXBmnCulvAAlYzVyVN36Q7ShbsKdvjMzOJm40TQ8GTIo/HZElBgX/YsOFIZQTXlQT4+pjdidcofDNofVTZVTFba0tQaZc5YkgWFRV24srzOeN/aGKfzAL8EW28z9qnKnrrx9ARcomwt4ds+W83P/frKWnFnJRyTJxMWsI9+RhZMo3x3Kx9TZzbAntGmUj32nxhQGj6tqvg56pfrkVs074pzsQpoKCjpgQ7jfa3OSKwTi7Wf1SkM+aehwLnNk1mtRZwL0sCQEW7bpQmNJELJBRm9ClG4zpZ1q9Q0eixQsEXOhPJ3jlGcVhk112uR5bXAplOri/cICwq9SsIxPVyQqpDaUA5pqQnPf6qRuwfXC7nC8/WaPYcLTIwRqABHqHGVa8GXjLqDuVf5+pGiGms3Z2kXtU9a0Q1nAATA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(54906003)(316002)(107886003)(110136005)(2616005)(38070700005)(86362001)(186003)(4326008)(44832011)(5660300002)(122000001)(2906002)(6486002)(71200400001)(38100700002)(36756003)(83380400001)(26005)(76116006)(8676002)(66556008)(64756008)(66446008)(66476007)(6512007)(91956017)(66946007)(6506007)(508600001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?O38TWKuYWhY6L10uNux4FOBWy+xfQ02RpmAuY31xH4xZ0sxjXn9AT8kUy?=
	=?iso-8859-15?Q?XTaH3nMDYxs5hC7JvTTUsAaJlPuEMlD5vSyc58Dy6VYghRFJTaxgNMoTa?=
	=?iso-8859-15?Q?VQlsGQzvJuosKrUflfPHADce2ZRG+/7OnWf84JoRt30QbZx4nayAsWRm8?=
	=?iso-8859-15?Q?bTEzHpbbjLWKfZrNFkfcBl054t0Sw0BKHheB9ximqp58DDZwZK0ta+GRl?=
	=?iso-8859-15?Q?/p6HwDGYOCgRtAXa+2AXqJAV78o86lehJcThC8vvuj6B6njZ0MKF2WHuK?=
	=?iso-8859-15?Q?mzpkvDnpZ4ouNbCf1y/ZFz56KA1XPhqfanzo/+4DuWy1jBcob/9AfzxXY?=
	=?iso-8859-15?Q?bmR+hxCpYODA1/lfYKVkpthtYGYjNcY3GpzG/8M1yMMlpZVm0pfqiWLMs?=
	=?iso-8859-15?Q?hnONnmFoo7FxpJ2XY3pCS86MxHnB0gTVNLy3obHZz37ANtI/ws7fIijVS?=
	=?iso-8859-15?Q?39CIaXBvwXWIycJoMQ4V7W9oinHHrU+VTu+T6HZRaYSX8gGgD+mq+Nv/o?=
	=?iso-8859-15?Q?8vC+X0kfPb5cgSI3cGzjTBA27dYC7Yj2VKDzHv4AX9rCvPJWiNKT0V+by?=
	=?iso-8859-15?Q?Oxpiksw044azvQC41PMQ3iUEMREj4j/627DuEa4E0mfVa9X5Wi5MSLjwB?=
	=?iso-8859-15?Q?lGOih9JvPxdKDp7zgKnsgMsnEyS3GTwZmgFrNNfasaz5OBqPrprxkpLp8?=
	=?iso-8859-15?Q?gShtiSS7bzHhs/iBlrANYvd7UlrIAoXclqiTAdciNPePYFWcseTaW9HLx?=
	=?iso-8859-15?Q?355r8S5xZzE6CllpQzkYDYsQZ4wAlagLa/AJ7d+P5Bc7n9yGNdepPooym?=
	=?iso-8859-15?Q?o1bvPslfSzX7JN6Qb8fgjuqmh7sw6NUrC8OOeyraG6Q5yZochuXk6Cy/6?=
	=?iso-8859-15?Q?UqTBxkeyp+BsxYIP+qrxbgr4RDMeJoiBptTKzfUgbgIiKmCENbxVCOYBs?=
	=?iso-8859-15?Q?6onIPxqAo2isrFCTUvnUHAjht+XEfVlLggkYppiX+k9t/uY8zJ59s2/NG?=
	=?iso-8859-15?Q?gbxU8o0+pHnzYZ4t+K40n8oa6n+Y6E/dcOlHXCpd58Lmh4plNIj/4Dqa1?=
	=?iso-8859-15?Q?J38G916Qo5dnm3WguRe988ATenF/Cv25SfRysO+d6EXloDEK4QVFd7o8R?=
	=?iso-8859-15?Q?MTFKBoTUbxSUNAaUx7NLptg9vPGbAtSSWFFRVWFsbF3VMsh4+/9lAsXLi?=
	=?iso-8859-15?Q?fE35QTbk/awMRg1YfFr8NPQawAqUeyEUKrLAeeL8WCnxQo/gES5g96AL7?=
	=?iso-8859-15?Q?zzm+g2EQ0tT0DHHx5PmUUMADh+tHfINJEsmfIqd/gQxWqMyaM7A2WcRvL?=
	=?iso-8859-15?Q?GkDU7LsZNSbtnZMyTOBlBNyb//rauHdAMsh7iHr4Cdz07yZLKmpVSAeMF?=
	=?iso-8859-15?Q?f6AUmPdiT4s0U8tnvpfBtFuvK8DCFgfIWDMJ9E5inxAwQh2r6hw8ggrfx?=
	=?iso-8859-15?Q?v13e2WG/YsnnW7VRSsA6YJXo30PPcZKxMAySqRXyy1wm4EZXT6g2V/8xv?=
	=?iso-8859-15?Q?4z/bfqLm/78Sm8ritUOYYNLf4VQyqgRbJxtPrEEbAkJmRcQeNN2mQVx+N?=
	=?iso-8859-15?Q?f6yuuXum47/jDR1KeL+jiEHHOPwq3wevpG7qHk4MD4SA6WLTM/Vlj3AFS?=
	=?iso-8859-15?Q?VjVL9nLRLLaTfqDmH9nXOdBqqbnUuxda4VriZ6MZVD38o0i3LPE6UekqA?=
	=?iso-8859-15?Q?dTqoyuNKk+l+umiS8OKkRlURVMkqQJYm4KoazSAFizqcF3A=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87bd621c-8a29-418f-8408-08d9e04cfe15
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 21:52:33.3475 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pxN+/yb57Spfho3GwBstYaM6rgNw+sNrY71IQv9jgihQs29l0NwVk/t9L19o8yX+bZMsh1Ki4LuVRGl0Nu6mJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4884
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20PLqgoA031489
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH v2 0/9] multipathd: remove udev settle
	dependency
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F902A68CF36A6A46AE885930A482AED0@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2022-01-24 at 12:19 +0100, Martin Wilck wrote:
> 
> My late testing has revealed an issue with this patch with explicit
> ALUA. It's similar to what you solved with the "ghost_delay"
> parameter
> in the past.
> 
> With this patch, multipathd now starts before SCSI device detection
> begins, and as soon as multipathd sets up a map, I/O on this map may
> be
> started. With arrays supporting Active/optimized and Active/non-
> optimized states and explicit ALUA, this causes unnecessary path
> state
> switching if paths in non-optimized state are detected before
> optimized
> ones. I/O will cause scsi_dh_activate() to be called in the kernel,
> and
> this will run an STPG, which always uses active/optimized as target
> state.
> 
> With RDDAC, we'll have a similar problem. The other device handlers
> don't distinguish active and optimal states, AFAICS.
> 
> I fear this behavior will not be welcome in some configurations. So
> far
> I haven't made up my mind how, and if at all, we can fix it. I
> suppose
> something similar to ghost_delay would be possible on the multipath-
> tools side, but it's not straightforward, because non-optimized paths
> simply count as PATH_UP in multipathd. Also, the delay should
> probably
> be much shorter than for PATH_GHOST. In my testing against a LIO
> target, it was a matter of milliseconds which path would appear
> first.
> 
> Alternatively, maybe we can consider the way scsi_dh_activate()
> works?
> Perhaps it doesn't have to switch from active/non-optimized to
> active/optimized state? OTOH, there are other situation (explicit
> path
> group switch) where we'd want exactly that.

In discussion with Hannes, we came to the conclusion:

 - for ALUA, the effect mentioned in my post can be avoided using
   the kernel parameter "scsi_dh_alua.optimize_stpg=1". Confirmed by
   testing.
 - even if this parameter is not used, spurious switching between 
   non-optimized and optimized state is non fatal, and much less
   resource-intensive on the storage side than switching between active
   and standby states.

So, it's not a big issue, after all...

> The other alternative would be waiting for udev settle again. I'd
> really like to avoid that.

... and this won't be necessary.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

