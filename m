From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Opening a dm device reads from cache, not the device.
Date: Fri, 17 Feb 2006 18:56:01 +0100
Message-ID: <20060217175601.GB23651@redhat.com>
References: <43F35F58.8B4D.000D.0@novell.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43F35F58.8B4D.000D.0@novell.com>
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


Is this dm-raid45 ?

If so, you'll need to add cluster logic to it (ie. taking locks
out on stripe cache accesses, invalidating stripes etc).

On Wed, Feb 15, 2006 at 05:05:28PM -0700, Allen Jack wrote:
> I have a RAID5 plugin that is also used with clustering.  I open the
> raid device (created in device-mapper) using the O_SYNC and O_DIRECT
> flags, but it seems to read the data from a cache somewhere.  I put a
> printk in my plugin map function, but it doesn't get hit.  If another
> node in the cluster changes the data on the disk, it never gets
> refreshed on this node because of the caching.
> 
> Is there any way to turn off the caching so that all read requests come
> to my plugin?  And where is the caching taking place?
> 
> Thanks,
> 
> Allen
> 
> Allen Jack
> email - ajack@novell.com
> Novell, Inc., the leading provider of information solutions
> http://www.novell.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
