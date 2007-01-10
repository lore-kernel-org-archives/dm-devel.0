From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: multipath's "-l" option behaves differently from "-ll" -
	for blacklisted devices
Date: Wed, 10 Jan 2007 15:52:49 +0530
Message-ID: <20070110102249.GA31476@amitarora.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
Cc: shenlinf@cn.ibm.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Hello,

A little bit of background first...

If we have blacklisted devices in /etc/multipath.conf, "multipath -l"
output looks like this (please note "#"s below) :
# multipath -l
mpath2 () dm-4 ,
[size=15G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:# -   #:#   [active][undef]
 \_ #:#:#:# -   #:#   [active][undef]
mpath1 () dm-1 ,
[size=15G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:# -   #:#   [active][undef]
 \_ #:#:#:# -   #:#   [active][undef]
mpath3 () dm-7 ,
[size=15G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:# -   #:#   [active][undef]
 \_ #:#:#:# -   #:#   [active][undef]


And, for these blacklisted devices, "multipath -ll" gives full output
(i.e. no "#"s in the result) :
# multipath -ll
mpath2 () dm-4 IBM,1724-100  FAStT
[size=15G][features=0][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
 \_ 1:0:1:2 sdh 8:112 [active][ready]
mpath1 () dm-1 IBM,1724-100  FAStT
[size=15G][features=0][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
 \_ 1:0:1:1 sdg 8:96  [active][ready]
mpath3 () dm-7 IBM,1724-100  FAStT
[size=15G][features=0][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:0:3 sde 8:64  [active][ready]
 \_ 1:0:1:3 sdi 8:128 [active][ready]

From the source code we can see that in both cases (-l and -ll),
path_discovery() and get_dm_mpvec() get called. The only difference is
that -ll will result in a call to update_paths() in get_dm_mpvec(),
after multipath maps have been disassembled/discovered.

The question is that, is this behavior intended, a bug or a "feature" as
a result of the design of the tool ? And, does it make sense to keep the
behavior identical for -l and -ll options (of multipath tool) incase of
blacklisted devices ?

Thanks!
--
Regards,
Amit Arora
