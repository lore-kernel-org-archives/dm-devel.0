Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9524DC4320E
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26EF260F41
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26EF260F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-42qIqvfsMPyd3PkZIcES0Q-1; Tue, 17 Aug 2021 03:26:29 -0400
X-MC-Unique: 42qIqvfsMPyd3PkZIcES0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C75161082925;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2E823A47;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73A484A7CA;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17GHKboO000894 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 13:20:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A617D100320D; Mon, 16 Aug 2021 17:20:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0F8110088A5
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 17:20:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1695180158D
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 17:20:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-125-1ISYkuF5MGeOyK77wuLICw-1; Mon, 16 Aug 2021 13:20:32 -0400
X-MC-Unique: 1ISYkuF5MGeOyK77wuLICw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17GHHWjC027582; Mon, 16 Aug 2021 17:20:19 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3af3kxtm16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Aug 2021 17:20:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17GHExv5077032; Mon, 16 Aug 2021 17:20:18 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
	(mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
	by userp3020.oracle.com with ESMTP id 3aeqkshs7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Aug 2021 17:20:18 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BY5PR10MB3779.namprd10.prod.outlook.com (2603:10b6:a03:1b6::26)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13;
	Mon, 16 Aug 2021 17:20:11 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7%5]) with mapi id 15.20.4415.023;
	Mon, 16 Aug 2021 17:20:11 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
Organization: Oracle Corporation
Message-ID: <de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
Date: Mon, 16 Aug 2021 10:20:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
X-ClientProxiedBy: SA0PR11CA0191.namprd11.prod.outlook.com
	(2603:10b6:806:1bc::16) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.39.192.148] (138.3.201.20) by
	SA0PR11CA0191.namprd11.prod.outlook.com (2603:10b6:806:1bc::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16
	via Frontend Transport; Mon, 16 Aug 2021 17:20:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84382469-5d6e-4cbc-2bfd-08d960da1a72
X-MS-TrafficTypeDiagnostic: BY5PR10MB3779:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3779F4F5595DAC9372E03371F3FD9@BY5PR10MB3779.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: FbSO7Dlex8jaGX0jopAshHdlVuS0hL+d6XGJIydmVIWicI8bQRcBfPYs2neWgJdWeirkrCLhAY/B0U5VjCwbIbKwJi7cm50dmetYrNe1oRFXbEPaxvD3uSlOcFPHUlZ8s2u4RFZUVWpXledxMVAmfZsMMsWTOErFW1DDTpYZH77AR0l9oMK1JuxnNXA3JhH9+l6nL0zOhvsLk+ofvz/6jHbqSSt2foqHLlwZIthYorYbJyUnhd0bojg8YlX8DURO5OUBt66fcvb9oltLGF+a4fZLpEnxfCNtu9gWz3gjUR8ts7Do5ON6mcJyaNPAssvzQ0U3TlAuaItlLjGkzeNRzC9fgka/HMyT3DWt73So1wwvWKoPhKGr/I5s7Cdgkvev9gdO1gXYDjSqSLp3NGr3TCdTy7oiprSNB9SUg5qX8bMSM6QlZKWenKjeV5QcRL/WU4jw5HP5N28lDD5Gsu13a2pRTGQSLusFz89rKVfWpThs1QFPAYz1lb+wY5nb+dtNiXYCtakhEnJLFp8T89xC8d8QZAucMvL/2WCgut1zlQo1jAhKeZhsfo6XOSox65Og+oyHm65IVEHziTonWpKd54x5CfLXQgSa/WWTknIGRLFDpNQBHctYEwp1R1GFgM2V2rSmpHjhhtNy7bePnXOg8FDEElR09rWO5JoNlOODM+G5lO/5kKkIjYMUPDMcdSFtIHw2Kba7gqGygx91JDszz/PEhkr1IynbI1y6ocvOjK4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(31686004)(186003)(16576012)(7416002)(26005)(2616005)(2906002)(5660300002)(83380400001)(316002)(4326008)(956004)(66946007)(36916002)(38100700002)(8676002)(31696002)(6486002)(6666004)(508600001)(66556008)(66476007)(44832011)(53546011)(8936002)(86362001)(36756003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXZPMERKeXQ1SkRwVnBIMStzRlJGNU5EVXlRUGlDaDZ1QWtsbmhwVWNtT090?=
	=?utf-8?B?dUxiK0t3QzVTTWxsNUlUeWpHY0I5YVZHTERYaDgwdE1zSExPaGVhOGVYNlFi?=
	=?utf-8?B?MmptNUJuNDZtZkVMUHR3Wlk1bStQalMzOFhSbGNFWFdtZ2M5U2dXb3VjTFhX?=
	=?utf-8?B?WSs1aGRuNW4wY2FSUUJjeTVDYSt3YW5xTjlCaDdPRy9OWmNoVzdaayt3bFNR?=
	=?utf-8?B?cVNZUWhPeFVhS3FENVVCN0t4RzFUaUJmVE0vWFBUZi8vSVZFOGxaeStQY0pr?=
	=?utf-8?B?dHQzc2RZeXhzeFJaMEkxZnZUZnptRllOaDdtMmkxZ3M0Mm16ZUlJSm5PbHVj?=
	=?utf-8?B?RVFDam81aVNwMi90Y0hJREpXSlQ2b2JrYVNLTzBIZ3hPL1p2ZFJIVlhYM2dX?=
	=?utf-8?B?MmN2NHlybHAvT0FDU0dQbThKTGI3OEdyVDhtMWJoQW1sWXd1S1RhcUx4N2lE?=
	=?utf-8?B?SDNPQ1YxTFRwVkF3VlFBaU1FUysyS3k4a0txUU1QOWxNaERWbUlNNWNLcVVw?=
	=?utf-8?B?VmdtMzlFVnJIS3VlQTExbmgwQjlvNUhCc3Y0YXZIVjI3UzVqWlRkdVFHcGN6?=
	=?utf-8?B?NXgzbkRWYVJhMnlwSmFIUkk5VHlMaEU5Rkp6djdDTDFETjF4aTlONlljZ1Zo?=
	=?utf-8?B?UmFQWG9STjZEMXJYRkFmSjhFZmY0S3A3RExHaGNERFZ4ZWxZYmpPYUR0VmdD?=
	=?utf-8?B?NXQ5b3FLeXA2dkd1VWlyVlhQT3VKa0hLR2F3djBjMDZBeDgyVnNqblVaSDJV?=
	=?utf-8?B?UXVGamxTZmo5WEJHS1BrcjlzVWJUSy9YTGZpaXIzNkhMTlZ1cmZZcXFQM3Js?=
	=?utf-8?B?UW40YXNXd2RBeXMwTmdUOVQ3NjR0Vm9mVlZXUm1wdE5LMHFaTi9kdVR1VVNo?=
	=?utf-8?B?b2RTcm0wbnZLNFpRUnZub1Z0NmhVcTZSOE1rVzNDVjRuM2srSjNYVExPQ2xN?=
	=?utf-8?B?QW1zemJTQzJrbUNiOWdJQ0NnaEo5Tk5FNFUxaVpObGF3cUN4U3JGamttNkdQ?=
	=?utf-8?B?SnhoQUI5ai9HTDA1RE1XNkxGZmJBUG9DbkRKRTJRRjIvdGREazRNM3VmYUNl?=
	=?utf-8?B?dWJwSiszd3FLSlVybWd0d1YrbXVBeTBhL0lYcUowTUFpa25XNEU4Y1RTeUcw?=
	=?utf-8?B?WTE3a2loajMzZG9abVRqeVRVMTRMOFlqQWtiN0tBL01JdEVFU0Z6VHM2cktB?=
	=?utf-8?B?RXpEU01iV3RRVHJwdktRTVZtNHB2VGZaYnZIRjBEbmVzTk1KQXhLOCtyVWJ3?=
	=?utf-8?B?R3M1MFp3VWdDQ3B3OE5zRWsxaEZ0cExzcFhqRHFxVWtQbWtNeXJwQzJ4M2hj?=
	=?utf-8?B?d2NVRW5pamdBZ1AxU1JjTWxOc0pkM21YRVFuaTBnNnlwa2RrZ1QyNE9UMVlW?=
	=?utf-8?B?eGZHYjVQNzh4bEhvSE1XY3MzaWNUQzJxZVI1VHh6aGl2ZGtFOVBpTDJhZUJw?=
	=?utf-8?B?ajhaeFJHYzV3QUFZL2lUSTZ1aUt6cnFDZk1nak8veVpEUDlFeDEyNTBKR0ww?=
	=?utf-8?B?NHVVcnpGM2ZBenVxYjNaOWNhUDFZZWZPR0pvUk1CM2dsYkI3UHlNRDQ0dDRN?=
	=?utf-8?B?L1AvVVhvSUR3R3VnK3VUSHdPaUpVeUErRjZjQmZRSWp1MWM1UCsxQTNESWxJ?=
	=?utf-8?B?Mk1YTUJaM3psREFtcXpNOExhd1BrbDNCNnc3THFLdTNCVnVrR1dUbFdNVmNu?=
	=?utf-8?B?TU5UVlcrSmIxU28xYjI1aG5DSlQ4MWFneXBZMTRoVEJBWHdGVkdIcUNpZDZT?=
	=?utf-8?Q?DVHj7EZ7F/1HZDGWSN53NMLoy2pU0Cql7Ie/2WA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84382469-5d6e-4cbc-2bfd-08d960da1a72
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:20:11.3906 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BsjxFr0Veui/QrnMQRofwytg9X6H/yMcCOAPkh5GT3Z22dnnQdb1p+XUy3Qsov9C++CXVopUUmGQvwCYDbhhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3779
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 malwarescore=0
	mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108160110
X-Proofpoint-GUID: xeswe8pJorPdvPGXcJacbHFRIl1yadvs
X-Proofpoint-ORIG-GUID: xeswe8pJorPdvPGXcJacbHFRIl1yadvs
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0b-00069f02.pphosted.com id 17GHHWjC027582
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17GHKboO000894
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
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

SGksIFNoaVlhbmcsCgpTbyBJIGFwcGxpZWQgdGhlIHY2IHBhdGNoIHNlcmllcyB0byBteSA1LjE0
LXJjMyBhcyBpdCdzIHdoYXQgeW91IAppbmRpY2F0ZWQgaXMgd2hhdCB2NiB3YXMgYmFzZWQgYXQs
IGFuZCBpbmplY3RlZCBhIGhhcmR3YXJlIHBvaXNvbi4KCkknbSBzZWVpbmcgdGhlIHNhbWUgcHJv
YmxlbSB0aGF0IHdhcyByZXBvcnRlZCBhIHdoaWxlIGFnbyBhZnRlciB0aGUKcG9pc29uIHdhcyBj
b25zdW1lZCAtIGluIHRoZSBTSUdCVVMgcGF5bG9hZCwgdGhlIHNpX2FkZHIgaXMgbWlzc2luZzoK
CioqIFNJR0JVUyg3KTogY2Fuam1wPTEsIHdoaWNoc3RlcD0wLCAqKgoqKiBzaV9hZGRyKDB4KG5p
bCkpLCBzaV9sc2IoMHhDKSwgc2lfY29kZSgweDQsIEJVU19NQ0VFUlJfQVIpICoqCgpUaGUgc2lf
YWRkciBvdWdodCB0byBiZSAweDdmNjU2ODAwMDAwMCAtIHRoZSB2YWRkciBvZiB0aGUgZmlyc3Qg
cGFnZQppbiB0aGlzIGNhc2UuCgpTb21ldGhpbmcgaXMgbm90IHJpZ2h0Li4uCgp0aGFua3MsCi1q
YW5lCgoKT24gOC81LzIwMjEgNjoxNyBQTSwgSmFuZSBDaHUgd3JvdGU6Cj4gVGhlIGZpbGVzeXN0
ZW0gcGFydCBvZiB0aGUgcG1lbSBmYWlsdXJlIGhhbmRsaW5nIGlzIGF0IG1pbmltdW0gYnVpbHQK
PiBvbiBQQUdFX1NJWkUgZ3JhbnVsYXJpdHkgLSBhbiBpbmhlcml0YW5jZSBmcm9tIGdlbmVyYWwg
bWVtb3J5X2ZhaWx1cmUgCj4gaGFuZGxpbmcuwqAgSG93ZXZlciwgd2l0aCBJbnRlbCdzIERDUE1F
TSB0ZWNobm9sb2d5LCB0aGUgZXJyb3IgYmxhc3QKPiByYWRpdXMgaXMgbm8gbW9yZSB0aGFuIDI1
NmJ5dGVzLCBhbmQgbWlnaHQgZ2V0IHNtYWxsZXIgd2l0aCBmdXR1cmUKPiBoYXJkd2FyZSBnZW5l
cmF0aW9uLCBhbHNvIGFkdmFuY2VkIGF0b21pYyA2NEIgd3JpdGUgdG8gY2xlYXIgdGhlIHBvaXNv
bi4KPiBCdXQgSSBkb24ndCBzZWUgYW55IG9mIHRoYXQgY291bGQgYmUgaW5jb3Jwb3JhdGVkIGlu
LCBnaXZlbiB0aGF0IHRoZQo+IGZpbGVzeXN0ZW0gaXMgbm90aWZpZWQgYSBjb3JydXB0aW9uIHdp
dGggcGZuLCByYXRoZXIgdGhhbiBhbiBleGFjdAo+IGFkZHJlc3MuCj4gCj4gU28gSSBndWVzcyB0
aGlzIHF1ZXN0aW9uIGlzIGFsc28gZm9yIERhbjogaG93IHRvIGF2b2lkIHVubmVjZXNzYXJpbHkK
PiByZXBhaXJpbmcgYSBQTUQgcmFuZ2UgZm9yIGEgMjU2QiBjb3JydXB0IHJhbmdlIGdvaW5nIGZv
cndhcmQ/Cj4gCj4gdGhhbmtzLAo+IC1qYW5lCj4gCj4gCj4gT24gNy8zMC8yMDIxIDM6MDEgQU0s
IFNoaXlhbmcgUnVhbiB3cm90ZToKPj4gV2hlbiBtZW1vcnktZmFpbHVyZSBvY2N1cnMsIHdlIGNh
bGwgdGhpcyBmdW5jdGlvbiB3aGljaCBpcyBpbXBsZW1lbnRlZAo+PiBieSBlYWNoIGtpbmQgb2Yg
ZGV2aWNlcy7CoCBGb3IgdGhlIGZzZGF4IGNhc2UsIHBtZW0gZGV2aWNlIGRyaXZlcgo+PiBpbXBs
ZW1lbnRzIGl0LsKgIFBtZW0gZGV2aWNlIGRyaXZlciB3aWxsIGZpbmQgb3V0IHRoZSBmaWxlc3lz
dGVtIGluIHdoaWNoCj4+IHRoZSBjb3JydXB0ZWQgcGFnZSBsb2NhdGVkIGluLsKgIEFuZCBmaW5h
bGx5IGNhbGwgZmlsZXN5c3RlbSBoYW5kbGVyIHRvCj4+IGRlYWwgd2l0aCB0aGlzIGVycm9yLgo+
Pgo+PiBUaGUgZmlsZXN5c3RlbSB3aWxsIHRyeSB0byByZWNvdmVyIHRoZSBjb3JydXB0ZWQgZGF0
YSBpZiBuZWNlc3NhcnkuCj4gCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==

