From: Josef Whiter <jwhiter@redhat.com>
Subject: Re: Question about Multibus+Failover
Date: Tue, 06 Dec 2005 16:10:50 -0500
Message-ID: <4395FE5A.7020300@redhat.com>
References: <4395F683.1000900@redhat.com> <1133903711.5650.17.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1133903711.5650.17.camel@zezette>
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

Christophe Varoqui wrote:

>On mar, 2005-12-06 at 15:37 -0500, Josef Whiter wrote:
>  
>
>>Hello,
>>
>>I've had several requests about loadbalancing coupled with failover for 
>>dm multipathing.  I know with failover you get just failover, and 
>>multibus you get just load balancing, but I was wondering if there was a 
>>hybrid option for load balancing that would handle a failed path 
>>gracefully.  Thanks much,
>>
>>    
>>
>Failed paths are handled quite gracefully in all grouping policies.
>
>That said, other stock grouping policies are at your disposal :
>group_by_serial or group_by_node_name or the special group_by_prio that
>let you do your own grouping policy with callouts (shell scripts or
>whatever).
>
>Please have a look at the documentation available.
>
>Regards,
>cvaroqui
>
>  
>
Hmm, then perhaps I've been seeing errant behavior, b/c everytime 
somebody uses multibus and they fail a path they get a bunch of IO 
errors and the FS is remounted, but if they use failover and pull the 
active connection, there are no errors and the failover is seamless.  I 
shall investigate further on what they are seeing.  Thank you,

Josef

-- 
Josef Whiter, RHCE
Global Support Services
Red Hat, Inc.
919-754-3700 x44429
