Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0118E26
	for <dm-devel@lists.linux.dev>; Fri, 20 Oct 2023 11:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LoaEw5vv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697801781;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=HICWuS4hDet1tu7ahyT8CBEgMKWQ7vTb5yV4DbD+34Y=;
	b=LoaEw5vvfduD2r1FqVG62qb0us+F9DdLV1G41Xr24GOAXSkr9i+5W+T4gBLuI1Ytb27nsH
	veOU5mt/Lp2ANAfwC7Za6aIegro8ZSyXGAhZ+UUNMbKMJINx7g/rG4yscbc5C6+2ZYzY9h
	5fVF5IhcpwxCSWzfOstoxKeGUhGbWws=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-hp7JscCUMieiN9aJPmd_VQ-1; Fri, 20 Oct 2023 07:36:13 -0400
X-MC-Unique: hp7JscCUMieiN9aJPmd_VQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AC27281295B
	for <dm-devel@lists.linux.dev>; Fri, 20 Oct 2023 11:36:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F876503B
	for <dm-devel@lists.linux.dev>; Fri, 20 Oct 2023 11:36:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB78D1946A70
	for <dm-devel@lists.linux.dev>; Fri, 20 Oct 2023 11:36:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FA091946A5E
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 Oct 2023 11:36:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 46F062026D66; Fri, 20 Oct 2023 11:36:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DCC62026D4C
 for <dm-devel@redhat.com>; Fri, 20 Oct 2023 11:36:12 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13F8C857D04
 for <dm-devel@redhat.com>; Fri, 20 Oct 2023 11:36:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-MhXgYlxNP3GBud1oL8iEsQ-1; Fri, 20 Oct 2023 07:36:10 -0400
X-MC-Unique: MhXgYlxNP3GBud1oL8iEsQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383695229"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; d="scan'208";a="383695229"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 20 Oct 2023 04:35:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="1004583828"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; d="scan'208";a="1004583828"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384;
 20 Oct 2023 04:35:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 04:35:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 04:35:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 04:35:04 -0700
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SN7PR11MB6945.namprd11.prod.outlook.com (2603:10b6:806:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Fri, 20 Oct
 2023 11:35:01 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3%4]) with mapi id 15.20.6886.034; Fri, 20 Oct 2023
 11:34:58 +0000
Date: Fri, 20 Oct 2023 12:34:54 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] qat: fix deadlock in backlog processing
Message-ID: <ZTJl3lgVujG7NCll@gcabiddu-mobl1.ger.corp.intel.com>
References: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com>
 <ZQ2vJNs/7ZzY44z1@gcabiddu-mobl1.ger.corp.intel.com>
 <ed935382-98ee-6f5d-2f-7c6badfd3abb@redhat.com>
 <ZRc75XGd92MgaVko@gcabiddu-mobl1.ger.corp.intel.com>
 <6b5cb6f-e4bb-8328-a718-f21b2575b8@redhat.com>
In-Reply-To: <6b5cb6f-e4bb-8328-a718-f21b2575b8@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0197.eurprd04.prod.outlook.com
 (2603:10a6:10:28d::22) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SN7PR11MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b698bc0-c1d0-4bb4-5b81-08dbd1609729
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: +bmnk3byboCUiEwW6iClPN2q4oTvBKcnCeIxw0EgXwXKsFjH5S/IqyhCvarusRGtPbEUNNIaSAK8I/ne0y6Q9JpCmXp8rAXbrFP3u3smLSa4Nj5Ngg9HHaAiGGGk/1/CduKIFK3fkgJ3OOpq6cMpDpWB/OV8Nfo0Tz1Hy244FZxpS8IqqGsDt97eMdqZAUXl48IQ/Df3mmMsjgtUvEAs4GHAhyXRh+mo61idj10FRluWQmrNl2NSX+UE0dXP5x+x8NfnCPMV8ERVdq7UHrkXC0ULT+6r/2/dYmcikIYLDw5cOEkN5Ut14z22tK0UqZjTAmvba8wZLl0PpbJHg8VimPUf2x4Ew549ELLg9ed2vr7+nnM4UymG14I+GNkg0BgkoXBWR0FKYG+JL2oG9z8KgE2WpUgCQ4d+WuJ+JBcbv/8TqYaORkLDdaL3X3zhDFVUVprx+RxLKB02zBdIho/rjDbcCWhpEb2swiaV+cg22h8pjrIHT4/A8IRedTqJLbxJ8LyNLRgHrXU4ErqAuOXuAqD7X36LRUFXeH/R7pfd9g5ak7yZEMxQimPsomxbxkSn
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CY5PR11MB6366.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(136003)(376002)(39860400002)(396003)(366004)(346002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(83380400001)(26005)(66946007)(6512007)(82960400001)(66556008)(66476007)(54906003)(6916009)(316002)(44832011)(38100700002)(41300700001)(5660300002)(8936002)(478600001)(2906002)(4326008)(8676002)(86362001)(6666004)(6506007)(6486002)(36916002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AeS+KGM3O/uabj1Oav13fbJ+lb402mzQmOkERd+EPA4VtHZk/y0saRE/Id66?=
 =?us-ascii?Q?2Y/FkK51NHJUfOI6hTT+4KL/B5hovTipEolTpDKXXd+qoZThFL6WoNr0urnf?=
 =?us-ascii?Q?Who9LON2yECVARq4Ef4Rne5fR8FfJlTl/yk2+ZPNVghRx1LSmj5jmdO213ED?=
 =?us-ascii?Q?lwKK8QIQeTnsUhZOjok0WGyibWIerf3y0K4EdhJ9tER4LR07RNBnxQPKOxx+?=
 =?us-ascii?Q?lydl10mHkv3uFOKkst+atek+zYmuHFAGm+dA1Opf1DyDZLIA5C2NY4v6iNe6?=
 =?us-ascii?Q?jng2ToddVCvoQFD9n8+kznEjOjzYYv9+9fmLUTxj3gDkjSij4Uk+G0q8XqNC?=
 =?us-ascii?Q?t4CkAtIMXPCe38QKw7QPhy6YXgercd1G1f0Y7zUNzblyUuckYzdPMm0G/+mV?=
 =?us-ascii?Q?xseaxkF9AyNDfD04DjQyiDRPoKOkzIA0tJGRAE0THiyNu28rcfqySjqm63gS?=
 =?us-ascii?Q?SzqLD82NXgwoIp8BLe0g3kEXigdhJ3xP4yagmcOIXcHAAlswGOv97+w4teHX?=
 =?us-ascii?Q?uI8lL+6mASD8nCnbx92Yv2AqUsNO64rbX5y2JJtw/umCiz8WEw56TRtcTLut?=
 =?us-ascii?Q?Y8S/nnhBAXnX7XT/bUrYM41B+B+nErJJl+ygcILNjkAuxcBfU4wAqSZOegc3?=
 =?us-ascii?Q?CFG3GTLfeWxqWbKLb1hrd0vtdBaaa4iFNka8O+xSUbiDejXJnr18H87PSe5+?=
 =?us-ascii?Q?VTW0vaQQU5RNhNe+V3mDTptOdwiVxhAPHYA3XvefHJDzbtuM6aLF7SQTiDwi?=
 =?us-ascii?Q?7lZYtQ9rzMGhsj2iNy0DZUH9qKe0et/AgSqTLTIz1PU/c17fkecA3naTNAfE?=
 =?us-ascii?Q?xrr8Y///bmKZpPfYm3sPjBedzBbtDr2FVgANSLkLTIF1V8/4//2Hi6dXjlwo?=
 =?us-ascii?Q?32WOZOJY4fd0LjiBX75FWw2LBhlt+maIYMTAz7FSJ3lhlEcolN2tA8vVdgLv?=
 =?us-ascii?Q?CF9AjNMqPF3d0kfw4Du8Oe+NNtsu9KNmHPOH2pIcZnVw7/w26ewyueLVutDw?=
 =?us-ascii?Q?mZaJpc2bflcS8QXIzirwDX3hjOY89Ucmvalg1ZNMhjN9fB/nUORohuX0cyjo?=
 =?us-ascii?Q?5HsKR/VWl3dfjf29T3eORH676wXL3w8+UqGRQMHaeEmIh3xYzooIZEg4MWwD?=
 =?us-ascii?Q?bJa1uGkWWp3gH0nnYf9hlTj8591AHRQTwxLNVdfUXLarWyo8j6ipA/GOE05S?=
 =?us-ascii?Q?jyyXNnzrEGVQrTphTxrMGTz1rOEAkJSSAIFOYTD+XwZrQaHyJ2HQk0WWopu7?=
 =?us-ascii?Q?dPlJII6YjJd6TtQoRxUyiOmjJ0/TGsWNXotS7mGBUdUmM8kUp0yusSn/znYQ?=
 =?us-ascii?Q?ldm517UARKDjF2MjcUeo3n5xLhpDlWN41/KC16FZrny2dqnK0f5Fhc+dDWeJ?=
 =?us-ascii?Q?D2DNf0RMLHBB8C3AjQV29oaVnhp/DqVEVLsoNLFQ5Ao7Qkyu3msxtMWcTAr1?=
 =?us-ascii?Q?SFPPBSv91P8oqZdI/Vr/RBYOAh4V47PNsFPG7tbfHM4hpJeI6PhAEQy4OFtf?=
 =?us-ascii?Q?WiZuQRM+a0KS0N/bOsTN2w370ofWy6p2BbzVizUBoO76pDd4bkRb9ZCa74O+?=
 =?us-ascii?Q?KpvD3DyfjJ2L/Yg9iph1DDWOBZAETmCVfULKNfLi0t09pnbvFVquDnYJfz5w?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b698bc0-c1d0-4bb4-5b81-08dbd1609729
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 11:34:58.8877 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PboI6xoI2cVdBLdEtQISZKTvtNU6BLzkyL1Aw38HHKJMkqzgtml8ApHirKEwladOQe3KRFSHf2fGOZkU8EwuZZSCmF8PKUzg9yZ9vxYCRkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6945
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Michael Hrivnak <mhrivnak@redhat.com>, qat-linux@intel.com,
 dm-devel@redhat.com, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Garver <egarver@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Oct 02, 2023 at 11:15:05AM +0200, Mikulas Patocka wrote:
> 
> 
> On Fri, 29 Sep 2023, Giovanni Cabiddu wrote:
> 
> > On Fri, Sep 22, 2023 at 06:34:16PM +0200, Mikulas Patocka wrote:
> > >
> > > > Also, deserves a fixes tag.
> > > 
> > > "Fixes" tag is for something that worked and that was broken in some 
> > > previous commit.
> > That's right.
> > 
> > > A quick search through git shows that QAT backlogging was 
> > > broken since the introduction of QAT.
> > The driver was moved from drivers/crypto/qat to drivers/crypto/intel/qat
> > that's why you see a single patch.
> > This fixes 386823839732 ("crypto: qat - add backlog mechanism")
> 
> But before 386823839732 it also didn't work - it returned -EBUSY without 
> queuing the request and deadlocked.
> 
> > Thanks - when I proposed the rework I was thinking at a solution without
> > gotos. Here is a draft:
> 
> Yes - it is possible to fix it this way.
> 
> 
> 
> > ------------8<----------------
> >  .../intel/qat/qat_common/qat_algs_send.c      | 40 ++++++++++---------
> >  1 file changed, 22 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > index bb80455b3e81..18c6a233ab96 100644
> > --- a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > +++ b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > @@ -40,17 +40,7 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
> >  	spin_unlock_bh(&backlog->lock);
> >  }
> >  
> > -static void qat_alg_backlog_req(struct qat_alg_req *req,
> > -				struct qat_instance_backlog *backlog)
> > -{
> > -	INIT_LIST_HEAD(&req->list);
> > -
> > -	spin_lock_bh(&backlog->lock);
> > -	list_add_tail(&req->list, &backlog->list);
> > -	spin_unlock_bh(&backlog->lock);
> > -}
> > -
> > -static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> > +static bool qat_alg_try_enqueue(struct qat_alg_req *req)
> >  {
> >  	struct qat_instance_backlog *backlog = req->backlog;
> >  	struct adf_etr_ring_data *tx_ring = req->tx_ring;
> > @@ -58,22 +48,36 @@ static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> >  
> >  	/* If any request is already backlogged, then add to backlog list */
> >  	if (!list_empty(&backlog->list))
> > -		goto enqueue;
> > +		return false;
> >  
> >  	/* If ring is nearly full, then add to backlog list */
> >  	if (adf_ring_nearly_full(tx_ring))
> > -		goto enqueue;
> > +		return false;
> >  
> >  	/* If adding request to HW ring fails, then add to backlog list */
> >  	if (adf_send_message(tx_ring, fw_req))
> > -		goto enqueue;
> > +		return false;
> >  
> > -	return -EINPROGRESS;
> > +	return true;
> > +}
> >  
> > -enqueue:
> > -	qat_alg_backlog_req(req, backlog);
> >  
> > -	return -EBUSY;
> > +static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> > +{
> > +	struct qat_instance_backlog *backlog = req->backlog;
> > +	int ret = -EINPROGRESS;
> > +
> > +	if (qat_alg_try_enqueue(req))
> > +		return ret;
> > +
> > +	spin_lock_bh(&backlog->lock);
> > +	if (!qat_alg_try_enqueue(req)) {
> > +		list_add_tail(&req->list, &backlog->list);
> > +		ret = -EBUSY;
> > +	}
> > +	spin_unlock_bh(&backlog->lock);
> > +
> > +	return ret;
> >  }
> >  
> >  int qat_alg_send_message(struct qat_alg_req *req)
> > -- 
> > 2.41.0
> 
> 
> Reviwed-by: Mikulas Patocka <mpatocka@redhat.com>
Thanks. I'm going to resend it with a slight change on the comments in
the function qat_alg_try_enqueue().

Regards,

-- 
Giovanni

