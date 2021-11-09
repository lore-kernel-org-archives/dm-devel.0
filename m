Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E6DC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:59:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EEB0661159
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EEB0661159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-oigsClvtOP63NoVLz_BcxA-1; Tue, 09 Nov 2021 14:59:16 -0500
X-MC-Unique: oigsClvtOP63NoVLz_BcxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50C2F1030C23;
	Tue,  9 Nov 2021 19:59:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E83360843;
	Tue,  9 Nov 2021 19:59:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3AF5181A1CF;
	Tue,  9 Nov 2021 19:59:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9Jx8tr016715 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 14:59:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CB7A1400E113; Tue,  9 Nov 2021 19:59:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6D22400E116
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 19:59:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A87D8802802
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 19:59:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-223-Iw08gnoSNYqzuVvbSsAR3g-1; Tue, 09 Nov 2021 14:59:05 -0500
X-MC-Unique: Iw08gnoSNYqzuVvbSsAR3g-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A9JiElS017452; Tue, 9 Nov 2021 19:58:56 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c6uh4pax8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Nov 2021 19:58:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9Ju21c091180;
	Tue, 9 Nov 2021 19:58:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
	(mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
	by aserp3030.oracle.com with ESMTP id 3c5fregrxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Nov 2021 19:58:50 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2488.namprd10.prod.outlook.com (2603:10b6:a02:b9::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16;
	Tue, 9 Nov 2021 19:58:48 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Tue, 9 Nov 2021 19:58:48 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Thread-Topic: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Thread-Index: AQHX0qwHA1irfgJJPUKt0/SD8Ofb86v60R0AgAC+aoCAABOLAA==
Date: Tue, 9 Nov 2021 19:58:48 +0000
Message-ID: <15f01d51-2611-3566-0d08-bdfbec53f88c@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<YYoi2JiwTtmxONvB@infradead.org>
	<CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
In-Reply-To: <CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 766ab48f-00c7-45aa-570b-08d9a3bb5879
x-ms-traffictypediagnostic: BYAPR10MB2488:
x-microsoft-antispam-prvs: <BYAPR10MB2488B68F64A84D5595DE5034F3929@BYAPR10MB2488.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: mWEameGwh0M8s0KVKPCAZL7NePCuNdut+4WEtEue9YH+9xnr+HH3mHZ4+NZ9lCirQpJftoLXgL6islWcOP8MvFlxZJkVPooeBBXHRuWrpQlXRsrd+Jso2eMk+dCtHQbZHkMjaJ1wQwNZBpf3TYL7426vdOsYzhBtyMhsfvqx0iNziAR4BfjhVuWr6jHPyIBNAvrrryNhdl3TlyoeetIXe7T2vDYFWJlFlOyX7uzOSYMrStAeppeMDIbBMQhwBr3oQRDtuxwUJFekh/UxfLfN9BzhVGHcijln3nZCReIvjQV+1h/ygyyjiTp80eAwiXON1mCNC2o4nBOcVAriIfXa43n2NXP0RRtR/U5TrGtZRC4DSbhwq0UCW2uHVKgIvrV6oD2o1xeNVBNVbDWhqCRWiP6QBTxZwDp/DpCkON21XAGPek1XPvw2rQt/Jvz26k1RxqHdvj3UvmnVDjrFTTWJK6bHE9e+oR+CflFqVAXm55VYzwR7BCNbD54bsSCW4Kh2hU82a8UZ2kKfzVcwMonvvl9736RzSWN4x8JKbom7MCk5O/1kDf5soveHvUsTynpT7YubwlcF9dmbbgo5lObyCf+qd9Bzn59VTlNO3YdVHGar7oGjNybZLQf0wj1IYQuGQ3/brTcnqcsl0sCgKomfGfysbGlvKZyz8QBc8ZKYc3ihdWRmQseu4zvT2J34/FdTTIZeSHCU9zWms9q+8/QY9TyEEn8vNvSkECOG4/Gntv1a+zymCDXYdcIeCCfRu1bJWRg/jMw8GKcm3jyTOLTNjQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(36756003)(71200400001)(8936002)(66946007)(66446008)(8676002)(31696002)(66556008)(316002)(64756008)(6486002)(26005)(110136005)(54906003)(86362001)(5660300002)(2906002)(66476007)(76116006)(38100700002)(6512007)(6506007)(122000001)(7416002)(31686004)(44832011)(186003)(83380400001)(2616005)(4326008)(508600001)(38070700005)(53546011)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVBEQnNNUFhiK1lCdnpxNjllWUp5TmpyR2VDdWZNKy85dmJkWlkyUWxheSs5?=
	=?utf-8?B?ckdJOTIzdEVXUHdta0FybXBVQjUvbDhaOE0xZEwwM0g3UVczUG11Z1lLTnJq?=
	=?utf-8?B?aEpkSUp1QUFhSG0wOXBGZEhDYXE4VzRuU3hyTFg4aUpMR2E2NlJIK1dnbE40?=
	=?utf-8?B?TEVDQ20zaUpnY3FGbkV3c3h3c1NMaXVpdnpMN3kxSE9jR0FtUmJLdUhTdnFU?=
	=?utf-8?B?U3ViRzFHSUxmL01IVEN5eXQ3OENiMTVqNGtGcitQMGNXRlNlYUxaT0piQW1R?=
	=?utf-8?B?b0djbWV2RU9WYUdMRGc4YTBmS2FtSXdObEN4MEVhQ3gvZjI4TGdKQ3kvWU5l?=
	=?utf-8?B?emtyQ094aE1qZTRJWnNiM0dzU01wa1FieGRvOGxwR0VpQVI2cGpueUFUWmtr?=
	=?utf-8?B?MVg3Nko4M2VqbEh3SUVCcHM5T1JmMWNIRHFJTjQrQjNhSnl4QnVaTmw0STNU?=
	=?utf-8?B?SVNISjFDVUNPb2hFR2FISlNkRmFxUU9vaGtIckpSSm45bUlUZ3R6UVFWZGND?=
	=?utf-8?B?NTByWlZ5YW9kNmpPTCs0eTl0QTgxUjRna2RNbEhVb3RDMXZvcHh5TkNtcm5x?=
	=?utf-8?B?aE4yT2NwaGlYbmxCNVUvenpnSjQ5RUJLaGgwRENGRlpyazR4aU1RMHVBMjlQ?=
	=?utf-8?B?eWNOT0NQdmJRaHVMVVZwT1JpMXJ6U29VaXdycXdiU1lGL0hsTm9TdURYNUl3?=
	=?utf-8?B?SHZod3BOejFSbWpyWDRjSHZhZitEOWN2Qk1wbjFNci90NGRNZUN4cTQwbkJt?=
	=?utf-8?B?Tk1haS9qMVNYT25wNDNwVVRjem90VWFLK2ZBMXpzak5LRmJDd0tmRUxLdDU3?=
	=?utf-8?B?aHdLVTZ6Z3NkQVdidC9ZMnhmZEtNUVZpOWNDS3h2L0tKb0locFFJbEs2M1hl?=
	=?utf-8?B?ZEhtbmFaMmZwaDB2b1dGUVlYSTkvYjYzWlRDbmFaK2tqVkdOQzdhS05vMzZT?=
	=?utf-8?B?RTBsY2NpTkQxM2o0RG1zcVYzOHh1dGh5dG1iZllsR0JDbDNTWTFzSm9aZG15?=
	=?utf-8?B?clhzU29GbW9JdEkxbHZ3ZU5iMERmTk5LcnQvNXpvSUZZUXduZzA5c0kvaThp?=
	=?utf-8?B?bnNjdkRVSW5RSGRLcTJONERFUmtCRDlYUmZRSmJnajRtMXFUWXNBL2hCR0hk?=
	=?utf-8?B?VTcvV1V0SFNYUGVCdVN6OXg5aDAyZ0lNYjdlbXA0cytwbXpnTEt3TGhJZW1n?=
	=?utf-8?B?U0R1MTNFS0kzZFJRZFhSUzVQN2pSMmVVUG1BaEpPOEpoRHE1UmZhLzYzaERz?=
	=?utf-8?B?Qkxab09ZbGhLa0JSQTNtVUpZdVVhczNsSnlhUWJ0RXN0NzBsNlRORVd6TGJz?=
	=?utf-8?B?djJHdjBNSXA2RmZ2YWJzTTNkQXN0azE3aDkrbURXMmtEMXFlajVONlhRNGZQ?=
	=?utf-8?B?d2dKVVJPUlFwVlU4enppQkJuZnB4MnlLLzUwN2pHTnpNcjlaR1NvbHhwQWhx?=
	=?utf-8?B?ZjZaclFxU2JnU1FkdEZ0bjhYT3dLRUo2MHdnN09sWnZhcTdWNXZ4aVpBc3kv?=
	=?utf-8?B?Y09qR3pwUEc3U1loSndFclRJYTRRMlArYTJxY1R6eU44NUI0TThOYXYxL1pV?=
	=?utf-8?B?QTAxV0ZDZVFSMnVvVWJVL1VXY1dQdGh5clM0eEs2MzlWTUVEdFBBWDNMTGFl?=
	=?utf-8?B?WisrWmxtK0VDTlowMGNxeWhvMks0bklkQkxlZmlsY1VranBLOXo3TUpiUysr?=
	=?utf-8?B?eHlBbDB3anFaK3QreU9vMXJLS0xMNFdXcktMMURNeXpqZVA4MGVQWXdtaGNw?=
	=?utf-8?B?cC93ZlNzdHptb1BNWXJpZ3prQ2pZQmVGcDJjcHZyU2pnV3h2Sm5sOTZXZEg4?=
	=?utf-8?B?ZWRXZmZyNENkdUJJYmFmajA1QUtLMklaSkN4VzhWWUR1MVBkdWQ5SXVRZUlW?=
	=?utf-8?B?RFBJSVA2cE1VendjdEJ5dWZDNlpkMnA2VDhkQTRJTERpOHFRNmJHOUZDY0Jt?=
	=?utf-8?B?OWs4a0NTK0dHdndyOUJlSDBhZEw1ZGU2REVQeUFaOXBkdmJMMk9pYi82a01W?=
	=?utf-8?B?aXVyeEh0cFIxa3RVS3VzcEliL1l5MjB1M05rMFE1d1M1S3I1VkFiT09KemUr?=
	=?utf-8?B?elh3aUtoME1JZUxPb1ZpQmVmZXNlMFo5TklweUszNGhzRlc5bU1DVGRPMUNN?=
	=?utf-8?B?Vjg4US9Mc1h2bUplT2dwalRhMzlkbUNRd0d2UTJmUHcrbFFqazhHWEVaUlhZ?=
	=?utf-8?B?eHc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766ab48f-00c7-45aa-570b-08d9a3bb5879
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 19:58:48.6950 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: unjXXVl+jL+WUg20hcfAoFf8VZmRZyEM57ni2aBbRap14J3XIWU+cMet2S+VESYuby+3NakXkHc51n4T1HDR7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2488
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0
	suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111090111
X-Proofpoint-ORIG-GUID: bGBLdVxs04P3vQIY6p7gEPnq5QzB3qSC
X-Proofpoint-GUID: bGBLdVxs04P3vQIY6p7gEPnq5QzB3qSC
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A9Jx8tr016715
X-loop: dm-devel@redhat.com
Cc: NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, Linux, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vishal, "Weiny,
	Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
Content-ID: <944FD2E0E17FDF439BB9D8073179E5FC@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/9/2021 10:48 AM, Dan Williams wrote:
> On Mon, Nov 8, 2021 at 11:27 PM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
>>>   static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>>                void *addr, size_t bytes, struct iov_iter *i, int mode)
>>>   {
>>> +     phys_addr_t pmem_off;
>>> +     size_t len, lead_off;
>>> +     struct pmem_device *pmem = dax_get_private(dax_dev);
>>> +     struct device *dev = pmem->bb.dev;
>>> +
>>> +     if (unlikely(mode == DAX_OP_RECOVERY)) {
>>> +             lead_off = (unsigned long)addr & ~PAGE_MASK;
>>> +             len = PFN_PHYS(PFN_UP(lead_off + bytes));
>>> +             if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>>> +                     if (lead_off || !(PAGE_ALIGNED(bytes))) {
>>> +                             dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
>>> +                                     addr, bytes);
>>> +                             return (size_t) -EIO;
>>> +                     }
>>> +                     pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>>> +                     if (pmem_clear_poison(pmem, pmem_off, bytes) !=
>>> +                                             BLK_STS_OK)
>>> +                             return (size_t) -EIO;
>>> +             }
>>> +     }
>>
>> This is in the wrong spot.  As seen in my WIP series individual drivers
>> really should not hook into copying to and from the iter, because it
>> really is just one way to write to a nvdimm.  How would dm-writecache
>> clear the errors with this scheme?
>>
>> So IMHO going back to the separate recovery method as in your previous
>> patch really is the way to go.  If/when the 64-bit store happens we
>> need to figure out a good way to clear the bad block list for that.
> 
> I think we just make error management a first class citizen of a
> dax-device and stop abstracting it behind a driver callback. That way
> the driver that registers the dax-device can optionally register error
> management as well. Then fsdax path can do:
> 
>          rc = dax_direct_access(..., &kaddr, ...);
>          if (unlikely(rc)) {
>                  kaddr = dax_mk_recovery(kaddr);

Sorry, what does dax_mk_recovery(kaddr) do?

>                  dax_direct_access(..., &kaddr, ...);
>                  return dax_recovery_{read,write}(..., kaddr, ...);
>          }
>          return copy_{mc_to_iter,from_iter_flushcache}(...);
> 
> Where, the recovery version of dax_direct_access() has the opportunity
> to change the page permissions / use an alias mapping for the access,

again, sorry, what 'page permissions'?  memory_failure_dev_pagemap()
changes the poisoned page mem_type from 'rw' to 'uc-' (should be NP?),
do you mean to reverse the change?

> dax_recovery_read() allows reading the good cachelines out of a
> poisoned page, and dax_recovery_write() coordinates error list
> management and returning a poison page to full write-back caching
> operation when no more poisoned cacheline are detected in the page.
> 

How about to introduce 3 dax_recover_ APIs:
   dax_recover_direct_access(): similar to dax_direct_access except
      it ignores error list and return the kaddr, and hence is also
      optional, exported by device driver that has the ability to
      detect error;
   dax_recovery_read(): optional, supported by pmem driver only,
      reads as much data as possible up to the poisoned page;
   dax_recovery_write(): optional, supported by pmem driver only,
      first clear-poison, then write.

Should we worry about the dm targets?

Both dax_recovery_read/write() are hooked up to dax_iomap_iter().

Thanks,
-jane




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

