Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E159C432BE
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6D3260EE4
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C6D3260EE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-AAy_ktUSN2uHidfCsUT2Zg-1; Mon, 09 Aug 2021 02:53:40 -0400
X-MC-Unique: AAy_ktUSN2uHidfCsUT2Zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E7587504B;
	Mon,  9 Aug 2021 06:53:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B231E5D6B1;
	Mon,  9 Aug 2021 06:53:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7FAB1180BAB3;
	Mon,  9 Aug 2021 06:53:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 176131vR020348 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 21:03:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D3D0F20A8DDC; Fri,  6 Aug 2021 01:03:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC57520B6627
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:02:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F116580158D
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:02:56 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-419-CwbFJ-ovPoekKijM4DGpDw-1; Thu, 05 Aug 2021 21:02:55 -0400
X-MC-Unique: CwbFJ-ovPoekKijM4DGpDw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17611x4S019408; Fri, 6 Aug 2021 01:02:44 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0e2d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 01:02:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1760xfVA095003; Fri, 6 Aug 2021 01:02:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by userp3030.oracle.com with ESMTP id 3a4un4t5pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 01:02:43 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2518.namprd10.prod.outlook.com (2603:10b6:a02:b8::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25;
	Fri, 6 Aug 2021 01:02:40 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434%3]) with mapi id 15.20.4373.027;
	Fri, 6 Aug 2021 01:02:40 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <e844fc54-113f-239d-da23-fa140aeea9d7@oracle.com>
Date: Thu, 5 Aug 2021 18:02:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: MN2PR19CA0011.namprd19.prod.outlook.com
	(2603:10b6:208:178::24) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by
	MN2PR19CA0011.namprd19.prod.outlook.com (2603:10b6:208:178::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17
	via Frontend Transport; Fri, 6 Aug 2021 01:02:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad4062eb-b50e-49d7-35be-08d95875e3ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB2518:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25186C8C0D15E6E15F00D21AF3F39@BYAPR10MB2518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: JLl/YW4yQpXe+275ZtYDnjfsjxQ3KAnQNde8b80lY6KdTXNHVpegdcsccWO3d1d36ALDHQDRjlNBWIvEvelw9YJUJsBSNGbEELpWjfqqmPJ3vtPtw0M16Ai6+MKuBOTBiM17WYq3lHT8jGiWCeh2+X+IqH63nzAtr6I6ltSCc+i5ckbtJXMp9MrAWYG+rjBKvLSK9eADMaqiXvI2/eC6BJKaDuesTVz+7CJovLPmrzC8KAFQVt+a6Rq1rEDpq2cLRTXI8ip2OVnuSBqpp58XKkQrWwI5EmdmUoxw6z/YwjpmxIFxq8OSWCKntCnEtC6Wd4rdaSrorfd8skmgvZmN51eiV1fhz5mTQdwoM8kciygD8r2QrAdr65iIUG9T+ooq6wrt0ZI585AVZH/yNfeJhaJ7XFz0cpPuam3dy6+Acx7Fl0KIYSK95fQodqfJMu0UAiEC8K5z0lvGSsiWvzXQ8iKEaz85RSqHCsqUp1lokj+ACtHkD2SNUZcR0tyU6mRQ8MVGNjC2oLBVLVbxm7FICv14EVAMvIQC3xaoyVuar0UNcwJcUq2HIGzuhWsHFhkjr582ve66t2roFYaGVD9MIXk7GeSXem0rSu838fwYJ9NI5zdoioMM6cNp8KhDfo2QCnE+E6coeyIzZ/Su7cTgbbwA7+QjWPjxINBq0P3H10RqqCjhUY9iD4Esqx1aSy3Mz8RM7bTrGS1sD8aceFgE7CLdLLBF9WbxRZ9Up4NgjRk=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(136003)(396003)(376002)(366004)(346002)(26005)(8936002)(7416002)(956004)(4326008)(44832011)(53546011)(36916002)(6486002)(2906002)(4744005)(6666004)(38100700002)(31686004)(36756003)(478600001)(8676002)(186003)(5660300002)(66946007)(31696002)(2616005)(66476007)(86362001)(66556008)(316002)(16576012)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTEvVGpMdSsvN1JQWnZMczlBMlFRbWRpVW9WRUNpdng0VDNOYjA4OTkrVHQw?=
	=?utf-8?B?bjRPZEVTRXplMFdWb2xpeGgrUFp1ZHRKNWhMZmZzMlpsaFFQL2M5bFpYRnFm?=
	=?utf-8?B?TE02aTdlZ1R1RDJNaUNxN2RTT25nbjh5TUhHK1UrL2tnbU8zTWFBY2xBRWNW?=
	=?utf-8?B?cnJpK0w2aXF1bU1wZHdDN1RlTFVIdDJVQlFBb1lhaU84S0tISjlkck56WnJn?=
	=?utf-8?B?ZzY4VmU3U3V3eUV2NmF3MHVvajM0UnMvU0UxSXZQVDFXNmFOaXlSOHJFR3k3?=
	=?utf-8?B?UWFKWW5JV2NrbVpBdmFWcXVMU09JTEJtWFJWM1ZmdFNuUm1RZEd4S2JlRjlz?=
	=?utf-8?B?dndxbjRUd2d1L2NnRWhmeWxYTndvNlArTW92S044RHBXSDV5Z3VvU09WODRU?=
	=?utf-8?B?TEZqbnBRM0VKV3U4dC9lUi84ODRkVmJXMnlKNXRkbnl1Tm9lbFEwVjRLenJy?=
	=?utf-8?B?TGpKOVArRTE3Ukk4MmZXMnJtdU9FN3VNS1BjY2kyekZlNlduMTdud25WNWdr?=
	=?utf-8?B?TWIrMjVyTW9lUVBwSUdiVzJLV1ZjVTYvQmQ2cENXQmtJMVdLRzlLbWdYTU1o?=
	=?utf-8?B?VVpWM0VsclFzWEdCNnZuK3BMTkVFMDlDNEYrNkNEUi9sakNPbllJaGlqQ2Fh?=
	=?utf-8?B?NkdtV1NLc3RlRjRmRkJ1NDVMTEt2RkZOUWdZQkNHZk84MDVySlpyUmYrL0Vu?=
	=?utf-8?B?bHRhcEp3K1hKaUN5Q0lNcC9MOXhzRjFGQ21uZTF3R2lkbnZsRXRLRHpWdUNC?=
	=?utf-8?B?Y3JEdnk3VjY2UTc5KzBxeFBtT3M0Z1JVYWkwcnliL3lhWEY5S2RRU205MHp4?=
	=?utf-8?B?UjIyaGMxdUxNMDNCRWVxK09sbzhOaXNPRTJsbHE4cnY4dHBBL3ZzWm5HbkpZ?=
	=?utf-8?B?RzRuOUZkdERZRVFKMUNNbHAzZkJ4YjJNenZQSmtpUUs5Tk5RNmwvYTRhaW5a?=
	=?utf-8?B?cnFPZG5QR3BqYUNrOG04NmVpNHg5eFk3RmZuWlkxM2pEeDJZK2FzN0NrVHRE?=
	=?utf-8?B?dUZvNjhZNkVkR0ZZR1h2TXNPakNhcWNySTlrTXBwai9WMkNqVDNjOTlJTjR4?=
	=?utf-8?B?VFpRbkN6SEY0blRrVXA0YzdKRFhWSTBTbDR2ZnBIUGpPNmowbU43MHpENzhG?=
	=?utf-8?B?TlhrSm4vSU16MkhxV2w3MUF6VWovMkdwSlB5VzRyb1VhZEQrN052dGptcUcr?=
	=?utf-8?B?S08xNE5nOUhzN29UNlRVcDJzVTFWUE5sYjJkaEtiSm0zYUtkL0tMUlJJUUZx?=
	=?utf-8?B?QlFYWENVNHFHOHdwRm5lcFc5UHM2c0VxajdHamE4TlFZSXcrSit3ejR6dk5D?=
	=?utf-8?B?TEVubE1NbnIwL2pSbmthKzd0Y3JWbnNWQ2FrQTFJaTJtdDV6WGlBODhmL29v?=
	=?utf-8?B?N2t1ZVNyajFLakFRcTdoVFNFZ3p1d2pYYW9LNXpqSTIvVVZIQzdVY2owcEUx?=
	=?utf-8?B?Uks5b01vdjZEODVTc2hkNHVQbncrVUNUeGxKY1JOSDYvZ2pmZm1JU0JFZEJv?=
	=?utf-8?B?cFFpYStGbS8rYUNYNCtCSXFqVGRkYVhYT09IUkUvZXV5WmdGc2RuQWhxcWV1?=
	=?utf-8?B?WGhnKzNjSjRrVW4wMGw4RFJmNEMzTll3L3RuZWtGakZFVDdtQW9XTDJrVStT?=
	=?utf-8?B?dUd6L0hHWjAybThWa0ZRV3FXNUhPUXdXeldJNEtuVnBaUjc1MTg4eU5VNTNV?=
	=?utf-8?B?Y1ArUDlhamU3ZXFJUENqODUxQjNMK1ZLaStZSGJ4bXlubDlDeGNaMFJnbkNx?=
	=?utf-8?Q?IAnJuGWor1R1Z1KFEIvMAEeYjKoz4KZbVpPUQKs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4062eb-b50e-49d7-35be-08d95875e3ac
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 01:02:40.5968 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TuvZCJ82o+qd5wJRReVcZ8ryzLU/2dbNussUvyPWaPN+mdx9Aq7QyE7dFcLMKRWfauEk+g7ZgsgTEFKFJmA9pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2518
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060004
X-Proofpoint-ORIG-GUID: hE2eVNFUt4OYE7Be0ektZlSPKjkMY7RC
X-Proofpoint-GUID: hE2eVNFUt4OYE7Be0ektZlSPKjkMY7RC
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
Subject: Re: [dm-devel] [PATCH RESEND v6 2/9] dax: Introduce holder for
	dax_device
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
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -214,6 +214,8 @@ enum dax_device_flags {
>    * @cdev: optional character interface for "device dax"
>    * @host: optional name for lookups where the device path is not available
>    * @private: dax driver private data
> + * @holder_rwsem: prevent unregistration while holder_ops is in progress
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
>    * @flags: state and boolean properties

Perhaps add two documentary lines for @ops and @holder_ops?
>    */
>   struct dax_device {
> @@ -222,8 +224,11 @@ struct dax_device {
>   	struct cdev cdev;
>   	const char *host;
>   	void *private;
> +	struct rw_semaphore holder_rwsem;
> +	void *holder_data;
>   	unsigned long flags;
>   	const struct dax_operations *ops;
> +	const struct dax_holder_operations *holder_ops;
>   };

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

