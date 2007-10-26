From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Fdisk Multipath Disks on NetApp / IBM N series SAN
	with intention for Oracle 10G RAC OCR and Voting Disks
Date: Fri, 26 Oct 2007 12:30:00 -0500
Message-ID: <20071026173000.GI27605@ether.msp.redhat.com>
References: <A5CA8967E48A23468EE061D2E5AAAE760207A6B5@gexcnt05.gl.ad.newsquest.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A5CA8967E48A23468EE061D2E5AAAE760207A6B5@gexcnt05.gl.ad.newsquest.co.uk>
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

On Thu, Oct 25, 2007 at 01:28:29PM +0100, Charles Batchelor wrote:
>    Hi,
> 
> 
> 
>    I am having a problem with a correct method for fdisk raw partitions in
>    preparation for Oracle OCR. I know that you cant fdisk the /dev/mapper or
>    /dev/dm-1 disks directly. Currently we have the following setup
> 
> 
> 
>    mpath11 (360a98000433543364734454a6f533061)</ span>
> 
>    [size=300 MB][features="1 queue_if_no_path"][hwhandler="0"]
> 
>    \_ round-robin 0 [prio=8][active]
> 
>     \_ 3:0:0:1 sdb 8:16  [active][ready]
> 
>     \_ 4:0:0:1 sdl 8:176 [active][ready]
> 
>    \_ round-robin 0 [prio=2][enabled]
> 
>     \_ 3:0:1:1 sdg 8:96  [active][ready]
> 
>     \_ 4:0:1:1 sdq 65:0  [active][ready]
> 
> 
> 
>    I have fdisk'ed the sbd (underlying) disk and rebooted to bring multipath
>    into sync.
> 
> 
> 
>    /dev/mpath now has the following entries
> 
> 
> 
>    lrwxrwxrwx   1 root root    7 Oct 25 11:53 mpath11 -> ../dm-0
> 
>    lrwxrwxrwx   1 root root    7 Oct 25 11:53 mpath11p1 -> ../dm-9
> 
> 
> 
>    /dev/mapper
> 
> 
> 
>    brw-rw----   1 oracle oinstall 253,  4 Oct 25 11:53 mpath11
> 
>    brw-rw----   1 oracle oinstall 253,  5 Oct 25 11:53 mpath11p1
> 

Were the snippets from /dev/mpath and /dev/mapper taken from different machines?
If /dev/mapth11 points to /dev/dm-0 on one machince, then /dev/mapper/mpath11
should have a minor number of 0 on that machine.
 
> 
>    I have tried addressing the
> 
> 
> 
>    I have specified the raw devices /etc/sysconfig/rawdevices using the major
>    minor id's
> 
> 
> 
>    /dev/raw/raw5 253 5
> 
> 
> 
>    However when trying to exchange data between the shared luns
> 
> 
> 
>    Dd if=/etc/hosts of=/dev/raw/raw5 I am getting an error.
> 
> 
> 
>    However if I do the following dd if=/etc/hosts of=/dev/mpath/mpath11p1 the
>    transfer works successfully.
> 
> 
> 
>    This has come about as each of the servers is reporting the /mpath's back
>    as different numbers. The /dev/dm-1 etc are all fine, how do I bring the
>    mpath back into sync, e.g. mpath1 across all boxes. Also am I going about
>    things the right way or fundamentally flawed?
> 
There is never any guarantee that /dev/dm-X on one machine will be the same as
/dev/dm-X on another machine. So, if you're setting the raw devices by
major/minor numbers, and expecting 253:5 on one machine to be the same device
as 253:5 on another machine, that simply won't work.

The user_friendly_names for multipath devices (mpath0, mpath1, etc.) are set by the file /var/lib/multipath/bindings. If you copy this file from one machine to
all your other machines, then all previously seen multipath devices will have
the same names on all the machines. (i.e. /dev/mapper/mpath11p1 on one node will
be the same device as /dev/mapper/mpath11p1 on another node)

Another way to guarantee that all the names are the same on all the machines
is to use make LVM2 devices on top the the multipath devices, and use CLVM to
manage them.

-Ben

> 
>    Regards
> 
> 
> 
>    Charles Batchelor
> 
> 
> 
>    Charles Batchelor
> 
>    Senior Technical Specialist
> 
>    + Herald and Times Group
> 
>            200 Renfield Street
> 
>            Glasgow G2 3QB
> 
>            Scotland
> 
>    (   Tel:  0141 - 302 7011
> 
>           Fax: 0141 - 302 7901
>    :  Email:  charles.batchelor@glasgow.newsquest.co.uk
> 
> 
> 
>    Please take the time to fill out the IT Satisfaction survey form @
>    [1]http://intranet/informationtechnology/itsurvey.shtml
> 
> 
> 
> 
> 
>  --------------------------------------------------------------------
>  This email has been scanned for viruses and other threats  using Newsquest's Ironport email filters
> 
>  This e-mail, including any attachment, is private and confidential.
>  It should not be read, copied, disclosed or otherwise used by any person other than the intended recipient(s).
>  If you have received this e-mail in error, please notify the sender immediately.
>  Newsquest reserves the right to monitor e-mails in accordance with the Telecommunications (Lawful Business Practice)
>  (Interception of Communications) Regulations 2000.
> 
>  Newsquest Limited.
>  Registered in England, number 3105111 .  Registered office: 58 Church Street, Weybridge, Surrey KT13 8DP
>  --------------------------------------------------------------------
> 
> References
> 
>    Visible links
>    1. http://intranet/informationtechnology/itsurvey.shtml

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
