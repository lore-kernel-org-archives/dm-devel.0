From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: create lvm2 snapshot will take a long time while
 large IO on origin lv(till large IO ends)
Date: Fri, 30 Apr 2010 10:39:12 -0400
Message-ID: <4BDAEB90.7050305@cfl.rr.com>
References: <w2ub8091bb41004282024i9ae427f7gf963baab82d811d0@mail.gmail.com>	
	<4BD9C264.7040501@cfl.rr.com>
	<q2hb8091bb41004291809i8fa5d34cr3918144d715f0792@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <q2hb8091bb41004291809i8fa5d34cr3918144d715f0792@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Busby <chaimvy@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 4/29/2010 9:09 PM, Busby wrote:
> Hi, Phillip Susi,
>                  Why not suspend the origin's IO first, then create the
> snapshot lv, resume the origin lv 's IO waiting Q last. the 'dd' cmd is
> eariler than the snapshot's creating, if suspend the IO, the filesystem
> on the snapshot will be corrupt, I get it, but I think the  snapshot is
> in block layer, should suspend the user layer's data coming first, then
> flush the data in the dirty buffer and create the snapshot.  like the dd
> cmd on the origin, will make the snapshot's creating take a very long
> time, for waiting for the dm suspend 's return, I think flush the data
> in the dirty buffer (data from dd ), suspend the next data of the dd,
> create the snapshot, then let the data into dirty buffer to the block
> layer. the dd cmd will put the data into dirty buffer continually, can
> not be suspended?

I don't think it is possible to suspend new IO requests from user land
while allowing it from the buffer cache.
