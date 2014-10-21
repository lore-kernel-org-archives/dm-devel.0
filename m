From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Thoughts on the multipath checker
Date: Tue, 21 Oct 2014 16:43:53 -0500
Message-ID: <20141021214353.GQ10973@ask-08.lab.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Just today, I've dealt with two groups of people using multipath on
single pathed devices for the persistent names and the IO queueing and
retrying.  It made we wonder how often this happens, and if we should
think about adding an option to disable preeptive path checking. You
could argue that it doesn't do any good on single pathed devices.  In
fact, you could argue that it doesn't do much good to fail the last
available path of any multipath device (You could also argue that it
does a lot of good, in warning users of problems in devices that they
aren't currently using but will be in the furture).

So what do people think about an option to not tell the kernel to fail
the last active path in a multipath device? It would keep multipathd
from calling dm_fail_path() in this case.

-Ben
