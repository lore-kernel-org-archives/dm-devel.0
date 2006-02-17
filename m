From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] User-configurable HDIO_GETGEO for dm volumes
Date: Thu, 16 Feb 2006 17:49:51 -0800
Message-ID: <20060216174951.22b50ded.akpm@osdl.org>
References: <43F38D83.3040702@us.ibm.com>
	<20060215190556.59c343b4.akpm@osdl.org>
	<43F5275A.6070603@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43F5275A.6070603@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, lcm@us.ibm.com
List-Id: dm-devel.ids

"Darrick J. Wong" <djwong@us.ibm.com> wrote:
>
> ...
> > That's brave - we take the hd_geometry straight from userspace without
> > checking anything?
> 
> My original approach didn't work anyway; libdevmapper thinks that a 
> target message is a string and would stop copying at the first null it 
> saw.  Since you're also concerned about being locked into a particular 
> hd_geometry structure layout, I respun the patch so that dmsetup passes 
> a string to the dm configuration code; now dm performs some basic 
> range/sanity checks.  However, the patch doesn't check that the CHS 
> values make sense or are even close to the real disk size; if somebody 
> in userspace wants to configure a 150G dm device to have the same 
> geometry as a 360K floppy disk, so be it.  Geometries seem to be rather 
> inaccurate anyway.
> 
> Or, were you worried that I'm dereferencing a userspace pointer in the 
> kernel?  The code that calls _setgeo handles that properly.

Well, I was just asking whether you'd thought about it...

> > Will this code dtrt if userspace is 32-bit and the kernel is 64-bit?
> 
> There shouldn't be any 32/64 mis-match issues with passing a string.  If 
> one tries to pass too-large values, -EINVAL is returned.

Yup, strings work.

> > > struct hd_geometry looks like something which different compilers could lay
> > out differently, perhaps even different gcc versions.  We're relying upon
> > the userspace representation being identical to the kernel's
> > representation.
> > 
> > It means that struct hd_geometry becomes part of the kernel ABI.  We can
> > never again change it and neither we (nor the compiler) can ever change its
> > layout.  That's dangerous.  I'd suggest that you not use hd_geometry in
> > this way (unless we're already using it that way, which might be the case).
> 
> hd_geometry is already part of the kernel ABI because the HDIO_GETGEO 
> ioctl takes a pointer to a struct hd_geometry in userspace and fills it 
> out.

argh.

> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 

We don't seem to have a changelog any more.
