From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [LSF/MM ATTEND]: Hot spare module ? And Btrfs volume
 management without mount
Date: Thu, 29 Jan 2015 16:31:35 +0800
Message-ID: <54C9EFE7.7040207@oracle.com>
References: <54B8C174.4020802@oracle.com>
	<20150127101845.GB13522@quack.suse.cz>
	<54C8BDB2.1020700@oracle.com> <20150128163324.GA11823@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150128163324.GA11823@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lsf-pc@lists.linux-foundation.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>, "JAIN,
	ANAND" <anand.jain@oracle.com>
List-Id: dm-devel.ids


Hi Mike,

  Thanks for looking into this and commenting.

> This seems like such a niche issue I think it isn't ever going to get
> traction.

  I anticipate some implementation challenges so community participation
  will help.

  btrfs needs hot spare solution, which I am working on, and its better
  to have it soon especially for data center uses.

  btrfs is another VM in the system. Now there is more pressure to look
  at system-wide hot spare efficiency for systems with heterogeneous VMs.

  Its a kind of important that we provide a holistic hot spare solution
  to the end user.

  In the days when system used to have one type of VM in the system,
  its global hot spare was really a system-wide global hot spare as well.
  Now with more types of VMs in the system these global hot spare aren't
  truly global any more, from the customers point of view who would
  also be concerned about total cost-per-byte.


> Having a common pool of hot spares doesn't buy you much if
> all the different volume managers were to experience a failure -- in
> that case the sharing actively works against you (if you've only
> accomodated for say 1 of the 3 different volume managers failing at any
> one time; but if you have provisioned for worst case of all solutions
> failing then what was the point of the exercise?).

  Good point. But what you have mentioned is a solution problem.
  Currently we do have global hot spare with in a VM containing different
  Raid volumes, and your point will apply their as well. And we expect
  customer to configure it properly as per their business needs.

  With system wide hot spare module, it will help to have global hot
  spare really a global hot spare no matter of whats underlaying VM is.
  And the same global hot spare rule/algorithm will apply but across VMs
  and Raids with in the system. As usual customers will still have
  choice to assign dedicated hot spare for more critical VM-raids if
  needed.

Thanks, Anand
