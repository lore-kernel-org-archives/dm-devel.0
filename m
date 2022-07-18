Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F05FC43334
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jul 2022 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658165979;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zzcroszlhECpCYw7+zlcI+W+mvMsIZdqqxyj3V46B2g=;
	b=WBf3Pwe9xSggwf5/526WPeG4hww1/PpUvqYIYHC5WlFjVfSB0SvJFrRUPJThijR+v2O3RB
	r8WS7JJnoyxlsVDC1OiWkQLFI5qdM6mbuOAnNhS7zX7/O4WXg7uPa99RxQbj+C/RvAMKyO
	w437x2R5vZ6t31ObiraLzcbqyPcl2Ow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-a61ACtzvOi-rZCU2Bbzx9w-1; Mon, 18 Jul 2022 13:39:37 -0400
X-MC-Unique: a61ACtzvOi-rZCU2Bbzx9w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C391C280F2AA;
	Mon, 18 Jul 2022 17:39:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F52C2026D64;
	Mon, 18 Jul 2022 17:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05FBA1947064;
	Mon, 18 Jul 2022 17:39:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A57A1945DA7
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Jul 2022 17:39:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA2A7492CA4; Mon, 18 Jul 2022 17:39:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4D2A492C3B
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 17:39:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98E711824605
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 17:39:30 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-uZ2Klu-OMSO_n0gzIgGXRQ-1; Mon, 18 Jul 2022 13:39:26 -0400
X-MC-Unique: uZ2Klu-OMSO_n0gzIgGXRQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHXgeO032504;
 Mon, 18 Jul 2022 17:39:18 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx0v48x-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 18 Jul 2022 17:39:17 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26IGKAU2001903; Mon, 18 Jul 2022 17:39:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k2pbqs-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 18 Jul 2022 17:39:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4003.namprd10.prod.outlook.com (2603:10b6:a03:1fc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Mon, 18 Jul
 2022 17:39:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 17:39:14 +0000
Message-ID: <0bfd6a7f-7ddd-60e5-d37a-0c399b4d2fb7@oracle.com>
Date: Mon, 18 Jul 2022 12:39:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
To: Christoph Hellwig <hch@infradead.org>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
 <YtBlLDShzLdW8xDx@redhat.com>
 <ffce063b-6afc-bf76-c429-353c70a73439@oracle.com>
 <YtT1uTW04BC38NSK@infradead.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YtT1uTW04BC38NSK@infradead.org>
X-ClientProxiedBy: CH2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:610:4f::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d251e422-0adc-4c5f-bc01-08da68e46e67
X-MS-TrafficTypeDiagnostic: BY5PR10MB4003:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ht6ou5xDIYftJXvTxahrl9CgdcYW1xrPur6psXFp2Jscz3jJO1G2CdTXGlk+vTNUHwTCraLM+XJgChAxzJqogU56LpTCWafULLJOP+ftlaTi/w+BnQ/IHDn0iQ/eDLoJ2/+6yb3Db/4S3t9NtICTyuX0Czn7yHpnCMsAt3kMFOHuY1lS5DbY0PeXPP4Lr5wM8C/80DQqoxnNYVbVqE7XmAz3KEF7vgdgnbbV65WT08X5RYaiC5OPTlkLrY3+pUUpuSf4odyzJanSjC9dUQOoxkyGzCsIgQsx4WdJq/BppbeSj4Af3KSpcgNyyNMNOg+yD2K03t8uzAJwohrGg4ZY4+F6OIu7uqYST4wQaXNkWD3JnDQVjDNFE/0V/qS1r2zXL3WABraaq7C4+o3JNn36ZD7Vee0RKZJjZVabOBGdqtRMAYh2qpjpfVOixKUwFATzOSEDc0FJNaAUPQupAeb454cc0sQRl8HPJ7MIHHGXy4BT9R3fZRu6VviNb4yV0zthlT8dWEg/GtTmuCHqvFFZt0oiU9G3ACEEtgTeuGez9W2mY9k2sthAPj3bbC5peq1SUI/xMuivCij9ZBUOIYOLO2hC6KKLfsD73kZb9yAovzI4YTz+jY+zf36XQaq6P0BcwqGDivNMoBVXHR9EyIlruvsDSzMDXh1JR6ulkYOsk5aVtmt0IfSKjqpBDlpyQc8iuhzQFKpOU2GC1UqyN6Rz0owUBsXIwPzrgWc2UvrcVocyc4XhYEuZhSzra7lFcwLSxyFY0qIcC6jWXxbeFUJMV7mIL/ORMSudZjtUSMNTCO5i2Ur1ah+AtAGarYr/evw4LePrG/kH2bSVQkq7zxO7YLWr53kYjEEbzIY8M4DvQ5g=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(376002)(39860400002)(346002)(396003)(366004)(136003)(8936002)(5660300002)(2906002)(86362001)(4326008)(6916009)(66946007)(31686004)(66476007)(316002)(36756003)(66556008)(8676002)(26005)(6506007)(2616005)(41300700001)(6486002)(478600001)(31696002)(186003)(53546011)(38100700002)(83380400001)(6512007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXcvTkl6NmRNNzI3Q0RwYnFrQlpZZzJyTGZxYlJkRU5DeHE5aGYxK1JteGll?=
 =?utf-8?B?c3F0UUo5Z2lMU0NjNE1xZVZzS2E4SzREZ2pLVllXZnZzdC8zYXhINTREdXpp?=
 =?utf-8?B?OFJSWHQ2SnVwSks2RDNySmM3Yk9WeTJjaHBmTXV1aXpBMEl5T3BJSE04cWIw?=
 =?utf-8?B?dkRXUGFtbTJtbWJhZEhWcFdnZUtmQ0tySzRkUWR1S3hrRDRjb1UrUFhBc0pp?=
 =?utf-8?B?K0s5VG5NNXk1Q3ZpbU1GZ3kwMzdUNkM2aW9jc3pKdlJDLyt0cGhnUVo1S1Ju?=
 =?utf-8?B?Z3FCTXpieVpyaWxWWTRQOURJbUZVVlBUNFVnL0FNN2RaaWRwbUg2Qk4wSERW?=
 =?utf-8?B?OG5HcDU5bDB5dXlMWGRhZkFVdThDOHQ0Z084NFFBbmhjTEVOZmxhdzJTNG1U?=
 =?utf-8?B?elNVdDJqaGVrRklnZFZiMFZheFk3MVpmSExPUGF1bGpkWVdSNXV3aEtPWjNz?=
 =?utf-8?B?NHZkYjNQdEU2Y2dnYTJsRldKRHNmaGt5RW84am96WG8rWkhSYXdZYkR4Tmdn?=
 =?utf-8?B?VnVjeUdTOWlyOEY1ZlBPOVppZVZPWEVKdHFOK25RVjZpaU1PZm5Genk2QTdo?=
 =?utf-8?B?elp4YmpiWWVHMVF4SmF6WnR2My80YThDNUdlTEY4dVA1WnhRNnAwaFlLWkxJ?=
 =?utf-8?B?T2YweURZQ21FZmI1TFE1Y1dObDhHSE9rNlp3aXJ1NG5PdW5neUQvRWkvRzNI?=
 =?utf-8?B?ZEFuV3NKRktlUjRCOWI2VEFoc2R4SzVXVk13YkNZM2pOR29KazBhdE9sQmRD?=
 =?utf-8?B?Q0JOVmVSS0MxS2FGWVBwVzhFSzBwNmtqdWxpS2VoTllDakVoOENrUGQ1R0dx?=
 =?utf-8?B?ek8yUmRSekNTVk4xd2hzZGYvSW1kM0EzWERJbEY3M2NGaDNTdGUva2xNTitr?=
 =?utf-8?B?dTRMWXFqbUFhV1BjTFRUWXRyWFVEczJKb0Y4bSt5YmVRU2JTTmN4dldMeHFl?=
 =?utf-8?B?Yjh4U3d1RTY0ZlE5cHU5NC9mNllRYzBVWU9PWkdzSitvMHlsNzFJTWI0UjZw?=
 =?utf-8?B?bDZZZjlFN05ETytLak5qRlRRa21KbCtZWmxvSkhIamlwc1BEZWgzNVNvWFJE?=
 =?utf-8?B?SDdSNEh5d3QvRHhha01xL1dvN2ZhZTZSU2hHK2xVZnVoQ0UzSHFKQm96ZzVm?=
 =?utf-8?B?L3dLZDZEaEpVV052bUZSOUZ3ei85and5OGxvVHNmL2J1RG5jc3hWOXlGUDRE?=
 =?utf-8?B?TDFlbGF5dkZiTlpEZC9RblJ6dytyWEtBS2c2R1pEZTFCc3Vpem9sL0U4S2tE?=
 =?utf-8?B?U2Fac0czOHIvcGc1ZUphWllZdVVRK2NHd0Q0amdSUXp4ZnV0MS93dldycGp4?=
 =?utf-8?B?MGxVS1pQeDdFamdJdHJVVWlLUmVMSGJlK1hFWjBDSVZrcW92dFhIY0tBZFhV?=
 =?utf-8?B?MlRDRFN4UmJadUtFMEFNVHVXTEdnSWFna3c1MHlmZkVZak9FZXRZM3hidmV5?=
 =?utf-8?B?OEZoSEY0dHJkS2RGbjZhSmpSdnhUWm9HbFI2UTlXSzVVeWZUSnkreWRnWk4w?=
 =?utf-8?B?Yks0OTBMQVplVTkrMjN1WGwyODB6MlYxdEdrSWhZVlorMHo1dm5tUzRGU1JK?=
 =?utf-8?B?R0lodDgvYy94dzZSUWR3OCswWnd5QmdLSzFERCtmV2VrMzZBeFhSZWdUNmQv?=
 =?utf-8?B?N1BHSDNZNFR5TW9XcFQ4eWtOUndTN3BvcUxqNFJUNnphVGR5SzFxbkFvTU1m?=
 =?utf-8?B?c3NQbVNnclhZdjg2bm5nN05UVi9jR0tGVmFVcFdGMWJLcVRvZ0dFcG01cXdS?=
 =?utf-8?B?dHJ4MWptazN3V2RNR2JMSzkySTYvUXhub1BEWXdsRkpxZ3BZK1NSYjVEYlkx?=
 =?utf-8?B?eStlTlJDM1JhS2dJdXp3RVVzc2xOTlVibytiZHlubFBCVUtXWC9rZmlvSjNV?=
 =?utf-8?B?OWNYRzU0bVVHbTQyRFU0RGVBVVJiVW1WM2pkQ1lVOVJuNGt6eTJDZzBoekdw?=
 =?utf-8?B?dURQdVRCWk5TOTBxa3p4VjhmK0VUMTVHaWFCRlJNaHI2dTV6cmVoK1kzbjk4?=
 =?utf-8?B?UWprSG1Rak5GRytycXdSRkFWcEpxajA0ZzNDWUFkbjdNNHVHR0lydFFIZnZV?=
 =?utf-8?B?Y2ZTQmx3YnpqUm1abGtKUEN2UGd3QlBoVC93WDJabHhwQzBJY0NRZEQra2Qr?=
 =?utf-8?B?Rkp6cTFkYWtqNE96L1hSQ3RNOFUwRVJiRG0xKys0YXk2UEsvcmUxZUhwZTFo?=
 =?utf-8?B?b1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d251e422-0adc-4c5f-bc01-08da68e46e67
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 17:39:14.1720 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMww3QU1BSixros9SnMOktAfoDJNaYzzmhC6X1BWAUGPFACWFrzrVVKKVDYZ0AwYLtI+4pfXbroXFga3SKlrwZr+Fei3qPMWCPb58r8oz98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4003
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_17,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180077
X-Proofpoint-GUID: JqGq1fR8-sNYw_uMVjDM60DREg69w9NP
X-Proofpoint-ORIG-GUID: JqGq1fR8-sNYw_uMVjDM60DREg69w9NP
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 2/3] dm: Start pr_reserve from the same
 starting path
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/18/22 12:55 AM, Christoph Hellwig wrote:
> On Thu, Jul 14, 2022 at 07:34:57PM -0500, Mike Christie wrote:
>> I also ran the libiscsi PGR tests. We pass all of those tests except the
>> Write Exclusive and Exclusive Access tests. I don't think those reservation
>> types make sense for multipath devices though. And as I write this I'm
>> thinking we should add a check for these types and just return failure).
> 
> Why would any reservation type make less sense for multipath vs
> non-multipath setups/

I think those 2 types only work for really specific use cases in multipath
setups.

1. Let's say you do an active-active setup with 2 paths in one priority group,
and the Write Exclusive or Exclusive Access reservation went down pathA so it's
the holder. When the app does IO to /dev/dm-0 the path selectors aren't PGR aware
so IO can go down any path. For Write Exclusive, when WRITEs go down pathB they
get failed with reservation conflicts (sbc4r22 table 13). So this type of
reservation and active-active would only be useful for read-only work loads.

For Exclusive Access READ/WRITEs can only go down pathA ok. If they go down
PathB we will get reservation conflicts. So it's really useless in an active-
active setup.

For All Reg and Reg Only this is not a problem because all paths are registered
and the spec says for those types of reservations we can do R/W IO through them
(sbc4r22 table 13).

2. For an active-passive setup with 2 priority groups and 1 path per group we have
a similar issue when there is a path failure. PathA in PG0 will be the holder and
since we have the one path in use, all IO will execute ok. If pathA fails and we
switch to pathB in PG1, then similar to above, depending on the reservation type
and IO type, we will get conflicts since PathA was the holder.

I was thinking maybe for this one, some specific user sometimes wants this
behavior (use PG1 as a last resort). However, I think the user would normally
expect the All Reg or Reg only behavior where when we switch to pathB and don't get
conflicts for a path failure.

For a non-multipath setup we don't hit 1 or 2 with Write Exclusive or Exclusive
Access since each host just has the one path to the device.

>>
>>
>>> systems that don't have the requirement to pin the PR to a device?
>>
>> I didn't find any real applications that use the All Registrants type of
>> reservation where every registered path is a reservation holder. However,
>> libiscsi has PGR tests for that type of reservation and the code works ok.
> 
> Well.  In general ALL_TG_PT would usually be the preferred method
> everywhere.  But that assumes:
> 
>  1) it actually is supported by the target
>  2) the target actually has a useful concept of the Linux system being
>     a single initiator, which outside of a few setups like software
>     only iSCSI are rarely true
> 
> so we usually have to fall back to just registering every path
> separately.

Yeah, windows sends a register down each path like us too.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

