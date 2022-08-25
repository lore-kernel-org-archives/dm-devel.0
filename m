Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6F3C64990
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 08:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661415883;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jVMtmdZWU5+YF6zsEambsvrsX0A0qxtNDkpKjd5akdk=;
	b=DJ9P+SlQg8l+AnzYIAhKBHgs/5ahpte8eucwYutzKxYjg3KzGhNHLDa3aFQKMXX/9X/kiJ
	DLEmLDroCoJzh5CHln0RfcbY3sIsMVgpKOLWToNBmjOZvYkQ7BqtNRgZvoeO7WEODpFj1B
	BlD/7/bmZHK7og4FDOErlrhLIUyFHNY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-tIJam9J9PLW5iD2TYi20RQ-1; Thu, 25 Aug 2022 04:24:40 -0400
X-MC-Unique: tIJam9J9PLW5iD2TYi20RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9063C181835C;
	Thu, 25 Aug 2022 08:24:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC4D141510F;
	Thu, 25 Aug 2022 08:24:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FCF71946A43;
	Thu, 25 Aug 2022 08:24:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD85E1946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 01:06:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B693AC15BC3; Thu, 25 Aug 2022 01:06:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1DB0C15BBD
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 01:06:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1601805B72
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 01:06:36 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-U8Gy7Be7MAK8BRc15yXK7g-1; Wed, 24 Aug 2022 21:06:34 -0400
X-MC-Unique: U8Gy7Be7MAK8BRc15yXK7g-1
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="277135518"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; d="scan'208";a="277135518"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Aug 2022 18:06:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; d="scan'208";a="643061556"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by orsmga001.jf.intel.com with ESMTP; 24 Aug 2022 18:06:33 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 18:06:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 18:06:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 18:06:32 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SJ0PR11MB5053.namprd11.prod.outlook.com (2603:10b6:a03:2af::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 01:06:30 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01%3]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 01:06:30 +0000
Message-ID: <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
Date: Wed, 24 Aug 2022 18:06:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Evan Green <evgreen@chromium.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
 <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
 <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
X-ClientProxiedBy: BY5PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:a03:180::46) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f96f7b0-5bfa-4162-54d3-08da86360b53
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5053:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Uy/AcoPyk77sIFG7DPGWKeHNUBvIWbCrNK1/Y7X0FVd1OxGIDV1Ps4YH3O4d7UaPlzacFBTwkobQajkXwqe8NvGUgZ5OzK0fnJmZZFHA8dg41MNUO+j8Rn2t4tn0olo36vPh9FkabbJniBI4j7f+4HrZ0YuRqdAEUmpDlSPE72igQOW0sHlZJHNP1CaZcbiDVB4hKcv+vGt8eE4lGo/PGxjKk9UL1LZCHgXA/IEy3r5dPwKdgmcO8V9er/BJShO8hfh+ORGEe5CO+cEt4z6SHVnPABN/CaITIUVyTIyOlgSERg82PO9lvF84Fl/5J7+jCV69fYS/a5fE1bZyFva7Fdbjj05+FB5c1yfcq4/Ol1foIj6/wT9xHsQmmhY0Nwxfrx3ODwCG4idBOEJgxSVW/YG1gXzGm1yA798EIKuxgEW9qsoH/2hTjnV8pqNEsNegR+X6ymHZbTSRYRxnAfO6StRFqGSh3aaSwYTQpdME0dIYyhHuqIwK/mAyP8AUPywb5mnWkTAG0YPPxwk16jfzx7OOXI84d0Dg79MiysgFbNUC2yWdqKYddaSKM+vygAOmazK6qQV8dYbrkvABhAIFO2oMvr2B2lrrIoeQJb4+01bsIUe29nVcjdZUPsbpW8+JmEhyB2daFnh4uJkVYcG65d+u9QkKcee7a+TIZi+BZwxQFH/wuPbRsUyNAtZdsQ4spPrfmOhT+reoF5L+hG+yIOIHDbrYKiN6TA5BiitLS6mne7CtzStSOTn22WI09myJtxjR7pinydm8vosyJUBLyszEfxTyTYUk32MbRR3DXHk=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(376002)(39860400002)(346002)(396003)(366004)(136003)(8936002)(5660300002)(41300700001)(7416002)(4744005)(478600001)(6512007)(26005)(6666004)(6506007)(2906002)(86362001)(31696002)(53546011)(38100700002)(82960400001)(186003)(2616005)(8676002)(54906003)(4326008)(6486002)(66946007)(6916009)(31686004)(66556008)(66476007)(36756003)(316002)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDF2cjNHSmhMNUV1eHo5RnR5dUlTNDBYZzRUUlRYQ1NIOTZHN1RJMnlFRDJ5?=
 =?utf-8?B?eTNQKzIxUVg0a2Z3bzlwUEgvNllUd3NvS1JLOElUd1Zhckc5M3pQT3IyNmFQ?=
 =?utf-8?B?dDhpSTkwaHE3QmtlZFlRT1JHV3h3czBnWUpIRmxCOW1wVDlNUUVYZzFueGZZ?=
 =?utf-8?B?VnMwZ2FoKzZ0SWhKR3p2T09LeENLMDRsUzNjcXBWZnBjUFJxZzFzYnRFRTVG?=
 =?utf-8?B?aUcycnZHS2VPTlk2aWQ0TEtEYVhZUkJCMWRGQ3RvVlBVRyt2NkVyS3ZxaVVt?=
 =?utf-8?B?QkUrSFY5VEluSFI4Yy8ySDdSUENFU2VoS3huaUc4aFVGU1dOc1RjZHRiOXgw?=
 =?utf-8?B?NFlvTDlXdXBjWEpvM2pkTzlSTjZaZ0tVUGlzNEFjZWpueE5IWXZJZXVQa0dH?=
 =?utf-8?B?SjIvT2tLK2JnT05JV1Q4bWZGNVNid05HUExKQXJ1MW03eVg3VjJBM2k2QjRX?=
 =?utf-8?B?K3c5bk1BeTlkak5jbUdjbUFoUHNBaEFyUlFHYU1kV0M5NnFDQXBtS1dQeUR2?=
 =?utf-8?B?eHZReG5KN0NLdTVFaHhpdVAxcXpROEdBNmhCaSt6MmMrYmR4SUxFNVBoejJk?=
 =?utf-8?B?Ti9NTU1lakI3aSsvWmdzYk8rbnQzNTZUZWZudnljRDN5MWo2bzhwRTd2ZWlK?=
 =?utf-8?B?MUVLdTgvVWJ4bUwzaGpnWE14b1loRVpyQ2NHNnhOTmZYMGZKU1dPYnJFZjMx?=
 =?utf-8?B?S3JESGcyN2FCV2NtZHhYMzJQTG1MYWlmR2VkUlZMWk41SG9XdmdRcWpUbmRr?=
 =?utf-8?B?RDcwRTF5U3d2ZVJXY1E4RGhEbEZLMUEvRU5Wb3dkOWpnSzFRWERqVW42Qmx2?=
 =?utf-8?B?ZzMzVDdqTmsrSjVrNUFIWmtQV0svN1JwNVVCeGdrOTU4czVzODNsQ3NwYUlT?=
 =?utf-8?B?RnlVcTQ1Wjh1SmEyT2oyNzA3YUpwblREdTlsSEZjWmZBM2FFT1BTZ2Y4UFhO?=
 =?utf-8?B?b3hXaUFQajRCdWFTMVpoekdHcDEwTVowa0VDZDYzRlBucXlEV3laRjZaT2pD?=
 =?utf-8?B?WG9pd2lTSG5mTHpIRzZOcVJHVHA1cDROdnUySXF3ajVrUG10MGV2M2s4WnJx?=
 =?utf-8?B?bnRHUkRRNnR1SExvSHZsUTAzdWU4M0NVSTI2cDFMcWpOTEZUT3NCRFROajNq?=
 =?utf-8?B?MXpZTGMrL0RXcGg3NCtwMG5jOUZ0YmZoZkh4RGhKK1c2Y1FQdit5aTgxSDRk?=
 =?utf-8?B?QlpYdUlHbk5ZTXBFZzFzd21QSVVacUY4Q2Rrc2NYSXZKWnlHeC9oNU9xZWFX?=
 =?utf-8?B?YkR3cHhWQXdrRDhmdVRKTk4vRWhuZDE1b1ZiM0p2K0tENktTeVBpVEMwdlUx?=
 =?utf-8?B?TVN1RFdwd1pTL2RkNmNUWXVLZmo2SWZlenF6dEd5OWtudnpWOStMdnlVSVFy?=
 =?utf-8?B?dWhNOUpyS1NpSUpqaXdrNS9iZ1kwSVhRbHcyckxNcUpwK0lFV1orRUZCcVpn?=
 =?utf-8?B?MFQ0UkZjZnVIUjZ6eCtRa3hzd3FiNkRXbmFOKzFFNUlHY3dwekd4U20xb2o0?=
 =?utf-8?B?dDFjaXBxWkVYdXpyNmFTRWRUUm8zWm8yTTFqUmlVZ1RqUW1TUE1HbU1kMnFn?=
 =?utf-8?B?ZEc1ZG8zbnp3RFl0NjJMTi9FQjNKNDVWanJSbDBDaDdrWkJNZEdHZGpxNlNR?=
 =?utf-8?B?YzFQcG9nS3FQUVRlM3JRQjRzQnEzYjRObzNOTDdibE9VQU53OU1QSzFqOFE2?=
 =?utf-8?B?U0dZSnJtcUE1ZWc4YlF1RDM1czByZG8wM2tkNDdxcHZUbjllRlY2MWdPWXhP?=
 =?utf-8?B?c0xuQVRmN1RpS0VBZklpeVhheW1OUlczdXUxa1AxQllPZTlGa25VTGJDcjNt?=
 =?utf-8?B?VmlXUlBTd3ppZTBDS3VQSmowUUtkRXgyTUNOdFlRQnVBcmNld1p6UkFsdE9V?=
 =?utf-8?B?V0dEUWdwYjhJV2ZlSWVVL216a0VOR3o4NXpLRmNGeWs0QUhKNlZBUVQzRktV?=
 =?utf-8?B?SjMvUlVDZjhpV3RLZ0ZuWkU4WFFCOGJjVkttczR0UHM1cVRhN3NQT0tTRmR3?=
 =?utf-8?B?Tmhzb2FuQ1VFcW5PN3hTd0luNDN0OXpyRlFHZlhkYSsyZThHMVlEOWVTTzEy?=
 =?utf-8?B?czBQOHY4OGRiNEJoSkpsWlRQMFprdU11dHA3Q1ZWTzQ2ZjdmWE4yVDdudzBo?=
 =?utf-8?B?eUgrYmtIaGpFZGlkSGtUK0RSWVRDc3hYWm5qZTlESm5GZ01nRmkwbzdtTEln?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f96f7b0-5bfa-4162-54d3-08da86360b53
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 01:06:30.4587 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LeO/lCNBsW2YSUVizqURadh3IgDTmDdwJvI5uoM8dBvOAKupN0rC8+JyypexN2TrVaepwM57IwjGbkGpcAWQzcRyY3Bo3dgVNpYh7KxtLN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5053
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Thu, 25 Aug 2022 08:24:35 +0000
Subject: Re: [dm-devel] [PATCH v5 07/12] x86/cpu/keylocker: Load an internal
 wrapping key at boot-time
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
Cc: ravi.v.shankar@intel.com, dave.hansen@linux.intel.com,
 herbert@gondor.apana.org.au, x86@kernel.org,
 Dan Williams <dan.j.williams@intel.com>, LKML <linux-kernel@vger.kernel.org>,
 mingo@kernel.org, Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 linux-crypto@vger.kernel.org, luto@kernel.org, Thomas
 Gleixner <tglx@linutronix.de>, bp@suse.de, Ard
 Biesheuvel <ardb@kernel.org>, charishma1.gairuboyina@intel.com,
 kumar.n.dwarakanath@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/24/2022 3:52 PM, Evan Green wrote:
> 
> Whatever we ended up landing in the ChromeOS tree (which I think was
> v4 of this series) actively hit this bug in hibernation, which is how
> I found it. I couldn't get a full backtrace because the backtracing
> code tripped over itself as well for some reason. If the next patch in
> this series is different from what we landed in ChromeOS, then maybe
> your description is correct, but I haven't dug in to understand the
> delta.

So the change from v4 is simply dropping CBC mode. Marvin who reported 
another issue told me that he pushed the fix to some Chrome repository. 
But I don't know that's the same repo that you mentioned. Are you able 
to locate that tree if possible?

Also, it would be nice to have more detail about that hibernation bug.

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

