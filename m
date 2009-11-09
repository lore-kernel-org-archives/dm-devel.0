From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [patch 0/1][RESEND] New Logging approach for Device
	Mapper
Date: Mon, 9 Nov 2009 16:37:02 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C03EA5@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "agk@redhat.com" <agk@redhat.com>, "hare@suse.de" <hare@suse.de>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Hi,

I have modified the previous dm logging patch to print logs in more user =
friendly format.=20

Ex :
Nov  9 16:45:04 localhost kernel: device-mapper: multipath: [dm-1] Switch=
ing to pathgroup index 1
Nov  9 16:45:04 localhost kernel: device-mapper: multipath: [dm-1] Select=
ing path sdc for I/O


This new patch includes following changes:
 - printing "[dm-*]" instead of "major:minor"
 - Added 3 macro functions for logging=20
	# define DMLOG(..)
		* It should be used when  we just want to print message without device =
name.
		Prototype : #define DMLOG(SHIFT, LEVEL, f, arg...)
		Usage ex: DMLOG(DMLOG_INIT, DMLOG_INFO, "cleaned up");
		=20
	# define DMLOG1(..)
		* prints device name with messages
		* (struct mapped_device * ) needs to be passed as 3rd argument to this =
macro function
		Prototype : #define DMLOG1(SHIFT, LEVEL, MAPPED_DEVICE, f, arg...)
		Usage ex: DMLOG1(DMLOG_IOCTL, DMLOG_INFO, md, " Setting DMF_NOFLUSH_SUS=
PENDING flag");

	# define DMLOG2(..)
		* prints device name with messages
		* (struct dm_target * ) needs to be passed as 3rd argument to this macr=
o function.=20
		  (Typically to be used by target)
		Prototype : #define DMLOG2(SHIFT, LEVEL, DM_TARGET, f, arg...)
		Usage ex: DMLOG2(DMLOG_IOCTL, ti, "Unrecognised multipath message recei=
ved.");


How to set logging level :
---------------------------
[copy paste from my previous mail]

1) On-the-fly by setting /sys/module/dm_mod/parameters/dm_logging_level.=20

For example: To enable DMLOG_INIT logs for all ERROR (i.e DMLOG_ERR level=
) and DMLOG_ADD_DEV logs at DMLOG_INFO level, we can set as=20
               follows:
	4   2   0       	=20
	|_|_|_|_|
       1 1 0 1   -->0x0d or 13	=20
=09
	echo 0x0000000d > >/sys/module/dm_mod/parameters/dm_logging_level
			or
	echo 13 >/sys/module/dm_mod/parameters/dm_logging_level


2) At boot time using modprobe.conf:
		options dm-mod dm_logging_level=3D13
=09

-------------------------------------------------------------------------=
-----
dm_logging_level bitwise representation (2 bit reserved for each logging =
type)
-------------------------------------------------------------------------=
-----

  	  20  18  16  14  12  10  8   6   4   2   0=09
      ......|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|        =20
            \   \   \   \   \   \   \   \   \   \_DMLOG_INIT  =20
          	 \   \   \   \   \   \   \   \   \_DMLOG_ADD_DEV   =20
              \   \   \   \   \   \   \   \_DMLOG_REMOVE_DEV
               \   \   \   \   \   \   \_DMLOG_IOCTL
                \   \   \   \   \   \_DMLOG_IO  =20
                 \   \   \   \   \_DMLOG_UEVENT  =20
                  \   \   \   \_DMLOG_TABLE
                   \   \   \_DMLOG_FAILOVER        =20
                    \   \_DMLOG_PATH_ACTIVATE
	               \_DMLOG_PATH_DEACTIVATE



snippet of syslog with new logging patch:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Nov  9 21:33:29 localhost kernel: device-mapper: multipath: version 1.1.0=
 loaded
Nov  9 21:33:29 localhost kernel: device-mapper: dm-path-selector: path s=
elector round-robin registered successfully
Nov  9 21:33:29 localhost kernel: device-mapper: multipath round-robin: v=
ersion 1.0.0 loaded
Nov  9 21:33:29 localhost kernel: device-mapper: dm-path-selector: path s=
elector module round-robin Loaded successfully
Nov  9 21:33:29 localhost kernel: device-mapper: ioctl: 3600a0b80003908f9=
000047ec4a10b680: Creating dm device
Nov  9 21:33:29 localhost kernel: device-mapper: ioctl: [dm-0] Inserting =
in hash table
Nov  9 21:33:29 localhost kernel: device-mapper: ioctl: [dm-0] Successful=
ly inserted in hash table
Nov  9 21:33:29 localhost multipathd: 3600a0b80003908f9000047ec4a10b680: =
load table [0 2097152 multipath 2 pg_init_retries 49 1 rdac 2 1 round-rob=
in 0 1 1 8:16 1000
Nov  9 21:33:29 localhost kernel: device-mapper: ioctl: 3600a0b80003910f3=
000058264a7e46cb: Creating dm device
Nov  9 21:33:29 localhost kernel: device-mapper: ioctl: [dm-1] Inserting =
in hash table
Nov  9 21:33:29 localhost kernel: device-mapper: ioctl: [dm-1] Successful=
ly inserted in hash table
Nov  9 21:33:29 localhost multipathd: 3600a0b80003910f3000058264a7e46cb: =
load table [0 20971520 multipath 2 pg_init_retries 49 1 rdac 2 1 round-ro=
bin 0 1 1 8:32 1000
Nov  9 21:33:29 localhost multipathd: 3600a0b80003908f9000047ec4a10b680: =
event checker started
Nov  9 21:33:29 localhost multipathd: 3600a0b80003910f3000058264a7e46cb: =
event checker started
Nov  9 21:33:29 localhost multipathd: path checkers start up
Nov  9 21:33:29 localhost kernel: device-mapper: multipath: [dm-1] Switch=
ing to pathgroup index 1
Nov  9 21:33:29 localhost kernel: device-mapper: multipath: [dm-1] Select=
ing path sdc for I/O
Nov  9 21:33:29 localhost kernel: device-mapper: multipath: [dm-1] pg_ini=
t_done: failover status =3D 0
Nov  9 21:33:30 localhost kernel: device-mapper: multipath: [dm-0] Switch=
ing to pathgroup index 1
Nov  9 21:33:30 localhost kernel: device-mapper: multipath: [dm-0] Select=
ing path sdb for I/O
Nov  9 21:33:30 localhost kernel: device-mapper: multipath: [dm-0] pg_ini=
t_done: failover status =3D 0



Please give your comments.

Thanks,
Vijay


On September 07, 2009 12:59 PM, Chauhan, Vijay wrote :
 >=20
 > On Sun, Sep 6, 2009 at 5:03 AM, Alasdair G Kergon=20
 > <agk@redhat.com> wrote:
 > > > Each logging type is represented with 2 bits in=20
 > > dm_logging_level. Following are the logging types=20
 > currently defined :
 > >=20
 > > Does that mean there's a limit we'll soon exceed?
 >=20
 > Yes true. In that case we can further split the logging=20
 > across the targets , such as multipath, linear so on. Your=20
 > thoughts please.
 >=20
 > >=20
 > > > Sep  5 18:32:02 localhost kernel: device-mapper: core:=20
 > > DEBUG: dm_resume: Unsetting DMF_SUSPENDED flag for 253:1
 > >=20
 > > I was hoping the next extension to the macro code would=20
 > > somehow add info
 > > like '253:1' (and maybe corresponding device name) automatically to
 > > every message related to a device.
 > >=20
