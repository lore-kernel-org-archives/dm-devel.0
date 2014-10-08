From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-bufio cache patches
Date: Wed, 8 Oct 2014 16:10:56 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410081607440.5670@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I created dm-bufio patchset that keep some amount of cache indefinitely, 
regardless of the timeout (the default is to keep 1/500 of total memory 
indefinitely).

I uploaded it here: 
http://people.redhat.com/~mpatocka/patches/kernel/dm-bufio-cache/

Try it, if it helps, we can backport it.

If you think that we should use different default values (for example, 
increase the max_age value), say it.

Mikulas
