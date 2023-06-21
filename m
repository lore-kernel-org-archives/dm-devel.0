Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8EDEB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 06:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687416420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oh+mz7TLiK5awFQw8woMO/dd5rSF/Z3IA0f39ib/iwo=;
	b=C56aRVlRfNjHW5oF89e9qpa4AAtOnvsdnRFVtPqWjt4CKBHwO7uwTG2PCPu0p5wdhALMNp
	nlmzBuQ3aDeLVPw57xDOYLe/yhlz7r0/KDiaSmNZosXV+9aCmCvDS68i/U5bAuZPqoOQJ3
	BHJcdPl6cP4q2aUURjcCUwelmLklfRU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-niD2S3f5OEChaWjGjqjRRg-1; Thu, 22 Jun 2023 02:46:59 -0400
X-MC-Unique: niD2S3f5OEChaWjGjqjRRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06B5A3C01B90;
	Thu, 22 Jun 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8B5C40C2063;
	Thu, 22 Jun 2023 06:46:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6627C194658C;
	Thu, 22 Jun 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 91C481946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Jun 2023 10:07:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A7B89492B02; Wed, 21 Jun 2023 10:07:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E325492B01
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 10:07:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D2513C108C5
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 10:07:18 +0000 (UTC)
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com
 [216.71.155.144]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-F5n8RXMRN_uEMamJlynRKw-1; Wed, 21 Jun 2023 06:07:16 -0400
X-MC-Unique: F5n8RXMRN_uEMamJlynRKw-1
X-IronPort-RemoteIP: 104.47.55.105
X-IronPort-MID: 116155715
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:njymha5VbyXT3IgsTX8J2AxRtHrHchMFZxGqfqrLsTDasY5as4F+v
 mMdC2HVb/+MYGqkLopxaNizoUtUvMfVn9dhHQRo+SA8Hi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraCYnsrLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9lU35JwehBtC5gZlPa4R5QeE/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5mp
 eIicxtQZDq/t++15ZfgeslKl8cNFZy+VG8fkikIITDxK98DGMiGZpqQoNhS0XE3m9xEGuvYa
 4wBcz1zYR/cYhpJfFAKFJY5m+TujX76G9FagAvN+exrvC6OkUooiOWF3Nn9I7RmQe1PmUmVv
 CTe9nnRCRAGLt2PjzGC9xpAg8eWxH2iBd9NTeDQGvhCq0HU/E88WSQqChinuaaczRS7XI9bN
 BlBksYphe1onKCxdfHxUhi5iH+CoB8HWtBUHvE66QeC0a7d6UCSAW1sZjdRYtsrnMw7Xzon0
 hmFnLvBDDNsmKeYRXKU6vGfqjbaETMTLHMQaDUsTgYf5dTn5oYpgXrnQtMmHKOrg9ndAzz8w
 zmW6iM5gt07iMcR0qyh8FPvgjSyp4PIRAo4+gXWWG2+6gpzIoWiYuSA7Vnd8OYFJoKeRVqpo
 ncJgY6d4foIAJXLkzaCKM0JHbe097OGPSfajFpHAZYs7XKu9mSlcIQW5ytxTG95P8BBdTL3b
 Uv7vQJK+IQVLHasdbVwYY+6F4It16eIKDj+fvXdb94LZ4crcgaCpXlqfRTJhz2rl1Uwm6YiP
 5vdadyrEXsRFaVgynyxWvsZ1rgogCs5wAs/WKzG8vhu6pLGDFb9dFvPGALmgjwRhE9cnDjoz
 g==
IronPort-HdrOrdr: A9a23:RcWz/avXxl96dOci9RaCUapw7skDstV00zEX/kB9WHVpm6yj+v
 xG/c5rsCMc7Qx6ZJhOo7+90cW7L080lqQFg7X5X43DYOCOggLBQL2KhbGI/9SKIVycygcy78
 Zdm6gVMqyLMbB55/yKnTVRxbwbsaW6GKPDv5ag8590JzsaD52Jd21Ce36m+ksdfnggObMJUK
 Cyy+BgvDSadXEefq2AdwI4t7iqnaysqHr+CyR2fiIa1A==
X-Talos-CUID: 9a23:PayOz24xSRS5i5rzkNsspFAuQet4eFfh/HrTBmrjOUZPWb67cArF
X-Talos-MUID: 9a23:c1HS8gRPFNuQepTwRXTHmHZYF+g52pjxS1wVzrBB4cyDaChvbmI=
X-IronPort-AV: E=Sophos;i="6.00,260,1681185600"; d="scan'208";a="116155715"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO
 NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 21 Jun 2023 06:07:14 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by SJ0PR03MB5662.namprd03.prod.outlook.com (2603:10b6:a03:285::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 10:07:13 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::1c83:1877:a68b:8902]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::1c83:1877:a68b:8902%6]) with mapi id 15.20.6521.020; Wed, 21 Jun 2023
 10:07:12 +0000
Date: Wed, 21 Jun 2023 12:07:05 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZJLLyVasQ/MAXFDI@MacBook-Air-de-Roger.local>
References: <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
 <ZIA9uBJxx2gqA4Cq@Air-de-Roger> <ZICs+WYCPYdu2yoI@itl-email>
 <ZIGRXrSGmgLF/07O@Air-de-Roger> <ZIH0yQCICZRpliSc@itl-email>
 <ZINBqToBZVdfmr0e@Air-de-Roger> <ZINZj8ubQj7yFxdR@itl-email>
 <ZIbSw44a8Te27BP3@Air-de-Roger> <ZJJO8zUBhd8QrQYL@itl-email>
In-Reply-To: <ZJJO8zUBhd8QrQYL@itl-email>
X-ClientProxiedBy: LO3P123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::7) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|SJ0PR03MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ca49a4-bbcc-4bdf-9a93-08db723f484a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: rQKkm+MI7DrL/X5YXJhCIKlPRS7ba+BirSnguTln6HEQjOhRIocqZqZ4n0rGFa6GXV6hQ16JGM4jE4S+5yEv7DjvYYid1QQhHmqmDGOkl82ld5hfe/9qWXlWkQMZ+BtP9u5ZPMEOmqT6qRqIXWSZh5v8B/1/EYvHgQxTFMdworPpipah23tNMNgSZGFndFyiKNkzR9IJVzikNYbqy73HgUMHO+20SKdSyrziZunbPV1C0gl8RPtcrzsH9Bt62eXYtqrpDf9lHMmub5015EzDaPsRO/4/CxoIw5b+jRjvmvMIODIKQ+FPQ6cUlB6YDJoFtDQKmP3x3o9I7zHfQxRSW4IL1e1TKLTAM4NXzmgGWz7/bX7QUwbo6Dukb+jnXSTSguXKxyz19dffHbTq5SLRcJTcS6rcSGYJpxAIP0Y4DEzNu1vg+TkYTVpj68R4vl6zvYj+PgqGgJOOZLJmhGCNn9f4sFJM/CzHLvpjVXCWyH6gjc/7wUiDzSIqWOt5MR6YQzTlPKgEDwOSf+8dWPlD1pZwBc4mI4+yBVmOiC5MqifamkzAQQubAUvUQg6yRQxh
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(2906002)(8936002)(8676002)(86362001)(316002)(4326008)(6916009)(85182001)(66946007)(66556008)(66476007)(478600001)(82960400001)(41300700001)(54906003)(5660300002)(83380400001)(6666004)(38100700002)(6486002)(186003)(26005)(9686003)(6506007)(6512007);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnVRMmNET2lFQS9oN1B3L3J4TEgyWWtEOXFXUVQwLyt1YzdIcnF3YThjaDNy?=
 =?utf-8?B?NCtqTXhjQUZrVnp2RUxCRC9neHA2SG1yb3RUbzF1alplVFQwM2l5QTB5aExZ?=
 =?utf-8?B?Q1NNa3hxRlhHck5rdmRxL1J2RVlBUEh2T1l0QjN3Rmszd01uOXc2UHJiUzVQ?=
 =?utf-8?B?amhaUDBydnhZWlpPQUozYXBSVktYMDlHYm00YnZqNHM2OUVOTy9vZ2Z4dWZZ?=
 =?utf-8?B?b0FVRnNOMDNUdld3T2VUc0wyNlhhVGlBdit0cExFbndpTE1PMnc4TDExRU1x?=
 =?utf-8?B?NldlNkhiOGNCbHUza01DTXJiZkNsSkZEQlVhcGFXSlVob1EyNk1mRTYzeXBa?=
 =?utf-8?B?S1hJemIyV2Z0QjFvZzJpb0czTWREWGI2WjRENURySGs5Z2czYUVZQ1RPdHRI?=
 =?utf-8?B?YnZ3YnplS0RBYWw0ZTYwQlBFWW56YW9Uakg2Y2V6MGdvN1RlUW1UMFU3VXVw?=
 =?utf-8?B?VFZzakNJNlNRQ1cxNG9uQjFlNytJRUYrM3lvZkZoZFh0dHhQaUw1NzJoS1Y5?=
 =?utf-8?B?SHVJMFFjVXkzNEkyeWs2eTY3QXlTdU5nSXZjU1pDWnlhQXRzK3AxVzdiQldF?=
 =?utf-8?B?WEFOaE43V0R0WVg4YjZEK0JIbFlvOW1HaTdvUWN2WkZ4UFg0djdGUTVXaTIr?=
 =?utf-8?B?YklGL2NEcVB4a210QTFMdm5wNTFmblY1SkF4RElVVlh4SDJzTGNmbFBBYlVJ?=
 =?utf-8?B?R1J4Y3h1WDNVbEpZL1h6VDJsa1RJSm1XcVVYYURXTjJ3Ukh0T21abDNLQmJo?=
 =?utf-8?B?NGJ3N0lVa01XN0p5TmtzTkY0ZEUvK0tRVlh0Q3YwTmNyN1A5Yjd3ZjNxWWM4?=
 =?utf-8?B?OTZINXVxaU5INjk3QjhHa1JqRHd4a2ZtZkR5L1hhcUVNZTR3VWVmd25tZVpL?=
 =?utf-8?B?N0d0VE41VXFGcW1PMkE2K3VUdGpmWXppbWQzRVUvdmlFY0tZSWgvVmZhVngz?=
 =?utf-8?B?OHROeUUwdkwzWGlWSk41R2ZVVGY1QnlMTm5IMUYyaGppcUloOWxuazMwbVEy?=
 =?utf-8?B?K1AyS0k2MWtNUDV5OFk5STNCelIwamF4K2RQK0szRkIySzNFZEZHd1dhb0xk?=
 =?utf-8?B?ejU5ZTE3eGVhZU0rTWpzVloxVWRhZEprcDdJem1Zc2l2NktDd2tHUnlwTFNm?=
 =?utf-8?B?Mm9DNW14Rlo3UFU3K2JOTmxhbmFHUWEyQUJNMGNaa1BKR0hibjBobkltZ2ZS?=
 =?utf-8?B?OHcyWEZIbXFRUkMreUhXSGYwRlhlcFlMc3hOVkl4UUdybVpiTENNbXZPcDMx?=
 =?utf-8?B?WjlnamgvRGY5MjJkM2tuTVovYXRIZlp0QWx6VG1mK2RldGxBaCtTaklpTFBG?=
 =?utf-8?B?eWtPc2JYbDh5d29BVE9jYU1KT08wNXFLZkZCcTA2N21rblFjVm5wSU5ZK0Uw?=
 =?utf-8?B?Ymx5eWx2cXNmWmh5eDl3R04zZE1HeTZWaWR6Um1TVkIwZjVwVkFxYkNkenVX?=
 =?utf-8?B?OGFUSHlPT2J1VEtMTTZIYkxNTkdqN0JhRE9CK2w5RVlsMW5wYjhtYzZGa0Rp?=
 =?utf-8?B?SHVUdUwwc0ZTTUlZelJ5bitRaXFjaElUQ09yQVdQODl4ZVErUTdQSjV5VXY0?=
 =?utf-8?B?Y240YWNWbVUzZERqMmEyeWllR2VRUTJoL1BOcEdlbmxYVzYyclQ0eERLWGN5?=
 =?utf-8?B?RUIzdTNEU1FZVXhXeGdIYTJDVUJaU3FMYVJZbm9ockpXVU5JR1orVFNZeHEv?=
 =?utf-8?B?WjZnaGtWSWw2VWt1TEs3NjFEems1UTVKN1NNUGltTFIxRmkxSjRKVXR5ZUFZ?=
 =?utf-8?B?SnM5aWlieU9obGN2aVJhejNyK2l4enF1dkRFYUhUUjEzd2JHUUh2VmFIZkRs?=
 =?utf-8?B?NWMzWWEzSit2SDFtNWovNHJranZnU3hiU2lXWXFWNGRWdG9BRGdSOUNPWFRq?=
 =?utf-8?B?ai9vVGwreExtR0FQNFhXZzh6N29yZ2tZb0U2MjJRRzE1ZllPa2tmZGlucldU?=
 =?utf-8?B?a0lPYXZ0SkllbWNacGt5M1pSRTZpY25RZWMzcVJvcjV4eDI4U3BJMlFSR0J5?=
 =?utf-8?B?aHpHK1RpYlhyUmR1bjdhc3ZZSEQ3TkNHYzVMRTM2ZmQzeXFEQS9BZlNXSWFs?=
 =?utf-8?B?eXlpWWhrZmNhRVR4MlVKM0FKWExJRy9QN1A5RTR2bzR4dlBDMUxuNzQvTm5k?=
 =?utf-8?Q?1WXVvA0WKPGUMynIXI1x7xkOl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZDhjUUZHMnRjcmxFY1oxYkJGMmZ1WWNydEpta0RYbmRCVzFOYzd2ODdYR3NP?=
 =?utf-8?B?KzFGdXd1L21LUkxWUjJ3ajJNRFltWFVMOXk0eHdsSmI1bTQ3ZnZnaUgxTVIr?=
 =?utf-8?B?K3RrRWZqNEc0bTRXKzNnTkE5azRpaWd0UEFSZDA2NEZyREJSSVNqc1JBNGE3?=
 =?utf-8?B?eFJST08rSEVHTmc3aVJGSHZBMGFCVEZ2aWRoeXFMVlNHSERTdWtPZ1FucHdF?=
 =?utf-8?B?Wlp4dFFNQytrck0raFRqaS9PYWtQVE1ZSktTaWoyR001cVR3MzQ4QXdwam9L?=
 =?utf-8?B?SUFEMEh6bkREVWxSSGJkeC9sNDN0N1BjZUcxaUx4VXd5NkpQSCtFM3FWamF4?=
 =?utf-8?B?UW1mY0xVbkhEOHJzOVYvQjYzVU5OSm9VMHdES0VsWGN5Qy9BZGt0WnoyTVF0?=
 =?utf-8?B?Q25iZnFVL1l6WDhsRTFuTGZVcjJVenpsNXlVYVNmUFYyd3dMVmdLbk1mMXJH?=
 =?utf-8?B?eVFRZUhueFVWcmJhdlEwUmdDTnJYbkxieFFDRlRQTHJ0dTFvZ3hGTU5FbUdq?=
 =?utf-8?B?M0JSUmZKcEdDWUhDZVE0OFgwVVFYQjNua3A2VGN0VEZuNWRNSXhIME9mbWZ6?=
 =?utf-8?B?cjB4V0tiZW40OERnOGkzdzVtVUZ4OXBlVjdJS08ySHJqcHVSQzcyVHpLM3Bo?=
 =?utf-8?B?bEFUY2hiRDVic2x5R2FzOXZsVEhhYUN6WmNqckllZVR0NzV2MTlRaUYvUEdi?=
 =?utf-8?B?Z1dzSVRSR2t6Z0JZblNhN3lLU1UrdDBodGdLS041a1ZBMXQ1Z0YzOGV0bFhI?=
 =?utf-8?B?S2RNU0FBZzR0NDNodWUrS2c5b2xVWnF0SVdQaGNHQUszTW14WHcvWXJPZG5K?=
 =?utf-8?B?US9lWTFPS2FqUldYNDdKRjgvd0hIYnk5c0ZUSk53OEV4a0RMRjdxLzNrZnpE?=
 =?utf-8?B?SUNnbDh2Y2p5YmZpSmQwSnkyeWxaSnY1UUp2ZEd2TG1td0NHbi9ZMHdlQit5?=
 =?utf-8?B?ZDhzQTBycDRYSi9LdEtOdWFrVWx6cFpCUm1yc2ZibmdkbEtiVUVNczhhTnU2?=
 =?utf-8?B?YTA5WW5kQ0UyTGhuV1lxeHg0NnQvc3NxbDU3c3RYcEdTWm9LQk1sU0RNZ20y?=
 =?utf-8?B?MTlKa2NoME9aR25VSjRBS05lM2JrNVorQnNseC9nNUVvUmNzUzhENG96S29u?=
 =?utf-8?B?aUEzZjB2Qm9SRTJZL2d4Unc3UnNwSHo4OEFCM0dQdm5NK1owa3BlSVR3dmJx?=
 =?utf-8?B?ZzFaV05oNE1CcmlsVVdyNVhGWTFjallZb0hlKzFvR2NOUDB0SElON0Vwb1po?=
 =?utf-8?B?clhmSlZZOFU1RnBacnRrRVpQMkY2ZXJTWGc2MzRuSCtldjFSUT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ca49a4-bbcc-4bdf-9a93-08db723f484a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 10:07:12.7439 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofCEiguSbBas1Pdunm3JZhuGqnRmG8ilmdrf8zT6CrSPPNYZkWTqarwNMD/EjqlDi6rXpVqufAKraYtYMIS9Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5662
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 22 Jun 2023 06:38:38 +0000
Subject: Re: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq
 checks
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMjAsIDIwMjMgYXQgMDk6MTQ6MjVQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIE1vbiwgSnVuIDEyLCAyMDIzIGF0IDEwOjA5OjM5QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBGcmksIEp1biAwOSwgMjAyMyBhdCAxMjo1NToz
OVBNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IE9uIEZyaSwgSnVuIDA5
LCAyMDIzIGF0IDA1OjEzOjQ1UE0gKzAyMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiA+
ID4gT24gVGh1LCBKdW4gMDgsIDIwMjMgYXQgMTE6MzM6MjZBTSAtMDQwMCwgRGVtaSBNYXJpZSBP
YmVub3VyIHdyb3RlOgo+ID4gPiA+ID4gT24gVGh1LCBKdW4gMDgsIDIwMjMgYXQgMTA6Mjk6MThB
TSArMDIwMCwgUm9nZXIgUGF1IE1vbm7DqSB3cm90ZToKPiA+ID4gPiA+ID4gT24gV2VkLCBKdW4g
MDcsIDIwMjMgYXQgMTI6MTQ6NDZQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVub3VyIHdyb3RlOgo+
ID4gPiA+ID4gPiA+IE9uIFdlZCwgSnVuIDA3LCAyMDIzIGF0IDEwOjIwOjA4QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiA+ID4gPiA+IFRoZW4gdGhlIGJsb2NrIHNjcmlwdCB3
aWxsIG9wZW4gdGhlIGRldmljZSBieSBkaXNrc2VxIGFuZCBwYXNzIHRoZQo+ID4gPiA+ID4gPiBt
YWpvcjptaW5vciBudW1iZXJzIHRvIGJsa2JhY2suCj4gPiA+ID4gPiAKPiA+ID4gPiA+IEFsdGVy
bmF0aXZlbHksIHRoZSB0b29sc3RhY2sgY291bGQgd3JpdGUgYm90aCB0aGUgZGlza3NlcSBhbmQK
PiA+ID4gPiA+IG1ham9yOm1pbm9yIG51bWJlcnMgYW5kIGJlIGNvbmZpZGVudCB0aGF0IGl0IGlz
IHJlZmVycmluZyB0byB0aGUKPiA+ID4gPiA+IGNvcnJlY3QgZGV2aWNlLCBubyBtYXR0ZXIgaG93
IGxvbmcgYWdvIGl0IGdvdCB0aGF0IGluZm9ybWF0aW9uLgo+ID4gPiA+ID4gVGhpcyBjb3VsZCBi
ZSBxdWl0ZSB1c2VmdWwgZm9yIGUuZy4gb25lIFZNIGV4cG9ydGluZyBhIGRldmljZSB0bwo+ID4g
PiA+ID4gYW5vdGhlciBWTSBieSBjYWxsaW5nIGxvc2V0dXAoOCkgYW5kIGV4cGVjdGluZyBhIGh1
bWFuIHRvIG1ha2UgYQo+ID4gPiA+ID4gZGVjaXNpb24gYmFzZWQgb24gdmFyaW91cyBwcm9wZXJ0
aWVzIGFib3V0IHRoZSBkZXZpY2UuICBJbiB0aGlzCj4gPiA+ID4gPiBjYXNlIHRoZXJlIGlzIG5v
IHVwcGVyIGJvdW5kIG9uIHRoZSByYWNlIHdpbmRvdy4KPiA+ID4gPiAKPiA+ID4gPiBJbnN0ZWFk
IG9mIHBsYXlpbmcgd2l0aCB4ZW5zdG9yZSBub2RlcywgaXQgbWlnaHQgYmUgYmV0dGVyIHRvIHNp
bXBseQo+ID4gPiA+IGhhdmUgYmxrYmFjayBleHBvcnQgb24gc3lzZnMgdGhlIGRpc2tzZXEgb2Yg
dGhlIG9wZW5lZCBkZXZpY2UsIGFuZCBsZXQKPiA+ID4gPiB0aGUgYmxvY2sgc2NyaXB0IGNoZWNr
IHdoZXRoZXIgdGhhdCdzIGNvcnJlY3Qgb3Igbm90LiAgVGhhdCBpbXBsaWVzCj4gPiA+ID4gbGVz
cyBjb2RlIGluIHRoZSBrZXJuZWwgc2lkZSwgYW5kIGRvZXNuJ3QgcG9sbHV0ZSB4ZW5zdG9yZS4K
PiA+ID4gCj4gPiA+IFRoaXMgd291bGQgcmVxdWlyZSB0aGF0IGJsa2JhY2sgZGVsYXkgZXhwb3Np
bmcgdGhlIGRldmljZSB0byB0aGUKPiA+ID4gZnJvbnRlbmQgdW50aWwgdGhlIGJsb2NrIHNjcmlw
dCBoYXMgY2hlY2tlZCB0aGF0IHRoZSBkaXNrc2VxIGlzIGNvcnJlY3QuCj4gPiAKPiA+IFRoaXMg
ZGVwZW5kcyBvbiB5b3VyIHRvb2xzdGFjayBpbXBsZW1lbnRhdGlvbi4gIGxpYnhsIHdvbid0IHN0
YXJ0IHRoZQo+ID4gZG9tYWluIHVudGlsIGJsb2NrIHNjcmlwdHMgaGF2ZSBmaW5pc2hlZCBleGVj
dXRpb24sIGFuZCBoZW5jZSB0aGUKPiA+IGJsb2NrIHNjcmlwdCB3YWl0aW5nIGZvciB0aGUgc3lz
ZnMgbm9kZSB0byBhcHBlYXIgYW5kIGNoZWNrIGl0IGFnYWluc3QKPiA+IHRoZSBleHBlY3RlZCB2
YWx1ZSB3b3VsZCBiZSBlbm91Z2guCj4gCj4gVHJ1ZSwgYnV0IHdlIGNhbm5vdCBhc3N1bWUgdGhh
dCBldmVyeW9uZSBpcyB1c2luZyBsaWJ4bC4KClJpZ2h0LCBmb3IgdGhlIHVkZXYgY2FzZSB0aGlz
IHdvbid0IGJlIGdvb2QsIHNpbmNlIHRoZSBkb21haW4gY291bGQgYmUKYWxyZWFkeSBydW5uaW5n
LCBhbmQgaGVuY2UgY291bGQgcG90ZW50aWFsbHkgYXR0YWNoIHRvIHRoZSBiYWNrZW5kCmJlZm9y
ZSB0aGUgaG90cGx1ZyBzY3JpcHQgcmVhbGl6ZWQgdGhlIG9wZW5lZCBkZXZpY2UgaXMgd3Jvbmcu
Ckxpa2V3aXNlIGZvciBob3QgYWRkIGRpc2tzLgoKPiA+ID4gTXVjaCBzaW1wbGVyIGZvciB0aGUg
YmxvY2sgc2NyaXB0IHRvIHByb3ZpZGUgdGhlIGRpc2tzZXEgaW4geGVuc3RvcmUuCj4gPiA+IElm
IHlvdSB3YW50IHRvIGF2b2lkIGFuIGV4dHJhIHhlbnN0b3JlIG5vZGUsIEkgY2FuIG1ha2UgdGhl
IGRpc2tzZXEgcGFydAo+ID4gPiBvZiB0aGUgcGh5c2ljYWwtZGV2aWNlIG5vZGUuCj4gPiAKPiA+
IEknbSB0aGlua2luZyB0aGF0IHdlIG1pZ2h0IHdhbnQgdG8gaW50cm9kdWNlIGEgInBoeXNpY2Fs
LWRldmljZS11dWlkIgo+ID4gbm9kZSBhbmQgdXNlIHRoYXQgdG8gcHJvdmlkZSB0aGUgZGlza3Nl
cSB0byB0aGUgYmFja2VuZWQuICBUb29sc3RhY2tzCj4gPiAob3IgYmxvY2sgc2NyaXB0cykgd291
bGQgbmVlZCB0byBiZSBzdXJlIHRoZSAicGh5c2ljYWwtZGV2aWNlLXV1aWQiCj4gPiBub2RlIGlz
IHBvcHVsYXRlZCBiZWZvcmUgc2V0dGluZyAicGh5c2ljYWwtZGV2aWNlIiwgYXMgd3JpdGVzIHRv
Cj4gPiB0aGF0IG5vZGUgd291bGQgc3RpbGwgdHJpZ2dlciBibGtiYWNrIHdhdGNoLiAgSSB0aGlu
ayB1c2luZyB0d28KPiA+IGRpc3RpbmN0IHdhdGNoZXMgd291bGQganVzdCBtYWtlIHRoZSBsb2dp
YyBpbiBibGtiYWNrIHRvbwo+ID4gY29tcGxpY2F0ZWQuCj4gPiAKPiA+IE15IHByZWZlcmVuY2Ug
d291bGQgYmUgZm9yIHRoZSBrZXJuZWwgdG8gaGF2ZSBhIGZ1bmN0aW9uIGZvciBvcGVuaW5nIGEK
PiA+IGRldmljZSBpZGVudGlmaWVkIGJ5IGEgZGlza3NlcSAoYXMgZmV0Y2hlZCBmcm9tCj4gPiAi
cGh5c2ljYWwtZGV2aWNlLXV1aWQiKSwgc28gdGhhdCB3ZSBkb24ndCBoYXZlIHRvIG9wZW4gdXNp
bmcKPiA+IG1ham9yOm1pbm9yIGFuZCB0aGVuIGNoZWNrIHRoZSBkaXNrc2VxLgo+IAo+IEluIHRo
ZW9yeSBJIGFncmVlLCBidXQgaW4gcHJhY3RpY2UgaXQgd291bGQgYmUgYSBzaWduaWZpY2FudGx5
IG1vcmUKPiBjb21wbGV4IHBhdGNoIGFuZCBnaXZlbiB0aGF0IGl0IGRvZXMgbm90IGltcGFjdCB0
aGUgdUFQSSBJIHdvdWxkIHByZWZlcgo+IHRoZSBsZXNzLWludmFzaXZlIG9wdGlvbi4KCkZyb20g
YSBibGtiYWNrIHBvaW50IG9mIHZpZXcgSSBkb24ndCBzZWUgdGhhdCBvcHRpb24gYXMgbW9yZSBp
bnZhc2l2ZSwKaXQncyBhY3R1YWxseSB0aGUgb3RoZXIgd2F5IGFyb3VuZCBJTU8uICBPbiBibGti
YWNrIHdlIHdvdWxkIHVzZQpibGtkZXZfZ2V0X2J5X2Rpc2tzZXEoKSAob3IgZXF1aXZhbGVudCkg
aW5zdGVhZCBvZgpibGtkZXZfZ2V0X2J5X2RldigpLCBzbyBpdCB3b3VsZCByZXN1bHQgaW4gYW4g
b3ZlcmFsbCBzaW1wbGVyCmNoYW5nZSAoYmVjYXVzZSB0aGUgY2hlY2sgYWdhaW5zdCBkaXNrc2Vx
IHdvbid0IGJlIG5lZWRlZCBhbnltb3JlKS4KCj4gSXMgdGhlcmUgYW55dGhpbmcgbW9yZSB0aGF0
IG5lZWRzIHRvIGJlIGRvbmUKPiBoZXJlLCBvdGhlciB0aGFuIHJlcGxhY2luZyB0aGUgImRpc2tz
ZXEiIG5hbWU/CgpJIHRoaW5rIHdlIGFsc28gc3Bva2UgYWJvdXQgdXNpbmcgc3NjYW5mIHRvIHBh
cnNlIHRoZSBvcHRpb24uCgpUaGUgcGF0Y2ggdG8gWGVuIGJsa2lmLmggbmVlZHMgdG8gYmUgYWNj
ZXB0ZWQgYmVmb3JlIHRoZSBMaW51eCBzaWRlCmNhbiBwcm9ncmVzcy4KCgo+IEkgcHJlZmVyCj4g
InBoeXNpY2FsLWRldmljZS1sdWlkIiBiZWNhdXNlIHRoZSBJRCBpcyBvbmx5IHZhbGlkIGluIG9u
ZSBwYXJ0aWN1bGFyCj4gVk0uCgoicGh5c2ljYWwtZGV2aWNlLXVpZCIgdGhlbiBtYXliZT8KClRo
YW5rcywgUm9nZXIuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

