Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33F4C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:57:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4ED646108B
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4ED646108B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-Nc8r0kRNP7a--sXc28xgWw-1; Wed, 18 Aug 2021 03:57:04 -0400
X-MC-Unique: Nc8r0kRNP7a--sXc28xgWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1AE587D547;
	Wed, 18 Aug 2021 07:56:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2BE060C17;
	Wed, 18 Aug 2021 07:56:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 945984BB7C;
	Wed, 18 Aug 2021 07:56:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17I5iSeM014833 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 01:44:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 254E6205EA8A; Wed, 18 Aug 2021 05:44:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F7E12044737
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 05:44:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F0DC800260
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 05:44:25 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-165-o78ktw_AM9OjYyzdNoiiUQ-1; Wed, 18 Aug 2021 01:44:21 -0400
X-MC-Unique: o78ktw_AM9OjYyzdNoiiUQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17I5g9Au000916; Wed, 18 Aug 2021 05:44:03 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agu24g3dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 05:44:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17I5eoOd150680; Wed, 18 Aug 2021 05:44:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by aserp3020.oracle.com with ESMTP id 3ae5n8u99p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Aug 2021 05:44:01 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16;
	Wed, 18 Aug 2021 05:43:59 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::bc10:efd4:f1f4:31c7%5]) with mapi id 15.20.4415.024;
	Wed, 18 Aug 2021 05:43:59 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
Organization: Oracle Corporation
Message-ID: <beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
Date: Tue, 17 Aug 2021 22:43:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
X-ClientProxiedBy: SN7PR04CA0230.namprd04.prod.outlook.com
	(2603:10b6:806:127::25) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.159.249.154] (138.3.200.26) by
	SN7PR04CA0230.namprd04.prod.outlook.com (2603:10b6:806:127::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19
	via Frontend Transport; Wed, 18 Aug 2021 05:43:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34471138-98fb-4935-d0c9-08d9620b2cd9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB481369FEC0E11BBC4FAF28BAF3FF9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: AhcUfsrfu3GBc20c/M0FejxayUFFCCeWvwmwNAIuvy42zHW/tAlXDMTgpVMNemrnlsOixp8Cx1ajNI6z/71F/JG81It3kdvqLVp+ug/cQZUOHmPLrTmFVQaLW7se+0Am/ATJ8I4MeU57+fWTNRS2aKGPYYBuX5Ni6CdvJ+d7Nl0z2dJweeQBvA4UTNJuKn+eZKc/n1y4pdJmyZQXWZSjwpZyLAwBHNEpMWyg98T/fl2Ikrp0enFf9o8fk/q3jQcKxGpdFLO3bzDVTb4x5Y40SWCUHMrMm5fjuskCtLL88ls2m+TdffxjTxcZsyD77FMKzggoE/E8XkeAZuY8tYcAYKTAXKLR0g/cNHXp5BKrxFLxqR75QZbRAk9Tcp1aZeXbUQjrvy+S0n0lsjZA1imbbagv2Xs0C8LrqcwoIm3TH58LpczRJZMPTI0zOBRJhWSFFiiCRDBsRDXGGXsFaern5XW05T3tRhg3+HqqmZAmbofpOYTVuYD4hetZJbybyzu9WlfI9tOWDO2OLilbtyVhV9VFtvWWfvvmOk+k8isW2U1nMG8X3kSR/qFu/ZkahNvU2rqeyNCp8PwMAQL4ZXnkoUpCx5KVMmnplBkmjc81HKHnCZJNcRwtZUce0d52I4JqXiyUX8dItZiADUgFbg2AgJt7S3LS4gv2FpU/VhycH1WlzsdWsOq4skr0cX+aM0GiH7SWUbP0aN5jbewZxqc9JLZEgYQRkp6zX8Qr8X9MNv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(8676002)(53546011)(36916002)(66946007)(2906002)(66476007)(8936002)(86362001)(83380400001)(36756003)(38100700002)(478600001)(66556008)(7416002)(4326008)(26005)(31686004)(956004)(6666004)(31696002)(5660300002)(16576012)(6486002)(44832011)(2616005)(186003)(316002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjZML0dINXFWajRoZUNkOXJsbWFyem8zMkJMWnhjOEdiR0Y0bXZnSlk0QmhN?=
	=?utf-8?B?ZTBlczhJd0p3OExPY3BYQldWUTJ0aWEvQ2JhclBmWEo3L21qdm4veUY2a1Z1?=
	=?utf-8?B?d091UE4zMGcyVjluOGZkUEdpUkhldlMzQUo1eWpKVVZJREwxVUt2dTdhcnJN?=
	=?utf-8?B?MnlYRnJ3c0hFR2NWNFpaODFvWEorL0JHYUVHTkJqa1pZZ1ExTit4cjhhemJ5?=
	=?utf-8?B?bER1K0dxbi9OTFRBaG1rR2RMNHdJaGdodGh4eGdCUnduZUdMUHFtS2phUmQ5?=
	=?utf-8?B?L0kxaW9aTndrR1JGYkFNZFp6cHkwc2RPT3AvdXJZaEp5RklZRXRkaUh2TnZm?=
	=?utf-8?B?N3c0MWFQL3VucWtwbkJKQ3NEWnMzcy9pZngvYUFMMFdQbnIzUkFHOHJPcmhJ?=
	=?utf-8?B?bW9HMk44SGJhT05JaFFTSVhRZWN1dU5lMnpmVnlJWHRwdk00V0JtNmVNRlM4?=
	=?utf-8?B?MndWVFNoOGloVGJxbXBDYkJJdTFGR2FRRGhqZEorR1U0NXJpT3RtWU5CZW91?=
	=?utf-8?B?YUJwRzl6ZXo5MUU2dnFwSjRpT0IvcGhwVVRXMzRNU2ZjMjV3YXE1UE1KaW5y?=
	=?utf-8?B?OU5ualdLUUdNcWllcHJMa1BkZmFJWThIdXNZcXpXUUFYTEJhM01iVkxTKytm?=
	=?utf-8?B?Tk5semQ0NUYwVWFHeDhGSTRJdCs5RFVHMEMwdExrZjlQT21jbVdDWHFuZHN2?=
	=?utf-8?B?Y3hCMFIxa2lqV0JwTTA5Y2h1eXIxRzFnZTFmV0Jqb1hDOWdJbWhsN2NJYkgw?=
	=?utf-8?B?R0pIVnlMcjBlVkFkSi9iRGU5SmUyUWNBTHd0a2VEa0hqWFhJQlppcjdWYjEr?=
	=?utf-8?B?L2NXYkg4QmZZTk84aVpXYTBTWUlzRDljKzRLb3lvN3JzNEhzdXZPRVBJVnFI?=
	=?utf-8?B?U0pha3BiSjQ2emcyeFFXUGhpWGJpNFRNVXp2VURNTjBHMk8xYTY4N0crVzZn?=
	=?utf-8?B?Nm5mOVVFVU9tL3lsSWI0YVZwNHk3b2U4cTlUajZ6V2E1czBIb3lvcVJRN0Mv?=
	=?utf-8?B?emlpT3U2UCtNYWxLdnJPektzNHVldkNmcHJxVThiTkxYTkhlemFBWHBTaFBW?=
	=?utf-8?B?N0F2cTdyVm5NT1BadEpyZ0h2RmNzYy9kZXp5UmtQNzY2Tll1R21KZ2Fxb2lH?=
	=?utf-8?B?U3ZPbEt0Wmc5elJlSTBkbUFUODQwU0FJWmlaMFI4VmZESzFBS0VkOUlsSUVP?=
	=?utf-8?B?R3dzek5ETFZNVUh3WHhVY0xoY1lCdGVTVnVjM2UyamFjMWFDTGpTMzZ0amVl?=
	=?utf-8?B?WGZDWkR0RTY4Y1dsM2JhS0xWbTlzb0ppMHZ1MlJrcjJwM1FWMVR2Z1hyay9C?=
	=?utf-8?B?RHFlL0tHaTNiakxGMFlEQzV1SVlKSExTUzh4cnhjdGpOYjJhbDQ0bW9hT3ZJ?=
	=?utf-8?B?UmU2QUFwU0dOSjZla0FpY0syWXhCaE02K3kwVFV4WjByMk9XMUpXdW1rNEQw?=
	=?utf-8?B?VkNBQ1pBamxRcFBQcTBXWk9WMUNrVHRrZGc0MTFNUnhKekpzTTFsR3g4Ymow?=
	=?utf-8?B?VkJqNklxaVNWM3BPc0lacTlSZ3YzMjExc2RaWGZVd2FtUmtiY1kyUzNWd01r?=
	=?utf-8?B?MlNxai9Vck9ZazkrNmhBY2ZYS2RkYllBTWpMdGJrZFhxY3daeE9oS0gxVWxk?=
	=?utf-8?B?QzF0SjZaclk1cVJQWnFUUzRTSG1YWk9tYTJHWDMzN0I5Tndhc3RiWllXUGt5?=
	=?utf-8?B?NjEydHhvZnE3WHg0MnQ1OEJxaUg0TTZidk95ZVlkVTRFUmt5QlNkLzNaTksr?=
	=?utf-8?Q?7UtdhNT5SL6OtvkPYqPtH6hjsE8Xu6iRywidxHu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34471138-98fb-4935-d0c9-08d9620b2cd9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 05:43:58.9107 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJIDL0oAHbnk68nM23JVP6kLfv1o2aMEEaWOgrff6JFRomzxz+CzMCrK/Pe2OxEZYtcZUwtdB3C9EtZ/con0Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108180035
X-Proofpoint-GUID: _g0KuBJjGJrbh39sATFznJ9HFw1qCnrv
X-Proofpoint-ORIG-GUID: _g0KuBJjGJrbh39sATFznJ9HFw1qCnrv
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0b-00069f02.pphosted.com id 17I5g9Au000916
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17I5iSeM014833
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

TW9yZSBpbmZvcm1hdGlvbiAtCgpPbiA4LzE2LzIwMjEgMTA6MjAgQU0sIEphbmUgQ2h1IHdyb3Rl
Ogo+IEhpLCBTaGlZYW5nLAo+IAo+IFNvIEkgYXBwbGllZCB0aGUgdjYgcGF0Y2ggc2VyaWVzIHRv
IG15IDUuMTQtcmMzIGFzIGl0J3Mgd2hhdCB5b3UgCj4gaW5kaWNhdGVkIGlzIHdoYXQgdjYgd2Fz
IGJhc2VkIGF0LCBhbmQgaW5qZWN0ZWQgYSBoYXJkd2FyZSBwb2lzb24uCj4gCj4gSSdtIHNlZWlu
ZyB0aGUgc2FtZSBwcm9ibGVtIHRoYXQgd2FzIHJlcG9ydGVkIGEgd2hpbGUgYWdvIGFmdGVyIHRo
ZQo+IHBvaXNvbiB3YXMgY29uc3VtZWQgLSBpbiB0aGUgU0lHQlVTIHBheWxvYWQsIHRoZSBzaV9h
ZGRyIGlzIG1pc3Npbmc6Cj4gCj4gKiogU0lHQlVTKDcpOiBjYW5qbXA9MSwgd2hpY2hzdGVwPTAs
ICoqCj4gKiogc2lfYWRkcigweChuaWwpKSwgc2lfbHNiKDB4QyksIHNpX2NvZGUoMHg0LCBCVVNf
TUNFRVJSX0FSKSAqKgo+IAo+IFRoZSBzaV9hZGRyIG91Z2h0IHRvIGJlIDB4N2Y2NTY4MDAwMDAw
IC0gdGhlIHZhZGRyIG9mIHRoZSBmaXJzdCBwYWdlCj4gaW4gdGhpcyBjYXNlLgoKVGhlIGZhaWx1
cmUgY2FtZSBmcm9tIGhlcmUgOgoKW1BBVENIIFJFU0VORCB2NiA2LzldIHhmczogSW1wbGVtZW50
IC0+bm90aWZ5X2ZhaWx1cmUoKSBmb3IgWEZTCgorc3RhdGljIGludAoreGZzX2RheF9ub3RpZnlf
ZmFpbHVyZSgKLi4uCisJaWYgKCF4ZnNfc2JfdmVyc2lvbl9oYXNybWFwYnQoJm1wLT5tX3NiKSkg
eworCQl4ZnNfd2FybihtcCwgIm5vdGlmeV9mYWlsdXJlKCkgbmVlZHMgcm1hcGJ0IGVuYWJsZWQh
Iik7CisJCXJldHVybiAtRU9QTk9UU1VQUDsKKwl9CgpJIGFtIG5vdCBmYW1pbGlhciB3aXRoIFhG
UywgYnV0IEkgaGF2ZSBhIGZldyBxdWVzdGlvbnMgSSBob3BlIHRvIGdldCAKYW5zd2VycyAtCgox
KSBXaGF0IGRvZXMgaXQgdGFrZSBhbmQgY29zdCB0byBtYWtlCiAgICB4ZnNfc2JfdmVyc2lvbl9o
YXNybWFwYnQoJm1wLT5tX3NiKSB0byByZXR1cm4gdHJ1ZT8KCjIpIEZvciBhIHJ1bm5pbmcgZW52
aXJvbm1lbnQgdGhhdCBmYWlscyB0aGUgYWJvdmUgY2hlY2ssIGlzIGl0CiAgICBva2F5IHRvIGxl
YXZlIHRoZSBwb2lzb24gaGFuZGxlIGluIGxpbWJvIGFuZCB3aHk/CgozKSBJZiB0aGUgYWJvdmUg
cmVncmVzc2lvbiBpcyBub3QgYWNjZXB0YWJsZSwgYW55IHBvdGVudGlhbCByZW1lZHk/Cgp0aGFu
a3MhCi1qYW5lCgoKPiAKPiBTb21ldGhpbmcgaXMgbm90IHJpZ2h0Li4uCj4gCj4gdGhhbmtzLAo+
IC1qYW5lCj4gCj4gCj4gT24gOC81LzIwMjEgNjoxNyBQTSwgSmFuZSBDaHUgd3JvdGU6Cj4+IFRo
ZSBmaWxlc3lzdGVtIHBhcnQgb2YgdGhlIHBtZW0gZmFpbHVyZSBoYW5kbGluZyBpcyBhdCBtaW5p
bXVtIGJ1aWx0Cj4+IG9uIFBBR0VfU0laRSBncmFudWxhcml0eSAtIGFuIGluaGVyaXRhbmNlIGZy
b20gZ2VuZXJhbCBtZW1vcnlfZmFpbHVyZSAKPj4gaGFuZGxpbmcuwqAgSG93ZXZlciwgd2l0aCBJ
bnRlbCdzIERDUE1FTSB0ZWNobm9sb2d5LCB0aGUgZXJyb3IgYmxhc3QKPj4gcmFkaXVzIGlzIG5v
IG1vcmUgdGhhbiAyNTZieXRlcywgYW5kIG1pZ2h0IGdldCBzbWFsbGVyIHdpdGggZnV0dXJlCj4+
IGhhcmR3YXJlIGdlbmVyYXRpb24sIGFsc28gYWR2YW5jZWQgYXRvbWljIDY0QiB3cml0ZSB0byBj
bGVhciB0aGUgcG9pc29uLgo+PiBCdXQgSSBkb24ndCBzZWUgYW55IG9mIHRoYXQgY291bGQgYmUg
aW5jb3Jwb3JhdGVkIGluLCBnaXZlbiB0aGF0IHRoZQo+PiBmaWxlc3lzdGVtIGlzIG5vdGlmaWVk
IGEgY29ycnVwdGlvbiB3aXRoIHBmbiwgcmF0aGVyIHRoYW4gYW4gZXhhY3QKPj4gYWRkcmVzcy4K
Pj4KPj4gU28gSSBndWVzcyB0aGlzIHF1ZXN0aW9uIGlzIGFsc28gZm9yIERhbjogaG93IHRvIGF2
b2lkIHVubmVjZXNzYXJpbHkKPj4gcmVwYWlyaW5nIGEgUE1EIHJhbmdlIGZvciBhIDI1NkIgY29y
cnVwdCByYW5nZSBnb2luZyBmb3J3YXJkPwo+Pgo+PiB0aGFua3MsCj4+IC1qYW5lCj4+Cj4+Cj4+
IE9uIDcvMzAvMjAyMSAzOjAxIEFNLCBTaGl5YW5nIFJ1YW4gd3JvdGU6Cj4+PiBXaGVuIG1lbW9y
eS1mYWlsdXJlIG9jY3Vycywgd2UgY2FsbCB0aGlzIGZ1bmN0aW9uIHdoaWNoIGlzIGltcGxlbWVu
dGVkCj4+PiBieSBlYWNoIGtpbmQgb2YgZGV2aWNlcy7CoCBGb3IgdGhlIGZzZGF4IGNhc2UsIHBt
ZW0gZGV2aWNlIGRyaXZlcgo+Pj4gaW1wbGVtZW50cyBpdC7CoCBQbWVtIGRldmljZSBkcml2ZXIg
d2lsbCBmaW5kIG91dCB0aGUgZmlsZXN5c3RlbSBpbiB3aGljaAo+Pj4gdGhlIGNvcnJ1cHRlZCBw
YWdlIGxvY2F0ZWQgaW4uwqAgQW5kIGZpbmFsbHkgY2FsbCBmaWxlc3lzdGVtIGhhbmRsZXIgdG8K
Pj4+IGRlYWwgd2l0aCB0aGlzIGVycm9yLgo+Pj4KPj4+IFRoZSBmaWxlc3lzdGVtIHdpbGwgdHJ5
IHRvIHJlY292ZXIgdGhlIGNvcnJ1cHRlZCBkYXRhIGlmIG5lY2Vzc2FyeS4KPj4KPiAKCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

