Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5571BC77B7E
	for <dm-devel@archiver.kernel.org>; Tue,  2 May 2023 07:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683011261;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0QAtBbYRLxu8Gm4HLQAeCs0/KOaKFSUzeSOXD5A5o3I=;
	b=QKSy7y5LlGk1ZBUZJh1NpxIoVqWqFhGCaB/Q3yxzL8p8NXbI7AXGbr3yEbb8jbXurLZTh8
	rGy1fvjEznH4/ymMXLfffdWJlvxLnWpltymrNyRD4O2M2eXjGyKjX8av50gzMc1RBgajgH
	QrEoPfaV07iymsIyhZIZHA01G4/aIuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-tyx56cFMNwaPvMp73kNURQ-1; Tue, 02 May 2023 03:07:37 -0400
X-MC-Unique: tyx56cFMNwaPvMp73kNURQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAB8D100B36E;
	Tue,  2 May 2023 07:07:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1294C15BAD;
	Tue,  2 May 2023 07:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B3B21946589;
	Tue,  2 May 2023 07:07:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A3D01946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 May 2023 04:35:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA5C8492C14; Mon,  1 May 2023 04:35:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1384492C13
 for <dm-devel@redhat.com>; Mon,  1 May 2023 04:35:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CB7685A5A3
 for <dm-devel@redhat.com>; Mon,  1 May 2023 04:35:47 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-RhV2X6JQMaqtr2mSDDgweA-1; Mon, 01 May 2023 00:35:45 -0400
X-MC-Unique: RhV2X6JQMaqtr2mSDDgweA-1
X-IronPort-AV: E=Sophos;i="5.99,239,1677513600"; d="scan'208";a="229654008"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO
 NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
 by ob1.hgst.iphmx.com with ESMTP; 01 May 2023 12:34:41 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6994.namprd04.prod.outlook.com (2603:10b6:a03:228::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 04:34:39 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%9]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 04:34:38 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Thread-Topic: [PATCH blktests v2] tests/dm: add a regression test
Thread-Index: AQHZe+Y9jbQxdYN1K02JKjkDsq86Uw==
Date: Mon, 1 May 2023 04:34:38 +0000
Message-ID: <2lsxdy3n7vfwtmyubfc7kh7yd6mxrht6nlnhmvwzrsellij3kc@5hctf5lvmr6e>
References: <20230427024126.1417646-1-yukuai1@huaweicloud.com>
In-Reply-To: <20230427024126.1417646-1-yukuai1@huaweicloud.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6994:EE_
x-ms-office365-filtering-correlation-id: d0fc3e4c-a61e-42bb-e530-08db49fd5fd1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MxXtLrIqUTQ7Mziv5GT/n9PZc4JqvcV0xgDiW+ZAW/0LNIy6OTXmHVYQclOpdc494WLMd/xu5v17oRe5U945xJTe70bPGyodmneiN7B9MoHZYlJVZmf5MqlbEhaaL3qjZCBJTW4k/kBGJHrfL0vLx+g26V37/j4VaP9cw1wXRdSKJhuFrJZ2hgCUrl3w6iDz+uZQ/Rj5A9gyHu/m2qnTfeRvZDfuzEWr3Eag7d4IqLAGXLFEqk5qt4ijvJj9v+3Clp4d4BSOj809EsVOQw5tn+ZOCJUPmvsvSa00Lt3fVAUpeac1wEJX+zCZQhtt+VgnRSppGkiecck2bUUF3wAoED6eJ5MvKlyHzwHEhMFoZqnYoP54enkS3e6cuBJo5I2VbbkHFdACd+LF4kpbZ50g0ZO3aIO2+m26mYJ+kWxkXF60XhXqqNqHd5nPYEvsIAKrLijXq1sVSKK9lOoP6Ej6xJoZgECfOdLj5IayQu2tz7Zx6BhQ8xgxJAYB4uNpYstV3HOTrSv9AMTwejUsVhfT710oW5VQuMEj8dZXMoCCcFPJnwi4eFvGrFpxsdte977rQ2Bo7Vc1xEE8lf2KR6zfBN+A0VsxcI8d+8anU+WvVUnsrqbCNVsQD5NpYKaTeozt
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(4636009)(376002)(346002)(366004)(396003)(39850400004)(136003)(451199021)(6506007)(6512007)(9686003)(186003)(26005)(2906002)(83380400001)(44832011)(33716001)(6486002)(5660300002)(71200400001)(478600001)(38100700002)(82960400001)(8676002)(8936002)(122000001)(38070700005)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(76116006)(66946007)(91956017)(86362001)(41300700001)(54906003)(316002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ih8sdMQvq0SI7g3BPD+NoNVWF5YOyZFHa+EubagdCqvGTi5tSQACd0e5D4FU?=
 =?us-ascii?Q?hnIGS4bJpKdNLFgw3VcIQe5fzniY+LTQMkeOccHYxhHzkQboxAkkp5WpiG7j?=
 =?us-ascii?Q?CnvjQ+ST6K1o6cxM6m3VW+daeUfPDPfsr4sRYOZ9OfhZ+2DdfEOH+9usqtat?=
 =?us-ascii?Q?NCws07SlwFri3RTLpwPWd7O8xKaSZyHpTyE9gX0dxRShmklT6H+n6kxX/Kmd?=
 =?us-ascii?Q?wbzqlfx48/duVyd0rM+/mAIu8Nv2ZaJ+/WDly0WGIwmrgNFrUBa5mnZmdCla?=
 =?us-ascii?Q?J4yXPDRi6V7OrkiPoYaSpKBzO3B0lKt/IhDFuef+oi9/c5be9lFM7JPVo16v?=
 =?us-ascii?Q?G+0KC5EQ/BZPAEOKhm9Vet3+siels2DYem1NiGkUkU3bazHx2WlaxbF3K9sT?=
 =?us-ascii?Q?Z9NaRPaCcfv4z9hx3NtgObXF2mrq26ZEKMUle+sDBl727MPxQp+O6k/7Coz4?=
 =?us-ascii?Q?GPQRqAAXXGjhB7Xol5VHNwv9/DyFQxfeGCxAhWP/MF52MXXhr0VsUoYYnx6P?=
 =?us-ascii?Q?NMCMFifCADvbKzTY9iTcKbSQYnF/+YtX/XFF4Y1wNGpWQ/xLliyBA16V6MtF?=
 =?us-ascii?Q?ul8Hg4RYtt69GAQzZgpIKiFs8y5sg8kqz3BV9EW9PITg005kRU79JfJ5ugj8?=
 =?us-ascii?Q?6qQg2PKUphcLIig9fb8GxQvf6brLTH4PIkSWnZQK0dfQyvHjkhIbe1YNBkoz?=
 =?us-ascii?Q?Us0/myTSRGz/w9hAHMAN7bc0oG/4ZHQhuN9tbkU2vWFU6/cB4uug+m+3n6To?=
 =?us-ascii?Q?QoCmf3vJL6Pcxa8rYp8VBSKmIwNUe6FDuNbjlvHbssVrOmQ+oAx+094cBDSj?=
 =?us-ascii?Q?qbKGyDgAKqRvOPm7UeNd+zSLbgi0YRefTKkga7+i11JHw5nvaZRSbr8x0Ofi?=
 =?us-ascii?Q?+Ap2nPfTPV63DT5bXmmA6iQPQ4mlvZKoAMfFs0nMCcnjszsFLodF5qRNg8Jj?=
 =?us-ascii?Q?qsnR2YQ/svbr+w/hYoz1ImYJRz3woDKJNvpaD3mQFTfkxhggHlx2I8VkuAlk?=
 =?us-ascii?Q?W0ewelcs9XnPPA/VsihrdKjP3XDpOsZjXi0BxvvNd64QyK4axjT2rJF22ZXi?=
 =?us-ascii?Q?AgAaU55Pew5eAWWlAMQ9FF+RpHdih+175HUowgqqRdD8BJTwF2TOOr4oGPqw?=
 =?us-ascii?Q?kXrdkJ1a8Sd8IyikMm3o1WF1CzEB/Zz6VPMajTFNdcV1diqEDT0lkYI5ELWD?=
 =?us-ascii?Q?JX1w7+PvWeQwuqK6bnM6mJKWL1VaG+uOv7a2S/CbH+YZjvil0amFIk88jsGL?=
 =?us-ascii?Q?kfS7w0LrgVbbwRN62zRTVWOrVFXzl9tnEY31CqpWUg3v/Ekt7AwtDMf0pPDY?=
 =?us-ascii?Q?VbdqTOs4HTYwMGWtfzS2aHGussGeUKowUGXdILTSFvcBYo+1K0l6flvIwW2s?=
 =?us-ascii?Q?FzRMUAobrs2I6FacLCP6vGGXd9pioJPLO2XCv3vdKzQC8J7skdlfO7lDixlx?=
 =?us-ascii?Q?Q4oePmth790aDqQkuEvAZJVhxXcLbCnGeSi2vya0QT4uIrtDmTq+vBLsnd8w?=
 =?us-ascii?Q?CQd4qbdgwaYEZiN4+0fy9D1xDV9WJHgMv6yuBpAGGSULGn8XBixi5hJW+W+7?=
 =?us-ascii?Q?MZXdDfBKEtyGIg0v2hOblLbzdGOG1eySGH2cIODV4M8rvc7wlgSJWSpVVtQn?=
 =?us-ascii?Q?mcjOJhgQO0glEDOt0FR+w18=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: C5rESEKIQBBmqVSr4M2N3Q2puddSO4L5Rh8uVH8dC3QG/TE5HGeuwqcDZBPLfmnmt5QqAw1ZnZEo38Hvd/yGarLsljOMii/v3eDV4mNcCYklkJePhg7aAw5To1JqFKu4m0WPF8IK6Djxo9hdhZ+3mJa+bJpfmkAWQJ/JvCQ5beC3JCUehXX/T2q1LN4x2HHvKz8GKKJJ7c5XtuE5rh6Moz3lgSE1UoHT1M/eG/vTt5cJ4sqJbPWHEytEaGErLAYBfsx5OUQvdECJ/BtEFuylBrP1em4WPLoATeoMawwHhW8CzDI9whjA1MmKmcENLAe5KEFCkB+Sce5/RTXY2eMX+QGLjh9dSdXvuKFob6FHJbGjmlgrZzJ7TOY03MxfYlyDRplqLdHlRr8CfMV9n2KOvmutPQWPJRt6fKiwc8PQvxXZo2RsXWe02V29DuJeeAF4aDud/xrnE02iu/yaT11rzEz44+xCRZiETyjsft51oA5ktWC0NUGWTVqloonDcGp/rj4HyRLsxkmjrIieRdTMBAN+zJQJT94/kF72j+2o2X4O+LZu+TYRxL8xY248uPJn3uARazpvAc4XHg88O4ON/9FN+oNYYY2Cxj+TzgczOU1iUSu+/Yoa6vEvJS/qQeL0NNiLXf3bysOaigGqFzzOaOWN4y1SOpLbE1mrx6LFiAgQAuYqoGTb3ymhFHaaVJ65KTL+rQTqg8rd4pz5Nybr5oFWpFMFv0fMT26fu/XvHx3lnSEtIjrLDm6mM7Myc3LCVy/P0CCBKqN6bYpRljLlWPwwSsPOsvuyEqQ9DTkAtsL0i6bn1iTSlG+4Sw63foVFatCqV4bCrJqZS3IefKdy0tHAuu9QyWHOSuTdbLTaHDDfwrdglOeG4beMdyQ1WSEVURZqBNaQMwOO66t3Gi2PrbKiuM5SyajRo/U+tiuLUPM=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0fc3e4c-a61e-42bb-e530-08db49fd5fd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 04:34:38.6165 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fyMV4okGme0XNZAEZ67adQrWPFpDCNsKvZZFVBZfRD2j97o83jO2OuMDCmTxBUx17smpuc9kar5XVa/iM01WF+Ujo5PDnKUGNe04VuWAOj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6994
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 02 May 2023 07:07:32 +0000
Subject: Re: [dm-devel] [PATCH blktests v2] tests/dm: add a regression test
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
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "shinichiro@fastmail.com" <shinichiro@fastmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <4546ABCB44D6C747B617434FAF07F48C@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Yu, thanks for the patch. I have three minor comments below. Other than that,
the patch looks good to me. If you do not mind, I can do these edits. Please let
me know your thoughts.

1) Let's describe a bit more in the commit title, like,
   "tests/dm: add dm test group and a test for self-map"
2) From historical reason, we add executable mode to the test script files.
   Let's add the file mode 755 to the tests/dm/001 file.
3) Please run "make check" to find script issues. With the command, shellcheck
   reports a warning:

   tests/dm/001:23:7: note: Check exit code directly with e.g. 'if mycmd;', not indirectly
   with $?. [SC2181]

A hunk below will avoid the warning.

diff --git a/tests/dm/001 b/tests/dm/001
index 09731d8..f69f30f 100644
--- a/tests/dm/001
+++ b/tests/dm/001
@@ -19,8 +19,8 @@ test_device() {
 
 	dmsetup create test --table "0 8192 linear ${TEST_DEV} 0"
 	dmsetup suspend test
-	dmsetup reload test --table "0 8192 linear /dev/mapper/test 0" &> /dev/null
-	if [ $? -eq 0 ]; then
+	if dmsetup reload test --table "0 8192 linear /dev/mapper/test 0" \
+	   &> /dev/null; then
 		echo "reload a dm with maps to itself succeed."
 	fi
 	dmsetup remove test

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

