Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E94C88CB4
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 12:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686658680;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xqW7oyTOCuFj2cy3syZf+3JqX68QAkmDKR0ialRldYA=;
	b=MMmP++WZGkCnInzfbnfQbl7CObafADp8hkPA1RZ+HMjr9oewEuVvnzq79OaXLc2g1tG+b9
	LzsnwQ+TVPswwkcypkTw8rHrYWjoTCkjzr6OC24Z40V83zZmy+lCwwM1M1fIeBPWu90hzd
	t9iwjC806n8hciTbTAcExXdVIqny0IM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-P5JeMmPQMQ2_fHyKqBYBwQ-1; Tue, 13 Jun 2023 08:17:57 -0400
X-MC-Unique: P5JeMmPQMQ2_fHyKqBYBwQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3BC185A5BB;
	Tue, 13 Jun 2023 12:17:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 60BA0492CA6;
	Tue, 13 Jun 2023 12:17:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2BA051946A42;
	Tue, 13 Jun 2023 12:17:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 04E73194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Jun 2023 08:09:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4F3B492C1B; Mon, 12 Jun 2023 08:09:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC955492C38
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 08:09:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE514101A53B
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 08:09:53 +0000 (UTC)
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com
 [216.71.155.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-yf-bDI3MMzGSx8UIPnqPfQ-1; Mon, 12 Jun 2023 04:09:51 -0400
X-MC-Unique: yf-bDI3MMzGSx8UIPnqPfQ-1
X-IronPort-RemoteIP: 104.47.74.48
X-IronPort-MID: 111751997
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:Bnkjx6wIzIrPA2DKsjh6t+d0xirEfRIJ4+MujC+fZmUNrF6WrkUCx
 mNNW2uOPvyDZzTzLdhyYIu/8k4HsceDyIVgTVBs/iAxQypGp/SeCIXCJC8cHc8wwu7rFxs7s
 ppEOrEsCOhuExcwcz/0auCJQUFUjP3OHfykTrafYEidfCc8IA85kxVvhuUltYBhhNm9Emult
 Mj75sbSIzdJ4RYtWo4vw/zF8EsHUMja4mtC5QRgPKoT5TcyqlFOZH4hDfDpR5fHatE88t6SH
 47r0Ly/92XFyBYhYvvNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ai87XAME0e0ZP4whlqvgqo
 Dl7WT5cfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQq2pYjqhljJBheAGEWxgp4KX4V8
 +YHNCkEVxrAoMynnImGZ9Ns1tt2eaEHPKtH0p1h5RfwKK56BLrlE+DN79Ie2yosjMdTG/qYf
 9AedTdkcBXHZVtIJ0sTD5U92uyvgxETcRUB8A7T+fVxvDSVkFwZPLvFabI5fvSQQspYhACAr
 3/u9GXlGBAKcteYzFJp91r137aQwHqqCd16+LuQyeZMjGyNyDwqVRRJeVKRsMC/qGWzVIcKQ
 6AT0m90xUQoz2SnQ9z8dxy+vn+fvxQYVsZQEus18wWEwOzf5APxLmEURDlMQN8rrsk7QXom1
 TehltzqLSZivL2cVTSW8bL8hSi0ODQHIHUqZiIeSwYBpd75r+kbgheKQtt9HaqdlND5GTjsh
 TuNqUAWgrwJiMcR2qaT/FbZgimtrJzEUg404ArMWmuvqAh+YeaNY42u9Eie5/JHJ4WxUFaMp
 j4HltKY4eRICouC/ASJQeMQDPSq6uyDPTn0n1FiBd8i+i6r9nrleppfiBluKUEsPssadDvBZ
 E7IpRgX9JJVJGGtb6J8f8S2EctC8ET7PdHsV/SRZNweZJF0LFOD5Hs2OR7W2H3xmk8xl615I
 Y2cbcunEXcdD+Jg0SayQOAel7Qsw0jS2F/ueHwy9Dz/uZL2WZJfYe1t3IemBgzh0J65nQ==
IronPort-HdrOrdr: A9a23:UBBpDaPo6PrRL8BcTjejsMiBIKoaSvp037BK7S1MoNJuEvBw9v
 re+sjzsCWftN9/Yh4dcLy7VpVoBEmsl6KdgrNhWotKPjOW21dARbsKheffKn/bakjDH4Zmvp
 uIGJIObOEYY2IasS77ijPIbOrJwrO8gd6VbTG19QYdceloAZsQnzuQEmygYzRLrJEtP+tFKH
 KbjPA33waISDAsQemQIGIKZOTHr82jruObXfZXbyRXkzVnlFmTmcTHLyQ=
X-Talos-CUID: 9a23:I5p+cGy0fFtgfcDh9MACBgULQcY/bWHExU7aYGiWGDpSdZCvSQ+PrfY=
X-Talos-MUID: =?us-ascii?q?9a23=3AV72ZJw8aP7Cr3jMR9yWnZYmQf/hwxaifFk5dqMg?=
 =?us-ascii?q?P5OWNHz1JPRW2gTviFw=3D=3D?=
X-IronPort-AV: E=Sophos;i="6.00,236,1681185600"; d="scan'208";a="111751997"
Received: from mail-bn8nam04lp2048.outbound.protection.outlook.com (HELO
 NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.48])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Jun 2023 04:09:48 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by SJ0PR03MB6327.namprd03.prod.outlook.com (2603:10b6:a03:399::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 08:09:46 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::3474:a81:a100:1529]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::3474:a81:a100:1529%6]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 08:09:45 +0000
Date: Mon, 12 Jun 2023 10:09:39 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZIbSw44a8Te27BP3@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
 <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
 <ZIA9uBJxx2gqA4Cq@Air-de-Roger> <ZICs+WYCPYdu2yoI@itl-email>
 <ZIGRXrSGmgLF/07O@Air-de-Roger> <ZIH0yQCICZRpliSc@itl-email>
 <ZINBqToBZVdfmr0e@Air-de-Roger> <ZINZj8ubQj7yFxdR@itl-email>
In-Reply-To: <ZINZj8ubQj7yFxdR@itl-email>
X-ClientProxiedBy: LO4P123CA0305.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::22) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|SJ0PR03MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ae785c-bbf3-438d-a45b-08db6b1c6253
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 73vCY+kgJLnSULPHQ3Ip/by0SO51Du2Lr/Wxwh3J1e7AA9gqFQ4xRQFQrWJHV9xToFkpAQc7YJAelOyvHX3Pumgo7TZWhzckcycFcXnT3HW+NQPvXGb5NRNUIxszPidrIOzZBYbfnxOXorM1gLmrndLlQ2SdPvhzu7lUlkaSSyvYQABjjFA+x8SEyYDvXTBPV4VQwzVNoBuxunlF/sQUnzBmuVL6bckILLSw2wuMrpvVJejw5azwkVCKBG9AyqBwfyII1K9d6BGQxkYxAzwDikEqFMWW6rpo1f5g4RFcA1/zbhIIJFZ2CvEYmbKrU24xT1GLqHU2/+WKXqr4aqcszhvCvzKYAVcFOIcsMTS0jKtbQyIvXP0Tt7Rydi+INcirgjyUM53KYB0iTEcFCKbtb6sydWCpRrZb7s1wN4gjYisHw95QKTNGFrx14gvvpmgN00zLmJm2fO/eAv+XTqLdTtFLDUgBDSD/OJQfsZ01apHIAfB62026O+wAIRBcJRsiDQtU84lNUxQhKWgx/06GCeQi4xwmpVkkpnzNAG8N+cjg7aEwCDPXSSZK/I4ZvqFL
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(7916004)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(86362001)(6486002)(316002)(8676002)(33716001)(41300700001)(82960400001)(83380400001)(5660300002)(26005)(38100700002)(85182001)(6512007)(9686003)(6506007)(6666004)(8936002)(66476007)(66556008)(4326008)(66946007)(6916009)(478600001)(186003)(2906002)(54906003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWVkU3FEeGFramQxZWZHZkdJSkFzT1kwNTk0U2FKdGUvazRHNmY0NW5LZ1No?=
 =?utf-8?B?dHJiQU1FdUxqRkwzR2pWVDNBbkw5aUp1eU5ZYm9LSmZxc05iQkVFRU5IdmJD?=
 =?utf-8?B?dUswU2YwaHYzRkl5aEx1VWszeUtGSjY1cFlRZmRlRmZRTXZpOVhabXltcnBa?=
 =?utf-8?B?SkFxbjAyTEJjSlMrTHRNRHlZdkMwU2hLWERleFJpWnFBTzNzUHlwSHNlbnNx?=
 =?utf-8?B?Q2hzMEdEQnppcEJTdjd6dG1iZTBaQ3ptR3NKbkpReTk1ZytzN3ZMZHoyR1F5?=
 =?utf-8?B?YVRpL2tSZ0l0QnVwMjVxUGtCeHNBL2hIWWhjelFBcFF5MUxMVGxkbjBnbVQx?=
 =?utf-8?B?QkFCZE1NWVlLTVlZbmJjZENkaktxVW0vZjU3RzliRkhPU3hUUGs4SmJyZVRQ?=
 =?utf-8?B?MWdQL1BaeXBkWkJ2VmlHQU9UUTVOb1BlbXNlampXcjQxclExMUNwZVNFaG00?=
 =?utf-8?B?bHlWL0RETmxtYmpwRDAvc0tTOUh2Z2xPVWNkS2V3dWhsOHZ3dmJ3OUZqazVE?=
 =?utf-8?B?ZW1lNStYaGRRQjJrZHpBdktmSEI3Tjg3VEtSV2VBcU1BTGNFNkRSSS8rT215?=
 =?utf-8?B?eHNueGQycEpOcDBJcmRjM3dNWjNheXpuaXQyRWxWSDdRV09lWTE2UHdSTUov?=
 =?utf-8?B?aXpzZXFEWHdPaFpXMm9ZdlRSTDlKS1k5M2Y5K1NMQlR0U3FXY3N2NVM1Sjhj?=
 =?utf-8?B?SjVVUmY2ZlQ3Z2pha1dVSlJmVy92dlVFdTNJNGI0NjNYZXE2MnFoNHF6RUxv?=
 =?utf-8?B?RG45SGRKWDZBQTA3TjVqVVo4Sy8vdVpWSm8xRXFuMjIxbzkxZmRGNUdaSzhu?=
 =?utf-8?B?UHdFU2lyK0ViRUZUc0k0b01pQWh3eTE0R1RRNzlXVTI2S2RwUjhNRnZVR3No?=
 =?utf-8?B?WXo3dm9YUjJNdDZDaExrVVovYk5XektrSmw2SDRTbEpYaVlwaWI4OU94bkpB?=
 =?utf-8?B?b28rcGhKN09vQm4wRVVJSnh2czNUczVEUXZuZ2E5VWl2NlU2emMzZWRvRGly?=
 =?utf-8?B?M0ZNc0cxUzg4U3ZLUVJIZ2FVSVJic1NVOEtSdGgrazNqTXZiYWQxdDVVbFQ5?=
 =?utf-8?B?L3pXQTUvelRQOFFHMnMxbVpuUFoyOU85Rkc0R2xEblhpYk40SWRIdzNRZ0ZF?=
 =?utf-8?B?VGl2Z01vWE5RMU1haDdwckhESW5DS0xETHNyNzVNaVJaNHNXMGJRdGtmU09i?=
 =?utf-8?B?SFhSTUV4VEMxdXExZHNyODJJQ29RNVZkRFVUbFYreXNSck9xRlhIM1htaXg4?=
 =?utf-8?B?clVvVXp1MUpUMklXL3NsZkVtWWtTckNRWnFiY0dGWnFLaHZBZm9va2RxT0cz?=
 =?utf-8?B?elcveXBrR1FIU3k1d3MyS2praStidlFmdm9JQm9pYVlOZEtIR1Z3TDJ2d2Iz?=
 =?utf-8?B?SmNoUkw5MVdXdGNNU2RPRTdEV21JL0Q4SVBYQ21Mcmp1VUVLMFk5SmJ3bGRF?=
 =?utf-8?B?OTFQK1FTbWJNNWxXdHRmdW9QWkxQYlp4S0g4bVh5UWJscGlJc3FwZytwQ3hj?=
 =?utf-8?B?aWI3anR0ejR3bERyc1hnTXdZbDlEUThjR2pialVRM2VrNnphOHFjYklwM05w?=
 =?utf-8?B?L3hDQ21GbS9qTDdxS2FhNzV0b1IwbEZmQVc1RlBPQ3V4VzVDdjRWVXphelNT?=
 =?utf-8?B?b3NBRDhaYUJzUkZraDkvcFZndVF0V3g2eUM1cXZLWlAxNko0M041V3JxUzIv?=
 =?utf-8?B?TDI5aHlCNVUwRnByaTFVOGs3SzgxaFJyUTNUQUEyMEttZzcxc1RCT3dMR1I1?=
 =?utf-8?B?ZnUvSk4xdUo3ZlB1YTFzTnR5bHQxMGVOSnNVWThoaW91L2NqQW9tZnNTWlEr?=
 =?utf-8?B?bWtkN2FmRzljRFpjQ2I4U0ZiRmJ2c3FyV05iTjk1MUwrY2Q5UWJYU1gvU0Ni?=
 =?utf-8?B?WCszVFVPVis5U1BkZFFGNThzK0JiQmovQjR5dmh0VzBZNXk1OXd1Mytudmx6?=
 =?utf-8?B?bFFvQUtiQURPVllxYmVZaGovak5EQ2lobFBVOWZhckZveHV1UlVqajJXNW1r?=
 =?utf-8?B?OTlMUlBsRTJOdGFyWnRCS2ZnSWR5QkdEeElIQ2JrNUJmekZoVVJCanZrYWI4?=
 =?utf-8?B?UWozU2ZXZzA5V21ZSk1pY0pXdnh1dVNSb0liNFhJQzZyaTRMS2gxblF4Vi8y?=
 =?utf-8?Q?/db9FsSJqxFD95oa2xYErsmKA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aS9helZMUkd1L1BpOEFGYnZoYUpVTHN3bFhGOWZsVWt5RCtWdEI1WEZGZ2dV?=
 =?utf-8?B?QXJxNkEyN05Jd0p5S3c5U3RYbDZDNnNVK2hIbWVrTHN2QmEyQ0lHTDZ4aFpX?=
 =?utf-8?B?cnJkN01iNFlsTzNLZmZ0NkF3UDBCN25PdzhJWTloL0tPaHNEekt4cXlUVDdX?=
 =?utf-8?B?aGd5cENNZVNlbXlxbWVFQytBclBiSFNvWTFXUmlEUE03dTBTOHJTdzdMbmNZ?=
 =?utf-8?B?MUpyMi92VmNabWRsWWlOMFY2M0ROR1E5c0lZQ2tEWDRONVhFZkZLZmpjNUVI?=
 =?utf-8?B?ZUFURTExWFRNQkczTmxwSXRoZURlYXdsRTZtRnI0VzhvalZ5RjRCTks2ZFRW?=
 =?utf-8?B?cXBHcFRMWTZNOGh1WEtLdGI3Y1VQNU9IYTVySnY1VWtMT1lQTGh6dzlQVkRK?=
 =?utf-8?B?bUpYYVJyaDY0SVRuS3lkNGgzMCsweldYZ2hsZDBxWGRpWUh3Zkx5RExCRkd3?=
 =?utf-8?B?TFJlQndDdEZ0ZGUxUStYd1BqVnJ1ZlpTTEdBYmNYU3J2bkRMa0xEQlNPUlRE?=
 =?utf-8?B?WVFSZTQxQTE2WE5aNnBBMkRORXJ6NFArcTFVSUw3dGtZSjVxVkFqTjRkbnpT?=
 =?utf-8?B?QVpVUTRTTmpnbjBQR3pzT1Y0RURRQWZFclROb0hCeGVkOVRmdms3UkNLenp4?=
 =?utf-8?B?WTdvZHZ5dDJtMjE2VVRRWjh5SjNzSFgrTnUzbXRMTmhOSUVTM2J2bE9nc1pw?=
 =?utf-8?B?Z0d2QUkwdUx5bVBjL0EzQ1R2ODZoU1BrM1Vtdm02dWduRW11N0daZGpOaUZE?=
 =?utf-8?B?NHpVR1piYjFHbzNYN0ZQOTJ0ZlVmWTlsU205a0NRZ3BwbllJTjZCWHIwTjVv?=
 =?utf-8?B?Rzh4enF1dFNUNlFrczduWFVqNys5WGI2dklmT1B3WnIySzN6cnY2T2ovVjlG?=
 =?utf-8?B?c2hPcXhFeWQ3Z2NUUGNObWI4N1NVVGk2MVIzMG9kVzdWMUxBcWNlOEs5SnE3?=
 =?utf-8?B?ZTRXcGFUQnMxTm8vOWlSNXNpazc2TGtpTC9qSEZhaFpxMTZLSVg0QU12L09p?=
 =?utf-8?B?QmFrbkFDc1FGOGFPeTlyV0hGNFVmT3lydXJXN25TSUR3SUxKaUxYeG5wVlVB?=
 =?utf-8?B?U1FBWWZSSWV3bjhlcUJuNzNNOEhsY0J5R2hZZjNGdXQ0MldlZk11aVlYVnBG?=
 =?utf-8?B?TVR5Q3hoODFheUFaQW12YmphdzFRSmVwdzFOYlJVRGFZMGxiQ3ZRZjkwSCtM?=
 =?utf-8?B?clNzbUZHSjBwUlJTTnkraXZEOUdOYkZvb1Jvd2ZhSnR5dmRrMlF4VEhJZjNP?=
 =?utf-8?B?UUN2cXhUbm5KQlRqYlFzUE5uaDNEMEQzWHl3a284MTk5SmVZQT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ae785c-bbf3-438d-a45b-08db6b1c6253
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 08:09:45.8273 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGNvJOed2Ea3bOGcbPHjCYhswakBYpanlFDGxULTuALBdXegRFp5zY0XEv9nr8uJXomlhRA1lvz15CH+G7dksg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB6327
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 13 Jun 2023 12:17:46 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdW4gMDksIDIwMjMgYXQgMTI6NTU6MzlQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIEZyaSwgSnVuIDA5LCAyMDIzIGF0IDA1OjEzOjQ1UE0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBUaHUsIEp1biAwOCwgMjAyMyBhdCAxMTozMzoy
NkFNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IE9uIFRodSwgSnVuIDA4
LCAyMDIzIGF0IDEwOjI5OjE4QU0gKzAyMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiA+
ID4gT24gV2VkLCBKdW4gMDcsIDIwMjMgYXQgMTI6MTQ6NDZQTSAtMDQwMCwgRGVtaSBNYXJpZSBP
YmVub3VyIHdyb3RlOgo+ID4gPiA+ID4gT24gV2VkLCBKdW4gMDcsIDIwMjMgYXQgMTA6MjA6MDhB
TSArMDIwMCwgUm9nZXIgUGF1IE1vbm7DqSB3cm90ZToKPiA+ID4gPiA+ID4gQ2FuIHlvdSBmZXRj
aCBhIGRpc2sgdXNpbmcgYSBkaXNrc2VxIGlkZW50aWZpZXI/Cj4gPiA+ID4gPiAKPiA+ID4gPiA+
IE5vdCB5ZXQsIGFsdGhvdWdoIEkgaGF2ZSBjb25zaWRlcmVkIGFkZGluZyB0aGlzIGFiaWxpdHku
ICBJdCB3b3VsZCBiZQo+ID4gPiA+ID4gb25lIHN0ZXAgdG93YXJkcyBhIOKAnGRpc2tzZXFmc+KA
nSB0aGF0IHVzZXJzcGFjZSBjb3VsZCB1c2UgdG8gb3BlbiBhIGRldmljZQo+ID4gPiA+ID4gYnkg
ZGlza3NlcS4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBXaHkgSSB1bmRlcnN0YW5kIHRoYXQgdGhp
cyBpcyBhbiBleHRyYSBzYWZldHkgY2hlY2sgaW4gb3JkZXIgdG8gYXNzZXJ0Cj4gPiA+ID4gPiA+
IGJsa2JhY2sgaXMgb3BlbmluZyB0aGUgaW50ZW5kZWQgZGV2aWNlLCBpcyB0aGlzIGF0dGVtcHRp
bmcgdG8gZml4IHNvbWUKPiA+ID4gPiA+ID4gZXhpc3RpbmcgaXNzdWU/Cj4gPiA+ID4gPiAKPiA+
ID4gPiA+IFllcywgaXQgaXMuICBJIGhhdmUgYSBibG9jayBzY3JpcHQgKHdyaXR0ZW4gaW4gQykg
dGhhdCB2YWxpZGF0ZXMgdGhlCj4gPiA+ID4gPiBkZXZpY2UgaXQgaGFzIG9wZW5lZCBiZWZvcmUg
cGFzc2luZyB0aGUgaW5mb3JtYXRpb24gdG8gYmxrYmFjay4gIEl0IHVzZXMKPiA+ID4gPiA+IHRo
ZSBkaXNrc2VxIHRvIGRvIHRoaXMsIGJ1dCBmb3IgdGhhdCBwcm90ZWN0aW9uIHRvIGJlIGNvbXBs
ZXRlLCBibGtiYWNrCj4gPiA+ID4gPiBtdXN0IGFsc28gYmUgYXdhcmUgb2YgaXQuCj4gPiA+ID4g
Cj4gPiA+ID4gQnV0IGlmIHlvdXIgYmxvY2sgc2NyaXB0IG9wZW5zIHRoZSBkZXZpY2UsIGFuZCBr
ZWVwcyBpdCBvcGVuIHVudGlsCj4gPiA+ID4gYmxrYmFjayBoYXMgYWxzbyB0YWtlbiBhIHJlZmVy
ZW5jZSB0byBpdCwgdGhlcmUncyBubyB3YXkgc3VjaCBkZXZpY2UKPiA+ID4gPiBjb3VsZCBiZSBy
ZW1vdmVkIGFuZCByZWNyZWF0ZWQgaW4gdGhlIHdpbmRvdyB5b3UgcG9pbnQgb3V0IGFib3ZlLCBh
cwo+ID4gPiA+IHRoZXJlJ3MgYWx3YXlzIGEgcmVmZXJlbmNlIG9uIGl0IHRha2VuPwo+ID4gPiAK
PiA+ID4gVGhpcyBhc3N1bWVzIHRoYXQgdGhlIGJsb2NrIHNjcmlwdCBpcyBub3Qga2lsbGVkIGlu
IHRoZSBtZWFudGltZSwKPiA+ID4gd2hpY2ggaXMgbm90IGEgc2FmZSBhc3N1bXB0aW9uIGR1ZSB0
byB0aW1lb3V0cyBhbmQgdGhlIE9PTSBraWxsZXIuCj4gPiAKPiA+IERvZXNuJ3Qgc2VlbSB2ZXJ5
IHJlbGlhYmxlIHRvIHVzZSB3aXRoIGRlbGV0ZS1vbi1jbG9zZSBlaXRoZXIgdGhlbi4KPiAKPiBU
aGF04oCZcyBhY3R1YWxseSB0aGUgcHVycG9zZSBvZiBkZWxldGUtb24tY2xvc2UhICBJdCBlbnN1
cmVzIHRoYXQgaWYgdGhlCj4gYmxvY2sgc2NyaXB0IGdldHMga2lsbGVkLCB0aGUgZGV2aWNlIGlz
IGF1dG9tYXRpY2FsbHkgY2xlYW5lZCB1cC4KCkJsb2NrIHNjcmlwdCBhdHRhY2ggZ2V0dGluZyBr
aWxsZWQgc2hvdWxkbid0IHByZXZlbnQgdGhlIHRvb2xzdGFjawpmcm9tIHBlcmZvcm1pbmcgZG9t
YWluIGRlc3RydWN0aW9uLCBhbmQgdGh1cyByZW1vdmluZyB0aGUgc3RhbGUgYmxvY2sKZGV2aWNl
LgoKT1RPSCBpZiB5b3VyIHRvb2xzdGFjayBnZXRzIGtpbGxlZCB0aGVuIHRoZXJlJ3Mgbm90IG11
Y2ggdGhhdCBjYW4gYmUKZG9uZSwgYW5kIHRoZSBzeXN0ZW0gd2lsbCBuZWVkIGludGVydmVudGlv
biBpbiBvcmRlciB0byBnZXQgYmFjayBpbnRvCmEgc2FuZSBzdGF0ZS4KCkhpdHRpbmcgT09NIGlu
IHlvdXIgY29udHJvbCBkb21haW4gaG93ZXZlciBpcyB1bmxpa2VseSB0byBiZSBoYW5kbGVkCmdy
YWNlZnVsbHksIGV2ZW4gd2l0aCBkZWxldGUtb24tY2xvc2UuCgo+ID4gPiA+IFRoZW4gdGhlIGJs
b2NrIHNjcmlwdCB3aWxsIG9wZW4gdGhlIGRldmljZSBieSBkaXNrc2VxIGFuZCBwYXNzIHRoZQo+
ID4gPiA+IG1ham9yOm1pbm9yIG51bWJlcnMgdG8gYmxrYmFjay4KPiA+ID4gCj4gPiA+IEFsdGVy
bmF0aXZlbHksIHRoZSB0b29sc3RhY2sgY291bGQgd3JpdGUgYm90aCB0aGUgZGlza3NlcSBhbmQK
PiA+ID4gbWFqb3I6bWlub3IgbnVtYmVycyBhbmQgYmUgY29uZmlkZW50IHRoYXQgaXQgaXMgcmVm
ZXJyaW5nIHRvIHRoZQo+ID4gPiBjb3JyZWN0IGRldmljZSwgbm8gbWF0dGVyIGhvdyBsb25nIGFn
byBpdCBnb3QgdGhhdCBpbmZvcm1hdGlvbi4KPiA+ID4gVGhpcyBjb3VsZCBiZSBxdWl0ZSB1c2Vm
dWwgZm9yIGUuZy4gb25lIFZNIGV4cG9ydGluZyBhIGRldmljZSB0bwo+ID4gPiBhbm90aGVyIFZN
IGJ5IGNhbGxpbmcgbG9zZXR1cCg4KSBhbmQgZXhwZWN0aW5nIGEgaHVtYW4gdG8gbWFrZSBhCj4g
PiA+IGRlY2lzaW9uIGJhc2VkIG9uIHZhcmlvdXMgcHJvcGVydGllcyBhYm91dCB0aGUgZGV2aWNl
LiAgSW4gdGhpcwo+ID4gPiBjYXNlIHRoZXJlIGlzIG5vIHVwcGVyIGJvdW5kIG9uIHRoZSByYWNl
IHdpbmRvdy4KPiA+IAo+ID4gSW5zdGVhZCBvZiBwbGF5aW5nIHdpdGggeGVuc3RvcmUgbm9kZXMs
IGl0IG1pZ2h0IGJlIGJldHRlciB0byBzaW1wbHkKPiA+IGhhdmUgYmxrYmFjayBleHBvcnQgb24g
c3lzZnMgdGhlIGRpc2tzZXEgb2YgdGhlIG9wZW5lZCBkZXZpY2UsIGFuZCBsZXQKPiA+IHRoZSBi
bG9jayBzY3JpcHQgY2hlY2sgd2hldGhlciB0aGF0J3MgY29ycmVjdCBvciBub3QuICBUaGF0IGlt
cGxpZXMKPiA+IGxlc3MgY29kZSBpbiB0aGUga2VybmVsIHNpZGUsIGFuZCBkb2Vzbid0IHBvbGx1
dGUgeGVuc3RvcmUuCj4gCj4gVGhpcyB3b3VsZCByZXF1aXJlIHRoYXQgYmxrYmFjayBkZWxheSBl
eHBvc2luZyB0aGUgZGV2aWNlIHRvIHRoZQo+IGZyb250ZW5kIHVudGlsIHRoZSBibG9jayBzY3Jp
cHQgaGFzIGNoZWNrZWQgdGhhdCB0aGUgZGlza3NlcSBpcyBjb3JyZWN0LgoKVGhpcyBkZXBlbmRz
IG9uIHlvdXIgdG9vbHN0YWNrIGltcGxlbWVudGF0aW9uLiAgbGlieGwgd29uJ3Qgc3RhcnQgdGhl
CmRvbWFpbiB1bnRpbCBibG9jayBzY3JpcHRzIGhhdmUgZmluaXNoZWQgZXhlY3V0aW9uLCBhbmQg
aGVuY2UgdGhlCmJsb2NrIHNjcmlwdCB3YWl0aW5nIGZvciB0aGUgc3lzZnMgbm9kZSB0byBhcHBl
YXIgYW5kIGNoZWNrIGl0IGFnYWluc3QKdGhlIGV4cGVjdGVkIHZhbHVlIHdvdWxkIGJlIGVub3Vn
aC4KCj4gTXVjaCBzaW1wbGVyIGZvciB0aGUgYmxvY2sgc2NyaXB0IHRvIHByb3ZpZGUgdGhlIGRp
c2tzZXEgaW4geGVuc3RvcmUuCj4gSWYgeW91IHdhbnQgdG8gYXZvaWQgYW4gZXh0cmEgeGVuc3Rv
cmUgbm9kZSwgSSBjYW4gbWFrZSB0aGUgZGlza3NlcSBwYXJ0Cj4gb2YgdGhlIHBoeXNpY2FsLWRl
dmljZSBub2RlLgoKSSdtIHRoaW5raW5nIHRoYXQgd2UgbWlnaHQgd2FudCB0byBpbnRyb2R1Y2Ug
YSAicGh5c2ljYWwtZGV2aWNlLXV1aWQiCm5vZGUgYW5kIHVzZSB0aGF0IHRvIHByb3ZpZGUgdGhl
IGRpc2tzZXEgdG8gdGhlIGJhY2tlbmVkLiAgVG9vbHN0YWNrcwoob3IgYmxvY2sgc2NyaXB0cykg
d291bGQgbmVlZCB0byBiZSBzdXJlIHRoZSAicGh5c2ljYWwtZGV2aWNlLXV1aWQiCm5vZGUgaXMg
cG9wdWxhdGVkIGJlZm9yZSBzZXR0aW5nICJwaHlzaWNhbC1kZXZpY2UiLCBhcyB3cml0ZXMgdG8K
dGhhdCBub2RlIHdvdWxkIHN0aWxsIHRyaWdnZXIgYmxrYmFjayB3YXRjaC4gIEkgdGhpbmsgdXNp
bmcgdHdvCmRpc3RpbmN0IHdhdGNoZXMgd291bGQganVzdCBtYWtlIHRoZSBsb2dpYyBpbiBibGti
YWNrIHRvbwpjb21wbGljYXRlZC4KCk15IHByZWZlcmVuY2Ugd291bGQgYmUgZm9yIHRoZSBrZXJu
ZWwgdG8gaGF2ZSBhIGZ1bmN0aW9uIGZvciBvcGVuaW5nIGEKZGV2aWNlIGlkZW50aWZpZWQgYnkg
YSBkaXNrc2VxIChhcyBmZXRjaGVkIGZyb20KInBoeXNpY2FsLWRldmljZS11dWlkIiksIHNvIHRo
YXQgd2UgZG9uJ3QgaGF2ZSB0byBvcGVuIHVzaW5nCm1ham9yOm1pbm9yIGFuZCB0aGVuIGNoZWNr
IHRoZSBkaXNrc2VxLgoKVGhhbmtzLCBSb2dlci4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwK

