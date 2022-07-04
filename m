Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E73C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656940991;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=QTmWE2vhkA4NbBITw3gMIeXYJOSpXGccJ/EsdymDUyret0BkMEsUgSv3X9JGa6MHY2Izyh
	XOgGEDo4t3kXpRMo6Hi+phUIcj9YYzkoE5Nuo8p3RHzF1+WJrz4idVPBXeBx0M6cryfHrq
	gCa7v6mxgRxWaD4A++s5CnUxFxQ4h8k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-ECP_tya1PcW2NzAxV1jbqQ-1; Mon, 04 Jul 2022 09:23:08 -0400
X-MC-Unique: ECP_tya1PcW2NzAxV1jbqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A4388339BD;
	Mon,  4 Jul 2022 13:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 349222166B2A;
	Mon,  4 Jul 2022 13:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E5A48194704A;
	Mon,  4 Jul 2022 13:23:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D9F0019466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:23:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2257C4C7A0; Mon,  4 Jul 2022 13:23:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA378C4C7A5
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:23:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89C0D8339A8
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:23:02 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-c7uEfEnPMt-ud1cUUjGepw-1; Mon, 04 Jul 2022 09:23:01 -0400
X-MC-Unique: c7uEfEnPMt-ud1cUUjGepw-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="204767248"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO
 NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:21:55 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:21:54 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:21:54 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 07/17] block: simplify blk_check_zone_append
Thread-Index: AQHYj6P/DrtBcNYUt0WfsATrLdpl9Q==
Date: Mon, 4 Jul 2022 13:21:54 +0000
Message-ID: <PH0PR04MB7416AD2DCA0E8D8462490B909BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-8-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcba4de9-88ff-478c-1377-08da5dc029ba
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Zcq3QmtBwT8Ha8d/3rb8uYo+eP3mvlD0/ZRzPbKS3rlx85uwda7xxc3mspmQIuqE7fUfIEZZhn6oCopzvD1P0U68cvsR4NMNTgZMBeRoPf+uATCInK7fSHoFZZlNkpZCruyGsrRHNTuHA9ridevHChk/9eMj45IBUYVNRO0nFE9QPfur5MQWBeMbHZmGVgAdaPkD3zK7x3syR6nKcNHlj+PchRQFwgqSdj/L+yde3D8M+dtlvcoLrLLY2eq9vcbYabroEw18dTZ/xkppM33JO3LsXGOz6Sz/YqVc5b0f3Aa1ky1XlDeF+YmkZFNdsjPRjh8KmPYS3sVYwz+weZsZbGsJu9wjkyeoZcqIT5XI6pZDmth85UOE8K8fcRObXHn+Dv8/thunZ4AONik1PwpZ+XHWjQNyWiNbZTopY08IPjeINUHL4SPimMn1gEsRqJHsa8W/VfFsprTxfUmqz8+FzxUPSAADIYP2O7aBU5Vuu968n/zxHm5ZJFiOkF2oNVvlcQ5aUpEqvPhy8wE3P6N5tcJS5EhN3dcMOo/OE2LO8kWULiKyLR2jqBjYlpix6fyd1fZvT6PnlPkwOL35lXHZlN/ykpqd+FGMGMAQmdrjL+5qQCSm0OvHYGGbV4dQ+yCFsITxOCkPDFI9bTWFuOPdxK8uHZO64Xbews8hHNyOE5kXASXgedIrhH3c0QEeZQ/fNyvQXGo2rfHV037IUJEUXNSsuTUHS6uswxYQf7uu2S6IqAE40RALay4T5dU1cR4oVHWJtOJSnLZL7qQ9rklJEiGF6jitke5vvXzi688AJfBiH/cpzGSwBD6hxecZOBKj
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yMvkpu3E7Avt8krnmJPqNd52BTCFXKXB+D851+b9j7zwFQqP+gXgx7cGILLZ?=
 =?us-ascii?Q?w3r7ph5ZfNPt34j4sqfhR1DlJKWjgR3k8/0qosXjAOGntCa5uTlcZlgqS4jc?=
 =?us-ascii?Q?NjhV0IiNDdK1fhSjzlYTtNXbe7lgotVE2QUHX1iOaWeG3rdp75Al3ZbDlCpA?=
 =?us-ascii?Q?RdY9Q0GqpZJgczfHQB0bWWFFXhwkgLqqqBWjzY58z0TquHbvlpcothiQ7REb?=
 =?us-ascii?Q?y/+lzrECpLwGfJxDIl3oqeA4xW5ru+A3goW1HpWEg0oz8KVHHzxxJPmk0D0Z?=
 =?us-ascii?Q?8otobRrWlbPnFquMu2mXbKkBMdwL8L6Ok+oe8/ALGzBa1RzqBPtfKS+p1vc1?=
 =?us-ascii?Q?8CtClg22AFGMvmQbqljs1KHvYF8xsh6xI9cBKt2Y1HgJu/ULwUAPlAalnZsx?=
 =?us-ascii?Q?2ZHFqUUzaTQ2RIoEvp5BRuoQIjxkgT6CJ1CJNvEHje+pdcMcXTZYBylX7Nwo?=
 =?us-ascii?Q?SGYk+J6iYfVdn825qKGOu59iK9BWToaOlhGCeUhXypGj9PIGGQ869aizx4P7?=
 =?us-ascii?Q?yvobfs4LcjnN2MoFpbv8W7oCQoffWw2hWDnzUaWal1VR7hIrRutlidmMhpZv?=
 =?us-ascii?Q?7J3my+y5p3xZ3yXSCmd4IolN/Jvxq5CbHgc/uXba+qEbhxgTdVaniy6a6t5X?=
 =?us-ascii?Q?Wc6NwuMWrAQU5SyK1bw4VrGuBLmodSry8cRC8BWamuQQodEMVrf4xEjpIXDf?=
 =?us-ascii?Q?Qvi/LaTCjyeA4DJWb4M+zoGG7YoARkXcvuw7MH3YIhFQnugk+SWf06FrjHK4?=
 =?us-ascii?Q?Vfo3QaFGrco5epDP4d+uiODBoBMwi/R2fbcVrhjOchngTUE3j4bs3rWiLWGi?=
 =?us-ascii?Q?fu7IlTs/V0DQ4z4Q2CfZ/kmYcoTtgAlL692WUxjmpC7IcMzKvPDaLpI9IKNU?=
 =?us-ascii?Q?ugAa6q87ED+Y6+Xjc7N2oGTCVdMCnlSg+0FIis4VgeyjCy2AzviQdb+9RJb+?=
 =?us-ascii?Q?MWLXS6rmOzM7a75/brhWQNzBdDz0/LR7H58XrUpb7lnvUHZgXLBzFTdvk+TF?=
 =?us-ascii?Q?uG7pvAhcW0MM5nSW6Z/CNvDXvShqTYbSX/wuvPXkRUg5kiLwC3UI1PY5QNkr?=
 =?us-ascii?Q?THOWncZ393ggAQZ3U5cmi+GQMX/LrxHBMrh2sgklRzf0YiPjAk9ETpbSQsaL?=
 =?us-ascii?Q?mG6ZNcS1ZZRK/kCgKCze4zfHZJktjM3wSPgdFsoSm2nUtXkTwTP2WzimQfLy?=
 =?us-ascii?Q?D8MQ9gyiy8SiBhOfRl6xplkKOQ6jfOtDmTiHCk9eKWujvUKNcjS5zmvT7lrD?=
 =?us-ascii?Q?d7flGZlwsJsYsN57jBJwCXUW3AqIdEHfh956cWSbNkZYeflEYoT9kMLEXBLy?=
 =?us-ascii?Q?PRjDW/rksTpjr5EbANv6j0F1d9417Zr/bLloaXvFgHdKty47SAETzNo5Z0NB?=
 =?us-ascii?Q?Roe+16Y6A5ChvGqAtTfUlff0pfThOJcF7dWXGQlk4lMmPM6taW8MeKE5J2H9?=
 =?us-ascii?Q?OkbKGqDRJ79DR603EC6qVPoMbhOnEUohvEX3O5hNN1x+4UZ/tRbULTQFm2w9?=
 =?us-ascii?Q?rQLmwUHhFsUaeAwAzbVYg8FsbuzA+ir6CCFaSn0oDK9N4K3qN9SZTKVAxTFu?=
 =?us-ascii?Q?1dWTaEPjBgl6V2gfKdfeagXX39q9MjEmmj7yTF+yjV7q0c73M1QYrjYxA8ML?=
 =?us-ascii?Q?zP64goqcxqhgI6BnHUSx0lVaLheMEcaLkGVZurK0FZ/8LLEem36ExA9A+sJv?=
 =?us-ascii?Q?HRaJXtQeeaqfwdWo9XqjVl9SGqs=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcba4de9-88ff-478c-1377-08da5dc029ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:21:54.1042 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9zJqxoEqc/brbp4cR9TwCs1fM9r7m/fSp1FC3Csk+TZn+VIhd7vUk0TL3J4Syk28e7+UKfm3JehhKvtI3UVqu6CDqtsn/itA5Wo5ahrTYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 07/17] block: simplify blk_check_zone_append
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

