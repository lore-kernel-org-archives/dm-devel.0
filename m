From: Arthur Bergman <sky@nanisky.com>
Subject: Re: RE: How is the multipath pg policy group-by-nodename
	any	differen t than the failover policy?
Date: Tue, 3 May 2005 13:22:32 +0100
Message-ID: <a104606cc87e76d5150c588d17db8905@nanisky.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A95A@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A95A@SRMANNING.eng.emc.com>
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


On 28 Apr 2005, at 19:53, goggin, edward wrote:

> On Wed, 27 Apr 2005 21:38:34 +0100, Arthur Bergman wrote:
>
>> All the path have the same serial, but the show up from different 
>> nodes.
>
> Not sure what this means.  The group-by-node-name policy implies 
> assigning
> paths with similar node name attribute to the same group.  For SCSI, 
> seems
> like the multipath configurator assigns the node name attribute to be 
> the
> combination of SCSI initiator and target addresses (in linux, host
> no/channel no/target id).  This should be different for every path 
> which
> would cause each path to be assigned to a different path group.
>
> How is the resultant path grouping any different than if you used the
> failover
> path grouping policy instead?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

Huh, as far as I understand it group_by_nodename uses the

/sys/class/fc_transport/target0:0:0/node_name information

from our setup, there are 8 paths to two controllers, there is no 
failover cost but it defeats read caching pretty beadly to use both 
controllers..

/sys/class/fc_transport/target0:0:0/node_name:0x50050768010003d5
/sys/class/fc_transport/target0:0:1/node_name:0x5005076801000361
/sys/class/fc_transport/target0:0:2/node_name:0x50050768010003d5
/sys/class/fc_transport/target0:0:3/node_name:0x5005076801000361
/sys/class/fc_transport/target1:0:0/node_name:0x5005076801000361
/sys/class/fc_transport/target1:0:1/node_name:0x5005076801000361
/sys/class/fc_transport/target1:0:2/node_name:0x50050768010003d5
/sys/class/fc_transport/target1:0:3/node_name:0x50050768010003d5


So all path that ends at a matching node_name, even if they are on 
different transport targets get one path.

Cheers
Arthur

-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/
