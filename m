From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: How is the multipath pg policy group-by-nodename
	any different th an the failover policy ...
Date: Wed, 27 Apr 2005 22:07:35 +0200
Message-ID: <1114632455.10011.49.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A950@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A950@SRMANNING.eng.emc.com>
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

On mer, 2005-04-27 at 15:42 -0400, goggin, edward wrote:
> ... especially for SCSI paths where the multipathing is designed to be
> indifferent to both transport and network route between SCSI initiator
> and SCSI target?  Don't they both result in one path per path group
> for a given SCSI logical unit as long as the node name is defined to
> be the "host number/channel number/target id" triple setup by
> sysfs_devinfo in libmultipath/discovery.c?
> 
> BTW, this is an example of the SCSI affinity I was mentioning in my
> previous submission.
> 
> --
Tunables don't account as blocking affinity : if you want to multipath
over ieee1394, you just won't use those tunables like group-by-nodename.

The fact is, the world seems full of exotic hardware. This pgpolicy was
asked by IBM for their ESS class controllers were each node has a unique
nodename whatever the number of paths to the node. Having a penalty
switching a LU from one node to its peer, they were interested in group
all paths to a node together.

Well, at least it's what I understood from the request :/

One would have thought that group_by_serial was here to cover that
scenario, but that hardware just doesn't work that way.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
