Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C235C19F2D
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 03:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660102479;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V7Cy5h0OjYmsbqvzE1DB5gH8WsJYJhI/BfW7ICYRhjQ=;
	b=iSYvMMwFbBZZhnnwzWkyng4QQQB/N9fFkQpCTtY7+2Rsbgf0ynLfC5o89amGJpJhHMErhW
	hlaBC8YENLjsL4o9OpV1RCzlRiYEAAKVaHw4+aJk7HjeX8ptgwTvtWfqIpOA//6xDac6e4
	KBNzyJzludNWtkuwHUsX4Um8CyGZCqg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-s_hV__-dN6aiH_R594ZpMg-1; Tue, 09 Aug 2022 23:34:36 -0400
X-MC-Unique: s_hV__-dN6aiH_R594ZpMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9BA28037A9;
	Wed, 10 Aug 2022 03:34:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97BEE40D2827;
	Wed, 10 Aug 2022 03:34:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 728951946A50;
	Wed, 10 Aug 2022 03:34:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28CAB1946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 03:34:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 076BC18EB5; Wed, 10 Aug 2022 03:34:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 029AA9457F
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 03:34:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7F5B805B72
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 03:34:32 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-gqHB0k0FNB69kFbHRtTw5A-1; Tue, 09 Aug 2022 23:34:31 -0400
X-MC-Unique: gqHB0k0FNB69kFbHRtTw5A-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E8VD026805;
 Wed, 10 Aug 2022 03:34:19 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqq4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 10 Aug 2022 03:34:19 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 27A0YFxu005087; Wed, 10 Aug 2022 03:34:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3huwqh8v45-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 10 Aug 2022 03:34:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Wed, 10 Aug 2022 03:34:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:34:15 +0000
Message-ID: <6d814bf5-e1c6-af57-613d-ea02c8bc2ebc@oracle.com>
Date: Tue, 9 Aug 2022 22:34:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-13-michael.christie@oracle.com>
 <20220809072155.GF11161@lst.de>
 <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
 <4768d11e-06c6-1b74-9822-b2421a3f59bb@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <4768d11e-06c6-1b74-9822-b2421a3f59bb@acm.org>
X-ClientProxiedBy: CH2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:610:20::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24f7994d-2714-431d-c0cb-08da7a81333e
X-MS-TrafficTypeDiagnostic: CH2PR10MB4375:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: fXuIDKlp2owv0QSzxiE88pC/+fIEKCQ+GquMUe4Kyf2beiBgkw0irbHOmJHxXua/DxLmQAxeeUr4PcD1Ni6FiJrlcTGpSVx/Ruu/5URgnx4eDTmK9HXc4IcGvO4yvc/GVEMMyPjH+qFeDcn7UiIegDp01hodJx75mmGYeyvLR/h1O/FWtX+4nv6aRTdcn65yZDdjp96cjEimTugyAL5hnCOJ7xPYW5Qr1XfzTtuNzRQ9DGildaT3fPRV6Xx4oJ01jP7gFloIqu4FKn5acCG3VN1pqiLADzT+bnAv9nEViVu/SoSMSlQJE60bAHAx8vNcLRIpDQh2KXK1t5VnB0WisXjvDl+yhtZ8/X8CQvGKi2+ry9Nrh6TQBOZq0DBfDqYy6qzkPmqNndP8FhCIQUNZ8+4Q2/MmrdsqJYROKuwxVqAOK/PeByt+ux5F5IaBen/6CqdLKubuSGjs0ZaBg/ExlLP68vZuEde7Equu6d4+DXue/VIZYTiN9ys34zqVj4WCjc6NJ9HGakoeF2vbOUMCuNwogneSoiZWKqe7oVR7h4+FsKOmOdoJEc7vr7W/9HcfoE9kh+npM7S9byTA9n1TX7Kl1JR03NwvbS41YQa5JCIYfJd6R9BMHK57Q5WUcaycd1vUrTT830JAywiBvmpu9JLYeeM7x1XSrv7nuLBbG7kM2dYC4hhoQgvykucKTgdPyhy9I2UUBbjjGlgjfnHAk6k4D33klUFeg8uiIFC6jJqaaG7svE+IR/aWEBI8WB+92JeqAZhqV4w3s1gdZfMOywyNyGcZSMoVzvlojbx8OEAJkV75klsWujQYchV4otLF17mnHYR91/mkP6Wn464b/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(66946007)(36756003)(478600001)(110136005)(316002)(6486002)(31686004)(8936002)(41300700001)(2616005)(38100700002)(6506007)(53546011)(26005)(86362001)(31696002)(6512007)(66476007)(4326008)(8676002)(66556008)(186003)(83380400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck0xcnZ0U1BTTmNpWG9RRjdNTVF3K2lVQ0ZGUTZIMDlzWkdmRmMzcGo1V21X?=
 =?utf-8?B?QXFVMTQ2cmM5RmxLemh0aWN3NzY5Mitxc1RpVThJb1F5ZEdaaXZGeWx3Q0lR?=
 =?utf-8?B?L09lRFNxT0tMcnZtaklZOTJpVFNwNHI3bFl0ZGZxTWJEVW0reFZUYWVyU05F?=
 =?utf-8?B?UmFrOUdPMnovekZaM29JNW1mWEVMRkZ0czluck4zNTAyMzgrT2JNd1RxdFFJ?=
 =?utf-8?B?WlV0UVdacWZJUFpLYndKZmdHSW8vUXl3dDJFWUNCMC9veXpzSzdpT3lBWUlo?=
 =?utf-8?B?OUNoK3h3N2o0YjJXN3VjQnNwd3Z4cnRaZ3pCbnRzRWlsNUF1YklXbWJyMjJ1?=
 =?utf-8?B?MXpiTXQxVUdUcGhaY0FPSXpOTjRxUEsrSDJaN3BROGpNTmxiejNRVU5EYkRK?=
 =?utf-8?B?NGJNemFYVDFCaVIyQVVkVkxQSmdoVWxYVU5uaU5IaTVISjdraHVEdlNuK1RR?=
 =?utf-8?B?Y0h6VzI2NU5OWEducDFWYTJBTzRmRGNmZll6VGpoTlR2OG1SdnNQNjYwN2xM?=
 =?utf-8?B?VEFUdHhhM2NvOEpCZWRlOUo4REVObi9LSnYyN1JNTDNMak5GNkpEMnlXV1RI?=
 =?utf-8?B?blR0bk9zeUhlUWxITXJLdUpDYjZZRlVtRTdFYzRORXZIdHI1dG15UjNKT1Ax?=
 =?utf-8?B?RCtQYWRnVzl1WlZSRUVhS2dyYWF5RGxHZnVxaG5Kd08zWUEwYi9xSEVNdXJ3?=
 =?utf-8?B?eEFtZ2pqa3VPNE9hSWFTb1lhdWUzZnJyT3V5cTRaM0FHTDd2dmQzMmYrRmgw?=
 =?utf-8?B?Y3ZGQ2NBSC9YV2wrdVBxdW1KRFkrbW12c25iY2J0Mk5xak0zTSszOG5Tdmxw?=
 =?utf-8?B?RTR2QXpLOVVIUXduNm5aUkpMOGJZVjlIZUhwZWpMU01pc2dDY3BKY2Q5Ungv?=
 =?utf-8?B?aE1vSnFXbEtMVE1NVkQ3MjRGZUVySkFCV3NtS3lTbEt5S2h0YW5mU0xDNzRI?=
 =?utf-8?B?dFpEYnRuNkRtTy82QW8weVlRRE1Xb3dJUkhFbCtWbThBNFFiS2xTaFN3VWFB?=
 =?utf-8?B?bDZoNm5xYzZ2UnFDUTJaUEhaa090WjRBYWNkazBiNityamFNWUgweEhwU0Nt?=
 =?utf-8?B?WWE0Vzd4M2dSbmZKQm5JWEVvNzR1OHhYaENSZTBhVXBOc3JEckt4UHN3REFt?=
 =?utf-8?B?S2gxbnNvbHF3SDVHLysyTTFMdVRiOEhQVkgxdlJ4MG5BcklIWHRCYUFHMnlS?=
 =?utf-8?B?UGczQjlDcTgvWVlpc3pGR2wwV0xmVTJwelJ1Q2ZUcFMrRWFFTlFtejVxZ1la?=
 =?utf-8?B?aFQyVDUrZDBsbFVQY0t1SmRJSDBIWEptcEZpRHFXVDJldnlVY1N4SWU2bkM4?=
 =?utf-8?B?a2ZRcWtrYXFlRHFPUnk1YlRpc2pteWR5a0VGRE1HMVExTFdNN00rL3dYWVVl?=
 =?utf-8?B?a3lVWHdZamhiSVJDWUpTVVFFUFdpOHFIN0tXeVh0elRhaVNsckt5WXhSai8y?=
 =?utf-8?B?eXRLSTBlUzY1M25UdnhKZ01PUW1KUE1ycDJRZkU4VGIrRUhIeGVlQVcwS09Y?=
 =?utf-8?B?V1J5K3BYdm5pRVczck1hMWVLZWFVc0FsRDQ5TTMzWkg5WTlmOU9QUDgxOVJs?=
 =?utf-8?B?RmdwUVIxZXJ2QU1BdVgzTkFwbkxKRnpzdWd5OStyTlcyZHBORC9uUUpCVEJQ?=
 =?utf-8?B?ZmNWZHZ6UU1JSFg4M2tvZDZ5c3E1dDd3SEQydDdXVlJhUDVVbkpKVmRPNE8v?=
 =?utf-8?B?Y0ZqdXFKaDBrc3BwVHd6c2h2R0J6WHVZVHRsVi9kNjZpckowbzBEbXJ4RHVN?=
 =?utf-8?B?dXdIejkwR1pLWHlJaVVhZk95MkdTbWcvVE9VWVRkR3p0cWxYSklMWmVzUitL?=
 =?utf-8?B?N1Fjdk8zc0xjblRMWU5OcGtNandEMVdTdE5wMGxwd1Z6VFhzM3grOHRuWHZa?=
 =?utf-8?B?VlkwUjFqcXdkNnlLLzA4djBuVXhwMURNYnd2QXc1TjgrZFB1cW9ZRTljZ09B?=
 =?utf-8?B?cHhneEhTcVMyNWtpQUF1TmhaOUpPMWgzcnVuMDVyV0FoLzdUb3ZDUUtkL3FU?=
 =?utf-8?B?MHF2ejhKSmRjMS8zeE9FaWVxOVJqQ0FnOTRSWDF6cGd0bUZiRGZwcFltSHRU?=
 =?utf-8?B?ZndNYVBHaFFiMk1La01vZHplUnhNdkwzSVF2TFJjOVNBcXA1eWNIVGZ0ajFi?=
 =?utf-8?B?VkUyTklqNG0yUWtremEzWGljSHFYSzYrZVNEUnBEd1VEK0Q3Qzg4Snpac3Mr?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f7994d-2714-431d-c0cb-08da7a81333e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:34:15.7029 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ESxBGOLpItr9G3z0yp1f0cIIL3OTJFSZ64Z2YlsYVdBf1x6umF/u2rRuKV40vvcdmgigwmejQvxom+uINTVIr1MPHJ34boZzt6SCrnCPXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=988 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: QqBs539NXERf_TEVO5v3nIIxlH1pup1w
X-Proofpoint-ORIG-GUID: QqBs539NXERf_TEVO5v3nIIxlH1pup1w
X-MIME-Autoconverted: from 8bit to base64 by mx0b-00069f02.pphosted.com id
 27A0E8VD026805
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 12/20] block, nvme, scsi,
 dm: Add blk_status to pr_ops callouts.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gOC85LzIyIDI6MzMgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gT24gOC85LzIyIDEx
OjA4LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPj4gT24gOC85LzIyIDI6MjEgQU0sIENocmlzdG9w
aCBIZWxsd2lnIHdyb3RlOg0KPj4+IE9uIE1vbiwgQXVnIDA4LCAyMDIyIGF0IDA3OjA0OjExUE0g
LTA1MDAsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+Pj4+IFRvIGhhbmRsZSBib3RoIGNhc2VzLCB0
aGlzIHBhdGNoIGFkZHMgYSBibGtfc3RhdHVzX3QgYXJnIHRvIHRoZSBwcl9vcHMNCj4+Pj4gY2Fs
bG91dHMuIFRoZSBsb3dlciBsZXZlbHMgd2lsbCBjb252ZXJ0IHRoZWlyIGRldmljZSBzcGVjaWZp
YyBlcnJvciB0bw0KPj4+PiB0aGUgYmxrX3N0YXR1c190IHRoZW4gdGhlIHVwcGVyIGxldmVscyBj
YW4gZWFzaWx5IGNoZWNrIHRoYXQgY29kZQ0KPj4+PiB3aXRob3V0IGtub3dpbmcgdGhlIGRldmlj
ZSB0eXBlLiBJdCBhbHNvIGFsbG93cyB1cyB0byBrZWVwIHVzZXJzcGFjZQ0KPj4+PiBjb21wYXQg
d2hlcmUgaXQgZXhwZWN0cyBhIG5lZ2F0aXZlIC1FeHl6IGVycm9yIGNvZGUgaWYgdGhlIGNvbW1h
bmQgZmFpbHMNCj4+Pj4gYmVmb3JlIGl0J3Mgc2VudCB0byB0aGUgZGV2aWNlIG9yIGEgZGV2aWNl
L3RyYW5wb3J0IHNwZWNpZmljIHZhbHVlIGlmIHRoZQ0KPj4+PiBlcnJvciBpcyA+IDAuDQo+Pj4N
Cj4+PiBXaHkgZG8gd2UgbmVlZCB0d28gcmV0dXJuIHZhbHVlcyBoZXJlPw0KPj4NCj4+IEkga25v
dyB0aGUgMiByZXR1cm4gdmFsdWVzIGFyZSBncm9zcyA6KSBJIGNhbiBkbyBpdCBpbiBvbmUsIGJ1
dCBJIHdhc24ndCBzdXJlDQo+PiB3aGF0J3Mgd29yc2UuIFNlZSBiZWxvdyBmb3IgdGhlIG90aGVy
IHBvc3NpYmxlIHNvbHV0aW9ucy4gSSB0aGluayB0aGV5IGFyZSBhbGwNCj4+IGJhZC4NCj4+DQo+
Pg0KPj4gMC4gQ29udmVydCBkZXZpY2Ugc3BlY2lmaWMgY29uZmxpY3QgZXJyb3IgdG8gLUVCQURF
IHRoZW4gYmFjazoNCj4+DQo+PiBzZF9wcl9jb21tYW5kKCkNCj4+DQo+PiAuLi4uLg0KPj4NCj4+
IC8qIHdvdWxkIGFkZCBzaW1pbGFyIGNoZWNrIGZvciBOVk1FX1NDX1JFU0VSVkFUSU9OX0NPTkZM
SUNUIGluIG52bWUgKi8NCj4+IGlmIChyZXN1bHQgPT0gU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9O
KQ0KPj4gwqDCoMKgwqByZXR1cm4gLUVCQURFOw0KPj4gZWxzZQ0KPj4gwqDCoMKgwqByZXR1cm4g
cmVzdWx0Ow0KPj4NCj4+DQo+PiBMSU8gdGhlbiBqdXN0IGNoZWNrcyBmb3IgLUVCQURFIGJ1dCB3
aGVuIGdvaW5nIHRvIHVzZXJzcGFjZSB3ZSBoYXZlIHRvDQo+PiBjb252ZXJ0Og0KPj4NCj4+DQo+
PiBibGtkZXZfcHJfcmVnaXN0ZXIoKQ0KPj4NCj4+IC4uLg0KPj4gwqDCoMKgwqByZXN1bHQgPSBv
cHMtPnByX3JlZ2lzdGVyKCkNCj4+IMKgwqDCoMKgaWYgKHJlc3VsdCA8IDApIHsNCj4+IMKgwqDC
oMKgwqDCoMKgIC8qIEZvciBjb21wYXQgd2UgbXVzdCBjb252ZXJ0IGJhY2sgdG8gdGhlIG52bWUv
c2NzaSBjb2RlICovDQo+PiDCoMKgwqDCoMKgwqDCoCBpZiAocmVzdWx0ID09IC1FQkFERSkgew0K
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBuZWVkIHNvbWUgaGVscGVyIGZvciB0aGlzIHRo
YXQgY2FsbHMgZG93biB0aGUgc3RhY2sgKi8NCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYg
KGJkZXYgPT0gU0NTSSkNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
U0FNX1NUQVRfUkVTRVJWQVRJT05fQ09ORkxJQ1QNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZWxzZQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBOVk1FX1NDX1JF
U0VSVkFUSU9OX0NPTkZMSUNUDQo+PiDCoMKgwqDCoMKgwqDCoCB9IGVsc2UNCj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIGJsa19zdGF0dXNfdG9fc3RyKHJlc3VsdCkNCj4+IMKgwqDC
oMKgfSBlbHNlDQo+PiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmVzdWx0Ow0KPj4NCj4+DQo+PiBU
aGUgY29udmVyc2lvbiBpcyBraW5kIG9mIGdyb3NzIGFuZCBJIHdhcyB0aGlua2luZyBpbiB0aGUg
ZnV0dXJlIGl0J3MgZ29pbmcNCj4+IHRvIGdldCB3b3JzZS4gSSdtIGdvaW5nIHRvIHdhbnQgdG8g
aGF2ZSBtb3JlIGFkdmFuY2VkIGVycm9yIGhhbmRsaW5nIGluIExJTw0KPj4gYW5kIGRtLW11bHRp
cGF0aC4gTGlrZSBkbS1tdWx0aXBhdGggd2FudHMgdG8ga25vdyBpZiBhbiBwcl9vcCBmYWlsZWQg
YmVjYXVzZQ0KPj4gb2YgYSBwYXRoIGZhaWx1cmUsIHNvIGl0IGNhbiByZXRyeSBhbm90aGVyIG9u
ZSwgb3IgYSBoYXJkIGRldmljZS90YXJnZXQgZXJyb3IuDQo+PiBJdCB3b3VsZCBiZSBuaWNlIGZv
ciBMSU8gaWYgYW4gUEdSIGhhZCBiYWQvaWxsZWdhbCB2YWx1ZXMgYW5kIHRoZSBkZXZpY2UNCj4+
IHJldHVybmVkIGFuIGVycm9yIHRoYW4gSSBjb3VsZCBkZXRlY3QgdGhhdC4NCj4+DQo+Pg0KPj4g
MS4gRHJvcCB0aGUgLUV4eXogZXJyb3IgdHlwZSBhbmQgdXNlIGJsa19zdGF0dXNfdCBpbiB0aGUg
a2VybmVsOg0KPj4NCj4+IHNkX3ByX2NvbW1hbmQoKQ0KPj4NCj4+IC4uLi4uDQo+PiBpZiAocmVz
dWx0IDwgMCkNCj4+IMKgwqDCoMKgcmV0dXJuIC1lcnJub190b19ibGtfc3RhdHVzKHJlc3VsdCk7
DQo+PiBlbHNlIGlmIChyZXN1bHQgPT0gU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9OKQ0KPj4gwqDC
oMKgwqByZXR1cm4gLUJMS19TVFNfTkVYVVM7DQo+PiBlbHNlDQo+PiDCoMKgwqDCoHJldHVybiBy
ZXN1bHQ7DQo+Pg0KPj4gYmxrZGV2X3ByX3JlZ2lzdGVyKCkNCj4+DQo+PiAuLi4NCj4+IMKgwqDC
oMKgcmVzdWx0ID0gb3BzLT5wcl9yZWdpc3RlcigpDQo+PiDCoMKgwqDCoGlmIChyZXN1bHQgPCAw
KSB7DQo+PiDCoMKgwqDCoMKgwqDCoCAvKiBGb3IgY29tcGF0IHdlIG11c3QgY29udmVydCBiYWNr
IHRvIHRoZSBudm1lL3Njc2kgY29kZSAqLw0KPj4gwqDCoMKgwqDCoMKgwqAgaWYgKHJlc3VsdCA9
PSAtQkxLX1NUU19ORVhVUykgew0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBuZWVkIHNv
bWUgaGVscGVyIGZvciB0aGlzIHRoYXQgY2FsbHMgZG93biB0aGUgc3RhY2sgKi8NCj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKGJkZXYgPT0gU0NTSSkNCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByZXR1cm4gU0FNX1NUQVRfUkVTRVJWQVRJT05fQ09ORkxJQ1QNCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZWxzZQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiBOVk1FX1NDX1JFU0VSVkFUSU9OX0NPTkZMSUNUDQo+PiDCoMKgwqDCoMKgwqDC
oCB9IGVsc2UNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGJsa19zdGF0dXNfdG9f
c3RyKHJlc3VsdCkNCj4+IMKgwqDCoMKgfSBlbHNlDQo+PiDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
cmVzdWx0Ow0KPj4NCj4+IFRoaXMgaGFzIHNpbWlsYXIgaXNzdWVzIGFzICMwIHdoZXJlIHdlIGhh
dmUgdG8gY29udmVydCBiZWZvcmUgcmV0dXJuaW5nIHRvDQo+PiB1c2Vyc3BhY2UuDQo+Pg0KPj4N
Cj4+IE5vdGU6IEluIHRoaXMgY2FzZSwgaWYgdGhlIGJsb2NrIGxheWVyIHVzZXMgYW4gLUV4eXog
ZXJyb3IgY29kZSB0aGVyZSdzIG5vdA0KPj4gQkxLX1NUUyBmb3IgdGhlbiB3ZSB3b3VsZCByZXR1
cm4gLUVJTyB0byB1c2Vyc3BhY2Ugbm93LiBJIHdhcyB0aGlua2luZw0KPj4gdGhhdCBtaWdodCBu
b3QgYmUgb2sgYnV0IEkgY291bGQgYWxzbyBqdXN0IGFkZCBhIEJMS19TVFMgZXJyb3IgY29kZQ0K
Pj4gZm9yIGVycm9ycyBsaWtlIEVJTlZBTCwgRVdPVUxEQkxPQ0ssIEVOT01FTSwgZXRjIHNvIHRo
YXQgZG9lc24ndCBoYXBwZW4uDQo+Pg0KPj4NCj4+IDIuIFdlIGNvdWxkIGRvIHNvbWV0aGluZyBs
aWtlIGJlbG93IHdoZXJlIHRoZSBsb3cgbGV2ZWxzIGFyZSBub3QgY2hhbmdlZCBidXQgdGhlDQo+
PiBjYWxsZXIgY29udmVydHM6DQo+Pg0KPj4gc2RfcHJfY29tbWFuZCgpDQo+PiDCoMKgwqDCoC8q
IG5vIGNoYW5nZXMgKi8NCj4+DQo+PiBsaW8oKQ0KPj4gwqDCoMKgwqByZXN1bHQgPSBvcHMtPnBy
X3JlZ2lzdGVyKCkNCj4+IMKgwqDCoMKgaWYgKHJlc3VsdCA+IDApIHsNCj4+IMKgwqDCoMKgwqDC
oMKgIC8qIGFkZCBzb21lIHN0YWNrZWQgaGVscGVyIGFnYWluIHRoYXQgZ29lcyB0aHJvdWdoIGRt
IGFuZA0KPj4gwqDCoMKgwqDCoMKgwqDCoCAqIHRvIHRoZSBsb3cgbGV2ZWwgZGV2aWNlDQo+PiDC
oMKgwqDCoMKgwqDCoMKgICovDQo+PiDCoMKgwqDCoMKgwqDCoCBpZiAoYmRldiA9PSBTQ1NJKSB7
DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlc3VsdCA9IHNjc2lfcmVzdWx0X3RvX2Jsa19z
dGF0dXMocmVzdWx0KQ0KPj4gwqDCoMKgwqDCoMKgwqAgZWxzZQ0KPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXN1bHQgPSBudm1lX2Vycm9yX3N0YXR1cyhyZXN1bHQpDQo+Pg0KPj4NCj4+IFRo
aXMgbG9va3Mgc2ltcGxlLCBidXQgaXQgZmVsdCB3cm9uZyBoYXZpbmcgdXBwZXIgbGF5ZXJzIGhh
dmluZyB0bw0KPj4ga25vdyB0aGUgZGV2aWNlIHR5cGUgYW5kIGNhbGxpbmcgY29udmVyc2lvbiBm
dW5jdGlvbnMuDQo+IA0KPiBIYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRvIGludHJvZHVjZSBhIG5l
dyBlbnVtZXJhdGlvbiB0eXBlIGluc3RlYWQgb2YgY2hvb3NpbmcgKDApLCAoMSkgb3IgKDIpPw0K
PiANCg0KVGhlIHByb2JsZW0gaXMgdGhhdCB1c2Vyc3BhY2UgY3VycmVudGx5IGdldHMgdGhlIG52
bWUgc3RhdHVzIHZhbHVlIG9yIHRoZQ0Kc2NzaV9jbW5kLT5yZXN1bHQgd2hpY2ggY2FuIGJlIGhv
c3Qvc3RhdHVzIGJ5dGUgdmFsdWVzIGxpa2Ugd2l0aCBTRyBJTy4NClNvIHlvdSBjb3VsZCB5b3Ug
anVzdCBkbyBhIG5ldyBlbnVtIG9yIGFkZCBldmVyeSBwb3NzaWJsZSBlcnJvciB0byBibGtfc3Rh
dHVzX3QNCmJ1dCBiZWZvcmUgcGFzc2luZyBiYWNrIHRvIHVzZXJzcGFjZSB5b3Ugc3RpbGwgaGF2
ZSB0byB0aGVuIGNvbnZlcnQgdG8gd2hhdA0KZm9ybWF0IHVzZXJzcGFjZSBpcyBnZXR0aW5nIHRv
ZGF5LiBTbyBmb3Igc2NzaSBkZXZpY2VzLCB5b3UgaGF2ZSB0byBtaW1pYw0KdGhlIGhvc3RfYnl0
ZS4NCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

