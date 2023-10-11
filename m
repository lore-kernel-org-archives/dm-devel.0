Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD93D111BB
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZR20iz8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524633;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Fa28NTVhibpLikBeuVemRJmO1y2Z+B1GpnjyDlQBlIk=;
	b=ZR20iz8Dh7D9A3QDIqrsvY/ZXtfn+F6yYgtLCfdAo2Jc7tDa+bq7fkLSVxonWdT7gv0dgR
	+gtbqondABNb5tgZI71FVO8pLsAGRU/FJv90yx4zfFwcy6QhOJOd6EHkBieyVkIHNee0k7
	sNQmyk1FVrxiiHvWwSfNbXKCRmsW8Qs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-JQvxcSqoM8ar1QKW3JEJ8g-1; Tue, 17 Oct 2023 02:37:12 -0400
X-MC-Unique: JQvxcSqoM8ar1QKW3JEJ8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D172B3C10422
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:37:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7B3820296DB
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:37:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A48B519466EE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:37:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C2E01946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 09:36:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CE6D21CAC6B; Wed, 11 Oct 2023 09:36:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5518921CAC76
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 09:36:00 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 311E5887E40
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 09:36:00 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-dybmRbOHOWizRlagPP1yVQ-1; Wed, 11 Oct 2023 05:35:58 -0400
X-MC-Unique: dybmRbOHOWizRlagPP1yVQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="6179275"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="6179275"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Oct 2023 02:34:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="1085158738"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; d="scan'208";a="1085158738"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384;
 11 Oct 2023 02:34:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 11 Oct 2023 02:34:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 11 Oct 2023 02:34:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 11 Oct 2023 02:34:43 -0700
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7919.namprd11.prod.outlook.com (2603:10b6:208:3fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Wed, 11 Oct
 2023 09:34:41 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::36be:aaee:c5fe:2b80]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::36be:aaee:c5fe:2b80%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 09:34:41 +0000
Message-ID: <a28542e2-4a5b-4c29-9d4a-12a0d2ab5527@intel.com>
Date: Wed, 11 Oct 2023 11:33:25 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/14] bitmap: extend bitmap_{get,set}_value8() to
 bitmap_{get,set}_bits()
To: Yury Norov <yury.norov@gmail.com>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-10-aleksander.lobakin@intel.com>
 <ZSQq02A9mTireK71@yury-ThinkPad>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZSQq02A9mTireK71@yury-ThinkPad>
X-ClientProxiedBy: FR4P281CA0173.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f434655-90e9-432d-7679-08dbca3d4b60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 1peSp9ZxEfvvylkkrrpUHil/AHeU7G+7/Y05Gw8rzb/uzCwdrYD4Wkt59HSUOcZ0hHJJp3GoZgDwviFCjNgSQsvcIW2PDqB3TPy4qT4DAjsuX1YZKZeZvr1I16DbtXMankM3EvvCFA4DDl27//topzfz9NEG6E41LIKubhr/quiwb56J8zzBUDU2gGOQiQBjdxMObVD+BeXi4wmFjdzoRCm/NBgFlhqh6x0eiwtrvSTLSOXbcWHNoEPdFvQetfS0VZW5iEjFAd0527pX4Y0RkQZJEhbAIno1953G28vdTX7Fv81KmDWORlxXKOuWrdNzaeWs9cv5LJzSxd6zB65x8F3rnagSdx/tHy/sy/Gi9q4XVMCgy0UnOIOrEu4GUK2OdRZbCntgoDnZCh+BkRVCUFkXfhK7ZoJFcvE4lVrzKEkZhCxxLDuEY1I4CmUktJ2Iyt6lr09AWSsPuZ0D8hpX8z3NpuWdZmG07wPBfLXBP6vTWUCm+SEMsHF0At0uY2pkK+uyYEsU2S56ndTdSzIqM/9TFqgf4TBQ4AWJ2ZbAI6BtDPaPxUs42hVV8JZ3vA5uIgugqFMwXeiE4Vq7G6ojDRx19mErsQx6mX13lThRwDZCAF2euuYiE0maHUl6gJHAx6MqdaflQdXscOc0vk7XqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM6PR11MB3625.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(136003)(346002)(376002)(39860400002)(366004)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(6512007)(6486002)(966005)(478600001)(2616005)(66476007)(316002)(66556008)(66946007)(54906003)(6916009)(8676002)(8936002)(4326008)(6506007)(6666004)(41300700001)(31686004)(83380400001)(5660300002)(7416002)(2906002)(38100700002)(31696002)(82960400001)(86362001)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmlFaFRVdmpYMnZ1QWtrbVBYSmZpVEVGZXY5UGJDMDVBQ1dOUTlwMkNmVkdX?=
 =?utf-8?B?a0NFVmlJQ1FQeEVtcEwzQ2x0cVJRYUJ5TlplcFFWYzZBeENlRzYyS3BhM3ZP?=
 =?utf-8?B?cmJMVi9WS3lCUGc0OFR4QVNMWlZRYU5JZzh5T1hUem0xWms3VFVtVFhCNmNU?=
 =?utf-8?B?OExZMFN5Sjk1TDlNQnRrOU5EczBPRjcxVzFQdjd3aFl1cUlEUklkY3YyOGVL?=
 =?utf-8?B?dHVOTytBRW9FR1g0VGFEb0hOT04wTUFab2x5U1c4WkJZc082ekt4MlZ6eU12?=
 =?utf-8?B?WlAzZndsakFCRFUyZ29PdXg4OWsvSjNURVY4YjhQd3B2SytDREt5cmNVa2Q5?=
 =?utf-8?B?MjRQRW92YlVPY3p3dzc4Rzc0Tms3WU42dkNNYXozMThPVFpleGhTYnJ0d0Y5?=
 =?utf-8?B?K1ZycjJmY0k0M1Z0L0ovejdvbnFiVmdxVTVIRG9VbXBodGkvbXcyZFAzMXBJ?=
 =?utf-8?B?MmhBRzJYbllPdmZlT2d0ZlJIYlR3aEluam01em1VSlh1U01JcjF2WHdxWDJ3?=
 =?utf-8?B?dUdlTjlWQm1BL1Zmc09ibzVTK3kzN3lmQWx1dm4zaWdhVUdZMVExVVNkUWVj?=
 =?utf-8?B?ZmZMOTNaODFRMW5EMzZkeHNIVVNTd3E3ZTd1M09hdjVYbTRqeHlZZHBhTDU3?=
 =?utf-8?B?clFFUmsybTVoQys0V2oyRW53dFh4K3dBaVdqUTA4TjRHbm5wMnJJY0hxdWly?=
 =?utf-8?B?cWlQbGdnazJTSi93bVJHbnhOOWZwMlRCaTFiY0doSThwSjIxUE1FMmEvbk52?=
 =?utf-8?B?VU9ydU1FaFdOcmQwaDVqQVBZNCs3bkxPVzY5L1JuRVN3OXFxNmdwT0ZEaUcx?=
 =?utf-8?B?U2hodStwVHRrNjE3SDI4blY3ekRQM3dtbWx2bHpOSWRPNGlLQi81MFNiWWo1?=
 =?utf-8?B?T3dLcjhEYkZwdWExNDcxcGl4c28xSHVMeUpCY2s1d2VwMnhHWEdCeExFU0t2?=
 =?utf-8?B?LzRrZjBnOTdhZzloVlo5YkxPMmFFSUF1S1FrWkN0cG1PZm9QQkFFelRpeXhO?=
 =?utf-8?B?dWRNR1dvNFFPWnlDRzhmUlNYcUFLWkdwZjZ0VUdiUFNZK1pyMitQNFdLcWR4?=
 =?utf-8?B?TmhYeXVGVitubnJmSFBKRHZtN2ZMN3FzZitxK1ROQXZsaGlYNjBXL1pWNG9q?=
 =?utf-8?B?RVNjKzh1V0JrellEMDV1M1ZqMHB6c2ZLUG02b2QxdmRuL1M4OUdMUnFGSENY?=
 =?utf-8?B?Ykp5c0JMREM0Rm9nRlFud2Y4NGd3cCtSQkd2VzZ2L2pyY1JLY0N1V1hSSEFx?=
 =?utf-8?B?ZWZPM2drdFZsaHJ5RUxZNm15S1RzTFBCS2daTXZTeDFJbi90WE12ZTFuWEho?=
 =?utf-8?B?SkFiKyttRlZWcmtpNzhIKy9SdldyT2RvM0F1VDAyb2gzd2ttNW9LOHNkMXUy?=
 =?utf-8?B?T2JJbWhWR0tEY3hleFFJaTFrSit5RWtLTkxBNWhYS2RMNmxaV3RJYmVteHBP?=
 =?utf-8?B?NUlEWUd2empLSTRjbTFiYU5PRGI5aWFuNFZRbTVseXJvMHJ6Qitkb2dVSi9t?=
 =?utf-8?B?KzBMaUY4QmdpdnlCc1YzQVRRYS9Lc0VHVXVGRHh1aDQwRTdmWTNTcmJ3MDB5?=
 =?utf-8?B?SUdvYUJvMUFIcTk0T21IcmVFdVhPcjRLVXR5c2ZxNnNlNXJ2b3F3RElzTGRz?=
 =?utf-8?B?RkQwZzFvVFRmOFdSbitmbHVnVWpPV2ZHQXp0dytiTlNIVEF2QisxWnh2czlh?=
 =?utf-8?B?ODBJZ2dqcGJKYllEaDFmRVhCNG1MWjRRWjdiWFVQL0ViTE1PWnRoUmFCOXN4?=
 =?utf-8?B?MStyNDhLeFhaeWowUGJ4aGkwa3FZT2I1WDRNZVlLREUrUG1wT1RlSS9KcHdH?=
 =?utf-8?B?SUtMbUc4bzNDVTN6LzBYVFk2K0ZyNXhST0IxcTVLbkkybVVxYklYajJGM01q?=
 =?utf-8?B?REJXT3d3ZXF2cVhxMHFUa3F2M1F2WWVzT2dTbU9IdzdKY3hCR3VIcGxLTmhH?=
 =?utf-8?B?cHp5NWN1cEZxTzdERWhBc3JiS2MzSlZ5UzIvZmQ4U2g2T0JRZWhUTWlzcGJU?=
 =?utf-8?B?WU9jTEhwM1NWbkZYR1YwelVOVUNyRGJEWVRBZmJVRE5ncUdLZlptQ2dwY1Fs?=
 =?utf-8?B?VWp0ak1DOHN2RFUrQmVWS3h2NWJOczh4UXIzK1hwbTVaeVpCZHJMNitYQjJJ?=
 =?utf-8?B?YVM3VjJSL3RmOExzTURNb0FNWjkweFBLQ09lRndqL3ZYN0FabDNnT2VmRytI?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f434655-90e9-432d-7679-08dbca3d4b60
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 09:34:41.1636 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhAoJsJisUP5FiLarYDQigJLovwkkuyrc/0B/QAJra2/OdLxT58BFXR0K6mwd9KsnvKuAHcF26qQsW3s5R6wfyDR4n7+1EcmrGKvrfy8El0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7919
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 17 Oct 2023 06:31:30 +0000
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Simon
 Horman <simon.horman@corigine.com>, Jakub
 Kicinski <kuba@kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Yury Norov <yury.norov@gmail.com>
Date: Mon, 9 Oct 2023 09:31:15 -0700

> + Alexander Potapenko <glider@google.com>
> 
> On Mon, Oct 09, 2023 at 05:10:21PM +0200, Alexander Lobakin wrote:
>> Sometimes there's need to get a 8/16/...-bit piece of a bitmap at a
>> particular offset. Currently, there are only bitmap_{get,set}_value8()
>> to do that for 8 bits and that's it.
> 
> And also a series from Alexander Potapenko, which I really hope will
> get into the -next really soon. It introduces bitmap_read/write which
> can set up to BITS_PER_LONG at once, with no limitations on alignment
> of position and length:
> 
> https://lore.kernel.org/linux-arm-kernel/ZRXbOoKHHafCWQCW@yury-ThinkPad/T/#mc311037494229647088b3a84b9f0d9b50bf227cb
> 
> Can you consider building your series on top of it?

Yeah, I mentioned in the cover letter that I'm aware of it and in fact
it doesn't conflict much, as the functions I'm adding here get optimized
as much as the original bitmap_{get,set}_value8(), while Alexander's
generic helpers are heavier.
I realize lots of calls will be optimized as well due to the offset and
the width being compile-time constants, but not all of them. The idea of
keeping two pairs of helpers initially came from Andy if I understood
him correctly.
What do you think? I can provide some bloat-o-meter stats after
rebasing. And either way, I see no issue in basing this series on top of
Alex' one.

> 
>> Instead of introducing a separate pair for u16 and so on, which doesn't
>> scale well, extend the existing functions to be able to pass the wanted
>> value width. Make both offset and width arbitrary, but in order to not
>> over complicate the current logic and keep the helpers as optimized as
>> the current ones, require the width to be a pow-2 value and the offset
>> to be a multiple of the width, while the target piece should not cross
>> a %BITS_PER_LONG boundary and stay within one long.
>> Avoid adjusting all the already existing callsites by defining oneliner
>> wrapper macros named after the former functions. bloat-o-meter shows
>> almost no difference (+1-2 bytes in a couple of places), meaning the

[...]

Thanks,
Olek

