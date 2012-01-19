From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH 0/3][RESEND]multipath-tools: mpathpersist utility
	for managing persistent reservation on dm multipath device.
Date: Fri, 20 Jan 2012 00:50:48 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr, Mike Snitzer <snitzer@redhat.com>, Fil <lists@internyc.net>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
List-Id: dm-devel.ids

Resending this patch with the fix mentioned by Mike Snitzer<snitzer@redhat.com> and Fil<lists@internyc.net>. 
Thanks to all for sending me your review comments. Fil, Thanks for trying out mpathpersist and providing your 
feedback. Also thanking Yanling Qi<Yanling.Qi@netapp.com> for proposing this design for pr management feature. 
These series of patch is made on commit 864162b08067d3e55d52996846d10a046956c6d6.


PERSISTENT RESERVE OUT/IN commands are currently not supported on mpath device. Any 
command sent to mpath device is routed to only one of the physical path (selected by 
path selector) from the active path group. PR OUT registration service action is one 
of the such use-case which fails as it expects all the physical path for the given mpath 
device to be registered. Due to these limitations, most of the cluster applications needs 
to manage persistent reservation through underlying physical path.


Following are the detailed description for Persistent Reservation management feature:
======================================================================================
CONTENT
=======================================================================================
1. Feature Introduction
2. Steps to configure for persistent reservation management
3. mpathpersist Command Usage
4. PR IN/OUT  service action and use-case handling
	4.1 Persistent Reserve Out service action
		4.1.1 [Register] 
		4.1.2 [Reserve]
		4.1.3 [Release]
		4.1.4 [CLEAR]
		4.1.5 [PREEMPT] & [PREEMPT AND ABORT]		
	4.2 Persistent Reserve In service action
		4.2.1 [READ KEY] 
		4.2.2 [READ RESERVATION]
		4.2.3 [READ STATUS]
		4.2.4 [REPORT CAPABILITIES]
	4.3 Usage case handled by multipath tools for PR management
5. mpathpersist library and header 
	5.1 mpathpersist  Library  APIs.
		5.1.1 int mpath_lib_init (void )
		5.1.2 int mpath_lib_exit (void )
		5.1.3 int mpath_persistent_reserve_in (int fd, int rq_servact,
				struct prin_resp *resp, int noisy, int verbose)			
		5.1.4 int mpath_persistent_reserve_out ( int fd, int rq_servact, 
				int rq_scope, unsigned int rq_type, struct rout_param_descriptor *paramp, 
				int noisy, int verbose)
6. Limitation and restriction.



1. Feature Introduction
==========================

Persistent reservation management feature allows cluster management software to manage 
persistent reservation through mpath device. It processes management requests from callers 
and hides the management task details. It also handles persistent reservation management of 
data path life cycle and state changes.

The series of patch introduces new utility named 'mpathpersist' for managing pr on multipath device.
'mpathpersist' is similar to sg_persist utility with respect to cli usage but 
applicable to mpath devices only.


2. Steps to configure for persistent reservation management
=============================================================
This feature adds new parameter 'reservation_key' in default section and multipath section of 
multipath.conf. 

'reservation_key'  here represents RESERVATION KEY field of PERSISTENT RESERVE OUT parameter 
list which contains an 8-byte value provided by the application client to the device server 
to identify the I_T nexus.
 
STEP 1: Set reservation_key parameter in multipath.conf for mpath device. 'reservation_key' 
parameter needs to be set for all the mpath device applicable for persistent management.
STEP 2: restart multipathd daemon

Note: reservation key in multipath.com must be same as service action reservation key used/to 
be used for mpath device registration reservation.


3. mpathpersist Command Usage
===============================

mpathpersist CLI usage is kept close to sg_persist usage except it takes mpath device as device name.

Usage: mpathpersist [OPTIONS] [DEVICE]
 Options:
    --verbose|-v level         verbosity level
                   0           Critical messages
                   1           Error messages
                   2           Warning messages
                   3           Informational messages
                   4           Informational messages with trace enabled
    --clear|-C                 PR Out: Clear
    --device=DEVICE|-d DEVICE  query or change DEVICE
    --help|-h                  output this usage message
    --hex|-H                   output response in hex
    --in|-i                    request PR In command
    --out|-o                   request PR Out command
    --param-aptpl|-Z           PR Out parameter 'APTPL'
    --read-keys|-k             PR In: Read Keys
    --param-sark=SARK|-S SARK  PR Out parameter service action
                               reservation key (SARK is in hex)
    --param-rk=RK|-K RK        PR Out parameter reservation key
                               (RK is in hex)
    --preempt|-P               PR Out: Preempt
    --preempt-abort|-A         PR Out: Preempt and Abort
    --prout-type=TYPE|-T TYPE  PR Out command type
    --read-status|-s           PR In: Read Full Status
    --read-keys|-k             PR In: Read Keys
    --read-reservation|-r      PR In: Read Reservation
    --register|-G              PR Out: Register
    --register-ignore|-I       PR Out: Register and Ignore
    --release|-L               PR Out: Release
    --report-capabilities|-c   PR In: Report Capabilities
    --reserve|-R               PR Out: Reserve
    --transport-id=TIDS|-X TIDS  TransportIDs can be mentioned
                               in several forms


4. PR IN/OUT  service action and use-case handling
===================================================

4.1 Persistent Reserve Out service action:
----------------------------------
4.1.1 [Register] 
The caller provides multipath device name, reservation key, and service action reservation 
key and optionally APTPL bit value. The persistent reservation management command issues PROUT 
Register service action to all active data paths of the multipath device. If reservation key or 
service action reservation key is not provided, fill with all 0s. For each path, a thread is 
created to process PROUT register service action. Consolidated results of all the paths are 
returned to caller. In case if this PROUT command fails with reservation conflict, all the 
successful registration by other threads will be rolled back.
Example:	mpathpersist --out --register --param-sark=123abc --prout-type=8 /dev/mapper/mpath9
			/*Unregister*/
		mpathpersist --out --register --param-rk=123abc --prout-type=8 /dev/mapper/mpath9


4.1.2 [Reserve]
The caller provides multipath device name, reservation type and reservation key. The reservation SCOPE 
value is not required since persistent reservation supports only LU_SCOPE. The persistent reservation 
management command issues PROUT Reserve service action to any active data paths of the multipath
device. PROUT command is send to one of the active path of multipath device. Result is returned to the 
caller of this module.
Example:	mpathpersist --out --reserve --param-rk=123abc --prout-type=8 /dev/mapper/mpath9


4.1.3 [Release]
The caller provides multipath device name, reservation type and reservation key. The persistent reservation 
management command issues PROUT Release service action to all active data paths of the multipath device. The 
reason why issuing PROUT Release service action is because it is unclear which data path is the reservation 
holder. If RESERVATION CONFLICT SCSI status is received, it indicates that either the reservation key or
reservation type is invalid. Return error status back to the caller. After PROUT Release service action command 
is issued to all active data paths, a PRIN Read Reservation service action should be issued to an active data 
path. If the Read Reservation parameter data indicates that the logical unit is still reserved and the registration 
key matches the reservation key caller provided, this indicates that the reservation holder belongs to a data 
path in failed state or removed data path of the multipath device. 
The following operations should be taken for this error case. 
1. Issue a PRIN Report Full Status service action to any active data path
2. Remember the full status descriptors returned from the step 1.
3. Issue a PROUT clear reservation service action, via any active data path, to clear the reservation and registrants
 and
4. Restore all registrants by issuing PROUT register service action with transport IDs from the full status 
 descriptors saved in the step 2.
Example:	mpathpersist --out --release --param-rk=123abc --prout-type=8 /dev/mapper/mpath9


4.1.4 [CLEAR]
The caller provides multipath device name and reservation key. The persistent reservation management
command issues PROUT Preempt service action to any active data paths of the multipath device.
If RESERVATION CONFLICT SCSI status is received, it indicates that the reservation key is invalid or the
data path is not a registrant. Return error status back to the caller.
Example:	mpathpersist --out --clear --param-rk=123abc --prout-type=8 /dev/mapper/mpath9
  

4.1.5 [PREEMPT] & [PREEMPT AND ABORT]
The caller provides multipath device name, reservation type, reservation key and service action reservation key. 
The persistent reservation management command issues PROUT Preempt service action to any active data paths of the 
multipath device. If RESERVATION CONFLICT SCSI status is received, it indicates that either the reservation key or 
service action reservation key is invalid. Return error status back to the caller. PROUT command is send to one of 
the active path of multipath device. Result is returned to the caller of this module.
Example: mpathpersist --out --preempt-abort --param-rk=0 --paramsark=789def --prout-type=8 /dev/mapper/mpath9


PS: This feature does not support ALL_TG_PT bit on. With a storage array having 8 or 16 target ports, the 
total number of registrants will be equal to total-number-of-initiator-ports X total-number-of target-ports. 
If ALL_TG_PT is on, too much storage array resources will be wasted and it also creates implementation 
challenge of managing registration rollback. In a use case where one initiator port (such as a FC port) connects 
to multiple target ports on the same storage array via a switch, ALL_TG_PT=1 will cause registration failed with 
RESERVATION CONFLICT status when issuing PROUT registration to the second data path which shares the same initiator port.

PS: This RFC version does not support REGISTER AND MOVE service action.

4.2 Persistent Reserve In service action:
--------------------------------------------
4.2.1 [READ KEY] 
The caller provides multipath device. The persistent reservation management command selects any active data path 
and issues a PRIN Read Keys service action to the selected data path of the multipath device. Parameter data is sent 
to the caller with appropriate formatted. The persistent reservation management command will not filter registration 
keys returned from the storage array. In other words, multiple registration keys is reported in general.
Example:	mpathpersist -i -k /dev/mapper/mpath9 


4.2.2 [READ RESERVATION]
The caller provides multipath device. The persistent reservation management command selects any active data path and 
issues a PRIN Read Reservation service action to the selected data path of the multipath device. Parameter data is 
sent to the caller with appropriate formatted.
Example:	mpathpersist -i -r /dev/mapper/mpath9 


4.2.3 [READ STATUS]
The caller provides multipath device. The persistent reservation management command selects any active data path and 
issues a PRIN Read Full Status service action to the selected data path of the multipath device. Parameter data is sent 
to the caller with appropriate formatted. The persistent reservation management command will not filter full status 
descriptor entries returned from the storage array. In other words, full statuses for multiple registrants is reported 
in general.
Example:	mpathpersist -i -s /dev/mapper/mpath9


4.2.4 [REPORT CAPABILITIES]
The caller provides multipath device. The persistent reservation management command selects any active data path
and issues a PRIN Report Capabilities service action to the selected data path of the multipath device. Parameter
data is sent to the caller with appropriate formatted.
Example:	mpathpersist -i -c /dev/mapper/mpath9


4.3 Use-case handled by multipath tools for PR management
- For any reinstated path, multipath daemon checks for persistent reservation on the path and registers the 
path with reservation_key (from multipath.conf) if required.
- For any new path discovery, multipath daemon checks for persistent reservation on the path and registers the path if required.
- In case of device all path failure condition, command is returns with failed status.
- PR command is retried by pr management for any Unit Attention.
- While performing persistent reservation registration on mpath device, if any of the path receives reservation conflict 
  then successful registration on the other paths will be rolled back.

5. mpathpersist Library and Header
======================================


mpathpersist library provides four APIs for managing persistent reservation on device mapper multipath device. 

5.1 mpathpersist  Library  APIs.
---------------------------------
5.1.1 int mpath_lib_init (void)
DESCRIPTION :
Initialize device mapper multipath configuration. This function must be invoked first before performing reservation 
management functions.

RETURNS:
0->Success, 1->Failed
Note: mpath_lib_init function must be called at the start of the usage of PR management APIs (such as 
mpath_persistent_reserve_in or mpath_persistent_reserve_out). This function is responsible for initializing 
config table. (Any dynamic allocation done by mpath_lib_init function will be de-allocated only by mpath_lib_exit API).


5.1.2  int mpath_lib_exit (void)
DESCRIPTION:
Release device mapper multipath configuration. This function must be invoked after performing reservation management functions.

RETURNS:
0->Success, 1->Failed.

Note: mpath_lib_exit function must be called at the end of the usage of PR management APIs (such as mpath_persistent_reserve_in 
or mpath_persistent_reserve_out). This function is responsible for freeing up the dynamic allocation made by mpath_lib_init function.


5.1.3 int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)
DESCRIPTION:
The function in the mpath_persistent_reserve_in() sends PRIN command to the DM device and gets the response.

PARAMETERS:
fd - The file descriptor of a multipath device. Input argument.
rq_servact  -  PRIN command service action. Input argument
resp - The response from PRIN service action. The caller should manage the memory allocation of this structure
noisy - Turn on debugging trace: Input argument. 0->Disable, 1->Enable
verbose -  Set verbosity level. Input argument. value:[0-3]. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug

RETURNS
	MPATH_PR_SUCCESS if PR command successful
	MPATH_PR_SYNTAX_ERROR if syntax error or invalid parameter
	MPATH_PR_SENSE_NOT_READY if command fails with [sk,asc,ascq: 0x2,*,*]
	MPATH_PR_SENSE_MEDIUM_ERROR if command fails with [sk,asc,ascq: 0x3,*,*]
	MPATH_PR_SENSE_HARDWARE_ERROR if command fails with [sk,asc,ascq: 0x4,*,*]
	MPATH_PR_SENSE_INVALID_OP if command fails with [sk,asc,ascq: 0x5,0x20,0x0]
	MPATH_PR_ILLEGAL_REQ if command fails with [sk,asc,ascq: 0x5,*,*]
	MPATH_PR_SENSE_UNIT_ATTENTION if command fails with [sk,asc,ascq: 0x6,*,*]
	MPATH_PR_SENSE_ABORTED_COMMAND if command fails with [sk,asc,ascq: 0xb,*,*]
	MPATH_PR_NO_SENSE if command fails with [sk,asc,ascq: 0x0,*,*]
      MPATH_PR_SENSE_MALFORMED if command fails with SCSI command malformed
      MPATH_PR_FILE_ERROR if command fails while accessing file (device node) problems(e.g. not found)
      MPATH_PR_DMMP_ERROR if Device Mapper related error.(e.g Error in getting dm info)
      MPATH_PR_OTHER if other error/warning has occurred(e.g transport or driver error)


5.1.4 int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope, unsigned int rq_type,
                struct rout_param_descriptor *paramp, int noisy, int verbose)
DESCRIPTION
The function in the mpath_persistent_reserve_out() sends PR OUT command to the DM device and gets the response.

PARAMETERS:
fd - The file descriptor of a multipath device. Input argument.
rq_servact  - PROUT command service action. Input argument
rq_scope - Persistent reservation scope. The value should be always LU_SCOPE (0h).
rq_type - Persistent reservation type. The valid values of persistent reservation types are
             5h (Write exclusive - registrants only)
             8h (Exclusive access - registrants only)
             7h (Write exclusive - All registrants)
             8h (Exclusive access - All registrants).
paramp - PROUT  command  parameter  data.  The paramp is a struct which describes PROUT parameter list. Caller should
                 manage the memory  allocation of this structure. 
noisy - Turn on debugging trace: Input argument. 0->Disable, 1->Enable.
verbose - Set verbosity level. Input argument. value: 0 to 3. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug

6. Limitation and restriction
	-This feature doesn't support persistent reservation types of Write-Exclusive (1h) 
	 and Exclusive-Access(3h).
	- This feature will not support ALL_TG_PT bit on. 
	- Current implementation is limited to FC SAS and ISCSI transport protocol. Other protocol support could be added in future.


Regards,
Vijay Chauhan



git status for newly added or changed files in multipath-tools:

# git diff -p --stat
 Makefile                  |    2 +
 Makefile.inc              |    2 +
 libmultipath/config.c     |    2 +
 libmultipath/config.h     |    2 +
 libmultipath/configure.c  |    1 +
 libmultipath/dict.c       |  114 ++++++++++++++++++++++++++++++++++++
 libmultipath/discovery.c  |    2 +-
 libmultipath/propsel.c    |   46 +++++++++++++++
 libmultipath/propsel.h    |    1 +
 libmultipath/structs.h    |    4 +
 multipathd/Makefile       |    4 +-
 multipathd/cli.c          |   29 ++++++----
 multipathd/cli.h          |   16 ++++--
 multipathd/cli_handlers.c |   72 +++++++++++++++++++++++
 multipathd/cli_handlers.h |    4 +
 multipathd/main.c         |  140 +++++++++++++++++++++++++++++++++++++++++++++
 multipathd/main.h         |   14 +++++

# git status -s
 M Makefile
 M Makefile.inc
A  libmpathpersist/Makefile
A  libmpathpersist/mpath_persist.c
A  libmpathpersist/mpath_persist.h
A  libmpathpersist/mpath_persistent_reserve_in.3
A  libmpathpersist/mpath_persistent_reserve_out.3
A  libmpathpersist/mpath_pr_ioctl.c
A  libmpathpersist/mpath_pr_ioctl.h
A  libmpathpersist/mpath_updatepr.c
A  libmpathpersist/mpathpr.h
 M libmultipath/config.c
 M libmultipath/config.h
 M libmultipath/configure.c
 M libmultipath/dict.c
 M libmultipath/discovery.c
 M libmultipath/propsel.c
 M libmultipath/propsel.h
 M libmultipath/structs.h
A  mpathpersist/Makefile
A  mpathpersist/main.c
A  mpathpersist/main.h
A  mpathpersist/mpathpersist.8
 M multipathd/Makefile
 M multipathd/cli.c
 M multipathd/cli.h
 M multipathd/cli_handlers.c
 M multipathd/cli_handlers.h
 M multipathd/main.c
 M multipathd/main.h 
