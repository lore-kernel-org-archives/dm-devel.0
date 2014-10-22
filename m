From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] mm/slab_common: don't check for duplicate cache names
Date: Wed, 22 Oct 2014 08:57:03 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1410220856450.8892@gentwo.org>
References: <alpine.LRH.2.02.1410211958030.19625@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LRH.2.02.1410211958030.19625@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Tue, 21 Oct 2014, Mikulas Patocka wrote:

> 12220dea07f1ac6ac717707104773d771c3f3077), therefore we need stop checking
> for duplicate names even for the SLAB subsystem. This patch fixes the bug
> by removing the check.

Acked-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
