Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA314C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 05:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-Us35hHutMv2SQip_4AABbA-1; Thu, 21 Apr 2022 01:51:49 -0400
X-MC-Unique: Us35hHutMv2SQip_4AABbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B90443811F32;
	Thu, 21 Apr 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AD268145;
	Thu, 21 Apr 2022 05:51:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 141E21940355;
	Thu, 21 Apr 2022 05:51:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 206541949763
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Apr 2022 04:07:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E33AF145BEE2; Thu, 21 Apr 2022 04:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE6A6145BEE1
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 04:07:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF677811E7A
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 04:07:32 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-dtNJrCdvONuXGaSPBO4IIA-1; Thu, 21 Apr 2022 00:07:30 -0400
X-MC-Unique: dtNJrCdvONuXGaSPBO4IIA-1
X-IronPort-AV: E=Sophos;i="5.90,277,1643644800"; d="scan'208";a="310402285"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
 by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2022 12:06:23 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6882.namprd04.prod.outlook.com (2603:10b6:a03:21b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Thu, 21 Apr
 2022 04:06:23 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2839:2ab4:7871:416e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2839:2ab4:7871:416e%8]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 04:06:22 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Mike Snitzer <snitzer@kernel.org>
Thread-Topic: [dm-devel] [dm-5.19 PATCH 21/21] dm: improve abnormal bio
 processing
Thread-Index: AQHYVTUouywRdzXcRE6qCxCXV+LQEw==
Date: Thu, 21 Apr 2022 04:06:22 +0000
Message-ID: <20220421040620.zbocicrqa76n4zqm@shindev>
References: <20220418022733.56168-1-snitzer@kernel.org>
 <20220418022733.56168-22-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-22-snitzer@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38d1fa43-293c-4783-ab5a-08da234c4c20
x-ms-traffictypediagnostic: BY5PR04MB6882:EE_
x-microsoft-antispam-prvs: <BY5PR04MB6882F3D78811D10BADFDAAD3EDF49@BY5PR04MB6882.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CImjnbaUOL4VIauUwF3BIBZPTWARDnnTHpJQQ8wM5Eapdl0dB+j5dXweq8Fi0rKpIkemQF5kRX3NlItLsA0pHzaf/VqcsZthsUzs5c8aVw1aqTYMDfz/pW3KEpkbIrsJCmSEJORkDeyg00PIQ53yV0cPcbQa7lGtjw4hbUt9lhVHjGUNTcdS/A2xu9qhPaO1+nJW3MYaI226d4ZAXuN9tci555iNs8GMfNh4RbKMECkNvM0mbvX1dyJrwBCjJk1VQgCBPVmaAHRhePA/ba2eUrVOaEkNuS+PWleFJHHiGR1AUuM2iiflTh3/LKEUvCkJgI4mhPMjjcX8tQZqut1K55LgtnBxtBXInkuYLSXwxlVACCe5YIWuB5GJjuW8Ilzqc5fSD4+R8IB283dir0iSMXa76iGpwBnq3GiEWUTvNtKLvUmpJzKl1U4EU67Zn/alfDYTD0j7blmEPOrfeho3uK7O/17hOoP6bpfrrYmMNYOqcBveax0+0mHHOhmZW11ZOkIkHgWC1foI38vZR/kLTjtNtqffXe7N8pXvEjjrHpvsYo8QwP3tiFdSg/eo3r8JoOLmlsOli+Dzh4sxoqbvKGsY8YBgd0Q7lrwHtK4+Z3DqgHN04tl1FG0cQ5ZMBBDLWqfWkCsCBMEHNBa5485PgcwclXDtHHAUhbYzG1LEHkkbY4MPd9+CdIxNWL4v1ArhHyirKP+KzITk7L+/uPGlfpGdftLD/ccoTjw9ZATroMoab5kREmlOIlyqZUBj6OnNRR/6Z6msGfDekhkOWNFlbStj8mxxrCiY+bS/w+K+UZo=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(7916004)(366004)(186003)(76116006)(2906002)(33716001)(8676002)(6916009)(54906003)(26005)(38070700005)(8936002)(4326008)(66476007)(66556008)(66446008)(66946007)(83380400001)(91956017)(64756008)(122000001)(508600001)(45080400002)(6506007)(5660300002)(82960400001)(38100700002)(86362001)(6486002)(966005)(44832011)(1076003)(6512007)(9686003)(316002)(71200400001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZtJtJDnNo2UwoNAimMKi54WDJIRq4O28JRCTG+SWBze+nZIcfiqwtfdtwKqd?=
 =?us-ascii?Q?3IPMwlDSi3VVtbiHNFgyT4lMttWp6Q6PCz8ftys+rBHtzF354C5Qo/ANW55v?=
 =?us-ascii?Q?W1tsJCuQaNyVnb8AWB6zMPUsiGG2YXZnQF4QFp6U7XllNrad9qlfkKbDUBRj?=
 =?us-ascii?Q?W4Ri3YP2tfZTwrUynyKrcEJIQGG5t2Q+K0pOAR3pRuBBGzyKTwYcun35BXJ1?=
 =?us-ascii?Q?hEUmcCusszvprR4HAdztNgpFxtG6wW7XCuJlZTt4X/mHmDe/Z/Q8boNO6YKc?=
 =?us-ascii?Q?IjWBtigj2oYeX46vxAwL13Q5HiAukPFXyPLFMKlHJntRy4X6BLKQTS9MicPs?=
 =?us-ascii?Q?2Uvc0vAYyx2Iqfc9XRrHLfIrBUIcA2lK1dp+T0gW4MmwWmY+H6lD6FqSe1te?=
 =?us-ascii?Q?NWzwQfy3p6cjbSaRZypllla+gvqgSTYzOvCvjVe5RL+6Hhl1y6rbpzM+TgC4?=
 =?us-ascii?Q?zOZmNpHL1ARjf47AYkiPYvGtdC/5e1aZhuxxvij9EfNcQ6ICNY8Ycx1eofi2?=
 =?us-ascii?Q?dtxlPy1Bu1ObOlrNHsGJ/jLvOiKMlWZsSMSDh+aCbNMoKdnVAJxsQOxob2gp?=
 =?us-ascii?Q?pL3OpXf5etvPuhZfXU31+E2LIys+QF50M8u0N/fqXOWztvRF8fygcIqZsZDi?=
 =?us-ascii?Q?UjvjCzJ0vfn6Kc8cgjnswLhYsci8ri0ulxoOszyQyy1XTqjIXK52dSlgJynh?=
 =?us-ascii?Q?Ov77sH5VCecmHimKmR5Ob6iEUGcuWDAPvfZ5twTEGBV29Ayrn+ot415RvACs?=
 =?us-ascii?Q?UNXaooCWHiDtRLrs3+DsZZ5rwNQ48mWQtCCS3PtySChc0bfT0blSTyqJynmr?=
 =?us-ascii?Q?XDhJbc0XmLHdyV+XKCPWkHhv6zi0ge/E4SP+OApwe5KDsLbnK62JgCx/8dsP?=
 =?us-ascii?Q?vMLI5nv7QILEjy53OluO07YHBzBWscegK0PVNcQTA87NIzMHn32Veauzkuvl?=
 =?us-ascii?Q?rfgLuwMIs6OOf6Q90FGChK3fZ5DXHXEIo2r4PwmFyToDEnXvLtCUnp9kV9mr?=
 =?us-ascii?Q?GiC/Cwe2T1BjL7lHfV++jPmw8Wqjf6uHNfp/fuUodapyspJL2VLBmsPn6NZe?=
 =?us-ascii?Q?7Pmpvmc5zHVKKbNj5kv0O7zc+LcTs5KX9CaoEOs566TCCVJvYpYJoNeJucKd?=
 =?us-ascii?Q?eIkNpEBefAR/W3JFPSXWerfakVJuddbJjUd+RFz3b9IjixmkhwX6zX3FMFLB?=
 =?us-ascii?Q?LYvNJIc/ktRxC+fP06Z2tWKrYqgZkJUnTSEiHNnPPVHjm7l8Aa7FSvOtDfil?=
 =?us-ascii?Q?Schs/bcjO2qfDSfwxoHTn0TPP/hBHZDzIwF46Ef6Hbzaa/uEZWd9g5ufLiyX?=
 =?us-ascii?Q?kCvooDhyYUGNwdu9USh7ehxkb4CjK18kUCM1mKUHiMUILyJiz0aQVBAN061D?=
 =?us-ascii?Q?L0m2FY4v55yyMmhrzyAdfkW57QutHq9K9NiiJFwnm9pdhGf2REmhlThoKxIV?=
 =?us-ascii?Q?FCyIcM4zLrpNKhHY8/EnLT50M+4x+u0giz5RaQdym2EjNS71M+0GamT3eTBj?=
 =?us-ascii?Q?fgfGRqr5Z2TZhPIHDIl0BgiAOPIR2IPKF8mhW3qo8zPSrVZ+OyOL7PQiOrSG?=
 =?us-ascii?Q?CCR9wYSYEbM7Uep+4pc1TWdFhdBSNqjmrakw7QvHwIrSkbGtY4o3ksUlEgEt?=
 =?us-ascii?Q?y3eHvfKeQtOlhTxWD3/rVoJ4EGwitdCcHL89ZlWQniACllE+Ym+MeiPps4qm?=
 =?us-ascii?Q?RtXOIlYy5p3i7VRgqmISwyLaCeJA8tVUwcp7wBaul29Ok8MHW+NrRIDpd00o?=
 =?us-ascii?Q?5VRo9JGsEtOI9cZsghwy1SXXQAaf9DS7Fnf9LjtGkWjGGshCaM1O?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d1fa43-293c-4783-ab5a-08da234c4c20
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 04:06:22.6948 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvLw7pE5bULdxtv1mDI8iS+Lr6gEZtlkXdwN5ek8pjeQxdnFduSKxzdToHNiYO7JS5UUUDQTIPorQCG9jvMhi+jpwbIPaAVustUAMpDmaqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6882
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 21 Apr 2022 05:51:43 +0000
Subject: Re: [dm-devel] [dm-5.19 PATCH 21/21] dm: improve abnormal bio
 processing
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
 "ming.lei@redhat.com" <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2547DCBBEE7D8F4F9BEFF4B77CD88095@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Apr 17, 2022 / 22:27, Mike Snitzer wrote:
> Read/write/flush are the most common operations, optimize switch in
> is_abnormal_io() for those cases. Follows same pattern established in
> block perf-wip commit ("block: optimise blk_may_split for normal rw")
> 
> Also, push is_abnormal_io() check and blk_queue_split() down from
> dm_submit_bio() to dm_split_and_process_bio() and set new
> 'is_abnormal_io' flag in clone_info. Optimize __split_and_process_bio
> and __process_abnormal_io by leveraging ci.is_abnormal_io flag.
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm.c | 60 +++++++++++++++++++++++++++++----------------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3b87d151ef88..b9c30dfe0f2a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -84,7 +84,8 @@ struct clone_info {
>  	struct dm_io *io;
>  	sector_t sector;

(snip)

>  	ci->sector = bio->bi_iter.bi_sector;
>  	ci->sector_count = bio_sectors(bio);
> @@ -1645,6 +1647,13 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  		__send_empty_flush(&ci);
>  		/* dm_io_complete submits any data associated with flush */
>  		goto out;
> +	} else if (unlikely(is_abnormal_io(bio))) {
> +		/*
> +		 * Use blk_queue_split() for abnormal IO (e.g. discard, etc)
> +		 * otherwise associated queue_limits won't be imposed.
> +		 */
> +		blk_queue_split(&bio);
> +		ci.is_abnormal_io = true;
>  	}
>  
>  	error = __split_and_process_bio(&ci);

Hi Mike,

The hunk above triggered a WARNING [1] which is observed at mkfs.xfs for dm-
zoned devices. With the hunk, the blk_queue_split(&bio) for abnormal I/O is
called after init_clone_info(). I think it made the cloned bio different from
the split bio. I suggest to move the "if (unlikely(is_abnormal_io(bio)))" block
at the beginning of dm_split_and_process_bio(), so that blk_queue_split() is
called before init_clone_info(). I created a patch for such change [2], and
confirmed the WARNING goes away.

> @@ -1698,13 +1707,6 @@ static void dm_submit_bio(struct bio *bio)
>  		goto out;
>  	}
>  
> -	/*
> -	 * Use blk_queue_split() for abnormal IO (e.g. discard, writesame, etc)
> -	 * otherwise associated queue_limits won't be imposed.
> -	 */
> -	if (unlikely(is_abnormal_io(bio)))
> -		blk_queue_split(&bio);
> -
>  	dm_split_and_process_bio(md, map, bio);
>  out:
>  	dm_put_live_table_bio(md, srcu_idx, bio);
> -- 
> 2.15.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

[1]

WARNING: CPU: 3 PID: 79434 at block/bio.c:1629 bio_trim+0x10a/0x150
Modules linked in: dm_zoned null_blk f2fs crc32_generic dm_flakey iscsi_target_mod tcm_loop target_core_pscsi target_core_file target_core_iblock xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp nf_conntrack_tftp bridge stp llc nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_raw rfkill iptable_security ip_set target_core_user nfnetlink target_core_mod ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter qrtr sunrpc intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel at24 iTCO_wdt intel_pmc_bxt iTCO_vendor_support btrfs kvm irqbypass rapl raid6_pq intel_cstate zstd_compress joydev
 intel_uncore i2c_i801 pcspkr i2c_smbus intel_pch_thermal lpc_ich ses enclosure ie31200_edac video zram ip_tables crct10dif_pclmul crc32_pclmul crc32c_intel ast ghash_clmulni_intel drm_vram_helper drm_kms_helper drm_ttm_helper ttm igb drm mpt3sas e1000e dca i2c_algo_bit raid_class scsi_transport_sas fuse [last unloaded: zonefs]
CPU: 3 PID: 79434 Comm: mkfs.xfs Kdump: loaded Not tainted 5.18.0-rc3+ #2
Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 3.0 04/24/2015
RIP: 0010:bio_trim+0x10a/0x150
Code: 8d 7c 24 68 48 89 fa 48 c1 ea 03 80 3c 02 00 75 58 49 83 7c 24 68 00 74 13 48 83 c4 10 4c 89 e7 5d 41 5c 41 5d e9 f6 aa 0f 00 <0f> 0b 48 83 c4 10 5d 41 5c 41 5d c3 4c 89 ef 48 89 54 24 08 48 89
RSP: 0018:ffff8881977d7928 EFLAGS: 00010206
RAX: 0000000008000000 RBX: ffff88852b000000 RCX: 0000000000040000
RDX: 00000000003c0000 RSI: 0000000000040000 RDI: ffff8883215a3d00
RBP: 0000000000400000 R08: 0000000000000001 R09: ffff8881124b9057
R10: ffffed102249720a R11: 0000000000000001 R12: ffff8883215a3d00
R13: ffff8883215a3d28 R14: ffff8881124b9098 R15: ffff8881124b9054
FS:  00007ff3a993dbc0(0000) GS:ffff8886ecf80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a1bf241900 CR3: 0000000177074002 CR4: 00000000001706e0
Call Trace:
 <TASK>
 dm_submit_bio+0x5fa/0x13b0
 ? dm_dax_direct_access+0x1c0/0x1c0
 ? lock_release+0x3a7/0x6c0
 ? lock_downgrade+0x6a0/0x6a0
 __submit_bio+0x1c2/0x2c0
 ? __bio_queue_enter+0x570/0x570
 submit_bio_noacct_nocheck+0x2f7/0x810
 ? should_fail_request+0x70/0x70
 ? rcu_read_lock_sched_held+0x3f/0x70
 ? __lock_acquire+0x1591/0x5030
 submit_bio+0x10a/0x270
 ? submit_bio_noacct+0x15c0/0x15c0
 submit_bio_wait+0xf2/0x1d0
 ? submit_bio_wait_endio+0x40/0x40
 ? lock_release+0x6c0/0x6c0
 blkdev_issue_discard+0xb5/0x110
 ? __blkdev_issue_discard+0x590/0x590
 ? truncate_bdev_range+0x15d/0x240
 blkdev_common_ioctl+0x853/0x1670
 ? blkdev_bszset+0x160/0x160
 ? __ia32_sys_readlinkat+0x87/0xf0
 ? __ia32_compat_sys_newlstat+0x70/0x70
 ? count_memcg_events.constprop.0+0x44/0x50
 blkdev_ioctl+0x23b/0x690
 ? blkdev_common_ioctl+0x1670/0x1670
 ? security_file_ioctl+0x50/0x90
 __x64_sys_ioctl+0x127/0x190
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff3a970731b
Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 2a 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd79c8db68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000e8000000 RCX: 00007ff3a970731b
RDX: 00007ffd79c8db80 RSI: 0000000000001277 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000000 R09: 00007ffd79c8d997
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd79c8db80
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000080000000
 </TASK>
irq event stamp: 10213
hardirqs last  enabled at (10223): [<ffffffffaa36e02e>] __up_console_sem+0x5e/0x70
hardirqs last disabled at (10232): [<ffffffffaa36e013>] __up_console_sem+0x43/0x70
softirqs last  enabled at (10190): [<ffffffffaa1faf06>] __irq_exit_rcu+0x1c6/0x260
softirqs last disabled at (10185): [<ffffffffaa1faf06>] __irq_exit_rcu+0x1c6/0x260
---[ end trace 0000000000000000 ]---

[2]

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7e3b5bdcf520..50382c98d7b3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1639,6 +1639,15 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	struct dm_io *io;
 	blk_status_t error = BLK_STS_OK;
 
+	if (unlikely(is_abnormal_io(bio))) {
+		/*
+		 * Use blk_queue_split() for abnormal IO (e.g. discard, etc)
+		 * otherwise associated queue_limits won't be imposed.
+		 */
+		blk_queue_split(&bio);
+		ci.is_abnormal_io = true;
+	}
+
 	init_clone_info(&ci, md, map, bio);
 	io = ci.io;
 
@@ -1646,13 +1655,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 		__send_empty_flush(&ci);
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
-	} else if (unlikely(is_abnormal_io(bio))) {
-		/*
-		 * Use blk_queue_split() for abnormal IO (e.g. discard, etc)
-		 * otherwise associated queue_limits won't be imposed.
-		 */
-		blk_queue_split(&bio);
-		ci.is_abnormal_io = true;
 	}
 
 	error = __split_and_process_bio(&ci);

-- 
Best Regards,
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

