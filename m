From: Josef Whiter <jwhiter@redhat.com>
Subject: Inconsistancy with multipath -v2 and multipath -ll
Date: Fri, 9 Jun 2006 16:29:32 -0400
Message-ID: <20060609202931.GE24377@korben.rdu.redhat.com>
Reply-To: dm-devel@redhat.com
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

Hello,

This is a sanity check for myself, I just want to make sure I'm not missing
something.  If I set features to be "1 queue_if_no_path" and I run

multipath -v2

I get

[size=12 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 
 \_ 2:0:0:0     sdb           8:16  [ready]
 \_ 3:0:0:0     sdf           8:80  [ready]

But if I then do a multipath -ll I get

[size=12 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 2:0:0:0     sdb           8:16  [active][ready]
 \_ 3:0:0:0     sdf           8:80  [active][ready]

Now when multipath -v2 is run, the maps arent printed until domap is hit in
coalesce_paths, at which point the mpp has had features set from the
configuration.  Howerver, with multipath -ll, it never hits coalesce_paths, it
just pulls the information out of mpp->params, which is something like

params = 0 0 1 1 round-robin 0 2 1 8:48 100 8:112 100

It doesn't look like the features is getting put into the params list.  My
question is this, is anyone else using features "1 queue_if_no_path", and if you
are do you see the same things I do?  If you are good theres a bug and that
needs to be addressed, if you aren't then would you mind posting your
multipath.conf to see if I've just fudged this all up?  Thank you,

Josef
