From: "goggin, edward" <egoggin@emc.com>
Subject: Re: RE: How is the multipath pg policy group-by-nodena
	me any differen t than the failover policy?
Date: Tue, 3 May 2005 12:11:56 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A991@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 3 May 2005 13:22:32 +0100, Arthur Bergman wrote:
 
> Huh, as far as I understand it group_by_nodename uses the
> 
> /sys/class/fc_transport/target0:0:0/node_name information
> 
> from our setup, there are 8 paths to two controllers, there is no 
> failover cost but it defeats read caching pretty beadly to use both 
> controllers..
> 
> /sys/class/fc_transport/target0:0:0/node_name:0x50050768010003d5
> /sys/class/fc_transport/target0:0:1/node_name:0x5005076801000361
> /sys/class/fc_transport/target0:0:2/node_name:0x50050768010003d5
> /sys/class/fc_transport/target0:0:3/node_name:0x5005076801000361
> /sys/class/fc_transport/target1:0:0/node_name:0x5005076801000361
> /sys/class/fc_transport/target1:0:1/node_name:0x5005076801000361
> /sys/class/fc_transport/target1:0:2/node_name:0x50050768010003d5
> /sys/class/fc_transport/target1:0:3/node_name:0x50050768010003d5
> 
> 
> So all path that ends at a matching node_name, even if they are on 
> different transport targets get one path.

Right.  I mis-read the code in discovery.c.  Thanks.
