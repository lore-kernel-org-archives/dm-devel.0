From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [Notice] multipath-tools changes upstream
Date: Wed, 14 May 2008 11:21:00 -0400 (EDT)
Message-ID: <20080514.112100.74755489.k-ueda@ct.jp.nec.com>
References: <1208278929.11770.62.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1208278929.11770.62.camel@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe and all,

Sorry for the late reply.
I took a quick look at the patch series and got some concerns.
Please see below for details.

On Tue, 15 Apr 2008 19:02:08 +0200, Christophe Varoqui wrote:
> please take notice I updated the upstream git tree for the
> multipath-tools project. This tree includes lots of code shuffling :
> 
> 1) prioritizers as dlopen'ed shared libs (/lib/libmultipath/libprio*.so)
> 2) checkers as dlopen'ed shared libs (/lib/libmultipath/libcheck*.so)

Dynamic loading is a nice feature for out-of-tree prioritizers
and checkers.
But I think it's better to avoid using dlopen for in-tree
prioritizers and checkers.
(Or at least provide configuration option to build them as built-in.)


I believe most distros want to use multipath-tools on installer
environment and initrd environment for root volume multipathing.
However, some distros may not be supporting dynamic loading
on such environments, and such distros are using static linked
binaries.
This change prevents such distros from using root volume multipath,
since the change dropped static build capability completely.

Does the change come from my comment below?
(http://marc.info/?l=dm-devel&m=119817423831745&w=2)

On Thu, 20 Dec 2007 13:10:39 -0500 (EST), Kiyoshi Ueda wrote:
> I would like to note that we lost the priority callout feature
> completely to fix the stall problem of root multipath.
> 
> Although below is just my humble opinion, I guess it was useful
> for people who want to use new prioritizers on official distro's
> environments until an update package including the prioritizer
> is released.
> So if such a case often happens, adding other ways to use external
> prioritizers (perhaps dynamic loading library module like LVM2)
> would be required in the near future.

If so, I apologize very much for confusing you.
What I meant on the comment above was:
  o stay all in-tree codes as built-in
  o add a new dynamic loading feature for out-of-tree codes

My exact image is like crash command (http://people.redhat.com/anderson/).
It has many built-in sub-commands for kernel core components
(e.g. bt, list).  And it has 'extend' sub-command to load a shared
library and to add extra sub-commands.

In multipath-tools, I thought we could specify shared libraries
in multipath.conf like below:
    defaults {
            extention  new_prioritizer1.so
            extention  new_prioritizer2.so
    }



Anyway, if all distros support dynamic loading on initrd environment
like Fedora, the patch series shouldn't matter.  But I'm not sure.
If there are such distros, we should take the approach above or
another solution like:
  o specify at build time whether in-tree prioritizers/checkers
    are built into the binary or built as shared libraries
  o they are built as shared libraries by default to minimize
    the binary size of multipath/multipathd commands

Thanks,
Kiyoshi Ueda
