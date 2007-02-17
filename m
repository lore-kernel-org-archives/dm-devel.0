From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Date: Fri, 16 Feb 2007 16:09:20 -0800
Message-ID: <20070216160920.27c1167a.akpm@linux-foundation.org>
References: <200702161437.34063.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946323AbXBQAJg@vger.kernel.org>
In-Reply-To: <200702161437.34063.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 16 Feb 2007 14:37:28 +0100
Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> I can't bring up my machine with root LVM anymore using x86_64. The same 
> machine from same kernel tree boots fine as x86. The error message is quoted 
> in subject. The tree is at 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for 
> those not using git: somewhere after 2.6.20).

Does this fix it?  I don't see why it would, but this was recently added.

--- a/block/genhd.c~a
+++ a/block/genhd.c
@@ -61,14 +61,6 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= index && index <= 63) ||
-					(120 <= index && index <= 127) ||
-					(240 <= index && index <= 254))
-				continue;
 			if (major_names[index] == NULL)
 				break;
 		}
_
