Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54378C38145
	for <dm-devel@archiver.kernel.org>; Wed,  7 Sep 2022 07:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662537492;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WcERFXYigysFBzNr4YFEiwqf5cepgNAohXVLyD//A/Q=;
	b=YRPWzRgEsRFOSDRtbxlr0Q0q1/U/ZSgpA/BjJJwqD+d0J0zUX3N+SVsEhXC8uFTu26wCur
	Y1YAIoAAo8z7xEyBrWsoTS//+46tW/v7MqhYrJpzhIQZs1tdgH03dLhKNRYyru64cuClBx
	mUOfQ9ZKa4get6Dm2q7+BpuSDNB7BmQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-bX2yYMBYM7mrRS2eXen26w-1; Wed, 07 Sep 2022 03:58:09 -0400
X-MC-Unique: bX2yYMBYM7mrRS2eXen26w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29A7E8037AE;
	Wed,  7 Sep 2022 07:58:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5ADE4011A3E;
	Wed,  7 Sep 2022 07:58:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E90781946A55;
	Wed,  7 Sep 2022 07:58:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7FE6B1946A45
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Sep 2022 16:47:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FC7D2166B29; Tue,  6 Sep 2022 16:47:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AF662166B26
 for <dm-devel@redhat.com>; Tue,  6 Sep 2022 16:47:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CCF73C0D84A
 for <dm-devel@redhat.com>; Tue,  6 Sep 2022 16:47:00 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-jXYOwvL8OASpwDdM2zAdww-1; Tue, 06 Sep 2022 12:46:58 -0400
X-MC-Unique: jXYOwvL8OASpwDdM2zAdww-1
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="322823235"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; d="scan'208";a="322823235"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 06 Sep 2022 09:46:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; d="scan'208";a="591334020"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
 by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 09:46:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 09:46:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 09:46:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 09:46:47 -0700
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH8PR11MB6999.namprd11.prod.outlook.com (2603:10b6:510:221::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Tue, 6 Sep
 2022 16:46:46 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01%3]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:46:45 +0000
Message-ID: <b0514d28-39f5-e66c-bb41-fc5450266e11@intel.com>
Date: Tue, 6 Sep 2022 09:46:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Evan Green <evgreen@chromium.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
 <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
 <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
 <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
 <CAE=gft6sO85RBpfdXnR=_r=KGmVrx0mnBOHK7XadNk00gDr-WA@mail.gmail.com>
 <a3fd8d2d-72d0-ba13-ef77-caff2b239867@intel.com>
 <CAE=gft7BQAwHTxoCtSu-gHZDtcETvBM-nony_nzBD8ziE_HcZw@mail.gmail.com>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CAE=gft7BQAwHTxoCtSu-gHZDtcETvBM-nony_nzBD8ziE_HcZw@mail.gmail.com>
X-ClientProxiedBy: BYAPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:a03:40::44) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00afc3f6-cf72-4411-1903-08da9027628d
X-MS-TrafficTypeDiagnostic: PH8PR11MB6999:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: C9uhRpLzPg9gBSmTJGsVkFnd+7zA4Bp3ffhx0zVRN6eomF74UgZn6ov/PWqdy+wBq1un9lO5bSWprq22uYCXPTR3Lx8VLLA6IuL7QxCJR4M842kGG5JNJ3peS2TtPS2bxj8cczb4V2qH58F+AjTFrQ5+6/9CggpHEcV3wd4ZGCV7ULtOzXN9v6IMbDESg20hmoDgmVcLxQWTGnF4FSK9Vh1rOYnqAeVyUIWJzrBylVW+GaI+zxdFhwbon2r+kjqezTRkyj5gTePe639D2tgX9+EQnW0nyUkRl9bPaJs7qeWECaTn/KEQ2TbgsykNRms1YLVkGlmp39M/BSymMjzk/e1gkpsB0JjUjhE1y77aVD9xo9EcLz+Dum8lyxqwP6bYbUsUlV1eutxez3xLrTV+xjx0PTjZY+PPXzmLBlbmZhTjvM0TBReRI1QpxSNL8A5tBcLwQCWzctVClXokAW7STBsSNY0Q8jy0ZGaGYb6/VRXdKGQOyCMySsWoaEgP08eMoRWlXZbI7pdEd86Yip25dGE8pw5FRO5xnD2c89oTz8dWOCR3UvUYEy3fbkxkpkEKNf+699AM8USmXix6wItrptf0qLRyr3rOW3v+v9wOh6wO56QNg87uWsGYI/J3WGhRsD101At28a2ouujkyC5x5iJ414pHEXOUlFINzA00q8D04wBHi5qJnJh7+3N6KcH1DlXPp4uZjZXCaVYiz/cJFxzF/pq7gBWk4qUSHw8kXjXWo3ZsaV6Tb/QB4gJ9+Nm0saUGg9vs1zE+vgg3msfnfI7IvWNGwaSESsqky7Amj58=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR11MB4855.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(396003)(346002)(39860400002)(136003)(376002)(8676002)(6506007)(66476007)(2906002)(6512007)(4744005)(66556008)(6486002)(53546011)(4326008)(66946007)(83380400001)(5660300002)(26005)(7416002)(8936002)(41300700001)(478600001)(54906003)(36756003)(316002)(31686004)(2616005)(31696002)(86362001)(82960400001)(186003)(6916009)(38100700002)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHdlTzNuSmxmN1krQkI4THRpOTFHaC9GamdPcHM0SGdxcjducGgxeER5ajFB?=
 =?utf-8?B?SE91dUx0OWZWbXZDOGdXV0hwOFQ3RHNuRjJxT2QrYXB0TktPTnBJS1Q2SVBB?=
 =?utf-8?B?Z2Q2RmprcEdrWk1rMHA4U2RjaVRvTHQrYTNndk02M2E5NjNZa2VBdVZtQ1pm?=
 =?utf-8?B?WWxUYldsRkMrSmk0L0p3YWhiNHV6SU05bGdqQURmTjdXeFlacUxONysyZTB3?=
 =?utf-8?B?VVIyREVMd21MYnlKTm4zdGJtRyt6L0xhK3grMHlyOTFYM1IyaEErVEZhNzYw?=
 =?utf-8?B?WFI5RmFqV3lCamFjYURmc1d3NnNUNC92RkR3QUJnY3RXOFVid3lNZWVMWE0y?=
 =?utf-8?B?TlM1M3BHaFBiZHVNY3FKZDFLTWNtQXlOL2laU3kzczFBNEladDFzeEd6REFJ?=
 =?utf-8?B?NmppT3BxNUNiR2NENjRaVlR2VktHMi9oQ0t1T1J3Ri9XZTNMTTZDQUkvNlh1?=
 =?utf-8?B?QVJWTnVwUjU0bG1mVmtmVzFIQzVScEVoMG5mM1VSYnplaUgwRi9wR0NBcDkz?=
 =?utf-8?B?Y0JZa3pKVkJ0bGk2TW5sOXc5Tkc3MCsxTjliU3VwU2pDSWNTQVBiNy95a3Vo?=
 =?utf-8?B?OVBPMHB3UUNOY3ZmY3NCdWhEbUR2QVdHOWMzbFFkQ0hlVDJXWStJRjVrRVFX?=
 =?utf-8?B?R0xZOGxDR0pwUmFNaER6bHRnY3A4VkZUdDFPd0FzTWo0aXprWFU5RSswaklJ?=
 =?utf-8?B?OEp3TkEwbFJFcW9pWTRkcnNQYWVsTTdBMjNLQmZaaTR6Rzh5dVJlU3dwbmM0?=
 =?utf-8?B?Q2E2VnZ6RW4xSUVkRmtKNHZONWVtazlQSGkveWJiUmtCTlVMbVh2a2Zla2hP?=
 =?utf-8?B?R0cwSW1QMDVQOEppMlFxZHA2K1NsY0NqUXFGa2VYS3BsOUNXOWZ5NGw4REpO?=
 =?utf-8?B?UUJzRGhXdlQxNTgzZ0VMRnAycEdiRU9GS3VTc3JrWHJKYkpBZkJnVTdCNHRZ?=
 =?utf-8?B?MFdQKzZydVYvNlgzUzhwZWJIcFpCczAvVEU0VkdVVGpyamVFMnp4citLR1p3?=
 =?utf-8?B?NFhYeHB0S3Z5SHBHWktaN3FheGpwd3JnNE9GcTh1dVBGdDkzNVB0SVlsaG42?=
 =?utf-8?B?bjNnZ3J2VEd4Yk9wUHZlMFVrR2prcnB3aXBYVFRNNzlHNWhHd1lUM2NUbUNH?=
 =?utf-8?B?OEJkTllZc0FiWmRMaWsvSEVzTEJsUmtZdWRRZXZXNHB1c1BMY2dINndNTVpD?=
 =?utf-8?B?b3k5azl6c3VmVFBxN3o4YTlDTGxydXZITGNJaTZnRnlsT0NLTlBEektWd0tG?=
 =?utf-8?B?T043TkxBd3F0NnV3MGFZVmJ0cS9SRTViSnVvNXU4aktPV2RPR0s3RmZmcXV2?=
 =?utf-8?B?eXY1WElXZU4rZHBwdlhiK2h6UnQxTk1JNm5VK0YvekhZY0wyaGJWRVFocVdl?=
 =?utf-8?B?SXBadjArS0FOanBuVmFKcW5RT05nRmdzQ1AyZUJmUS9KNlhFSjFEOVVEV3Np?=
 =?utf-8?B?T0lHc2xsTXM2SGdqYmEyODNNLzBBQ2w4UE9tbitEMXZpMENPV1NvREc3Y0pN?=
 =?utf-8?B?QXJGWVdkNFZqY2VPQk5PRkh1Q3dRWXBVN205WnpUeXVTODFkWnl3MTg1SW1D?=
 =?utf-8?B?Q0JwYkN1RjFqTlo5MGYwSFBoQXZQVi91RmpkdGhjRkNrUjRaVXNyRjY5Q1V0?=
 =?utf-8?B?alFyMVBpK0JnaEROV0NsK1dvaGxQbDk3Y2JOQmRKWTRUZVcxcmJqaUd0WFdG?=
 =?utf-8?B?ejkybmZ0dzhLMzRzdnczL1I3T2RYSXdZUlRhZHd6WURVTm5jcjU2cWRObW80?=
 =?utf-8?B?L0lHOHp3TEVlYUo1bEJNSkVkWjFzOWZpZlNOdVdndGwwc2g2b3c3RUhnUkdJ?=
 =?utf-8?B?ZHdwdHcxWXVGRzVyS1NMRWdIZDRWVldnSlBiZFJoa0lIWEdpL3BhTHVtQUI4?=
 =?utf-8?B?OVhOdW5sUFVTZytXa0RoNXNiWjg3c21VN3phYWtJcy9IRHNmcFBoTjdoakQr?=
 =?utf-8?B?Uk5LMEswQ1loejVlTGVTSVk4WDFRNHY4RTR4V2hjOURRVFlQb3IrVnp0QWls?=
 =?utf-8?B?bjJuend0Z3RQQkZHZHN2L3JGWUFqZWM0M1MxZzY0QnlBNEQveHhUVXVEVzlp?=
 =?utf-8?B?RkpxVzRTVWxpYTVhWTcyNGJkQVpEZFdnRXQ3M1p1bWdweldGa0pTR3dMaktL?=
 =?utf-8?B?NjJ4cHdwMDFXSVRMbm1YUG9XTmlyTE1ZM1V3OEFER3MwdjNiYkFvMG80QXdD?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00afc3f6-cf72-4411-1903-08da9027628d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:46:45.9290 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzxubLFef+X/6oriAowI1yULPSCZrq+w1BQzbCe0viTDFH8MVhFecJ7/CI0J0BtHIl2AiecjRQzV7EmHEOyfa93zikwDdeyzauCcDBX+8/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6999
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Wed, 07 Sep 2022 07:58:03 +0000
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/6/2022 9:22 AM, Evan Green wrote:
> On Wed, Aug 31, 2022 at 4:16 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
> 
> But this still doesn't explain this crash, since in this case we're
> still on our way down and haven't even done the shutdown yet. We can
> see the "PM: hibernation: Image created (1536412 pages copied)" log
> line just before the keylocker read failure. So then it seems
> something's not working with the pre-hibernate CPU hotplug path?

No, that backup crash message came from the boot-CPU's wakeup path:
__restore_processor_state()->restore_keylocker().

If the issue is repeatable, then I suspect that's something to do with 
the specific platform implementation. I don't have any detail yet on the 
customized systems. Let me check with some Chrome HW folks.

> How were you exercising the CPU onlining in this case? Boot, cpu
> hotplug, or hibernate?

Hibernate.

Thanks,
Chang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

