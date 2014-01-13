From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache for Fedora 21?
Date: Mon, 13 Jan 2014 10:18:01 +0000
Message-ID: <20140113101800.GC4984@debian>
References: <52D15B93.8000500@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52D15B93.8000500@rolffokkens.nl>
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

On Sat, Jan 11, 2014 at 03:56:19PM +0100, Rolf Fokkens wrote:
> What are your views on the status of dm-cache?

I know of people outside our development team who've been testing
dm-cache quite thoroughly (eg, soak test runs that go for weeks, 4T
SSD, huge origin etc.).  So my confidence in dm-cache is improving.

There are still some significant things I need to do over the next few
weeks.  Probably the most important being reducing the memory
footprint, and making the cache spot when a working set has changed
and migrate the chunks more quickly.

- Joe
