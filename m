Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE89DC43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941319;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=LOb7y9RbcagWX0yGQwSRpEbBTvbGwz/ctmxmiZkFnypleGJyfPO1xpacFDmJRWmdbJtreT
	zFNSjw6zly4zoOzttzgSdQmIk42uolNGueSO87u6ofbDprctQK3SveefBt5XMVNAfdikrq
	jCk09BR3vfCb7R7PSd23WmH7H5LpipQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-8NoFH4dSNNuz2yEdlOrJyw-1; Mon, 04 Jul 2022 09:28:36 -0400
X-MC-Unique: 8NoFH4dSNNuz2yEdlOrJyw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 035A480390C;
	Mon,  4 Jul 2022 13:28:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E671F492C3B;
	Mon,  4 Jul 2022 13:28:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA6BA194704D;
	Mon,  4 Jul 2022 13:28:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C9A83194704A
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:28:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BEF07492CA3; Mon,  4 Jul 2022 13:28:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9E5D492C3B
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:28:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1F4A80390C
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:28:33 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-R3Fmb_WUPjigbmFa3v3cmQ-1; Mon, 04 Jul 2022 09:28:32 -0400
X-MC-Unique: R3Fmb_WUPjigbmFa3v3cmQ-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="204767565"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:28:29 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:28:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:28:29 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
Thread-Index: AQHYj6QNR57Pa1MQKE+RuFMYfKVMlg==
Date: Mon, 4 Jul 2022 13:28:29 +0000
Message-ID: <PH0PR04MB741686E3F46025901DDE5F209BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-16-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be0cb1ed-353c-45a6-7624-08da5dc11590
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: e33nQ3QjIuxVtSAd1qHM9DDwkVmf6XSWKZ4yOEjR09xQStjBb7aq8H7/qbEn+8ZpyTyVDE0fvVf3NBTIVUmLIomMBn9YnX597+trKgfR6wtZq/ASj4fDn8PWdv/rEQDFYT81MatgsD46XOWnt9tuIy2HE6fCcgjJ3AdH/tbslOG8GOy6/fiv4DUN5LJKGIFt4CfY24lCKqjRVCFyNAOfnm5s3aUZytgabgXSijlY2u4ValQn+GN+8dd6MQLMGbevaVDOWrR7CS8leSvCPbhA9cJIZHj/Cn9Ay/lbIA5kv52fgD9PceH8G/ngA+0MhW/rc1N9LSVsEvOjovN+PZGZGZPInvfo9ZEqoISepidjedHopK2TgmX4LWj2QmY9rUnmY8JiQZydc9lHfJYtuORQjUBPq2kJVvWLQpVIU983AapoSTO8G1gB6JwZGBJFHm3RnRrXxUZi4i+2i5/PzvLW/SDhY+qaGV6V3BYywNKMewKPrIwgCY1XKSnjXTYvZkX7zHnp2jJJ9hJPXK4ly371nafxze9OdQRhlPz+xsFafgYALzNp9fiV3Rj3GELmfJshEmjS4X8IuvjOuSOlc4TLmL7MJxE9kSCz/lQGSnBl/Y8t1lUmzbPwTvF9/O7tqkXVi6yNOAvXQ9gca0mkJNrWh1TMEugeLDyjODjgKpSsAG6lJnGlLtHBAqxPyKoVVMHCCeFuHSa7thYQXsQaba/0Iw7XRFxkh/Fc+u2LMAaommsmLqpO+/+r5La7iyNhdahvEmA0jXQoALBid7aRiB6FWX0LkWq1dDHMeZ9LKxZCXJbazMbjSsJ++S0jXIGiSiOR
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(55016003)(558084003)(4270600006)(38100700002)(186003)(33656002)(2906002)(19618925003)(66476007)(8676002)(4326008)(66446008)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(52536014)(9686003)(5660300002)(8936002)(6506007)(7696005)(110136005)(86362001)(71200400001)(316002)(82960400001)(478600001)(41300700001)(122000001)(38070700005);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5isNnPWIzrc3mblO8qymwg5g27PFlwnhX6XxtEpU2PYrwEOFuj5ZqF00FAO9?=
 =?us-ascii?Q?4CASnjK7vpXsOqKDQu64EiAROlJO2wnm95Dm66eG53VNvywHonSm6MjpE/os?=
 =?us-ascii?Q?81MXx3daUO7TOf14v/cRqy2dXfh6vu9cKh40VehWh8Zbuc77VPArVD//QLD0?=
 =?us-ascii?Q?7VnX/bPOLruNMED1jB6FpU5UaW5SbOQgASFMSgynb7ohcb6fqSURAaTCXxyt?=
 =?us-ascii?Q?Gokztf5Oop2iuquRkaU4JxqOnxuW5j6WlwnOcOXhR2oPbbSSo22VDyAtT/CM?=
 =?us-ascii?Q?EQPoVK/DyUWLqKMlB2Lrlfy8Vh41D5m0Yf1aCcl+XOEN2eHWUiT9lD5usNrJ?=
 =?us-ascii?Q?Vi2YgFEFj68sfRcC4NbISip4lW73D3nymhXW9RvxAdW5hHe4ISgrzzpDwGEM?=
 =?us-ascii?Q?86AooGoH1GTKehfTmYfwVkARmK8PDhXAHagvWdJVpTRNn6+2QJFAxN1oi7NB?=
 =?us-ascii?Q?Qskn/YSlRE16shWwVyOC1oPxSAvfYQ3wAiTQsWfm+teCTk/4uwUg/cMcG1By?=
 =?us-ascii?Q?0CW4c4ZeuqKn02ItxGt8O8LqQO8n1T1zpeHlhrpDRvOw/CqsbJ2/y5bwNSVK?=
 =?us-ascii?Q?fIP90kne69B0168rLQYfFtsXt2PcHAwuVV2maNo4VtRQHaSmOjPMjXtGbyQA?=
 =?us-ascii?Q?wgJd8wpOee/zOArpoBNABI1AmSdq0OhPNw4RMxEaPe6qLbWTn0EdDSrindt3?=
 =?us-ascii?Q?qb7hkgQN4+6/uHHRxgX3dr1RPAMRAiz7JZgVOdq1QzCxkfuPXvPXXg/5fG5j?=
 =?us-ascii?Q?KeMeyn053RheCvadqzC4GyPLw1xnAj3yLnSwVNrAp4vcp8clU+i4gEARhwEZ?=
 =?us-ascii?Q?gF4QFtlKXkPlPz8xI5XcLvZkC5ALSYbTLGWET2mT/TWOzvv4L4wFQXl/d6qh?=
 =?us-ascii?Q?o2HDEBuiM6X8pxO4UbUd9cQ5d+W2+RXybx2TWbRGFWwg8IiZdCjZirxaKAjl?=
 =?us-ascii?Q?u6rd+rsgls7bTXKAOM5H9Rca6bGVDEPiBIZQJx72UmQqxKdocSvaRYDFhBm0?=
 =?us-ascii?Q?voZNnSdZuolRdb+dN8SJPbqJ7ZXcFmasJAqxFdbbm04WTABYQYQ1r7VGbV5z?=
 =?us-ascii?Q?On7uH9PMJUwT7POEEhRNtjFYOIxVDvDzMb9eXUhn0D8U8B1oKoL3TkdZqLO+?=
 =?us-ascii?Q?626h/VERAB9ywAyTSRjF/XyI4SptzskznFw2VUVF0d9qEt10/xknh8ON6S/G?=
 =?us-ascii?Q?HNYZCov4YDeKFAs7VGCCMwiJH60oYsWbRcCMNVT1tu0uAKAEU1YwNYbniEbk?=
 =?us-ascii?Q?A/To3flpZLAalZEEuRzg5Wt/5opRCcckcNmsc6DljF3OCj1VlimKrR8C0q7Q?=
 =?us-ascii?Q?lPp7W7PFkcuJTYC4AlJHRnn6Iw2vqKyDgCL0WOD/5U5Qjpjv4CdnCAckd/pP?=
 =?us-ascii?Q?gF3lwNezWOPhmCvbL8HdZvIcseI32EFoItD6wM1WFnURWedLRFuYNd1Ek4Q4?=
 =?us-ascii?Q?hbykmlBDKi8SWDo58b9JU+mWax6HMFyiAvFt2oOf+6H+AN9QySFXew1qNtLA?=
 =?us-ascii?Q?4gv9xOR5wnGFy6XELmi3jB2WNXrw3jmWjlVoHHX5FEG0Y/3dhAGhEOBFzs7J?=
 =?us-ascii?Q?COu2zY18fwgrZUGYT/gdVyvlrOSMpAnGdFL8ro6jDEKdLHThc/r297+vBE4s?=
 =?us-ascii?Q?Vd9dctsOOP1A13z3aCmdHI3QoZ8bIsBGSDCl/OfrST19IZ5iy8qVJ5Pz6YJZ?=
 =?us-ascii?Q?Xu1/V4jyI9qNP3UOQ0ti0PqJqik=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0cb1ed-353c-45a6-7624-08da5dc11590
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:28:29.7893 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUcTI4UFIhI2bb2YwyiZdZLpEHbUW8I1Ff5yNUpgOVZ8jUo7LBrberdSzZo9qFQnPwUvYJfe2akrrJokJKDWy8H3wKwep2rgYaK3m7Yi8ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

