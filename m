From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Re: [Report] crash tool cannot resolve struct
 dm_table properly
Date: Thu, 13 Apr 2017 17:53:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1704131751210.16044@file01.intranet.prod.int.rdu2.redhat.com>
References: <ed7ae3a8-f053-fb4b-8523-c09b8c725ed9@suse.com>
	<alpine.LRH.2.02.1704130727230.881@file01.intranet.prod.int.rdu2.redhat.com>
	<9b535371-b391-6d36-f83d-559d405ef870@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9b535371-b391-6d36-f83d-559d405ef870@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Ren <zren@suse.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Thu, 13 Apr 2017, Eric Ren wrote:

> Hi,
> 
> 
> On 04/13/2017 07:28 PM, Mikulas Patocka wrote:
> > 
> > On Thu, 13 Apr 2017, Eric Ren wrote:
> > 
> > > Hi Mikulas,
> > > 
> > > When inspecting on coredump with crash tool, I find that 'dm_table' cannot
> > > be
> > > resolved properly as follows:
> > > 
> > > ===
> > > crash> struct dm_table
> > > struct dm_table {
> > >      int undefined__;
> > > }
> > > SIZE: 4
> > > ===
> > > 
> > > Looks this issue is introduced by 83d5e5b (dm: optimize use SRCU and RCU)
> > > with
> > > this code:
> > > ===
> > > +/*
> > > + * A dummy definition to make RCU happy.
> > > + * struct dm_table should never be dereferenced in this file.
> > >   + */ +struct dm_table {
> > > + int undefined__;
> > > +};
> > > +
> > > ===
> > > 
> > > It stops me from looking into dm_table when analyzing coredump. Is there
> > > any
> > > workaround?
> > > or can be fixed somehow?
> > > 
> > > Regards,
> > > Eric
> > So, move dm_table definition to drivers/md/dm.h
> Thanks. So, are your going to fix this? Or should I test on your suggestion
> and send a patch if it works?
> 
> Regards,
> Eric
> > 
> > Mikulas
> > 
> 

Hi

It turned out that the RCU macros changed and the dummy definition is no 
longer needed. So, we can remove it.



From: Mikulas Patocka <mpatocka@redhat.com>

dm: remove dummy dm_table definition

This dummy structure definition was required for RCU macros, but it
doesn't seem to be required anymore, so delete it.

The dummy definition confuses the crash tool, see
https://www.redhat.com/archives/dm-devel/2017-April/msg00197.html

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -37,14 +37,6 @@ struct hash_cell {
 	struct dm_table *new_map;
 };
 
-/*
- * A dummy definition to make RCU happy.
- * struct dm_table should never be dereferenced in this file.
- */
-struct dm_table {
-	int undefined__;
-};
-
 struct vers_iter {
     size_t param_size;
     struct dm_target_versions *vers, *old_vers;
