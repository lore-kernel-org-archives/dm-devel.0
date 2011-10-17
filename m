From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-bufio
Date: Mon, 17 Oct 2011 12:49:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110171226070.21071@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
	<20111014091537.GA4496@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111014091537.GA4496@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 14 Oct 2011, Joe Thornber wrote:

> On Thu, Oct 13, 2011 at 11:05:51AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I found a way how to shut up lockdep warnings in dm-bufio, so you can 
> > download new a version which uses nested locks from 
> > http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/
> 
> Thanks Mikulas, I'd had a couple of people ask me about these warnings.
> 
> > BTW. why did you move dm-bufio to persistent-data directory? What are 
> > other dm-bufio users (such as dm-zeroed or dm-multisnap) going to do? I 
> > thought dm-bufio should be a separate module available to all device 
> > mapper targets, such as dm-io, dm-kcopyd or so?
> 
> agk made it clear he wasn't going to merge bufio when I met with him a
> couple of weeks ago.  So to try and speed things up I put my 'agk' hat
> on and tidied as I thought he would.  The main things I did were
> remove the gratuitous gotos (eg, jumping from one branch of an if to
> another).

My point is that - to get understandable code, each function should do a 
task that can be easily and simply described. It is not necessary that the 
function body is small or that it dosn't contain gotos, what is required 
is that the description of a function is small.

If you replace random parts of a function body with a call to another 
function in order to eliminate a goto, it doesn't improve readability of 
the code at all. Instead of a goto you get a call - both are control 
transfer constructs and a call is not necessarily easier to follow than a 
goto (unless the condition in the first paragraph is true) - as it can be 
seen that both you and me made some bugs on those new 
goto-replaced-with-call functions.

If you want to do it, just do it, but it makes no sense to me.

Mikulas
