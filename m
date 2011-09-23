From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RESEND][PATCH] multipath: don't set
	queue_if_no_path without	multipathd
Date: Fri, 23 Sep 2011 09:58:33 -0500
Message-ID: <20110923145833.GS24133@ether.msp.redhat.com>
References: <20110923044158.GP24133@ether.msp.redhat.com>
	<1316757172.1850.4.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1316757172.1850.4.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Fri, Sep 23, 2011 at 07:52:52AM +0200, Christophe Varoqui wrote:
> On jeu., 2011-09-22 at 23:41 -0500, Benjamin Marzinski wrote:
> > If multipathd is not running, when all paths to a device have failed, there's
> > no way for them to automatically get restored.  If the device is set to queue,
> > whatever is accessing it will hang forever. This can lead to problems if it
> > happens at boot-up.  This patch unsets queue_if_no_path for all devices created
> > when multipathd is not running. When multipathd starts, it will automatically
> > get reset queue_if_no_path to the proper value.  This new behaviour can be
> > overridden using the new "-q" option to multipath.
> > 
> > This patch applies against the current head, instead of building on my
> > find_multipaths patch.  It moves pidfile.[ch] into libmultipath, but is
> > functionally identical to the last version.
> > 
> As stated by Hannes recently, it would be better not to add more users
> of the pidfile. May be you could switch to test the unix socket
> instead ?

Sure.
 
> May we could also reverse the -q meaning ... making multipath default
> behaviour to not honor queueing by default when multipathd is not
> running. As you said, multipathd starting will update the maps.

I'm confused.  In the patch I sent, by default, multipath will not set
the device to queuing if multipathd isn't running.  If you want
multipath to honor the configured queueing setting when multipathd is
not running, you need to use the -q option.  Isn't that what you're
asking for?

-Ben

> What do you think ?
> 
> Regards,
> cvaroqui
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/Makefile    |    2 
> >  libmultipath/config.h    |    1 
> >  libmultipath/configure.c |   13 +++++-
> >  libmultipath/pidfile.c   |   95 +++++++++++++++++++++++++++++++++++++++++++++++
> >  libmultipath/pidfile.h   |    2 
> >  multipath/main.c         |    8 ++-
> >  multipathd/Makefile      |    2 
> >  multipathd/main.c        |    2 
> >  multipathd/pidfile.c     |   67 ---------------------------------
> >  multipathd/pidfile.h     |    1 
> >  10 files changed, 119 insertions(+), 74 deletions(-)
> > 
> > Index: multipath-tools-110916/libmultipath/config.h
> > ===================================================================
> > --- multipath-tools-110916.orig/libmultipath/config.h
> > +++ multipath-tools-110916/libmultipath/config.h
> > @@ -92,6 +92,7 @@ struct config {
> >  	int attribute_flags;
> >  	int fast_io_fail;
> >  	unsigned int dev_loss;
> > +	int allow_queueing;
> >  	uid_t uid;
> >  	gid_t gid;
> >  	mode_t mode;
> > Index: multipath-tools-110916/libmultipath/configure.c
> > ===================================================================
> > --- multipath-tools-110916.orig/libmultipath/configure.c
> > +++ multipath-tools-110916/libmultipath/configure.c
> > @@ -35,6 +35,7 @@
> >  #include "alias.h"
> >  #include "prio.h"
> >  #include "util.h"
> > +#include "pidfile.h"
> >  
> >  extern int
> >  setup_map (struct multipath * mpp, char * params, int params_size)
> > @@ -555,7 +556,17 @@ coalesce_paths (struct vectors * vecs, v
> >  		if (r == DOMAP_DRY)
> >  			continue;
> >  
> > -		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
> > +		if (!conf->daemon && !conf->allow_queueing &&
> > +		    !pidfile_check(DEFAULT_PIDFILE)) {
> > +			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
> > +			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
> > +				condlog(3, "%s: multipathd not running, unset "
> > +					"queue_if_no_path feature", mpp->alias);
> > +			if (!dm_queue_if_no_path(mpp->alias, 0))
> > +				remove_feature(&mpp->features,
> > +					       "queue_if_no_path");
> > +		}
> > +		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
> >  			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL) {
> >  				condlog(3, "%s: unset queue_if_no_path feature",
> >  					mpp->alias);
> > Index: multipath-tools-110916/multipath/main.c
> > ===================================================================
> > --- multipath-tools-110916.orig/multipath/main.c
> > +++ multipath-tools-110916/multipath/main.c
> > @@ -79,7 +79,7 @@ usage (char * progname)
> >  {
> >  	fprintf (stderr, VERSION_STRING);
> >  	fprintf (stderr, "Usage:\n");
> > -	fprintf (stderr, "  %s [-d] [-r] [-v lvl] [-p pol] [-b fil] [dev]\n", progname);
> > +	fprintf (stderr, "  %s [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
> >  	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
> >  	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
> >  	fprintf (stderr, "  %s -t\n", progname);
> > @@ -92,6 +92,7 @@ usage (char * progname)
> >  		"  -ll     show multipath topology (maximum info)\n" \
> >  		"  -f      flush a multipath device map\n" \
> >  		"  -F      flush all multipath device maps\n" \
> > +		"  -q      allow queue_if_no_path when multipathd is not running\n"\
> >  		"  -d      dry run, do not create or update devmaps\n" \
> >  		"  -t      dump internal hardware table\n" \
> >  		"  -r      force devmap reload\n" \
> > @@ -397,7 +398,7 @@ main (int argc, char *argv[])
> >  		condlog(0, "multipath tools need sysfs mounted");
> >  		exit(1);
> >  	}
> > -	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Brt")) != EOF ) {
> > +	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Brtq")) != EOF ) {
> >  		switch(arg) {
> >  		case 1: printf("optarg : %s\n",optarg);
> >  			break;
> > @@ -414,6 +415,9 @@ main (int argc, char *argv[])
> >  		case 'B':
> >  			conf->bindings_read_only = 1;
> >  			break;
> > +		case 'q':
> > +			conf->allow_queueing = 1;
> > +			break;
> >  		case 'd':
> >  			conf->dry_run = 1;
> >  			break;
> > Index: multipath-tools-110916/multipathd/pidfile.c
> > ===================================================================
> > --- multipath-tools-110916.orig/multipathd/pidfile.c
> > +++ /dev/null
> > @@ -1,67 +0,0 @@
> > -#include <sys/types.h> /* for pid_t */
> > -#include <sys/stat.h>  /* for open */
> > -#include <signal.h>    /* for kill() */
> > -#include <errno.h>     /* for ESHRC */
> > -#include <stdio.h>     /* for f...() */
> > -#include <string.h>    /* for memset() */
> > -#include <stdlib.h>    /* for atoi() */
> > -#include <unistd.h>    /* for unlink() */
> > -#include <fcntl.h>     /* for fcntl() */
> > -
> > -#include <debug.h>
> > -
> > -#include "pidfile.h"
> > -
> > -int pidfile_create(const char *pidFile, pid_t pid)
> > -{
> > -	char buf[20];
> > -	struct flock lock;
> > -	int fd, value;
> > -
> > -	if((fd = open(pidFile, O_WRONLY | O_CREAT,
> > -		       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH))) < 0) {
> > -		condlog(0, "Cannot open pidfile [%s], error was [%s]",
> > -			pidFile, strerror(errno));
> > -		return 1;
> > -	}
> > -	lock.l_type = F_WRLCK;
> > -	lock.l_start = 0;
> > -	lock.l_whence = SEEK_SET;
> > -	lock.l_len = 0;
> > -
> > -	if (fcntl(fd, F_SETLK, &lock) < 0) {
> > -		if (errno != EACCES && errno != EAGAIN)
> > -			condlog(0, "Cannot lock pidfile [%s], error was [%s]",
> > -				pidFile, strerror(errno));
> > -		else
> > -			condlog(0, "process is already running");
> > -		goto fail;
> > -	}
> > -	if (ftruncate(fd, 0) < 0) {
> > -		condlog(0, "Cannot truncate pidfile [%s], error was [%s]",
> > -			pidFile, strerror(errno));
> > -		goto fail;
> > -	}
> > -	memset(buf, 0, sizeof(buf));
> > -	snprintf(buf, sizeof(buf)-1, "%u", pid);
> > -	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
> > -		condlog(0, "Cannot write pid to pidfile [%s], error was [%s]",
> > -			pidFile, strerror(errno));
> > -		goto fail;
> > -	}
> > -	if ((value = fcntl(fd, F_GETFD, 0)) < 0) {
> > -		condlog(0, "Cannot get close-on-exec flag from pidfile [%s], "
> > -			"error was [%s]", pidFile, strerror(errno));
> > -		goto fail;
> > -	}
> > -	value |= FD_CLOEXEC;
> > -	if (fcntl(fd, F_SETFD, value) < 0) {
> > -		condlog(0, "Cannot set close-on-exec flag from pidfile [%s], "
> > -			"error was [%s]", pidFile, strerror(errno));
> > -		goto fail;
> > -	}
> > -	return 0;
> > -fail:
> > -	close(fd);
> > -	return 1;
> > -}
> > Index: multipath-tools-110916/multipathd/pidfile.h
> > ===================================================================
> > --- multipath-tools-110916.orig/multipathd/pidfile.h
> > +++ /dev/null
> > @@ -1 +0,0 @@
> > -int pidfile_create(const char *pidFile, pid_t pid);
> > Index: multipath-tools-110916/libmultipath/Makefile
> > ===================================================================
> > --- multipath-tools-110916.orig/libmultipath/Makefile
> > +++ multipath-tools-110916/libmultipath/Makefile
> > @@ -15,7 +15,7 @@ OBJS = memory.o parser.o vector.o devmap
> >         pgpolicies.o debug.o regex.o defaults.o uevent.o \
> >         switchgroup.o uxsock.o print.o alias.o log_pthread.o \
> >         log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
> > -       lock.o waiter.o
> > +       lock.o waiter.o pidfile.o
> >  
> >  LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
> >  
> > Index: multipath-tools-110916/libmultipath/pidfile.c
> > ===================================================================
> > --- /dev/null
> > +++ multipath-tools-110916/libmultipath/pidfile.c
> > @@ -0,0 +1,95 @@
> > +#include <sys/types.h> /* for pid_t */
> > +#include <sys/stat.h>  /* for open */
> > +#include <signal.h>    /* for kill() */
> > +#include <errno.h>     /* for ESHRC */
> > +#include <stdio.h>     /* for f...() */
> > +#include <string.h>    /* for memset() */
> > +#include <stdlib.h>    /* for atoi() */
> > +#include <unistd.h>    /* for unlink() */
> > +#include <fcntl.h>     /* for fcntl() */
> > +
> > +#include "debug.h"
> > +#include "pidfile.h"
> > +
> > +int pidfile_create(const char *pidFile, pid_t pid)
> > +{
> > +	char buf[20];
> > +	struct flock lock;
> > +	int fd, value;
> > +
> > +	if((fd = open(pidFile, O_WRONLY | O_CREAT,
> > +		       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH))) < 0) {
> > +		condlog(0, "Cannot open pidfile [%s], error was [%s]",
> > +			pidFile, strerror(errno));
> > +		return 1;
> > +	}
> > +	lock.l_type = F_WRLCK;
> > +	lock.l_start = 0;
> > +	lock.l_whence = SEEK_SET;
> > +	lock.l_len = 0;
> > +
> > +	if (fcntl(fd, F_SETLK, &lock) < 0) {
> > +		if (errno != EACCES && errno != EAGAIN)
> > +			condlog(0, "Cannot lock pidfile [%s], error was [%s]",
> > +				pidFile, strerror(errno));
> > +		else
> > +			condlog(0, "process is already running");
> > +		goto fail;
> > +	}
> > +	if (ftruncate(fd, 0) < 0) {
> > +		condlog(0, "Cannot truncate pidfile [%s], error was [%s]",
> > +			pidFile, strerror(errno));
> > +		goto fail;
> > +	}
> > +	memset(buf, 0, sizeof(buf));
> > +	snprintf(buf, sizeof(buf)-1, "%u", pid);
> > +	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
> > +		condlog(0, "Cannot write pid to pidfile [%s], error was [%s]",
> > +			pidFile, strerror(errno));
> > +		goto fail;
> > +	}
> > +	if ((value = fcntl(fd, F_GETFD, 0)) < 0) {
> > +		condlog(0, "Cannot get close-on-exec flag from pidfile [%s], "
> > +			"error was [%s]", pidFile, strerror(errno));
> > +		goto fail;
> > +	}
> > +	value |= FD_CLOEXEC;
> > +	if (fcntl(fd, F_SETFD, value) < 0) {
> > +		condlog(0, "Cannot set close-on-exec flag from pidfile [%s], "
> > +			"error was [%s]", pidFile, strerror(errno));
> > +		goto fail;
> > +	}
> > +	return 0;
> > +fail:
> > +	close(fd);
> > +	return 1;
> > +}
> > +
> > +int pidfile_check(const char *file)
> > +{
> > +	int fd;
> > +	struct flock lock;
> > +
> > +	fd = open(file, O_RDONLY);
> > +	if (fd < 0) {
> > +		if (errno == ENOENT)
> > +			return 0;
> > +		condlog(0, "Cannot open pidfile, %s : %s", file,
> > +				strerror(errno));
> > +		return -1;
> > +	}
> > +	lock.l_type = F_WRLCK;
> > +	lock.l_start = 0;
> > +	lock.l_whence = SEEK_SET;
> > +	lock.l_len = 0;
> > +
> > +	if (fcntl(fd, F_GETLK, &lock) < 0) {
> > +		condlog(0, "Cannot check lock on pidfile, %s : %s", file,
> > +				strerror(errno));
> > +		return -1;
> > +	}
> > +	close(fd);
> > +	if (lock.l_type == F_UNLCK)
> > +		return 0;
> > +	return 1;
> > +}
> > Index: multipath-tools-110916/libmultipath/pidfile.h
> > ===================================================================
> > --- /dev/null
> > +++ multipath-tools-110916/libmultipath/pidfile.h
> > @@ -0,0 +1,2 @@
> > +int pidfile_create(const char *pidFile, pid_t pid);
> > +int pidfile_check(const char *file);
> > Index: multipath-tools-110916/multipathd/Makefile
> > ===================================================================
> > --- multipath-tools-110916.orig/multipathd/Makefile
> > +++ multipath-tools-110916/multipathd/Makefile
> > @@ -19,7 +19,7 @@ LDFLAGS += -lpthread -ldevmapper -lreadl
> >  #
> >  # object files
> >  #
> > -OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> > +OBJS = main.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> >  
> > 
> >  #
> > Index: multipath-tools-110916/multipathd/main.c
> > ===================================================================
> > --- multipath-tools-110916.orig/multipathd/main.c
> > +++ multipath-tools-110916/multipathd/main.c
> > @@ -49,9 +49,9 @@
> >  #include <prio.h>
> >  #include <pgpolicies.h>
> >  #include <uevent.h>
> > +#include <pidfile.h>
> >  
> >  #include "main.h"
> > -#include "pidfile.h"
> >  #include "uxlsnr.h"
> >  #include "uxclnt.h"
> >  #include "cli.h"
> 
