Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D1F1C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 16:56:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-z-Siln7mOOyx7LnnuRyhzw-1; Thu, 10 Feb 2022 11:56:19 -0500
X-MC-Unique: z-Siln7mOOyx7LnnuRyhzw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90697100CCC1;
	Thu, 10 Feb 2022 16:56:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12DFE858A0;
	Thu, 10 Feb 2022 16:56:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 722EA4BB7C;
	Thu, 10 Feb 2022 16:56:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AGtmLO017923 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 11:55:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9569840CFD0A; Thu, 10 Feb 2022 16:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E46540CFD08
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 16:55:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70DD8857050
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 16:55:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-609-TzjxqQR-OkW4Z7uNQvMrUg-1; Thu, 10 Feb 2022 11:55:46 -0500
X-MC-Unique: TzjxqQR-OkW4Z7uNQvMrUg-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-34-ejl9R2JZP9GBs9HxcNuinQ-1; Thu, 10 Feb 2022 17:55:44 +0100
X-MC-Unique: ejl9R2JZP9GBs9HxcNuinQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2871.eurprd04.prod.outlook.com (2603:10a6:4:99::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19;
	Thu, 10 Feb 2022 16:55:43 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 16:55:43 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH v3] multipathd: handle fpin events
Thread-Index: AQHYHmebN4b6TWOhBUe6OTftFkCXxA==
Date: Thu, 10 Feb 2022 16:55:43 +0000
Message-ID: <133eed88a2cd40da76e53829a4422ca6f6faea18.camel@suse.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
	<d564d33320acaea31144f7f224a515556e786976.camel@suse.com>
In-Reply-To: <d564d33320acaea31144f7f224a515556e786976.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfa27583-5906-4e3c-13d7-08d9ecb62d02
x-ms-traffictypediagnostic: DB6PR0402MB2871:EE_
x-microsoft-antispam-prvs: <DB6PR0402MB28718BE0FE47152353B8C4A6FC2F9@DB6PR0402MB2871.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KnubhHgiNXhjubnP6OLzAu4yWC5RXO5c2RW4JY77fa0qaq0kbrhDxaI91ZnQ1BlqfHlFzhVQd9CHRSYXCwTbNM6cToU9By4FYTvhGLRcJDNY/V2YPZ+66QQjhq6NOaXg9B20EFi8JKZg+44ejdLQme+0o0oEOelNNU5Okmhw6bnWF2XRtp3zeIDzCWPRTUgUzsEGu5DQcfjSVvuSFLCFxEOQfI4rRYMaKTqnkL4OY6uV9OpWWVEJzxGwHKVAuHCY/VejjTCi6xVm3tLo3RBGBouoxwv045BTkmNVCKXy4+ve2lYIC2VpHrPg0EsAq0V3FOoNFkWWsoOU7CQ75W6m9xB1TDzDplNiBf61BXtIq2ZnwwAoiJggAK+8nVuzj+ssylDMdHDrPiK4yQ06QTvU2f+bVm7H1bNZiZeDxlTlsAlhEFK4X3970nXFcCSS3C0Ckzs3ppxXNEDlwGRKFKIZqqmYQkSXFZkPGb3Suuw6bo3QxGsw7GpVJGiQh7U/tNV/zhDmN9DV9p8pChWw1NOJAiXumXiNxhuMQXLRqnwgBc6uv4ldwpPKvvoL9VTObjCyDRxBgePo1fVLk+j8JGkrrVHBhXoKZgE/tT3zfxT0qo9RVWm+kv56eLenVvkZHGT2sJHiwPhDQWZNNfcYuBQWBRTQi3xC3fGZpnngVbk0n7YXpp/MIX0IsIhRY19SDXciB2Dz4hV0bb/oURRbtzfL3g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(508600001)(66556008)(64756008)(66476007)(66446008)(2616005)(71200400001)(76116006)(8676002)(8936002)(4326008)(54906003)(44832011)(66946007)(91956017)(5660300002)(6506007)(38070700005)(110136005)(6512007)(122000001)(316002)(86362001)(186003)(6486002)(26005)(36756003)(2906002)(38100700002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Pw0X/2g6I7PE6OGS4PZP1ZSucBSQn9JQNRDBPK1PFq4q0vZSNM9Z79iUm?=
	=?iso-8859-15?Q?vGyVdcGf5rogo3FvghziHy7je7NXpphJLApXY6uXKTimwjd1eGp6xwfO3?=
	=?iso-8859-15?Q?ZZ4e5x5O9CDeoYIJvfftY3ji41fjFlEUFMtkDs6F5m9A0APNwfVzhBAKx?=
	=?iso-8859-15?Q?X0REWpv2AWeEPHf4OkWAYTb2yeLyW8a7gQUmyRGymVhz62xACKJ+CtpNy?=
	=?iso-8859-15?Q?6lTgX1i81J2HbtfKONHpRtkaaMIkqmegJRXkmAyKTCehc93JUy8GzsTfo?=
	=?iso-8859-15?Q?wiBdupbKa7meVs8Hsto5YlFS8h/g+6kaQ7ZFaw+pQPAh9Ur0N+ydmQOGD?=
	=?iso-8859-15?Q?f2LERBtdK2PR1yo8xH8zno7wI06/d4DeBpC09827q/trcfoFJcSnBrDKa?=
	=?iso-8859-15?Q?bd3oo7EMeVQAmtR5o/xJ1d2LB+XJwUi+KGAUsuo2yyCfXYSr5MQ/PM2k8?=
	=?iso-8859-15?Q?XTmBvuMY3Btrnb0PSKg1wjQJIh7+FyTRjWvXlGMA3kcunE/V6i1CrKzLd?=
	=?iso-8859-15?Q?poDmAHKOpfmMb+ARjb2shMcv5bIGPP0QQoU4APYHfgB0pKdjR1bQpIoNT?=
	=?iso-8859-15?Q?pOszOd0Ji47qqzIdolNtv72KzHi3E6JNTmln9egyy9LRi4xZaiPJEzwti?=
	=?iso-8859-15?Q?0klHoNC9VQA+ls/Ww6iWVENFLz/jiM+CzqbDP0mnLLkbODyyfK7p89t9z?=
	=?iso-8859-15?Q?F4CwV4y5msUEeSfDwHfaLMmSkOVmj60TIhkpgF/8t0XRCcQP2zs4ZnAuS?=
	=?iso-8859-15?Q?s4gB3KWawPRckwIfqkQwDOY0g7LoN5LYZWfKMnzrAMoMTK28jfsr9XI0X?=
	=?iso-8859-15?Q?qs9+hRM9CVXCiynoMps4QD0bkvjJLASkCQzyDTMwsONCrF3G1Ybb6VWqd?=
	=?iso-8859-15?Q?38ppvxQkdA0toXHaGSs+60YPnzjiKwngLMaN82kbqmOTf+lKYPH0UIHOk?=
	=?iso-8859-15?Q?i3CVndpxmluEadc7I+6ZgsHfasD/BaLClVqdsLFZ0WkBSs4Po4pyHZ6pd?=
	=?iso-8859-15?Q?paom92R/kM94GERfQb6rv7Z91wkLZViAtibncGl+829iai8H153zKapl8?=
	=?iso-8859-15?Q?factIsUXhewTot+dDrLzBeZKL2HgYK1i+LGx9hhrTE0vE4DSuxlDJC0zr?=
	=?iso-8859-15?Q?nb+NH46KMWdy9skN2beG9sA3Dei57qq+6fY2/wibVA34PsjT7/wZp5Odb?=
	=?iso-8859-15?Q?4/Rpf3DKYYZuWGU/h8+eitae0tjkHOsRboeFRdNd9j47j4NIVjNZ5fe9t?=
	=?iso-8859-15?Q?bjCOMpKvT8ZjIknk05CiWXvXqdOJEue5kLOFSzn+nYnobn3/NKXusd6UP?=
	=?iso-8859-15?Q?/yA7R98WeQLVjr0S+i9lcIpR4BMMwABZMnb4N4hTquylfjTVAwrdmSqtJ?=
	=?iso-8859-15?Q?WtLRiiBcJvLSe7rm0Z2mHoI7VEJyDZlDocvVN/4T7ub5wwoStTOSuFYXB?=
	=?iso-8859-15?Q?1kPUJl6wehKtOJzPQjk6VNOmUz7xJouwG6GUVSRZvPOpw6NzwUxWzj84g?=
	=?iso-8859-15?Q?+suz8sHWXDR7ge+glPo1NSeLa0HlWXZUs+mOdABXEzSMKvhbqTxPsebq9?=
	=?iso-8859-15?Q?w69ZOK/i5CFL18nKsUPa7m8qiuBTEr35CHjAIDsl3JxvTmbe/MoYwi7dn?=
	=?iso-8859-15?Q?xWfLkbt33PMCKeOEsLJqsnptK4XQOOeP5A1DEl17JSttHdvCp1UrZDAZv?=
	=?iso-8859-15?Q?os3S6miohv3Fk/YynSYlynRKhfoOxu2MhWNB/VRSY571xEM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa27583-5906-4e3c-13d7-08d9ecb62d02
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 16:55:43.2324 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rqT9g67Pwf0RDUjtOBOJnC9ac0B7AK0bHdQ7Ed+1zreNb/4ZSh+Vwr+cRZc9fO2wfm9YlYZDF4A4ogezJKTrHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2871
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AGtmLO017923
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5D6226903E667C4AA8AF0F06560735F1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2022-02-10 at 17:07 +0100, Martin Wilck wrote:
> On Wed, 2022-02-09 at 19:28 -0800, Muneendra Kumar wrote:
> > This patch incorporates the functionality to handle
> > FPIN ELS events present as part of FCTransport daemon
> > (available in EPEL8) into the multipathd. This helps us to
> > reduce the response time to react and take the necessary actions
> > on receiving the FPIN events.
> > 
> > This patch currently support FPIN-Li Events.
> > 
> > It adds a new thread to listen for ELS frames from driver and on
> > receiving the frame payload, push the payload to a list and notify
> > the
> > fpin_els_li_consumer thread to process it.Once consumer thread is
> > notified, it returns to listen for more ELS frames from driver.
> > 
> > The consumer thread process the ELS frames and moves the devices
> > paths
> > which are affected due to link integrity to marginal path groups.
> > This also sets the associated portstate to marginal.
> > The paths which are set to marginal path group will be unset
> > on receiving the RSCN events
> > 
> > Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Thanks!
> 
> Martin
> 

The CI found a minor issue on 32bit, which I'll fixup myself as shown
below.

Martin

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 2a94024..a5e9477 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -287,7 +287,7 @@ fpin_parse_li_els_setpath_marginal(uint16_t host_num, struct fc_tlv_desc *tlv,
 		wwpn = be64_to_cpu(li_desc->pname_list[iter]);
 		ret = fpin_chk_wwn_setpath_marginal(host_num, vecs, wwpn);
 		if (ret < 0)
-			condlog(2, "failed to set the path marginal associated with wwpn: 0x%lx\n", wwpn);
+			condlog(2, "failed to set the path marginal associated with wwpn: 0x%" PRIx64 "\n", wwpn);
 
 		count++;
 	}


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

