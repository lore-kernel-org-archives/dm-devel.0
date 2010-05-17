From: Will Drewry <wad@chromium.org>
Subject: Re: [RFC PATCH v2 2/2] init: boot to device-mapper targets without an
	initr*
Date: Mon, 17 May 2010 13:13:48 -0500
Message-ID: <AANLkTimRJAOO6frxyr3M-cL8UCxYZfU4FN1TBJn3sd4c@mail.gmail.com>
References: <20100514035347.GA20636@redhat.com>
	 <1273887701-2152-2-git-send-email-wad@chromium.org>
	 <20100517094724.48632380.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100517094724.48632380.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Mon, May 17, 2010 at 11:47 AM, Randy Dunlap <randy.dunlap@oracle.com=
> wrote:
> On Fri, 14 May 2010 20:41:41 -0500 Will Drewry wrote:
>
>> Add a dm=3D kernel parameter modeled after the md=3D parameter from
>> do_mounts_md. =A0It allows for device-mapper targets to be configure=
d at
>> boot time for use early in the boot process (as the root device or
>> otherwise).
>
> dm=3D<blah>
> documentation needs to be added to Documentation/kernel-parameters.tx=
t and/or
> Documentation/md.txt.

Absolutely -- I've appended a proposed version below which I'll include=
 in the
next round.  I'm not a lkml veteran, so if it makes sense to resend
the full patchset
again with it, I can.  Otherwise, I'll wait for comments on the code to=
o.

>> The format is dm=3D"name uuid ro,table line 1,table line 2,...". =A0=
The
>> parser expects the comma to be safe to use as a newline substitute b=
ut,
>> otherwise, uses the normal separator of space. =A0Some attempt has b=
een
>> made to make it forgiving of additional spaces (using skip_spaces())=
=2E
>
> This "space in the arg string" has been tested, right?

Works for me so far.  I've tested this on a user mode linux instance an=
d
a real x86 machine with the dm-linear target and a custom dm target
(which I'll be
mailing to dm-devel@ for feedback later this week).

> It seems a bit odd to me. =A0Most kernel parameter strings that I am =
familiar with
> use punctuation for separating parameter parts.

Yup - I agree. My first cut I used commas with an empty ,, delimiter as=
 a new
line.  Then I ran across this in the source:

kernel/params.c
76 /* You can use " around spaces, but can't escape ". */
77 /* Hyphens and underscores equivalent in parameter names. */
78 static char *next_arg(char *args, char **param, char **val)

I will need to cross-check all the known dm targets to make sure that
they don't expect quoted internal strings.  In my first look, I didn't =
see any.

However, I'm perfectly content with either approach so if there's a pre=
ference,
I'll rework it to make it happen.  This approach just maps more cleanly=
 to the
existing experience of configuring a mapped device.

thanks!
will


documentation: dm=3D parameter documentation

Add documentation for early mapped device creation without an initial r=
d.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/device-mapper/boot.txt |   36 ++++++++++++++++++++++++++=
++++++++
 Documentation/kernel-parameters.txt  |    4 +++
 2 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/boot.txt

diff --git a/Documentation/device-mapper/boot.txt
b/Documentation/device-mapper/boot.txt
new file mode 100644
index 0000000..00fb557
--- /dev/null
+++ b/Documentation/device-mapper/boot.txt
@@ -0,0 +1,36 @@
+Boot time creation of mapped devices
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+You can boot directly to a dm device using the following kernel comman=
d
+line:
+
+dm=3D"<name> <uuid> <ro>,table line 1,...,table line n"
+
+name =3D the name to associated with the device
+	 after boot, udev, if used, will use that name to label
+	 the device node.
+uuid =3D may be 'none' or the UUID desired for the device.
+ro =3D may be 0 or 1.  If non-zero, the device and device table will b=
e
+	marked read-only.
+
+Each table line may be as normal when using the dmsetup tool except fo=
r
+two variations:
+1. Any use of commas will be interpreted as a newline
+2. Quotation marks cannot be escaped and cannot be used without
+   terminating the dm=3D argument.
+
+Unless renamed by udev, the device node created will be dm-0 as the
+first minor number for the device-mapper is used during early creation=
=2E
+
+Example
+=3D=3D=3D=3D=3D=3D=3D
+
+- Booting to a linear array made up of user-mode linux block devices:
+
+  dm=3D"lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0"=
 \
+  root=3D/dev/dm-0
+
+Will boot to a rw dm-linear target of 8192 sectors split across two
+block devices identified by their major:minor numbers.  After boot, ud=
ev
+will rename this target to /dev/mapper/lroot (depending on the rules).
+No uuid was assigned.
diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 839b21b..9e22f8e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -43,6 +43,7 @@ parameter is applicable:
 	AVR32	AVR32 architecture is enabled.
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
+	DM	Device mapper support is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
 	EFI	EFI Partitioning (GPT) is enabled
@@ -654,6 +655,9 @@ and is between 256 and 4096 characters. It is
defined in the file
 			Disable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs.

+	dm=3D		[DM] Allows early creation of a device-mapper device.
+			See Documentation/device-mapper/boot.txt.
+
 	dmasound=3D	[HW,OSS] Sound subsystem buffers

 	dma_debug=3Doff	If the kernel is compiled with DMA_API_DEBUG support,
--=20
1.7.0.4
