From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: mirroring: [patch 1 of 8] device failure tolerance
Date: Thu, 30 Jun 2005 11:13:17 -0400
Message-ID: <87f94c37050630081370347a28@mail.gmail.com>
References: <16a7b346170f3909d57592016a32abc0@redhat.com>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <16a7b346170f3909d57592016a32abc0@redhat.com>
Content-Disposition: inline
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
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

On 6/29/05, Jonathan E Brassow <jbrassow@redhat.com> wrote:
> This patch defines a couple more states that logs can return, and
> checks for those states in the mirror code.  The states are useful for
> logs that have cluster support.
>=20
>   brassow

Have I been asleep?  This is the first I heard of DM having cluster
mirror support.  I assume the goal is something along the lines of
what DRBD provides.

Can someone give a very high-level overview of current status, plans,
etc. related to DM Cluster Mirror support.  And if this related to the
DRBD project?

Thanks
Greg
--=20
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
