From: Juha Koivisto <Juha.Koivisto@hut.fi>
Subject: Re: Re: Problems with path groups in multipath-tools
Date: Fri, 25 Feb 2005 19:10:35 +0200
Message-ID: <20050225171035.GA8328@debian.mydomain.bogus>
References: <20050224210918.GA10496@debian.mydomain.bogus>
	<20050225125613.GA6076@debian.mydomain.bogus>
	<87f94c3705022507074134a792@mail.gmail.com>
	<20050225163117.GA8151@debian.mydomain.bogus>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050225163117.GA8151@debian.mydomain.bogus>
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

[This is a repost of my original message which didn't seem to go to
the list (apologies if it actually did). The problem, which turned out
to be an embarrassing blindness to a missing "!", has been solved
already, but this might still contain some useful information and/or
bug reports, so here it goes.

Again, please Cc: replies to me, as I'm not on the list (yet - maybe
I should...)]

-----

Sorry if this is slightly off-topic for dm-devel, I wasn't sure if there
is a better list for the multipath userspace tools.

Anyway, for the last couple of days I've been trying to get a multipath
setup running, and while it seems I got most of the other problems sorted
out, I'm now stuck at getting the path groups right. [Solved now; see
script posted earlier in this thread (but add the missing "!")]

First, our hardware and fabric topology:
  - 2 Emulex LP9002L HBA's
  - EMC CX300 (two storage processors, one of them active and the other
    standby (can't access the disks); two FC ports each)
  - one path to each of the four ports (each HBA sees one active and
    one standby port through its own FC switch)

And software:
  - kernel 2.6.11-rc4 with patches 00003 through 00010 from
    http://sources.redhat.com/dm/ applied (00001 and 00002 were already
    in the rc4 kernel); dm_multipath and dm_emc modules loaded
  - lpfc driver v8.0.24 from http://sourceforge.net/projects/lpfcxxxx/
  - multipath-tools v0.4.2 (23/01, 2005) from the debian package

The problem:

I would (obviously) want to put the active paths (which are sda and sdd
at the moment) into one group, and the standby paths (currently sdb and
sdc) into another.

Unfortunately, with this combination of hardware and drivers, all paths
report the same node_name and serial number, so grouping by those isn't
working. It seems that the necessary information would in theory be
available with a patched /sbin/scsi_id (I remember reading about it
here, but has the patch been released yet?)

Until then the only way seems to be writing a prio_callout script that
would examine the port_name of the corresponding fc_transport target in
sysfs (giving the SP port WWN which is the only uniquely identifying
piece of information that I could find):

$ cat /sys/class/fc_transport/target*/port_name
0x5006016130209865
0x5006016830209865
0x5006016930209865
0x5006016030209865

Here, if the eighth digit is 0 or 1, the path is on storage processor A;
if 8 or 9, it's on storage processor B. (I believe this numbering scheme
is universal for the EMC CX?00 series; in the higher-end models with more
ports the numbers would be 0/1/2/3 and 8/9/a/b if I'm not mistaken.)

[broken script deleted]

Apart from the script, multipath seems to be doing something strange
when using group_by_prio. This is what I get with no multipath.conf:

# multipath -d -v 2 -p group_by_prio
Unknown page code '0xc0'
Unknown page code '0xc0'
Unknown page code '0xc0'
Unknown page code '0xc0'
create: 36006016024601200ea747d273d7fd911
[size=1 TB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [first]
  \_ 0:0:0:0 sda  8:0     [ready ]
  \_ 0:0:1:0 sdb  8:16    [ready ]
  \_ 1:0:1:0 sdd  8:48    [ready ]
\_ round-robin 0 
  \_ 1:0:0:0 sdc  8:32    [ready ]

(The "Unknown page code" messages are printed by /sbin/scsi_id which
doesn't support the command that multipath is trying to use for EMC
hardware).

So the paths get grouped three and one - I would understand each path
in its own group, or all in one, or the intended two and two, but this
I can't figure out. Judging by the debug output [see below], it would
appear to be a bug in the multipath tool.

[Also note that all paths are marked ready, even though in reality half
of them are failing. Below is the output when using the readsector0
path_checker instead of the default emc_clariion.] This also happens
with an empty "devices { }" section, so having that in the config file
at all masks out the built-in defaults. Not sure if this is a bug or a
feature.

# multipath -d -v 2 -p group_by_prio     
create: 36006016024601200ea747d273d7fd911
[size=1 TB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
  \_ 0:0:0:0 sda  8:0     [ready ]
  \_ 0:0:1:0 sdb  8:16    [faulty]
  \_ 1:0:1:0 sdd  8:48    [ready ]
\_ round-robin 0 
  \_ 1:0:0:0 sdc  8:32    [faulty]


[Deleted lengthy debug output (of multipath-tools compiled with
DEBUG=1) which is irrelevant now that the actual problem in the script
was found. It did show, though, that prio = 1 for all of the above
paths, which still end up in two groups. I can post it again if someone
really wants to see it.]

-- 
Juha.Koivisto@hut.fi
