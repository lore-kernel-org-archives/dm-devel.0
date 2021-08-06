Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42A1C432BE
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 63F1160234
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 63F1160234
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-RvcDM-0TOY2swMdw1lL4XA-1; Mon, 09 Aug 2021 02:53:44 -0400
X-MC-Unique: RvcDM-0TOY2swMdw1lL4XA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EA58802923;
	Mon,  9 Aug 2021 06:53:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44E12669F3;
	Mon,  9 Aug 2021 06:53:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E2B3E180BABF;
	Mon,  9 Aug 2021 06:53:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1760ouq1019381 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 20:50:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 27DFF115D93; Fri,  6 Aug 2021 00:50:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22172115D94
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 00:50:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62608800BED
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 00:50:50 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-183-0mCQFJA3MzO9RCDrycNmng-1; Thu, 05 Aug 2021 20:50:46 -0400
X-MC-Unique: 0mCQFJA3MzO9RCDrycNmng-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1760jxTm025844; Fri, 6 Aug 2021 00:50:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0e21m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 00:50:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1760nXTi002811; Fri, 6 Aug 2021 00:50:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by userp3020.oracle.com with ESMTP id 3a5ga18031-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 00:50:32 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BY5PR10MB3825.namprd10.prod.outlook.com (2603:10b6:a03:1f6::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15;
	Fri, 6 Aug 2021 00:50:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434%3]) with mapi id 15.20.4373.027;
	Fri, 6 Aug 2021 00:50:29 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <ec5dd047-a420-8e17-d803-729e052b2377@oracle.com>
Date: Thu, 5 Aug 2021 17:50:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: SJ0PR03CA0032.namprd03.prod.outlook.com
	(2603:10b6:a03:33e::7) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by
	SJ0PR03CA0032.namprd03.prod.outlook.com (2603:10b6:a03:33e::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17
	via Frontend Transport; Fri, 6 Aug 2021 00:50:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64d03e6e-6f3a-4063-6bd6-08d95874300f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3825:
X-Microsoft-Antispam-PRVS: <BY5PR10MB38251ED3DEEF36DF8A87BC76F3F39@BY5PR10MB3825.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 30dpxfRHXlewOhog/H7iocZcue7V4sd5lh/SZtlb9b0j0mjQVhKavtNoV8X/BMvNoYqKAgJO/xFxPbcEaql9q1F88S1c+FODimOhXDdauDtfHoK6rdsbt8/4q/3UrpcdKLsyxc3cSIE6vFCaS1wvu9D7XjCXvF/WKqpvnPxl/Of/iEpkLfKqvWagyHxMajKroG/ZJKUzS7hh3fYL9QUWPuUOmYZZh5nrHjalxrvfDIRDFSE0+Fc2bDySblGgnslfLUSGsItsTsYuhY13z7PJLecgIJyqXidrbTkCoFCkMJs4JNgWcwgbIai8hKF38OVe+jbVgHlkkVsdVMScN/afDa7Va+1mSrVqolm7gNf6R2rnvghOxpGzLvYUi9UMgTxAJmZmW8Cruk2YLNQEH9MI70YCS9JGxXCW0wDR9eftcdoXL00d7gI72pbgeO+i6TRNgMkRtKzeHR/DI9dNKl+7ImYZJ+jZ9fe9W8GL0Ixilwgu3QVjTXOqOKxBpEIBxmYf7s34v1L4K6/DTZsG+pasjFueRGJ6ZMaoxMqKK/TatXEfHn/TEPx5BfZ7mPsAHzWxru3rYS8YqIsYtHtFfZIsy1NKzP0hnxwmzCE6/ONlNdGOLyWKeuuF7B3BOUau1/Ya+wisadGjmZDk+lcVuoYO3VQuPV3glUZbNblXzdUMssFb8MC3mKiE2a6teghYMYTiYr7UeGqyL+bKSFnTvZjH1//X41GLf8owbi2GoQaQjnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(6486002)(36756003)(4744005)(66556008)(7416002)(2906002)(86362001)(66476007)(66946007)(31696002)(83380400001)(31686004)(316002)(44832011)(4326008)(36916002)(8676002)(478600001)(2616005)(956004)(8936002)(186003)(16576012)(38100700002)(26005)(53546011)(5660300002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0llY2xUVFhMcjFPQWVlNGhNcFA3TWhnU1pLRG1IakMvaVFsdTdLdDZWdUJm?=
	=?utf-8?B?NFAxWmZBSm92eHphRVZlMDNxT1NDU3UzbDllRUhpQU82TnF2QTBCSG1Oemth?=
	=?utf-8?B?OExkUVR2ZktWN2Y1N2I4dERKVzE4eDZqWGRqa21pc0R4ZTJkWFVaUHRxNTVi?=
	=?utf-8?B?VWxDdEN6ZmRGWUtMY2NKS2MxVThVeHA3VWdpd0p2NWZOMzhlT05WcmkrRktu?=
	=?utf-8?B?b2FpWXVPM3hlY1gyb3EySlhZcmtseVRqMVI0dFIyVzE5c0V1ajMxQlBQaEZD?=
	=?utf-8?B?a0ovbXl0NnlZdzNkTFdLTUUzdmJrWTlhcXdvd3NwenJMeXM3amE2YXpBRnAx?=
	=?utf-8?B?QWxmSmVkZmFzUGZUcGRKdUJsQldQY2UxYUR4ZjBDdGFOQ2RsWE5PU1lLSko0?=
	=?utf-8?B?ZTZDZFEwbWRYRWF1dDFFQ3NiRWltUS90bHJETHZ0SVFYOEpYMklLcG5MNHVm?=
	=?utf-8?B?WVlIRTdUL0taMmVlVlNtZUJuUHd2YytjK2pnS0hoWHp3cXFQNHphMTRETmdZ?=
	=?utf-8?B?aXV6amVreVEzYktoK3A5T2MveVZ5QUsrN1VQemJvUXVJZ3FFY3Qvd2NmSnFF?=
	=?utf-8?B?cEpWSWp6QnJja1lHdnhwNzVrZy9MYk5ZVjRzaFVWVkpnK3YrZi9IclYyeloz?=
	=?utf-8?B?MHdCVG9ZeVZLVmJnZmorM0hlNnNLc3VZam9kaVFHdmhXcXBmeWU4Z05FeXJv?=
	=?utf-8?B?RFhzcEJCcStZMkp6SkdmK2VibW1NT2E1cEkvcUZUYUd6ejZETHF3bkNETTMx?=
	=?utf-8?B?L1pUYWFrMlZldFhORUlkeGFGRGMzVnVvYUJWblY1SnJ1OFp4M0FtbmtXQm82?=
	=?utf-8?B?RGFJSlBpSGhNYWtJS3hIbnlTU08zb2ZiNEJzOXg1VVFiWFAvalFjWXRFejIy?=
	=?utf-8?B?YXhlS0dVcnJCc3FOY2RjYTZPVmdiRVdwSlBubkFQamdtUWxqMlQ3aGxxMkk2?=
	=?utf-8?B?UzNVemtLU1pCWlcxOGd3WHZQdDJuRHl3amNMY2M5d01UWE5HNDRhUGhJVFFY?=
	=?utf-8?B?L2JUMHpJYjZ0bHg3elJtZFoyM2VnUmZpOUtpMThHWThHY3FFMUlRUW5kckNa?=
	=?utf-8?B?OVhtcUY5MWtqMnJkeGtuTHF5OVA2ZnVjVTNkUDhZbmFrRlI1QjVoT3dGNFpp?=
	=?utf-8?B?dHQvdEJYOStUdFZqVzZsUG1LRng2VWh3RjBUcnVTS1A0QmJLdi9OMm5DWFdJ?=
	=?utf-8?B?UlFFcHZZSGE3a1d0bHY0T0FiQ25hZ2JMZk0zUklPZTVIcndNMlN6b0k3eitD?=
	=?utf-8?B?UG9kMFdPckc1UFd2T0Y3TUs0U2VkY0ErZ3VQYThoNVY5YVJEa2xEZ3NLOFA1?=
	=?utf-8?B?elRsWENBaU01Y1FtNkZwNnZ6UEFubVdteWRwT0hxbFV0bktCNTEzRXlvQnB3?=
	=?utf-8?B?MFV2bzFHR0RCSnZkdi9uZTRvaTArNVZMOWJ5bVIxZHRmNnJRblAwc0hHeFlo?=
	=?utf-8?B?R1d1dHRkSWZHbEZzb1dlWEo0S01ZeTZYa3JzRWFBSFhoSkVTSDhZRWFCS2xQ?=
	=?utf-8?B?S0FTRVFrbjhBaUhjSmVnR0NjVjVwTi9yazcvSHMzc2RldFNESWVLTWlVZ1dq?=
	=?utf-8?B?WjFIU2MycXVSalRBdTlXZlpUK2VmQ2FoRm9JaHpJcTVuVjZjc1l5TDlXSjB1?=
	=?utf-8?B?RVBDdGgxWFM1TENncGVUYm9yYlA2cDhLSE5RaktjVmIxemdLOWMrOHRaeEh4?=
	=?utf-8?B?THMxNlpnakQ2MlFNUkNoOEZJdXlWVEhoWThOdS9FNjVkNGFpTCt1MnRjOUlX?=
	=?utf-8?Q?zCyFeyiLFOFHqjwwamzLBHMgbjl9CL2pnxJFzrP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d03e6e-6f3a-4063-6bd6-08d95874300f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:50:29.7743 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O2zjtJsr/AUdhMXYdYAwCG9aQN/CQkeNOiuqoYtVXaQB0c5zbAnIOO+ZU7rYk8Y0SJXNSpAuzClSy72pPhXKBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3825
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0 phishscore=0
	spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060003
X-Proofpoint-ORIG-GUID: S53qrv18NH5aN2vJq07z6mcXDJ3Bf6W6
X-Proofpoint-GUID: S53qrv18NH5aN2vJq07z6mcXDJ3Bf6W6
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, david@fromorbit.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 6/9] xfs: Implement
	->notify_failure() for XFS
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
> +	mapping = VFS_I(ip)->i_mapping;
> +	if (IS_ENABLED(CONFIG_MEMORY_FAILURE)) {
> +		for (i = 0; i < rec->rm_blockcount; i++) {
> +			error = mf_dax_kill_procs(mapping, rec->rm_offset + i,
> +						  *flags);
> +			if (error)
> +				break;
> +		}
> +	}

If a poison is injected to a PMD dax page, after consuming the poison,
how many SIGBUS signals are expected to be sent to the process?

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

