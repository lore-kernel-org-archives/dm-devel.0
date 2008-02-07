From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath and getuid_callout issues with
	HPXP1024diskarray
Date: Thu, 7 Feb 2008 07:27:48 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F195@exchmail03.ncogroup.com>
References: <20080207083902.GB7665@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080207083902.GB7665@percy.comedia.it>
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

I finally got a support call going with HP, and here's the "official"
resolution:

The XP1024 disk array has to be at a certain firmware version for the
required system modes of 140 and 293 to be available to be turned on.
Additionally, HP states that the configuration is only "blessed" for
certain versions of Red Hat, HBA cards, and drivers.  Oh, one other
thing...you have to load their version of DMM, not the standard version
that comes with RedHat or downloading and compiling your own version.
Their version currently doesn't have the patch for the longer strings in
getuid_callout.

By going to www.hp.com and putting in "device mapper multipath" in the
search box, you should find a link to "Device Mapper Multipath
Enablement Kit for HP StorageWorks Disk Arrays Installation and
Reference Guide", a PDF document which details everything.  Don't want
to quote it here as it'll likely change over time.

After working with a fairly knowledgeable person at HP, my solution is
to use a custom script that parses output from the unsupported "xpinfo"
command from HP to pull out the CU:LDev value of the devices and feed
that back into multipath.

Works fine, except for an odd issue at reboot times, for which I've got
a separate unanswered query out to this list.

Thanks to Malahal, Vijayakumar Balasubramanian, and Luca Berra for their
responses.

Rick

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Luca Berra
Sent: Thursday, February 07, 2008 3:39 AM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Multipath and getuid_callout issues with
HPXP1024diskarray

On Wed, Jan 30, 2008 at 01:56:09PM -0500, Greene, Rick wrote:
>I've been trying to play with using a different command in the
>getuid_callout, but everything I try comes up with "error calling out".
>For example, I wrote my own little shell script that pushes out the
same
>scsi_id string, plus some output from a vendor-supplied disk querying
>command, and this is what "multipath -v3" shows for one of the devices
>(they all display similar results):

can you strace the multipath invocation, so maybe we will see if it
really does execute your callout?

I solved a problem similar to yours by using a custom script myself,
about one year ago for a customer using an xp12000, unfortunately i
don't have a copy of the script or of the multipath configuration at
that site.

L.

--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
