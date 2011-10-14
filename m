From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 14 Oct 2011 10:15:38 +0100
Message-ID: <20111014091537.GA4496@ubuntu>
References: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
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

On Thu, Oct 13, 2011 at 11:05:51AM -0400, Mikulas Patocka wrote:
> Hi
> 
> I found a way how to shut up lockdep warnings in dm-bufio, so you can 
> download new a version which uses nested locks from 
> http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/

Thanks Mikulas, I'd had a couple of people ask me about these warnings.

> BTW. why did you move dm-bufio to persistent-data directory? What are 
> other dm-bufio users (such as dm-zeroed or dm-multisnap) going to do? I 
> thought dm-bufio should be a separate module available to all device 
> mapper targets, such as dm-io, dm-kcopyd or so?

agk made it clear he wasn't going to merge bufio when I met with him a
couple of weeks ago.  So to try and speed things up I put my 'agk' hat
on and tidied as I thought he would.  The main things I did were
remove the gratuitous gotos (eg, jumping from one branch of an if to
another).

I'm not sure moving dm-bufio to pdata was the right thing to do.  My
rationale was there's only one user atm, so put it in there.  I don't
think the header should be in include/linux, this is not going to be
used outside dm (dm-io.h should be either).

This isn't set in stone, take this up with agk.

- Joe
