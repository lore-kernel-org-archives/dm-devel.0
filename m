Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D5AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 21:12:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-Sn-MZ5BSPhuUO_qttb0Edg-1; Thu, 14 Apr 2022 17:12:28 -0400
X-MC-Unique: Sn-MZ5BSPhuUO_qttb0Edg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DD941C0904A;
	Thu, 14 Apr 2022 21:12:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A3B3404E4AF;
	Thu, 14 Apr 2022 21:12:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F2EA194034A;
	Thu, 14 Apr 2022 21:12:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7136D19452D2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 21:12:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6415D7B7C; Thu, 14 Apr 2022 21:12:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E68C7AE3
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 21:12:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C652D1014A61
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 21:12:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-2ccpxpHYPAOIws4K64RJDg-1; Thu, 14 Apr 2022 17:12:14 -0400
X-MC-Unique: 2ccpxpHYPAOIws4K64RJDg-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2052.outbound.protection.outlook.com [104.47.5.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-16-3zFpLZ78Og6C-FL6lQYvDg-1; Thu, 14 Apr 2022 23:12:12 +0200
X-MC-Unique: 3zFpLZ78Og6C-FL6lQYvDg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by VI1PR04MB6030.eurprd04.prod.outlook.com (2603:10a6:803:f8::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 21:12:10 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 21:12:10 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: use symbolic value for invalid pcentry
Thread-Index: AQHYUEQuehaTQi4QKkGHGRLn8hT3P6zv6BMA
Date: Thu, 14 Apr 2022 21:12:10 +0000
Message-ID: <4bf968d87d7bb07a52217d8449bd53b3693c9613.camel@suse.com>
References: <1649970670-30135-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649970670-30135-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 185ea04f-f0ec-4fe9-e4b2-08da1e5b7093
x-ms-traffictypediagnostic: VI1PR04MB6030:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6030D5C48B8E77C402229116FCEF9@VI1PR04MB6030.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /iLS933jgJwhQSYpH/xvL+E3T8jTZDx97B94zsa5ZIRoK3juBQJvlQ6zXyKp1rRLIcDiimnJ+RWrl7rhXDyK7y/cwVcEc/kwzBY56Ki1QC5BJBmNoXvRQ/Nt9x7DNCv8IzzbwqZgRGhZGC5kSzx26iee02GZutPcUv9xZz2p8566FVs26ogNwW5T32l2yKce8MAS06P+YwyMndMO3kJk1VlITKzAHvM2/IJqbQ3HLSePlpamKeJJ0hpe3Pu40sfwUIGCBx+8F8XiQf/CeI/L6Z63zFZImHy4mcHJQ80VZjS0hG8bRh7byDg0J1p9MkzceE5+OwA+r6/+vcOQGLxbQ6n50yaQTys8dskNrKjDHUQYEn/tiQVyxORv8MAJrQODsgWgnRWR47ibHjuNKOKV2fksrmLd+sgpW2/nmFbjHSEOvhB6oUns5WHNQeq28Ru80xbIj3j1xBrNQkQxBOQqkSY9NgwWTC1H9U4WKcMReAPCRhd1+u6raIEaKUelt2houoxxrVbxHglkAw/LzVD2B0ktcMI7YZF3CvgTsXDZTl48f5Ut7attLpQZukcoLJXrtmHVc8jPWhCF8rtuAQJf47jZ6fBlMPCrJWDOQX14DWC+RYMS5UYe+Y8RYukgtnBWZQnXakdFFAyFkf1k3vPDeZ16ZqX54y5LToBX2QogadsgtZOPzFIpsxyR953jzz3eTddxSCNKY30NJ7KZ8WVcqw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(558084003)(44832011)(4326008)(110136005)(186003)(2616005)(316002)(5660300002)(8936002)(2906002)(86362001)(36756003)(122000001)(91956017)(26005)(38070700005)(6506007)(6512007)(38100700002)(66946007)(508600001)(66446008)(71200400001)(76116006)(64756008)(66476007)(6486002)(8676002)(66556008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?NoxYpV8lGHJrEdKyuITxCOqSfv00EJEsQ7TRTZ7iRGYRkG7DZlczowVVo?=
 =?iso-8859-15?Q?kY9Spna3jOUZH7IoZaOdS5YedPsaXKLR0g7oXAgVrFVbQBfHS02CemV1g?=
 =?iso-8859-15?Q?8/Xwu68eyWyxpd961mGf5HAsjS+BWzw0Nuyv+EBT3LrnXb3jhsTYppZvn?=
 =?iso-8859-15?Q?sjjrw5A8UJAw/VsnF29DWPnTDmDFIcG7f9urYMo8X5WTkJmnVSdX70RE0?=
 =?iso-8859-15?Q?i9IJWa4K6Pw3doGpC5BdbaTQx9+6F/dPRS9uXFImy6pDkUGNMAGEuQNtW?=
 =?iso-8859-15?Q?uPwrrwF2W9FxtApNWtLSCkB+Yz4EXmqK3wg2LhObmkUko+Yn3BpVj2swG?=
 =?iso-8859-15?Q?vpqEdBfrvW8oeo/XBR/m+KG8QNxE/xQNaftTCgbKB7Kl4w1RQOJiK1G73?=
 =?iso-8859-15?Q?SuGGZohTvsOym0DHrsLlTVJIT8vQ01b/Gi78Lm+/5jwTLSESYmlakeQv/?=
 =?iso-8859-15?Q?RsgpUmHBwYLU8LE3jVMuHoLzPSCdG7k1hAI2A7/Xx+INEm99dBBPq9aIT?=
 =?iso-8859-15?Q?+lVaYnEOtO9iVCaCg7YteIfljPkbRLL/wFNJG2NWkGKIwbt5NPtjq4arL?=
 =?iso-8859-15?Q?jPwRXHmNZotyUXLSpmlKFykitxT4o1tRQiMLuHOj40KO+en2rcv4C5l9w?=
 =?iso-8859-15?Q?kNkDyZ6/p0d5CmkRdHRvj2n5mTuc11Sunm4mI6wyqLRmMXfTURSbJiGcW?=
 =?iso-8859-15?Q?w17+Z578Qhs8yrkWYiN8I1aDr/dBfuifXwD++jT5n6Q8n7tbwpBflpFlP?=
 =?iso-8859-15?Q?QuYyjhKcHDB0vXGtpnUIZAeNwnPMx/uB21MnLfUecV2zh0VSaSyDrLjc3?=
 =?iso-8859-15?Q?mH1nQcIkq0hhEzf40g13hXMBze+rgY91Ed55ycyDvv0DJH+GDoRXVguIY?=
 =?iso-8859-15?Q?H2R2IfBiibLsccmlgNY3Za/GHSU9tgSCMjMilL+blSJoZUyKqf95yV1oM?=
 =?iso-8859-15?Q?Dhe0eDwUnIGJnZWnPWudLvD7BJz2YJ7GaqI3ZOXvfSGqLCxwPzya7IeE2?=
 =?iso-8859-15?Q?UQ6BNoMLjaGl0qrhkECkqBml2u28SEUU0zQU+ND1m0/G3iFj7xKevwkuD?=
 =?iso-8859-15?Q?nju+z/H4vOjVXOaK5OD4tEG7MmfWveKBHcJIuvxwX3uVQnormTlnDlXly?=
 =?iso-8859-15?Q?gXOcykwnEr8nVFvhsd4ALIenmbDFtlhjF7ex+J1DsO4OTDvrVrDAUDeUa?=
 =?iso-8859-15?Q?ml31gbDKCQGMv4u7bfU7n/YjbkXN67wpusSazQP3Sc9s2QDDD2dyDN5ne?=
 =?iso-8859-15?Q?lRfzOXFZStBLqIhmRHVSxIQKflbFZg+CQTVpaWBzGntfHRBKAnwqXOfXP?=
 =?iso-8859-15?Q?LwZrIf4lbPKHe48ckVupX71y1SIHnE36YUvtYMcpBxSzw7eNKsOjFTYjp?=
 =?iso-8859-15?Q?ShlvCjxkNFxXACBa+vKRy7L/Q1svuy/t/bvrmgEqV4wJuAJlTIIxnnXHD?=
 =?iso-8859-15?Q?3n1yH+bjrNGl1UTS4PpBM0poDrEW6X2fMbFTeBUUBPisQVBu1Tgtg8LXQ?=
 =?iso-8859-15?Q?gFQHX+PwJOwYHvSCKT/K41XhOcsNnGiVDqTYNnJFIsvq1CoYVwkJlJQLq?=
 =?iso-8859-15?Q?VjbU5mh1PBsJxogG9N4kIFvswqPJo0/DUZF5416WpeCZSaSDmq/hFvQem?=
 =?iso-8859-15?Q?VnisaSYBW7zD92bfaXoXxMEPSXHP5tT7i8U2LYeyYN7PR1PWOhdI582hu?=
 =?iso-8859-15?Q?jDsy/aN1rlwQhE6+fdLIfQVRBWCJkn7joR6avvLo16zuDCpr3gf4fT3ip?=
 =?iso-8859-15?Q?npVAKHYNXR1WpovWTyvhgGsB3AUNL9uT3dgQ/3jAhWpsfHShAT4Jppyk5?=
 =?iso-8859-15?Q?SXv8lt2M9kQCchNZTrt0VhiZ2iRQGTIkmbdruF9EdUKQpGUaw20wFUKQm?=
 =?iso-8859-15?Q?yaPU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185ea04f-f0ec-4fe9-e4b2-08da1e5b7093
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 21:12:10.5475 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dAFkhYaS74MoMp3Xn9r5XNYLDfMys9A7ChqFay70/3X8vJZF9b6ydKSQpo4fOKsXu9xmw4KmK+j+m5ZJpQy3Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6030
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] libmultipath: use symbolic value for invalid
 pcentry
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <78046B7FC6F61F47BB2ABD92E940AA63@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2022-04-14 at 16:11 -0500, Benjamin Marzinski wrote:
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

