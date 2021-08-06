Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67566C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E1C9860F55
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E1C9860F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-X1VqKXX4Omyi9rO4v-dhYg-1; Mon, 09 Aug 2021 02:53:44 -0400
X-MC-Unique: X1VqKXX4Omyi9rO4v-dhYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C42591009617;
	Mon,  9 Aug 2021 06:53:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F64F5D6CF;
	Mon,  9 Aug 2021 06:53:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 353FD4A7CD;
	Mon,  9 Aug 2021 06:53:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1761iQjk024601 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 21:44:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9848920BEDD1; Fri,  6 Aug 2021 01:44:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9280020BEDCE
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:44:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 936F98CA94F
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:44:23 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-457-NUhApEKOP-KXqrqDqOiieA-1; Thu, 05 Aug 2021 21:44:22 -0400
X-MC-Unique: NUhApEKOP-KXqrqDqOiieA-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1760l10s007584; Fri, 6 Aug 2021 00:47:01 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubpf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 00:47:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1760k7GZ154538; Fri, 6 Aug 2021 00:46:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
	by aserp3020.oracle.com with ESMTP id 3a7r4apeyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 00:46:59 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26;
	Fri, 6 Aug 2021 00:46:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434%3]) with mapi id 15.20.4373.027;
	Fri, 6 Aug 2021 00:46:57 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-10-ruansy.fnst@fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <7e9589cc-92a6-ad57-edd9-fdcdc4e49150@oracle.com>
Date: Thu, 5 Aug 2021 17:46:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20210730100158.3117319-10-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: SN7PR04CA0075.namprd04.prod.outlook.com
	(2603:10b6:806:121::20) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by
	SN7PR04CA0075.namprd04.prod.outlook.com (2603:10b6:806:121::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15
	via Frontend Transport; Fri, 6 Aug 2021 00:46:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d7cf042-ede8-470b-d4c8-08d95873b1ae
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758DC99686C2B3E04B03033F3F39@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: rbC95OAcFTuydXBbVC5QIE9/7AUHhL6ZLjgfOBMT1y7KJr4DwPq3jW1PvYUo39A9iOrplV4MRiZxSyWjZDVyUqt/mTk7xBqtKDEZjni33jZwK6yyq3hQrcn0DfatDDatq+r5LeH3uf2+s0BJMixD/02c+ZQxqcQZk/vcpclUHBO3U9jdIxObblWLCmGXsKSxYcwlVjn7edUAKuGJultSEb53b/qjxxAQ8iD5U+1MqJYbovPcBzonHzP6hYSz15xDoo4pfg6JqOtzrthEQJiBboS0PcS/xcexLB4rhgumqFbbjEZptzqbfUmxlK1sM/09/KLx8FDJXmwfxVcfnQpwAxxSZXXKvHTbqdEpvRzopLtC6qPKylqYu5N//fBe5Hb61+KP5bRG6weps6cR5hUr95q53ubn6uTVaWrtShtcRd4XskeB/I2qdUddFhkgYRVcm2YAInv1UEnGb4W+yyb211WSxUX1XtW4NkjBZUYWGVZzZzkTxCkZAjD8O/N7OMDwwWFrs7JJoQDpYeYD76nQVKc832NO1qZ2OdmsdzGOPvJ+1d4ar+m4jjIxHAvdatnUcl5ek7lQQX75MjZU24nxQ5c6nwNrAOcpj4cQxkm3S0HySy/NnefwZQqLG+hmwctb3TM6nKaxdN+iZ8NhH+S8Og8CnE5bjaqroAzc84Vb4DDi7zUiotxjDLsY6Vit+MMHMr5SJB8LpQBoBcBS6nmxFBggKhUFXuFHUofUdTNENIQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(39860400002)(366004)(396003)(346002)(376002)(66946007)(66476007)(66556008)(36916002)(186003)(956004)(5660300002)(2616005)(31686004)(36756003)(44832011)(8676002)(53546011)(26005)(8936002)(31696002)(6486002)(86362001)(2906002)(4326008)(7416002)(16576012)(316002)(478600001)(38100700002)(6666004)(83380400001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGJUTHJBVGJyN2pCc1ZyWGR0SDZSRkcyYmN2VnRzMTc2NWxIc01TeExDY0Rq?=
	=?utf-8?B?YTRxVE1WaDVXNDgvMW9OYXpFY2ZMckpjVTB0NXppNldWM2t0STlnQkVCU28z?=
	=?utf-8?B?eVYvRERkbHFIc0VTK2V3TlNmWnVWajFldGJmWmpEVTBYaXIwRWVmdFNaZnVy?=
	=?utf-8?B?T2ZGVHhnOFVac0taOHphZExsV3VYa1kwdWtldkhYVXc5T1BRZ0RXZVVTMFZH?=
	=?utf-8?B?UzdjNGtVdGRLdEg3OGhoY1lwRFlqNndOTEdWZ2d5aUhjVysxK1FpUzE4L012?=
	=?utf-8?B?WnEvMGFveUNHYjJMU2FxK3RkOW9lczd3MkRiSGJBR2hxdzRlSTZPdUJUMUwy?=
	=?utf-8?B?czd1cDlrU2dwT1FvK0JvTUFzbXphdDI4bzRnTzZYTGl1RHdIVFVjS2dBdFo4?=
	=?utf-8?B?eEN6aE9ncEFzaDIxeEVvWTJvSmpDakJVSktEdXpLT3ZDL1ZGanVmR3IwVTI5?=
	=?utf-8?B?R2hDcGJSNjNWUHV4WjgxeGU2cUtkQUlOWjdTZGYwK2MrMWVWTlV5Z1pQMllE?=
	=?utf-8?B?OVBsMCtJdk4yTTVSb2d2RjA1VWNVTlByRVhPVjdxSkM2M2pURzlZbnJWVlBq?=
	=?utf-8?B?ZnFnUTlKWkYvUGpFNU1OejBTakE2dWFqSkx4Y1FsK1FvZmp6YjkrZXA2UkhD?=
	=?utf-8?B?aThZd3dXbzF0cUxaSG1HcjVYbXVXRkNKY0VvVGdrdjEwMzdGdCtHZlpzcU5x?=
	=?utf-8?B?OThtL0dtaUMrYkZkZjRGWDJJTjU3OWYyVnJPc1B1TzNKcXZVdmtRQkt3RkEy?=
	=?utf-8?B?bExVWVpSRWZ3TWtzTlc1aG5uYWpsRGErUG9lMDdpcjZXdHBxMzE2eU9ERFZl?=
	=?utf-8?B?bENUSDdhNVk3VlR2NEJMM3NNcHB0NmthTTFKK0JucjRtd1ptZWdzTzhIbzdz?=
	=?utf-8?B?SlNwMmxMNVFlMU5EZW8ra3dlYldGY0lVeVdvbVQ1U28vaWR3YWlZb1VVVlJ1?=
	=?utf-8?B?OHRQdllJczhTbC94eDVSd0tBNmpxQ0FwR2Nva0J5UFV4cENNT3E4ak0wTXZR?=
	=?utf-8?B?dTcwUm85RDhIZ3JZakJuZ3E2RVA2c0FMUU4rdXZvbkRpZWR1a3FzN20rOFly?=
	=?utf-8?B?Qlo5YWh6S0d6b2pLc0RlVUx6TldXRk1LVG9aMUhPNDlkZXFjRW8xcXhENkEy?=
	=?utf-8?B?bklCcS8vcTZMb3R2S1JrR1NqdVJZbVVGbDB4Z0o5dWVLNFEzNmVmVy9VRWh3?=
	=?utf-8?B?U3ZDY09qY2F3QjVOMDFxdTEvWHdWMFI1MitUTjBiQ0ZkelhxTmdFTTh0TXA2?=
	=?utf-8?B?ZU0xNHU1ZE94WkhGcWIxSThWdFkvUmpjUUR4RG5IZWhzTjdVU0pLUFUrMnhE?=
	=?utf-8?B?VW5BZjhDYmh2VUxVYzRsdjZBWGQ5NjVsMmUvRDBESVVDNTVFS1VTMkYwTzlJ?=
	=?utf-8?B?ZzloYkZWNUpDWXlaV092ZmRUbW9WSDNlQTZUeVdJL2NLK1d2UmJBUWY3MXB6?=
	=?utf-8?B?MjZJeUNUaTdvc1pRWXlMWGRuUlEwamt5L09SV01NZ2czam8relhZMTdDdGVN?=
	=?utf-8?B?VlRhSm4yT0pBdEI1WlJDMEtPRGN0VlFSQkxYOFlxbnJTeGN0UHgwMGI0Qmxq?=
	=?utf-8?B?S0MreWhXWVpaMFdpTVlvZlh0TS9BaWUyajMzR3ZOODhtRG5rT2dDMEFBRDRF?=
	=?utf-8?B?Y0xoREU5M05kOFlyaFZqSDJCUFhnb0lPKzBZTUVVbzJvTkxzaTBVaVN4ZXE2?=
	=?utf-8?B?bExzaU0vZ3NTYktCRXFIUHk0Mm5EZTdxNUZwVHhlSGI1NmtkOGxpNjh4a3Ja?=
	=?utf-8?Q?EfBSiUEkTK4bN3dCr0u9E4I9zgUkLuI31FrgyZ5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7cf042-ede8-470b-d4c8-08d95873b1ae
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:46:57.7503 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQEKJdzXiDabJXSF9j1zigYnyZ1ySqlWFuZbQdLyu2uSIwu7irI9Yq5M8Rmszi+tWODrmIYwm76QnuxPDa4XQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	malwarescore=0 adultscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060002
X-Proofpoint-GUID: AjUiWNE9JeFKRj0fEdGLPzokYNoWB0qO
X-Proofpoint-ORIG-GUID: AjUiWNE9JeFKRj0fEdGLPzokYNoWB0qO
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, david@fromorbit.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 9/9] fsdax: add exception for
	reflinked files
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> For reflinked files, one dax page may be associated more than once with
> different fime mapping and index.  It will report warning.  Now, since             ^^^typo here?

> we have introduced dax-RMAP for this case and also have to keep its
> functionality for other filesystems who are not support rmap, I add this
> exception here.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   fs/dax.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index dce6307a12eb..f5910d178695 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -352,9 +352,10 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>   	for_each_mapped_pfn(entry, pfn) {
>   		struct page *page = pfn_to_page(pfn);
>   
> -		WARN_ON_ONCE(page->mapping);
> -		page->mapping = mapping;
> -		page->index = index + i++;
> +		if (!page->mapping) {
> +			page->mapping = mapping;
> +			page->index = index + i++;
> +		}
>   	}
>   }
>   
> @@ -370,9 +371,10 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>   		struct page *page = pfn_to_page(pfn);
>   
>   		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> -		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
> -		page->mapping = NULL;
> -		page->index = 0;
> +		if (page->mapping == mapping) {
> +			page->mapping = NULL;
> +			page->index = 0;
> +		}
>   	}
>   }
>   
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

