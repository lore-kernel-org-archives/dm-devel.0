From: Arno Wagner <wagner@tik.ee.ethz.ch>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Sun, 18 Jun 2006 20:50:21 +0200
Message-ID: <20060618185021.GA24450@tik.ee.ethz.ch>
References: <62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
	<Pine.LNX.4.63.0606181533080.15173@pingle.local.rsnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0606181533080.15173@pingle.local.rsnet>
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

On Sun, Jun 18, 2006 at 03:45:36PM +0200, Rune Saetre wrote:
> Hi
> 
> >Arno Wagner:
> >>If you can test it with reasonable effort and cost (e.g. put some of
> >>them on another PSU), you might want to do that.
> >
> >Is that safe?
> 
> Don't know how safe it is to use different PSU's, but I have done it with 
> success several times on old hardware used for testing. I can't think of 
> any reason you should run into trouble if ground is common, and the disks 
> are powered up first.

It is pretty safe, as long as you plug both PSUs into the same
outlet and the outlet its grounded. Also powering up may be a bit
difficult, since the power-up signal comes from the mainboard today.

Better solution: Get a PSU with more power reserves and try with that.
From the time you have alreasy sunk into this problem, I gather 
paying for a, say, 500W PSU would not be too bad.
 
> >Another way could be to use a meter to gauge how much power it drains.
> 
> You better use an oscilloscope if anything, as you are looking for very 
> short transients. I have heard (but never tested) that the disks pull 
> large currents when moving the heads, but with seek times of some 
> milliseconds you wouldn't even see it on a regular amperemeter.

Nor a regular oscilloscope. Would need to be the storage kind.
Expensive, unless you can borrow it.

Arno

-- 
Arno Wagner, Dipl. Inform., CISSP --- CSG, ETH Zurich, wagner@tik.ee.ethz.ch 
GnuPG:  ID: 1E25338F  FP: 0C30 5782 9D93 F785 E79C  0296 797F 6B50 1E25 338F
----
Cuddly UI's are the manifestation of wishful thinking. -- Dylan Evans
Windows is the "under-3" toy of the OS world. -- Matthew D. Fuller
