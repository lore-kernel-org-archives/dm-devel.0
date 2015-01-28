From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND]: Hot spare module ? And Btrfs volume
 management without mount
Date: Wed, 28 Jan 2015 11:33:24 -0500
Message-ID: <20150128163324.GA11823@redhat.com>
References: <54B8C174.4020802@oracle.com>
	<20150127101845.GB13522@quack.suse.cz>
	<54C8BDB2.1020700@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54C8BDB2.1020700@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Anand Jain <anand.jain@oracle.com>
Cc: Chris Mason <clm@fb.com>, dm-devel@redhat.com, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>
List-Id: dm-devel.ids

On Wed, Jan 28 2015 at  5:45am -0500,
Anand Jain <anand.jain@oracle.com> wrote:

> 
> 
> Thanks for the reply.
> 
>  now based on your advise, if my participation is confirmed, by march,
>  I would come up with a concrete proposal or an experimental code
>  to share results at the conference if needed.

Maybe I'm misunderstanding the proposal but..

This seems like such a niche issue I think it isn't ever going to get
traction.  Having a common pool of hot spares doesn't buy you much if
all the different volume managers were to experience a failure -- in
that case the sharing actively works against you (if you've only
accomodated for say 1 of the 3 different volume managers failing at any
one time; but if you have provisioned for worst case of all solutions
failing then what was the point of the exercise?).
