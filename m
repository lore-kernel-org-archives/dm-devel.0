From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: Re: General and configuration questions
Date: Fri, 28 May 2010 19:23:38 -0400
Message-ID: <230ED15F81AFD3409345FFA4E565F0E50A978B57@NDHV3000.na.corp.mckesson.com>
References: <230ED15F81AFD3409345FFA4E565F0E50A978AA3@NDHV3000.na.corp.mckesson.com>
	<20100528221325.GA29567@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
Content-class: urn:content-classes:message
In-reply-to: <20100528221325.GA29567@us.ibm.com>
References: <230ED15F81AFD3409345FFA4E565F0E50A978AA3@NDHV3000.na.corp.mckesson.com>
	<20100528221325.GA29567@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

 

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Malahal Naineni
Sent: Friday, May 28, 2010 6:13 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] General and configuration questions

Allen, Jack [Jack.Allen@mckesson.com] wrote:
>    Hello:
>            I have a system with 2 paths to the SAN which is HITACHI
HP. The
>    output of multipath -ll is:
> 
>    mpath2 (360060e8005491000000049100000700a) dm-1 HP,OPEN-V
>    [size=10G][features=1 queue_if_no_path][hwhandler=0][rw]
>    \_ round-robin 0 [prio=2][active]
>     \_ 3:0:0:1 sdc 8:32  [active][ready]
>     \_ 4:0:0:1 sde 8:64  [active][ready]
>    mpath1 (360060e80054910000000491000007003) dm-0 HP,OPEN-V
>    [size=10G][features=1 queue_if_no_path][hwhandler=0][rw]
>    \_ round-robin 0 [prio=2][active]
>     \_ 3:0:0:0 sdb 8:16  [active][ready]
>     \_ 4:0:0:0 sdd 8:48  [active][ready]
> 
>            If I run multipathd -k and do show config, there is a lot
of out
>    put but I think the key things are:
> 
>    defaults {
>            verbosity 2
>            polling_interval 10
>            path_grouping_policy multibus
>            failback 5
>            rr_min_io 10
>            no_path_retry 5
>            user_friendly_names yes
>            bindings_file /etc/multipath.bindings
>    }
> 
>    devices {
>            LOTS OF DEVICE ENTRIES.
> 
>            device {
>                    vendor (HITACHI|HP)
>                    product OPEN-.*
>                    path_checker tur
>                    failback immediate
>                    no_path_retry 12
>                    rr_min_io 1000
>            }
>    }
> 
>            The device entry for the SAN has rr_min_io set to 1000. I
added
>    rr_min_io 10 in the default, but per the man page for
multipath.conf
>    entries in the defaults will only be used if they do not appear
other
>    places.
> 
>    Q1) If I want to over ride the rr_min_io value in the
devices/device
>    section can I just add a devices/device section in
/etc./multipath.conf
>    with the things I want to change or do I have to duplicate
everything that
>    is in the built-in devices/device entry?

I have seen some values not specified in the multipath.conf
devices/device section are picked up from the "default" table (don't
remember if this was internal default table or config default table)
instead of "controller table" (aka built-in devices/device entry
values).  So, the best is to duplicate everything from the internal
controller table.

>    Q2) How can I determine the best value for rr_min_io?
>            I assume whom ever added the HITACHI|HP devices/device
built-in
>    entry decide on the value
>            of 1000 for a reason. Maybe they did benchmarks or maybe
they just
>    copied another entry
>            that was some what like what they needed and changed the
vendor
>    and product.

I doubt if they carried out a benchmark, but possible! At one time the
default used to be 1000. I think it is 1 now with request based
multipath.

Thanks, Malahal.
================

Thanks for the quick reply.

	OK, I duplicated the information and changed rr_min_io to 100 so
I could tell my entry from the built-in. Ran multipathd -k and did
reconfigure and show config. The original built-in entry does not show
up where it use to. The entry I added shows up as the first device entry
in devices with the rr_min_io value I specified. So it would seem if you
specify a vendor/product combination that is just like a built-in, the
built-in is either modified and moved to the top or is not shown at all.
It would be nice if the output of show config would indicate the
built-in entries with a comment and/or the ones found in the
multipath.conf file. It would also be nice to indicate when a value from
the defaults is being used by a device entry. Maybe this has been done
on later versions of multipathd.

	Then I lowered rr_min_io to 10 and did reconfigure and show
config and the parameter does not show up at all. The device entry is
still at the top of the devices, just does not have the rr_min_io
parameter at all. So I went through several values for rr_min_io stating
at 100 and decreasing it by 10 each time and then doing reconfigure and
show config. When it got to 10 again the parameter did not show up. So I
increased it to 11 and it showed up. So there must be some min/max value
that multipath will not allow setting the parameter to and if it is not
within that range, it just ignores it all together.

-----
Jack Allen
