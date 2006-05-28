From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: dm-linear error: Device lookup failed
Date: Sun, 28 May 2006 13:06:22 +0200
Message-ID: <20060528110622.GA2179@redhat.com>
References: <1148338665.1812.16.camel@solid.brisbane.redhat.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1148338665.1812.16.camel@solid.brisbane.redhat.com>
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
Cc: hjm@redhat.com
List-Id: dm-devel.ids


Mark,

you're saying, the system is wotking properly, but without the respecive
mapping tables it's hard to tell if there's a hidden issue.

The message shows, that device-mapper is unable to discover 2 devices
while loading (a) mapping table(s).

On Tue, May 23, 2006 at 08:57:45AM +1000, Mark Huth wrote:
> Hi,
> I am encountering the following error/message whilst the machine is
> booting up:
> 
> kernel: device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-
> devel@redhat.com
> kernel: device-mapper: dm-linear: Device lookup failed
> kernel: device-mapper: error adding target to table
> kernel: device-mapper: dm-linear: Device lookup failed
> kernel: device-mapper: error adding target to table
> kernel: cdrom: open failed.
> last message repeated 2 times
> 
> I am not using LVM (just a bunch of raid0 partitions) so it seems that
> this error is more informational rather than a sign of possible
> problems, and the system seems to otherwise be functioning normally.  So
> I was wondering if anyone on this list can confirm that it is nothing to
> worry about and if there a way to make the system happy to prevent this
> message from showing up.  I am using RHEL4U3 (kernel 2.6.9-34.EL).
> 
> Thanks,
> Mark
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 

Regards,
Heinz    -- The LVM Guy --

*** Software bugs are stupid.
    Nevertheless it needs not so stupid people to solve them ***

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
