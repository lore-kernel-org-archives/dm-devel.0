Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDF6C432BE
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:57:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F2FF60F39
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F2FF60F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461--OHxrmDjM9-Fw4e5lCwbwA-1; Wed, 18 Aug 2021 03:57:05 -0400
X-MC-Unique: -OHxrmDjM9-Fw4e5lCwbwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF6A6101C8A8;
	Wed, 18 Aug 2021 07:57:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB58C6A8FE;
	Wed, 18 Aug 2021 07:57:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A07534A7C9;
	Wed, 18 Aug 2021 07:57:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17I69Dgo017681 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 02:09:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E0C1200ACFF; Wed, 18 Aug 2021 06:09:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 241FF2124212
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 06:09:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD5D866DF4
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 06:09:06 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-107-r5qaURprNT6uG_igxXdDkA-1; Wed, 18 Aug 2021 02:09:05 -0400
X-MC-Unique: r5qaURprNT6uG_igxXdDkA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17I62dc4003684; Wed, 18 Aug 2021 06:08:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3afgpgnnsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 06:08:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17I6150H166766; Wed, 18 Aug 2021 06:08:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
	(mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
	by userp3020.oracle.com with ESMTP id 3aeqkvkcdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 06:08:46 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB4656.namprd10.prod.outlook.com (2603:10b6:a03:2d1::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16;
	Wed, 18 Aug 2021 06:08:44 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7%5]) with mapi id 15.20.4415.024;
	Wed, 18 Aug 2021 06:08:44 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
Organization: Oracle Corporation
Message-ID: <78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
Date: Tue, 17 Aug 2021 23:08:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
X-ClientProxiedBy: SA9PR10CA0019.namprd10.prod.outlook.com
	(2603:10b6:806:a7::24) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.159.249.154] (138.3.200.26) by
	SA9PR10CA0019.namprd10.prod.outlook.com (2603:10b6:806:a7::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18
	via Frontend Transport; Wed, 18 Aug 2021 06:08:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f3c103-1c0a-4671-0720-08d9620ea270
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4656:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4656345C8FD784CF7E57C06BF3FF9@SJ0PR10MB4656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: h8wnMyFzjnYSt0obBV+rMMwdvCiBAettySHs8CcyQNYIAh3vz27YVZJkaF8TYkKWsZBZ5yytw/biALMt69VqzClj3eDAJiaU6WHV94BH3sgRR4hPz7V1ZfLtX62/J7hXqfNF7kH7iRdiCx6rjgKVHJ5ez7cM5VPcQEm86mbrH9I9HdwUoW3E3fsZDCwVz7EsRK4RTEA/s07rg287tLyDQSzIq/kBYH4uMt18PSZYwR6c0FF+s2lbhugEvKrzOtW+hS9sq0h76aDRBHrh3y5+fWAjylaVIh9xDae4dZLHmqlktpWVLjKm0dnWPkjVKh4uxnP0w7BGnx8n7wKDHZBeW5Z/L5eT1+mjXlvdGqUPZ3XpFiUZyZkvx7dohpQ9blQ0kyjVPGHSk6h9MvWjBZpk8l+BHZVrkAosRtwmzaVshK9vXzFEhgiKNFbOAbDssN72uiU2G2BhNT912a4LAf0s14hA7ZwAI5Y38cxU1n2omCxJs/8xXPfWeHntlNG3jHkz9E15qjsHDiR8avHkwIAZgBnYy4qIqxVNvxirffIoi8FMhGCo42TBBRmKHJvi4WHkcP5FMoWJ/+gEWkSGiwIodHw6ckVp4+65eIQx84SSX1slvCfOBDVKPLcJSK4eDVhLoAmNthzhmJjYHjI4TPslpXB/1j16iRk7y2C95NrQD51YsB5f3o4a9vyMNkn1oOD5+K/SwnGy94wqsqoBczSljTWnRVlVMC8gLWDTJj2eKC8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(86362001)(36916002)(66946007)(7416002)(8676002)(4326008)(44832011)(66476007)(26005)(66556008)(508600001)(8936002)(5660300002)(6486002)(36756003)(2616005)(16576012)(31686004)(2906002)(316002)(53546011)(38100700002)(83380400001)(956004)(31696002)(186003)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDhJTDlxMVFCMVczUWsxVlhwYmpRTlpvNjZSUW44VEpSaE1sSkFMNk81U3d0?=
	=?utf-8?B?N0FMSlZkaUQ2ekh6WEpsUkpNL3BFa0JhS0RuSEFtOWNxOGFSY01IaEFza2Z6?=
	=?utf-8?B?VzlwS2RLTmFydnZGNm9GNEdLYTdPSnVpOE5QLzc3SkVCaVBaZy9ScFVZdm9q?=
	=?utf-8?B?bVFzRDV2d0JtNVdjb095NnhXQVRBRExNNUlSZ0N6T2YrMk1TcXY0eGhUbVBC?=
	=?utf-8?B?YzJNSEk1eXlrT0N3bWJ5TytIR3JQVDBxOG9DVERjcXEyZEtMbk5WdHdZaVEr?=
	=?utf-8?B?WU56eERxd0xrUTZWR2dJbDAxSWthNE9PYWFaS3J3a05qQTZ2MGJ5MU5JK1RF?=
	=?utf-8?B?T0p6ekhoMXlNVkg0ei9FOW5mSzl3bDVkSVRLNVg0WWJIbUJ4cUZ1Y1hEaXhH?=
	=?utf-8?B?NmY3MEM1YXJlS2tLM1ZzS1BiWWZWUFJTc2hIRWJMd3A1ZHRaZWpPWTd4blRU?=
	=?utf-8?B?alR1Y3dlU251V3RjYUJTcVNtZndIWFFBYmVUcXJsN1YvRUU3SVV1cVNMek9F?=
	=?utf-8?B?cTQzSzhRaElybDdpRjJnRUlKM0tWcnJLUVFrVlVXUElhN25jN1lmTzB1cWxW?=
	=?utf-8?B?cXVwbG82V0kzbVNVT05Ic01VQy9MbThUeHM4aW9aODI0dEs2MXUrUHZzK1RF?=
	=?utf-8?B?dTViWGVzL0FFNDYrNlpicVpqNjlnMERGdEQ1cWx0ZlZwSFQ5ZWxFQTBiN1hD?=
	=?utf-8?B?UituOU40N21zdHgrbktLRWJQYnlyQSs1cWE5TnRUN0gybXQ1akJjTTlQeXRz?=
	=?utf-8?B?eDZkMWtDcTRoN0JqWU9PWXViMVpnMFljWkVXcDFpTE5hd3dCdEQxNTZhcEtF?=
	=?utf-8?B?TVMraElEVFNiaDl5NE5xWCtvdDRUSzhIZ3c2UXI0ME9GYitlR1lCQXJuemJD?=
	=?utf-8?B?Zng0T0NZYytCZld3ejVLTklYbndyS2dmbHIybS8zd2JGQUMyZVRmcy9SNFI5?=
	=?utf-8?B?cDgzY1BPWXBhSXk1NCs0akJjM1JEdFNMMnVpZDJNamFCWGVJQXlwR1BvZDdK?=
	=?utf-8?B?Zm1wNG1IUlBNMHA4ci8xdWVhU3Fib3ZhZ1hsamtuQjJWMFJycXR4dTkrb0Jq?=
	=?utf-8?B?UmttZGw5UDFvNjczSVlPcGFrWlVBbjVXZFpLRHEwTEQ4cG9WU3Y3WEpLemlv?=
	=?utf-8?B?ZFNYc2grYjVDWFowS1pzVlVMMkMvVExhZXJrMzF1c1FiTzdaYS9hYWg3OUx6?=
	=?utf-8?B?OVBWeTFkVG5ZOTgxRjFFWmRXY2VPb0d4K3pDVmhWUHVPUWpaNDRoTlhqSUZD?=
	=?utf-8?B?M3dOaU5TdlNwMjZPQ2NJNWthSUJyUG1yV1EwamRNQklYcnJSc2dPcS9TcUxo?=
	=?utf-8?B?eVliWjdjUEphZVB5eUQwQWovRTVWZFJNV1RCWmVUMmlDL0RpTXkrNE5QQUtH?=
	=?utf-8?B?TUZpNlNyVyt6TTljSER4b08vaHFRRE9CalR1WEQ3anlLWUVIdkxtSlBIeUx5?=
	=?utf-8?B?ZW8vZ1BZNEVNeEV1OFUxQjhyU3RYSG5VZGo0aFJscEJ2YVVBeGdTKzJzN21M?=
	=?utf-8?B?WVUrMjJ0Myt3UUlxRWtKVE1kU2NKa1M4YUJQT0FGOGMvTzBlbkRvMnVtR3lN?=
	=?utf-8?B?QU4vNFZncnQxSTQ0Nk96UVRESzlZV05HS2dYZFZRREtJa2tMd003MmdybGhE?=
	=?utf-8?B?SWVIVVJjSGRxWjRjTy81TFc3dFQzWDAvWWp4Z1NKcnRDaEdwcnREdEpmcFZI?=
	=?utf-8?B?cFRnOElmYldyUkdPY3JzNWVySS9xRVdiekwxUmdSQ3dGQ2NBUE5za1ppTkJk?=
	=?utf-8?Q?OjHhLpQAuIGPxGqDqOt6iF45Rwn1sd3EklCYXZ4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f3c103-1c0a-4671-0720-08d9620ea270
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 06:08:44.5563 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +J4+0tNW8f+jODfD80tvOTBn4gZvwWlzyBJj8xdzqstDfuAsK9xglAZRaZrAs/HkI3jAvzicxIvdFvsQdhy1ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4656
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 malwarescore=0
	mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180038
X-Proofpoint-GUID: IIrNvFR3-VYflODdUfnxvCD7PloUGzMs
X-Proofpoint-ORIG-GUID: IIrNvFR3-VYflODdUfnxvCD7PloUGzMs
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0b-00069f02.pphosted.com id 17I62dc4003684
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17I69Dgo017681
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 18 Aug 2021 03:56:53 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, david@fromorbit.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDgvMTcvMjAyMSAxMDo0MyBQTSwgSmFuZSBDaHUgd3JvdGU6Cj4gTW9yZSBpbmZvcm1hdGlv
biAtCj4gCj4gT24gOC8xNi8yMDIxIDEwOjIwIEFNLCBKYW5lIENodSB3cm90ZToKPj4gSGksIFNo
aVlhbmcsCj4+Cj4+IFNvIEkgYXBwbGllZCB0aGUgdjYgcGF0Y2ggc2VyaWVzIHRvIG15IDUuMTQt
cmMzIGFzIGl0J3Mgd2hhdCB5b3UgCj4+IGluZGljYXRlZCBpcyB3aGF0IHY2IHdhcyBiYXNlZCBh
dCwgYW5kIGluamVjdGVkIGEgaGFyZHdhcmUgcG9pc29uLgo+Pgo+PiBJJ20gc2VlaW5nIHRoZSBz
YW1lIHByb2JsZW0gdGhhdCB3YXMgcmVwb3J0ZWQgYSB3aGlsZSBhZ28gYWZ0ZXIgdGhlCj4+IHBv
aXNvbiB3YXMgY29uc3VtZWQgLSBpbiB0aGUgU0lHQlVTIHBheWxvYWQsIHRoZSBzaV9hZGRyIGlz
IG1pc3Npbmc6Cj4+Cj4+ICoqIFNJR0JVUyg3KTogY2Fuam1wPTEsIHdoaWNoc3RlcD0wLCAqKgo+
PiAqKiBzaV9hZGRyKDB4KG5pbCkpLCBzaV9sc2IoMHhDKSwgc2lfY29kZSgweDQsIEJVU19NQ0VF
UlJfQVIpICoqCj4+Cj4+IFRoZSBzaV9hZGRyIG91Z2h0IHRvIGJlIDB4N2Y2NTY4MDAwMDAwIC0g
dGhlIHZhZGRyIG9mIHRoZSBmaXJzdCBwYWdlCj4+IGluIHRoaXMgY2FzZS4KPiAKPiBUaGUgZmFp
bHVyZSBjYW1lIGZyb20gaGVyZSA6Cj4gCj4gW1BBVENIIFJFU0VORCB2NiA2LzldIHhmczogSW1w
bGVtZW50IC0+bm90aWZ5X2ZhaWx1cmUoKSBmb3IgWEZTCj4gCj4gK3N0YXRpYyBpbnQKPiAreGZz
X2RheF9ub3RpZnlfZmFpbHVyZSgKPiAuLi4KPiArwqDCoMKgIGlmICgheGZzX3NiX3ZlcnNpb25f
aGFzcm1hcGJ0KCZtcC0+bV9zYikpIHsKPiArwqDCoMKgwqDCoMKgwqAgeGZzX3dhcm4obXAsICJu
b3RpZnlfZmFpbHVyZSgpIG5lZWRzIHJtYXBidCBlbmFibGVkISIpOwo+ICvCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVPUE5PVFNVUFA7Cj4gK8KgwqDCoCB9Cj4gCj4gSSBhbSBub3QgZmFtaWxpYXIg
d2l0aCBYRlMsIGJ1dCBJIGhhdmUgYSBmZXcgcXVlc3Rpb25zIEkgaG9wZSB0byBnZXQgCj4gYW5z
d2VycyAtCj4gCj4gMSkgV2hhdCBkb2VzIGl0IHRha2UgYW5kIGNvc3QgdG8gbWFrZQo+ICDCoMKg
IHhmc19zYl92ZXJzaW9uX2hhc3JtYXBidCgmbXAtPm1fc2IpIHRvIHJldHVybiB0cnVlPwo+IAo+
IDIpIEZvciBhIHJ1bm5pbmcgZW52aXJvbm1lbnQgdGhhdCBmYWlscyB0aGUgYWJvdmUgY2hlY2ss
IGlzIGl0Cj4gIMKgwqAgb2theSB0byBsZWF2ZSB0aGUgcG9pc29uIGhhbmRsZSBpbiBsaW1ibyBh
bmQgd2h5Pwo+IAo+IDMpIElmIHRoZSBhYm92ZSByZWdyZXNzaW9uIGlzIG5vdCBhY2NlcHRhYmxl
LCBhbnkgcG90ZW50aWFsIHJlbWVkeT8KCkhvdyBhYm91dCBtb3ZpbmcgdGhlIGNoZWNrIHRvIHBy
aW9yIHRvIHRoZSBub3RpZmllciByZWdpc3RyYXRpb24/CkFuZCByZWdpc3RlciBvbmx5IGlmIHRo
ZSBjaGVjayBpcyBwYXNzZWQ/ICBUaGlzIHNlZW1zIGJldHRlcgp0aGFuIGFuIGFsdGVybmF0aXZl
IHdoaWNoIGlzIHRvIGZhbGwgYmFjayB0byB0aGUgbGVnYWN5IG1lbW9yeV9mYWlsdXJlCmhhbmRs
aW5nIGluIGNhc2UgdGhlIGZpbGVzeXN0ZW0gcmV0dXJucyAtRU9QTk9UU1VQUC4KCnRoYW5rcywK
LWphbmUKCj4gCj4gdGhhbmtzIQo+IC1qYW5lCj4gCj4gCj4+Cj4+IFNvbWV0aGluZyBpcyBub3Qg
cmlnaHQuLi4KPj4KPj4gdGhhbmtzLAo+PiAtamFuZQo+Pgo+Pgo+PiBPbiA4LzUvMjAyMSA2OjE3
IFBNLCBKYW5lIENodSB3cm90ZToKPj4+IFRoZSBmaWxlc3lzdGVtIHBhcnQgb2YgdGhlIHBtZW0g
ZmFpbHVyZSBoYW5kbGluZyBpcyBhdCBtaW5pbXVtIGJ1aWx0Cj4+PiBvbiBQQUdFX1NJWkUgZ3Jh
bnVsYXJpdHkgLSBhbiBpbmhlcml0YW5jZSBmcm9tIGdlbmVyYWwgbWVtb3J5X2ZhaWx1cmUgCj4+
PiBoYW5kbGluZy7CoCBIb3dldmVyLCB3aXRoIEludGVsJ3MgRENQTUVNIHRlY2hub2xvZ3ksIHRo
ZSBlcnJvciBibGFzdAo+Pj4gcmFkaXVzIGlzIG5vIG1vcmUgdGhhbiAyNTZieXRlcywgYW5kIG1p
Z2h0IGdldCBzbWFsbGVyIHdpdGggZnV0dXJlCj4+PiBoYXJkd2FyZSBnZW5lcmF0aW9uLCBhbHNv
IGFkdmFuY2VkIGF0b21pYyA2NEIgd3JpdGUgdG8gY2xlYXIgdGhlIHBvaXNvbi4KPj4+IEJ1dCBJ
IGRvbid0IHNlZSBhbnkgb2YgdGhhdCBjb3VsZCBiZSBpbmNvcnBvcmF0ZWQgaW4sIGdpdmVuIHRo
YXQgdGhlCj4+PiBmaWxlc3lzdGVtIGlzIG5vdGlmaWVkIGEgY29ycnVwdGlvbiB3aXRoIHBmbiwg
cmF0aGVyIHRoYW4gYW4gZXhhY3QKPj4+IGFkZHJlc3MuCj4+Pgo+Pj4gU28gSSBndWVzcyB0aGlz
IHF1ZXN0aW9uIGlzIGFsc28gZm9yIERhbjogaG93IHRvIGF2b2lkIHVubmVjZXNzYXJpbHkKPj4+
IHJlcGFpcmluZyBhIFBNRCByYW5nZSBmb3IgYSAyNTZCIGNvcnJ1cHQgcmFuZ2UgZ29pbmcgZm9y
d2FyZD8KPj4+Cj4+PiB0aGFua3MsCj4+PiAtamFuZQo+Pj4KPj4+Cj4+PiBPbiA3LzMwLzIwMjEg
MzowMSBBTSwgU2hpeWFuZyBSdWFuIHdyb3RlOgo+Pj4+IFdoZW4gbWVtb3J5LWZhaWx1cmUgb2Nj
dXJzLCB3ZSBjYWxsIHRoaXMgZnVuY3Rpb24gd2hpY2ggaXMgaW1wbGVtZW50ZWQKPj4+PiBieSBl
YWNoIGtpbmQgb2YgZGV2aWNlcy7CoCBGb3IgdGhlIGZzZGF4IGNhc2UsIHBtZW0gZGV2aWNlIGRy
aXZlcgo+Pj4+IGltcGxlbWVudHMgaXQuwqAgUG1lbSBkZXZpY2UgZHJpdmVyIHdpbGwgZmluZCBv
dXQgdGhlIGZpbGVzeXN0ZW0gaW4gCj4+Pj4gd2hpY2gKPj4+PiB0aGUgY29ycnVwdGVkIHBhZ2Ug
bG9jYXRlZCBpbi7CoCBBbmQgZmluYWxseSBjYWxsIGZpbGVzeXN0ZW0gaGFuZGxlciB0bwo+Pj4+
IGRlYWwgd2l0aCB0aGlzIGVycm9yLgo+Pj4+Cj4+Pj4gVGhlIGZpbGVzeXN0ZW0gd2lsbCB0cnkg
dG8gcmVjb3ZlciB0aGUgY29ycnVwdGVkIGRhdGEgaWYgbmVjZXNzYXJ5Lgo+Pj4KPj4KPiAKCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

