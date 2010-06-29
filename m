From: "Narendran Ganapathy" <Narendran_Ganapathy@Dell.com>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selector interface
	for	supporting Dell EqualLogic path selector
Date: Tue, 29 Jun 2010 17:30:19 -0400
Message-ID: <86A3089001A44141B76B882059E7E53B05968CCB@M31.equallogic.com>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
	<4C29D489.3040801@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4C29D489.3040801@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Parind Shah <Parind_Shah@Dell.com>, Jason Shamberger <Jason_Shamberger@Dell.com>, agk@redhat.com
List-Id: dm-devel.ids

Hi,

Thanks for the feedback..  

> Interesting.
> How can the path-selector know which path owns which location?

Path selector obtains the "path-location mappings" through a user land
helper application that queries the storage group. To explain further,
Path-Location mappings are nothing but relationships between the SCSI
minor and LBA ranges. 
 
> I can just see "it's invisible from initiator" from your explanation
> above, so I can't understand why the path-selector can choose the best
> path which is directly connected to the member owning the location.
> It can just guess using the new path-selector parameters below?

By using the address parameter the path selector can choose the optimal
path to the member where the requested data is located and increase the
performance instead of getting forwarded from one member to another
member. 

> I disagree with passing 'struct request' directly to path-selector.
> As I said at http://marc.info/?l=dm-devel&m=123330286327402&w=2,
> I think we should keep independency of path-selector from the type of
> I/O structure as much as possible, since bio-based targets may want
> to use them in the future (e.g. read balancing of dm-mirror).

> So I would prefer the way below:
>  o define what parameters are needed (now and in the future)
>  o pass them to path-selector

Ok. We thought passing the request pointer would allow extra flexibility
in the case of future path selectors who could choose a path based on
different criteria (like the direction of request, read goes to a
separate path, write goes to another path etc..). For our path selector,
we need the starting address of the request. 

> Also, please post your path-selector patch if you already have,
> so that people can understand your needs much correctly.

We are working on it and would post the path-selector patch soon. 

Thanks,
 Naren.



-----Original Message-----
From: Kiyoshi Ueda [mailto:k-ueda@ct.jp.nec.com] 
Sent: Tuesday, June 29, 2010 7:10 AM
To: Narendran Ganapathy
Cc: device-mapper development; Parind Shah; Jason Shamberger;
agk@redhat.com
Subject: Re: [dm-devel] [PATCH 1/1] dm-mpath: Extend path selector
interface for supporting Dell EqualLogic path selector

Hi,

On 06/28/2010 10:53 PM +0900, Narendran Ganapathy wrote:
> This patch extends the dm-path-selector interface to allow path
> selectors to use extra information from the IO request when selecting
> a path.
>
> Dell EqualLogic and other iSCSI storage arrays use a distributed
> frameless architecture.  In this architecture, the storage group
> consists of a number of distinct storage arrays ("members"),
> each having independent controllers, disk storage and network
adapters.
> When a LUN is created it is spread across multiple members.
> The details of the distribution are hidden from initiators connected
to
> this storage system.  The storage group exposes a single target
> discovery portal, no matter how many members are being used.
> When iSCSI sessions are created, each session is connected to an eth
> port on a single member.  Data to a LUN can be sent on any iSCSI
> session, and if the blocks being accessed are stored on another
> member the IO will be forwarded as required.  This forwarding is
> invisible to the initiator.  The storage layout is also dynamic,
> and the blocks stored on disk may be moved from member to member
> as needed to balance the load.
>
> This architecture simplifies the management and configuration of both
> the storage group and initiators.  In a multipathing configuration,
> it is possible to set up multiple iSCSI sessions to use multiple
> network interfaces on both the host and target to take advantage of
> the increased network bandwidth.  An initiator can use a simple round
> robin algorithm to send IO on all paths and let the storage array
> members forward it as necessary.  However, there is a performance
> advantage to sending data directly to the correct member.
> At the same time, the existing techniques of building a separate
> priority group for paths to each controller does not fit this model,
> because the block ranges may be moved at any time from member to
member,
> and it is also acceptable to send IO to any member in the group when
> no direct path exists or there is a path error.
>
> We propose to develop a new path selector to perform this
location-based
> routing.  The basic idea is to use knowledge about the current
location
> of data to prefer paths directly to the owning member, but fall back
to
> use any available path when no direct path is available.
> This submission includes the necessary changes to the dm-path-selector
> interface.  In the current interface, the only information passed
> to the select_path routine is the path_selector struct and the number
> of bytes in the request.  To do location based routing, we need
> the address information of the request.

Interesting.
How can the path-selector know which path owns which location?

I can just see "it's invisible from initiator" from your explanation
above, so I can't understand why the path-selector can choose the best
path which is directly connected to the member owning the location.
It can just guess using the new path-selector parameters below?


> We propose to extend the path selector interface to pass the entire
> request pointer to the 'select_path' / 'start_io' /  'end_io'
functions
> so that the path selector can use any information therein to route
> the I/O.
>
> We also propose extending the dm_mpath_io structure used to hold
> information about each I/O to include extra fields for the path
> selector to store I/O specific flags and a timestamp, so the path
> selector can determine the latency of I/Os on different paths and
> that information is passed to the 'select_path' / 'start_io' /
'end_io'
> functions for path selector usage. These additions to the dm_mpath_io
> allow future flexibility in developing algorithms that route IO based
> on other information from the request in the future.

I disagree with passing 'struct request' directly to path-selector.
As I said at http://marc.info/?l=dm-devel&m=123330286327402&w=2,
I think we should keep independency of path-selector from the type of
I/O structure as much as possible, since bio-based targets may want
to use them in the future (e.g. read balancing of dm-mirror).

So I would prefer the way below:
  o define what parameters are needed (now and in the future)
  o pass them to path-selector


Also, please post your path-selector patch if you already have,
so that people can understand your needs much correctly.

Thanks,
Kiyoshi Ueda
