From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Re: Problems with path groups in multipath-tools
Date: Fri, 25 Feb 2005 10:07:43 -0500
Message-ID: <87f94c3705022507074134a792@mail.gmail.com>
References: <20050224210918.GA10496@debian.mydomain.bogus>
	<20050225125613.GA6076@debian.mydomain.bogus>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050225125613.GA6076@debian.mydomain.bogus>
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

Your problem is the very first line of your script

#/bin/sh

should be

#!/bin/sh

Note the missing ! in your line.

#! is a magic sequence to Liunx/UNIX to run the program as a script. 
The interpreter is whatever is on the rest of the line.

ie. #!/bin/perl is for a perl script.

Greg
On Fri, 25 Feb 2005 14:56:13 +0200, Juha Koivisto wrote:
> I'm not sure if my previous message is going to make it to the list (by
> now it hasn't yet, at least according to the web archive), but I solved
> my problem already. It turns out that in order to use a shell script as
> prio_callout (in multipath.conf), the command needs to be explicitly
> executed with /bin/sh.
> 
> This works (at least for me):
> 
> /etc/multipath.conf:
> ---cut---
> devices {
>         device {
>                 vendor                  "DGC     "
>                 product                 "*"
>                 path_grouping_policy    group_by_prio
>                 prio_callout            "/bin/sh /usr/local/sbin/get_path_prio %n"
>                 #getuid_callout         "/sbin/scsi_id -g -s /block/%n"
>                 #path_checker           emc_clariion
>                 path_selector           "round-robin 0"
>                 hardware_handler        "1 emc"
>         }
> }
> ---cut---
> 
> /usr/local/sbin/get_path_prio:
> ---cut---
> #/bin/sh
> 
> PATH=/bin:/usr/bin
> 
> prio=1
> if [ -e /sys/block/$1/device ]; then
>         target=`ls -l /sys/block/$1/device | tr / "\n" | grep target.:.:`
>         if [ -e /sys/class/fc_transport/$target/port_name ]; then
>                 id=`cut -c 10 < /sys/class/fc_transport/$target/port_name`
>                 case $id in
>                         0 | 1 | 2 | 3 )
>                                 prio=1
>                                 ;;
>                         8 | 9 | a | b | A | B )
>                                 prio=2
>                                 ;;
>                 esac
>         fi
> fi
> 
> echo $prio
> ---cut---
> 
> I don't know if I should use emc_clarion as path_checker (it sees the
> non-active paths as "ready", while the default readsector0 reports them
> as faulty), but I guess that's not very important right now.
> 
> Please Cc: me in replies, I'm not subscribed to the list.
> 
> --
> Juha.Koivisto@hut.fi
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
