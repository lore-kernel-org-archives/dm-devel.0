From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] [RFC] persistent readable names
Date: Wed, 05 Oct 2005 23:27:38 +0200
Message-ID: <1128547659.6140.40.camel@zezette>
References: <4343DFDC.2020701@redhat.com> <20051005150923.GC6195@free.fr>
	<20051005180721.GA22387@us.ibm.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051005180721.GA22387@us.ibm.com>
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


> I haven't recently looked at dm or dm multipath naming, but dm and dm
> multipath should not have a different naming scheme outside of udev.
> 
Do you mean we should stop naming the maps after aliases ?

If so, there are quite a few glitches ahead : the multipath configurator
and daemon will have a hard time playing with those meaningful aliases.

They are used for :
1) printing meaningful map names (multipath -l, multipathd -k"show
maps")
2) limiting the scope (multipath -l mymap, multipathd -k"del map mymap")
3) naming /dev/mapper/ nodes


I'm all in favor of keeping the naming policies in a central place
(udev). But can we safely lose (1) and (2) ?


FYI, DM currently does its best to circumvent udev. Most distro ship
with an "ignore" rule sticked to KERNEL=="dm-*".

Recent upstream multipath-tools also play by that rule : /dev/mapper/ is
the only place to find and use multipath maps. /dev/dm-* are also
created but only because I couldn't find how to avoid it while still
having RUN and PROGRAM directives working.

multipath rules are :

# lookup the devmap name
ACTION=="add", SUBSYSTEM=="block", KERNEL=="dm-*", \
        PROGRAM="/sbin/dmsetup -j %M -m %m --noopencount --noheadings -c
-o name info"

# take care of devmap partitioning
ACTION=="add", SUBSYSTEM=="block", KERNEL=="dm-*", \
        RUN+="/sbin/kpartx -a /dev/mapper/%c"

# insert new paths in multipath topology
ACTION=="add", SUBSYSTEM=="block", KERNEL!="dm-*", \
        RUN+="/sbin/multipath -v0 %r/%k"


Can/will this "outlaw" behaviour persist ?

> udev now has persistent naming, and probably could or should have a dm_id
> (dm_id could run scsi_id on a single path, unless dm is passing down scsi
> ioctl's). The udev persistent naming scheme is not intuitive (i.e.  not
> easy for people to create and use).
> 
Are you sure you mean persistent like "stable enumeration accross
reboots, and even accross a cluster", or simply persistent like
"predictable" ?

Personnaly, I fail to see how to achieve persistance through udev (1st
definition, the one PatrickC cares about). Do I miss something ?

That said, I agree it makes sense : a persistent (and reliable)
enumeration naming through a udev '%e'-like substitution would be a nice
and simple thing to use.

> Intuitive names could be built upon the persistent names as part of udev,
> like an alias, or if you could "match" a NAME, and have a new udev rule
> like:
> 
> 	NAME=="disk/by-id/foo" SYMLINK+="disk/by-simple/my-database"
> 
I fail to see how this can be done without 1 rule per multipath. 

Administrative scalability was the purpose of PatrickC's patch, ie no
admin-supplied aliases.

Regards,
cvaroqui
