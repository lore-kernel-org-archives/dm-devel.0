From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio
Date: Mon, 17 Oct 2011 08:41:28 -0400
Message-ID: <20111017124128.GA8295@redhat.com>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017100808.GA4635@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111017100808.GA4635@ubuntu>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 17 2011 at  6:08am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This is a patch for dm-bufio.
> > 
> > Changes:
...
> > * dm-bufio.h moved from drivers/md to include/linux
> 
> Who outside dm do you expect to use this?

External DM target modules may have an interest (not great justification
but...).
