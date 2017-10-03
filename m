From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0 of 2] Various dm-raid.c clean-ups
Date: Tue, 3 Oct 2017 15:09:50 -0400
Message-ID: <20171003190950.GA25870@redhat.com>
References: <20171002221725.693A21A4715B@ovpn-117-28.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171002221725.693A21A4715B@ovpn-117-28.phx2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 02 2017 at  6:17pm -0400,
Jonathan Brassow <jbrassow@ovpn-117-28.phx2.redhat.com> wrote:

[Something is messed up with your tools ^ "ovpn-117-28.phx2." shouldn't
be there.]

> Hi,
> 
> One minor clean-up and a status fix.  (Heinz,) Please take a careful
> look over the status clean-up.  While it fixes a bug, that code can
> be a bit tricky to get right and I don't want other things going wrong.

2/2 is a fix, yet it depends on the trivial cleanup in 1/1, please
change the order of the patches or fold them together.  I can take care
of it if you'd like.  The important part is validating the correctness
of the 2/2 fix.  Then the rest of the "how should this land upstream?"
can be sorted out easily.

Thanks,
Mike
