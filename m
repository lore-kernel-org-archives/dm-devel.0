Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49C6C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 16:10:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-K34x3IrqPVOldfOxVzze6A-1; Thu, 10 Feb 2022 11:10:03 -0500
X-MC-Unique: K34x3IrqPVOldfOxVzze6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5755319253C0;
	Thu, 10 Feb 2022 16:09:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 372F97DE47;
	Thu, 10 Feb 2022 16:09:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5AD101809CB8;
	Thu, 10 Feb 2022 16:09:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AG7ls3013345 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 11:07:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 338AB40F9D6B; Thu, 10 Feb 2022 16:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF6240F9D71
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 16:07:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 161F8802E5B
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 16:07:47 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-529-qPfhutR6NaG8gm5Xv8E5fA-1; Thu, 10 Feb 2022 11:07:43 -0500
X-MC-Unique: qPfhutR6NaG8gm5Xv8E5fA-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2055.outbound.protection.outlook.com [104.47.6.55]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-41-JugUhLhRNHWP42RsUceq4Q-1; Thu, 10 Feb 2022 17:07:40 +0100
X-MC-Unique: JugUhLhRNHWP42RsUceq4Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM9PR04MB8337.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Thu, 10 Feb 2022 16:07:38 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 16:07:38 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH v3] multipathd: handle fpin events
Thread-Index: AQHYHmebN4b6TWOhBUe6OTftFkCXxKyM89WA
Date: Thu, 10 Feb 2022 16:07:38 +0000
Message-ID: <d564d33320acaea31144f7f224a515556e786976.camel@suse.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81ebe3ef-2b79-4530-4e00-08d9ecaf757c
x-ms-traffictypediagnostic: AM9PR04MB8337:EE_
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-microsoft-antispam-prvs: <AM9PR04MB83374888E4AF56957BFE74FFFC2F9@AM9PR04MB8337.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zmuApivdw6ow4lYvR0Xwx6Tqiq68oGcgh9z3tRoH9dMjrUiHiGc0Gb60VSiQ6GXNpZWY7g4Y3IHL5CHJzUdsghXeqnSmpgJOgWxYj8AjrpIKaG4jhXGF5QkivcLQf4vUTVp47E/pvKs5RzXojUSejVXL2LojLo0yAypSsNaacTKHJObL2MgISP9QhKThn9j+yy7Fcp8zCzXB5mW4hvN/KkXXAPdDWmn+0L7k+4Oxtk1hVTaaKWL7UdEa7IN6si+5hhqyojP3i9Xm+jE1Rg6RCKOH23VHOtVSw2G7/ciixFcfg2nMCo0uPOH6repHh4jtMwxMyrmVlGzSLbkz9Nt8IApi8iWB1hworpT8G0sCvArU24hTS4zRDO7xhkKEDpdkJhazUA/u/7aGo5LDCv1Ji+2TakYsqTbs+wykQipiJK8oRZoHbX1EtVYQ5v8i+gxaSR9Jh7yupFcib/7y5zlYgo0uxaCRaJb2UK6BMFrDIXo1h+Hdr3RjUgKdiZq+n8/cr7ZsyMim37xXJkPZidlDlC/VAgq6vfX+Mbr4ZxrskSrMki7rCp3iDQSnaBNPwAVItb0kpTW9XuV6dJKk7UVNvZrW1MnQGVo7weAX57q3KXh+EHdnsCy2mbjJGEYSUhB7Kuwk6v9lrNOY3vuIIcaJvNcwoEhg4xXryJ15ZxiVfmNZY58A8MFBrPzJ2+4difUXTqGMjDZbrkzTlcZleHQrFw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(2616005)(122000001)(36756003)(316002)(2906002)(6512007)(107886003)(44832011)(5660300002)(91956017)(4326008)(8936002)(71200400001)(86362001)(66446008)(66556008)(8676002)(64756008)(6506007)(66946007)(66476007)(38100700002)(508600001)(6486002)(26005)(186003)(38070700005)(110136005)(76116006)(54906003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?4qIHv6fRXB6kecUqLS3NqDQfDh4BsC1ri9eMNuEkR5aLW2ZABi5Duc5BV?=
	=?iso-8859-15?Q?ROvE3gmeIj9gNMyOYnR2M5/ghfEBFNb2moVyNb5v8vu36yFGvhzFZcPzP?=
	=?iso-8859-15?Q?aJ8pGmAog7+sJ4X/nY956+6bydzm0vLlT3F1Ejk6Ws6OSmsOBTeluXp3K?=
	=?iso-8859-15?Q?xFRjEfF0auNbWNF8WLdNBfyf8ssdeK1af78lZZt58y4oBoe91HtGx0HJ/?=
	=?iso-8859-15?Q?5q9Cb3WRvMiUZ6/u6b6N44x8YqYpsZ6efIf6yIMT310xeIaYOvv25A5I1?=
	=?iso-8859-15?Q?u47ePBT+HUlDaau6VsQRapPBb3g0oIN77yWyu5MKW/531AHLe7GPLnRbG?=
	=?iso-8859-15?Q?ZdMunTuWgL6lsMakutkYGwflFsGDaPx635qTgFrCgKBeqbO72tLkrPaYy?=
	=?iso-8859-15?Q?hn7U1vit47LQripJV1nf6hZrEzENiwx3YyJthH/lKD7BjpJh9utCOhrz3?=
	=?iso-8859-15?Q?ke0p3adNc06GHJai6K02SxRjZDkODdZ3FhXXxKfbwYsYjbiUb8CO9h6aA?=
	=?iso-8859-15?Q?My5tZJrtZVCVyR2Gm5tIR5bOuJfb6WyVMPIH+zlqdIxQd7ZTYEGHVAI49?=
	=?iso-8859-15?Q?Gn9jMC/Zy2XvfhxK4Y5Ykw8JqN5dPWl0o+KCNs4AAvT8u9gociDjoCCuh?=
	=?iso-8859-15?Q?OvuhI+3Jn1eD5ssU2xRhGwOQdZbaxrpwg7fJ0iCS/uZd53H2JXhlnZWiM?=
	=?iso-8859-15?Q?86afHjxrXN4lcQeq9xo8++SqGubAY9Qrk1B50OAVZWrnx4VWZA6NgSYWN?=
	=?iso-8859-15?Q?X0jTVK4cessIbQoVoGKSzIT9gQnA0Hw/PIcp1jfHVdJDeAp8G0YQKRUMZ?=
	=?iso-8859-15?Q?M2bDQpfCO6Eg99tBzdLvOOVwBG9DVk1YMzy+vMPPT5iLqhp5bka/QvmAn?=
	=?iso-8859-15?Q?u5Gjplhj9jwDW4RsJOcbyqFSzc4Bi2H6oNcKtSRKkteAs51NIKULYfN4P?=
	=?iso-8859-15?Q?fiuusgbq3yGzWyTCQpzUQeK43odhEsM2DOtRJ88ygenAFEXnSMxterK4S?=
	=?iso-8859-15?Q?6WbuRD97/dZjnMfbp26MD+SwPH+KuTm98E27jZxTm2wN00vASJsC6v9ea?=
	=?iso-8859-15?Q?ejKHi7H5QylMhv9YJPtRcLp/nSQ9flb32Db7GQyOkiDcGBLDhCoraRRd6?=
	=?iso-8859-15?Q?gfPxrEZPHIdYrteOihbU4dpl0Ci/redqiSsLz3faVR/H86xXv2SOppAm5?=
	=?iso-8859-15?Q?rY12iN0oVDbLesiNt2Cn3YTetwdh6wV7cbOBgpQBM61dCkkBOh8pdom+i?=
	=?iso-8859-15?Q?UVIXmAjtxV6Ne7dYodB5t/W1qs6tWjoDQOs5cDLn1dygll2k5XXOD2TUW?=
	=?iso-8859-15?Q?BQb+fTqPXGiGiWQe2rx5/YDFBkmm0lPlkuOmq0lUsnlsZEsiiZqbJdGrX?=
	=?iso-8859-15?Q?mX4y1czp7xLxPIt6otmWS8gawplAuinSTEIhOJLpBvNT6ewN4XfURc7X3?=
	=?iso-8859-15?Q?f2tbdBbeb3mxr/2ZfD6df02Kv9skW0M8Grm8s1GczgyLLqh9gKCXXAZWd?=
	=?iso-8859-15?Q?ZyZBqYWE06KW8J5ojKIP5IXUmkPlpXbg2JFDPFi2XG+dHVsNYa6AhqSNr?=
	=?iso-8859-15?Q?XyvyYq85uT/NZPYNcw+AvXzESIaLoT3kAqeg4tWwcd1ZOstI8IaT3AfJR?=
	=?iso-8859-15?Q?X92AabK5LEBuJ5Nx/JGg0JpMsBq96GyDilKe+597YYCAjRyrurKDvM2Zz?=
	=?iso-8859-15?Q?4//VZDA6hzNh8mjWdQnXgPm/HKNpmYo/VEA7ia6J5pIuUqU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ebe3ef-2b79-4530-4e00-08d9ecaf757c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 16:07:38.3054 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFkAeqeVbT/KobnOYhN9e1cFlPthzp4zq5bLjL05RSOgqtyCHO3Oo22E1qBr24icTqVEihvnsnMXrJys9U01vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8337
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AG7ls3013345
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>, Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH v3] multipathd: handle fpin events
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
Content-ID: <36CB2C39771DE242A374D88865F5A92A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-02-09 at 19:28 -0800, Muneendra Kumar wrote:
> This patch incorporates the functionality to handle
> FPIN ELS events present as part of FCTransport daemon
> (available in EPEL8) into the multipathd. This helps us to
> reduce the response time to react and take the necessary actions
> on receiving the FPIN events.
> 
> This patch currently support FPIN-Li Events.
> 
> It adds a new thread to listen for ELS frames from driver and on
> receiving the frame payload, push the payload to a list and notify
> the
> fpin_els_li_consumer thread to process it.Once consumer thread is
> notified, it returns to listen for more ELS frames from driver.
> 
> The consumer thread process the ELS frames and moves the devices
> paths
> which are affected due to link integrity to marginal path groups.
> This also sets the associated portstate to marginal.
> The paths which are set to marginal path group will be unset
> on receiving the RSCN events
> 
> Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

