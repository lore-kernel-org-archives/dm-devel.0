From: Dale.R.Fowle@seagate.com
Subject: device mapper cleanup
Date: Thu, 6 Apr 2006 15:42:23 -0600
Message-ID: <OF16134823.26AB83BB-ON87257148.0076840B-87257148.0077352B@seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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


Hi all, what can I use to clean up old device mapper entries. I've got some
devices sitting under /dev/mapper that do not get cleaned up after a
reboot. These devices no longer exist on my storage, yet they still show
up. I attempted a 'multipath -F' to flush the maps to all "unused" devices,
but it wound up only clearing the configuration of everything I had just
configured. Is there another command or tool I should be using to clean out
the device trees of these old devices? I'm running
multipath-tools0.4.5-0.11.

Any ideas would be appreciated.

Thanks,
Dale


Dale Fowle
Seagate Technology
Colorado Springs, CO
