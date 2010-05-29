From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: General and configuration questions
Date: Fri, 28 May 2010 18:46:59 -0700
Message-ID: <20100529014659.GA1852@us.ibm.com>
References: <230ED15F81AFD3409345FFA4E565F0E50A978AA3@NDHV3000.na.corp.mckesson.com>
	<20100528221325.GA29567@us.ibm.com>
	<230ED15F81AFD3409345FFA4E565F0E50A978B57@NDHV3000.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <230ED15F81AFD3409345FFA4E565F0E50A978B57@NDHV3000.na.corp.mckesson.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Allen, Jack [Jack.Allen@mckesson.com] wrote:
> 
> Thanks for the quick reply.
> 
> 	Then I lowered rr_min_io to 10 and did reconfigure and show
> config and the parameter does not show up at all. The device entry is
> still at the top of the devices, just does not have the rr_min_io
> parameter at all. So I went through several values for rr_min_io stating
> at 100 and decreasing it by 10 each time and then doing reconfigure and
> show config. When it got to 10 again the parameter did not show up. So I
> increased it to 11 and it showed up. So there must be some min/max value
> that multipath will not allow setting the parameter to and if it is not
> within that range, it just ignores it all together.

You could have used binary search. :-)

Not sure if such a value is not used or not displayed in in "show
config" You can do "multipath -v4" that should display what value is
used for your device while creating it though.

I always use 'multipath -v4' to see what settings are done for my
devices if I change something in multipath.conf.

Hope that helps!
--Malahal.
