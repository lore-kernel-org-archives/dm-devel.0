Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47305C761AF
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 05:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679289432;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BmA0/TE79+eU14yGNwF7JprFCG9pim5F3dkWHvPrA9g=;
	b=Ch0jrvkJcPc3egYn9VMx5NzvPGojERQbV6nb95AeY2gnTYA1Xsi+YzpwSZLnbkH9aLk2ZK
	8OnAiQdEe5+uQ/JYqFFERzKFN31nIeJtrnykakrz6ArztEW1v7BOJSMrV1i+j6DnuvKmRw
	3BJ2OcT/Yq0OJfQCzVO6f1Yy3LNZ/Tc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-RYfMfWxeP9iOFMU_XlVJFg-1; Mon, 20 Mar 2023 01:17:09 -0400
X-MC-Unique: RYfMfWxeP9iOFMU_XlVJFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6086C85530D;
	Mon, 20 Mar 2023 05:17:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10E7C40C20FA;
	Mon, 20 Mar 2023 05:17:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 450151946A6E;
	Mon, 20 Mar 2023 05:16:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32A711946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 16:36:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 00F6740CFD41; Thu, 16 Mar 2023 16:36:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC8AD40CFD40
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 16:36:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C53A83814955
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 16:36:38 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-6bjAyagpN_KO75UPwB71Og-1; Thu, 16 Mar 2023 12:36:37 -0400
X-MC-Unique: 6bjAyagpN_KO75UPwB71Og-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32GF9mHZ012743; Thu, 16 Mar 2023 16:36:17 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29snna-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 16 Mar 2023 16:36:17 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 32GGDGV9004928; Thu, 16 Mar 2023 16:36:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pbq452qsn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 16 Mar 2023 16:36:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6722.namprd10.prod.outlook.com (2603:10b6:208:440::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 16:36:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:36:14 +0000
Message-ID: <6da0ec0a-d465-fec4-0ca5-96b2ffb7be7a@oracle.com>
Date: Thu, 16 Mar 2023 11:36:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: Stefan Haberland <sth@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
 <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
X-ClientProxiedBy: DM6PR02CA0114.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cae15fe-77ef-4875-2157-08db263c8eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: KRgJ/E41j5PiKV+98Jz4W0anXd7e2rzN0HdGVF9zRxm7+6H4FaAjPnXaEYhxoHnEWoUs/ee8rOPitk22J+3JU3Wd54LkveWoAKHuDlW3wXs/r7GuXzUz1puHBGqLp/O/Nyr93i4tGI4owRbnSxZSM41YH5FyAWah+MISqjejqkBkXCVHMUPQWi/H3L2B9GAM61daMeO9iWDhqO6mBclbgsqTcL+WEatm0JCD3HvYwXRpglxgo3snpplhaIQf7lt0Q4UgWddueyoCFJn3Uqlt39eLph36WHrAKSiR7zvGPRIdUGe0mIV3CpQwCodIC1QFJXV8Bege4FeRmp/UFNn3mHilxvQCY7D54KkRJ9dkQXSlC0j7nnETKlpX+7Di2pjfNECiLCCBbjF4Fyv5VXz/iYlqpqPyLrvUV1SN3AnI0pMt0w4VnhNxwH+/oCYaSLfvaViCs+F2HS7iN554S1pz7er+IOCc/IBObdUcn8FiV745ae/3ZqzrtzZM/lvVUmq+DLj/19j0O83mpNd3FyRqkWzSzY69odhQAlZYpAKTAodg8FANyifVrtYZKoXs+sBUQH5lzIm+yiFjNQ3ZGi12U6vk53+Z7diKTx3+2bEbwr+TjFrKqye7xmasr7qZysBLajEgiW/PrEPRxC3ks/5u2DwFG3lagMAIZp46wFtAS9AsVcmGf9RK1kVw354HJ6mCm9/H1Uwfy7yFBPGqE/CRT8mkJUgJcSpMfXCzWEGMhEQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199018)(2906002)(31686004)(41300700001)(5660300002)(7416002)(66946007)(36756003)(31696002)(86362001)(66556008)(110136005)(4326008)(316002)(8936002)(83380400001)(38100700002)(478600001)(186003)(66476007)(26005)(6506007)(2616005)(8676002)(53546011)(6486002)(6512007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkZEeHR2UEo5VFZFaUE4WkdabHBpVXpxdlZzRkFWSldERWZOdGw2MFFxbFhS?=
 =?utf-8?B?eXlvL0Y4a0dYbFdkT29IdGFBRHFoU29YTU1GdVRtZVFxVzRpOGJTUk81RHZ6?=
 =?utf-8?B?eGI1SlJLL203RG42UUpLTW50a09WcVgrN0lpMGhBZ2UyU3RTQ3lZcGdWbG1W?=
 =?utf-8?B?cGtBekwzMDhlVzJKelRTSkluRzFGT0xHcUlBQjFQZWUzTkhrOHJWT0RRb0o5?=
 =?utf-8?B?T2NFYnNrbEdXcXpLMnpzcXZzU3d2UU5aNDdyN1NrRDI2NURxRkZMRFJxQUFq?=
 =?utf-8?B?NTRZRnZKK0NkODhObWs2b1N2c1czcUt0UHYxUnpMWFVCdlU0OCtTU3lHZDhy?=
 =?utf-8?B?cC9aTFhIUnVSSmFsYnQ1Yjg2akZ4TnM2cURtVUNQTVJMYmxyN2Y1VGZja1cy?=
 =?utf-8?B?dkhtWlNFZGYreURMZUZ6WEg0ZXgwOFRmbFpJTVE0T1dCL1Bud3RSSlJQT08v?=
 =?utf-8?B?L3BybG94czczRXpFbTBadjgyR1FJQlZOclU0ZnJSRVpOcVFCYnJiaWx4dEdC?=
 =?utf-8?B?V0lYNXB0ZmtkbTlLczJzc3hlNlRPNnN6cE5pOThmdTVwbitHekIwM0RLdUJh?=
 =?utf-8?B?cDRDNG9VY3V0dUl2ZGVxcmFDMDY5OWxxbkRQRmtnRE1yQlpYaGdPOEZ2VVNG?=
 =?utf-8?B?Z21yZVNxYnoxcTZuUGtNY2hwSnNLYUdUSzNkMFFVOVV4aDlwWU9vRFdOVksw?=
 =?utf-8?B?OWxqMDIwTTNvL0pZbnp3Yk05ZWJHWUhwVDRwYnd4MmFlRHd2NHZMcnFaTFlM?=
 =?utf-8?B?Z0dIR2NDazBtcTdYNTUyakxLY0xyalIxOE95Y2Fra24xZGhFcFRVTEhKWmxC?=
 =?utf-8?B?YjNkcUlnQUdJQndGbHZmQmtnOERydGV3SUp5WDFkWWxZbk1wc3RwY2R4VUFP?=
 =?utf-8?B?c3o1N0tackFyQkgyNi8vNEdrYzV6dlF0ZkpLaUljK3FWMWJ0dWsxVXdseHJP?=
 =?utf-8?B?d3BMeVQrblE4UjFwN0tudmthSyszazJYWDJGZ04yZ09rbXl2S21IaHZjenpT?=
 =?utf-8?B?ZWk2ZXI5ZlduNHV0RjhFcFB2SWRJaG5ndlVpS3F5a0E1ZUN4NTZOSFByWnNs?=
 =?utf-8?B?MEN2ZG1BNldLN3pvNEgxQ0t6LzhoY28wdDNNUWZpd0VxMGdUUkQ4NThEcUdW?=
 =?utf-8?B?aUZlVWl6MFh1VitobkVHVkFFdEI4QTFOSVhLL2FZbkZKaG9uRkY2ZmlRU2lQ?=
 =?utf-8?B?R3QzMWlocTNaOU93aUhHTm1HMGp0c0lyMjQrTXlqQnpHcHRTNHc0cWQ1OGdx?=
 =?utf-8?B?MTZzbkM0aTY1K3U0a0c2cHQ4RXF2QWl4b3JjTVBFZS9YeFVsTXprcDZya0Vp?=
 =?utf-8?B?dXJ1MFNyOXpBVWtCYlBRL1hPNFFtUU50MHVrc3RyZUVmUXEzK3RxNlE1RGdt?=
 =?utf-8?B?eE9Wc2JKdlJocEt6UWNiNmliSllHNVBjMFA5c0VsR1lWRWN6eWMycmNZTnlZ?=
 =?utf-8?B?azBEVzdZd0JMQTkrNEpyc0hvbGoyS1hFNm5QNHZmUHhqMCtHcnExU2R0b3Yw?=
 =?utf-8?B?WU9IRndKcXZjSUJVTEJlNEdVUS82dHBNdzM2MS82NHlHRTA1UmRYUVovWG5s?=
 =?utf-8?B?QkVmV29XbzU4ZU9yTFBZT3lvZlNWaTRzM3pVbGRMbXhzMklTc085R21UMWRR?=
 =?utf-8?B?MFA4REs5a2g5WGlwS1U1T1g5cm8waXpIZjlVYlNIMWNIcFlSbWs2dU1Rck54?=
 =?utf-8?B?M3UzQXZ2eSt0OEhNbWFUYnU4RUZtZTgvaURJdXpta3RRaXAxcklHL04reitC?=
 =?utf-8?B?TG5aa0hLUFBUNndNVmRXczVpTStnRG1QUlpIb0NhZ1ZkVGNaWUllczFRKzBl?=
 =?utf-8?B?WkI0ZDRWUDIraERXWCt3ZHQva2JTVHJPN2tNWlNmQ3pGOEs5Q0MxQWFtMG1s?=
 =?utf-8?B?YkJMaUVnMHRsa0tObndlS3g3Um5UYzl3Q2x6VUlMQVNGRVhqR245eE90WTdh?=
 =?utf-8?B?b3Y4clR6S3czSXkxNXpJQk5lSTdoWm8ybjg0YldwMHdpMk9oTmtNSVRRNGIw?=
 =?utf-8?B?RDBpMkNnbUJXNCtUSHg0YlFkYXNxVEpVWEowV3IzSUd5VDJFQ2NJZ0RxZEZ5?=
 =?utf-8?B?U3p3dzM4dWJlYmx2MGQzc0JOR0E1WkVVVGhjc09QSmwzUUxBN2Y4ZTlzbmQx?=
 =?utf-8?B?ZmcrNzVpa1RISnRDMHNXTGthdHNMMlo5VmV0Vm5aMVlzR2ZReUxFS0FVTkpK?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VzV2OC9QVGtaZ0N4Rm0wTlRyTGR1b0tPelVDdVlWaXFpWDhVQzJ0MkFWdk5P?=
 =?utf-8?B?MlRmQURUcXRXK1NjazRsUmpXaDlObWJHMVpZcXJCbTRFWmtodkhTYUJuZDVP?=
 =?utf-8?B?UkRncDJDK0YySTFCQ2hnMmIyVnh6NUhLQmFwV0lpcFRHQk9hSGtpSmJBWHlG?=
 =?utf-8?B?bll2b1ppNHVXc2NCQ2Y1dGlRMDNmWnRRY3E0c1MySjd4aUErNmZNKzJUZGNR?=
 =?utf-8?B?OG1adzVCMU9rK0NiemxNWUp4TlNWcm1sNWlPWE4rV21Ca3JFZEo1eHpFVHZ0?=
 =?utf-8?B?eFVIUWJlQk1qMTRqcDJiS1MweW04Y1lZRE9HZG80V2VuK1g4Q0JjeUsza3pl?=
 =?utf-8?B?UzJNK1JhU2tVQzE0RjdZc0RDcUtoN1NUN0VQVHFaM21IUnc5T1N0NU1jUk1Q?=
 =?utf-8?B?MUNQT0FhbHNwWVg3VlFPYjdyRmpNSm9KcHYrRHpnV3l2NWRvOXlVSzhQT1ZF?=
 =?utf-8?B?Sno5eFFnWlZ2QXV6czgrdllxTklweVFuRmlZRVBxQUlOaTEvSm1SalBlSm03?=
 =?utf-8?B?UmE0ZGhXMlRPODEvc3l1M0hwUGNTcWlzdnl6KzJQemR3V0V0YnQ2QjdlT1BZ?=
 =?utf-8?B?Ulcwc3lERWt4VDVCdjBsYVJDcm1OTFBGM3BjY21UaDRZRnpxMnVscXBVRHhN?=
 =?utf-8?B?V3NkSGUxN3BZUzk3MEtxMFZ4ZTcxK1FyeWpYNTN6OERJR2VSNVRXMVBwQWY4?=
 =?utf-8?B?eFhDQ2tmdXl3SkVKMUdUYmNMWDFpWUhQMHRBTWVIRzVuMVppN2tIVTVPa1c5?=
 =?utf-8?B?Rjl4cXZPcDRicWJRUEY5ck5pYVN1dG1vdjVlQWcvazdNRzkyb2NZVVVMSXIr?=
 =?utf-8?B?ZGk0bFhaOStiaE9Da0x6cUQySURDbVFFSExORlR0cHg0cHNpY1VYaWF1ejIx?=
 =?utf-8?B?Q21hVEJqZTVCVmNNUk9EZFBIS2RmVGtGRFVCbThRZDZwNFRrcm42Njh0WWxU?=
 =?utf-8?B?RE1kdk5laXd2Rkl3azhMN1Q5NGZOWE5lL2czak1rYlFYczZjdXp6bXpZaGgy?=
 =?utf-8?B?dGxLR2JZRDAxMm5FQ1FTVitySEJrY2dpc3ZmdEJWamthb3RqN2t3eG9DR0Zz?=
 =?utf-8?B?T0p5QXYvWmFuRi9Ga1d0UTZsWmZiNGxUYVFrT3dMcUt4ZGkvUjkvM3dUUFNW?=
 =?utf-8?B?ZVFpQVRtVWViRm5WUjB4NmtkbUs2M2ZUVXlVVEV2RWFiZDVURXZMTndHNS9K?=
 =?utf-8?B?bmhqTzdFRW1nalB3cEcwSWdpbHVtTU9QY3Urdmd2T2NuRXJ1cjY5NW9xbGZ2?=
 =?utf-8?B?TDZPZDVLL1BXcXZlWWRrTzZoNU96M3NFbmxvUjNIRzNHdng2MXAwRjcyd3Zu?=
 =?utf-8?B?N2VlNlc3MzF5alRWZjBZZVc1cTNacXV0N2lSUkp4b29pNWZ1ZlFNVHpKZ1Bm?=
 =?utf-8?B?RWg2ZnJrYkRNb0J0V3YxY2N2QzVFMXJZUm9lSFM5dUlqSjVVYlZtSHc0TFFr?=
 =?utf-8?Q?kVKGtH2r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cae15fe-77ef-4875-2157-08db263c8eb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:36:14.1510 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/LWbydvrcN9O67dDTEglVbW6fh3gnzNBkow2ofEYcnC3hEOMVD6RBuXTRa0oDYVMjvXlTnh76hWMWYdOMT9nWk/5AjYPnzBinlEDpnHtiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_10,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160131
X-Proofpoint-GUID: J7xblq_27tnTtfufmdtAgu43xVFFK8L6
X-Proofpoint-ORIG-GUID: J7xblq_27tnTtfufmdtAgu43xVFFK8L6
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 32GF9mHZ012743
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 20 Mar 2023 05:16:58 +0000
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
 bvanassche@acm.org, martin.petersen@oracle.com, snitzer@kernel.org,
 Jan Hoeppner <hoeppner@linux.ibm.com>, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kbusch@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMy8xNi8yMyA1OjE3IEFNLCBTdGVmYW4gSGFiZXJsYW5kIHdyb3RlOgo+IEFtIDE1LjAzLjIz
IHVtIDE0OjMwIHNjaHJpZWIgQ2hyaXN0b3BoIEhlbGx3aWc6Cj4+IE9uIFdlZCwgTWFyIDE1LCAy
MDIzIGF0IDExOjA0OjIyQU0gKzAxMDAsIFN0ZWZhbiBIYWJlcmxhbmQgd3JvdGU6Cj4+PiBUaGlz
IGFsc28gZml0cyBmb3IgdGhlIERBU0QgY2FzZS4gV2UgdXNlIHRoaXMgZXJyb3IgY29kZSBmb3Ig
YQo+Pj4gcmVzZXJ2YXRpb24vbG9ja2luZyBjb25mbGljdCBvZiB0aGUgREFTRCBkZXZpY2Ugd2hl
biB0aGUgbG9jayB3ZQo+Pj4gcHJldmlvdXNseSBoZWxkIHdhcyBzdG9sZW4uCj4+IEJ1dCB0aGF0
J3Mgbm90IHJlYWxseSBhIHJlc2VydmF0aW9uIGNvbmZsaWN0IGluIHRoZSBzZW5zZQo+PiBvZiB0
aGUgcmVzZXJ2YXRpb24gQVBJLsKgIEdpdmVuIHRoYXQgREFTRCBkb2Vzbid0IHN1cHBvcnQgaXQg
aXQKPj4gbWlnaHQgbm90IG1hdHRlci7CoCBEbyB5b3UgaGF2ZSBhcHBsaWNhdGlvbnMgdGhhdCBj
aGVja3MgZm9yCj4+IHRoZSB0cmFuc2xhdGVkIGVycm5vIHZhbHVlP8KgIFdlJ2xsIHByb2JhYmx5
IGF0IGxlYXN0IHdhbnQKPj4gYSBjb21tZW50IGRvY3VtZW50aW5nIHRoaXMgc3RhdHVzIGNvZGUu
Cj4gCj4gV2VsbCwgSSBtaWdodCBjb21wbGV0ZWx5IG1pc3VuZGVyc3RhbmQgdGhlIHVzZSBjYXNl
IGZvciB0aGlzIGVycm9yIGNvZGUuCj4gU29ycnkgaWYgdGhhdCBpcyB0aGUgY2FzZS4KPiAKPiBC
ZXNpZGUgdGhhdCBJIHRob3VnaHQgdGhhdCB0aGUgcmV0dXJuIGNvZGVzIGFyZSBnZW5lcmljIGJs
b2NrbGF5ZXIgcmV0dXJuIGNvZGVzCj4gYW5kIG5vdCBib3VuZCB0byBhIHNwZWNpZmljIEFQSS4g
SSBhbSBub3QgZmFtaWxpYXIgd2l0aCB0aGUgcmVzZXJ2YXRpb24gQVBJIHlvdQo+IGFyZSB0YWxr
aW5nIGFib3V0Lgo+IAo+IFdoYXQgSSB1bmRlcnN0b29kIGZyb20gdGhlIHJlc2VydmF0aW9uIGlu
IE5WTWUgY29udGV4dCBpcyB0aGF0IGEgbmFtZXNwYWNlCj4gbWlnaHQgYmUgcmVzZXJ2ZWQgdG8g
YSBob3N0LiBJZiB0aGVyZSBpcyBhIGNvbmZsaWN0IHdpdGggdGhpcyByZXNlcnZhdGlvbgo+IHRo
aXMgZXJyb3IgY29kZSBpcyBwcm92aWRlZCBmb3IgdGhlIElPIHJlcXVlc3QuCj4gCj4gRm9yIERB
U0RzIHdlIGhhdmUgdGhlIHBvc3NpYmlsaXR5IHRvIHJlc2VydmUgYSBkaXNrIGZvciBhIGhvc3Qu
IElmIHRoZXJlIGlzIGEKPiBjb25mbGljdCB3aXRoIHRoaXMgcGxhdGZvcm0gc3BlY2lmaWMgcmVz
ZXJ2YXRpb24gd2Ugd291bGQgcHJlc2VudCB0aGlzIGVycm9yCj4gZm9yIGFuIElPIHJlcXVlc3Qu
Cj4gCj4gVGhpcyBzb3VuZGVkIHF1aXRlIHNpbWlsYXIgZm9yIG1lLgo+IAo+IEkgYW0gY29tcGxl
dGVseSBvcGVuIHRvIHVzaW5nIGFub3RoZXIgcmV0dXJuIGNvZGUgYW5kIEkgYW0gbm90IGF3YXJl
IG9mIGFuCj4gYXBwbGljYXRpb24gY2hlY2tpbmcgZm9yIHRoaXMgc3BlY2lmaWMgcmV0dXJuIGNv
ZGUuCj4gCj4gSXMgdGhlcmUgYW55IHRoYXQgd291bGQgZml0IGJldHRlciBmcm9tIHlvdXIgcG9p
bnQgb2Ygdmlldz8KPiAKCkkgdGhpbmsgd2UgYXJlIG9rIGZvciBkYXNkIHVzaW5nIEJMS19TVFNf
UkVTVl9DT05GTElDVC4KCkl0IHRob3VnaHQgaXQgc291bmRlZCBzaW1pbGFyIHRvIFNDU0kvTlZN
ZSBhbmQgdXNlcnNwYWNlIHdpbGwgc3RpbGwKc2VlIC1FQkFERSBiZWNhdXNlIHRoZSBibGtfc3Rh
dHVzX3RvX2Vycm5vL2Vycm5vX3RvX2Jsa19zdGF0dXMgd2lsbApoYW5kbGUgdGhpcy4KClRoZXJl
IHdhcyBubyBpbnRlcm5hbCBkYXNkIGNvZGUgY2hlY2tpbmcgZm9yIEJMS19TVFNfTkVYVVMuCgpU
aGVyZSBpcyBhIHByX29wcyBBUEksIGJ1dCBkYXNkIGlzIG5vdCBob29rZWQgaW50byBpdCBzbyB3
ZSBkb24ndApoYXZlIHRvIHdvcnJ5IGFib3V0IGJlaGF2aW9yIGNoYW5nZXMuCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

