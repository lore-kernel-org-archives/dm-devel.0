From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 09/13] Documentation/admin-guide: intel_pstate: drop doubled word
Date: Fri,  3 Jul 2020 20:20:16 -0700
Message-ID: <20200704032020.21923-10-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

Drop the doubled word "to".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-pm@vger.kernel.org
---
 Documentation/admin-guide/pm/intel_pstate.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/pm/intel_pstate.rst
+++ linux-next-20200701/Documentation/admin-guide/pm/intel_pstate.rst
@@ -708,7 +708,7 @@ core (for the policies with other scalin
 
 The ``ftrace`` interface can be used for low-level diagnostics of
 ``intel_pstate``.  For example, to check how often the function to set a
-P-state is called, the ``ftrace`` filter can be set to to
+P-state is called, the ``ftrace`` filter can be set to
 :c:func:`intel_pstate_set_pstate`::
 
  # cd /sys/kernel/debug/tracing/
