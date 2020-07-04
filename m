From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 03/13] Documentation/admin-guide: dm-integrity: drop doubled words
Date: Fri,  3 Jul 2020 20:20:10 -0700
Message-ID: <20200704032020.21923-4-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

Drop the doubled words "on" and "the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: dm-devel@redhat.com
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200701.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ linux-next-20200701/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -45,7 +45,7 @@ To use the target for the first time:
    will format the device
 3. unload the dm-integrity target
 4. read the "provided_data_sectors" value from the superblock
-5. load the dm-integrity target with the the target size
+5. load the dm-integrity target with the target size
    "provided_data_sectors"
 6. if you want to use dm-integrity with dm-crypt, load the dm-crypt target
    with the size "provided_data_sectors"
@@ -99,7 +99,7 @@ interleave_sectors:number
 	the superblock is used.
 
 meta_device:device
-	Don't interleave the data and metadata on on device. Use a
+	Don't interleave the data and metadata on the device. Use a
 	separate device for metadata.
 
 buffer_sectors:number
