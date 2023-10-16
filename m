Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEEA12B69
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SzH91nb0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524438;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=6bw4UalwD6RTLFekVHi/CP+1fpgIfdUhpzj+EU1oO1Y=;
	b=SzH91nb0fpkAtG5u0AwJRSKW6bw6TZn8ezd1DHW8XYxaBr2rZvUmjI+nWr1Q30lbPVY3M3
	KSPkOnZFwVZGpzuY97Anb2maASnDT+4VyFEDl0WAH2lChtnRjMNlh7swr8ga7Dm2qXQ7zT
	KaTWpq4t1r4c4a0neLGcxEwfRuApUPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-00EbuxAlPK21Fl_2SPuG0w-1; Tue, 17 Oct 2023 02:33:57 -0400
X-MC-Unique: 00EbuxAlPK21Fl_2SPuG0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3FF31023111
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:33:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA3C820296DB
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:33:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C59119466EE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:33:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EAD011946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Oct 2023 17:55:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAC7C1C060B0; Mon, 16 Oct 2023 17:55:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C30E01C060AE
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 17:55:04 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CE498E8C61
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 17:55:04 +0000 (UTC)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com
 [209.85.128.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-_vHaSCigOC28hasVCZ695g-1; Mon, 16 Oct 2023 13:55:02 -0400
X-MC-Unique: _vHaSCigOC28hasVCZ695g-1
Received: by mail-yw1-f172.google.com with SMTP id
 00721157ae682-5a7eef0b931so59747217b3.0
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 10:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1697478902; x=1698083702;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6bw4UalwD6RTLFekVHi/CP+1fpgIfdUhpzj+EU1oO1Y=;
 b=iCYTxOWY8DgDUFr5kEBPdo0ur7dSHRZXV/k2eTC6fif5SrNc4qgv4N2dL9r830+FTZ
 SxmoQ8o0ex3BEfF4c7fVrCneQ7MERlfR7eCr2zSvOwpEsGMYTkDfMLN/KiK2CYl/aJHY
 ZoH3at4yEwqgqcRfmUdMhJbwQ2YlINj9X+IcnK8QDv8AhNsySCneRmVRFCKR68ubMnvN
 IOtNPo2sgkX3Kbx9K+HhXpFYG1rJICDFLsmwLxj+O0l2eV37nPSD8Nd1T9PLop9gMs/U
 lEM/1qr4rZJWui3V8pW+L1LzRe7C42f7KSXuowoKGmKpquLyTdTGLK1Xa5BsDUhGYYk/
 6HGA==
X-Gm-Message-State: AOJu0YxioW9DCeJvsKosZfkHeQTMsm1AW9GbL9KurqhlsAPtMKsdgSIg
 wZqJ4IYevvsckWVWk7mDtEs=
X-Google-Smtp-Source: AGHT+IGTSnIMdj/n4Ja3NbcbsGlcoAWOTqGIDx359ahueXqqmFI98BytrXJ2gg+e90t8fNnGTP3pNA==
X-Received: by 2002:a05:690c:95:b0:5a8:6286:bee with SMTP id
 be21-20020a05690c009500b005a862860beemr5534482ywb.4.1697478901928; 
 Mon, 16 Oct 2023 10:55:01 -0700 (PDT)
Received: from localhost ([2607:fb90:be80:2b9:64a5:5a0e:5435:bd4])
 by smtp.gmail.com with ESMTPSA id
 w185-20020a817bc2000000b005a7ab32d454sm2404120ywc.10.2023.10.16.10.54.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Oct 2023 10:55:01 -0700 (PDT)
Date: Mon, 16 Oct 2023 10:54:58 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH v2 00/13] ip_tunnel: convert __be16 tunnel flags to bitmaps
Message-ID: <ZS148saIsG7WY8ul@yury-ThinkPad>
References: <20231016165247.14212-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231016165247.14212-1-aleksander.lobakin@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 16, 2023 at 06:52:34PM +0200, Alexander Lobakin wrote:
> Based on top of "Implement MTE tag compression for swapped pages"[0]
> from Alexander Potapenko as it uses its bitmap_{read,write}() functions
> to not introduce another pair of similar ones.
> 
> Derived from the PFCP support series[1] as this grew bigger (2 -> 13
> commits) and involved more core bitmap changes. Only commits 10 and 11
> are from the mentioned tree, the rest is new. PFCP itself still depends
> on this series.
> 
> IP tunnels have their flags defined as `__be16`, including UAPI, and
> after GTP was accepted, there are no more free bits left. UAPI (incl.
> direct usage of one of the user structs) and explicit Endianness only
> complicate things.
> Since it would either way end up with hundreds of locs due to all that,
> pick bitmaps right from the start to store the flags in the most native
> and scalable format with rich API. I don't think it's worth trying to
> praise luck and pick smth like u32 only to redo everything in x years :)
> More details regarding the IP tunnel flags is in 11 and 13.
> 
> The rest is just a good bunch of prereqs and tests: a couple of new
> helpers and extensions to the old ones, a few optimizations to partially
> mitigate IP tunnel object code growth due to __be16 -> long, and
> decouping one UAPI struct used throughout the whole kernel into the
> userspace and the kernel space counterparts to eliminate the dependency.
> 
> [0] https://lore.kernel.org/lkml/20231011172836.2579017-1-glider@google.com
> [1] https://lore.kernel.org/netdev/20230721071532.613888-1-marcin.szycik@linux.intel.com
> 
> Alexander Lobakin (13):
>   bitops: add missing prototype check
>   bitops: make BYTES_TO_BITS() treewide-available
>   bitops: let the compiler optimize {__,}assign_bit()
>   linkmode: convert linkmode_{test,set,clear,mod}_bit() to macros
>   s390/cio: rename bitmap_size() -> idset_bitmap_size()
>   fs/ntfs3: add prefix to bitmap_size() and use BITS_TO_U64()
>   btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
>   bitmap: introduce generic optimized bitmap_size()
>   bitmap: make bitmap_{get,set}_value8() use bitmap_{read,write}()
>   ip_tunnel: use a separate struct to store tunnel params in the kernel
>   ip_tunnel: convert __be16 tunnel flags to bitmaps
>   lib/bitmap: add compile-time test for __assign_bit() optimization
>   lib/bitmap: add tests for IP tunnel flags conversion helpers
> 
>  drivers/md/dm-clone-metadata.c                |   5 -
>  drivers/net/bareudp.c                         |  19 ++-
>  .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   2 +-
>  .../mellanox/mlx5/core/en/tc_tun_encap.c      |   6 +-
>  .../mellanox/mlx5/core/en/tc_tun_geneve.c     |  12 +-
>  .../mellanox/mlx5/core/en/tc_tun_gre.c        |   8 +-
>  .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |   9 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  16 +-
>  .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  56 ++++---
>  .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   2 +-
>  .../ethernet/mellanox/mlxsw/spectrum_span.c   |  10 +-
>  .../ethernet/netronome/nfp/flower/action.c    |  27 +++-
>  drivers/net/geneve.c                          |  44 +++---
>  drivers/net/vxlan/vxlan_core.c                |  14 +-
>  drivers/s390/cio/idset.c                      |  12 +-
>  fs/btrfs/free-space-cache.c                   |   8 +-
>  fs/ntfs3/bitmap.c                             |   4 +-
>  fs/ntfs3/fsntfs.c                             |   2 +-
>  fs/ntfs3/index.c                              |  11 +-
>  fs/ntfs3/ntfs_fs.h                            |   4 +-
>  fs/ntfs3/super.c                              |   2 +-
>  include/linux/bitmap.h                        |  46 ++----
>  include/linux/bitops.h                        |  23 +--
>  include/linux/cpumask.h                       |   2 +-
>  include/linux/linkmode.h                      |  27 +---
>  include/linux/netdevice.h                     |   7 +-
>  include/net/dst_metadata.h                    |  10 +-
>  include/net/flow_dissector.h                  |   2 +-
>  include/net/gre.h                             |  70 +++++----
>  include/net/ip6_tunnel.h                      |   4 +-
>  include/net/ip_tunnels.h                      | 136 ++++++++++++++---
>  include/net/udp_tunnel.h                      |   4 +-
>  include/uapi/linux/if_tunnel.h                |  33 ++++
>  kernel/trace/trace_probe.c                    |   2 -
>  lib/math/prime_numbers.c                      |   2 -
>  lib/test_bitmap.c                             | 123 ++++++++++++++-
>  net/bridge/br_vlan_tunnel.c                   |   9 +-
>  net/core/filter.c                             |  26 ++--
>  net/core/flow_dissector.c                     |  20 ++-
>  net/ipv4/fou_bpf.c                            |   2 +-
>  net/ipv4/gre_demux.c                          |   2 +-
>  net/ipv4/ip_gre.c                             | 144 +++++++++++-------
>  net/ipv4/ip_tunnel.c                          | 109 ++++++++-----
>  net/ipv4/ip_tunnel_core.c                     |  82 ++++++----
>  net/ipv4/ip_vti.c                             |  41 +++--
>  net/ipv4/ipip.c                               |  33 ++--
>  net/ipv4/ipmr.c                               |   2 +-
>  net/ipv4/udp_tunnel_core.c                    |   5 +-
>  net/ipv6/addrconf.c                           |   3 +-
>  net/ipv6/ip6_gre.c                            |  85 ++++++-----
>  net/ipv6/ip6_tunnel.c                         |  14 +-
>  net/ipv6/sit.c                                |  38 ++---
>  net/netfilter/ipvs/ip_vs_core.c               |   6 +-
>  net/netfilter/ipvs/ip_vs_xmit.c               |  20 +--
>  net/netfilter/nft_tunnel.c                    |  44 +++---
>  net/openvswitch/flow_netlink.c                |  61 +++++---
>  net/psample/psample.c                         |  26 ++--
>  net/sched/act_tunnel_key.c                    |  36 ++---
>  net/sched/cls_flower.c                        |  27 ++--
>  tools/include/linux/bitmap.h                  |   8 +-
>  tools/include/linux/bitops.h                  |   2 +
>  tools/perf/util/probe-finder.c                |   2 -
>  62 files changed, 1011 insertions(+), 600 deletions(-)
> 
> ---
> Not sure whether it's fine to have that all in one series, but OTOH
> there's not much stuff I could split (like, 3 commits), it either
> depends directly (new helpers etc.) or will just generate suboptimal
> code w/o some of the commits.
> 
> I'm also thinking of which tree this would ideally be taken through.
> The main subject is networking, but most of the commits are generic.
> My idea is to push this via Yury / bitmaps and then ask the netdev
> maintainers to pull his tree before they take PFCP (dependent on this
> one).

Let's wait for more comments, but I'm generally OK with the generic
part, and have nothing against moving it, or the whole series, through
bitmap-for-next.

Thanks,
Yury
 
> >From v1[2]:
>  * 03: convert assign_bit() to a macro as well, saves some bytes and
>    looks more consistent (Yury);
>  * 03: enclose each argument into own pair of braces (Yury);
>  * 06: use generic BITS_TO_U64() while at it (Yury);
>  * 07: pick Acked-by (David);
>  * 08: Acked-by, use bitmap_size() in the code from 05 as well (Yury);
>  * 09: instead of introducing a new pair of functions, use generic
>    bitmap_{read,write}() from [0]. bloat-o-meter shows no regressions
>    from the switch (Yury, also Andy).
> 
> Old pfcp -> bitmap changelog:
> 
> As for former commits (now 10 and 11), almost all of the changes were
> suggested by Andy, notably: stop violating bitmap API, use
> __assign_bit() where appropriate, and add more tests to make sure
> everything works as expected. Apart from that, add simple wrappers for
> bitmap_*() used in the IP tunnel code to avoid manually specifying
> ``__IP_TUNNEL_FLAG_NUM`` each time.
> 
> [2] https://lore.kernel.org/lkml/20231009151026.66145-1-aleksander.lobakin@intel.com
> -- 
> 2.41.0

