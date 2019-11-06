From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 16/72] libmultipath: make path_discovery()
 pthread_cancel()-safe
Date: Wed, 6 Nov 2019 14:51:14 -0600
Message-ID: <20191106205114.GA30153@octiron.msp.redhat.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-17-martin.wilck@suse.com>
	<20191030145333.GN25414@octiron.msp.redhat.com>
	<1dafb5da296c6eec383213ec04dcf399fe45c0f6.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1dafb5da296c6eec383213ec04dcf399fe45c0f6.camel@suse.com>
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

On Mon, Nov 04, 2019 at 08:29:21AM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> thanks for looking into this.
>=20
> On Wed, 2019-10-30 at 09:53 -0500, Benjamin Marzinski wrote:
> > On Sat, Oct 12, 2019 at 09:27:57PM +0000, Martin Wilck wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > The udev_enumerate and udev_device refs wouldn't be released
> > > if the thread was cancelled. Fix it.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/discovery.c | 51 +++++++++++++++++++++++++++++++-----
> > > ----
> > >  1 file changed, 40 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > > index e68b0e9f..d217ca92 100644
> > > --- a/libmultipath/discovery.c
> > > +++ b/libmultipath/discovery.c
> > > @@ -140,19 +140,47 @@ path_discover (vector pathvec, struct config
> > > * conf,
> > >  =09return pathinfo(pp, conf, flag);
> > >  }
> > > =20
> > > +static void cleanup_udev_enumerate_ptr(void *arg)
> > > +{
> > > +=09struct udev_enumerate *ue;
> > > +
> > > +=09if (!arg)
> > > +=09=09return;
> > > +=09ue =3D *((struct udev_enumerate**) arg);
> > > +=09if (ue)
> > > +=09=09(void)udev_enumerate_unref(ue);
> > > +}
> > > +
> > > +static void cleanup_udev_device_ptr(void *arg)
> > > +{
> > > +=09struct udev_device *ud;
> > > +
> > > +=09if (!arg)
> > > +=09=09return;
> > > +=09ud =3D *((struct udev_device**) arg);
> > > +=09if (ud)
> > > +=09=09(void)udev_device_unref(ud);
> > > +}
> > > +
> > >  int
> > >  path_discovery (vector pathvec, int flag)
> > >  {
> > > -=09struct udev_enumerate *udev_iter;
> > > +=09struct udev_enumerate *udev_iter =3D NULL;
> > >  =09struct udev_list_entry *entry;
> > > -=09struct udev_device *udevice;
> > > +=09struct udev_device *udevice =3D NULL;
> > >  =09struct config *conf;
> > > -=09const char *devpath;
> > >  =09int num_paths =3D 0, total_paths =3D 0, ret;
> > > =20
> > > +=09pthread_cleanup_push(cleanup_udev_enumerate_ptr, &udev_iter);
> > > +=09pthread_cleanup_push(cleanup_udev_device_ptr, &udevice);
> > > +=09conf =3D get_multipath_config();
> > > +=09pthread_cleanup_push(put_multipath_config, conf);
> > > +
> > >  =09udev_iter =3D udev_enumerate_new(udev);
> > > -=09if (!udev_iter)
> > > -=09=09return -ENOMEM;
> > > +=09if (!udev_iter) {
> > > +=09=09ret =3D -ENOMEM;
> > > +=09=09goto out;
> > > +=09}
> > > =20
> > >  =09if (udev_enumerate_add_match_subsystem(udev_iter, "block") < 0
> > > ||
> > >  =09    udev_enumerate_add_match_is_initialized(udev_iter) < 0 ||
> > > @@ -165,6 +193,8 @@ path_discovery (vector pathvec, int flag)
> > >  =09udev_list_entry_foreach(entry,
> > >  =09=09=09=09udev_enumerate_get_list_entry(udev_iter
> > > )) {
> > >  =09=09const char *devtype;
> > > +=09=09const char *devpath;
> > > +
> > >  =09=09devpath =3D udev_list_entry_get_name(entry);
> > >  =09=09condlog(4, "Discover device %s", devpath);
> > >  =09=09udevice =3D udev_device_new_from_syspath(udev, devpath);
> > > @@ -175,19 +205,18 @@ path_discovery (vector pathvec, int flag)
> > >  =09=09devtype =3D udev_device_get_devtype(udevice);
> > >  =09=09if(devtype && !strncmp(devtype, "disk", 4)) {
> > >  =09=09=09total_paths++;
> > > -=09=09=09conf =3D get_multipath_config();
> > > -=09=09=09pthread_cleanup_push(put_multipath_config,
> > > conf);
> >=20
> > Why move grabbing the config RCU lock out of the loop?=20
>=20
> Yes, that was the idea.
>=20
> > All things being
> > equal, it seems like we'd rather hold this for less time, and
> > rcu_read_lock() is designed to be lightweight, so calling it more
> > times
> > shouldn't be an issue.=20
>=20
> It's not the execution time of rcu_read_lock() that I'm concerned
> about.=20
>=20
> In this particular loop, my estimate is that >90% of time is spent in
> path_discover()/pathinfo(), so time-during-which-lock-is-held-wise, we
> gain little by taking and releasing the RCU lock in every iteration.=20
>=20
> Right, we might catch a configuration change _earlier_ if we release
> the lock between pathinfo() invocations. But - do we actually want
> that? This lock protects us against corruption of the multipathd
> configuration, basically against someone calling "multipathd
> reconfigure" while our code is running. But if the configuration ins
> really changed, what we're currently doing is vain anyway - once the
> configure() call is finished, we will go through yet another full
> reconfigure cycle. IOW: Do we seriously want to call pathinfo() for the
> different paths in the system with  different configuration, once with
> and once without "user_friendly_names", for example?
>=20
> Given that the code we're talking about is only called from
> reconfigure(), multipath_conf having just been reassigned, IMO it's an
> improvement to hold the lock through the entire loop. It might even be
> good to hold the lock for the complete invocation of configure(), but I
> haven't thought about that in detail yet.
>=20
> Does this make sense?

Sure. ACK

-Ben
=20
> Besides, to my taste at least, it improves readability of the code to
> move get_multipath_config() out of certain loops.
>=20
> Thanks,
> Martin
>=20
