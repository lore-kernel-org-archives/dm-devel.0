Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2CD8C19F2D
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 03:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660102144;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P3hJa9XM0FzGiO7K2/UTeNu0KGHCq3hax3ArLHSW6wg=;
	b=AOr1slW7XTIA/aT0oV7zcAmgqe6tudpTi8xE9jhAI3oZFIsJ3GbtklF3c4ge3ASi5nY/7u
	HWpkWYqgDLpZuBN1auY2UkIYSQFiGdyXPsLnPaU0FYQ9Q2hXbxBXvFu8Dnq0JXoQ9crqUw
	yAUsbOdrOkkVm++j3bvas/FDcYZt7/0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-5TIE0adtNXyfSam0_cKK6g-1; Tue, 09 Aug 2022 23:29:01 -0400
X-MC-Unique: 5TIE0adtNXyfSam0_cKK6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CD8C3800C2F;
	Wed, 10 Aug 2022 03:28:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 529052166B26;
	Wed, 10 Aug 2022 03:28:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BABC1946A4D;
	Wed, 10 Aug 2022 03:28:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3CEB1946A41
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 03:28:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CA4CC945D9; Wed, 10 Aug 2022 03:28:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3F719457F
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 03:28:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A502085A58A
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 03:28:54 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-Ontu7fxTMbykEPWffUweiw-1; Tue, 09 Aug 2022 23:28:53 -0400
X-MC-Unique: Ontu7fxTMbykEPWffUweiw-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E8UG026805;
 Wed, 10 Aug 2022 03:28:34 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqfa-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 10 Aug 2022 03:28:34 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 27A0Aswb024110; Wed, 10 Aug 2022 03:28:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3huwqfrr4x-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 10 Aug 2022 03:28:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Wed, 10 Aug 2022 03:28:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:28:30 +0000
Message-ID: <3d2e8c97-3097-4eb9-8852-3a41e42555df@oracle.com>
Date: Tue, 9 Aug 2022 22:28:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-5-michael.christie@oracle.com>
 <a3117849-420b-65fb-dafa-c2a464482f7b@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <a3117849-420b-65fb-dafa-c2a464482f7b@acm.org>
X-ClientProxiedBy: CH2PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:610:58::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631dc4d1-ed33-4b31-9b31-08da7a806596
X-MS-TrafficTypeDiagnostic: CH2PR10MB4375:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 2eKbNQj8wEE+Bxe9Y8fdhCKLG5JP0zQ+gGIWyM9To+r6JvT8UjDBIcpoUxrgIhXx1NfGpTmLZWclyKmcPUb2YlGqnMSKqt7XvRGy88KyvVibW3Rw9JpK6VR9sZz7HCsaqypGLtwLZ2wgOQWgNQlgsUOZqX2jE6V/Jx8joLBG/iP/dGY+ZtcV2OCOrw9LLcjt8qqBiRLbLfu/2N7eW4XR/CKS/rOwyqvbfNPViBfxdDOQ07xEg/ZNis9VC6ickntu4WUEfQiOY/X8C5TVgpyjAHZxfV51BLDy1QCYn0obxSZTjFHMFPErLlBxTeQosJc31xLWvUCHsZfvaWv60D5yVENLtscJKtVjqB+9pQiHCUjuzSL8pU7UKXefXdf8wX6Q2J7jIiq6n23TrW/JZgr9sUtd+4goWk2SIMvhO4xjOFOKWVw506KEwK4z8mTWyjEwlfXheHnYtI5FIZw38Em+ZXXHpI+WeqG/K1LLVgT9x/I/cUUXTXImEMQR5Xl4eRLd1NGLN6ePH/XAYqpR/F1U7ZWJMBZE2Ju+tfQV6IQouYBGj8CgtI7skV3MYJj5H5LkSRpDsuBMKleIkqYYsP4qxyKjE+Kt4EPWbMYhRzveMWhSTbRLnyBLyP/pjc3oVhhNBQ8nLP00B5fSrmo650nHEr2hfRTm6Ws/cl81IPE1Sr+yfdbUpW/jb9PsPAeU+oAuPD06iTbAmy+NKPYsxugWonSQGnR5zbf5e24N6oDG7iVVW6RlQA7VdBQG32zUu1rxFOMPvcvEcZJZXDfDmKl/Jc0WwjSDE319XjX9UiNyGahvcB2EAvQRFS0cfT7vGaLt8/nHutrYXx8P3A6sItgZMR68HVrX9Ix9+o3mGzaIRLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(66946007)(36756003)(478600001)(316002)(6486002)(31686004)(8936002)(41300700001)(921005)(2616005)(38100700002)(6506007)(53546011)(26005)(86362001)(31696002)(6512007)(66476007)(8676002)(66556008)(186003)(83380400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzlqY21UWlV6RVpLZzJLVldkY0ZXb201UWduK1czaUN2bVNBaGhWNUdmeEIv?=
 =?utf-8?B?Z0IrTHhZUEFVeUd2Qkl4TTdBZlk2MEZCdnBSRDZsMGZHS2tZVXdibUxUMWJ1?=
 =?utf-8?B?TmE0TWNNVXJCMXBIY0JwTkt4Mlk1NkR6UUdWTGVzWXBIWjVZQXBlQzhsa2dS?=
 =?utf-8?B?R0ZDNjZWZHk1end3TFBNMmpLTTZ5Q2E5Qk41UUhYU0hxVFh0K1dRNi9FeE0z?=
 =?utf-8?B?aTR0dU1zZ01YS0o5RlQ4SjJKUkV5bkZjZERIUkluTkh5NXNEcG9uTVFNRlA4?=
 =?utf-8?B?VTMzcVZVUm1jTzFGY1VUVEpQUmE5VXVMbWc3QzhGbHAzOG0zNWM3Q3A3L0RM?=
 =?utf-8?B?bkxwWFd1OTJnbkQxOUtCSHpIclVQb1pRZ01YOE5KTW9nOVJaVkxGcXVoYUl6?=
 =?utf-8?B?d1pDZk1mNjZ4Si9lNE5wOEFIdElRdDB2SFJhMGUrcStzWWJEVGs0VG03eFQ0?=
 =?utf-8?B?NnZkNjczeEQ0bC9UNnY0NmpVQmp2QlhwZEZoUERHdTIyRG9tSGI3b2VOamlo?=
 =?utf-8?B?eWx2TWh2L1RUK2VOUjQyaTcvUmt0Rm1YYTVrNEFnWDNrRTUrdDEza2l2cDk4?=
 =?utf-8?B?aFhQbnVGQXd0UjF2R2tFSlZkNktHTnVnMnZEYW9PVkE5dnc4NUpDV0ZpcFJp?=
 =?utf-8?B?bit4bWp0N3F4R1h0clMrbk5kTWI5NTVDSm1sMEVvcEtQT1NJNGJzSVZQbzJi?=
 =?utf-8?B?SFVTbVd5SGZHenM5WEd2Q0x2eXFNMDEwNVJvcnZ2QWFZR2pvOGlXcVBieklk?=
 =?utf-8?B?ZEdCR3BXaGZ6Rittc1JaU3l6VGN3ZGNWSWhsak5qNkZabmx6NHphOXZnSkdx?=
 =?utf-8?B?Mi9YQXNsUjZBSVpUbWxaMmJPZUNRMEgxZjI4SDFqcEVBcEZOYndPR0lLRFFt?=
 =?utf-8?B?QUo5SnhTR3Z0WkFmdjNJZzRLdjViWUI5c3ZNcnQ5a2Rpdkh1QXYxWGh0a1N5?=
 =?utf-8?B?QkQ2ek1RRmhOU0QxRVgvT3RScm9mMU5oSmNITFRraXE5NjBGRXhLMmczV1hm?=
 =?utf-8?B?Vm5mRW91eWEyMGlBN01KQWRjSXIwRGlYRzlWRHRtRldnS2dnRnZOVmFzM1R6?=
 =?utf-8?B?QTlHbnBnV21BMVhXaFpBeVUzOGs4SXVHTUd1dGg2RW96ZjQ5Mm9TZlRaRDlG?=
 =?utf-8?B?SGJ4THBlTUt2SGs2MkphZy9pc25Sdk0rZUxra25nS3R0VUhCWEJSMW5PaWZr?=
 =?utf-8?B?L1ZwdkFuR0hVY3l0M3h3MFZlb3VCa2ViRzZENGErMjlIZFp2eEFibXk4MVhB?=
 =?utf-8?B?UDhETDhRbzZSVDlYM3hSNVBiSTkwUlZlN0xWL1h3aHY3TGY5Vk1ocm1VQ2NZ?=
 =?utf-8?B?ak1EUHNSdU9DRDc4UlQwMnZSQkFBcFFhYW92SkdSQ29oeDFIbWZ3bUdVWU1K?=
 =?utf-8?B?eDliMkw0K0NPb3VTZU9SSmpjMGNMaTIrbUJDMStvSWN0UXRqaTR4OEhuL0VJ?=
 =?utf-8?B?T1NPcG1yM3BneHoralpzRndwcjhHKzN1YlFUVTRoMUNRVWs4UXBwU0RIQU5m?=
 =?utf-8?B?Nnc2SmtEZ05vaENDa1hpMGplenJsWXpXWTY1R0VHM1I2a0hUYis4SEJ4NktI?=
 =?utf-8?B?cVQrVTR2SU5rc3FQaFJ3SzFDKzdSZCtvYzUreXpOcTZDcHJCeWlVZHQxYkNZ?=
 =?utf-8?B?U3lCUkZKOG4xc3l2ZHdHTm9nbWR5Tk5ENHFhZHBpaGlDMExiMlZ3ZUNhZEU0?=
 =?utf-8?B?a0lOMGZPSkZ4dFJLWk5OTkhIaEZTcDBqK1UycEdRK1cyTExzbVVROU1NYlRQ?=
 =?utf-8?B?UkJWVEw4RmltcDdTS0tvc05hOURKTm4zVW9rTnF1My9IVWlXWkhIK2ZIVlo2?=
 =?utf-8?B?NGVpUzAvc1hHUHQvUER5MmNYOWdTTFN0QUI1YUtFTHQwSm5ES2R5eU03Y3pv?=
 =?utf-8?B?ZFRwZzZSTXZGamFrbFpubkxXMWxXRVNiQkFNdGs1RFp2cmVPY1AweEY1VEZS?=
 =?utf-8?B?Qnc3bG9jUTdxS2R0YW9zcGllYlhSS3dhNkNKdlRuM2dGOC9KVEVkazVldGVL?=
 =?utf-8?B?ZDlRNlVkc1RaR1FSeGNKNkN4UDlrWVFRRExsaW84S0lrOC9qdklKOFJWakpG?=
 =?utf-8?B?U3lERTFXbkNYM0F1dGtnV2I5RitxemRtcGZRMnlRT0QxSXQwUUt3NGhBQUl2?=
 =?utf-8?B?NDdwVzZuVUxRRlZ4ZlVjai8xTWx6ZGNlZm84bkNVR0tYc1FLd3loMGU3WllG?=
 =?utf-8?B?OVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631dc4d1-ed33-4b31-9b31-08da7a806596
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:28:30.7305 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSDvQ25l+XTG3IZoVyvod3LPxM4Edldm3EtKAxvBF/RQbI8EsbOx4g1bg9mVZoBCj3zWKFKJe5Gox2ReH3hUASyBvSR39a/aFCvLLDS5HuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: S4zR36ToCsgEd9mHAYP7njPh7aFrqMnH
X-Proofpoint-ORIG-GUID: S4zR36ToCsgEd9mHAYP7njPh7aFrqMnH
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 27A0E8UG026805
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 04/20] scsi: Add support for block PR read
 keys/reservation.
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gOC85LzIyIDI6MjYgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPiBPbiA4LzgvMjIgMTc6
MDQsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6Cj4+ICtzdGF0aWMgaW50IHNkX3ByX2luX2NvbW1hbmQo
c3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgdTggc2EsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdW5zaWduZWQgY2hhciAqZGF0YSwgaW50IGRhdGFfbGVuKQo+PiArewo+PiAr
wqDCoMKgIHN0cnVjdCBzY3NpX2Rpc2sgKnNka3AgPSBzY3NpX2Rpc2soYmRldi0+YmRfZGlzayk7
Cj4+ICvCoMKgwqAgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gc2RrcC0+ZGV2aWNlOwo+PiAr
wqDCoMKgIHN0cnVjdCBzY3NpX3NlbnNlX2hkciBzc2hkcjsKPj4gK8KgwqDCoCB1OCBjbWRbMTBd
ID0geyAwLCB9Owo+PiArwqDCoMKgIGludCByZXN1bHQ7Cj4gCj4gSXNuJ3QgInsgfSIgaW5zdGVh
ZCBvZiAieyAwLCB9IiB0aGUgcHJlZmVycmVkIHdheSB0byB6ZXJvLWluaXRpYWxpemUgYSBkYXRh
IHN0cnVjdHVyZT8KClRoZSBvcmlnaW5hbCBjb2RlIHVzZWQgeyAwLCB9IGFuZCB0aGF0IHNlZW1z
IGNvbW1vbiBzZC5jLiB7IH0gd2FzIG5vdCB1c2VkIGluIHNkLmMuCgpJIGRpZG4ndCBzZWUgYW55
dGhpbmcgaW4gY29kaW5nLXN0eWxlLnJzdC4gSXQgZG9lcyBub3QgbWFrZSBhbnkgZGlmZmVyZW5j
ZSB0byBtZQpvdGhlciB0aGFuIGl0J3MgYmV0dGVyIHRvIGJlIGNvbnNpc3RlbnQgdW5sZXNzIHdl
IGFyZSBzdXBwb3NlZCB0byBiZSB0cmFuc2l0aW9uaW5nCnRvIGEgbmV3IHN0eWxlLgoKPiAKPj4g
Kwo+PiArwqDCoMKgIGNtZFswXSA9IFBFUlNJU1RFTlRfUkVTRVJWRV9JTjsKPj4gK8KgwqDCoCBj
bWRbMV0gPSBzYTsKPiAKPiBDYW4gdGhlIGFib3ZlIHR3byBhc3NpZ25tZW50cyBiZSBtb3ZlZCBp
bnRvIHRoZSBpbml0aWFsaXplciBvZiBjbWRbXT8KPiAKClllcywgYnV0IGl0IHdhcyBsaWtlIHRo
ZSBmaXJzdCBjb21tZW50LiBUaGUgb3JpZ2luYWwgY29kZSBkaWRuJ3QgZG8KdGhhdCBhbmQgaXQg
c2VlbWVkIG1vcmUgY29tbW9uIHRvIG5vdCBkbyBpdC4gRG8gd2Ugd2FudCB0byBzd2l0Y2gKb3Ig
YXJlIHdlIHRyYW5zaXRpb25pbmc/IEl0IGRvZXMgbm90IG1hdHRlciB0byBtZS4gQm90aCBhcmUg
c2ltcGxlIGNoYW5nZXMuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

