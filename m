From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 07/13] Documentation/admin-guide: pnfs-scsi-server: drop doubled word
Date: Fri,  3 Jul 2020 20:20:14 -0700
Message-ID: <20200704032020.21923-8-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-media-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

Drop the doubled word "with".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
---
 Documentation/admin-guide/nfs/pnfs-scsi-server.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/nfs/pnfs-scsi-server.rst
+++ linux-next-20200701/Documentation/admin-guide/nfs/pnfs-scsi-server.rst
@@ -9,7 +9,7 @@ which in addition to handling all the me
 also hands out layouts to the clients so that they can directly access the
 underlying SCSI LUNs that are shared with the client.
 
-To use pNFS SCSI layouts with with the Linux NFS server, the exported file
+To use pNFS SCSI layouts with the Linux NFS server, the exported file
 system needs to support the pNFS SCSI layouts (currently just XFS), and the
 file system must sit on a SCSI LUN that is accessible to the clients in
 addition to the MDS.  As of now the file system needs to sit directly on the
