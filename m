From: Bob Bawn <bob.bawn@solidfire.com>
Subject: IO Ordering on Path Failover
Date: Fri, 28 Feb 2014 15:42:41 -0700
Message-ID: <CAPB7CupKZqW_tLZHcYsMS2eyqkFnmb0gDE2JrDoTqRpn43fsgg@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I am trying to understand how IO ordering safety is enforced with on
path failover. This is new territory for me so forgive me if this is
obvious. Consider the sequence:

1. client writes(lba=0,val=x) on path A.
2. multipath declares path A dead and retries write on path B
3. retried write on path B completes successfully and client get ack'd
4. client writes(lba=0,val=y) on path B. It also completes
successfully and is ack'd to client
5. write from (1) completes and corrupts data

It seems like multipath needs a guarantee at step 2 that the original
write won't complete after path A has been declared down. I thought it
would issue something like a LUN RESET on path B and that the response
to that reset would indicate that it is safe to proceed. This page
sort of supports that speculation:
http://scst.sourceforge.net/mc_s.html

In testing with dm-multipath accessing an LIO/IBLOCK device over FC, I
don't see a LUN RESET. I also don't see any indication of this in the
code but I might be missing something.

It occurred to me that my target might not be setting the correct bits
for multipathing.

Any advice?

-- 
Bob Bawn
