From: "goggin, edward" <egoggin@emc.com>
Subject: version 0.4.3-pre(3,
	5) multipath tools have memory/cpu consumptio n issues
Date: Fri, 4 Mar 2005 17:57:29 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A7F7@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_000_01C5210D.8A481830"
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'christophe varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5210D.8A481830
Content-Type: text/plain

The recent change to multipath/main.c:main() to include an inner loop which
"calls both devt2devname() and devinfo() for each sysfs discovered path"
inside
an outer loop which runs for each currently configured multipath mapped
device
in the kernel has turned multipath(8) into both a cpu and memory monster.

top(1) shows that a simple "multipath -v0 -l" command has been running for
over
20 minutes of "cpu time" over a 25 minute time span and it has not yet
finished!

This is only after fixing a bug in devt2devname() where the sysfs directory
wasn't
being closed before returning after matching the specified dev_t with a
sysfs entry.
Simply adding call to sysfs_close_directory() before early prevented huge
memory
consumption from keeping anything else from happening on the machine.  I
found
another much smaller memory leak in multipath/devinfo.c:apply_format() and
the
calls to apply_format() from multipath/devinfo.c:devinfo().  I've enclosed a
patch for
devinfo.c with both of these leaks fixed.
 <<devinfo.c.patch>> 

It looks like this change is to allow multipath to retrieve "very recent"
path health
before comparing this path health status with the path status from the
kernel
dm map.  This comes at quite a cost though.  My host has 128 LUs each with
2 paths and 32 LUs each with 4 paths for an aggregate total of 160 LUs and
320
paths.  Each of the calls to devinfo() does 2 fork/exec pairs, leading to a
total of 
160 * 320 * 2 = 102,400 fork/exec pairs before the command completes.  The
numbers will look astronomically large for a host with 4K LUs each with 4
paths.

I suspect that the fork/exec overhead is the major cause of the time delay
since
time(1) for the command invocation shows slightly more system time than user
time.  Conditionally compiling out the inner loop enables the "multipath -v0
-l"
command to complete in 2.3 seconds.

------_=_NextPart_000_01C5210D.8A481830
Content-Type: application/octet-stream;
	name="devinfo.c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="devinfo.c.patch"

*** multipath-tools-0.4.3-pre5/multipath/devinfo.c	2005-01-23 =
17:48:05.000000000 -0500=0A=
--- multipath-tools-0.4.3-pre5-patched/multipath/devinfo.c	2005-03-04 =
12:40:13.000000000 -0500=0A=
***************=0A=
*** 150,155 ****=0A=
--- 150,156 ----=0A=
  			}=0A=
  			sysfs_get_name_from_path(attr_path, devname,=0A=
  						 FILE_NAME_SIZE);=0A=
+ 			sysfs_close_directory(sdir);=0A=
  			return 0;=0A=
  		}=0A=
  	}=0A=
***************=0A=
*** 322,328 ****=0A=
  	char * dst;=0A=
  	char * p;=0A=
  	int len;=0A=
! 	int free;=0A=
  =0A=
  	if (!string)=0A=
  		return NULL;=0A=
--- 323,329 ----=0A=
  	char * dst;=0A=
  	char * p;=0A=
  	int len;=0A=
! 	int myfree;=0A=
  =0A=
  	if (!string)=0A=
  		return NULL;=0A=
***************=0A=
*** 334,349 ****=0A=
  =0A=
  	p =3D dst;=0A=
  	pos =3D strchr(string, '%');=0A=
! 	free =3D maxsize;=0A=
  =0A=
! 	if (!pos)=0A=
! 		return string;=0A=
  =0A=
  	len =3D (int) (pos - string) + 1;=0A=
! 	free -=3D len;=0A=
  =0A=
! 	if (free < 2)=0A=
  		return NULL;=0A=
  =0A=
  	snprintf(p, len, "%s", string);=0A=
  	p +=3D len - 1;=0A=
--- 335,354 ----=0A=
  =0A=
  	p =3D dst;=0A=
  	pos =3D strchr(string, '%');=0A=
! 	myfree =3D maxsize;=0A=
  =0A=
! 	if (!pos) {=0A=
! 		strcpy(dst, string);=0A=
! 		return dst;=0A=
! 	}=0A=
  =0A=
  	len =3D (int) (pos - string) + 1;=0A=
! 	myfree -=3D len;=0A=
  =0A=
! 	if (myfree < 2) {=0A=
! 		free(dst);=0A=
  		return NULL;=0A=
+ 	}=0A=
  =0A=
  	snprintf(p, len, "%s", string);=0A=
  	p +=3D len - 1;=0A=
***************=0A=
*** 352,371 ****=0A=
  	switch (*pos) {=0A=
  	case 'n':=0A=
  		len =3D strlen(pp->dev) + 1;=0A=
! 		free -=3D len;=0A=
  =0A=
! 		if (free < 2)=0A=
  			return NULL;=0A=
  =0A=
  		snprintf(p, len, "%s", pp->dev);=0A=
  		p +=3D len - 1;=0A=
  		break;=0A=
  	case 'd':=0A=
  		len =3D strlen(pp->dev_t) + 1;=0A=
! 		free -=3D len;=0A=
  =0A=
! 		if (free < 2)=0A=
  			return NULL;=0A=
  =0A=
  		snprintf(p, len, "%s", pp->dev_t);=0A=
  		p +=3D len - 1;=0A=
--- 357,380 ----=0A=
  	switch (*pos) {=0A=
  	case 'n':=0A=
  		len =3D strlen(pp->dev) + 1;=0A=
! 		myfree -=3D len;=0A=
  =0A=
! 		if (myfree < 2) {=0A=
! 			free(dst);=0A=
  			return NULL;=0A=
+ 		}=0A=
  =0A=
  		snprintf(p, len, "%s", pp->dev);=0A=
  		p +=3D len - 1;=0A=
  		break;=0A=
  	case 'd':=0A=
  		len =3D strlen(pp->dev_t) + 1;=0A=
! 		myfree -=3D len;=0A=
  =0A=
! 		if (myfree < 2) {=0A=
! 			free(dst);=0A=
  			return NULL;=0A=
+ 		}=0A=
  =0A=
  		snprintf(p, len, "%s", pp->dev_t);=0A=
  		p +=3D len - 1;=0A=
***************=0A=
*** 379,388 ****=0A=
  		return dst;=0A=
  =0A=
  	len =3D strlen(pos) + 1;=0A=
! 	free -=3D len;=0A=
  =0A=
! 	if (free < 2)=0A=
  		return NULL;=0A=
  =0A=
  	snprintf(p, len, "%s", pos);=0A=
  	dbg("reformated callout =3D %s", dst);=0A=
--- 388,399 ----=0A=
  		return dst;=0A=
  =0A=
  	len =3D strlen(pos) + 1;=0A=
! 	myfree -=3D len;=0A=
  =0A=
! 	if (myfree < 2) {=0A=
! 		free(dst);=0A=
  		return NULL;=0A=
+ 	}=0A=
  =0A=
  	snprintf(p, len, "%s", pos);=0A=
  	dbg("reformated callout =3D %s", dst);=0A=
***************=0A=
*** 429,434 ****=0A=
--- 440,446 ----=0A=
  	else if (execute_program(buff, prio, 16)) {=0A=
  		dbg("error calling out %s", buff);=0A=
  		pp->priority =3D 1;=0A=
+ 		free(buff);=0A=
  	} else=0A=
  		pp->priority =3D atoi(prio);=0A=
  =0A=
***************=0A=
*** 439,448 ****=0A=
  	 */=0A=
  	select_getuid(pp);=0A=
  	buff =3D apply_format(pp->getuid, CALLOUT_MAX_SIZE, pp);=0A=
! =0A=
! 	if (buff && execute_program(buff, pp->wwid, WWID_SIZE) =3D=3D 0) =
{=0A=
! 		dbg("uid =3D %s (callout)", pp->wwid);=0A=
! 		return 0;=0A=
  	}=0A=
  =0A=
  	/*=0A=
--- 451,463 ----=0A=
  	 */=0A=
  	select_getuid(pp);=0A=
  	buff =3D apply_format(pp->getuid, CALLOUT_MAX_SIZE, pp);=0A=
! 	if (buff) {=0A=
! 		if (execute_program(buff, pp->wwid, WWID_SIZE) =3D=3D 0) {=0A=
! 			free(buff);=0A=
! 			dbg("uid =3D %s (callout)", pp->wwid);=0A=
! 			return 0;=0A=
! 		}=0A=
! 		free(buff);=0A=
  	}=0A=
  =0A=
  	/*=0A=

------_=_NextPart_000_01C5210D.8A481830
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_000_01C5210D.8A481830--
