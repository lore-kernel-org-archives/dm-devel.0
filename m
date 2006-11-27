From: bert hubert <bert.hubert@netherlabs.nl>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target for device mapper
Date: Mon, 27 Nov 2006 19:47:48 +0100
Message-ID: <20061127184748.GA11219@outpost.ds9a.nl>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933046AbWK0Srv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611271826.kARIQYRi032717@hera.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, ming@acis.ufl.edu, ericvh@gmail.com
List-Id: dm-devel.ids

On Mon, Nov 27, 2006 at 06:26:34PM +0000, Eric Van Hensbergen wrote:
> This is the first cut of a device-mapper target which provides a write-back
> or write-through block cache.  It is intended to be used in conjunction with
> remote block devices such as iSCSI or ATA-over-Ethernet, particularly in
> cluster situations.

How does this work in practice? In other words, what is a typical actual
configuration?

There is a remote block device, and a local one, and these are kept into
sync in some way?

Thanks.

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
