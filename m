From: seth vidal <skvidal@linux.duke.edu>
Subject: Re: failover speed
Date: Tue, 29 Aug 2006 12:57:12 -0400
Message-ID: <1156870632.29242.80.camel@cutter>
References: <1156791189.26413.8.camel@cutter>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1156791189.26413.8.camel@cutter>
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

On Mon, 2006-08-28 at 14:53 -0400, seth vidal wrote:
> Hi,
>  I've gotten failover and failback working, however, I'm not sure if the
> amount of wait time for the failover is reasonable. I'm using QLogic
> 2340 cards and an EVA8000. I'm curious if anyone else using something
> similar is seeing in terms of failover times. 
> 
> When things are running as I'd expect I'm seeing just a few seconds
> before the new path is up. When things seem wrong it's waiting and
> queueing for as much as 1.5 minutes.
> 

Okay - I read #8 on the faq in the wiki which told me to look for \*tmo
\* files in /sys/

The problem is I'm running a 2.6.9 kernel for rhel4/centos4 and it
doesn't have those, yet.

I did, however, find these:
/sys/class/fc_transport/target1:0:0/device/1:0:0:*/timeout

which are set to 30s each.

Are these the functional equivalent of each other? Or if I set the above
down to say 6s or 3s will I encounter other types of suffering?

Thanks,
-sv
