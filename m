From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 28 Feb 2011 14:38:46 +0100
Message-ID: <4D6BA566.1050305@redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>	<20110228114801.GZ3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>	<20110228121149.GA3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
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

Dne 28.2.2011 14:13, Eli Malul napsal(a):
> 
> OK, I will try that and check the implications of that, thanks!!
> 
> But, do you know why having 10,000 extents is causing this overwhelming
> memory usage?
> 

If you really need that many devices - be also sure
you have disabled this kernel config option:

CONFIG_BLK_DEV_INTEGRITY


For some reason it consumes massive amount of memory.
Other than that - you should count with  64KB per device usually.

Zdenek
