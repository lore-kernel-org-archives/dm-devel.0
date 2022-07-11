Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173EDC43334
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jul 2022 08:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657613740;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oJKyjlsKzb6XB8RRD+5oJO/ZDhPDVTReALb3BMztsuI=;
	b=Ne2eoG3Bfr+pIqR/ewtuj7b7/1AL2fEpth1Gi+KjGfdtc9+4jkd87AFAsrKryCeSbwDwz1
	7klXIsiN4D5N5wCtwMCm4GNqxZnGtKe178A4ku8mNmHVrLHYnhXafk4bXgZmKvDHjwbzZx
	Yjj6M871YO71TAyYiODbY697DuJZqsY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-Zafqy8dmNe2PIXkv2igW0Q-1; Tue, 12 Jul 2022 04:15:33 -0400
X-MC-Unique: Zafqy8dmNe2PIXkv2igW0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1FEA85A581;
	Tue, 12 Jul 2022 08:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C23AF112131B;
	Tue, 12 Jul 2022 08:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D8141947B89;
	Tue, 12 Jul 2022 08:15:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 889241947055
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Jul 2022 15:10:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F9A1492CA2; Mon, 11 Jul 2022 15:10:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AACB492C3B
 for <dm-devel@redhat.com>; Mon, 11 Jul 2022 15:10:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA1E18812CA
 for <dm-devel@redhat.com>; Mon, 11 Jul 2022 15:10:43 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-k5NXC-cdOrKje934lMvj5g-1; Mon, 11 Jul 2022 11:10:39 -0400
X-MC-Unique: k5NXC-cdOrKje934lMvj5g-1
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="346369561"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; d="scan'208";a="346369561"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Jul 2022 08:09:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; d="scan'208";a="545047351"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
 by orsmga003.jf.intel.com with ESMTP; 11 Jul 2022 08:09:29 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 08:09:29 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 08:09:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 08:09:28 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 08:09:28 -0700
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by CY4PR1101MB2245.namprd11.prod.outlook.com (2603:10b6:910:1f::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Mon, 11 Jul
 2022 15:09:25 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::504a:2f0d:997a:a260]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::504a:2f0d:997a:a260%3]) with mapi id 15.20.5417.015; Mon, 11 Jul 2022
 15:09:25 +0000
Date: Mon, 11 Jul 2022 17:09:07 +0200
From: Lucas Segarra <lucas.segarra.fernandez@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <Ysw9E2Az2oK4jfCf@lucas-Virtual-Machine>
References: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
 <20220410194707.9746-2-giovanni.cabiddu@intel.com>
 <YlRnVBYl1eJ+zvM5@gmail.com> <Yswx1myaFwJR22FQ@silpixa00400314>
In-Reply-To: <Yswx1myaFwJR22FQ@silpixa00400314>
X-ClientProxiedBy: FR0P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::13) To MW5PR11MB5812.namprd11.prod.outlook.com
 (2603:10b6:303:193::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1ff5716-af0a-4a16-c84d-08da634f57e1
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2245:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: j/k1edLFeGSGKi+PdSQLPt5lokGESEiCeoGkwhjXTRkW/KOkS85Oc6LHWCIqs/c23n6v58T1WCdOKSs9h86H72jhOz5IwCXkdXSu5+/lHLPEi1dg7IdXMkCitLrmDNpdE2kOQnPHXMOZJeI6Nwck4PTf7hITG9ovUU5RoUeIiAGN8URFrmAd/6p0cfb/rz/6bM+qYtfeBfbNYjn1gaCoeKoHoukjMb4XuTsBWrAn+vcpLeDM4gaQN8TmsUNtMzylXblgsGPzR5BRIIPP9LZfCwvf6Nym2xubKqnH0tzcAzdP+nnxB1dQP728ZWRHCHs7+QohxojiVbTpKTOMrck+9R4/4XY3iICTgwEqvv+Gb4lDg5sHn4G7jWK7QgeakU1crboABC5QQtAXr6JhKZXCu9GjkW4Wptekhx1bn8fVtIUgKxboxP45urzJ1mk4TizUws1CANTcEuCXnPmGofuKk8o13vWiC7vbd1pCEki2oqbMIFZrBt+jLwmlubONMvcA9WUEkpQquRorGc8Klm0it02XtUWQbHVOoV128rayY2mJouUYM7+fTAnXReQRRvpggF009+KRrlxhsWI1RoQ0k6PcUyovkGf1vYoaz8TD7dMhrRssGIbeChZznAAtaps90PDcsSy3p50rgIJwfw8Aa819/2niVh3OKAlPDOtrhct2UZIjzot9E22XN0W2hcb3mTJeUpZTLKssKhKV0lwNkX1/g6JJXEoTm9ZtQ7c3xXWdGhU0B6CQMsLiBpZ5eKZ9DSqcSG9VOFOoe3gsnBsBQ7htgTZUET9BHaWEGIBqB74=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW5PR11MB5812.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(376002)(346002)(136003)(396003)(366004)(39860400002)(82960400001)(83380400001)(8936002)(186003)(5660300002)(2906002)(66946007)(6512007)(66476007)(66556008)(26005)(54906003)(8676002)(4326008)(6666004)(33716001)(6506007)(9686003)(41300700001)(38100700002)(6486002)(316002)(966005)(86362001)(478600001)(6916009);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1cwY1g0UFpic1hhTnZHYmNOTW8ydGpFelZwSGtMUVFZcXVzMFFiV1pZaVdX?=
 =?utf-8?B?WU04K3RDbkh4eTl3QjFSbjNrRS9kSG05dzJwY2hqYnNhL1dJcDlBd1JPa1FE?=
 =?utf-8?B?NC9kMzBUd2hKd2dpQWZVYVNUU2lzcDRJc1c0MWNKZWpGZEVwcmFhS3huaE9E?=
 =?utf-8?B?U0FMcTdwZDVXOTMrQUxrZ0xUMGVHU1B2MkV1bzY5bmRIWExZMjloRWdMM2Nm?=
 =?utf-8?B?eW1YL1VKQWtkTXIwRHRISGRaSVFrK3c1WjZibVh2S09Cc21hWEFoZjhKWjFF?=
 =?utf-8?B?MTh4K1JDZ0x1S1NzTFhjQnZBSTNFRXI3WmhZY2xnTFF1TG1DWmpJUURTMTFh?=
 =?utf-8?B?Ukh3UnJQa3pNbG1BbVRvc0daTVQzREMvcDQ2NW1ab0VxR1F2RUR1SENxSERX?=
 =?utf-8?B?cmNXbnlTZ0lvM0ZFbUhJcWx0OVVUN1RoT1hBRmxYSDNyb0RXLzUyaTNYZzEw?=
 =?utf-8?B?T3ZpMDdXTXBTaTVnYXFjNjNUVWdZZTBZb1ZQVm1NenZzMFk3QWk5VWdEc255?=
 =?utf-8?B?TWhDbi9UYjlnbVdhSUlLTklBUXdvS3NlMHRlRW85S3VEaTdPUFFFRWE3OTNo?=
 =?utf-8?B?WHVGVjdGTElTRDBZdjMzQnpoVmpQb1hLQmxxSFpBaEZWMGxzczU1ajljWUFy?=
 =?utf-8?B?RW5TSTBsYVZBUnVFTmcrY3JaYnBlREt5dXR5aEhGd1VUaWJZdm5Pb3RkYnhG?=
 =?utf-8?B?Y3BEN28zTDdybUlaT0RvUDY5K1VvQmNuZkZTRnkxbFliNTJYbE5mcEhiNVhZ?=
 =?utf-8?B?bi9oZjNERnlWSmVsbFpRTURZbmZXRHpEcloza0Rvamh4MkgxS09rOG5RbHFZ?=
 =?utf-8?B?Yit4VmhGTHoyMFQ2b3cwdFZNSmdVRUpuYkgvZ0ZVeHE5V1AvQ21zVnlaSjVp?=
 =?utf-8?B?cmpFRW5oUGFmU1oxZmhtMk1aT0tBMzBnTDZvVjlqUnpTWXRMK2p1N1dGclVp?=
 =?utf-8?B?R3o4Rm1aNFRXcTZVaXdKK1gvR2hXMUViWko2REpXcHplUWRyZWFJdnpZSkZJ?=
 =?utf-8?B?eTd2SWpQSFpnbTY4ZnhJdld6S2pYSStnNGRabXVOZDduSnhhZUNrK0VSbjlo?=
 =?utf-8?B?REJycDNBa1lrVE5hK3M0YnZNWk5ETWQvVkppcTBaVHA2azJQeC84bmZhUnIy?=
 =?utf-8?B?aXJnT0tzNkZsUm82M3BQR0VWV0diNDQwcHB1V3VycjlyckszMGN5OEcyc3JL?=
 =?utf-8?B?cU11dndiMTA1SjFQY0g0VHlGK0luQ2Q0ZnZQYUFObnBPVXRMVDcybVVPQzBC?=
 =?utf-8?B?cVd0MS9yTW1haHV0cGFCT2twdnIrdUlyL21SUjJ3N3pYdEtBdEt0eEtrbzRz?=
 =?utf-8?B?S0JjMElXUjdjbktzSW1hbkhGMlZIWnhZbVVxRTY4YXlZSTI4OWhpN2l6Q1hW?=
 =?utf-8?B?T0FJSUQwVDdRbW1zWlZCYS84THY5S0pWY0I2K0Z2YzBZSjFraTRLWTBHcisz?=
 =?utf-8?B?cS9YbGM5TUpJZkRqVXhCaUo4djBkd0U5TEhUeVpUTE9iL0tNTnV6azRBZ00v?=
 =?utf-8?B?YWMzbHhsRnpmdEtRVG52ODd0ZFdtM2VUbTFYSGxSSGlyQmxPbnY1Z3ZmNXZZ?=
 =?utf-8?B?WFlsdlFUelZPaTQrTnNhajJTOW12NEtJRlpOOXBUUmlXZlJXM24yUkJNTzNC?=
 =?utf-8?B?ZTV2OGRsM1ZzOXFsSlZabGZZdGFlQ2xSakJZNjhFQkZXTGRlczFRV0R0SVpU?=
 =?utf-8?B?c09YMytNUThWSk1EQ05pTzlZeTBwazNWR2VybVdWMlBQU0tpQjFBYTcxUWQv?=
 =?utf-8?B?VWwvMzI2WlBNMDFaM3JCZkZqSVRtTDJxTExNcis4aVl4SnllcHpyYzVUbG5i?=
 =?utf-8?B?eUNxVHdHcU5veFBTOExvRHBEek1WWkMvY0s4N3ZaT3Qvck85bzM0UDFlMDNn?=
 =?utf-8?B?OUZwVGVHRWJZSmxZT2NTbWNTYVhmbkdmcmZRelQyWTdRTU1EaWJYcURJVEpm?=
 =?utf-8?B?TDVuekg2RnY5dGxlRG1xRTVtZ1FqZ2JneHNJZFlkSEpkdWZHbitHUjVYdEtS?=
 =?utf-8?B?RTN4V3ltMDhrdGpzTDlGdUsrOStITEk3bFpJWFpOMXpHMG5jREFBd2VNR0xs?=
 =?utf-8?B?bFRaM3RPQ1kweE81MFRSUmhFOUZEZDE3SjZ1T3ZSazZWMmZZMGt1S05aeVMr?=
 =?utf-8?B?UFRNOTczemZ4QzRyRnoxNE5DWjBmaGpuZHNWT3B5RmFVeDRiYWo0czcwNXJp?=
 =?utf-8?Q?dCl4MmMHeykmwt/bzUWtBQw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ff5716-af0a-4a16-c84d-08da634f57e1
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 15:09:25.7597 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBl62ZsPIO2PZmf0i4640Y8ksP/y2tn9I2WAvrQNKmBk2K0r88PnsLJD5gY0qwhAXsotqEC28fGicarfjd+MpKdEZB6kZ63eFQFjyAfAEkMRKBbnXkYv5R+FYWEobfOi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2245
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Tue, 12 Jul 2022 08:15:28 +0000
Subject: Re: [dm-devel] [PATCH v3 1/3] crypto: qat - use pre-allocated
 buffers in datapath
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
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Marco Chiappero <marco.chiappero@intel.com>, herbert@gondor.apana.org.au,
 Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, qat-linux@intel.com,
 stable@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org, Wojciech
 Ziemba <wojciech.ziemba@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdWwgMTEsIDIwMjIgYXQgMDM6MjE6MzlQTSArMDEwMCwgR2lvdmFubmkgQ2FiaWRk
dSB3cm90ZToKPiBPbiBNb24sIEFwciAxMSwgMjAyMiBhdCAwNTozNzoyNFBNICswMDAwLCBFcmlj
IEJpZ2dlcnMgd3JvdGU6Cj4gPiBPbiBTdW4sIEFwciAxMCwgMjAyMiBhdCAwODo0NzowNVBNICsw
MTAwLCBHaW92YW5uaSBDYWJpZGR1IHdyb3RlOgo+ID4gPiBJZiByZXF1ZXN0cyBleGNlZWQgNCBl
bnRyaWVzIGJ1ZmZlcnMsIG1lbW9yeSBpcyBhbGxvY2F0ZWQgZHluYW1pY2FsbHkuCj4gPiA+IAo+
ID4gPiBJbiBhZGRpdGlvbiwgcmVtb3ZlIHRoZSBDUllQVE9fQUxHX0FMTE9DQVRFU19NRU1PUlkg
ZmxhZyBmcm9tIGJvdGggYWVhZAo+ID4gPiBhbmQgc2tjaXBoZXIgYWxnIHN0cnVjdHVyZXMuCj4g
PiA+IAo+ID4gCj4gPiBUaGVyZSBpcyBub3RoaW5nIHRoYXQgc2F5cyB0aGF0IGFsZ29yaXRobXMg
Y2FuIGlnbm9yZQo+ID4gIUNSWVBUT19BTEdfQUxMT0NBVEVTX01FTU9SWSBpZiB0aGVyZSBhcmUg
dG9vIG1hbnkgc2NhdHRlcmxpc3QgZW50cmllcy4gIFNlZSB0aGUKPiA+IGNvbW1lbnQgYWJvdmUg
dGhlIGRlZmluaXRpb24gb2YgQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZLgo+ID4gCj4gPiBJ
ZiB5b3UgbmVlZCB0byBpbnRyb2R1Y2UgdGhpcyBjb25zdHJhaW50LCB0aGVuIHlvdSB3aWxsIG5l
ZWQgdG8gYXVkaXQgdGhlIHVzZXJzCj4gPiBvZiAhQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZ
IHRvIHZlcmlmeSB0aGF0IG5vbmUgb2YgdGhlbSBhcmUgaXNzdWluZyByZXF1ZXN0cwo+ID4gdGhh
dCB2aW9sYXRlIHRoaXMgY29uc3RyYWludCwgdGhlbiBhZGQgdGhpcyB0byB0aGUgZG9jdW1lbnRh
dGlvbiBjb21tZW50IGZvcgo+ID4gQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZLgo+IEJlbGF0
ZWRseS4uLgo+IAo+IEFkZGluZyB0byB0aGlzIHRocmVhZCBteSBjb2xsZWFndWUgTHVjYXMgd2hv
IGRpZCBhbiBhdWRpdCBvZiB0aGUgdXNlcnMKPiBvZiAhQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVN
T1JZIHRvIHVuZGVyc3RhbmQgaWYgd2UgY2FuIGFkZCBhIGNvbnN0cmFpbnQKPiB0byB0aGUgZGVm
aW5pdGlvbiBvZiBDUllQVE9fQUxHX0FMTE9DQVRFU19NRU1PUlkuCj4gCj4gUmVnYXJkcywKPiAK
PiAtLSAKPiBHaW92YW5uaQoKQW4gYXVkaXQgd2FzIGRvbmUgb24gdXNlcnMgb2YgIUNSWVBUT19B
TEdfQUxMT0NBVEVTX01FTU9SWTogZG0tY3J5cHQgYW5kIGRtLWludGVncml0eS4gZG0tY3J5cHQg
dXNlcyBzY2F0dGVybGlzdHMgd2l0aCBhdCBtb3N0IDQgZW50cmllcywgYnV0IGRtLWludGVncml0
eSBtYXkgYWxsb2NhdGUgbWVtb3J5IGZvciBzY2F0dGVybGlzdCB3aXRoIGFyY2gtZGVwZW5kZW50
IGFuZCBzeXN0ZW0tYm91bmRlZCBudW1iZXIgb2YgZW50cmllcy4gVGhlcmVmb3JlIHRoZSBjb25z
dHJhaW50IGluIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDIwMDcyMjA3
MjkzMi5HQTI3NTQ0QGdvbmRvci5hcGFuYS5vcmcuYXUvIGNhbm5vdCBiZSBpbnRyb2R1Y2VkLgoK
QSB3YXkgdG8gc29sdmUgdGhlIHByb2JsZW0gbWlnaHQgYmUgdG8gZm9yd2FyZCByZXF1ZXN0cyB3
aXRoIG1vcmUgdGhhbiA0IGVudHJpZXMgaW4gYSBzY2F0dGVybGlzdCB0byBhbiBpbXBsZW1lbnRh
dGlvbiB0aGF0IGRvZXMgbm90IGFsbG9jYXRlIG1lbW9yeS4gVGhpcyB3aWxsIGludHJvZHVjZSBh
bHdheXMgYSBwZXJmb3JtYW5jZSBwZW5hbHR5IGZvciByZXF1ZXN0cyB3aXRoIHNjYXR0ZXJsaXN0
cyBncmVhdGVyIHRoYW4gNCBpbiBhbGdvcml0aG1zIGJhY2tlZCB1cCBieSBIVyBhY2NlbGVyYXRv
cnMsIGV2ZW4gaWYgdGhlIHJlcXVlc3RvciBkb2VzIG5vdCByZXF1aXJlcyB0aGlzIHJlc3RyaWN0
aW9uLiBBIHdheSB0byBzb2x2ZSB0aGlzIG1pZ2h0IGJlIHRvIHJlZ2lzdGVyIHR3byB2ZXJzaW9u
cyBvZiB0aGUgc2FtZSBhbGdvcml0aG0sIG9uZSB3aXRob3V0IENSWVBUT19BTEdfQUxMT0NBVEVT
X01FTU9SWSB0aGF0IGZvcndhcmRzIHRvIFNXIGFuZCBvbmUgd2l0aCBDUllQVE9fQUxHX0FMTE9D
QVRFU19NRU1PUlkgc2V0IHRoYXQgZG9lc27igJl0LiBBbnkgc3VnZ2VzdGlvbnM/CgpBZGRpbmcg
SG9yaWEgR2VhbnTEgyBhbmQgZG0tZGV2ZWwgYmFzZWQgb24gdGhlIHByZXZpb3VzIHRocmVhZC4K
ClRoYW5rcy4KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCkludGVsIFRlY2hub2xvZ3kgUG9sYW5kIHNwLiB6IG8uby4K
dWwuIFNsb3dhY2tpZWdvIDE3MyB8IDgwLTI5OCBHZGFuc2sgfCBTYWQgUmVqb25vd3kgR2RhbnNr
IFBvbG5vYyB8IFZJSSBXeWR6aWFsIEdvc3BvZGFyY3p5IEtyYWpvd2VnbyBSZWplc3RydSBTYWRv
d2VnbyAtIEtSUyAxMDE4ODIgfCBOSVAgOTU3LTA3LTUyLTMxNiB8IEthcGl0YWwgemFrbGFkb3d5
IDIwMC4wMDAgUExOLgpUYSB3aWFkb21vc2Mgd3JheiB6IHphbGFjem5pa2FtaSBqZXN0IHByemV6
bmFjem9uYSBkbGEgb2tyZXNsb25lZ28gYWRyZXNhdGEgaSBtb3plIHphd2llcmFjIGluZm9ybWFj
amUgcG91Zm5lLiBXIHJhemllIHByenlwYWRrb3dlZ28gb3RyenltYW5pYSB0ZWogd2lhZG9tb3Nj
aSwgcHJvc2lteSBvIHBvd2lhZG9taWVuaWUgbmFkYXdjeSBvcmF6IHRyd2FsZSBqZWogdXN1bmll
Y2llOyBqYWtpZWtvbHdpZWsgcHJ6ZWdsYWRhbmllIGx1YiByb3pwb3dzemVjaG5pYW5pZSBqZXN0
IHphYnJvbmlvbmUuClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4g
Y29uZmlkZW50aWFsIG1hdGVyaWFsIGZvciB0aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJl
Y2lwaWVudChzKS4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgcGxlYXNl
IGNvbnRhY3QgdGhlIHNlbmRlciBhbmQgZGVsZXRlIGFsbCBjb3BpZXM7IGFueSByZXZpZXcgb3Ig
ZGlzdHJpYnV0aW9uIGJ5IG90aGVycyBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

