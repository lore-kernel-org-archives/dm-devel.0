From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Multipath-tools not seeing replaced RAID controller
Date: Wed, 13 Feb 2008 17:30:02 -0800
Message-ID: <1202952602.13537.148.camel@linuxchandra>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<46F8A29F.6060803@suse.de>  <200709250852.08464.npf@eurotux.com>
	<1191345214.5831.2.camel@linuxchandra>
	<1202940553.6733.7.camel@localhost>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1202940553.6733.7.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "S. J. van Harmelen" <svh@dds.nl>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2008-02-13 at 23:09 +0100, S. J. van Harmelen wrote:
> Hi Chandra,
> 
> I hope you can answer this question, but of course I'll be very happy if
> anyone on this list can answer my question.
> 
> I just replaced a faulty RAID controller in an MD3000 enclosure. Now
> after enabling it, I can't see it in the multipath driver (mutlipath
> -ll). Not even after restarting the multipath-tools (version 0.4.8)...
> 
> So what should I restart so that it sees the new controller? I rather
> not restart the host if possible...
> 

Do you see the disks ? (doing a lsscsi would show it). I guess not.

If not, you need to probe/hotplug the disks first

ho,
# echo "- - -" > /sys/class/scsi_host/host${host_no}/scan
  ## the three -'s are for wildcards for channel, id and LUN.

If you don't know the "host_no", do it on for all the hosts under
scsi_host, it will not harm anything.

If you have multipathd running when you run the "echo" above you would
see all the dm devices when it completes (or soon thereafter).

You don't need to reboot the server.

> Thanks!!
> 
> Sander
> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
