From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Recommendations for cascaded snapshots
Date: Mon, 2 Oct 2006 02:42:20 -0400
Message-ID: <79ABCD24-0B9C-4D80-8BB9-79367A038CEC@mac.com>
References: <D47F6AD4-A487-41B7-8576-D480D50E9F23@mac.com>
	<20061001210921.GC17654@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061001210921.GC17654@agk.surrey.redhat.com>
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

On Oct 01, 2006, at 17:09:21, Alasdair G Kergon wrote:
> On Sun, Oct 01, 2006 at 03:12:01PM -0400, Kyle Moffett wrote:
>> Another quickie question:  How can I measure the current %use of a  
>> given snapshot device?
>
> lvs -o snap_percent vgname/lvname
> (see man page for formatting options to control output units &  
> suppress headings etc.)

Ok; this works for in-LVM snapshots; what if my blockdev isn't  
actually an LVM device?  I'd like to be able to just run some command  
on /dev/mapper/whatever or even /dev/sdXY that happens to contain my  
"SnAp" exception table and get an answer from that.  If such a tool  
doesn't exist; I'll probably just read the LVM sources and write one  
myself but I'd rather not do that if a preexisting solution exists.

>> My first "solution" was to use stacked snapshots such that the
>
> See the list archives for the thread last week.  I'll review the  
> concept & initial code later this week. [see LVM2/lib/report/ 
> columns.h in the source tree for the definitive list of fields; we  
> should probably fix the tools to display the list that got compiled  
> in.]

This looks interesting; this would mean I could just create all the  
snapshots sequentially and rely on the DM-snapshot code to do the  
right thing.  I suppose the one issue is that the all-in-kernel  
approach is still horrendously pre-alpha.  I've got time constraints  
so I'm more curious what the present performance disadvantages are to  
managing the stacking in userspace (using code I've mostly written  
and partially tested already, and with the exception of the merging,  
of course).

>> First of all, it doesn't seem possible to merge two snapshots  
>> together
>
> Mark has code to do this for read-only origins (originally  
> implemented in
> userspace).

Oh?  Do you have a link I could go peek at?  My "origin" would be  
effectively read-only by the time I try to do any merges so an all- 
userspace solution would be very easy for me to safely implement.  It  
also makes the thread very easy to control CPU and IO usage using  
traditional process-management tools.

Also, is it possible to mark a DM blockdev as "read-only" so that  
attempts to mount it read-write or even write to it directly would  
fail?  I _think_ I saw something going via LVM; but I haven't been  
able to find a simple direct userspace tool to do that.  If it's  
possible but such a tool doesn't exist then I'll probably just write  
one.

I realize there are a number of advantages to doing everything  
through the LVM interface but I like to have a manual fallback for  
when the excrement hits the impeller, especially on beta software  
like this.

>> but I couldn't determine how stable it was or whether or not it  
>> applied to recent kernels.
>
> I'm part-way through integrating it.  Once the snapshot concurrent  
> read/write bug fix is finally sorted out, it shouldn't take long.

Hmm, ok, thanks for the reply.  When you get it working do you have a  
git tree or quilt patchset I could start testing with?  Also, I'm  
curious about the "concurrent read/write bug"; do you have a message- 
id or reference of some kind for that?

Thanks for all your help!

Cheers,
Kyle Moffett
