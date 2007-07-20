From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: Question about dmevents
Date: Fri, 20 Jul 2007 09:02:18 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC0122629E@orsmsx418.amr.corp.intel.com>
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

Hello everyone, I have a question about something in the
"libdevmapper-event.c" code. I'm building a test application that I can
use to setup events I would like to register with dmeventd. As suggested
by Jonathan Brassow I've used the framework from lib/mirror/mirrored.c
in LVM2 as a template to creating my setup code in the test application.
Right now I'm hard coding in the name of the dso and the name of the
device I would like to register as a watch point. Here is how I get
things going:=20

Create a structure "dm_event_handler"
Set char *dso to a stub dso (created for testing).
Set char *name to "/dev/mapper/XXXXX_Volume0p1" (one of my dm device
names)=20
Call "dm_event_handler_create()"
Call "dm_event_handler_set_dso()"
Call "dm_event_handler_set_dev_name()"

After setting all this up I call "dm_event_register_handler()" passing
in the "dm_event_handler" structure. Inside this call the first thing is
a call to "_get_device_info()" that sets up my "dm_task" structure.
Inside this function I noticed the "dm_task_create()" function sets up
the dm_task structure, but leaves uuid as null. We then test uuid (since
its null it jumps past the first "if" statement heading into
dm_task_set_name()). In here it cuts off the "/dev/mapper/" and sets
dev_name to XXXXX and returns as it should.

After this long setup here's the problem I'm having. I run through the
remaining function calls in _get_device_info() and my uuid for the
dm_task is still null. The last call before sending this message off to
dmeventd using the "_do_event()" is a call to dm_task_get_uuid() that is
passed my dm_task struct. This should return a uuid string, but returns
null since my dm_task is never getting a uuid set. Without this I get a
failure on the dmeventd side stating I passed a null pointer into
dm_strdup via the function _alloc_thread_status (where it checks the
uuid field).=20

Just as a test, in my gdb session I set the uuid to some text string,
"blah" for example, and I'm able to register my event and get a
"SUCCESS" message back in the FIFO.=20

=20
My one clue is that I noticed back in _get_device_info() a line that
says
 	/* FIXME Add name or uuid or devno to messages */
Does this mean that there needs to be code added to setup the dm_task
uuid? Or is there another call in libdevmapper.h that I'm missing that I
can use to set this up?

Thank you for any help you might be able to offer; I'm hoping I just
missed calling a libdevmapper* initialization function :)


Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com
