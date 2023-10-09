Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27860CD68F5
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pYNy1t/6PeGyyUlE0jYuwfTevnXdsinxDb7N6J3MKwc=;
	b=Q3ggyYT9QaJYwF4WBV/KmPjrG913Q/FMm1uh42ZgfXJwwJq6brbFuUYR6c5Zy/r1Q1gvag
	JarXK/gw92x3fMZnEgCWeS+fF1DnGGXxZNTs2vLTZrPNyxdfmSXGQCbPK/+km3obRaohG0
	oNsOpdkwkbDelgXrS/PVeqh5cf1jybI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-FGrBCgmBNcq0an0X7ysGbg-1; Tue, 10 Oct 2023 03:02:57 -0400
X-MC-Unique: FGrBCgmBNcq0an0X7ysGbg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C41023C02B67;
	Tue, 10 Oct 2023 07:02:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D42BF215670B;
	Tue, 10 Oct 2023 07:02:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8260F19465B6;
	Tue, 10 Oct 2023 07:02:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 30B5019465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 15:14:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2166240C6EBF; Mon,  9 Oct 2023 15:14:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 197B740C6EA8
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:14:29 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE334101A597
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:14:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-4Mkl8G1CN8uUwMYf3Kj0PQ-1; Mon, 09 Oct 2023 11:14:12 -0400
X-MC-Unique: 4Mkl8G1CN8uUwMYf3Kj0PQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="369231971"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="369231971"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Oct 2023 08:13:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="869287927"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="869287927"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga002.fm.intel.com with ESMTP; 09 Oct 2023 08:13:00 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Date: Mon,  9 Oct 2023 17:10:12 +0200
Message-ID: <20231009151026.66145-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:50 +0000
Subject: [dm-devel] [PATCH 00/14] ip_tunnel: convert __be16 tunnel flags to
 bitmaps
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
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Derived from the PFCP support series[0] as this grew bigger (2 -> 14
commits) and involved more core bitmap changes. Only commits 10 and 11
are from the mentioned tree, the rest is new. PFCP itself still depends
on this series.

IP tunnels have their flags defined as `__be16`, including UAPI, and
after GTP was accepted, there are no more free bits left. UAPI (incl.
direct usage of one of the user structs) and explicit Endianness only
complicate things.
Since it would either way end up with hundreds of locs due to all that,
pick bitmaps right from the start to store the flags in the most native
and scalable format with rich API. I don't think it's worth trying to
praise luck and pick smth like u32 only to redo everything in x years :)
More details regarding the IP tunnel flags is in 11 and 14.

The rest is just a good bunch of prereqs and tests: a couple of new
helpers and extensions to the old ones, a few optimizations to partially
mitigate IP tunnel object code growth due to __be16 -> long, and
decouping one UAPI struct used throughout the whole kernel into the
userspace and the kernel space counterparts to eliminate the dependency.

[0] https://lore.kernel.org/netdev/20230721071532.613888-1-marcin.szycik@linux.intel.com

Alexander Lobakin (14):
  bitops: add missing prototype check
  bitops: make BYTES_TO_BITS() treewide-available
  bitops: let the compiler optimize __assign_bit()
  linkmode: convert linkmode_{test,set,clear,mod}_bit() to macros
  s390/cio: rename bitmap_size() -> idset_bitmap_size()
  fs/ntfs3: rename bitmap_size() -> ntfs3_bitmap_size()
  btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
  bitmap: introduce generic optimized bitmap_size()
  bitmap: extend bitmap_{get,set}_value8() to bitmap_{get,set}_bits()
  ip_tunnel: use a separate struct to store tunnel params in the kernel
  ip_tunnel: convert __be16 tunnel flags to bitmaps
  lib/bitmap: add compile-time test for __assign_bit() optimization
  lib/bitmap: add tests for bitmap_{get,set}_bits()
  lib/bitmap: add tests for IP tunnel flags conversion helpers

 drivers/md/dm-clone-metadata.c                |   5 -
 drivers/net/bareudp.c                         |  19 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   2 +-
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |   6 +-
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     |  12 +-
 .../mellanox/mlx5/core/en/tc_tun_gre.c        |   8 +-
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  16 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  56 +++--
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  10 +-
 .../ethernet/netronome/nfp/flower/action.c    |  27 ++-
 drivers/net/geneve.c                          |  44 ++--
 drivers/net/vxlan/vxlan_core.c                |  14 +-
 drivers/s390/cio/idset.c                      |  10 +-
 fs/btrfs/free-space-cache.c                   |   8 +-
 fs/ntfs3/bitmap.c                             |   4 +-
 fs/ntfs3/fsntfs.c                             |   2 +-
 fs/ntfs3/index.c                              |  11 +-
 fs/ntfs3/ntfs_fs.h                            |   2 +-
 fs/ntfs3/super.c                              |   2 +-
 include/linux/bitmap.h                        |  59 ++++--
 include/linux/bitops.h                        |  13 +-
 include/linux/cpumask.h                       |   2 +-
 include/linux/linkmode.h                      |  27 +--
 include/linux/netdevice.h                     |   7 +-
 include/net/dst_metadata.h                    |  10 +-
 include/net/flow_dissector.h                  |   2 +-
 include/net/gre.h                             |  70 +++---
 include/net/ip6_tunnel.h                      |   4 +-
 include/net/ip_tunnels.h                      | 136 ++++++++++--
 include/net/udp_tunnel.h                      |   4 +-
 include/uapi/linux/if_tunnel.h                |  33 +++
 kernel/trace/trace_probe.c                    |   2 -
 lib/math/prime_numbers.c                      |   2 -
 lib/test_bitmap.c                             | 200 +++++++++++++++++-
 net/bridge/br_vlan_tunnel.c                   |   9 +-
 net/core/filter.c                             |  26 +--
 net/core/flow_dissector.c                     |  20 +-
 net/ipv4/fou_bpf.c                            |   2 +-
 net/ipv4/gre_demux.c                          |   2 +-
 net/ipv4/ip_gre.c                             | 144 ++++++++-----
 net/ipv4/ip_tunnel.c                          | 109 +++++++---
 net/ipv4/ip_tunnel_core.c                     |  82 ++++---
 net/ipv4/ip_vti.c                             |  41 ++--
 net/ipv4/ipip.c                               |  33 +--
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/udp_tunnel_core.c                    |   5 +-
 net/ipv6/addrconf.c                           |   3 +-
 net/ipv6/ip6_gre.c                            |  85 ++++----
 net/ipv6/ip6_tunnel.c                         |  14 +-
 net/ipv6/sit.c                                |  38 ++--
 net/netfilter/ipvs/ip_vs_core.c               |   6 +-
 net/netfilter/ipvs/ip_vs_xmit.c               |  20 +-
 net/netfilter/nft_tunnel.c                    |  44 ++--
 net/openvswitch/flow_netlink.c                |  61 +++---
 net/psample/psample.c                         |  26 +--
 net/sched/act_tunnel_key.c                    |  36 ++--
 net/sched/cls_flower.c                        |  27 +--
 tools/include/linux/bitmap.h                  |   8 +-
 tools/include/linux/bitops.h                  |   2 +
 tools/perf/util/probe-finder.c                |   2 -
 62 files changed, 1116 insertions(+), 571 deletions(-)

---
Not sure whether it's fine to have that all in one series, but OTOH
there's not much stuff I could split (like, 3 commits), it either
depends directly (new helpers etc.) or will just generate suboptimal
code w/o some of the commits.

I'm also thinking of which tree this would ideally be taken through.
The main subject is networking, but most of the commits are generic.
My idea is to push this via Yury / bitmaps and then ask the netdev
maintainers to pull his tree before they take PFCP (dependent on this
one).

Speaking of bitmap_{read,write}() from [1] vs bitmap_{get,set}_bits()
from #09: they don't really conflict, because the former are
generic-generic and support bound crossing, while the latter require
the width to be a pow-2 and the offset to be a multiple of the width
in order to preserve the optimization level as close to the current
bitmap_{get,set}_value8() as possible...

Old pfcp -> bitmap changelog:

As for former commits (now 10 and 11), almost all of the changes were
suggested by Andy, notably: stop violating bitmap API, use
__assign_bit() where appropriate, and add more tests to make sure
everything works as expected. Apart from that, add simple wrappers for
bitmap_*() used in the IP tunnel code to avoid manually specifying
``__IP_TUNNEL_FLAG_NUM`` each time.

[1] https://lore.kernel.org/lkml/20231006134529.2816540-2-glider@google.com
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

