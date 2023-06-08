Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 137DCC7EE29
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 07:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686294054;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jifPqRkH7TOjk5l7cTV9nkZL61iSZwoVpzIbxXAYA1s=;
	b=AkgDuPNKC/tXVw17DshRtaXDHat3lUXtat5ftC1AHTYqTvKC6tTVLvf4EhspKKPZP9cunI
	l/qOBfNXB+J60obxcsRKX3HuqHiley0bMoefkmK+KEnAouWOf5bwGJpxj1zJkh40njGK6G
	Olle6dkNdZFE9H6BFbZcEUM/jN/BYVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-ZI_tk5W3OUexJlUftiWf2A-1; Fri, 09 Jun 2023 03:00:51 -0400
X-MC-Unique: ZI_tk5W3OUexJlUftiWf2A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60F21101A531;
	Fri,  9 Jun 2023 07:00:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B2A140C1282;
	Fri,  9 Jun 2023 07:00:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA12B19451C0;
	Fri,  9 Jun 2023 07:00:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 72256194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 09:12:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51C0CC16046; Thu,  8 Jun 2023 09:12:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48654C16044
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 09:12:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23F092823804
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 09:12:00 +0000 (UTC)
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com
 [216.71.155.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-Y6uLrOdbMNesLpy3tNs3vw-1; Thu, 08 Jun 2023 05:11:56 -0400
X-MC-Unique: Y6uLrOdbMNesLpy3tNs3vw-1
X-IronPort-RemoteIP: 104.47.58.104
X-IronPort-MID: 111362467
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:gRrISq8H+tlT1lIFHKpmDrUDwn6TJUtcMsCJ2f8bNWPcYEJGY0x3z
 WobXGGEOPaOYjOhf9lwbIrn80xSusSDzdQ1TAVv+So8E34SpcT7XtnIdU2Y0wF+jCHgZBk+s
 5hBMImowOQcFCK0SsKFa+C5xZVE/fjUAOG6UKicYXoZqTZMEE8JkQhkl/MynrlmiN24BxLlk
 d7pqojUNUTNNwRcawr40Ird7ks31BjOkGlA5AdmO6gb5Aa2e0Q9V/rzG4ngdxMUfaEMdgKKb
 76r5K20+Grf4yAsBruN+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+v9T2M4nQVVWk120c+VZk
 72hg3ASpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn9IBDJyCAWlvVbD09NqbDklL0
 9olEA4wMCyehue3mriXWMtqhPoseZyD0IM34hmMzBn/JNN/GdXvZvuP4tVVmjAtmspJAPDSI
 dIDbiZiZwjBZBsJPUoLDJU5n6GjgXyXnz9w8QrJ4/ZopTWDilUpjNABM/KMEjCObd9SkUuC4
 HrP4kzyAw0ANczZwj2Amp6prraWxHilAt5MS9VU8NZv2neNwVc2ByQXXHm1vvi/zUKsZvlQf
 hl8Fi0G6PJaGFaQZtXwWhyQoXiavwUdUd5dD+077g6WzqPepQ2eAwAsRy5Lb9EOt8IsQzEuk
 FOK9/vgCj9HqrCZSXuBsLyTqFuaIi4UMX0PfwcHQBED7t2lp5s85jrDS5NvHbC4ivXvFD3wy
 izMpy87750WhNQO3r+2/njGhSytvZnDSgMp5gTRUXmh5wk/b4mgD6Ss6F7G/bNKKIGSTXGfs
 3Ue3cuT9uYDCdeKjiPlaOEMGqy5ovWIKjvRhXZxEJQ7sTeg4XiuecZX+j4WDFdkNIMIdCHkZ
 GfXuBhN/9lDMX2yd6h1bomtTcMwwsDd+c/NU/nVap9CZ8Z3fQrepCV2PxfIgybqjVQmlrw5N
 dGDa8GwAH0GCKNhij2rW+Ma1rxtzSc7rY/Oea3GI92c+eL2TBaopX0tajNisshRAHu4nTjo
IronPort-HdrOrdr: A9a23:K6o0K6ENXiALmxKjpLqEGMeALOsnbusQ8zAXPiBKJCC9E/bo8/
 xG+c5w6faaslkssR0b9+xoW5PwJE80l6QFgrX5VI3KNGXbUQ2TTb2KhbGI/9SKIVydygcy78
 ddmtNFebrN5VgRt7eH3OG7eexQv+VuJsqT9JnjJ3QGd3AaV0l5hT0JbDpyiidNNXN77ZxSLu
 vk2uN34wCOVF4wdcqBCnwMT4H41qD2fMKPW29/O/Y/gjP+9g+V1A==
X-Talos-CUID: =?us-ascii?q?9a23=3AFVc5Jmqv4dewM4xNLqIKcvbmUcUDVEDl8kqOH1K?=
 =?us-ascii?q?5DGczQpGHa1mSxqwxxg=3D=3D?=
X-Talos-MUID: 9a23:xeXqqQSoKghuLHbMRXTp3ht8M/xN7J2vAWIDjpQA/MWWCAd/bmI=
X-IronPort-AV: E=Sophos;i="6.00,226,1681185600"; d="scan'208";a="111362467"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO
 NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 08 Jun 2023 05:11:54 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by CO1PR03MB5873.namprd03.prod.outlook.com (2603:10b6:303:9b::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Thu, 8 Jun
 2023 09:11:51 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Thu, 8 Jun 2023
 09:11:51 +0000
Date: Thu, 8 Jun 2023 11:11:44 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZIGbUDpqjwbR5zmz@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-17-demi@invisiblethingslab.com>
 <ZH75OTMA6N3zYrH2@Air-de-Roger> <ZH9tcGh0N2fEcwjH@itl-email>
 <ZIBDgKKDhDj+//Q0@Air-de-Roger> <ZICwaWidZxhaGp8v@itl-email>
In-Reply-To: <ZICwaWidZxhaGp8v@itl-email>
X-ClientProxiedBy: LO4P123CA0165.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::8) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|CO1PR03MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a92e457-0e57-41c2-64fc-08db68006509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: dCG8b2hegsg5rquNK13BWen0/GsRzM6xXZiOhxfEyAMdMAnJYozEKuCWGAZfzRUkyzOqj7zbF2Epjy6oWFIEJoPPE/aoghB95mmztY2XNBuAGa3/0t9erJCwMNJFlzDbXasfs4nIBuyts2Nc8ixx7EXIyBMGJufdFpAsZ0KRe63M9c923ra+wgN5Razrs/rMX4uVXam+UoLaAeQWg9gEaVHrcc+n4d9hBjHSBOfs4s8rNWyhcW1Xk6hQ6eWKyKeAKSCdgV0hdRMZfw9qOyUnK/PL0prBAwIGNApixfsLgMqmuRxosY8zvSOFls1rI8sD9DWl0y0kUFmwcRF6i0Mt67qJfXCt9wIzKEO2lGYlsEPJeCeonMpYUZ3qndZ4mVhEMnbVlt/uzYfjU1cUXtHLKKai+gowtY3tXoXo0IhYkrTYJdgva1lfNC0DDetNq+Zcv7wyc2yqY4zMZ0R/zUxrtDD1iQhuKdu6fgXEmOI1L9XAB5areu79jYIiRghH6m73m0BiWB7P7bzhj+4akwMRBwLOKV9zUkhKL1J77p0m2Hcyd/jjUcFyJS0q8L7ljzEb
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(7916004)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199021)(54906003)(82960400001)(478600001)(5660300002)(8936002)(8676002)(4326008)(6916009)(66556008)(66476007)(316002)(66946007)(41300700001)(38100700002)(186003)(83380400001)(6486002)(6666004)(9686003)(6506007)(26005)(6512007)(86362001)(33716001)(2906002)(85182001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm5NMDZ5anEvcVRzVzVZc0pFK203dGhsRW9uTXFjdGZpNDNYZ0lxOEl3a3px?=
 =?utf-8?B?ZTM2YjFjSE1UcDYzQzFVcUkyc1NnV0pKbVh6MWdDMUY5N0Q4RnNPQlV6WDdR?=
 =?utf-8?B?UndTT3BOaDlBZ1hqeG1nbFdLOCtIZjB1ZlcxU2tHcEV1ck55R2w0eG1FOGtF?=
 =?utf-8?B?THA4Qi9kRWJYZnY5TXZiWVBDTjJhWi93cWhYY2JuQUJlMTJ1UUNOeFlKODZN?=
 =?utf-8?B?NVQxbVQ4UEdrb3NhVlB5dDczMkF6bHJ0WHN1ZFZuRTVKZGltM0hrRnBudU1M?=
 =?utf-8?B?OEtrZ1hGSFB3Z2hmcTExN0xyeThsQm8rQ0lzUnk1RDVMOEdCYVdKUXkwMXZ4?=
 =?utf-8?B?Vy9rTVlGUjFudFphOTNFdWEyMHZSVklRbTRldXVzZmtReEwwN3I4OXJKUUlF?=
 =?utf-8?B?Z0N4cCtwZEtFcGpMTFczZVZhOU1YU2hka0ZPYTMzakFzak1hR2lmMForT0pp?=
 =?utf-8?B?cFNLa2NTZERpMENDRFc2S0NUVW1xcXFXd1ExaUJQb2pEZXc5MDhPQWg3UUtL?=
 =?utf-8?B?QVZnVFhuMU1EYVc3WmFzcVJiTjVZQW50MXFwN05jS2pHVlgxZnB3cFBVVk92?=
 =?utf-8?B?ZXBIdm4zcDkwL08vbFNqdzZvOC80QnlPSUhoRjg2Vnp0WVQ3ckxPVmU1ZnJw?=
 =?utf-8?B?d2hLU0lvMnVjRVhyaXkrT2k4d1MzVWFLaTYzNUhXYUx5ZlVyY1FQYXpucloy?=
 =?utf-8?B?c1BCVmxMYjAxZ1R1VG1Td3JwY3pySUpQNWF3dWljVzZLS0dMRmZqc0xKVDBJ?=
 =?utf-8?B?QjZpaTZ4eXFhL2dHcmtXdjhUYWVid3I2a2EvRmowZ1BMZjFNOEJJMnBpS1F0?=
 =?utf-8?B?N0grODNhN3VGc082NlMrRm1MdkJKbzVyOWdScEhtak5pNlVMZXl6OUVxWksx?=
 =?utf-8?B?TVFML3YyaGpkOGk1RlBTSXNxbVFtcklSVHl4T1NZbitjRWFuM21ySUNCMENG?=
 =?utf-8?B?clRoakZFUkJvVWlGQ0JpbEhCaEU3WkNOZXJYQmRKNVIrQ0h1blkxZ3NycWVo?=
 =?utf-8?B?YXZXVlVmTnZhenJVYUxLRzB6b3VyVW5jbHp3K1NXaGNkdTVRdnJxMk1KQjNJ?=
 =?utf-8?B?Qk1WalR6cDdBM1IrNHdkeitZcHN5UGhzTklOT1lYZUZvcXdCMXdrOEx2aFRO?=
 =?utf-8?B?UWx4b1VwTTVFN1l2U1g4L1BJYW5vSzRkaUkzc0NsUUE5Rm42R0tFbGh4Y1VR?=
 =?utf-8?B?azZWWEd0WUpycFZZUGdrVnVsWHRzU2dxd2ROQVFldkhMQ2xjcjR1Z0VMSkhz?=
 =?utf-8?B?SE9ZajVJNDZYOUMvYWVqMkpZdFFTVHJxQUFsZFNXUzhFV1JMV3NUZXFmekZB?=
 =?utf-8?B?cDZOakRndi9SWXMwcmRHNXhmU0JNYnYxeERLNWpqYTlZTURxTmxCSzN3UWRE?=
 =?utf-8?B?cUNLbjBlYlhsSFN1WDVuWkc3Zm4wdXNPZVlpZ2xrUzUvMSt6L241OHdSWCtt?=
 =?utf-8?B?UVZyY1NqQ2hZaHloSkNGWVdwbmJGeU9GclNUaXdvN1VuQ21Yam1tYWVVc1Vz?=
 =?utf-8?B?SEFsZmhYNVByRVlqNFlqZ01mQ204ZHFGZTlrdU81QVAydVA2dExWaHEzdGdy?=
 =?utf-8?B?cHZqTVE4M21RZU1xUThxMGpZd2tRQUxSVXhSVEdCYU8xRzIzMFVHL2w0YUV2?=
 =?utf-8?B?U1lhK1BrYW5VRGNwY044QVdjL0V2OTM5VzdaRDhNZlNDZ1g1U29SRzFsc2pw?=
 =?utf-8?B?M2tKdlR6eHlHeXVFcStIN3ZiOGt2ZWRSWmh0ZENzeGdSekFLa05yVTlzbUNp?=
 =?utf-8?B?cDNKNlduMTJGWjhhYW9wTGwvOTk1RDFPS1JoSG5aWlpQYWtJMFg0QXFwUmJT?=
 =?utf-8?B?K214VnE0TzJ5YlkwSWVvcFZTQmIxMFROYzR0MlNVUlNBVXd4L1M2N1VwRzk2?=
 =?utf-8?B?Um9GdXYvVjVSLzZNZGdETGtLN3pLaVVoeFFZNnA5ZTg1eU9TeEFBc1czZXZa?=
 =?utf-8?B?QnBSSHdIZWhoMTFlUG5oWU9IOVhlU3YwU1hvcGxNckZzZ2xHY1FNV2FNZGR1?=
 =?utf-8?B?Tkl0aE5kbjd2Yi9KL2RiNnpnZFVWWEpIVGFiYXM5ZFlONFlOR3AzcGwwYTNw?=
 =?utf-8?B?RnJRWlFlZDV4WUxlMkNiQmlXTnNjYm9renlxdEJhMTJGQTNDdGx4eVV1aFBM?=
 =?utf-8?B?Yk93U0NvdE5nNFlNUWdOZ1B1d0RoZ0NMZlZaaS9RM0xIU1pMaGRieEVueW9K?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YysvMmlUblhpWlEveVhHbTVKeVpmOEd3UnlMUUFiRGNSSElEdEhPQXlpQ2h4?=
 =?utf-8?B?eGppREZTWkUyanlNUGRJL0tzcFRHaFU2S0xUOWluYk16akJvTlQzT2UrSEth?=
 =?utf-8?B?bGN5L2huTklOVW1UYW9mZ2xGYjBGODBoZXRhSkF5UUtaTjVndnhRL1NDVlFz?=
 =?utf-8?B?bTd5cVJxM1VEbHhVVnAxelhHNHNkeXYyRkltSkFCQWFaZFVPWmpqR3hIakla?=
 =?utf-8?B?NHk0OWhMOVorL0tJZy82eTQxa3FhSUI2a1hrSDM5Ym1oR1hBT044ak5nZzdF?=
 =?utf-8?B?cnJCcVYxYnJ6aHRhYjJmbTFtWlFuVXRTZCtkeU1CNFRxdGFBWEIwczhwOEtO?=
 =?utf-8?B?WmZNYXMxTW03K0x0S2JhallaZzV5YmpyYkxjNEsyL2J0L2V2QTUrTCtVVVhv?=
 =?utf-8?B?Q2prYkpORU1NaXIvWWFoZE1pdlFoZGxnS3k5NjEvdnJScWZwYjEzOHIra3hD?=
 =?utf-8?B?VFZQd0tPeWU1MUowYThqK1BmNllrcG12OStqREJsV2lna0hNdHkxRUhQa2g5?=
 =?utf-8?B?cWhqdkhnZWhrS05ZQk5wL2ZyaGFiNVZLc0J1Sm8rODRNMDIzT25vUm05dlo0?=
 =?utf-8?B?enZXRTYzQ2pzMGdwdnljTm02QjBtenhaM2M1UU1BYWkxNXU1K084TzZ2RUsz?=
 =?utf-8?B?VHdBTjRhdTRTSXlMM1ZxUmFDM2J5bll6OEhSNXFuNHE2QUQ1REdESzFGcDRh?=
 =?utf-8?B?TnRVWEhoTk9Cc0IxU0JKWllhRmtLeG5EN2ZKSTQyekhMMG44UUlQZ1ZIeHYw?=
 =?utf-8?B?akltNHYrdVowZkRDaitEU3BIRTRqNEtvR3RTNEpydHZpYzVJb1lPL3JJY0dP?=
 =?utf-8?B?MHliamtia0FBc0ZPNThRUU5OMGkzZFdiRXdOYURUUDJMUEVDZVdWTWdWMTR3?=
 =?utf-8?B?SzR1WmFLcTBYZC8zdFdvdXBEUzQrait4a1NGU2JicEpLN0RlYkhKV1B2MlUr?=
 =?utf-8?B?dEI3TDlZTWs2VEdyNnR3bWJoVTFSVUZYL3U5aXZqaWkyNjN2UHNGYXdQTzN4?=
 =?utf-8?B?VDI5Wmlya0hxaC9lNEhsNmQ0dytFVmlhZzZFem1PT0tmaW8vaEJXeFFPc1Bs?=
 =?utf-8?B?UUo2a0NjYnRNQllwVG0wWUZNWWJVYm1HR1NJRm5qYnVaeWFVOHFZTHF5QVdz?=
 =?utf-8?B?cUx3ak9TMjNTR2VRRzd5bjFiZk5BYWxxYlRGK3FEbHFOckZxOVNVdGRpc0pU?=
 =?utf-8?B?cE4wclpnOUFCUEV6NmFCRnhGSFFBUjRDem9LUXFCeEpzcXZabUtjckVKVHN0?=
 =?utf-8?B?dEpUZnVHaU82N0N2Tk5MOTVVcjR3Y3VHRkVuK2x2cDVrcmtDZz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a92e457-0e57-41c2-64fc-08db68006509
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 09:11:51.1063 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDbJaNQ6GmtpULeYEdhhy+D1txRQFQPG3J1OPXhgq6JekeCDtbzJMyzyH8nusFK95yTFN5CpbvcW6hefzymvgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR03MB5873
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 09 Jun 2023 07:00:46 +0000
Subject: Re: [dm-devel] [PATCH v2 16/16] xen-blkback: Inform userspace that
 device has been opened
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMDcsIDIwMjMgYXQgMTI6Mjk6MjZQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIFdlZCwgSnVuIDA3LCAyMDIzIGF0IDEwOjQ0OjQ4QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBUdWUsIEp1biAwNiwgMjAyMyBhdCAwMTozMToy
NVBNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IE9uIFR1ZSwgSnVuIDA2
LCAyMDIzIGF0IDExOjE1OjM3QU0gKzAyMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiA+
ID4gT24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgMDQ6MzE6MTZQTSAtMDQwMCwgRGVtaSBNYXJpZSBP
YmVub3VyIHdyb3RlOgo+ID4gPiA+ID4gU2V0ICJvcGVuZWQiIHRvICIwIiBiZWZvcmUgdGhlIGhv
dHBsdWcgc2NyaXB0IGlzIGNhbGxlZC4gIE9uY2UgdGhlCj4gPiA+ID4gPiBkZXZpY2Ugbm9kZSBo
YXMgYmVlbiBvcGVuZWQsIHNldCAib3BlbmVkIiB0byAiMSIuCj4gPiA+ID4gPiAKPiA+ID4gPiA+
ICJvcGVuZWQiIGlzIHVzZWQgZXhjbHVzaXZlbHkgYnkgdXNlcnNwYWNlLiAgSXQgc2VydmVzIHR3
byBwdXJwb3NlczoKPiA+ID4gPiA+IAo+ID4gPiA+ID4gMS4gSXQgdGVsbHMgdXNlcnNwYWNlIHRo
YXQgdGhlIGRpc2tzZXEgWGVuc3RvcmUgZW50cnkgaXMgc3VwcG9ydGVkLgo+ID4gPiA+ID4gCj4g
PiA+ID4gPiAyLiBJdCB0ZWxscyB1c2Vyc3BhY2UgdGhhdCBpdCBjYW4gd2FpdCBmb3IgIm9wZW5l
ZCIgdG8gYmUgc2V0IHRvIDEuCj4gPiA+ID4gPiAgICBPbmNlICJvcGVuZWQiIGlzIDEsIGJsa2Jh
Y2sgaGFzIGEgcmVmZXJlbmNlIHRvIHRoZSBkZXZpY2UsIHNvCj4gPiA+ID4gPiAgICB1c2Vyc3Bh
Y2UgZG9lc24ndCBuZWVkIHRvIGtlZXAgb25lLgo+ID4gPiA+ID4gCj4gPiA+ID4gPiBUb2dldGhl
ciwgdGhlc2UgY2hhbmdlcyBhbGxvdyB1c2Vyc3BhY2UgdG8gdXNlIGJsb2NrIGRldmljZXMgd2l0
aAo+ID4gPiA+ID4gZGVsZXRlLW9uLWNsb3NlIGJlaGF2aW9yLCBzdWNoIGFzIGxvb3AgZGV2aWNl
cyB3aXRoIHRoZSBhdXRvY2xlYXIgZmxhZwo+ID4gPiA+ID4gc2V0IG9yIGRldmljZS1tYXBwZXIg
ZGV2aWNlcyB3aXRoIHRoZSBkZWZlcnJlZC1yZW1vdmUgZmxhZyBzZXQuCj4gPiA+ID4gCj4gPiA+
ID4gVGhlcmUgd2FzIHNvbWUgd29yayBpbiB0aGUgcGFzdCB0byBhbGxvdyByZWxvYWRpbmcgYmxr
YmFjayBhcyBhCj4gPiA+ID4gbW9kdWxlLCBpdCdzIGNsZWFyIHRoYXQgdXNpbmcgZGVsZXRlLW9u
LWNsb3NlIHdvbid0IHdvcmsgaWYgYXR0ZW1wdGluZwo+ID4gPiA+IHRvIHJlbG9hZCBibGtiYWNr
Lgo+ID4gPiAKPiA+ID4gU2hvdWxkIGJsa2JhY2sgc3RvcCBpdHNlbGYgZnJvbSBiZWluZyB1bmxv
YWRlZCBpZiBkZWxldGUtb24tY2xvc2UgaXMgaW4KPiA+ID4gdXNlPwo+ID4gCj4gPiBIbSwgbWF5
YmUuICBJIGd1ZXNzIHRoYXQncyB0aGUgYmVzdCB3ZSBjYW4gZG8gcmlnaHQgbm93Lgo+IAo+IEni
gJlsbCBpbXBsZW1lbnQgdGhpcy4KCkxldCdzIG1ha2UgdGhpcyBhIHNlcGFyYXRlIHBhdGNoLgoK
PiA+ID4gPiBJc24ndCB0aGVyZSBzb21lIGV4aXN0aW5nIHdheSB0byBjaGVjayB3aGV0aGVyIGEg
ZGV2aWNlIGlzIG9wZW5lZD8KPiA+ID4gPiAoc3RhdCBzeXNjYWxsIG1heWJlPykuCj4gPiA+IAo+
ID4gPiBLbm93aW5nIHRoYXQgdGhlIGRldmljZSBoYXMgYmVlbiBvcGVuZWQgaXNu4oCZdCBlbm91
Z2guICBUaGUgYmxvY2sgc2NyaXB0Cj4gPiA+IG5lZWRzIHRvIGJlIGFibGUgdG8gd2FpdCBmb3Ig
YmxrYmFjayAoYW5kIG5vdCBzb21ldGhpbmcgZWxzZSkgdG8gb3Blbgo+ID4gPiB0aGUgZGV2aWNl
LiAgT3RoZXJ3aXNlIGl0IHdpbGwgYmUgY29uZnVzZWQgaWYgdGhlIGRldmljZSBpcyBvcGVuZWQg
YnkKPiA+ID4gZS5nLiB1ZGV2Lgo+ID4gCj4gPiBVcmcsIG5vLCB0aGUgYmxvY2sgc2NyaXB0IGNh
bm5vdCB3YWl0IGluZGVmaW5pdGVseSBmb3IgYmxrYmFjayB0byBvcGVuCj4gPiB0aGUgZGV2aWNl
LCBhcyBpdCBoYXMgYW4gZXhlY3V0aW9uIHRpbWVvdXQuICBibGtiYWNrIGlzIGZyZWUgdG8gb25s
eQo+ID4gb3BlbiB0aGUgZGV2aWNlIHVwb24gZ3Vlc3QgZnJvbnRlbmQgY29ubmVjdGlvbiwgYW5k
IHRoYXQgKHdoZW4gdXNpbmcKPiA+IGxpYnhsKSByZXF1aXJlcyB0aGUgaG90cGx1ZyBzY3JpcHRz
IGV4ZWN1dGlvbiB0byBiZSBmaW5pc2hlZCBzbyB0aGUKPiA+IGd1ZXN0IGNhbiBiZSBzdGFydGVk
Lgo+IAo+IEnigJltIGEgYml0IGNvbmZ1c2VkIGhlcmUuICBNeSB1bmRlcnN0YW5kaW5nIGlzIHRo
YXQgYmxrZGV2X2dldF9ieV9kZXYoKQo+IGFscmVhZHkgb3BlbnMgdGhlIGRldmljZSwgYW5kIHRo
YXQgaGFwcGVucyBpbiB0aGUgeGVuc3RvcmUgd2F0Y2gKPiBoYW5kbGVyLiAgSSBoYXZlIHRlc3Rl
ZCB0aGlzIHdpdGggZGVsZXRlLW9uLWNsb3NlIGRldmljZS1tYXBwZXIgZGV2aWNlcywKPiBhbmQg
aXQgZG9lcyB3b3JrLgoKUmlnaHQsIGJ1dCBvbiBhIHZlcnkgY29udGVuZGVkIHN5c3RlbSB0aGVy
ZSdzIG5vIGd1YXJhbnRlZSBvZiB3aGVuCmJsa2JhY2sgd2lsbCBwaWNrIHVwIHRoZSB1cGRhdGUg
dG8gInBoeXNpY2FsLWRldmljZSIgYW5kIG9wZW4gdGhlCmRldmljZSwgc28gZmFyIHRoZSBibG9j
ayBzY3JpcHQgb25seSB3cml0ZXMgdGhlIHBoeXNpY2FsLWRldmljZSBub2RlCmFuZCBleGl0cy4g
IFdpdGggdGhlIHByb3Bvc2VkIGNoYW5nZSB0aGUgYmxvY2sgc2NyaXB0IHdpbGwgYWxzbyB3YWl0
CmZvciBibGtiYWNrIHRvIHJlYWN0IHRvIHRoZSBwaHlzY2FsLWRldmljZSB3cml0ZSwgaGVuY2Ug
bWFraW5nIFZNCmNyZWF0aW9uIHNsb3dlci4KCj4gPiA+ID4gSSB3b3VsZCBsaWtlIHRvIGF2b2lk
IGFkZGluZyBtb3JlIHhlbnN0b3JlIGJsa2JhY2sgc3RhdGUgaWYgc3VjaAo+ID4gPiA+IGluZm9y
bWF0aW9uIGNhbiBiZSBmZXRjaGVkIGZyb20gb3RoZXIgbWV0aG9kcy4KPiA+ID4gCj4gPiA+IEkg
ZG9u4oCZdCB0aGluayBpdCBjYW4gYmUsIHVubGVzcyB0aGUgaW5mb3JtYXRpb24gaXMgcGFzc2Vk
IHZpYSBhCj4gPiA+IGNvbXBsZXRlbHkgZGlmZmVyZW50IG1ldGhvZC4gIE1heWJlIG5ldGxpbmso
Nykgb3IgaW9jdGwoMik/ICBBcmd1YWJseQo+ID4gPiB0aGlzIGluZm9ybWF0aW9uIHNob3VsZCBu
b3QgYmUgc3RvcmVkIGluIFhlbnN0b3JlIGF0IGFsbCwgYXMgaXQgZXhwb3Nlcwo+ID4gPiBiYWNr
ZW5kIGltcGxlbWVudGF0aW9uIGRldGFpbHMgdG8gdGhlIGZyb250ZW5kLgo+ID4gCj4gPiBDb3Vs
ZCB5b3UgbWF5YmUgdXNlIHN5c2ZzIGZvciB0aGlzIGluZm9ybWF0aW9uPwo+IAo+IFByb2JhYmx5
PyAgVGhpcyB3b3VsZCBpbnZvbHZlIGFkZGluZyBhIG5ldyBmaWxlIGluIHN5c2ZzLgo+IAo+ID4g
V2UgaGF2ZSBhbGwgc29ydHMgb2YgY3JhcCBpbiB4ZW5zdG9yZSwgYnV0IGl0IHdvdWxkIGJlIGJl
c3QgaWYgd2UgY2FuCj4gPiBzZWUgb2YgcGxhY2luZyBzdHVmZiBsaWtlIHRoaXMgaW4gYW5vdGhl
ciBpbnRlcmZhY2UuCj4gCj4gRmFpci4KCkxldCdzIHNlZSBpZiB0aGF0J3MgYSBzdWl0YWJsZSBh
cHByb2FjaCwgYW5kIHdlIGNhbiBhdm9pZCBoYXZpbmcgdG8KYWRkIGFuIGV4dHJhIG5vZGUgdG8g
eGVuc3RvcmUuCgpUaGFua3MsIFJvZ2VyLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

