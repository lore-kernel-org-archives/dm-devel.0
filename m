From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: multipath -f/-F exit status
Date: Fri, 12 Dec 2008 15:30:27 +0000
Message-ID: <49428393.6040102@redhat.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hi Folks,

Older versions of multipath-tools would always exit with status 0
(success) when flushing multipath device maps (-f/-F). This was never
guaranteed but happened because the "r" local in multipath/main.c was
used uninitialised in these code paths (by chance, it always lands on a
freshly zeroed stack page, so although undefined the behaviour was
pretty reliable).

This was changed by commit 8497928514aa3df6d46f24d8d9b70b086e9fcfbd:

commit 8497928514aa3df6d46f24d8d9b70b086e9fcfbd
Author: Christophe Varoqui <root@xa-s05.(none)>
Date:   Mon Mar 13 14:55:16 2006 +0100

     [build] minor compilation issues

     SuSE checker found some minor issues:

     - refwwid in libmultipath/configure.c:get_refwwid() might be used
     uninitialized. As dev_type is a simple 'int' there is nothing which
     prevents the unsuspecting user to call it with an unhandled value.
     We shoud rather use an enum and set refwwid to NULL to be on the
     safe side.

     - attr in libmultipath/discovery.c:devt2devname() might be used
     uninitialized. Quite unlikely, but might happen in principle.
     So better have it initialized.

     - r in multipath/main.c:main() might be used uninitialized.
     True. So have it initialized.

This causes -f/-F in more recent versions of the tools to always exit
with status 1 (failure) which does not seem correct.

I think the following would be an improvement on the current behaviour:

multipath -f <map>
------------------

-f     flush a multipath device map specified as parameter, if unused

Exit Status
        0 The map existed and was successfully flushed
        1 The map did not exist or could not be flushed

multipath -F
------------

-F     flush all unused multipath device maps

Exit status
        0 At least one unused multipath device map was flushed
        1 No unused maps were found or no maps could be flushed

The alternative for -F seems to be to return 0 if all unused maps were
flushed and 1 if there were unused maps that could not be flushed. This
doesn't seem like a very likely occurrence, but maybe it should be
handled separately?

Regards,
Bryn.
