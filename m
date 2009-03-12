From: Daniel Stodden <daniel.stodden@citrix.com>
Subject: Multipath architecture.
Date: Wed, 11 Mar 2009 18:58:24 -0700
Message-ID: <1236823104.22679.71.camel@agari.van.xensource.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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


Hi.

Can someone spare a little time to help me understand the multipath
utility and daemon a little better?

I read myself through the available documentation. The refbook says that
it's multipath who's creating maps, and multipathd responsible for path
checking.

Running multipath (at least the version 0.4.7 I've got here), this
actually doesn't seem to be the case. Unless I'm totally mistaken,
multipathd actually does create DM maps as paths are discovered. And not
just fork/exec the utility as many sources (most notably the man page)
state.

No, I'm not asking for general advice on how old documentation relates
to new code. :)

My question here would be rather: Everywhere I've been looking at until
now there's seems to be a multipath %M:%m being run from udev. In
addition to the running daemon.

Is this redundant or does the run from udevd still add some major value?

Cheers,
Daniel 
