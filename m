From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: dm-multipath: del/add map problem
Date: Tue, 21 Feb 2006 15:38:05 -0600
Message-ID: <20060221213805.GA5670@ether.msp.redhat.com>
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

When you delete a multipath map, orphaning the path clears out some members
of the path structure.  Adding that map again doesn't bring them back.
Specifically, you loose your checker file descriptor.

The attached patch restores most of the members. It doesn't reset getuid.
I don't see why that gets cleared in the first place?  Actually, I don't
see why most of these get cleared, but I didn't look too hard, so I might
just be missing the reason.

Note: I cannot get multipathd add the map if it doesn't already exist in
device mapper, which I assume that I'm supposed to be able to do. To see
this bug, I need to re-add the map with multipath before re-adding it in
multipathd. I'll look into that right after I clean up my next patch.

-Ben
