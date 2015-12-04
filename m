From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Modern device mapper module makes problems for dump
	analysis
Date: Thu, 3 Dec 2015 20:36:46 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512032033060.23305@file01.intranet.prod.int.rdu2.redhat.com>
References: <565DA1FD.3010804@linux.vnet.ibm.com>
	<20151203193129.GA5264@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151203193129.GA5264@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, dm-devel@redhat.com, Alexey Ishchuk <aishchuk@linux.vnet.ibm.com>
List-Id: dm-devel.ids



On Thu, 3 Dec 2015, Mike Snitzer wrote:

> On Tue, Dec 01 2015 at  8:34am -0500,
> Alexey Ishchuk <aishchuk@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > in the modern device mapper Linux kernel module the data structure
> > struct dm_table is declared more than once. One of those
> > declarations is the real structure definition and the other are
> > dummy definitions. This coding manner makes serious problems for the
> > Linux kernel dump analysis with crash utility using custom EPPIC
> > language scripts and even the dminfo built-in crash extension does
> > not work with the dumps. The problem occurs because the crash
> > utility tries to expose to the EPPIC language scripts a dummy
> > structure definition that contains no required fields.
> > 
> > I would like to get to know, why do we need more than one struct
> > dm_table declarations in the kernel module? Is it possible to
> > improve the device mapper kernel module code to have the only one
> > struct dm_table declaration to allow kernel dumps to be analyzed
> > using custom scripts?
> 
> The dm.c definition is:
> 
> /*
>  * A dummy definition to make RCU happy.
>  * struct dm_table should never be dereferenced in this file.
>  */
> struct dm_table {
>         int undefined__;
> };
> 
> As you can see in the block comment above this dummy definition is
> purely to "make RCU happy"...
> 
> We'll need to research how/if we can avoid such hacks (and still have
> RCU function as needed).

The function __rcu_dereference_check does:
((typeof(*p) __force __kernel *)(________p1));

--- and that typeof(*p) will not compile if the structure pointerd to by p 
isn't defined. You could change "typeof(*p) *" to "typeof(p)" and it will 
compile, but I don't know what to do with the __force and __kernel flags.

Mikulas


> But short of eliminating the dummy definition, have you tried using the
> crash utility's 'set scope <text_address>' capability to force the use
> of the dm-table.c definition? e.g.:
> 
> crash> mod -s dm_mod
>      MODULE       NAME                     SIZE  OBJECT FILE
> ffffffffa0013640  dm_mod                 110592  /lib/modules/4.4.0-rc1.snitm+/kernel/drivers/md/dm-mod.ko
> 
> crash> struct dm_table
> struct dm_table {
>     int undefined__;
> }
> SIZE: 4
> 
> crash> set scope dm_table_create
> scope: ffffffffa0005b30 (dm_table_create)
> 
> crash> struct dm_table
> struct dm_table {
>     struct mapped_device *md;
>     unsigned int type;
>     unsigned int depth;
>     unsigned int counts[16];
>     sector_t *index[16];
>     unsigned int num_targets;
>     unsigned int num_allocated;
>     sector_t *highs;
>     struct dm_target *targets;
>     struct target_type *immutable_target_type;
>     unsigned int integrity_supported : 1;
>     unsigned int singleton : 1;
>     fmode_t mode;
>     struct list_head devices;
>     void (*event_fn)(void *);
>     void *event_context;
>     struct dm_md_mempools *mempools;
>     struct list_head target_callbacks;
> }
> SIZE: 304
> 
