Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D96CCA479
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941002;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=IWcNdCdbxusIuTN3tGcm7e0RzRRfVHFz6YADlO5tgLCtbBnTxYd/GoXcRMd9f7AEiF2uD3
	jufQAH7G7IlN7bprl2ksAHUrS5QyjW+J3ScoyYTLJ3kyCzpj8EqnORHAkKAb1IBZ8R/SmQ
	df5FCLkgs3DF3vij0t3rtp5ZpnUKtF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-AfhvF60-P7amF5iFsWiAqQ-1; Mon, 04 Jul 2022 09:23:21 -0400
X-MC-Unique: AfhvF60-P7amF5iFsWiAqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 136518339A5;
	Mon,  4 Jul 2022 13:23:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3FB240E7F2A;
	Mon,  4 Jul 2022 13:23:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D94691947041;
	Mon,  4 Jul 2022 13:23:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0918619466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:23:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D28A140E7F2A; Mon,  4 Jul 2022 13:23:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CDACE40E7F28
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:23:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB5003C1173A
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:23:18 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-sROFl0KtMYKybo-djZ8_-g-1; Mon, 04 Jul 2022 09:23:17 -0400
X-MC-Unique: sROFl0KtMYKybo-djZ8_-g-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="316886321"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:23:10 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:23:07 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:23:07 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Thread-Index: AQHYj6P8W2g8ljstqUC2nb6WLoCFqQ==
Date: Mon, 4 Jul 2022 13:23:07 +0000
Message-ID: <PH0PR04MB7416E28A6B375325491431579BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-10-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25bd764a-7f3b-4756-941b-08da5dc05586
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FEFN5Wg6RZiW3bgUtTGSzpAUX0rmRJ5wJmQBwYZUYqiWyvT8IC46/5OnrC03K6aY2q0Nva+I+uozOLQXvjV31B6uR2ZqeRl9RME7TPpXcCK0zdHKxXWiGd8HL1X1LfupvEmeQ28DucuS8+Z8Tgj1UGbOI7x+IJwa7sWWMLcKp3M4CfyugxYgryoHgulDNtgtaq3E6JY70vTdq4WrBJAh2TudIvW5fmqHCNNEMzu2pnVNRq37EwVanSNX+EH6IvQYj/X9YCWdCnO5YBDMn6OW2Yk7Dt6nAmSp6jxnLfUDuBFJEwYI1jDBnWC/WBvoA769Bj5VeN3NT5CkCWGBAKnBkIDONJJv3tvDSisMQLGu1B+plhCCHHzpAz/VQN5AHn6XEWm5c1L+MgAS6P2B8/KhkMXAw2ONKETceRTHE49kqZtfe67FIa9SbPJwJg9mTjJ1miw3duOjXj8blCKPVA4WgXNCsQTQeX/gCG581iGG74cNgLEbtfBawnB/4EbbV691y2bzo1Y63b72t7UIrOuBld0uUiXh+Vd5mG8VPhOvsYb2PAtqyNLJl8W5PnPMAg2ex/UJFISWpKdLFT7ZmR6YsxMY4xqCekkv1qKappbcMBe7J90DGozPPKIAyQV/+OvWJoUgvLll4Pt7xEHBKGZ6Qm2WxMBH2gVUzG4g1RMXsJk3mA0Rn49ghbkzMq7DyLNkZ8HL0z7dhYgQ6kvZbcKvs4Mooa5ZDCiCZVSKS4SrYzqXIf44b/C3W22pSadnjgzgNqBuYWSZ4FQOvD3VV8dZnhdB0/bDM1HT0YivCOYIRsfUyFxpT9cYSo05rgrI60F7
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9GabfyP1HRk7E+S3nsleCNZiH2ty6YFfckhL2DpBxixdMKt1eE/aAzSQO4l3?=
 =?us-ascii?Q?mqbJmwIbGUuaB9di+p+Do9u0YrYJDNJ8utTjvzwZmtY4bIGZKlpJpPli2z39?=
 =?us-ascii?Q?W+UFPvytsyTpvOuWdc/Ma4pPAAAeDUHQ81zbojuAErOmyP9TZvmcrDSumazE?=
 =?us-ascii?Q?Onbat4f1cax0w3KZffC7pvrEOgUMchZB4WPQ2c4l23XHrJLhmU9ADSdwSl0m?=
 =?us-ascii?Q?T1DdmM/Tzb2/IWGSCtCcTgzljsW0WegPrxHq0mre301R56qLxQKbpjLrO36J?=
 =?us-ascii?Q?hV5aTuUqWHdjTyN/2NJjfjJfd9CIfFfDl13087X48LlyL++hfFCVOFCcc1cB?=
 =?us-ascii?Q?orPNZh1BtiLkElH3KxSVaK5Hirxv0RT2LHIn16UvM5jK+oxiW5xblreuWkIh?=
 =?us-ascii?Q?c5gbUtWsB//QlJ5vWZqcPRuqusqezaJJyCMfHFqf3iI2qxDhRblNlsH1oPps?=
 =?us-ascii?Q?WMbqVwWiaxar6V8TVj4MUE8dGyBmQLO+Fw3Rmv9oYvccWmxlOPlnnEdAevMy?=
 =?us-ascii?Q?GjmbobQOqz66+uB1V9UitzgFaH0unD0072tpZMxSruiDJx5yyz8L1yOJFJGX?=
 =?us-ascii?Q?mc4qbMYvM7Cn5ZwTCoe2oGipuD0sqleX5I93zZQJ1csFQyYlszLHj6mhztSy?=
 =?us-ascii?Q?3/cg1FdfNgVGCfgxwDGJi4ywnSQA+xPtSAqin4DNX9qYlMf9pQs1sqEKrUUU?=
 =?us-ascii?Q?AopoTbFTVc584Xl3aa8ozzvYET0nfI+/d/GZdkxlJhMYY5TIop3ZtxkhLJq0?=
 =?us-ascii?Q?t44DFz0zlTVyn9VpijHV7ki0jG6gchRN+9FAgYi68/9JMOfz+V5EOcmBr3lp?=
 =?us-ascii?Q?xkjJZ2W25QRXzqU6lXWrA/xZinKUk48fUbzikJ3oNpNofQjx5M7pdBq4s8MC?=
 =?us-ascii?Q?Ar66UFTZKVo5RxsFyvs7DZJ7JZTNuDJXyg3Wug/95SWSHo7GRHlo0/3fy2iB?=
 =?us-ascii?Q?/VCVyfmGVGikQZfb9t0L36BPGVOBDUlPpDZ00CySutEuAHeORO4IYppoLC9t?=
 =?us-ascii?Q?m+zM9s5eSxEy/soZalNx8t6f7o0FPlFP6pG12TP1NVM2YD1AYDy+ZemOzhtm?=
 =?us-ascii?Q?2iMHafVzxBwR+fDL//m3I+HJISdNK53Co3Wm/uToyRGO5HQhCZGuRxJ70D5w?=
 =?us-ascii?Q?QRYyvh7mVsNB4clZWfLkCTZcWG6Jro5NvWihxSBU9q7tfq2F80YYC1pyXNre?=
 =?us-ascii?Q?TVnjI1GOsYppQABO7r81BsNSkX2t+K3R7YiLhkIG0vL7I+qVCQcVAQxrZ1O0?=
 =?us-ascii?Q?EixmfbKZS3Wylz0JUfBARUBamD6DJIoieUtFFIragjmx1cnN/36/XIN2Xr4p?=
 =?us-ascii?Q?dPhRCCk15ACmkdc7/1w/0Y2xFUPa2VUL33Lxp53WXsnQiB11zZB21sYuJGHQ?=
 =?us-ascii?Q?3e7RUjnpC4nZiOBKk/X1GkiVmBWslOi9cEkgZLafmmJp7JBqjiDCNl3D4mSk?=
 =?us-ascii?Q?rs6XoMyMZwQB4NHPu36yqShj+guL30xOD5R5MNHQL+eOHwQtVkzb8ptOF7dA?=
 =?us-ascii?Q?pICHfc1jz+u+OGwS9zZASpAgxPKC7N/0iL8ZrEbaxeZ/xhpHc+q5EMI6TnW7?=
 =?us-ascii?Q?92j9Va5eV/Qclj+F9tAv+3M0A8HFa9l9jqHg/DgTSI+woKybOfTPqbxjf9sD?=
 =?us-ascii?Q?cTId6EVIfET6CpvLSn8wxdK1hxGqBvHNMVxXvIzRN9AX2UvrnFYyQhOLZb24?=
 =?us-ascii?Q?piVMZey+mmbWqPjv35Cj+6ONF/c=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25bd764a-7f3b-4756-941b-08da5dc05586
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:23:07.6177 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6uo+UJL7b0Vm8/wawJL3q0rq0ir2gEocL4VvXMPnY5mLfvxS3OFO1cNOcuKOWvsOIEh5e93Nj3qxotVjZ/jANBns1Mid1BPEZCyLo25kGyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

