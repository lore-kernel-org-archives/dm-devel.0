Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A23BC43334
	for <dm-devel@archiver.kernel.org>; Tue,  7 Jun 2022 07:16:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-A_fhYw5xOD-QucRmSE7V1g-1; Tue, 07 Jun 2022 03:16:52 -0400
X-MC-Unique: A_fhYw5xOD-QucRmSE7V1g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C340A858EED;
	Tue,  7 Jun 2022 07:16:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2578140336A;
	Tue,  7 Jun 2022 07:16:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D954319452D2;
	Tue,  7 Jun 2022 07:16:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E880194706E
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Jun 2022 16:57:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0A796C27E92; Mon,  6 Jun 2022 16:57:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 052A5C27E8F
 for <dm-devel@redhat.com>; Mon,  6 Jun 2022 16:57:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA7803C41661
 for <dm-devel@redhat.com>; Mon,  6 Jun 2022 16:57:29 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-fS0zdyyjOlaKfSf0bXEzzw-1; Mon, 06 Jun 2022 12:57:28 -0400
X-MC-Unique: fS0zdyyjOlaKfSf0bXEzzw-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256FTlAH000558;
 Mon, 6 Jun 2022 16:57:20 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyekbkkx-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Jun 2022 16:57:20 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 256GLtra007984; Mon, 6 Jun 2022 16:38:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3gfwu1un10-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Jun 2022 16:38:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5753.namprd10.prod.outlook.com (2603:10b6:510:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 16:38:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 16:38:04 +0000
Message-ID: <d7355a7c-9587-5658-44c7-09143abe09a7@oracle.com>
Date: Mon, 6 Jun 2022 11:38:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
 <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
 <09be5981-705a-5c82-a189-dd7f0475d227@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <09be5981-705a-5c82-a189-dd7f0475d227@acm.org>
X-ClientProxiedBy: DM3PR12CA0105.namprd12.prod.outlook.com
 (2603:10b6:0:55::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f81599c-f3ed-4bb1-c5cf-08da47daeda9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5753:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB57539C35C1E5365499BE9D86F1A29@PH0PR10MB5753.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: nSlMRIeBRBN51GQ4blwUVDwiZhH8E08tjwsdm/Uk+lGTdFQl40XL3JojK+KPemXU0Vv0eLrAgNGHQWn9B2Ly4dp6SsUxriIiZFva7q4JVJ5btmm8/gErYFEYHdP5PGiif2X1Th2VG1aVgRxemDFjj3g3WtAE+WxsDB08TXqNq0J9y5VFjvvqroLgQhI5ljehpbEVb0zSYx1lmU0GAUggQN1O94hfzOmE3N+Wf8fsPapPPMO7pmm1kN9FxrjOqS5Qs2WtD0sHX2EHOrK3uFUBkDNDAFXP2756cAZyMXgd7Q4IqdvzdHVOcrhhlthnrQOcMkU7BtSV21UFU9o3VO+3LAgA2b0sjQx6sI42V6fZXTio3aRC+0Uj15emXLRNU00wNhOHDEps6xUJhaJYIgt1nxqrLUoMGUtWg1dq76yA4O+3bRi0lPPZEN4yEdjmavWEYOZV5Yee1/uqKKsuB41nceelJC5ZRQMwVHmxrqHQ6G/INSGe1vumdKE8LxBi0UKD1/ffrqYEnJEKkuOMh0XBXEAGDHRtl5zWaYougBbE0d9S8NK3clS6qAitWynvvlk6DlOFJXddFViCCnDMzW/D4a8kBPjK0tNFjuU3Ogpc1JykHm2a4HivSYcsxbRt+MFWO9ei5sPK+BrX7GQK90na15TdBkM+XpI2y22fv09PZIbI479Lqmi8ydkoHSJNhgCTY7zcP2FtN+IMOvTJ7+7Hb2NZ6+qntbqW2pMyv3Hm3CuGyDOIxWLTvvhfPqwellxL
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(86362001)(31696002)(508600001)(6486002)(186003)(38100700002)(921005)(26005)(53546011)(6512007)(6506007)(2906002)(5660300002)(4744005)(83380400001)(316002)(36756003)(8676002)(2616005)(31686004)(66476007)(66946007)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUk5VFNQZEYzV3MybUp5b3FYRnhGRmQyQWZhQmZUL0hhbW5BUWJIeW5HM0sr?=
 =?utf-8?B?ZnJEOHVhTStNcWlsS1lidU4rUFlBNkd2WXhTejBrRStzdm82dDE0MndJY2JE?=
 =?utf-8?B?ajM2eFlLejcyemdKSXFYVU44NHl5STF1bVBnbDNjTWFyOFl2bHlrQ0ViK3M1?=
 =?utf-8?B?Zk9tbWpVOWxxaVpOb1JqWTBkc25CVVJwenRtQWNQUVQxd2lRckxpNVQwRE5X?=
 =?utf-8?B?TW9Mc3g5TVJHbUNjN0dJQlFsZm1uTlkxbHhXci8vdTE0THBhSmVnYUJheVFZ?=
 =?utf-8?B?ejZieE1RRGFnOVRYNlgzM0pxMEI1WXJpbEhoS2lJbkhsOUNzSi9IV3hRdlVM?=
 =?utf-8?B?OFEraC9yNExXZmFHVHI2UUszdEs3VlcvRk1XQndMZk1HMTJDZkg4YnVZcnVs?=
 =?utf-8?B?Q0dOclJSMDZCOTlQY3didG5yNlVpWmVGMSs5a1BDZkhNUzNqVHEvbDlOTEtw?=
 =?utf-8?B?cDFjdi9CK3ZCL2MyNnJWVnRWZnRrNnhCRExoNEgrcFRVRWhxcWJPc1ZBQ0I5?=
 =?utf-8?B?YmxYRXU2Zmo4c0dNVjFydnJOZ29lS3FZbTNOVUFFdWhwc2FMMGFIdU4xd2h5?=
 =?utf-8?B?NjFydFJudWdRODBDQUFRZlVJK01Bd3MxTWEvTTQ0L05OMDh1dUxQNnZiUkNv?=
 =?utf-8?B?V2hnSnZyQlMzQTZhanBRSjcvbUpzc25rSm5aODJybUFJR29CeUJLMTh1dlVH?=
 =?utf-8?B?Y2I1MGozL1JaWXg4Q1Ureml5eHBQN0RlRCtkVmZlTmJOZTdQN2lxTzZWbXhi?=
 =?utf-8?B?U1pNYk9HK0p0ZER0U2t6d3Y3Q3FvNzc0QW9DQnMzQkhNL2NubFY0aGlNVXBz?=
 =?utf-8?B?Z08xcTYzUGtCc0VZQTV2MVJ3WWFZYm50bHJyM2FNY3JZekRLWitsUE1GNWlS?=
 =?utf-8?B?VExZdHNUTjJKRnUwSml5VDVQOEFCc0MvUGV4ejNQWFFVZ3E2UzVTWVp1S0Rt?=
 =?utf-8?B?UGloaElGKzRGR1F0V1BhUkdrdlBpcEJWWDZkQ2FDL1BTbjVUZ3pyRXlKSytm?=
 =?utf-8?B?N2tHU3ptR0VDaVBlTGpQQXR1c3BJRU8zT1FPZFl0ZmtJTmVzMXFFREtXS0RU?=
 =?utf-8?B?VDlqVGtvczQxd0VEM01jb3hBTDZocWJKQTJnYS9UTFpoNVc3V2VnZHMyN21w?=
 =?utf-8?B?cWlLQnMyL2lQdERxaVFvdkNnWk9lQ3R3Zi9vNlMvUlFGYitieWNqeS9kKzZa?=
 =?utf-8?B?MlV3UHNlTFQ1eVowTjVVUnFFb2x2T0ZYVGpwK0pzRlo5SHUvdHVjMHNmdTdB?=
 =?utf-8?B?RnhGMmdIWlZlaUxadTBlT2dIdVZqOWwxYmVmTjlMUGV3YmYweXprQzgyVmJs?=
 =?utf-8?B?RUFsc3RoZmNIdG5pRXFRNXV1T0Z6V1d0K1pBdEI5Z0o5VytpUGtQYXlJMUgz?=
 =?utf-8?B?c2dDaXRpWDAvclUxZmtIYXdaR3JPakJDLzZRZHMwL1pMK2ZrSDdUZUlQTDk0?=
 =?utf-8?B?Nk9uRjNCSERnbnA1a1VsNThwd2hKOTdIdkRZNlFxd091Y1M3N2svTWxDMVh4?=
 =?utf-8?B?Ri9XeVRBcDIyU1d6a2RMa0c5K1ZNQmE1aWR0R00wdDBOdlJsS2xBTGNIRGNC?=
 =?utf-8?B?RDRtMXJBNU9tS3ZIcWttRENUOXM1WkZteUd6UksrakdWQWR6cDA5YzF6OFkz?=
 =?utf-8?B?UTlNUHliSlh3b2xFM3JQZzgrTW1kcW1CNUpYOEUzeEEyYnZ0SkQ0eU03WGw5?=
 =?utf-8?B?dGtxZit2T1NtQUd3N21oMUJPVXJ4NHFkL1VXcmllYjh0TzRZV2JVdDlIdmdZ?=
 =?utf-8?B?cXp0UzNDWStKRGI5VU83MTNWSHNiMTBaZzhsWm1oMkdUNTQzcWNBUTZ5a0ZZ?=
 =?utf-8?B?VFhicnBIRmVBU1FPNzJSQWE1enhrWTVmaXpTZC9tOFd4Z1oxb3NwNmtxRTZE?=
 =?utf-8?B?Yjl0RGtQZ2Y1NWZPTFVsV29BV2VFTmFyY2dvMlR1cjc3Wm9JcVpQWXpFMGxk?=
 =?utf-8?B?SnZVdWpTYWVzaVNIelI0d2dFSzJ6Y0NvMHVGd1ZiNnJBWUpaWDJvS0Qwc09r?=
 =?utf-8?B?cVVGMnJRclNhaXdqMVNidFYvcUZTdXV0WmJvUDIvaDZOT2k2VEpiemc0TEph?=
 =?utf-8?B?Nzh3NWZ4L2tFSkk3TXFoMDlweDNQWDd6Z2wzQUVXODREb2lvcWkxRXoyTjdO?=
 =?utf-8?B?aFVMS1hqdkl2RXR2SWZYa014TTI3ZzhBK0tIUFloemRhQmM2L2NsUGl1QUxC?=
 =?utf-8?B?S3pKMzUzOVhxYnVFamMyWVN0NmlrYTljdHVhQ3R2RjYzekVRMVBMN2s2NGxV?=
 =?utf-8?B?dWdRZUhzTmlvUDgrbERDT3R0MU1zcmI3aWFRRDFtM1FKS0U2RFRxQmFEcDhx?=
 =?utf-8?B?cUc3bTcvenl3U1p1SXluRXR4QW13Y1ZIUlhwUFN2ZmF4UWVBSHF6MWlMcFhX?=
 =?utf-8?Q?yHfzoG9KeWzqhdPo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f81599c-f3ed-4bb1-c5cf-08da47daeda9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 16:38:04.5396 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ul+uTNxWh3l3IuHjKexbxECvV90VgYo5tv59GKhWrJyoAqidmN8RqlueGzkm3xkHKTI2Cl5AmEAsHMvGgYUeoKHmkRgXEUBQszMr/7Qo1uI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5753
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-06_04:2022-06-02,
 2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060072
X-Proofpoint-GUID: npGOz1lv75vJPLW_suEuYXrSdyPo14fc
X-Proofpoint-ORIG-GUID: npGOz1lv75vJPLW_suEuYXrSdyPo14fc
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 256FTlAH000558
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 07 Jun 2022 07:16:47 +0000
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNi81LzIyIDE6MTUgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPiBPbiA2LzUvMjIgMDk6
NTUsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6Cj4+IGxpYmlzY3NpIGlzIG5vdCBzdWl0YWJsZSBmb3Ig
dGhpcyB0eXBlIG9mIHNldHVwLgo+IEkgdGhpbmsgdGhhdCB0aGlzIHNldHVwIGNhbiBiZSB0ZXN0
ZWQgYXMgZm9sbG93cyB3aXRoIGxpYmlzY3NpOgo+ICogQ29uZmlndXJlIHRoZSBiYWNrZW5kIHN0
b3JhZ2UuCj4gKiBDb25maWd1cmUgTElPIHRvIHVzZSB0aGUgYmFja2VuZCBzdG9yYWdlIG9uIHR3
byBkaWZmZXJlbnQgc2VydmVycy4KPiAqIE9uIGEgdGhpcmQgc2VydmVyLCBsb2cgaW4gd2l0aCB0
aGUgaVNDU0kgaW5pdGlhdG9yIHRvIGJvdGggc2VydmVycy4KPiAqIFJ1biB0aGUgbGliaXNjc2kg
aXNjc2ktdGVzdC1jdSB0ZXN0IHNvZnR3YXJlIG9uIHRoZSB0aGlyZCBzZXJ2ZXIgYW5kCj4gwqAg
cGFzcyB0aGUgdHdvIElRTnMgdGhhdCByZWZlciB0byB0aGUgTElPIHNlcnZlcnMgYXMgYXJndW1l
bnRzLgo+IAo+IEZyb20gdGhlIGlzY3NpLXRlc3QtY3UgLWggb3V0cHV0Ogo+IAo+IMKgwqDCoCBp
c2NzaS10ZXN0LWN1IFtPUFRJT05TXSA8aXNjc2ktdXJsPiBbbXVsdGlwYXRoLWlzY3NpLXVybF0K
PiAKCkFoIEkgZGlkbid0IHNlZSB0aGF0LiBJbiB0aGUgUkVBRE1FL21hbiBpdCBvbmx5IGRlc2Ny
aWJlcyB0aGUgbXVsdGlwbGUKaW5pdGlhdG9yIG5hbWUgZmVhdHVyZSBmb3IgbXVsdGlwbGUgc2Vz
c2lvbnMuIFRoZXkgZG9uJ3QgaGF2ZSB0aGUKbXVsdGlwYXRoIGFyZywgc28gSSBkaWRuJ3Qga25v
dyB5b3UgY2FuIHBhc3MgaW4gdGhlIHNlY29uZCB0YXJnZXQuCgo+IERpZCBJIHBlcmhhcHMgb3Zl
cmxvb2sgb3IgbWlzdW5kZXJzdGFuZCBzb21ldGhpbmc/CgpJdCB3b3Jrcy4gVGhhbmtzLgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

