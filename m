From: Mike Snitzer <snitzer@redhat.com>
Subject: basic cache policy module fix [was: Re: Another cache
	target]
Date: Tue, 18 Dec 2012 10:44:04 -0500
Message-ID: <20121218154403.GA1389@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<50CF4E61.5030904@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <50CF4E61.5030904@redhat.com>
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
Cc: dm-devel@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

On Mon, Dec 17 2012 at 11:54am -0500,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> 
> Darrick,
> 
> please try attached patch, which is on my
> git@github.com:lvmguy/linux-2.6, branch thin-dev_Work as well.
> Does that fix the issue for you?

FYI, I've pushed this fix to the previously mentioned 'dm-devel-cache' 
branch of my github: git://github.com/snitm/linux.git
