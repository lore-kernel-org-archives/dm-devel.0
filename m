From: Mikulas Patocka <mpatocka@redhat.com>
Subject: "handle_errors" argument in dm-raid1
Date: Tue, 14 Jul 2009 17:04:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907141658140.8166@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

You said that "handle_errors" argument in dm-raid1 means that dmeventd is 
running. I/Os are held back when this argument is present.

But when I look at the table, the argument isn't there (even when I fixed 
dmeventd).

When I grep the whole LVM2 package for handle_errors string, the string 
isn't there at all.

Am I misunderstanding something? Or is there a gross bug in lvm, not 
passing "handle_errors" to the kernel and thus it is not able to recover 
from certain errors (such as log failure)?

Mikulas
