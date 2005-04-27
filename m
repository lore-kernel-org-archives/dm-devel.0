From: Arthur Bergman <sky@nanisky.com>
Subject: Re: How is the multipath pg policy group-by-nodename any
	different th an the failover policy ...
Date: Wed, 27 Apr 2005 21:38:34 +0100
Message-ID: <9011afeb25b897c4f1566971ca134326@nanisky.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A950@SRMANNING.eng.emc.com>
	<1114632455.10011.49.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1114632455.10011.49.camel@zezette>
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


On 27 Apr 2005, at 21:07, christophe varoqui wrote:

> The fact is, the world seems full of exotic hardware. This pgpolicy was
> asked by IBM for their ESS class controllers were each node has a 
> unique
> nodename whatever the number of paths to the node. Having a penalty
> switching a LU from one node to its peer, they were interested in group
> all paths to a node together.
>


Yep, I think I requested it for the San Volume Controllers (IBM 
standalone ESS derivative (and as I say that no doubt a ESS team member 
will flame me ;))

> Well, at least it's what I understood from the request :/
>
> One would have thought that group_by_serial was here to cover that
> scenario, but that hardware just doesn't work that way.

All the path have the same serial, but the show up from different nodes.

Cheers
Arthur


-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/
