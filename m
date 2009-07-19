From: Tapani Tarvainen <tapani@tapanitarvainen.fi>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sun, 19 Jul 2009 06:44:36 +0300
Message-ID: <20090719034436.GA27328@musti.tarvainen.info>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090718074811.GA2682@basil.fritz.box>
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Jul 18, 2009 at 09:48:11AM +0200, Andi Kleen (andi@firstfloor.org) wrote:
> On Sat, Jul 18, 2009 at 02:52:13AM -0400, Andreas Dilger wrote:
> > If you aren't running a 32-bit system with this config, you shouldn't
> > really care.  For those systems that need to run in this mode they
> > would rather have it work a few percent slower instead of not at all.
> 
> Well, it doesn't work at all anyways due to the fsck problem.

I can imagine several scenarios where 16TB+ raid would be useful
without any filesystems bigger than 2TB.
Or does LVM have problems with 16TB+ devices in 32bit-systems, too?

-- 
Tapani Tarvainen
