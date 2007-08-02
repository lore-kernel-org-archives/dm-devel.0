From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: Segmentation Fault Question
Date: Thu, 2 Aug 2007 10:38:43 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC012EECCA@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Hello everyone, I think I've found an issue in libdevmapper-event.c that
is generating a segmentation fault condition for me during some boundary
testing. I wanted to get some advice on how the patch I'm going to make
should fix this. Here's the snippet that leads to the segfault:

In the file libdevmapper-event.c at line 722 the _get_device_info() call
can return NULL to dmt on failure. This causes the leap to the "fail"
label where the null pointer is passed into dm_task_destroy().=20

   int dm_event_get_registered_device(struct dm_event_handler *dmevh,
int next)
   {
      .
      .
      .
      if (!(dmt =3D _get_device_info(dmevh))) {
		ret =3D -ENXIO; /* dmeventd probably gave us bogus uuid
back */
		goto fail;
	}
      .
      .
      .
      fail:
	if (msg.data)
		dm_free(msg.data);
	if (reply_dso)
		dm_free(reply_dso);
	if (reply_uuid)
		dm_free(reply_uuid);
	_dm_event_handler_clear_dev_info(dmevh);
	dm_task_destroy(dmt);


In the file libdm-iface.c at line 320 where dm_task_destroy() resides it
blindly uses the passed in pointer without checking if its NULL; this is
where the segmentation fault occurs.

   void dm_task_destroy(struct dm_task *dmt)
   {
	struct target *t, *n;

	for (t =3D dmt->head; t; t =3D n) {
      .
      .
      .


My question is should the patch insert a test condition of the pointer
before using it in the "for" loop (which is where I want to put the
fix)? Or is there another preferred way the maintainers of device-mapper
would like to handle error checking in this case?

=20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com
