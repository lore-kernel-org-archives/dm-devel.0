From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Fri, 12 Dec 2008 14:21:01 -0600
Message-ID: <ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
References: <492C91DF.7040507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <492C91DF.7040507@redhat.com>
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


On Nov 25, 2008, at 6:01 PM, Takahiro Yasui wrote:
> PATCH SET
> =========
>  1/4: dm-log: fix no io_client_destroy

definitely, ACK.

>  2/4: dm-log: remove unnecessary updates of io_req members

haven't fully reviewed yet.

>  3/4: dm-log: introduce multi-log devices
>  4/4: dm-log: update interface to control multi-log devices

No.  more follows...

> BACKGROUND
> ==========

<snip>

> However, once log disk breaks down, data replications are required
> for a whole data disks, and if a size of data disk is huge, it
> takes long time

Not entirely true.  When the log disk breaks down /and/ the machine  
crashes or reboots, then resynchronization is necessary.  However,  
this means that in almost all circumstances, you are immediately able  
to replace the failed disk log with another and maintain the in-sync  
state of the log - avoiding the resync.

> This patch introduces multi-log devices for mirror target, which
> stores log data on multiple log devices, and decreases probability
> of disk replication even if one log disk has broken down.

Given what I said above, I'd like to see intelligence added to the  
dmeventd mirror DSO to handle replacing mirror logs done first.  There  
is certainly a lot of low lying fruit in that space.  However, I can  
see a small benefit to implementing multi-log.  Specifically, to  
address the case where a log device dies and is immediately followed  
by a machine failure before corrective action can be taken.  IOW, you  
are targeting a very small window of time here.

If you choose to take on the multi-log (which it appears you are  
mostly done), then I'd like to see it as a separate module.  IOW,  
there should be no code changes to dm-log.c.  You would implement a  
new module, named dm-log-multi[ple].ko.  The name would be "multi- 
disk".  This frees you to have whatever constructor table arguments  
you want.  (I've done something similar when creating my cluster-aware  
logging.)

I'll be on the call on Monday, of course you can ask any questions  
then too.

  brassow
