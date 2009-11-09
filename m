From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: unwanted kpartx partition delimiter persistance
Date: Mon, 9 Nov 2009 16:14:04 -0500
Message-ID: <20091109211403.GH30590@mtholyoke.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hi,

I have a strange problem w/ a new server.  Debian Lenny, kernel 2.6.27.26.

While getting our multipath setup going, we edited
/etc/udev/rules.d/z60_kpartx.rules to change the partition delimiter to
'quack'.

That's not the name we want in production, of course, so we changed it
to 'p'.  The problem is, on every reboot, the /dev/mapper (and
/dev/disk/...) names come up with the old delimiter - 'quack'.

If I run 'multipath -F', and 'multipath -v2', then the device names are
created as we'd expect them to.

We have grep'd for the string 'quack' everywhere it we can think of, and
it's nowhere to be found.  There is one kpartx config file in
/etc/udev/rules.d only.  What could cause the old name to persist like
this?

TIA

-Ron-
