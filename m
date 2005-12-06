From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Question about Multibus+Failover
Date: Tue, 06 Dec 2005 22:15:11 +0100
Message-ID: <1133903711.5650.17.camel@zezette>
References: <4395F683.1000900@redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4395F683.1000900@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On mar, 2005-12-06 at 15:37 -0500, Josef Whiter wrote:
> Hello,
> 
> I've had several requests about loadbalancing coupled with failover for 
> dm multipathing.  I know with failover you get just failover, and 
> multibus you get just load balancing, but I was wondering if there was a 
> hybrid option for load balancing that would handle a failed path 
> gracefully.  Thanks much,
> 
Failed paths are handled quite gracefully in all grouping policies.

That said, other stock grouping policies are at your disposal :
group_by_serial or group_by_node_name or the special group_by_prio that
let you do your own grouping policy with callouts (shell scripts or
whatever).

Please have a look at the documentation available.

Regards,
cvaroqui
