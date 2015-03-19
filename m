From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: How to shrink think pool device?
Date: Wed, 18 Mar 2015 20:51:44 -0400
Message-ID: <20150319005144.GA18305@redhat.com>
References: <CAFmwnFZU56G8EAHprspPhsXsihRj017RhuansYtgEAuoCBG9qA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFmwnFZU56G8EAHprspPhsXsihRj017RhuansYtgEAuoCBG9qA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 18 2015 at  7:46pm -0400,
Maxim Patlasov <mpatlasov@parallels.com> wrote:

> Hi,
> 
> It seems that a "trim" pool message was planned long time ago, but never
> implemented. Could someone update about current status of that? The
> question came from the following use-case:
> 
> Suppose we have a thin pool on top of LVM volume group. The group comprises
> of several storage drives. Now I need to (physically) remove one of them.
> The intention is to use pvmove and vgreduce, but obviously thin pool must
> be requested to shrink itself at first.

We only support growing the pool.  If a drive used by the pool goes
missing then thin_repair will need to fix things.
 
> Btw, Documentation/device-mapper/thin-provisioning.txt still has a leftover
> about it:
> 
> > If you wish to reduce the size of your thin device and potentially
> > regain some space then send the 'trim' message to the pool.

I'll remove that stale documentation (commit 5ec02084f6 should've done
that).

The 'trim' message was never about reducing pool space.  The usage for
the trim message (sent to the pool device) was:
 trim <dev_id> <new_size_in_sectors>

It was to reduce the size of the thin volume; don't think it was ever
wired up because it wasn't needed.
