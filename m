From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-thinp BUG
	at	drivers/md/persistent-data/dm-btree-remove.c:188
Date: Fri, 15 Feb 2013 02:34:00 +0000
Message-ID: <20130215023400.GM24130@agk-dp.fab.redhat.com>
References: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@ew.ewheeler.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 14, 2013 at 06:07:56PM -0800, Eric Wheeler wrote:
> Does this indicate a corrupt volume or metadata volume?

It could be a software bug.
It is always worth trying the newest code, but I don't spot any
obvious change that could be related to this.

> Let me know what other data I can collect, if any.  The VM seems to hang  
> every few hours or so but I'm not sure what triggers it yet.

Please provide the basic parameters of the device e.g.
  dmsetup info -c
  dmsetup table
  dmsetup status

and then I think we'll probably want to see your metadata (or
the relevant part of it) at the point where it hangs.

The trace shows it's applying a 'discard' to the metadata and releasing
blocks when the problem occurs.

Alasdair
