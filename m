From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 01/15] multipathd: warn when configuration
 has been changed.
Date: Wed, 22 Jan 2020 05:59:11 -0600
Message-ID: <20200122115911.GY30153@octiron.msp.redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-2-git-send-email-bmarzins@redhat.com>
	<586e8c02fc60cde6771c14f7aa012c3fd55cc3ca.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <586e8c02fc60cde6771c14f7aa012c3fd55cc3ca.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 17, 2020 at 03:45:34PM +0000, Martin Wilck wrote:
> On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> > It would be helpful if multipathd could log a message when
> > multipath.conf or files in the config_dir have been written to, both
> > so
> > that it can be used to send a notification to users, and to help with
> > determining after the fact if multipathd was running with an older
> > config, when the logs of multipathd's behaviour don't match with the
> > current multipath.conf.
> >=20
> > To do this, the multipathd uxlsnr thread now sets up inotify watches
> > on
> > both /etc/multipath.conf and the config_dir to watch if the files are
> > deleted or closed after being opened for writing.  In order to keep
> > uxlsnr from polling repeatedly if the multipath.conf or the
> > config_dir
> > aren't present, it will only set up the watches once per reconfigure.
> > However, since multipath.conf is far more likely to be replaced by a
> > text editor than modified in place, if it gets removed, multipathd
> > will
> > immediately try to restart the watch on it (which will succeed if the
> > file was simply replaced by a new copy).  This does mean that if
> > multipath.conf or the config_dir are actually removed and then later
> > re-added, multipathd won't log any more messages for changes until
> > the
> > next reconfigure. But that seems like a fair trade-off to avoid
> > repeatedly polling for files that aren't likely to appear.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.h |   1 +
> >  multipathd/main.c     |   1 +
> >  multipathd/uxlsnr.c   | 134
> > ++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 130 insertions(+), 6 deletions(-)
>=20
> I know I reviewed this already, but this time I have some more remarks,
> mostly style.

Sure. I can do all these.

-Ben

>=20
> >=20
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index ffec3103..e69aa07c 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -188,6 +188,7 @@ struct config {
> >  =09int find_multipaths_timeout;
> >  =09int marginal_pathgroups;
> >  =09unsigned int version[3];
> > +=09unsigned int sequence_nr;
> > =20
> >  =09char * multipath_dir;
> >  =09char * selector;
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 34a57689..7b364cfe 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2618,6 +2618,7 @@ reconfigure (struct vectors * vecs)
> >  =09uxsock_timeout =3D conf->uxsock_timeout;
> > =20
> >  =09old =3D rcu_dereference(multipath_conf);
> > +=09conf->sequence_nr =3D old->sequence_nr + 1;
> >  =09rcu_assign_pointer(multipath_conf, conf);
> >  =09call_rcu(&old->rcu, rcu_free_config);
> > =20
> > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > index bc71679e..92d9a79a 100644
> > --- a/multipathd/uxlsnr.c
> > +++ b/multipathd/uxlsnr.c
> > @@ -23,6 +23,7 @@
> >  #include <sys/time.h>
> >  #include <signal.h>
> >  #include <stdbool.h>
> > +#include <sys/inotify.h>
> >  #include "checkers.h"
> >  #include "memory.h"
> >  #include "debug.h"
> > @@ -51,6 +52,8 @@ struct client {
> >  LIST_HEAD(clients);
> >  pthread_mutex_t client_lock =3D PTHREAD_MUTEX_INITIALIZER;
> >  struct pollfd *polls;
> > +int notify_fd =3D -1;
> > +char *config_dir;
>=20
> Nit: please declare these as static, as they are used only in this
> file. Also, naming the variable differently, e.g. conf_dir, would
> decrease the number of false hits when grepping for the variable name.
>=20
> > =20
> >  static bool _socket_client_is_root(int fd);
> > =20
> > @@ -151,6 +154,8 @@ void uxsock_cleanup(void *arg)
> >  =09long ux_sock =3D (long)arg;
> > =20
> >  =09close(ux_sock);
> > +=09close(notify_fd);
> > +=09free(config_dir);
> > =20
> >  =09pthread_mutex_lock(&client_lock);
> >  =09list_for_each_entry_safe(client_loop, client_tmp, &clients,
> > node) {
> > @@ -162,6 +167,106 @@ void uxsock_cleanup(void *arg)
> >  =09free_polls();
> >  }
> > =20
> > +/* failing to set the watch descriptor is o.k. we just miss a
> > warning
> > + * message */
> > +void reset_watch(int notify_fd, int *wds, unsigned int *sequence_nr)
>=20
> This function could also be static.
>=20
> > +{
> > +=09struct config *conf;
> > +=09int dir_reset =3D 0;
> > +=09int conf_reset =3D 0;
> > +
> > +=09if (notify_fd =3D=3D -1)
> > +=09=09return;
> > +
> > +=09conf =3D get_multipath_config();
> > +=09/* instead of repeatedly try to reset the inotify watch if
> > +=09 * the config directory or multipath.conf isn't there, just
> > +=09 * do it once per reconfigure */
> > +=09if (*sequence_nr !=3D conf->sequence_nr) {
> > +=09=09*sequence_nr =3D conf->sequence_nr;
> > +=09=09if (wds[0] =3D=3D -1)
> > +=09=09=09conf_reset =3D 1;
> > +=09=09if (!config_dir || !conf->config_dir ||
> > +=09=09    strcmp(config_dir, conf->config_dir)) {
> > +=09=09=09dir_reset =3D 1;
> > +=09=09=09if (config_dir)
> > +=09=09=09=09free(config_dir);
> > +=09=09=09if (conf->config_dir)
> > +=09=09=09=09config_dir =3D strdup(conf->config_dir);
> > +=09=09=09else
> > +=09=09=09=09config_dir =3D NULL;
> > +=09=09} else if (wds[1] =3D=3D -1)
> > +=09=09=09dir_reset =3D 1;
> > +=09}
> > +=09put_multipath_config(conf);
> > +
> > +=09if (dir_reset) {
> > +=09=09if (wds[1] !=3D -1) {
> > +=09=09=09inotify_rm_watch(notify_fd, wds[1]);
> > +=09=09=09wds[1] =3D -1;
> > +=09=09}
> > +=09=09if (config_dir) {
> > +=09=09=09wds[1] =3D inotify_add_watch(notify_fd,
> > config_dir,
> > +=09=09=09=09=09=09   IN_CLOSE_WRITE |
> > IN_DELETE |
> > +=09=09=09=09=09=09   IN_ONLYDIR);
> > +=09=09=09if (wds[1] =3D=3D -1)
> > +=09=09=09=09condlog(3, "didn't set up notifications
> > on %s: %s", config_dir, strerror(errno));
>=20
> Another nitpick: IMO we should be using "%m" for this in new code.
>=20
> > +=09=09}
> > +=09}
> > +=09if (conf_reset) {
> > +=09=09wds[0] =3D inotify_add_watch(notify_fd,
> > DEFAULT_CONFIGFILE,
> > +=09=09=09=09=09   IN_CLOSE_WRITE);
> > +=09=09if (wds[0] =3D=3D -1)
> > +=09=09=09condlog(3, "didn't set up notifications on
> > /etc/multipath.conf: %s", strerror(errno));
> > +=09}
> > +=09return;
> > +}
> > +
> > +void handle_inotify(int fd, int  *wds)
>=20
> Again, static.
>=20
> > +{
> > +=09char buff[1024]
> > +=09=09__attribute__ ((aligned(__alignof__(struct
> > inotify_event))));
> > +=09const struct inotify_event *event;
> > +=09ssize_t len;
> > +=09char *ptr;
> > +=09int i, got_notify =3D 0;
> > +
> > +=09for (;;) {
> > +=09=09len =3D read(fd, buff, sizeof(buff));
> > +=09=09if (len <=3D 0) {
> > +=09=09=09if (len < 0 && errno !=3D EAGAIN) {
> > +=09=09=09=09condlog(3, "error reading from
> > inotify_fd");
> > +=09=09=09=09for (i =3D 0; i < 2; i++) {
> > +=09=09=09=09=09if (wds[i] !=3D -1) {
> > +=09=09=09=09=09=09inotify_rm_watch(fd,
> > wds[i]);
> > +=09=09=09=09=09=09wds[i] =3D -1;
> > +=09=09=09=09=09}
> > +=09=09=09=09}
> > +=09=09=09}
> > +=09=09=09break;
> > +=09=09}
> > +
> > +=09=09got_notify =3D 1;
> > +=09=09for (ptr =3D buff; ptr < buff + len;
> > +=09=09     ptr +=3D sizeof(struct inotify_event) + event->len)
> > {
> > +=09=09=09event =3D (const struct inotify_event *) ptr;
> > +
> > +=09=09=09if (event->mask & IN_IGNORED) {
> > +=09=09=09=09/* multipathd.conf may have been
> > overwritten.
> > +=09=09=09=09 * Try once to reset the notification
> > */
> > +=09=09=09=09if (wds[0] =3D=3D event->wd)
> > +=09=09=09=09=09wds[0] =3D
> > inotify_add_watch(notify_fd,
> > +=09=09=09=09=09=09=09DEFAULT_CONFIGF
> > ILE,
> > +=09=09=09=09=09=09=09IN_CLOSE_WRITE)
> > ;
> > +=09=09=09=09else if (wds[1] =3D=3D event->wd)
> > +=09=09=09=09=09wds[1] =3D -1;
> > +=09=09=09}
> > +=09=09}
> > +=09}
> > +=09if (got_notify)
> > +=09=09condlog(1, "Multipath configuration updated.\nReload
> > multipathd for changes to take effect");
> > +}
> > +
> >  /*
> >   * entry point
> >   */
> > @@ -173,13 +278,19 @@ void * uxsock_listen(uxsock_trigger_fn
> > uxsock_trigger, long ux_sock,
> >  =09char *reply;
> >  =09sigset_t mask;
> >  =09int old_clients =3D MIN_POLLS;
> > +=09/* conf->sequence_nr will be 1 when uxsock_listen is first
> > called */
> > +=09unsigned int sequence_nr =3D 0;
> > +=09int wds[2] =3D { -1, -1 };
>=20
> Style issue: The code might be better readable if we used a struct for
> this,
>=20
> struct watch_descriptors {
> =09int conf_wd;
> =09int dir_wd;
> };=09
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
