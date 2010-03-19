From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 16:36:33 +0000
Message-ID: <20100319163633.GH919@agk-dp.fab.redhat.com>
References: <ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
	<20100319143412.GE919@agk-dp.fab.redhat.com>
	<7b13a0f81003190759w4de7be34pfa1a0454ac311ad8@mail.gmail.com>
	<20100319152409.GG919@agk-dp.fab.redhat.com>
	<7b13a0f81003190901o225df427o4468700888501177@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7b13a0f81003190901o225df427o4468700888501177@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Zeuthen <zeuthen@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 19, 2010 at 12:01:23PM -0400, David Zeuthen wrote:
> > So again, the 'don't issue ADD until device is usable' offers a simple
> > way of avoiding this class of problems.
> But as Kay said it's a horrible horrible hack.
 
I quite agree.  But every solution is a horrible hack in some way.

If we *really* want to solve this, we have to put all options on the table
and go back to the fundamentals, and aim to get agreement on definitions
of things like "block device visible to userspace" which we all believe
can be made to work.

> Sorry, but this is an even worse hack. Mandating that all of user
> space (that is: past, present and future) needs to read some
> random 'private' attribute in sysfs because of weird life-cycle
> issues in the device-mapper implementation... that's not really
> workable.
 
I think it's a simple and general concept.  Similar to an inactive multipath
path that must not have any I/O sent to it unless the first path fails.
Similar to a device in a shared storage cluster that has an exclusive
reservation on it from a different node.

Basically it's a marker to say: 
  Hands off! There's nothing here that would interest you.

Alasdair
