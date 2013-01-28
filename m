From: thornber@redhat.com
Subject: Re: dd between thin provisioned devices
Date: Mon, 28 Jan 2013 12:54:13 +0000
Message-ID: <20130128125412.GB2442@raspberrypi>
References: <CABSD0hKsdtxyQCeZPzFhwpiKY7kmapkPxWJLFidK4VujHnTqTg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABSD0hKsdtxyQCeZPzFhwpiKY7kmapkPxWJLFidK4VujHnTqTg@mail.gmail.com>
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

On Sun, Jan 27, 2013 at 06:01:25PM +0800, devicemapper niko wrote:
> Hi,everyone
> 
> if we dd between thin provisioned devices,
> can we just get allocated blocks copied ?
> Will the output thin device get fully provisioned?

I think what you want to do is take a thin snapshot.  This is a clone
of a thin device's mapping tree.  Initially all blocks will be
identical, but sharing will be broken as you write to either the
original thin device or the snapshot.

> I glanced through the dm-thin code,
> it turns out unmapped blocks return zeroed,am i right?

A read to an unprovisioned block will always return zeroes.  If you
write to an unprovisioned block any data that is not covered by the
write will be zeroed iff you have set the appropriate flag.

> Is there a trick to tell upper applications that all u got are zeroes.
> or should they scan zeroed blocks themselves to trigger WRITE_SAME to
> reduce I/O load?

Not sure what you're trying to do here.  You can use the thin tools to
grab a snapshot of the _metadata_ on a live system.  From this you can
work out what was shared at the time.  Of course there'll always be a
potential race with this kind of approach.  Why has your application
forgotten where it's written?

- Joe
