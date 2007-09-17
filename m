From: Jens Thiele <karme@berlios.de>
Subject: bio too big device md0 (248 > 240) - lvm on top of raid1
Date: Mon, 17 Sep 2007 19:28:34 +0200
Message-ID: <87ejgv27nb.fsf@thialfi.karme-net.hirschau>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I think I run into the same problem as described in a thread on the lkml:
"[dm-devel] bio too big device md1 (16 > 8)"
Message-Id   <87irc84bcq.87hcrs4bcq@87fy7c4bcq.message.id>
http://lkml.org/lkml/2007/4/7/81

A related thread on dm-devel about a patch that probably doesn't help:
"[dm-devel] [2.6.22 PATCH 01/26] dm: merge max_hw_sector"
http://www.redhat.com/archives/dm-devel/2007-May/msg00007.html

Any news regarding this one?
Should I file a bug on http://bugzilla.kernel.org/ ?
(It seems there is no entry yet)

Anything I could do to help fix this problem?

Thanks
Jens

PS: if I have a LVM snapshot the message disappears
