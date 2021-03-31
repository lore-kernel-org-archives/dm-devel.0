Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AA0C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1735A6192F
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1735A6192F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-ZXA7XsRXMlOeBImDjz3vTg-1; Wed, 31 Mar 2021 09:32:58 -0400
X-MC-Unique: ZXA7XsRXMlOeBImDjz3vTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF3B2108BD06;
	Wed, 31 Mar 2021 13:32:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 970C110016F4;
	Wed, 31 Mar 2021 13:32:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36E561809C84;
	Wed, 31 Mar 2021 13:32:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12VBjY7v016179 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 07:45:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5AB411457D4; Wed, 31 Mar 2021 11:45:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D09C71012C5F
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 11:45:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12255805C1D
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 11:45:32 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-373-XabzreijN5iyeifkQMTx5Q-1;
	Wed, 31 Mar 2021 07:45:29 -0400
X-MC-Unique: XabzreijN5iyeifkQMTx5Q-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2057.outbound.protection.outlook.com [104.47.10.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-33-K76xdPABM7Sg39hcyvPcFA-1; Wed, 31 Mar 2021 13:45:27 +0200
X-MC-Unique: K76xdPABM7Sg39hcyvPcFA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26;
	Wed, 31 Mar 2021 11:45:25 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.3999.027;
	Wed, 31 Mar 2021 11:45:25 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"bblock@linux.ibm.com" <bblock@linux.ibm.com>,
	"hare@suse.de" <hare@suse.de>
Thread-Topic: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
	Congestion/Latency notifications.
Thread-Index: AQHXH8ZRsvMl6pS9x02jEI+NQfbmHaqU4l6AgAFApYCAB5ulQoAAKk8AgAAORwCAAA/hAA==
Date: Wed, 31 Mar 2021 11:45:24 +0000
Message-ID: <7b7663da1edf9fcb3e2515e41602ab68de02d2a9.camel@suse.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
In-Reply-To: <30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 768c088b-3b9d-46e0-0046-08d8f43a791e
x-ms-traffictypediagnostic: DB8PR04MB6555:
x-microsoft-antispam-prvs: <DB8PR04MB6555F276FC950109CF5BC215FC7C9@DB8PR04MB6555.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0JiHWFZZQe9WRiVZ3aL83b+gDqokp1AFXEC8rhKzOHUxQJlwuuOleDhTxupukWncy8IFNpkZZVeTlsHYvwG3itbKc15p4ViVC3FAMJJCwFXz6nb6cccK7CV0bEhxBongWTCa+EaZV18+7MsSTXG0wc8sfxK/F09bohCZwoeiZHPhlGwQpKr1HXQznxlRi0khqU7DSDHNcs44S0R+STMdyJRukt9dHOMEc+TI0ycog+rCwQhZfnqZbgwhW0Nt5433I+mmfA6bYvpC9PXvpMs6OubqUvC03UvSRfzGhuFBtIBOdDReVBgx+7FR7XQo5i/FWVUz5od+q5OE5ZTDfeM7hHbr3rtJ44QedIas7KPIV4T+GtnvJHlevwIpB1TEh2YRuGrHExaOjWsySRBr9eYBzw2f5PCtY9bVx9k3nu41gIz5STeYqhljEx0HrqsbuvFM+EFbW/SSP3mhcdQUINxHnq8z0aOg1F3WSD1IzjWP77KuFt0aCkeKxiohvGyPC9PITlwS72+gIWqkYag/GijbxE+FojfizAD1Bt7yp7GtqLqLPhhLffzgSk3nDP6S6MidPlPbHcLOkWSK1wO++/r6ISgYOgyVcSig7R8sRMOPeAAta06fKaMyFZOqtsjAxlQ6IUQ5Tv2yuX6hTndEdxalr1wQ1qdFJzU5DSRKplopa130xuN+2Y0EXTr66fbYOZfX5j8CWyU/L0Hc14Gl0kWVEEMd5qkT+hWuXf0v7xLfVMM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(38100700001)(86362001)(36756003)(6506007)(2616005)(316002)(110136005)(6486002)(6512007)(44832011)(54906003)(71200400001)(186003)(478600001)(66446008)(4326008)(8936002)(26005)(966005)(66476007)(64756008)(66556008)(66946007)(91956017)(76116006)(2906002)(5660300002)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?/lA6h020ijOHUCWUVoQkWHZXt8Q0mxwDVTeviNo3XNpPQwlxSTxPCez0z?=
	=?iso-8859-15?Q?OG/st2sHtWS5ZW0kXR4c0na+it4WO2ETGmMrfbCr2ywuHpYDHMACo6zYL?=
	=?iso-8859-15?Q?JEuj+BxT/pODQo4SXMXcXZkPzuGY+kdja/POiINb69WcmMFmnUQPAgrLK?=
	=?iso-8859-15?Q?3m4SMFv70WZWIYXzsX0W5JbQFLCygSi8oMSdu/c5oPKofzuX9qqX5T0qy?=
	=?iso-8859-15?Q?tvhe6/etDfZlq8M8rkWQTSprVY+LrD3h9n4XTuwvx0+dYM+5hP3OpWGJb?=
	=?iso-8859-15?Q?PKGpEDANafwLd9Q36dtPYsQOmXHMbWRMLwSbATvz3XKoAVAN4vW9e/zuu?=
	=?iso-8859-15?Q?dYUItB7qOiAHyAd1++NOHzIVxAuYsIJfrpS5iwK7K9o6vDQUhAvA42Zak?=
	=?iso-8859-15?Q?PCSoi8baxvAGOL//C2Qot9j2PvUfvLVz/qB+7EasG09GPnk+aCWyGTKBA?=
	=?iso-8859-15?Q?jzYHqFvH+bJzKRzxBy3+Xry5rq61WaHYHDeGyP6vwXPuu3vMe2Y1zk7Y1?=
	=?iso-8859-15?Q?05/YX//8EaDa1ODaCd3Wwbx4af8cs6fT8Nz3V0xQLKWftofsFAxfvKeRz?=
	=?iso-8859-15?Q?4POvdCs8Fgpgfln27dCv5l5E2uaLLZ9LrQMzpsOaUezInwUp0TnQlQlXq?=
	=?iso-8859-15?Q?zLjTD1C74zy1nn5SeAr3VmN/2roS5KuHSccjDmosNpho2oTUaEUdc31qQ?=
	=?iso-8859-15?Q?GWI9oAupu26Ze8qO+lcX6MGZxHMzM7UxbQjan+iGse8Tmf/SdAS+2bSgy?=
	=?iso-8859-15?Q?4RCIrUP6+Ey3rANc9bzne0GidoU2lHxK26CQxF/7sUvbb7K6L3a19yWrl?=
	=?iso-8859-15?Q?xycASWi9TBcbdFHOIhBRuwPPzAfzYapIF5rr+hmxjUdNM4o8davVKzbFS?=
	=?iso-8859-15?Q?dSBZFOi+5DnI/PZ9YMEFnB4cnO+k6wI0NxCzpzT5kDFG9hT7PidPYdlCF?=
	=?iso-8859-15?Q?NpmqBxq4aiLtHWLKF+zFELOvA/5PHYicjK4iJlDn9YwL9S213OngbiRpW?=
	=?iso-8859-15?Q?BgeWmD6Cv9xgUDO4BQeH8/89h5BrJOVBq7alCvmay8pzDxNcGiP1BHOfG?=
	=?iso-8859-15?Q?LJtFvBPXfppkTtUKi+CzOuKMo0kabYIs05MiZwkbzjrgYUkIlHzcU9Fy+?=
	=?iso-8859-15?Q?1U/LNW11qemXVIASb3khnd/G14fA/kHmbqV/lSX+XWqu8Z9M4el68h6x2?=
	=?iso-8859-15?Q?SZjvHoxkIP4l5+Dg9ELMN5D+pTcg9ta/1W/tsW5ClqfEOKEpTvw5GagDE?=
	=?iso-8859-15?Q?RkZv4ygFaPk9bezRNzibyI+mq9YAYsNJC404NX/LlsJTbToryN9dcRldx?=
	=?iso-8859-15?Q?62aIqyRO8kXVdOz45KU8VofGDzjNX2oDZyJ10Nv39De+2/Rsb1Wo4Ll+5?=
	=?iso-8859-15?Q?xFiD1rhFvD4D4zFw81+FMtyAstHUFLZMK?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768c088b-3b9d-46e0-0046-08d8f43a791e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 11:45:24.9405 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgEY1q6KSCpkVVIT1uo/pUbM6ti6gU4CUZkdhOjFeXwfBCG5RfkMUUkY2B+DCd+1CHBSl00gwjmbhBPh9mnLEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6555
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12VBjY7v016179
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:19 -0400
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <EB0B98AE37F1A5428831695F287F9104@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-03-31 at 16:18 +0530, Muneendra Kumar M wrote:
>=20
> > Talking about FPIN, is it planned to notify user space about such
> > fabric
> events, and if yes, how?
>=20
> [Muneendra]Yes. FC drivers, when receiving FC FPIN ELS's are calling
> a
> scsi transport routine with the FPIN payload.=A0 The transport
> is pushing this as an "event" via netlink.=A0 An app bound to the local
> address used by the scsi transport can receive the event and parse
> it.
>=20
> Benjamin has added a marginal_path group(multipath marginal
> pathgroups) in
> the dm-multipath.
> https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-gi=
t
> -send-email-bmarzins@redhat.com/
>=20
> One of the intention of the Benjamin's patch (support for maginal
> path) is
> to support for the FPIN events we receive from fabric.
> On receiving the fpin-li our intention was to=A0 place all the paths
> that
> are affected into the marginal path group.
>=20

I'm aware of Ben's work, but I hadn't realized it had anything to do
with FPIN. As of today, multipathd doesn't listen on the
NETLINK_SCSITRANSPORT socket. Does any user space tool do this?
Google didn't show me anything.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

