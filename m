From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: add allocated metadata to snapshot
	status
Date: Fri, 9 Oct 2009 08:52:30 -0400
Message-ID: <20091009125230.GA8411@redhat.com>
References: <1255017269-4429-1-git-send-email-snitzer@redhat.com>
	<20091009114509.GA3054@agk-dp.fab.redhat.com>
	<20091009120400.GB3054@agk-dp.fab.redhat.com>
	<20091009120732.GC3054@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091009120732.GC3054@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 09 2009 at  8:07am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Oct 09, 2009 at 01:04:00PM +0100, Alasdair G Kergon wrote:
> > So just current_area + 3?
> > (The first is 0, plus 2 for the header.)
> 
> But the header is only 1 not 2 chunks, so finally I agree, current_area + 2.
> 
> We really should get this documented...

:) I see you've taken care of it in your editing tree.

Thanks,
Mike
