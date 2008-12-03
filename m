From: "Ty! Boyack" <ty@nrel.colostate.edu>
Subject: What does no_path_retry=NULL mean?
Date: Wed, 03 Dec 2008 12:26:29 -0700
Message-ID: <4936DD65.9000101@nrel.colostate.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

I've been trying to understand what the default behavior should be if
no_path_retry is not set in the multipath.conf file.  The annotated
version describes (somewhat) what happens with values of queue, fail, or
n>0, but says the default is NULL, and does not say what behavior NULL
produces.

The reason for the question is a situation where a highly-available
iscsi target undergoes failover from one node to another, and the iscsi
initiators see all their multiple paths fail during that transition
time, which takes 5-120 seconds.  I had set no_path_retry to queue,
thinking it would queue until the paths come back, but it seems to stop
checking the path status and queue forever.  Is that expected?  Or 
should no_path_retry=queue stop queuing (but continue checking the 
paths) and send both queued and new requests when the paths are 
available again?  With it set to queue it hangs all I/O requests until I 
restart multipathd, at which point I expect that all queued data is 
lost.  It will stay in the queued state for hours/days even though the 
paths are back if no action is taken.

This is on fedora 9, the default device-mapper-multipath rpm, version
0.4.7, release 16.fc9.  path_checker=readsector0, and poling_interval=10.

Thanks for helping me understand what is happening here.

-Ty!



-- 
-===========================-
  Ty! Boyack
  NREL Unix Network Manager
  ty@nrel.colostate.edu
  (970) 491-1186
-===========================-
