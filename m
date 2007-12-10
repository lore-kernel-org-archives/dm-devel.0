From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: device-mapper multipath retry IO errors
Date: Mon, 10 Dec 2007 10:06:47 -0500
Message-ID: <1197299207.6188.10.camel@eddie-laptop.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
List-Id: dm-devel.ids


It looks to me like device mapper multipath will retry IO errors, no
matter what the error, indefinitely if no_path_retry is set to anything
other than 0 and the path checker does not detect the failure.

Say you run into a medium error, the particular IO will fail.  The path
will be marked failed and retried on another path.  This will exhaust
the list of paths since the medium error will happen on each path.  If
no_path_retry is set to 1 or more then the IO will be queued.  The path
checker will come along and the TUR or the IO to block 0 will pass so it
will mark the path as good, clearing the error.  The IO will then get
reissued, marking the paths failed, etc.

Am I missing something in the code that will catch this?

I don't have a means to force a medium error but I was able to create
something similar by creating a reservation conflict.

Eddie
