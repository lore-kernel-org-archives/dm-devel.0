From: Brian Long <brilong@cisco.com>
Subject: Re: Clariion CX600 automatic failback support
Date: Mon, 31 Oct 2005 08:58:06 -0500
Message-ID: <1130767086.4071.6.camel@brilong-lnx>
References: <013350FE9CC8AC4EB602045723F47222B9A2BB@xmb-rtp-215.amer.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <013350FE9CC8AC4EB602045723F47222B9A2BB@xmb-rtp-215.amer.cisco.com>
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

On Wed, 2005-10-26 at 15:37 -0400, Phil Lowden (plowden) wrote:
> I'm using LVM2 with device-mapper-multipath 0.4.5 on GA RHEL 4 update 2 
> release, kernel version 2.6.9-22.ELsmp.  Storage is 4 Clariion CX600
> LUNs, 
> 2 with a primary path on SP A and 2 on SP B.  HBAs are QLA3240 with
> firmware 3.03.15 IPX and the RedHat-distributed driver version
> 8.01.00b5-rh2.
> 
> When I disrupt one path by disabling a host or SP switch port,
> failover works great but failback doesn't happen automatically
> with the current config (below).  By this I mean
> when the connection to e.g. SP B is restored, all
> 4 LUNs stay trespassed to SP A.  Is this by design?
> Or is there support for automatic failback, i.e.
> I/O is paused and a trespass is issued to restore
> the 2 SP B LUNs to their primary paths?
> 
> Of course manual failback is possible, but without
> quiescing I/O I found I was able to munge my LVM2
> objects up quite nicely.  Manual failback with quiesced 
> I/O is fine.

No one has automatic failback working on Clarrion storage?

/Brian/
-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
