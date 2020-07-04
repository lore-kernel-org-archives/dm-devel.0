From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 05/13] Documentation/admin-guide: mm/ksm: drop doubled word
Date: Fri,  3 Jul 2020 20:20:12 -0700
Message-ID: <20200704032020.21923-6-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

Drop the doubled word "the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 Documentation/admin-guide/mm/ksm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/mm/ksm.rst
+++ linux-next-20200701/Documentation/admin-guide/mm/ksm.rst
@@ -52,7 +52,7 @@ with EAGAIN, but more probably arousing
 If KSM is not configured into the running kernel, madvise MADV_MERGEABLE
 and MADV_UNMERGEABLE simply fail with EINVAL.  If the running kernel was
 built with CONFIG_KSM=y, those calls will normally succeed: even if the
-the KSM daemon is not currently running, MADV_MERGEABLE still registers
+KSM daemon is not currently running, MADV_MERGEABLE still registers
 the range for whenever the KSM daemon is started; even if the range
 cannot contain any pages which KSM could actually merge; even if
 MADV_UNMERGEABLE is applied to a range which was never MADV_MERGEABLE.
