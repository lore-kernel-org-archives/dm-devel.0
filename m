From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm raid: fix parse_raid_params() variable
	range issue
Date: Mon, 26 Mar 2018 19:23:42 -0400
Message-ID: <20180326232342.GA23449@redhat.com>
References: <6386b9f02b3513bd0ba5ddccd437502313448f7d.1521738866.git.heinzm@redhat.com>
	<20180322194144.GA32294@redhat.com>
	<ac064103-c40b-544a-ef33-e0eaba9a8070@redhat.com>
	<20180326181651.GA22251@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180326181651.GA22251@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 26 2018 at  2:16pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Mar 22 2018 at  5:13pm -0400,
> Heinz Mauelshagen <heinzm@redhat.com> wrote:
> =

> > On 03/22/2018 08:41 PM, Mike Snitzer wrote:
> > >On Thu, Mar 22 2018 at  1:21pm -0400,
> > >Heinz Mauelshagen <heinzm@redhat.com> wrote:
> > >
> > >>This v2 addresses Mikulas' point about the variable range and folds in
> > >>"[PATCH] dm raid: use __within_range() more in parse_raid_params()":
> > >>
> > >>parse_raid_parames() compared variable "int value" with
> > >>INT_MAX to prevent overflow of mddev variables set.
> > >>
> > >>Change type to "long long value".
> > >Can you elaborate on the risk/issue that is being fixed here?
> > =

> > Fix addresses a coverity finding supporting the full,
> > positive range of the "struct mddev" int members
> > set here.=A0 I.e. the "int" cast is compared with INT_MAX.
> =

> Can you cut and paste the relevant portions of the coverity report?

I've dropped this patch for now.  Until I get more insight on what the
problem is I'm not appreciating why changing to a larger data type is
the right way forward (especially if MD is just using int anyway).

Mike
