From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Naming of dm-multipath hardware handler modules
Date: Wed, 01 Aug 2007 11:39:13 -0500
Message-ID: <46B0B731.1070601@cs.wisc.edu>
References: <1185913012.4392.46.camel@linux-cxyg>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1185913012.4392.46.camel@linux-cxyg>
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

Dave Wysochanski wrote:
> Do we have an agreed upon scheme?
> 
> I noticed in 2.6.23-rc1, the RDAC module is named "dm-mpath-rdac.ko",
> but the source file is "dm-rdac.c".  Should we be naming things

Are you sure about that? In linus's tree it is named dm-mpath-rdac.c. 
The module that is created is named dm-rdac.ko.

> "dm-mpath-hwhname" everywhere?  If so, should we rename dm-emc?
> 
> I was not sure exactly what was correct for the HP handler.  Currently
> it follows the dm-emc scheme, which is probably wrong.
> 

Alasdair, initially wanted the modules and file names to have dm-mpath 
prefixes, but userspace for emc is already passing in "emc" and 
dm_get_hw_handler does request_module("dm-%s", name) and 
__find_hw_handler_type does strcmp(name, hwhi->hwht.name).

So we ended up doing a partial conversion leaving userspace alone, but 
changing the filenames to what Alasdair wanted. So rdac got the source 
filename dm-mpath-rdac.c, but its module gets the name dm-rdac.ko.

So yeah, I forgot about that in the review, and instead of

obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o

you should do

dm-hw-objs	:= dm-mpath-hw.o

......


obj-$(CONFIG_DM_MULTIPATH_HP_SW) += dm-hp-sw.o

In the Makefile, and the source filename for should be dm-mpath-hp-sw.c.

And dm-emc.c should probably be changed, although we could probably do 
it after the logical unit follow-over cap patch is cleaned up and merged.
