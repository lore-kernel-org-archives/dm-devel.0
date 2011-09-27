From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-bufio
Date: Tue, 27 Sep 2011 13:20:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109271316500.1333@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Thornber <thornber@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I placed updated dm-bufio here: 
http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/

It uses kmem_cache with proper alignment instead of kmalloc (which may 
return unaligned memory), so it should fix problems that Heinz observed on 
Sparc.

Mikulas
