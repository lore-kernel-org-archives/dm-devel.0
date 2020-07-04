From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 11/13] Documentation/admin-guide: sysctl/kernel: drop doubled word
Date: Fri,  3 Jul 2020 20:20:18 -0700
Message-ID: <20200704032020.21923-12-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-media-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

Drop the doubled word "set".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/admin-guide/sysctl/kernel.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/sysctl/kernel.rst
+++ linux-next-20200701/Documentation/admin-guide/sysctl/kernel.rst
@@ -235,7 +235,7 @@ This toggle indicates whether unprivileg
 from using ``dmesg(8)`` to view messages from the kernel's log
 buffer.
 When ``dmesg_restrict`` is set to 0 there are no restrictions.
-When ``dmesg_restrict`` is set set to 1, users must have
+When ``dmesg_restrict`` is set to 1, users must have
 ``CAP_SYSLOG`` to use ``dmesg(8)``.
 
 The kernel config option ``CONFIG_SECURITY_DMESG_RESTRICT`` sets the
