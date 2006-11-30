From: Jens Wilke <jens.wilke@de.ibm.com>
Subject: Re: [dm-devel] [RFC][PATCH] dm-cache: block level disk cache target for device mapper
Date: Thu, 30 Nov 2006 12:32:57 +0100
Message-ID: <200611301232.57966.jens.wilke@de.ibm.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935659AbWK3LdF@vger.kernel.org>
In-Reply-To: <200611271826.kARIQYRi032717@hera.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>, linux-kernel@vger.kernel.org, ming@acis.ufl.edu
List-Id: dm-devel.ids

On Monday 27 November 2006 19:26, Eric Van Hensbergen wrote:
> This is the first cut of a device-mapper target which provides a write-back
> or write-through block cache.  It is intended to be used in conjunction with
> remote block devices such as iSCSI or ATA-over-Ethernet, particularly in
> cluster situations.
> 
> In performance tests with iSCSI, gave peformance improvements of 2-10x that
> of iSCSI alone when Postmark or Bonnie loads were applied from 8 clients to
> a single server.  Evidence suggests even greater differences on larger
> clusters.  A detailed performance analysis will be vailable shortly via a
> technical report on IBM's CyberDigest.

Can you give an idea how this relates to the normal block device buffers?

If this is intended to speed up remote disks, is it possible that the cache content
can be paged out on local disks in low-mem situations?

Best,

Jens
