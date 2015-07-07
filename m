From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/7] mm: reliable memory allocation with kvmalloc
Date: Tue, 7 Jul 2015 11:08:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Mike Snitzer <msnitzer@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This patchset introduces function kvmalloc and kvmalloc_node. These 
functions allow reliable allocation of objects of arbitrary size. They 
attempt to do allocation with kmalloc and if it fails, use vmalloc. Memory 
allocated with these functions should be freed with kvfree.

The patchset makes modification to device mapper to use these functions.

Mikulas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
