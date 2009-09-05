From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [RFC] New  Logging approach for Device Mapper
Date: Sun, 6 Sep 2009 00:36:02 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8EAE093B@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
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
To: "agk@redhat.com" <agk@redhat.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Hi Alasdair and All,

Currently device mapper has DMCRIT, DMERR, DMWARN & DMINFO macros for log=
ging messages. These macros are printk's with printk levels  KERN_CRIT, K=
ERN_ERR, KERN_WARNING & KERN_INFO respectively.

---------------------------------------------------
Following are the disadvantages with above approach:=20
---------------------------------------------------
* To enable these logs we need to set printk levels which may also enable=
 all other printk's (non dm related) resulting in populating syslog.

* We do not have sub categories within each Log type in DM. As a reason e=
nabling specific logging type enables all the logging messages set at the=
ir printk level. It may take more time for us in filtering the relevant m=
essages.

-----------------------------
New proposal for dm logging :
-----------------------------
Below is the new logging style I am proposing for device mapper. The form=
at is very similar to scsi logging level.=20

Thanks Chandra for his initial comments and reviews.
=09
I am replacing existing [DMCRIT, DMERR, DMWARN & DMINFO] macros with [DML=
OG] macro which looks as following:


#define DMLOG_BITS                      2

#  define DMLOG_LEVEL(SHIFT)                             \
        ((dm_logging_level >> (SHIFT * DMLOG_BITS)) & ((1 << (DMLOG_BITS)=
) - 1))

#  define DMLOG( SHIFT, LEVEL, f, arg...) \
        do {                                                            \
                if ((DMLOG_LEVEL(SHIFT)) >=3D (LEVEL))                   =
                                 \
                        do {                                            \
                                printk(DM_NAME ": " DM_MSG_PREFIX ": " \
                                        "DEBUG: %s: " f "\n", __FUNCTION_=
_, ## arg); \
                        } while (0);                                    \
        } while (0)




I am adding dm_logging_level (unsigned int ) as module param in dm-mod ke=
rnel module. This is used to set dm logging level on-the-fly  as=20
	echo "[LEVEL]" >/sys/module/dm_mod/parameters/dm_logging_level
  			or	 =20
at the load time from modprobe config file with following setting:
	options dm-mod  dm_logging_level=3D[level]


Each logging type is represented with 2 bits in dm_logging_level. Followi=
ng are the logging types currently defined :
	DMLOG_INIT=20
	DMLOG_ADD_DEV=20
	DMLOG_REMOVE_DEV
	DMLOG_IOCTL
	DMLOG_IO
      DMLOG_UEVENT
	DM_LOG_TABLE
			=09
	DMLOG_FAILOVER		//for multipath=20
	DMLOG_PATH_ACTIVATE
	DMLOG_PATH_DEACTIVATE



These 2 bits for each logging type are used to represent either of 4 logg=
ing levels mentioned below:
/* DM Logging level */
#define DMLOG_CRIT                   0   		//CRITICAL
#define DMLOG_ERR                    1		//ERROR=09
#define DMLOG_WARN                   2		//WARNING
#define DMLOG_INFO                   3		//INFORMATIONAL


---------------------------------------
dm_logging_level bitwise representation
---------------------------------------

  	  20  18  16  14  12  10  8   6   4   2   0=09
      ..|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|        =20
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



----------------------------------
How to add logging in DM code:
----------------------------------
Logs can be added in code with DMLOG macro in following format:

DMLOG([DMLOG TYPE], [DMLOG LEVEL], [DEBUG message]);

Ex:
 DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector %s registered successfully"=
, pst->name);


-----------------------------------
How to enable DM logging
------------------------------------
1) DM logging can be enabled on-the-fly by setting /sys/module/dm_mod/par=
ameters/dm_logging_level.=20

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

       (PS: If the above approach looks fine then I can come up with more=
 user friendly interface to set logging from=20
             dmsetup utility)


2) At boot time by mentioning it in modprobe.conf:
		options dm-mod dm_logging_level=3D13
=09

--------------------------------------------
Advantage of using new DM LOGGING style:
--------------------------------------------
* Logging level can be enabled with specific logging types. This avoids p=
opulating non-relevant logging messages.
* Each logging type can be set with their respective logging level. It wi=
ll help in filtering and root causing issue with ease.
* ALL critical messages with be logged by default


------------
Limitation
------------
* CONFIG_DM_DEBUG=3Dy should be set in order to enable dm logging

--------------------------------------------------
Following are syslog snippet with debug enabled:
--------------------------------------------------

Sep  5 18:31:54 localhost kernel: device-mapper: ioctl: DEBUG: dm_hash_in=
sert: Successfully inserted 3600a0b80003908f9000057c74a839420 in hash tab=
le
Sep  5 18:31:54 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd09 called from userspace.
Sep  5 18:31:54 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd06 called from userspace.
Sep  5 18:31:54 localhost kernel: device-mapper: core: DEBUG: dm_suspend:=
 Setting DMF_BLOCK_IO_FOR_SUSPEND and DMF_QUEUE_IO_TO_THREAD flags for 25=
3:0
Sep  5 18:31:54 localhost kernel: device-mapper: core: DEBUG: dm_suspend:=
 Setting DMF_SUSPENDED flag for 253:0
Sep  5 18:31:54 localhost kernel: device-mapper: core: DEBUG: dm_resume: =
Unsetting DMF_SUSPENDED flag for 253:0
Sep  5 18:31:54 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd0e called from userspace.
Sep  5 18:31:54 localhost multipathd: 3600a0b80003908f9000057c74a839420: =
load table [0 204800 multipath 2 pg_init_retries 50 0 1 1 round-robin 0 1=
 1 8:32 100]
Sep  5 18:32:01 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd02 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd0c called from userspace.
Sep  5 18:32:02 localhost last message repeated 2 times
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd07 called from userspace.
Sep  5 18:32:02 localhost last message repeated 2 times
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd03 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: dev_create=
: Creating dm device for 3600a0b80003908f9000057c64a83941a
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: dm_hash_in=
sert: inserting 3600a0b80003908f9000057c64a83941a in hash table
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: dm_hash_in=
sert: Successfully inserted 3600a0b80003908f9000057c64a83941a in hash tab=
le
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd00 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd07 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd09 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd06 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: core: DEBUG: dm_suspend:=
 Setting DMF_BLOCK_IO_FOR_SUSPEND and DMF_QUEUE_IO_TO_THREAD flags for 25=
3:1
Sep  5 18:32:02 localhost kernel: device-mapper: core: DEBUG: dm_suspend:=
 Setting DMF_SUSPENDED flag for 253:1
Sep  5 18:32:02 localhost kernel: device-mapper: core: DEBUG: dm_resume: =
Unsetting DMF_SUSPENDED flag for 253:1
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd0e called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd02 called from userspace.
Sep  5 18:32:02 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd0c called from userspace.
Sep  5 18:32:03 localhost multipathd: 3600a0b80003908f9000057c64a83941a: =
load table [0 204800 multipath 2 pg_init_retries 50 0 1 1 round-robin 0 1=
 1 8:16 100]
Sep  5 18:32:07 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd0c called from userspace.
Sep  5 18:32:07 localhost multipathd: 3600a0b80003908f9000057c84a839426: =
load table [0 204800 multipath 2 pg_init_retries 50 0 1 1 round-robin 0 1=
 1 8:48 100]
Sep  5 18:32:07 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 IOCTL command 0xc138fd0c called from userspace.
Sep  5 18:32:07 localhost multipathd: 3600a0b80003908f9000057ca4a839432: =
load table [0 204800 multipath 2 pg_init_retries 50 0 1 1 round-robin 0 1=
 1 8:80 100]=20



Thanks,
Vijay
