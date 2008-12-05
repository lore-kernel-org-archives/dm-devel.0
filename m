From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: What does no_path_retry=NULL mean?
Date: Fri, 5 Dec 2008 09:20:01 -0600
Message-ID: <20081205152000.GA1585@ether.msp.redhat.com>
References: <4936DD65.9000101@nrel.colostate.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4936DD65.9000101@nrel.colostate.edu>
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
List-Id: dm-devel.ids

On Wed, Dec 03, 2008 at 12:26:29PM -0700, Ty! Boyack wrote:
> I've been trying to understand what the default behavior should be if
> no_path_retry is not set in the multipath.conf file.  The annotated
> version describes (somewhat) what happens with values of queue, fail, or
> n>0, but says the default is NULL, and does not say what behavior NULL
> produces.

NULL is the same as fail, unless you manually set the retry feature
with

features "1 queue_if_no_path"

> The reason for the question is a situation where a highly-available
> iscsi target undergoes failover from one node to another, and the iscsi
> initiators see all their multiple paths fail during that transition
> time, which takes 5-120 seconds.  I had set no_path_retry to queue,
> thinking it would queue until the paths come back, but it seems to stop
> checking the path status and queue forever.  Is that expected?  Or should 
> no_path_retry=queue stop queuing (but continue checking the paths) and send 
> both queued and new requests when the paths are available again?  With it 
> set to queue it hangs all I/O requests until I restart multipathd, at which 
> point I expect that all queued data is lost.  It will stay in the queued 
> state for hours/days even though the paths are back if no action is taken.

This is not what is supposed to happen, but yout queued data is not lost when
multipathd is stopped and restarted.  It is queued in the kernel, not userspace.
Does /var/log/messages say anything when multipathd hangs?  Would it be
possible for you to attach gdb, and get a backtrace of the multipath
threads when it hangs?

> This is on fedora 9, the default device-mapper-multipath rpm, version
> 0.4.7, release 16.fc9.  path_checker=readsector0, and poling_interval=10.
>
> Thanks for helping me understand what is happening here.
>
> -Ty!
>
>
>
> -- 
> -===========================-
>  Ty! Boyack
>  NREL Unix Network Manager
>  ty@nrel.colostate.edu
>  (970) 491-1186
> -===========================-
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
