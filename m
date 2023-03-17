Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93439C7618A
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 05:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679289430;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VEJmepF6Tn4cCXHmqlhTPDPyVvIi0QgiQLXIqQvsXgQ=;
	b=Ct5bB+iC37SwohVaODY2ZwZc44m7Z/myh7komV5pSzduUbU5SZTMbr1yNi0Ol6nQY1KCaq
	ATxepJwYftnIaORmUzGEZTyBKKzThnNHZj/GnwkRJ8mtPNd4IIA2D78bW7E7VzuEIPHCrw
	kJ7jAg5kHQDC7Dei2ULS83SJOubHEbM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-T3u9UAbyPCCRv0aRxSHJ0A-1; Mon, 20 Mar 2023 01:17:08 -0400
X-MC-Unique: T3u9UAbyPCCRv0aRxSHJ0A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 625563810B1D;
	Mon, 20 Mar 2023 05:17:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9EB71C15BA0;
	Mon, 20 Mar 2023 05:17:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99EB219459FC;
	Mon, 20 Mar 2023 05:16:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F3F01946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Mar 2023 08:01:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D86DE2027047; Fri, 17 Mar 2023 08:01:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CFB362027046
 for <dm-devel@redhat.com>; Fri, 17 Mar 2023 08:01:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC2DB811E7E
 for <dm-devel@redhat.com>; Fri, 17 Mar 2023 08:01:46 +0000 (UTC)
Received: from mail-edgeKA27.fraunhofer.de (mail-edgeka27.fraunhofer.de
 [153.96.1.27]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-6QCiaonPPdeOQbI28M8_UQ-1; Fri, 17 Mar 2023 04:01:42 -0400
X-MC-Unique: 6QCiaonPPdeOQbI28M8_UQ-1
X-IPAS-Result: =?us-ascii?q?A2FOCAA1HRRk/x0BYJlQCh4BAQsSDECDfYJPhFORAS4Dn?=
 =?us-ascii?q?CaCUQMYPg8BAQEBAQEBAQEHAQFEBAEBAwSEfgKFNiY4EwECAQMBAQEBAwIDA?=
 =?us-ascii?q?QEBAQEBAwEBBgEBAQEBAQYEAgKBGYUvOQ2DVk07AQEBAQEBAQEBAQEBAQEBA?=
 =?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBBQKBCE4BAQEBAgEjBAsBDQEBNwEPCxgCA?=
 =?us-ascii?q?iYCAjIlBg0BBQIBAYJ6gikDDiOyAHp/M4EBgggBAQacVRiBHYEeCQkBgQosg?=
 =?us-ascii?q?0yNaIJPgTwPgQaBNzc+gQUBgxEtFYNDgmeZAgqBNHaBIA6BPYEEAgkCEWuBE?=
 =?us-ascii?q?ghrgX1BAg1lCw52gUwCgVolBA4DGSsdQAIBCzs6PzUJCyFeawItERMFAwsVK?=
 =?us-ascii?q?kcECDkGGzQRAggPEg8GJkMOQjc0EwZcASkLDhEDT4FHBC9cgQEGASYknGogg?=
 =?us-ascii?q?Q4xgVBzHpJFAYMai1KiDAeCKIFVoHEGDwQulxaSKZdqp3ECBAIEBQIOCIF5g?=
 =?us-ascii?q?X8zPoM2UhkPjiAMCwuDUI96dAI5AgcBCgEBAwmCOYQShHgBAQ?=
IronPort-PHdr: A9a23:wKuoBR04ZvW943jlsmDO+QUyDhhOgF2JFhBAs8lvgudUaa3m5JTrZ
 hGBtr1m2UXEWYzL5v4DkefSurDtVT9lg96N5X4YeYFKVxgLhN9QmAolAcWfDlb8IuKsZCs/T
 4xZAURo+3ywLU9PQoPwfVTPpH214zMIXxL5MAt+POPuHYDOys+w0rPXmdXTNitSgz/vTbpuI
 UeNsA/Tu8IK065vMb04xRaMg1caUONQ2W5uORevjg7xtOKR2bMmzSlKoPMm8ZxwFIDBOokoR
 rxRCjsrdls44sHmrzDvZguC7XhPNwdemBodWDrp9B7DTqrzuCahpMNchi25MffNZIsVa2zh6
 5pmVTjk0RYqL2IG+1Hat5kj6cATqke4rRtczr/tXq2eO/wmfqX8Id8xSGtiUNRPXiFbGZ6tT
 LcSJusaMbhahoispH8NkCSuLDa2O8bXzDJDvXP1wPMa4dUYDz3Hhyh7PvkkoWb9ru/lM7kZb
 e6T1oLu6A7zZMlygQbj1bDhTQAz+8vRQOMudcjR1EkGTTvGj0yiiaPeMRWl/NUhjDjAtuhGC
 /2vim8LoBlwpQqI5cAzmobujJgH52HY8Qx1x74OH8btGwZrJN++F51IsDuGcpF7Wd4mXzRws
 T0hmdXu2La+dSkOjZkryBP8QqbYNYaS6w/lVOGfLC0+iH82ML68hhPn6UG70aW8Tci71l9Ws
 zBI2sfBrHED1hHfq4CHR/Jx813n2GOn2Rra9+dEJk45j+zcLZsgyaQ3jZ0drQLIGSqepQ==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.98,268,1673910000"; d="scan'208";a="50838543"
Received: from mail-mtaka29.fraunhofer.de ([153.96.1.29])
 by mail-edgeKA27.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Mar 2023 09:00:34 +0100
IronPort-SDR: 64141e1e_3Nl5rKR4SHTN1yg7J41ulNu7W6eEkP8Q59y3mZxM8zzeqac
 zS/lT4WXqFDQoxHxb8K5MJg7dpLfRYzkVJiHUvw==
X-IPAS-Result: =?us-ascii?q?A0DoCAA1HRRk/3+zYZlQChwBAQEBAQEHAQESAQEEBAEBQ?=
 =?us-ascii?q?AkcgSqBXFIHgUYqWIRSg00BAYUvhg2CJAM5m22CUQNWDwEDAQEBAQEHAQFEB?=
 =?us-ascii?q?AEBhQUChTMCJjgTAQIBAQIBAQEBAwIDAQEBAQEBAwEBBQEBAQIBAQYEgQoTh?=
 =?us-ascii?q?WgNhlUBAQEBAgESEQQLAQ0BARQjAQ8LGAICJgICMgceBg0BBQIBAR6CXIIpA?=
 =?us-ascii?q?w4jAgEBphsBgT8Cih96fzOBAYIIAQEGBAScTRiBHYEeCQkBgQosg0yNaIJPg?=
 =?us-ascii?q?TwPgQaBNzc+gQUBgxEtg1iCZ5kCCoE0doEgDoE9gQQCCQIRa4ESCGuBfUECD?=
 =?us-ascii?q?WULDnaBTAKBWiUEDgMZKx1AAgELOzo/NQkLIV5rAi0REwUDCxUqRwQIOQYbN?=
 =?us-ascii?q?BECCA8SDwYmQw5CNzQTBlwBKQsOEQNPgUcEL1yBAQYBJiScaiCBDjGBUHMek?=
 =?us-ascii?q?kUBgxqLUqIMB4IogVWgcQYPBC6XFpIpl2qncQIEAgQFAg4BAQaBeSWBWTM+g?=
 =?us-ascii?q?zZPAxkPjiAMCwuDUI96QjICOQIHAQoBAQMJgjmEEoR4AQE?=
IronPort-PHdr: A9a23:XmK96hRwx6fHEHjvvkwkf4fLu9psovKeAWYlg6HP9ppQJ/3wt523J
 lfWoO5thQWUA9aT4Kdehu7fo63sHnYN5Z+RvXxRFf4EW0oLk8wLmQwnDsOfT0r9Kf/hdSshG
 8peElRi+iLzKh1OFcLzbEHVuCf34yQbBxP/MgR4PKHyHIvThN6wzOe859jYZAAb4Vj1YeZcN
 hKz/ynYqsREupZoKKs61knsr2BTcutbgEJEd3mUmQrx4Nv1wI97/nZ1mtcMsvBNS777eKJqf
 fl9N3ELI2s17cvkuFz4QA2D62E1fk4WnxFLUG2npBv6C8zDnjP1j/pA2iOXZt/fbO4wejiY1
 I5QaS2wyyM6OiMe/Djmp9Qss6lrrS/09Hkdi4SBeYuSF/dPR53xdtwcHWpHf5pdfCFAIY2uc
 YICFfEcLMVksqD8vFdQrzK/VAqIB97Q2hZ3nEDT5as32N8tEhyY/D4RJswysS/w9/TeHrYAe
 OKP3K7WxgnNSel9/xLG2IPyVkgQv8y0dI1gY5DrlFR+SQfHjkiQgNbdPDKM5MQiiGa938BRe
 d3/0DcljV9uojmu6sw0i477oaES1UDL0i9j0qsEOdmRRElDWuS/RcgYp2SbLYxwWsQ4XyRyt
 T0nzqFToZegZ3tiIPUPwhfeb7mCb4Gry0iyEuiLKCp+hHVrdaj5ixvhuUSjy+ipTsCvyx4Kt
 StKlNDQq2oAnwLe8MmJS/Zxvw+h1D+D2hqV67RsL1o9iKzbLJAs2Pg3kJ8Sul7EBSj4hAP9i
 6r+Sw==
IronPort-Data: A9a23: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
IronPort-HdrOrdr: A9a23:33RYVa5vn9Zja603pAPXwNbXdLJyesId70hD6qkXc203TiX4ra
 CTdZsgpHrJYVoqNE3I+urgBEDjex7hHPdOiOF7V4tKNzOJhILHFu5fBcCL+UyDJxHD
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.98,268,1673910000"; d="scan'208";a="44483565"
Received: from 153-97-179-127.vm.c.fraunhofer.de (HELO
 smtp.exch.fraunhofer.de) ([153.97.179.127])
 by mail-mtaKA29.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Mar 2023 09:00:29 +0100
Received: from XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 17 Mar 2023 09:00:29 +0100
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (104.47.7.170) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP
 Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25 via Frontend Transport; Fri, 17 Mar 2023 09:00:29 +0100
Received: from BEZP281MB2791.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:50::14)
 by FR3P281MB1804.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:6d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 08:00:28 +0000
Received: from BEZP281MB2791.DEUP281.PROD.OUTLOOK.COM
 ([fe80::695e:eca6:9177:29bc]) by BEZP281MB2791.DEUP281.PROD.OUTLOOK.COM
 ([fe80::695e:eca6:9177:29bc%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 08:00:28 +0000
Message-ID: <1f58acef-1e93-ed7a-3ad8-dd0927dacddc@aisec.fraunhofer.de>
Date: Fri, 17 Mar 2023 09:00:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Mike Snitzer <snitzer@kernel.org>
References: <20230301113415.47664-1-michael.weiss@aisec.fraunhofer.de>
 <CAHC9VhQ_zvTqck4A7HvqH2rcwxuato_9nVWMk_Yf=ip3q9omgA@mail.gmail.com>
From: =?UTF-8?Q?Michael_Wei=c3=9f?= <michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <CAHC9VhQ_zvTqck4A7HvqH2rcwxuato_9nVWMk_Yf=ip3q9omgA@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::19) To BEZP281MB2791.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:50::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BEZP281MB2791:EE_|FR3P281MB1804:EE_
X-MS-Office365-Filtering-Correlation-Id: 69afe9ff-beb2-414e-841c-08db26bdac09
X-LD-Processed: f930300c-c97d-4019-be03-add650a171c4,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: V9aOcJSqrCHiiVkppXDoFEBjdwz17yZYoybWsQU4oUc0bLXRbMqVhmNoUlEbuo5sI3Xy58R4/eS+SOkl2tKMYdnYn83EnfhVRLKKi4KFA9ZREZP1jbKvm6a94OTh9AT2oT8OrH3cBXyMsH0z2Ssg+QbM1ACTJJeSQVJjQUvg0rZBZTlSkvSeZpPWTG2xUZEH2/h4AZb2OBRp0bj8K6ZmhoOZ/tu54RRpIchUzzmz/vvv+Kj5xy3TL4JrX37xisqG1qWdoYBE0A7KX3pR9n2XWkpFZ5bdv8F0+Le5MginHTQA0dSK4KpPNSFMDaq5/aZWZ3kM2XHep07jMcP/F3m/DAQQHZipF8hKLfNU3FduZWGSyxiIgGHphacvdBfS52j+IrQKQVBQZQpiavBz4aiyVu1tbFyZJH+bJ/SR1mk6FMv7m7AnBI+KeC4uRGBXkAVbXhb4GjJYg/LXiGyfRomQkfUqX1sZuSvn8KYrlF0XkQ7AKcmTJr2FcVsxZlBcNUqfhrS3AN8hQsZDkdXqG1QiD19+/vT9thkpqil0B82Dah+MZuZrUE3/6ONCVjZsUc8KJ+3EpUjrzBTD3bxckaoQWwTYpybeLq8uiG6BD35zNIi7Crb7r3EvhrYgrU4JhPfceoC3xa6TwSCx+A0pB+aV5IuHyyJ/FTjYrrcLrlgTXe/5s2MTGTSbSLdtSA7fBceFCRk+uXE8yfLA0Vs+U93LEpmJe8tx9G4iGXQsupOEeOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BEZP281MB2791.DEUP281.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(13230025)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199018)(6512007)(6506007)(186003)(53546011)(83380400001)(31696002)(86362001)(82960400001)(38100700002)(2616005)(4326008)(66946007)(66476007)(8676002)(66556008)(316002)(54906003)(8936002)(5660300002)(31686004)(2906002)(41300700001)(6916009)(6486002)(6666004)(478600001)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWdVbFlzNnR1ZW1hZ0ZqQWsyS0p1Tm1pWElmZDZLckxURXdwaDgyN0g2UHd5?=
 =?utf-8?B?NjVoRWdONWhVWnY3N3ZmNEVNbWJWUmdKNW5HQWxOMDJmM3Vmc3UvTW5hUFVi?=
 =?utf-8?B?allkcWhkQ0Z0Y0lxSytHNkZucC92d1ZpUkJESkRHQmJoT2YyVlVmODlET1N3?=
 =?utf-8?B?dTdnbzlSWUxVbTAvOHFYMHlvcU4xNGgxR3F6RnJyM081K1RybkYzTy9xelZv?=
 =?utf-8?B?Y3RXM0tYUlUyNmNXOUxWVy9SbTNOaW5rZ3JFRzJWVVU2cW9JVmMvVno5czc5?=
 =?utf-8?B?ZTZuaHU4b2F6cGJwMFFpaEl5UHBzK0JRVllXV2wxbSt2RW5xT2hrOGVYUVlK?=
 =?utf-8?B?WlR2cExIQjlQa3MxQkRPSUNtVkQ3L1ZteDQ5OWNaa3hXZmRQbkZTVHE1WXA0?=
 =?utf-8?B?NDRFWHNweW96N2ZqWHJMaUZRVHV5OWZzZkxDNzZ6ZGNSKzJkemNCTUJwbW1X?=
 =?utf-8?B?dU5ob1BmWUdXL0xFMWlYQjJGeUN6YlVwdFp4Zm5vL0dlVVQxTXRUa1AwQk4y?=
 =?utf-8?B?UmhvdVMwN1FpY0F1ZWdic0dteHNpNVZwbWVjQzVGZkRTb1hHY2NUSkRXZ1Ra?=
 =?utf-8?B?anAzRXJpcEhGM3VsWncvREVtdXhxOEFwN01WcmpmWHdVZ3VGR2FhcGcwNXIv?=
 =?utf-8?B?ZjRjZkt5N0VvRzZzT2JIRWFXOWVMWVlkTjFwSU14S1FJVUhaK2E5NG1Qamp6?=
 =?utf-8?B?NWdTalhtVVdod3plMVlrMm9icyt1SEpraVhuck9oQ29JNEYrZFpvU1ZCMEw5?=
 =?utf-8?B?OCt1TXEvMFJpdmd2SGx0K3Z0OHEzSXlpSy9uL0h6eGhaWHdzOUtiL3pKRCtx?=
 =?utf-8?B?ejVidHBMOFRQUHlSaGZyelBuNDFrOTZQWFg2K2dvYzdtVVV2Rk1tSzJaTG9F?=
 =?utf-8?B?Qzg3bTN4cjdPcTVOdnkyNi9RL0hQSGZKOGJyV3lKV2ZDa3JUZi9NSndKQXJm?=
 =?utf-8?B?UElqS0VVbWhDcUdBdkVndlN0UWlVeHFyS3RZWXNYOWpjR2N4cG50a2g2ei9l?=
 =?utf-8?B?cEpXMHZBS1g4M3lHSFoyd0NVZlpRVTdGbk4zVmpIQUZrZlEwZjBUeERPOUlj?=
 =?utf-8?B?V1MrN2ViNnZwY2ZhSzJHNVoyM2ZvcGxKV0lPL0UvRXd0QkdKM01GbmdvY1dV?=
 =?utf-8?B?S3BvMGNHZGJZVmRSbW5tSnMvSTlPV0NpNllYeDlqSmlSNFNuN0FRNVVwMTRw?=
 =?utf-8?B?N2tFWTRKMHd1ZDQzc0J1NzczeU9RVWcyWnpZNTNEeHFWNjJhbVU5dmxpajZi?=
 =?utf-8?B?SWdFcTBtYjRtd2x3RXYvaFZ5QmkyNjk4QUFPaG0yYXJnV1FPUWY3QTg0UGZo?=
 =?utf-8?B?Rk1VS21JSitKS0loUWxiQndVVmVxS3lxa3lYZ3B3bFlUdWNRMTdqcGN3alpu?=
 =?utf-8?B?RllrMmxUOEgwZldHUkxTM2Yrd0lka3k5Z2R1K1hQcGFQUk5WN2pBS294TjBy?=
 =?utf-8?B?R2ttN1crR2ZGL1BhWGhhd2JuVkFXN2w3bkRCdVU3NlpTS0NuK2FzOVBrWkZw?=
 =?utf-8?B?L0wybkhzaC9NSUZDZG0rOGNJZ3ZrVklCc1MyUFo3Snk4ZDRlOHo1aTJSR1ZF?=
 =?utf-8?B?VllBUFRva2hKcnFSd2I0TnVsUDd4cW5xT0t5T08wZ2d0VkM2WDBQNmcrMVRt?=
 =?utf-8?B?NFZIWDFYMFRoVEM1Tklzd0gyQWROTEZYdEhubitNZjFLMitueVBQOXNLa0xR?=
 =?utf-8?B?MXpNcjJHcFlrMjFXUVlyTTRYUWhBUmhUeHFTblZLbWZQMlF2SDhncVFSZGd1?=
 =?utf-8?B?bXN5THFWZmJEZGVNRG5WaWhFKzlKNWZmREgvemVXbFhLT3N6dlRXSmtXamxZ?=
 =?utf-8?B?RkRRNDlKRXZxQnpIYkdXR0hvL2dCUEJqaWRDcGJOSXZ0N1NlKzRXanBiUE5l?=
 =?utf-8?B?RTJyN0d3QTZ6bjVoWGlWbmUwWU9NZGlaY25GbVR5eGpGVjdweWJBN1FoTG5W?=
 =?utf-8?B?VTRsS3Y2emZhU09sQmEzTGZHSmFsL24vVW5VTVArc0hqL3hldmR2Sk5FY1hp?=
 =?utf-8?B?ek4xSFkxanhUbzdJcENhcmszNmQ3UlZMUzhtUTFEMUdVNzlaLzlySWNManhD?=
 =?utf-8?B?NlJFeXZNYzZwaFdNVThEZ3NXcmNIaGQ1YllTSTN6NVFRSG9LRE9tQ2RZbjRi?=
 =?utf-8?B?UkFOSXluNFZ4dlZORTNDQmxNakZ1Nyt2WHRCWHRUTTVqYkVrQXRQblErYUpo?=
 =?utf-8?B?SDdsZWY0ODlmV3VQVTVJWGU2ZkdyQmRkb2lwL09DVDEvVTh2YkVxekJRQk0r?=
 =?utf-8?Q?J47gBYwCgrFEApkk98LOFVxs71hIT0U0fCPAuq4/bI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69afe9ff-beb2-414e-841c-08db26bdac09
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB2791.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 08:00:28.1286 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ug2blbcfFa855mSLEE80g7R5gwU3SJ+g0MOokuZFBCnfwUV0wIdQuP7AWb0yFUhlUMdizEP0KbL3LO0/0QPFs8fGHc8RIQja+TV2n4jd9fF8XIGXdVKtYGOfkZTGgI9u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB1804
X-OriginatorOrg: aisec.fraunhofer.de
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 20 Mar 2023 05:16:58 +0000
Subject: Re: [dm-devel] [PATCH] dm verity: log audit events for dm-verity
 target
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
Cc: Paul Moore <paul@paul-moore.com>, gyroidos@aisec.fraunhofer.de,
 Richard Guy Briggs <rgb@redhat.com>, open list <linux-kernel@vger.kernel.org>,
 Eric Paris <eparis@redhat.com>,
 "open list:AUDIT SUBSYSTEM" <audit@vger.kernel.org>,
 "maintainer:DEVICE-MAPPER \(LVM\)" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMDIuMDMuMjMgMDM6MjUsIFBhdWwgTW9vcmUgd3JvdGU6Cj4gT24gV2VkLCBNYXIgMSwgMjAy
MyBhdCA2OjM04oCvQU0gTWljaGFlbCBXZWnDnwo+IDxtaWNoYWVsLndlaXNzQGFpc2VjLmZyYXVu
aG9mZXIuZGU+IHdyb3RlOgo+Pgo+PiBkbS12ZXJpdHkgc2lnbmFscyBpbnRlZ3JpdHkgdmlvbGF0
aW9ucyBieSByZXR1cm5pbmcgSS9PIGVycm9ycwo+PiB0byB1c2VyIHNwYWNlLiBUbyBpZGVudGlm
eSBpbnRlZ3JpdHkgdmlvbGF0aW9ucyBieSBhIGNvbnRyb2xsaW5nCj4+IGluc3RhbmNlLCB0aGUg
a2VybmVsIGF1ZGl0IHN1YnN5c3RlbSBjYW4gYmUgdXNlZCB0byBlbWl0IGF1ZGl0Cj4+IGV2ZW50
cyB0byB1c2VyIHNwYWNlLiBBbmFsb2dvdXMgdG8gZG0taW50ZWdyaXR5LCB3ZSBhbHNvIHVzZSB0
aGUKPj4gZG0tYXVkaXQgc3VibW9kdWxlIGFsbG93aW5nIHRvIGVtaXQgYXVkaXQgZXZlbnRzIG9u
IHZlcmlmaWNhdGlvbgo+PiBmYWlsdXJlcyBvZiBtZXRhZGF0YSBhbmQgZGF0YSBibG9ja3MgYXMg
d2VsbCBhcyBpZiBtYXggY29ycnVwdGVkCj4+IGVycm9ycyBhcmUgcmVhY2hlZC4KPj4KPj4gVGhl
IGNvbnN0cnVjdGlvbiBhbmQgZGVzdHJ1Y3Rpb24gb2YgdmVyaXR5IGRldmljZSBtYXBwaW5ncyBh
cmUKPj4gYWxzbyByZWxldmFudCBmb3IgYXVkaXRpbmcgYSBzeXN0ZW0uIFRodXMsIHRob3NlIGV2
ZW50cyBhcmUgYWxzbwo+PiBsb2dnZWQgYXMgYXVkaXQgZXZlbnRzLgo+Pgo+PiBXZSB0ZXN0ZWQg
dGhpcyBieSBzdGFydGluZyBhIGNvbnRhaW5lciB3aXRoIHRoZSBjb250YWluZXIgbWFuYWdlcgo+
PiAoY21sZCkgb2YgR3lyb2lkT1Mgd2hpY2ggdXNlcyBhIGRtLXZlcml0eSBwcm90ZWN0ZWQgcm9v
dGZzIGltYWdlCj4+IHJvb3QuaW1nIG1hcHBlZCB0byAvZGV2L21hcHBlci88dXVpZD4tcm9vdC4g
V2UgdGhhbiBtYW5pcHVsYXRlZAo+PiBvbmUgYmxvY2sgaW4gdGhlIHVuZGVybHlpbmcgaW1hZ2Ug
ZmlsZSBhbmQgcmVhZGluZyBpdCBmcm9tIHRoZQo+PiBwcm90ZWN0ZWQgbWFwcGVyIGRldmljZSBh
Z2FpbiBhbmQgYWdhaW4gdW50aWwgd2UgcmVhY2ggdGhlIG1heAo+PiBjb3JydXB0ZWQgZXJyb3Jz
IGxpa2UgdGhpczoKPj4KPj4gICBkZCBpZj0vZGV2L3VyYW5kb20gb2Y9cm9vdC5pbWcgYnM9NTEy
IGNvdW50PTEgc2Vlaz0xMDAwCj4+ICAgZm9yIGkgaW4gcmFuZ2UgezEuLjEwMX07IGRvIFwKPj4g
ICAgIGRkIGlmPS9kZXYvbWFwcGVyLzx1dWlkPi1yb290IG9mPS9kZXYvbnVsbCBicz00MDk2IFwK
Pj4gICAgICAgIGNvdW50PTEgc2tpcD0xMDAwIFwKPj4gICBkb25lCj4+Cj4+IFRoZSByZXN1bHRp
bmcgYXVkaXQgbG9nIGxvb2tzIGFzIGZvbGxvd3M6Cj4+Cj4+ICAgdHlwZT1ETV9DVFJMIG1zZz1h
dWRpdCgxNjc3NjE4NzkxLjg3Njo5NjIpOgo+PiAgICAgbW9kdWxlPXZlcml0eSBvcD1jdHIgcHBp
ZD00ODc2IHBpZD0yOTEwMiBhdWlkPTAgdWlkPTAgZ2lkPTAKPj4gICAgIGV1aWQ9MCBzdWlkPTAg
ZnN1aWQ9MCBlZ2lkPTAgc2dpZD0wIGZzZ2lkPTAgdHR5PShub25lKSBzZXM9NDQKPj4gICAgIGNv
bW09ImNtbGQiIGV4ZT0iL3Vzci9zYmluL2NtbC9jbWxkIiBzdWJqPXVuY29uZmluZWQKPj4gICAg
IGRldj0yNTQ6MyBlcnJvcl9tc2c9J3N1Y2Nlc3MnIHJlcz0xCj4+Cj4+ICAgdHlwZT1ETV9FVkVO
VCBtc2c9YXVkaXQoMTY3NzYxOTQ2My43ODY6MTA3NCk6IG1vZHVsZT12ZXJpdHkKPj4gICAgIG9w
PXZlcmlmeS1kYXRhIGRldj03OjAgc2VjdG9yPTEwMDAgcmVzPTAKPj4gICAuLi4KPj4gICB0eXBl
PURNX0VWRU5UIG1zZz1hdWRpdCgxNjc3NjE5NTk2LjcyNzoxMTYyKTogbW9kdWxlPXZlcml0eQo+
PiAgICAgb3A9dmVyaWZ5LWRhdGEgZGV2PTc6MCBzZWN0b3I9MTAwMCByZXM9MAo+Pgo+PiAgIHR5
cGU9RE1fRVZFTlQgbXNnPWF1ZGl0KDE2Nzc2MTk1OTYuNzMxOjExNjMpOiBtb2R1bGU9dmVyaXR5
Cj4+ICAgICBvcD1tYXgtY29ycnVwdGVkLWVycm9ycyBkZXY9MjU0OjMgc2VjdG9yPT8gcmVzPTAK
Pj4KPj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBXZWnDnyA8bWljaGFlbC53ZWlzc0BhaXNlYy5m
cmF1bmhvZmVyLmRlPgo+PiAtLS0KPj4gIGRyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jIHwg
MjAgKysrKysrKysrKysrKysrKysrLS0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IFRoaXMgbG9va3MgcmVhc29uYWJsZSB0byBtZSBmcm9t
IGFuIGF1ZGl0IHBlcnNwZWN0aXZlLgo+IAo+IEFja2VkLWJ5OiBQYXVsIE1vb3JlIDxwYXVsQHBh
dWwtbW9vcmUuY29tPgoKSGkgTWlrZSwgc2luY2UgUGF1bCBhbHJlYWR5IGdhdmUgaGlzIGFjayBm
cm9tIGF1ZGl0IHBlcnNwZWN0aXZlLApkbyB5b3UgcGljayB0aGlzIHVwPyBPciBpcyB0aGVyZSBh
bnl0aGluZyB3aGljaCBJIGNhbiBpbXByb3ZlIGZyb20gZGV2aWNlCm1hcHBlciBzaWRlPwoKVGhh
bngsCk1pY2hhZWwKCj4gCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJn
ZXQuYyBiL2RyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jCj4+IGluZGV4IGFkZTgzZWYzYjQz
OS4uOGJlZWI0ZWE2NmQxIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJn
ZXQuYwo+PiArKysgYi9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYwo+PiBAQCAtMTYsNiAr
MTYsNyBAQAo+PiAgI2luY2x1ZGUgImRtLXZlcml0eS5oIgo+PiAgI2luY2x1ZGUgImRtLXZlcml0
eS1mZWMuaCIKPj4gICNpbmNsdWRlICJkbS12ZXJpdHktdmVyaWZ5LXNpZy5oIgo+PiArI2luY2x1
ZGUgImRtLWF1ZGl0LmgiCj4+ICAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Cj4+ICAjaW5jbHVk
ZSA8bGludXgvcmVib290Lmg+Cj4+ICAjaW5jbHVkZSA8bGludXgvc2NhdHRlcmxpc3QuaD4KPj4g
QEAgLTI0OCw4ICsyNDksMTAgQEAgc3RhdGljIGludCB2ZXJpdHlfaGFuZGxlX2VycihzdHJ1Y3Qg
ZG1fdmVyaXR5ICp2LCBlbnVtIHZlcml0eV9ibG9ja190eXBlIHR5cGUsCj4+ICAgICAgICAgRE1F
UlJfTElNSVQoIiVzOiAlcyBibG9jayAlbGx1IGlzIGNvcnJ1cHRlZCIsIHYtPmRhdGFfZGV2LT5u
YW1lLAo+PiAgICAgICAgICAgICAgICAgICAgIHR5cGVfc3RyLCBibG9jayk7Cj4+Cj4+IC0gICAg
ICAgaWYgKHYtPmNvcnJ1cHRlZF9lcnJzID09IERNX1ZFUklUWV9NQVhfQ09SUlVQVEVEX0VSUlMp
Cj4+ICsgICAgICAgaWYgKHYtPmNvcnJ1cHRlZF9lcnJzID09IERNX1ZFUklUWV9NQVhfQ09SUlVQ
VEVEX0VSUlMpIHsKPj4gICAgICAgICAgICAgICAgIERNRVJSKCIlczogcmVhY2hlZCBtYXhpbXVt
IGVycm9ycyIsIHYtPmRhdGFfZGV2LT5uYW1lKTsKPj4gKyAgICAgICAgICAgICAgIGRtX2F1ZGl0
X2xvZ190YXJnZXQoRE1fTVNHX1BSRUZJWCwgIm1heC1jb3JydXB0ZWQtZXJyb3JzIiwgdi0+dGks
IDApOwo+PiArICAgICAgIH0KPj4KPj4gICAgICAgICBzbnByaW50Zih2ZXJpdHlfZW52LCBETV9W
RVJJVFlfRU5WX0xFTkdUSCwgIiVzPSVkLCVsbHUiLAo+PiAgICAgICAgICAgICAgICAgRE1fVkVS
SVRZX0VOVl9WQVJfTkFNRSwgdHlwZSwgYmxvY2spOwo+PiBAQCAtMzQwLDYgKzM0MywxMSBAQCBz
dGF0aWMgaW50IHZlcml0eV92ZXJpZnlfbGV2ZWwoc3RydWN0IGRtX3Zlcml0eSAqdiwgc3RydWN0
IGRtX3Zlcml0eV9pbyAqaW8sCj4+ICAgICAgICAgICAgICAgICBlbHNlIGlmICh2ZXJpdHlfaGFu
ZGxlX2Vycih2LAo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
RE1fVkVSSVRZX0JMT0NLX1RZUEVfTUVUQURBVEEsCj4+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBoYXNoX2Jsb2NrKSkgewo+PiArICAgICAgICAgICAgICAgICAg
ICAgICBzdHJ1Y3QgYmlvICpiaW8gPQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGRtX2Jpb19mcm9tX3Blcl9iaW9fZGF0YShpbywKPj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdi0+dGktPnBlcl9pb19kYXRhX3NpemUp
Owo+PiArICAgICAgICAgICAgICAgICAgICAgICBkbV9hdWRpdF9sb2dfYmlvKERNX01TR19QUkVG
SVgsICJ2ZXJpZnktbWV0YWRhdGEiLCBiaW8sCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgYmxvY2ssIDApOwo+PiAgICAgICAgICAgICAgICAgICAgICAgICByID0g
LUVJTzsKPj4gICAgICAgICAgICAgICAgICAgICAgICAgZ290byByZWxlYXNlX3JldF9yOwo+PiAg
ICAgICAgICAgICAgICAgfQo+PiBAQCAtNTkwLDggKzU5OCwxMSBAQCBzdGF0aWMgaW50IHZlcml0
eV92ZXJpZnlfaW8oc3RydWN0IGRtX3Zlcml0eV9pbyAqaW8pCj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIC1FSU87Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgIH0K
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHZlcml0eV9oYW5kbGVfZXJyKHYsIERNX1ZF
UklUWV9CTE9DS19UWVBFX0RBVEEsCj4+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBjdXJfYmxvY2spKQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY3VyX2Jsb2NrKSkgewo+PiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGRtX2F1ZGl0X2xvZ19iaW8oRE1fTVNHX1BSRUZJWCwgInZlcmlmeS1kYXRhIiwK
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJpbywg
Y3VyX2Jsb2NrLCAwKTsKPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4g
LUVJTzsKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgfQo+PiAgICAgICAgICAgICAgICAgfQo+
PiAgICAgICAgIH0KPj4KPj4gQEAgLTk3NSw2ICs5ODYsOCBAQCBzdGF0aWMgdm9pZCB2ZXJpdHlf
ZHRyKHN0cnVjdCBkbV90YXJnZXQgKnRpKQo+PiAgICAgICAgICAgICAgICAgc3RhdGljX2JyYW5j
aF9kZWMoJnVzZV90YXNrbGV0X2VuYWJsZWQpOwo+Pgo+PiAgICAgICAgIGtmcmVlKHYpOwo+PiAr
Cj4+ICsgICAgICAgZG1fYXVkaXRfbG9nX2R0cihETV9NU0dfUFJFRklYLCB0aSwgMSk7Cj4+ICB9
Cj4+Cj4+ICBzdGF0aWMgaW50IHZlcml0eV9hbGxvY19tb3N0X29uY2Uoc3RydWN0IGRtX3Zlcml0
eSAqdikKPj4gQEAgLTE0MjksMTEgKzE0NDIsMTQgQEAgc3RhdGljIGludCB2ZXJpdHlfY3RyKHN0
cnVjdCBkbV90YXJnZXQgKnRpLCB1bnNpZ25lZCBpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4+Cj4+
ICAgICAgICAgdmVyaXR5X3ZlcmlmeV9zaWdfb3B0c19jbGVhbnVwKCZ2ZXJpZnlfYXJncyk7Cj4+
Cj4+ICsgICAgICAgZG1fYXVkaXRfbG9nX2N0cihETV9NU0dfUFJFRklYLCB0aSwgMSk7Cj4+ICsK
Pj4gICAgICAgICByZXR1cm4gMDsKPj4KPj4gIGJhZDoKPj4KPj4gICAgICAgICB2ZXJpdHlfdmVy
aWZ5X3NpZ19vcHRzX2NsZWFudXAoJnZlcmlmeV9hcmdzKTsKPj4gKyAgICAgICBkbV9hdWRpdF9s
b2dfY3RyKERNX01TR19QUkVGSVgsIHRpLCAwKTsKPj4gICAgICAgICB2ZXJpdHlfZHRyKHRpKTsK
Pj4KPj4gICAgICAgICByZXR1cm4gcjsKPj4gLS0KPj4gMi4zMC4yCj4gCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

