Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45661C19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660062106;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/jPhTLZAo6uLfzffyKGu1NvCE30AmiBwp28FGx4W+LU=;
	b=IHNLDx7iez0CNvZJXlekZWd7Gu/0pPAAS1ReLgqb/QoM1ThrhW+3/10mgVy/qg+NDKyj+A
	Pf5FFkleSbwMDM/BMIh2OJeufENuSU8B162mZrfz98vQ8XAAljCBYgh9p4Ilp3rJTYf9tg
	FMwbd6sTVDMLYHidM56EW5b782aSptQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-xwC9wR1RMzi4tA4UeD0XvA-1; Tue, 09 Aug 2022 12:21:45 -0400
X-MC-Unique: xwC9wR1RMzi4tA4UeD0XvA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8A8F1C06EDF;
	Tue,  9 Aug 2022 16:21:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C2781492C3B;
	Tue,  9 Aug 2022 16:21:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E09E1946A4C;
	Tue,  9 Aug 2022 16:21:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 785A71946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 16:21:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3230EC15BA3; Tue,  9 Aug 2022 16:21:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CF52C15BA1
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 16:21:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E644811E81
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 16:21:37 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-3noHQkbhMFKyK-prrBL9OQ-1; Tue, 09 Aug 2022 12:21:35 -0400
X-MC-Unique: 3noHQkbhMFKyK-prrBL9OQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279Efp7h020885;
 Tue, 9 Aug 2022 16:21:14 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hseqcpvh9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 16:21:13 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 279FwaDg011619; Tue, 9 Aug 2022 16:21:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hser2tsrn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 16:21:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4296.namprd10.prod.outlook.com (2603:10b6:610:7a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Tue, 9 Aug 2022 16:21:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 16:21:10 +0000
Message-ID: <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
Date: Tue, 9 Aug 2022 11:21:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
To: Keith Busch <kbusch@kernel.org>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
 <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: CH0PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:610:b0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 375141d6-0f57-48af-3ec2-08da7a232bc9
X-MS-TrafficTypeDiagnostic: CH2PR10MB4296:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TUcBSraMZKCYRs7gL+QrC7tp4gc1X19IGZA1hEGUaqGyQ9+8LCNPCCfHKHxnZhYza5WsXOsFI+eOVnv65BFiNj+JN+jY20A6an4i3S0GtMeeA9EmVbQphdzMdUBKkepoDTEpVbuqjxWXTm3DbB38cUSvliIpgVbXTQB+VhYolUJZgFVq1/L7QkuA0spwTyjRqErA1AdJm9Oa3koGpHeVJ/+gRIxar25w1evjwF4/bMm5mkxL2HyBW3CVyZTdWKJ8yFaQZFdgPEusmPt3vqcZ4MSN5N3fSG5Mnp9umN3FQEdTK0ptTjbhkL9v0bkXTRXOPYrmtNbNLqFFROJ1dmzsTujEolXLioELzrCpVKt4EQXOXi+jm4a5+h5z1n9u5QZJ5WnfN6nsKODnfdrU/I4uXMnzshat5BpcsrmLZkJP+MPsU3uEIwh9PQixdSVvbwgVTuBAan5RtJV440ZPpxNoa8RgJCN3uVIPwXxc3lhuQ7GpbJM8zjB05JsjnrTLz+toXPSfGsAcs+rS5oPQLldZBw22a3XjYHnxURq5nGQA1mSpoWBTrqmIcQ2D3FSHPGFHnVhls5Icmqfz2SDTdTKjyF86V9q2ZJGN6oaHK91H6ExrwC8H8t8znyZWWR4yj4lRayJjhB0HosQo+pOb3cgq4LArh6ziU08kbxn8d0P/Td5Gcm4anJm2Sk8cv5ZthESVpjR7HawwlRTnbkJb8UsAgr12KsYdU3jmFTlyBMH9LMQIph9MsyHgmMF0PvvoY/PWaY5B7vEg/6w52Ifr9PLYgYWyt987zLxe0+fRydsaa3NOq8N+3y6Chpdi+cfzs0bhMosQ5e3Ijv+XcmU0h8tCGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(39860400002)(366004)(346002)(396003)(7416002)(5660300002)(2906002)(36756003)(478600001)(110136005)(6486002)(316002)(54906003)(8936002)(31686004)(66946007)(53546011)(38100700002)(86362001)(26005)(31696002)(6506007)(2616005)(6512007)(8676002)(66476007)(4326008)(66556008)(41300700001)(186003)(83380400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmJ0Y0c1dzZxQTRUQ3YvVC9vLzlFRWUyanRaL1FBLzM3WmpoZXB4c3UzRStR?=
 =?utf-8?B?cmRDNkgvMzhHa2lEbzhibXJueFpydUdQc3RsMnI1UWpnUFVMZGl2VjlFRE11?=
 =?utf-8?B?b0JBZnJUR0gxUGdSa3Q2c1VyMnZXUEFwenhWYjJkaDd4b1pqaTRBMzJabVRn?=
 =?utf-8?B?VTJKdXBqVHBMTlNYS1M2cm9YQlBZVFUwRFREU1hOOHFXbEZ1QWhTY0JaN2J5?=
 =?utf-8?B?NVhUQmtTT0xYcEVjTSthVEYyU2hVVEpWNE92OWJ6a2dnZnBzMnVldFlyL0c4?=
 =?utf-8?B?QksvTy9iWGtWNzJuRmRacmUvTXc1aURzWmZ0dXYzZHVBeEliRHFXSGdVOERj?=
 =?utf-8?B?RDREZHVBUUJRRzRUMkRwMnhsTm1BSGtlWm9aQTJRK0NaTU9PbjhkNjBoYWNM?=
 =?utf-8?B?SEtFOE5BeU1NTTZSR1NWZnlBazBEVHcyTTVlWm0vZzR1SG1VZy92NXB1MnpD?=
 =?utf-8?B?TjhZUi9KV20zVHJybkJqRzYwK2Zsb0dPdlE2NDdHQXpjMHp5b3F2a1BhN2pn?=
 =?utf-8?B?dE5FUXlscnNGMk1udE9JemJQazJFREQzeEZpM1VEdFduOVZrbXVySENRdEN4?=
 =?utf-8?B?ZzdES09NYzBZQlBud3FrMnF6RCs1WGM4aFZFcTZ0RnUyTDFJdUJhblN1SkUw?=
 =?utf-8?B?Rnl2ZHpvUUlhZmtiMWYxZE5mMXRORW1yYVRFTXN2U29KSnJOVzhnQXBpSVdC?=
 =?utf-8?B?Ulh4N2o3WUFQOGxUTnh3TVBLYlAzMHVIL0J1cHgrcVdOUzNEWUNWdlFzVEV2?=
 =?utf-8?B?eFNGMkZVaGlXVXpKMHFqbVBtQURLRkQ3OERMOFZuZDM1bHdoOUV0WGljeWdI?=
 =?utf-8?B?R3U5ODUwKzJmN0Y5UUEzWFNlZFF0OC92UWFGQ0FJS01VM21JbTF5TVdvMDhn?=
 =?utf-8?B?eVVQR1lCbTRoQk81dHhyYUF4dWNQaFJsQkM4b3F3WlI1cysrVkRESkJqb3dT?=
 =?utf-8?B?Vm5pY1daWWhaV1BhcWNRZmErRVh5NzhVb3ZMYWVqVzhPNkNIYTQ0M1JJc2gw?=
 =?utf-8?B?azlYK0I1UlBmWUlvc0RDSEZmRldqNFpQKzJiSnpITjFCRHIwY1c2NnQxditY?=
 =?utf-8?B?NW15Mmx1UkY1RmRnNlVFMWVqMFA4R3hzb0JMbkdiY25aaVArazVuR0tEaWhy?=
 =?utf-8?B?Q1F1dkNwM2ZtN0JCUVdFUkIyMWcya0UrZ2Q4cEZUVlRxZEZMeEdod2tFRC8v?=
 =?utf-8?B?MklrSnlTQ2xJUjNqeXFEQ2pOU3NBZksydk5Xc1hwdGlSakhnOUFmZUdUTTdK?=
 =?utf-8?B?VXk0bTlVRE9DU0hweUZUWGRCOTYzRmlURWtwSlpBVStwd0xHMi9UOEg0VjRO?=
 =?utf-8?B?ek5jdVpwWXIxdmo3eHhzTW1hRk8xanhJcXNNbjBtVEowcWo2REVEVE9ZQktH?=
 =?utf-8?B?dndJakN0aUNWUHpTRXc0ckFlOHducFI5eU5qdDBPTXRMWmw4eVBZUFhEUVJW?=
 =?utf-8?B?cHAzUXRPSUxuY2lrT2djZk1UaXhTQXhpdFV5dWRxYUF4TENaaGpDdlgyei9Y?=
 =?utf-8?B?SHJlSWhqcTFvUUdkaXc5Y2JBRTljbWU0N0o5OG16bWJ4aHBzYXJmY3FBbTFj?=
 =?utf-8?B?Z1VUOW9oWk5aTHhoZkRtdHJJSU8wK1pFd244Y0czU0twVStpZkhDc2dabHg1?=
 =?utf-8?B?aXZJZi9CNm9CbjhXUm5pMjh5RC9Fb2ppZXdXY1VBSm5IUXVSZ25Rb2VPbW5T?=
 =?utf-8?B?eUlqVWd3eGZJcUx3dTVmSWIwOVlOd2NwTVl6dFdaazNzZDFBeW5nM1NERzVB?=
 =?utf-8?B?VWRkdXZnM1FabnovdC91WjQzRW45RXV6cFMxeGdFS0h4VzdVQ0t6d2ZTT05q?=
 =?utf-8?B?VW10RHJ6S3VpQ2NtMXZNT3hOWWxVS0gzSTdXSzVZYUh3YTFWNTFRWEdjUnpB?=
 =?utf-8?B?SDE1WXh1WmRqbEdkZ1MwNG8vSkl3N3lXZEcydWhPWTB5MUJBSmQ0VmFqRjRE?=
 =?utf-8?B?Wlc1SXhyQXJjbCtkS1FzbUVEdWxsS201emx5NmpYSFpOYVZVcDRZN01yWm1s?=
 =?utf-8?B?OXFzZFhBRnRSQjVSRC9BZmIvRlRaTGF2ck5McWtKbXlyWUNRVXJKQnp1Q2g5?=
 =?utf-8?B?QzNDOXl5N1R3eEtPbW45ejdadEZndmxpa2RDRTAzeTdqS0F6QThyc2p0c05p?=
 =?utf-8?B?KzZveTBzU2RCTXcwM1h5VnJ1aTBMTnBHU3k5SU1aSW5GcjBYRGlnOXVvdVNy?=
 =?utf-8?B?VFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375141d6-0f57-48af-3ec2-08da7a232bc9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 16:21:10.4493 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXDVVGP4dwae25D78xm4DyNn3XEFsIH3MqIl2rHTXo1lLhSIMsccILw3Zf8LmV3/ke7GtT0hPCf3UQGdI2IU7r0J82c172BZSkix8mDS9gQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208090067
X-Proofpoint-ORIG-GUID: iByAeZwuaQFpcJIUEzNXx5xjU8S9LoWh
X-Proofpoint-GUID: iByAeZwuaQFpcJIUEzNXx5xjU8S9LoWh
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 09/20] nvme: Add helper to execute
 Reservation Report
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/9/22 9:51 AM, Keith Busch wrote:
> On Tue, Aug 09, 2022 at 10:56:55AM +0000, Chaitanya Kulkarni wrote:
>> On 8/8/22 17:04, Mike Christie wrote:
>>> +
>>> +	c.common.opcode = nvme_cmd_resv_report;
>>> +	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
>>> +	c.common.cdw11 = 1;
>>> +	*eds = true;
>>> +
>>> +retry:
>>> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
>>> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
>>> +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
>>> +	else
>>> +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
>>> +					      data, data_len);
>>> +	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
>>> +		c.common.cdw11 = 0;
>>> +		*eds = false;
>>> +		goto retry;
>>
>> Unconditional retries without any limit can create problems,
>> perhaps consider adding some soft limits.
> 
> It's already conditioned on cdw11, which is cleared to 0 on the 2nd try. Not
> that that's particularly clear. I'd suggest naming an enum value for it so the
> code tells us what the signficance of cdw11 is in this context (it's the
> Extended Data Structure control flag).

Will do that.

Chaitanya for your comment, with a bad device we could hit an issue where we
we cleared the Extended Data Structure control flag and it also returned 
NVME_SC_HOST_ID_INCONSIST and we'd be in an infinite loop, so I'll handle that.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

