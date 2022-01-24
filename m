Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B51C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jan 2022 11:24:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-uLFqnOWmMy-Y7j2K5CFVYg-1; Mon, 24 Jan 2022 06:24:31 -0500
X-MC-Unique: uLFqnOWmMy-Y7j2K5CFVYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0506083DD30;
	Mon, 24 Jan 2022 11:24:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A91C753DB;
	Mon, 24 Jan 2022 11:24:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5E66F4BB7C;
	Mon, 24 Jan 2022 11:24:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20OBK3JG027389 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 Jan 2022 06:20:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E8C642026D07; Mon, 24 Jan 2022 11:20:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E28E22026D11
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 11:19:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB22738035D2
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 11:19:59 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-418-vLvluPn2P26YdvyuL5YaJQ-1; Mon, 24 Jan 2022 06:19:58 -0500
X-MC-Unique: vLvluPn2P26YdvyuL5YaJQ-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-4-26NMaCVdOvajn0PnK8yV_Q-2; Mon, 24 Jan 2022 12:19:55 +0100
X-MC-Unique: 26NMaCVdOvajn0PnK8yV_Q-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by PAXPR04MB8474.eurprd04.prod.outlook.com (2603:10a6:102:1dd::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17;
	Mon, 24 Jan 2022 11:19:53 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4909.017;
	Mon, 24 Jan 2022 11:19:53 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/9] multipathd: remove udev settle dependency
Thread-Index: AQHX2/kcqYz9XADO80u4JTNgHS2rlaxycKoA
Date: Mon, 24 Jan 2022 11:19:53 +0000
Message-ID: <2d4c46dcaee54eb39e96831c0ee9bf88204cc819.camel@suse.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 080cce4b-f712-49a5-9051-08d9df2b71b8
x-ms-traffictypediagnostic: PAXPR04MB8474:EE_
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-microsoft-antispam-prvs: <PAXPR04MB8474775E2DD9EDD99FF97DDCFC5E9@PAXPR04MB8474.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 8ruD8GPQVx7f6LuH0VQJE2TLsduaFqvdEXIGX4Imit8nr7JY1oEiFCyQo7ydEjE3KAZwI8OrpLo1pizVW8UAydZ6Z34Nr5ndl5e5HZkvC+9meYtC3H35Ic8WZlL6U4zY5bpVMMjDfxlpcjBQLNHEnCUMxxB/Vx0Tr5a7IYlitYdNof/oxwf7b77eu9fD3Va3bwbYhRPSeIemh4Z28YfVhoV7/fmxVBku9fKPi5x2HgzhaZpz3uDhZRae/4jmZYZfN2lBhvwa5WbiGqSeeL3a4l09cJ2fBQJIv1xFJhHiuMvY/h8zKHBW1/S7YU0InkQo5R7XFgm6hYa/hAEZkvWwfTU3PU8Bx1VheIfP+36OuV81JnqN+rYcuZhbVYLEg15h+gHjSA9Ngq+jRV3isXXa/nYMqpb06MxhWGEfvsTQsvqBk9l1uOLAE9G0oAQgZIgWUYsTqg7hDrVBXG7pdXEaiaUH2GLLN5+2EkcvOa0yn/xnH9T4ETP5WZHhVVKvRZi9+IMxp7wlCQrm8dmzytIjAZf27/rrfOVCwteTfgkrboBlcKJAPR3uqJLFPwbQjd4XX+zbEEpzp+t2AUyP+Mt8ygZ8ocz5+5/hqbSAlZLX0hzsMsVCPg3wvb4rSQEvXfy+9OmHJZ2Uc9UZWiOJ6+JieYp1UO05T+UjbNGkBoz/15Y+6mSAamfi4NZb9kwFvTH1mT0TgbCGV5MkK9qzVc8tbw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66476007)(38100700002)(8936002)(5660300002)(76116006)(6486002)(316002)(91956017)(4001150100001)(66556008)(66446008)(64756008)(2906002)(508600001)(83380400001)(6506007)(66946007)(26005)(2616005)(186003)(44832011)(4326008)(54906003)(107886003)(38070700005)(8676002)(86362001)(110136005)(71200400001)(122000001)(6512007)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?CEms01YGTj+0C9ny+Q/o/Yvn75FAqg4cXQabV2AJnVn72pnzDYTxWwuvL?=
	=?iso-8859-15?Q?RAfgK+8ff0w9wR1I2D7uGd6F4dM14UdT4gHjez9UoUexvTJ6TMUZ1fKsj?=
	=?iso-8859-15?Q?spkOIQqHkw6ptORSKjL+vsdcTsp6TdaTEBQPuGebjfxs7QQqBIXCTPEud?=
	=?iso-8859-15?Q?cyE/dAFuUOn4DLRtw08IEGVa8zMNXo4QSlQAQLJQbD0MqAD2+oc7qTU/x?=
	=?iso-8859-15?Q?L+uNYxf/+CNu11ZkxPCZcXy0/1wD8RHufJMDI8CmjtrXPeajdWmOcxbt0?=
	=?iso-8859-15?Q?eeh3l2rxc8TQbPj7KUZV6lr12LMHEusfjJ/0uo4hJIANR30AOS/LyBi8U?=
	=?iso-8859-15?Q?LqtCRb5pcsGR/7LV2OqeVBuCClk7dkZaE0Bvlgwp8J21x+gtMlnR9jRz0?=
	=?iso-8859-15?Q?wYMSxqnj/v/5SoHgrBiKZ/oamAFMpl51f/2Jvxv07t/I/EBbRrQOL/wij?=
	=?iso-8859-15?Q?n8C92VPaJdOOk6Fb6wHSwoRvamROcI1m4LFijOKJSFAZ+NLwCjxYayRDv?=
	=?iso-8859-15?Q?gcp7AzLQxCvrERddhBNXYd/TEvI2oIo8fdvCBEqxp8hgJqsxu4TVIHg0w?=
	=?iso-8859-15?Q?TwIsp3oafPmpTMn0ezej9lLOH4MAYbxW8SnMWZ03s0AqGdp/sr4lHclbX?=
	=?iso-8859-15?Q?CDwwF7OS4qsGz6APLIjbrsoptiO+IA2Cs1kD08aCyefnASmGA1Jhhvgk4?=
	=?iso-8859-15?Q?OzNSX5UzpHiDV41HaTYxZo75qoGIPBZLX+Y4UDeu7Mj5PxduEmjPHnNVu?=
	=?iso-8859-15?Q?n6641SCxXjVZPrJG/JSc8mSVNPzX5/pTtFh+Qlg6xGTPO7zuJjJ7wMewT?=
	=?iso-8859-15?Q?JprLLA3mRXaVUeTEmlBlsOoBWRynkMhbMGzu89JPjSoIJSDTQ0HxS/2D1?=
	=?iso-8859-15?Q?u49xhZArJsL2PZl3iTy1oUBkLS9pAmDkdnjEj84yJEpXgcpdZ7NLH4Vl8?=
	=?iso-8859-15?Q?3r5Qa7Y/hgMlUQFsVpdieNTugJ3CQtL/XlqNtxm50T7yURmWl23LEZfN1?=
	=?iso-8859-15?Q?IPeMYDuTacC0rBprYTEo+A0JPgJehpUrEQRhk2nV9oLlheSmL1I8i5Fqa?=
	=?iso-8859-15?Q?5J5QjMSvq5WTCSLrZwjNVJzWQr65YhMc6+xDWN36Kl0wOUJQLvn0D0H/P?=
	=?iso-8859-15?Q?h1krTiTStGmUSNvnVzAEkcpFEvvNmRHCjvIsHkBBnuox11gpoZ6jdrCNR?=
	=?iso-8859-15?Q?o3P6roXqx2RyFLZ334Ne42Gw3aMWUC7VoDRHykGWlsXjcCmpPkPBK9ZDb?=
	=?iso-8859-15?Q?JH5htNHYYmAZFdN9BNsCpBkgt9FhUFuFL3Dry9TsJe2o9cnTWoejkerVU?=
	=?iso-8859-15?Q?L1BbQO1CTttIEv4eWaPl5lhskUpLyZBd64KfTbLUsJQIqTZVieeaQrLfc?=
	=?iso-8859-15?Q?YBa9am3S/vdh36eJmUr09WHAjEQHLaNKc3XhjJ3gjGnHHebg9LOZ0xAP7?=
	=?iso-8859-15?Q?yYLccRFLVVpLRcyhKAPWn2lOA3eutK37LRqnLX/oI4wpqWz21DGc4zYzL?=
	=?iso-8859-15?Q?NOTiGYTSvcU9p6vItYv5uv+oMIUujMbCjqc2/jT+UfgDVfIUtu/PcWf0L?=
	=?iso-8859-15?Q?5TtUaDG/sdN+VzxH0ltm6GRJ7R3bMMPmabxXKHYQRL9WHAMxJM7C74yMU?=
	=?iso-8859-15?Q?XOAzkaq90DTQR1GIhWNRPMaqHgu/LfAdM5Yq3hVszGsteVO8ZIPQ/wrah?=
	=?iso-8859-15?Q?KbSEQI7spFqjdT1Yfr8AN7jrnp4puycLrsMZ/rmxRlsq64o=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080cce4b-f712-49a5-9051-08d9df2b71b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 11:19:53.2795 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewukdUz/mFr47vnW3wWekTqyqp8tQdbL3J8RtJNAnPTFwlv2BW+Ajejd5zZppVeTMzlCmosVzbkp/nV94pRszw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8474
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20OBK3JG027389
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
Content-ID: <68D5B9EFE6FD594BBD0C5609514B7FA6@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-17 at 15:21 -0600, Benjamin Marzinski wrote:
> So, it turns out that commit 4ef67017 "libmultipath: add
> update_pathvec_from_dm()" already does most of the hard work of
> making
> multipath handle the uninitialized paths that exist during boot,
> after
> the switch root, but before the all the coldplug uevents have been
> processed. The only problem is that this code leaves the paths in a
> partially initialized state, which doesn't completely get corrected
> until a reconfigure happens.
> 
>  [...]
>
> I've tested these patches both by rebooting with necessary and
> unnecessary multipath devices in the initramfs and multipathd.service
> set to make multipathd start up at various points after the switch
> root,
> and by manually sending remove uevents to unintialize some paths, and
> then starting multipathd to test specific combinations of path
> states.
> But more testing is always welcome.

My late testing has revealed an issue with this patch with explicit
ALUA. It's similar to what you solved with the "ghost_delay" parameter
in the past.

With this patch, multipathd now starts before SCSI device detection
begins, and as soon as multipathd sets up a map, I/O on this map may be
started. With arrays supporting Active/optimized and Active/non-
optimized states and explicit ALUA, this causes unnecessary path state
switching if paths in non-optimized state are detected before optimized
ones. I/O will cause scsi_dh_activate() to be called in the kernel, and
this will run an STPG, which always uses active/optimized as target
state.

With RDDAC, we'll have a similar problem. The other device handlers
don't distinguish active and optimal states, AFAICS.

I fear this behavior will not be welcome in some configurations. So far
I haven't made up my mind how, and if at all, we can fix it. I suppose
something similar to ghost_delay would be possible on the multipath-
tools side, but it's not straightforward, because non-optimized paths
simply count as PATH_UP in multipathd. Also, the delay should probably
be much shorter than for PATH_GHOST. In my testing against a LIO
target, it was a matter of milliseconds which path would appear first.

Alternatively, maybe we can consider the way scsi_dh_activate() works?
Perhaps it doesn't have to switch from active/non-optimized to
active/optimized state? OTOH, there are other situation (explicit path
group switch) where we'd want exactly that.

The other alternative would be waiting for udev settle again. I'd
really like to avoid that.

Ideas and thoughts highly welcome.

Regards,
Martin





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

