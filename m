From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 14 Oct 2011 10:19:15 +0100
Message-ID: <20111014091914.GB4496@ubuntu>
References: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
	<20111013194001.GA12863@redhat.com>
	<Pine.LNX.4.64.1110131817300.11120@hs20-bc2-1.build.redhat.com>
	<20111013223147.GA14220@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111013223147.GA14220@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 13, 2011 at 06:31:47PM -0400, Mike Snitzer wrote:
> On Thu, Oct 13 2011 at  6:19pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > +static int dm_bufio_trylock(struct dm_bufio_client *c)
> > > +{
> > > +	return dm_bufio_trylock(c);
> > > +}
> > > +
> > > +static void dm_bufio_unlock(struct dm_bufio_client *c)
> > > +{
> > > +	dm_bufio_unlock(c);
> > > +}
> > 
> > These two functions are recursive nonsense :) There should be
> > "return mutex_trylock(&c->lock);" and "mutex_unlock(&c->lock);".
> 
> Heheh.  Sorry, M-x replace-string gone wild.
> 
> Here is a fixed version.

Thanks Mike.  If you haven't tested something can you please say, so I
know to run it through the full suite?

- Joe
