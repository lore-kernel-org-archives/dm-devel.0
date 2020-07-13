From: Martin Wilck <mwilck@suse.com>
Subject: Re: [lvm-devel] master - multipathd: fix fd leak when
 iscsi device logs in
Date: Mon, 13 Jul 2020 21:59:43 +0200
Message-ID: <f818352533682ae13fee17eb945fc2c9f62d15cd.camel@suse.com>
References: <6eb10725-456f-de68-e927-1f5a9771c16c@huawei.com>
	<86d8307c-1747-2254-4f87-fac36f0d51ca@redhat.com>
	<0d26c9f6-4379-f201-a9a5-839bddef3f25@huawei.com>
	<92db2c49d0ddbbc385c6a14ef3d99a54457b908e.camel@suse.com>
	<b482dfdb-a40b-e523-1dcc-d37ddc4fc399@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b482dfdb-a40b-e523-1dcc-d37ddc4fc399@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong@huawei.com, dm-devel@redhat.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

On Mon, 2020-07-13 at 11:56 +0200, Zdenek Kabelac wrote:
> 
> > @Zdenek, do we have to protect every libdm call, or is it
> > sufficient
> > to protect only dm_task_run(), as lixiaokeng suggested?
> > 
> 
> Hi
> 
> It's actually hard to answer it in a simple way.
> Several properties are held in library static variables.
>
> ...
>
> As for the issue of keeping control_fd open - there should be a
> synchronized 
> call of dm_hold_control_dev(0/1) -  see the codebase of  dmeventd.c
> in lvm2 
> code base - how we solve the control_fd handling.

I've made an assessment of the libdm calls that multipath-tools use.

Most of them are trivial getters and setters and need no locking,
because they don't operate on any static or global data structures.

The exceptions I found are are listed here:

dm_driver_version
dm_hold_control_dev
dm_is_dm_major
dm_lib_exit
dm_lib_release
dm_log_init
dm_log_init_verbose
dm_task_create
dm_task_run
dm_task_set_cookie
dm_udev_set_sync_support
dm_udev_wait

The reported race around _control_fd could probably be fixed simply
by calling dm_hold_control_dev() and dm_driver_version() early on e.g.
via pthread_once(), because dm_driver_version() calls dm_task_create()
and dm_task_run(), and thus implicitly initializes the _control_fd.
(libmultipath currently doesn't do these calls in the right order).
This should also avoid the need for locking dm_is_dm_major() (access to
_bitset) and dm_task_create (check_version()). The early init function
could also call dm_log_init(), dm_log_init_verbose(), and
dm_udev_set_sync_support(), setting up the libdm parameters once and
for all.

However, there are other possible races, as you noted. Mainly related
to manipulating the node_ops stack - this concerns dm_task_run(),
dm_udev_wait(), dm_lib_release(), dm_lib_exit(). I'm uncertain about 
dm_task_set_cookie(). I suppose it doesn't need protecting, but I tend
to be on the safe side.

Anyway, that's my summary: the 4 or 5 functions mentioned in the
previous paragraph would need wrapping under a lock. The rest can be
handled by making sure the initialization is made early on, and only
once.

Comments welcome.

Regards
Martin
