From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: BUG/OOPS fix
Date: Tue, 8 Aug 2006 15:59:24 +0100
Message-ID: <20060808145924.GX18633@agk.surrey.redhat.com>
References: <20060808113227.GA26434@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060808113227.GA26434@rere.qmqm.pl>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Aug 08, 2006 at 01:32:27PM +0200, Micha=C5=82 Miros=C5=82aw wrote=
:
> BUG shows up on error path in multipath_ctr() when parse_priority_group=
() fails
> after returning at least once without error. The fix is to initialize m=
->ti
> early - just after alloc()ing it.
=20
Yes.

Alasdair
--=20
agk@redhat.com
