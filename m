From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 12/13] Documentation/admin-guide: tainted-kernels: drop doubled word
Date: Fri,  3 Jul 2020 20:20:19 -0700
Message-ID: <20200704032020.21923-13-rdunlap@infradead.org>
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
---
 Documentation/admin-guide/tainted-kernels.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/tainted-kernels.rst
+++ linux-next-20200701/Documentation/admin-guide/tainted-kernels.rst
@@ -61,7 +61,7 @@ this on the machine that had the stateme
 	 * Proprietary module was loaded (#0)
 	 * Kernel issued warning (#9)
 	 * Externally-built ('out-of-tree') module was loaded  (#12)
-	See Documentation/admin-guide/tainted-kernels.rst in the the Linux kernel or
+	See Documentation/admin-guide/tainted-kernels.rst in the Linux kernel or
 	 https://www.kernel.org/doc/html/latest/admin-guide/tainted-kernels.html for
 	 a more details explanation of the various taint flags.
 	Raw taint value as int/string: 4609/'P        W  O     '
