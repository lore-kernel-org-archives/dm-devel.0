From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-bufio
Date: Mon, 17 Oct 2011 19:01:28 +0100
Message-ID: <20111017180127.GA21843@ubuntu>
References: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
	<20111014091537.GA4496@ubuntu>
	<Pine.LNX.4.64.1110171226070.21071@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110171226070.21071@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 17, 2011 at 12:49:22PM -0400, Mikulas Patocka wrote:
> If you want to do it, just do it, but it makes no sense to me.

Well Alasdair, Mike and myself have all looked at this code at various
times over the last 18 months and come to similar conclusions.  We
find the following logic difficult with all those gotos.  There is
also some redundancy which I only noticed when trying to refactor it
(repeated checks).  There's an example that has a jump from one branch
of an 'if' to another, it's trivial to factor out into a function for
each branch, yet you insist on arguing and refuse to change it.  I'm
perfectly prepared to accept that you're familiar enough with this
code, or just clever enough for it to be transparent to you.  But it's
the sort of thing that's going to get picked up on by other small
brained developers like me.  Choose your battles wisely, and save your
energies for something more interesting.

- Joe
