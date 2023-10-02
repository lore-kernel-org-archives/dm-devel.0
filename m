Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D32CDE7849A
	for <dm-devel@archiver.kernel.org>; Mon,  2 Oct 2023 08:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696234211;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QvzLY27RHzUH618JZNnt0XTr/VN2eq9ndzq2TMTCf4s=;
	b=b6TWyJNsICqc4YV64npwxfs3Ed2cD2c/KEduEITtEUg+nbydSmHym4ZW/pPw7bcdHtAoYy
	JZPiFER9Zjf/GJqowJ3WQuGj2sGH0yzLj2GGMFN2/Xd2kfm8hC2jM8Mn3CCVphke9VWR7V
	7ZNmfzJY23t+YSzjx7QIPmZt7qq5Up4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-UqIkrdxNODyLXhhFStu_Pg-1; Mon, 02 Oct 2023 04:10:08 -0400
X-MC-Unique: UqIkrdxNODyLXhhFStu_Pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22246811E7B;
	Mon,  2 Oct 2023 08:10:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A749140E950;
	Mon,  2 Oct 2023 08:10:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14EE01946597;
	Mon,  2 Oct 2023 08:10:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BE881946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 Oct 2023 08:10:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DB982156702; Mon,  2 Oct 2023 08:10:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 659842156701
 for <dm-devel@redhat.com>; Mon,  2 Oct 2023 08:10:04 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33F9629AB400
 for <dm-devel@redhat.com>; Mon,  2 Oct 2023 08:10:04 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-rLNclpd3MxamGt6Z6j5PJg-1; Mon, 02 Oct 2023 04:09:57 -0400
X-MC-Unique: rLNclpd3MxamGt6Z6j5PJg-1
X-CSE-ConnectionGUID: F+bpKlgITZibjSSTuShkNA==
X-CSE-MsgGUID: rkvo9P6RRjS12jueBsPQGg==
X-IronPort-AV: E=Sophos;i="6.03,193,1694707200"; d="scan'208";a="357542375"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
 by ob1.hgst.iphmx.com with ESMTP; 02 Oct 2023 16:08:53 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CYYPR04MB8790.namprd04.prod.outlook.com (2603:10b6:930:c0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.25; Mon, 2 Oct 2023 08:08:23 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6838.016; Mon, 2 Oct 2023
 08:08:23 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Thread-Topic: [bug report] dm-crypt setup failure with next-20230929 kernel
Thread-Index: AQHZ9QedZs2zex8je02tGiGJaFS5rw==
Date: Mon, 2 Oct 2023 08:08:23 +0000
Message-ID: <4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxdsu3g4uughh6go@6owks5linnxi>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CYYPR04MB8790:EE_
x-ms-office365-filtering-correlation-id: 35ce2a7f-e616-480d-410f-08dbc31ebfcc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: guKNu6ecK3+tqOinjz2eJbRKXeLas9l2u39SrILwYwthORBWpHAqZaN0OCvldVRGtovnhi/ySDMfBzHSsNwMPbXZiMXnAncAc3vk4hT3Djid8IPawXjQEybG3gUxSgmh10ctcghtfwwznhUNns2Wrjw9KfoyKzRvVKdcJuDFkFWAA5uZG9nEWIrhRtN7kA8v32orwEYs06BT5c0TAtHtF5uz9x15QplKKLQgVE96WUYVvx/jfeX3KE4xjqFy+RrupqSTK4ljD+Rc4Wo41OfuGIM6fQrJkRi9ylVjlJ8av0pGmeT5Ub5PrJfMCVDfeUMDk0h9biB3jvw5/XbYP10qc12RtJf5JBITYy4lsmEAEdW1gWcDuXkULQYGZhKAIfP1sFi1q8pLAw5mB9XbejGLnmrBZ1C6gfXgNw9UJpFEwgO7HEgOJLuhV9xlMW+yN17jWJuo4qHApCUB9A5v+Jmm8nOJhO6JSFTUEgt9RBeUhRxdutZzoJowrujS8ytBywus4ss8mQaw84FbMPOJ6ao/60Y+XIoz9VqyC5WyUarkfNLnpdAv1r7/88hS9GhLsBYPs+D0BIEmAPnmURX/ePX/m6wVV5ft/pyBGSsfnFMyNyWUQ0knxc5fQ2d5BNVjv1Rt
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(7916004)(376002)(366004)(396003)(136003)(346002)(39860400002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(83380400001)(26005)(66556008)(86362001)(38070700005)(38100700002)(76116006)(122000001)(66476007)(66446008)(91956017)(82960400001)(64756008)(6916009)(316002)(54906003)(41300700001)(66946007)(5660300002)(33716001)(8936002)(44832011)(4326008)(8676002)(2906002)(9686003)(6506007)(478600001)(6486002)(6512007)(71200400001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nh+f3HWSxUVYPEkXe9RKRp0M/AneFZ+pmHC6nCctPuo3MlelrE0odudzqoHp?=
 =?us-ascii?Q?TCxIFfu1hOLNxbCNnSBi9bpHN2J16Mji7UTAz9RDP/zQ0PelFAQMkK0drckW?=
 =?us-ascii?Q?BVTQx61yrhC62cEzVHfvQCvI4G29RW1J3j1xVBMwLHdj3kRKULk5gOfZF2DO?=
 =?us-ascii?Q?Te9LR09t05FFlRZ41v8OnglWF6cvvfo/LalCHq+CgVjxicjwGCQfk4g8aBFm?=
 =?us-ascii?Q?nQKs/2/BXHTtG1Fve89BcbQTVj4SzsgHQZkLLX5P21cIq1EvXvTDDVA91SkA?=
 =?us-ascii?Q?h4JDPs0hHvEpV6O1e0wRis+YLIoiysPhof88kFFKpJqNl0jVmTWiayKH6jui?=
 =?us-ascii?Q?hNHRLHizOWHtlV9OVAijtr3W9S1HuF9bStaPaJcpCs3omJ7iVaG1Ktuxtx0x?=
 =?us-ascii?Q?phxPSXBYypXZkSPM/baH3thWqRycnt8/87FAt52axCYxe4gjQNdPPjsxrilA?=
 =?us-ascii?Q?Pu5fBK9ea7Gp9MyCkGH40uq9ytti3D4FYqYQ08v1bbgwklPpGVufagTqWpnw?=
 =?us-ascii?Q?qoUKlmu0VYvwo0/UxAH/3X2+1nWvzPZ757gXBX4MFQ2njhIJr/mpJCHAGX2p?=
 =?us-ascii?Q?Tit7bltZcdPwRfcpYanW2gkx62fCfGxwaRWzYOSFMQ/feUOfuGAEBGYGAocq?=
 =?us-ascii?Q?W3T9ypNJ8nlEpxRBh5Y+wYQcAwVg+oKC1igsaXJ00GNlFRQKvmQw4FwntgY8?=
 =?us-ascii?Q?6RHarP9znuWIksJfBipPc9vCfFXI0aXHumAdjjsIUqsshBUI6foYXtOcT4Hq?=
 =?us-ascii?Q?4RWoNbj8zQL5xKQcvJXkJMcyAFkRKCVFg8Cp12HsYQyz/ntTrMwwHOi8aWf1?=
 =?us-ascii?Q?pglOTUchDQcG+0RR5L9ABePvzC58aAYBtP1TqhsG5QGNNHOSbhEY6d7AjprK?=
 =?us-ascii?Q?FIrb4QKRpbj5GAStgiPYnfoL2lb6Zv0UJMmWFIl8b9LXZZ59sJ/8tFEa5sMv?=
 =?us-ascii?Q?YTapDdsFWJFwMVL93H4gfCFaUl52XctGzRQk2qQFJBXuVM139GNVmt6IZ2Pk?=
 =?us-ascii?Q?GFVC7C9HZXojTKHyKfpY/urYIOmp3WNQSaj7UUwmU2429nWf0flSWlCZEBtX?=
 =?us-ascii?Q?44TIu8vrXuErSHs5RZv6YAafPraRn5QS/ELW+5sXXR89NDWf+9HJ5qvOhUiV?=
 =?us-ascii?Q?ElwA7KCVRXyO2WlCYuZ7WufKEtnUCds0GU3Wm2OPZzoGJZIWWu2cipzUsa1p?=
 =?us-ascii?Q?owNrMGhgDJPGefyL3vVpp5G9omMkKXYmUJOjuH6/auUmnRNPvQaW7xDA6wBy?=
 =?us-ascii?Q?F0TNHuH2DsAUg9fgDFu2/jcdA+WVnEdNSbkUZBzRhOWIy6DEV2g4f+b7+tjx?=
 =?us-ascii?Q?ezkUoTp43riV808XDjeXmoqK2BPzoxRdfWZqhGlWkFfsHGeABa3FKuAyE+RB?=
 =?us-ascii?Q?N8V+IKgN2YObXXaTGyx+Zl0FcGJah4MKb/OW9PZAJbEmehlEM10Zu/rN+H/3?=
 =?us-ascii?Q?41jntC+WMf6strHHBsBISUm3L5SfHtXtZomVnL0QwYpgB+hp5qyq8LaRmBdj?=
 =?us-ascii?Q?bBmhWS6lumgX9yyCW7yDAeSCrD6cOxLmtwYvqYs5iVNLASCHgByyRiUM71sJ?=
 =?us-ascii?Q?xWDgu+8q1/EVpORmABbcAYH6K+FUGjSlSb2CRwa1O0JPLAd1hgcVQJ5e7FaA?=
 =?us-ascii?Q?0620++glY1vQSe74S6wAr2Q=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +FJAoHKtiSb834WESd4PlbNDn+YIkYESf5D6GnB9APP4qeCd0opAK51ZRMzB0s0g/d7zeINIjGd8nD/zprcNUs445SlhDE1fV1IYle6xn+qTqo1P8LeiZfar+YlEK5YEbhxZ9wnjyVyM7u8iGhY1pcU+FtTUTxYBwSB0QUobIympZcAmM5dMArSaTc5zAVg7VDZnQHWu3qjPIAsLJKy6zCKgmGFb5tsQZKxH4/DrCX0PHffrAagcX5SA+CJw1ef3UtjaRdItBNyXqbEqKFdy5BRrQ7yYIh4AGJO1fBZosgiux3va/L7nvDb2B1juRQ+hCnEwgkKi6z5BQIk/eU1mqWMf7KNm7lfv9+Hsfko9datszy8tyAi5RMCp4KYe3iHYxjyUfkJZagvoCR7dbbdGich2IIpuzN4aNVyDhZX6Id5HAySH/NwTgiaY0tFlslYB/KXiI0cbn+tzuFpWgYdZ4QzEUmQE7ZgbvpK2iDCFzpsDTc1V1YysmehsGVxV3N/k6/O4XAkH/k5PtgOvQEp2Y49ev3Pz/FoVGBVCQ9vT3zVoJ//3ZVHlrKtn9EbWKQh1neTMprnCKgRylWcmH+otewyMIFfqPN9xRavdQUVhaPzNZ8P2EuoDzDdzEUjVjMu8YWKxvMfqWUjj8S8f+xzzqEtjAvLt3PJZsLKLmsC5WQgt3eAgRKBj0PGAqxq7bWySZseWA6pezFju14IpKSc3Lz6QG6272kFNTC3I2XeOSgV/dfUBWKgOhnIusF+8ieCxHlysSvVjQESzzG+a3DTrrYqpVGYrHLKw8sKrcENDMnySHBP8zeUg0nCVKh1pDxq3X/X0vufkvHPn378e4j/uHYVmJaIilKgQkIsjCq8/Euw=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ce2a7f-e616-480d-410f-08dbc31ebfcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2023 08:08:23.7298 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FdVEWIpYOJq6Nz+x6yecFZcYGdd99ZxpGVMKfY91L6K10oBNf/m5VYgEUx8cMu1FsXRs9JpDyQQpJ6dEvYl1Ssm6vSdRTWfC1oBbDk6gNTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8790
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [bug report] dm-crypt setup failure with next-20230929
 kernel
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <5F892623868AAF48A4445EB676955CFD@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello there,

I ran the command below on top of linux-next kernel with the tag next-20230929,
and observed dm-crypt setup failed.

  $ sudo cryptsetup open --type=plain --key-file=/dev/zero /dev/nullb0 test
  device-mapper: reload ioctl on test (253:0) failed: No such file or directory

Kernel reported an error related to crypto.

  device-mapper: table: 253:0: crypt: Error allocating crypto tfm (-ENOENT)
  device-mapper: ioctl: error adding target to table

The failure was observed with null_blk and SATA HDD. It looks independent of
block device type.

I bisected and found that the commit 31865c4c4db2 ("crypto: skcipher - Add
lskcipher") is the trigger. I reverted the commit from next-20230929 together
with other four dependent commits below, and observed the failure disappears.

  705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher")
  32a8dc4afcfb ("crypto: ecb - Convert from skcipher to lskcipher")
  3dfe8786b11a ("crypto: testmgr - Add support for lskcipher algorithms")
  8aee5d4ebd11 ("crypto: lskcipher - Add compatibility wrapper around ECB")

Is this a known issue?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

