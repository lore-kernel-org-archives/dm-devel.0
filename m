From: Dale.R.Fowle@seagate.com
Subject: Automatic failback with multipath
Date: Fri, 11 Nov 2005 17:23:01 +0000 (UTC)
Message-ID: <200511111721.jABHLQto010050@mh0.sv.mailhost.seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
Date: 11-Nov-2005 10:21:26 MST
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


Hi all,

I recently saw a workaround that was given in a previous query about
automatic failback with EMC arrays. I'm testing a different array, but I
tried the 'failback immediate' option in the /etc/multipath.conf file and
it doesn't do automatic failback. I wound up having to reset the path with
'multipath -v2 -p failover' for multipath to scan the re-enabled path and
update it's own status. Am I missing something or is this a known issue?

Also, is this an issue just with multipath-tools 0.4.4 or has anyone seen
this in 0.4.5.? The only reason I'm not using 0.4.5 is because I've had
issues getting it to make/compile.

Any help would be appreciated.

Thanks,
Dale

Dale Fowle
Seagate Technology
Colorado Springs, CO
719-388-5584
