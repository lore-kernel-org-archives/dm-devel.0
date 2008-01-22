From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Root device multipathed host freeze with the latest
 upstream multipath-tools package
Date: Tue, 22 Jan 2008 13:14:36 -0500 (EST)
Message-ID: <20080122.131436.85415012.k-ueda@ct.jp.nec.com>
References: <7026BCCA258BA2438F885772CA0B431310523ACD@exbtc01.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7026BCCA258BA2438F885772CA0B431310523ACD@exbtc01.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: marting@netapp.com
Cc: Ritesh.Sarraf@netapp.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Martin,

Thank you for your testing.
Please see my comments below.

On Tue, 22 Jan 2008 21:56:13 +0530, "Sarraf, Ritesh" wrote:
> Hi Kiyoshi,
>  
> I took the latest upstream multipath-tools package (Jan 15, 2008) and
> installed it on my RHEL 5.1 host to verify the libprio fix. To simulate
> the FCP path faults, I ran your script (as attached in the mail) which
> alternately offlined/onlined the corresponding SCSI paths of the root dm
> device in the syfs. Listing my observations below:
>  
> 1) The freeze was still reproducible. On checking the sysrq dumps (as
> attached), I could see it was the script itself i.e. test.sh which seems
> to have stalled on the exec () system call perhaps waiting for inode
> write out for updated access time (the script resides on my root dm
> device itself). As suggested by you in the bugzilla, I remounted the
> root device using the noatime option and then reran the script - I have
> not hit the freeze yet. Is this the expected behavior? 

As for your script, it is the expected behavior.
I found that you added some sleep commands to my original script
posted by the following email.

    http://marc.info/?l=dm-devel&m=119465024621783&w=2

sleep is not shell build-in command, so need to access the root device.
I guess that is the reason of the freeze.

Please retest using a script doesn't include any sleep command or
your fault injection method.
If you need to sleep anyway, empty while loop like below might be used
though you have to change the '1000000' depending on your system:
    i=0
    while [ $i -lt 1000000 ]; do
        i=$(($i + 1))
    done


> 2) With the latest upstream multipath-tools package, "multipath -ll"
> displays all paths with the same priority - I am not able to prioritize
> paths into primary/secondary despite the normal group_by_prio setting.
> Does the libprio fix alter the behavior here?

The keyword of libprio setting is "prio", and the name of the netapp
prioritizer is "netapp".
So you need to change your multipath.conf like this:

    From: prio_callout    "/sbin/mpath_prio_netapp /dev/%n"
    To:   prio            "netapp"

Thanks,
Kiyoshi Ueda
