Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423EAC4320A
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A2C6561250
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A2C6561250
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-TxNfhrsFMxmbppdblKkSHQ-1; Mon, 23 Aug 2021 02:40:04 -0400
X-MC-Unique: TxNfhrsFMxmbppdblKkSHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 366E9760C4;
	Mon, 23 Aug 2021 06:40:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E228B60C59;
	Mon, 23 Aug 2021 06:39:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 215B8181A0F7;
	Mon, 23 Aug 2021 06:39:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17J8CP2J018869 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 04:12:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9E31B2089A03; Thu, 19 Aug 2021 08:12:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 989042087A50
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 08:12:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1300D800B28
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 08:12:23 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-519-L74PNo7XMkKpGlFY4p_jrQ-1; Thu, 19 Aug 2021 04:12:20 -0400
X-MC-Unique: L74PNo7XMkKpGlFY4p_jrQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17J86U9d014269; Thu, 19 Aug 2021 08:12:02 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agu24k5e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 08:12:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17J85Bpo042835; Thu, 19 Aug 2021 08:12:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by userp3020.oracle.com with ESMTP id 3aeqkxyw80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 08:12:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5646.namprd10.prod.outlook.com (2603:10b6:a03:3d0::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19;
	Thu, 19 Aug 2021 08:11:58 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7%6]) with mapi id 15.20.4436.019;
	Thu, 19 Aug 2021 08:11:57 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
	<d908b630-dbaf-fac5-527b-682ced045643@oracle.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <ab9b42d8-2b81-9977-c60a-3f419e53f7bc@oracle.com>
Date: Thu, 19 Aug 2021 01:11:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <d908b630-dbaf-fac5-527b-682ced045643@oracle.com>
X-ClientProxiedBy: BYAPR07CA0007.namprd07.prod.outlook.com
	(2603:10b6:a02:bc::20) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.39.250.26] (138.3.201.26) by
	BYAPR07CA0007.namprd07.prod.outlook.com (2603:10b6:a02:bc::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19
	via Frontend Transport; Thu, 19 Aug 2021 08:11:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0f3e761-6b28-4ef8-a2ff-08d962e903a2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB564638F0E0B06B7B90C25CF7F3C09@SJ0PR10MB5646.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Ppn4zSrPec/kRjgUJM9ZegvQjsYMRRze7Bht/s1MefHzz/Kk1wgxdTeMpb6VaKHf7yVpvQO3A9vxP205G/4roUCmgFWlfbF7b1b0hUccnCZCwqQl9LRpbVKH44CzPmeoinH4HzW3Vn4+YBCHAXSAgVb2SP4WA8prD4MVoOnM/nZzvLCG9/5SyiWC0TmD69qj3enWQVS/yMcnOQs+3mjFTe7sgQxGsbIa/mB/Fd6ChNlIUZjFBAcsXWhqVBuZwTQTkXplMvtMSViXqvOn6sWlFK0oC6S0cKoP8i7GKAp2HaKErQ4pkjKzhJUgXBwavAPGJbc9p1Ajp7xYP1NewEmCLlJN5E9/LISDPURGz5Wcq62rxi+5+CaOPjgLfX6nUOhF7Hca1U9ARg9sRWfXkQNVMUXqZESmcjz5h3oASVjE0F5P2w2Le4SmH4Vx4KrDt63iqia4iC8Ds1lctfJMrqUQygDOSX2+E7y1+5TigCWUY3aKsWnLvULQMwHpk9LOCmMIHs0TsxyKfg8VuRfgpeLvS10vQQXlietgpnZDoHliIOHgTbs9sjEKD9yqFBcLrmVsxDFKIYUM8PoNj9u/HzccoKWq1ZG0T1vL9QPMNN5B2O9N9UwZxMLdZFmoKuByIG2vYEe+T9HW2nTvcFxuMBVVOXOU966nfPerfkTuil2UMrQ8slFskG09R7yGm539E/x4E0+HilQd1H8yBU8BceOiKey3zxgnmTasJeT0rzSj0mw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(53546011)(8936002)(26005)(508600001)(6486002)(316002)(5660300002)(107886003)(6666004)(36916002)(86362001)(956004)(83380400001)(8676002)(38100700002)(66556008)(2616005)(7416002)(4326008)(66476007)(66946007)(31696002)(16576012)(44832011)(2906002)(31686004)(36756003)(186003)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTRRTlBlMGJZMXhtYXZpL2RtZW5BWlNJekkyWWlnT0ZEc1EwSDN4OUExbFpa?=
	=?utf-8?B?TUlqRUNoREJPZ3RTTi9mV0luOE1DbmorRUNpcUtuNm5CMjM5UXV6VjZmUWt6?=
	=?utf-8?B?blVIT1cyQWlvNko1clkydE11dHp0NEVramtUcmRveVBQZm5LZG9NbTY5QmRk?=
	=?utf-8?B?NzUzSWNBTUQwMllQUDluWEpubi9FeXFHaStnV05GMXdIdHdPZ2JkUjJpY1pq?=
	=?utf-8?B?aGVBYnpGWmtMUG9HaFhFbHl1dG5WWFJoUEM3SzR2K01qY0RseloyR1Q5VHpT?=
	=?utf-8?B?QkVTcHdRdVZBSzlVaUpFUE52eW50b0diNE1TQ1NYdWp4cVNSdnlydkp4eDgx?=
	=?utf-8?B?VkxXVk9URjJtaEliamttUHc3eURaOXJzbFI1U3FFS0tJbDVWZlV6TnlqZW1M?=
	=?utf-8?B?RDlPY1pvSEQwalQ5TnBXdndrd2pRbURuVnpTSWc1RFNYODREcTNMQWFPSUVw?=
	=?utf-8?B?cG1YT25SZUJnMkxncTR2MWQ0SmluMHZLTkVMdVU0L3dBakprbVVsN0VCbGRz?=
	=?utf-8?B?Nm0zZnJ3bDcyY2J0d0ZtSjRqeXRzL2NPeXcvWGVKMzVCTlpMQzg5QlM2WHk2?=
	=?utf-8?B?bTIwZFNXNEo2S2QwY3F4ZVJacWQ5aE1HUFBDNGQ1NHlaeTlzRUM0bXl6OUlL?=
	=?utf-8?B?ZHBkdE1aODREaFB6NmtDeVBNTSt0a2V3ZUhzMHJVNUJxTDNRbGtoVTRmSkJY?=
	=?utf-8?B?ZkFkQzNLclRvMERCVjhPZlJpOXBPNlE3bFB5c3hOUUhmK1NtNVdSOXZFMms5?=
	=?utf-8?B?UEJiMHZNSCt3TmJaejdsdEZ0MnNJYi9lTlFmNGtCMFh1VStBUTAySDdRVWYx?=
	=?utf-8?B?Y1hnSmdrZVVIMzlMQitIY3hZUFkvSXplWDRCRFpuSWNZVVpPYi9FRzBQV1Bp?=
	=?utf-8?B?ejkybGIzOEdMVHdtNUFSR243RTVURkN6Q1hHZVVZc0t4UnJqNDA5UDczVW9s?=
	=?utf-8?B?MzZKRm5BNTBId3hRYkZSZ3pmSzhudkg1L1VYMEVzS0k0V0dOQkdNcXcxRTBj?=
	=?utf-8?B?MFdIOUQwMkU0bG5tcVF1L3VBcjFiZ0NQcDI2L0d3dFVvWUNGVGNpVFBjSENv?=
	=?utf-8?B?MGl3QytudzdjcHNNMERkMDJOZUJFQTNVQzVvRVJPQmxFU2YzSzhzdDRjVXJY?=
	=?utf-8?B?L3JyVmpiRlNBNUwyWVVORVJYcWFCeHE3LzVMZUN5bE5oMTZkVHFzOGp6VWhq?=
	=?utf-8?B?YVljUk51UWR3VTdZL3NmSVNYQjBIeHduNDQ0QnYvMGZTUGVMclRER1p4WTBn?=
	=?utf-8?B?dDFicnFGZEtGMWQ4dkxuZ0cvenE4Mnp6emlXVDZKcFlXRGpjVVpEd01PZTU0?=
	=?utf-8?B?eEZKUEd5K0RGRHZicVlGemJ6dTJuQmNHTTdocFVWcVJBRDNUK3E1d250QStu?=
	=?utf-8?B?S054dGRvYWxLTE90bDVOMWxCYkd4U3YzWWh5dUs2MS9ESHA1b0dDYVJhdlIz?=
	=?utf-8?B?cDlhSGhqQ3FQak5oc2htdzYwNFVPT3laREZTNXJ5ZTEzaWRBV2QxVEcyQi9t?=
	=?utf-8?B?ejdvbEtPQnZ3RFZKcUZSUmtXNHVpeUh1R3RQK203UUFZZWRUZXdtb2h2MlV5?=
	=?utf-8?B?Tks4R21KQU9PUFF0SzY2bzRXbW1XbHpXTVRsQmRJdTMvcjhZOWhHdVppN2R0?=
	=?utf-8?B?NUpIcVJMUWxkZnVuNlNydG5LZ3lTeHpnb1dKeDVLdzlNdWNORHlPTWNWKzhh?=
	=?utf-8?B?bmZPNzJWL0Rvb1duQVZpNkFJem5JTE4xOWNNRWNkaEJwYmFEMTFwVTBxL0gx?=
	=?utf-8?Q?r0IRHupehgUGUSPJkTsXhqTt/Uze/xgFvhSKSBa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f3e761-6b28-4ef8-a2ff-08d962e903a2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 08:11:57.8533 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7faHi/meUdjW6wpEZ3+pJy/XnzBedm8gCARXlmmZldRUH9fvu60HIgIrWXzqN7ou6vNX24+W8BrB+aIErTYNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5646
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 malwarescore=0
	mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190045
X-Proofpoint-GUID: IBbctYYfUvpxHy1lc2ovPtmQDGICLmTI
X-Proofpoint-ORIG-GUID: IBbctYYfUvpxHy1lc2ovPtmQDGICLmTI
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0b-00069f02.pphosted.com id 17J86U9d014269
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17J8CP2J018869
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: Jane Chu <jane.chu@oracle.com>, snitzer@redhat.com, djwong@kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

U29ycnksIGNvcnJlY3Rpb24gaW4gbGluZS4KCk9uIDgvMTkvMjAyMSAxMjoxOCBBTSwgSmFuZSBD
aHUgd3JvdGU6Cj4gSGksIFNoaXlhbmcsCj4gCj4gID7CoCA+ID4gMSkgV2hhdCBkb2VzIGl0IHRh
a2UgYW5kIGNvc3QgdG8gbWFrZQo+ICA+wqAgPiA+wqDCoMKgwqAgeGZzX3NiX3ZlcnNpb25faGFz
cm1hcGJ0KCZtcC0+bV9zYikgdG8gcmV0dXJuIHRydWU/Cj4gID4KPiAgPiBFbmFibGUgcm1wYWJ0
IGZlYXR1cmUgd2hlbiBtYWtpbmcgeGZzIGZpbGVzeXN0ZW0KPiAgPsKgwqDCoMKgIGBta2ZzLnhm
cyAtbSBybWFwYnQ9MSAvcGF0aC90by9kZXZpY2VgCj4gID4gQlRXLCByZWZsaW5rIGlzIGVuYWJs
ZWQgYnkgZGVmYXVsdC4KPiAKPiBUaGFua3MhwqAgSSB0cmllZAo+IG1rZnMueGZzIC1kIGFnY291
bnQ9MixleHRzemluaGVyaXQ9NTEyLHN1PTJtLHN3PTEgLW0gcmVmbGluaz0wIC1tIAo+IHJtYXBi
dD0xIC1mIC9kZXYvcG1lbTAKPiAKPiBBZ2FpbiwgaW5qZWN0ZWQgYSBIVyBwb2lzb24gdG8gdGhl
IGZpcnN0IHBhZ2UgaW4gYSBkYXgtZmlsZSwgaGFkCj4gdGhlIHBvaXNvbiBjb25zdW1lZCBhbmQg
cmVjZWl2ZWQgYSBTSUdCVVMuIFRoZSByZXN1bHQgaXMgYmV0dGVyIC0KPiAKPiAqKiBTSUdCVVMo
Nyk6IGNhbmptcD0xLCB3aGljaHN0ZXA9MCwgKioKPiAqKiBzaV9hZGRyKDB4MHg3ZmYyZDg4MDAw
MDApLCBzaV9sc2IoMHgxNSksIHNpX2NvZGUoMHg0LCBCVVNfTUNFRVJSX0FSKSAqKgo+IAo+IFRo
ZSBTSUdCVVMgcGF5bG9hZCBsb29rcyBjb3JyZWN0Lgo+IAo+IEhvd2V2ZXIsICJkbWVzZyIgaGFz
IDIwNDggbGluZXMgb24gc2VuZGluZyBTSUdCVVMsIG9uZSBwZXIgNTEyYnl0ZXMgLQoKQWN0dWFs
bHkgdGhhdCdzIG9uZSBwZXIgMk1CLCBldmVuIHRob3VnaCB0aGUgcG9pc29uIGlzIGxvY2F0ZWQK
aW4gcGZuIDB4MTg1MDYwMCBvbmx5LgoKPiAKPiBbIDcwMDMuNDgyMzI2XSBNZW1vcnkgZmFpbHVy
ZTogMHgxODUwNjAwOiBTZW5kaW5nIFNJR0JVUyB0byAKPiBmc2RheF9wb2lzb25fdjE6NDEwOSBk
dWUgdG8gaGFyZHdhcmUgbWVtb3J5IGNvcnJ1cHRpb24KPiBbIDcwMDMuNTA3OTU2XSBNZW1vcnkg
ZmFpbHVyZTogMHgxODUwODAwOiBTZW5kaW5nIFNJR0JVUyB0byAKPiBmc2RheF9wb2lzb25fdjE6
NDEwOSBkdWUgdG8gaGFyZHdhcmUgbWVtb3J5IGNvcnJ1cHRpb24KPiBbIDcwMDMuNTMxNjgxXSBN
ZW1vcnkgZmFpbHVyZTogMHgxODUwYTAwOiBTZW5kaW5nIFNJR0JVUyB0byAKPiBmc2RheF9wb2lz
b25fdjE6NDEwOSBkdWUgdG8gaGFyZHdhcmUgbWVtb3J5IGNvcnJ1cHRpb24KPiBbIDcwMDMuNTU0
MTkwXSBNZW1vcnkgZmFpbHVyZTogMHgxODUwYzAwOiBTZW5kaW5nIFNJR0JVUyB0byAKPiBmc2Rh
eF9wb2lzb25fdjE6NDEwOSBkdWUgdG8gaGFyZHdhcmUgbWVtb3J5IGNvcnJ1cHRpb24KPiBbIDcw
MDMuNTc1ODMxXSBNZW1vcnkgZmFpbHVyZTogMHgxODUwZTAwOiBTZW5kaW5nIFNJR0JVUyB0byAK
PiBmc2RheF9wb2lzb25fdjE6NDEwOSBkdWUgdG8gaGFyZHdhcmUgbWVtb3J5IGNvcnJ1cHRpb24K
PiBbIDcwMDMuNTk2Nzk2XSBNZW1vcnkgZmFpbHVyZTogMHgxODUxMDAwOiBTZW5kaW5nIFNJR0JV
UyB0byAKPiBmc2RheF9wb2lzb25fdjE6NDEwOSBkdWUgdG8gaGFyZHdhcmUgbWVtb3J5IGNvcnJ1
cHRpb24KPiAuLi4uCj4gWyA3MDQ1LjczODI3MF0gTWVtb3J5IGZhaWx1cmU6IDB4MTk0ZmUwMDog
U2VuZGluZyBTSUdCVVMgdG8gCj4gZnNkYXhfcG9pc29uX3YxOjQxMDkgZHVlIHRvIGhhcmR3YXJl
IG1lbW9yeSBjb3JydXB0aW9uCj4gWyA3MDQ1Ljc1ODg4NV0gTWVtb3J5IGZhaWx1cmU6IDB4MTk1
MDAwMDogU2VuZGluZyBTSUdCVVMgdG8gCj4gZnNkYXhfcG9pc29uX3YxOjQxMDkgZHVlIHRvIGhh
cmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uCj4gWyA3MDQ1Ljc3OTQ5NV0gTWVtb3J5IGZhaWx1cmU6
IDB4MTk1MDIwMDogU2VuZGluZyBTSUdCVVMgdG8gCj4gZnNkYXhfcG9pc29uX3YxOjQxMDkgZHVl
IHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uCj4gWyA3MDQ1LjgwMDEwNl0gTWVtb3J5IGZh
aWx1cmU6IDB4MTk1MDQwMDogU2VuZGluZyBTSUdCVVMgdG8gCj4gZnNkYXhfcG9pc29uX3YxOjQx
MDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uCj4gCj4gVGhhdCdzIHRvbyBtdWNo
IGZvciBhIHNpbmdsZSBwcm9jZXNzIGRlYWxpbmcgd2l0aCBhIHNpbmdsZQo+IHBvaXNvbiBpbiBh
IFBNRCBwYWdlLiBJZiBub3RoaW5nIGVsc2UsIGdpdmVuIGFuIC5zaV9hZGRyX2xzYiBiZWluZyAw
eDE1LAo+IGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byBzZW5kIGEgU0lHQlVTIHBlciA1MTJCIGJs
b2NrLgo+IAo+IENvdWxkIHlvdSBkZXRlcm1pbmUgdGhlIHVzZXIgcHJvY2VzcycgbWFwcGluZyBz
aXplIGZyb20gdGhlIGZpbGVzeXN0ZW0sCj4gYW5kIHRha2UgdGhhdCBhcyBhIGhpbnQgdG8gZGV0
ZXJtaW5lIGhvdyBtYW55IGl0ZXJhdGlvbnMgdG8gY2FsbAo+IG1mX2RheF9raWxsX3Byb2NzKCkg
PwoKU29ycnksIHNjcmF0Y2ggdGhlIDUxMmJ5dGUgc3R1ZmYuLi4gdGhlIGZpbGVzeXN0ZW0gaGFz
IGJlZW4Kbm90aWZpZWQgdGhlIGxlbmd0aCBvZiB0aGUgcG9pc29uIGJsYXN0IHJhZGl1cywgY291
bGQgaXQgdGFrZSBjbHVlCmZyb20gdGhhdD8KCnRoYW5rcywKLWphbmUKCj4gCj4gdGhhbmtzIQo+
IC1qYW5lCj4gCj4gCj4gCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bA==

