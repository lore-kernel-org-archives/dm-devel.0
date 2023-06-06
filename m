Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3DAC7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 04:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686025108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+EdPTke6aKSztKW7HtUnZD9Rg89yONCFBlvU/U+q7GI=;
	b=PvXBl/Wad8Kv18hSHpivsIO1caXJrtEQE83B6BDBbG/rpBnJfPECl709U7Rc7Ov3fIZTdM
	AwjhU0Inp7CiuyAY/JcGYwbJ19Gl/kgaldXEV7xiUGcXRYwmMarn30bi+r1O63J/Rc9aHR
	8D5dyfgdh/RowLcNW4U4KSasX8s25kk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-BlbqEr_6OweRTmbrsgq4Sg-1; Tue, 06 Jun 2023 00:18:27 -0400
X-MC-Unique: BlbqEr_6OweRTmbrsgq4Sg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A91C029DD98D;
	Tue,  6 Jun 2023 04:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 72F147AE4;
	Tue,  6 Jun 2023 04:18:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A48019465B7;
	Tue,  6 Jun 2023 04:18:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77D721946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 04:18:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48F37140E955; Tue,  6 Jun 2023 04:18:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40AD3140E954
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 04:18:21 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E49E801224
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 04:18:21 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-JnM5MWT4O0-6JphcCyyuxg-1; Tue, 06 Jun 2023 00:18:17 -0400
X-MC-Unique: JnM5MWT4O0-6JphcCyyuxg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="354052384"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; d="scan'208";a="354052384"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2023 21:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="1039025039"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; d="scan'208";a="1039025039"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
 by fmsmga005.fm.intel.com with ESMTP; 05 Jun 2023 21:18:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 21:18:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 21:18:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 21:18:14 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by DM4PR11MB5518.namprd11.prod.outlook.com (2603:10b6:5:39a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 04:18:12 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::a41b:1b6c:8306:7644%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 04:18:12 +0000
Message-ID: <0c32fc78-5755-09b8-4d2c-81101e33fdee@intel.com>
Date: Mon, 5 Jun 2023 21:18:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <dm-devel@redhat.com>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-2-chang.seok.bae@intel.com>
 <32ffb593-c39c-c741-7b6f-6f1cbcb1d558@infradead.org>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <32ffb593-c39c-c741-7b6f-6f1cbcb1d558@infradead.org>
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|DM4PR11MB5518:EE_
X-MS-Office365-Filtering-Correlation-Id: 928138a0-dcd2-4476-8676-08db66450aac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: nlpH+S7yY6VXm3gAT2+Sbb/0VbEcqjWU8WaLy/fCRydGIzj3spyjERffY+tep8VB/x0oZGJn85/wv7Ke6LCt1MvG8KvYhBDv7Lk3Gh6/smvfdHhZp1UA0xN7kmhOm+W/gn+R2PHxfrU2/aDB7Wgk+w3ljQBwg0XJ+JZFJKn15ORcA8ASzkYtNi7ZxZIuPgQ7bnpx6u9/Bo+RLdFvBigVqFAi1Xlx7KcsRZPgzQXWlxdxMb2hya4RQmLwLhIOtP5b1KfSaBK0EMZYVccDq8D5FmF6iPYqm5IYJpPCg+5YYpRqA2UkXUM0MkNfofpzaAlNyiL+6I8h3bbmAb/TDjeKpXJ1SfkuQAqSthjkmDMWmI1v4uU1okfBHCU2UKoKEOTxKFj2zKzPEL82CMZXCQC9w2oB1BULaCBnw4NYtPi0nzp4CuGmttG4KQwi9WhSgoWZNY7cLh1Zb5mLohgL2qSDeAfrW4d2OyYR4Eo7Yx+q7JPvJlrb++bkVzWFklLURpyzxjd2yXATZQ8PcAZRFYYKn3g/Fx0/lXgjHTSU5pM+YX4vQemqh+SvLGRslZwBeruH7L1ODZV/Lm1qZbSIvsJj9vMVTWWZ2sIXyRTyUuspv9RQC1xNLUk6QTHJ4QUODGeeIWUY0LI57Axz3eixDGgGEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199021)(6506007)(186003)(26005)(6512007)(53546011)(2616005)(31686004)(83380400001)(7416002)(6486002)(36756003)(2906002)(4744005)(8676002)(8936002)(82960400001)(54906003)(478600001)(86362001)(5660300002)(31696002)(38100700002)(316002)(66476007)(41300700001)(4326008)(66556008)(66946007)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzlkSVZsRW1DOG1oU3NhRUFCS2Z6bGZRVSs5ZUllNkFEdEpBYXNQdFNtSXcw?=
 =?utf-8?B?dlJFdUR2R3ZkdnJVdnc1Ym5jUWJwNlBMU3ZUbE9Hd1ZuU3ZhM2lEeFJjeWh3?=
 =?utf-8?B?OU9FL2QzeWFGV1p2cmEyaTIvbWNJd3psVFdqYkQrWHAxRGkzZExvZ0lZT083?=
 =?utf-8?B?MEh4UTRiQm93b2ZhR0xMb3hiTG9oWWo1a2xiM0lVUFd2bHloTHdqS3htSkRv?=
 =?utf-8?B?ZkdyWjdSaHFyMTdJcDVQak1Pa0dacU1ZcWJaNEsyWVl6Y1JpWVBCMUh5SDdC?=
 =?utf-8?B?cmNTOGJIWE1wT2N0My90VzU1by9wRDB4M1IwYWlkMVdUOUM1ejdqd0J3MTV2?=
 =?utf-8?B?dFVwYldvamQrQnJvaFowamVjcFlFQWk3NjNxcTV3aExMcm5QdGcyYllqZzIw?=
 =?utf-8?B?czlZN3NVMnhSZXJGdDhORU1sdDlsTHpSV0pBaXVoUzNQWHhCNFgwbnFLM1Vt?=
 =?utf-8?B?bENZZDNNTFdibXg1RW1hdVNBNStxTlV2a0wzaVM5OU93OTU1amwrNXFySXRs?=
 =?utf-8?B?b2tta0hJNUtJR1JRREY5L1hhZkN3NjYwZEsxanYrdE9OcXJTaXJBYllIMjk2?=
 =?utf-8?B?dmVabEtUV3VoYTRYN0U5VldTaTlGeVZDZU5Sall3RHhoTWhuSldQcEdpMm9O?=
 =?utf-8?B?Tit2RXh4Ty94dVBKenhFWFNOZXBFWi9zakZKN1pjMG9Ra3RpdDY5bXkyMUpn?=
 =?utf-8?B?UFdESDBiQktyR1h6eHV4ZkxadjJCdnNHQ1VnSUhUUk1HOEplWVMvSG96TXdo?=
 =?utf-8?B?Uy9JaXZNM3l3ck9idlk0aURxMmhmZzhJYldmeitUYTBmRy9pYVpKaTJHV2Vi?=
 =?utf-8?B?aFp2UmdMMnYyL3hLMVVxOEx0VmhQRS9FVWIwLzFiU0lvZC9vTlNaaWdndmQz?=
 =?utf-8?B?VjQ4eGdMV1JKdlZwYUVtQkpJUWpCcnlOdkxKb0VlU3JBUDFHSE8vL0tGZFht?=
 =?utf-8?B?bGRzMjMzZGptbDZBUU5xRlpNWXdFeW4xbjJndWtxZWdscGxFMFdnR21LTkpX?=
 =?utf-8?B?RFBqY3E1dkpoVnZDQzJoSEFkTkNOMlhPbExsV0Z3Qm13UjFPakQrcGtFb2gv?=
 =?utf-8?B?RkxiU1QyUFhhNjlhNEF1aEtNQTB0K0U4ZEx0Z0xZYldKVzZMd3YzSUJXOGw1?=
 =?utf-8?B?M3MvWDVTcDdaOTBvM2FRUit6QUFnUEFMQnpNS3EvZWdRUXNkYmdhSFYrQ3lK?=
 =?utf-8?B?cUpCU3hmNnlqN3FnTEQ0N1QwS0FHeU5kTVJGbU5acVdsd2NFSU5TeVQ1dmtE?=
 =?utf-8?B?M3lwbW44bTR3bjNid3VqUmMvNWx0UUMxWWVsUGVOTXJtTWZEWjVhWndZRFh5?=
 =?utf-8?B?VFlqT3JOb29yVllCUFNZNy96cFBHWk12bm1hU3Y5dGd4aitZYWpESEtVcGc1?=
 =?utf-8?B?cWRJVmpvSnRDWXg4dWpBVGI3OW5ibDhOUkhmYjEzTnA2YWprN3ZzV2hib1ZB?=
 =?utf-8?B?aXFDVGJqeExSQ3VtUVdKbnRWOEcxYXBlUW1CMm5yOWFiRlRCMTRCWUE1Z3Fp?=
 =?utf-8?B?SXNleFVNRGRyRFpCQ3ZVY2NVK2RNRTRlRDkwQmp6aFEzUHFqdjVFeGdrRDJx?=
 =?utf-8?B?K3pqTStHaUh1TjRyM1Y5N0diNU9OaDhLaks1ZHE2MHpOUTZjVzlidS9JdHVT?=
 =?utf-8?B?VTVZTytNMytMWHFhaml6VlNpbTVpRFZCVFhJOWEwVytucVM4QUZuKzBuazRJ?=
 =?utf-8?B?MEJyTTA3ZWl4RzNycll2ZVNsTHF5UjBNVjFIYSswcEt4T1ZmYmgrMkhCSkNE?=
 =?utf-8?B?UFRvN1AxVVlmQm9PdWZXQWZ4Yy9FdFNRT0hyZE5MdWpWMVZObnlNTUpFMFpy?=
 =?utf-8?B?VG11T1NQc04wNGQ3OVkvN2hIcm1LbVlUaEVZU0ZZRys1UERpMmFTeW85L3Z2?=
 =?utf-8?B?akhPNXR1RGVQeEVGV044blZvTExEanJuNEFMWGZOVDg5dEdnamJKQ2huVkZ5?=
 =?utf-8?B?aGRWR3ZTNVB3VUxYbzRDS2NZV0xGYlhHbUlRRm5tM0NhMlJnY1N2QVdIUmx0?=
 =?utf-8?B?NkI1T25yS3djdmxLM210bW1JSjNGMXFBVDZaWFBmUHFQa2YwdWdmYXk0Q0FH?=
 =?utf-8?B?cEdCdGFjQXcvR2QvUzFvSVR0OFNoWkFSU3FNbWFRaUJYdEFkdkIrZW5nNlJR?=
 =?utf-8?B?VnFyWVFDUURxZURFTHdXczh4VDN4aHRFRFQzdjdmaXBxVHhUZjdYN1RmTUhV?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 928138a0-dcd2-4476-8676-08db66450aac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 04:18:12.3798 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qS9EL/oh3Wz5fjILXR4yrRF46gEA70x4lDIeWiK91/bnmqBZ9G1rDXIIDKmdmyrXjLY9OXw+sgS0PfWgoafCABzXZGixD/chDpMUq5EWNbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5518
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 01/12] Documentation/x86: Document Key
 Locker
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, ardb@kernel.org, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, Ingo Molnar <mingo@redhat.com>,
 bp@alien8.de, charishma1.gairuboyina@intel.com, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/5/2023 7:17 PM, Randy Dunlap wrote:
> On 6/3/23 08:22, Chang S. Bae wrote:
>> +
>> +* AES-KL implements support for 128-bit and 256-bit keys, but there is no
>> +  AES-KL instruction to process an 192-bit key. The AES-KL cipher
>> +  implementation logs a warning message with a 192-bit key and then falls
>> +  back to AES-NI. So, this 192-bit key-size limitation is only documented,
> 
> Is it logged anywhere?  i.e., a kernel log message?

Yes, this is the relevant change in the last patch:

 > +static int aeskl_setkey(struct crypto_tfm *tfm, void *raw_ctx, const 
u8 *in_key,
 > +			unsigned int keylen)
 > +{
...
 > +	if (unlikely(keylen == AES_KEYSIZE_192)) {
 > +		pr_warn_once("AES-KL does not support 192-bit key. Use AES-NI.\n");
...
 > +}

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

