From: Dennis Yang <shinrairis@gmail.com>
Subject: I/O block when removing thin device on the same pool
Date: Wed, 20 Jan 2016 18:05:40 +0800
Message-ID: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

I had noticed that I/O requests to one thin device will be blocked
when the other thin device is being deleting. The root cause of this
is that to delete a thin device will eventually call dm_btree_del()
which is a slow function and can block. This means that the device
deleting process will need to hold the pool lock for a very long time
to wait for this function to delete the whole data mapping subtree.
Since I/O to the devices on the same pool needs to held the same pool
lock to lookup/insert/delete data mapping, all I/O will be blocked
until the delete process finish.

For now, I have to discard all the mappings of a thin device before
deleting it to prevent I/O from being blocked. Since these discard
requests not only take lots of time to finish but hurt the pool I/O
throughput, I am still looking for other better solutions to fix this
issue.

I think the main problem is still the big pool lock in dm-thin which
hurts both the scalability and performance of. I am wondering if there
is any plan on improving this or any better fix for the I/O block
problem.

Any help would be grateful.
Dennis
