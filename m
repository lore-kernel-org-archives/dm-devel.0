From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: creating partition mappings with different delimiters
Date: Tue, 04 Apr 2006 09:36:23 -0400
Message-ID: <1144157784.3111.60.camel@gator.sc.steeleye.com>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>
	<1144097506.3111.81.camel@gator.sc.steeleye.com>
	<44319246.6040008@free.fr>
	<20060404132417.GH5783@vienna.egenera.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060404132417.GH5783@vienna.egenera.com>
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

On Tue, 2006-04-04 at 09:24 -0400, Philip R. Auld wrote:
> Hi,
> 
> Rumor has it that on Mon, Apr 03, 2006 at 11:23:18PM +0200 Christophe Varoqui said:
> > I'm inclined to leave it that way, if not only to discourage people to 
> > partition multipathed devices :)
> > 
> 
> Why do you want to discourage partitioning multipath devices? That
> seems to me to be a requirement. 

It seems to me that volume managers, aka LVM or the like, is where folks
should be heading and the faster we can move them in that direction the
better.  The volume managers provide so much more flexibility than
partitions.

Eddie
