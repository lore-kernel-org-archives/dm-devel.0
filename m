From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: compiling Multipath-tools on RHE4 .
Date: Wed, 23 Mar 2005 18:51:02 +0000
Message-ID: <20050323185102.GT19749@agk.surrey.redhat.com>
References: <1111522135.29700.8.camel@localhost>
	<1111531414.7024.17.camel@zezette>
	<20050322225024.GQ19749@agk.surrey.redhat.com>
	<1111533723.7024.24.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1111533723.7024.24.camel@zezette>
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

On Wed, Mar 23, 2005 at 12:22:03AM +0100, christophe varoqui wrote:
> Also what would be to proper fix to the dev_t define ?

Persuade the glibc-kernheaders people they have a responsibility
to provide support through the headers for every linux ioctl, 
even the ones with nasty structures they wish would go away.
Even extensions like O_DIRECT can take years to work their
way through for applications to use. [Yes, I'm thinking of when
lvm2 started using O_DIRECT on Debian and ended up having to use
private #defines for different architectures.]

linux dev_t handling is always a mess - we're left with applications
needing workarounds such as maintaining private copies of kernel headers 
because the glibc ones are inadequate.

e.g. losetup takes its own copy of loop.h and modifies it
to use "my_dev_t" with:

  /* silliness to get dev_t defined as the kernel defines it */
  /* glibc uses a different dev_t */
  /* maybe we need __kernel_old_dev_t -- later */
  /* for ancient systems use "unsigned short" */
 
  #include <linux/posix_types.h>
  #define my_dev_t __kernel_dev_t

which does look wrong because:
  typedef __u32 __kernel_dev_t;

whereas the kernel's loop.h uses:
  __kernel_old_dev_t lo_device;



The intended usage looks something like:

  #include <linux/posix_types.h>
  /* If, as in RHEL4, __kernel_old_dev_t is not defined, then replace
     this #include with the correct definition for the current arch. */

  typedef __kernel_old_dev_t dev_t;
  #include <linux/loop.h>

  /* NB Take care if dev_t is used anywhere later in the code 
     or if lo_device or lo_rdevice are referenced */

The private copy of loop.h does look unnecessary.


Alasdair
-- 
agk@redhat.com
