From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: v4.8 dm-mpath
Date: Fri, 26 Aug 2016 08:33:25 -0700
Message-ID: <47ef2a90-d465-9afa-ef1a-51b43f5c7915@sandisk.com>
References: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
	<20160816191241.GA16948@redhat.com> <20160817024302.GA29089@redhat.com>
	<a85fe9dc-e09a-152f-8576-13e899cde9c4@sandisk.com>
	<20160818015433.GA8972@redhat.com>
	<ab6df671-d6b3-86b1-72e3-25e162b679b4@sandisk.com>
	<20160826142647.GA1876@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160826142647.GA1876@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/26/2016 07:26 AM, Mike Snitzer wrote:
> On Thu, Aug 25 2016 at  1:40pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> As usual, thanks for the quick feedback. But it seems like I sent my
>> e-mail too soon: after I had sent my e-mail I ran again into the
>> truncate_inode_pages_range() hang.
>
> I was skeptical your 3 earlier patches (particularly the __dm_destroy to
> use internel suspend patch) would fix anything you care about in your
> testing.  __dm_destroy is only used once all references on the DM mpath
> device are dropped.  When you do your fio + cable pull tests you're just
> bouncing underlying paths around.  You aren't _ever_ destroying the
> multipath device.  That is why your __dm_destroy patch seemed off the
> mark to me.

Hello Mike,

In case it wasn't clear, I want to drop the three patches you referred 
to. But I also want to clarify that my tests *do* trigger 
__dm_destroy(). If you have a look at the srp-test scripts then you will 
see that "dmsetup remove" is invoked after each test. What I see is that 
lock_page() and other page cache functions hang sporadically around the 
time the dm device is removed, most likely due to I/O that is submitted 
but never completed. That's why I started looking at the scsi-mq/blk-mq 
device removal code.

Bart.
