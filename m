From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache warming
Date: Mon, 29 Jul 2013 11:40:07 +0100
Message-ID: <20130729104006.GC19261@debian>
References: <51F294A0.6080103@cozx.com>
 <51F640EB.6050701@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <51F640EB.6050701@redhat.com>
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

On Mon, Jul 29, 2013 at 12:16:11PM +0200, Heinz Mauelshagen wrote:
> 
> Hi,
> 
> dm-cache is a hot-spot cache. Ie. you need multiple accesses to the
> same block to get it promoted into the cache (depending on the
> policy plugin btw).
> 
> If your patterns is one-time-only access type, it ain't warm the cache.

Remember there's the page cache in front of dm-cache too.  You may be
accessing data many times, but not actually hitting the disk with
your requests.

- Joe
