From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: [PATCH] dm-striped device sizes must be multiple of
	chunk-size(Causes Failures)
Date: Thu, 4 May 2006 08:41:49 -0500
Message-ID: <200605040841.50083.kevcorry@us.ibm.com>
References: <OFFE1FB53B.25095B7A-ON85257161.0072CF32-85257161.0073E75D@wsib.on.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OFFE1FB53B.25095B7A-ON85257161.0072CF32-85257161.0073E75D@wsib.on.ca>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Dwaine_Garden@wsib.on.ca, dwainegarden@rogers.com
List-Id: dm-devel.ids

On Mon May 1 2006 4:05 pm, Dwaine_Garden@wsib.on.ca wrote:
> It looks like dmsetup need to be patched as well.   There is a bug opened
> up for dmraid because after this
> patch, Fedora 5 installs would not boot with kernel 2.6.16.  There is a
> patch to round down the stripe size to be multiple of the chunk-size, but
> the computers still fail trying to boot and mount volumes.
>
> After Heinz patched dmraid, it now fixed.  It looks like dmsetup needs to
> be patched as well(Or something within device-mapper).  Via_ecfdfiehfa is
> not a multiple of chunk-size,   Both dmraid and dmsetup should match.   So
> all software raid0 setup with dmraid still fail to boot under 2.6.16+.
> Nvidia, Intel and Via chipsets are confirmed impacted, but all the chipsets
> which has this software raid0 will have this problem.

There's nothing in dmsetup to patch with regards to this problem. dmsetup and 
libdevmapper have no knowledge at all of any of the device-mapper kernel 
target modules (e.g. linear, striped, mirror, snapshot). They effectively 
just act as a convenient pass-thru to the device-mapper ioctl interface. If 
you're using dmsetup, you need to know about any restrictions required by the 
target you're using, and write your mappings appropriately.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
