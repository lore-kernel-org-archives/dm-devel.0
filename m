From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Wed, 30 Sep 2009 17:35:20 +0100
Message-ID: <20090930163519.GV5351@agk-dp.fab.redhat.com>
References: <20090923030331.GA26449@us.ibm.com>
	<F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
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

On Wed, Sep 30, 2009 at 10:50:06AM -0500, Jon Brassow wrote:
> As long as we are on the topic of mirror logs (and this is unrelated to 
> your patch), I'd like to complain about the current behavior of log  
> allocation vs the log policy.  I don't think it should take  
> 'alloc_anywhere' for a log to be placed on the same disk as one of the  
> mirror legs... that should be 'alloc_normal'.

It was assumed that performance would be better this way, but I have
never seen any tests to prove or disprove that.  Maybe someone could run
some?

One way we could handle this is by creating a new policy between
NORMAL and ANYWHERE that does this, then renaming the old NORMAL
to something else and the new policy to NORMAL.

Alasdair
