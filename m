From: Jim Meyering <jim@meyering.net>
Subject: NEW git mirrors of the lvm2 and device-mapper CVS
	repositories
Date: Thu, 20 Sep 2007 22:44:12 +0200
Message-ID: <87zlzhf4o3.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: LVM <lvm-devel@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
List-Id: dm-devel.ids

You may recall that I set up git mirrors of the lvm2 and
device-mapper CVS repositories:

    http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/3758

The repositories mentioned there will continue to work indefinitely,
but now, there are new, more reliable ones.  They're hosted on the
same system as the CVS repositories:

    git-clone git://sources.redhat.com/git/dm
    http://sources.redhat.com/git/gitweb.cgi?p=dm.git

    git-clone git://sources.redhat.com/git/lvm2
    http://sources.redhat.com/git/gitweb.cgi?p=lvm2.git

Thanks to Frank Ch. Eigler for setting up for git service
on sources.redhat.com (aka sourceware.org).
