From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: basic cache policy module fix [was: Re: Another
	cache target]
Date: Thu, 20 Dec 2012 08:24:59 -0500
Message-ID: <20121220132459.GA20026@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<50CF4E61.5030904@redhat.com> <20121218154403.GA1389@redhat.com>
	<20121220011430.GB4878@blackbox.djwong.org>
	<50D30B57.6030403@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <50D30B57.6030403@redhat.com>
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
Cc: dm-devel@redhat.com, darrick.wong@oracle.com
List-Id: dm-devel.ids

On Thu, Dec 20 2012 at  7:57am -0500,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> Darrick,
> 
> thanks for testing.
> 
> Bug's a superfluous increment of the number of allocated cache
> blocks in dm-cache-policy-basic:load_mappings().
> 
> Patch is attached and on my git@github.com:lvmguy/linux-2.6, branch
> dm-devel-cache.

FYI, I merged the fix into my dm-devel-cache too.
