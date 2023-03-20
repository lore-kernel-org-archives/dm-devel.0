Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51964C6FD1D
	for <dm-devel@archiver.kernel.org>; Tue, 21 Mar 2023 07:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679385260;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wPQMkuAC47q8GEzT8Zts2dhaMJCfyUkTxuNmrJATvqw=;
	b=P8OfHMfmE5egO+u3ZShQwQBybtAE6zFApa3ol/9+lMCFtfC4DK8p85urtmPIBb7gv20ERu
	gHi6sGS4adSYpvqRQioKJmC3W0eYbiCbQ3C0HNQnZfhL751+VgTrVK++H4XK+bFBoL64Wm
	B4bODNLDs/Fk38FGBRZ2vxFJg8TjxMI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-J7ji8md7NT22fmCDa0QB3g-1; Tue, 21 Mar 2023 03:54:16 -0400
X-MC-Unique: J7ji8md7NT22fmCDa0QB3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E2E33C218A7;
	Tue, 21 Mar 2023 07:54:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E062785768;
	Tue, 21 Mar 2023 07:54:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6A5F19465A2;
	Tue, 21 Mar 2023 07:54:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9FEC11946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 16:39:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 83A0D40C6E69; Mon, 20 Mar 2023 16:39:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B1B640C6E68
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 16:39:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 579161C02D28
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 16:39:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-U41eAR5nOeWUptmNr2I-3w-1; Mon, 20 Mar 2023 12:39:38 -0400
X-MC-Unique: U41eAR5nOeWUptmNr2I-3w-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32KFxEx2018351; Mon, 20 Mar 2023 16:39:20 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd56auv30-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 20 Mar 2023 16:39:20 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32KFDnQH037002; Mon, 20 Mar 2023 16:39:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3peg5njdk0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 20 Mar 2023 16:39:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 16:39:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:39:15 +0000
Message-ID: <ed8afac2-af41-dd0e-16d0-b0253d1a5528@oracle.com>
Date: Mon, 20 Mar 2023 11:39:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Christoph Hellwig <hch@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
 <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
 <6da0ec0a-d465-fec4-0ca5-96b2ffb7be7a@oracle.com>
 <20230320130625.GA11908@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230320130625.GA11908@lst.de>
X-ClientProxiedBy: DM6PR02CA0166.namprd02.prod.outlook.com
 (2603:10b6:5:332::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4662:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a8e5a2-5af8-4aa5-9df4-08db2961a4d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: /YixQ9am8jG7ueubP8Ej2fJrbf/eywD/eAQaxsSy6BV10WjTRmXAHxe5mFDG0qk1qcuYt2uEZBrmhIbPCJa/eACo8x+DmmnTcwFtTKM/oybdLIz493/l8gRtHEuvgJkuT88reMAZj8dLncG4A2R8o5M7ykNvoiMdMPirUTK2T+uBnw3Awbw61KngvHdKzdLBVSSouet4uQc+n3kr9w4bQA6EgrJJeDzp/CWEvA5UEa0btPuKHKdzHctmG0x/mq/6Gt9YWDMBxRAlNZJiGmA7p9OxFybTIit0qk1TSMFaOA4vYxBcV0FS3ZzUXGSDCUpn8FeMuK6TdBUku8s7O9LThKtG7VUhEuzQbQuTSXO5MvhaS4Fv1q0wgWuVMLMhxK27XrdiNOi7/WkrNbIsoTSkXOsRt1blkQyT9clNDb1M7KwctvmaxzjCb4loan5DQrld1oY12z8WrnCMKH8NyuNQiRCJv9zxmkqFw5703OzSoFIUctrJVhPAdaK26UFMWMLAxfgtYIAf9Rl+FK/vuGVz2zAhkO9oY8697+bnPPxExJn6+m9+9RYVuonCRC99Wlq6vZ1X1It6tlB6l9DV3OHaePTs/EfrndiFvr8vnFq+FKsPyZ2fBhuIVVwOHCnelZTkrZ/0bEv+qL8EsO1UniB7lll+vgiprWbpROh9s6rP4Lv6H0xhsOpDdLW1DwuAzo3uTIK+FwJBOtk+HwxLT5dhyGL0RlNFxw4W0Z9VfOQ5yY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(54906003)(316002)(31696002)(86362001)(6486002)(83380400001)(2616005)(38100700002)(478600001)(36756003)(53546011)(26005)(186003)(6506007)(6512007)(4744005)(2906002)(8936002)(31686004)(41300700001)(5660300002)(7416002)(8676002)(66476007)(4326008)(66556008)(66946007)(6916009)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REtCbWhyQUtDUnVIeHB0cUdXT0NIeDlhc0VZZW5GS3MyK3NFcGxsdXRtNy9J?=
 =?utf-8?B?OW05cXcwb3RYMkdmSldaSXE2TUxmeXNxTGVLWVNLYWNscnBBcUxwdk5BWU5k?=
 =?utf-8?B?ZmZqQXV4aG1KY0lmWnVuSUw4dTlVWDYySWVkckNoNkR5bnN5TVBUUnp2eW54?=
 =?utf-8?B?YTNuSzBJdytiVHMyUHpoYUsreURhM3VETG0xTTFsQkUzb1JWVHl5dE05TmR2?=
 =?utf-8?B?dkdLb1hoeWQ3THEwWXZKWThhT051aHlJYW1WZEFyMGNaZ0hNMTF0VFBMeEtl?=
 =?utf-8?B?VlFGUnoyVjhMLzlDSk0wNzJPWUNSMnRmS1BWM2ltYXFaaTA5SWJ2SkNhNWo2?=
 =?utf-8?B?ZEVLa0N5dVZUK2NZK2o2ZERadXp0cTYyMkpBNG5YQTBzMmFaZ1VMdFhqbUNy?=
 =?utf-8?B?aTJiNGFnam1hbkVVRENzTTRmdlVBdC9heXVYbm5uU1JMRmNzWGRUVG5SVkF0?=
 =?utf-8?B?Zm1xeENnVitHWG44UXk3L3ZGcmxuOE1NeG9vZVc3RFdFcmZBZ1FRTHZlMkhE?=
 =?utf-8?B?YXltSzNLZ3NFeWtFTCtyTXFvNDR4dnJZQTdSRHdYRXQ4bFc5WkZTajNpd0pH?=
 =?utf-8?B?RXdJa0lNcmhIdmlORmFUZStzdzluN1BkRk5wZ3d2N1didDFJT1JrUWlNbE5y?=
 =?utf-8?B?TmJuY1lKVjN5R3NPcmh2WmlRTkIxQXlWTWltN3dNWlNITUNYRE01aWs4bXZ5?=
 =?utf-8?B?dm5HS0R4V29XcEMrZWFIa3JlaXFpNUlQbXdiZm1Yay9BaHFuQXh4cnA4bzRr?=
 =?utf-8?B?Q1BwSEpPQXpabi9LcUx6Zm5aSVNqaTBYcjc5WTJZbkQ3eEtkdHFlaFpBR0Jy?=
 =?utf-8?B?Z3krdFh0M2RMaU4yMjJscmJYV3A0Y1RZYTdsdmpoQ1haMUpCcGpMQkQvVVln?=
 =?utf-8?B?Ty94VGhOR0g4NGJZODJCaXVlZW8rSU5DY09qcGxCbzR5d0k4eEtWVkE2OUpT?=
 =?utf-8?B?UzJHQjMxMGFWc01iQjArblV5WEg1Yks4NDVPSmFYSE9ET092MWtyWW9XcGhW?=
 =?utf-8?B?cnRFbDQ1TWF5ZTRQV2JjdHlVMXQ0RGs0M0FLWFlCOHU0VnlOWEMyT3hZTEFT?=
 =?utf-8?B?YWVmdWxTNEllMHJ2cytUTWFILy9odXI3VlRiaWxBbmJhVkZSajlGU2tJb1pS?=
 =?utf-8?B?UE94ZXJFWjZ2OXIxVjVMQnB0aHNJbUtaSmlNbUJUVFZDaGZIQ2hDdGNCVjRT?=
 =?utf-8?B?UlRxTjU1TFhYU1pVYVIwUzkrVWhYenZ5NmVmUi9La2t0bytlMUpDRmJnMlQ4?=
 =?utf-8?B?bW9rTExjVUhlaXBFS2hURzhaUEwrTC94R2I4RGVSeGFtbXVCZE9Rd2MvelNP?=
 =?utf-8?B?TXdlZFlTUmJHWnFneW5uaU0welVGZ0xGaGUva3hmS21halJCMFlDZjlndXpS?=
 =?utf-8?B?eUw1bTBSQ2lnVThrbExkQVNpSmhqemtaeVJIR3BQLy9CSFMyMWpTa0RGaDM5?=
 =?utf-8?B?MzhwUmZuWVdtKy8xR2lUanJiNEdnWkwrRDdrbnNpTDMwUFV3d2NwZGloUTFP?=
 =?utf-8?B?YXErMXE2SEtkUWtyQ3pvVXF4NUxyQUE2My8zeHdnRDhDQ0VRUzdoc1ltVlVF?=
 =?utf-8?B?dnJTT3ZXM1phUHhGVjFRZXFXVGhubFVudDc3a2taWk90TENLY3VUMXZ2OFUv?=
 =?utf-8?B?dk9pT2lCSDVjS2FZZm5zSmxoa0tIdExsK3NVMHlvdTR5OVVNNzBURTQwZmw4?=
 =?utf-8?B?Umt5dHNmRmRJSjEwcWVaTGI0anlCNkx5NjVpdXgrS3pqM09oSWVybHRKcHlO?=
 =?utf-8?B?V292K1VVZ3NEODkzYUttcVdpMmpZVi9QNkEvbExrWlQ0M2tScTBYZVAwUFVP?=
 =?utf-8?B?RkRzN0RWeE9QS3NJZWcrNFlYWmsyS1QvbWdVQjJOeng2dlg4dEVBamtkakJ0?=
 =?utf-8?B?ZWFqeEFCRHMxeWpBZFV2d1FjVVQyZ0MxVVM0MjhhZC9Qa2NUZlhLaksrd0ll?=
 =?utf-8?B?OEpBeXo2Y3libmNlUjRMQS9Gdys0QmRwVXIwby9ienJ1VjByU0Fsalh0cC9o?=
 =?utf-8?B?d2xqOWg0UEt3RmxyV3JLZk1Bb1VMblZ2ZytLL3QvWlRDQzJWbjVmbFhFTkxk?=
 =?utf-8?B?MnZoYTBKd1ViLzlJQWNrWm9mRmRRUU1Hb2pVSDkxWlRzdzBsNVd5ZlRXUzVz?=
 =?utf-8?B?ZXV3OG5yL094dTNjWWtqL1huNDhjc2d0Z2tLWHJWdEgxNzdqOUJ6T0dXQXdO?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZWdTMWZBVm42bzg4T21QenhFQ2MzVUJkNTgzMW1RZHN3OXljZzgzNzI2WjlC?=
 =?utf-8?B?Q3BqTW85NEV1ZENJREQxclVsNjZuZVUvaTNBVU10SWQzbk5UQURJaW1DQjdp?=
 =?utf-8?B?V0tYU2NMNlJMcGVJbUhQTDNET3hreXZTakY5aWI3UklwNVNvOG9OeTQxL2dG?=
 =?utf-8?B?RzZxOTl1YkMzM0dmU1Z3RDcxb2xSZDZrWGZ0V0JRR2RWUHdIbXpwQ0hseUZ5?=
 =?utf-8?B?ZmhUcFZNK0VYMHg4eG8zZytLQi9pNjFQK0lwYzJQMkxCWU9KMGhuUWJueThq?=
 =?utf-8?B?TUZNYWJFRXNqbVZOQk9CTEZIMlhxUUdQcEpnczNUNE5YRW9XZGxtSlh2YTlF?=
 =?utf-8?B?WEVaN205anJLTGEyUXFiRk94M3ZGaUF4akQ5TXdCQUY1RlduN0RwQ3M1eEYw?=
 =?utf-8?B?M0R1Mjl1dXpvYjFtVkVUQXYycytydVJ2QXFraERlTFRyUHgzWkV2anZsVHIx?=
 =?utf-8?B?c05tb0lFVXBvVkJBdlRZL3p2WjVwWWFoZW84bXgwOVBhdFE1SUV2YmhHT1Qr?=
 =?utf-8?B?MktZM3JNR3phWDRvNWRWSzFWdVY1ZVQ1SlVVNTBXS21pekl6ZHJhMTlDSll0?=
 =?utf-8?B?U3RNRTc4ME1iUU9SS01tMmJUV0RRaEJ5cE5QdXVGRWs1d2VYMGd4ZEQzdGdX?=
 =?utf-8?B?QU85Zm9rQ1grd2F2bXBOZ0lJTFZWMHV4dlhDcGVYWnR4dmF5c0NNajhrLzJp?=
 =?utf-8?B?SUR2U3gyVXVuV2JINmZLNlpuMTFwZ3JISTJYNEdVNnlnbEc1Q2p1RUI2RlBq?=
 =?utf-8?B?S1o0R3lua3U3Q2pRTFBEWURuTGtlVVhqaGhKVTVaM0R5M2JCWUh2d09mN1c3?=
 =?utf-8?B?bFdrNjJlN2twVFBaRjZNQUJaWnhxUnRwWHNLdGNJMXp6MWVpZ3hyRXBYalg4?=
 =?utf-8?B?R2ZIK0pPaEFBazdQZXl1YTNPRmM3cFNsejJ0UllMdW9xRkxEdkhvbE1mU1JG?=
 =?utf-8?B?eDViU3g0UXhNYVdFZ0lZNTRidHFYbktSb2djeDJaMFhWQXRIVVNJQm05ZkFo?=
 =?utf-8?B?VzU1K1RWV2RCVEdtb1A4bitCZkc4UUNCaFJQMmpZYTliZjFqUjE2OXJzK3lM?=
 =?utf-8?B?eTV2Q1ZJdHVlZlhKMzAxek95YnJNcy8zOG14UHg3SjhpOFo2RXhEOWVkZkZz?=
 =?utf-8?B?RUdvRVdyYVljZEJOanp2dkxXMkJTK0ZJRUZKc0U1MGZVRTNtKzJLc002bWIw?=
 =?utf-8?B?THFaNjdZbWs3OFBiN2pZZXNGK1YxbjhJMUVPN2d6TmkrbnBYbFpwVUlYYlJp?=
 =?utf-8?B?Z2dzbzNicmphMVVIRjk3YXFuc0c1c3hieFN3cTZxcGxpMWZzcHloTExOSFJY?=
 =?utf-8?B?RUpTc1JGOTRUQnBKdGUwaGlPTlc4NTdwWlZKajZUcGJBRkZ3SmtGZXBMMGU3?=
 =?utf-8?B?cldjam84ZjF4a1hlU1RUZzBEMmp5Mjg1Umo5TkIzVWJBRTVTN0tqN3VqY0I5?=
 =?utf-8?Q?YZiHYZI7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a8e5a2-5af8-4aa5-9df4-08db2961a4d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:39:15.8699 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMC3cVlQ8j9rzQmMuF2Ug1VitYUDIdDp5QOQBfqHn83eifQn4veUXE6P0f+gpuuKxBNvenegCB3Cifc2/69cBlFtoWDRtATgE2g0ASliLus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_13,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303200141
X-Proofpoint-ORIG-GUID: DNz4M7Pbmc4-v4LyZ9dY2mGoQsAs9vsA
X-Proofpoint-GUID: DNz4M7Pbmc4-v4LyZ9dY2mGoQsAs9vsA
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 21 Mar 2023 07:54:06 +0000
Subject: Re: [dm-devel] [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 Jan Hoeppner <hoeppner@linux.ibm.com>, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
 kbusch@kernel.org, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/20/23 8:06 AM, Christoph Hellwig wrote:
> On Thu, Mar 16, 2023 at 11:36:12AM -0500, Mike Christie wrote:
>> I think we are ok for dasd using BLK_STS_RESV_CONFLICT.
>>
>> It thought it sounded similar to SCSI/NVMe and userspace will still
>> see -EBADE because the blk_status_to_errno/errno_to_blk_status will
>> handle this.
>>
>> There was no internal dasd code checking for BLK_STS_NEXUS.
>>
>> There is a pr_ops API, but dasd is not hooked into it so we don't
>> have to worry about behavior changes.
> 
> Yes, we don't have to worry about it.  I just find a bit confusing
> to have a PR-related error in a driver that doesn't use PRs.
> > Maybe add a little comment that it is used for some s390 or DASD
> specific locking instead.

Ok. 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

