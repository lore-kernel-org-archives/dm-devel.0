From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Changing some multipath defaults
Date: Fri, 18 May 2012 21:01:26 -0500
Message-ID: <20120519020126.GJ3343@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Now that we have better path selectors than round-robin, is seems kind
of silly to have all of our built-in device configs actually setting
their path selector to round-robin.  I think we should either
change the default, or not set a path selector in the builtin device
configs, unless the harware vendor thinks that one of them will
give the best performace. Personally I'd be in favor of doing both.
Removing them from the builtin device configs, and changing the default
to either queue-length or service-time.

Also, since we are now increasing dev_loss_tmo to make sure that devices
don't get removed before queue_if_no_path times out, it seems reasonable
to set a default value for fast_io_fail_tmo, so that devices which will
queue forever will actually fail back the IO in a reasonable time,
something like 5.

These would go a long way towards make the defaults work better on more
systems.  Any thoughts?

-Ben
