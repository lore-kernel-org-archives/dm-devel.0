From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Problem with lvm - mapping after <= 1s power
	breakdown -> incorrect mapping.
Date: Tue, 26 Jun 2007 09:59:45 +0200
Message-ID: <20070626075945.GA2982@redhat.com>
References: <467BAC81.C2D2.0099.0@eumetsat.int>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <467BAC81.C2D2.0099.0@eumetsat.int>
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

On Fri, Jun 22, 2007 at 11:03:34AM +0200, Marcus Minzenmay wrote:
> After a very short power breakdown I've got a problem with one of the
> (lvm2/reiser) filesystems:
> 
> Mounting the /dev/mapper/xxx - device manually for a check it obviously
> points to a filesystem which is incorrect and mounted already.
> How van this get corrected ?

No checks on mounted filesystems unless you want to order data corruption!

Is this a broken multipath setup and a componet device got mounted ?

> 
> Regards
> 
> ...
> 
> Marcus Minzenmay
> UNIX Systems Engineer
> EUMETSAT
> Am Kavalleriesand, 31
> 64295, Darmstadt, Germany
> Tel : +49 6151 807-7358 or 0172-1479403
> EMail: marcus.minzenmay@eumetsat.int 
> iNet : http://www.eumetsat.int 
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
