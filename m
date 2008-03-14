From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: mapper device perms on reboot
Date: Fri, 14 Mar 2008 09:29:20 -0500
Message-ID: <342d47870803140729r564431dejdf3340587e32727f@mail.gmail.com>
References: <342d47870802261304s54c3650dv83216abd8ffaee8f@mail.gmail.com>
	<788110.21147.qm@web90606.mail.mud.yahoo.com>
	<342d47870803111314w6fced87v9215c7573fbb5002@mail.gmail.com>
	<342d47870803121846j5306a20boab6ed9e5801d325a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870803121846j5306a20boab6ed9e5801d325a@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I removed the multipath, rebooted, made successful tests the HBA and
NIC, reinstalled multipath, rebooted and this time the I/O works fine!
 After my initial multipath install, I partitioned, formated and
mounted the LUNs to verify they were working.  I think that must've
caused some kind of corruption that would not allow them to work with
my Oracle installation until they were reset fresh.  Interesting.
What a fun process that was to go through.

For the Oracle 10g record, I used the /dev/dm-* devices instead of the
mapper devices.  Permissions were able to be set and there's no
problem accessing the devices.

Thanks,
Scott



On Wed, Mar 12, 2008 at 8:46 PM, Scott Moseman <scmoseman@gmail.com> wrote:
>
> Actually I need to take that back now.  The direct i/o support works
>  fine on local disks and even my iSCSI SAN connections direct through
>  an HBA or NIC.  But it's when I try to access them via multipath
>  devices they fail and have the i/o errors.  I updated my ticket with
>  Red Hat, but so far they're not coming back with anything at all.
>
>  Thanks,
>  Scott
>
>
>  On Tue, Mar 11, 2008 at 3:14 PM, Scott Moseman <scmoseman@gmail.com> wrote:
>  >
>  > Thanks for the info.  Our problem has been isolated as lack of direct
>  >  i/o support on our Red Hat box.  The problem does not appear to be
>  >  MPIO related, at least not from what Oracle support is telling me.  So
>  >  now I'm off to deal with Red Hat support to see how they counter.
>  >
>  >  Thanks,
>  >  Scott
>  >
>  >
>  >  On Wed, Feb 27, 2008 at 1:17 PM, Dharmesh Kamdar <kamdard71@yahoo.com> wrote:
>  >  >
>  >  > Hi Scott,
>  >  >
>  >  >  This weblink may help -->
>  >  >  http://www.ardentperf.com/2008/02/13/oracle-clusterware-on-rhel5oel5-with-udev-and-multipath/
>  >  >  I've not tried this, but the author of the article
>  >  >  claims that it works..
>  >  >
>  >  >  We are also facing similar issue(s) with Oracle and
>  >  >  RHEL 5.1 using UDEV/Device-mapper..I've also posted a
>  >  >  query on the same
>  >  >  (https://www.redhat.com/archives/dm-devel/2008-February/msg00201.html)
>  >  >  ...But it just discusses the changing of permissions,
>  >  >  however creation of raw devices using UDEV is not
>  >  >  specified, hence we are still looking for that answer.
>  >  >
>  >  >  Hope it helps somewhat.
>  >  >
>  >  >  Let us know.
>  >  >
>  >  >  Regards,
>  >  >  Dharmesh.
>  >  >
>  >  >
>  >  >  --- Scott Moseman <scmoseman@gmail.com> wrote:
>  >  >
>  >  >  > How can I get the mapper device permissions set on
>  >  >  > reboot?
>  >  >  >
>  >  >  > When I attempted to try this...
>  >  >  >
>  >  >  > # cat /etc/udev/permissions.d/50-udev.permissions |
>  >  >  > grep mapper
>  >  >  > mapper/mpath*:oracle:dba:0660
>  >  >  >
>  >  >  > But it did not seem to work...
>  >  >  >
>  >  >  > # ls -l /dev/mapper/mpath*
>  >  >  > brw-rw----  1 root disk 253, 2 Feb 26 20:56
>  >  >  > /dev/mapper/mpath0
>  >  >  > brw-rw----  1 root disk 253, 5 Feb 26 20:56
>  >  >  > /dev/mapper/mpath0p1
>  >  >  > brw-rw----  1 root disk 253, 3 Feb 26 20:56
>  >  >  > /dev/mapper/mpath1
>  >  >  > brw-rw----  1 root disk 253, 4 Feb 26 20:56
>  >  >  > /dev/mapper/mpath1p1
>  >  >  >
>  >  >  > Am I doing something wrong?  Is there another way to
>  >  >  > do this?
>  >  >  >
>  >  >  > Thanks,
>  >  >  > Scott
>  >  >  >
