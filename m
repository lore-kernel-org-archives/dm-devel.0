From: malahal@us.ibm.com
Subject: Re: DM-RAID1 data corruption
Date: Tue, 14 Apr 2009 20:12:10 -0700
Message-ID: <20090415031210.GA11881@us.ibm.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
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

Mikulas Patocka [mpatocka@redhat.com] wrote:
> Hi
> 
> because of a loose cable, overheating, insufficient power or so, and the 
> condition is repaired), raid1 sees set bit in the dirty bitmap and starts 
> copying data from disk 0 to disk 1.
> 
> The result: write bio was ended as succes, but the data was lost. For 
> databases, this might have bad consequences - committed transactions being 
> forgotten.
> 
> -
> 
> If the above scenario can't happen, pls. describe why.
 
IIRC, this is a known problem, always attributed to a "rare/small
window" of chance. :-(

> Delay all bios until the userspace code removes the failed mirror?

That is what the code does when a log device fails. We can use the same
approach.

> Or store the number of the default mirror in the log?

This is one way to do it but what about "corelog" mirrors?

Look at this patch
http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/4973

It essentially generates an uevet and waits for the user level code to
act on it and send a message to unblock it.
