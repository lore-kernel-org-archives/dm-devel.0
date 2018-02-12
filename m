From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 5/5] multipathd: RFC add new polling
 dmevents waiter thread
Date: Mon, 12 Feb 2018 17:18:02 -0600
Message-ID: <20180212231802.GA14513@octiron.msp.redhat.com>
References: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
	<1518239251-29392-6-git-send-email-bmarzins@redhat.com>
	<1518292553.2937.44.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518292553.2937.44.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Feb 10, 2018 at 08:55:53PM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> thanks a lot for this. I have only a few minor nitpicks (see below).
> I suppose you've tested this already?

Yes. I do plan on doing some more testing after I look into making
libdevmapper support re-arming the polling interface and grabbing the
event number from the names listing, before I repost this without the
RFC tag. I was also thinking of trying out cmocka by mocking up a
device-mapper interface that let me test this code in isolation.

> =

> Regards
> Martin
> =

> On Fri, 2018-02-09 at 23:07 -0600, Benjamin Marzinski wrote:
> > The current method of waiting for dmevents on multipath devices
> > involves
> > creating a seperate thread for each device. This can become very
> > wasteful when there are large numbers of multipath devices. Also,
> > since
> > multipathd needs to grab the vecs lock to update the devices, the
> > additional threads don't actually provide much parallelism.
> > =

> > The patch adds a new method of updating multipath devices on
> > dmevents,
> > which uses the new device-mapper event polling interface. This means
> > that there is only one dmevent waiting thread which will wait for
> > events
> > on all of the multipath devices.  Currently the code to get the event
> > number from the list of device names and to re-arm the polling
> > interface
> > is not in libdevmapper, so the patch does that work. Obviously, these
> > bits need to go into libdevmapper, so that multipathd can use a
> > standard
> > interface.
> > =

> > I haven't touched any of the existing event waiting code, since event
> > polling was only added to device-mapper in version
> > 4.37.0.  multipathd
> > checks this version, and defaults to using the polling code if
> > device-mapper supports it. This can be overridden by running
> > multipathd
> > with "-w", to force it to use the old event waiting code.
> =

> Why use a command line option here rather than a config file option?

Mostly because it was faster, and I wanted to get to testing it. The
other reason is that I don't see any benefit for the work involved in
making this be changeable in

# multipathd reconfigure

However, we already have configuration settings that can't get changed
on reconfigure, so making this another one is not a big deal. I agree
that it is easier for users to change if it is a configuration setting,
but I'm hoping that this change will be invisible to users. If you would
prefer it as a configuration setting, I have no problem with changing
that.

> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/Makefile   |   3 +-
> >  multipathd/dmevents.c | 396
> > ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  multipathd/dmevents.h |  13 ++
> >  multipathd/main.c     |  58 +++++++-
> >  4 files changed, 461 insertions(+), 9 deletions(-)
> >  create mode 100644 multipathd/dmevents.c
> >  create mode 100644 multipathd/dmevents.h
> > =

> > diff --git a/multipathd/Makefile b/multipathd/Makefile
> > index 85f29a7..4c438f0 100644
> > --- a/multipathd/Makefile
> > +++ b/multipathd/Makefile
> > @@ -22,7 +22,8 @@ ifdef SYSTEMD
> >  	endif
> >  endif
> >  =

> > -OBJS =3D main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> > waiter.o
> > +OBJS =3D main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> > waiter.o \
> > +       dmevents.o
> >  =

> >  EXEC =3D multipathd
> >  =

> > diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> > new file mode 100644
> > index 0000000..a56c055
> > --- /dev/null
> > +++ b/multipathd/dmevents.c
> > @@ -0,0 +1,396 @@
> > +/*
> > + * Copyright (c) 2004, 2005 Christophe Varoqui
> > + * Copyright (c) 2005 Kiyoshi Ueda, NEC
> > + * Copyright (c) 2005 Edward Goggin, EMC
> > + * Copyright (c) 2005, 2018 Benjamin Marzinski, Redhat
> > + */
> > +#include <unistd.h>
> > +#include <libdevmapper.h>
> > +#include <sys/mman.h>
> > +#include <pthread.h>
> > +#include <urcu.h>
> > +#include <poll.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <linux/dm-ioctl.h>
> > +#include <errno.h>
> > +
> > +#include "vector.h"
> > +#include "structs.h"
> > +#include "structs_vec.h"
> > +#include "devmapper.h"
> > +#include "debug.h"
> > +#include "dmevents.h"
> > +
> > +#ifndef DM_DEV_ARM_POLL
> > +#define DM_DEV_ARM_POLL _IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD + 1,
> > struct dm_ioctl)
> > +#endif
> > +
> > +enum event_actions {
> > +	EVENT_NOTHING,
> > +	EVENT_REMOVE,
> > +	EVENT_UPDATE,
> > +};
> > +
> > +struct dev_event {
> > +	char name[WWID_SIZE];
> > +	uint32_t evt_nr;
> > +	enum event_actions action;
> > +};
> > +
> > +struct dmevent_waiter {
> > +	int fd;
> > +	struct vectors *vecs;
> > +	vector events;
> > +	pthread_mutex_t events_lock;
> > +};
> > +
> > +static struct dmevent_waiter *waiter;
> > +
> > +int dmevent_poll_supported(void)
> > +{
> > +	unsigned int minv[3] =3D {4, 37, 0};
> > +	unsigned int v[3];
> > +
> > +	if (dm_drv_version(v))
> > +		return 0;
> > +
> > +	if (VERSION_GE(v, minv))
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +
> > +int alloc_dmevent_waiter(struct vectors *vecs)
> > +{
> > +	if (!vecs) {
> > +		condlog(0, "can't create waiter structure. invalid
> > vectors");
> > +		goto fail;
> > +	}
> > +	waiter =3D (struct dmevent_waiter *)malloc(sizeof(struct
> > dmevent_waiter));
> > +	if (!waiter) {
> > +		condlog(0, "failed to allocate waiter structure");
> > +		goto fail;
> > +	}
> > +	memset(waiter, 0, sizeof(struct dmevent_waiter));
> > +	waiter->events =3D vector_alloc();
> > +	if (!waiter->events) {
> > +		condlog(0, "failed to allocate waiter events
> > vector");
> > +		goto fail_waiter;
> > +	}
> > +	waiter->fd =3D open("/dev/mapper/control", O_RDWR);
> > +	if (waiter->fd < 0) {
> > +		condlog(0, "failed to open /dev/mapper/control for
> > waiter");
> > +		goto fail_events;
> > +	}
> > +	pthread_mutex_init(&waiter->events_lock, NULL);
> > +	waiter->vecs =3D vecs;
> > +
> > +	return 0;
> > +fail_events:
> > +	vector_free(waiter->events);
> > +fail_waiter:
> > +	free(waiter);
> > +fail:
> > +	waiter =3D NULL;
> > +	return -1;
> > +}
> =

> Nitpick: conventionally, an "alloc"-type function would return the
> pointer, and NULL on failure.

Is this a naming complaint, or an interface complaint?  I'm fine with
changing the names so they follow the lead of checkers and prio, i.e.
init_dmevents_waiter() and cleanup_dmevents_waiter(). The init and
cleanup functions for checkers and prio have the same returns as the
dmevent functions (well the init functions return 1 for failure, and I
can do that as well)

Since there is only ever going to be one dmevent waiter thread running,
I'm not sure what the rest of multipathd gains by returning a pointer to
its data structure. It would be extra work to make multipathd store and
pass this data structure on calls to watch or unwatch devices, for no
benefit that I can see. If you see a good reason for doing this, I'm
open to being convinced otherwise.

I was originally going to make this allocation and deallocation happen
when starting and shutting down the thread, but I through that not doing
this would allow me to create and join the threads directly in child(),
like most of the other threads. Also it would allow me to initialize the
data structure without having to start a thread, which seemed useful
for unit testing.

> > +
> > +void free_dmevent_waiter(void)
> > +{
> > +	struct dev_event *dev_evt;
> > +	int i;
> > +
> > +	if (!waiter)
> > +		return;
> > +	pthread_mutex_destroy(&waiter->events_lock);
> > +	close(waiter->fd);
> > +	vector_foreach_slot(waiter->events, dev_evt, i)
> > +		free(dev_evt);
> > +	vector_free(waiter->events);
> > +	free(waiter);
> > +	waiter =3D NULL;
> > +}
> =

> Nitpick: Similarly, a "free" function typically takes the pointer to be
> freed as argument. =

> =

> > +
> > +static int arm_dm_event_poll(int fd)
> > +{
> > +	struct dm_ioctl dmi;
> > +	memset(&dmi, 0, sizeof(dmi));
> > +	dmi.version[0] =3D DM_VERSION_MAJOR;
> > +	dmi.version[1] =3D DM_VERSION_MINOR;
> > +	dmi.version[2] =3D DM_VERSION_PATCHLEVEL;
> > +	dmi.flags =3D 0x4;
> =

> What's the meaning of this flag? I couldn't find it in dm-ioctl.h
>

It is the DM_EXISTS_FLAG. It's defined in libdm/ioctl/libdm-iface.c in
the lvm2 source.  It is unconditionally set on all dm control ioctls
from libdevmapper by _do_dm_ioctl() (also in libdm/ioctl/libdm-iface.c).
I don't know the reason for this. I don't see anything that uses it in
driver/md/dm-ioctl.c, and I see that line in the libdm source has a
/* FIXME */ next to it. On the other hand, all I'm trying to do here is
run the same ioctl that libdevmapper would if it supported this command,
and there may well be a reason for it that I'm missing.
 =

> > +	dmi.data_start =3D offsetof(struct dm_ioctl, data);
> > +	dmi.data_size =3D sizeof(dmi);
> > +	return ioctl(fd, DM_DEV_ARM_POLL, &dmi);
> > +}
> > +
> > +/*
> > + * As of version 4.37.0 device-mapper stores the event number in the
> > + * dm_names structure after the name, when DM_DEVICE_LIST is called
> > + */
> > +static uint32_t dm_event_nr(struct dm_names *n)
> > +{
> > +	return *(uint32_t *)(((uintptr_t)(strchr(n->name, 0) + 1) +
> > 7) & ~7);
> > +}
> > +
> > +static int dm_get_events(void)
> > +{
> > +	struct dm_task *dmt;
> > +	struct dm_names *names;
> > +	struct dev_event *dev_evt;
> > +	int i;
> > +
> > +	if (!(dmt =3D libmp_dm_task_create(DM_DEVICE_LIST)))
> > +		return -1;
> > +
> > +	dm_task_no_open_count(dmt);
> > +
> > +	if (!dm_task_run(dmt))
> > +		goto fail;
> > +
> > +	if (!(names =3D dm_task_get_names(dmt)))
> > +		goto fail;
> > +
> > +	pthread_mutex_lock(&waiter->events_lock);
> > +	vector_foreach_slot(waiter->events, dev_evt, i)
> > +		dev_evt->action =3D EVENT_REMOVE;
> > +	while (names->dev) {
> > +		uint32_t event_nr;
> > +
> > +		if (!dm_is_mpath(names->name))
> > +			goto next;
> > +
> > +		event_nr =3D dm_event_nr(names);
> > +		vector_foreach_slot(waiter->events, dev_evt, i) {
> > +			if (!strcmp(dev_evt->name, names->name)) {
> > +				if (event_nr !=3D dev_evt->evt_nr) {
> > +					dev_evt->evt_nr =3D event_nr;
> > +					dev_evt->action =3D
> > EVENT_UPDATE;
> > +				} else
> > +					dev_evt->action =3D
> > EVENT_NOTHING;
> > +				break;
> > +			}
> > +		}
> > +next:
> > +		if (!names->next)
> > +			break;
> > +		names =3D (void *)names + names->next;
> > +	}
> > +	pthread_mutex_unlock(&waiter->events_lock);
> > +	dm_task_destroy(dmt);
> > +	return 0;
> > +
> > +fail:
> > +	dm_task_destroy(dmt);
> > +	return -1;
> > +}
> > +
> > +/* You must call update_multipath() after calling this function, to
> > + * deal with any events that came in before the device was added */
> > +int watch_dmevents(char *name)
> > +{
> > +	int event_nr;
> > +	struct dev_event *dev_evt, *old_dev_evt;
> > +	int i;
> > +
> > +	if (!dm_is_mpath(name)) {
> > +		condlog(0, "%s: not a multipath device. can't watch
> > events",
> > +			name);
> > +		return -1;
> > +	}
> > +
> > +	if ((event_nr =3D dm_geteventnr(name)) < 0)
> > +		return -1;
> > +
> > +	dev_evt =3D (struct dev_event *)malloc(sizeof(struct
> > dev_event));
> > +	if (!dev_evt) {
> > +		condlog(0, "%s: can't allocate event waiter
> > structure", name);
> > +		return -1;
> > +	}
> > +
> > +	strncpy(dev_evt->name, name, WWID_SIZE);
> > +	dev_evt->name[WWID_SIZE - 1] =3D 0;
> =

> Nitpick: It might be better to use strlcpy or snprintf here.

Sure.

> > +	dev_evt->evt_nr =3D event_nr;
> > +	dev_evt->action =3D EVENT_NOTHING;
> > +
> > +	pthread_mutex_lock(&waiter->events_lock);
> > +	vector_foreach_slot(waiter->events, old_dev_evt, i){
> > +		if (!strcmp(dev_evt->name, old_dev_evt->name)) {
> > +			/* caller will be updating this device */
> > +			old_dev_evt->evt_nr =3D event_nr;
> > +			old_dev_evt->action =3D EVENT_NOTHING;
> > +			pthread_mutex_unlock(&waiter->events_lock);
> > +			condlog(2, "%s: already waiting for events
> > on device",
> > +				name);
> > +			free(dev_evt);
> > +			return 0;
> > +		}
> > +	}
> > +	if (!vector_alloc_slot(waiter->events)) {
> > +		pthread_mutex_unlock(&waiter->events_lock);
> > +		free(dev_evt);
> > +		return -1;
> > +	}
> > +	vector_set_slot(waiter->events, dev_evt);
> > +	pthread_mutex_unlock(&waiter->events_lock);
> > +	return 0;
> > +}
> > +
> > +void unwatch_all_dmevents(void)
> > +{
> > +	struct dev_event *dev_evt;
> > +	int i;
> > +
> > +	pthread_mutex_lock(&waiter->events_lock);
> > +	vector_foreach_slot(waiter->events, dev_evt, i)
> > +		free(dev_evt);
> > +	vector_reset(waiter->events);
> > +	pthread_mutex_unlock(&waiter->events_lock);
> > +}
> > +
> > +static void unwatch_dmevents(char *name)
> > +{
> > +	struct dev_event *dev_evt;
> > +	int i;
> > +
> > +	pthread_mutex_lock(&waiter->events_lock);
> > +	vector_foreach_slot(waiter->events, dev_evt, i) {
> > +		if (!strcmp(dev_evt->name, name)) {
> > +			vector_del_slot(waiter->events, i);
> > +			free(dev_evt);
> > +			break;
> > +		}
> > +	}
> > +	pthread_mutex_unlock(&waiter->events_lock);
> > +}
> > +
> > +/*
> > + * returns the reschedule delay
> > + * negative means *stop*
> > + */
> > +
> > +/* poll, arm, update, return */
> > +static int dmevent_loop (void)
> > +{
> > +	int r, i =3D 0;
> > +	struct pollfd pfd;
> > +	struct dev_event *dev_evt;
> > +
> > +	pfd.fd =3D waiter->fd;
> > +	pfd.events =3D POLLIN;
> > +	r =3D poll(&pfd, 1, -1);
> > +	if (r <=3D 0) {
> > +		condlog(0, "failed polling for dm events: %s",
> > strerror(errno));
> > +		/* sleep 1s and hope things get better */
> > +		return 1;
> > +	}
> > +
> > +	if (arm_dm_event_poll(waiter->fd) !=3D 0) {
> > +		condlog(0, "Cannot re-arm event polling: %s",
> > strerror(errno));
> > +		/* sleep 1s and hope things get better */
> > +		return 1;
> > +	}
> > +
> > +	if (dm_get_events() !=3D 0) {
> > +		condlog(0, "failed getting dm events: %s",
> > strerror(errno));
> > +		/* sleep 1s and hope things get better */
> > +		return 1;
> > +	}
> > +
> > +	/*
> > +	 * upon event ...
> > +	 */
> > +
> > +	while (1) {
> > +		int done =3D 1;
> > +		struct dev_event curr_dev;
> > +		struct multipath *mpp;
> > +
> > +		pthread_mutex_lock(&waiter->events_lock);
> > +		vector_foreach_slot(waiter->events, dev_evt, i) {
> > +			if (dev_evt->action !=3D EVENT_NOTHING) {
> > +				curr_dev =3D *dev_evt;
> > +				if (dev_evt->action =3D=3D EVENT_REMOVE)
> > {
> > +					vector_del_slot(waiter-
> > >events, i);
> > +					free(dev_evt);
> > +				} else
> > +					dev_evt->action =3D
> > EVENT_NOTHING;
> > +				done =3D 0;
> > +				break;
> > +			}
> > +		}
> > +		pthread_mutex_unlock(&waiter->events_lock);
> > +		if (done)
> > +			return 1;
> > +
> > +		condlog(3, "%s: devmap event #%i", curr_dev.name,
> > +			curr_dev.evt_nr);
> > +
> > +		/*
> > +		 * event might be :
> > +		 *
> > +		 * 1) a table reload, which means our mpp structure
> > is
> > +		 *    obsolete : refresh it through
> > update_multipath()
> > +		 * 2) a path failed by DM : mark as such through
> > +		 *    update_multipath()
> > +		 * 3) map has gone away : stop the thread.
> > +		 * 4) a path reinstate : nothing to do
> > +		 * 5) a switch group : nothing to do
> > +		 */
> > +		pthread_cleanup_push(cleanup_lock, &waiter->vecs-
> > >lock);
> > +		lock(&waiter->vecs->lock);
> > +		pthread_testcancel();
> > +		r =3D 0;
> > +		if (curr_dev.action =3D=3D EVENT_REMOVE) {
> > +			mpp =3D find_mp_by_alias(waiter->vecs->mpvec,
> > +					       curr_dev.name);
> > +			if (mpp)
> > +				remove_map(mpp, waiter->vecs, 1);
> > +		} else
> > +			r =3D update_multipath(waiter->vecs,
> > curr_dev.name, 1);
> > +		lock_cleanup_pop(&waiter->vecs->lock);
> > +
> > +		if (r) {
> > +			condlog(2, "%s: stopped watching dmevents",
> > +				curr_dev.name);
> > +			unwatch_dmevents(curr_dev.name);
> > +		}
> > +	}
> > +	condlog(0, "dmevent waiter thread unexpectedly quit");
> > +	return -1; /* never reach there */
> > +}
> > +
> > +static void rcu_unregister(void *param)
> > +{
> > +	rcu_unregister_thread();
> > +}
> > +
> > +void *wait_dmevents (void *unused)
> > +{
> > +	int r;
> > +
> > +
> > +	if (!waiter) {
> > +		condlog(0, "dmevents waiter not intialized");
> > +		return NULL;
> > +	}
> > +
> > +	pthread_cleanup_push(rcu_unregister, NULL);
> > +	rcu_register_thread();
> > +	mlockall(MCL_CURRENT | MCL_FUTURE);
> > +
> > +	while (1) {
> > +		r =3D dmevent_loop();
> > +
> > +		if (r < 0)
> > +			break;
> > +
> > +		sleep(r);
> > +	}
> > +
> > +	pthread_cleanup_pop(1);
> > +	return NULL;
> > +}
> > diff --git a/multipathd/dmevents.h b/multipathd/dmevents.h
> > new file mode 100644
> > index 0000000..569e855
> > --- /dev/null
> > +++ b/multipathd/dmevents.h
> > @@ -0,0 +1,13 @@
> > +#ifndef _DMEVENTS_H
> > +#define _DMEVENTS_H
> > +
> > +#include "structs_vec.h"
> > +
> > +int dmevent_poll_supported(void);
> > +int alloc_dmevent_waiter(struct vectors *vecs);
> > +void free_dmevent_waiter(void);
> > +int watch_dmevents(char *name);
> > +void unwatch_all_dmevents(void);
> > +void *wait_dmevents (void *unused);
> > +
> > +#endif /* _DMEVENTS_H */
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 2963bde..6dabf2c 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -82,6 +82,7 @@ static int use_watchdog;
> >  #include "cli_handlers.h"
> >  #include "lock.h"
> >  #include "waiter.h"
> > +#include "dmevents.h"
> >  #include "io_err_stat.h"
> >  #include "wwids.h"
> >  #include "../third-party/valgrind/drd.h"
> > @@ -108,6 +109,7 @@ int uxsock_timeout;
> >  int verbosity;
> >  int bindings_read_only;
> >  int ignore_new_devs;
> > +int poll_dmevents =3D 1;
> >  enum daemon_status running_state =3D DAEMON_INIT;
> >  pid_t daemon_pid;
> >  pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
> > @@ -288,11 +290,23 @@ switch_pathgroup (struct multipath * mpp)
> >  		 mpp->alias, mpp->bestpg);
> >  }
> >  =

> > +static int
> > +wait_for_events(struct multipath *mpp, struct vectors *vecs)
> > +{
> > +	if (poll_dmevents)
> > +		return watch_dmevents(mpp->alias);
> > +	else
> > +		return start_waiter_thread(mpp, vecs);
> > +}
> > +
> >  static void
> >  remove_map_and_stop_waiter(struct multipath *mpp, struct vectors
> > *vecs,
> >  			   int purge_vec)
> >  {
> > -	stop_waiter_thread(mpp, vecs);
> > +	/* devices are automatically removed by the dmevent polling
> > code,
> > +	 * so they don't need to be manually removed here */
> > +	if (!poll_dmevents)
> > +		stop_waiter_thread(mpp, vecs);
> >  	remove_map(mpp, vecs, purge_vec);
> >  }
> >  =

> > @@ -305,8 +319,12 @@ remove_maps_and_stop_waiters(struct vectors
> > *vecs)
> >  	if (!vecs)
> >  		return;
> >  =

> > -	vector_foreach_slot(vecs->mpvec, mpp, i)
> > -		stop_waiter_thread(mpp, vecs);
> > +	if (!poll_dmevents) {
> > +		vector_foreach_slot(vecs->mpvec, mpp, i)
> > +			stop_waiter_thread(mpp, vecs);
> > +	}
> > +	else
> > +		unwatch_all_dmevents();
> >  =

> >  	remove_maps(vecs);
> >  }
> > @@ -351,7 +369,7 @@ retry:
> >  	dm_lib_release();
> >  =

> >  fail:
> > -	if (new_map && (retries < 0 || start_waiter_thread(mpp,
> > vecs))) {
> > +	if (new_map && (retries < 0 || wait_for_events(mpp, vecs)))
> > {
> >  		condlog(0, "%s: failed to create new map", mpp-
> > >alias);
> >  		remove_map(mpp, vecs, 1);
> >  		return 1;
> > @@ -870,7 +888,7 @@ retry:
> >  =

> >  	if ((mpp->action =3D=3D ACT_CREATE ||
> >  	     (mpp->action =3D=3D ACT_NOTHING && start_waiter && !mpp-
> > >waiter)) &&
> > -	    start_waiter_thread(mpp, vecs))
> > +	    wait_for_events(mpp, vecs))
> >  			goto fail_map;
> >  =

> >  	/*
> > @@ -2173,7 +2191,7 @@ configure (struct vectors * vecs)
> >  	 * start dm event waiter threads for these new maps
> >  	 */
> >  	vector_foreach_slot(vecs->mpvec, mpp, i) {
> > -		if (start_waiter_thread(mpp, vecs)) {
> > +		if (wait_for_events(mpp, vecs)) {
> >  			remove_map(mpp, vecs, 1);
> >  			i--;
> >  			continue;
> > @@ -2414,7 +2432,7 @@ set_oom_adj (void)
> >  static int
> >  child (void * param)
> >  {
> > -	pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr;
> > +	pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> > dmevent_thr;
> >  	pthread_attr_t log_attr, misc_attr, uevent_attr;
> >  	struct vectors * vecs;
> >  	struct multipath * mpp;
> > @@ -2476,6 +2494,8 @@ child (void * param)
> >  		goto failed;
> >  	}
> >  =

> > +	if (poll_dmevents)
> > +		poll_dmevents =3D dmevent_poll_supported();
> >  	setlogmask(LOG_UPTO(conf->verbosity + 3));
> >  =

> >  	envp =3D getenv("LimitNOFILE");
> > @@ -2542,6 +2562,19 @@ child (void * param)
> >  =

> >  	init_path_check_interval(vecs);
> >  =

> > +	if (poll_dmevents) {
> > +		if (alloc_dmevent_waiter(vecs)) {
> > +			condlog(0, "failed to allocate dmevents
> > waiter info");
> > +			goto failed;
> > +		}
> > +		if ((rc =3D pthread_create(&dmevent_thr, &misc_attr,
> > +					 wait_dmevents, NULL))) {
> > +			condlog(0, "failed to create dmevent waiter
> > thread: %d",
> > +				rc);
> > +			goto failed;
> > +		}
> > +	}
> > +
> >  	/*
> >  	 * Start uevent listener early to catch events
> >  	 */
> > @@ -2615,11 +2648,15 @@ child (void * param)
> >  	pthread_cancel(uevent_thr);
> >  	pthread_cancel(uxlsnr_thr);
> >  	pthread_cancel(uevq_thr);
> > +	if (poll_dmevents)
> > +		pthread_cancel(dmevent_thr);
> >  =

> >  	pthread_join(check_thr, NULL);
> >  	pthread_join(uevent_thr, NULL);
> >  	pthread_join(uxlsnr_thr, NULL);
> >  	pthread_join(uevq_thr, NULL);
> > +	if (poll_dmevents)
> > +		pthread_join(dmevent_thr, NULL);
> >  =

> >  	stop_io_err_stat_thread();
> >  =

> > @@ -2634,6 +2671,8 @@ child (void * param)
> >  =

> >  	cleanup_checkers();
> >  	cleanup_prio();
> > +	if (poll_dmevents)
> > +		free_dmevent_waiter();
> >  =

> >  	dm_lib_release();
> >  	dm_lib_exit();
> > @@ -2765,7 +2804,7 @@ main (int argc, char *argv[])
> >  	udev =3D udev_new();
> >  	libmp_udev_set_sync_support(0);
> >  =

> > -	while ((arg =3D getopt(argc, argv, ":dsv:k::Bn")) !=3D EOF ) {
> > +	while ((arg =3D getopt(argc, argv, ":dsv:k::Bniw")) !=3D EOF ) {
> >  		switch(arg) {
> >  		case 'd':
> >  			foreground =3D 1;
> > @@ -2799,6 +2838,9 @@ main (int argc, char *argv[])
> >  		case 'n':
> >  			ignore_new_devs =3D 1;
> >  			break;
> > +		case 'w':
> > +			poll_dmevents =3D 0;
> > +			break;
> >  		default:
> >  			fprintf(stderr, "Invalid argument '-%c'\n",
> >  				optopt);
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
