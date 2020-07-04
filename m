From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 08/13] Documentation/admin-guide: arm-ccn: drop doubled word
Date: Fri,  3 Jul 2020 20:20:15 -0700
Message-ID: <20200704032020.21923-9-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

Drop the doubled word "as".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/admin-guide/perf/arm-ccn.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/perf/arm-ccn.rst
+++ linux-next-20200701/Documentation/admin-guide/perf/arm-ccn.rst
@@ -27,7 +27,7 @@ Crosspoint PMU events require "xp" (inde
 and "vc" (virtual channel ID).
 
 Crosspoint watchpoint-based events (special "event" value 0xfe)
-require "xp" and "vc" as as above plus "port" (device port index),
+require "xp" and "vc" as above plus "port" (device port index),
 "dir" (transmit/receive direction), comparator values ("cmp_l"
 and "cmp_h") and "mask", being index of the comparator mask.
 
