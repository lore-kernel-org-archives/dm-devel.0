Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310A5C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 17:33:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-rzdOP7jpPQ-CoqgmZWg6fA-1; Wed, 06 Apr 2022 13:33:02 -0400
X-MC-Unique: rzdOP7jpPQ-CoqgmZWg6fA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C320238008A9;
	Wed,  6 Apr 2022 17:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 70EE64029A4;
	Wed,  6 Apr 2022 17:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 325DC1949763;
	Wed,  6 Apr 2022 17:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6FA291949762
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 17:32:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32E544066CAB; Wed,  6 Apr 2022 17:32:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DABD407C943
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:32:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D616818F0264
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:32:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-VLbPr0n7N3WX9-k2RG0hdg-1; Wed, 06 Apr 2022 13:32:47 -0400
X-MC-Unique: VLbPr0n7N3WX9-k2RG0hdg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236FMiWY000752; 
 Wed, 6 Apr 2022 17:32:34 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3ssm3u-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 06 Apr 2022 17:32:34 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 236HHKY1032416; Wed, 6 Apr 2022 17:32:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97uvusea-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 06 Apr 2022 17:32:33 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BY5PR10MB4194.namprd10.prod.outlook.com (2603:10b6:a03:20f::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 17:32:31 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:32:31 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYSSYdGKTdETDbkEmdZR/SZY7Ic6ziWZ4AgADMqgA=
Date: Wed, 6 Apr 2022 17:32:31 +0000
Message-ID: <196d51a3-b3cc-02ae-0d7d-ee6fbb4d50e4@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <Yk0i/pODntZ7lbDo@infradead.org>
In-Reply-To: <Yk0i/pODntZ7lbDo@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 563668be-15c7-4b04-253d-08da17f36ddb
x-ms-traffictypediagnostic: BY5PR10MB4194:EE_
x-microsoft-antispam-prvs: <BY5PR10MB41940A3C0459728438D5771EF3E79@BY5PR10MB4194.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: g8sdYEbxWhoKjojwrfHFTOgKG+ELw/bgOgrSimEoUuVeh89j5oH6kqx0zMxKjJkHrFbDVJPsJtJ0B+zIZSmsLMUCL2pm7GT2d4sEF184wc9j2p9o9meJOachrxD5OiIQIzkjf1zh8IRnP/cbXnzl5aWcOYiOCy+0h9u9QdCltSHuqiMl19ZFowcn2afFq1WcZyHJkw0043WkMuZZYN6l9Cxd8JlerSljUcLtmOdBCGVFvPvs5PPoKpiO70hEjO5itkQzZSWjscD4jxwGb6AKAoEm4Kn10IwEoZDdDK/3/6tgY8BU2iC29w34eAobhOcXu/2mfE51+eXEb8Fzi05fBW06nnYNBKZuHNCSfW3XkdFtCdRu/qRbdD/oPxjMbT6W6dhX6gQbZgJET1dfA/92oWsGb0ruDx1ZlGbKmoDR+Mph1df7t2JTbfl14dFrj6OpUbrrczGomu5yJThdH9Wi0iUY7v6c1eNj9ifNRJoU0PWPSh5kR8FJXPScorpnAAKXXPvRcHCVzdB6df34pu5QA2hghV/n8Gfn5Bajj/uzVzfqY6uLMHIMjwRKh9hxuj65/wZ4Pg5P98FME/4zCOCw7PkbzcGXn+8X/jG3bKgeq/KYZcKpZQBtwrfwMCdyFtM/k813PjLWNvgnzvfWxVvB8/EwN65tqsSPr97NtYmzYlYzdBD4f8esCToAhrQonQDOdFW726AxAsn2FDjgdJzETO+cr2NFAd3E5DvSo0WyZGsb+fOz6e4JIJJJMT6UBgo914gB/N86XwzJwC3ckc1ubThP5i24yU2pZTDX2jGabjVyzWisweakJXe2qpspqg12
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(31686004)(54906003)(7416002)(44832011)(38100700002)(8936002)(31696002)(38070700005)(86362001)(5660300002)(83380400001)(508600001)(76116006)(53546011)(66476007)(64756008)(8676002)(66556008)(186003)(122000001)(4326008)(26005)(2616005)(66446008)(6916009)(66946007)(36756003)(316002)(6512007)(6486002)(6506007)(71200400001)(142923001)(43740500002)(45980500001)(309714004);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXhXV3F6d0lxK1lUNnQ2QjNlcENvS3I4Nnhqc3FoTTkrZ244VTl4YVJiUUFZ?=
 =?utf-8?B?VnI3UGU4dis1b2Fmdm5ZYlV4VjdGTDM4K1Y2T3U3dU5kRk9OenFjQUI1MGJB?=
 =?utf-8?B?SjRoaTZWMjBNYU5GOFRNbTZNZW9remY3c2xYT21MZThqR3ZsMzZ3Y0JIN1Js?=
 =?utf-8?B?elQwYWtDUDNPZThkN1MxVWRvZUM2dVJhSW5sQldpR0VuNm5hWmZyeWI5ZUVE?=
 =?utf-8?B?WjArNWF5ZU50WDFaVlNVMVQ3REZZT3VnRDlXenV6MWE0TVBaSXR4M1FVMnFq?=
 =?utf-8?B?TkVXNkhhOTFORzF6MlEybGFSdHBBaDJ6QkNDa3UyZHB0N2NnZE5QbVRFM3du?=
 =?utf-8?B?NFNpNUhOVUtMYmJYRkVrV1ZIU1o2QnlYU1VKeExDN0NjY0FhZXNYb21FT3dW?=
 =?utf-8?B?aUc2TDRWbTh4UkR0cmJDNGV0bElCbFl0U1lhQ2N2MllBMW8wLy93aWo1Nnp3?=
 =?utf-8?B?WG1nWVB3OHB5ZVdjSU9SVmtlNUkzNG11QWFJNncyaVc3WFNHRm9lcmNpK2lI?=
 =?utf-8?B?elRQeXJILzFaSHl5Z0VDcU1TRDNzcWttSjBMRlpqNjlUbGUreXZWbTBvUVMr?=
 =?utf-8?B?eTlCclJUd0dITXlQS1UxZDByM2dSTnFXakNSZjlNTDNEOXZ0aTkxMWF6d3VJ?=
 =?utf-8?B?Tmp1Q1V6U1VqOVRoTGwyR00xbnJBTjI2RVBCVjZsTEJYbmtabURHME8wdXZm?=
 =?utf-8?B?VENybGwyR0VEOTVqTWpEQmxCclRpNjZsMlg3NTlSYStWODNNeXpjQ0dDSXIw?=
 =?utf-8?B?VWdxOTFmRVpqZmpzeUx4S3FFOWZFb2IyaURKOHRhY00xT01TM1hDaktGc3lY?=
 =?utf-8?B?UVo5VjRSOEwrajAxN3VJQmE1QzBHbzdZMXVySmZvRkJyUDdUR3BWQ2VDRGdW?=
 =?utf-8?B?M2pvTDNKSFJ2U0pIbENSODJ6bFZGdmM5WGlyYk91SXI0UEFRRE9HWVBBbHN3?=
 =?utf-8?B?VzQ4TGJVaHdkb0FjKzVrOURnWkV4bDB1SjJzakFlR1gyS0QxT2wwWElhYlhw?=
 =?utf-8?B?eTAzUjFlS09BRFhsNTVzTUtycndUZU1JNGx6cTU4bDdpTnJMMzhvV01QbWEx?=
 =?utf-8?B?dUJzOE9Bai80cGx5ZkxMbWRnN0Q5MERWa0RlbDVPZGEwM1FDeVNqVGlqTEZZ?=
 =?utf-8?B?MEEwNk9tZ1p2ZXAxVHFUM3JDcVlXdkRjdnh3REtaVmFBMkJVckU1aHBleVp6?=
 =?utf-8?B?Vm5nT25wamMrMXVOM0EzUlc2WFVDZlc4c3RzLyttYlhkMnhNUlJPOU9EWWE4?=
 =?utf-8?B?TWJBQkFKSWNieDJpdWtBc0xieStxYVRMdTNMaFkveXJCYXhLQUpYdFNrcnk4?=
 =?utf-8?B?ZTR5Ui85bUdXNFdKeXFBK2RWVE13WGI4K0dGU3lWRjFDcVNhVCtYSThEeVZU?=
 =?utf-8?B?SkZTc3hESDd1ZlF3VmdyZTZWR0VzZHMzQVlKNUc2M2w3UmpCbmhrRWtFRGNV?=
 =?utf-8?B?YlY3QkxxZDdiZkd1UUMwRmV1MmlpVTZ3Tk5sc1pHS2tMTWlxTkI1c1ZFRGF2?=
 =?utf-8?B?a2RpamFTY1htM2pZWEcwY1pXRW9DT2hja3pNNVAvMVRqaHVhcGw2Ymt5bW9S?=
 =?utf-8?B?UGcvV0ZOR05OS3Qvb21HZW1sUldQSU5jZFFrVXJSQnRGVGJOK0ZuOXQxWENZ?=
 =?utf-8?B?UXR0ZG54Z0xBWjJZcktGVWxjWkJuVTg0dm96WXYrTncvdXJ0b0RscWl1b1Rv?=
 =?utf-8?B?NCtEUjVSOGtBbjR0TEc5ZEh2T2FyVjQyanVBbmNHUDJrN2NneFVqV0p4MHBz?=
 =?utf-8?B?ay9ZWlQ3K292c094UHBDZnlBcE05NmUxSjRuSzdEcFpyNEtRZ3Q0NTVnYmlS?=
 =?utf-8?B?K084bWNVZHJHVFJ0YitHR25zZEk2RmU4NTF4L0F5eHFiNnZ3YlNCdHN5UXNR?=
 =?utf-8?B?Y2p2RU5yWkdFYlhQUlhuNzdMRWlmSmxybFNzZytFOE1hYTR6STZsVUp1Ly9m?=
 =?utf-8?B?NUo5U2lYL3lXNVJmeXBLWjNzMThwRHYrSzIvcWFxZ2pJT3dzdjBSc2lUY2NX?=
 =?utf-8?B?SWFUWjlKT2FudUptV1QrVXpBVFBxSFNQZWhQQVI5Q0ZCM0xQTkx1ci9OSEh6?=
 =?utf-8?B?VjY0ajZJa1cySkxNT1ZuUitzUks1ZHVWQzA1c3RLSVBDa2hUWWZReTRtOTNJ?=
 =?utf-8?B?UEJKZUVPSTRMaEwxZE1nNmd4VXFxUDhHYWVndEVuVDVlSFJ3UEFPZDZpam1E?=
 =?utf-8?B?d2ZEem5IU2RaazU1VjZCWXZIcCtBUjhJdGZ4WXd2cEhKLzlUQmVYbDNpb09G?=
 =?utf-8?B?OHMrSVgrUzN3MkJlSEJGbDRramxncjdGNDZiSVJRcmNaMUZxSTN2S0VQT2c4?=
 =?utf-8?Q?2jE2GOPyk4Sw5Vhyql?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563668be-15c7-4b04-253d-08da17f36ddb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 17:32:31.2354 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ym3ROX5nIyO2TpcLHD12r6u+QVi97T7su5B3Y59fynUDRWOeZ0cCjEY9LyOO65WButGWNh37jeRdUscZKsfidQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4194
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_09:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060086
X-Proofpoint-ORIG-GUID: AttF8cHDVPgj3B68s1M8SyLakEdJNySz
X-Proofpoint-GUID: AttF8cHDVPgj3B68s1M8SyLakEdJNySz
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D25894A0F59B9B4EB755458807B215CD@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/5/2022 10:19 PM, Christoph Hellwig wrote:
> On Tue, Apr 05, 2022 at 01:47:45PM -0600, Jane Chu wrote:
>> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
>> not set by default in dax_direct_access() such that the helper
>> does not translate a pmem range to kernel virtual address if the
>> range contains uncorrectable errors.  When the flag is set,
>> the helper ignores the UEs and return kernel virtual adderss so
>> that the caller may get on with data recovery via write.
>>
>> Also introduce a new dev_pagemap_ops .recovery_write function.
>> The function is applicable to FSDAX device only. The device
>> page backend driver provides .recovery_write function if the
>> device has underlying mechanism to clear the uncorrectable
>> errors on the fly.
> 
> I know Dan suggested it, but I still think dev_pagemap_ops is the very
> wrong choice here.  It is about VM callbacks to ZONE_DEVICE owners
> independent of what pagemap type they are.  .recovery_write on the
> other hand is completely specific to the DAX write path and has no
> MM interactions at all.

Yes, I believe Dan was motivated by avoiding the dm dance as a result of
adding .recovery_write to dax_operations.

I understand your point about .recovery_write is device specific and
thus not something appropriate for device agnostic ops.

I can see 2 options so far -

1)  add .recovery_write to dax_operations and do the dm dance to hunt 
down to the base device that actually provides the recovery action

2)  an ugly but expedient approach based on the observation that 
dax_direct_access() has already gone through the dm dance and thus could 
scoop up the .recovery_write function pointer if DAX_RECOVERY flag is 
set.  Like bundle action-flag with action, and if should there need more
device specific actions, just add another action with associated flag.

I'm thinking about something like this

    long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
                           long nr_pages, struct daxdev_specific *action,
                           int flags, void **kaddr, pfn_t *pfn)

    where
    struct daxdev_specific {
	int flags;	/* DAX_RECOVERY, etc */
	size_t (*recovery_write) (pfn_t pfn, pgoff_t pgoff, void *addr,
				 size_t bytes, void *iter);
    }

    __pmem_direct_access() provides the .recovery_write function pointer;
    dax_iomap_iter() ends up directly invoke the function in pmem.c
      which finds pgmap from pfn_t, and (struct pmem *) from
      pgmap->owner;

In this way, we get rid of dax_recovery_write() interface as well as the
dm dance.

What do you think?

Dan, could you also chime in ?

> 
>>   /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
>>   __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>> -		long nr_pages, void **kaddr, pfn_t *pfn)
>> +		long nr_pages, int flags, void **kaddr, pfn_t *pfn)
>>   {
>>   	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>> +	sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
>> +	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
>> +	struct badblocks *bb = &pmem->bb;
>> +	sector_t first_bad;
>> +	int num_bad;
>> +	bool bad_in_range;
>> +	long actual_nr;
>> +
>> +	if (!bb->count)
>> +		bad_in_range = false;
>> +	else
>> +		bad_in_range = !!badblocks_check(bb, sector, num, &first_bad, &num_bad);
>>   
>> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
>> -					PFN_PHYS(nr_pages))))
>> +	if (bad_in_range && !(flags & DAX_RECOVERY))
>>   		return -EIO;
> 
> The use of bad_in_range here seems a litle convoluted.  See the attached
> patch on how I would structure the function to avoid the variable and
> have the reocvery code in a self-contained chunk.

Much better, will use your version, thanks!

> 
>> -		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
>> -				&kaddr, NULL);
>> +		nrpg = PHYS_PFN(size);
>> +		map_len = dax_direct_access(dax_dev, pgoff, nrpg, 0, &kaddr, NULL);
> 
> Overly long line here.

Okay, will run the checkpatch.pl test again.

thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

