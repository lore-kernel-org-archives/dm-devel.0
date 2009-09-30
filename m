From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Wed, 30 Sep 2009 14:19:52 -0700
Message-ID: <20090930211952.GA12977@us.ibm.com>
References: <20090923030331.GA26449@us.ibm.com>
	<F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
	<20090930163519.GV5351@agk-dp.fab.redhat.com>
	<61B37279-E0E3-4AF6-81AB-82EEE65C1A09@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <61B37279-E0E3-4AF6-81AB-82EEE65C1A09@redhat.com>
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

Jonathan Brassow [jbrassow@redhat.com] wrote:
>
> On Sep 30, 2009, at 11:35 AM, Alasdair G Kergon wrote:
>
>> On Wed, Sep 30, 2009 at 10:50:06AM -0500, Jon Brassow wrote:
>>> As long as we are on the topic of mirror logs (and this is unrelated to
>>> your patch), I'd like to complain about the current behavior of log
>>> allocation vs the log policy.  I don't think it should take
>>> 'alloc_anywhere' for a log to be placed on the same disk as one of the
>>> mirror legs... that should be 'alloc_normal'.
>>
>> It was assumed that performance would be better this way, but I have
>> never seen any tests to prove or disprove that.  Maybe someone could run
>> some?
>>
>> One way we could handle this is by creating a new policy between
>> NORMAL and ANYWHERE that does this, then renaming the old NORMAL
>> to something else and the new policy to NORMAL.
>
> In addition to performance, I would also think that "preserving hardware" 
> might be a minor priority.  You don't want to go banging around the heads 
> of your hard-drives if you don't have to.
>
> However, the user will get these benefits if they have 1 more device than 
> the mirror images they are trying to create...  If not, it should naturally 
> fall back to allowing the overlap of images and logs.
>
> Inserting a new allocation level is a possibility.  I don't think it's 
> necessary to solve (what I see as) the problem.  Do you have a reason for 
> this?  (Remember, the change would only affect how mirrors behave with the 
> various allocation policies.  If the user wanted the old behavior, they 
> could get it with ALLOC_CONTIGUOUS....  However, the user would be stupid 
> to choose that, because if they have enough disks, they will get 
> CONTIGUOUS, and if they don't it would fail...  Perhaps they would rather 
> have the command fail then allow them to do what they are trying?)

Imagine that I have lots of PVs and only two of them have free space.
When I create a mirror, your proposal could put the log on a PV that
has one of the mirror legs. It is silent! Had it failed, I could have
extended any of the full PVs and re-ran lvcreate. I think I like the
current behaviour for that reason.

I would rather have a system that fail and tell me why it failed rather
than do something that I don't expect!

Maybe, a better failure message is an answer?  If such default lvcreate
failures bother someone, he can probably ask for something in lvm.conf
he can set at one time to behave the way you want it.

Thanks, Malahal.
