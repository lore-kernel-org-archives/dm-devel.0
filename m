From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 4/6] Unit tests for is_path_valid()
Date: Mon, 18 May 2020 13:57:49 -0500
Message-ID: <20200518185749.GX5907@octiron.msp.redhat.com>
References: <1589507962-6895-1-git-send-email-bmarzins@redhat.com>
	<1589507962-6895-5-git-send-email-bmarzins@redhat.com>
	<9b472a9cdcea88daf12e74733eb579e489daded5.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9b472a9cdcea88daf12e74733eb579e489daded5.camel@suse.com>
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

On Fri, May 15, 2020 at 08:37:23PM +0000, Martin Wilck wrote:
> On Thu, 2020-05-14 at 20:59 -0500, Benjamin Marzinski wrote:
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Two minor nits below, otherwise ack.

Sure. I can fix those up.

-Ben

>=20
> > ---
> >  tests/Makefile |   4 +-
> >  tests/valid.c  | 424
> > +++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 427 insertions(+), 1 deletion(-)
> >  create mode 100644 tests/valid.c
> >=20
> > diff --git a/tests/Makefile b/tests/Makefile
> > index 1b8706a7..125553b8 100644
> > --- a/tests/Makefile
> > +++ b/tests/Makefile
> > @@ -13,7 +13,7 @@ CFLAGS +=3D $(BIN_CFLAGS) -I$(multipathdir)
> > -I$(mpathcmddir) \
> >  LIBDEPS +=3D -L$(multipathdir) -L$(mpathcmddir) -lmultipath -lmpathcmd
> > -lcmocka
> > =20
> >  TESTS :=3D uevent parser util dmevents hwtable blacklist unaligned vpd
> > pgpolicy \
> > -=09 alias directio
> > +=09 alias directio valid
> > =20
> >  .SILENT: $(TESTS:%=3D%.o)
> >  .PRECIOUS: $(TESTS:%=3D%-test)
> > @@ -50,6 +50,8 @@ vpd-test_OBJDEPS :=3D  ../libmultipath/discovery.o
> >  vpd-test_LIBDEPS :=3D -ludev -lpthread -ldl
> >  alias-test_TESTDEPS :=3D test-log.o
> >  alias-test_LIBDEPS :=3D -lpthread -ldl
> > +valid-test_OBJDEPS :=3D ../libmultipath/valid.o
> > +valid-test_LIBDEPS :=3D -ludev -lpthread -ldl
> >  ifneq ($(DIO_TEST_DEV),)
> >  directio-test_LIBDEPS :=3D -laio
> >  endif
> > diff --git a/tests/valid.c b/tests/valid.c
> > new file mode 100644
> > index 00000000..b128b029
> > --- /dev/null
> > +++ b/tests/valid.c
> > @@ -0,0 +1,424 @@
> > +/*
> > + * Copyright (c) 2020 Benjamin Marzinski, Redhat
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program.  If not, see <
> > https://www.gnu.org/licenses/>;.
> > + *
> > + */
> > +
> > +#define _GNU_SOURCE
> > +#include <stdint.h>
> > +#include <stdbool.h>
> > +#include <stdarg.h>
> > +#include <stddef.h>
> > +#include <setjmp.h>
> > +#include <stdlib.h>
> > +#include <errno.h>
> > +#include <cmocka.h>
> > +#include "globals.c"
> > +#include "util.h"
> > +#include "discovery.h"
> > +#include "wwids.h"
> > +#include "valid.h"
> > +
> > +int test_fd;
> > +struct udev_device {
> > +=09int unused;
> > +} test_udev;
> > +
> > +bool __wrap_sysfs_is_multipathed(struct path *pp, bool set_wwid)
> > +{
> > +=09bool is_multipathed =3D mock_type(bool);
> > +=09assert_non_null(pp);
> > +=09assert_int_not_equal(strlen(pp->dev), 0);
> > +=09if (is_multipathed && set_wwid)
> > +=09=09strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
> > +=09return is_multipathed;
> > +}
> > +
> > +int __wrap___mpath_connect(int nonblocking)
> > +{
> > +=09bool connected =3D mock_type(bool);
> > +=09assert_int_equal(nonblocking, 1);
> > +=09if (connected)
> > +=09=09return test_fd;
> > +=09errno =3D mock_type(int);
> > +=09return -1;
> > +}
> > +
> > +int __wrap_systemd_service_enabled(const char *dev)
> > +{
> > +=09return (int)mock_type(bool);
> > +}
> > +
> > +/* There's no point in checking the return value here */
> > +int __wrap_mpath_disconnect(int fd)
> > +{
> > +=09assert_int_equal(fd, test_fd);
> > +=09return 0;
> > +}
> > +
> > +struct udev_device
> > *__wrap_udev_device_new_from_subsystem_sysname(struct udev *udev,
> > const char *subsystem, const char *sysname)
> > +{
> > +=09bool passed =3D mock_type(bool);
> > +=09assert_string_equal(sysname, mock_ptr_type(char *));
> > +=09if (passed)
> > +=09=09return &test_udev;
> > +=09return NULL;
> > +}
> > +
> > +int __wrap_pathinfo(struct path *pp, struct config *conf, int mask)
> > +{
> > +=09int ret =3D mock_type(int);
> > +=09assert_string_equal(pp->dev, mock_ptr_type(char *));
> > +=09assert_int_equal(mask, DI_SYSFS | DI_WWID | DI_BLACKLIST);
> > +=09if (ret =3D=3D PATHINFO_OK)
> > +=09=09strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
> > +=09else
> > +=09=09memset(pp->wwid, 0, WWID_SIZE);
> > +=09return ret;
> > +}
> > +
> > +int __wrap_is_failed_wwid(const char *wwid)
> > +{
> > +=09int ret =3D mock_type(int);
> > +=09assert_string_equal(wwid, mock_ptr_type(char *));
> > +=09return ret;
> > +}
> > +
> > +int __wrap_check_wwids_file(char *wwid, int write_wwid)
> > +{
> > +=09bool passed =3D mock_type(bool);
> > +=09assert_int_equal(write_wwid, 0);
> > +=09assert_string_equal(wwid, mock_ptr_type(char *));
> > +=09if (passed)
> > +=09=09return 0;
> > +=09else
> > +=09=09return -1;
> > +}
> > +
> > +int __wrap_dm_map_present_by_uuid(const char *uuid)
> > +{
> > +=09int ret =3D mock_type(int);
> > +=09assert_string_equal(uuid, mock_ptr_type(char *));
> > +=09return ret;
> > +}
> > +
> > +enum {
> > +=09STAGE_IS_MULTIPATHED,
> > +=09STAGE_CHECK_MULTIPATHD,
> > +=09STAGE_GET_UDEV_DEVICE,
> > +=09STAGE_PATHINFO,
> > +=09STAGE_IS_FAILED,
> > +=09STAGE_CHECK_WWIDS,
> > +=09STAGE_UUID_PRESENT,
> > +};
>=20
> nice :-)
>=20
> > +
> > +/* setup the test to continue past the given stage in
> > is_path_valid() */
> > +static void setup_passing(char *name, char *wwid, bool
> > check_multipathd,
> > +=09=09=09  unsigned int stage)
> > +{
> > +=09will_return(__wrap_sysfs_is_multipathed, false);
> > +=09if (stage =3D=3D STAGE_IS_MULTIPATHED)
> > +=09=09return;
> > +=09if (check_multipathd)
> > +=09=09will_return(__wrap___mpath_connect, true);
> > +=09if (stage =3D=3D STAGE_CHECK_MULTIPATHD)
> > +=09=09return;
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > true);
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > +=09=09    name);
> > +=09if (stage =3D=3D STAGE_GET_UDEV_DEVICE)
> > +=09=09return;
> > +=09will_return(__wrap_pathinfo, PATHINFO_OK);
> > +=09will_return(__wrap_pathinfo, name);
> > +=09will_return(__wrap_pathinfo, wwid);
> > +=09if (stage =3D=3D STAGE_PATHINFO)
> > +=09=09return;
> > +=09will_return(__wrap_is_failed_wwid, WWID_IS_NOT_FAILED);
> > +=09will_return(__wrap_is_failed_wwid, wwid);
> > +=09if (stage =3D=3D STAGE_IS_FAILED)
> > +=09=09return;
> > +=09will_return(__wrap_check_wwids_file, false);
> > +=09will_return(__wrap_check_wwids_file, wwid);
> > +=09if (stage =3D=3D STAGE_CHECK_WWIDS)
> > +=09=09return;
> > +=09will_return(__wrap_dm_map_present_by_uuid, 0);
> > +=09will_return(__wrap_dm_map_present_by_uuid, wwid);
> > +}
> > +
> > +static void test_bad_arguments(void **state)
> > +{
> > +=09struct path pp;
> > +=09char too_long[FILE_NAME_SIZE + 1];
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09/* test NULL pointers */
> > +=09assert_int_equal(is_path_valid("test", &conf, NULL, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09assert_int_equal(is_path_valid("test", NULL, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09assert_int_equal(is_path_valid(NULL, &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09/* test undefined find_mutlipaths */
>=20
> typo
>=20
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_UNDEF;
> > +=09assert_int_equal(is_path_valid("test", &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09/* test name too long */
> > +=09memset(too_long, 'x', sizeof(too_long));
> > +=09too_long[sizeof(too_long) - 1] =3D '\0';
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09assert_int_equal(is_path_valid(too_long, &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +}
> > +
> > +static void test_sysfs_is_multipathed(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +=09char *wwid =3D "test_wwid";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09/* test for already existing multiapthed device */
> > +=09will_return(__wrap_sysfs_is_multipathed, true);
> > +=09will_return(__wrap_sysfs_is_multipathed, wwid);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, true),
> > +=09=09=09 PATH_IS_VALID_NO_CHECK);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +=09/* test for wwid device with empty wwid */
> > +=09will_return(__wrap_sysfs_is_multipathed, true);
> > +=09will_return(__wrap_sysfs_is_multipathed, "");
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +}
> > +
> > +static void test_check_multipathd(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09/* test failed check to see if multipathd is active */
> > +=09will_return(__wrap_sysfs_is_multipathed, false);
> > +=09will_return(__wrap___mpath_connect, false);
> > +=09will_return(__wrap___mpath_connect, ECONNREFUSED);
> > +=09will_return(__wrap_systemd_service_enabled, false);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, true),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09/* test pass because service is enabled. fail getting udev */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09will_return(__wrap_sysfs_is_multipathed, false);
> > +=09will_return(__wrap___mpath_connect, false);
> > +=09will_return(__wrap___mpath_connect, ECONNREFUSED);
> > +=09will_return(__wrap_systemd_service_enabled, true);
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > false);
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > +=09=09    name);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09assert_string_equal(pp.dev, name);
> > +=09/* test pass because connect returned EAGAIN. fail getting udev
> > */
> > +=09will_return(__wrap_sysfs_is_multipathed, false);
> > +=09will_return(__wrap___mpath_connect, false);
> > +=09will_return(__wrap___mpath_connect, EAGAIN);
>=20
> Here we may want a test that should succeeds with PATH_IS_VALID after
> mpath_connect returns EAGAIN.
>=20
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > false);
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > +=09=09    name);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09/* test pass because connect succeeded. fail getting udev */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09will_return(__wrap_sysfs_is_multipathed, false);
> > +=09will_return(__wrap___mpath_connect, true);
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > false);
> > +=09will_return(__wrap_udev_device_new_from_subsystem_sysname,
> > +=09=09    name);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, true),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09assert_string_equal(pp.dev, name);
> > +}
> > +
> > +static void test_pathinfo(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09/* Test pathinfo blacklisting device */
> > +=09setup_passing(name, NULL, false, STAGE_GET_UDEV_DEVICE);
> > +=09will_return(__wrap_pathinfo, PATHINFO_SKIPPED);
> > +=09will_return(__wrap_pathinfo, name);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09/* Test pathinfo failing */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09setup_passing(name, NULL, false, STAGE_GET_UDEV_DEVICE);
> > +=09will_return(__wrap_pathinfo, PATHINFO_FAILED);
> > +=09will_return(__wrap_pathinfo, name);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_ERROR);
> > +=09/* Test blank wwid */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09setup_passing(name, NULL, false, STAGE_GET_UDEV_DEVICE);
> > +=09will_return(__wrap_pathinfo, PATHINFO_OK);
> > +=09will_return(__wrap_pathinfo, name);
> > +=09will_return(__wrap_pathinfo, "");
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +}
> > +
> > +static void test_is_failed_wwid(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +=09char *wwid =3D "test-wwid";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09/* Test wwid failed */
> > +=09setup_passing(name, wwid, false, STAGE_PATHINFO);
> > +=09will_return(__wrap_is_failed_wwid, WWID_IS_FAILED);
> > +=09will_return(__wrap_is_failed_wwid, wwid);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +=09/* test is_failed_wwid error */
> > +=09setup_passing(name, wwid, false, STAGE_PATHINFO);
> > +=09will_return(__wrap_is_failed_wwid, WWID_FAILED_ERROR);
> > +=09will_return(__wrap_is_failed_wwid, wwid);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_ERROR);
> > +}
> > +
> > +static void test_greedy(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +=09char *wwid =3D "test-wwid";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_GREEDY;
> > +=09setup_passing(name, wwid, false, STAGE_IS_FAILED);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +}
> > +
> > +static void test_check_wwids(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +=09char *wwid =3D "test-wwid";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09setup_passing(name, wwid, false, STAGE_IS_FAILED);
> > +=09will_return(__wrap_check_wwids_file, true);
> > +=09will_return(__wrap_check_wwids_file, wwid);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_VALID_NO_CHECK);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +}
> > +
> > +static void test_check_uuid_present(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +=09char *wwid =3D "test-wwid";
> > +
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09setup_passing(name, wwid, false, STAGE_CHECK_WWIDS);
> > +=09will_return(__wrap_dm_map_present_by_uuid, 1);
> > +=09will_return(__wrap_dm_map_present_by_uuid, wwid);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +}
> > +
> > +
> > +static void test_find_multipaths(void **state)
> > +{
> > +=09struct path pp;
> > +=09char *name =3D "test";
> > +=09char *wwid =3D "test-wwid";
> > +
> > +=09/* test find_multipaths =3D FIND_MULTIPATHS_STRICT */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_STRICT;
> > +=09setup_passing(name, wwid, false, STAGE_UUID_PRESENT);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +=09/* test find_multipaths =3D FIND_MULTIPATHS_OFF */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_OFF;
> > +=09setup_passing(name, wwid, false, STAGE_UUID_PRESENT);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +=09/* test find_multipaths =3D FIND_MULTIPATHS_ON */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_ON;
> > +=09setup_passing(name, wwid, false, STAGE_UUID_PRESENT);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_NOT_VALID);
> > +=09/* test find_multipaths =3D FIND_MULTIPATHS_SMART */
> > +=09memset(&pp, 0, sizeof(pp));
> > +=09conf.find_multipaths =3D FIND_MULTIPATHS_SMART;
> > +=09setup_passing(name, wwid, false, STAGE_UUID_PRESENT);
> > +=09assert_int_equal(is_path_valid(name, &conf, &pp, false),
> > +=09=09=09 PATH_IS_MAYBE_VALID);
> > +=09assert_string_equal(pp.dev, name);
> > +=09assert_ptr_equal(pp.udev, &test_udev);
> > +=09assert_string_equal(pp.wwid, wwid);
> > +}
> > +
> > +int test_valid(void)
> > +{
> > +=09const struct CMUnitTest tests[] =3D {
> > +=09=09cmocka_unit_test(test_bad_arguments),
> > +=09=09cmocka_unit_test(test_sysfs_is_multipathed),
> > +=09=09cmocka_unit_test(test_check_multipathd),
> > +=09=09cmocka_unit_test(test_pathinfo),
> > +=09=09cmocka_unit_test(test_is_failed_wwid),
> > +=09=09cmocka_unit_test(test_greedy),
> > +=09=09cmocka_unit_test(test_check_wwids),
> > +=09=09cmocka_unit_test(test_check_uuid_present),
> > +=09=09cmocka_unit_test(test_find_multipaths),
> > +=09};
> > +=09return cmocka_run_group_tests(tests, NULL, NULL);
> > +}
> > +
> > +int main(void)
> > +{
> > +=09int ret =3D 0;
> > +=09ret +=3D test_valid();
> > +=09return ret;
> > +}
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
