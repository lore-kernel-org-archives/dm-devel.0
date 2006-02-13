From: "Kevin Lyons" <klyons@novell.com>
Subject: Re: dm-multipath: multipath setup okay,nothing in
	/dev/disk/by-name
Date: Mon, 13 Feb 2006 09:54:56 -0700
Message-ID: <43F0495D.D2F3.0050.0@novell.com>
References: <57309.194.39.131.39.1139845883.squirrel@www.hcsd.de>
	<1139846514.7784.9.camel@zezette>
	<37637.194.39.131.39.1139847251.squirrel@www.hcsd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37637.194.39.131.39.1139847251.squirrel@www.hcsd.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: au@hcsd.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

>>> On Mon, Feb 13, 2006 at  8:14 am, in message
<37637.194.39.131.39.1139847251.squirrel@www.hcsd.de>, au@hcsd.de
wrote: 
> Hi,
> 
>> Please mention the distrib you report for.
>> It'll help get the right people get involved.
>> This area is heavily distrib (and distrib version) dependent.
> 
> SLES 9 SP2 (2.6.5-7.191-smp)
> multipath-tools-0.4.5-0.11
> 

On SLES, the symlinks are created by the udev system.  The symlinks are
created by a rule in the /etc/udev/udev.rules file similar to the
following:

KERNEL="dm-[0-9]*", PROGRAM="/sbin/devmap_name %M %m", NAME="%k"
SYMLINK="disk/by-name/%c"

You will probably want to make sure that you have udev installed and
running, and maybe test out that /sbin/devmap_name command to make sure
it works (%M it the major number for the dm device and %m is the minor
number)

Note that there should also be devices in the /dev/mapper directory
with the FC WWN name, iSCSI equivalent, or whatever you have specified
for the alias parameter in multipath.conf.

HTH

Kevin

> Thanks,
> 
> Stephan
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
