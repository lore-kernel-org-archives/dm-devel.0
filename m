From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: multipath.rules placement
Date: Tue, 8 Nov 2016 13:56:25 -0600
Message-ID: <20161108195625.GQ1972@octiron.msp.redhat.com>
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
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm looking through the multipath udev rules again to see if we can come
closer to one consistent set, or at least understand why we need to
agree to disagree and right now I'm trying to figure out why it's
important for SUSE to have 56-multipath.rules run before
60-persistent-storage.rules.

We use 62-multipath.rules in RHEL for two main reasons. First, scsi_id
is run in 60-persistent-storage.rules, which is what sets ID_SERIAL, so
if multipath.rules is run before that, we'll never be able to get our
information from udev. I know that you've added code to cope with this,
assuming the standard uid_attribute, but it seems better to me to just
wait for udev to fill in these values itself.

Second, 60-persistent-storage.rules runs blkid, which should set
ID_FS_TYPE.  Setting it in 56-multipath.rules just means that
60-persistent-storage.rules will overwrite it.

So, what do we gain by running multipath.rules before
60-persistent-storage.rules?

-Ben
