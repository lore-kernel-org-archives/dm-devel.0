Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4DC1C63707
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420243;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4KOja9rwbeL72YftC5mjFhWixEOheR9fZm8+AFrXyME=;
	b=KJjHqT5TC1q7r/fGLxqAC0IGpYjxJKY8U9PT4mcknuRmiCRJOeBJgoi0KZaILpa6WSyrcV
	7iTWnSYpkiA1pXJraxPzAtNhlQuQXHlav4V9kQSmFDXUd3dLpphhJDB6oOQ5iGAcPTsjPV
	Q4S8OPZ6HMPF8TsBK2jkXfnHFpHC/Gk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-6JxmQw63MCaxUBmTskur0w-1; Wed, 07 Dec 2022 08:37:22 -0500
X-MC-Unique: 6JxmQw63MCaxUBmTskur0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49732803D48;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 365E42024CBE;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D29581946A51;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFB131946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 17:18:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE79A63A57; Sat,  3 Dec 2022 17:18:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C5F4835429
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 17:18:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A259C8339B4
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 17:18:51 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-urTfWYPZMn-rQJRHJNlmbw-1; Sat, 03 Dec 2022 12:18:49 -0500
X-MC-Unique: urTfWYPZMn-rQJRHJNlmbw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 2B3FOKc1018296; Sat, 3 Dec 2022 17:18:47 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya40rvj-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 03 Dec 2022 17:18:47 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2B3E0daE016757; Sat, 3 Dec 2022 17:18:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3m7vwn7uxv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 03 Dec 2022 17:18:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4143.namprd10.prod.outlook.com (2603:10b6:208:1dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 17:18:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 17:18:43 +0000
Message-ID: <5155c8f4-df2d-9257-5a7c-619c4ecee6fd@oracle.com>
Date: Sat, 3 Dec 2022 11:18:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
 <41d2ff77-05c8-dd18-b24f-e3ec6884dfb2@gmail.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <41d2ff77-05c8-dd18-b24f-e3ec6884dfb2@gmail.com>
X-ClientProxiedBy: CH2PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:610:58::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4143:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c40f05-62d5-41df-fa3a-08dad5526d6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ZlZGb5SUDHpYhPnYybuaxk3mMl0Fb8JmOa0bb24UcPzDSLRxgPQoEOzKR5GCmvG5/KU+i3Tnfhr65IklUiSKWvpX4TEhjm5jToJhv/0jfAchy61NaXS/hlqrP4rY162qAi2KnOJTaktBGkanIw/lF0yF8wfmjuErWORnWclaqFni+l5Y48zVS3uH0Mcweb+4GrYytA6uwMiFvsXrKfCe07x+AyHpUThlLIW2WrlJCu2XkEZbC8rc2n97jYNp7cLobTKzdAORmKxCPiEwBIazYIcCEcscby8AAO1VzkmxahPiAgAGL/FnQfWYQEL1mrZOCWI8+i8gRfdsolybh5EVy8li+i4SuU6hfAs9fWTvp6sc8dhOr0tDHxZFrgi5mDLElRPMptKg9wln4L2YhQp62gG1jUXcxq5PWeTNWlvbkPRr8Pa6Rud+jCw/q9Yijrk7/NLMO94UDFS1og5HA/dPUUEP8KSkn1qOqxR9ElsSRpH9QslpQD48FA6uA6PORZqXaQtZbwo8Gn2OrWzCXBhp1h/7Uhf5NYBl0UGmw2+J0Ens4b08+5keg+cNu9wHm0uQ7c0thZp+0AU//lAe5NkgG+wySg7f9CZRpupDvW6F3UEMkvA4kn8HhW7ysI2lc9tFKo39xqko2cYd6Z9Mvw2ZgUhWVvdyns6XNLnkuTpTGwlzHb7RheiyjdNu8JVVZjvLF4JHQQ9+wkf3wdtioo8bbR7EoAB+7aVDnjubnTxMn+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(36756003)(86362001)(31696002)(6486002)(478600001)(53546011)(6506007)(26005)(6512007)(5660300002)(8676002)(4326008)(41300700001)(8936002)(316002)(2906002)(110136005)(54906003)(66946007)(66556008)(66476007)(38100700002)(2616005)(186003)(83380400001)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0FvS0xmMjk4UGlDT3l1Y2pLYVkxNEx3bXNGb2tYbDFLZklteVVyTlNyZHZM?=
 =?utf-8?B?cThXQSsxUitTTHRybER6NVB0aFFzYkVxbGZ1YlVvS3l0NnF2dWZiWm03SzdO?=
 =?utf-8?B?SnplZ1U0TVYyV1JPL0Z1RG5XdkxMbkRVQ1BrUlFjSEtDN015OGlHeDlhWEd4?=
 =?utf-8?B?VkpQRk9JYTJPMzBsQjlkbFlHYUFCSmxDVEVoNGVsM3JORURpVFBXRWIvM09k?=
 =?utf-8?B?Z3Jvem9IRTZGYUpXK0MzTjk0WThiTnJYVEpBVktSNG0zaUlydHNhSSt0aE54?=
 =?utf-8?B?Y0wrMUpVVUFqNU5heEx0dEI1RC9XWXgzSWMwbTBYS0lVMjNZanVoeElIQXpN?=
 =?utf-8?B?UGVrQ1JKdnBRWjdrT0dPcmRJeURSdU1xTld4ZVZIMjBLU1BrTllFUkNXbXU4?=
 =?utf-8?B?MjE5aTBoUUxtOXNXVWZPejAxcFpGQzRvcmZCNGpwN29wQ1VieUxSV2VLU0Nm?=
 =?utf-8?B?dWZWQWdRU0c5a3NBYzNBTzhkbldBQVB5VDRwWTFGZU9vd1NOR0lveWVPWGRY?=
 =?utf-8?B?dXVZYzVEZ0NnUHVUVGNjVEJhVDMxQ3FDRCtwUXc4bzVIUGxMcnVYMzZZdGx3?=
 =?utf-8?B?WDZxZEU1SmhOT3ppRHFLdW9Qams5cEhvZG9BWEp2S0NUWDQybndUVWpESk80?=
 =?utf-8?B?cEZHVUtrZlkrZDJOMFo3N0Z1L1BTZ2NhOUdiWVg3R2kvQjVzYitqNDREK054?=
 =?utf-8?B?WmtxNlR1RmRpcnhwUUpwMUEyaVorNlBoY0FZQzl2cUNDNzJ3c0FwSm9rSHFh?=
 =?utf-8?B?bGRVZVVmWmg0NHBtdjFHN3pRRWVQc1o0SDNPZTJLcWVMeUVuK3c3VFFYTkxq?=
 =?utf-8?B?K05yUlNhcGxZTW9vSXNZd25UdVNRMTM2OWhiNnl1VWF1bSt4QSt6UVpybStq?=
 =?utf-8?B?Y1hNeXl4OU5ENVVHVndzaDlhdTJjUHhJYVhySURXRlZraUtYOTRlUE1RNVox?=
 =?utf-8?B?cVVIOWZJbDZuNm45Y0VMajU2L1ErQi9DL1J0SndTQUdqTDI4NnZ1VzNnOE9H?=
 =?utf-8?B?cGtaK0lJTEsxMUFndmpUTUVuRFhFeml4cy8rQ1dvNXJJSW4ranJwWjF2bkRZ?=
 =?utf-8?B?SGVTbjZHN1NFQmhpZVNuUEJSazgvcEdjM3JYWExzc3BCdWRkZGdRajh5Tkcw?=
 =?utf-8?B?N3pmY21PUURkb002OGRoRyt4NWR5TzJkUDNaVUlNbDFOMUYwOHo4eWZLN09t?=
 =?utf-8?B?OTd0ZG1aV0lucFB0Tm9pbk1scGllTXJGMW1Lc250R1o2cml0WXdIb0taYTBT?=
 =?utf-8?B?VnVST205Zmc3UU1FblYrdkJDbGErMHRlM1ljbVJPNEIxMXg2M2pmcG8zRGN4?=
 =?utf-8?B?RytCSWR3azhJbUpjYmhnMk9Nb2ZWaE15ejh1WGpYajRZd1pJL1o5S3hzaFNv?=
 =?utf-8?B?OFp0ZTNndU8yOWY3K21aNTRCYWczcmNxZlhqUURGSWE2VE9GdkxhaHRGOUxl?=
 =?utf-8?B?VFcwb3JPeSs0OEVpM1dmd1JXSllLa0FiLzM0MmtsWVBWWWhYY3IwcUR2bit4?=
 =?utf-8?B?SS93YlkzMHIrblJTOVRDZTN5SDdDbGlMZ3VOQmpXNVlrTWNaaHRkcDNRN3hS?=
 =?utf-8?B?NWgzMnY1eFpiWW91WkdHek82NklMa0pURHJnTWJUWHdCcTZsVGQ4b2gxTk5i?=
 =?utf-8?B?TE1aeEVwTUh2ZmplaDBGU2pZWk5MUVZzb0t2R3pYbXk1SzJKRTdnLytDNXZu?=
 =?utf-8?B?WGRUL1VkeUduWk5Lb0JTczdFRFAzZ29zcUFmckpvWnFDZ0Izd1ord2JuZEIy?=
 =?utf-8?B?Z1NLc1Y4UVdTOFJ2aUFMSkc1ODFidGlRaVQ0UGp2Sm10dEZtWkhMd1pyZnh6?=
 =?utf-8?B?VnpoRGdINUtseWZIWVkwVjRRekduK0NSVndsdDY3V3FPeFlnczZwZzUzcUZT?=
 =?utf-8?B?QXk3dnNzaDZVejdoZEZQTmw3S3hVTXg3TzEzR2lzcE4rdE1icllnS0VuNlM5?=
 =?utf-8?B?c2J4dDB5VzZJTFFBcCtXaEs1TXJtR3BNNVplWlU1Y3dKU1FDWXhlNE9mVFdj?=
 =?utf-8?B?VU52eG81ejAxck9IUUV1a1NVd29YYmp1Y2tKWHdjVkFkNkxsNGdUenRld1VX?=
 =?utf-8?B?M2FhT21rQ2thS2FPNGs2SGhtZVRLZXRMb0dRL0I2MmU3d0RxeWUxVFNVeU9E?=
 =?utf-8?B?WDBOYlIyK2xET011RGdPWFREdGVWK0hUK0pFend0eTBwZjJYNkNDT2M1ZUpw?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rVz6sPVz4KnkQiXyi15HXvpUBOfCkOpHAmT5xuWZVjqjhblAX+Gi8byRaChiZLGKkgGNP17PeKOFaVfE8NCqV3TkKDiER3x1pAR3a36kDI4pWVWTw4KFfOvcEYloUhY1jBiMzTxqp1MbTtpDd6l0HBTQk4DfwVUW76t3FQ0Bz9r7aFs3KpoUC/+CCFknwndiILnbvtnOKpIc7yNpDRCxdPqEGG5P4s7E85dee1OP3ByhKgltHBeLTe/IDDU1NZbBy4ME9PyilfMYLekIJ8dZiZsA2nV41+WKeJ6x9bcRWNgu8gvQcU3U1JDAT6Jbi+H37qCSYPr6LsxRnhqZJkZFamgd4lPvxTMemaQTlSNpIHdMg1EklBiVZe2n11h4dDPPAToWEJtQ+wLVTMvUDesjn/QVhtrOfMwPB6d/caIzshxkBhXNPsX7R+OC2c243rtimwmpWUpI1ibqV8dJOZ1uYVzOoOKdVlegB3RMS+J/ErbnKeqFk9HF6WjDpGnFWRCB/aiLP/J92yiG/l7jlSD/tUdOKQ60/I7FkXkgWJ6QkepvkLVTgmQ+gkcapLaO2Y3uB3xxQf8ol0t50F5YBnkVC2gv2n1yUe0Plnti8L2xghOJ0QQjGXIH1VXgRze7Q7d1+GB1t4GmJQbCDuBhAMmacWU8gd3TWnfcmVB9qQhuA4iL0Sg+/k7tGrAtaNFRr0OR3O5rVC+r0f+PxSY3ImZxjLqx0GFuVVlR8vFWMtsnq16RCwwr+EWd3+m+dHAunSyjlvLhiuS5Y1DpNOI8KuMwDREvKGVqEd8XLSB7TvBRWI0GQZNQ1jpQV3tuhG/NPKANR2BDvIi0WRz/YidF4Ye6yg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c40f05-62d5-41df-fa3a-08dad5526d6d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 17:18:42.8023 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ix/+OzWn6Apb+J34FUBxNJuCqWtmntYfumrYzcSPXtVJCHGPqOhtHu2iRIe/8UG4kboOUDL4TCsxoNpTnihKGyjUsNRDHnaBsXHwCqu95+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-03_07,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212030151
X-Proofpoint-GUID: X-lZ-iOLpIoDTkjNgQ6Sd1VEDK5Zsbdm
X-Proofpoint-ORIG-GUID: X-lZ-iOLpIoDTkjNgQ6Sd1VEDK5Zsbdm
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 2B3FOKc1018296
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: Re: [dm-devel] [PATCH 1/2] multipath.conf(5): remove io-affinity
 information
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTIvMy8yMiA5OjEwIEFNLCBYb3NlIFZhenF1ZXogUGVyZXogd3JvdGU6Cj4gT24gMTEvMzAv
MjIgMDU6NTYsIGJtYXJ6aW5zIGF0IHJlZGhhdC5jb20gKEJlbmphbWluIE1hcnppbnNraSkgd3Jv
dGU6Cj4gCj4+IFRoZSBtdWx0cGF0aC10b29scyBkbyBub3Qgc3VwcG9ydCB0aGUgaW8tYWZmaW5p
dHkgcGF0aCBzZWxlY3Rvci7CoCBXZQo+PiBhbHdheXMgYWRkIGEgcmVwZWF0IGNvdW50IGFzIHRo
ZSBwYXRoIGFyZ3VtZW50LiBUaGUgaW8tYWZmaW5pdHkgc2VsZWN0b3IKPj4gZG9lc24ndCB0YWtl
IG9uZS4gSW5zdGVhZCBpdCB0YWtlcyBhIGJpdG1hcCBvZiBDUFVzIHRoYXQgYSBwYXRoIGNhbiBy
dW4KPj4gb24uIFRoaXMgaXNuJ3Qgc29tZXRoaW5nIHRoYXQgbGVuZHMgaXRzZWxmIHRvIHRoZSBr
aW5kIG9mCj4+IGF1dG8tYXNzZW1ibGluZyB0aGF0IG11bHRpcGF0aGQgZG9lcy4gQnV0IGV2ZW4g
aWYgd2UgZGlkIHdhbnQgdG8gdHJ5IHRvCj4+IHN1cHBvcnQgdGhpcyBwYXRoLXNlbGVjdG9yLCB1
bnRpbCB3ZSBkbywgd2Ugc2hvdWxkbid0IGJlIGxpc3RpbmcgaXQgaW4KPj4gdGhlIG11bHRpcGF0
aC5jb25mIGRvY3VtZW50YXRpb24uCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEJlbmphbWluIE1hcnpp
bnNraSA8Ym1hcnppbnMgYXQgcmVkaGF0LmNvbT4KPiAKPj4gLS0tCj4+IMKgIG11bHRpcGF0aC9t
dWx0aXBhdGguY29uZi41IHwgNCAtLS0tCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA0IGRlbGV0aW9u
cygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUgYi9tdWx0
aXBhdGgvbXVsdGlwYXRoLmNvbmYuNQo+PiBpbmRleCAxZmVhOWQ1YS4uM2E0NWFjODkgMTAwNjQ0
Cj4+IC0tLSBhL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41Cj4+ICsrKyBiL211bHRpcGF0aC9t
dWx0aXBhdGguY29uZi41Cj4+IEBAIC0yMDUsMTAgKzIwNSw2IEBAIG9mIG91dHN0YW5kaW5nIEkv
TyB0byB0aGUgcGF0aCBhbmQgaXRzIHJlbGF0aXZlIHRocm91Z2hwdXQuCj4+IMKgIGVzdGltYXRp
b24gb2YgZnV0dXJlIHNlcnZpY2UgdGltZSBiYXNlZCBvbiB0aGUgaGlzdG9yeSBvZiBwcmV2aW91
cyBJL08gc3VibWl0dGVkCj4+IMKgIHRvIGVhY2ggcGF0aC4KPj4gwqAgLlRQCj4+IC0uSSAiaW8t
YWZmaW5pdHkgMCIKPj4gLShTaW5jZSA1LjExIGtlcm5lbCkgQ2hvb3NlIHRoZSBwYXRoIGZvciB0
aGUgbmV4dCBidW5jaCBvZiBJL08gYmFzZWQgb24gYSBDUFUgdG8KPj4gLXBhdGggbWFwcGluZyB0
aGUgdXNlciBwYXNzZXMgaW4gYW5kIHdoYXQgQ1BVIHdlIGFyZSBleGVjdXRpbmcgb24uCj4+IC0u
VFAKPj4gwqAgVGhlIGRlZmF1bHQgaXM6IFxmQnNlcnZpY2UtdGltZSAwXGZSCj4+IMKgIC5SRQo+
PiDCoCAuCj4gCj4gSSB0aGluayB0aGUgbWFpbiwgYW5kIG9ubHk/LCBjb25zdW1lciBmb3IgdGhp
cyBwYXRoIHNlbGVjdG9yIGlzIEV4YWRhdGEuCgpOb3QgZXhhZGF0YSBidXQgYW5vdGhlciB1c2Vy
IGluIG9yYWNsZS4KClRoZSBwYXRjaCBpcyBvayB3aXRoIG1lLiBXZSd2ZSBiZWVuIHNldHRpbmcg
aXQgdXAgbWFudWFsbHkuIFdoZW4gSSBnZXQgdGltZQp0byBkbyBtdWx0aXBhdGhkIHN1cHBvcnQg
SSdsbCB1cGRhdGUgdGhlIGRvY3MgYXMgd2VsbC4KCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

