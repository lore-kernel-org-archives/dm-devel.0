From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: device-mapper oops (and more!)
Date: Wed, 16 Feb 2005 10:18:41 -0600
Message-ID: <200502161018.41415.kevcorry@us.ibm.com>
References: <62b0912f050121080176a120f@mail.gmail.com>
	<20050201091612.GM3471@redhat.com>
	<62b0912f050212032335d2248c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f050212032335d2248c@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Molle Bestefich <molle.bestefich@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat February 12 2005 5:23 am, Molle Bestefich wrote:
> Topic 1: 'dmraid' and device-mapper target availability
>
> Dmraid does not check for available targets before trying to assemble
> arrays.
>
> Example:
> If I run 'dmraid -ay', dmraid tries to create device-mapper tables
> using the 'mirror' target,
> even though dmsetup does not list "mirror" support in 'dmsetup targets'.
> (The mirror target is not compiled in and there is no dm-mirror.ko
> available.)

This is actually the way DM is intended to work. When the kernel gets a 
load-table command, it checks its target-module list for the specified 
target-type name. If it doesn't find it, it attempts to load that target 
using the kernel's module-loader routine. If the target module can't be 
loaded, DM can't load the table and returns an error.

You could obviously make the argument that dmraid could check from user-space 
that the target module is loaded and try to load it with modprobe if 
necessary. But if the module simply doesn't exist, then the end result is no 
different. You'll just get an error that the device can't be activated.

> Topic 2: Error message propagation from device-mapper through dmraid to end
> user
>
> When the device-mapper fails to do something for dmraid, the error
> does not get propagated to the end user.
> Sometimes there is a follow-on error from dmraid, sometimes there is
> no indication at all that something is wrong.
> The device-mapper errors, however, is in the syslog, so it should be
> possible to show them to the end user?
>
> Examples of device mapper error messages in attached syslog_{1,2}.txt.
> Example of follow-on error message from dmraid:
>
> ERROR: dos: reading /dev/mapper/hpt45x_bbdfhdjicg[2]

Yes, error reporting from DM to the user-space tools can be tricky. About the 
only meaningful thing that is returned in these types of error scenarios are 
a rather generic error code like ENOENT, EINVAL, ENOMEM, and such. These 
don't translate very well to end-user messages about the actual cause of the 
error. EVMS and I'd imagine LVM2 have similar problems when trying to report 
messages about errors returned from DM. Your idea about extracting error 
messages from syslog seems like a good one.

I don't work on dmraid, so I'll leave your dmraid-specific questions to those 
developers.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/ltc/
http://evms.sourceforge.net/

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
