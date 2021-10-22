Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7FDC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 20:56:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F05FF6112F
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 20:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F05FF6112F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-1rb15CC_OEKSZ8qaJ-yxuw-1; Fri, 22 Oct 2021 16:56:01 -0400
X-MC-Unique: 1rb15CC_OEKSZ8qaJ-yxuw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E82B801FCE;
	Fri, 22 Oct 2021 20:55:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 592B9ADF9;
	Fri, 22 Oct 2021 20:55:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 958CD4A703;
	Fri, 22 Oct 2021 20:55:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19MKrCVf022716 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 16:53:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C2145D016B; Fri, 22 Oct 2021 20:53:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB0D4CF616
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 20:53:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E847F1066558
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 20:53:09 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-397-fWcSKQd2N3SUwW0agUYxVw-1; Fri, 22 Oct 2021 16:53:06 -0400
X-MC-Unique: fWcSKQd2N3SUwW0agUYxVw-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19MJ9qn5026503; Fri, 22 Oct 2021 20:52:59 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bundfmjem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 20:52:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MKjL1Z065182;
	Fri, 22 Oct 2021 20:52:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by aserp3020.oracle.com with ESMTP id 3bqpjb69eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 20:52:57 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB4623.namprd10.prod.outlook.com (2603:10b6:a03:2dc::5)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15;
	Fri, 22 Oct 2021 20:52:55 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 20:52:55 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
Thread-Index: AQHXxhAze/H2dZp4I0O0xNcfyRn+pqvdUicAgADsdoCAAELPAIABAAaA
Date: Fri, 22 Oct 2021 20:52:55 +0000
Message-ID: <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
In-Reply-To: <YXJN4s1HC/Y+KKg1@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f68e89e-66b7-4332-ce14-08d9959dec72
x-ms-traffictypediagnostic: SJ0PR10MB4623:
x-microsoft-antispam-prvs: <SJ0PR10MB4623D231008406D117BA8B8FF3809@SJ0PR10MB4623.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1+pagA++qWelxE9tCbikAUz87/MUTVPdJHAkWIKJDyADOB2V4vaKU3jwQM6l7YkukgHJEq/Uct85tXBswjZqnUKAmXQE+XCV5/cGiTG91jbPKgjFitWOuDPBKXJF7S8oe4pJf1T+RXAOc/Hd2UZO8uHSPiOUkf41vWS35jTQR4ERQeD0jPMFEiigsd516ddPoc30vUpXH3EV9EQ6W7UJY2+Kp69FhDxQVdHEFJ1bkcfvIsZzeJG0ZtzI0SJ2zqJkgC/y2k4jGty3cVb8397ySx71OBI1AvKhDRjnD8h0dL1SVpDt5wDgpl1Z644BsSjK4t2fiYm9DJbwnLd2/VNY/XHG7calvCpAhwwkWezB8tmVT3dM4ro/ZMHv1UK/14PizcJQGdgQ2O/eqm7F3Rq4sbwUhQ+AUfLe8hPvEcQpuC0fDcKAaO60lE1rnVquGz34VZW0EZSz8s7L4NTCBKlFi6x+k4mMFzKaz0wDWdjY8TZT4XXjy5XjTbpEDG9wkA/Y9QJzxPc5sWGKnRuXPlKyDTXL52gZ4z0ZN9Tv2t3nbcHB17duho89K0JR6FOFdRjDFU5H3JVaACZWgHupdZuwCELQs3hFKbDziia/unhKA6MqZSf8xn95miH/4CVUk7bjfruL6+WCZ4TVdknN5yVGZx+V3mGfMOl6DT1fRyBzm0ASsXQtUBKCvca5CIM8YazRhR7Gsh7OBtS72pvpJFtUkneRwxEarswWzDT8fQ+72MFrpwD3jVd378kR3fa171cR3k3k3Ay3Pr4l8BVKYnxJPg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(36756003)(8676002)(8936002)(508600001)(6512007)(6486002)(316002)(7416002)(2616005)(6916009)(186003)(44832011)(31686004)(76116006)(5660300002)(91956017)(4326008)(66476007)(122000001)(64756008)(6506007)(66946007)(38100700002)(66556008)(71200400001)(86362001)(66446008)(54906003)(38070700005)(2906002)(53546011)(26005)(31696002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TituSWhLckVvcXJuOXBWbUU1aVFwR2JlNktxckE5THNhS21hUlhCZ3pnTEJV?=
	=?utf-8?B?TEhuYjlqRnJhMGp5eEU1Ym5Zd3hNajkzem56dTlZL2xNNUxsamwwUXlMcHlo?=
	=?utf-8?B?L3Zpd0NOZU82aXJsQXNHMVQxMndMRnJwZFB6c0FKd202MzBMclJnZWpHMjZI?=
	=?utf-8?B?RlNieFZvSzVDemxhcHFFbTVzK3J4VFhqaWhWMHpxSlRqZWN5YXV2M1htWmNQ?=
	=?utf-8?B?M1QvUWRoaEhpR2IzOUZYb2lvYUY5TnNPWjhIUlI0Z2VSSkRTMHVnS2R6TWZr?=
	=?utf-8?B?bTFZcVRaZ1ZCbVUwR2w0TzYxelpVeDdzRFZVZXpxOG94NUJ5eVdxYXZLOUYy?=
	=?utf-8?B?OGh3UzNRamlIcE5SZTdhNXNERDg1RlJtTWFpZEZ5cEZ4YUpRR3hQUVoxa0VR?=
	=?utf-8?B?dzBrSmVvY01yOWNJMVFZNnc5Q0IyRkZhSUdkTFJvTVJaVXE4blhDL3E3U013?=
	=?utf-8?B?Nk9BVGMzdkUwbFAyM3d0TXp6RjJmNDYyY2YvY1haTWhXL0JCd3N3c1FBc2gv?=
	=?utf-8?B?TDNZQS9YeExWcW1TcHdkV1poWlNhOGplUVhIcE0zZHE3YS84Rnl5bHp0TVRm?=
	=?utf-8?B?Z3NCcXVLYWZiUEVnZndRdHBIS2ZERU5rQnNOaURRdVR1cklqeXpmaHl2Z1FD?=
	=?utf-8?B?THBuWHdQSlAwZm10WnFmdzhBeDNTK1R4a0l3Vi9CcWEvRUtmMTVSbnNPMlZ2?=
	=?utf-8?B?T3RzUDBJMzJsMXVod2p1dTQwck1rcFp1NktYeUw1ZDVlMnYya1NLZnU4UnZV?=
	=?utf-8?B?OXYvSVh2RWoyU2MyUWdsQ1V1UkhjSHZiT0NqSFlQUlpFQjZmQ0duZzNpcTFW?=
	=?utf-8?B?bzBydmxWWHkxaUR2UU15cndEcmxua2NCNldFVWorVUxGNHM4UmsyZTNENktx?=
	=?utf-8?B?eHZvdGJRM3B1UnZvWEp3QjVIR0JEVWdjdXBieVRzM0J6TTVVUGxNK3g3aWRr?=
	=?utf-8?B?OUdoOEJKSG8xdG9NbzJXc09zVE1QV1VNNzlsL3dPcERxMm1SMkk3VW82SGox?=
	=?utf-8?B?SUNKQnQxT1dTUjhWSXlQb1JOVXE0bnJvMFZyR1FkQkhqUStma1dFM2QzdzZX?=
	=?utf-8?B?dzNvK0dEK3l2VnNuMTM2blJkS3RvZTRYeEVpckVpNkdyajdIQi9qSlU5SXpB?=
	=?utf-8?B?Sk5laytlQzRuTXJxSTRLMkxnNnVCRlNDU09Wcjdta3hScy9WdjNMVUl6WXc4?=
	=?utf-8?B?U2xIYmd0bGJabksvZmcwU01OV3lhWnp5RkN0K0lFQW96ZENocHBsZGllSnp5?=
	=?utf-8?B?TTVPNGxTSks3OHlnQmxzU0VkYzNNeE10ZFZ1bkZBS250ZEdYNXlINDBmSDB4?=
	=?utf-8?B?Y0lTY3JMUEIydStYbHFjM2s0YUZRb2dORGIvVy9JS0dhUHU0TlB1UmVMeDY2?=
	=?utf-8?B?dzd5aHd4eG8vQ0NYM2lRa0hFS3kyMTVaWFNvRTNHRDdZQWl5ZTNGOEtVRUNV?=
	=?utf-8?B?ZC9tMGcvaDlVdFpEUGFybU9mVDhpcnJ6K2M4M1FUbVU5dnludThIWXZQVUhq?=
	=?utf-8?B?b3hSRURSd3JDWmtaM2ZxR1pjV2lYdUtwQ1QrSHo0UXBYeTdoQ3JzRk9UMzZj?=
	=?utf-8?B?REUxRzVoZk9QOXR3OXI2cHdIRlVFNXRlS3c3LzE2bGI5UUg0RTkyRFlBNjk5?=
	=?utf-8?B?VWtrV0lYNTZ2SjJXY3IzRDd6OU5iOWRCMElIeVpGcVNmRlVWUlVqbHBBc0pJ?=
	=?utf-8?B?eTBSTzJQQ2Y2Q2luNzhUQlV3VzdjZ01oRitTM0YxSHRTL0tIeWJVY3JUL2JV?=
	=?utf-8?B?eldFRXZiSVdibERMRWdIV2dWSk4xTVo4cTM1eVhCMTVLb1JIRDBMc0Rxamx1?=
	=?utf-8?B?TG5KZjhwYmJ1T202SmdLTVpMNEwvT0ZPWklSNkkzYzhTcGliYzhuN0RVZGRO?=
	=?utf-8?B?ME8vNkFRS0NMeDhMQUd3eXU1UVBtOXYwMEFQamVnU3lGRUJVSkx5eWxoSGQ1?=
	=?utf-8?Q?NRLlMph/UCg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f68e89e-66b7-4332-ce14-08d9959dec72
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 20:52:55.8060 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jane.chu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4623
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	spamscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220116
X-Proofpoint-ORIG-GUID: oqQeaT9yd6Hlp7JCBzOms4Bzj7zHRQRI
X-Proofpoint-GUID: oqQeaT9yd6Hlp7JCBzOms4Bzj7zHRQRI
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19MKrCVf022716
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <021EC1710E3A6E4CA006BA3EBA297DF4@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/21/2021 10:36 PM, Christoph Hellwig wrote:
> On Fri, Oct 22, 2021 at 01:37:28AM +0000, Jane Chu wrote:
>> On 10/21/2021 4:31 AM, Christoph Hellwig wrote:
>>> Looking over the series I have serious doubts that overloading the
>>> slow path clear poison operation over the fast path read/write
>>> path is such a great idea.
>>>
>>
>> Understood, sounds like a concern on principle. But it seems to me
>> that the task of recovery overlaps with the normal write operation
>> on the write part. Without overloading some write operation for
>> 'recovery', I guess we'll need to come up with a new userland
>> command coupled with a new dax API ->clear_poison and propagate the
>> new API support to each dm targets that support dax which, again,
>> is an idea that sounds too bulky if I recall Dan's earlier rejection
>> correctly.
> 
> When I wrote the above I mostly thought about the in-kernel API, that
> is use a separate method.  But reading your mail and thinking about
> this a bit more I'm actually less and less sure that overloading
> pwritev2 and preadv2 with this at the syscall level makes sense either.
> read/write are our I/O fast path.  We really should not overload the
> core of the VFS with error recovery for a broken hardware interface.
> 

Thanks - I try to be honest.  As far as I can tell, the argument
about the flag is a philosophical argument between two views.
One view assumes design based on perfect hardware, and media error
belongs to the category of brokenness. Another view sees media
error as a build-in hardware component and make design to include
dealing with such errors.

Back when I was fresh out of school, a senior engineer explained
to me about media error might be caused by cosmic ray hitting on
the media at however frequency and at whatever timing.  It's an
argument that media error within certain range is a fact of the product,
and to me, it argues for building normal software component with
errors in mind from start.  I guess I'm trying to articulate why
it is acceptable to include the RWF_DATA_RECOVERY flag to the
existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
and its slow path (w/ error clearing) is faster than other alternative.
Other alternative being 1 system call to clear the poison, and
another system call to run the fast pwrite for recovery, what
happens if something happened in between?

thanks!
-jane








--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

