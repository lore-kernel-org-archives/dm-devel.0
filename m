Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E4AC7EE45
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206938;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dETJrVjEESCT12Zp7MjOGZ8OOeevytUc2RfGNBHUEMQ=;
	b=PyOuK6NUMwA4bAgFKbJn66Zo6lRSHXHC9ZSVyWvGr0uoc3oX/STi+Wxre8aQQRAxLvkhjV
	dO5L6PgV40endAHVVJFIWmWldKBCry+GRhMEZJuE8UQ2+cUxpAjxPpQhvF5uEieIJRyT1y
	Xtvelnv6IE604MMmp6OFDl+6xif1BNs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-oIfzZ_p9N6quMQ4M2bmC3Q-1; Thu, 08 Jun 2023 02:48:54 -0400
X-MC-Unique: oIfzZ_p9N6quMQ4M2bmC3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A5F738184E3;
	Thu,  8 Jun 2023 06:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1499D1121315;
	Thu,  8 Jun 2023 06:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04D1B194E104;
	Thu,  8 Jun 2023 06:48:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 49AB719465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 08:45:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 179BE7AE4; Wed,  7 Jun 2023 08:45:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EDE19E8B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 08:45:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7C9F101A55C
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 08:45:00 +0000 (UTC)
Received: from esa1.hc3370-68.iphmx.com (esa1.hc3370-68.iphmx.com
 [216.71.145.142]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-JpRnYcF_NZuTb2E0Y9GxPA-1; Wed, 07 Jun 2023 04:44:58 -0400
X-MC-Unique: JpRnYcF_NZuTb2E0Y9GxPA-1
X-IronPort-RemoteIP: 104.47.51.46
X-IronPort-MID: 112295559
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:pyQ6cqPmcUl25irvrR3ml8FynXyQoLVcMsEvi/4bfWQNrUojg2EPx
 jQdDWnSb/mIYGGnc4snPtmwoRkG6JDWz99gSAto+SlhQUwRpJueD7x1DKtS0wC6dZSfER09v
 63yTvGacajYm1eF/k/F3oDJ9CU6jufQAOKnUoYoAwgpLSd8UiAtlBl/rOAwh49skLCRDhiE/
 Nj/uKUzAnf8s9JPGjxSs/rrRC9H5qyo42tG5gNmPJingXeF/5UrJMNHTU2OByOQrrl8RoaSW
 +vFxbelyWLVlz9F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq/0Te5p0TJvsEAXq7vh3S9zxHJ
 HehgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/ZqAJGpfh66wGMa04AWEX0sRbWX9o7
 PgUEQgcakmCl+SHw56wddA506zPLOGzVG8ekldJ6GmDSNwAGNXESaiM4sJE1jAtgMwIBezZe
 8cSdTtoalLHfgFLPVAUTpk5mY9EhFGmK2Ee9A3T+PNxvza7IA9ZidABNPLPfdOHX4NNl1uwr
 WPa5WXpRBodMbRzzBLcqyj217KSwHKTtIQ6JoSF+KNxq12vnVMsDgIKRH+ervKLsxvrMz5YA
 wlOksY0loA++UmqZtj7QRyjoXSAswIcWtxfCOkz4keGza+8yw+JDG8JZj1MctorsIk6RlQC3
 1CKt8nkCTxmrPueTnf13qySrC+gNDI9LmIYYyIACwwf7LHLrIR2gh/RQ9JLCqO5jtTpXzr3x
 liiqSEkgrwJgM0j1qOl/EvGiTahupjISAEu4gzdGGmi62tRYI+jepzt41zc5vVoMomUVB+Cs
 WIClszY6/oBZbmJlSqQUKAOEauv6vKtLjLRmxhsEoMn+jDr/GSsFahA7Tc7KEp3P8IsfT7yf
 FSVqQ5X/IVUPnahcelweY3ZNigx5a3pFNCgXPaNaNNLOsJ1bFXfoH8oYlOM1WfwlkRqibs4J
 ZqQbcerCzAdFLhjyz21Aewa1NfH2xwD+I8afrijpzzP7FZUTCT9pWstWLdWUt0E0Q==
IronPort-HdrOrdr: A9a23:PNoloK75iQCMyapI+QPXwDjXdLJyesId70hD6qkQc3Fom62j5q
 STdZEgvyMc5wx/ZJhNo7690cq7MBbhHPxOkOos1N6ZNWGLhILPFuBfBOPZqAEIcBeOlNK1u5
 0BT0EEMqyWMbB75/yKnDVREbwbsaa6GHbDv5ah859vJzsaGp2J921Ce2Cm+tUdfng9OXI+fq
 Dsn/Zvln6bVlk8SN+0PXUBV/irnay3qHq3CSR2fyLO8WO1/EiV1II=
X-Talos-CUID: 9a23:urKZWG0sJ3BzInh45XcNNbxfOOx9bFvEyHvpG168UGd5ToyWZVSvwfYx
X-Talos-MUID: =?us-ascii?q?9a23=3AuEYyOg5Buqa/mjCzzfz9/r/9xoxa2pmgVVsmkal?=
 =?us-ascii?q?dhPaCKjBhHxKShwaOF9o=3D?=
X-IronPort-AV: E=Sophos;i="6.00,223,1681185600"; d="scan'208";a="112295559"
Received: from mail-bn1nam02lp2046.outbound.protection.outlook.com (HELO
 NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.46])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 07 Jun 2023 04:44:56 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by DM8PR03MB6262.namprd03.prod.outlook.com (2603:10b6:8:26::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 08:44:53 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Wed, 7 Jun 2023
 08:44:53 +0000
Date: Wed, 7 Jun 2023 10:44:48 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZIBDgKKDhDj+//Q0@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-17-demi@invisiblethingslab.com>
 <ZH75OTMA6N3zYrH2@Air-de-Roger> <ZH9tcGh0N2fEcwjH@itl-email>
In-Reply-To: <ZH9tcGh0N2fEcwjH@itl-email>
X-ClientProxiedBy: LNXP123CA0023.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::35) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|DM8PR03MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: 100ceb4f-ead3-422e-a45d-08db67337685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: pZyyBKMW9FLLvfYwN7by2w0Gti1FCw9kGin4VoCCU0fQh8UMQWdXIYp/mk9FQBfrLdsr4wpmWoLf84XECrepe7g+t2bYvtQhLcDSF6G11bkxaJ5k97pkOYat4DLvAUGR/BhEcI1qn9Q9jvLY2ggDpqjpuEdWSjZ+Z+EHczUkpmGYmzRxRaikqSyUSj/CNZePTEzVYsZssZm6DO9XpGDGp73ZcHi7xOadbsJUKQNvX0m1vbfl+2OQkN7duXJh0bo7b698wDfCMV/wVpMoo+3PGe00b232pWggUbrtDslQNKlZVkaBLlqsyNl/URSAFfMcCsVGu6Umu64LwRuNTlXH5JEvu8kLEiEFdWOY7IgkZmGLATU9fxKlzvXZkUr0ImaM7ZtCVwb7rpOHy2TJrxWEMfqYmgDCjE4jMHkLzALvv7m/ICA4/q6TYcWbjNshOM5j+MrsEXeg0R9vdxB2AhokUKjzpqMZ6Lbg3Ad9JovUJ83FV/ARy1meiH8Nq2OCKudl/5XIvzZBc/9gPXKdrc2N3ZnWVVnngTxhxLkIfJ+FZnFfhrQCTZNFoinvO6DISCtQ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(7916004)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199021)(6512007)(6506007)(9686003)(26005)(186003)(33716001)(83380400001)(6666004)(66556008)(82960400001)(2906002)(66946007)(66476007)(6486002)(8676002)(8936002)(85182001)(86362001)(38100700002)(5660300002)(54906003)(478600001)(41300700001)(316002)(4326008)(6916009);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1FqaG44dmJ1dVFmR3FWRnNuU0luNDFOcGd6dEhBL0lyNDFWVFZaemFOSGIz?=
 =?utf-8?B?b3FyZTRsUHVyOVp5OE56Z1F3Sll6WW54ckdybzBadUF6MXk1OVFKcUc5Z1J3?=
 =?utf-8?B?U3NOSDQzQXpLeUlzbXdnOVRKUGQ5VVowbDNSYkJ6YW5mNEpEU2ZGOFpITUhu?=
 =?utf-8?B?a3JJMFg3ZUdUR005NWN5OXhoZGJIWHZVSStVT1YvaG4zc1VGUFMyOUVvL0hI?=
 =?utf-8?B?K0FzQ2VvUWx4VFRSbDZsWkRHMG0rcnN6R010cjU0SUhpSHdldVhxMHFhb2NY?=
 =?utf-8?B?OHdtajNDbjJoaG5nRjljcGtCaUZRUE50cU52Skpyd2xId05heTNkWEZ3TnVN?=
 =?utf-8?B?RjVnRVQwYzBiTUZpZDlwdTdPdXhPdVZlSldHbGNlbHNTV0hYTm1EQkN1bUdx?=
 =?utf-8?B?dHhBWThEOWxJUXhJQmtYeHZIblRYMitIalk3ZHUvSnVlSzVRYkY3aTNvRE1r?=
 =?utf-8?B?V0pzUHNwRjRaZVJSakRwU1hJak5uUWg1WGpUd3A5Y3Z5RnJqSUtBMElQdE9O?=
 =?utf-8?B?Z2NuQzROSXR4S1QzcWNRQ1FyYVpFR3RTbjhyTFU3T2FnYStOTXpydWJZQ25w?=
 =?utf-8?B?T2xDVmRCMEFyQmUvbURDT1V2UmxtZjc0b3pDalJ1MTRVM09NUkpRNXlWRFgz?=
 =?utf-8?B?Wm5QM3FPMGNFMUZLTU5PYk9IT0NKMlMrZm9SOG5UMkxrMnRGL3laM0QxR2JH?=
 =?utf-8?B?SHFaOUxjQnhoRExvZUZFL2xTMDl4czJvbkNNOEdkVFNxN1dmVUd5TTJSUzNV?=
 =?utf-8?B?Uml5TzgrTTlHa3psK0YvSWQxRXZDM1Mzd3FNbGVNRGFHVWFoQ01VOU56Sm9q?=
 =?utf-8?B?VTBtZ0xrRXhsdTFGWUM3WnhDTUdtKzhoUkszNUpCN1dIYnFEdUdVUDlldFZ0?=
 =?utf-8?B?bzZkakdyWFhXQXRKMDVId2ZyYklETUVlamVKSmh4ZnA3cVI0dHN5S240N3pw?=
 =?utf-8?B?MlIrdk1kdTFzWDM0dkpFSHNBcnpKUC95SFcxWm13ZFRPc09UdzZycTdBdVhs?=
 =?utf-8?B?NFlBdWlnSEJEdC8zeGlvQ0RWYVlTWXptMTd0ekZPRVpCbE1wdnphdXZDemIz?=
 =?utf-8?B?M3pFK01FMjdtT3VCdzdwY29FREg4d2pPaHVNZTVXRS82a291QWxremgvRGtl?=
 =?utf-8?B?c2J5SjBaRzBoYmNoRVpOTmJsbkNER3BORjc1endsZkRXL2NGRklYeFVHNWdn?=
 =?utf-8?B?MzJJUk5Oak93cE9vYm5BVEtMZ0xhcld6aVJ4UXhXK2hOb3p0eG1FUmpQSjlH?=
 =?utf-8?B?b0V4emRSV3ovWFhDblZWaWg1Rmw2cUZRb1l1b3pFWlR2dGxyNWlvWjQvM0Iz?=
 =?utf-8?B?dnZWSWpqYTJvTjllL0oxRTFSRnVISmsvMWNtKzRuSWR3V00vM2RXTFFIcm9v?=
 =?utf-8?B?eGVaM0c1bmZDblZJMlR0QkY1a2hVT3duN0JOWUV0QjNuZ3I3VHFpMWJ5Umln?=
 =?utf-8?B?cXFHWXFCQXJtTkMxWWczNDFxRXJCZm9aT2RXSlJxOU92bXlxUCswZDBoWCtX?=
 =?utf-8?B?VWRlWnlwMklHN0JYeWJLQkVSVGZBYjd4ZEZGa1VaZmhWMys5cms0ZlJoaDBW?=
 =?utf-8?B?c1pmbUErMHA0alJJQzJ6a3lKOHhKZFRvYkdFYUpGOEhEQ25ySXZVNmNnVjE5?=
 =?utf-8?B?c3ZjN3M2ajhEMWZuY1dOdWo2RGVNdERRdHR1L0JRa2VONUZMVU9sRU5JZFlw?=
 =?utf-8?B?WUJBL05EOXR1QVZsL3JJK0ZaanUzdnlGZDZRaTcwajdaejk4TkxZOGpBRWZC?=
 =?utf-8?B?M3pvNGhRQlJ1NzU0K1JJSWMrVldadzhocEw1RUtEb2VFekM3WitZYVJlL3Z2?=
 =?utf-8?B?emtrM0ZVUVpFUUFVMTRkL2lQckM2M1ZBeWh4MExSQmUxUjU2QTY2YWRtRFVZ?=
 =?utf-8?B?bzdlUC9jclB5OHFWbjZUWFZlOGZ2YkYrTUZRL0ZtakJCQS9SWE5DbWNGWTFy?=
 =?utf-8?B?QmIwOUlYTWVnQTNNNEFXVGtPWEV4akU2NForM3VCY3JDa3FIQnkyaDZTRHJl?=
 =?utf-8?B?MlFvVnR2R3h0MGx6RWZJcG1HcnNVZGFsZUJLbVJsNUVwUHI5QXJNaE83UFl0?=
 =?utf-8?B?MFQ0aXBqR21LRHdLNnFhMHJhSW5nMzgxSVpnK1Z2TlJibmJac3hZdmE3eEh3?=
 =?utf-8?B?Mld2ZDEzM1ZzbmNNdldxRnQ4TCtCQW51cHF1SkJmZW9MOFlqaVNGeGN6ekdj?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?V0JaTGxOcXFvU3k4NytBalBTSjkzTHpseGQ0ZzdvOGxlV25sNzZpbFVNVi9Y?=
 =?utf-8?B?V2VwTnJpUXFMWEdXQ29hRisxUjIweXcxVTBCcysyeDhtOEQ5dzh1Q0VOamkx?=
 =?utf-8?B?T3VtUklPOXBYblcwMDFIdk5pYjNhd3pnTFpBUzdjYWxTOUF2UEVHU2VaQUt1?=
 =?utf-8?B?cmJ4NU9lMnlEV3dOeUpQWi9XczVaVVZ5ZnVSTmtKV3JwUFVwa2tMWTVVN0py?=
 =?utf-8?B?SWNJa3Y0NHVmeWhqRzJWTldoY05VRHZPak11U2J5N3V6VXVxa21aRUs1Yito?=
 =?utf-8?B?R1NWekZyL3pWcFB6ai9ZRTVtYWtzTUVvYWhhaWlHdnFFSHlMaWhSLzUveXlh?=
 =?utf-8?B?cW9mY254ZDkrdVNzcWQzUENWRXRrTzdKWjgyMVFIWHBHUU1leml2MzM5VlFZ?=
 =?utf-8?B?V2p0TTdpdzRORjZEQWdLV25WbkRlK2dvQmRBcWF6SUFhRUFnMXpobVpXSUg2?=
 =?utf-8?B?MitYa1RDQzAzcXpJT0NVZ2puazNhZWxCc25MOGE2eGY3QlQvQm83RWxQcHpI?=
 =?utf-8?B?YzRmWElxbkRwWWlKR3QvbmVEQk1IZ2o3dldvdW9na0hRWVIwREU2OUpRU3Y3?=
 =?utf-8?B?TkpKZkMrYnNBaldEanBkNDZtTnBPeUVhd0E0QWZTNTBqd1h3OTZFV3gvZEJv?=
 =?utf-8?B?MTAwdndHUDJDREdocUdSdGtRemJsY2RNMDFYQWtlVCthSEZFd29ERklqSUtZ?=
 =?utf-8?B?b0l2dVVsdTF4ZndjY3V0SG1OOVRsV2xwYlE0U1JCSm1xMVpOUnUwQzFQZ0wv?=
 =?utf-8?B?RU52bVpXU050Q2JaUEYzUkpXaHFpU2hZdVpCKzdyaWJwMEk3U3VXYTJ3U1VM?=
 =?utf-8?B?WnJNNk44WU5YODBHbDkzWmxjV2FnMCtkOGJJK0ZIVkc0bVpoODh4NENCS3Q1?=
 =?utf-8?B?dkdNK0ErRHdPU1ZTRVVVeWl1Mm80M3ZObFdLV215MG9hQXhIdG1zK3Jza3Ur?=
 =?utf-8?B?SkE2YXY0OFFRb0l6RU15NUR4ZDJEaVpMWlRwdHBmOFVBU09HUFBqZjc4ZEx0?=
 =?utf-8?B?WWphZCsrRVViemFseW1EZk01MDhkVit0dytWRDhjNUltK3NMQ0FscExGRTFm?=
 =?utf-8?B?cXlMZ0F1NGdnR1BXQXM5NDJhMmtDNFNqamFWQk5RU04rcjhLN3YrNzRINytS?=
 =?utf-8?B?YmpjdFJuU3RnanY5b2d4aXM2MWRzclkzMG9vejl4bmZUbWxnbzRmMzRNUkV0?=
 =?utf-8?B?VGJURFk5bHFKSHNQOXQwazRGcWM0ZHBTZUIyaEVWUFJHNlhYY05sTW01Yzdk?=
 =?utf-8?B?bWlhb2tTY1hHMVg1Q1ZWczRZeG9qb05Ka0JKUmwrZi9rUEg4Zz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 100ceb4f-ead3-422e-a45d-08db67337685
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:44:53.5073 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcUZYPJhUlbOjaoCqPw2FuG2t2ZjpY42mE/INCLsd0w2m7PdBdQpsHWkS6l0XTh4o47Jaw2wYA9bmrbbbkP4yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR03MB6262
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:46 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMDE6MzE6MjVQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIFR1ZSwgSnVuIDA2LCAyMDIzIGF0IDExOjE1OjM3QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBUdWUsIE1heSAzMCwgMjAyMyBhdCAwNDozMTox
NlBNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IFNldCAib3BlbmVkIiB0
byAiMCIgYmVmb3JlIHRoZSBob3RwbHVnIHNjcmlwdCBpcyBjYWxsZWQuICBPbmNlIHRoZQo+ID4g
PiBkZXZpY2Ugbm9kZSBoYXMgYmVlbiBvcGVuZWQsIHNldCAib3BlbmVkIiB0byAiMSIuCj4gPiA+
IAo+ID4gPiAib3BlbmVkIiBpcyB1c2VkIGV4Y2x1c2l2ZWx5IGJ5IHVzZXJzcGFjZS4gIEl0IHNl
cnZlcyB0d28gcHVycG9zZXM6Cj4gPiA+IAo+ID4gPiAxLiBJdCB0ZWxscyB1c2Vyc3BhY2UgdGhh
dCB0aGUgZGlza3NlcSBYZW5zdG9yZSBlbnRyeSBpcyBzdXBwb3J0ZWQuCj4gPiA+IAo+ID4gPiAy
LiBJdCB0ZWxscyB1c2Vyc3BhY2UgdGhhdCBpdCBjYW4gd2FpdCBmb3IgIm9wZW5lZCIgdG8gYmUg
c2V0IHRvIDEuCj4gPiA+ICAgIE9uY2UgIm9wZW5lZCIgaXMgMSwgYmxrYmFjayBoYXMgYSByZWZl
cmVuY2UgdG8gdGhlIGRldmljZSwgc28KPiA+ID4gICAgdXNlcnNwYWNlIGRvZXNuJ3QgbmVlZCB0
byBrZWVwIG9uZS4KPiA+ID4gCj4gPiA+IFRvZ2V0aGVyLCB0aGVzZSBjaGFuZ2VzIGFsbG93IHVz
ZXJzcGFjZSB0byB1c2UgYmxvY2sgZGV2aWNlcyB3aXRoCj4gPiA+IGRlbGV0ZS1vbi1jbG9zZSBi
ZWhhdmlvciwgc3VjaCBhcyBsb29wIGRldmljZXMgd2l0aCB0aGUgYXV0b2NsZWFyIGZsYWcKPiA+
ID4gc2V0IG9yIGRldmljZS1tYXBwZXIgZGV2aWNlcyB3aXRoIHRoZSBkZWZlcnJlZC1yZW1vdmUg
ZmxhZyBzZXQuCj4gPiAKPiA+IFRoZXJlIHdhcyBzb21lIHdvcmsgaW4gdGhlIHBhc3QgdG8gYWxs
b3cgcmVsb2FkaW5nIGJsa2JhY2sgYXMgYQo+ID4gbW9kdWxlLCBpdCdzIGNsZWFyIHRoYXQgdXNp
bmcgZGVsZXRlLW9uLWNsb3NlIHdvbid0IHdvcmsgaWYgYXR0ZW1wdGluZwo+ID4gdG8gcmVsb2Fk
IGJsa2JhY2suCj4gCj4gU2hvdWxkIGJsa2JhY2sgc3RvcCBpdHNlbGYgZnJvbSBiZWluZyB1bmxv
YWRlZCBpZiBkZWxldGUtb24tY2xvc2UgaXMgaW4KPiB1c2U/CgpIbSwgbWF5YmUuICBJIGd1ZXNz
IHRoYXQncyB0aGUgYmVzdCB3ZSBjYW4gZG8gcmlnaHQgbm93LgoKPiA+IElzbid0IHRoZXJlIHNv
bWUgZXhpc3Rpbmcgd2F5IHRvIGNoZWNrIHdoZXRoZXIgYSBkZXZpY2UgaXMgb3BlbmVkPwo+ID4g
KHN0YXQgc3lzY2FsbCBtYXliZT8pLgo+IAo+IEtub3dpbmcgdGhhdCB0aGUgZGV2aWNlIGhhcyBi
ZWVuIG9wZW5lZCBpc27igJl0IGVub3VnaC4gIFRoZSBibG9jayBzY3JpcHQKPiBuZWVkcyB0byBi
ZSBhYmxlIHRvIHdhaXQgZm9yIGJsa2JhY2sgKGFuZCBub3Qgc29tZXRoaW5nIGVsc2UpIHRvIG9w
ZW4KPiB0aGUgZGV2aWNlLiAgT3RoZXJ3aXNlIGl0IHdpbGwgYmUgY29uZnVzZWQgaWYgdGhlIGRl
dmljZSBpcyBvcGVuZWQgYnkKPiBlLmcuIHVkZXYuCgpVcmcsIG5vLCB0aGUgYmxvY2sgc2NyaXB0
IGNhbm5vdCB3YWl0IGluZGVmaW5pdGVseSBmb3IgYmxrYmFjayB0byBvcGVuCnRoZSBkZXZpY2Us
IGFzIGl0IGhhcyBhbiBleGVjdXRpb24gdGltZW91dC4gIGJsa2JhY2sgaXMgZnJlZSB0byBvbmx5
Cm9wZW4gdGhlIGRldmljZSB1cG9uIGd1ZXN0IGZyb250ZW5kIGNvbm5lY3Rpb24sIGFuZCB0aGF0
ICh3aGVuIHVzaW5nCmxpYnhsKSByZXF1aXJlcyB0aGUgaG90cGx1ZyBzY3JpcHRzIGV4ZWN1dGlv
biB0byBiZSBmaW5pc2hlZCBzbyB0aGUKZ3Vlc3QgY2FuIGJlIHN0YXJ0ZWQuCgo+ID4gSSB3b3Vs
ZCBsaWtlIHRvIGF2b2lkIGFkZGluZyBtb3JlIHhlbnN0b3JlIGJsa2JhY2sgc3RhdGUgaWYgc3Vj
aAo+ID4gaW5mb3JtYXRpb24gY2FuIGJlIGZldGNoZWQgZnJvbSBvdGhlciBtZXRob2RzLgo+IAo+
IEkgZG9u4oCZdCB0aGluayBpdCBjYW4gYmUsIHVubGVzcyB0aGUgaW5mb3JtYXRpb24gaXMgcGFz
c2VkIHZpYSBhCj4gY29tcGxldGVseSBkaWZmZXJlbnQgbWV0aG9kLiAgTWF5YmUgbmV0bGluayg3
KSBvciBpb2N0bCgyKT8gIEFyZ3VhYmx5Cj4gdGhpcyBpbmZvcm1hdGlvbiBzaG91bGQgbm90IGJl
IHN0b3JlZCBpbiBYZW5zdG9yZSBhdCBhbGwsIGFzIGl0IGV4cG9zZXMKPiBiYWNrZW5kIGltcGxl
bWVudGF0aW9uIGRldGFpbHMgdG8gdGhlIGZyb250ZW5kLgoKQ291bGQgeW91IG1heWJlIHVzZSBz
eXNmcyBmb3IgdGhpcyBpbmZvcm1hdGlvbj8KCldlIGhhdmUgYWxsIHNvcnRzIG9mIGNyYXAgaW4g
eGVuc3RvcmUsIGJ1dCBpdCB3b3VsZCBiZSBiZXN0IGlmIHdlIGNhbgpzZWUgb2YgcGxhY2luZyBz
dHVmZiBsaWtlIHRoaXMgaW4gYW5vdGhlciBpbnRlcmZhY2UuCgpUaGFua3MsIFJvZ2VyLgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

