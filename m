From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: StorageWorks multipath support
Date: Tue, 21 Jun 2005 00:16:26 +0200
Message-ID: <1119305786.1515.92.camel@zezette>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
	<20050615135337.GG11423@marowsky-bree.de>
	<20050615140740.GD16446@averon.dyndns.org>
	<20050615142052.GT4195@agk.surrey.redhat.com>
	<1119116112.1515.59.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1119116112.1515.59.camel@zezette>
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
List-Id: dm-devel.ids

On sam, 2005-06-18 at 19:35 +0200, christophe varoqui wrote:
> On mer, 2005-06-15 at 15:20 +0100, Alasdair G Kergon wrote:
> > On Wed, Jun 15, 2005 at 04:07:40PM +0200, christophe varoqui wrote:
> > > Can you elaborate on what you have in mind ?
> >  
> > Listen on a socket in the filesystem?  [cf. what screen does]
> > And have a separate helper program that sends messages down it
> > similar to the uevent messages.
> > 
> Would the following do what you want ?
> 
No response ? LinuxTag vielleicht ?
Well, it must mean yes then :)

I commited the thing, plus readline support and a few fixes for bugs
uncovered by this nice new feature.

The parser, and the synthax, are still ugly as hell. If someone cares,
he should point me to a nice one.

I'm also open to "lp" and "lm" output format/content suggestions.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
