From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: RAID 5 support?
Date: Fri, 23 Sep 2005 16:52:31 +0200
Message-ID: <20050923145231.GA17817@redhat.com>
References: <1127421818.3350.25.camel@dhcp-174-61.nvidia.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1127421818.3350.25.camel@dhcp-174-61.nvidia.com>
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


Jane,

your help would be much appreciated because we haven't had capacity to
implement a RAID5 device-mapper target yet
(though I've got one in the mothballs).

Let's chat next week about option to elaborate from what I've got...

BTW: dmraid doesn't need much change (minor addition to format handlers
     plus an activation handler function in activate.c)

Regards,
Heinz


On Thu, Sep 22, 2005 at 01:43:38PM -0700, Jane Liu wrote:
> Is there a RAID 5 target for device-mapper? If not we would like to add
> RAID 5 support in both device-mapper and dmraid. We'll be happy to
> contribute to any efforts already underway.
> 
> Thanks,
> Jane Liu
> --------
> NVIDIA Corporation
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
