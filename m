Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197E6C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Apr 2022 04:15:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-q7yUxoraOVyYUNrm1gsObQ-1; Fri, 22 Apr 2022 00:15:48 -0400
X-MC-Unique: q7yUxoraOVyYUNrm1gsObQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB2C686B8A0;
	Fri, 22 Apr 2022 04:15:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8285340EC000;
	Fri, 22 Apr 2022 04:15:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 359431940350;
	Fri, 22 Apr 2022 04:15:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6B33194034C
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Apr 2022 04:15:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A36FC5671CC; Fri, 22 Apr 2022 04:15:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DBF8551195
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 04:15:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D5C729AA2FD
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 04:15:45 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-4ObWIHtDPv2C2vxCz73qIg-1; Fri, 22 Apr 2022 00:15:40 -0400
X-MC-Unique: 4ObWIHtDPv2C2vxCz73qIg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LLnrAP014729; 
 Fri, 22 Apr 2022 04:15:23 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffndtnqav-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 04:15:23 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23M46Jf4007863; Fri, 22 Apr 2022 04:15:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3ffm8d5f61-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 04:15:22 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3349.namprd10.prod.outlook.com (2603:10b6:a03:155::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 04:15:20 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 04:15:20 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax access mode
Thread-Index: AQHYVFsQsaUDJAWZ/UKYy6bMSO9seaz58VqAgAFlF4A=
Date: Fri, 22 Apr 2022 04:15:19 +0000
Message-ID: <7736b8b0-4265-4291-c699-e4a9cf1825c5@oracle.com>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-5-jane.chu@oracle.com> <YmEAS5hi7Os9Lgcq@infradead.org>
In-Reply-To: <YmEAS5hi7Os9Lgcq@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c54d90fb-c310-4531-9d9a-08da2416b6c4
x-ms-traffictypediagnostic: BYAPR10MB3349:EE_
x-microsoft-antispam-prvs: <BYAPR10MB3349E8EB33A5ED57E70F039BF3F79@BYAPR10MB3349.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: aQRkqj7cKlVIMST3L3PpbqFyD7JLRbjfEdyZPTVgvR/vlm4JGQq3czDfrLAKS8xgp3gErrxcZz41ltI5xNMPT73tg7/nfyerhPO2OnypSXQMIeDXNlnVLPX+zHImF9+mSglth2bbtbLSyD106FmXvnDCEKMFoe77tIifNOvoX7WzalD5WHFq2EzBfbZx7IZhkIfg4DkNhA57H1RGbui5rO5TVHDn7Xsq53xPSZCSaM2Lu7PAfbRlYQMKTJfnfAM3wjV3x7y8TshFLDBrYFh+GSRQQOYCVeX0Q5qMnQ1cEwpj8ru2cW/BJM4wSCng8wa6d1ZfSJIhB2m1ReQDx3jjMFgXkmHtr3Bf/JrAE19CNnkCLL+4tEUctosMbobdwBwXbXnoF34k8zR98OfMx9y1spXd+HtPkIVMIDtfIJ0tHvprCfTxOgzNVmomJDtDI7UZRdkZfQI7Dp52VNcfKgkFQI7ncC+/pDoiVbGjzajWoKE5kRr3F+XMWq7NwA/3RfGdycc1mik3Y0So/TvmuHrlXv6csemgul7sjQeWKL01xSnc1nHp5jXuCXw9iJ6IEVhG09zZQEg3qOcRucVEqcgSXOXrrQu19iuvTiQydZsvgzZjYizPoeluuJeAYHkeoXPBuo0Dr/bRsi5i1lFfm1sGxTnBWIuU0i122veSTFBd3G/ZjINu0uEiTqDos9kh4jIhTD86LXbOLwpXfb0aD/8p1yeaOqPRqrAcOXInGQ2uZWF4rB5HFiTUj1JbnECrhb6v0RxYqhh2BrCNVxxnVfdoWA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(76116006)(83380400001)(64756008)(66446008)(8936002)(186003)(66476007)(8676002)(66946007)(4326008)(31686004)(6512007)(122000001)(7416002)(53546011)(86362001)(26005)(2616005)(31696002)(5660300002)(54906003)(6486002)(44832011)(66556008)(38070700005)(6916009)(71200400001)(316002)(508600001)(4744005)(2906002)(6506007)(38100700002)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjRQODE2bFVQVEZvaVB1NTl5VkZVa1psUU05cHpWQVMxa1JFSTVXZkltamZy?=
 =?utf-8?B?c2pTTW5OQTFNcWNDcjhJYnZqWWdaZ3FPNEpGZE5iOXhCTE5DejIzcUZPcFQy?=
 =?utf-8?B?amVaT0dDMWRHRmZZMDZmNlk3dzM0WjQ0V0xBcDI5NzA0WEtudW42K3hOWHlW?=
 =?utf-8?B?UzdkcW4rUW5UR084MUdSZ3paSWJCYWhjeTdrcDM4QWZucENMOXIrL1g5VkdT?=
 =?utf-8?B?aVp4dEtzKytFRmY0d1djZmx2cUpMWGJobWVCUmhBeEUzR3JXTE5mOExkUTFi?=
 =?utf-8?B?TGRzZGlEUzEyakdZb1REOGpHdnVCWmorRXh4azlhcWI0eklhRHN4VWx4SmR0?=
 =?utf-8?B?V09CQTJBK1RyNS81cXZ6MXN0ZVdhU0NxMnF1VnRpMjdwYUpsd2dyRE95Vkdj?=
 =?utf-8?B?WmlCY2tBMjZ6NXhrSVBka2tBNHEvamFxTEptYVlCNjZkTWlUVE5UM3JZa2gr?=
 =?utf-8?B?eEZrakF1dm9DdUUrSWVwUC9JcHcva0VTU0dvZUFKdkVrZGltNVplT0FNeWp1?=
 =?utf-8?B?WVV4N3dJTE13NUpzeWoramhOelVKSFp3eVQvWmF5TWhRc2kyOXVtS3ZiUU1j?=
 =?utf-8?B?S2hCS25weU5GTW1tMUdkcTRYZTNYdHFrS2Raa1FPZVB4clpwbTc3QnVWcWhG?=
 =?utf-8?B?c1JVazc3MmJBUGQ2TlVTbjF0QnlpUlVzVE1VclZ6M2tTMC94SG5JMDRBdlpY?=
 =?utf-8?B?N1M4Z3JjOGFSalY0dEJDVXRiYXFxWUdIR1lRK05nMFk1MjNBMUMxRlRVV2xi?=
 =?utf-8?B?bFh2Y3R0Ly9jY256SXMyM1NrVW45V3R6S1pDZGE4bk9jK0kxTWxwdHd0d0dk?=
 =?utf-8?B?OFlYbm5nZjdNSHgrbHhabXl4SlJObVNJZ3QyZGNXWVF1MFVFckxmdTB3YUhL?=
 =?utf-8?B?dGVGRXllOEZWM3QzcjJ0eElmSCt5UEw3RmNFK3Q3NCtQMjRoMVNZY1k5eGZW?=
 =?utf-8?B?SGZCVGRYdXkwYlNIc2JHUDRHYUdLZkczR0NzY3hHVVkzT1d6bmhkNUFSS2JX?=
 =?utf-8?B?b1hZMFBFd0pPbHhZV1BNak94dTRhVi9wMDVvaC9wMjlMeURBL2dib2M4b01C?=
 =?utf-8?B?bWJnMTdNSkFMWDBEUnpRbzhKMmtJbEcyNjcxSE0rWkZpOGE1cXBFNFVXYjFj?=
 =?utf-8?B?NkZJelIySFczYmY1bW9DU1lsbU9wVVFRTzJJUWJESEhEQzBwN1luYk95Tmpn?=
 =?utf-8?B?c0cxYlA1dVNTN0ZTbi9xWjVMUUY0bVc1OUloLzNuNVl3MG9lSFZYZklhdFMr?=
 =?utf-8?B?RFdHRHRpTGVUWXVYb0ZSV1o1b2Q1a1pha0hibDVjeVJFMEl3MEd2WGhCT1pM?=
 =?utf-8?B?c1p0TjdaOUlUUXpzRENLbytQSlVMbkc4cUcrZHR3UUkvaDg0ZHNpQzU3ZGRh?=
 =?utf-8?B?UWl5VkJYeVRIeFcydUtBZFhDV1ZPNVcwZzZwWFVvUnp2T2p2UmVyMllhbXZH?=
 =?utf-8?B?OU9OVHRKemdtU1BTYytnWWpsbVRabGljYTJ1QnpHemVDbnJib2NNdm9acVpS?=
 =?utf-8?B?VklnSjBTandDNEQxR1I0Z3RaNTlPN2QxUmR4ci81aldUNnFwQnFxblRHZENF?=
 =?utf-8?B?NEFyVzZXbXM4bkt6RDJncDZKenBHcHczM2FvSjBIYjFBSFlOODQ3dzZnSnIx?=
 =?utf-8?B?VER3ZkJjM05qZ1diLzNIN2lQQ3JBMHQza2VDWVd1UnhwTHhjd1pPblR1Vkhu?=
 =?utf-8?B?cnh6VDBJK3VScXduTUsyaVgrT2JocTBpbTA2bURzM01yUlNMMEp0V1ZxVWIr?=
 =?utf-8?B?L0I5WjllK2FQT0dOUUN0Mld1bk00aDMvUVA4ZXNjSStuM2tGbEZJekVSd1NQ?=
 =?utf-8?B?UFFGZ2c3MGRwZHlyT1hLRkV1ek9FUVkxbGUzTUtCMmRsZUxlSzhoTlUxeUU0?=
 =?utf-8?B?MGJGRVBPRE41M3UyRlhLVlNjdEkvdUpVN0d0RnhKNTh0MVlzZG4zUjNMZ21o?=
 =?utf-8?B?VzJWenFiK0FncXM1REdhZUFSUFhtL0FDVmEwT0YvN1EvazVvSHBZVm9jU2h6?=
 =?utf-8?B?M04rTGFXakdZVzhBQmlabmJITm5LR1huK3NUb2FwTmRZSnRCSndGUnV0emtt?=
 =?utf-8?B?TkhnRFRJZG50U0srMTlKSTN0TEhrSCszaEdRQXdMbUw1bGtjZkRManNYT3Ey?=
 =?utf-8?B?aTBRdWhZQ0cvejBGM1lkL1Q0dVFKMVo1dW1LV2FUb1dIbysyU0dWZkdyVEh6?=
 =?utf-8?B?Z2NLQ3RkZkRJejlxam16bk9JVmkvRmFuTjJtWVRIaUNFNmZ4T3RqTnpQUDFU?=
 =?utf-8?B?ZnV4Ujltc252SHFtMTlqbmFLa3BISjZIcU5pQWEwMi9kOWVicysxbnJwa0hW?=
 =?utf-8?Q?d/wErfMWsN8IRx8J9J?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c54d90fb-c310-4531-9d9a-08da2416b6c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 04:15:19.9940 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZJAwyk70Ey3CsG7hnXWLY/mcJW2qwb+/uZ0FCT9z40n7vvqbVdHbiT3RcKB3HoBftHoMLvigA/owgvyWRZYGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3349
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-22_01:2022-04-21,
 2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220015
X-Proofpoint-ORIG-GUID: ZKUbVh6m9tygZcpOGXuE8R1w6sha6g1Z
X-Proofpoint-GUID: ZKUbVh6m9tygZcpOGXuE8R1w6sha6g1Z
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax
 access mode
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "dave.hansen@intel.com" <dave.hansen@intel.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>, "luto@kernel.org" <luto@kernel.org>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <085B955EE9A45C46B1EA12D53A0C6059@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/20/2022 11:57 PM, Christoph Hellwig wrote:
>> +	if (bb->count &&
>> +		badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
> 
> Weird alignment here, continuing lines for conditionals are aligned
> either after the opening brace:
> 
> 	if (bb->count &&
> 	    badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
> 
> or with double tabs.  I tend to prefer the version I posted above.
> 
> The being said, shouldn't this change even be in this patch and not just
> added once we add actual recovery support?

Right, will move the recovery_write related  changes to next patch.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

