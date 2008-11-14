From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [RFC][PATCH] Handle multipath paths in a path group properly
	during pg_init (was "RE: [dm-devel] DM does not activate the paths if there
	are more than one path in path group during failover")
Date: Fri, 14 Nov 2008 12:24:46 -0800
Message-ID: <1226694286.8998.104.camel@chandra-ubuntu>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	 <20081111005920.GN16649@agk.fab.redhat.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
	 <1226620138.8998.64.camel@chandra-ubuntu>
	 <20081114001205.GQ30569@agk.fab.redhat.com>
	 <1226689728.8998.76.camel@chandra-ubuntu>
	 <20081114193458.GV30569@agk.fab.redhat.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20081114193458.GV30569@agk.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Levy_Jerome <Levy_Jerome@emc.com>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, asson_ronald <asson_ronald@emc.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids


On Fri, 2008-11-14 at 19:34 +0000, Alasdair G Kergon wrote:
> On Fri, Nov 14, 2008 at 11:08:48AM -0800, Chandra Seetharaman wrote:
> > No, I "replaced" the "per-group" pg_init with "per-path" init.
> 
> Indeed, but I'm pointing out that the per-group initialisation was
> originally added for EMC and arguing that per-group initialisation
> and per-path initialisation are independent conceptually and the
> code may need to support both: adding one to deal with the problem
> reported here need not necessitate removing the other.

It was the case earlier. But Ed changed it (to send a mode select only
when needed) before I moved the emc code to be under SCSI Hardware
Handler. Later Hannes made it still better.

IOW, The EMC code in SCSI hardware handler is smart to find out if the
trespass/mode_select command need to be sent down the wire (they first
do a inquiry and if the state is "OWNED", they just return).

Hannes, MikeC, correct me if I am wrong.

> 
> Alasdair

