From: Joe Thornber <thornber@redhat.com>
Subject: Re: About the thin provision function @ kernel 3.2 or
 later.
Date: Fri, 27 Jan 2012 16:04:14 +0000
Message-ID: <20120127160354.GB30635@ubuntu>
References: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
	<20120116143816.GA2184@ubuntu> <20120116155959.GC4667@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120116155959.GC4667@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Ted,

On Mon, Jan 16, 2012 at 10:59:59AM -0500, Ted Ts'o wrote:
> (This is also
> apparently not implemented, from what I can tell from the source; do
> you have an approximate idea of where in the priority list / when it
> is scheduled to be implemented?)

The 'thin-dev' branch of my github repo now has external origin and
discard support.

    https://github.com/jthornber/linux-2.6/tree/thin-dev

I'll give it 2 or 3 weeks of testing before pushing it upstream.

- Joe
