From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Question about dmevents
Date: Sun, 22 Jul 2007 12:15:53 +0100
Message-ID: <20070722111553.GL459@agk.fab.redhat.com>
References: <20070720162626.GA459@agk.fab.redhat.com>
	<D44F48C7D79D2943A073C8FA0F49A3CC0122633A@orsmsx418.amr.corp.intel.com>
	<20070720171404.GC459@agk.fab.redhat.com>
	<20070722084315.GA9301@mornfall.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070722084315.GA9301@mornfall.net>
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

On Sun, Jul 22, 2007 at 10:43:17AM +0200, Peter Rockai wrote:
> In fact, when using theh libdevmapper-event library, the client-side
> code should already fail, if a device has no uuid. In practice, this
> means that uuid-less devices cannot be monitored, but that is probably
> a case that is not really important (or is it?).
> I would probably prefer to just document this as requirement and keep
> things as they are. Comments?

That all makes sense to me.

  name = user-friendly reference; can be changed at will
  uuid = software-friendly reference, a constant for the life of the device

If we have existing software not setting up uuids then those programs need
investigating.

Alasdair
-- 
agk@redhat.com
