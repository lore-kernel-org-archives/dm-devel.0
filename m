Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1833AC2F
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hS/Z54bd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524316;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jB9YkGfHJD2EO5oqxB2ehMJ83HmCcAn2be8pZPMH5tA=;
	b=hS/Z54bd/Mqspxph3o08wURRAenhyn7/nU+BoMZbqxEedzWbbFDysGvgQjwKanxW/N9GN8
	h2By3CxOuzTZEpH8OC6aISMWgxtaegL8AwjluVzHtejWnIbtnfqQwqJpy8eLn1ypzOdCvN
	iFtlWO2WHBSRwT+jyr9hU/6Dydh57XY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-6JnK9aF0P0yAanqQvYOcjw-1; Tue, 17 Oct 2023 02:31:55 -0400
X-MC-Unique: 6JnK9aF0P0yAanqQvYOcjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CF6B1029F41
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 139541121314
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD41219466F2
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AAFC51946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Oct 2023 16:54:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68EAD492BEF; Mon, 16 Oct 2023 16:54:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6141F492BEE
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 16:54:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 216571C0BB42
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 16:54:20 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-7754_eVlN9m0X7Lr1GqCOg-1; Mon, 16 Oct 2023 12:54:17 -0400
X-MC-Unique: 7754_eVlN9m0X7Lr1GqCOg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364936993"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; d="scan'208";a="364936993"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 16 Oct 2023 09:54:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826083910"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; d="scan'208";a="826083910"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 09:54:12 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH v2 00/13] ip_tunnel: convert __be16 tunnel flags to bitmaps
Date: Mon, 16 Oct 2023 18:52:34 +0200
Message-ID: <20231016165247.14212-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
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
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Based on top of "Implement MTE tag compression for swapped pages"[0]
from Alexander Potapenko as it uses its bitmap_{read,write}() functions
to not introduce another pair of similar ones.

Derived from the PFCP support series[1] as this grew bigger (2 -> 13
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
More details regarding the IP tunnel flags is in 11 and 13.

The rest is just a good bunch of prereqs and tests: a couple of new
helpers and extensions to the old ones, a few optimizations to partially
mitigate IP tunnel object code growth due to __be16 -> long, and
decouping one UAPI struct used throughout the whole kernel into the
userspace and the kernel space counterparts to eliminate the dependency.

[0] https://lore.kernel.org/lkml/20231011172836.2579017-1-glider@google.com
[1] https://lore.kernel.org/netdev/20230721071532.613888-1-marcin.szycik@linux.intel.com

Alexander Lobakin (13):
  bitops: add missing prototype check
  bitops: make BYTES_TO_BITS() treewide-available
  bitops: let the compiler optimize {__,}assign_bit()
  linkmode: convert linkmode_{test,set,clear,mod}_bit() to macros
  s390/cio: rename bitmap_size() -> idset_bitmap_size()
  fs/ntfs3: add prefix to bitmap_size() and use BITS_TO_U64()
  btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
  bitmap: introduce generic optimized bitmap_size()
  bitmap: make bitmap_{get,set}_value8() use bitmap_{read,write}()
  ip_tunnel: use a separate struct to store tunnel params in the kernel
  ip_tunnel: convert __be16 tunnel flags to bitmaps
  lib/bitmap: add compile-time test for __assign_bit() optimization
  lib/bitmap: add tests for IP tunnel flags conversion helpers

 drivers/md/dm-clone-metadata.c                |   5 -
 drivers/net/bareudp.c                         |  19 ++-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   2 +-
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |   6 +-
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     |  12 +-
 .../mellanox/mlx5/core/en/tc_tun_gre.c        |   8 +-
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  16 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  56 ++++---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  10 +-
 .../ethernet/netronome/nfp/flower/action.c    |  27 +++-
 drivers/net/geneve.c                          |  44 +++---
 drivers/net/vxlan/vxlan_core.c                |  14 +-
 drivers/s390/cio/idset.c                      |  12 +-
 fs/btrfs/free-space-cache.c                   |   8 +-
 fs/ntfs3/bitmap.c                             |   4 +-
 fs/ntfs3/fsntfs.c                             |   2 +-
 fs/ntfs3/index.c                              |  11 +-
 fs/ntfs3/ntfs_fs.h                            |   4 +-
 fs/ntfs3/super.c                              |   2 +-
 include/linux/bitmap.h                        |  46 ++----
 include/linux/bitops.h                        |  23 +--
 include/linux/cpumask.h                       |   2 +-
 include/linux/linkmode.h                      |  27 +---
 include/linux/netdevice.h                     |   7 +-
 include/net/dst_metadata.h                    |  10 +-
 include/net/flow_dissector.h                  |   2 +-
 include/net/gre.h                             |  70 +++++----
 include/net/ip6_tunnel.h                      |   4 +-
 include/net/ip_tunnels.h                      | 136 ++++++++++++++---
 include/net/udp_tunnel.h                      |   4 +-
 include/uapi/linux/if_tunnel.h                |  33 ++++
 kernel/trace/trace_probe.c                    |   2 -
 lib/math/prime_numbers.c                      |   2 -
 lib/test_bitmap.c                             | 123 ++++++++++++++-
 net/bridge/br_vlan_tunnel.c                   |   9 +-
 net/core/filter.c                             |  26 ++--
 net/core/flow_dissector.c                     |  20 ++-
 net/ipv4/fou_bpf.c                            |   2 +-
 net/ipv4/gre_demux.c                          |   2 +-
 net/ipv4/ip_gre.c                             | 144 +++++++++++-------
 net/ipv4/ip_tunnel.c                          | 109 ++++++++-----
 net/ipv4/ip_tunnel_core.c                     |  82 ++++++----
 net/ipv4/ip_vti.c                             |  41 +++--
 net/ipv4/ipip.c                               |  33 ++--
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/udp_tunnel_core.c                    |   5 +-
 net/ipv6/addrconf.c                           |   3 +-
 net/ipv6/ip6_gre.c                            |  85 ++++++-----
 net/ipv6/ip6_tunnel.c                         |  14 +-
 net/ipv6/sit.c                                |  38 ++---
 net/netfilter/ipvs/ip_vs_core.c               |   6 +-
 net/netfilter/ipvs/ip_vs_xmit.c               |  20 +--
 net/netfilter/nft_tunnel.c                    |  44 +++---
 net/openvswitch/flow_netlink.c                |  61 +++++---
 net/psample/psample.c                         |  26 ++--
 net/sched/act_tunnel_key.c                    |  36 ++---
 net/sched/cls_flower.c                        |  27 ++--
 tools/include/linux/bitmap.h                  |   8 +-
 tools/include/linux/bitops.h                  |   2 +
 tools/perf/util/probe-finder.c                |   2 -
 62 files changed, 1011 insertions(+), 600 deletions(-)

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

From v1[2]:
 * 03: convert assign_bit() to a macro as well, saves some bytes and
   looks more consistent (Yury);
 * 03: enclose each argument into own pair of braces (Yury);
 * 06: use generic BITS_TO_U64() while at it (Yury);
 * 07: pick Acked-by (David);
 * 08: Acked-by, use bitmap_size() in the code from 05 as well (Yury);
 * 09: instead of introducing a new pair of functions, use generic
   bitmap_{read,write}() from [0]. bloat-o-meter shows no regressions
   from the switch (Yury, also Andy).

Old pfcp -> bitmap changelog:

As for former commits (now 10 and 11), almost all of the changes were
suggested by Andy, notably: stop violating bitmap API, use
__assign_bit() where appropriate, and add more tests to make sure
everything works as expected. Apart from that, add simple wrappers for
bitmap_*() used in the IP tunnel code to avoid manually specifying
``__IP_TUNNEL_FLAG_NUM`` each time.

[2] https://lore.kernel.org/lkml/20231009151026.66145-1-aleksander.lobakin@intel.com
-- 
2.41.0

