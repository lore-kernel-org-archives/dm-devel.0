From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: bdclaim reversal in DM for EVMS2
Date: Mon, 15 Aug 2005 10:04:26 -0500
Message-ID: <200508151004.27299.kevcorry@us.ibm.com>
References: <20050815105301.GJ4997@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050815105301.GJ4997@marowsky-bree.de>
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
To: dm-devel@redhat.com
Cc: Lars Marowsky-Bree <lmb@suse.de>
List-Id: dm-devel.ids

Hi Lars,

On Mon August 15 2005 5:53 am, Lars Marowsky-Bree wrote:
> Hi,
>
> EVMS2 users keep complaining about the fact that DM bdclaim()s the whole
> disk, which makes it impossible to mix EVMS2 use with regular mounts on
> the same disk. The EVMS2 folks suggest the attached patch.
>
> Alasdair, do you have any comments on that? This is being requested for
> inclusion into openSUSE
> (https://bugzilla.novell.com/show_bug.cgi?id=104046 - there's some
> confusion in the bugzilla as always ;-), and I'd like to get upstream
> agreement on where to go first.

I'm going to say that you probably don't want to add that patch to the 
standard kernel for openSUSE. It removes functionality that was specifically 
added to the kernel a couple years ago, and there's pretty much no way that 
patch will be picked up for mainline. We still provide that patch with the 
EVMS source code, but I've been trying to get people to move away from using 
it whenever possible.

As for mixing EVMS and "regular mounts" on the same disk, I generally advise 
against that. EVMS is perfectly capable of handling disk partitioning using 
Device-Mapper, and provides features that aren't possible using the kernel's 
built-in partitions (e.g. online resize and moving of partitions, taking 
snapshots of partitions).

If openSUSE provides a way for users to create their volumes with EVMS (at the 
very least creating DOS partitions, Software-RAID devices, and LVM volumes) 
and install directly to those volumes, there shouldn't be a need to use the 
bd-claim patch.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
