Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B17C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 07:48:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-ivYRgZVBPAWU-YoGyAlXIA-1; Thu, 14 Apr 2022 03:48:39 -0400
X-MC-Unique: ivYRgZVBPAWU-YoGyAlXIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C77AE86B8A4;
	Thu, 14 Apr 2022 07:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6104E2166B4F;
	Thu, 14 Apr 2022 07:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C6561940345;
	Thu, 14 Apr 2022 07:48:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BD17E1940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 07:48:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 981762166B1B; Thu, 14 Apr 2022 07:48:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92CEF2166B4F
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:48:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 955E1833962
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:48:30 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-MA73oF4-MUac_ta0v2wojw-1; Thu, 14 Apr 2022 03:48:28 -0400
X-MC-Unique: MA73oF4-MUac_ta0v2wojw-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-bNEmHUHkOhWDqqaoDCqb7Q-1; Thu, 14 Apr 2022 09:48:26 +0200
X-MC-Unique: bNEmHUHkOhWDqqaoDCqb7Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB7PR04MB4058.eurprd04.prod.outlook.com (2603:10a6:5:1b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 07:48:24 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 07:48:24 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 4/7] libmultipath: Set the scsi timeout parameters by
 path
Thread-Index: AQHYT7gDq884zg7wxUei9tRmoorl7qzvCJiA
Date: Thu, 14 Apr 2022 07:48:24 +0000
Message-ID: <6c274e28d5ea97af1efe7008ae133de2679d772f.camel@suse.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
 <1649910461-25263-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf647a7b-0515-4cdf-cd09-08da1deb2759
x-ms-traffictypediagnostic: DB7PR04MB4058:EE_
x-microsoft-antispam-prvs: <DB7PR04MB405886780059B2CD646277A0FCEF9@DB7PR04MB4058.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: W78kQocWnE/Gy3BJotjZvefIomqOZpccIAflw7IDyI+BeuwixwCGldHit6lAfAmS9ZYLeMG/5ptWmzlM0aEYQXWXgAmiOTj8prJotshPdf+7aDZumNK6pE39/naV1iMgihM3YjKsX1uFPRzjZlU3MwNejU0Fbg38ha9V07hKyx9H8pTDefnKLzHAVHLQRBohH9pYjNvgXcvN9uFPB9i7Iyf3tgBuZakyREhFMD5r6pTtwoxmtboUoWxfpSJloGQagqy7Uxz3XGVxvir+2PchSUP2e0cEicG8kNvls8VYJzz60VAaQCIJSAFhSPU57XMcT/S7EgI7vUOjYTwKmsOcUGynrjfr336P112dEwJWadT28e8G/YYn+s/KBKKrOq4VPeivfbqu3VdghfHrZyG6xqmmmSGT4e6K60uO7KaMU5Bj7mX2URN+b9t3x9vjbWMAtNYIYPfPeiaZRTAq+y9RmFtKYxevFnaIEbwxBr33H4PPYVYHyuqexvVFc/0LMRjNdoyo0tlTGmbdIMBpg2KwJLSBZK4GXhLIG89/FDTfZ4JW2mokWNcffmx1CNIg5xoXZqHuf2PC9zvt9NzXblnRaJfpb/E8rpmNZGf0oAWE0B1vrrkSQ7SYyPR/FXYeik/cH3aBCvs/2r41J7RkCyXdrrs2eRcksny2JUvnFL0MULirH3ZwjDC84cs7ksPBQPxu45gs9IKMY442ZyLv20wJEA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(44832011)(2616005)(186003)(4744005)(110136005)(8936002)(5660300002)(316002)(122000001)(2906002)(86362001)(4326008)(36756003)(91956017)(38100700002)(38070700005)(6512007)(6506007)(26005)(64756008)(66476007)(66946007)(508600001)(66446008)(76116006)(8676002)(6486002)(71200400001)(66556008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?kdUshDNs6NzVxu8/Z6Eqfmx7bjiCR8GS4zjUElrA4zmWSwWYYcYRpjHvy?=
 =?iso-8859-15?Q?4fwf4aBVjgonhYw6YdC9PCnavJSZlFoiK0RPyxa0neMmaBTMBOKeDGi/J?=
 =?iso-8859-15?Q?eDZgscqcUtZMRJMn7Nzj/hqOrNt/latQfVujXJEha7a4BgNgj8aRL+PRd?=
 =?iso-8859-15?Q?n8hSvLlgJi5hTEVZx3wYNI9nWZO9WddRoSESMu6y7GnG8lONBOiEq5pZS?=
 =?iso-8859-15?Q?vEFih2ZZC1SXxXxmbnVLffV2/Mlzoxn/HpngDV+uWoPO6kokJfrfy/esF?=
 =?iso-8859-15?Q?UZfSDhcHeNA5tn0WLrpwOWv1f++USOfDVgJDkQyiKk36A5HER1SnUf57c?=
 =?iso-8859-15?Q?dP1/H5LcFDDbAc1nKHYMnuPdOY42kvwC/ygkgyE3ZcdjmUOChcc2sKW/d?=
 =?iso-8859-15?Q?v2vqsHmUWaSgUYGeFbDj5FptswDCmjN7MWe3uby705ZygWZ7ESpe77nNk?=
 =?iso-8859-15?Q?TTE3d99srg99zRmoCauRmkycDCUIRWwbgvhVxT8ihLWN3KUK6TWb+Gc/A?=
 =?iso-8859-15?Q?8PM7so8VUSEl2aUZw9IR8UYM+kojxsCepWQKgLVoRpRL6uvOGM4+ZP6xL?=
 =?iso-8859-15?Q?2AujQxCAEeBnlahAX59+DAL5webrAeL2RRNhlc+JkKqmO5UQmVRSvUAV6?=
 =?iso-8859-15?Q?A1pDKYmfodDPSHiJjDMRz99Sxf4GvrwMIfuAMgAkEV4p7O9dCQKeiUDxM?=
 =?iso-8859-15?Q?KZglvYaJWFDkUHXl9pluLG8myJJq+yA/NeU1NI4Wih6GhpOXo780soWnM?=
 =?iso-8859-15?Q?SzLeDH1dDDxKDzYymPmMLrgip5L68czHshUKBHTjhMb/A1sAAEaHX3kcL?=
 =?iso-8859-15?Q?FVaiT4vmTPCn6DzHGt1eBjvO5iVAdKfvhH5ROQBbfhfJFSLPNQI/JkIjb?=
 =?iso-8859-15?Q?0FLmuwSvhAm/czlbB/yK75NCqF8B9utwPqYKrctwSqjiR87MmnsCG0oF7?=
 =?iso-8859-15?Q?oZIG0Ruh9Ih0voXGtlJpU+qicDP/GVubAA/c3iJAb3Ell/6PRL6/rbw+y?=
 =?iso-8859-15?Q?ShHqPI8JyabLCnxeL9feS4KFJ4P9vcTak2/t408nGWCMKLu3n0ueY6HwS?=
 =?iso-8859-15?Q?+ul3P85SdmPEIgxbxH8ptQFagrjXOQRJI2FZ47MlRJOsMwkSvUe0kvkt8?=
 =?iso-8859-15?Q?eox63Q64lNz+wYhdLOrK76RGZLc+D9+ExjYz1m4wXzOcwYZYv5eUMhQeB?=
 =?iso-8859-15?Q?D1iGaa+u/0kzJ0O67H5ID04uFgJBHo/PHOhJwQtPPuS6XbPcYv1vNklvv?=
 =?iso-8859-15?Q?Zk2T+Busoi0iU9zm1ldMkRBS5rt/KLelerldO/vx5W2saBh2wxmTE6WJm?=
 =?iso-8859-15?Q?xHYhekTgB122kBsKLLVauPbdX8kmpuWFst63bRTccgo3Fco29m3ffzXZ2?=
 =?iso-8859-15?Q?kVAMIWPgi2KuMFMeHdHWtz04ZnmLVax73xEhWtTzA1Y++FTCxvmUMepk4?=
 =?iso-8859-15?Q?3j4njKx0JuBzrK6PYRJFkC0GewChB+APdVVx5iddtkSE00b7Y6pxIWCYY?=
 =?iso-8859-15?Q?Zr1Ao7UmvhvRSd1ie84QCYmqVzVo0xvY1mtteqWpWimJ3XcAlqqtLhmXe?=
 =?iso-8859-15?Q?WpChhLeiYUZEqLcnhzIoo2W9GMmnie0ewjbkB4YOlS3QUGEZeNgc+afI+?=
 =?iso-8859-15?Q?ETTksvNQFd34eR1WOWBCoLh4Dku8rKVsgNSDgmYw0iFj07VQq/5w3zkhf?=
 =?iso-8859-15?Q?n8L335UebQN0r4rs+khyUdkFzGxDDYwo0onXoBynOiPL/i+cAlN2P+E3E?=
 =?iso-8859-15?Q?TFaQAyDU4JeF9ESicDAjT+0v1tf8Lfv1WJW2l9ekgLjIMmwuIAxbOXxf4?=
 =?iso-8859-15?Q?hxfynPdJV/nbh455w8ssA/2wJG5fulKZiPIVxf5HzcSMdcFZiJEIZyMy6?=
 =?iso-8859-15?Q?GH80=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf647a7b-0515-4cdf-cd09-08da1deb2759
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 07:48:24.0750 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UEI048JnRQHZyQoP4Y5USaiI9h0AZLSYjmX8FpRVkdTCQilt2SbtAsHZwHFa24gETuJENyIeYD+2/X1tfp4EZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4058
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 4/7] libmultipath: Set the scsi timeout
 parameters by path
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <993FF26F1EB7BD49AAF60AC722B53CE8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-04-13 at 23:27 -0500, Benjamin Marzinski wrote:
> Instead of dev_loss, fast_io_fail, and eh_deadline belonging to the
> multipath structure, have them belong to the path structure. This
> means
> that they are selected per path, and that sysfs_set_scsi_tmo()
> doesn't
> assume that all paths of a multipath device will have the same value.
> Currently they will all be the same, but a future patch will make it
> possible for paths to have different values based on their protocol.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

