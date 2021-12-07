Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B77C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  7 Dec 2021 09:13:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-GAbA0NeGMgG0w1ArfMjUeA-1; Tue, 07 Dec 2021 04:13:28 -0500
X-MC-Unique: GAbA0NeGMgG0w1ArfMjUeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A151894DCE;
	Tue,  7 Dec 2021 09:13:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAB585D740;
	Tue,  7 Dec 2021 09:13:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BFC61809CBA;
	Tue,  7 Dec 2021 09:13:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B79C1Nf021858 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 7 Dec 2021 04:12:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3F217492C3B; Tue,  7 Dec 2021 09:12:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39844492C38
	for <dm-devel@redhat.com>; Tue,  7 Dec 2021 09:12:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BB0285A5A8
	for <dm-devel@redhat.com>; Tue,  7 Dec 2021 09:12:01 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-125-FMpJxKYLO_SdGSuO0S_3xQ-1; Tue, 07 Dec 2021 04:11:59 -0500
X-MC-Unique: FMpJxKYLO_SdGSuO0S_3xQ-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2054.outbound.protection.outlook.com [104.47.10.54]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-31-_Hrrigr1MPSxXBnJBn-wvA-1; Tue, 07 Dec 2021 10:11:57 +0100
X-MC-Unique: _Hrrigr1MPSxXBnJBn-wvA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4923.eurprd04.prod.outlook.com (2603:10a6:10:1c::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20;
	Tue, 7 Dec 2021 09:11:56 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%5]) with mapi id 15.20.4755.022;
	Tue, 7 Dec 2021 09:11:56 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "muneendra.kumar@broadcom.com"
	<muneendra.kumar@broadcom.com>
Thread-Topic: [dm-devel] [PATCH] multipathd: handle fpin events
Thread-Index: AQHX4cN3WHkLuxT/XU2rhrfCJFDyL6wmLT6XgACkMIA=
Date: Tue, 7 Dec 2021 09:11:55 +0000
Message-ID: <b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
	<f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
In-Reply-To: <f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed1f0e82-a42f-42c7-4530-08d9b9619dd8
x-ms-traffictypediagnostic: DB7PR04MB4923:EE_
x-microsoft-antispam-prvs: <DB7PR04MB49236C61286053E9EB8E1C0CFC6E9@DB7PR04MB4923.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ocG8aWsksLdrjdDUukiaS1WXYb5FZeJs8TN574XF++H+MGTsvJhf70YFPbzw8CdXhyPfTWOLawzS8mYkZZ+ie7aCXhcAvTKhqQ9lbkh4uMO1E/L4nRnmJkc6Kr845jl5hKIQ7THjnFIehpRCQCyF387k42YydxOR89uw+0lfhBp8iYvQqIIWUlLEthK5+SxoFa+C2DF++KXKZ1THTgvMmLlJFEsJrFE8QGEutVBe0N4gXUmjtsR8aj8HjOiAcVdily2KCoRpWfYvZ1BbCpYuVICYU5HsMWPLJojJto0I6TaEb+kMj/pGpS2Hi36aZHF2Ajlawz0VM/4WA78r+0O/6xbOHdLXxd8PPUEVGFvKE2QzCFwTz76aneR5uLqo0NaNmOPwb9A2AoXbmVXwTNm5m88tXYmZowwfi5vtRKncyTdNrRYSWif/MudNKP098lLlVkO4OfaDT1zdu+SOwbbZ3RXq2p3fd1fe4tcFh/KjSYoKYPWgsLyb3JeuFbzTzOr0jztVlOipQJ2Rp2xO0L7SY/c2nuHshoxJNhU1+87kqdZihSyk1s6lSNyI5YOc9yZflt1EUGF+iRcrGYF9iXEFBa5B0AJ/iHFCBo4Ra3KS4bS/lIJZEfnpU3XFscwdykKBsh6SwIp8+vkDuY94OtPLZpQPQlA8pItOaZpGO9IrcCqtTjAnTGJIAPQtYhIbsu1XNLKbn+6UiIZH6iE+QfXStw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66556008)(110136005)(83380400001)(186003)(66446008)(64756008)(2906002)(26005)(38070700005)(66946007)(316002)(6486002)(44832011)(66476007)(8936002)(91956017)(76116006)(6512007)(508600001)(86362001)(4326008)(6506007)(36756003)(122000001)(5660300002)(38100700002)(8676002)(2616005)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?uzMFE+viuio33MuAJ1azQ642/2cg4nPvWOEbipSNtARG4vpLFz8qWKGdA?=
	=?iso-8859-15?Q?JV9gVAyJB6g3XD9FjuCVbkWgKmGupxMVV+6nQCfJ0r+ClRimE7F6iyQy6?=
	=?iso-8859-15?Q?aRlXKbk+X8OycTan1io7NGznL7BwubP57lXm3+iyTtTzsz1F/BkfRe88j?=
	=?iso-8859-15?Q?p2naMIM6gLFI7lDEgyA3PSDmHqpwLbBKC18BUV0mqpme21ccjMGTM3n79?=
	=?iso-8859-15?Q?uINFysWIJ2tT07YSotvhemno5qlgybUO8CjnJln/j0aDLsVuDlt8Lu4nS?=
	=?iso-8859-15?Q?d7TMlw/dWP6x5FndC9BEYZEMcriFFJx7LrHtZkBp+jFBWj7dVXd74PtXG?=
	=?iso-8859-15?Q?HmwRnzWQUAK2vcWUwlM9EAQWyLBplPGYdvuoJ0M0Ym4mDD2uXbqLxQxzd?=
	=?iso-8859-15?Q?V4OR0qk2UQRfE+IlFhJ+gTE0I/ftCjVmIqqfKdDmXu3g7D+nHZ5WnUy78?=
	=?iso-8859-15?Q?i3iWpC06GrF7EkTZlW4ndMjdmwdLjMGJjkVq78dkCTb1CNhrvQU59OILH?=
	=?iso-8859-15?Q?GDS8X3ifQzBz5mg1kW7MjORvw9qO3eccCk1g49EDYML404swiWvm7njvj?=
	=?iso-8859-15?Q?muPlVNVqASLpw5QAgqvxUMBKA22c0DvEOUzkQZSCo7TVwaDZE3xIOQtSc?=
	=?iso-8859-15?Q?E8sG8Fhcp+TQ/xXQjqKaf4TFil97zRRGdQthaLU9n1LmWw7o8sULwRvEW?=
	=?iso-8859-15?Q?f2sg4bmbaSHH6A+P+oZz6hgE1NJh/r98b8USq9R7YLUCWR1zuPqzyXhqo?=
	=?iso-8859-15?Q?YU1nAurSYDB1n97AzY6AJjk8M0tAHlKIxrWwOubC0jTH9DafGSnj+9Sho?=
	=?iso-8859-15?Q?wqOXGxwptff6NYuO7vzG+O2Jxosw26i6xAF8QotTQjyAJdHox1C+Ao6jm?=
	=?iso-8859-15?Q?UGHTnAK1/MJdGc+QmR/+TYludkJvuazgoiA1r7wGiyB0BASg2yy0+re1A?=
	=?iso-8859-15?Q?WQeXkaPSYEB7B6hIfFeDNgEIvBa16OxCOlUB221ulprqisufvdia7vQ17?=
	=?iso-8859-15?Q?CV1nkxCURfyc/wzng3tJSG55MpjYUwSUzwja3HwqzJh6Irg/p2UH1ocwl?=
	=?iso-8859-15?Q?vE5x3AnyrESWUmFs+csdgRsLwm35fRBE9JaoS63xO/k9g3Zud+oDerI/r?=
	=?iso-8859-15?Q?QvUk6rgiIs+h3welbALcB9ZxIV6qUSI/TDKws4S9DQNxMItpRda58KALR?=
	=?iso-8859-15?Q?TKaILOYsg1H+ksMguS+iB0/RoD8u3mVYYkkKB1t8L9qyF6uzigpZlij5G?=
	=?iso-8859-15?Q?uVUDGUjkfMd9wFGTnC3uSXPTE4b2pagdGqJr2kbisOTQj0bWL4UieFCp1?=
	=?iso-8859-15?Q?mUjAW16ZcnXdIBvykRvXnrrqA2oBEaS2d8YYxxcall6ndKyc6zCHGefd7?=
	=?iso-8859-15?Q?aTumeHBB7HnhoTfsj0EA0xsuNlAQx+BW0DpEwpQ2fQMO3lkD1n1uU+J6c?=
	=?iso-8859-15?Q?gz6R5P4jGlFXpGU0M/NuUiiIvthbRQ6leOLimngk+q83S7V/MGvQnafkf?=
	=?iso-8859-15?Q?fpJPFjZoI9eRhwLJpHvJvDLqKUMCebIfJASQdAszr68d+EAQvGUdTH0KR?=
	=?iso-8859-15?Q?F0VCoRrrtwhEvUEIhwwtgZI4oMQghY+sVZLUuMK5gDVwG5h2knqPtnyPy?=
	=?iso-8859-15?Q?kANioAJKdpCDaG6GxCti3KbJR3BYkPJIFZbX/iOM54gnWWqqASNVNXIZg?=
	=?iso-8859-15?Q?/wJjPtlB0QHuOeQ2HbVgmpmD/QJGyn0Kd/qrW4rFU4xn/Oo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1f0e82-a42f-42c7-4530-08d9b9619dd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 09:11:55.8559 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: llcLDnRJBuZ9ZiIl97oNBCizB0J+lrSUNbmprZZUUhetn1v30IYE1ydGj38ffHhLV78XsWstNjqikVWms0EskA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4923
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B79C1Nf021858
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8AFBE87BE9CE3441BBE4EB79363B95F2@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-12-07 at 09:19 +1000, Erwin van Londen wrote:
> Hello Martin, Muneendra.
> 
> As I kicked this discussion off in the beginning of the year and
> seeing the Muneendra and the broadcom people have come up with the
> first iteration I can only applaud the efforts. On behalf of all
> storage and linux administrators I would say "Thank you".
> 
> As for your remark Martin my view would be to try and create a
> modular approach where the transport layer drivers can hook into and
> inform multipathd of any event. The module in multipathd would then
> decide based on configured characteristics what the actions should
> be. (Take it offline, suspend for X amount of time, introduce X us
> delay etc...) That way when more transport methods are used these can
> then dynamically be linked into the configuration without having any
> impact on other parts of the transport stack. I can imagine that
> Infiniband. ethernet, SAS and others utilise different transport
> characteristics and as such may need to inform the attached hosts of
> one or more events. On FC this is FPIN but a similar module may be
> written for other transports.

Interesting idea. Are you aware of a technology for non-FC transports
that could take the role of FPIN? I have to admit I'm not, but that
doesn't mean they don't exist or won't exist in the future.

In the first place we'd need to "hook in" an event listener. Like with
Muneendra's patch, we're adding a new class of events that we're
listening to. The events would then than collected and processed by
separate worker thread (which unlike the listener would take the
multipath lock), setting paths states to marginal or back to normal. 

I don't think we want to add plug-ins that spawn their own independent
threads, though. That sounds very difficult to handle properly, and we
already have more than enough complexity.

If we want to modularize this, we need a *generic* event listener
thread. A module would basically provide an fd for that thread to poll
on, and a callback to be called when an event occurs. This idea appeals
to me a lot, in particular because we already have an event listener
(the uevent listener thread) which is sitting idle most of the time.

So Muneendra, instead of creating a new receiver thread, you would
extend the existing uevent listener to handle the FPIN events as well.
The thread would now add uevents to the uevent list and FPIN events to
the FPIN events list. 

Next, we'd also need a generic event consumer, with callbacks for
different types of marginal state handlers. Perhaps this could even be
the uevent trigger thread? The uevent trigger has more work to do than
the uevent listener. But any handler thread that wants to modify path
state would need to take the lock anyway, effectively serializing all
operations. So I guess we might as well use both uevent threads for
"transport event notification" reception and processing, respectively.

We also need to think about whether the currently existing marginal
path handler could fit into this framework. Not so well probably,
because it's not event driven and hooks into check_path(). OTOH, maybe
possible future mechanisms might hook into check_path(), too, so we'd
need a generic callback there?

Moreover, the existing marginal paths handler has two different modes
of operation, the "classical" one that disables reinstate, and the 
more modern one that uses marginal pathgroups. I am wondering whether
we need the first mode in the long run. In particular if we want to
generalize this feature, we may want to get rind of the "classical"
mode altogether. I'm not aware of any distinct advantages of that
algorithm compared to marginal path groups.

@Ben, Muneendra, what do you think?

One word of caution here: we must be careful not to over-engineer.
As long as no other mechanism like FPIN for other transports is
conceivable, generalizing the concept makes only so much sense.
Therefore we shouldn't hold back the FPIN patches until we have
conceived of a generic mechanism, which may take a lot of time to
develop. If another mechanism becomes available, we could still try to
generalize the concept, if we keep the current additions clean and
well-separated from the core multipathd code.

However I am really thrilled by the prospect of generalizing event
handling and reusing the uevent threads for FPIN. That would reduce
complexity a lot, which is a good thing IMO.

@Ben, Muneendra, again, your opinions?

Best
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

