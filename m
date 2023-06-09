Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CA4C7EE2F
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jun 2023 06:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686552353;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FbgWvXEwWIfiDoiHeSyHAezrTp+Bwh1DN4N7YLjGtLY=;
	b=YVXe5i9IhMyYZm3N6ZPyldOJmM4+NYNOmmTt8aOAILebVicAt0YHjPPhDATwcSPTd5dWKV
	JG+xPLZUljYB6NM/pVXOoVH5sA6saOLXHAx9fC12kWpSxNspqLaS5X+pynmux8hoTKXJE/
	w1PbY0FseD9WUx4pMMnf3N8c/6BzwiM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-MG5P5_XjO8a1jsuq7Vatug-1; Mon, 12 Jun 2023 02:45:49 -0400
X-MC-Unique: MG5P5_XjO8a1jsuq7Vatug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6621E3801FF2;
	Mon, 12 Jun 2023 06:45:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 065EC2166B25;
	Mon, 12 Jun 2023 06:45:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A82D219465A3;
	Mon, 12 Jun 2023 06:45:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AFD81194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 15:13:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A102D40B4CD6; Fri,  9 Jun 2023 15:13:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9829B40B4CD7
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 15:13:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 798E03802000
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 15:13:57 +0000 (UTC)
Received: from esa1.hc3370-68.iphmx.com (esa1.hc3370-68.iphmx.com
 [216.71.145.142]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-pCnFnBeCOwmJJJVkdj8Uww-1; Fri, 09 Jun 2023 11:13:55 -0400
X-MC-Unique: pCnFnBeCOwmJJJVkdj8Uww-1
X-IronPort-RemoteIP: 104.47.59.172
X-IronPort-MID: 112646623
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:bZ2Nea0tQXqpWgi0i/bD5ZFxkn2cJEfYwER7XKvMYLTBsI5bp2dTn
 GdMXGqOM/+MNmSmf4tya4W290sOsZPVmtY3SAs6pC1hF35El5HIVI+TRqvS04F+DeWYFR46s
 J9OAjXkBJppJpMJjk71atANlVEliefTAOK6ULWeUsxIbVcMYD87jh5+kPIOjIdtgNyoayuAo
 tq3qMDEULOf82cc3lk8teTb8HuDgNyo4GlD5gJmNKgS1LPjvyJ94Kw3dPnZw0TQGuG4LsbiL
 87fwbew+H/u/htFIrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRrukoPD9IOaF8/ttm8t4sZJ
 OOhF3CHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqFvnrSFL/hGVSkL0YMkFulfE0921
 +wmJBo3MhGZuvOp57uJd+cymZF2RCXrFNt3VnBI6xj8VKxjbbWdBqLA6JlfwSs6gd1IEbDGf
 c0FZDFzbRPGJRpSJlMQD5F4l+Ct7pX9W2QA9BTJ+uxqsi6Kk1YZPLvFabI5fvSQQspYhACAr
 3/u9GXlGBAKcteYzFJp91r137WRwX2lAtl6+LuQ3fpUkUaBn1wqBzokZV6yhte2mGukcocKQ
 6AT0m90xUQoz2SnQ9z8dxy+vn+fvxQYVsZQEus18wWEwOzf5APxLmEURDlMQN8rrsk7QXom1
 TehltzqLSZivL2cVTSW8bL8hSi0ODQHIHUqZiIeSwYBpd75r+kbgheKQtt9HaqdlND5GTjsh
 TuNqUAWgrwJiMcR2qaT/FbZgimtrJzEUg404ArMWmuvqAh+YeaNY42u9Eie5/JHJ4WxUFaMp
 j4HltKY4eRICouC/ASJQeMQDPSq6uyDPTn0n1FiBd8i+i6r9nrleppfiBluKUEsPssadDvBZ
 E7IpRgX9JJVJGGtb6J8f8S2EctC8ET7PdHsV/SRYt8QZJF0LVWD5Hs3OhTW2H3xmk8xl615I
 Y2cbcunEXcdD+Jg0SayQOAel7Qsw0jS2F/ueHwy9Dz/uZL2WZJfYe5t3IemBgzh0J65nQ==
IronPort-HdrOrdr: A9a23:Eg5ibq1du1lXLFnmIQMlTgqjBNEkLtp133Aq2lEZdPU1SKylfq
 WV98jzuiWYtN98YhsdcLO7WZVoP0myyXcd2+B4AV7IZmXbUQWTQr1f0Q==
X-Talos-CUID: 9a23:0/3QzWMDX7+XA+5DSgdf1l4qFuofLnzH8WbPBEaKNGg3V+jA
X-Talos-MUID: 9a23:73sJ+Ag4CITUvG0W46p0LMMpH8NW8r+8UXA0nrI0i8yNEgJ/KRKHpWHi
X-IronPort-AV: E=Sophos;i="6.00,229,1681185600"; d="scan'208";a="112646623"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 09 Jun 2023 11:13:53 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by PH7PR03MB7161.namprd03.prod.outlook.com (2603:10b6:510:2b7::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 9 Jun
 2023 15:13:51 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Fri, 9 Jun 2023
 15:13:50 +0000
Date: Fri, 9 Jun 2023 17:13:45 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZINBqToBZVdfmr0e@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
 <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
 <ZIA9uBJxx2gqA4Cq@Air-de-Roger> <ZICs+WYCPYdu2yoI@itl-email>
 <ZIGRXrSGmgLF/07O@Air-de-Roger> <ZIH0yQCICZRpliSc@itl-email>
In-Reply-To: <ZIH0yQCICZRpliSc@itl-email>
X-ClientProxiedBy: LO4P123CA0542.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::7) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|PH7PR03MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3c429e-66d9-47fd-0a74-08db68fc218f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: d5Ue7PcpP3u2dMM+Io7ktvMTdxS4q70nuNMJpQW//v/SbPPgr113/8gaoXOdhKo6Xpxg8hVmXhE3HtQK+ipE1bgmg24ROvuZILfGFzqaj4NDz/aWpFTaV/rXL5EY3uYCOkXgN2eLnC1bGLxDnLRZl5BrfGk0x3D7PYKL6LcziWT0/XkVABeYTG1CxleI9AWEl4OaM70vQ0xalCNuo/qPkvEBSsZR0rb4ITo629Wzek/NDscPu5wQ/Rqsn2t4xOU6cYr7jxIAUKuam0jYW7ODghBV17OAsEaT3Jxy+kSEHtMLT0ISl53hUqRChf07pNxhvi81jolg1iVd5DNRYiOIv3igqyjea7vqgEOU7nHG0cCU+sDmJpd3Gcc/46T1kn7GxmmW7W9AuP4b60m9oGe1rOxttg3ABXDUvlwV/cZWOyYRG1toJXaHX35z6ZUESfcYp4IV/FBwCYlEa+YaaSO0rEmGmw9JIXdqbZR8LP6zqYlifiZsQ+sYGAe6dzTFQfOk9vvZoE57r+iAFizXPGky/bY+A6cWD8EgKYfEDiwbbUrlc29pdourFd5yGvqoxBf1o5p7B5y/3UfGPr1ugIeaczt0cyzhOT+VRdcko2w9xHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(2906002)(5660300002)(6916009)(41300700001)(8936002)(8676002)(4326008)(54906003)(66556008)(66476007)(66946007)(478600001)(316002)(6666004)(6486002)(186003)(33716001)(86362001)(83380400001)(85182001)(82960400001)(6506007)(6512007)(9686003)(26005)(38100700002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnJYUlA5U2NnaVFqdlc0V1R5MTNzaXJMR05RQzI1Z0h5SDJHUTBHcjhIbk1Q?=
 =?utf-8?B?ZDYzc3ZtVExlajVzL1RTSXpPc1lpQVZMWXN5dHMxaFc2K0FXcDBFeUEzdng4?=
 =?utf-8?B?OEJxbnN3K1d4ZXhvb2xhRFY4cVhsTzd0OXB4TmZJeGtQeGdpK1NYUUtUS3Fs?=
 =?utf-8?B?c3lyQXhVaHpjODNqRDhqUURKeFZaZ1NzQ04rZnkxRE5TS3VrS2twMlNuYzk2?=
 =?utf-8?B?dmdnakhhaVovSXZSNmdRS3MyWGtVa1Yxc1FzK3ltZHozQ3k0ZjM0d3owTmhu?=
 =?utf-8?B?Tk82WDc4ZVVDK1A5SXIwdUl0R1RqUjQ1QjZjQXR2eEZBT1A2OEd4b3NJOHJW?=
 =?utf-8?B?MytLeEI2UlI3VVNMb21YRkE1QkNUdnRiSmVDb2pHdDBxTFMvZHlsaFJqcEJ2?=
 =?utf-8?B?WjhKcUhic3lwRWhDZUxvNkFJV3psTDdNYWR2VlB1eHE0Z3hUWlRwV1BtMGRS?=
 =?utf-8?B?TnZjV3kvVXVZdDZDZFhHeStQK3pBY1JmaWpabXp3V290MjBNK3J0ZGNFanRI?=
 =?utf-8?B?MHM1YkVmSEZlOGZMNVpFYlp3RXcvWXRSYTFkSHRPaHBkL1BIZzE2MzcwcVJu?=
 =?utf-8?B?MzdyZEQwamtoT2tpN010VngxWUprcktjVytYdzBJd0djc3J3UFBFaGYwY0h3?=
 =?utf-8?B?WXkyb2t5RE5SM0pzN1FIVTdHUFdPVDRORXlOT3A0YTkrVDNEUVhHMHc3ZHRu?=
 =?utf-8?B?bkhhQWhwRzc4ZkdJLzhmM2UraG1QcVpIN0x0eGNROEs0cHR6akxhOHZJRGcz?=
 =?utf-8?B?WFJLWS9reUF6SWI5QkhFQWF5RlkyclVIRytFSnEvOThWeXNtUXpkbmlwVGVl?=
 =?utf-8?B?M1N6NjNCdG5pZHhQOFRMWE1BYnM0b0JYbjlrUmlIZFc0Q2VtQzBIUFM5djBZ?=
 =?utf-8?B?MmZwcWxLYU1mN2Z6c2J4d2h0MXM3R0pjN3ZNS1c3UnkvKzZ2ZVNhdVNRWEhy?=
 =?utf-8?B?R0daZ1U0ZjdhV2xTeVV5UFlIeGoxemp6WmF4c3Y4WGFESlhrR1gyc0NBL0h3?=
 =?utf-8?B?MVN2TUVSSFEvUzFaS1NPL2J5TittQzBhZ3gzUG10NzB6WkpWWlJwTnhydjI4?=
 =?utf-8?B?RWQvRDk1OWVDZW1WSVdWMjZwaVZnZzk2cWpBSm05d3FNUitPakdZd0dTTzZq?=
 =?utf-8?B?K1o2V0VJWWpXYUlDTEFQaW9lMlhDWXhNWGs1WUg2eWFPWlZZUWJGeHBkK0NV?=
 =?utf-8?B?cE1KL0xwamROZmhwRGh4SjAzUmQzSlErNFdlVFlSYWNlOXRCaVQweEo1WFcw?=
 =?utf-8?B?KzR1c3BHb1RWQjh6OHVZNU03eTRDU2I2NWt4KzI3THhEWDNYdVJJMVk0d0Rw?=
 =?utf-8?B?Rmpab3VvWmhhRHVqNXZYRzdyTkxTaDF1V2s0aC9JcjJOamNQalR3eXo3cGc2?=
 =?utf-8?B?WmJCcXZhTTNrS3NEdjRLQ2J5RjFNWGk4SU1XaVFHck9JMlo1V3NOanBCYkY3?=
 =?utf-8?B?NGNaMmFYTEpYWkFUMHJJV1ZMNmJNR1hxeDBIc1JNeHA4bFd3RWZmK2Y3aXh1?=
 =?utf-8?B?UUt6ZXB0YllhemdTUnh6K1A1QTdZaVFPb2M0TFNvcWNqbVBWYnR5RXpzZnVE?=
 =?utf-8?B?ZkJyOWx1RmxZRXI1aDVIMVVIcU44MHRqTm9NL2MwMGsveWlNdVIvVktMKytQ?=
 =?utf-8?B?VUwreEdMT0UvREJZN0haaGpDRGNYNnF4ZmpvSHcvZEYwcFE4ZGFJM28wb2ZY?=
 =?utf-8?B?U3FmV2tMZnB4SHQ2VDZYakdsOU9HVWQvRm5DYXJPQ2Q2ZUZjK29mNUdvS1NN?=
 =?utf-8?B?cXhuVjRzYmRqamx0SVg1by9oYXkzaFNVTUZyRVB5bmVhMVg0VklWdjFyc241?=
 =?utf-8?B?cGprakR5VXdWTzczajI4aDVrSXorTnBWNCtjMjdhaml3VjhTaGxDays2ajA2?=
 =?utf-8?B?bW92NnN0NS9sWjhUd1BidlEyT3NmZ1VtYUR2dVpveURlVllQalFEcTNnVHhz?=
 =?utf-8?B?bEloTytVN0NUSGk1bFNtZWh2ZVFxRDNkNnBneldEVU54UFRuQVo1ZGszWnlI?=
 =?utf-8?B?bGlRZzVvRUxRN2w4cGw2MWNKSTVhMVNCRFg0VnFXNDNXc1lFSWl4WmNTMEtB?=
 =?utf-8?B?ak9IdDlqREp3NXI5a2kwZ2NFYkJCU3dNTUZwZW5QVHhRbHZsTENza2xRQU5E?=
 =?utf-8?Q?l33QYGAbTGml6xbV0FTDYJxoi?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZFlkUnFaZ1htMk9XeE5JblFpY1FIVndFM0hNUDVxUE82YVYyV2hiSUorTmJU?=
 =?utf-8?B?UVpHek9KUVF3WnhyZ1g1V3VNcmtSWjZOMmFBakVubDlZVTlxakF4WUhTNjda?=
 =?utf-8?B?V2pveERBcGVDd0hxaUo5WnNlMWFsaVZUR3UwbzFlTE1ZME1aSHhSUWw0RXpw?=
 =?utf-8?B?TXMzSFFoUUdHTWJxUjdSNUI1M01KOHBBSG5rY0VoSmp5Ri8zc1Fnd2RiL2pS?=
 =?utf-8?B?Y0Z6RytWc1ZndUQrSERLSHAyTHpNSnJWL2FRSFFlN3BQclpCbWZZa3k2Q2JW?=
 =?utf-8?B?OTl0eUU5WUpOazlpQ0pIOHl3aHdIYUREYkI1WHNCeHhQekFUYzVMZ0xqM2sv?=
 =?utf-8?B?ZzVvWnVPWnljSjJ0amlPU3JUd2JsTjM5b1pyTXVWYjVnVmVoa2IxcW9YTnNn?=
 =?utf-8?B?TGwzWHlmOS95Q010WmpsVWVPejNVZzRtb2RMV2RlUi9aWlR5ZkhndzRaVm1i?=
 =?utf-8?B?ekpHSy9mejRtVkVTZWpIKzZMK2RmeHNMWVgyQjZwUUVhY0FkdGVGRG0wcDlT?=
 =?utf-8?B?ekprd0hZODM4L3ZmS05aWnlFQm5yeHJyNDlYUFZFRUlGdGYwSkVBcXNEblpm?=
 =?utf-8?B?M2Y4RDhxUlIzZzVYOU9KMVNuQ2RmMmw2VEZobGZrKy95VmtxZTVlQlFSbkpV?=
 =?utf-8?B?SU9KblFPTlJQVTUrdFIvZ3JBM01URmdiSDRQQ2F1dDViU3l3SDJIalRnR1Bq?=
 =?utf-8?B?SjlLdnNxelNlRm05NEpBRzJqNkw3MExrVzhNRE1hekY4dGl2bVFWQm1UbTV3?=
 =?utf-8?B?TkNmbjU5dkg3MFVaalI4L3NyUGhCRks0TDlZZlFwRG9SSnZjaXR5NmMrUElW?=
 =?utf-8?B?Tm1JMzhTNC9hM3l1Qlgva3hPS3R0K3dzLzdoNXlVclErS0VPK3RZc0lnamRp?=
 =?utf-8?B?OGpKbk9HVjYzWHRqb2RQa0ZYN1VxQmI4YXNFT240c2Y2RGtySXloR1IyeXpD?=
 =?utf-8?B?WmJjL0ZvOTVrRmY4YXZsampaM0ZUb0JRZm5GSVR6RnJGU1huQThTYWNqTzZH?=
 =?utf-8?B?cGd4TVFuN3VWSjk1WGtpV0xsU3pzZjVkMzJpdkRWOGZwQmZpMGU0RnFCVDRD?=
 =?utf-8?B?M3M3SDN2OThnekZEOXR2WDQ4TzBUSm9MSTZrdTBKU2VLWE5XKzlqanlSeXZ3?=
 =?utf-8?B?dmNmQXQxc0hqSGR1ZjFLZzdVZWtKZVVWR0V4a3NPNVh5ZXNoU1RRNVo5V2tr?=
 =?utf-8?B?dmdMWnU5YUcvZ0hRSmQzTUFUc0Nvd1VNdFllZFVaRDdReWlnT2Fpb1ZvZkVG?=
 =?utf-8?B?ZEl5UW9FTWx6cWJIQXBiWlVNTG13bGJmYVFOajhQWlVsbFNTUT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3c429e-66d9-47fd-0a74-08db68fc218f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 15:13:50.9092 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eg9Y3LdB42Eq1+kEALYd0hKxNYVHh3U6763fXGi05G2CJRGSVkWu8BSrqOcAkO8EBORhfhmdpt8TcZejcFjLhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR03MB7161
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 12 Jun 2023 06:45:41 +0000
Subject: Re: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq
 checks
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gMDgsIDIwMjMgYXQgMTE6MzM6MjZBTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIFRodSwgSnVuIDA4LCAyMDIzIGF0IDEwOjI5OjE4QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBXZWQsIEp1biAwNywgMjAyMyBhdCAxMjoxNDo0
NlBNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IE9uIFdlZCwgSnVuIDA3
LCAyMDIzIGF0IDEwOjIwOjA4QU0gKzAyMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiA+
ID4gT24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMDE6MDE6MjBQTSAtMDQwMCwgRGVtaSBNYXJpZSBP
YmVub3VyIHdyb3RlOgo+ID4gPiA+ID4gT24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMTA6MjU6NDdB
TSArMDIwMCwgUm9nZXIgUGF1IE1vbm7DqSB3cm90ZToKPiA+ID4gPiA+ID4gT24gVHVlLCBNYXkg
MzAsIDIwMjMgYXQgMDQ6MzE6MTNQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVub3VyIHdyb3RlOgo+
ID4gPiA+ID4gPiBBbHNvLCB5b3UgdGllIHRoaXMgbG9naWMgdG8gdGhlICJwaHlzaWNhbC1kZXZp
Y2UiIHdhdGNoLCB3aGljaAo+ID4gPiA+ID4gPiBzdHJpY3RseSBpbXBsaWVzIHRoYXQgdGhlICJk
aXNrc2VxIiBub2RlIG11c3QgYmUgd3JpdHRlbiB0byB4ZW5zdG9yZQo+ID4gPiA+ID4gPiBiZWZv
cmUgdGhlICJwaHlzaWNhbC1kZXZpY2UiIG5vZGUuICBUaGlzIHNlZW1zIGZyYWdpbGUsIGJ1dCBJ
IGRvbid0Cj4gPiA+ID4gPiA+IHNlZSBtdWNoIGJldHRlciBvcHRpb25vIHNpbmNlIHRoZSAiZGlz
a3NlcSIgaXMgb3B0aW9uYWwuCj4gPiA+ID4gPiAKPiA+ID4gPiA+IFdoYXQgYWJvdXQgaW5jbHVk
aW5nIHRoZSBkaXNrc2VxIGluIHRoZSAicGh5c2ljYWwtZGV2aWNlIiBub2RlPyAgUGVyaGFwcwo+
ID4gPiA+ID4gdXNlIGRpc2tzZXFAbWFqb3I6bWlub3Igc3ludGF4Pwo+ID4gPiA+IAo+ID4gPiA+
IEhtLCBob3cgd291bGQgeW91IGtub3cgd2hldGhlciB0aGUgYmxrYmFjayBpbnN0YW5jZSBpbiB0
aGUga2VybmVsCj4gPiA+ID4gc3VwcG9ydHMgdGhlIGRpc2tzZXEgc3ludGF4IGluIHBoeXNpY2Fs
LWRldmljZT8KPiA+ID4gCj4gPiA+IFRoYXTigJlzIHdoYXQgdGhlIG5leHQgcGF0Y2ggaXMgZm9y
IPCfmYIuCj4gPiAKPiA+IEhtLCBJIHRoaW5rIHdlIHNob3VsZCBzZXBhcmF0ZSBkaXNrc2VxIHN1
cHBvcnQgZnJvbSB0aGUgbm90aWZ5IG9wZW4KPiA+IHN0dWZmOiBpdCdzIHBvc3NpYmxlIGEgZGlm
ZmVyZW50IChub24tTGludXgpIGJhY2tlbmQgd2FudHMgdG8KPiA+IGltcGxlbWVudCBvcGVuIG5v
dGlmeSBzdXBwb3J0IGJ1dCBkb2Vzbid0IGhhdmUgZGlza3NlcS4KPiAKPiBJIGxpa2UgdGhpcyBp
ZGVhISAgV2hhdCBhYm91dCBoYXZpbmcgYmxrYmFjayBzZXQgZGlza3NlcSB0byB6ZXJvPwo+IFVz
ZXJzcGFjZSBjb3VsZCB0aGVuIHJlcGxhY2UgaXQgd2l0aCB0aGUgYWN0dWFsIHZhbHVlLgoKSSB0
aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYgd2UgdXNlZCBhIHN5c2ZzIG5vZGUsIGJlY2F1c2Ug
YmxrZnJvbnQKaGFzIG5vIGJ1c2luZXNzIGlzIGtub3dpbmcgd2hldGhlciBkaXNrc2VxIGlzIHN1
cHBvcnRlZCBieSB0aGUKYmFja2VuZCBvciBub3QuCgp4ZW5zdG9yZSBzaG91bGQgYmUgcmVzZXJ2
ZWQgdG8gZmVhdHVyZXMgZXhwb3NlZCBiZXR3ZWVuIGJsa2Zyb250IGFuZApibGtiYWNrIGlmIHBv
c3NpYmxlLiAgSSBrbm93IHdlIGhhdmVuJ3QgYmVlbiB2ZXJ5IGdvb2QgYXQgdGhpcwpob3dldmVy
LgoKPiA+ID4gPiBDYW4geW91IGZldGNoIGEgZGlzayB1c2luZyBhIGRpc2tzZXEgaWRlbnRpZmll
cj8KPiA+ID4gCj4gPiA+IE5vdCB5ZXQsIGFsdGhvdWdoIEkgaGF2ZSBjb25zaWRlcmVkIGFkZGlu
ZyB0aGlzIGFiaWxpdHkuICBJdCB3b3VsZCBiZQo+ID4gPiBvbmUgc3RlcCB0b3dhcmRzIGEg4oCc
ZGlza3NlcWZz4oCdIHRoYXQgdXNlcnNwYWNlIGNvdWxkIHVzZSB0byBvcGVuIGEgZGV2aWNlCj4g
PiA+IGJ5IGRpc2tzZXEuCj4gPiA+IAo+ID4gPiA+IFdoeSBJIHVuZGVyc3RhbmQgdGhhdCB0aGlz
IGlzIGFuIGV4dHJhIHNhZmV0eSBjaGVjayBpbiBvcmRlciB0byBhc3NlcnQKPiA+ID4gPiBibGti
YWNrIGlzIG9wZW5pbmcgdGhlIGludGVuZGVkIGRldmljZSwgaXMgdGhpcyBhdHRlbXB0aW5nIHRv
IGZpeCBzb21lCj4gPiA+ID4gZXhpc3RpbmcgaXNzdWU/Cj4gPiA+IAo+ID4gPiBZZXMsIGl0IGlz
LiAgSSBoYXZlIGEgYmxvY2sgc2NyaXB0ICh3cml0dGVuIGluIEMpIHRoYXQgdmFsaWRhdGVzIHRo
ZQo+ID4gPiBkZXZpY2UgaXQgaGFzIG9wZW5lZCBiZWZvcmUgcGFzc2luZyB0aGUgaW5mb3JtYXRp
b24gdG8gYmxrYmFjay4gIEl0IHVzZXMKPiA+ID4gdGhlIGRpc2tzZXEgdG8gZG8gdGhpcywgYnV0
IGZvciB0aGF0IHByb3RlY3Rpb24gdG8gYmUgY29tcGxldGUsIGJsa2JhY2sKPiA+ID4gbXVzdCBh
bHNvIGJlIGF3YXJlIG9mIGl0Lgo+ID4gCj4gPiBCdXQgaWYgeW91ciBibG9jayBzY3JpcHQgb3Bl
bnMgdGhlIGRldmljZSwgYW5kIGtlZXBzIGl0IG9wZW4gdW50aWwKPiA+IGJsa2JhY2sgaGFzIGFs
c28gdGFrZW4gYSByZWZlcmVuY2UgdG8gaXQsIHRoZXJlJ3Mgbm8gd2F5IHN1Y2ggZGV2aWNlCj4g
PiBjb3VsZCBiZSByZW1vdmVkIGFuZCByZWNyZWF0ZWQgaW4gdGhlIHdpbmRvdyB5b3UgcG9pbnQg
b3V0IGFib3ZlLCBhcwo+ID4gdGhlcmUncyBhbHdheXMgYSByZWZlcmVuY2Ugb24gaXQgdGFrZW4/
Cj4gCj4gVGhpcyBhc3N1bWVzIHRoYXQgdGhlIGJsb2NrIHNjcmlwdCBpcyBub3Qga2lsbGVkIGlu
IHRoZSBtZWFudGltZSwKPiB3aGljaCBpcyBub3QgYSBzYWZlIGFzc3VtcHRpb24gZHVlIHRvIHRp
bWVvdXRzIGFuZCB0aGUgT09NIGtpbGxlci4KCkRvZXNuJ3Qgc2VlbSB2ZXJ5IHJlbGlhYmxlIHRv
IHVzZSB3aXRoIGRlbGV0ZS1vbi1jbG9zZSBlaXRoZXIgdGhlbi4KCj4gPiA+ID4gSSdtIG5vdCBz
dXJlIEkgc2VlIGhvdyB0aGUgbWFqb3I6bWlub3IgbnVtYmVycyB3b3VsZCBwb2ludCB0byBhCj4g
PiA+ID4gZGlmZmVyZW50IGRldmljZSB0aGFuIHRoZSBvbmUgc3BlY2lmaWVkIGJ5IHRoZSB0b29s
c3RhY2sgdW5sZXNzIHRoZQo+ID4gPiA+IGFkbWluIGV4cGxpY2l0bHkgbWVzc2VzIHdpdGggdGhl
IGRldmljZXMgYmVmb3JlIGJsa2JhY2sgaGFzIGdvdCB0aW1lCj4gPiA+ID4gdG8gb3BlbiB0aGVt
LiAgQnV0IHRoZW4gdGhlIGFkbWluIGNhbiBhbHJlYWR5IGRvIHByZXR0eSBtdWNoCj4gPiA+ID4g
ZXZlcnl0aGluZyBpdCB3YW50cyB3aXRoIHRoZSBzeXN0ZW0uCj4gPiA+IAo+ID4gPiBBZG1pbnMg
dHlwaWNhbGx5IHJlZmVyIHRvIGUuZy4gZGV2aWNlLW1hcHBlciBkZXZpY2VzIGJ5IG5hbWUsIG5v
dCBieQo+ID4gPiBtYWpvcjptaW5vciBudW1iZXIuICBJZiBhIGRldmljZSBpcyBkZXN0cm95ZWQg
YW5kIHJlY3JlYXRlZCByaWdodCBhcyB0aGUKPiA+ID4gYmxvY2sgc2NyaXB0IGlzIHJ1bm5pbmcs
IHRoaXMgcmFjZSBjb25kaXRpb24gY2FuIG9jY3VyLgo+ID4gCj4gPiBSaWdodCwgYnV0IHdoYXQg
YWJvdXQgdGhpcyBkZXZpY2UgcmVjcmVhdGlvbiBoYXBwZW5pbmcgYWZ0ZXIgdGhlIGFkbWluCj4g
PiBoYXMgd3JpdHRlbiB0aGUgZ3Vlc3QgY29uZmlnIGZpbGUgYnV0IGJlZm9yZSB0aGUgY2FsbCB0
byAobGliKXhsCj4gPiBoYXBwZW5zPyAgYmxrYmFjayB3b3VsZCBhbHNvIGVuZCB1cCB1c2luZyBh
IGRpZmZlcmVudCBkZXZpY2UgdGhhbgo+ID4gaW5kZW50ZWQsIGFuZCB5b3VyIHByb3Bvc2VkIGFw
cHJvYWNoIGRvZXNuJ3QgZml4IHRoaXMuICBUaGUgb25seSB3YXkgdG8KPiA+IHNvbHZlIHRoaXMg
d291bGQgYmUgdG8gcmVmZXJlbmNlIGRldmljZXMgYnkgVVVJRCAoaW93OiBkaXNrc2VxKQo+ID4g
ZGlyZWN0bHkgaW4gdGhlIGd1ZXN0IGNvbmZpZyBmaWxlLgo+IAo+IFRoYXQgd291bGQgYmUgYSBn
b29kIGlkZWEsIGJ1dCBpdCBpcyBvcnRob2dvbmFsIHRvIHRoaXMgcGF0Y2guICBNeQo+IHNjcmlw
dCBvcGVucyB0aGUgZGV2aWNlIGFuZCB1c2VzIHZhcmlvdXMgbWVhbnMgdG8gY2hlY2sgdGhhdCBp
dCBkaWQKPiBvcGVuIHRoZSBjb3JyZWN0IGRldmljZS4gIEl0IHRoZW4gcGFzc2VzIHRoZSBkaXNr
c2VxIHRvIGJsa2JhY2suCgpIb3cgeW91IGRvIHRoaXMgd2l0aCBsb3NldHVwPyAgSSBndWVzcyB0
aGVyZSdzIGFuIGF0b21pYyB3YXkgdG8gc2V0dXAKYSBsb29wIGRldmljZSBhbmQgZ2V0IGl0cyBk
aXNrc2VxPwoKPiA+IFRoZW4gdGhlIGJsb2NrIHNjcmlwdCB3aWxsIG9wZW4gdGhlIGRldmljZSBi
eSBkaXNrc2VxIGFuZCBwYXNzIHRoZQo+ID4gbWFqb3I6bWlub3IgbnVtYmVycyB0byBibGtiYWNr
Lgo+IAo+IEFsdGVybmF0aXZlbHksIHRoZSB0b29sc3RhY2sgY291bGQgd3JpdGUgYm90aCB0aGUg
ZGlza3NlcSBhbmQKPiBtYWpvcjptaW5vciBudW1iZXJzIGFuZCBiZSBjb25maWRlbnQgdGhhdCBp
dCBpcyByZWZlcnJpbmcgdG8gdGhlCj4gY29ycmVjdCBkZXZpY2UsIG5vIG1hdHRlciBob3cgbG9u
ZyBhZ28gaXQgZ290IHRoYXQgaW5mb3JtYXRpb24uCj4gVGhpcyBjb3VsZCBiZSBxdWl0ZSB1c2Vm
dWwgZm9yIGUuZy4gb25lIFZNIGV4cG9ydGluZyBhIGRldmljZSB0bwo+IGFub3RoZXIgVk0gYnkg
Y2FsbGluZyBsb3NldHVwKDgpIGFuZCBleHBlY3RpbmcgYSBodW1hbiB0byBtYWtlIGEKPiBkZWNp
c2lvbiBiYXNlZCBvbiB2YXJpb3VzIHByb3BlcnRpZXMgYWJvdXQgdGhlIGRldmljZS4gIEluIHRo
aXMKPiBjYXNlIHRoZXJlIGlzIG5vIHVwcGVyIGJvdW5kIG9uIHRoZSByYWNlIHdpbmRvdy4KCklu
c3RlYWQgb2YgcGxheWluZyB3aXRoIHhlbnN0b3JlIG5vZGVzLCBpdCBtaWdodCBiZSBiZXR0ZXIg
dG8gc2ltcGx5CmhhdmUgYmxrYmFjayBleHBvcnQgb24gc3lzZnMgdGhlIGRpc2tzZXEgb2YgdGhl
IG9wZW5lZCBkZXZpY2UsIGFuZCBsZXQKdGhlIGJsb2NrIHNjcmlwdCBjaGVjayB3aGV0aGVyIHRo
YXQncyBjb3JyZWN0IG9yIG5vdC4gIFRoYXQgaW1wbGllcwpsZXNzIGNvZGUgaW4gdGhlIGtlcm5l
bCBzaWRlLCBhbmQgZG9lc24ndCBwb2xsdXRlIHhlbnN0b3JlLgoKUmVnYXJkcywgUm9nZXIuCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

